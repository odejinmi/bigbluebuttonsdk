import 'dart:convert';

import 'package:get/get.dart';

import 'package:dio/dio.dart' as dio;

import '../../../utils/pollanalyseparser.dart';
import '../../bigbluebuttonsdk_method_channel.dart';
import '../../utils/diorequest.dart';
import '../../utils/presentationmodel.dart';
import '../../utils/strings.dart';
import '../remotescreenshare.dart';
import '../remotevideowebsocket.dart';
import '../websocket.dart';
import '../whiteboardcontroller.dart';
import 'chats.dart';
import 'users.dart';

class Websocketresponse{
  // a["{\"msg\":\"added\",\"collection\":\"presentation-upload-token\",\"id\":\"LCLjzj7Ruv2rYCQ8Q\",\"fields\":{\"meetingId\":\"d54ad009d179ae346683cfc3603979bc99339ef7-1729907981034\",\"podId\":\"DEFAULT_PRESENTATION_POD\",\"userId\":\"w_pknbeovblnp0\",\"filename\":\"Screenshot 2024-09-04 at 4.37.57\u202fPM.png\",\"authzToken\":\"PresUploadToken-en05ju0uDEFAULT_PRESENTATION_POD-w_pknbeovblnp0\",\"temporaryPresentationId\":\"5P4vXvai4sTE9cKHpjAC624\",\"failed\":false,\"used\":false}}"]
  // a["{\"msg\":\"ready\",\"subs\":[\"J76sMrKavd25c4cN4\"]}"]
  var websocket = Get.find<Websocket>();
  reseponse(event) async {
    var firstsplit = event.toString().split("a[");
    if (firstsplit.length > 1) {
      var secondsplit = firstsplit[1].split("}\"]");
      var result = "${secondsplit[0]}}\"";
      var json = jsonDecode(jsonDecode(result));
      // print("general json");
      // print(json);
      websocket.addEvent(jsonEncode(json));
      if (json["collection"] != null) {
        switch(json["collection"]){
          case "users":
            Users().jsonresponse(json);
            break;
          case "current-user" :
            Users().currentuser(json);
            break;
          case "voiceUsers" :
            if (json["fields"] != null) {
              Users().controlingvoice(json);
            }
            break;
          case "group-chat-msg" :
            Chats().addmessages(json);
            break;
          case "group-chat" :
            Chats().updateParticipantsChatId(json,websocket.participant);
            break;
          case "users-typing" :
            if(json["msg"] == "added"){
              Chats().addtypingmessages(json["fields"]);
            }
            break;
          case "external-video-meetings" :
            if (json["fields"] != null) {
              if(json["fields"]["externalVideoUrl"] != null) {
              }else{
                Get.back();
                websocket.ishowecinema = false;
              }
            }
            break;
          case "polls" :
            if(json["msg"] == "added") {
              websocket.ispolling = true;
              websocket.polljson = json;
            }
          case "current-poll" :
            print(jsonEncode(json));
            if(json["msg"] == "added") {
              websocket.ispolling = true;
              websocket.polljson = json;
              websocket.pollanalyseparser = pollanalyseparserFromJson(jsonEncode(json["fields"]));
            }else if(json["msg"] == "changed") {
              websocket.pollanalyseparser = Pollanalyseparser.fromJson(websocket.mergeData(json["fields"],websocket.pollanalyseparser.toJson()));
            }else{
              // a["{\"msg\":\"changed\",\"collection\":\"current-poll\",\"id\":\"9bEfYoy9xQ2uDyHWe\",\"fields\":{\"answers\":[{\"id\":0,\"key\":\"ljiuyiopi\",\"numVotes\":1},{\"id\":1,\"key\":\"p9786589op\",\"numVotes\":1}],\"numResponders\":2}}"]
            }
            break;
          case "video-streams" :
            controlingvideo(json);
            break;
          case "record-meetings" :
            if(json["msg"] == "added") {
              if (json["fields"]["recording"] != null) {
                websocket.isrecording = json["fields"]["record"];
              }
            }else if(json["msg"] == "changed") {
              if (json["fields"]["time"] != null) {
                var recordingtime = json["fields"]["time"];
                // print(jsonEncode(json));
              }
            }
            break;
          case "screenshare" :
            if(json["msg"] == "added") {
              var remotevideowebsocket = Get.find<RemoteScreenShareWebSocket>();
              remotevideowebsocket.initiate(
                  webrtctoken: websocket.webrtctoken,
                  mediawebsocketurl: websocket.mediawebsocketurl,
                  meetingdetails: websocket.meetingdetails);
            }else if(json["msg"] == "removed"){
              var remotevideowebsocket = Get.find<RemoteScreenShareWebSocket>();
              remotevideowebsocket.stopCameraSharing();
            }
            break;
          case "presentation-upload-token" :
            // a["{\"msg\":\"changed\",\"collection\":\"presentation-upload-token\",\"id\":\"LCLjzj7Ruv2rYCQ8Q\",\"fields\":{\"used\":true}}"]
            if(json["msg"] == "added"){
              uploadpresentation(json);
              // websocket.websocketsub(["{\"msg\":\"method\",\"id\":\"962\",\"method\":\"setUsedToken\",\"params\":[\"${json["fields"]["authzToken"]}\"]}"]);
            }else if(json["msg"] == "changed") {
              // a["{\"msg\":\"changed\",\"collection\":\"presentation-upload-token\",\"id\":\"4guHsQNu6mf3ANscz\",\"fields\":{\"used\":true}}"]
            }
            break;
          case "presentations" :
            if(json["msg"] == "added") {
              websocket.presentationmodel.add(presentationmodelFromJson(jsonEncode(json)));
            }else if(json["msg"] == "changed") {
              print(jsonEncode(json));
              var list = websocket.presentationmodel.where((v) {
                return v.id == json["id"];
              }).toList();
              websocket.mergeData(json, list[0].toJson());
            }else if(json["msg"] == "removed") {
              var list = websocket.presentationmodel.where((v) {
                return v.id == json["id"];
              }).toList();
              websocket.presentationmodel.remove(list);
              // "{\"msg\":\"removed\",\"collection\":\"presentations\",\"id\":\"gQiYcFoascDovEpyu\"}"

            }
            break;
           case "slide-position" :
            if(json["msg"] == "added") {
              websocket.slideposition.add(json);
            }else if(json["msg"] == "removed") {
              var list = websocket.slideposition.where((v) {
                return v.id == json["id"];
              }).toList();
              websocket.slideposition.remove(list);
            }
            break;
           case "slides" :
             print(jsonEncode(json));
            if(json["msg"] == "added") {
              if(websocket.slides.isNotEmpty && json["fields"]["presentationId"] != websocket.slides[0]["fields"]["presentationId"]) {
                websocket.slides.clear();
              }
              websocket.slides.add(json);
            }else if(json["msg"] == "changed") {
              var list = websocket.slides.where((v) {
                  return v["id"] == json["id"];
              }).toList();
              websocket.mergeData(json, list[0]);
            }else if(json["msg"] == "removed") {
              var list = websocket.slides.where((v) {
                return v.id == json["id"];
              }).toList();
              websocket.slides.remove(list);
            }
            break;
           case "breakouts" :
            if(json["msg"] == "added") {
              websocket.breakoutroom.add(json);
              // a["{\"msg\":\"added\",\"collection\":\"breakouts\",\"id\":\"CraaKzdLpfoBSsecA\",\"fields\":{\"breakoutId\":\"65ad68093588dfa5eb0de0b177c6df044143072d-1728837792661\",\"captureNotes\":false,\"captureSlides\":false,\"externalId\":\"42b94a09c8d622ea635fbe02dd7ba106220403c4-1728837792661\",\"freeJoin\":true,\"isDefaultName\":true,\"joinedUsers\":[],\"name\":\"tolu (Room 2)\",\"parentMeetingId\":\"9753e686f0a75399ca60ae03442353b4b7862ee2-1728837597302\",\"sendInviteToModerators\":false,\"sequence\":2,\"shortName\":\"Room 2\",\"timeRemaining\":0}}"]
              // a["{\"msg\":\"added\",\"collection\":\"breakouts\",\"id\":\"EGWZpi2v44R8KempF\",\"fields\":{\"breakoutId\":\"f24a3b915ad0f42a729728a397851c07cff5431e-1728837792661\",\"captureNotes\":false,\"captureSlides\":false,\"externalId\":\"0982362fd72cbad57966fb5b681c0cf741617f37-1728837792661\",\"freeJoin\":true,\"isDefaultName\":true,\"joinedUsers\":[],\"name\":\"tolu (Room 1)\",\"parentMeetingId\":\"9753e686f0a75399ca60ae03442353b4b7862ee2-1728837597302\",\"sendInviteToModerators\":false,\"sequence\":1,\"shortName\":\"Room 1\",\"timeRemaining\":0}}"]
            }else if(json["msg"] == "changed") {
              // a["{\"msg\":\"changed\",\"collection\":\"breakouts\",\"id\":\"CraaKzdLpfoBSsecA\",\"fields\":{\"timeRemaining\":890}}"]
            }
            break;
           case "annotations" :
             var whiteboard = Get.find<Whiteboardcontroller>();
             whiteboard.parsedata(json);
            break;
           case "stream-annotations" :
             // "{\"msg\":\"changed\",\"collection\":\"stream-annotations-d54ad009d179ae346683cfc3603979bc99339ef7-1730813701243\",\"id\":\"id\",\"fields\":{\"eventName\":\"added\",\"args\":[{\"meetingId\":\"d54ad009d179ae346683cfc3603979bc99339ef7-1730813701243\",\"annotations\":[{\"meetingId\":\"d54ad009d179ae346683cfc3603979bc99339ef7-1730813701243\",\"whiteboardId\":\"e77ad8a2f55834ec9396f2c3410fed061ff4c3b2-1730813701246/1\",\"userId\":\"w_bajpiy8r8fvd\",\"annotation\":{\"id\":\"ed8edd59-481b-4386-3217-1dddbf3adb9d\",\"annotationInfo\":{\"size\":[559.1,399.82],\"style\":{\"isFilled\":false,\"size\":\"small\",\"scale\":1,\"color\":\"black\",\"textAlign\":\"start\",\"font\":\"script\",\"dash\":\"draw\"},\"rotation\":0,\"isModerator\":true,\"isComplete\":true,\"parentId\":\"1\",\"childIndex\":1,\"name\":\"Draw\",\"point\":[578.6,279.01],\"points\":[[448.58,227.54,0.5],[448.58,227.54,0.5],[448.58,230.79,0.5],[448.58,234.04,0.5],[451.83,234.04,0.5],[451.83,237.29,0.5],[458.33,240.54,0.5],[461.58,243.79,0.5],[471.33,247.04,0.5],[474.58,250.29,0.5],[487.59,253.54,0.5],[490.84,253.54,0.5],[494.09,256.8,0.5],[510.34,256.8,0.5],[513.59,256.8,0.5],[526.59,256.8,0.5],[536.35,256.8,0.5],[539.6,256.8,0.5],[542.85,253.54,0.5],[546.1,250.29,0.5],[549.35,243.79,0.5],[552.6,237.29,0.5],[555.85,211.29,0.5],[559.1,198.28,0.5],[559.1,182.03,0.5],[559.1,175.53,0.5],[559.1,149.53,0.5],[559.1,143.03,0.5],[555.85,133.27,0.5],[549.35,117.02,0.5],[526.59,91.02,0.5],[513.59,74.76,0.5],[474.58,42.26,0.5],[455.08,29.26,0.5],[438.83,19.5,0.5],[432.33,16.25,0.5],[390.07,3.25,0.5],[360.81,0,0.5],[344.56,0,0.5],[315.31,0,0.5],[299.05,0,0.5],[266.55,0,0.5],[243.79,3.25,0.5],[217.79,13,0.5],[188.53,22.75,0.5],[169.03,29.26,0.5],[146.28,39.01,0.5],[113.77,55.26,0.5],[94.27,68.26,0.5],[58.51,91.02,0.5],[42.26,104.02,0.5],[29.26,113.77,0.5],[22.76,120.27,0.5],[13,133.27,0.5],[6.5,139.77,0.5],[3.25,143.03,0.5],[3.25,146.28,0.5],[0,149.53,0.5],[0,152.78,0.5],[29.26,221.04,0.5],[58.51,256.8,0.5],[91.02,292.55,0.5],[107.27,305.55,0.5],[159.28,347.81,0.5],[178.78,360.81,0.5],[214.54,377.07,0.5],[256.8,390.07,0.5],[299.05,396.57,0.5],[373.82,399.82,0.5],[393.32,399.82,0.5],[422.58,396.57,0.5],[432.33,393.32,0.5],[451.83,386.82,0.5],[468.08,377.07,0.5],[474.58,373.82,0.5],[477.84,370.56,0.5],[484.34,367.31,0.5],[487.59,364.06,0.5],[497.34,357.56,0.5],[500.59,357.56,0.5],[503.84,357.56,0.5],[507.09,357.56,0.5]],\"id\":\"ed8edd59-481b-4386-3217-1dddbf3adb9d\",\"userId\":\"w_bajpiy8r8fvd\",\"type\":\"draw\"},\"wbId\":\"e77ad8a2f55834ec9396f2c3410fed061ff4c3b2-1730813701246/1\",\"userId\":\"w_bajpiy8r8fvd\"}}]}]}}"

             if(json["msg"] == "added") {
              websocket.breakoutroom.add(json);
              // a["{\"msg\":\"added\",\"collection\":\"breakouts\",\"id\":\"CraaKzdLpfoBSsecA\",\"fields\":{\"breakoutId\":\"65ad68093588dfa5eb0de0b177c6df044143072d-1728837792661\",\"captureNotes\":false,\"captureSlides\":false,\"externalId\":\"42b94a09c8d622ea635fbe02dd7ba106220403c4-1728837792661\",\"freeJoin\":true,\"isDefaultName\":true,\"joinedUsers\":[],\"name\":\"tolu (Room 2)\",\"parentMeetingId\":\"9753e686f0a75399ca60ae03442353b4b7862ee2-1728837597302\",\"sendInviteToModerators\":false,\"sequence\":2,\"shortName\":\"Room 2\",\"timeRemaining\":0}}"]
              // a["{\"msg\":\"added\",\"collection\":\"breakouts\",\"id\":\"EGWZpi2v44R8KempF\",\"fields\":{\"breakoutId\":\"f24a3b915ad0f42a729728a397851c07cff5431e-1728837792661\",\"captureNotes\":false,\"captureSlides\":false,\"externalId\":\"0982362fd72cbad57966fb5b681c0cf741617f37-1728837792661\",\"freeJoin\":true,\"isDefaultName\":true,\"joinedUsers\":[],\"name\":\"tolu (Room 1)\",\"parentMeetingId\":\"9753e686f0a75399ca60ae03442353b4b7862ee2-1728837597302\",\"sendInviteToModerators\":false,\"sequence\":1,\"shortName\":\"Room 1\",\"timeRemaining\":0}}"]
            }else if(json["msg"] == "changed") {
              // a["{\"msg\":\"changed\",\"collection\":\"breakouts\",\"id\":\"CraaKzdLpfoBSsecA\",\"fields\":{\"timeRemaining\":890}}"]
            }
            break;
          default:
          // print("default response");
          // print(json);
          // if(json["collection"].contains("stream-cursor")){
          //   print("default stream-cursor");
          //   print(json);
          // }else {
          //
          // }
            break;
        }
      }
    }
  }


