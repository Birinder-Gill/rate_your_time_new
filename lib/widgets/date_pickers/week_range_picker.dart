import 'package:flutter/material.dart';
import 'package:rate_your_time_new/models/hours_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class WeekRangePicker extends StatelessWidget {
  final AppModel model;

  final DateTime firstDate;

  WeekRangePicker({Key? key,required this.model, required this.firstDate}) : super(key: key) {
    setSelection(model.date, refreshModel: false);
  }

  void selectionChanged(DateRangePickerSelectionChangedArgs args) async {
    PickerDateRange ranges = args.value;
    DateTime date1 = ranges.startDate??DateTime.now();
    setSelection(date1);
  }

  @override
  Widget build(BuildContext context) {
    final l = MaterialLocalizations.of(context);
    return SfDateRangePicker(
      controller: model.controller,
      view: DateRangePickerView.month,
      minDate: firstDate,
      maxDate: DateTime.now(),
      selectionMode: DateRangePickerSelectionMode.range,
      onSelectionChanged: selectionChanged,
      monthViewSettings: DateRangePickerMonthViewSettings(
          enableSwipeSelection: false,
          firstDayOfWeek: l.firstDayOfWeekIndex + 1),
    );
  }

  void setSelection(DateTime date1, {bool refreshModel = true}) async {
    final to = await TimeUtils.getWeekEnd(date1);
    final from = await TimeUtils.getWeekStart(date1);
    model.controller.selectedRange = PickerDateRange(from, to);
    if (refreshModel) model.refresh(date1);
  }
}
