// To parse this JSON data, do
//
//     final slidemodel = slidemodelFromJson(jsonString);

import 'dart:convert';

Slidemodel slidemodelFromJson(String str) => Slidemodel.fromJson(json.decode(str));

String slidemodelToJson(Slidemodel data) => json.encode(data.toJson());

class Slidemodel {
  String? msg;
  String? collection;
  String? id;
  Fields? fields;

  Slidemodel({
    this.msg,
    this.collection,
    this.id,
    this.fields,
  });

  factory Slidemodel.fromJson(Map<String, dynamic> json) => Slidemodel(
    msg: json["msg"],
    collection: json["collection"],
    id: json["id"],
    fields: json["fields"] == null ? null : Fields.fromJson(json["fields"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "collection": collection,
    "id": id,
    "fields": fields?.toJson(),
  };
}

class Fields {
  String? id;
  String? meetingId;
  String? podId;
  String? presentationId;
  String? content;
  bool? current;
  String? imageUri;
  int? num;
  bool? safe;
  String? svgUri;
  String? thumbUri;
  String? txtUri;

  Fields({
    this.id,
    this.meetingId,
    this.podId,
    this.presentationId,
    this.content,
    this.current,
    this.imageUri,
    this.num,
    this.safe,
    this.svgUri,
    this.thumbUri,
    this.txtUri,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
    id: json["id"],
    meetingId: json["meetingId"],
    podId: json["podId"],
    presentationId: json["presentationId"],
    content: json["content"],
    current: json["current"],
    imageUri: json["imageUri"],
    num: json["num"],
    safe: json["safe"],
    svgUri: json["svgUri"],
    thumbUri: json["thumbUri"],
    txtUri: json["txtUri"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "meetingId": meetingId,
    "podId": podId,
    "presentationId": presentationId,
    "content": content,
    "current": current,
    "imageUri": imageUri,
    "num": num,
    "safe": safe,
    "svgUri": svgUri,
    "thumbUri": thumbUri,
    "txtUri": txtUri,
  };
}
