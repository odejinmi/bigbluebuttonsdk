// To parse this JSON data, do
//
//     final pollanalyseparser = pollanalyseparserFromJson(jsonString);

import 'dart:convert';

Pollanalyseparser pollanalyseparserFromJson(String str) => Pollanalyseparser.fromJson(json.decode(str));

String pollanalyseparserToJson(Pollanalyseparser data) => json.encode(data.toJson());

class Pollanalyseparser {
  List<Answer>? answers;
  int? numRespondents;
  int? numResponders;
  String? questionText;
  String? questionType;
  List<Response>? responses;
  List<dynamic>? users;

  Pollanalyseparser({
    this.answers,
    this.numRespondents,
    this.numResponders,
    this.questionText,
    this.questionType,
    this.responses,
    this.users,
  });

  factory Pollanalyseparser.fromJson(Map<String, dynamic> json) => Pollanalyseparser(
    answers: json["answers"] == null ? [] : List<Answer>.from(json["answers"]!.map((x) => Answer.fromJson(x))),
    numRespondents: json["numRespondents"],
    numResponders: json["numResponders"],
    questionText: json["questionText"],
    questionType: json["questionType"],
    responses: json["responses"] == null ? [] : List<Response>.from(json["responses"]!.map((x) => Response.fromJson(x))),
    users: json["users"] == null ? [] : List<dynamic>.from(json["users"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "answers": answers == null ? [] : List<dynamic>.from(answers!.map((x) => x.toJson())),
    "numRespondents": numRespondents,
    "numResponders": numResponders,
    "questionText": questionText,
    "questionType": questionType,
    "responses": responses == null ? [] : List<dynamic>.from(responses!.map((x) => x.toJson())),
    "users": users == null ? [] : List<dynamic>.from(users!.map((x) => x)),
  };
  
  @override
  String toString() => toJson().toString();
}

class Answer {
  int? id;
  String? key;
  int? numVotes;

  Answer({
    this.id,
    this.key,
    this.numVotes,
  });

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
    id: json["id"],
    key: json["key"],
    numVotes: json["numVotes"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "key": key,
    "numVotes": numVotes,
  };

  @override
  String toString() => toJson().toString();
}

class Response {
  String? userId;
  List<int>? answerIds;

  Response({
    this.userId,
    this.answerIds,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    userId: json["userId"],
    answerIds: json["answerIds"] == null ? [] : List<int>.from(json["answerIds"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "answerIds": answerIds == null ? [] : List<dynamic>.from(answerIds!.map((x) => x)),
  };

  @override
  String toString() => toJson().toString();
}
