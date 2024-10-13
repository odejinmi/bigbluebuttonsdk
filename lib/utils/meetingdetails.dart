// To parse this JSON data, do
//
//     final meetingdetails = meetingdetailsFromJson(jsonString);

import 'dart:convert';

Meetingdetails meetingdetailsFromJson(String str) => Meetingdetails.fromJson(json.decode(str));

String meetingdetailsToJson(Meetingdetails data) => json.encode(data.toJson());

class Meetingdetails {
  String returncode;
  String fullname;
  String confname;
  String meetingId;
  String externMeetingId;
  String externUserId;
  String internalUserId;
  String authToken;
  String role;
  bool guest;
  String guestStatus;
  String conference;
  String room;
  String voicebridge;
  String dialnumber;
  String webvoiceconf;
  String mode;
  String record;
  bool isBreakout;
  int logoutTimer;
  bool allowStartStopRecording;
  bool recordFullDurationMedia;
  String welcome;
  String customLogoUrl;
  String customCopyright;
  bool muteOnStart;
  bool allowModsToUnmuteUsers;
  String logoutUrl;
  String defaultLayout;
  String avatarUrl;
  BreakoutRooms breakoutRooms;
  List<dynamic> customdata;
  List<dynamic> metadata;

  Meetingdetails({
    required this.returncode,
    required this.fullname,
    required this.confname,
    required this.meetingId,
    required this.externMeetingId,
    required this.externUserId,
    required this.internalUserId,
    required this.authToken,
    required this.role,
    required this.guest,
    required this.guestStatus,
    required this.conference,
    required this.room,
    required this.voicebridge,
    required this.dialnumber,
    required this.webvoiceconf,
    required this.mode,
    required this.record,
    required this.isBreakout,
    required this.logoutTimer,
    required this.allowStartStopRecording,
    required this.recordFullDurationMedia,
    required this.welcome,
    required this.customLogoUrl,
    required this.customCopyright,
    required this.muteOnStart,
    required this.allowModsToUnmuteUsers,
    required this.logoutUrl,
    required this.defaultLayout,
    required this.avatarUrl,
    required this.breakoutRooms,
    required this.customdata,
    required this.metadata,
  });

  factory Meetingdetails.fromJson(Map<String, dynamic> json) => Meetingdetails(
    returncode: json["returncode"],
    fullname: json["fullname"],
    confname: json["confname"],
    meetingId: json["meetingID"],
    externMeetingId: json["externMeetingID"],
    externUserId: json["externUserID"],
    internalUserId: json["internalUserID"],
    authToken: json["authToken"],
    role: json["role"],
    guest: json["guest"],
    guestStatus: json["guestStatus"],
    conference: json["conference"],
    room: json["room"],
    voicebridge: json["voicebridge"],
    dialnumber: json["dialnumber"],
    webvoiceconf: json["webvoiceconf"],
    mode: json["mode"],
    record: json["record"],
    isBreakout: json["isBreakout"],
    logoutTimer: json["logoutTimer"],
    allowStartStopRecording: json["allowStartStopRecording"],
    recordFullDurationMedia: json["recordFullDurationMedia"],
    welcome: json["welcome"],
    customLogoUrl: json["customLogoURL"],
    customCopyright: json["customCopyright"],
    muteOnStart: json["muteOnStart"],
    allowModsToUnmuteUsers: json["allowModsToUnmuteUsers"],
    logoutUrl: json["logoutUrl"],
    defaultLayout: json["defaultLayout"],
    avatarUrl: json["avatarURL"],
    breakoutRooms: BreakoutRooms.fromJson(json["breakoutRooms"]),
    customdata: List<dynamic>.from(json["customdata"].map((x) => x)),
    metadata: List<dynamic>.from(json["metadata"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "returncode": returncode,
    "fullname": fullname,
    "confname": confname,
    "meetingID": meetingId,
    "externMeetingID": externMeetingId,
    "externUserID": externUserId,
    "internalUserID": internalUserId,
    "authToken": authToken,
    "role": role,
    "guest": guest,
    "guestStatus": guestStatus,
    "conference": conference,
    "room": room,
    "voicebridge": voicebridge,
    "dialnumber": dialnumber,
    "webvoiceconf": webvoiceconf,
    "mode": mode,
    "record": record,
    "isBreakout": isBreakout,
    "logoutTimer": logoutTimer,
    "allowStartStopRecording": allowStartStopRecording,
    "recordFullDurationMedia": recordFullDurationMedia,
    "welcome": welcome,
    "customLogoURL": customLogoUrl,
    "customCopyright": customCopyright,
    "muteOnStart": muteOnStart,
    "allowModsToUnmuteUsers": allowModsToUnmuteUsers,
    "logoutUrl": logoutUrl,
    "defaultLayout": defaultLayout,
    "avatarURL": avatarUrl,
    "breakoutRooms": breakoutRooms.toJson(),
    "customdata": List<dynamic>.from(customdata.map((x) => x)),
    "metadata": List<dynamic>.from(metadata.map((x) => x)),
  };
}

class BreakoutRooms {
  bool record;
  bool privateChatEnabled;
  bool captureNotes;
  bool captureSlides;
  String captureNotesFilename;
  String captureSlidesFilename;

  BreakoutRooms({
    required this.record,
    required this.privateChatEnabled,
    required this.captureNotes,
    required this.captureSlides,
    required this.captureNotesFilename,
    required this.captureSlidesFilename,
  });

  factory BreakoutRooms.fromJson(Map<String, dynamic> json) => BreakoutRooms(
    record: json["record"],
    privateChatEnabled: json["privateChatEnabled"],
    captureNotes: json["captureNotes"],
    captureSlides: json["captureSlides"],
    captureNotesFilename: json["captureNotesFilename"],
    captureSlidesFilename: json["captureSlidesFilename"],
  );

  Map<String, dynamic> toJson() => {
    "record": record,
    "privateChatEnabled": privateChatEnabled,
    "captureNotes": captureNotes,
    "captureSlides": captureSlides,
    "captureNotesFilename": captureNotesFilename,
    "captureSlidesFilename": captureSlidesFilename,
  };
}
