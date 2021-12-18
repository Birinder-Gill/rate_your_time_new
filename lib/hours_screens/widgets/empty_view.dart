import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rate_your_time_new/models/hours_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';

class EmptyView extends StatelessWidget {

  const EmptyView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _emptyView(context);
  }
  Widget _emptyView(BuildContext context) {
    final model = Provider.of<AppModel>(context);
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
          "No data found for\n${model.frontLabel(MaterialLocalizations.of(context))}",
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
              "Please choose another date.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        ),

        const SizedBox(
          height:16,
        ),

        ElevatedButton.icon(
          onPressed:model.toggleBackdrop,
          icon: Icon(Icons.date_range),
          label: Text("Choose another date"),
          style: ButtonStyle(),
        )
      ],
    );
  }

}
