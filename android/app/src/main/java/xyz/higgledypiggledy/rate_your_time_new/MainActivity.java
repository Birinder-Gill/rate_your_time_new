package xyz.higgledypiggledy.rate_your_time_new;

import android.app.AppOpsManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;
import android.util.Log;

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
import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.utils.AppExecutors;
import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.utils.Injection;

public class MainActivity extends FlutterActivity {

    private static final String TAG = "MainActivity";
    public static final int LAST_HOUR = 22;
    private static final String SHARED_PREFERENCES_NAME = "rateYourTimePrefs";


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

    public String getStringVal(String key) {
        return getApplicationContext().getSharedPreferences(SHARED_PREFERENCES_NAME, Context.MODE_PRIVATE).getString(key, "0");
    }

    public void setStringVal(String key, String value, final MethodChannel.Result result) {
        AppExecutors.getInstance().diskIO().execute(new Runnable() {
            @Override
            public void run() {
                final boolean success = getApplicationContext().getSharedPreferences(SHARED_PREFERENCES_NAME, Context.MODE_PRIVATE).edit().putString(key, value).commit();
                AppExecutors.getInstance().mainThread().execute(new Runnable() {
                    @Override
                    public void run() {
                        result.success(success);
                    }
                });
            }
        });
    }


    boolean test = true;

    public void createAlarms(int wake, int sleep) {
        for (int i = wake + 1; i <= sleep; i++) {
            final Calendar c = Calendar.getInstance();
            final int secondsPastMidnight = 5 +
                    i * 3600 +
                    ((test ? (c.get(Calendar.MINUTE) + 1) : 0) * 60);//TODO:SET MINUTES TO ZERO
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
                case "getDayData": {
//                    boolean testFlag = call.argument("test")!=null&& ((int)call.argument("test")) == 1;
                    Injection.provideRepository(getApplicationContext()).getDataFor(call.argument("date"), call.argument("month"), call.argument("year"), result::success);
                    return;
                }
                case "getRangeHours": {
                    Log.i(TAG, "configureFlutterEngine: "+call.arguments());
//                    boolean testFlag = call.argument("test")!=null&& ((int)call.argument("test")) == 1;
                    Injection.provideRepository(getApplicationContext()).getRangeDataFor(call.argument("d1"), call.argument("m1"), call.argument("y1"), call.argument("d2"), call.argument("m2"), call.argument("y2"), result::success);
                    return;
                }

                case "getWeekData": {
                    Calendar cal = Calendar.getInstance();
                    cal.set(call.argument("year"), call.argument("month"), call.argument("date"));
//                    boolean testFlag = call.argument("test")!=null&& ((int)call.argument("test")) == 1;
                    Injection.provideRepository(getApplicationContext()).getWeekData(cal, result::success);
                    return;
                }

                case "getMonthData": {
                    Calendar cal = Calendar.getInstance();
                    cal.set(call.argument("year"), call.argument("month"), call.argument("date"));
//                    boolean testFlag = call.argument("test")!=null&& ((int)call.argument("test")) == 1;
                    Injection.provideRepository(getApplicationContext()).getMonthData(cal, result::success);
                    return;
                }

                case "addAlarms": {
                    createAlarms(call.argument("wHour"), call.argument("sHour"));
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
//                        boolean testFlag = call.argument("test")!=null&& ((int)call.argument("test")) == 1;
                        Injection.provideRepository(getApplicationContext()).getRunningApps(getApplicationContext(), call.argument("d1"), call.argument("m1"), call.argument("y1"), call.argument("d2"), call.argument("m2"), call.argument("y2"), result::success);
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
                case "openNotificationSettings": {
                    openNotificationSettings();
                    return;
                }


                case "isAccessGranted": {
                    //TODO:CHECK SOMETHING FOR OLDER VERSIONS MAYBE HIDE STATS SCREEN IF ANDROID VERSION IS OLDER
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                        result.success(isUsageAccessGranted());
                    }
                    return;
                }
                case "getString": {
                    result.success(getStringVal(call.argument("key")));
                    return;
                }
                case "setString": {
                    setStringVal(call.argument("key"), call.argument("value"), result);
                    return;
                }
                case "updateHour": {
                    updateHour(call.argument("id"), call.argument("activity"), call.argument("note"), result);
                    return;
                }


            }
        });
    }

    private void updateHour(int id, int activity, String note, MethodChannel.Result result) {
        Injection.provideRepository(getApplicationContext()).updateHour(id, activity, note, result);

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


    void openNotificationSettings(){
        Intent intent = new Intent();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            intent.setAction(Settings.ACTION_APP_NOTIFICATION_SETTINGS);
            intent.putExtra(Settings.EXTRA_APP_PACKAGE, getPackageName());
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP){
            intent.setAction("android.settings.APP_NOTIFICATION_SETTINGS");
            intent.putExtra("app_package", getPackageName());
            intent.putExtra("app_uid", getApplicationInfo().uid);
        } else {
            intent.setAction(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
            intent.addCategory(Intent.CATEGORY_DEFAULT);
            intent.setData(Uri.parse("package:" + getPackageName()));
        }
        startActivity(intent);
    }

}


