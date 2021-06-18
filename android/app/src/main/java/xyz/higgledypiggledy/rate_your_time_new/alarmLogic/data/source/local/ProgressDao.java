package xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.source.local;

import androidx.room.Dao;
import androidx.room.Insert;
import androidx.room.Query;
import androidx.room.Update;


import java.util.List;

import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.Hour;


@Dao
public interface ProgressDao{
    @Query("SELECT * FROM entries WHERE date = :day AND month = :month AND year = :year")
    List<Hour> getDataFor(int day, int month, int year);

    @Insert
    void addHour(Hour hour);

    @Query("UPDATE entries SET activity=:activity, note=:note WHERE id=:id")
    void updateHour(int id,int activity,String note);
}
