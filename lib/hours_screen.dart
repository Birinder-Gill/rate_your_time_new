
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

  Widget _average(context) =>Material(
    elevation: 4,
    color: Theme.of(context).primaryColorDark,
    child: Row(
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
    ),
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
  final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:2.0,horizontal: 1.0),
      child: Card(
        color: hour.worth>0?theme.cardColor:theme.scaffoldBackgroundColor,
        borderOnForeground:hour.worth==0,
        elevation: hour.worth>0?1:0,
        child: Container(
          decoration: BoxDecoration(
            border: hour.worth>0?null:Border.all(color: theme.primaryColorDark),
                borderRadius: BorderRadius.all(Radius.circular(4))
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 4,),
                SizedBox(
                    width: 50,
                    child: Text('${TimeUtils.parseTimeHours(hour.time)}',style: TextStyle(color: theme.textTheme.bodyText2.color.withOpacity(hour.worth>0?1:.5)),)),
                const SizedBox(height: 42,),
                Expanded(
                  child: (hour.worth>0)?LinearProgressIndicator(
                    minHeight: 4,
                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
                    backgroundColor: Theme.of(context).primaryColorDark,
                    value: (hour.worth/5),
                  ):
                    _emptyWorthCard(theme),
                ),
                const SizedBox(height: 4,),
                // Text("${hour.date}/${hour.month}/${hour.year}"),
                // const SizedBox(height: 4,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _emptyWorthCard(ThemeData theme) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
        // Icon(Icons.outlet),
      Icon(Icons.close,color: theme.primaryColorDark,),
      Text('Value not entered',style: TextStyle(color: theme.primaryColorDark),),
      Icon(Icons.close,color: theme.primaryColorDark),
    ],
  );

  // Color getColor(Hour hour) =>hour.worth==1?Colors.red:hour.worth==2?Colors.deepOrange:hour.worth==3?Colors.orange:hour.worth==4?Colors.yellow:Colors.green;
}
