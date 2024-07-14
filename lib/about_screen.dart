import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:launch_review/launch_review.dart';
import 'package:rate_your_time_new/app_logo.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:rate_your_time_new/welcome_info_screen.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

///

class _AboutScreenState extends State<AboutScreen>
    with SingleTickerProviderStateMixin {
  final _pc = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: AnimatedBackground(
        vsync: this,
        behaviour: RandomParticleBehaviour(
            options: ParticleOptions(
                particleCount: 24,
                image: Image.network(
                    'https://banner2.cleanpng.com/20190305/sy/kisspng-portable-network-graphics-computer-icons-vector-gr-clock-png-transparent-images-pictures-photos-png-5c7e9f9ccdc855.5241486715518022688429.jpg'),
                spawnMinSpeed: 1,
                minOpacity: .05,
                maxOpacity: .1,
                opacityChangeRate: 12,
                spawnMaxSpeed: 2,
                spawnMinRadius: 16,
                spawnMaxRadius: 56)),
        child: SafeArea(
          child: PageView(
            controller: _pc,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            children: [
              _AboutPageContent(onNext: () {
                _pc.nextPage(
                    duration: Duration(milliseconds: 600),
                    curve: Curves.linear);
              }),
              WelcomeInfoScreen(onPrev: () {
                _pc.previousPage(
                    duration: Duration(milliseconds: 600),
                    curve: Curves.linear);
              })
            ],
          ),
        ),
      ),
    );
  }
}

//TODO: USE THIS IN PLAY STORE LISTING
// 'How often do you find yourself thinking "Where did all that time go?"',
// "Sometimes people fail to achieve their goals or targets even though they think they're working hard.",
// 'Most people fail to realise how much of there time actually gets wasted during the day.',
class _AboutPageContent extends StatelessWidget {
  final VoidCallback onNext;

  _AboutPageContent({Key? key, required this.onNext}) : super(key: key);

  final title = 'Intention:';

  final points = [
    '${Constants.appName} was developed with an intention to provide you a tool to assess every hour of your time and train your brain to stay focused through out the day.'
  ];

  final buttonText = 'How it works';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        SizedBox(
          height: 24,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16),
            child: Material(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              elevation: 24,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      Center(
                        child: Text(
                          "Rate your time",
                          style: theme.textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                      ),
                      Divider(),
                      Center(
                        child: AppLogo(
                          size: 100,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      for (final p in points)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            p,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                      SizedBox(
                        height: 24,
                      ),
                      Center(
                        child: ElevatedButton(
                            onPressed: onNext,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                buttonText.toUpperCase(),style: TextStyle(letterSpacing: 1),),
                            )),
                      ),
                      ListTile(
                        onTap: (){
                          showAboutDialog(
                              context: context,
                              applicationIcon: AppLogo(
                                size: 24,
                              ),
                              applicationName: "Rate your time",
                              applicationVersion: '1.0',
                              children: [
                                Text('Developed by Birinder gill in India')
                              ]);
                        },
                        leading: Icon(Icons.paste_outlined),
                        title: Text("Licences"),
                      ),
                      ListTile(
                        leading: Icon(Icons.star_rate_outlined),
                        onTap: (){
                          LaunchReview.launch();
                        },
                          title:  Text("Rate on Google play",style: TextStyle(color: Colors.black),)),
                      ListTile(
                        leading: Icon(Icons.share),
                          title: Text("Share app")),
                      Expanded(
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _icon(FontAwesomeIcons.facebook),
                              _icon(
                                FontAwesomeIcons.instagram,
                              ),
                              _icon(
                                FontAwesomeIcons.youtube,
                              ),
                              _icon(
                                FontAwesomeIcons.whatsapp,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  BackButton()
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 50,
        )
      ],
    );
  }

  Widget _icon(IconData icon) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: FaIcon(
          icon,
          size: 24,
        ),
      );
}
