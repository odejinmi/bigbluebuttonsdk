// To parse this JSON data, do
//
//     final roomlistparser = roomlistparserFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

List<Roomlistparser> roomlistparserFromJson(String str) =>
    List<Roomlistparser>.from(
        json.decode(str).map((x) => Roomlistparser.fromJson(x)));

String roomlistparserToJson(List<Roomlistparser> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Roomlistparser extends ChangeNotifier {
  Roomlistparser({
    required this.id,
    required this.name,
    required this.url,
    required this.logoutUrl,
    required this.welcomeMessage,
    required this.maxParticipants,
    required this.duration,
    this.banner,
    required this.createdAt,
  });

  int id;
  String name;
  String url;
  String logoutUrl;
  String welcomeMessage;
  int maxParticipants;
  int duration;
  dynamic banner;
  DateTime createdAt;

  factory Roomlistparser.fromJson(Map<String, dynamic> json) => Roomlistparser(
        id: json["id"],
        name: json["name"],
        url: json["url"],
        logoutUrl: json["logout_url"],
        welcomeMessage: json["welcome_message"],
        maxParticipants: json["max_participants"],
        duration: json["duration"],
        banner: json["banner"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "url": url,
        "logout_url": logoutUrl,
        "welcome_message": welcomeMessage,
        "max_participants": maxParticipants,
        "duration": duration,
        "banner": banner,
        "created_at": createdAt.toIso8601String(),
      };
}
