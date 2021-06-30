import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rate_your_time_new/widgets/graphs/grouped_bar_graph.dart';

class WeekViewScreen extends StatefulWidget {
  @override
  _WeekViewScreenState createState() => _WeekViewScreenState();
}

class _WeekViewScreenState extends State<WeekViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              horizontalTitleGap: 0,
              title: Text("Activity you spent Most time spent on"),
              subtitle: Text('4 hrs 32 mins'),
              leading: FaIcon(FontAwesomeIcons.bicycle,color: Colors.blue,),
            ),
            ListTile(
              horizontalTitleGap: 0,
              title: Text("Most used app this week: Instagram"),
              subtitle: Text('12 hrs 56 mins'),
              leading: FaIcon(FontAwesomeIcons.instagram,color: Colors.red,),
            ),
            ListTile(title: Text('Average of hourly ratings given by yourself this week.')),
            Container(
                height: 300,
                child: GroupedBarChart.withSampleData())

          ],
        ),
      ),
    );
  }
}
