/****************************************************************************
 * Copyright 2016 kraigs.android@gmail.com
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 ****************************************************************************/

package xyz.higgledypiggledy.rate_your_time_new.alarmLogic;

import android.app.AlarmManager;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.BroadcastReceiver;
import android.content.ContentUris;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.media.AudioAttributes;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Build;
import android.os.Handler;
import android.os.IBinder;
import android.os.PowerManager;
import android.os.VibrationEffect;
import android.os.Vibrator;
import android.provider.Settings;
import android.util.ArrayMap;
import android.util.Log;
import android.widget.RemoteViews;

import java.io.IOException;
import java.util.Calendar;
import java.util.HashSet;
import java.util.Locale;

import xyz.higgledypiggledy.rate_your_time_new.InputScreen;
import xyz.higgledypiggledy.rate_your_time_new.MainActivity;
import xyz.higgledypiggledy.rate_your_time_new.R;

public class AlarmNotificationService extends Service {
    public static final String ALARM_ID = "alarm_id";
    public static final String CLICK_NOTES = "clickNotes";
    private static final String TIME_UTC = "time_utc";
    public static final String CLICK_EXTRAS = "clickExtra";
    public static final String CLICK_TITLE = "clickTitle";
    private static final int UNIQUE_ID = 234;

    /**
     * Write new alarm information to the data store and schedule it.
     * NOTE: this context should be the application-level context.
     */
    public static long newAlarm(Context c, int secondsPastMidnight) {

        ContentValues v = new ContentValues();
        v.put(AlarmClockProvider.AlarmEntry.TIME, secondsPastMidnight);
        int repeat = TimeUtil.EVERYDAY;
//        Log.d(TAG, "newAlarm() called with: c = [" + c + "], secondsPastMidnight = [" + secondsPastMidnight + ", Repeat = " + v.get(AlarmClockProvider.AlarmEntry.DAY_OF_WEEK) + " ]");
        v.put(AlarmClockProvider.AlarmEntry.DAY_OF_WEEK, repeat);
        Uri u = c.getContentResolver().insert(AlarmClockProvider.ALARMS_URI, v);
        long alarmid = ContentUris.parseId(u);
//        Log.i(TAG, "New alarm: " + alarmid + " (" + u + ")");
        Calendar ts = TimeUtil.nextOccurrence(secondsPastMidnight, repeat);
        scheduleAlarmTrigger(c, alarmid, ts.getTimeInMillis());

//    onPick(c,repeat,alarmid);
        return alarmid;
    }

    public static void onPick(Context c, int repeat, long id) {
        Uri uri = ContentUris.withAppendedId(
                AlarmClockProvider.ALARMS_URI, id);
        ContentValues val = new ContentValues();
        val.put(AlarmClockProvider.AlarmEntry.DAY_OF_WEEK, repeat);
        c.getContentResolver().update(uri, val, null, null);
        final DbUtil.Alarm a = DbUtil.Alarm.get(c, id);
        final Calendar next =
                TimeUtil.nextOccurrence(a.time, repeat, a.next_snooze);
        Context wakeup = c.getApplicationContext();
        AlarmNotificationService.removeAlarmTrigger(wakeup, id);
        scheduleAlarmTrigger(
                wakeup, id, next.getTimeInMillis());
    }


