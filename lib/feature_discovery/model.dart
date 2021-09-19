import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'delegate.dart';

class FDProvider {

  static List<FDelegate> get toggleIcons =>
      <FDelegate>[];

  static void runOverlays(BuildContext context){
    FeatureDiscovery.discoverFeatures(context, List<String>.from(toggleIcons.map((e) => e.featureId)));
}

}
