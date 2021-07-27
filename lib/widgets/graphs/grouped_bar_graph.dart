/// Bar chart example
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:rate_your_time_new/utils/constants.dart';

class GroupedBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  GroupedBarChart(this.seriesList, {this.animate});

  factory GroupedBarChart.withHoursData(List<SingleDayAverage> av) {
    return new GroupedBarChart(
      _createSampleData(av),
      // Disable animations for image tests.
      animate: true,
    );
  }


  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      barGroupingType: charts.BarGroupingType.stacked,
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<SingleDayAverage, String>> _createSampleData(List<SingleDayAverage> av) {
    return [
      new charts.Series<SingleDayAverage, String>(
        id: 'mobile',
        domainFn: (SingleDayAverage sales, _) => Utils.shortDays[sales.date.weekday],
        measureFn: (SingleDayAverage sales, _) => sales.worth>0?sales.worth:0,
        data: av,
      ),
      // new charts.Series<OrdinalSales, String>(
      //   id: 'Mobile',
      //   domainFn: (OrdinalSales sales, _) => sales.year,
      //   measureFn: (OrdinalSales sales, _) => sales.sales,
      //   data: mobileSalesData,
      // ),
    ];
  }
}

/// Sample ordinal data type.
class SingleDayAverage {
  final DateTime date;
  final double worth;

  SingleDayAverage(this.date, this.worth);

}
