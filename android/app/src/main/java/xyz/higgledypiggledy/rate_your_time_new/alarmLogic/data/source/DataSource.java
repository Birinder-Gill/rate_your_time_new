package xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.source;




import android.content.Context;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;

import io.flutter.plugin.common.MethodChannel;
import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.Hour;


public interface DataSource
{
    
    interface LoadProgressCallback {
        void onProgressLoaded(ArrayList<HashMap<String,Object>> list);
    }

    interface RangeProgressCallback{
        void onRangeProgressLoaded(HashMap<String,ArrayList<HashMap<String,Object>>> map);
    }

    interface CheckFirstTimeCallback{
        void checkFirstTime(boolean isTableEmpty);
    }

    void getDataFor(int day, int month, int year, LoadProgressCallback callback);
    void getRangeDataFor(int day1, int month1, int year1, int day2, int month2, int year2, RangeProgressCallback callback);
    
    ///GET DATA FOR THIS WEEK
    void getWeekData(Calendar cal, RangeProgressCallback success);

    ///GET DATA FOR THIS MONTH
    void getMonthData(Calendar cal, RangeProgressCallback success);

    void updateHour(int id, int activity, String note,int worth, MethodChannel.Result result);

    void getRunningApps(final Context context, int d1, int m1, int y1, int d2, int m2, int y2, LoadProgressCallback callback);

    void isTableEmpty(CheckFirstTimeCallback callback);



}
