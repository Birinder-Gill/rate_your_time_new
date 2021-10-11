// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';
import 'package:rate_your_time_new/alarms_screen.dart';
import 'package:rate_your_time_new/feature_discovery/delegate.dart';
import 'package:rate_your_time_new/feature_discovery/feature_discovery.dart';
import 'package:rate_your_time_new/hours_screens/widgets/toggle.dart';
import 'package:rate_your_time_new/models/hours_model.dart';
import 'package:rate_your_time_new/settings_screen.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:rate_your_time_new/widgets/page_status.dart';

const Cubic _accelerateCurve = Cubic(0.548, 0, 0.757, 0.464);
const Cubic _decelerateCurve = Cubic(0.23, 0.94, 0.41, 1);
const _peakVelocityTime = 0.248210;
const _peakVelocityProgress = 0.379146;

class _FrontLayer extends StatelessWidget {
  const _FrontLayer({
    Key key,
    this.onTap,
    this.child,
  }) : super(key: key);

  final VoidCallback onTap;
  final Widget child;

  DateTime get now => DateTime.now();

  @override
  Widget build(BuildContext context) {
    // An area at the top of the product page.
    // When the menu page is shown, tapping this area will close the menu
    // page and reveal the product page.
    final Widget pageTopArea = Container(
      height: 45,
      alignment: AlignmentDirectional.centerStart,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Consumer<AppModel>(builder: (_, model, __) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // if (model.toggle != 0)
                //   IconButton(icon: Icon(Icons.chevron_left), onPressed: () {}),
                Opacity(
                  opacity: model.animController.value,
                  child: false?ToggleButtons(
                      selectedColor: Theme.of(context).accentColor,
                      onPressed: model.animController.value == 1
                          ? model.changeViewToggle
                          : null,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: FDelegate(
                              title: 'Day view',
                              description:
                              'Day view shows your hourly rating for the selected day',
                              featureId: 'calendar_view_day',
                              child: Icon(Icons.calendar_view_day)),
                        ),
                       if(now.weekday>1) SizedBox(
                          height: 50,
                          width: 50,
                          child: FDelegate(
                              title: 'Week View',
                              description:
                              'Week view shows your daily average ratings, time spent on activities and screen time spent on various apps in the selected week.',
                              featureId: 'view_week',
                              child: Icon(Icons.view_week)),
                        ),
                        if(now.day>1)SizedBox(
                          height: 50,
                          width: 50,
                          child: FDelegate(
                              title: 'Month View',
                              description:
                              'Month view shows your daily average ratings, time spent on activities and screen time spent on various apps in the selected month.',
                              featureId: 'date_range',
                              child: Icon(Icons.date_range)),
                        ),
                      ],
                      isSelected: model.selections):ViewToggle(),
                ),
                // if (model.toggle != 0)
                //   IconButton(icon: Icon(Icons.chevron_right), onPressed: () {}),
              ],
            );
          }),
        ),
      ),
    );

    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      elevation: 4,
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(42)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          onTap != null
              ? GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  excludeFromSemantics:
                      true, // Because there is already a "Close Menu" button on screen.
                  onTap: onTap,
                  child: pageTopArea,
                )
              : pageTopArea,
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}

class _BackdropTitle extends AnimatedWidget {
  const _BackdropTitle({
    Key key,
    Animation<double> listenable,
    this.onPress,
    @required this.frontTitle,
    @required this.backTitle,
  })  : assert(frontTitle != null),
        assert(backTitle != null),
        super(key: key, listenable: listenable);

  final void Function() onPress;
  final Widget frontTitle;
  final Widget backTitle;

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = CurvedAnimation(
      parent: listenable as Animation<double>,
      curve: const Interval(0, 0.78),
    );

    final textDirectionScalar =
        Directionality.of(context) == TextDirection.ltr ? 1 : -1;

    final slantedMenuIcon = const Icon(Icons
        .date_range); //ImageIcon(AssetImage('packages/shrine_images/slanted_menu.png'));

