package xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.source;


import java.util.Calendar;

import io.flutter.plugin.common.MethodChannel;

public class DataRepository implements DataSource {

    private static DataRepository INSTANCE;
    private final DataSource dataSource;

    private DataRepository(DataSource dataSource){
        this.dataSource=dataSource;
    }
    public static DataRepository getInstance(DataSource dataSource){
        if(INSTANCE==null)
        {
            INSTANCE=new DataRepository(dataSource);
        }
        return INSTANCE;
    }
    @Override
    public void getDataFor(int day,int month,int year,LoadProgressCallback callback) {
        dataSource.getDataFor(day,(month-1),year,callback);
    }

    @Override
    public void getRangeDataFor(int day1, int month1, int year1, int day2, int month2, int year2, RangeProgressCallback callback) {
        dataSource.getRangeDataFor(day1,month1,year1,day2,month2,year2,callback);
    }

    @Override
    public void getWeekData(Calendar cal, RangeProgressCallback success) {
        dataSource.getWeekData(cal,success);
    }

    @Override
    public void getMonthData(Calendar cal, RangeProgressCallback success) {
        dataSource.getMonthData(cal,success);
    }

    @Override
    public void updateHour(int id, int activity, String note, MethodChannel.Result result) {
        dataSource.updateHour(id,activity,note,result);
    }
}
