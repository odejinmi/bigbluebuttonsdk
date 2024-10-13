import 'dart:convert';


import 'package:get/get.dart';

import '../../../utils/participant.dart';
import '../websocket.dart';

class Users{

  var websocket = Get.find<Websocket>();
   jsonresponse(var json){
     // print("user change");
     // print(json);
     if (json["msg"] == "added") {
       addparticipant(json);
     } else if (json["msg"] == "removed") {
       removeparticipant(json);
     } else if (json["msg"] == "changed") {
       ChangeUserProperties(json);
       if((json["fields"]["loggedOut"]!=null &&json["fields"]["loggedOut"]) ||json["fields"]["exitReason"] == "logout") {
         removeparticipant(json);
       }
     }else{
     }
   }

   currentuser(var json){
     if(json["msg"] == "removed"){
       Get.offNamed("/leftsession", arguments:{"webrtctoken":websocket.webrtctoken, "meetingdetails": websocket.meetingdetails, "reason":websocket.reason});
     }else if(json["msg"] == "added"){
       websocket.mydetails = Participant.fromJson(json);
     }else if(json["msg"] == "changed"){
       websocket.mydetails = Participant.fromJson(websocket.mergeData(json,websocket.mydetails!.toJson()));
       if(json["fields"]["ejected"] != null && json["fields"]["ejected"]){
         websocket.reason = "You are kicked out of the session";
       }
     }
   }


   void addparticipant(var json){
     Participant data = participantFromJson(jsonEncode(json));
     if (json["fields"]["breakoutProps"] != null) {
       var list = websocket.participant.where((v) {
         return v.id == data.id;
       }).toList();
       if (list.isEmpty) {
         websocket.participant.add(data);
       }else{
         websocket.participant.remove(list[0]);
         websocket.participant.add(data);
       }
     }
   }

   void removeparticipant(var json){
     if (json["id"] != null) {
       var list = websocket.participant.where((v) {
         return v.id == json["id"];
       }).toList();
       if (list.isNotEmpty) {
         websocket.participant.remove(list[0]);
       }
     }
   }


   ChangeUserProperties(var json){
     // Find the index of the participant in the original list
     var index = websocket.participant.indexWhere((v) => v.fields!.userId == json["fields"]["userId"]);

     if (index != -1) {
       websocket.participant[index] = Participant.fromJson(websocket.mergeData(json, websocket.participant[index].toJson()));
     }
   }

  void controlingvoice(var json){
    // print("json changes");
    // print(json);
    if(json["msg"] == "added") {
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
    }else{
      var index = websocket.participant.indexWhere((v) => v.fields!.voiceid == json["id"]);

      if (index != -1) {
        websocket.participant[index] = Participant.fromJson(websocket.mergeData(json, websocket.participant[index].toJson()));

        if(websocket.mydetails?.fields?.userId == websocket.participant[index].fields?.userId){
          websocket.mydetails = Participant.fromJson(websocket.mergeData(json,websocket.mydetails!.toJson()));
        }
      }else{
        var list = websocket.participant.where((v) {
          return v.fields!.voiceid == null;
        }).toList();
        list[0].fields!.voiceid = json["id"];
      }
      var list = websocket.participant.where((v) {
        return v.fields!.talking == null || v.fields!.talking!;
      }).toList();
      websocket.talking = list;
    }
  }

}