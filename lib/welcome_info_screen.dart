import 'package:flutter/material.dart';
import 'package:rate_your_time_new/onboarding/data_models.dart';
import 'package:rate_your_time_new/onboarding/onboarding_page.dart';
import 'package:rate_your_time_new/select_time_screen.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:rate_your_time_new/utils/shared_prefs.dart';

class WelcomeInfoScreen extends StatefulWidget {
  @override
  _WelcomeInfoScreenState createState() => _WelcomeInfoScreenState();
}

const model = const OnBoardingModel(
  "Heading of on boarding screen.",
  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
  "https://www.freeiconspng.com/uploads/calendar-image-png-3.png",
);

class _WelcomeInfoScreenState extends State<WelcomeInfoScreen> {
  final _pageC = PageController();

  int _page = 0;

  int get _length => models.length - 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        height: 72,
        child: Row(
          children: [
            Container(
                width: 100,
                child: LinearProgressIndicator(
                  value: _page / _length,
                )),
            Expanded(child: Container()),
            if (_page > 0)
              IconButton(
                  icon: Icon(Icons.navigate_before),
                  onPressed: () {
                    _pageC.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.linear);
                  }),
            SizedBox(
              width: 100,
              child: (_page == _length)
                  ? OutlinedButton(
                      onPressed: _navigateAhead, child: Text("N E X T"))
                  : IconButton(
                      icon: Icon(Icons.navigate_next),
                      onPressed: () {
                        _pageC.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.linear);
                      }),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: PageView(
                    onPageChanged: (e) {
                      consoleLog(e);
                      setState(() {
                        _page = e;
                      });
                    },
                    controller: _pageC,
                    physics: const BouncingScrollPhysics(),
                    children: [
                  for (final model in models)
                    OnBoardingPage(
                      model: model,
                    ),
                ])),
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
