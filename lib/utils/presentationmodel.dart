// To parse this JSON data, do
//
//     final presentationmodel = presentationmodelFromJson(jsonString);

import 'dart:convert';

Presentationmodel presentationmodelFromJson(String str) => Presentationmodel.fromJson(json.decode(str));

String presentationmodelToJson(Presentationmodel data) => json.encode(data.toJson());

class Presentationmodel {
  String? msg;
  String? collection;
  String? id;
  Fields? fields;

  Presentationmodel({
    this.msg,
    this.collection,
    this.id,
    this.fields,
  });

  factory Presentationmodel.fromJson(Map<String, dynamic> json) => Presentationmodel(
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
  Conversion? conversion;
  String? name;
  bool? renderedInToast;
  String? temporaryPresentationId;
  bool? current;
  bool? downloadable;
  Exportation? exportation;
  String? filenameConverted;
  bool? isInitialPresentation;
  List<Page>? pages;
  bool? removable;
  String? downloadableExtension;

  Fields({
    this.id,
    this.meetingId,
    this.podId,
    this.conversion,
    this.name,
    this.renderedInToast,
    this.temporaryPresentationId,
    this.current,
    this.downloadable,
    this.exportation,
    this.filenameConverted,
    this.isInitialPresentation,
    this.pages,
    this.removable,
    this.downloadableExtension,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
    id: json["id"],
    meetingId: json["meetingId"],
    podId: json["podId"],
    conversion: json["conversion"] == null ? null : Conversion.fromJson(json["conversion"]),
    name: json["name"],
    renderedInToast: json["renderedInToast"],
    temporaryPresentationId: json["temporaryPresentationId"],
    current: json["current"],
    downloadable: json["downloadable"],
    exportation: json["exportation"] == null ? null : Exportation.fromJson(json["exportation"]),
    filenameConverted: json["filenameConverted"],
    isInitialPresentation: json["isInitialPresentation"],
    pages: json["pages"] == null ? [] : List<Page>.from(json["pages"]!.map((x) => Page.fromJson(x))),
    removable: json["removable"],
    downloadableExtension: json["downloadableExtension"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "meetingId": meetingId,
    "podId": podId,
    "conversion": conversion?.toJson(),
    "name": name,
    "renderedInToast": renderedInToast,
    "temporaryPresentationId": temporaryPresentationId,
    "current": current,
    "downloadable": downloadable,
    "exportation": exportation?.toJson(),
    "filenameConverted": filenameConverted,
    "isInitialPresentation": isInitialPresentation,
    "pages": pages == null ? [] : List<dynamic>.from(pages!.map((x) => x.toJson())),
    "removable": removable,
    "downloadableExtension": downloadableExtension,
  };
}

class Conversion {
  bool? done;
  bool? error;
  String? status;
  int? numPages;
  int? pagesCompleted;

  Conversion({
    this.done,
    this.error,
    this.status,
    this.numPages,
    this.pagesCompleted,
  });

  factory Conversion.fromJson(Map<String, dynamic> json) => Conversion(
    done: json["done"],
    error: json["error"],
    status: json["status"],
    numPages: json["numPages"],
    pagesCompleted: json["pagesCompleted"],
  );

  Map<String, dynamic> toJson() => {
    "done": done,
    "error": error,
    "status": status,
    "numPages": numPages,
    "pagesCompleted": pagesCompleted,
  };
}

class Exportation {
  dynamic status;

  Exportation({
    this.status,
  });

  factory Exportation.fromJson(Map<String, dynamic> json) => Exportation(
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
  };
}

class Page {
  String? id;
  int? num;
  String? thumbUri;
  String? txtUri;
  String? svgUri;
  bool? current;
  int? xOffset;
  int? yOffset;
  int? widthRatio;
  int? heightRatio;

  Page({
    this.id,
    this.num,
    this.thumbUri,
    this.txtUri,
    this.svgUri,
    this.current,
    this.xOffset,
    this.yOffset,
    this.widthRatio,
    this.heightRatio,
  });

  factory Page.fromJson(Map<String, dynamic> json) => Page(
    id: json["id"],
    num: json["num"],
    thumbUri: json["thumbUri"],
    txtUri: json["txtUri"],
    svgUri: json["svgUri"],
    current: json["current"],
    xOffset: json["xOffset"],
    yOffset: json["yOffset"],
    widthRatio: json["widthRatio"],
    heightRatio: json["heightRatio"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "num": num,
    "thumbUri": thumbUri,
    "txtUri": txtUri,
    "svgUri": svgUri,
    "current": current,
    "xOffset": xOffset,
    "yOffset": yOffset,
    "widthRatio": widthRatio,
    "heightRatio": heightRatio,
  };
}
