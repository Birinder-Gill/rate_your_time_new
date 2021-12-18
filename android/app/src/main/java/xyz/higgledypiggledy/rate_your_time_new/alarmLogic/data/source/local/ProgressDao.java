package xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.source.local;

import androidx.room.Dao;
import androidx.room.Insert;
import androidx.room.Query;


import java.util.List;

import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.Goal;
import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.Hour;


@Dao
public interface ProgressDao{
    @Query("SELECT * FROM entries WHERE date = :day AND month = :month AND year = :year")
    List<Hour> getDataFor(int day, int month, int year);

    @Query("SELECT * FROM entries ORDER BY id LIMIT 1")
     Hour checkTableEmpty();

    @Insert
    void addHour(Hour hour);

    @Query("UPDATE entries SET activity=:activity, note=:note, worth=:worth WHERE id=:id")
    void updateHour(int id,int activity,String note,int worth);
    
    @Query("SELECT * FROM goals WHERE date = :day AND month = :month AND year = :year")
    List<Goal> getGoalFor(int day, int month, int year);

    @Insert
    void addGoal(Goal goal);

    @Query("UPDATE goals SET ratingTarget=:ratingTarget, isAccomplished=:isAccomplished, goal=:goal WHERE id=:id")
    void updateGoal(int id,int ratingTarget,int isAccomplished, String goal);
    
    
}
