import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:rate_your_time_new/utils/constants.dart';

import 'utils.dart';

class BasePainter extends CustomPainter {
  Color baseColor;
  Color selectionColor;
  int primarySectors;
  int secondarySectors;
  double sliderStrokeWidth;

  Offset center;
  double radius;

  final Color textColor;

  BasePainter({
    @required this.baseColor,
    @required this.textColor,
    @required this.selectionColor,
    @required this.primarySectors,
    @required this.secondarySectors,
    @required this.sliderStrokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Paint base = _getPaint(color: baseColor);

    center = Offset(size.width / 2, size.height / 2);
    radius = min(size.width / 2, size.height / 2) - sliderStrokeWidth - (sliderStrokeWidth*3.5);
    // we need this in the parent to calculate if the user clicks on the circumference

    assert(radius > 0);

    // canvas.drawCircle(center, radius, base);

    if (primarySectors > 0) {
      _paintSectors(primarySectors, 8.0, selectionColor, canvas);
    }

    if (secondarySectors > 0) {
      _paintSectors(secondarySectors, 6.0, baseColor, canvas);
    }
    _paintTime(4, 6.0, textColor, canvas);
  }

  void _paintSectors(
      int sectors, double radiusPadding, Color color, Canvas canvas) {
    Paint section = _getPaint(color: color, width: 2.0);

    var endSectors =
        getSectionsCoordinatesInCircle(center, radius + radiusPadding, sectors);
    var initSectors =
        getSectionsCoordinatesInCircle(center, radius - radiusPadding, sectors);
    _paintLines(canvas, initSectors, endSectors, section);
  }

  void _paintTime(
      int sectors, double radiusPadding, Color color, Canvas canvas) {
    var initSectors =
        getSectionsCoordinatesInCircle(center, radius+(sliderStrokeWidth*3.5), sectors);
    Paint paint = _getPaint(color: color, width: 2.0);
    canvas.drawPoints(ui.PointMode.points, [center], paint);
    _paintText(
      canvas,
      initSectors,
      color
    );
  }

  void _paintLines(
      Canvas canvas, List<Offset> inits, List<Offset> ends, Paint section) {
    assert(inits.length == ends.length && inits.length > 0);

    for (var i = 0; i < inits.length; i++) {
      canvas.drawLine(inits[i], ends[i], section);
    }
  }

  void _paintText(Canvas canvas, List<Offset> inits, Color color) {
    assert(inits.length > 0);
    final times = ['12','18','00','06'];
    for (final i in times) {
      consoleLog('$i ${inits[times.indexOf(i)]}');
      TextPainter(text: TextSpan(style: TextStyle(color: color,fontWeight: FontWeight.bold), text: i), textAlign: TextAlign.left, textDirection: TextDirection.ltr,)
      ..layout(minWidth: 36)
      ..paint(canvas,inits[times.indexOf(i)].translate(-8, -6));
    }
  }

  Paint _getPaint({@required Color color, double width, PaintingStyle style}) =>
      Paint()
        ..color = color
        ..strokeCap = StrokeCap.round
        ..style = style ?? PaintingStyle.stroke
        ..strokeWidth = width ?? sliderStrokeWidth;

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
