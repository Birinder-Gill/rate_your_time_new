package xyz.higgledypiggledy.rate_your_time_new;

import android.app.AppOpsManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.os.Build;
import android.provider.Settings;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.LinkedList;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.AlarmClockProvider;
import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.AlarmNotificationService;
import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.TimeUtil;
import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.utils.Injection;

public class MainActivity extends FlutterActivity {


    public static final int LAST_HOUR = 22;

    ArrayList<HashMap<String, Object>> loadAlarms() {
        Cursor data = getContentResolver().query(AlarmClockProvider.ALARMS_URI,
                new String[]{
                        AlarmClockProvider.AlarmEntry._ID,
                        AlarmClockProvider.AlarmEntry.TIME,
                        AlarmClockProvider.AlarmEntry.ENABLED,
                        AlarmClockProvider.AlarmEntry.NAME,
                        AlarmClockProvider.AlarmEntry.DAY_OF_WEEK,
                        AlarmClockProvider.AlarmEntry.NEXT_SNOOZE},
                null, null, AlarmClockProvider.AlarmEntry.TIME + " ASC");
        ArrayList<HashMap<String, Object>> list = new ArrayList<>();
        if (data.moveToFirst())
            do {
                HashMap<String, Object> map = new HashMap<>();
                int time = data.getInt(1);
                int repeat = data.getInt(4);
                final Calendar next =
                        TimeUtil.nextOccurrence(time, repeat);
                map.put("time", TimeUtil.formatLong(getApplicationContext(), next));
                map.put("enabled", data.getInt(2));
                map.put("repeat", TimeUtil.repeatString(getApplicationContext(), repeat));
                list.add(map);

            }
            while (data.moveToNext());
        return list;

    }


    public void createAlarms() {
        for (int i = 7; i <= MainActivity.LAST_HOUR; i++) {
            final Calendar c = Calendar.getInstance();
            final int secondsPastMidnight = 5 +
                    i * 3600 +
                    ((c.get(Calendar.MINUTE) + 1) * 60);
            AlarmNotificationService.newAlarm(
                    getApplicationContext(), secondsPastMidnight);
        }
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        MethodChannel channel = new MethodChannel(flutterEngine.getDartExecutor(), "name");
        channel.setMethodCallHandler((call, result) -> {
            switch (call.method) {
                case "getHours": {
                    Calendar cal = Calendar.getInstance();
                    Injection.provideRepository(getApplicationContext()).getDataFor(call.argument("date"), call.argument("month"),call.argument("year"), result::success);
                    return;
                }
                case "getRangeHours": {
                    Calendar cal = Calendar.getInstance();
                    Injection.provideRepository(getApplicationContext()).getDataFor(cal.get(Calendar.DATE), cal.get(Calendar.MONTH) - 1, cal.get(Calendar.YEAR), cal.get(Calendar.DATE), cal.get(Calendar.MONTH), cal.get(Calendar.YEAR), result::success);
                    return;
                }

                case "addAlarms": {
                    createAlarms();
                    result.success("Alarms created...probably");
                    return;
                }
                case "getAlarms": {
                    result.success(loadAlarms());
                    return;
                }
                case "deleteAlarms": {
                    deleteAllAlarms();
                    result.success("Alarms deleted");
                    return;
                }
                case "getApps": {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1) {
                        UsageTracker.getRunningApps(getApplicationContext(),result::success);


                    }
                    return;
                }
                case "openSettings": {
                    Intent intent = null;
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                        intent = new Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS);
                    }
                    startActivity(intent);
                    return;
                }
                case "isAccessGranted": {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                        result.success(isUsageAccessGranted());
                    }
                    return;
                }

            }
        });
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    private boolean isUsageAccessGranted() {
        try {
            PackageManager packageManager = getPackageManager();
            ApplicationInfo applicationInfo = packageManager.getApplicationInfo(getPackageName(), 0);
            AppOpsManager appOpsManager = (AppOpsManager) getSystemService(Context.APP_OPS_SERVICE);
            int mode = 0;
            if (android.os.Build.VERSION.SDK_INT > android.os.Build.VERSION_CODES.KITKAT) {
                mode = appOpsManager.checkOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS,
                        applicationInfo.uid, applicationInfo.packageName);
            }
            return (mode == AppOpsManager.MODE_ALLOWED);

        } catch (PackageManager.NameNotFoundException e) {
            return false;
        }
    }

    void deleteAllAlarms() {
        LinkedList<Long> ids = new LinkedList<Long>();
        Cursor c = getContext().getContentResolver().query(
                AlarmClockProvider.ALARMS_URI,
                new String[]{AlarmClockProvider.AlarmEntry._ID},
                AlarmClockProvider.AlarmEntry.ENABLED + " == 1",
                null, null);
        while (c.moveToNext())
            ids.add(c.getLong(c.getColumnIndex(
                    AlarmClockProvider.AlarmEntry._ID)));
        c.close();
        // Delete the entire alarm table.
        getContext().getContentResolver().delete(
                AlarmClockProvider.ALARMS_URI, null, null);
        // Unschedule any alarms that were active.
        for (long id : ids)
            AlarmNotificationService.removeAlarmTrigger(
                    getContext(), id);
    }

}


