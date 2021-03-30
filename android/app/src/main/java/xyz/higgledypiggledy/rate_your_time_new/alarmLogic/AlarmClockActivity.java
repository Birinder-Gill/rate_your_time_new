///****************************************************************************
// * Copyright 2016 kraigs.android@gmail.com
// * Licensed under the Apache License, Version 2.0 (the "License");
// * you may not use this file except in compliance with the License.
// * You may obtain a copy of the License at
// *
// *   http://www.apache.org/licenses/LICENSE-2.0
// *
// * Unless required by applicable law or agreed to in writing, software
// * distributed under the License is distributed on an "AS IS" BASIS,
// * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// * See the License for the specific language governing permissions and
// * limitations under the License.
// ****************************************************************************/
//
//package xyz.higgledypiggledy.rate_your_time_new.alarmLogic;
//
//import android.app.Activity;
//import android.app.AlertDialog;
//import android.app.Dialog;
//import android.content.ContentUris;
//import android.content.ContentValues;
//import android.content.Context;
//import android.content.DialogInterface;
//import android.content.Intent;
//import android.content.pm.ApplicationInfo;
//import android.database.Cursor;
//import android.os.Bundle;
//import android.os.Handler;
//import android.os.Looper;
//import android.util.Log;
//import android.view.Menu;
//import android.view.MenuItem;
//import android.view.View;
//import android.widget.AdapterView;
//import android.widget.CheckBox;
//import android.widget.ListView;
//import android.widget.ResourceCursorAdapter;
//import android.widget.TextView;
//import android.widget.TimePicker;
//
//
//import xyz.higgledypiggledy.rate_your_time_new.R;
//import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.Hour;
//import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.data.source.DataSource;
//import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.utils.Injection;
//
//import java.util.ArrayList;
//import java.util.Calendar;
//import java.util.LinkedList;
//
//public class AlarmClockActivity extends Activity {
//  private Runnable refresh_tick;
//  private final Handler handler = new Handler(Looper.getMainLooper());
//
//    private static final String TAG = "AlarmClockActivity";
//  void getAlarms(){
//      Log.d(TAG, "getAlarms() called");
//      Calendar c = Calendar.getInstance();
//      Injection.provideRepository(getApplicationContext()).getDataFor(c.get(Calendar.DAY_OF_MONTH),c.get(Calendar.MONTH),c.get(Calendar.YEAR),new DataSource.LoadProgressCallback() {
//          @Override
//          public void onProgressLoaded(ArrayList<Hour> list) {
//             for (int i =0;i<list.size();i++){
//                 Log.d(TAG, "[" +"Date = "+list.get(i).getDate()+"/"+list.get(i).getMonth()+"/"+list.get(i).getYear()+" Worth = "+ list.get(i).getWorth() + " Time = "+list.get(i).getTime()+"]");
//             }
//          }
//      });
//
//  }
//
//  @Override
//  public void onCreate(Bundle savedInstanceState) {
//    super.onCreate(savedInstanceState);
//getAlarms();
////    final android.content.Loader<Cursor> loader = getLoaderManager().initLoader(
////        0, null, new android.app.LoaderManager.LoaderCallbacks<Cursor>() {
////            @Override
////            public android.content.Loader<Cursor> onCreateLoader(int id, Bundle args) {
////              return new android.content.CursorLoader(
////                  getApplicationContext(), AlarmClockProvider.ALARMS_URI,
////                  new String[] {
////                    AlarmClockProvider.AlarmEntry._ID,
////                    AlarmClockProvider.AlarmEntry.TIME,
////                    AlarmClockProvider.AlarmEntry.ENABLED,
////                    AlarmClockProvider.AlarmEntry.NAME,
////                    AlarmClockProvider.AlarmEntry.DAY_OF_WEEK,
////                    AlarmClockProvider.AlarmEntry.NEXT_SNOOZE },
////                  null, null, AlarmClockProvider.AlarmEntry.TIME + " ASC");
////            }
////            @Override
////            public void onLoadFinished(android.content.Loader<Cursor> loader, Cursor data) {
////              adapter.changeCursor(data);
////            }
////            @Override
////            public void onLoaderReset(android.content.Loader<Cursor> loader) {
////              adapter.changeCursor(null);
////            }
////          });
//
//    // Force the cursor loader to refresh on the minute every minute to
//    // recompute countdown displays.
////    refresh_tick = new Runnable() {
////        @SuppressWarnings("deprecation")  // Loader
////        @Override
////        public void run() {
////          loader.forceLoad();
////          handler.postDelayed(refresh_tick, TimeUtil.nextMinuteDelay());
////        }
////      };
//
//    // For debug binaries, display a button that creates an alarm 5 seconds
//    // in the future.
////    if ((getApplicationInfo().flags & ApplicationInfo.FLAG_DEBUGGABLE) != 0) {
////      final View v = findViewById(R.id.test_alarm);
////      v.setVisibility(View.VISIBLE);
////      v.setOnClickListener(
////          new View.OnClickListener() {
////            @Override
////            public void onClick(View view) {
////               for(int i =7;i<=22;i++){
////                   final Calendar c = Calendar.getInstance();
////                   final int secondsPastMidnight = 5 +
////                           i * 3600 +
////                           ((c.get(Calendar.MINUTE)+1)*60);
////                   AlarmNotificationService.newAlarm(
////                           getApplicationContext(), secondsPastMidnight);
////               }
////
////            }
////          });
////    }
//
//    // Setup the new alarm button.
////    findViewById(R.id.new_alarm).setOnClickListener(
////        new View.OnClickListener() {
////          @SuppressWarnings("deprecation")  // FragmentManager, DialogFragment.show()
////          @Override
////          public void onClick(View view) {
////            TimePicker time_pick = new TimePicker();
////            time_pick.setListener(new_alarm);
////            time_pick.show(getFragmentManager(), "new_alarm");
////          }
////        });
////
//    // Listener can not be serialized in time picker, so it must be explicitly
//    // set each time.
////    if (savedInstanceState != null) {
////      @SuppressWarnings("deprecation")  // FragmentManager
////              TimePicker t = (TimePicker)getFragmentManager()
////        .findFragmentByTag("new_alarm");
////      if (t != null)
////        t.setListener(new_alarm);
////    }
//  }
//
//  @Override
//  public void onStart() {
//    super.onStart();
//    handler.postDelayed(refresh_tick, TimeUtil.nextMinuteDelay());
//    // Show the notification activity if an alarm is triggering.
////    if (AlarmNotificationService.isFiring()) {
////      startActivity(new Intent(this, AlarmNotificationActivity.class)
////                    .setFlags(Intent.FLAG_ACTIVITY_NEW_TASK));
////    }
//  }
//
//  @SuppressWarnings("deprecation")  // LoadManager
//  @Override
//  public void onRestart() {
//    super.onRestart();
//    getLoaderManager().getLoader(0).forceLoad();
//  }
//
//  @Override
//  public void onStop() {
//    super.onStop();
//    handler.removeCallbacks(refresh_tick);
//  }
//
//  @SuppressWarnings("deprecation")  // PreferenceManager
//  @Override
//  public boolean onCreateOptionsMenu(Menu menu) {
////    getMenuInflater().inflate(R.menu.alarm_list_menu, menu);
////    menu.findItem(R.id.display_notification)
////      .setChecked(
////          android.preference.PreferenceManager.getDefaultSharedPreferences(this)
////          .getBoolean(CountdownRefresh.DISPLAY_NOTIFICATION_PREF, true));
//    return super.onCreateOptionsMenu(menu);
//  }
//
//  @SuppressWarnings("deprecation")  // FragmentManager, PreferenceManager
//  @Override
//  public boolean onOptionsItemSelected(MenuItem item) {
////    switch (item.getItemId()) {
////    case R.id.default_options:
////      AlarmOptions options = new AlarmOptions();
////      Bundle b = new Bundle();
////      b.putLong(AlarmNotificationService.ALARM_ID, DbUtil.Settings.DEFAULTS_ID);
////      options.setArguments(b);
////      options.show(getFragmentManager(), "default_alarm_options");
////      return true;
//
////    case R.id.display_notification:
////      boolean new_val = !item.isChecked();
////      item.setChecked(new_val);
////      android.preference.PreferenceManager.getDefaultSharedPreferences(this)
////        .edit()
////        .putBoolean(CountdownRefresh.DISPLAY_NOTIFICATION_PREF, new_val)
////        .commit();
////      if (new_val) {
////        CountdownRefresh.start(getApplicationContext());
////      } else {
////        CountdownRefresh.stop(getApplicationContext());
////      }
////      return true;
//
////    case R.id.delete_all:
////      new DeleteAllConfirmation()
////        .show(getFragmentManager(), "confirm_delete_all");
////
////      return true;
////    default:
//      return super.onOptionsItemSelected(item);
//    }
//  }
//
////  @SuppressWarnings("deprecation")  // DialogFragment
////  public static class DeleteAllConfirmation extends android.app.DialogFragment {
////    @Override
////    public Dialog onCreateDialog(Bundle savedInstanceState) {
////      return new AlertDialog.Builder(getContext())
////        .setTitle(R.string.delete)
////        .setMessage(R.string.delete_all_sure)
////        .setNegativeButton(R.string.cancel, null)
////        .setPositiveButton(
////            R.string.ok, new DialogInterface.OnClickListener() {
////                @Override
////                public void onClick(DialogInterface dialog, int which) {
////                  // Find all of the enabled alarm ids.
////                  LinkedList<Long> ids = new LinkedList<Long>();
////                  Cursor c = getContext().getContentResolver().query(
////                      AlarmClockProvider.ALARMS_URI,
////                      new String[] { AlarmClockProvider.AlarmEntry._ID },
////                      AlarmClockProvider.AlarmEntry.ENABLED + " == 1",
////                          null, null);
////                  while (c.moveToNext())
////                    ids.add(c.getLong(c.getColumnIndex(
////                        AlarmClockProvider.AlarmEntry._ID)));
////                  c.close();
////                  // Delete the entire alarm table.
////                  getContext().getContentResolver().delete(
////                      AlarmClockProvider.ALARMS_URI, null, null);
////                  // Unschedule any alarms that were active.
////                  for (long id : ids)
////                    AlarmNotificationService.removeAlarmTrigger(
////                        getContext(), id);
////                }
////              }).create();
////    }
////  }
////}
//
