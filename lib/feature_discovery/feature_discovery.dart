// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'animation.dart';
import 'overlay.dart';



/// [Widget] to enforce a global lock system for [FeatureDiscovery] widgets.
///
/// This widget enforces that at most one [FeatureDiscovery] widget in its
/// widget tree is shown at a time.
///
/// Users wanting to use [FeatureDiscovery] need to put this controller
/// above [FeatureDiscovery] widgets in the widget tree.
class FeatureDiscoveryController extends StatefulWidget {
  final Widget child;

  FeatureDiscoveryController(this.child);

  static _FeatureDiscoveryControllerState of(BuildContext context) {
    final matchResult =
        context.findAncestorStateOfType<_FeatureDiscoveryControllerState>();
    if (matchResult != null) {
      return matchResult;
    }

    throw FlutterError(
        'FeatureDiscoveryController.of() called with a context that does not '
        'contain a FeatureDiscoveryController.\n The context used was:\n '
        '$context');
  }

  @override
  _FeatureDiscoveryControllerState createState() =>
      _FeatureDiscoveryControllerState();
}

class _FeatureDiscoveryControllerState
    extends State<FeatureDiscoveryController> {
  bool _isLocked = false;

  /// Flag to indicate whether a [FeatureDiscovery] widget descendant is
  /// currently showing its overlay or not.
  ///
  /// If true, then no other [FeatureDiscovery] widget should display its
  /// overlay.
  bool get isLocked => _isLocked;

  /// Lock the controller.
  ///
  /// Note we do not [setState] here because this function will be called
  /// by the first [FeatureDiscovery] ready to show its overlay, and any
  /// additional [FeatureDiscovery] widgets wanting to show their overlays
  /// will already be scheduled to be built, so the lock change will be caught
  /// in their builds.
  void lock() => _isLocked = true;

  /// Unlock the controller.
  void unlock() => setState(() => _isLocked = false);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    assert(
      context.findAncestorStateOfType<_FeatureDiscoveryControllerState>() ==
          null,
      'There should not be another ancestor of type '
      'FeatureDiscoveryController in the widget tree.',
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Widget that highlights the [child] with an overlay.
///
/// This widget loosely follows the guidelines set forth in the Material Specs:
/// https://material.io/archive/guidelines/growth-communications/feature-discovery.html.
class FeatureDiscovery extends StatefulWidget {
  /// Title to be displayed in the overlay.
  final String title;

  /// Description to be displayed in the overlay.
  final String description;

  /// Icon to be promoted.
  final Icon child;

  /// Flag to indicate whether to show the overlay or not anchored to the
  /// [child].
  final bool showOverlay;

  /// Callback invoked when the user dismisses an overlay.
  final void Function() onDismiss;

  /// Callback invoked when the user taps on the tap target of an overlay.
  final void Function() onTap;

  /// Color with which to fill the outer circle.
  final Color color;

  @visibleForTesting
  static final overlayKey = const Key('overlay key');

  @visibleForTesting
  static final gestureDetectorKey = const Key('gesture detector key');

  FeatureDiscovery({
    @required this.title,
    @required this.description,
    @required this.child,
    @required this.showOverlay,
    this.onDismiss,
    this.onTap,
    this.color,
  }) {
    assert(title != null);
    assert(description != null);
    assert(child != null);
    assert(showOverlay != null);
  }

  @override
  _FeatureDiscoveryState createState() => _FeatureDiscoveryState();
}

class _FeatureDiscoveryState extends State<FeatureDiscovery>
    with TickerProviderStateMixin {
  bool showOverlay = false;
  FeatureDiscoveryStatus status = FeatureDiscoveryStatus.closed;

  AnimationController openController;
  AnimationController rippleController;
  AnimationController tapController;
  AnimationController dismissController;

  Animations animations;
  OverlayEntry overlay;

  Widget buildOverlay(BuildContext ctx, Offset center) {
    debugCheckHasMediaQuery(ctx);
    debugCheckHasDirectionality(ctx);

    final deviceSize = MediaQuery.of(ctx).size;
    final color = widget.color ?? Theme.of(ctx).primaryColor;

    // Wrap in transparent [Material] to enable widgets that require one.
    return Material(
      key: FeatureDiscovery.overlayKey,
      type: MaterialType.transparency,
      child: Stack(
        children: [
          GestureDetector(
            key: FeatureDiscovery.gestureDetectorKey,
            onTap: dismiss,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
            ),
          ),
          Background(
            animations: animations,
            status: status,
            color: color,
            center: center,
            deviceSize: deviceSize,
            textDirection: Directionality.of(ctx),
          ),
          Content(
            animations: animations,
            status: status,
            center: center,
            deviceSize: deviceSize,
            title: widget.title,
            description: widget.description,
            textTheme: Theme.of(ctx).textTheme,
          ),
          Ripple(
            animations: animations,
            status: status,
            center: center,
          ),
          TapTarget(
            animations: animations,
            status: status,
            center: center,
            child: widget.child,
            onTap: tap,
          ),
        ],
      ),
    );
  }

  /// Method to handle user tap on [TapTarget].
  ///
  /// Tapping will stop any active controller and start the [tapController].
  void tap() {
    openController.stop();
    rippleController.stop();
    dismissController.stop();
    tapController.forward(from: 0.0);
  }

  /// Method to handle user dismissal.
  ///
  /// Dismissal will stop any active controller and start the
  /// [dismissController].
  void dismiss() {
    openController.stop();
    rippleController.stop();
    tapController.stop();
    dismissController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, _) {
      if (overlay != null) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          // [OverlayEntry] needs to be explicitly rebuilt when necessary.
          overlay.markNeedsBuild();
        });
      } else {
        if (showOverlay && !FeatureDiscoveryController.of(ctx).isLocked) {
          final entry = OverlayEntry(
            builder: (_) => buildOverlay(ctx, getOverlayCenter(ctx)),
          );

          // Lock [FeatureDiscoveryController] early in order to prevent
          // another [FeatureDiscovery] widget from trying to show its
          // overlay while the post frame callback and set state are not
          // complete.
          FeatureDiscoveryController.of(ctx).lock();

          SchedulerBinding.instance.addPostFrameCallback((_) {
            setState(() {
              overlay = entry;
              status = FeatureDiscoveryStatus.closed;
              openController.forward(from: 0.0);
            });
            Overlay.of(context).insert(entry);
          });
        }
      }
      return widget.child;
    });
  }

  /// Compute the center position of the overlay.
  Offset getOverlayCenter(BuildContext parentCtx) {
    final box = parentCtx.findRenderObject() as RenderBox;
    final size = box.size;
    final topLeftPosition = box.localToGlobal(Offset.zero);
    final centerPosition = Offset(
      topLeftPosition.dx + size.width / 2,
      topLeftPosition.dy + size.height / 2,
    );
    return centerPosition;
  }

  @override
  void initState() {
    super.initState();

    initAnimationControllers();
    initAnimations();
    showOverlay = widget.showOverlay;
  }

  void initAnimationControllers() {
    openController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((animationStatus) {
        if (animationStatus == AnimationStatus.forward) {
          setState(() => status = FeatureDiscoveryStatus.open);
        } else if (animationStatus == AnimationStatus.completed) {
          rippleController.forward(from: 0.0);
        }
      });

    rippleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((animationStatus) {
        if (animationStatus == AnimationStatus.forward) {
          setState(() => status = FeatureDiscoveryStatus.ripple);
        } else if (animationStatus == AnimationStatus.completed) {
          rippleController.forward(from: 0.0);
        }
      });

    tapController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((animationStatus) {
        if (animationStatus == AnimationStatus.forward) {
          setState(() => status = FeatureDiscoveryStatus.tap);
        } else if (animationStatus == AnimationStatus.completed) {
          widget.onTap?.call();
          cleanUponOverlayClose();
        }
      });

    dismissController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((animationStatus) {
        if (animationStatus == AnimationStatus.forward) {
          setState(() => status = FeatureDiscoveryStatus.dismiss);
        } else if (animationStatus == AnimationStatus.completed) {
          widget.onDismiss?.call();
          cleanUponOverlayClose();
        }
      });
  }

  void initAnimations() {
    assert(openController != null);
    assert(rippleController != null);
    assert(tapController != null);
    assert(dismissController != null);

    animations = Animations(
      openController,
      tapController,
      rippleController,
      dismissController,
    );
  }

  /// Clean up once overlay has been dismissed or tap target has been tapped.
  ///
  /// This is called upon [tapController] and [dismissController] end.
  void cleanUponOverlayClose() {
    FeatureDiscoveryController.of(context).unlock();
    setState(() {
      status = FeatureDiscoveryStatus.closed;
      showOverlay = false;
      overlay?.remove();
      overlay = null;
    });
  }

  @override
  void didUpdateWidget(FeatureDiscovery oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showOverlay != oldWidget.showOverlay) {
      showOverlay = widget.showOverlay;
    }
  }

  @override
  void dispose() {
    overlay?.remove();
    openController?.dispose();
    rippleController?.dispose();
    tapController?.dispose();
    dismissController?.dispose();
    super.dispose();
  }
}
