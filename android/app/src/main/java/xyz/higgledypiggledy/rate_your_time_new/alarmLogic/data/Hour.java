package xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data;


import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.Ignore;
import androidx.room.PrimaryKey;

import java.util.HashMap;

@Entity(tableName = "entries")
public class Hour {

    @PrimaryKey(autoGenerate = true)
    private  int id;

    private  int worth;
    private  int time;
    private  int date;
    private int month;
    private int year;
    @ColumnInfo(defaultValue = "0")
    private int activity;
    @ColumnInfo(defaultValue = "")
    private String note;


    public Hour(int id, int worth, int time, int date, int month, int year,int activity,String note) {
        this.id = id;
        this.worth = worth;
        this.time = time;
        this.date = date;
        this.month = month;
        this.year = year;
        this.activity=activity;
        this.note=note;
    }
    @Ignore
    public Hour(int worth, int time, int date, int month, int year,int activity,String note) {
        this.worth = worth;
        this.time = time;
        this.date = date;
        this.month = month;
        this.year = year;
        this.activity=activity;
        this.note=note;
    }

    public int getId() {
        return id;
    }
    public void setId(int id)
    {
        this.id=id;
    }
    public int getDate() {
        return date;
    }

    public int getActivity() {
        return activity;
    }

    public void setActivity(int activity) {
        this.activity = activity;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public int getTime() {
        return time;
    }

    public void setWorth(int worth) {
        this.worth = worth;
    }

    public int getMonth() {
        return month;
    }

    public int getYear() {
        return year;
    }

    public void setTime(int time) {
        this.time = time;
    }

    public void setDate(int date) {
        this.date = date;
    }

    public void setMonth(int month) {
        this.month = month;
    }

    public void setYear(int year) {
        this.year = year;
    }

    public int getWorth() {
        return worth;
    }

    public HashMap toMap(){
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("id",this.id);
        map.put("worth",this.worth);
        map.put("time",this.time);
        map.put("date",this.date);
        map.put("month",this.month+1);
        map.put("year",this.year);
        map.put("activity",this.activity);
        map.put("note",this.note);
        return map;
    }
}
