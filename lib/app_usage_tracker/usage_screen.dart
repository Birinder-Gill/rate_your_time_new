import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rate_your_time_new/app_usage_tracker/stat_model.dart';
import 'package:rate_your_time_new/providers/app_usage_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:rate_your_time_new/utils/usage_interval_info_dialog.dart';
import 'package:rate_your_time_new/widgets/graphs/pie%20chart.dart';

class AppsUsageScreen extends StatefulWidget {
  final DateTime? from;
  final DateTime? to;
  final List<UsageStat>? distinctApps;

  final String? dateRangeLabel;

  const AppsUsageScreen(
      {Key? key, this.from, this.to, this.distinctApps, this.dateRangeLabel})
      : super(key: key);

  @override
  _AppsUsageScreenState createState() => _AppsUsageScreenState();
}

class _AppsUsageScreenState extends State<AppsUsageScreen>
    with WidgetsBindingObserver {
  List<UsageStat> apps = [];

  bool _granted = false;

  var search = '';

  bool loading = false;

  List<UsageStat> distinctApps = [];

  var error = false;

 late DateTime to, from;

  Map<int, int> catMap = {};

  String label = '';

  double get sum =>
      sumOf<UsageStat>(distinctApps, (e) => e.totalTimeInForeground??0);

  get granted => ((_granted));

  Color get primaryDark => Theme.of(context).primaryColorDark;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        if (_granted == false) {
          isAccessGranted();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      default:
        break;

    }
  }

  getApps({bool forceReload = true}) async {
    setState(() {
      loading = true;
    });
    try {
      if (forceReload) {
        final model = AppUsageModel();
        await model.getApps(begin: from, end: to);
        distinctApps = model.distinctApps;
        catMap = model.catMap;
        label = model.label;
      } else {
        distinctApps = widget.distinctApps??[];
        catMap = AppUsageModel.makeCatMap(distinctApps);
        label = widget.dateRangeLabel ?? '';
      }
    } catch (e) {
      error = true;
    }
    setState(() {
      loading = false;
    });
  }

  openSettings() {
    Utils.openUsageSettingsScreen();
  }

  @override
  void initState() {
    to = DateUtils.dateOnly(widget.to ?? DateTime.now());
    from = widget.from ?? to.subtract(Duration(days: 1));
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      isAccessGranted();
    });
    super.initState();
  }

  Future<void> isAccessGranted() async {
    _granted = await Utils.isUsageAccessGranted();
    if (_granted) {
      getApps(forceReload: false);
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final theme = themeData.textTheme;
    // _granted = false;
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (granted)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextButton.icon(
                onPressed: pickFromDate,
                label: Text(
                  "${_label(from)} - ${_label(to)}",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: themeData.colorScheme.secondary),
                ),
                icon: Icon(Icons.edit, size: 16, color: themeData.colorScheme.secondary),
              ),
            ),
        ],
      ),
      body: !granted
          ? gotoSettingsView()
          : loading
              ? simpleLoader()
              : error
                  ? _errorView()
                  : Scrollbar(
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: Material(
                              elevation: 12,
                              color: themeData.primaryColorDark,
                              // borderRadius:
                              //     BorderRadius.all(Radius.circular(12)),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showIntervalInfoDialog(context, label);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Total screen time ($label)",
                                          textAlign: TextAlign.center,
                                          style: theme.titleMedium!.copyWith(
                                              color: themeData
                                                  .colorScheme.onSecondary),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Icon(
                                          Icons.info_sharp,
                                          size: 12,
                                          color:
                                              themeData.colorScheme.secondary,
                                        )
                                      ],
                                    ),
                                  ),
                                  // Divider(),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        TimeUtils.convertMillsToTime(sum),
                                        textAlign: TextAlign.center,
                                        style: theme.displaySmall?.copyWith(
                                            color: themeData
                                                .colorScheme.onSecondary),
                                      ),
                                      IconButton(
                                        iconSize: 36,
                                        icon: Icon(
                                          Icons.refresh,
                                          color: Theme.of(context).colorScheme.secondary,
                                        ),
                                        onPressed: getApps,
                                        // mini: true,
                                        // backgroundColor:
                                        //     Theme.of(context).accentColor,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 24,
                                  )
                                ],
                              ),
                            ),
                          ),
                          _mostUsedApps(themeData),
                          _categoryGraph(themeData),
                          Center(child: _subTitle('All apps', themeData)),
                          for (UsageStat i in distinctApps)
                            if ((i.package?.contains(search)??false) ||
                                i.appName.contains(search))
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 4),
                                child: Card(
                                  elevation: 1,
                                  child: ListTile(
                                    onTap: () {
                                      final lastDateUsed =
                                          DateTime.fromMillisecondsSinceEpoch(
                                              i.lastTimeUsed??0);
                                      final lastTimeUsed =
                                          TimeOfDay.fromDateTime(lastDateUsed);
                                      final lastDateStamp =
                                          DateTime.fromMillisecondsSinceEpoch(
                                              i.lastTimeStamp??0);
                                      final lastTimeStamp =
                                          TimeOfDay.fromDateTime(lastDateStamp);
                                      final loc =
                                          MaterialLocalizations.of(context);
                                      showCupertinoModalPopup(
                                          context: context,
                                          builder: (c) => SimpleDialog(
                                                titlePadding: EdgeInsets.zero,
                                                title: ListTile(
                                                  title: Text('${i.appName}'),
                                                  subtitle: Text(i.package??"-/-"),
                                                  leading: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child:i.appLogo==null?
                                                        Image.memory(i.appLogo!):ErrorWidget(Exception("Image logo not found")),
                                                  ),
                                                ),
                                                children: [
                                                  ListTile(
                                                    title: Text("Category"),
                                                    subtitle: Text(
                                                        "${TimeSpent.cats[i.category]}"),
                                                  ),
                                                  ListTile(
                                                    title:
                                                        Text("Last timestamp"),
                                                    subtitle: Text(
                                                        '${loc.formatShortDate(lastDateStamp)} ${loc.formatTimeOfDay(lastTimeStamp)}'),
                                                  ),
                                                  ListTile(
                                                    title: Text(
                                                        "Total time visible"),
                                                    subtitle: Text(
                                                      TimeUtils
                                                          .convertMillsToTime(i
                                                              .totalTimeVisible??0),
                                                    ),
                                                  ),
                                                  ListTile(
                                                    title: Text(
                                                        "Total time in foreground"),
                                                    subtitle: Text(
                                                      TimeUtils.convertMillsToTime(
                                                          i.totalTimeInForeground??0),
                                                    ),
                                                  ),
                                                  ListTile(
                                                    title:
                                                        Text("Last time used"),
                                                    subtitle: Text(
                                                        '${loc.formatShortDate(lastDateUsed)} ${loc.formatTimeOfDay(lastTimeUsed)}'),
                                                  )
                                                ],
                                              ));
                                    },
                                    trailing: Text(
                                      TimeUtils.convertMillsToTime(
                                        i.totalTimeInForeground??0,
                                      ),
                                      style: theme.bodyLarge?.copyWith(
                                          color: themeData.colorScheme.secondary),
                                    ),
                                    title: Text(
                                      "${i.appName}",
                                      style: theme.titleLarge,
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: LinearProgressIndicator(
                                        value: (i.totalTimeInForeground??0) /
                                            (distinctApps[0]
                                                .totalTimeInForeground??0),
                                        minHeight: 8,
                                        valueColor:
                                            AlwaysStoppedAnimation(primaryDark),
                                        backgroundColor:
                                            themeData.scaffoldBackgroundColor,
                                      ),
                                    ),
                                    leading: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.memory(i.appLogo!,errorBuilder: (c,o,e)=>SizedBox.shrink(),
                                    ),
                                    // horizontalTitleGap: 0,
                                  ),
                                ),
                              ),
                              )],
                      ),
                    ),
    );
  }

  gotoSettingsView() {
    return _OpenSettingsView(
      openSettings: openSettings,
    );
  }

  _errorView() => Center(child: Text("An error occurred"));

  String _label(DateTime date) => MaterialLocalizations.of(context).formatShortMonthDay(date);

  void pickFromDate() {
    final theme = Theme.of(context);
    final c = Theme.of(context).colorScheme;
    final lastDate = DateTime.now();
    if (to.isAfter(lastDate)) {
      to = lastDate;
    }
    showDateRangePicker(
            builder: (context, child) => Theme(
                data: theme.copyWith(
                    colorScheme: c.copyWith(
                        onSurface: c.secondaryContainer,
                        primary: c.primaryContainer,
                        brightness: Brightness.light,
                        onPrimary: c.onSecondary,
                        onSecondary: c.onPrimary)),
                child: child??SizedBox.shrink()),
            context: context,
            initialDateRange: DateTimeRange(start: from, end: to),
            firstDate: DateTime(2018),
            lastDate: lastDate)
        .then((value) {
      if (value != null) {
        if (value.start != from || value.end != to) {
          from = value.start;
          to = value.end;
          getApps();
        }
      }
    });
  }

  Widget _mostUsedApps(ThemeData themeData) {
    if ((distinctApps.length) < 4) {
      return SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _subTitle('Most used apps', themeData, showDivider: false),
          for (final e in [0, 1])
            Row(
              children: [
                for (final i in [0, 1])
                  Expanded(
                    child: Material(
                      elevation: 4,
                      child: ListTile(
                          leading: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.memory(
                                distinctApps[int.parse('$e$i', radix: 2)]
                                    .appLogo!,errorBuilder: (c,o,e)=>SizedBox.shrink(),),
                          ),
                          title: Text(
                            TimeUtils.convertMillsToTime(
                              distinctApps[int.parse('$e$i', radix: 2)]
                                  .totalTimeInForeground??0,
                            ),
                            style: themeData.textTheme.bodyLarge!.copyWith(color: themeData.colorScheme.secondary),
                          )),
                    ),
                  )
              ],
            ),
        ],
      ),
    );
  }

  Widget _categoryGraph(ThemeData themeData) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _subTitle("Categories", themeData),
          SizedBox(
              height: 200, child: DatumLegendWithMeasures.withCatData(catMap)),
        ],
      ),
    );
  }

  Widget _subTitle(String s, ThemeData theme, {bool showDivider = true}) =>
      Column(
        children: [
          if (showDivider) const Divider(),
          Text(
            s,
            style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold, color: theme.primaryColorDark),
          ),
          const SizedBox(
            height: 8,
          )
        ],
      );
}

class _OpenSettingsView extends StatelessWidget {
  final VoidCallback openSettings;

  const _OpenSettingsView({Key? key, required this.openSettings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "This app needs Android's usage access permission to get your app usage stats.",
                  style: tt.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTap: openSettings,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                              image: AssetImage(
                                'assets/images/settings_asset.jpg',
                              ),
                              fit: BoxFit.cover)),
                      height: 200,
                    ),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                FaIcon(
                  FontAwesomeIcons.handPointUp,
                  size: 32,
                  color: tt.primaryColorDark,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "In your device's usage access settings, Turn on \"${Constants.appName}\" to access this feature.",
                    style: tt.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            ElevatedButton(
                onPressed: openSettings, child: Text("Open usage settings")),
            SizedBox.shrink(),
            SizedBox.shrink(),
            SizedBox.shrink(),
            SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
// app usage, apps monitor data manager, stay free, usage analyser
