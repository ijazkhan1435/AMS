package com.example.flutter_application_1.utility;

import android.os.Environment;
import android.util.Log;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import com.example.flutter_application_1.describe.GlobalDescribe;


/**
 * Created by miller.pan on 2019/1/29.
 */

public class LogHelp {

    private static volatile LogHelp instance = null;
    private static String LogFilePath;
    private static boolean mFlag = false;

    public static synchronized LogHelp getInstance() {
        if (instance == null) {
            instance = new LogHelp();
        }
        return instance;
    }

    public void Initial() {

        String root = Environment.getExternalStorageDirectory().getAbsolutePath();

        Calendar mCalendar = Calendar.getInstance();
        SimpleDateFormat dateformat = new SimpleDateFormat("yyyy-MM-dd");
        String datetime = dateformat.format(mCalendar.getTime());

        LogFilePath = String.format("%s%s/%s", root, GlobalDescribe.DEFAULT_FOLDER, datetime);
    }

    public void SetFlag(boolean flag) {
        mFlag = flag;
    }

    public void Write(String text) {

        Log.i(GlobalDescribe.TAG, text);
        if (mFlag == true) {
            appendLog(text);
        }
    }

    private void appendLog(String text) {
        if (LogFilePath == null)
            return;

        File logFile = new File(LogFilePath);
        if (!logFile.exists()) {
            try {
                logFile.createNewFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        try {
            Calendar mCalendar = Calendar.getInstance();
            SimpleDateFormat dateformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String temp = String.format("%s %s", dateformat.format(mCalendar.getTime()), text);
            BufferedWriter buf = new BufferedWriter(new FileWriter(logFile, true));
            buf.append(temp);
            buf.newLine();
            buf.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
