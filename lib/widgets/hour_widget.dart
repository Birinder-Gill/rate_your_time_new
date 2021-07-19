import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rate_your_time_new/data/activities.dart';
import 'package:rate_your_time_new/models/hours_model.dart';
import 'package:rate_your_time_new/providers/day_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:rate_your_time_new/widgets/edit_hour_widget.dart';

class HourWidget extends StatelessWidget {
  final Hour hour;

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

  HourWidget(this.hour);

  get elevation => 1.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double emojiSize = 14;
    return Row(
      children: [
        Container(
          height: 90,
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Material(
            elevation: elevation,
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
        ),
        Expanded(
          // child: Dismissible(
          //    background: Container(color: Colors.red,),
          //   secondaryBackground: Container(color: Colors.green,),

          // key: ValueKey(hour.id),
          child: Container(
            height: 90,
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            decoration: const BoxDecoration(
                border: const Border(
              left: const BorderSide(),
            )),
            child: Material(
              elevation: elevation,
              child: Stack(
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          hour.worth == 0
                              ? _emptyWorthCard(theme)
                              : LinearProgressIndicator(
                                  minHeight: 16,
                                  backgroundColor: Colors.white,
                                  value: (hour.worth / 5),
                                  valueColor: AlwaysStoppedAnimation(
                                      Theme.of(context).accentColor)),
                          Text(
                            " ${hour.note ?? ''}",
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(color: Colors.grey, fontSize: 12),
                          )
                        ],
                      )),
                  if (hour.worth > 0)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: hour.activity != 0
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(right: 18.0, top: 4),
                              child: activities[hour.activity].icon)
                          : InkWell(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 18.0, top: 4),
                                child: Icon(
                                  Icons.add,
                                  size: 16,
                                ),
                              ),
                              onTap: () {
                                dialog(
                                    context,
                                    ChangeNotifierProvider.value(
                                        value: Provider.of<DayModel>(context,
                                            listen: false),
                                        child: EditHourWidget(hour)));
                              },
                            ),
                    ),
                ],
              ),
            ),
          ),
          // ),
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
}
