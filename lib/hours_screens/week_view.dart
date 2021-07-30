import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rate_your_time_new/data/activities.dart';
import 'package:rate_your_time_new/hours_screens/widgets/app_usage_card.dart';
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
    return ChangeNotifierProvider.value(

      value:
          WeekModel(date: Provider.of<HoursModel>(context, listen: false).date),
      child: WeekViewScreen(firstDay),
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
          if(model.isEmpty) {
            return _emptyView(context);
          }
          return SingleChildScrollView(
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
                          child: AppUSageCard(model.appUsage),
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
  Widget _firstTimeEmptyView(BuildContext context) => Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Tell here about what will be shown on this screen.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline5,
        ),
      ));
  Widget _emptyView(BuildContext context) {
    if (widget.firstDay) return _firstTimeEmptyView(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // SizedBox(height:MediaQuery.of(context).size.height/6 ,),
        Icon(
          Icons.search_off,
          size: MediaQuery.of(context).size.width / 3,
          color: Theme.of(context).primaryColorDark.withOpacity(0.6),
        ),
        Text(
          "No data found",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline5,
        ),
        // SizedBox(height: 50,),
        // SizedBox(height:MediaQuery.of(context).size.height/12 ,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Opacity(
            opacity: .7,
            child: Text(
              "No data for this date, please choose another date.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 12,
        ),

        ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.date_range),
          label: Text("Choose another date"),
          style: ButtonStyle(),
        )
      ],
    );
  }

}
