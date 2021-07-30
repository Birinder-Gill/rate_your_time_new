import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rate_your_time_new/hours_screens/widgets/activity_av_card.dart';
import 'package:rate_your_time_new/hours_screens/widgets/app_usage_card.dart';
import 'package:rate_your_time_new/models/hours_model.dart';
import 'package:rate_your_time_new/providers/month_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';

class MonthViewWrapper extends StatelessWidget {
  final bool firstDay;

  MonthViewWrapper(this.firstDay);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value:
      MonthModel(date: Provider
          .of<HoursModel>(context, listen: false)
          .date),
      child: MonthViewScreen(firstDay),
    );
  }
}

class MonthViewScreen extends StatefulWidget {
  final bool firstDay;

  MonthViewScreen(this.firstDay);

  @override
  _MonthViewScreenState createState() => _MonthViewScreenState();
}

class _MonthViewScreenState extends State<MonthViewScreen> {
  get width =>
      MediaQuery
          .of(context)
          .size
          .width - 16;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MonthModel>(
        builder: (BuildContext context, model, Widget child) {
          if (!model.loaded) {
            return simpleLoader();
          }
          if(model.isEmpty) {
            return _emptyView(context);
          }
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Your time efficiency this month so far"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  children: [
                    for (final i in model.av.averages)
                      Container(
                        padding: EdgeInsets.all(1),
                        width: width / 5,
                        height: 86,
                        child: Container(
                          color: Colors.blue.withOpacity(i.worth > 0 ? i.worth /
                              5 : 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text("${i.date.day}",
                                  textAlign: TextAlign.center,),
                              ),
                              Text(i.worth > 0
                                  ? "${(i.worth * 20).toInt()}%"
                                  : ".", textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text("")
                            ],
                          ),
                        ),
                      )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ActivityAverageCard(model.av),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppUSageCard(model.appUsage),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _firstTimeEmptyView(BuildContext context) =>
      Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Tell here about what will be shown on this screen.",
              textAlign: TextAlign.center,
              style: Theme
                  .of(context)
                  .textTheme
                  .headline5,
            ),
          ));

  Widget _emptyView(BuildContext context) {
    if (widget.firstDay) return _firstTimeEmptyView(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // SizedBox(height:MediaQuery.of(context).size.height/6 ,),
        Icon(
          Icons.search_off,
          size: MediaQuery
              .of(context)
              .size
              .width / 3,
          color: Theme
              .of(context)
              .primaryColorDark
              .withOpacity(0.6),
        ),
        Text(
          "No data found",
          textAlign: TextAlign.center,
          style: Theme
              .of(context)
              .textTheme
              .headline5,
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
              style: Theme
                  .of(context)
                  .textTheme
                  .caption,
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery
              .of(context)
              .size
              .height / 12,
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
