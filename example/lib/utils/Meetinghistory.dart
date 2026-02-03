import 'dart:convert';

import 'package:flutter/material.dart';

List<Meetinghistoryparser> meetinghistoryparserFromJson(String str) =>
    List<Meetinghistoryparser>.from(
        json.decode(str).map((x) => Meetinghistoryparser.fromJson(x)));

String meetinghistoryparserToJson(List<Meetinghistoryparser> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Meetinghistoryparser extends ChangeNotifier {
  Meetinghistoryparser({
    required this.id,
    required this.meetingId,
    required this.identifier,
    required this.name,
    required this.email,
    this.passwordAttendee,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.room,
  });

  int id;
  int meetingId;
  String identifier;
  String name;
  String email;
  String? passwordAttendee;
  String status;
  DateTime createdAt;
  DateTime? updatedAt;
  Room? room;

  factory Meetinghistoryparser.fromJson(Map<String, dynamic> json) =>
      Meetinghistoryparser(
        id: json["id"],
        meetingId: json["meeting_id"],
        identifier: json["identifier"] ?? ' ',
        name: json["name"],
        email: json["email"],
        passwordAttendee: json["password_attendee"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : null,
        room: json["room"] != null ? Room.fromJson(json["room"]):null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "meeting_id": meetingId,
        "identifier": identifier,
        "name": name,
        "email": email,
        "password_attendee": passwordAttendee,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "room": room?.toJson(),
      };
}

class Room extends ChangeNotifier {
  Room({
    required this.id,
    required this.userId,
    required this.name,
    required this.url,
    required this.defaultRoom,
    this.dialNumber,
    required this.welcomeMessage,
    required this.logoutUrl,
    required this.maxParticipants,
    required this.duration,
    this.muj,
    this.dpuc,
    this.dprc,
    this.ewma,
    this.dum,
    this.dsn,
    this.dwr,
    this.banner,
    this.prereg,
    this.bbbReturncode,
    this.internalMeetingId,
    this.parentMeetingId,
    this.voiceBridge,
    this.createDate,
    this.createTime,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int userId;
  String name;
  String url;
  String defaultRoom;
  dynamic dialNumber;
  String welcomeMessage;
  String logoutUrl;
  int maxParticipants;
  int duration;
  dynamic muj;
  dynamic dpuc;
  dynamic dprc;
  dynamic ewma;
  dynamic dum;
  dynamic dsn;
  dynamic dwr;
  dynamic banner;
  dynamic prereg;
  dynamic bbbReturncode;
  dynamic internalMeetingId;
  dynamic parentMeetingId;
  dynamic voiceBridge;
  dynamic createDate;
  dynamic createTime;
  DateTime createdAt;
  DateTime updatedAt;

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        url: json["url"],
        defaultRoom: json["default_room"],
        dialNumber: json["dial_number"],
        welcomeMessage: json["welcome_message"],
        logoutUrl: json["logout_url"],
        maxParticipants: json["max_participants"],
        duration: json["duration"],
        muj: json["muj"],
        dpuc: json["dpuc"],
        dprc: json["dprc"],
        ewma: json["ewma"],
        dum: json["dum"],
        dsn: json["dsn"],
        dwr: json["dwr"],
        banner: json["banner"],
        prereg: json["prereg"],
        bbbReturncode: json["bbb_returncode"],
        internalMeetingId: json["internalMeetingID"],
        parentMeetingId: json["parentMeetingID"],
        voiceBridge: json["voiceBridge"],
        createDate: json["createDate"],
        createTime: json["createTime"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "url": url,
        "default_room": defaultRoom,
        "dial_number": dialNumber,
        "welcome_message": welcomeMessage,
        "logout_url": logoutUrl,
        "max_participants": maxParticipants,
        "duration": duration,
        "muj": muj,
        "dpuc": dpuc,
        "dprc": dprc,
        "ewma": ewma,
        "dum": dum,
        "dsn": dsn,
        "dwr": dwr,
        "banner": banner,
        "prereg": prereg,
        "bbb_returncode": bbbReturncode,
        "internalMeetingID": internalMeetingId,
        "parentMeetingID": parentMeetingId,
        "voiceBridge": voiceBridge,
        "createDate": createDate,
        "createTime": createTime,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
