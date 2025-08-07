import 'dart:convert';

import 'package:get/get.dart';

import '../../../utils/participant.dart';
import '../Speechtotext.dart';
import '../audiowebsocket.dart';
import '../remotescreenshare.dart';
import '../remotevideowebsocket.dart';
import '../screensharewebsocket.dart';
import '../videowebsocket.dart';
import '../websocket.dart';
import '../whiteboardcontroller.dart';

class Users {
  var websocket = Get.find<Websocket>();
  jsonresponse(var json) {
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
      websocket.mydetails = Participant.fromJson(json);
    } else if (json["msg"] == "changed") {
      websocket.mydetails = Participant.fromJson(
          websocket.mergeData(json, websocket.mydetails!.toJson()));
      if (json["fields"]["ejected"] != null && json["fields"]["ejected"]) {
        websocket.reason = "You are kicked out of the session";
      } else if (json["fields"]["loggedOut"] != null &&
          json["fields"]["loggedOut"]) {
        websocket.stopwebsocket();
        Get.delete<Websocket>();
        Get.delete<Audiowebsocket>();
        Get.delete<Videowebsocket>();
        Get.delete<Screensharewebsocket>();
        Get.delete<RemoteVideoWebSocket>();
        Get.delete<RemoteScreenShareWebSocket>();
        Get.delete<Texttospeech>();
        Get.delete<Whiteboardcontroller>();
      }
    }
  }

  void addparticipant(var json) {
    Participant data = participantFromJson(jsonEncode(json));
    if (json["fields"]["breakoutProps"] != null) {
      var list = websocket.participant.where((v) {
        return v.id == data.id || v.fields!.userId == data.fields!.userId;
      }).toList();
      if (list.isEmpty) {
        websocket.participant.add(data);
      } else {
        websocket.participant.remove(list[0]);
        websocket.participant.add(data);
      }
    }
  }

  void removeparticipant(var json) {
    if (json["id"] != null) {
      var list = websocket.participant.where((v) {
        return v.id == json["id"];
      }).toList();
      if (list.isNotEmpty) {
        websocket.participant.remove(list[0]);
      }
    }
  }

  ChangeUserProperties(var json) {
    // Find the index of the participant in the original list
    var index = websocket.participant.indexWhere((v) {
      return v.fields!.userId == json["fields"]["userId"] || v.id == json["id"];
    });
    if (index != -1) {
      if (json["fields"]["raiseHand"] != null &&
          json["fields"]["raiseHand"] &&
          websocket.participant[index].fields!.name! !=
              websocket.meetingdetails.fullname) {
        Get.snackbar("Hand raise", websocket.participant[index].fields!.name!);
      }
      websocket.participant[index] = Participant.fromJson(
          websocket.mergeData(json, websocket.participant[index].toJson()));
    }
  }

  void controlingvoice(var json) {
    // print("controlingvoice");
    // print(json);
    if (json["msg"] == "added") {
      var list = websocket.participant.where((v) {
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
        websocket.talking.add(list[0]);
      }
    } else {
      // Find the participant by voiceid
      final index = websocket.participant.indexWhere(
        (v) => v.fields?.voiceid == json["id"],
      );

      if (index != -1) {
        // Update the found participant with merged data
        final updated = Participant.fromJson(
          websocket.mergeData(json, websocket.participant[index].toJson()),
        );
        websocket.participant[index] = updated;

        // If this is the current user, update mydetails as well
        final myDetails = websocket.mydetails;
        if (myDetails?.fields?.userId == updated.fields?.userId) {
          websocket.mydetails = Participant.fromJson(
            websocket.mergeData(json, myDetails!.toJson()),
          );
        }
      } else {
        // Assign voiceid to the first participant without a voiceid
        final unassignedList = websocket.participant
            .where((v) => v.fields?.voiceid == null)
            .toList();
        if (unassignedList.isNotEmpty) {
          unassignedList[0].fields?.voiceid = json["id"];
        }
      }

// Update the talking list
      websocket.talking = websocket.participant
          .where((v) => v.fields?.talking != false)
          .toList();
    }
  }
}
