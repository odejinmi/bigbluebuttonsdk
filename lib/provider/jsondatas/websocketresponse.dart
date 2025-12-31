import 'dart:async';
import 'dart:convert';

import 'package:bigbluebuttonsdk/bigbluebuttonsdk.dart';
import 'package:bigbluebuttonsdk/provider/jsondatas/WebSocketService.dart';
import 'package:bigbluebuttonsdk/provider/jsondatas/users.dart';
import 'package:bigbluebuttonsdk/provider/whiteboardcontroller.dart';
import 'package:bigbluebuttonsdk/utils/diorequest.dart';
import 'package:bigbluebuttonsdk/utils/meetingresponse.dart';
import 'package:bigbluebuttonsdk/utils/presentationmodel.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

import 'chats.dart';

class WebSocketResponse {
  final WebSocketService _service;

  // Constructor with dependency injection
  WebSocketResponse(this._service);

  late final Map<String, Function> _collectionHandlers = {
    "users": _handleUsers,
    "current-user": _handleCurrentUser,
    "voiceUsers": _handleVoiceUsers,
    "group-chat-msg": _handleGroupChatMsg,
    "group-chat": _handleGroupChat,
    "users-typing": _handleUsersTyping,
    "guestUsers": _handleGuestUsers,
    "external-video-meetings": _handleExternalVideoMeetings,
    "polls": _handlePolls,
    "current-poll": _handleCurrentPoll,
    "video-streams": _handleVideoStreams,
    "record-meetings": _handleRecordMeetings,
    "screenshare": _handleScreenshare,
    "presentation-upload-token": _handlePresentationUploadToken,
    "presentations": _handlePresentations,
    "slide-position": _handleSlidePosition,
    "slides": _handleSlides,
    "breakouts": _handleBreakouts,
    "annotations": _handleAnnotations,
    "meetings": _handleMeetings,
  };

  Future<void> response(Map<String, dynamic> json) async {
    if (json["collection"] == "current-user") {
      print("pre addevent");
    }
    _service.addEvent(jsonEncode(json));
    if (json["collection"] == "current-user") {
      print("post addevent");
    }

    final collection = json["collection"];
    if (collection != null && _collectionHandlers.containsKey(collection)) {
      await _collectionHandlers[collection]!(json);
    } else if (collection?.contains("stream-cursor") == true) {
      // _handleStreamCursor(json);
    } else if (collection?.contains("stream-annotations") == true) {
      _handleStreamAnnotations(json);
    }
  }

  Future<void> _handleUsers(Map<String, dynamic> json) async {
    Users(_service).jsonresponse(json);
  }

  Future<void> _handleCurrentUser(Map<String, dynamic> json) async {
    Users(_service).currentuser(json);
  }

  Future<void> _handleVoiceUsers(Map<String, dynamic> json) async {
    if (json["fields"] != null) {
      Users(_service).controlingvoice(json);
    }
  }

  Future<void> _handleGroupChatMsg(Map<String, dynamic> json) async {
    Chats(_service).addmessages(json);
  }

  Future<void> _handleGroupChat(Map<String, dynamic> json) async {
    if (json["fields"] != null &&
        json["fields"]["chatId"] != "MAIN-PUBLIC-GROUP-CHAT") {
      Chats(_service).updateParticipantsChatId(json, _service.participant);
    }
  }

  Future<void> _handleUsersTyping(Map<String, dynamic> json) async {
    if (json["msg"] == "added") {
      Chats(_service).addtypingmessages(json["fields"]);
    }
  }

  Future<void> _handleGuestUsers(Map<String, dynamic> json) async {
    switch (json["msg"]) {
      case "added":
        _service.waitingParticipant.add(json);
        break;
      case "changed":
        if (json["fields"].containsKey("approved")) {
          _service.waitingParticipant
              .removeWhere((item) => item["id"] == json["id"]);
        }
        break;
    }
  }

