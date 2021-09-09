import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rate_your_time_new/goal/goal_provider.dart';
import 'package:rate_your_time_new/models/hours_model.dart';

class GoalWidgetWrapper extends StatelessWidget {
  final goalProvider = GoalProvider();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GoalProvider>.value(
        value: goalProvider..loadGoal(Provider.of<HoursModel>(context).date),
        child: GoalWidget());
  }
}

class GoalWidget extends StatefulWidget {
  @override
  _GoalWidgetState createState() => _GoalWidgetState();
}

class _GoalWidgetState extends State<GoalWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GoalProvider>(
      builder:(_,v,__)=> Material(
        child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                ],
              ),
        ),
      ),
    );
  }
}
