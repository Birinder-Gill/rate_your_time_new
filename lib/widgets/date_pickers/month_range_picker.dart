import 'package:flutter/material.dart';
import 'package:rate_your_time_new/models/hours_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';

class MonthRangePicker extends StatefulWidget {
  final HoursModel model;
  final DateTime firstDate;

  const MonthRangePicker({Key key, this.model, this.firstDate})
      : super(key: key);

  @override
  _MonthRangePickerState createState() => _MonthRangePickerState();
}


class _MonthRangePickerState extends State<MonthRangePicker> {

  PageController pageController;
  DateTime selectedDate;
  int displayedYear;

  final List<int> years = [2021];

  Color get accentColor =>
      Theme
          .of(context)
          .accentColor;

  get primary => Colors.orange;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildHeader(),
        Expanded(
          child: buildPager(),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    selectedDate = widget.model.date;
    displayedYear = selectedDate.year;
  }

  buildHeader() {
    return Material(
      color: Theme
          .of(context)
          .primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('$displayedYear', style: Theme
                    .of(context)
                    .textTheme
                    .headline6,),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_up),
                      onPressed: () =>
                          pageController.animateToPage(
                              displayedYear - 1,
                              duration: Duration(milliseconds: 400),
                              curve: Curves.easeInOut),
                    ),
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_down),
                      onPressed: () =>
                          pageController.animateToPage(
                              displayedYear + 1,
                              duration: Duration(milliseconds: 400),
                              curve: Curves.easeInOut),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  buildPager() =>
      PageView(
          controller: pageController,
          scrollDirection: Axis.vertical,
          onPageChanged: (index) {
            setState(() {
              displayedYear = index;
            });
          },
          children: [
            for(final year in years)
              GridView.count(
                shrinkWrap: true,
                padding: EdgeInsets.all(12.0),
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                children: List<int>.generate(12, (i) => i + 1)
                    .map((month) => DateTime(year, month))
                    .map(
                      (date) =>
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: OutlinedButton(
                          onPressed: () =>
                              setState(() {
                                selectedDate = DateTime(date.year, date.month);
                                widget.model.refresh(selectedDate);
                              }),


                          style: ButtonStyle(
                            elevation: MaterialStateProperty.resolveWith(
                                  (states) =>
                              date.month == selectedDate.month &&
                                  date.year == selectedDate.year
                                  ? 4.0
                                  : 0,
                            ),
                            backgroundColor: MaterialStateProperty.resolveWith(
                                  (states) =>
                              date.month == selectedDate.month &&
                                  date.year == selectedDate.year
                                  ? accentColor
                                  : null,
                            ),
                            textStyle: MaterialStateProperty.resolveWith((
                                states) =>
                                TextStyle(
                                    color: date.month == selectedDate.month &&
                                        date.year == selectedDate.year
                                        ? Colors.white
                                        : date.month == DateTime
                                        .now()
                                        .month &&
                                        date.year == DateTime
                                            .now()
                                            .year
                                        ? accentColor
                                        : null)),
                          ),
                          child: Text(
                              Constants.months[date.month - 1],
                              style: TextStyle(
                                  color: date.month == selectedDate.month &&
                                      date.year == selectedDate.year
                                      ? Colors.white
                                      : date.month == DateTime
                                      .now()
                                      .month &&
                                      date.year == DateTime
                                          .now()
                                          .year
                                      ? primary
                                      : null)
                          ),
                        ),
                      ),
                )
                    .toList(),
              )
          ],
      );
}
