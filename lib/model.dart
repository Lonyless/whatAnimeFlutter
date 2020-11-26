// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  Welcome({
    this.used,
    this.source,
    this.type,
    this.deleted,
    this.id,
    this.v,
    this.text,
    this.updatedAt,
    this.createdAt,
    this.user,
  });

  bool used;
  String source;
  String type;
  bool deleted;
  String id;
  int v;
  String text;
  DateTime updatedAt;
  DateTime createdAt;
  String user;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        used: json["used"],
        source: json["source"],
        type: json["type"],
        deleted: json["deleted"],
        id: json["_id"],
        v: json["__v"],
        text: json["text"],
        updatedAt: DateTime.parse(json["updatedAt"]),
        createdAt: DateTime.parse(json["createdAt"]),
        user: json["user"],
      );

  Map<String, dynamic> toJson() => {
        "used": used,
        "source": source,
        "type": type,
        "deleted": deleted,
        "_id": id,
        "__v": v,
        "text": text,
        "updatedAt": updatedAt.toIso8601String(),
        "createdAt": createdAt.toIso8601String(),
        "user": user,
      };
}
