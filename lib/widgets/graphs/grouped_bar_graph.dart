import 'dart:async';

/// Bar chart example
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:rate_your_time_new/utils/constants.dart';

class GroupedBarChart extends StatelessWidget {
  // final List<charts.Series> seriesList;
  final bool animate;
  final void Function(int index) onBarSelected;
  final List<SingleDayAverage> av;

  final List<bool> tapped = [false];

  final bool showLabel;

  GroupedBarChart(this.av,
      {this.animate = true,required this.onBarSelected, this.showLabel = true});

  // factory GroupedBarChart.withHoursData(
  //     List<SingleDayAverage> av, void Function(int index) onBarSelected) {
  //   return new GroupedBarChart(
  //     _createSampleData(av),
  //     animate: true,
  //     onBarSelected: onBarSelected,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final barColor = Theme.of(context).primaryColorDark;
    return new charts.BarChart(
      _createSampleData(barColor),
      animate: animate,
      barRendererDecorator: charts.BarLabelDecorator<String>(
        insideLabelStyleSpec:
            charts.TextStyleSpec(color: charts.Color.transparent),
        outsideLabelStyleSpec: charts.TextStyleSpec(
          fontSize: 8,
          fontWeight: '900',
        ),
      ),
      barGroupingType: charts.BarGroupingType.stacked,
      selectionModels: [
        charts.SelectionModelConfig(
            updatedListener: (charts.SelectionModel model) {
          if (model.hasDatumSelection) {
            if (!tapped[0]) {
              tapped[0] = true;
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              Duration d = Duration(milliseconds: 300);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Double tap to open details',
                ),
                duration: d,
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
              onBarSelected(model.selectedDatum[0].index??0);
            }
          }
        })
      ],
    );
  }

  /// Create series list with multiple series
  List<charts.Series<SingleDayAverage, String>> _createSampleData(
      Color barColor) {
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
              sales.label ?? Utils.shortDays[sales.date?.weekday]??'',
          labelAccessorFn: (t, i) =>
              (showLabel && av[i??0].worth > 0) ? "${av[i??0].worth.toInt()}h" : '',
          measureFn: (SingleDayAverage sales, _) =>
              sales.worth > 0 ? sales.worth : 0,
          data: charter,
          fillColorFn: (d, i) => charts.ColorUtil.fromDartColor(barColor),
          patternColorFn: (d, i) => charts.ColorUtil.fromDartColor(barColor),
          fillPatternFn: (d, i) => DateUtils.isSameDay(d.date, now)
              ? charts.FillPatternType.forwardHatch
              : charts.FillPatternType.solid),
      new charts.Series<SingleDayAverage, String>(
        id: 'mobile',
        labelAccessorFn: (t, i) => '',
        fillColorFn: (d, i) => charts.ColorUtil.fromDartColor(barColor),
        domainFn: (SingleDayAverage sales, _) =>
            sales.label ?? Utils.shortDays[sales.date?.weekday] ?? "",
        measureFn: (SingleDayAverage sales, _) =>
            sales.worth > 0 ? sales.worth : 0,
        data: av,
      ),
    ];
  }
}

/// Sample ordinal data type.
class SingleDayAverage {
  final DateTime? date;
  final double worth;

  final double pendingSales;

  // final int filledRegion;

  final String? label;

  SingleDayAverage(
      {required this.worth,
      this.pendingSales = 0.0,
      this.date,
      // this.filledRegion = 0,
      this.label});

  double get whiteBlocks => (pendingSales / (worth + pendingSales)) * 5;

  SingleDayAverage copyWith(
          {DateTime? date,
          double? worth,
          double? pendingSales,
          int? filledHours,
          String? label}) =>
      SingleDayAverage(
          date: date ?? this.date,
          worth: worth ?? this.worth,
          pendingSales: pendingSales ?? this.pendingSales,
          // filledRegion: filledHours ?? this.filledRegion,
          label: label ?? this.label);

  @override
  String toString() {
    return date == null
        ? ""
        : "${DefaultMaterialLocalizations().formatShortDate(date!)}\nWorth ---> $worth\nPending sales -> $pendingSales\nLabel $label";
  }
}
