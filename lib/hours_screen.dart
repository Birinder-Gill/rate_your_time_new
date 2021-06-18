import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:rate_your_time_new/models/hours_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:rate_your_time_new/widgets/hour_widget.dart';

class HoursScreen extends StatelessWidget {
  final List<Hour> hours;

  final double average;

  final bool firstDay;

  HoursScreen(this.hours, this.average, this.firstDay);

  get hoursLength => hours?.length ?? 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            // physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // Text("Today's performance chart"),
                // OutlinedButton(onPressed: (){}, child: Text('Show today\'s app usage report')),
                   if(hoursLength == 0) _emptyView(context),
                    for(final i in hours) HourWidget(i),

              ],
            ),
          ),
        ),
        if (average > 0) _average(context)
      ],
    );
  }

  Widget _average(context) =>true? Row(
    children: [
      Container(
        height: 90,
        // padding: const EdgeInsets.symmetric(vertical:4.0),
        child: Material(
          color: Theme.of(context).primaryColor,
          elevation: 4,
          child: SizedBox(
            width: 60,
            child: Center(
              child: Text(
                'Average',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyText2.color),
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
          // padding: const EdgeInsets.symmetric(vertical:4.0),
          decoration: const BoxDecoration(
              border:const Border(
                left: const BorderSide(),
              )),
          child: Material(
            color: Theme.of(context).primaryColor,
            elevation: 4,
            child: Stack(
              children: [
                Container(
                    padding:const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        LinearProgressIndicator(
                            minHeight: 16,
                            backgroundColor: Colors.white,
                            value: (average),
                            valueColor:AlwaysStoppedAnimation(Theme.of(context).accentColor)
                          // style: ProgressStyle(
                          //   borderRadius: BorderRadius.zero,
                          //   depth: 2,
                          //   accent: true?_color[hour.worth]:Theme.of(context).accentColor,
                          //   variant:true?_color[hour.worth]: Theme.of(context).accentColor,
                          // ),
                        ),
                      ],
                    )),
                // Positioned(
                //   top: 0,
                //   right: 0,
                //   child: Random.secure().nextInt(100)%2==0?Padding(
                //     padding: const EdgeInsets.only(right:18.0,top: 4),
                //     child: Icon(Icons.directions_bike_sharp,size: 16,color: _color[hour.worth],),
                //   ):TextButton.icon(
                //     onPressed: () {},
                //     label: Text(
                //       "Activity",
                //       style: TextStyle(fontSize: 12),
                //     ),
                //     style: ButtonStyle(
                //         minimumSize: MaterialStateProperty.resolveWith((states) => Size(12, 24)),
                //         tapTargetSize: MaterialTapTargetSize.shrinkWrap
                //     ),
                //     icon: Icon(
                //       Icons.add,
                //       size: 12,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
        // ),
      ),
    ],
  ): Material(
        elevation: 4,
        color: Theme.of(context).primaryColorDark,
        child: Row(
          children: [
            const Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text('Average'),
            ),
            Expanded(
              child: LinearProgressIndicator(
                minHeight: 8,
                value: average,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).accentColor),
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(
              height: 70,
            )
          ],
        ),
      );

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
    if (this.firstDay) return _firstTimeEmptyView(context);
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
              )),
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

