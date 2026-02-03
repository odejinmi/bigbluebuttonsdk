// To parse this JSON data, do
//
//     final messagelistperser = messagelistperserFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

List<Messagelistperser> messagelistperserFromJson(String str) =>
    List<Messagelistperser>.from(
        json.decode(str).map((x) => Messagelistperser.fromJson(x)));

String messagelistperserToJson(List<Messagelistperser> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Messagelistperser extends ChangeNotifier {
  Messagelistperser({
    this.id,
    this.roomId,
    this.sender,
    this.message,
    this.replyTo,
    this.type,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.user,
  });

  var id;
  var roomId;
  var sender;
  var message;
  var replyTo;
  var type;
  var status;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  User? user;

  factory Messagelistperser.fromJson(Map<String, dynamic> json) =>
      Messagelistperser(
        id: json["id"],
        roomId: json["room_id"],
        sender: json["sender"],
        message: json["message"],
        replyTo: json["reply_to"],
        type: json["type"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "room_id": roomId,
        "sender": sender,
        "message": message,
        "reply_to": replyTo,
        "type": type,
        "status": status,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "deleted_at": deletedAt,
        "user": user!.toJson(),
      };
}

class User extends ChangeNotifier {
  User({
    this.id,
    this.firstname,
    this.lastname,
    this.email,
    this.phone,
    this.referralCode,
    this.referral,
    this.plan,
    // this.subscription,
    this.freetrial,
    this.type,
    this.status,
    this.emailVerifiedAt,
    this.currentTeamId,
    this.profilePhotoPath,
    this.whatsappInvite,
    this.roomBundles,
    this.createdAt,
    this.updatedAt,
    this.profilePhotoUrl,
  });

  var id;
  var firstname;
  var lastname;
  var email;
  var phone;
  var referralCode;
  dynamic referral;
  var plan;
  // DateTime? subscription;
  var freetrial;
  var type;
  var status;
  dynamic emailVerifiedAt;
  dynamic currentTeamId;
  dynamic profilePhotoPath;
  var whatsappInvite;
  var roomBundles;
  DateTime? createdAt;
  DateTime? updatedAt;
  var profilePhotoUrl;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        phone: json["phone"],
        referralCode: json["referral_code"],
        referral: json["referral"],
        plan: json["plan"],
        // subscription: DateTime.parse(json["subscription"]),
        freetrial: json["freetrial"],
        type: json["type"],
        status: json["status"],
        emailVerifiedAt: json["email_verified_at"],
        currentTeamId: json["current_team_id"],
        profilePhotoPath: json["profile_photo_path"],
        whatsappInvite: json["whatsapp_invite"],
        roomBundles: json["room_bundles"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        profilePhotoUrl: json["profile_photo_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "phone": phone,
        "referral_code": referralCode,
        "referral": referral,
        "plan": plan,
        // "subscription": subscription!.toIso8601String(),
        "freetrial": freetrial,
        "type": type,
        "status": status,
        "email_verified_at": emailVerifiedAt,
        "current_team_id": currentTeamId,
        "profile_photo_path": profilePhotoPath,
        "whatsapp_invite": whatsappInvite,
        "room_bundles": roomBundles,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "profile_photo_url": profilePhotoUrl,
      };
}
