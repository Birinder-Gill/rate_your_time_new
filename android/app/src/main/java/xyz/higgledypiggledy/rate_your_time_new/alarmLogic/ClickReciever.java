package xyz.higgledypiggledy.rate_your_time_new.alarmLogic;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;



import java.util.Calendar;

import io.flutter.plugin.common.MethodChannel;
import xyz.higgledypiggledy.rate_your_time_new.InputScreen;
import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.Hour;
import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.source.local.ProgressDatabase;
import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.utils.AppExecutors;

public class ClickReciever extends BroadcastReceiver {

    @Override
    public void onReceive(final Context context, Intent intent) {
        int worth=intent.getIntExtra(AlarmNotificationService.CLICK_EXTRAS,0);
        int time=intent.getIntExtra(AlarmNotificationService.CLICK_TITLE,0);
        String note=intent.getStringExtra(AlarmNotificationService.CLICK_NOTES);
        Calendar c= Calendar.getInstance();
        int date= c.get(Calendar.DAY_OF_MONTH);
        int month=c.get(Calendar.MONTH);
        int year=c.get(Calendar.YEAR);
        final Hour hour=new Hour(worth,time,date,month,year,0,note);
        AppExecutors.getInstance().diskIO().execute(new Runnable() {
            @Override
            public void run() {
                ProgressDatabase.getInstance(context).dao().addHour(hour);
                AppExecutors.getInstance().mainThread().execute(new Runnable() {
                    @Override
                    public void run() {
                        AlarmNotificationService.dismissAllAlarms(context.getApplicationContext());
                        exitInputDialogIfOpen();
                    }

                    private void exitInputDialogIfOpen() {
                        Intent local = new Intent();
                        local.setAction(InputScreen.exitAction);
                        context.sendBroadcast(local);
                    }
                });
            }
        });
    }
}