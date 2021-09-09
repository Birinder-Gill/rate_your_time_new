package xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data;

import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.Ignore;
import androidx.room.PrimaryKey;

import java.util.HashMap;

@Entity(tableName = "goals")
public class Goal {
    @PrimaryKey(autoGenerate = true)
    private int id;

    @ColumnInfo(defaultValue = "0")
    private int ratingTarget;

    private int date;
    private int month;
    private int year;
    @ColumnInfo(defaultValue = "0")
    private int isAccomplished;
    @ColumnInfo(defaultValue = "")
    private String goal;

    public Goal(int id, int ratingTarget, int date, int month, int year, int isAccomplished, String goal) {
        this.id = id;
        this.ratingTarget = ratingTarget;
        this.date = date;
        this.month = month;
        this.year = year;
        this.isAccomplished = isAccomplished;
        this.goal = goal;
    }

    @Ignore
    public Goal(int ratingTarget, int date, int month, int year, int isAccomplished, String goal) {
        this.ratingTarget = ratingTarget;
        this.date = date;
        this.month = month;
        this.year = year;
        this.isAccomplished = isAccomplished;
        this.goal = goal;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getRatingTarget() {
        return ratingTarget;
    }

    public void setRatingTarget(int ratingTarget) {
        this.ratingTarget = ratingTarget;
    }

    public int getDate() {
        return date;
    }

    public void setDate(int date) {
        this.date = date;
    }

    public int getMonth() {
        return month;
    }

    public void setMonth(int month) {
        this.month = month;
    }

    public int getYear() {
        return year;
    }

    public void setYear(int year) {
        this.year = year;
    }

    public int getIsAccomplished() {
        return isAccomplished;
    }

    public void setIsAccomplished(int isAccomplished) {
        this.isAccomplished = isAccomplished;
    }

    public String getGoal() {
        return goal;
    }

    public void setGoal(String goal) {
        this.goal = goal;
    }

    public HashMap toMap(){
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("id",this. id);
        map.put("ratingTarget",this. ratingTarget);
        map.put("date",this. date);
        map.put("month",this. month);
        map.put("year",this. year+1);
        map.put("isAccomplished",this. isAccomplished);
        map.put("goal",this. goal);
        return map;
    }
}
