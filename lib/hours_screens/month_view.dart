import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MonthView extends StatefulWidget {
  @override
  _MonthViewState createState() => _MonthViewState();
}

class _MonthViewState extends State<MonthView> {
  get width => MediaQuery.of(context).size.width-16;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Your time efficiency this month so far"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              children: [
                for (var i = 0; i < 12; i++)
                  Container(
                    padding: EdgeInsets.all(1),
                    width: width / 5,
                    height: 86,
                    child: Container(
                      color: Colors.blue.withOpacity(Random().nextDouble()),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text("${i+1}",textAlign: TextAlign.center,),
                          ),
                          Text("${Random().nextInt(100)}%",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold)),
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
        ],
      ),
    );
  }
}
