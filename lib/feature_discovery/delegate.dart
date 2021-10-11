import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';

class FDelegate extends StatelessWidget {
  final Widget child;
  final String title;
  final String description;
  final String featureId;
  final void Function() onDismiss;

  final ContentLocation location;

  final Color color;

  FDelegate({
    Key key,
    @required this.title,
    @required this.description,
    @required this.child,
    @required this.featureId,
    this.onDismiss,
    this.location = ContentLocation.below, this.color=Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DescribedFeatureOverlay(
        barrierDismissible: false,
        targetColor: color,

        onBackgroundTap: () async{
          await FeatureDiscovery.completeCurrentStep(context);
          return false;
        },
        backgroundColor: Theme.of(context).accentColor,
        overflowMode: OverflowMode.extendBackground,
        contentLocation: location,
        title: Text(
          '$title',
          style: TextStyle(fontSize: 20.0),
        ),
        enablePulsingAnimation: true,

        description: Text('$description'),
        featureId: '$featureId',
        tapTarget: IgnorePointer(child: child),
        child: child);
  }
}
