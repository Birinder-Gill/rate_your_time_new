import 'dart:ui' as ui;
import 'dart:math';

import 'package:flutter/material.dart';

import 'circular_slider_paint.dart' show CircularSliderMode;
import 'utils.dart';

class SliderPainter extends CustomPainter {
  CircularSliderMode mode;
  double startAngle;
  double endAngle;
  double sweepAngle;
  Color selectionColor;
  Color handlerColor;
  double handlerOutterRadius;
  bool showRoundedCapInSelection;
  bool showHandlerOutter;
  double sliderStrokeWidth;

  Offset initHandler;
  Offset endHandler;
  Offset center;
  double radius;

  SliderPainter({
    required this.mode,
    required this.startAngle,
    required this.endAngle,
    required this.sweepAngle,
    required this.selectionColor,
    required this.handlerColor,
    required this.handlerOutterRadius,
    required this.showRoundedCapInSelection,
    required this.showHandlerOutter,
    required this.sliderStrokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    center = Offset(size.width / 2, size.height / 2);
    Paint progress = _getPaint(color: Colors.red, center: center);
    radius = min(size.width / 2, size.height / 2) - sliderStrokeWidth-(sliderStrokeWidth*2);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        -pi / 2 + startAngle, sweepAngle, false, progress);

    Paint handler =
        _getHandlerPaint(color: handlerColor, style: PaintingStyle.fill);
    // Paint handlerOutter = _getHandlerPaint(color: handlerColor, width: 2.0);

    // draw handlers
    if (mode == CircularSliderMode.doubleHandler) {
      initHandler = radiansToCoordinates(center, -pi / 2 + startAngle, radius);
      canvas.drawCircle(initHandler, handlerOutterRadius, handler..color = Colors.deepOrange.shade800);
        _drawSunny(canvas,initHandler,Icons.wb_sunny_sharp,Colors.amber);
    }

    endHandler = radiansToCoordinates(center, -pi / 2 + endAngle, radius);
    canvas.drawCircle(endHandler,handlerOutterRadius, handler..color=Colors.deepPurple);
    if (showHandlerOutter) {
      _drawSunny(canvas,endHandler,Icons.nights_stay_sharp,Colors.lightBlueAccent);

      // canvas.drawCircle(endHandler, handlerOutterRadius, handlerOutter);
    }
  }

  Paint _getPaint(
          {required Color color,
          List<Color> selectionColors = const [
            Colors.deepOrange,
            Colors.deepOrangeAccent,
            Colors.amber,
            Colors.deepOrange,
            Colors.deepPurpleAccent,
            Colors.deepPurple,
            Colors.deepPurple,
            Colors.deepPurple,
            Colors.deepOrange,
          ],
          double? width,
          PaintingStyle? style,
          Offset center = Offset.zero}) =>
      Paint()
        // ..color = color
        ..shader = ui.Gradient.sweep(
          center,
          selectionColors,
          <double>[0.0, 0.125,0.25,0.375, 0.5,0.675, 0.75,0.875, 1.0],
          // List<double>.generate(selectionColors.length, (index) => (index+1)/selectionColors.length),
        )
        ..strokeCap =
            showRoundedCapInSelection ? StrokeCap.round : StrokeCap.butt
        ..style = style ?? PaintingStyle.stroke
        ..strokeWidth = width ?? sliderStrokeWidth;

  Paint _getHandlerPaint(
          {required Color color, double? width, PaintingStyle style = PaintingStyle.stroke}) =>
      Paint()
        ..color = color
        ..strokeCap =
            showRoundedCapInSelection ? StrokeCap.round : StrokeCap.butt
        ..style = style
        ..strokeWidth = width ?? sliderStrokeWidth;

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void _drawSunny(Canvas canvas, Offset offset, IconData icon, Color color) {
    TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl,textAlign: TextAlign.center);
    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        color: color,
        fontSize: (handlerOutterRadius*2)-4,
        fontFamily: icon.fontFamily,
        package: icon.fontPackage,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas,offset.translate(-textPainter.width/2, -textPainter.height/2));
  }
}
