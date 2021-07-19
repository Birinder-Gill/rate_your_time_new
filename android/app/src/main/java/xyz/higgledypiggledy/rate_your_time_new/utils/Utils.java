package xyz.higgledypiggledy.rate_your_time_new.utils;

import java.util.Calendar;

public class Utils {


    public static Calendar getMondayFor(Calendar cal2) {
        Calendar c = Calendar.getInstance();
        c.setTime(cal2.getTime());
        c.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
        return c;
    }

    public static Calendar getFirstDateFor(Calendar c2) {
        Calendar c = Calendar.getInstance();
        c.setTime(c2.getTime());
        c.set(Calendar.DATE, 1);
        return c;
    }
}
