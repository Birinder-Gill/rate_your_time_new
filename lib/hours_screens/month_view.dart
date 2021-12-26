import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rate_your_time_new/app_usage_tracker/usage_screen.dart';
import 'package:rate_your_time_new/hours_screens/widgets/activity_av_card.dart';
import 'package:rate_your_time_new/hours_screens/widgets/app_usage_card.dart';
import 'package:rate_your_time_new/hours_screens/widgets/empty_month_view.dart';
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
      body: true? EmptyMonthView(): Consumer<MonthModel>(
        builder: (BuildContext context, model, Widget child) {
          final appModel = Provider.of<AppModel>(context, listen: false);
          final date = appModel.frontLabel(MaterialLocalizations.of(context));
          return ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              _MonthViewStats(
                model,
                date: date,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ActivityAverageCard(
                  model.av,
                  isWeek: false,
                ),
              ),
              if(model.loaded && !model.isEmpty)Padding(
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
                        dateRangeLabel: model.appUsage.label,
                      ),
                    );
                  },
                  date:()=> model.appUsage.label,
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

  final String date;

  _MonthViewStats(this.model, {this.date});

  @override
  Widget build(BuildContext context) {
    if (!model.loaded) return simpleLoader();
    if (model.isEmpty) {
      return EmptyMonthView();
    }
    final primaryDark = Theme.of(context).primaryColorDark;
    final gridHeight = _gridHeight(model.av.averages.length);
    final theme = Theme.of(context);
    return Card(
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Time efficiency for $date.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColorDark))),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: gridHeight,
              child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: model.av.averages.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5, mainAxisExtent: 86),
                  itemBuilder: (c, index) {
                    final i = model.av.averages[index];
                    return Container(
                      padding: EdgeInsets.all(1),
                      child: InkWell(
                        onLongPress: () {
                          final hm =
                              Provider.of<AppModel>(context, listen: false);
                          hm.changeViewToggle(0);
                          hm.refresh(i.date);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                primaryDark.withOpacity(
                                    (i.worth + i.pendingSales) / 5),
                                if (!DateUtils.isSameDay(
                                    i.date, DateTime.now()))
                                  primaryDark.withOpacity(
                                      (i.worth + i.pendingSales) / 5)
                                else
                                  for (double w = 0; w < i.whiteBlocks; w++)
                                    Theme.of(context).primaryColorLight,
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
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text("")
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  double _gridHeight(int length) {
    if (length % 5 == 0) {
      return 86 * (length / 5);
    }
    return (86 * ((length ~/ 5) + 1)).toDouble();
  }
}
