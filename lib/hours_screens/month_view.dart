import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rate_your_time_new/hours_screens/widgets/activity_av_card.dart';
import 'package:rate_your_time_new/hours_screens/widgets/app_usage_card.dart';
import 'package:rate_your_time_new/hours_screens/widgets/empty_view.dart';
import 'package:rate_your_time_new/models/hours_model.dart';
import 'package:rate_your_time_new/providers/month_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';

class MonthViewWrapper extends StatelessWidget {
  final bool firstDay;

  MonthViewWrapper(this.firstDay);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Provider.of<MonthModel>(context,listen: false)
        ..changeDate(Provider.of<HoursModel>(context, listen: false).date),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MonthModel>(
        builder: (BuildContext context, model, Widget child) {
          return ListView(
            children: [
              _MonthViewStats(model, widget.firstDay),
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
}

class _MonthViewStats extends StatelessWidget {
  final MonthModel model;

  final bool firstDay;

  _MonthViewStats(this.model, this.firstDay);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 16;
    if (!model.loaded) return simpleLoader();
    if (model.isEmpty) {
      return EmptyView(
        firstDay: firstDay,
      );
    }
    return Column(
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
                    color:
                        Colors.blue.withOpacity(i.worth > 0 ? i.worth / 5 : 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            "${i.date.day}",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Text(i.worth > 0 ? "${(i.worth * 20).toInt()}%" : ".",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold)),
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
      ],
    );
  }
}
