// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';
import 'package:rate_your_time_new/alarms_screen.dart';
import 'package:rate_your_time_new/feature_discovery/feature_discovery.dart';
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
          child: Consumer<HoursModel>(builder: (_, model, __) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // if (model.toggle != 0)
                //   IconButton(icon: Icon(Icons.chevron_left), onPressed: () {}),
                Opacity(
                  opacity: model.animController.value,
                  child: ToggleButtons(
                      selectedColor: Theme.of(context).accentColor,
                      onPressed: model.animController.value == 1?model.changeViewToggle:null,
                      children: [
                        Icon(Icons.calendar_view_day),
                        Icon(Icons.view_week),
                        Icon(Icons.date_range)
                      ],
                      isSelected: model.selections),
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

  bool _showGuide = true;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
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
    const layerTitleHeight = 48;
    final layerSize =
        Size(constraints.biggest.width,Constants.datePickerHeight);
    final layerTop = layerSize.height - layerTitleHeight;

    _layerAnimation = _getLayerAnimation(layerSize, layerTop);

    return Stack(
      key: _backdropKey,
      children: [
        ExcludeSemantics(
          excluding: _frontLayerVisible,
          child: widget.backLayer,
        ),
        PositionedTransition(
          rect: _layerAnimation,
          child: ExcludeSemantics(
            excluding: !_frontLayerVisible,
            child: AnimatedBuilder(
              animation: PageStatus.of(context).cartController,
              builder: (context, child) => AnimatedBuilder(
                animation: PageStatus.of(context).menuController,
                builder: (context, child) => _FrontLayer(
                  onTap: null,
    // menuPageIsVisible(context)
    //                   ? _toggleBackdropLayerVisibility
    //                   : null,
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
    final theme = Theme.of(context);
    final appBar = AppBar(
      // leading: IconButton(icon: Icon(Icons.menu,color: Colors.transparent,), onPressed: null),
      automaticallyImplyLeading: true,
      brightness: Brightness.dark,
      // backgroundColor: theme.primaryColor,
      elevation: 0,
      // leading: IconButton(
      //     icon: Icon(Icons.settings),
      //     onPressed: () {
      //       pushTo(context, SettingsScreen());
      //     }),
      titleSpacing: 0,
      centerTitle: true,
      title: _BackdropTitle(
        listenable: _controller.view,
        onPress: _toggleBackdropLayerVisibility,
        frontTitle: widget.frontTitle,
        backTitle: widget.backTitle,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          // tooltip: GalleryLocalizations.of(context).shrineTooltipSearch,
          onPressed: () {
            Utils.openUsageSettingsScreen();
          },
        ),
        // if (false)
        IconButton(
          icon: const Icon(Icons.alarm),
          // tooltip: GalleryLocalizations.of(context).shrineTooltipSearch,
          onPressed: () {
            pushTo(context, AlarmsScreen());
          },
        ),
          _showGuide
              ? FeatureDiscoveryController(
                  IconButton(
                    icon: FeatureDiscovery(
                        description: 'Test desc',
                        title: "Test title",
                        showOverlay: true,
                        onDismiss: () {
                          _showGuide = false;
                          // setState(() {
                          //
                          // });
                          // _toggleBackdropLayerVisibility();
                        },
                        child: Icon(Icons.menu)),
                    // tooltip: GalleryLocalizations.of(context).shrineTooltipSettings,
                    onPressed: _toggleBackdropLayerVisibility,
                  ),
                )
              : IconButton(
                  icon: AnimatedIcon(
                      icon: AnimatedIcons.add_event,
                      progress: _controller),
                  // tooltip: GalleryLocalizations.of(context).shrineTooltipSettings,
                  onPressed: _toggleBackdropLayerVisibility,
                ),
      ],
    );
    return AnimatedBuilder(
      animation: PageStatus.of(context).cartController,
      builder: (context, child) => ExcludeSemantics(
        excluding: cartPageIsVisible(context),
        child: Scaffold(
          drawer: Drawer(child: SettingsScreen()),
          appBar: appBar,
          body: LayoutBuilder(
            builder: _buildStack,
          ),
        ),
      ),
    );
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
