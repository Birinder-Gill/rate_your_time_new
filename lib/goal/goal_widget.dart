import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rate_your_time_new/goal/goal_provider.dart';
import 'package:rate_your_time_new/models/hours_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:rate_your_time_new/widgets/ratings_widget.dart';

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
      builder: (_, v, __) {
        if (!v.loaded) return simpleLoader();
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            elevation: 1,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if(v.goal==null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Enter goal for today",
                        hintText: "Be specific and sh*t."
                      ),
                    ),
                  ),
                  _GoalView(v.goal)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GoalView extends StatelessWidget {
  final Goal goal;
  _GoalView(this.goal);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          "Your goal for today",
          style: theme.subtitle2,
        ),
        Text(
          "${goal.goal}",
          style: theme.headline5,
        ),
        Divider(),
        Text(
          "Rating target for today",
          style: theme.subtitle1,
        ),
        RatingStars(
          rating: goal.ratingTarget,
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Column(
              children: [
                Text(
                  "Would you consider you accomplished your goal for today",
                  style: theme.button,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                        child: OutlinedButton(
                            onPressed: () {}, child: Text("YES"))),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                        child: OutlinedButton(
                            onPressed: () {}, child: Text("No"))),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
