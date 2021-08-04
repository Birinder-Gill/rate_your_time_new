import 'package:flutter/material.dart';
import 'package:rate_your_time_new/models/hours_model.dart';

class MonthRangePicker extends StatefulWidget {
  final HoursModel model;
  final DateTime firstDate;

  const MonthRangePicker({Key key, this.model, this.firstDate})
      : super(key: key);

  @override
  _MonthRangePickerState createState() => _MonthRangePickerState();
}

class _MonthRangePickerState extends State<MonthRangePicker> {
  final months = [
    'Jan',
    'Feb',
    'Mar',
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sept",
    "Oct",
    "Nov",
    "Dec"
  ];

  var years = List<int>.generate(20, (index) => 2020 + index);

  int year;

  String month;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(year!=null && month!=null)Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("$month, $year",style: Theme.of(context).textTheme.headline3,),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton(
              value: year,
              onChanged: (e) {
                setState(() {
                  year = e;
                });
              },
              items: years
                  .map((e) => DropdownMenuItem(
                        child: Text('$e'),
                        value: e,
                      ))
                  .toList()),
        ),
        Expanded(
          child: GridView.builder(
              itemCount: months.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (c, i) => TextButton(
                  onPressed: () {
                    setState(() {
                      month = months[i];
                      widget.model.refresh(DateTime(year,i+1));
                    });
                  },
                  child: Text(months[i]))),
        ),
      ],
    );
  }
}
