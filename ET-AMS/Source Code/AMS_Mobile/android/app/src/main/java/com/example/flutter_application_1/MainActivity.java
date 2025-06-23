package com.example.flutter_application_1;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import android.os.Bundle;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
 import io.flutter.plugin.common.MethodChannel;

 public class MainActivity extends FlutterActivity {

     private final AppHelper helper = AppHelper.getInstance();
    private static final String CHANNEL = "rfid";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {

                System.out.println("Hello, World!");

        super.configureFlutterEngine(flutterEngine);
        MethodChannel channel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL);
        channel.setMethodCallHandler(new RfidTagService(getApplicationContext(), channel));
    }
}
//
//package com.example.flutter_application_1;
//
//import android.os.Bundle;
//import androidx.annotation.NonNull;
//import io.flutter.embedding.android.FlutterActivity;
//import io.flutter.embedding.engine.FlutterEngine;
//import io.flutter.plugin.common.MethodChannel;
//
//public class MainActivity extends FlutterActivity {
//    private static final String CHANNEL = "com.example.rfid";
//
//    @Override
//    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
//        super.configureFlutterEngine(flutterEngine);
//
//        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
//                .setMethodCallHandler(
//                        (call, result) -> {
//                            if (call.method.equals("showRssi")) {
//                                double rssi = call.argument("rssi");
//                                ShowRSSI(rssi);
//                                result.success(null);
//                            } else {
//                                result.notImplemented();
//                            }
//                        }
//                );
//    }
//
//    private void ShowRSSI(double db) {
//        // Your ShowRSSI implementation here.
//        if (db > boundary[0])
//            SetImage(40);
//        else if (db >= boundary[1] && db < boundary[0])
//            SetImage(39);
//        // continue your existing ShowRSSI code...
//    }
//
//    private void SetImage(int index) {
//        // Implement your SetImage method here
//    }
//}
//
