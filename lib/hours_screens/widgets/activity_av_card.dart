import 'package:flutter/material.dart';
import 'package:rate_your_time_new/models/average_data_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';

class ActivityAverageCard extends StatefulWidget {
  final AverageDataModel av;

  ActivityAverageCard(this.av);

  @override
  _ActivityAverageCardState createState() => _ActivityAverageCardState();
}

class _ActivityAverageCardState extends State<ActivityAverageCard> {
  bool expanded=false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text("Activities you spent most time spent on"),
          for(final a in widget.av.activities)
          if(a.id!=16)
            ExpansionTile(
              // horizontalTitleGap: 0,
              title: Text("$a"),
              initiallyExpanded: true,
              children: [
                for(var i in [widget.av.dayActivities[a.id]].single.entries)
                ListTile(
                  title: Text(Utils.shortDays[i.key]),
                  trailing: Text("${i.value} hrs"),
                  subtitle: Divider(),
                )
              ],
              subtitle: Text('${a.timeSpent} hrs'),
              leading: a.icon,
            )else
              ExpansionTile(
                onExpansionChanged: (e){
                  expanded=e;
                  // nextTick((){
                  //   setState(() {
                  //
                  //   });
                  // });
                },
                title: Text("$a"),
                subtitle: Text('${a.timeSpent} hrs'),
                trailing: TextButton.icon(onPressed: null, label: Icon(expanded?Icons.arrow_drop_up:Icons.arrow_drop_down), icon: Text("${widget.av.others.length} activities")),
                leading: a.icon,
                children: [
                for(final a in widget.av.others)
                  ListTile(
                    horizontalTitleGap: 0,
                    title: Text("$a"),
                    subtitle: Text('${a.timeSpent} hrs'),
                    leading: a.icon,
                  ),
              ],)

        ],
      ),
    );
  }
}
