import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:rate_your_time_new/utils/api_helper.dart';

class GoalProvider with ChangeNotifier {
  Goal? goal;

  bool loaded=false;

  loadGoal(DateTime date) async {
    final json = await ApiHelper.loadGoal(date);
    this.goal = Goal.fromMap(json);
    loaded=true;
    notifyListeners();
  }
}

class Goal {
  Goal({
    required this.id,
    required this.ratingTarget,
    required this.date,
    required this.month,
    required this.year,
    required this.isAccomplished,
    required this.goal,
  });

  int id;
  double ratingTarget;
  int date;
  int month;
  int year;
  int isAccomplished;
  String goal;

  Goal copyWith({
    int? id,
    double? ratingTarget,
    int? date,
    int? month,
    int? year,
    int? isAccomplished,
    String? goal,
  }) =>
      Goal(
        id: id ?? this.id,
        ratingTarget: ratingTarget ?? this.ratingTarget,
        date: date ?? this.date,
        month: month ?? this.month,
        year: year ?? this.year,
        isAccomplished: isAccomplished ?? this.isAccomplished,
        goal: goal ?? this.goal,
      );

  factory Goal.fromJson(String str) => Goal.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Goal.fromMap(Map<String, dynamic> json) => Goal(
        id: json["id"] == null ? null : json["id"],
        ratingTarget:
            json["ratingTarget"] == null ? null : json["ratingTarget"],
        date: json["date"] == null ? null : json["date"],
        month: json["month"] == null ? null : json["month"],
        year: json["year"] == null ? null : json["year"],
        isAccomplished:
            json["isAccomplished"] == null ? null : json["isAccomplished"],
        goal: json["goal"] == null ? null : json["goal"],
      );

  Map<String, dynamic> toMap() => {
        "id": id ,
        "ratingTarget": ratingTarget ,
        "date": date ,
        "month": month ,
        "year": year ,
        "isAccomplished": isAccomplished ,
        "goal": goal ,
      };
}
