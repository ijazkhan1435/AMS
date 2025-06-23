package com.example.flutter_application_1.utility;

import android.content.Context;
import android.widget.Toast;

public class StringEX {

    public static boolean IsNullOrEmpty(String string) {
        return string == null || string.equals("");
    }

    public static void ShowMessage(Context context, CharSequence text) {
        Toast t = Toast.makeText(context, text, Toast.LENGTH_SHORT);
        t.show();
    }

    public static void ShowMessage(Context context, int resId) {
        Toast t = Toast.makeText(context, resId, Toast.LENGTH_SHORT);
        t.show();
    }
}
