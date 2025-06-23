//package com.example.flutter_application_1;
//
//import android.content.BroadcastReceiver;
//import android.content.Context;
//import android.content.Intent;
//import android.content.IntentFilter;
//
//import com.cipherlab.rfid.ClResult;
//import com.cipherlab.rfid.DeviceVoltageInfo;
//import com.cipherlab.rfid.GeneralString;
//import com.cipherlab.rfid.InventoryType;
//import com.cipherlab.rfid.ScanMode;
//import com.cipherlab.rfidapi.RfidManager;
//import com.example.flutter_application_1.utility.TIDUtils;
//
//import java.util.HashMap;
//import java.util.HashSet;
//import java.util.Map;
//import java.util.Set;
//
//import io.flutter.plugin.common.MethodCall;
//import io.flutter.plugin.common.MethodChannel;
//import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
//import io.flutter.plugin.common.MethodChannel.Result;
//
// class RfidTagService implements MethodCallHandler {
//    private final RfidManager rfidManager;
//    private final Context context;
//    private final MethodChannel channel;
//
//    private static ScanMode scanMode;
//    private static boolean mSoftInventory = false;
//
//    private static final String TAG = "RfidTagService";
//    private static String connStatus = "Disconnected";
//
//
//    private final AppHelper helper;
//    private final TIDUtils utils;
//    private boolean isReceiverRegistered;
//
//    // Inventory Data
//    private final Map<String, InventoryItem> inventoryMap = new HashMap<>();
//    private final Set<String> unknownTags = new HashSet<>();
//    private int totalCount = 0;
//    private int scannedCount = 0;
//    private int unknownCount = 0;
//
//
////    InventoryItem = [
////    {
////        "name": "Item 1",
////            "tagId": "E20000163517020819004C23"
////    },
////    {
////        "name": "Item 2",
////            "tagId": "E20000163517020819004C24"
////    },
////    {
////        "name": "Item 3",
////            "tagId": "E20000163517020819004C25"
////    }
////]
//
//
//
//
//    public RfidTagService(Context context, MethodChannel channel) {
//        this.rfidManager = RfidManager.InitInstance(context);
//        this.context = context;
//        this.channel = channel;
//        this.helper = AppHelper.getInstance();
//        this.utils = TIDUtils.getInstance();
//        registerReceiver();
//       // loadInventoryData();
//    }
//
//    @Override
//    public void onMethodCall(MethodCall call, Result result) {
//        switch (call.method) {
//            case "getConnectionStatus":
//                System.out.println("Hello, Worldccc!");
//
//                result.success(getConnectionStatus());
//                break;
//            case "getServiceVersion":
//                result.success(rfidManager.GetServiceVersion());
//                break;
//            case "getBatteryLevel":
//
//
//
//                System.out.println("Hello, Worldddw!");
//                // DeviceVoltageInfo info = new DeviceVoltageInfo();
//                // int re = rfidManager.GetBatteryLifePercent(info);
//                // if (re == ClResult.S_OK.ordinal()) {
//                //     // Return the battery percentage
//                //     result.success(info.Percentage);
//                // } else {
//                //     // Handle error
//                //     String error = rfidManager.GetLastError();
//                //     result.error("ERROR", "GetBatteryLifePercent failed: " + error, null);
//                // }
//                break;
//            case "startInventory":
//                readTag();
//                result.success("Inventory Started");
//                break;
//
//            case "stopInventory":
//                stopInventory();
//                result.success("Inventory Stopped");
//                break;
//            case "readTag":
//                readTag();
//                result.success("Reading Tag...");
//                break;
////            case "getInventoryData":
////                result.success(getInventoryData());
////                break;
//            default:
//                result.notImplemented();
//                break;
//        }
//    }
//
//    private void startInventory() {
//        if (rfidManager == null) return;
//        rfidManager.RFIDDirectStartInventoryRound(InventoryType.EPC_AND_TID, 0);
//    }
//
//    private void readTag() {
//        helper.Inventory();
//    }
//
//
//
//    private void stopInventory() {
//        if (rfidManager == null) return;
//        rfidManager.RFIDDirectCancelInventoryRound();
//    }
//
//    private String getConnectionStatus() {
//            connStatus="Disconnected";
//
//        if (rfidManager != null) {
//            connStatus="Connected";
//        }
//        return connStatus;
//    }
//
//    private void updateConnectionStatus(String status) {
//        connStatus = status;
//        channel.invokeMethod("updateConnectionStatus", status); // Notify Flutter
//    }
//
//    public ScanMode GetScanMode() {
//        if (rfidManager == null)
//            return ScanMode.Err;
//
//        ScanMode mode = rfidManager.GetScanMode();
//      //  rfidManager.Write("GetScanMode = " + mode.toString());
//        return mode;
//    }
//
//    public void SetScanMode(ScanMode mode) {
//        rfidManager.SetScanMode(mode);
//    }
//
//    private void registerReceiver() {
//        IntentFilter filter = new IntentFilter();
//        filter.addAction(GeneralString.Intent_RFIDSERVICE_CONNECTED);
//        filter.addAction(GeneralString.Intent_RFIDSERVICE_TAG_DATA);
//        filter.addAction(GeneralString.Intent_GUN_Attached);
//        filter.addAction(GeneralString.Intent_GUN_Unattached);
//        context.registerReceiver(mMessageReceiver, filter);
//        isReceiverRegistered = true;
//        context.registerReceiver(mMessageReceiver, filter);
//    }
//    private final BroadcastReceiver mMessageReceiver = new BroadcastReceiver() {
//        @Override
//        public void onReceive(Context context, Intent intent) {
//            String action = intent.getAction();
//            if (action == null) return;
//            switch (action) {
//                case GeneralString.Intent_RFIDSERVICE_TAG_DATA:
//                    int response = intent.getIntExtra(GeneralString.EXTRA_RESPONSE, -1);
//                    if (response == GeneralString.RESPONSE_OPERATION_SUCCESS) {
//                        String EPC = intent.getStringExtra(GeneralString.EXTRA_EPC); //tag id
//                        //double rssi = intent.getDoubleExtra(GeneralString.EXTRA_DATA_RSSI,0); //get read power
//                        if (EPC != null) {
//                           // handleTagRead(EPC);
//                          //  Map<String, Object> tagData = new HashMap<>();
//                           // tagData.put("epc", EPC);
//                           // tagData.put("rssi", rssi);
//                            channel.invokeMethod("onTagRead", EPC);
//                        }
//                    }
//                    break;
//                case GeneralString.Intent_GUN_Attached:
//                    updateConnectionStatus("Connected");
//                    break;
//                case GeneralString.Intent_GUN_Unattached:
//                    updateConnectionStatus("Disconnected");
//                    break;
//            }
//        }
//    };
////    private void handleTagRead(String epc) {
////        //totalCount++;
////        InventoryItem item = inventoryMap.get(epc);
////        if (item != null) {
////            item.incrementReadCount();
////            scannedCount++;
////        } else {
////            unknownCount++;
////        }
////        // Update Flutter UI
////        channel.invokeMethod("updateCounters", getCounters());
////    }
//
////    private void loadInventoryData() {
////        // Dummy data; replace with actual data loading logic if needed
////        inventoryMap.put("E20000163517020819004C23", new InventoryItem("Item 1", "E20000163517020819004C23"));
////        inventoryMap.put("E20000163517020819004C24", new InventoryItem("Item 2", "E20000163517020819004C24"));
////        inventoryMap.put("E20000163517020819004C25", new InventoryItem("Item 3", "E20000163517020819004C25"));
////    }
//
////    private Map<String, Object> getInventoryData() {
////        Map<String, Object> data = new HashMap<>();
////        data.put("totalCount", totalCount);
////        data.put("scannedCount", scannedCount);
////        data.put("unknownCount", unknownCount);
////        data.put("inventory", inventoryMap.values());
////        return data;
////    }
//
//    private void handleTagRead(String epc) {
//        InventoryItem item = inventoryMap.get(epc);
//        if (item != null) {
//            if (item.getReadCount() == 0) {
//                item.incrementReadCount();
//                scannedCount++;
//            }
//        } else {
//            if (!unknownTags.contains(epc)) {
//                unknownTags.add(epc);
//                unknownCount++;
//            }
//        }
//        // Update Flutter UI
//     //   channel.invokeMethod("updateCounters", getCounters());
//    }
//
////    private Map<String, Integer> getCounters() {
////        Map<String, Integer> counters = new HashMap<>();
////        counters.put("scanned", scannedCount);
////        counters.put("unknown", unknownCount);
////        counters.put("unscanned", totalCount - scannedCount);
////        return counters;
////    }
//
////    private Map<String, Integer> getCounters() {
////        Map<String, Integer> counters = new HashMap<>();
////        counters.put("total", totalCount);
////        counters.put("scanned", scannedCount);
////        counters.put("unknown", unknownCount);
////        counters.put("unscanned", inventoryMap.size() - scannedCount);
////        return counters;
////    }
//
//    // InventoryItem class to hold inventory data
//    private static class InventoryItem {
//        private final String name;
//        private final String tagId;
//        private int readCount;
//
//        private double RSSI;
//
//        public InventoryItem(String name, String tagId,double rssi,int readCount) {
//            this.name = name;
//            this.tagId = tagId;
//            this.readCount = readCount;
//            this.RSSI=rssi;
//        }
//
//        public void incrementReadCount() {
//            this.readCount++;
//        }
//
//        public String getName() {
//            return name;
//        }
//
//        public String getTagId() {
//            return tagId;
//        }
//
//        public int getReadCount() {
//            return readCount;
//        }
//
//        public double getReadRssi() {
//            return RSSI;
//        }
//    }
//
//}




