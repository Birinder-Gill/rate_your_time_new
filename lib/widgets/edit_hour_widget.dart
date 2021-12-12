import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rate_your_time_new/data/activities.dart';
import 'package:rate_your_time_new/models/hours_model.dart';
import 'package:rate_your_time_new/providers/day_model.dart';

class EditHourWidget extends StatefulWidget {
  final Hour hour;

  EditHourWidget(this.hour, {this.updateHour});

  @override
  _EditHourWidgetState createState() => _EditHourWidgetState();

  final void Function(int id, int activityId, String text, int rating)
      updateHour;
}

class _EditHourWidgetState extends State<EditHourWidget> {
  int activityId = 0;
  final commentC = TextEditingController();

  int rating;

  @override
  void initState() {
    rating = widget.hour.worth;
    activityId = widget.hour.activity;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attach an activity"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              for (final i in [1, 2, 3, 4, 5])
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _ratingBtn(i),
                  ),
                )
            ],
          ),
          Wrap(
            children: List<Widget>.from(activities.values.map((e) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    elevation: activityId == e.id ? 4 : 0,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          activityId = e.id;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: activityId == e.id ? Border.all() : null,
                        ),
                        width: 100,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 4,
                            ),
                            FaIcon(e.icon),
                            Text(
                              e.name,
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: commentC,
              maxLines: 2,
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
                        widget.updateHour(
                            widget.hour.id, activityId, commentC.text, rating);
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

  Widget _ratingBtn(int i) => OutlinedButton(
        onPressed: () {
          setState(() {
            rating = i;
          });
        },
        child: Text("$i"),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) =>
              i <= rating
                  ? Theme.of(context).primaryColorDark
                  : Colors.transparent),
          foregroundColor: MaterialStateProperty.resolveWith((states) =>
              i <= rating
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface),
        ),
      );
}
