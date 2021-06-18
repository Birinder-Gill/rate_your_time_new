package xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data;


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


    public Hour(int id, int worth, int time, int date, int month, int year) {
        this.id = id;
        this.worth = worth;
        this.time = time;
        this.date = date;
        this.month = month;
        this.year = year;
    }
    @Ignore
    public Hour(int worth, int time, int date, int month, int year) {
        this.worth = worth;
        this.time = time;
        this.date = date;
        this.month = month;
        this.year = year;
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
        HashMap<String, Integer> map = new HashMap<String, Integer>();
        map.put("id",this.id);
        map.put("worth",this.worth);
        map.put("time",this.time);
        map.put("date",this.date);
        map.put("month",this.month+1);
        map.put("year",this.year);
        return map;
    }
}