package com.example.flutter_application_1;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;

import com.cipherlab.rfid.ClResult;
import com.cipherlab.rfid.DeviceVoltageInfo;
import com.cipherlab.rfid.GeneralString;
import com.cipherlab.rfid.InventoryType;
import com.cipherlab.rfid.ScanMode;
import com.cipherlab.rfidapi.RfidManager;
import com.example.flutter_application_1.utility.TIDUtils;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

class RfidTagService implements MethodCallHandler {
    private final RfidManager rfidManager;
    private final Context context;
    private final MethodChannel channel;
    private static double[] boundary;
    private static ScanMode scanMode;
    private static boolean mSoftInventory = false;

    private static final String TAG = "RfidTagService";
    private static String connStatus = "Disconnected";


    private final AppHelper helper;
    private final TIDUtils utils;
    private boolean isReceiverRegistered;

    // Inventory Data
    private final Map<String, InventoryItem> inventoryMap = new HashMap<>();
    private final Set<String> unknownTags = new HashSet<>();
    private int totalCount = 0;
    private int scannedCount = 0;
    private int unknownCount = 0;

    String currentEPC = "";


    public RfidTagService(Context context, MethodChannel channel) {
        this.rfidManager = RfidManager.InitInstance(context);
        this.context = context;
        this.channel = channel;
        this.helper = AppHelper.getInstance();
        this.utils = TIDUtils.getInstance();
        registerReceiver();
        // loadInventoryData();
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
            case "getConnectionStatus":
                System.out.println("Hello, Worldccc!");

                result.success(getConnectionStatus());
                break;
            case "getServiceVersion":
                result.success(rfidManager.GetServiceVersion());
                break;
            case "getBatteryLevel":
                System.out.println("Hello, Worldddw!");
                break;
            case "startInventory":
                readTag();
                result.success("Inventory Started");
                break;

            case "startLocating":

                String tagId = call.argument("tagId");
                int range = call.argument("range");

                if (tagId != null &&  !tagId.isEmpty() ) {
                    Calculation(range);
                    currentEPC = tagId;
                    readTag();
                    result.success("Locating Started for " + tagId);
                }else {
                    result.error("INVALID_TAG_ID", "Tag ID and Range cannot be null or empty", null);
                }
                break;

            case "stopLocating":
                currentEPC="";
                break;

            case "stopInventory":
                stopInventory();
                result.success("Inventory Stopped");
                break;

            case "readTag":
                readTag();
                result.success("Reading Tag...");
                break;
//            case "getInventoryData":
//                result.success(getInventoryData());
//                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void Calculation(int index) {
        double max;
        switch (index) {
            default:
            case 0:
                max = -35;
                break;
            case 1:
                max = -40;
                break;
            case 2:
                max = -45;
                break;
        }

        boundary = null;
        boundary = new double[40];
        double interval = (max - (-80.0)) / 40;
        for (int i = 0; i < 40; i++) {
            boundary[i] = max - interval * i;
        }
    }

