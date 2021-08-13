import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rate_your_time_new/hours_screens/widgets/app_usage_card.dart';
import 'package:rate_your_time_new/hours_screens/widgets/empty_view.dart';
import 'package:rate_your_time_new/models/hours_model.dart';
import 'package:rate_your_time_new/providers/week_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:rate_your_time_new/widgets/graphs/grouped_bar_graph.dart';

import 'widgets/activity_av_card.dart';

class WeekViewWrapper extends StatelessWidget {
  final bool firstDay;

  WeekViewWrapper(this.firstDay);

  @override
  Widget build(BuildContext context) {
    return Selector<WeekModel,WeekModel>(
      selector: (c,model)=>model,
      shouldRebuild: (p,c)=>!DateUtils.isSameDay(p.date,c.date),
      builder:(_,model,__){
        model.changeDate(Provider.of<HoursModel>(context, listen: false).date);
        return WeekViewScreen(firstDay);
      },
    );
  }
}

class WeekViewScreen extends StatefulWidget {
  final bool firstDay;

  WeekViewScreen(this.firstDay);

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
                _WeekViewStats(model, widget.firstDay),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppUsageCard(model.appUsage,model.accessGranted,(){
                    model.refresh(hours: false);
                  }),
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

  final bool firstDay;

  _WeekViewStats(this.model, this.firstDay);

  @override
  Widget build(BuildContext context) {
    if (!model.loaded) return simpleLoader();
    if (model.isEmpty) {
      return EmptyView(
        firstDay: firstDay,
      );
    }
    return Column(
      children: [
        ListTile(
            title:
                Text('Average of hourly ratings given by yourself this week.')),
        Container(
            height: 300,
            child: GroupedBarChart.withHoursData(model.av.averages,(i){
              final hm= Provider.of<HoursModel>(context,listen: false);
              hm.changeViewToggle(0);
              hm.refresh(model.av.averages[i].date);
            })),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ActivityAverageCard(model.av),
        ),
      ],
    );
  }
}