  Future<void> _handleVideoStreams(Map<String, dynamic> json) async {
    if (json["msg"] == "added") {
      final participants = _service.participant
          .where((v) => v.fields?.intId == json["fields"]["userId"])
          .toList();

      if (participants.isNotEmpty) {
        final participant = participants[0];
        participant.isvideo = true;
        participant.videoid = json["id"];
        participant.videodeviceId = json["fields"]["stream"];

        final remoteVideoWebSocket = Get.find<RemoteVideoWebSocket>();
        remoteVideoWebSocket.initiate(
          webrtctoken: _service.webrtcToken,
          meetingdetails: _service.meetingDetails!,
          mediawebsocketurl: _service.mediaWebsocketUrl,
          cameraId: json["fields"]["stream"],
        );
      }
    } else if (json["msg"] == "removed") {
      final remoteVideoWebSocket = Get.find<RemoteVideoWebSocket>();
      remoteVideoWebSocket.stopCameraSharing();

      final participants =
          _service.participant.where((v) => v.videoid == json["id"]).toList();

      if (participants.isNotEmpty) {
        final participant = participants[0];
        participant.isvideo = false;
        participant.videoid = null;
        participant.videodeviceId = null;
        participant.rtcVideoRenderer?.srcObject = null;
      }
    }
  }

  Future<void> _handleRecordMeetings(Map<String, dynamic> json) async {
    if (json["msg"] == "added") {
      if (json["fields"]["recording"] != null) {
        _service.isRecording = json["fields"]["recording"];
      }
    } else if (json["msg"] == "changed") {
      if (json["fields"]["time"] != null) {
        _service.recordingTime = json["fields"]["time"].toString();
        _startTimer();
      } else if (json["fields"]["recording"] != null) {
        _service.isRecording = json["fields"]["recording"];
      }
    }
  }

  void _startTimer() {
    _service.timer?.cancel();
    _service.timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _service.recordingTime =
          (_convertToSeconds(_service.recordingTime) + 1).toString();
    });
  }

  _convertToSeconds(String time) {
    final parts = time.split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    final seconds = int.parse(parts[2]);
    return hours * 3600 + minutes * 60 + seconds;
  }

