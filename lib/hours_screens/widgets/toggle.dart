import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rate_your_time_new/feature_discovery/delegate.dart';
import 'package:rate_your_time_new/models/hours_model.dart';

class ViewToggle extends StatefulWidget {
  const ViewToggle({
    Key key,
  }) : super(key: key);

  @override
  _ViewToggleState createState() => _ViewToggleState();
}

class _ViewToggleState extends State<ViewToggle> {
  double get _size => 35;
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AppModel>(context);
    final theme = Theme.of(context);
    // DateTime now = DateTime.now();
    return CupertinoSegmentedControl<int>(
      groupValue: model.toggle,
      selectedColor: theme.primaryColor,
      unselectedColor: Colors.white,
      borderColor: theme.accentColor,
      onValueChanged: (int i) {
        if (model.animController.value == 1) model.changeViewToggle(i);
      },
      children: {
        0: SizedBox(
          height: _size,
          width: _size,
          child: FDelegate(
              title: 'Day view',
              description:
                  'Day view shows your hourly rating for the selected day',
              featureId: 'calendar_view_day',
              child: Icon(Icons.calendar_view_day,color: model.toggle==0?theme.accentColor:theme.primaryColor,)),
        ),
        // if (now.weekday > 1)
          1: SizedBox(
            height: _size,
            width: _size,
            child: FDelegate(
                title: 'Week View',
                description:
                    'Week view shows your daily average ratings, time spent on activities and screen time spent on various apps in the selected week.',
                featureId: 'view_week',
                child: Icon(Icons.view_week,color: model.toggle==1?theme.accentColor:theme.primaryColor,)),
          ),
        // if (now.day > 1)
          2: SizedBox(
            height: _size,
            width: _size,
            child: FDelegate(
                title: 'Month View',
                description:
                    'Month view shows your daily average ratings, time spent on activities and screen time spent on various apps in the selected month.',
                featureId: 'date_range',
                child: Icon(Icons.date_range,color: model.toggle==2?theme.accentColor:theme.primaryColor,)),
          ),
      },
    );
  }
}
