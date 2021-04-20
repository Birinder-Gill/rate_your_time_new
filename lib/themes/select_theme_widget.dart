import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rate_your_time_new/models/app_model.dart';
import 'package:rate_your_time_new/themes/theme_model.dart';

class SelectThemeWidget extends StatefulWidget {
  @override
  _SelectThemeWidgetState createState() => _SelectThemeWidgetState();
}

class _SelectThemeWidgetState extends State<SelectThemeWidget> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AppModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Select theme"),
      ),
      body: Row(
        children: [
          Expanded(
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
                children: [
                  for(int i=0;i<model.themes.length;i++)
                    GestureDetector(
                        onTap: (){
                          model.setTheme(i);
                          // Navigator.pop(context);
                        },
                        child: ThemeTile(model.themes[i],height: 70,))
                ],
              ),
          ),
        ],
      ),
    );

  }
}

class ThemeTile extends StatelessWidget {
  final MyTheme e;

  final double height;

  const ThemeTile(this.e, {Key key, this.height=50}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: height,
        width: height,
        child: Material(
          elevation: 4,
          child: Column(
            children: [
              Expanded(
                child: _themeView(back:e.primaryColor,front:e.primaryTextColor),
              ),
              Expanded(
                child: _themeView(back: e.primaryDarkColor,front:e.primaryTextColor.value== e.secondaryColor.value?Colors.transparent:e.secondaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _themeView({Color back, Color front}) =>Container(
    width: double.infinity,
    color: back,
    child: Container(
     margin:  EdgeInsets.all(height/8),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: front
      ),),
  );
}
