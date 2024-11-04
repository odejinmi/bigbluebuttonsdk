// To parse this JSON data, do
//
//     final participant = participantFromJson(jsonString);

import 'dart:convert';

import '../bigbluebuttonsdk.dart';



Participant participantFromJson(String str) => Participant.fromJson(json.decode(str));

String participantToJson(Participant data) => json.encode(data.toJson());

class Participant {
  String? msg;
  String? collection;
  String? id;
  String? presentation;
  bool? isvidieo = false;
  dynamic vidieoid;
  dynamic vidieodeviceId;
  dynamic mediaStream;
  RTCVideoRenderer? rtcVideoRenderer;
  Fields? fields;

  Participant({
    this.msg,
    this.collection,
    this.isvidieo,
    this.presentation,
    this.vidieoid,
    this.vidieodeviceId,
    this.mediaStream,
    this.rtcVideoRenderer,
    this.id,
    this.fields,
  });

  factory Participant.fromJson(Map<String, dynamic> json) => Participant(
    msg: json["msg"],
    collection: json["collection"],
    isvidieo: json["isvidieo"],
    presentation: json["presentation"],
    vidieoid: json["vidieoid"],
    vidieodeviceId: json["vidieodeviceId"],
    mediaStream: json["mediaStream"],
    rtcVideoRenderer: json["RTCVideoRenderer"],
    id: json["id"],
    fields: json["fields"] == null ? null : Fields.fromJson(json["fields"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "collection": collection,
    "presentation": presentation,
    "isvidieo": isvidieo,
    "vidieoid": vidieoid,
    "vidieodeviceId": vidieodeviceId,
    "mediaStream": mediaStream,
    "RTCVideoRenderer": rtcVideoRenderer,
    "id": id,
    "fields": fields?.toJson(),
  };
}

class Fields {
  String? meetingId;
  String? userId;
  String? clientType;
  bool? validated;
  bool? left;
  bool? approved;
  bool? talking;
  bool? spoke;
  bool? muted;
  String? voiceid;
  int? authTokenValidatedTime;
  bool? inactivityCheck;
  int? loginTime;
  bool? authed;
  String? avatar;
  String? chatId;
  bool? away;
  BreakoutProps? breakoutProps;
  String? color;
  dynamic effectiveConnectionType;
  String? emoji;
  String? extId;
  bool? guest;
  String? guestStatus;
  String? intId;
  bool? locked;
  bool? loggedOut;
  bool? mobile;
  String? name;
  bool? pin;
  bool? presenter;
  bool? raiseHand;
  String? reactionEmoji;
  int? responseDelay;
  String? role;
  String? sortName;
  String? speechLocale;

  Fields({
    this.meetingId,
    this.userId,
    this.clientType,
    this.validated,
    this.talking,
    this.spoke,
    this.muted,
    this.voiceid,
    this.left,
    this.approved,
    this.authTokenValidatedTime,
    this.inactivityCheck,
    this.loginTime,
    this.authed,
    this.avatar,
    this.chatId,
    this.away,
    this.breakoutProps,
    this.color,
    this.effectiveConnectionType,
    this.emoji,
    this.extId,
    this.guest,
    this.guestStatus,
    this.intId,
    this.locked,
    this.loggedOut,
    this.mobile,
    this.name,
    this.pin,
    this.presenter,
    this.raiseHand,
    this.reactionEmoji,
    this.responseDelay,
    this.role,
    this.sortName,
    this.speechLocale,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
    meetingId: json["meetingId"],
    userId: json["userId"],
    clientType: json["clientType"],
    validated: json["validated"],
    left: json["left"],
    chatId: json["chatId"],
    talking: json["talking"],
    spoke: json["spoke"],
    muted: json["muted"],
    voiceid: json["voiceid"],
    approved: json["approved"],
    authTokenValidatedTime: json["authTokenValidatedTime"],
    inactivityCheck: json["inactivityCheck"],
    loginTime: json["loginTime"],
    authed: json["authed"],
    avatar: json["avatar"],
    away: json["away"],
    breakoutProps: json["breakoutProps"] == null ? null : BreakoutProps.fromJson(json["breakoutProps"]),
    color: json["color"],
    effectiveConnectionType: json["effectiveConnectionType"],
    emoji: json["emoji"],
    extId: json["extId"],
    guest: json["guest"],
    guestStatus: json["guestStatus"],
    intId: json["intId"],
    locked: json["locked"],
    loggedOut: json["loggedOut"],
    mobile: json["mobile"],
    name: json["name"],
    pin: json["pin"],
    presenter: json["presenter"],
    raiseHand: json["raiseHand"],
    reactionEmoji: json["reactionEmoji"],
    responseDelay: json["responseDelay"],
    role: json["role"],
    sortName: json["sortName"],
    speechLocale: json["speechLocale"],
  );

  Map<String, dynamic> toJson() => {
    "meetingId": meetingId,
    "userId": userId,
    "clientType": clientType,
    "validated": validated,
    "left": left,
    "approved": approved,
    "talking": talking,
    "spoke": spoke,
    "muted": muted,
    "voiceid": voiceid,
    "authTokenValidatedTime": authTokenValidatedTime,
    "inactivityCheck": inactivityCheck,
    "loginTime": loginTime,
    "authed": authed,
    "avatar": avatar,
    "chatId": chatId,
    "away": away,
    "breakoutProps": breakoutProps?.toJson(),
    "color": color,
    "effectiveConnectionType": effectiveConnectionType,
    "emoji": emoji,
    "extId": extId,
    "guest": guest,
    "guestStatus": guestStatus,
    "intId": intId,
    "locked": locked,
    "loggedOut": loggedOut,
    "mobile": mobile,
    "name": name,
    "pin": pin,
    "presenter": presenter,
    "raiseHand": raiseHand,
    "reactionEmoji": reactionEmoji,
    "responseDelay": responseDelay,
    "role": role,
    "sortName": sortName,
    "speechLocale": speechLocale,
  };
}

class BreakoutProps {
  bool? isBreakoutUser;
  String? parentId;

  BreakoutProps({
    this.isBreakoutUser,
    this.parentId,
  });

  factory BreakoutProps.fromJson(Map<String, dynamic> json) => BreakoutProps(
    isBreakoutUser: json["isBreakoutUser"],
    parentId: json["parentId"],
  );

  Map<String, dynamic> toJson() => {
    "isBreakoutUser": isBreakoutUser,
    "parentId": parentId,
  };

  String toString() => toJson().toString();
}