    final directionalSlantedMenuIcon =
        Directionality.of(context) == TextDirection.ltr
            ? slantedMenuIcon
            : Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(pi),
                child: slantedMenuIcon,
              );

    // final menuButtonTooltip = animation.isCompleted
    //     ? GalleryLocalizations.of(context).shrineTooltipOpenMenu
    //     : animation.isDismissed
    //     ? GalleryLocalizations.of(context).shrineTooltipCloseMenu
    //     : null;

    return DefaultTextStyle(
      style: Theme.of(context).primaryTextTheme.headline6,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      child: Stack(
        children: [
          Opacity(
            opacity: CurvedAnimation(
              parent: ReverseAnimation(animation),
              curve: const Interval(0.5, 1),
            ).value,
            child: FractionalTranslation(
              translation: Tween<Offset>(
                begin: Offset.zero,
                end: Offset(0.5 * textDirectionScalar, 0),
              ).evaluate(animation),
              child: backTitle,
            ),
          ),
          Opacity(
            opacity: CurvedAnimation(
              parent: animation,
              curve: const Interval(0.5, 1),
            ).value,
            child: FractionalTranslation(
              translation: Tween<Offset>(
                begin: Offset(-0.25 * textDirectionScalar, 0),
                end: Offset.zero,
              ).evaluate(animation),
              child: frontTitle,
            ),
          ),
        ],
      ),
    );
  }
}

/// Builds a Backdrop.
///
/// A Backdrop widget has two layers, front and back. The front layer is shown
/// by default, and slides down to show the back layer, from which a user
/// can make a selection. The user can also configure the titles for when the
/// front or back layer is showing.
class Backdrop extends StatefulWidget {
  const Backdrop({
    @required this.frontLayer,
    @required this.backLayer,
    @required this.frontTitle,
    @required this.backTitle,
    @required this.controller,
  })  : assert(frontLayer != null),
        assert(backLayer != null),
        assert(frontTitle != null),
        assert(backTitle != null),
        assert(controller != null);

  final Widget frontLayer;
  final Widget backLayer;
  final Widget frontTitle;
  final Widget backTitle;
  final AnimationController controller;

  @override
  _BackdropState createState() => _BackdropState();
}

