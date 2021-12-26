import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rate_your_time_new/hours_screens/widgets/empty_view.dart';
import 'package:rate_your_time_new/models/hours_model.dart';

import 'first_time_empty_view.dart';

class EmptyMonthView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final newUser = Provider.of<AppModel>(context).isEmpty;
    if (newUser) {
      return FirstTimeEmptyView(title: "Month view",desc: "This will show your efficiency this month so far. Your average of every day for this month so far",
      assetPath: "assets/images/month_view.jpg",);
    } else {
      return EmptyView();
    }
  }
}
