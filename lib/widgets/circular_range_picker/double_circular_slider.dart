import 'package:flutter/material.dart';

import 'circular_slider_paint.dart';

/// Returns a widget which displays a circle to be used as a slider.
///
/// Required arguments are init and end to set the initial selection.
/// onSelectionChange is a callback function which returns new values as the user
/// changes the interval.
/// The rest of the params are used to change the look and feel.
///
///     DoubleCircularSlider(5, 10, onSelectionChange: () => {});
class DoubleCircularSlider extends StatefulWidget {
  /// the selection will be values between 0..divisions; max value is 300
  final int divisions;

  /// the initial value in the selection
  final int init;

  /// the end value in the selection
  final int end;

  /// the number of primary sectors to be painted
  /// will be painted using selectionColor
  final int primarySectors;

  /// the number of secondary sectors to be painted
  /// will be painted using baseColor
  final int secondarySectors;

  /// an optional widget that would be mounted inside the circle
  final Widget child;

  /// height of the canvas, default at 220
  final double height;

  /// width of the canvas, default at 220
  final double width;

  /// color of the base circle and sections
  final Color baseColor;

  /// color of the selection
  final Color selectionColor;

  /// color of the handlers
  final Color handlerColor;

  /// callback function when init and end change
  /// (int init, int end) => void
  final SelectionChanged<int> onSelectionChange;

  /// callback function when init and end finish
  /// (int init, int end) => void
  final SelectionChanged<int> onSelectionEnd;

  /// outter radius for the handlers
  final double handlerOutterRadius;

  /// if true an extra handler ring will be displayed in the handler
  final bool showHandlerOutter;

  /// stroke width for the slider, defaults at 12.0
  final double sliderStrokeWidth;

  /// if true, the onSelectionChange will also return the number of laps in the slider
  /// otherwise, everytime the user completes a full lap, the selection restarts from 0
  final bool shouldCountLaps;

  final Color textColor;

  DoubleCircularSlider(
    this.divisions,
    this.init,
    this.end, {
    this.height = 220,
    this.width = 220,
    required this.child,
    this.primarySectors = 0,
    this.secondarySectors = 0,
    this.baseColor = const Color.fromRGBO(255, 255, 255, 0.1),
    this.selectionColor = const Color.fromRGBO(255, 255, 255, 0.3),
    this.handlerColor = Colors.white,
    required this.onSelectionChange,
    required this.onSelectionEnd,
    this.handlerOutterRadius = 12.0,
    this.showHandlerOutter = true,
    this.sliderStrokeWidth = 12.0,
    this.shouldCountLaps = false,
    required this.textColor,
  })  : assert(init >= 0 && init <= divisions,
            'init has to be > 0 and < divisions value'),
        assert(end >= 0 && end <= divisions,
            'end has to be > 0 and < divisions value'),
        assert(divisions >= 0 && divisions <= 300,
            'divisions has to be > 0 and <= 300');

  @override
  _DoubleCircularSliderState createState() => _DoubleCircularSliderState();
}

class _DoubleCircularSliderState extends State<DoubleCircularSlider> {
  late int _init;
  late int _end;

  @override
  void initState() {
    super.initState();
    _init = widget.init;
    _end = widget.end;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.height,
        width: widget.width,
        child: CircularSliderPaint(
          mode: CircularSliderMode.doubleHandler,
          init: _init,
          end: _end,
          divisions: widget.divisions,
          primarySectors: widget.primarySectors,
          secondarySectors: widget.secondarySectors,
          child: widget.child,
          onSelectionChange: (newInit, newEnd, laps) {
            widget.onSelectionChange(newInit, newEnd, laps);
            setState(() {
              _init = newInit;
              _end = newEnd;
            });
          },
          onSelectionEnd: (newInit, newEnd, laps) {
            widget.onSelectionEnd(newInit, newEnd, laps);
          },
          sliderStrokeWidth: widget.sliderStrokeWidth,
          baseColor: widget.baseColor,
          selectionColor: widget.selectionColor,
          handlerColor: widget.handlerColor,
          handlerOutterRadius: widget.handlerOutterRadius,
          showRoundedCapInSelection: true,
          showHandlerOutter: widget.showHandlerOutter,
          shouldCountLaps: widget.shouldCountLaps,
          textColor: widget.textColor,
        ));
  }
}
