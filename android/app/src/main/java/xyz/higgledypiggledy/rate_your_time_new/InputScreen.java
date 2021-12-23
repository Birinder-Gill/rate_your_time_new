package xyz.higgledypiggledy.rate_your_time_new;


import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import androidx.core.content.ContextCompat;

import java.util.Calendar;

import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.AlarmNotificationService;
import xyz.higgledypiggledy.rate_your_time_new.alarmLogic.ClickReciever;


public class InputScreen extends Activity implements View.OnClickListener {
    private Button button1, button2, button3, button4, button5, buttonAdd;
    private EditText noteInput;
    private int i;
    public static String exitAction = "com.exit.input";
    private BroadcastReceiver receiver;
    private static final String TAG = "InputScreen";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.notification_input_dialog);
        initViews();
        setListeners();
        setUpExitReceiver();
    }

    private void setUpExitReceiver() {
        receiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                exitActivity();
            }
        };
        IntentFilter filter = new IntentFilter();
        filter.addAction(exitAction);
        registerReceiver(receiver, filter);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        unregisterReceiver(receiver);
    }

    private void setListeners() {
        button1.setOnClickListener(this);
        button2.setOnClickListener(this);
        button3.setOnClickListener(this);
        button4.setOnClickListener(this);
        buttonAdd.setEnabled(false);
        buttonAdd.setOnClickListener(this);
        button5.setOnClickListener(this);

        //CLICKING ANYWHERE IN THE BACKGROUND FINISHES THE ACTIVITY
        findViewById(R.id.root).setOnClickListener(view -> exitActivity());
    }

    private void exitActivity() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            finishAndRemoveTask();
        } else {
            finish();
        }
    }

    private void initViews() {
        button1 = findViewById(R.id.button1);
        button2 = findViewById(R.id.button2);
        button3 = findViewById(R.id.button3);
        button4 = findViewById(R.id.button4);
        button5 = findViewById(R.id.button5);

        button1.setBackground(ContextCompat.getDrawable(this, R.drawable.input_button_disable));
        button2.setBackground(ContextCompat.getDrawable(this, R.drawable.input_button_disable));
        button3.setBackground(ContextCompat.getDrawable(this, R.drawable.input_button_disable));
        button4.setBackground(ContextCompat.getDrawable(this, R.drawable.input_button_disable));
        button5.setBackground(ContextCompat.getDrawable(this, R.drawable.input_button_disable));

        buttonAdd = findViewById(R.id.button_add);
        noteInput = findViewById(R.id.noteInput);
    }

    @Override
    public void onClick(View view) {
        if (view.getId() == R.id.button_add) {
            addToDb(Calendar.getInstance().get(Calendar.HOUR_OF_DAY), noteInput.getText().toString());
        } else {
            final Button b = (Button) view;
            this.i = Integer.parseInt(b.getText().toString());
            button1.setBackground(ContextCompat.getDrawable(this, Integer.parseInt(button1.getText().toString()) > this.i ? R.drawable.input_button_disable : R.drawable.input_button));
            button2.setBackground(ContextCompat.getDrawable(this, Integer.parseInt(button2.getText().toString()) > this.i ? R.drawable.input_button_disable : R.drawable.input_button));
            button3.setBackground(ContextCompat.getDrawable(this, Integer.parseInt(button3.getText().toString()) > this.i ? R.drawable.input_button_disable : R.drawable.input_button));
            button4.setBackground(ContextCompat.getDrawable(this, Integer.parseInt(button4.getText().toString()) > this.i ? R.drawable.input_button_disable : R.drawable.input_button));
            button5.setBackground(ContextCompat.getDrawable(this, Integer.parseInt(button5.getText().toString()) > this.i ? R.drawable.input_button_disable : R.drawable.input_button));
            buttonAdd.setBackground(ContextCompat.getDrawable(this, R.drawable.accent_button));
            buttonAdd.setEnabled(true);
        }

    }

    void addToDb(int title, String notes) {
        Log.d(TAG, "addToDb() called with: title = [" + title + "] extras = [" + i + "] and notes = [" + notes + "]");
        Intent i1 = new Intent(getApplicationContext(), ClickReciever.class);
        i1.putExtra(AlarmNotificationService.CLICK_EXTRAS, i);
        i1.putExtra(AlarmNotificationService.CLICK_TITLE, title);
        i1.putExtra(AlarmNotificationService.CLICK_NOTES, notes);
        i1.setAction("");
        sendBroadcast(i1);
        exitActivity();
    }

}