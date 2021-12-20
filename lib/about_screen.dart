import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  _AboutPageContent({Key key, this.onNext}) : super(key: key);

  final title = 'Intention:';

  final points = [
    '${Constants.appName} was developed with an intention to provide you a tool to assess every hour of your time and train your brain to stay focused through out the day.'
  ];

  final buttonText = 'How this works?';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical:24.0,horizontal: 16),
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
                          "About",
                          style: theme.textTheme.headline6.copyWith(
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
                        height: 24,
                      ),
                      for (final p in points)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            p,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.subtitle1,
                          ),
                        ),
                      SizedBox(
                        height: 16,
                      ),
                      Center(
                        child: OutlinedButton(
                            onPressed: onNext,
                            child: Text(
                              buttonText,
                              style: theme.textTheme.headline5,
                            )),
                      ),
                      // ListTile(
                      //   title: Text("Version:"),
                      //   trailing: Text(
                      //     "1.0",
                      //     style:
                      //         theme.textTheme.headline6.copyWith(fontWeight: FontWeight.bold),
                      //   ),
                      // ),
                      ListTile(
                        leading: TextButton(
                            onPressed: () {
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
                            child: Text("Licences")),
                      ),
                      ListTile(
                          leading: TextButton(
                              onPressed: () {},
                              child: Text("Rate on Google play"))),
                    ],
                  ),
                  BackButton()
                ],
              ),
            ),
          ),
        ),
        SizedBox(
            height: 100,
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
            ))
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