  void controlingvideo(var json){
    print(json);
    if(json["msg"] == "added") {
        var list = websocket.participant.where((v) {
            return v.fields!.intId == json["fields"]["userId"];
        }).toList();
        if (list.isNotEmpty) {
          list[0].isvidieo = true;
          list[0].vidieoid = json["id"];
          list[0].vidieodeviceId = json["fields"]["stream"];

          var remotevideowebsocket = Get.find<RemoteVideoWebSocket>();
          remotevideowebsocket.initiate(
              webrtctoken:websocket.webrtctoken, meetingdetails:websocket.meetingdetails, mediawebsocketurl: websocket.mediawebsocketurl, cameraId: json["fields"]["stream"]);
        }
        // 4a52e9693531407dfa0b6471e3a22ce0a6f0ee64b2f4c1af256b4a6cb8c35418
    }else if(json["msg"] == "removed"){
      // msg: removed, collection: video-streams, id: auDsWddGP4PkcSkXK}
      var remotevideowebsocket = Get.find<RemoteVideoWebSocket>();
      remotevideowebsocket.stopCameraSharing();
      var list = websocket.participant.where((v) {
          return v.vidieoid == json["id"];
      }).toList();
      if (list.isNotEmpty) {
        list[0].isvidieo = false;
        list[0].vidieoid = null;
        list[0].vidieodeviceId = null;
        list[0].rtcVideoRenderer!.srcObject = null;
     }
    }
  }

  void uploadpresentation(var token) async {
    dio.FormData formData = dio.FormData.fromMap({
      "fileUpload": await dio.MultipartFile.fromFile(
        websocket.platformFile.path,
        filename: websocket.platformFile.name,
      ),
      "conference": token["fields"]["meetingId"],
      "room": token["fields"]["meetingId"],
      "temporaryPresentationId": token["fields"]["temporaryPresentationId"],
      "pod_id": "DEFAULT_PRESENTATION_POD",
      "is_downloadable": false
    });
    print("presentation upload");
    var cmddetails = await Diorequest().post("https://${websocket.baseurl}/bigbluebutton/presentation/${token["fields"]["authzToken"]}/upload",
        formData);
    print(cmddetails);
    if (cmddetails["success"]) {
        websocket.makepresentationdefault(presentation:token);
      // Get.offNamed(
      // Routes.POSTJOIN, arguments: {"token": webtoken,"meetingdetails":cmddetails["response"]});
      // update();
    }else{
      print("start the meeting again");
    }
  }
}