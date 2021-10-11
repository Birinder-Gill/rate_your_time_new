// To parse this JSON data, do
//
//     final activity = activityFromMap(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Activity {
  final IconData icon;

  final int timeSpent;

  const Activity(
      {this.id,
      this.name,
      this.icon = FontAwesomeIcons.goodreads,
      this.timeSpent = 0});

  Activity copyWith({
    int id,
    String name,
    Widget icon,
    int timeSpent,
  }) =>
      Activity(
          id: id ?? this.id,
          name: name ?? this.name,
          icon: icon ?? this.icon,
          timeSpent: timeSpent ?? this.timeSpent);

  final int id;
  final String name;

  @override
  String toString() {
    return name;
  }

  factory Activity.fromJson(String str) => Activity.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Activity.fromMap(Map<String, dynamic> json) => Activity(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        icon: json["icon"] == null ? null : json["icon"],
        timeSpent: json["timeSpent"] ?? 0,
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "icon": icon == null ? null : icon,
        'timeSpent': timeSpent ?? 0
      };
}
