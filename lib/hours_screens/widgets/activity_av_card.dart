import 'package:flutter/material.dart';
import 'package:rate_your_time_new/models/average_data_model.dart';

class ActivityAverageCard extends StatefulWidget {
  final AverageDataModel av;

  ActivityAverageCard(this.av);

  @override
  _ActivityAverageCardState createState() => _ActivityAverageCardState();
}

class _ActivityAverageCardState extends State<ActivityAverageCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text("Activities you spent most time spent on"),
          for(final a in widget.av.activities)
          // if(a.key>0)
            ListTile(
              horizontalTitleGap: 0,
              title: Text("$a"),
              subtitle: Text('${a.timeSpent} hrs'),
              leading: a.icon,
            ),
          for(final a in widget.av.others)
            ListTile(
              horizontalTitleGap: 0,
              title: Text("$a"),
              subtitle: Text('${a.timeSpent} hrs'),
              leading: a.icon,
            ),
        ],
      ),
    );
  }
}
