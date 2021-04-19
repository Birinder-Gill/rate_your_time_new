import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rate_your_time_new/home_screen.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:rate_your_time_new/utils/shared_prefs.dart';

class SelectTimeScreen extends StatefulWidget {
  @override
  _SelectTimeScreenState createState() => _SelectTimeScreenState();
}

class _SelectTimeScreenState extends State<SelectTimeScreen> {
  TimeOfDay initTime;

  final _wC = TextEditingController();

  final _formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      // appBar: AppBar(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _savePrefs,
        label: Text('Next'),
        icon: Icon(Icons.arrow_forward),
      ),
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Welcome! Tell us a little about your time.",style: theme.textTheme.headline3.copyWith(height: 1.2),),
                SizedBox(height: 52,),
                Text(
                  "What time do you wake up at:",
                  style: theme.textTheme.headline6,
                ),
                SizedBox(height: 8,),

               _pickTime(),
                SizedBox(height: 100,),
                Text(
                  "You go to sleep at:",
                  style: theme.textTheme.headline6,
                ),
                SizedBox(height: 8,),
                _pickTime(),
                SizedBox(height: 24,),
                Text("Great! Lets move forward.")

              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _savePrefs() async {

    if(_formKey.currentState.validate()) {
      //TODO: SET WAKEUP HOUR AND SLEEP HOUR VALUES
      final int wHour=0;
      final int sHour=0;
      await SharedPrefs.setInt(SharedPrefs.wakeUpHour, wHour);
      await SharedPrefs.setInt(SharedPrefs.sleepHour, sHour);
      pushTo(context, HomeScreen(), clear: true);
    }
  }

  Widget _pickTime() => InkWell(
      onTap: () async {
        initTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(DateTime.now()),
            initialEntryMode: TimePickerEntryMode.input,confirmText: "OK",helpText: "Pick an approx time when you wake up");
        setState(() {});
        _wC.text
        =initTime.format(context);
      },
      child: IgnorePointer(
          ignoring: true,
          child: TextFormField(
            validator: (e)=>e.isEmpty?"Select Wakeup time":null,
            decoration: InputDecoration(hintText: "Select a time",
            prefixIcon: Icon(Icons.access_time)),

            controller: _wC,
          )));
}
