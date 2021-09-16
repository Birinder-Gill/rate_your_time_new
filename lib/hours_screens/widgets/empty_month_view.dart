import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rate_your_time_new/hours_screens/widgets/empty_view.dart';
import 'package:rate_your_time_new/models/hours_model.dart';

class EmptyMonthView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final newUser = Provider.of<AppModel>(context).isEmpty;
    final theme = Theme.of(context).textTheme;
    if(!newUser)
    return EmptyView();
    return Container(
      child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Tell here about what will be shown on this screen.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5,
            ),
          )),
    );
  }
}
