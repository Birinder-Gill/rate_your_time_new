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

            ListTile(title: Text('Average of hourly ratings given by yourself this week.')),
            Container(
                height: 300,
                child: GroupedBarChart.withSampleData()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                  children: [
                    Text("Activities you spent most time spent on"),
                    ListTile(
                      horizontalTitleGap: 0,
                      title: Text("Cycling"),
                      subtitle: Text('4 hrs 32 mins'),
                      leading: FaIcon(FontAwesomeIcons.bicycle,color: Colors.blue,),
                    ),
                    ListTile(
                      horizontalTitleGap: 0,
                      title: Text("Movies"),
                      subtitle: Text('4 hrs 32 mins'),
                      leading: FaIcon(FontAwesomeIcons.film,color: Colors.blue,),
                    ),
                    ListTile(
                      horizontalTitleGap: 0,
                      title: Text("Others"),
                      subtitle: Text('4 hrs 32 mins'),
                      leading: FaIcon(FontAwesomeIcons.list,color: Colors.blue,),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                  children: [
                    Text('Most used app this week: '),
                    ListTile(
                      horizontalTitleGap: 0,
                      title: Text("Instagram"),
                      subtitle: Text('12 hrs 56 mins'),
                      trailing: TextButton(onPressed: () {  }, child: Text("Detailed report"),),
                      leading: FaIcon(FontAwesomeIcons.instagram,color: Colors.red,),
                    ),
                  ],
                ),
              ),
            ),
                SizedBox(height: 24,)
          ],
        ),
      ),
    );
  }
}
