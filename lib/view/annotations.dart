// To parse this JSON data, do
//
//     final annotations = annotationsFromJson(jsonString);

import 'dart:convert';

Annotations annotationsFromJson(String str) => Annotations.fromJson(json.decode(str));

String annotationsToJson(Annotations data) => json.encode(data.toJson());

class Annotations {
  String? msg;
  String? collection;
  String? id;
  Fields? fields;

  Annotations({
    this.msg,
    this.collection,
    this.id,
    this.fields,
  });

  factory Annotations.fromJson(Map<String, dynamic> json) => Annotations(
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
  AnnotationInfo? annotationInfo;
  String? wbId;
  String? whiteboardId;

  Fields({
    this.id,
    this.meetingId,
    this.annotationInfo,
    this.wbId,
    this.whiteboardId,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
    id: json["id"],
    meetingId: json["meetingId"],
    annotationInfo: json["annotationInfo"] == null ? null : AnnotationInfo.fromJson(json["annotationInfo"]),
    wbId: json["wbId"],
    whiteboardId: json["whiteboardId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "meetingId": meetingId,
    "annotationInfo": annotationInfo?.toJson(),
    "wbId": wbId,
    "whiteboardId": whiteboardId,
  };
}

class AnnotationInfo {
  List<double>? size;
  List<double>? radius;
  Style? style;
  int? rotation;
  bool? isModerator;
  bool? isComplete;
  String? parentId;
  int? childIndex;
  String? name;
  List<double>? point;
  List<List<double>>? points;
  String? id;
  String? userId;
  String? type;

  AnnotationInfo({
    this.size,
    this.radius,
    this.style,
    this.rotation,
    this.isModerator,
    this.isComplete,
    this.parentId,
    this.childIndex,
    this.name,
    this.point,
    this.points,
    this.id,
    this.userId,
    this.type,
  });

  factory AnnotationInfo.fromJson(Map<String, dynamic> json) => AnnotationInfo(
    size: json["size"] == null ? [] : List<double>.from(json["size"]!.map((x) => x?.toDouble())),
    radius: json["radius"] == null ? [] : List<double>.from(json["radius"]!.map((x) => x?.toDouble())),
    style: json["style"] == null ? null : Style.fromJson(json["style"]),
    rotation: json["rotation"],
    isModerator: json["isModerator"],
    isComplete: json["isComplete"],
    parentId: json["parentId"],
    childIndex: json["childIndex"],
    name: json["name"],
    point: json["point"] == null ? [] : List<double>.from(json["point"]!.map((x) => x?.toDouble())),
    points: json["points"] == null ? [] : List<List<double>>.from(json["points"]!.map((x) => List<double>.from(x.map((x) => x?.toDouble())))),
    id: json["id"],
    userId: json["userId"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "size": size == null ? [] : List<dynamic>.from(size!.map((x) => x)),
    "radius": size == null ? [] : List<dynamic>.from(radius!.map((x) => x)),
    "style": style?.toJson(),
    "rotation": rotation,
    "isModerator": isModerator,
    "isComplete": isComplete,
    "parentId": parentId,
    "childIndex": childIndex,
    "name": name,
    "point": point == null ? [] : List<dynamic>.from(point!.map((x) => x)),
    "points": points == null ? [] : List<dynamic>.from(points!.map((x) => List<dynamic>.from(x.map((x) => x)))),
    "id": id,
    "userId": userId,
    "type": type,
  };
}

class Style {
  bool? isFilled;
  String? size;
  int? scale;
  String? color;
  String? textAlign;
  String? font;
  String? dash;

  Style({
    this.isFilled,
    this.size,
    this.scale,
    this.color,
    this.textAlign,
    this.font,
    this.dash,
  });

  factory Style.fromJson(Map<String, dynamic> json) => Style(
    isFilled: json["isFilled"],
    size: json["size"],
    scale: json["scale"],
    color: json["color"],
    textAlign: json["textAlign"],
    font: json["font"],
    dash: json["dash"],
  );

  Map<String, dynamic> toJson() => {
    "isFilled": isFilled,
    "size": size,
    "scale": scale,
    "color": color,
    "textAlign": textAlign,
    "font": font,
    "dash": dash,
  };
}
