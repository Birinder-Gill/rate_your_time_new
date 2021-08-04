package xyz.higgledypiggledy.rate_your_time_new;

import android.app.Activity;
import android.app.usage.UsageStats;
import android.app.usage.UsageStatsManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.pm.PackageManager;
import android.content.res.Resources;
import android.content.res.TypedArray;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.util.Base64;
import android.util.Log;

import androidx.annotation.RequiresApi;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;

import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.source.DataSource;
import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.utils.AppExecutors;

public class UsageTracker {
    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP_MR1)
    public static void getRunningApps(final Context context, int d1, int m1, int y1, int d2, int m2, int y2, DataSource.LoadProgressCallback callback) {
        ArrayList<HashMap<String, Object>> result = new ArrayList<>();
        AppExecutors.getInstance().diskIO().execute(new Runnable() {
            @Override
            public void run() {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    UsageStatsManager mUsageStatsManager = (UsageStatsManager) context.getSystemService(Context.USAGE_STATS_SERVICE);

                    Calendar fromC = Calendar.getInstance();
                    fromC.set(y1,m1,d1);
                    long from = fromC.getTimeInMillis();

                    Calendar toC = Calendar.getInstance();
                    toC.set(y2,m2,d2);
                    long to = toC.getTimeInMillis();
                    // We get usage stats for the last 10 seconds
                    List<UsageStats> stats = new ArrayList<>(mUsageStatsManager.queryAndAggregateUsageStats(from, to).values());

                    // Sort the stats by the last time used
                    for (UsageStats u : stats) {
                        final HashMap<String, Object> map = new HashMap<>();
                        map.put("package", u.getPackageName());
                        map.put("firstTimeStamp", u.getFirstTimeStamp());
                        map.put("LastTimeStamp", u.getLastTimeStamp());
                        map.put("LastTimeUsed", u.getLastTimeUsed());
                        map.put("TotalTimeInForeground", u.getTotalTimeInForeground());
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                            map.put("TotalTimeVisible", u.getTotalTimeVisible());
                        }
                        map.put("appName", getAppName(context, u.getPackageName()));
                        if (u.getTotalTimeInForeground() > 0 && hasLauncher(context, u.getPackageName())) {
                            String logo=getAppLogo(context, u.getPackageName());
//                            Log.d(TAG, "getAppLogo: Icon = FOR "+u.getPackageName()+"Length = "+logo.length()+" logo = "+logo);
                            map.put("appLogo", logo);
//                                map.put("color",getColor(context,u.getPackageName()));
                            result.add(map);
                        }


                    }
                }
                AppExecutors.getInstance().mainThread().execute(new Runnable() {
                    @Override
                    public void run() {
                        callback.onProgressLoaded(result);
                    }
                });
            }
        });
    }

    private static boolean hasLauncher(Context context, String packageName) {
        return (context.getPackageManager().getLaunchIntentForPackage(packageName) != null);
    }

    private static final String TAG = "UsageTracker";

    static String getAppName(Context context, String packageName) {
        PackageManager pm = context.getPackageManager();

        try {


            return (String) pm.getApplicationLabel(
                    pm.getApplicationInfo(packageName
                            , PackageManager.GET_META_DATA));

        } catch (Exception e) {
        }
        return "";
    }

    static String getAppLogo(Context context, String packageName) {
        PackageManager pm = context.getPackageManager();

        try {
            Drawable icon = pm.getApplicationIcon(packageName);

            return bitmapToString(drawableToBitmap(icon));
        } catch (Exception e) {
//            Log.d(TAG, "getAppLogo() called with: packageName = [" + packageName + "]");
//            Log.e(TAG, "getAppLogo: ", e);
        }
        return null;
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    static String getColor(Context context, String packageName){
        try {
            final PackageManager pm = context.getPackageManager();

            // The package name of the app you want to receive resources from
            // Retrieve the Resources from the app
            final Resources res = pm.getResourcesForApplication(packageName);
            // Create the attribute set used to get the colorPrimary color
            final int[] attrs = new int[] {
                    res.getIdentifier("colorAccent", "attr", packageName),
                    android.R.attr.colorPrimary
            };

            // Create a new Theme and apply the style from the launcher Activity
            final Resources.Theme theme = res.newTheme();
            final ComponentName cn = pm.getLaunchIntentForPackage(packageName).getComponent();
            theme.applyStyle(pm.getActivityInfo(cn, 0).theme, false);

            // Obtain the colorPrimary color from the attrs
            TypedArray a = theme.obtainStyledAttributes(attrs);
            // Do something with the color
            final int colorPrimary = a.getColor(0, a.getColor(1, Color.WHITE));


            // Make sure you recycle the TypedArray
            a.recycle();
            a = null;
            return String.format("#%06X", (0xFFFFFF & colorPrimary));
        } catch (final PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
            return "0";
    }

    public static Bitmap drawableToBitmap(Drawable drawable) {
        Bitmap bitmap = null;

        if (drawable instanceof BitmapDrawable) {
            BitmapDrawable bitmapDrawable = (BitmapDrawable) drawable;
            if (bitmapDrawable.getBitmap() != null) {
                return bitmapDrawable.getBitmap();
            }
        }

        if (drawable.getIntrinsicWidth() <= 0 || drawable.getIntrinsicHeight() <= 0) {
            bitmap = Bitmap.createBitmap(1, 1, Bitmap.Config.ARGB_8888); // Single color bitmap will be created of 1x1 pixel
        } else {
            bitmap = Bitmap.createBitmap(drawable.getIntrinsicWidth(), drawable.getIntrinsicHeight(), Bitmap.Config.ARGB_8888);
        }

        Canvas canvas = new Canvas(bitmap);
        drawable.setBounds(0, 0, canvas.getWidth(), canvas.getHeight());
        drawable.draw(canvas);
        return bitmap;
    }

    static String bitmapToString(Bitmap bitmap) {
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, byteArrayOutputStream);
        byte[] byteArray = byteArrayOutputStream.toByteArray();
        return Base64.encodeToString(byteArray, Base64.NO_WRAP);
    }
}
