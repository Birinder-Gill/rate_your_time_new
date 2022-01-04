import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirstTimeEmptyView extends StatelessWidget {
  final String title;
  final String desc;
  final String caption;
  final String assetPath;

  const FirstTimeEmptyView({Key key, this.title, this.desc, this.caption, this.assetPath}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          "$title",
          style: tt.headline4,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(height: 340, child: _GradientyImage(assetPath: assetPath,)),
        ),
        Text(
          "$desc",
          style: tt.subtitle1,
          textAlign: TextAlign.center,
        ),
        Expanded(
          child: Center(
            child: _NotificationInTimer(),
          ),
        ),
      ],
    );
  }
}

class _NotificationInTimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Text(
     "Notification in 00:27".toUpperCase(),
      style: tt.caption.copyWith(
          letterSpacing: 2,
          wordSpacing: 2,
          fontWeight: FontWeight.bold),
    );
  }
}

class _GradientyImage extends StatelessWidget {
  final String assetPath;

  const _GradientyImage({Key key, this.assetPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scColor = Theme.of(context).scaffoldBackgroundColor;
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            // Colors.transparent,
            scColor,
            scColor,
            scColor,
            // Colors.transparent,
          ],
        ).createShader(
          Rect.fromLTRB(0, 0, rect.width, rect.height),
        );
      },
      blendMode: BlendMode.dstIn,
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Theme.of(context).primaryColorDark,width: .3),
            // boxShadow: [BoxShadow(color: Theme.of(context).primaryColorDark,blurRadius: 4)],
            color: scColor,
        image: DecorationImage(image: AssetImage(assetPath),fit: BoxFit.contain)),
      ),
    );
  }
}
