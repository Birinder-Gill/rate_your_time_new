package xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.source;




import java.util.ArrayList;
import java.util.HashMap;

import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.Hour;


public interface DataSource
{

    interface LoadProgressCallback {
        void onProgressLoaded(ArrayList<HashMap<String,Object>> list);
    }

    interface RangeProgressCallback{
        void onRangeProgressLoaded(HashMap<String,ArrayList<HashMap<String,Object>>> map);
    }

    void getDataFor(int day, int month, int year, LoadProgressCallback callback);
    public void getDataFor(int day1, int month1, int year1, int day2, int month2, int year2, RangeProgressCallback callback);
    



}
