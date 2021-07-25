package xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.source.local;


import android.util.Log;


import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;

import io.flutter.plugin.common.MethodChannel;
import xyz.higgledypiggledy.rate_your_time_new.MainActivity;
import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.Hour;
import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.source.DataSource;
import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.utils.AppExecutors;
import xyz.higgledypiggledy.rate_your_time_new.utils.Utils;


public class LocalDataSource implements DataSource {


    private static LocalDataSource INSTANCE;
    private final ProgressDao dao;
    private final AppExecutors executors;

    private LocalDataSource(ProgressDao dao, AppExecutors diskIO) {
        this.dao = dao;
        this.executors = diskIO;
    }

    public static LocalDataSource getInstance(ProgressDao dao, AppExecutors diskIO) {
        if (INSTANCE == null) {
            synchronized (LocalDataSource.class) {
                if (INSTANCE == null) {
                    INSTANCE = new LocalDataSource(dao, diskIO);
                }
            }
        }
        return INSTANCE;
    }

    private static final String TAG = "LocalDataSource";

    @Override
    public void getDataFor(final int day, final int month, final int year, final LoadProgressCallback callback) {

        executors.diskIO().execute(new Runnable() {
            @Override
            public void run() {
                ArrayList<HashMap<String, Object>> finalList = getHoursFor(day, month, year);
                executors.mainThread().execute(new Runnable() {
                    @Override
                    public void run() {
                        callback.onProgressLoaded(finalList);

                    }
                });
            }
        });

    }

    ArrayList<HashMap<String, Object>> getHoursFor(int day, int month, int year) {
        List<Hour> list = (dao.getDataFor(day, month, year));
        final ArrayList<HashMap<String, Object>> finalList = new ArrayList<>();
        int tempTime = 7;//TODO:: WAKE UP HOUR HERE
        for (Hour h : list) {
            int time = h.getTime();
            //FILL THE MISSING HOURS VALUE THAT WERE NOT ENTERED BY THE USER
            while (tempTime < time) {
                finalList.add(new Hour(0, tempTime, day, month, year, 0, "").toMap());
                tempTime++;
            }
            finalList.add(h.toMap());
            tempTime++;
        }
        Calendar now = Calendar.getInstance();

        ///IF THE USER FETCHING HOURS OF A PREVIOUS DATE, WE SHOULD SHOW DATA FROM WAKE UP TO SLEEP TIME.
        /// IF USER'S LAST RATING WAS SOME HOURS BEFORE SLEEP TIME, IT FILLS THOSE HOURS WITH 0s
        if ((!finalList.isEmpty()) && (now.get(Calendar.MONTH) == month) && (now.get(Calendar.YEAR) == year) && (now.get(Calendar.DATE) > day)) {
            int lastHour = (int) finalList.get(finalList.size() - 1).get("time");
            while (lastHour != MainActivity.LAST_HOUR) {
                finalList.add(new Hour(0, lastHour, day, month, year, 0, "").toMap());
                lastHour++;
            }
        }
        Log.d(TAG, "getHoursFor() called with: day = [" + day + "], month = [" + month + "], year = [" + year + "]");
        return finalList;
    }

    @Override
    public void getRangeDataFor(int day1, int month1, int year1, int day2, int month2, int year2, RangeProgressCallback callback) {

        executors.diskIO().execute(() -> {
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
            executors.mainThread().execute(() -> callback.onRangeProgressLoaded(map));
        });


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
        executors.diskIO().execute(new Runnable() {
            @Override
            public void run() {
                dao.updateHour(id,activity,note);
                AppExecutors.getInstance().mainThread().execute(new Runnable() {
                    @Override
                    public void run() {
                        result.success(true);
                    }
                });
            }
        });
    }
}
