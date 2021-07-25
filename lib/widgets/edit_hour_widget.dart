
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rate_your_time_new/data/activities.dart';
import 'package:rate_your_time_new/models/hours_model.dart';
import 'package:rate_your_time_new/providers/day_model.dart';

class EditHourWidget extends StatefulWidget {
  final Hour hour;

  EditHourWidget(this.hour, {this.updateHour});

  @override
  _EditHourWidgetState createState() => _EditHourWidgetState();

  final void Function(int id, int activityId, String text) updateHour;
}

class _EditHourWidgetState extends State<EditHourWidget> {
  int activityId = 0;
  final commentC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attach an activity"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            children: List<Widget>.from(activities.values.map((e) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  setState(() {
                    activityId = e.id;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: activityId == e.id ? Border.all() : null),
                  width: 100,
                  child: Column(
                    children: [
                      e.icon,
                      Text(
                        e.name,
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: commentC,
              maxLines:2,
              decoration: InputDecoration(labelText: "Add a comment"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                       widget.updateHour(widget.hour.id, activityId, commentC.text);
                        Navigator.pop(context);
                      },
                      child: Text("Submit"),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