    private void ShowRSSI(double db) {

        if (db > boundary[0])
            SetPercentage(40);
        else if (db >= boundary[1] && db < boundary[0])
            SetPercentage(39);
        else if (db >= boundary[2] && db < boundary[1])
            SetPercentage(38);
        else if (db >= boundary[3] && db < boundary[2])
            SetPercentage(37);
        else if (db >= boundary[4] && db < boundary[3])
            SetPercentage(36);
        else if (db >= boundary[5] && db < boundary[4])
            SetPercentage(35);
        else if (db >= boundary[6] && db < boundary[5])
            SetPercentage(34);
        else if (db >= boundary[7] && db < boundary[6])
            SetPercentage(33);
        else if (db >= boundary[8] && db < boundary[7])
            SetPercentage(32);
        else if (db >= boundary[9] && db < boundary[8])
            SetPercentage(31);
        else if (db >= boundary[10] && db < boundary[9])
            SetPercentage(30);
        else if (db >= boundary[11] && db < boundary[10])
            SetPercentage(29);
        else if (db >= boundary[12] && db < boundary[11])
            SetPercentage(28);
        else if (db >= boundary[13] && db < boundary[12])
            SetPercentage(27);
        else if (db >= boundary[14] && db < boundary[13])
            SetPercentage(26);
        else if (db >= boundary[15] && db < boundary[14])
            SetPercentage(25);
        else if (db >= boundary[16] && db < boundary[15])
            SetPercentage(24);
        else if (db >= boundary[17] && db < boundary[16])
            SetPercentage(23);
        else if (db >= boundary[18] && db < boundary[17])
            SetPercentage(22);
        else if (db >= boundary[19] && db < boundary[18])
            SetPercentage(21);
        else if (db >= boundary[20] && db < boundary[19])
            SetPercentage(20);
        else if (db >= boundary[21] && db < boundary[20])
            SetPercentage(19);
        else if (db >= boundary[22] && db < boundary[21])
            SetPercentage(18);
        else if (db >= boundary[23] && db < boundary[22])
            SetPercentage(17);
        else if (db >= boundary[24] && db < boundary[23])
            SetPercentage(16);
        else if (db >= boundary[25] && db < boundary[24])
            SetPercentage(15);
        else if (db >= boundary[26] && db < boundary[25])
            SetPercentage(14);
        else if (db >= boundary[27] && db < boundary[26])
            SetPercentage(13);
        else if (db >= boundary[28] && db < boundary[27])
            SetPercentage(12);
        else if (db >= boundary[29] && db < boundary[28])
            SetPercentage(11);
        else if (db >= boundary[30] && db < boundary[29])
            SetPercentage(10);
        else if (db >= boundary[31] && db < boundary[30])
            SetPercentage(9);
        else if (db >= boundary[32] && db < boundary[31])
            SetPercentage(8);
        else if (db >= boundary[33] && db < boundary[32])
            SetPercentage(7);
        else if (db >= boundary[34] && db < boundary[33])
            SetPercentage(6);
        else if (db >= boundary[35] && db < boundary[34])
            SetPercentage(5);
        else if (db >= boundary[36] && db < boundary[35])
            SetPercentage(4);
        else if (db >= boundary[37] && db < boundary[36])
            SetPercentage(3);
        else if (db >= boundary[38] && db < boundary[37])
            SetPercentage(2);
        else if (db >= boundary[39] && db < boundary[38])
            SetPercentage(1);
        else
            SetPercentage(0);
    }
    private void startInventory() {
        if (rfidManager == null) return;
        rfidManager.RFIDDirectStartInventoryRound(InventoryType.EPC_AND_TID, 0);
    }

