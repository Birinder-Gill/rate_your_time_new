import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rate_your_time_new/models/activity_model.dart';
import 'package:rate_your_time_new/models/average_data_model.dart';
import 'package:rate_your_time_new/models/hours_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:rate_your_time_new/widgets/graphs/grouped_bar_graph.dart';

class ActivityAverageCard extends StatefulWidget {
  final AverageDataModel av;

  final bool isWeek;

  ActivityAverageCard(this.av, {this.isWeek = true});

  @override
  _ActivityAverageCardState createState() => _ActivityAverageCardState();
}

class _ActivityAverageCardState extends State<ActivityAverageCard> {
  bool expanded = false;
  late AppModel hoursModel;

  @override
  Widget build(BuildContext context) {
    if (widget.av.activities.isEmpty) return SizedBox.shrink();
    final theme = Theme.of(context);
    return Card(
      child: Column(
        children: [
          SizedBox(
            height: 16,
          ),
          Text(
            "Activities you spent most time spent on",
            style: theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold, color: theme.primaryColorDark),
          ),
          Divider(),
          for (final a in widget.av.activities)
            if (a.id != 16)
              if (widget.isWeek)
                ExpansionTile(
                  title: Text(
                    "$a",
                    style: theme.textTheme.titleMedium,
                  ),
                  initiallyExpanded: false,
                  children: [
                    SizedBox(
                      height: 200,
                      child: GroupedBarChart(
                        List<SingleDayAverage>.generate(
                            7,
                            (index) => SingleDayAverage(
                                date:null,
                                worth:widget.av.weekDayActivities[a.id]![index + 1]
                                        ?.toDouble() ??
                                    0.0,
                                label: Utils.shortDays[index + 1]!)),
                      ),
                    ),
                  ],
                  subtitle: Text(
                    '${a.timeSpent}${_hrs(a.timeSpent)}',
                    style: theme.textTheme.titleSmall,
                  ),
                  leading: FaIcon(
                    a.icon,
                    color: Theme.of(context).primaryColorDark,
                  ),
                )
              else
                ListTile(
                  title: Text("$a"),
                  trailing: Icon(Icons.arrow_right),
                  subtitle: Text('${a.timeSpent}${_hrs(a.timeSpent)}'),
                  leading: FaIcon(a.icon),
                  onTap: () {
                    showDayActivitiesList(
                        widget.av.weekDayActivities[a.id]!.entries, a);
                  },
                )
            else
              ExpansionTile(
                onExpansionChanged: (e) {
                  expanded = e;
                  // nextTick((){
                  //   setState(() {
                  //
                  //   });
                  // });
                },
                title: Text("$a"),
                subtitle: Text('${a.timeSpent}${_hrs(a.timeSpent)}'),
                trailing: TextButton.icon(
                    onPressed: null,
                    label: Icon(
                        expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                    icon: Text("${widget.av.others.length} activities")),
                leading: FaIcon(a.icon),
                children: [
                  for (final a in widget.av.others)
                    ListTile(
                      horizontalTitleGap: 0,
                      title: Text("$a"),
                      subtitle: Text('${a.timeSpent}${_hrs(a.timeSpent)}'),
                      leading: FaIcon(a.icon),
                    ),
                ],
              ),
          SizedBox(height: 16,)
        ],
      ),
    );
  }

  String _hrs(value) => "${value > 1 ? ' hrs' : ' hr'}";

  void showDayActivitiesList(Iterable<MapEntry<int, int>> entries, Activity a) {
    final label = hoursModel.frontLabel(MaterialLocalizations.of(context));
    pushTo(
        context,
        Scaffold(
          appBar: AppBar(
            title: Text("Time spent on $a in $label"),
          ),
          body:  SizedBox(
                  height: 300,
                  child: GroupedBarChart(List<SingleDayAverage>.generate(
                      entries.length,
                      (index) => SingleDayAverage(
                          worth: entries.elementAt(index).value.toDouble(),
                          label: entries.elementAt(index).key.toString()))),
                )
        ),
        dialog: true);
  }
}
