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
  List<Widget> get children => [
        FDelegate(
            title: 'Day view',
            description:
                'Day view shows your hourly rating for the selected day',
            featureId: 'calendar_view_day',
            child: Icon(Icons.calendar_view_day)),
        FDelegate(
            title: 'Week View',
            description:
            'Week view shows your daily average ratings, time spent on activities and screen time spent on various apps in the selected week.',
            featureId: 'view_week',
            child: Icon(Icons.view_week)),
        FDelegate(
            title: 'Month View',
            description:
            'Month view shows your daily average ratings, time spent on activities and screen time spent on various apps in the selected month.',
            featureId: 'date_range',
            child: Icon(Icons.date_range)),
      ];

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AppModel>(context);
    return Row(
      children: [
        for (int i = 0; i < children.length; i++)
          InkWell(
            onTap: () {
              if (model.animController.value == 1) model.changeViewToggle(i);
            },
            child: IconTheme(
                data: IconThemeData(
                    color: model.toggle == i
                        ? Theme.of(context).accentColor
                        : Theme.of(context).primaryColor),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: children[i],
                )),
          )
      ],
    );
  }
}