    private void readTag() {
        helper.Inventory();
    }

    private void SetPercentage(int percentage) {
        channel.invokeMethod("onTagLocated", percentage);
    }
    private void stopInventory() {
        if (rfidManager == null) return;
        rfidManager.RFIDDirectCancelInventoryRound();
    }

    private String getConnectionStatus() {
        connStatus = "Disconnected";

        if (rfidManager != null) {
            connStatus = "Connected";
        }
        return connStatus;
    }

    private void updateConnectionStatus(String status) {
        connStatus = status;
        channel.invokeMethod("updateConnectionStatus", status); // Notify Flutter
    }

    public ScanMode GetScanMode() {
        if (rfidManager == null)
            return ScanMode.Err;

        ScanMode mode = rfidManager.GetScanMode();
        //  rfidManager.Write("GetScanMode = " + mode.toString());
        return mode;
    }

    public void SetScanMode(ScanMode mode) {
        rfidManager.SetScanMode(mode);
    }

    private void registerReceiver() {
        IntentFilter filter = new IntentFilter();
        filter.addAction(GeneralString.Intent_RFIDSERVICE_CONNECTED);
        filter.addAction(GeneralString.Intent_RFIDSERVICE_TAG_DATA);
        filter.addAction(GeneralString.Intent_GUN_Attached);
        filter.addAction(GeneralString.Intent_GUN_Unattached);
        context.registerReceiver(mMessageReceiver, filter);
        isReceiverRegistered = true;
    }