class _BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');
  AnimationController _controller;
  Animation<RelativeRect> _layerAnimation;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      Timer(Duration(seconds: 1), (){
        _showFeatureOverlays();
      });
    });
  }

  bool get _frontLayerVisible {
    final status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  void _toggleBackdropLayerVisibility() {
    // Call setState here to update layerAnimation if that's necessary
    setState(() {
      _frontLayerVisible ? _controller.reverse() : _controller.forward();
    });
  }

  // _layerAnimation animates the front layer between open and close.
  // _getLayerAnimation adjusts the values in the TweenSequence so the
  // curve and timing are correct in both directions.
  Animation<RelativeRect> _getLayerAnimation(Size layerSize, double layerTop) {
    Curve firstCurve; // Curve for first TweenSequenceItem
    Curve secondCurve; // Curve for second TweenSequenceItem
    double firstWeight; // Weight of first TweenSequenceItem
    double secondWeight; // Weight of second TweenSequenceItem
    Animation<double> animation; // Animation on which TweenSequence runs

    if (_frontLayerVisible) {
      firstCurve = _accelerateCurve;
      secondCurve = _decelerateCurve;
      firstWeight = _peakVelocityTime;
      secondWeight = 1 - _peakVelocityTime;
      animation = CurvedAnimation(
        parent: _controller.view,
        curve: const Interval(0, 0.78),
      );
    } else {
      // These values are only used when the controller runs from t=1.0 to t=0.0
      firstCurve = _decelerateCurve.flipped;
      secondCurve = _accelerateCurve.flipped;
      firstWeight = 1 - _peakVelocityTime;
      secondWeight = _peakVelocityTime;
      animation = _controller.view;
    }

    return TweenSequence<RelativeRect>(
      [
        TweenSequenceItem<RelativeRect>(
          tween: RelativeRectTween(
            begin: RelativeRect.fromLTRB(
              0,
              layerTop,
              0,
              layerTop - layerSize.height,
            ),
            end: RelativeRect.fromLTRB(
              0,
              layerTop * _peakVelocityProgress,
              0,
              (layerTop - layerSize.height) * _peakVelocityProgress,
            ),
          ).chain(CurveTween(curve: firstCurve)),
          weight: firstWeight,
        ),
        TweenSequenceItem<RelativeRect>(
          tween: RelativeRectTween(
            begin: RelativeRect.fromLTRB(
              0,
              layerTop * _peakVelocityProgress,
              0,
              (layerTop - layerSize.height) * _peakVelocityProgress,
            ),
            end: RelativeRect.fill,
          ).chain(CurveTween(curve: secondCurve)),
          weight: secondWeight,
        ),
      ],
    ).animate(animation);
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    final layerSize =
        Size(constraints.biggest.width, Constants.datePickerHeight);
    final layerTop = layerSize.height;

    _layerAnimation = _getLayerAnimation(layerSize, layerTop);

    return Stack(
      key: _backdropKey,
      children: [
        ExcludeSemantics(
          excluding: _frontLayerVisible,
          child: Theme(
              data: Theme.of(context).copyWith(
                accentColor: Theme.of(context).colorScheme.secondary
              ),
              child: widget.backLayer),
        ),
        PositionedTransition(
          rect: _layerAnimation,
          child: ExcludeSemantics(
            excluding: !_frontLayerVisible,
            child: AnimatedBuilder(
              animation: PageStatus.of(context).cartController,
              builder: (context, child) => child,
              child: AnimatedBuilder(
                animation: PageStatus.of(context).menuController,
                builder: (context, child) => child,
                child: _FrontLayer(
                  child: widget.frontLayer,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
     final appBar = AppBar(
      leading: Builder(
          builder: (BuildContext c) => FDelegate(
                featureId: 'menu',
                color: Theme.of(context).primaryColor,
                title: 'Menu',
                description: 'Open Settings using this button.',
                child: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: Scaffold.of(c).openDrawer),
              )),
      automaticallyImplyLeading: true,
      brightness: Brightness.dark,
      elevation: 0,
      titleSpacing: 0,
      centerTitle: true,
      title: _BackdropTitle(
        listenable: _controller.view,
        onPress: _toggleBackdropLayerVisibility,
        frontTitle: widget.frontTitle,
        backTitle: widget.backTitle,
      ),
      actions: [
        IconButton(icon: FaIcon(FontAwesomeIcons.chalkboardTeacher,size: 16,), onPressed: (){
          _showFeatureOverlays();
        }),
        FDelegate(
          featureId: 'add_event',
          description: "Click here to change date",
          title: 'Change date',
          color: Theme.of(context).primaryColor,
          child: IconButton(
            icon: AnimatedIcon(
                icon: AnimatedIcons.add_event, progress: _controller),
            onPressed: _toggleBackdropLayerVisibility,
          ),
        ),
      ],
    );
    return AnimatedBuilder(
      animation: PageStatus.of(context).cartController,
      builder: (context, child) => ExcludeSemantics(
        excluding: cartPageIsVisible(context),
        child: Scaffold(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          drawer: Drawer(child: SettingsScreen()),
          appBar: appBar,
          body: LayoutBuilder(
            builder: _buildStack,
          ),
        ),
      ),
    );
  }

  void _showFeatureOverlays() {
    FeatureDiscovery.discoverFeatures(context, <String>[
      'menu',
      'calendar_view_day',
      'view_week',
      'date_range',
      'add_event'
    ]);
  }
}

class DesktopBackdrop extends StatelessWidget {
  const DesktopBackdrop({
    @required this.frontLayer,
    @required this.backLayer,
  });

  final Widget frontLayer;
  final Widget backLayer;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        backLayer,
        Padding(
          padding: EdgeInsetsDirectional.only(
            start: desktopCategoryMenuPageWidth(context: context),
          ),
          child: Material(
            elevation: 16,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: frontLayer,
          ),
        )
      ],
    );
  }

  double desktopCategoryMenuPageWidth({
    BuildContext context,
  }) {
    return 232 * 1.0; //reducedTextScale(context);
  }
}
