import 'dart:convert';

import 'package:get/get.dart';

import '../../../utils/chatmodel.dart';
import '../../../utils/participant.dart';
import '../../../utils/typingmodel.dart';
import '../websocket.dart';

class Chats{

  var websocket = Get.find<Websocket>();
  void addmessages(var json){
    print(
      'messages'
    );
    print(json);
    var message = json["fields"];
    message["istyping"] = false;
    // a["{\"msg\":\"added\",\"collection\":\"group-chat-msg\",\"id\":\"qaBHzXdkh5DrsrCCe\",\"fields\":{\"id\":\"1728639206961-r0x38gph\",\"timestamp\":1728639206961,\"correlationId\":\"w_nidxlpogyafr-1728639206402\",\"chatEmphasizedText\":true,\"message\":\"Donation created|help the needy|2|10000000|7\",\"sender\":\"w_nidxlpogyafr\",\"senderName\":\"dfghjklhgtuyioupibpuiovugyfdtgfx\",\"senderRole\":\"VIEWER\",\"meetingId\":\"9753e686f0a75399ca60ae03442353b4b7862ee2-1728638792140\",\"chatId\":\"MAIN-PUBLIC-GROUP-CHAT\"}}"]

    final chatMessage = chatMessageFromJson(jsonEncode(message));
    if (websocket.chatMessages.isNotEmpty && websocket.chatMessages.last.istyping != null && websocket.chatMessages.last.istyping!) {

      websocket.chatMessages.remove(websocket.chatMessages.last);
      websocket.chatMessages.add(chatMessage);
    } else {
      websocket.chatMessages.add(chatMessage);
    }
  }

  void addtypingmessages(var json){
    websocket.typing = typingFromJson(jsonEncode(json));
    if (websocket.mydetails!.fields!.name != websocket.typing.name) {
      // Check if the chatMessages list is empty or if the last message is not a typing indicator
      if (websocket.chatMessages.isEmpty ) {
        // Add a new typing message if the conditions are met
        websocket.chatMessages.add(ChatMessage(
          senderName: websocket.typing.name,
          message: "",
          istyping: true,
          id: '',
          timestamp: 0,
          correlationId: '',
          chatEmphasizedText: false,
          sender: '',
          senderRole: '',
          meetingId: '',
          chatId: websocket.typing.isTypingTo == "public" ?"MAIN-PUBLIC-GROUP-CHAT":websocket.typing.isTypingTo,
        ));
      } else {
        // Find if there's already a typing message for the user
        var existingTypingMessages = websocket.chatMessages.where((v) {
          return v.senderName!.toLowerCase() == websocket.typing.name.toLowerCase() && v.istyping!;
        });

        // If no typing message is found, add a new one
        if (existingTypingMessages.isEmpty) {
          websocket.chatMessages.add(ChatMessage(
            senderName: websocket.typing.name,
            message: "",
            istyping: true,
            id: '',
            timestamp: 0,
            correlationId: '',
            chatEmphasizedText: false,
            sender: '',
            senderRole: '',
            meetingId: '',
            chatId: websocket.typing.isTypingTo == "public" ?"MAIN-PUBLIC-GROUP-CHAT":websocket.typing.isTypingTo,
          ));
        }

        // Set typing indicator flag
        websocket.istypingnow = true;
      }
    }

  }

  void updateParticipantsChatId(Map<String, dynamic> json, List<Participant> participant) {
    // Convert the participant list to a map for O(1) lookups based on userId
    Map<String, Participant> participantMap = {
      for (var p in participant) p.fields!.userId!: p
    };

    // Loop through participants in the JSON and update their chatId
    for (var participantData in json["fields"]["participants"]) {
      String userId = participantData["id"];
      if (participantMap.containsKey(userId)) {
        participantMap[userId]!.fields!.chatId = json["fields"]["chatId"];
      }
    }
  }
}