import 'package:flutter/material.dart';
import 'package:rate_your_time_new/utils/constants.dart';

class EmptyView extends StatelessWidget {
  final bool firstDay;

  const EmptyView({Key key, this.firstDay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _emptyView(context);
  }
  Widget _firstTimeEmptyView(BuildContext context) => Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Tell here about what will be shown on this screen. ${Constants.testFlag}",

          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline5,
        ),
      ));
  Widget _emptyView(BuildContext context) {
    if (firstDay) return _firstTimeEmptyView(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // SizedBox(height:MediaQuery.of(context).size.height/6 ,),
        Icon(
          Icons.search_off,
          size: MediaQuery.of(context).size.width / 3,
          color: Theme.of(context).primaryColorDark.withOpacity(0.6),
        ),
        Text(
          "No data found",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline5,
        ),
        // SizedBox(height: 50,),
        // SizedBox(height:MediaQuery.of(context).size.height/12 ,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Opacity(
            opacity: .7,
            child: Text(
              "No data for this date, please choose another date.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 12,
        ),

        ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.date_range),
          label: Text("Choose another date"),
          style: ButtonStyle(),
        )
      ],
    );
  }

}
