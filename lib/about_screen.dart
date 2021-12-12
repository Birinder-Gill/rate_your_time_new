import 'package:flutter/material.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:rate_your_time_new/welcome_info_screen.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

///

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rate your time"),
        actions: [
          TextButton(
              onPressed: () {
                showAboutDialog(
                    context: context,
                    applicationIcon: Icon(Icons.font_download),
                    applicationName: "Rate your time",
                    applicationVersion: '1.0',
                    children: [
                      Text('This is a demo description for the application')
                    ]);
              },
              child: Text("Licences"))
        ],
      ),
      body: PageView(
        scrollDirection: Axis.vertical,
        children: [_AboutPageContent(), WelcomeInfoScreen()],
      ),
    );
  }
}

class _AboutPageContent extends StatelessWidget {
  final title = 'Intention:';
  final points = [
    'How often do you find yourself thinking "Where did all that time go?"',
    'Most of the people fail to achieve their goals in life because they don\'t realise how much of there time actually gets wasted during the day.',
    '${Constants.appName} was developed with an intention to train your brain to stay focused through out the day and make everyday more productive.'
  ];
  final buttonText = 'How this works';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: theme.textTheme.headline4,
          ),
        ),
        for (final p in points)
          ListTile(
            horizontalTitleGap: 0,
            leading: Icon(
              Icons.circle,
              color: Colors.black,
              size: 12,
            ),
            title: Text(
              p,
              style: theme.textTheme.headline6,
            ),
            subtitle: Divider(),
          ),
        OutlinedButton(
            onPressed: () {},
            child: Text(
              buttonText,
              style: theme.textTheme.headline5,
            )),
      ],
    );
  }
}
