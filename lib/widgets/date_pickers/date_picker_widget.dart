import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rate_your_time_new/models/hours_model.dart';
import 'package:rate_your_time_new/widgets/date_pickers/month_range_picker.dart';
import 'package:rate_your_time_new/widgets/date_pickers/week_range_picker.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DatePickerWidget extends StatelessWidget {
  final DateTime firstDate;

  const DatePickerWidget({Key key, this.firstDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final model = Provider.of<HoursModel>(context);
    return Container(
      height: MediaQuery.of(context).size.height,
      color: theme.primaryColor,
      child: Theme(
        data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
          onPrimary: theme.accentColor,
          primary: theme.primaryColorDark,
          onSurface: theme.colorScheme.onPrimary,
        )),
        child: Column(
          children: [
            Container(
                height: 450,
                child: model.toggle == 1
                    ? WeekRangePicker(model: model,firstDate:firstDate,)
                    : model.toggle==0?SingleDatePicker(model: model,firstDate: firstDate):
                     MonthRangePicker(model: model,firstDate: firstDate),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      final DateTime rangeStartDate = args.value.startDate;
      final DateTime rangeEndDate = args.value.endDate;
    } else if (args.value is DateTime) {
      final DateTime selectedDate = args.value;
    } else if (args.value is List<DateTime>) {
      final List<DateTime> selectedDates = args.value;
    } else {
      final List<PickerDateRange> selectedRanges = args.value;
    }
  }
}

class SingleDatePicker extends StatelessWidget {
  final HoursModel model;
  final DateTime firstDate;

  const SingleDatePicker({Key key, this.model, this.firstDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfDateRangePicker(
      minDate: this.firstDate,
      initialSelectedDate: model.date,
      maxDate: DateTime.now(),
      onSelectionChanged: (args) {
        model.refresh(args.value);
      },
    );
  }
}
