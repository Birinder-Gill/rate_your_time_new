import 'package:flutter/src/widgets/icon_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rate_your_time_new/models/activity_model.dart';

Map<int,Activity> activities = {
   1: Activity(id: 1, name: "Sleep", icon: _faIcon(FontAwesomeIcons.bed,)),
   2: Activity(
       id: 2, name: "Transport", icon: _faIcon(FontAwesomeIcons.carSide)),
   3: Activity(id: 3, name: "Eat", icon: _faIcon(FontAwesomeIcons.pizzaSlice)),
   4: Activity(
       id: 4, name: "Sports", icon: _faIcon(FontAwesomeIcons.basketballBall)),
   5: Activity(id: 5, name: "Read", icon: _faIcon(FontAwesomeIcons.book)),
   6: Activity(id: 6, name: "Work", icon: _faIcon(FontAwesomeIcons.briefcase)),
   7: Activity(
       id: 7, name: "Shop", icon: _faIcon(FontAwesomeIcons.shoppingCart)),
   8: Activity(
       id: 8, name: "Entertainment", icon: _faIcon(FontAwesomeIcons.gamepad)),
   9: Activity(id: 9, name: "Housework", icon: _faIcon(FontAwesomeIcons.broom)),
   10: Activity(id: 10, name: "Cinema", icon: _faIcon(FontAwesomeIcons.film)),
   11: Activity(id: 11, name: "Walk", icon: _faIcon(FontAwesomeIcons.walking)),
   12: Activity(
       id: 12, name: "Study", icon: _faIcon(FontAwesomeIcons.userGraduate)),
   13: Activity(
       id: 13, name: "Internet", icon: _faIcon(FontAwesomeIcons.tablet)),
   14: Activity(
       id: 14, name: "Exercise", icon: _faIcon(FontAwesomeIcons.dumbbell)),
   15: Activity(id: 15, name: "Date", icon: _faIcon(FontAwesomeIcons.heart)),
};

_faIcon(IconData icon) =>FaIcon(icon,size: 16,);