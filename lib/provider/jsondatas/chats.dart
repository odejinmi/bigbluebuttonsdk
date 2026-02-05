import 'dart:convert';

import 'package:bigbluebuttonsdk/provider/jsondatas/WebSocketService.dart';
import 'package:get/get.dart';

import '../../../utils/chatmodel.dart';
import '../../../utils/participant.dart';
import '../../../utils/typingmodel.dart';
import '../../utils/sound_manager.dart';

class Chats {
  final WebSocketService _service;
  Chats(this._service);

  Future<Map<String, dynamic>> createGroupChat({required Participant participant}) {
    return _service.callMethod("createGroupChat", [jsonEncode(participant.fields?.toJson())]);
  }

  void addmessages(var json) {
    var message = json["fields"];
    // MotionToast.success(
    //   title: Text("Public Message from ${message["senderName"]}"),
    //   description: Text("Meeting Link copied"),
    // ).show(Get.context!);
    message["istyping"] = false;
    // a["{\"msg\":\"added\",\"collection\":\"group-chat-msg\",\"id\":\"qaBHzXdkh5DrsrCCe\",\"fields\":{\"id\":\"1728639206961-r0x38gph\",\"timestamp\":1728639206961,\"correlationId\":\"w_nidxlpogyafr-1728639206402\",\"chatEmphasizedText\":true,\"message\":\"Donation created|help the needy|2|10000000|7\",\"sender\":\"w_nidxlpogyafr\",\"senderName\":\"dfghjklhgtuyioupibpuiovugyfdtgfx\",\"senderRole\":\"VIEWER\",\"meetingId\":\"9753e686f0a75399ca60ae03442353b4b7862ee2-1728638792140\",\"chatId\":\"MAIN-PUBLIC-GROUP-CHAT\"}}"]

    final chatMessage = chatMessageFromJson(jsonEncode(message));
    if (_service.chatMessages.isNotEmpty &&
        _service.chatMessages.last.istyping != null &&
        _service.chatMessages.last.istyping!) {
      _service.chatMessages.remove(_service.chatMessages.last);
      _service.chatMessages.add(chatMessage);
    } else {
      _service.chatMessages.add(chatMessage);
    }
    if (chatMessage.senderName != _service.meetingDetails!.fullname) {
      SoundManager().playAsset('packages/bigbluebuttonsdk/assets/sounds/message.mp3');
      Get.snackbar(
          "${chatMessage.chatId == "MAIN-PUBLIC-GROUP-CHAT" ? 'Public' : 'Private'} message from ${chatMessage.senderName}",
          chatMessage.message);
    }
  }

  void addtypingmessages(var json) {
    _service.typing = typingFromJson(jsonEncode(json));
    if (_service.myDetails!.fields!.name != _service.typing.name) {
      // Check if the chatMessages list is empty or if the last message is not a typing indicator
      if (_service.chatMessages.isEmpty) {
        // Add a new typing message if the conditions are met
        _service.chatMessages.add(ChatMessage(
          senderName: _service.typing.name,
          message: "",
          istyping: true,
          id: '',
          timestamp: 0,
          correlationId: '',
          chatEmphasizedText: false,
          sender: '',
          senderRole: '',
          meetingId: '',
          chatId: _service.typing.isTypingTo == "public"
              ? "MAIN-PUBLIC-GROUP-CHAT"
              : _service.typing.isTypingTo,
        ));
      } else {
        // Find if there's already a typing message for the user
        var existingTypingMessages = _service.chatMessages.where((v) {
          return v.senderName!.toLowerCase() ==
                  _service.typing.name.toLowerCase() &&
              v.istyping!;
        });

        // If no typing message is found, add a new one
        if (existingTypingMessages.isEmpty) {
          _service.chatMessages.add(ChatMessage(
            senderName: _service.typing.name,
            message: "",
            istyping: true,
            id: '',
            timestamp: 0,
            correlationId: '',
            chatEmphasizedText: false,
            sender: '',
            senderRole: '',
            meetingId: '',
            chatId: _service.typing.isTypingTo == "public"
                ? "MAIN-PUBLIC-GROUP-CHAT"
                : _service.typing.isTypingTo,
          ));
        }

        // Set typing indicator flag
        _service.isTypingNow = true;
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

    // Convert the map back to a list and assign it
    _service.participant = participantMap.values.toList();
  }
}
