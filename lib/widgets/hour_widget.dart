import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rate_your_time_new/models/hours_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';

class HourWidget extends StatelessWidget {
  final Hour hour;

  static const _color={
    0:Colors.grey,
    1:Colors.red,
    2:Color(0xffbf360c),
    3:Colors.orange,
    4:Colors.lightGreen,
    5:Colors.green
  };

  static const _emojis={
    1:Icons.face_outlined,
    2:Icons.face_outlined,
    3:Icons.face_outlined,
    4:Icons.tag_faces_sharp,
    5:Icons.emoji_emotions_rounded
  };

  const HourWidget(this.hour);

  get elevation => 1.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double emojiSize=14;
    return  Row(
      children: [
        Container(
          height: 90,
          padding: const EdgeInsets.symmetric(vertical:4.0),
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
            padding: const EdgeInsets.symmetric(vertical:4.0),
            decoration: const BoxDecoration(
                border:const Border(
                  left: const BorderSide(),
                )),
            child: Material(
              elevation: elevation,
              child: Stack(
                children: [
                  Container(
                      padding:const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          hour.worth==0?_emptyWorthCard(theme):
                          LinearProgressIndicator(
                              minHeight: 16,
                              backgroundColor: Colors.white,
                              value: (hour.worth / 5),
                              valueColor:AlwaysStoppedAnimation(Theme.of(context).accentColor)
                          ),
                          Text(Random.secure().nextInt(100)%2==0?"":"Lorem ipsum Birtinder singh gill the king of nthe world",overflow:TextOverflow.ellipsis,style: Theme.of(context).textTheme.caption.copyWith(color: Colors.grey,fontSize: 12),)
                        ],
                      )),
                  Positioned(
                    top: 0,
                    right: 0,
                    child:Padding(
                      padding: const EdgeInsets.only(right:18.0,top: 4),
                      child:  Random.secure().nextInt(100)%2==0?Icon(Icons.directions_bike_sharp,size: 16,color: _color[hour.worth],): Icon(Icons.add,size: 16,),
                    )
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

// Color getColor(Hour hour) =>hour.worth==1?Colors.red:hour.worth==2?Colors.deepOrange:hour.worth==3?Colors.orange:hour.worth==4?Colors.yellow:Colors.green;
}
