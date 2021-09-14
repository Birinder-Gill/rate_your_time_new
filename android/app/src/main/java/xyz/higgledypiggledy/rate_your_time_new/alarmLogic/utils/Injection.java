package xyz.higgledypiggledy.rate_your_time_new.alarmLogic.utils;

import android.content.Context;

import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.source.DataRepository;
import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.source.local.LocalDataSource;
import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.source.local.ProgressDatabase;
import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.source.mock.MockDataSource;

public class Injection {
    private static final String TAG = "Injection";

    public static DataRepository provideRepository(Context context) {
        if (context == null) {
            throw new IllegalArgumentException("Context can not be null");
        }
//        Log.d(TAG, "provideRepository() called with: context = [" + context + "], test = [" + test + "]");

//      MockDataSource source = MockDataSource.getInstance();
        LocalDataSource source = LocalDataSource.getInstance(ProgressDatabase.getInstance(context).dao(), AppExecutors.getInstance());
        return DataRepository.getInstance(source);
}
}
