import 'package:flutter/material.dart';

class FirstTimeEmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(height: 300, child: _GradientyImage()),
        ),
        Text(
          "Day view",
          style: tt.headline5,
        ),
        Text(
          "Your daily hourly ratings will be shown here after you input them via notification.",
          style: tt.subtitle1,
          textAlign: TextAlign.center,
        ),
        Text(
          "Next rating notification in 00:27",
          style: tt.caption.copyWith(color: tt.caption.color.withOpacity(.6),fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _GradientyImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scColor = Theme.of(context).scaffoldBackgroundColor;
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            scColor,
            scColor,
            scColor,
            Colors.transparent,
          ],
        ).createShader(
          Rect.fromLTRB(0, 0, rect.width, rect.height),
        );
      },
      blendMode: BlendMode.dstIn,
      child: Image.asset(
        'assets/images/day_view.jpg',
        fit: BoxFit.cover,
      ),
    );
  }
}
