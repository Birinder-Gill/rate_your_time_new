import 'package:flutter/material.dart';



class ErrorImage extends StatelessWidget {
  const ErrorImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.network(
        'https://freepikpsd.com/media/2019/10/android-app-icon-png-Free-PNG-Images-Transparent.png');
  }
}