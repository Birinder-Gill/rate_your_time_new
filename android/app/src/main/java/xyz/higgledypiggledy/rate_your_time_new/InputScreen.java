package xyz.higgledypiggledy.rate_your_time_new;


import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;

public class InputScreen extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {


        super.onCreate(savedInstanceState);
        TextView txt=new TextView(this);

        txt.setText("This is the message!");
        setContentView(R.layout.notification_rate);
    }
}