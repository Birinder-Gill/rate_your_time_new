package xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.source.mock;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Random;

import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.Hour;
import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.source.DataSource;
import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.source.local.LocalDataSource;
 
public class MockDataSource implements DataSource {


    private static MockDataSource INSTANCE;

    public static MockDataSource getInstance() {
        if (INSTANCE == null) {
            synchronized (LocalDataSource.class) {
                if (INSTANCE == null) {
                    INSTANCE = new MockDataSource();
                }
            }
        }
        return INSTANCE;
    }
    @Override
    public void getDataFor(int day, int month, int year, LoadProgressCallback callback) {
                    callback.onProgressLoaded(getHoursFor(day,month,year));
    }

    @Override
    public void getDataFor(int day1, int month1, int year1, int day2, int month2, int year2, RangeProgressCallback callback) {

    }

    private static final String TAG = "MockDataSource";
    ArrayList<HashMap<String, Object>> getHoursFor(int day, int month, int year){
        final ArrayList<HashMap<String,Object>> finalList=new ArrayList<>();
        Random random= new Random();
        Calendar now = Calendar.getInstance();
        int lastTime =((now.get(Calendar.MONTH)==month) && (now.get(Calendar.YEAR)==year) && (now.get(Calendar.DATE)>day)?22:now.get(Calendar.HOUR_OF_DAY));
        for(int i= 7;i<lastTime;i++)
        {
           finalList.add(new Hour(random.nextInt(5),i,day,month,year).toMap());
         }
        return finalList;
    }

}