    /**
     * Schedule an alarm event for a previously created alarm.
     * NOTE: this context should be the application-level context.
     */
    public static void scheduleAlarmTrigger(Context c, long alarmid, long tsUTC) {
        if (alarmid < 0) {
            throw new IllegalArgumentException("Invalid alarmid: " + alarmid);
        }

        // Intents are considered equal if they have the same action, data, type,
        // class, and categories.  In order to schedule multiple alarms, every
        // pending intent must be different.  This means that we must encode
        // the alarm id in the request code.
        PendingIntent schedule = PendingIntent.getBroadcast(
                c, (int) alarmid, new Intent(c, AlarmTriggerReceiver.class)
                        .putExtra(ALARM_ID, alarmid), 0);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            ((AlarmManager) c.getSystemService(Context.ALARM_SERVICE))
                    .setAlarmClock(new AlarmManager.AlarmClockInfo(
                            tsUTC, PendingIntent.getActivity(
                            c, 0, new Intent(c, MainActivity.class), 0)), schedule);
        }
        CountdownRefresh.start(c);
    }

    /**
     * Un-schedule a previously scheduled alarm event.
     * NOTE: this context should be the application-level context.
     */
    public static void removeAlarmTrigger(Context c, long alarmid) {
        PendingIntent schedule = PendingIntent.getBroadcast(
                c, (int) alarmid, new Intent(c, AlarmTriggerReceiver.class)
                        .putExtra(ALARM_ID, alarmid), 0);

        ((AlarmManager) c.getSystemService(Context.ALARM_SERVICE)).cancel(schedule);
        CountdownRefresh.start(c);
    }

    /**
     * Dismiss all of the currently firing alarms.  Any marked for repeat will
     * be rescheduled appropriately.
     * NOTE: this context should be the application-level context.
     */
    public static void dismissAllAlarms(Context c) {
        if (activeAlarms == null) {
            Log.w(TAG, "No active alarms when dismissed");
            return;
        }

        for (long alarmid : activeAlarms.alarmids) {
            final DbUtil.Alarm a = DbUtil.Alarm.get(c, alarmid);
            ContentValues v = new ContentValues();
            v.put(AlarmClockProvider.AlarmEntry.NEXT_SNOOZE, 0);
            if (a.repeat == 0)
                v.put(AlarmClockProvider.AlarmEntry.ENABLED, false);
            int r = c.getContentResolver().update(
                    ContentUris.withAppendedId(AlarmClockProvider.ALARMS_URI, alarmid),
                    v, null, null);
            if (r < 1) {
                Log.e(TAG, "Failed to dismiss " + alarmid);
            }
            if (a.repeat != 0) {
                final long nextUTC =
                        TimeUtil.nextOccurrence(a.time, a.repeat).getTimeInMillis();
                AlarmNotificationService.scheduleAlarmTrigger(c, alarmid, nextUTC);
            }
        }

        activeAlarms.alarmids.clear();
        CountdownRefresh.start(c);
        c.stopService(new Intent(c, AlarmNotificationService.class));
    }

    /**
     * Snooze all of the currently firing alarms.
     * NOTE: this context should be the application-level context.
     */
    public static void snoozeAllAlarms(Context c, long snoozeUTC) {
        if (activeAlarms == null) {
            Log.w(TAG, "No active alarms when snoozed");
            return;
        }

        for (long alarmid : activeAlarms.alarmids) {
            ContentValues v = new ContentValues();
            v.put(AlarmClockProvider.AlarmEntry.NEXT_SNOOZE, snoozeUTC);
            int r = c.getContentResolver().update(
                    ContentUris.withAppendedId(AlarmClockProvider.ALARMS_URI, alarmid),
                    v, null, null);
            if (r < 1) {
                Log.e(TAG, "Failed to snooze " + alarmid);
            }
            scheduleAlarmTrigger(c, alarmid, snoozeUTC);
        }

        activeAlarms.alarmids.clear();
        CountdownRefresh.start(c);
        c.stopService(new Intent(c, AlarmNotificationService.class));
    }

    /**
     * Is an alarm firing?
     */
    public static boolean isFiring() {
        return activeAlarms != null && !activeAlarms.alarmids.isEmpty();
    }

    /**
     * The set of currently active alarms.
     */
    private static ActiveAlarms activeAlarms = null;

    public static HashSet<Long> getActiveAlarms() {
        // NOTE: onDestroy sets this to null again.
        if (activeAlarms != null) {
            return activeAlarms.alarmids;
        } else {
            return new HashSet<Long>();
        }
    }

    @Override
    public int onStartCommand(Intent i, int flags, int startId) {
        // NOTE: This shouldn't happen, but the crash reports show otherwise.
        // This does not call startForeground, which is bad if this came from
        // the alarm trigger, but maybe good if at was some random spurious thing?
        if (i == null || !i.hasExtra(ALARM_ID)) {
            Log.e(TAG, "Spurious start, flags: " + flags + " id: " + startId +
                    " intent: " + i.toString());
            if (!isFiring()) {
                stopSelf();
            }
            return START_NOT_STICKY;
        }

        // NOTE: The service should continue running while there are any active
        // alarms.  This calls startForeground() and startActivity().
        handleTriggerAlarm(i);

        return START_REDELIVER_INTENT;
    }

    @Override
    public void onDestroy() {
        if (activeAlarms == null)
            return;

        activeAlarms.release();
        activeAlarms = null;
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @SuppressWarnings("deprecation") // Notification channel required
    private void handleTriggerAlarm(Intent i) {
        final long alarmid = i.getLongExtra(ALARM_ID, -1);
        final DbUtil.Settings settings =
                DbUtil.Settings.get(getApplicationContext(), alarmid);

        PowerManager.WakeLock w = null;
        if (i.hasExtra(AlarmTriggerReceiver.WAKELOCK_ID)) {
            w = AlarmTriggerReceiver.consumeLock(
                    i.getExtras().getInt(AlarmTriggerReceiver.WAKELOCK_ID));
        }

        if (w == null)
            Log.e(TAG, "No wake lock present for alarm trigger " + alarmid);

        if (activeAlarms == null) {
            activeAlarms = new ActiveAlarms(getApplicationContext(), w, settings);
        } else {
            Log.i(TAG, "Already wake-locked, releasing extra lock");
            w.release();
        }
        activeAlarms.alarmids.add(alarmid);

        String labels = "";
        for (long id : activeAlarms.alarmids) {
            String label = DbUtil.Alarm.get(getApplicationContext(), id).label;
            if (!label.isEmpty()) {
                if (labels.isEmpty())
                    labels = label;
                else
                    labels += ", " + label;
            }
        }

//    Intent notify = new Intent(this, AlarmNotificationActivity.class)
//      .setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

        final NotificationManager manager =
                (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O &&
                manager.getNotificationChannel(FIRING_ALARM_NOTIFICATION_CHAN) == null) {
            // Create a notification channel on first use.
            NotificationChannel chan = new NotificationChannel(
                    FIRING_ALARM_NOTIFICATION_CHAN,
                    getString(R.string.ringing_alarm_notification),
                    NotificationManager.IMPORTANCE_MAX);
//      chan.setSound(null, null);  // Service manages its own sound.
            manager.createNotificationChannel(chan);
        }
        RemoteViews remoteView = new RemoteViews(getApplicationContext().getPackageName(), R.layout.notification_rate);

        Notification.Builder builder = (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O ?
                new Notification.Builder(this, FIRING_ALARM_NOTIFICATION_CHAN) :
                new Notification.Builder(this));
        builder
                .setContentTitle(getString(R.string.app_name))
                .setContentText(labels.isEmpty() ? getString(R.string.dismiss) : labels)

                .setSmallIcon(R.drawable.launch_background)
                // NOTE: This takes the place of the window attribute
                // FLAG_SHOW_WHEN_LOCKED in the activity itself for newer APIs.
//      .setFullScreenIntent(PendingIntent.getActivity(this, 0, notify, 0), true)
                .setPriority(Notification.PRIORITY_MAX)
                .setOngoing(true)
                .setLights(Color.WHITE, 1000, 1000);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            builder.setCategory(Notification.CATEGORY_ALARM)
                    .setVisibility(Notification.VISIBILITY_PUBLIC);
        }


        String t;
        int title = Calendar.getInstance().get(Calendar.HOUR_OF_DAY);

        int tempTitle = title;
        if (tempTitle > 12) {
            tempTitle -= 12;
            t = "pm";
        } else {
            t = "am";
        }
        String time = String.format(Locale.getDefault(), "%02d - %02d %s", (tempTitle - 1), tempTitle, t);

        remoteView.setTextViewText(R.id.notifhead, "Rate your time. (" + time + ")");


        remoteView.setOnClickPendingIntent(R.id.button7, makePiWith(1, title));
        remoteView.setOnClickPendingIntent(R.id.button8, makePiWith(2, title));
        remoteView.setOnClickPendingIntent(R.id.button9, makePiWith(3, title));
        remoteView.setOnClickPendingIntent(R.id.button10, makePiWith(4, title));
        remoteView.setOnClickPendingIntent(R.id.button6, makePiWith(5, title));

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            builder.setCustomContentView(remoteView)
                    .setCustomBigContentView(remoteView)
                    .setCustomHeadsUpContentView(remoteView);
        }
        final Notification notification = builder
                .build();

        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.N) {
            notification.contentView = remoteView;
            notification.bigContentView = remoteView;
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                notification.headsUpContentView = remoteView;
            }
        }
        Intent notifyIntent = new Intent(this, InputScreen.class);
        notifyIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK|Intent.FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS);

        notification.contentIntent = PendingIntent.getActivity(this, UNIQUE_ID,
                notifyIntent, PendingIntent.FLAG_UPDATE_CURRENT);
        notification.flags |= Notification.FLAG_INSISTENT;  // Loop sound/vib/blink
        startForeground(FIRING_ALARM_NOTIFICATION_ID, notification);

        CountdownRefresh.stop(getApplicationContext());

        // NOTE: As of API 29, this only works when the app is in the foreground.
        // https://developer.android.com/guide/components/activities/background-starts
        // The setFullScreenIntent option above handles the lock screen case.
        startActivity(notifyIntent);
    }

    private PendingIntent makePiWith(int i, int title) {

        Intent i1 = new Intent(this.getApplicationContext(), ClickReciever.class);
        i1.putExtra(CLICK_EXTRAS, i);
        i1.putExtra(CLICK_TITLE, title);
        i1.putExtra(CLICK_NOTES, "");
//    i1.putExtra("ID",id);
        i1.setAction("");
        return PendingIntent.getBroadcast(this.getApplicationContext(), i, i1, PendingIntent.FLAG_UPDATE_CURRENT);
    }

    private static final String TAG =
            AlarmNotificationService.class.getSimpleName();
    // Notification ids
    private static final int FIRING_ALARM_NOTIFICATION_ID = 42;
    private static final String FIRING_ALARM_NOTIFICATION_CHAN = "ring";
    private static final int NEXT_ALARM_NOTIFICATION_ID = 69;
    private static final String NEXT_ALARM_NOTIFICATION_CHAN = "next";

    private static class ActiveAlarms {
        public static final int TRIGGER_INC = 1;
        public static final int RESET_VOLUME = 2;

        private PowerManager.WakeLock wakelock = null;
        private HashSet<Long> alarmids = new HashSet<Long>();
        private MediaPlayer player = null;
        private Vibrator vibrator = null;
        private Handler handler = null;
        private Runnable timeout = null;

        @SuppressWarnings("deprecation")  // vibrate()
        public ActiveAlarms(final Context c, PowerManager.WakeLock w,
                            final DbUtil.Settings s) {
            // Since we will be changing the notification channel volume, store
            // the initial value so we can reset it afterward.
            final AudioManager a = (AudioManager) c.getSystemService(
                    Context.AUDIO_SERVICE);
            final int init_volume = a.getStreamVolume(AudioManager.STREAM_ALARM);
            a.setStreamVolume(AudioManager.STREAM_ALARM,
                    a.getStreamMaxVolume(AudioManager.STREAM_ALARM), 0);

            wakelock = w;
            player = new MediaPlayer();
//      if (s.vibrate) {
            vibrator = (Vibrator) c.getSystemService(Context.VIBRATOR_SERVICE);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                vibrator.vibrate(
                        VibrationEffect.createWaveform(new long[]{1000, 1000}, -1));
            } else {
                vibrator.vibrate(new long[]{1000, 1000}, -1);
            }
//      }
//       This handler will be used to asynchronously trigger volume adjustments.
//      handler = new Handler() {
//          @Override
//          public void handleMessage(Message m) {
//            switch (m.what) {
//            case TRIGGER_INC:
//              float inc = s.volume_time > 0 ?
//                (s.volume_ending - s.volume_starting) / (float)s.volume_time :
//                s.volume_ending;
//              float next = Math.min(s.volume_ending, (float)m.obj + inc);
//              float norm = (float)((Math.pow(5, next/100.0)-1)/4);
//              Log.i(TAG, "Incrementing volume to " + norm);
//              player.setVolume(norm, norm);
//              if (next < s.volume_ending) {
//                Message m2 = new Message();
//                m2.what = TRIGGER_INC;
//                m2.obj = next;
//                sendMessageDelayed(m2, 1000);
//              }
//              break;
//            case RESET_VOLUME:
//              a.setStreamVolume(AudioManager.STREAM_ALARM, init_volume, 0);
//              break;
//            }
//          }
//        };

            // Setup a watchdog to dismiss this alarm if it goes unanswered for
            // 10 minutes.  Otherwise the screen would stay on indefinitely.
//      timeout = new Runnable() {
//          @Override
//          public void run() {
//            Log.w(TAG, "Alarm timeout");
//            AlarmNotificationService.dismissAllAlarms(c);
//            Intent timeout = new Intent(c, AlarmNotificationActivity.class)
//              .putExtra(AlarmNotificationActivity.TIMEOUT, true)
//              .setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//             NOTE: this only works when the activity is in the foreground.
//             Otherwise the alarm is dismissed without a warning.
//            c.startActivity(timeout);
//          }
//        };
//      handler.postDelayed(timeout, 10 * 60 * 1000);

            // NOTE: We use the alarm channel for notification sound.
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                player.setAudioAttributes(
                        new AudioAttributes.Builder()
                                .setLegacyStreamType(AudioManager.STREAM_ALARM)
                                .build());
            }
            player.setLooping(false);
            final float start = s.volume_starting / (float) 100.0;
            player.setVolume(start, start);
