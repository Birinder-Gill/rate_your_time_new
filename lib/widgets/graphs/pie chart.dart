/// Bar chart with example of a legend with customized position, justification,
/// desired max rows, and padding. These options are shown as an example of how
/// to use the customizations, they do not necessary have to be used together in
/// this way. Choosing [end] as the position does not require the justification
/// to also be [endDrawArea].
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

/// Example that shows how to build a datum legend that shows measure values.
///
/// Also shows the option to provide a custom measure formatter.
class DatumLegendWithMeasures extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  DatumLegendWithMeasures(this.seriesList, {this.animate});

  factory DatumLegendWithMeasures.withSampleData() {
    return new DatumLegendWithMeasures(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList,
        animate: animate,
        // Add an [ArcLabelDecorator] configured to render labels outside of the
        // arc with a leader line.
        //
        // Text style for inside / outside can be controlled independently by
        // setting [insideLabelStyleSpec] and [outsideLabelStyleSpec].
        //
        // Example configuring different styles for inside/outside:
        //       new charts.ArcLabelDecorator(
        //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
        //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
        defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: 12,
            arcRendererDecorators: [
          new charts.ArcLabelDecorator(
              labelPosition: charts.ArcLabelPosition.outside)
        ]));
  }

  /// Create series list with one series
  static List<charts.Series<TimeSpent, String>> _createSampleData() {
    final data = [
    ];

    return [
      new charts.Series<TimeSpent, String>(
        id: 'Sales',
        domainFn: (TimeSpent sales, _) => sales.category,
        measureFn: (TimeSpent sales, _) => sales.hours,
        colorFn: (sales, _) => charts.ColorUtil.fromDartColor(Colors.redAccent),
        data: data,
      )
    ];
  }

  static withCatData(Map<int, int> catMap) {
    return new DatumLegendWithMeasures(
      _createData(catMap),
      // Disable animations for image tests.
      animate: false,
    );
  }

  static List<charts.Series> _createData(Map<int, int> catMap) {
    final data = <TimeSpent>[];
    catMap.forEach((key, value) {
      data.add(TimeSpent(key, value));
    });
    return [
      new charts.Series<TimeSpent, String>(
        id: 'Sales',
        domainFn: (TimeSpent sales, _) => sales.category,
        measureFn: (TimeSpent sales, _) => sales.hours,
        colorFn: (sales, _) => charts.ColorUtil.fromDartColor(sales.color),
        data: data,
      )
    ];
  }
}

/// Sample linear data type.
class TimeSpent {
  // (4, -1, 0, 5, 7, 1, 2, 3)
  static const cats = {
    1: 'Music',
    0: 'Games',
    3: 'Images',
    6: 'Maps',
    5: 'News',
    7: 'Productivity',
    4: 'Social',
    -1: 'Others',
    2: 'Videos',
  };
  final int cat;
  final int hours;

  static const colors = {
    1: Colors.pinkAccent,
    0: Colors.deepPurple,
    3: Color(0xff278EA5),
    6: Colors.purpleAccent,
    5: Color(0xff064663),
    7: Color(0xffFF4C29),
    4: Color(0xffC70039),
    -1:Color(0xff374045),
    2: Colors.purpleAccent,
  };
  TimeSpent(this.cat, this.hours);

  String get category => TimeSpent.cats[cat];

  Color get color => colors[cat];
}
