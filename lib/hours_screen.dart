
import 'package:flutter/material.dart';
import 'package:rate_your_time_new/models/hours_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';

class HoursScreen extends StatelessWidget {
  final List<Hour> hours;

  final double average;
  HoursScreen(this.hours,this.average);

  get hoursLength =>  hours?.length??0;





  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: hoursLength==0?_emptyView():ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount:hoursLength,
            itemBuilder: (BuildContext context, int i) => HourWidget(hours[i]),
          ),
        ),
        if(average>0)_average(context)
      ],
    );
  }

  Widget _average(context) =>Row(
    // crossAxisAlignment: CrossAxisAlignment.ce,
    children: [
     const Padding(
        padding: const EdgeInsets.all(8.0),
        child: const Text('Average'),
      ),
      Expanded(
        child: LinearProgressIndicator(
          minHeight: 8,
          value: average,
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ),
      const SizedBox(height: 70,)
    ],
  );

  _emptyView() {
    return Center(child: Text('Create an empty view here....'));
  }
}




class HourWidget extends StatelessWidget {
  final Hour hour;

  HourWidget(this.hour);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:2.0,horizontal: 1.0),
      child: Card(
        elevation: hour.worth>0?1:0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 4,),
              SizedBox(
                  width: 50,
                  child: Text('${TimeUtils.parseTimeHours(hour.time)}')),
              const SizedBox(height: 42,),
              Expanded(
                child: (hour.worth>0)?LinearProgressIndicator(
                  minHeight: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
                  backgroundColor: Theme.of(context).primaryColor,
                  value: (hour.worth/5),
                ):
                  _emptyWorthCard(),
              ),
              const SizedBox(height: 4,),
              // Text("${hour.date}/${hour.month}/${hour.year}"),
              // const SizedBox(height: 4,),
            ],
          ),
        ),
      ),
    );
  }

  _emptyWorthCard() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
        // Icon(Icons.outlet),
      Icon(Icons.close),
      Text('Value not entered'),
      Icon(Icons.close),
    ],
  );

  // Color getColor(Hour hour) =>hour.worth==1?Colors.red:hour.worth==2?Colors.deepOrange:hour.worth==3?Colors.orange:hour.worth==4?Colors.yellow:Colors.green;
}
