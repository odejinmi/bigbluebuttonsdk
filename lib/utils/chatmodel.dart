// To parse this JSON data, do
//
//     final chatMessage = chatMessageFromJson(jsonString);

import 'dart:convert';

ChatMessage chatMessageFromJson(String str) => ChatMessage.fromJson(json.decode(str));

String chatMessageToJson(ChatMessage data) => json.encode(data.toJson());

class ChatMessage {
  String? id;
  int timestamp;
  String? correlationId;
  bool? chatEmphasizedText;
  String message;
  String sender;
  String? senderName;
  String? senderRole;
  String? meetingId;
  bool? istyping;
  String? chatId;

  ChatMessage({
    this.id,
    required this.timestamp,
    this.correlationId,
    this.chatEmphasizedText,
    required this.message,
    required this.sender,
    this.senderName,
    this.senderRole,
    this.meetingId,
    this.istyping = false,
    this.chatId,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    id: json["id"],
    timestamp: json["timestamp"],
    correlationId: json["correlationId"],
    chatEmphasizedText: json["chatEmphasizedText"],
    message: json["message"],
    sender: json["sender"],
    senderName: json["senderName"],
    senderRole: json["senderRole"],
    meetingId: json["meetingId"],
    istyping: json["istyping"],
    chatId: json["chatId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "timestamp": timestamp,
    "correlationId": correlationId,
    "chatEmphasizedText": chatEmphasizedText,
    "message": message,
    "sender": sender,
    "senderName": senderName,
    "senderRole": senderRole,
    "meetingId": meetingId,
    "istyping": istyping,
    "chatId": chatId,
  };

  String toString() => toJson().toString();
}

