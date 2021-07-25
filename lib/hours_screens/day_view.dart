import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:rate_your_time_new/models/hours_model.dart';
import 'package:rate_your_time_new/providers/day_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:rate_your_time_new/widgets/hour_widget.dart';

class DayViewWrapper extends StatelessWidget {
  final bool firstDay;

  DayViewWrapper(this.firstDay);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value:
          DayModel(date: Provider.of<HoursModel>(context, listen: false).date),
      child: DayViewScreen(firstDay),
    );
  }
}

class DayViewScreen extends StatelessWidget {
  final bool firstDay;

  DayViewScreen(this.firstDay);

  @override
  Widget build(BuildContext context) {
    return Consumer<DayModel>(
      builder: (_, model, __) => !model.loaded
          ? simpleLoader()
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    // physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        if ((model.hours?.length ?? 0) == 0)
                          _emptyView(context),
                        for (var i in model.hours)
                          HourWidget(i, updateHour: (id, activityId, note) {
                            model.updateHour(id, activityId, note);
                          }),
                      ],
                    ),
                  ),
                ),
                if (model.average > 0) _average(context, model.average)
              ],
            ),
    );
  }

  Widget _average(context, average) => Row(
        children: [
          Container(
            height: 90,
            // padding: const EdgeInsets.symmetric(vertical:4.0),
            child: Material(
              color: Theme.of(context).primaryColor,
              elevation: 4,
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
              child: Material(
                color: Theme.of(context).primaryColor,
                elevation: 4,
                child: Stack(
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LinearProgressIndicator(
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
            ),
            // ),
          ),
        ],
      );

  Widget _firstTimeEmptyView(BuildContext context) => Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Tell here about what will be shown on this screen.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline5,
        ),
      ));

  Widget _emptyView(BuildContext context) {
    if (this.firstDay) return _firstTimeEmptyView(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // SizedBox(height:MediaQuery.of(context).size.height/6 ,),
        Icon(
          Icons.search_off,
          size: MediaQuery.of(context).size.width / 3,
          color: Theme.of(context).primaryColorDark.withOpacity(0.6),
        ),
        Text(
          "No data found",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline5,
        ),
        // SizedBox(height: 50,),
        // SizedBox(height:MediaQuery.of(context).size.height/12 ,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Opacity(
            opacity: .7,
            child: Text(
              "No data for this date, please choose another date.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 12,
        ),

        ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.date_range),
          label: Text("Choose another date"),
          style: ButtonStyle(),
        )
      ],
    );
  }
}
