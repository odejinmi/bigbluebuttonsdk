import 'dart:convert';

import 'package:get/get.dart';

import '../../../utils/pollanalyseparser.dart';
import '../../bigbluebuttonsdk_method_channel.dart';
import '../remotescreenshare.dart';
import '../remotevideowebsocket.dart';
import '../websocket.dart';
import 'chats.dart';
import 'users.dart';

class Websocketresponse{

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
            var remotevideowebsocket = Get.find<RemoteScreenShareWebSocket>();
            remotevideowebsocket.initiate(
                webrtctoken: websocket.webrtctoken,  mediawebsocketurl: websocket.mediawebsocketurl, meetingdetails: websocket.meetingdetails,);
            break;
          case "presentation-upload-token" :
            if(json["msg"] == "added"){
              websocket.websocketsub(["{\"msg\":\"sub\",\"id\":\"vbAwr1EusAkRGhC45\",\"name\":\"presentation-upload-token\",\"params\":[\"${json["field"]["podId"]}\",\"undefined\",\"${json["id"]}\"]}"]);
              websocket.websocketsub(["{\"msg\":\"method\",\"id\":\"962\",\"method\":\"setUsedToken\",\"params\":[\"${json["fields"]["authzToken"]}\"]}"]);
            }else if(json["msg"] == "changed") {
              // a["{\"msg\":\"changed\",\"collection\":\"presentation-upload-token\",\"id\":\"4guHsQNu6mf3ANscz\",\"fields\":{\"used\":true}}"]
            }
            break;
          case "presentations" :
            if(json["msg"] == "added") {
              // a["{\"msg\":\"added\",\"collection\":\"presentations\",\"id\":\"SdT6veDxhRdNtQoGX\",\"fields\":{\"id\":\"babacb799674fc398b451c71afbf1bd7cb9dd645-1727990231301\",\"meetingId\":\"9753e686f0a75399ca60ae03442353b4b7862ee2-1727988992798\",\"podId\":\"DEFAULT_PRESENTATION_POD\",\"conversion\":{\"done\":false,\"error\":false,\"status\":\"SUPPORTED_DOCUMENT\"},\"name\":\"Screenshot 2024-09-04 at 4.37.01\u202fPM.png\",\"renderedInToast\":false,\"temporaryPresentationId\":\"yMbQ5qmTpKOn834EuPwMtvKj\"}}"]
            }else if(json["msg"] == "changed") {
              // a["{\"msg\":\"changed\",\"collection\":\"presentations\",\"id\":\"SdT6veDxhRdNtQoGX\",\"fields\":{\"conversion\":{\"done\":false,\"error\":false,\"status\":\"GENERATING_TEXTFILES\"}}}"]
              // a["{\"msg\":\"changed\",\"collection\":\"presentations\",\"id\":\"SdT6veDxhRdNtQoGX\",\"fields\":{\"conversion\":{\"done\":false,\"error\":false,\"status\":\"GENERATING_THUMBNAIL\"}}}"]
              // a["{\"msg\":\"changed\",\"collection\":\"presentations\",\"id\":\"SdT6veDxhRdNtQoGX\",\"fields\":{\"conversion\":{\"done\":false,\"error\":false,\"status\":\"GENERATING_SVGIMAGES\"}}}"]
              // a["{\"msg\":\"changed\",\"collection\":\"presentations\",\"id\":\"SdT6veDxhRdNtQoGX\",\"fields\":{\"conversion\":{\"done\":false,\"error\":false,\"status\":\"GENERATED_SLIDE\",\"numPages\":1,\"pagesCompleted\":1}}}"]
              // a["{\"msg\":\"changed\",\"collection\":\"presentations\",\"id\":\"SdT6veDxhRdNtQoGX\",\"fields\":{\"conversion\":{\"done\":true,\"error\":false,\"status\":\"GENERATED_SLIDE\",\"numPages\":1,\"pagesCompleted\":1},\"current\":false,\"downloadable\":false,\"exportation\":{\"status\":null},\"filenameConverted\":\"\",\"isInitialPresentation\":false,\"pages\":[{\"id\":\"babacb799674fc398b451c71afbf1bd7cb9dd645-1727990231301/1\",\"num\":1,\"thumbUri\":\"https://meet.konn3ct.ng/bigbluebutton/presentation/9753e686f0a75399ca60ae03442353b4b7862ee2-1727988992798/9753e686f0a75399ca60ae03442353b4b7862ee2-1727988992798/babacb799674fc398b451c71afbf1bd7cb9dd645-1727990231301/thumbnail/1\",\"txtUri\":\"https://meet.konn3ct.ng/bigbluebutton/presentation/9753e686f0a75399ca60ae03442353b4b7862ee2-1727988992798/9753e686f0a75399ca60ae03442353b4b7862ee2-1727988992798/babacb799674fc398b451c71afbf1bd7cb9dd645-1727990231301/textfiles/1\",\"svgUri\":\"https://meet.konn3ct.ng/bigbluebutton/presentation/9753e686f0a75399ca60ae03442353b4b7862ee2-1727988992798/9753e686f0a75399ca60ae03442353b4b7862ee2-1727988992798/babacb799674fc398b451c71afbf1bd7cb9dd645-1727990231301/svg/1\",\"current\":true,\"xOffset\":0,\"yOffset\":0,\"widthRatio\":100,\"heightRatio\":100}],\"removable\":true}}"]
              // a["{\"msg\":\"changed\",\"collection\":\"presentations\",\"id\":\"SdT6veDxhRdNtQoGX\",\"fields\":{\"downloadableExtension\":\"\"}}"]
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
          default:
          // print("default response");
          // print(json);
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
      var list = websocket.participant.where((v) {
          return v.vidieoid == json["id"];
      }).toList();
      if (list.isNotEmpty) {
        list[0].isvidieo = false;
        list[0].vidieoid = null;
        list[0].vidieodeviceId = null;
     }
    }
  }
}