import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelfAnalysisView extends StatefulWidget {
  @override
  _SelfAnalysisViewState createState() => _SelfAnalysisViewState();
}

class _SelfAnalysisViewState extends State<SelfAnalysisView> {
  final heading = "Answer the following questions to help you set your priorities and adjust your management of your time accordingly.";
  final ques= [
        'What do you think are your most important tasks and responsibilities?',
        'List the things you should do every day. Circle the things you really do every day',
        'What things contribute the most to your success?',
        'What distracts you? What helps you concentrate?',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Self analysis"),
      ),
      body:Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(heading,style: Theme.of(context).textTheme.headline6,textAlign: TextAlign.center,),
          ),
          Divider(),
          for(final q in ques)
            ListTile(
              horizontalTitleGap: 0,
              leading: Icon(Icons.circle,color: Colors.black,size: 12,),
              title: Text(q),
              subtitle: Divider(),
            )
          ,
          Text(
              "Use this data to review your week. What worked? Where did you focus? Where did you get distracted? What did you learn that will help make next week more productive"),
        ],
      ),
    );
  }
}
