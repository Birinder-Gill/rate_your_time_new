import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:rate_your_time_new/models/hours_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';

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
          child: hoursLength == 0
              ? _emptyView(context)
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: hoursLength,
                  itemBuilder: (BuildContext context, int i) =>
                      HourWidget(hours[i]),
                ),
        ),
        if (average > 0) _average(context)
      ],
    );
  }

  Widget _average(context) => Material(
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double emojiSize=14;
    return  Material(
      elevation: hour.worth>0?4:0,
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(
              '  ${TimeUtils.parseTimeHours(hour.time)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyText2.color
                      .withOpacity(hour.worth > 0 ? .9 : .5)),
            ),
          ),
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        left: BorderSide(color: _color[hour.worth]),
                    )),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0),
                child: Column(
                  children: [
                    if(hour.worth>0)Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                       Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Icon(
                            _emojis[hour.worth],
                            size: emojiSize,
                            color: _color[hour.worth],
                          ),
                        ),
                        Expanded(child:Container()),
                        TextButton.icon(
                          onPressed: () {},
                          label: Text(
                            "Activity",
                            style: TextStyle(fontSize: 12),
                          ),
                          style: ButtonStyle(
                              minimumSize: MaterialStateProperty.resolveWith((states) => Size(12, 24)),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap
                          ),
                          icon: Icon(
                            Icons.add,
                            size: 12,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          label: Text(
                            "Note",
                            style: TextStyle(fontSize: 12),
                          ),
                          style: ButtonStyle(
                              minimumSize: MaterialStateProperty.resolveWith((states) => Size(12, 24)),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap
                          ),
                          icon: Icon(
                            Icons.add,
                            size: 12,
                          ),
                        )
                      ],
                    ),
                    hour.worth==0?_emptyWorthCard(theme):LinearProgressIndicator(
                      minHeight: 16,
                      backgroundColor: Colors.white,
                      value: (hour.worth / 5),
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
          ),
        ],
      ),
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

///OLD HOUR WIDGET
/**Card(
    color: hour.worth > 0 ? theme.cardColor : theme.scaffoldBackgroundColor,
    borderOnForeground: hour.worth == 0,
    elevation: hour.worth > 0 ? 1 : 0,
    child: Container(
    decoration: BoxDecoration(
    border: hour.worth > 0
    ? null
    : Border.all(color: theme.primaryColorDark),
    borderRadius: BorderRadius.all(Radius.circular(4))),
    child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
    const SizedBox(
    height: 4,
    ),
    SizedBox(
    width: 50,
    child: Text(
    '${TimeUtils.parseTimeHours(hour.time)}',
    style: TextStyle(
    color: theme.textTheme.bodyText2.color
    .withOpacity(hour.worth > 0 ? 1 : .5)),
    )),
    const SizedBox(
    height: 42,
    ),
    Expanded(
    child: (hour.worth > 0)
    ? LinearProgressIndicator(
    minHeight: 4,
    valueColor: AlwaysStoppedAnimation<Color>(
    Theme.of(context).accentColor),
    backgroundColor: Theme.of(context).primaryColorDark,
    value: (hour.worth / 5),
    )
    : _emptyWorthCard(theme),
    ),
    const SizedBox(
    height: 4,
    ),
    // Text("${hour.date}/${hour.month}/${hour.year}"),
    // const SizedBox(height: 4,),
    ],
    ),
    ),
    ),
    ),**/
