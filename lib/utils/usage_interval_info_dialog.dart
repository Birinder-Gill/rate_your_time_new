import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rate_your_time_new/utils/constants.dart';

showIntervalInfoDialog(BuildContext context,String label) => showCupertinoModalPopup(
    context: context, builder: (c) => _UsageIntervalInfoDialog(label: label,));

class _UsageIntervalInfoDialog extends StatefulWidget {
  final String label;

  const _UsageIntervalInfoDialog({Key? key, required this.label}) : super(key: key);
  @override
  _UsageIntervalInfoDialogState createState() =>
      _UsageIntervalInfoDialogState();
}

class _UsageIntervalInfoDialogState extends State<_UsageIntervalInfoDialog> {
  final shortDesc =
      'This date range maybe different from what you selected above.\n\n'
      'This is because android saves usage stats in specific intervals.\n\n'
      'We try to pick an interval closest to the date you selected.';
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(child: Text('${widget.label}')),
          CloseButton()
        ],
      ),
      content: Text('$shortDesc'),
      actions: [
        OutlinedButton(
            onPressed: () {
              pushTo(
                  context,
                  _UsageIntervalDetails());
            },
            child: Text("Find out more"))
      ],
    );
  }
}

class _UsageIntervalDetails extends StatelessWidget {
  final title = 'According to google release documentation.';

  final buttonLink =
      'https://developer.android.com/about/versions/android-5.0.html#System';

  final desc =
      'The system collects the usage data on a per-app basis, aggregating the data over daily, weekly, monthly, and yearly intervals. The maximum duration that the system keeps this data is as follows:';

  final points = [
    'Daily intervals: 7 days',
    'Weekly intervals: 4 weeks',
    'Monthly intervals: 6 months',
    'Yearly intervals: 2 years',
  ];
  final footer =
      'Therefore, stats for older than 7 seven days changes time interval to weekly and so on.';

  @override
  Widget build(BuildContext context) {
    final tt =Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:8.0),
            child: Text('$title',style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold),),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:8.0),
            child: Text('$buttonLink'),
          ),
          SizedBox(height: 8,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(desc,style: tt.titleMedium,),
          ),
          SizedBox(height: 8,),
          for (final i in points) ListTile(
              visualDensity: VisualDensity.compact,
              horizontalTitleGap: 0,
              leading: Icon(Icons.circle,size: 12,),
              title: Text(i,style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold,letterSpacing: 1),)),
          SizedBox(height: 8,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(footer,style:tt.titleMedium),
          ),
        ],
      ),

    );
  }
}
