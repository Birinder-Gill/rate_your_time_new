import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rate_your_time_new/models/hours_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class WeekRangePicker extends StatelessWidget {
  final HoursModel model;

  final DateTime firstDate;

  WeekRangePicker({Key key, this.model, this.firstDate}) : super(key: key);

  void selectionChanged(DateRangePickerSelectionChangedArgs args)async {
    PickerDateRange ranges = args.value;
    DateTime date1 = ranges.startDate;
    model.controller.selectedRange = PickerDateRange(await TimeUtils.getWeekStart(date1), await TimeUtils.getWeekEnd(date1));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfDateRangePicker(
        controller: model.controller,
        view: DateRangePickerView.month,
        minDate: firstDate,

        maxDate: DateTime.now(),
        selectionMode: DateRangePickerSelectionMode.range,
        onSelectionChanged: selectionChanged,
        monthViewSettings: DateRangePickerMonthViewSettings(enableSwipeSelection: false,firstDayOfWeek: 1),
      ),
    );
  }
}
