package xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.source.mock;

import android.util.Log;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Random;

import io.flutter.plugin.common.MethodChannel;
import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.Hour;
import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.source.DataSource;
import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.source.local.LocalDataSource;
import xyz.higgledypiggledy.rate_your_time_new.utils.Utils;

public class MockDataSource implements DataSource {


    private static MockDataSource INSTANCE;

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
    public void updateHour(int id, int activity, String note, MethodChannel.Result result) {
        Log.d(TAG, "updateHour() called with: id = [" + id + "], activity = [" + activity + "], note = [" + note + "], result = [" + result + "]");
    }

    private static final String TAG = "MockDataSource";

    ArrayList<HashMap<String, Object>> getHoursFor(int day, int month, int year) {
        final ArrayList<HashMap<String, Object>> finalList = new ArrayList<>();
        Random random = new Random();
        Calendar now = Calendar.getInstance();
        int lastTime = ((now.get(Calendar.MONTH) >= month) && (now.get(Calendar.YEAR) >= year) && (now.get(Calendar.DATE) > day) ? 22 : now.get(Calendar.HOUR_OF_DAY));
        for (int i = 7; i < lastTime; i++) {
            finalList.add(new Hour(finalList.size()+1,random.nextInt(4) + 1, i, day, month, year, random.nextInt(15), "").toMap());
        }
        return finalList;
    }

}
