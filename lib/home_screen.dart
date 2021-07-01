import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rate_your_time_new/alarms_screen.dart';
import 'package:rate_your_time_new/hours_screens/day_view.dart';
import 'package:rate_your_time_new/hours_screens/month_view.dart';
import 'package:rate_your_time_new/hours_screens/week_view.dart';
import 'package:rate_your_time_new/models/hours_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:rate_your_time_new/utils/shared_prefs.dart';
import 'package:rate_your_time_new/widgets/backdrop.dart';
import 'package:rate_your_time_new/widgets/page_status.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, RestorationMixin {
  HoursModel model;

  final RestorableDouble _expandingTabIndex = RestorableDouble(0);
  final RestorableDouble _tabIndex = RestorableDouble(1);
  AnimationController _controller;

  // Animation Controller for expanding/collapsing the cart menu.
  AnimationController _expandingController;

  bool firstDay = false;

  int toggle =0;

  @override
  void restoreState(RestorationBucket oldBucket, bool initialRestore) {
    registerForRestoration(_tabIndex, 'tab_index');
    registerForRestoration(
      _expandingTabIndex,
      'expanding_tab_index',
    );
    _controller.value = _tabIndex.value;
    _expandingController.value = _expandingTabIndex.value;
  }

  @override
  void dispose() {
    _controller.dispose();
    _expandingController.dispose();
    _tabIndex.dispose();
    _expandingTabIndex.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      model.calculateDatePickerHeight();
      _checkFirstDay();
    });
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
      value: 1,
    );
    // Save state restoration animation values only when the cart page
    // fully opens or closes.
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _tabIndex.value = _controller.value;
      }
    });
    _expandingController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    // Save state restoration animation values only when the menu page
    // fully opens or closes.
    _expandingController.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _expandingTabIndex.value = _expandingController.value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    model = Provider.of<HoursModel>(context);
    if (!model.loaded) model.getHours();

    return Stack(
      children: [
        backdrop(),
        SafeArea(
          child: Material(
            child: IconButton(icon: Icon(Icons.ac_unit_sharp), onPressed: (){
              if(toggle==3)toggle=1;
              else toggle++;
              setState(() {

              });
            }),
          ),
        )
      ],
    );

  }

  void pickDate() {
    showDatePicker(
            context: context,
            initialDate: model.date,
            firstDate: launchDate,
            lastDate: model.date)
        .then(model.refresh);
  }

  void gotoAlarms() {
    pushTo(context, AlarmsScreen());
  }

  Widget backdrop() {
    final theme = Theme.of(context);
    return PageStatus(
      cartController: _controller,
      menuController: _expandingController,
      child: Backdrop(
          pickDate: pickDate,
          frontLayer:toggle==1?MonthView() :toggle==2? DayViewScreen(model.hours, model.average, this.firstDay):WeekViewScreen(),
          backLayer: Container(
            height: double.infinity,
            color: theme.primaryColor,
            child: Theme(
              data: theme.copyWith(
                  colorScheme: theme.colorScheme.copyWith(
                onPrimary: theme.accentColor,
                primary: theme.primaryColorDark,
                onSurface: theme.colorScheme.onPrimary,
              )),
              child: CalendarDatePicker(
                key: model.datePickerKey,
                initialDate: model.date,
                firstDate: launchDate,
                lastDate: DateTime.now(),
                onDateChanged: (DateTime value) {
                  model.refresh(value);
                },
              ),
            ),
          ),
          frontTitle: Text("${TimeUtils.formatDate(model.date)}"),
          backTitle: Text("Select date"),
          controller: _controller),
    );
  }

  @override
  String get restorationId => 'rate_your_time_app_state';

  Future<void> _checkFirstDay() async {
    this.firstDay = await SharedPrefs.isFirstDayAtHome();
    nextTick(() {
      setState(() {});
    });
  }
}
