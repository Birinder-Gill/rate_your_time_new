import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rate_your_time_new/onboarding/data_models.dart';

class OnBoardingPage extends StatefulWidget {
  final OnBoardingModel model;

  const OnBoardingPage({Key key, this.model}) : super(key: key);
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  double get _size => 220;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${widget.model.title}",
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 56,
          ),
          false?FaIcon(FontAwesomeIcons.solidCalendarAlt,color: Colors.red,size: 200,):Image.network(
            "${widget.model.imagePath}",
            // ,
            fit: BoxFit.cover,
            height: _size,
            width: _size,
          ),
          SizedBox(
            height: 56,
          ),
          Text(
              "${widget.model.desc}",
              // ,
              textAlign: TextAlign.center),
          SizedBox(
            height: 56,
          ),
        ],
      ),
    );
  }
}
