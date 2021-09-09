package xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.source.local;

import android.content.Context;

import androidx.room.Database;
import androidx.room.Room;
import androidx.room.RoomDatabase;

import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.Goal;
import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.Hour;


@Database(entities = {Hour.class, Goal.class}, version = 1,exportSchema = false)
public abstract class ProgressDatabase extends RoomDatabase {

    private static ProgressDatabase INSTANCE;

    public abstract ProgressDao dao();

    private static final Object sLock = new Object();

    public static ProgressDatabase getInstance(Context context) {
        synchronized (sLock) {

            if (INSTANCE == null) {
                INSTANCE = Room.databaseBuilder(context.getApplicationContext(), ProgressDatabase.class, "Progress.db").build();
            }
        }
        return INSTANCE;
    }
}
