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
    "https://www.freeiconspng.com/uploads/calendar-image-png-3.png");

class _WelcomeInfoScreenState extends State<WelcomeInfoScreen> {
  final _pageC = PageController(viewportFraction: .9);

  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        // actions: [TextButton(onPressed: () {}, child: Text("SKIP"))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                  const OnBoardingPage(
                    model: model,
                  ),
                  const OnBoardingPage(
                    model: model,
                  ),
                  const OnBoardingPage(
                    model: model,
                  ),
                  const OnBoardingPage(
                    model: model,
                  ),
                ])),
            Container(
              height: 56,
              child: Row(
                children: [
                  Container(
                      width: 100,
                      child: LinearProgressIndicator(
                        value: _page / 3,
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
                    child: (_page == 3)
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
