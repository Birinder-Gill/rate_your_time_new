// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:rate_your_time_new/utils/constants.dart';



/// A colored piece of the [RallyPieChart].
class RallyPieChartSegment {
  const RallyPieChartSegment({required this.color, this.value = 0.0});

  final Color color;
  final double value;
}

/// The max height and width of the [RallyPieChart].
const pieChartMaxSize = 500.0;

// List<RallyPieChartSegment> buildSegmentsFromAccountItems(
//     List<AccountData> items) {
//   return List<RallyPieChartSegment>.generate(
//     items.length,
//     (i) {
//       return RallyPieChartSegment(
//         color: RallyColors.accountColor(i),
//         value: items[i].primaryAmount,
//       );
//     },
//   );
// }

// List<RallyPieChartSegment> buildSegmentsFromBillItems(List<BillData> items) {
//   return List<RallyPieChartSegment>.generate(
//     items.length,
//     (i) {
//       return RallyPieChartSegment(
//         color: RallyColors.billColor(i),
//         value: items[i].primaryAmount,
//       );
//     },
//   );
// }

// List<RallyPieChartSegment> buildSegmentsFromBudgetItems(
//     List<BudgetData> items) {
//   return List<RallyPieChartSegment>.generate(
//     items.length,
//     (i) {
//       return RallyPieChartSegment(
//         color: RallyColors.budgetColor(i),
//         value: items[i].primaryAmount - items[i].amountUsed,
//       );
//     },
//   );
// }

/// An animated circular pie chart to represent pieces of a whole, which can
/// have empty space.
class RallyPieChart extends StatefulWidget {
  const RallyPieChart(
      {required this.heroLabel, required this.heroAmount, required this.wholeAmount, required this.segments});

  final String heroLabel;
  final String heroAmount;
  final double wholeAmount;
  final List<RallyPieChartSegment> segments;

  @override
  _RallyPieChartState createState() => _RallyPieChartState();
}

class _RallyPieChartState extends State<RallyPieChart>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    animation = CurvedAnimation(
        parent: TweenSequence<double>(<TweenSequenceItem<double>>[
          TweenSequenceItem<double>(
            tween: Tween<double>(begin: 0, end: 0),
            weight: 1,
          ),
          TweenSequenceItem<double>(
            tween: Tween<double>(begin: 0, end: 1),
            weight: 1.5,
          ),
        ]).animate(controller),
        curve: Curves.decelerate);
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: _AnimatedRallyPieChart(
        animation: animation,
        centerLabel: widget.heroLabel,
        centerAmount: widget.heroAmount,
        total: widget.wholeAmount,
        segments: widget.segments,
      ),
    );
  }
}

class _AnimatedRallyPieChart extends AnimatedWidget {
  const _AnimatedRallyPieChart({
    Key? key,
    required this.animation,
    required this.centerLabel,
    required this.centerAmount,
    required this.total,
    required this.segments,
  }) : super(key: key, listenable: animation);

  final Animation<double> animation;
  final String centerLabel;
  final String centerAmount;
  final double total;
  final List<RallyPieChartSegment> segments;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final labelTextStyle = textTheme.bodyMedium!.copyWith(
      fontSize: 14,
      letterSpacing: letterSpacingOrNone(0.5),
    );

    return LayoutBuilder(builder: (context, constraints) {
      // When the widget is larger, we increase the font size.
      var headlineStyle = constraints.maxHeight >= pieChartMaxSize
          ? textTheme.headlineSmall!.copyWith(fontSize: 70)
          : textTheme.headlineSmall;

      // With a large text scale factor, we set a max font size.
      // if (GalleryOptions.of(context).textScaleFactor(context) > 1.0) {
      //   headlineStyle = headlineStyle.copyWith(
      //     fontSize: (headlineStyle.fontSize / reducedTextScale(context)),
      //   );
      // }

      return DecoratedBox(
        decoration: _RallyPieChartOutlineDecoration(
          Theme.of(context).scaffoldBackgroundColor,
          maxFraction: animation.value,
          total: total,
          segments: segments,
        ),
        child: Container(
          height: constraints.maxHeight,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                centerLabel,
                style: labelTextStyle,
              ),
              Text(
                centerAmount.toString(),
                style: headlineStyle,
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _RallyPieChartOutlineDecoration extends Decoration {
  final backgroundColor;

  const _RallyPieChartOutlineDecoration(this.backgroundColor,
      {required this.maxFraction, required this.total, required this.segments});

  final double maxFraction;
  final double total;
  final List<RallyPieChartSegment> segments;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _RallyPieChartOutlineBoxPainter(
      maxFraction: maxFraction,
      wholeAmount: total,
      segments: segments,
      backGroundColor:backgroundColor
    );
  }
}

class _RallyPieChartOutlineBoxPainter extends BoxPainter {
  final Color backGroundColor;

  _RallyPieChartOutlineBoxPainter(
      { required this.maxFraction,  required this.wholeAmount,  required this.segments, required this.backGroundColor,});

  final double maxFraction;
  final double wholeAmount;
  final List<RallyPieChartSegment> segments;
  static const double wholeRadians = 2 * math.pi;
  static const double spaceRadians = wholeRadians / 180;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    // Create two padded reacts to draw arcs in: one for colored arcs and one for
    // inner bg arc.
    const strokeWidth = 4.0;
    final outerRadius = math.min(
          configuration.size!.width,
          configuration.size!.height,
        ) /
        2;
    final outerRect = Rect.fromCircle(
      center: configuration.size!.center(offset),
      radius: outerRadius - strokeWidth * 3,
    );
    final innerRect = Rect.fromCircle(
      center: configuration.size!.center(offset),
      radius: outerRadius - strokeWidth * 12,
    );

    // Paint each arc with spacing.
    var cumulativeSpace = 0.0;
    var cumulativeTotal = 0.0;
    for (final segment in segments) {
      final paint = Paint()..color = segment.color;
      final startAngle = _calculateStartAngle(cumulativeTotal, 0);
      final sweepAngle = _calculateSweepAngle(segment.value, cumulativeSpace);
      consoleLog("Start Angle = $startAngle  Sweep angle = $sweepAngle");
      canvas.drawArc(outerRect, startAngle, sweepAngle, true, paint);
      cumulativeTotal += segment.value;
      cumulativeSpace += spaceRadians;
    }
consoleLog("-------**-------**-------**-------**----------**--------**-------**");
    // Paint any remaining space black (e.g. budget amount remaining).
    final remaining = wholeAmount - cumulativeTotal;
    if (remaining > 0) {
      final paint = Paint()..color = Colors.black;
      final startAngle =
          _calculateStartAngle(cumulativeTotal, spaceRadians * segments.length);
      final sweepAngle = _calculateSweepAngle(remaining, -spaceRadians);
      canvas.drawArc(outerRect, startAngle, sweepAngle, true, paint);

    }

    // Paint a smaller inner circle to cover the painted arcs, so they are
    // display as segments.
    final bgPaint = Paint()..color =backGroundColor;
    canvas.drawArc(innerRect, 0, 2 * math.pi, true, bgPaint);
  }

  double _calculateAngle(double amount, double offset) {
    final wholeMinusSpacesRadians =
        wholeRadians - (segments.length * spaceRadians);
    return maxFraction * (amount / wholeAmount * wholeMinusSpacesRadians + offset);
  }

  double _calculateStartAngle(double total, double offset) =>
      _calculateAngle(total, offset) - math.pi / 2;

  double _calculateSweepAngle(double total, double offset) =>
      _calculateAngle(total, offset);
}