    private final BroadcastReceiver mMessageReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            if (action == null) return;
            switch (action) {
                case GeneralString.Intent_RFIDSERVICE_TAG_DATA:
                    int response = intent.getIntExtra(GeneralString.EXTRA_RESPONSE, -1);
                    if (response == GeneralString.RESPONSE_OPERATION_SUCCESS) {
                        String EPC = intent.getStringExtra(GeneralString.EXTRA_EPC); //tag id
                        //double rssi = intent.getDoubleExtra(GeneralString.EXTRA_DATA_RSSI,0); //get read power
                        if (EPC != null) {
                            // handleTagRead(EPC);
                            //  Map<String, Object> tagData = new HashMap<>();
                            // tagData.put("epc", EPC);
                            // tagData.put("rssi", rssi);
                            if (!currentEPC.isEmpty()) {

                                double rssi = intent.getDoubleExtra(GeneralString.EXTRA_DATA_RSSI, 0);
                                if (currentEPC != null) {
                                    if (currentEPC.equals(EPC)) {
                                        ShowRSSI(rssi);
                                    }
                                }
                            }else {
                                channel.invokeMethod("onTagRead", EPC);
                            }

                        }
                    }
                    break;
                case GeneralString.Intent_GUN_Attached:
                    updateConnectionStatus("Connected");
                    break;
                case GeneralString.Intent_GUN_Unattached:
                    updateConnectionStatus("Disconnected");
                    break;
            }
        }
    };

    private void handleTagRead(String epc) {
        InventoryItem item = inventoryMap.get(epc);
        if (item != null) {
            if (item.getReadCount() == 0) {
                item.incrementReadCount();
                scannedCount++;
            }
        } else {
            if (!unknownTags.contains(epc)) {
                unknownTags.add(epc);
                unknownCount++;
            }
        }
        // Update Flutter UI
        //   channel.invokeMethod("updateCounters", getCounters());
    }

    // InventoryItem class to hold inventory data
    private static class InventoryItem {
        private final String name;
        private final String tagId;
        private int readCount;

        private double RSSI;

        public InventoryItem(String name, String tagId, double rssi, int readCount) {
            this.name = name;
            this.tagId = tagId;
            this.readCount = readCount;
            this.RSSI = rssi;
        }

        public void incrementReadCount() {
            this.readCount++;
        }

        public String getName() {
            return name;
        }

        public String getTagId() {
            return tagId;
        }

        public int getReadCount() {
            return readCount;
        }

        public double getReadRssi() {
            return RSSI;
        }
    }

}
