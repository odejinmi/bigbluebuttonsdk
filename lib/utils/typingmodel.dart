// To parse this JSON data, do
//
//     final typing = typingFromJson(jsonString);

import 'dart:convert';

Typing typingFromJson(String str) => Typing.fromJson(json.decode(str));

String typingToJson(Typing data) => json.encode(data.toJson());

class Typing {
  String meetingId;
  String userId;
  String name;
  String isTypingTo;
  String role;
  Time time;

  Typing({
    required this.meetingId,
    required this.userId,
    required this.name,
    required this.isTypingTo,
    required this.role,
    required this.time,
  });

  factory Typing.fromJson(Map<String, dynamic> json) => Typing(
    meetingId: json["meetingId"],
    userId: json["userId"],
    name: json["name"],
    isTypingTo: json["isTypingTo"],
    role: json["role"],
    time: Time.fromJson(json["time"]),
  );

  Map<String, dynamic> toJson() => {
    "meetingId": meetingId,
    "userId": userId,
    "name": name,
    "isTypingTo": isTypingTo,
    "role": role,
    "time": time.toJson(),
  };
}

class Time {
  int date;

  Time({
    required this.date,
  });

  factory Time.fromJson(Map<String, dynamic> json) => Time(
    date: json["\u0024date"],
  );

  Map<String, dynamic> toJson() => {
    "\u0024date": date,
  };
}
