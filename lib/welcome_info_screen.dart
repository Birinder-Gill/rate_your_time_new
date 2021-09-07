import 'package:flutter/material.dart';
import 'package:rate_your_time_new/onboarding/onboarding_page.dart';
import 'package:rate_your_time_new/select_time_screen.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:rate_your_time_new/utils/shared_prefs.dart';

class WelcomeInfoScreen extends StatefulWidget {
  @override
  _WelcomeInfoScreenState createState() => _WelcomeInfoScreenState();
}

class _WelcomeInfoScreenState extends State<WelcomeInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [TextButton(onPressed: () {}, child: Text("SKIP"))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: PageView.builder(itemBuilder:(c,i) => OnBoardingPage())),
            Row(
              children: [
                Container(width: 100, child: LinearProgressIndicator()),
                Expanded(child: Container()),
                OutlinedButton(onPressed: () {}, child: Text("N E X T"))
              ],
            )
          ],
        ),
      ),
    );
  }

  void _navigateAhead() {
    SharedPrefs.setInt(SharedPrefs.tutorialSeen, 1).then((value) {
      pushTo(context, SelectTimeScreen());
    });
  }
}
