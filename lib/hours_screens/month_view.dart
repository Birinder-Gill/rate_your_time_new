import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rate_your_time_new/hours_screens/widgets/activity_av_card.dart';
import 'package:rate_your_time_new/models/hours_model.dart';
import 'package:rate_your_time_new/providers/month_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';

class MonthViewWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value:
      MonthModel(date: Provider.of<HoursModel>(context, listen: false).date),
      child: MonthViewScreen(),
    );
  }
}

class MonthViewScreen extends StatefulWidget {
  @override
  _MonthViewScreenState createState() => _MonthViewScreenState();
}

class _MonthViewScreenState extends State<MonthViewScreen> {
  get width => MediaQuery.of(context).size.width-16;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MonthModel>(
        builder: (BuildContext context, model, Widget child)=>!model.loaded
            ? simpleLoader()
            : ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Your time efficiency this month so far"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                children: [
                  for (final i in model.av.averages)
                    Container(
                      padding: EdgeInsets.all(1),
                      width: width / 5,
                      height: 86,
                      child: Container(
                        color: Colors.blue.withOpacity(i.worth/5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text("${i.date.day}",textAlign: TextAlign.center,),
                            ),
                            Text("${(i.worth*20).toInt()}%",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("")
                          ],
                        ),
                      ),
                    )
                ],
              ),
            ),
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
                      trailing: TextButton(onPressed: () {  }, child: Text("Detailed report"),),
                      leading: FaIcon(FontAwesomeIcons.instagram,color: Colors.red,),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
