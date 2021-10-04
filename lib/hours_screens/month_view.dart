import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rate_your_time_new/app_usage_tracker/usage_screen.dart';
import 'package:rate_your_time_new/hours_screens/widgets/activity_av_card.dart';
import 'package:rate_your_time_new/hours_screens/widgets/app_usage_card.dart';
import 'package:rate_your_time_new/hours_screens/widgets/empty_month_view.dart';
import 'package:rate_your_time_new/hours_screens/widgets/empty_view.dart';
import 'package:rate_your_time_new/models/hours_model.dart';
import 'package:rate_your_time_new/providers/month_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';

class MonthViewWrapper extends StatelessWidget {
  // final bool firstDay;

  MonthViewWrapper(/*this.firstDay*/);

  @override
  Widget build(BuildContext context) {
    return Selector<MonthModel, MonthModel>(
      selector: (c, model) => model,
      shouldRebuild: (p, c) => !DateUtils.isSameDay(p.date, c.date),
      builder: (_, model, __) {
        model.changeDate(Provider.of<AppModel>(context, listen: false).date);
        return MonthViewScreen();
      },
    );
  }
}

class MonthViewScreen extends StatefulWidget {
  // final bool firstDay;

  MonthViewScreen(/*this.firstDay*/);

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
              _MonthViewStats(model),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppUsageCard(
                  model.appUsage,
                  model.accessGranted,
                  onRetry: () {
                    model.refresh(hours: false);
                  },
                  openDetails: (list) async {
                    pushTo(
                        context,
                        AppsUsageScreen(
                          from: await TimeUtils.getMonthStart(model.date),
                          to: await TimeUtils.getMonthEnd(model.date),
                          distinctApps: list,
                        ));
                  },
                ),
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

  // final bool firstDay;

  _MonthViewStats(this.model);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 16;
    if (!model.loaded) return simpleLoader();
    if (model.isEmpty) {
      return EmptyMonthView();
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
                  child: InkWell(
                    onLongPress: () {
                      // showDialog(
                      //     context: context,
                      //     builder: (c) => AlertDialog(
                      //           content: Text('$i'),
                      //         ));
                      final hm =
                          Provider.of<AppModel>(context, listen: false);
                      hm.changeViewToggle(0);
                      hm.refresh(i.date);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                            Colors.blue
                                .withOpacity((i.worth + i.pendingSales) / 5),
                            if(!DateUtils.isSameDay(i.date, DateTime.now()))
                            Colors.blue
                                .withOpacity((i.worth + i.pendingSales) / 5)
                                else
                              for(double w=0;w< i.whiteBlocks;w++)
                                Colors.white,
                          ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter)),
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
                          Text(
                              (i.worth + i.pendingSales) > 0
                                  ? "${((i.worth + i.pendingSales) * 20).toInt()}%"
                                  : ".",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("")
                        ],
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ActivityAverageCard(
            model.av,
            isWeek: false,
          ),
        ),
      ],
    );
  }
}
