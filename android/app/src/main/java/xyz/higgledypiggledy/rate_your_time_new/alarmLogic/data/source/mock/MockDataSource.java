package xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.source.mock;

import android.content.Context;
import android.os.Build;
import android.util.Log;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Random;
import java.util.concurrent.ThreadLocalRandom;

import io.flutter.plugin.common.MethodChannel;
import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.Hour;
import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.source.DataSource;
import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.source.local.LocalDataSource;
import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.utils.AppExecutors;
import xyz.higgledypiggledy.rate_your_time_new.utils.Utils;

public class MockDataSource implements DataSource {


    private static MockDataSource INSTANCE;
    private final String[] mockApps = new String[]{"Instagram","Facebook","Snapchat","Twitter","9Gag","Clash of clans","PUBG","Camera","Calendar","Rate your time"};

    public static MockDataSource getInstance() {
        if (INSTANCE == null) {
            synchronized (MockDataSource.class) {
                if (INSTANCE == null) {
                    INSTANCE = new MockDataSource();
                }
            }
        }
        return INSTANCE;
    }

    @Override
    public void getDataFor(int day, int month, int year, LoadProgressCallback callback) {
        callback.onProgressLoaded(getHoursFor(day, month, year));
    }

    @Override
    public void getRangeDataFor(int day1, int month1, int year1, int day2, int month2, int year2, RangeProgressCallback callback) {
        HashMap<String, ArrayList<HashMap<String, Object>>> map = new HashMap<>();
        Calendar c1 = Calendar.getInstance();
        c1.set(year1, month1, day1);
        Calendar c2 = Calendar.getInstance();
        c2.set(year2, month2, day2);
        Log.d(TAG, "getDataFor() called with: day1 = [" + day1 + "], month1 = [" + month1 + "], year1 = [" + year1 + "], day2 = [" + day2 + "], month2 = [" + month2 + "], year2 = [" + year2 + "], callback = [" + callback + "]");

        while (!c1.after(c2)) {
            int d = c1.get(Calendar.DATE);
            int m = c1.get(Calendar.MONTH);
            int y = c1.get(Calendar.YEAR);
            ArrayList<HashMap<String, Object>> list = getHoursFor(d, m, y);
            map.put(y + "-" + m + "-" + d, list);
            c1.add(Calendar.DATE, 1);
        }
        callback.onRangeProgressLoaded(map);

    }


    @Override
    public void getWeekData(Calendar c2, RangeProgressCallback success) {
        Calendar c1 = Utils.getMondayFor(c2);
        getRangeDataFor(c1.get(Calendar.DATE), c1.get(Calendar.MONTH), c1.get(Calendar.YEAR), c2.get(Calendar.DATE), c2.get(Calendar.MONTH), c2.get(Calendar.YEAR), success);
    }

    @Override
    public void getMonthData(Calendar c2, RangeProgressCallback success) {
        Calendar c1 = Utils.getFirstDateFor(c2);
        getRangeDataFor(c1.get(Calendar.DATE), c1.get(Calendar.MONTH), c1.get(Calendar.YEAR), c2.get(Calendar.DATE), c2.get(Calendar.MONTH), c2.get(Calendar.YEAR), success);
    }

    @Override
    public void updateHour(int id, int activity, String note,int worth, MethodChannel.Result result) {
        Log.d(TAG, "updateHour() called with: id = [" + id + "], activity = [" + activity + "], note = [" + note + "], worth = [" + worth + "], result = [" + result + "]");
    }

    @Override
    public void addHour(Hour hour, MethodChannel.Result result) {
        Log.d(TAG, "addHour() called with: hour = [" + hour + "], result = [" + result + "]");
    }

    @Override
    public void getRunningApps(Context context, int d1, int m1, int y1, int d2, int m2, int y2, LoadProgressCallback callback) {
        ArrayList<HashMap<String, Object>> result = new ArrayList<>();
        for (String u:mockApps) {

            int max = m2<m1?100:d2-d1;
            int random=0;
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
                random = ThreadLocalRandom.current().nextInt(1, max *1000*3600 + 1);
            }

            final HashMap<String, Object> map = new HashMap<>();
            map.put("package", "android.package."+u);
            map.put("firstTimeStamp", random);
            map.put("LastTimeStamp", random);
            map.put("LastTimeUsed", random);
            map.put("TotalTimeInForeground", random);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                map.put("TotalTimeVisible", random);
            }
            map.put("appName", u);
            map.put("appLogo", "");
                result.add(map);
            }
        AppExecutors.getInstance().mainThread().execute(new Runnable() {
            @Override
            public void run() {
                callback.onProgressLoaded(result);
            }
        });
        }

    @Override
    public void isTableEmpty(CheckFirstTimeCallback callback) {
        callback.checkFirstTime(true);
    }


    private static final String TAG = "MockDataSource";

    ArrayList<HashMap<String, Object>> getHoursFor(int day, int month, int year) {
        final ArrayList<HashMap<String, Object>> finalList = new ArrayList<>();
        Random random = new Random();
        Calendar now = Calendar.getInstance();
        now.set(now.get(Calendar.YEAR),now.get(Calendar.MONTH),now.get(Calendar.DATE),0,0,0);
        Calendar checkWith = Calendar.getInstance();
        checkWith.set(year,month,day,0,0,0);
        int lastTime = now.getTimeInMillis()>checkWith.getTimeInMillis() ? 22 : Calendar.getInstance().get(Calendar.HOUR_OF_DAY);
        Log.i(TAG, "getHoursFor: LAST TIME  = "+lastTime);
        for (int i = 7; i < lastTime; i++) {
            finalList.add(new Hour(finalList.size()+1,random.nextInt(4) + 1, i, day, month, year, random.nextInt(15), "").toMap());
        }
        return finalList;
    }

}
