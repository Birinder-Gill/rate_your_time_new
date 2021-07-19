import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rate_your_time_new/data/activities.dart';
import 'package:rate_your_time_new/models/hours_model.dart';
import 'package:rate_your_time_new/providers/week_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:rate_your_time_new/widgets/graphs/grouped_bar_graph.dart';

import 'widgets/activity_av_card.dart';

class WeekViewWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value:
          WeekModel(date: Provider.of<HoursModel>(context, listen: false).date),
      child: WeekViewScreen(),
    );
  }
}

class WeekViewScreen extends StatefulWidget {
  @override
  _WeekViewScreenState createState() => _WeekViewScreenState();
}

class _WeekViewScreenState extends State<WeekViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<WeekModel>(
        builder: (BuildContext context, model, Widget child) =>
            SingleChildScrollView(
          child: !model.loaded
              ? simpleLoader()
                  : Column(
                      children: [
                        ListTile(
                            title: Text(
                                'Average of hourly ratings given by yourself this week.')),
                        Container(
                            height: 300,
                            child: GroupedBarChart.withHoursData(
                                model.av.averages)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ActivityAverageCard(model.av),
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
                                  trailing: TextButton(
                                    onPressed: () {},
                                    child: Text("Detailed report"),
                                  ),
                                  leading: FaIcon(
                                    FontAwesomeIcons.instagram,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 24,
                        )
                      ],
                    ),
        ),
      ),
    );
  }
}
