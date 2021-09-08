import 'dart:async';

import 'package:charts_flutter/flutter.dart';

/// Bar chart example
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:rate_your_time_new/utils/constants.dart';

class GroupedBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final void Function(int index) onBarSelected;

  final List<bool> tapped = [false];

  GroupedBarChart(this.seriesList, {this.animate, this.onBarSelected});

  factory GroupedBarChart.withHoursData(
      List<SingleDayAverage> av, void Function(int index) onBarSelected) {
    return new GroupedBarChart(
      _createSampleData(av),
      animate: true,
      onBarSelected: onBarSelected,
    );
  }

  static charts.Color get veryVeryLightBlue =>
      charts.ColorUtil.fromDartColor(Colors.blue);

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      barGroupingType: charts.BarGroupingType.stacked,
      selectionModels: [
        SelectionModelConfig(updatedListener: (SelectionModel model) {
          if (model.hasDatumSelection && onBarSelected != null) {
            if (!tapped[0]) {
              tapped[0] = true;
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              Duration d = Duration(milliseconds: 300);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Double tap to open details',
                ),
                duration: d,
                backgroundColor: Colors.black87,
                behavior: SnackBarBehavior.floating,
                elevation: 4,
                shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadiusDirectional.all(Radius.circular(4)),
                ),
              ));
              Timer(d, () {
                tapped[0] = false;
              });
            } else {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              onBarSelected(model.selectedDatum[0].index);
            }
          }
        })
      ],
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<SingleDayAverage, String>> _createSampleData(
      List<SingleDayAverage> av) {
    final now = DateTime.now();
    List<SingleDayAverage> charter = av.map((element) {
      if (!DateUtils.isSameDay(element.date, now))
        return element.copyWith(worth: 0.0);
      return element.copyWith(worth: element.pendingSales);
    }).toList();
    return [
      new charts.Series<SingleDayAverage, String>(
          id: 'tv',
          domainFn: (SingleDayAverage sales, _) =>
          sales.label ?? Utils.shortDays[sales.date.weekday],
          measureFn: (SingleDayAverage sales, _) =>
              sales.worth > 0 ? sales.worth : 0,
          data: charter,
          fillColorFn: (d, i) => veryVeryLightBlue,
          patternColorFn: (d, i) => charts.Color.white,
          fillPatternFn: (d, i) => DateUtils.isSameDay(d.date, now)
              ? FillPatternType.forwardHatch
              : FillPatternType.solid),
      new charts.Series<SingleDayAverage, String>(
        id: 'mobile',
        domainFn: (SingleDayAverage sales, _) =>
            sales.label ?? Utils.shortDays[sales.date.weekday],
        measureFn: (SingleDayAverage sales, _) =>
            sales.worth > 0 ? sales.worth : 0,
        data: av,
      ),
    ];
  }
}

/// Sample ordinal data type.
class SingleDayAverage {
  final DateTime date;
  final double worth;

  final double pendingSales;

  final int filledRegion;

  final String label;

  SingleDayAverage(this.date, this.worth,
      {this.pendingSales = 0.0, this.filledRegion = 0, this.label});

  SingleDayAverage copyWith(
          {DateTime date,
          double worth,
          double pendingSales,
          int filledHours,
          String label}) =>
      SingleDayAverage(date ?? this.date, worth ?? this.worth,
          pendingSales: pendingSales ?? this.pendingSales,
          filledRegion: filledHours ?? this.filledRegion,
          label: label ?? this.label);

  @override
  String toString() {
    return "$date ---> $worth";
  }
}
