import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:rate_your_time_new/goal/goal_widget.dart';
import 'package:rate_your_time_new/hours_screens/widgets/empty_day_view.dart';
import 'package:rate_your_time_new/hours_screens/widgets/empty_view.dart';
import 'package:rate_your_time_new/models/hours_model.dart';
import 'package:rate_your_time_new/providers/day_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:rate_your_time_new/widgets/hour_widget.dart';
import 'package:rate_your_time_new/widgets/ratings_widget.dart';

class DayViewWrapper extends StatelessWidget {
  // final bool firstDay;

  DayViewWrapper(/*this.firstDay*/);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value:
          DayModel(date: Provider.of<AppModel>(context, listen: false).date),
      child: DayViewScreen(),
    );
  }
}

class DayViewScreen extends StatefulWidget{
  // final bool firstDay;

  DayViewScreen(/*this.firstDay*/);

  @override
  _DayViewScreenState createState() => _DayViewScreenState();
}

class _DayViewScreenState extends State<DayViewScreen> with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("State = $state");
    if (state == AppLifecycleState.resumed) {
      Provider.of<AppModel>(context).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DayModel>(
      builder: (_, model, __) {
        if(!model.loaded)
          return simpleLoader();
        if ((model.hours?.length ?? 0) == 0) {
          return EmptyDayView();
        }
        return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        for (var i in model.hours)
                          HourWidget(i, updateHour: (hour) {
                            model.updateHour(hour);
                          }),
                        // GoalWidgetWrapper(),
                      ],
                    ),
                  ),
                ),
                if (model.average > 0) _average(context, model.average)
              ],
            );
      },
    );
  }

  Widget _average(context, average) => Material(
    elevation: 12,
    color: Theme.of(context).scaffoldBackgroundColor,
    child: Row(
          children: [
            Container(
              height: 90,
               child: SizedBox(
                width: 60,
                child: Center(
                  child: Text(
                    'Average',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyText2.color),
                  ),
                ),
              ),
            ),
            Expanded(
              // child: Dismissible(
              //    background: Container(color: Colors.red,),
              //   secondaryBackground: Container(color: Colors.green,),

              // key: ValueKey(hour.id),
              child: Container(
                height: 90,
                // padding: const EdgeInsets.symmetric(vertical:4.0),
                decoration: const BoxDecoration(
                    border: const Border(
                  left: const BorderSide(),
                )),
                child: Stack(
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                           false?RatingStars(size: 50,): LinearProgressIndicator(
                                minHeight: 16,
                                backgroundColor: Colors.white,
                                value: (average),
                                valueColor: AlwaysStoppedAnimation(
                                    Theme.of(context).accentColor)),
                          ],
                        )),
                  ],
                ),
              ),
              // ),
            ),
          ],
        ),
  );

}
