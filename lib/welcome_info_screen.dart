
import 'package:flutter/material.dart';
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
      bottomNavigationBar: ElevatedButton(onPressed: () {
        _navigateAhead();
      }, child: Text("Next"),),
      body: Center(
        child: Text("Implement welcome cards"),
      ),
    );
  }

  void _navigateAhead() {
    SharedPrefs.setInt(SharedPrefs.tutorialSeen,1).then((value){
      pushTo(context, SelectTimeScreen());
    });
  }
}