// Add other handler methods following the same pattern...
  Future<void> _handleExternalVideoMeetings(Map<String, dynamic> json) async {
    if (json["msg"] == "added" || json["msg"] == "changed") {
    if (json["fields"] != null && json["fields"]["externalVideoUrl"] != null) {
        _service.externalvideomeetings(json["fields"]["externalVideoUrl"]);
    } else {
      // Navigator.pop(context);
      _service.isShowECinema = false;
      // _service.externalvideomeetings(false);
    }
    } else if (json["msg"] == "removed") {
      _service.externalvideomeetings(false);
    }
  }

  Future<void> _handlePolls(Map<String, dynamic> json) async {
    if (json["msg"] == "added") {
      _service.isPolling = true;
      _service.pollJson = json;
      _service.polls(json["fields"]);
    } else if (json["msg"] == "removed"){
      _service.polls(json["fields"]);
    }
  }

  Future<void> _handleCurrentPoll(Map<String, dynamic> json) async {
    print(jsonEncode(json));
    if (json["msg"] == "added") {
      _service.isPolling = true;
      _service.pollJson = json;
      _service.pollAnalyseParser = pollanalyseparserFromJson(
        jsonEncode(json["fields"]),
      );
      _service.currentpoll(json["fields"]);
    } else if (json["msg"] == "changed") {
      _service.pollAnalyseParser = Pollanalyseparser.fromJson(
        _service.mergeData(
          json["fields"],
          _service.pollAnalyseParser.toJson(),
        ),
      );
    } else {
      // a["{\"msg\":\"changed\",\"collection\":\"current-poll\",\"id\":\"9bEfYoy9xQ2uDyHWe\",\"fields\":{\"answers\":[{\"id\":0,\"key\":\"ljiuyiopi\",\"numVotes\":1},{\"id\":1,\"key\":\"p9786589op\",\"numVotes\":1}],\"numResponders\":2}}"]
    }
  }

  Future<void> _handleScreenshare(Map<String, dynamic> json) async {
    print(jsonEncode(json));
    if (json["msg"] == "added") {
      var remotevideowebsocket = Get.find<RemoteScreenShareWebSocket>();
      remotevideowebsocket.initiate(
        webrtctoken: _service.webrtcToken,
        mediawebsocketurl: _service.mediaWebsocketUrl,
        meetingdetails: _service.meetingDetails!,
      );
    } else if (json["msg"] == "removed") {
      var remotevideowebsocket = Get.find<RemoteScreenShareWebSocket>();
      remotevideowebsocket.stopCameraSharing();
    }
  }

  Future<void> _handlePresentationUploadToken(Map<String, dynamic> json) async {
    print(jsonEncode(json));
    // a["{\"msg\":\"changed\",\"collection\":\"presentation-upload-token\",\"id\":\"LCLjzj7Ruv2rYCQ8Q\",\"fields\":{\"used\":true}}"]
    if (json["msg"] == "added") {
      uploadpresentation(json);
      // _service.websocketsub(["{\"msg\":\"method\",\"id\":\"962\",\"method\":\"setUsedToken\",\"params\":[\"${json["fields"]["authzToken"]}\"]}"]);
    } else if (json["msg"] == "changed") {
      // a["{\"msg\":\"changed\",\"collection\":\"presentation-upload-token\",\"id\":\"4guHsQNu6mf3ANscz\",\"fields\":{\"used\":true}}"]
    }
  }

  Future<void> _handlePresentations(Map<String, dynamic> json) async {
    print(jsonEncode(json));
    if (json["msg"] == "added") {
      _service.presentationModel.add(
        presentationmodelFromJson(jsonEncode(json)),
      );
    } else if (json["msg"] == "changed") {
      print(jsonEncode(json));
      var list = _service.presentationModel.where((v) {
        return v.id == json["id"];
      }).toList();
      _service.mergeData(json, list[0].toJson());
    } else if (json["msg"] == "removed") {
      var list = _service.presentationModel.where((v) {
        return v.id == json["id"];
      }).toList();
      _service.presentationModel.remove(list);
      // "{\"msg\":\"removed\",\"collection\":\"presentations\",\"id\":\"gQiYcFoascDovEpyu\"}"
    }
  }

  Future<void> _handleSlidePosition(Map<String, dynamic> json) async {
    print(jsonEncode(json));
    if (json["msg"] == "added") {
      _service.slidePosition.add(json);
    } else if (json["msg"] == "removed") {
      var list = _service.slidePosition.where((v) {
        return v.id == json["id"];
      }).toList();
      _service.slidePosition.remove(list);
    }
  }

  Future<void> _handleSlides(Map<String, dynamic> json) async {
    print(jsonEncode(json));
    if (json["msg"] == "added") {
      if (_service.slides.isNotEmpty &&
          json["fields"]["presentationId"] !=
              _service.slides[0]["fields"]["presentationId"]) {
        _service.slides.clear();
      }
      _service.slides.add(json);
    } else if (json["msg"] == "changed") {
      var list = _service.slides.where((v) {
        return v["id"] == json["id"];
      }).toList();
      _service.mergeData(json, list[0]);
    } else if (json["msg"] == "removed") {
      var list = _service.slides.where((v) {
        return v["id"] == json["id"];
      }).toList();
      _service.slides.remove(list);
    }
  }

  Future<void> _handleBreakouts(Map<String, dynamic> json) async {
    print(jsonEncode(json));
    if (json["msg"] == "added") {
      _service.breakoutRoom.add(json);
      _service.breakouts();
      // a["{\"msg\":\"added\",\"collection\":\"breakouts\",\"id\":\"CraaKzdLpfoBSsecA\",\"fields\":{\"breakoutId\":\"65ad68093588dfa5eb0de0b177c6df044143072d-1728837792661\",\"captureNotes\":false,\"captureSlides\":false,\"externalId\":\"42b94a09c8d622ea635fbe02dd7ba106220403c4-1728837792661\",\"freeJoin\":true,\"isDefaultName\":true,\"joinedUsers\":[],\"name\":\"tolu (Room 2)\",\"parentMeetingId\":\"9753e686f0a75399ca60ae03442353b4b7862ee2-1728837597302\",\"sendInviteToModerators\":false,\"sequence\":2,\"shortName\":\"Room 2\",\"timeRemaining\":0}}"]
      // a["{\"msg\":\"added\",\"collection\":\"breakouts\",\"id\":\"EGWZpi2v44R8KempF\",\"fields\":{\"breakoutId\":\"f24a3b915ad0f42a729728a397851c07cff5431e-1728837792661\",\"captureNotes\":false,\"captureSlides\":false,\"externalId\":\"0982362fd72cbad57966fb5b681c0cf741617f37-1728837792661\",\"freeJoin\":true,\"isDefaultName\":true,\"joinedUsers\":[],\"name\":\"tolu (Room 1)\",\"parentMeetingId\":\"9753e686f0a75399ca60ae03442353b4b7862ee2-1728837597302\",\"sendInviteToModerators\":false,\"sequence\":1,\"shortName\":\"Room 1\",\"timeRemaining\":0}}"]
    } else if (json["msg"] == "changed") {
      // a["{\"msg\":\"changed\",\"collection\":\"breakouts\",\"id\":\"CraaKzdLpfoBSsecA\",\"fields\":{\"timeRemaining\":890}}"]
    }
  }

  static Future<void> _handleAnnotations(Map<String, dynamic> json) async {
    print(jsonEncode(json));
    var whiteboard = Get.find<Whiteboardcontroller>();
    whiteboard.parsedata(json);
  }

  Future<void> _handleMeetings(Map<String, dynamic> json) async {
    print(jsonEncode(json));
    if (json["msg"] == "changed") {
      _service.meetingResponse = meetingResponseFromJson(jsonEncode(
          _service.mergeData(json, _service.meetingResponse!.toJson())));
      // a["{\"msg\":\"changed\",\"collection\":\"meetings\",\"id\":\"9753e686f0a75399ca60ae03442353b4b7862ee2-1728837597302\",\"fields\":{\"timeRemaining\":0}}"]
      if(json["fields"] != null &&
          json["fields"]["meetingEnded"] != null &&
          json["fields"]["meetingEnded"]) {
        _service.stopWebsocket();
      }
    } else if (json["msg"] == "added") {
      _service.meetingResponse = meetingResponseFromJson(jsonEncode(json));
      // a["{\"msg\":\"added\",\"collection\":\"meetings\",\"id\":\"9753e686f0a75399ca60ae03442353b4b7862ee2-1728837597302\",\"fields\":{\"timeRemaining\":0}}"]
    }
  }

  Future<void> _handleStreamAnnotations(Map<String, dynamic> json) async {
    print(jsonEncode(json));
    if (json["msg"] == "added") {
      _service.breakoutRoom.add(json);
      // a["{\"msg\":\"added\",\"collection\":\"breakouts\",\"id\":\"CraaKzdLpfoBSsecA\",\"fields\":{\"breakoutId\":\"65ad68093588dfa5eb0de0b177c6df044143072d-1728837792661\",\"captureNotes\":false,\"captureSlides\":false,\"externalId\":\"42b94a09c8d622ea635fbe02dd7ba106220403c4-1728837792661\",\"freeJoin\":true,\"isDefaultName\":true,\"joinedUsers\":[],\"name\":\"tolu (Room 2)\",\"parentMeetingId\":\"9753e686f0a75399ca60ae03442353b4b7862ee2-1728837597302\",\"sendInviteToModerators\":false,\"sequence\":2,\"shortName\":\"Room 2\",\"timeRemaining\":0}}"]
      // a["{\"msg\":\"added\",\"collection\":\"breakouts\",\"id\":\"EGWZpi2v44R8KempF\",\"fields\":{\"breakoutId\":\"f24a3b915ad0f42a729728a397851c07cff5431e-1728837792661\",\"captureNotes\":false,\"captureSlides\":false,\"externalId\":\"0982362fd72cbad57966fb5b681c0cf741617f37-1728837792661\",\"freeJoin\":true,\"isDefaultName\":true,\"joinedUsers\":[],\"name\":\"tolu (Room 1)\",\"parentMeetingId\":\"9753e686f0a75399ca60ae03442353b4b7862ee2-1728837597302\",\"sendInviteToModerators\":false,\"sequence\":1,\"shortName\":\"Room 1\",\"timeRemaining\":0}}"]
    } else if (json["msg"] == "changed") {
      // a["{\"msg\":\"changed\",\"collection\":\"breakouts\",\"id\":\"CraaKzdLpfoBSsecA\",\"fields\":{\"timeRemaining\":890}}"]
    }
  }

  void uploadpresentation(var token) async {
    dio.FormData formData = dio.FormData.fromMap({
      "fileUpload": await dio.MultipartFile.fromFile(
        _service.platformFile.path!,
        filename: _service.platformFile.name,
      ),
      "conference": token["fields"]["meetingId"],
      "room": token["fields"]["meetingId"],
      "temporaryPresentationId": token["fields"]["temporaryPresentationId"],
      "pod_id": "DEFAULT_PRESENTATION_POD",
      "is_downloadable": false,
    });
    print("presentation upload");
    var cmddetails = await Diorequest().post(
      "https://${_service.baseUrl}/bigbluebutton/presentation/${token["fields"]["authzToken"]}/upload",
      formData,
    );
    print(cmddetails);
    if (cmddetails["success"]) {
      _service.makePresentationDefault(presentation: token);
      // Get.offNamed(
      // Routes.POSTJOIN, arguments: {"token": webtoken,"meetingdetails":cmddetails["response"]});
      // update();
    } else {
      print("start the meeting again");
    }
  }
}
