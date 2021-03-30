package xyz.higgledypiggledy.rate_your_time_new.alarmLogic.utils;

import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;

import java.util.concurrent.Executor;
import java.util.concurrent.Executors;

public class AppExecutors {
    private static final int THREAD_COUNT = 3;
    private static  AppExecutors INSTANCE;
    private final Executor diskIO;

    private final Executor networkIO;

    private final Executor mainThread;

        private AppExecutors(Executor diskIO, Executor networkIO, Executor mainThread) {
        this.diskIO = diskIO;
        this.networkIO = networkIO;
        this.mainThread = mainThread;
    }

    public static  AppExecutors getInstance() {
        if(INSTANCE==null)
        {
            INSTANCE=new AppExecutors(Executors.newSingleThreadExecutor(), Executors.newFixedThreadPool(THREAD_COUNT),new MainThreadExecutor());
        }
        return INSTANCE;
    }

    public Executor diskIO() {
        return diskIO;
    }

    public Executor networkIO() {
        return networkIO;
    }

    public Executor mainThread() {
        return mainThread;
    }

    private static class MainThreadExecutor implements Executor {
        private final Handler mainThreadHandler = new Handler(Looper.getMainLooper());

        @Override
        public void execute(@NonNull Runnable command) {
            mainThreadHandler.post(command);
        }
    }
}
