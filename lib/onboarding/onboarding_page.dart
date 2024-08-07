import 'package:flutter/material.dart';
import 'package:rate_your_time_new/onboarding/data_models.dart';

class OnBoardingPage extends StatefulWidget {
  final OnBoardingModel model;

  const OnBoardingPage({Key? key, required this.model}) : super(key: key);

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  double get _size => 220;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "${widget.model.title}",
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 24,
            ),
            Image.network(
              "${widget.model.imagePath}",
              // ,
              fit: BoxFit.cover,
              height: _size,
              width: _size,
            ),
            SizedBox(
              height: 24,
            ),
            Text("${widget.model.desc}",
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.start),
          ],
        ),
      ),
    );
  }
}
