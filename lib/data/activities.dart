import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rate_your_time_new/models/activity_model.dart';

const Map<int,Activity> activities =const {
   1: Activity(id: 1, name: "Sleep", icon: FaIcon(FontAwesomeIcons.bed)),
   2: Activity(
       id: 2, name: "Transport", icon: FaIcon(FontAwesomeIcons.carSide)),
   3: Activity(id: 3, name: "Eat", icon: FaIcon(FontAwesomeIcons.pizzaSlice)),
   4: Activity(
       id: 4, name: "Sports", icon: FaIcon(FontAwesomeIcons.basketballBall)),
   5: Activity(id: 5, name: "Read", icon: FaIcon(FontAwesomeIcons.book)),
   6: Activity(id: 6, name: "Work", icon: FaIcon(FontAwesomeIcons.briefcase)),
   7: Activity(
       id: 7, name: "Shop", icon: FaIcon(FontAwesomeIcons.shoppingCart)),
   8: Activity(
       id: 8, name: "Entertainment", icon: FaIcon(FontAwesomeIcons.gamepad)),
   9: Activity(id: 9, name: "Housework", icon: FaIcon(FontAwesomeIcons.broom)),
   10: Activity(id: 10, name: "Cinema", icon: FaIcon(FontAwesomeIcons.film)),
   11: Activity(id: 11, name: "Walk", icon: FaIcon(FontAwesomeIcons.walking)),
   12: Activity(
       id: 12, name: "Study", icon: FaIcon(FontAwesomeIcons.userGraduate)),
   13: Activity(
       id: 13, name: "Internet", icon: FaIcon(FontAwesomeIcons.tablet)),
   14: Activity(
       id: 14, name: "Exercise", icon: FaIcon(FontAwesomeIcons.dumbbell)),
   15: Activity(id: 15, name: "Date", icon: FaIcon(FontAwesomeIcons.heart)),
};