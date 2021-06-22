// To parse this JSON data, do
//
//     final activity = activityFromMap(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Activity {
  final Widget icon;

  const Activity({
    this.id,
    this.name,
    this.icon=const FaIcon(FontAwesomeIcons.goodreads),
  });

  final int id;
  final String name;


  factory Activity.fromJson(String str) => Activity.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Activity.fromMap(Map<String, dynamic> json) => Activity(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    icon: json["icon"] == null ? null : json["icon"],
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "icon": icon == null ? null : icon,
  };
}
