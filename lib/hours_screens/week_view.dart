import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:rate_your_time_new/app_usage_tracker/usage_screen.dart';
import 'package:rate_your_time_new/hours_screens/widgets/app_usage_card.dart';
import 'package:rate_your_time_new/hours_screens/widgets/empty_view.dart';
import 'package:rate_your_time_new/hours_screens/widgets/empty_week_view.dart';
import 'package:rate_your_time_new/models/hours_model.dart';
import 'package:rate_your_time_new/providers/week_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:rate_your_time_new/widgets/graphs/grouped_bar_graph.dart';
import 'package:rate_your_time_new/widgets/ratings_widget.dart';
import 'package:rate_your_time_new/widgets/self_analysis.dart';

import 'widgets/activity_av_card.dart';

class WeekViewWrapper extends StatelessWidget {
  // final bool firstDay;

  WeekViewWrapper(/*this.firstDay*/);

  @override
  Widget build(BuildContext context) {
    return Selector<WeekModel, WeekModel>(
      selector: (c, model) => model,
      shouldRebuild: (p, c) => !DateUtils.isSameDay(p.date, c.date),
      builder: (_, model, __) {
        model.changeDate(Provider.of<AppModel>(context, listen: false).date);
        return WeekViewScreen();
      },
    );
  }
}

class WeekViewScreen extends StatefulWidget {
  // final bool firstDay;

  WeekViewScreen(/*this.firstDay*/);

  @override
  _WeekViewScreenState createState() => _WeekViewScreenState();
}

class _WeekViewScreenState extends State<WeekViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<WeekModel>(
        builder: (BuildContext context, model, Widget child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                _WeekViewStats(model),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppUsageCard(model.appUsage, model.accessGranted, onRetry:() {
                    model.refresh(hours: false);
                  },openDetails: (list)async{
                    pushTo(context, AppsUsageScreen(
                      from: await TimeUtils.getWeekStart(model.date),
                      to: await TimeUtils.getWeekEnd(model.date),
                      distinctApps: list,
                    ));
                  },),
                ),
                SizedBox(
                  height: 24,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class _WeekViewStats extends StatelessWidget {
  final WeekModel model;

  // final bool firstDay;

  _WeekViewStats(this.model);

  @override
  Widget build(BuildContext context) {
    if (!model.loaded) return simpleLoader();
    if (model.isEmpty) {
      return EmptyWeekView();
    }
    return Column(
      children: [
        ListTile(
            title:
                Text('Average of hourly ratings given by yourself this week.')),
        Container(
            height: 300,
            child: GroupedBarChart(model.av.averages,onBarSelected: (i) {
              final hm = Provider.of<AppModel>(context, listen: false);
              hm.changeViewToggle(0);
              hm.refresh(model.av.averages[i].date);
            })),
        // Text("Looks like monday was the most productive day of your week."),
        // Text("See what times were you most productive and doing what."),
        Center(
            child: RatingStars(
          size: 50,
              rating: model.rating,
        )),
        OutlinedButton.icon(
            onPressed: () {
              showCupertinoModalPopup(
                  context: context, builder: (c) => SelfAnalysisView());
            },
            icon: Icon(Icons.list_rounded),
            label: Text("Self analysis")),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ActivityAverageCard(model.av),
        ),
        // Text(
        //     "You are only concentrating on work, you need to balance between every activity")
      ],
    );
  }
}
