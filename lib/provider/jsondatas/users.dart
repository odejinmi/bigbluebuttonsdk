import 'dart:convert';

import 'package:bigbluebuttonsdk/provider/jsondatas/WebSocketService.dart';
import 'package:bigbluebuttonsdk/provider/jsondatas/chats.dart';
import 'package:get/get.dart';

import '../../../utils/participant.dart';
import '../../utils/sound_manager.dart';
import '../DirectSocketIOStreamer.dart';
import '../audiowebsocket.dart';
import '../remotescreenshare.dart';
import '../remotevideowebsocket.dart';
import '../screensharewebsocket.dart';
import '../videowebsocket.dart';
import '../websocket.dart';
import '../whiteboardcontroller.dart';

class Users {
  final WebSocketService _service;
  Users(this._service);

  jsonresponse(var json) {
    if(json['fields'] != null && json['fields']['raiseHand'] == true){
      SoundManager().playAsset('packages/bigbluebuttonsdk/assets/sounds/finger-snaps.mp3');
    }
    if (json["msg"] == "added") {
      addparticipant(json);
    } else if (json["msg"] == "removed") {
      removeparticipant(json);
    } else if (json["msg"] == "changed") {
      ChangeUserProperties(json);
      if ((json["fields"]["loggedOut"] != null &&
              json["fields"]["loggedOut"]) ||
          json["fields"]["exitReason"] == "logout") {
        removeparticipant(json);
      }
    } else {}
  }

  currentuser(var json) {
    if (json["msg"] == "added") {
      _service.myDetails = Participant.fromJson(json);
      for (var element in _service.participant) {
        if (element.fields!.userId == _service.myDetails!.fields!.userId) {
          element.fields!.name = "${element.fields!.name} (YOU)";
        }
      }
      _service.setusermobile();
    } else if (json["msg"] == "changed") {
      _service.myDetails = Participant.fromJson(
          _service.mergeData(json, _service.myDetails!.toJson()));
      if (json["fields"]["ejected"] != null && json["fields"]["ejected"]) {
        _service.reason = "You are kicked out of the session";
      } else if (json["fields"]["loggedOut"] != null &&
          json["fields"]["loggedOut"]) {
        _service.leavemeeting ("You are kicked out of the session");
        _service.stopWebsocket();
        Get.delete<Websocket>();
        Get.delete<Audiowebsocket>();
        Get.delete<Videowebsocket>();
        Get.delete<Screensharewebsocket>();
        Get.delete<RemoteVideoWebSocket>();
        Get.delete<RemoteScreenShareWebSocket>();
        Get.delete<Whiteboardcontroller>();
        Get.delete<DirectSocketIOStreamer>();
      }
    } else {
      _service.stopWebsocket();
      Get.delete<Websocket>();
      Get.delete<Audiowebsocket>();
      Get.delete<Videowebsocket>();
      Get.delete<Screensharewebsocket>();
      Get.delete<RemoteVideoWebSocket>();
      Get.delete<RemoteScreenShareWebSocket>();
      Get.delete<Whiteboardcontroller>();
      Get.delete<DirectSocketIOStreamer>();
    }
  }

  void addparticipant(var json) {
    Participant data = participantFromJson(jsonEncode(json));
    if (_service.myDetails != null &&
        data.fields!.userId == _service.myDetails!.fields!.userId) {
      data.fields!.name = "${data.fields!.name} (YOU)";
    }
    if (json["fields"]["breakoutProps"] != null) {
      var list = _service.participant.where((v) {
        return v.id == data.id || v.fields!.userId == data.fields!.userId;
      }).toList();
      if (list.isEmpty) {
        _service.participant.add(data);
      } else {
        _service.participant.remove(list[0]);
        _service.participant.add(data);
      }
    }
    Chats(_service).createGroupChat(
      participant: data,
    );
  }

  void removeparticipant(var json) {
    if (json["id"] != null) {
      var list = _service.participant.where((v) {
        return v.id == json["id"];
      }).toList();
      if (list.isNotEmpty) {
        _service.participant.remove(list[0]);
      }
    }
  }

  ChangeUserProperties(var json) {
    // Find the index of the participant in the original list
    var index = _service.participant.indexWhere((v) {
      return v.fields!.userId == json["fields"]["userId"] || v.id == json["id"];
    });
    if (index != -1) {
      if (json["fields"]["raiseHand"] != null &&
          json["fields"]["raiseHand"] &&
          _service.participant[index].fields!.name! !=
              _service.meetingDetails!.fullname) {
        Get.snackbar("Hand raise", _service.participant[index].fields!.name!);
      }
      _service.participant[index] = Participant.fromJson(
          _service.mergeData(json, _service.participant[index].toJson()));

      if (_service.myDetails != null &&
          _service.participant[index].fields!.userId ==
              _service.myDetails!.fields!.userId) {
        if (!_service.participant[index].fields!.name!.contains("(YOU)")) {
          _service.participant[index].fields!.name =
              "${_service.participant[index].fields!.name} (YOU)";
        }
      }
    }
  }

  void controlingvoice(var json) {
    if (json["msg"] == "added") {
      var list = _service.participant.where((v) {
        if (v.fields!.voiceid == null) {
          return v.fields!.intId == json["fields"]["intId"];
        } else {
          return v.fields!.voiceid == json["id"];
        }
      }).toList();
      if (list.isNotEmpty) {
        list[0].fields!.muted = json["fields"]["muted"];
        list[0].fields!.voiceid = json["id"];
        list[0].fields!.talking = json["fields"]["talking"];
        list[0].fields!.spoke = json["fields"]["spoke"];
        _service.talking.add(list[0]);
      }
    } else {
      // Find the participant by voiceid
      final index = _service.participant.indexWhere(
        (v) => v.fields?.voiceid == json["id"],
      );

      if (index != -1) {
        // Update the found participant with merged data
        final updated = Participant.fromJson(
          _service.mergeData(json, _service.participant[index].toJson()),
        );
        _service.participant[index] = updated;

        // If this is the current user, update mydetails as well
        final myDetails = _service.myDetails;
        if (myDetails?.fields?.userId == updated.fields?.userId) {
          _service.myDetails = Participant.fromJson(
            _service.mergeData(json, myDetails!.toJson()),
          );
        }
      } else {
        // Assign voiceid to the first participant without a voiceid
        final unassignedList = _service.participant
            .where((v) => v.fields?.voiceid == null)
            .toList();
        if (unassignedList.isNotEmpty) {
          unassignedList[0].fields?.voiceid = json["id"];
        }
      }

// Update the talking list
      _service.talking = _service.participant
          .where((v) => v.fields?.talking != false)
          .toList();
    }
  }
}
