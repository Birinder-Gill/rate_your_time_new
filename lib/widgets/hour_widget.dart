import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rate_your_time_new/data/activities.dart';
import 'package:rate_your_time_new/models/hours_model.dart';
import 'package:rate_your_time_new/providers/day_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:rate_your_time_new/widgets/edit_hour_widget.dart';

class HourWidget extends StatelessWidget {
  final Hour hour;
  final void Function(int id, int activityId, String text) updateHour;

  static const _color = {
    0: Colors.grey,
    1: Colors.red,
    2: Color(0xffbf360c),
    3: Colors.orange,
    4: Colors.lightGreen,
    5: Colors.green
  };

  static const _emojis = {
    1: Icons.face_outlined,
    2: Icons.face_outlined,
    3: Icons.face_outlined,
    4: Icons.tag_faces_sharp,
    5: Icons.emoji_emotions_rounded
  };

  ThemeData theme;


  HourWidget(this.hour, {this.updateHour});

  get elevation => 1.0;

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    final primaryDark = theme.primaryColorDark;
    final double emojiSize = 14;
    return Row(
      children: [
        Container(
          height: 100,
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: SizedBox(
            width: 60,
            child: Center(
              child: Transform.rotate(
                angle: -.5,
                child: Text(
                  '${TimeUtils.parseTimeRange(hour.time)}',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyText2.color
                          .withOpacity(hour.worth > 0 ? .9 : .5)),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 100,
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            decoration: const BoxDecoration(
                border: const Border(
              left: const BorderSide(),
            )),
            child: GestureDetector(
              onTap: () {
                dialog(context, EditHourWidget(hour, updateHour: updateHour));
              },
              child: Stack(
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(child: _worthWidget(hour)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal:8.0),
                                  child: _activityIcon(context, hour),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Text(
                              " ${hour.note ?? ''}",
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(color: primaryDark, fontSize: 12),
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _emptyWorthCard(ThemeData theme) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon(Icons.outlet),
          Icon(
            Icons.close,
            color: theme.primaryColorDark,
          ),
          Text(
            'Value not entered',
            style: TextStyle(color: theme.primaryColorDark),
          ),
          Icon(Icons.close, color: theme.primaryColorDark),
        ],
      );

  Widget y(double i) => SizedBox(
        height: i,
      );

  Widget _worthWidget(Hour hour) => hour.worth == 0
      ? _emptyWorthCard(theme)
      : LinearProgressIndicator(
          minHeight: 32,
          backgroundColor: theme.primaryColorLight,
          value: (hour.worth / 5),
          valueColor: AlwaysStoppedAnimation(theme.primaryColorDark),);

  Widget _activityIcon(BuildContext context, Hour hour) =>
        hour.activity != 0
            ? FaIcon(activities[hour.activity].icon)
            : Icon(
                Icons.add,
                size: 16,
              );

}
