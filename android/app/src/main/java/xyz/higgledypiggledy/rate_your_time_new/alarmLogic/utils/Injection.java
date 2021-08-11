package xyz.higgledypiggledy.rate_your_time_new.alarmLogic.utils;

import android.content.Context;
import android.util.Log;
import android.widget.Toast;

import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.source.DataRepository;
import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.source.DataSource;
import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.source.local.LocalDataSource;
import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.source.local.ProgressDatabase;
import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.source.mock.MockDataSource;


public class Injection {
    private static final String TAG = "Injection";

    public static DataRepository provideRepository(Context context, boolean test) {
        if (context == null) {
            throw new IllegalArgumentException("Context can not be null");
        }
        Log.d(TAG, "provideRepository() called with: context = [" + context + "], test = [" + test + "]");

        Toast.makeText(context, "VALUE OF TEST IS "+test, Toast.LENGTH_SHORT).show();
        if (test) {
            Log.i(TAG, "provideRepository: INSIDE TEST");
            MockDataSource source = MockDataSource.getInstance();
            return DataRepository.getInstance(source);
        }
        LocalDataSource source = LocalDataSource.getInstance(ProgressDatabase.getInstance(context).dao(), AppExecutors.getInstance());
        return DataRepository.getInstance(source);




    }
}
