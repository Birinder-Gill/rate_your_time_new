import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rate_your_time_new/hours_screens/widgets/empty_view.dart';
import 'package:rate_your_time_new/models/hours_model.dart';

import 'first_time_empty_view.dart';

class EmptyWeekView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final newUser = Provider.of<AppModel>(context).isEmpty;

    if (newUser) {
      return FirstTimeEmptyView(
        title: 'Week View',
        desc:
            "This is the week view description for this week. This screen shows the daily averages for this week for you to see the progress you've made this week so far and to compare it with previous weeeks.",
        assetPath: 'assets/images/week_view.jpg',
      );
    } else {
      return EmptyView();
    }
  }
}
