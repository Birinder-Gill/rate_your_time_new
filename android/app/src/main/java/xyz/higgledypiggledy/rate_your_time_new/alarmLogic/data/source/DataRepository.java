package xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.source;


import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.source.local.LocalDataSource;

public class DataRepository implements DataSource {

    private static DataRepository INSTANCE;
    private final LocalDataSource dataSource;

    private DataRepository(LocalDataSource dataSource){
        this.dataSource=dataSource;
    }
    public static DataRepository getInstance(LocalDataSource dataSource){
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
    public void getDataFor(int day1, int month1, int year1, int day2, int month2, int year2, RangeProgressCallback callback) {
        dataSource.getDataFor(day1,month1,year1,day2,month2,year2,callback);
    }
}
