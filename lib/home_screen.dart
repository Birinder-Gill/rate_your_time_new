import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rate_your_time_new/alarms_screen.dart';
import 'package:rate_your_time_new/hours_screens/day_view.dart';
import 'package:rate_your_time_new/hours_screens/month_view.dart';
import 'package:rate_your_time_new/hours_screens/week_view.dart';
import 'package:rate_your_time_new/models/hours_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:rate_your_time_new/utils/shared_prefs.dart';
import 'package:rate_your_time_new/widgets/backdrop.dart';
import 'file:///C:/Users/Birinder/AndroidStudioProjects/rate_your_time_new/lib/widgets/date_pickers/date_picker_widget.dart';
import 'package:rate_your_time_new/widgets/page_status.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, RestorationMixin {
  AppModel model;

  final RestorableDouble _expandingTabIndex = RestorableDouble(0);
  final RestorableDouble _tabIndex = RestorableDouble(1);
  

  // bool firstDay = false;

  DateTime launchDate;

  @override
  void restoreState(RestorationBucket oldBucket, bool initialRestore) {
    registerForRestoration(_tabIndex, 'tab_index');
    registerForRestoration(
      _expandingTabIndex,
      'expanding_tab_index',
    );
    model.animController.value = _tabIndex.value;
    model.expandingController.value = _expandingTabIndex.value;
  }

  @override
  void dispose() {
    // model.animController.dispose();
    model.expandingController.dispose();
    _tabIndex.dispose();
    _expandingTabIndex.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    model = Provider.of<AppModel>(context,listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _checkFirstDay();
    });
    model.animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
      value: 1,
    );

    model.animController.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _tabIndex.value = model.animController.value;
      }
    });
    model.expandingController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    // Save state restoration animation values only when the menu page
    // fully opens or closes.
    model.expandingController.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _expandingTabIndex.value = model.expandingController.value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    model = Provider.of<AppModel>(context);
    return backdrop();
  }

  void gotoAlarms() {
    pushTo(context, AlarmsScreen());
  }

  Widget backdrop() {
    return PageStatus(
      cartController: model.animController,
      menuController: model.expandingController,
      child: Backdrop(
          frontLayer: _getFrontLayer(model.toggle),
          backLayer: DatePickerWidget(
            firstDate: launchDate ?? DateTime(1900),
          ),
          frontTitle: Text(model.frontLabel(MaterialLocalizations.of(context))),
          backTitle: Text("Select date"),
          controller: model.animController),
    );
  }

  @override
  String get restorationId => 'rate_your_time_app_state';

  Future<void> _checkFirstDay() async {
    launchDate = await SharedPrefs.checkInstallDate();

    // this.firstDay = DateUtils.isSameDay(launchDate, DateTime.now());
    nextTick(() {
      setState(() {});
    });
  }

  Widget _getFrontLayer(int toggle) {
    switch (toggle) {
      case 0:
        return DayViewWrapper(/*this.firstDay*/);
      case 1:
        return WeekViewWrapper(/*this.firstDay*/);
      default:
        return MonthViewWrapper(/*this.firstDay*/);
    }
  }
}
