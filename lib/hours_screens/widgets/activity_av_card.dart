import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  AppModel hoursModel;

  @override
  Widget build(BuildContext context) {
    if (hoursModel == null) hoursModel = Provider.of<AppModel>(context);
    if(widget.av.activities.isEmpty)
      return SizedBox.shrink();
    return Card(
      child: Column(
        children: [
          Text("Activities you spent most time spent on"),
          for (final a in widget.av.activities)
            if (a.id != 16)
              if (widget.isWeek)
                ExpansionTile(
                  // horizontalTitleGap: 0,
                  title: Text("$a"),
                  initiallyExpanded: false,
                  children: [
                    SizedBox(
                      height: 200,
                      child: GroupedBarChart.withHoursData(
                          List<SingleDayAverage>.generate(
                              7,
                              (index) => SingleDayAverage(
                                  null,
                                  widget.av.weekDayActivities[a.id][index + 1]
                                          ?.toDouble() ??
                                      0.0,
                                  label: Utils.shortDays[index + 1])),
                          (e) {}),
                    ),
                    // for (var i in widget.av.weekDayActivities[a.id].entries)
                    //   ListTile(
                    //     title: Text(Utils.shortDays[i.key]),
                    //     trailing: Text("${i.value}${_hrs(i.value)}"),
                    //     subtitle: Divider(),
                    //   )
                  ],
                  subtitle: Text('${a.timeSpent}${_hrs(a.timeSpent)}'),
                  leading: a.icon,
                )
              else
                ListTile(
                  title: Text("$a"),
                  trailing: Icon(Icons.arrow_right),
                  subtitle: Text('${a.timeSpent}${_hrs(a.timeSpent)}'),
                  leading: a.icon,
                  onTap: () {
                    showDayActivitiesList(
                        widget.av.weekDayActivities[a.id].entries, a);
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
                leading: a.icon,
                children: [
                  for (final a in widget.av.others)
                    ListTile(
                      horizontalTitleGap: 0,
                      title: Text("$a"),
                      subtitle: Text('${a.timeSpent}${_hrs(a.timeSpent)}'),
                      leading: a.icon,
                    ),
                ],
              )
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
          body: true? SizedBox(
            height: 300,
            child: GroupedBarChart.withHoursData(List<SingleDayAverage>.generate(
                entries.length, (index) => SingleDayAverage(null, entries.elementAt(index).value.toDouble(),label: entries.elementAt(index).key.toString())), (e){}),
          ):ListView(children: [
            for (var i in entries)
              ListTile(
                title: Text(i.key.toString() + "-$label"),
                trailing: Text("${i.value} ${i.value > 1 ? 'hrs' : 'hr'}"),
                subtitle: Divider(),
              )
          ]),
        ),
        dialog: true);
  }
}