//      Log.i(TAG, "Starting volume: " + start);

            // Try to load the configured media, but fall back to the system
            // default if that fails.
            try {
                player.setDataSource(c, s.tone_url);
            } catch (IOException e) {
                Log.e(TAG, "Failed loading tone: " + e.toString());
                try {
                    player.setDataSource(c, Settings.System.DEFAULT_ALARM_ALERT_URI);
                } catch (IOException e2) {
                    Log.e(TAG, "Failed loading backup tone: " + e2.toString());
                }
            }
//
            try {
                player.prepare();
                player.start();
            } catch (IOException | IllegalStateException e) {
                Log.e(TAG, "prepare failed: " + e.toString());
            }
//
            // Begin the volume fade.
//      Message m = new Message();
//      m.what = TRIGGER_INC;
//      m.obj = (float)s.volume_starting;
//      handler.sendMessage(m);
        }

        public void release() {
            if (!alarmids.isEmpty())
                Log.w(TAG, "Releasing wake lock with active alarms! (" +
                        alarmids.size() + ")");
            Log.i(TAG, "Releasing wake lock");
            wakelock.release();
            wakelock = null;

//      handler.removeCallbacks(timeout);
//      handler.removeMessages(ActiveAlarms.TRIGGER_INC);
//      handler.sendEmptyMessage(ActiveAlarms.RESET_VOLUME);
//      handler = null;

            if (player.isPlaying())
                player.stop();
            player.reset();
            player.release();
            player = null;

            if (vibrator != null) {
                vibrator.cancel();
                vibrator = null;
            }
        }
    }

    public static class AlarmTriggerReceiver extends BroadcastReceiver {
        public static final String WAKELOCK_ID = "wakelock_id";
        private static final ArrayMap<Integer, PowerManager.WakeLock> locks =
                new ArrayMap<Integer, PowerManager.WakeLock>();
        private static int nextid = 0;

        @Override
        public void onReceive(Context c, Intent i) {
            final long alarmid = i.getLongExtra(ALARM_ID, -1);
            if (alarmid < 0) {
                throw new IllegalArgumentException("Invalid alarmid: " + alarmid);
            }

//      int title = Calendar.getInstance().get(Calendar.HOUR_OF_DAY);
//      NotificationUtils.showDefaultNotification(c,title);

            @SuppressWarnings("deprecation")  // SCREEN_DIM_WAKE_LOCK
                    PowerManager.WakeLock w =
                    ((PowerManager) c.getSystemService(Context.POWER_SERVICE))
                            .newWakeLock(PowerManager.SCREEN_DIM_WAKE_LOCK |
                                    PowerManager.ACQUIRE_CAUSES_WAKEUP, "wake id " + nextid);
            w.setReferenceCounted(false);
            w.acquire();
            locks.put(nextid, w);
            Log.i(TAG, "Acquired lock " + nextid + " for alarm " + alarmid);

            Intent alarm = new Intent(c, AlarmNotificationService.class)
                    .putExtra(ALARM_ID, alarmid)
                    .putExtra(WAKELOCK_ID, nextid++);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                c.startForegroundService(alarm);
            } else {
                c.startService(alarm);
            }
        }

        public static PowerManager.WakeLock consumeLock(int id) {
            return locks.remove(id);
        }
    }
}
