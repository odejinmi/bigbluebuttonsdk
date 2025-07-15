import 'dart:convert';

import 'package:get/get.dart';

import '../../../utils/chatmodel.dart';
import '../../../utils/participant.dart';
import '../../../utils/typingmodel.dart';
import '../websocket.dart';

class Chats {
  var websocket = Get.find<Websocket>();

  createGroupChat({
    required Participant participant,
  }) {
    // "{\"msg\":\"method\",\"id\":\"957\",\"method\":\"createGroupChat\",\"params\":[{\"subscriptionId\":\"wWxgIKTehg5OR6P1A\",\"meetingId\":\"1cbd2cb09db2ac48529827879eaad399f2e11c9f-1749702556588\",\"userId\":\"w_9bhtyhpznvxe\",\"clientType\":\"HTML5\",\"validated\":true,\"left\":false,\"approved\":true,\"authTokenValidatedTime\":1749702604070,\"inactivityCheck\":false,\"loginTime\":1749702602616,\"authed\":true,\"avatar\":\"https://ui-avatars.com/api/?name=videx&bold=true\",\"away\":false,\"breakoutProps\":{\"isBreakoutUser\":false,\"parentId\":\"bbb-none\"},\"color\":\"#4a148c\",\"effectiveConnectionType\":null,\"emoji\":\"none\",\"extId\":\"odejinmiabraham@gmail.com\",\"guest\":false,\"guestStatus\":\"ALLOW\",\"intId\":\"w_9bhtyhpznvxe\",\"locked\":true,\"loggedOut\":false,\"mobile\":false,\"name\":\"videx\",\"pin\":false,\"presenter\":false,\"raiseHand\":false,\"reactionEmoji\":\"none\",\"responseDelay\":0,\"role\":\"VIEWER\",\"sortName\":\"videx\",\"speechLocale\":\"\",\"connection_status\":\"normal\",\"id\":\"Fth2CaBDcLQov9PJm\"}]}"
    var json = [
      // "{\"msg\":\"method\",\"id\":\"900\",\"method\":\"createGroupChat\",\"params\":[{\"subscriptionId\":\"wWxgIKTehg5OR6P1A\",\"meetingId\":\"${websocket.meetingdetails.meetingId}\",\"userId\":\"${participant.fields?.userId}\",\"clientType\":\"HTML5\",\"validated\":true,\"left\":false,\"approved\":true,\"authTokenValidatedTime\":1749702604070,\"inactivityCheck\":false,\"loginTime\":1749702602616,\"authed\":true,\"avatar\":\"${participant.fields?.avatar}\",\"away\":false,\"breakoutProps\":${participant.fields?.breakoutProps},\"color\":\"#4a148c\",\"effectiveConnectionType\":null,\"emoji\":\"none\",\"extId\":\"odejinmiabraham@gmail.com\",\"guest\":false,\"guestStatus\":\"ALLOW\",\"intId\":\"w_9bhtyhpznvxe\",\"locked\":true,\"loggedOut\":false,\"mobile\":false,\"name\":\"videx\",\"pin\":false,\"presenter\":false,\"raiseHand\":false,\"reactionEmoji\":\"none\",\"responseDelay\":0,\"role\":\"VIEWER\",\"sortName\":\"videx\",\"speechLocale\":\"\",\"connection_status\":\"normal\",\"id\":\"Fth2CaBDcLQov9PJm\"}]}"
      "{\"msg\":\"method\",\"id\":\"900\",\"method\":\"createGroupChat\",\"params\":[${jsonEncode(participant.fields?.toJson())}]}"
    ];
    websocket.websocketsub(json);
  }

  void addmessages(var json) {
    print('messages');
    print(json);
    var message = json["fields"];
    message["istyping"] = false;
    // a["{\"msg\":\"added\",\"collection\":\"group-chat-msg\",\"id\":\"qaBHzXdkh5DrsrCCe\",\"fields\":{\"id\":\"1728639206961-r0x38gph\",\"timestamp\":1728639206961,\"correlationId\":\"w_nidxlpogyafr-1728639206402\",\"chatEmphasizedText\":true,\"message\":\"Donation created|help the needy|2|10000000|7\",\"sender\":\"w_nidxlpogyafr\",\"senderName\":\"dfghjklhgtuyioupibpuiovugyfdtgfx\",\"senderRole\":\"VIEWER\",\"meetingId\":\"9753e686f0a75399ca60ae03442353b4b7862ee2-1728638792140\",\"chatId\":\"MAIN-PUBLIC-GROUP-CHAT\"}}"]

    final chatMessage = chatMessageFromJson(jsonEncode(message));
    if (websocket.chatMessages.isNotEmpty &&
        websocket.chatMessages.last.istyping != null &&
        websocket.chatMessages.last.istyping!) {
      websocket.chatMessages.remove(websocket.chatMessages.last);
      websocket.chatMessages.add(chatMessage);
    } else {
      websocket.chatMessages.add(chatMessage);
    }
    if (chatMessage.senderName != websocket.meetingdetails.fullname) {
      Get.snackbar(
          "${chatMessage.chatId == "MAIN-PUBLIC-GROUP-CHAT" ? 'Public' : 'Private'} message from ${chatMessage.senderName}",
          chatMessage.message);
    }
  }

  void addtypingmessages(var json) {
    websocket.typing = typingFromJson(jsonEncode(json));
    if (websocket.mydetails!.fields!.name != websocket.typing.name) {
      // Check if the chatMessages list is empty or if the last message is not a typing indicator
      if (websocket.chatMessages.isEmpty) {
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
          chatId: websocket.typing.isTypingTo == "public"
              ? "MAIN-PUBLIC-GROUP-CHAT"
              : websocket.typing.isTypingTo,
        ));
      } else {
        // Find if there's already a typing message for the user
        var existingTypingMessages = websocket.chatMessages.where((v) {
          return v.senderName!.toLowerCase() ==
                  websocket.typing.name.toLowerCase() &&
              v.istyping!;
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
            chatId: websocket.typing.isTypingTo == "public"
                ? "MAIN-PUBLIC-GROUP-CHAT"
                : websocket.typing.isTypingTo,
          ));
        }

        // Set typing indicator flag
        websocket.istypingnow = true;
      }
    }
  }

  void updateParticipantsChatId(
      Map<String, dynamic> json, List<Participant> participant) {
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
    websocket.participant = participantFromJson(jsonEncode(participantMap));
  }
}
