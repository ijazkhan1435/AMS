//package sw.programme.flutter_application_1;
//
//import android.content.BroadcastReceiver;
//import android.content.Context;
//import android.content.Intent;
//import android.content.IntentFilter;
//import android.content.res.Resources;
//import android.content.res.TypedArray;
//import android.os.Bundle;
//import android.text.Editable;
//import android.text.TextWatcher;
//import android.view.KeyEvent;
//import android.view.Menu;
//import android.view.MenuItem;
//import android.view.View;
////import android.widget.AdapterView;
//import android.widget.ArrayAdapter;
////import android.widget.EditText;
////import android.widget.ImageView;
////import android.widget.Spinner;
//
////import androidx.appcompat.app.AppCompatActivity;
//
//import com.cipherlab.rfid.GeneralString;
//import com.cipherlab.rfid.RFIDMode;
//import com.cipherlab.rfid.RfidEpcFilter;
//
//import java.util.Timer;
//import java.util.TimerTask;
//
//import sw.programme.ezedit1.describe.GlobalDescribe;
//import sw.programme.ezedit1.utility.StringEX;
//
//
//public class LocationActivity extends AppCompatActivity {
//
//
//
//    private final AppHelper helper = AppHelper.getInstance();
//    private boolean isReceiverRegistered;
//    private boolean isKeyPressed;
//    private static int preIndex = -1;
//    private static int setValues = -1;
//    private static String currentEPC;
//    private static double[] boundary;
//    private Timer schedule = null;
//
//    @Override
//    protected void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
////        setContentView(R.layout.activity_location);
////        this.getSupportActionBar().setTitle(R.string.STR_TagLocating);
////
////
////        Ctrl_EPC.addTextChangedListener(new TextWatcher() {
////
////            @Override
////            public void afterTextChanged(Editable s) {
////            }
////
////            @Override
////            public void beforeTextChanged(CharSequence s, int start,
////                                          int count, int after) {
////            }
////
////            @Override
////            public void onTextChanged(CharSequence s, int start,
////                                      int before, int count) {
////                if (s.length() > 0) {
////                    currentEPC = s.toString();
////                    SetImage(0);
////                    //helper.WriteLog(String.format("currentEPC=%s", currentEPC));
////                }
////            }
////        });
//
//        Resources res = getResources();
//        ArrayAdapter<String> adapter1 = new ArrayAdapter<>(this,
//                R.layout.dropdown_item, res.getStringArray(R.array.signal_option));
//        Ctrl_Max.setAdapter(adapter1);
//        Ctrl_Max.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
//
//            @Override
//            public void onItemSelected(AdapterView<?> parentView, View selectedItemView, int position, long id) {
//                Calculation(position);
//                SetImage(0);
//            }
//
//            @Override
//            public void onNothingSelected(AdapterView<?> parentView) {
//
//            }
//        });
//        Ctrl_Max.setSelection(1);
//
//        Ctrl_Signal = findViewById(R.id.imageView1);
//        AssignImage(0);
//
//        preIndex = -1;
//        Intent intent = this.getIntent();
//        if (intent != null) {
//            String temp = intent.getStringExtra(GlobalDescribe.EXTRA_DATA);
//            if (temp != null) {
//                RfidEpcFilter rfid_cmd = new RfidEpcFilter();
//                helper.GetIncludedEPCFilter(rfid_cmd);
//                Ctrl_EPC.setText(temp);
//                currentEPC = temp;
//                SetEPCTarget(currentEPC);
//            }
//        } else {
//            currentEPC = "";
//        }
//        schedule = new Timer();
//        schedule.schedule(task, 0, 3000);
//    }
//
//    @Override
//    public void onDestroy() {
//        if (schedule != null)
//            schedule.cancel();
//        schedule = null;
//        super.onDestroy();
//    }
//
//    private final TimerTask task = new TimerTask() {
//        @Override
//        public void run() {
//            Intent intent = new Intent(GlobalDescribe.SEND_TIMER_CHANGE);
//            AppHelper helper = AppHelper.getInstance();
//            helper.getContext().sendBroadcast(intent);
//        }
//    };
//
//    private void SetEPCTarget(String epc) {
//        if (epc == null) {
//            RfidEpcFilter rfid_cmd_009 = new RfidEpcFilter();
//            helper.SetIncludedEPCFilter(rfid_cmd_009);
//        } else {
//            String header = epc.substring(0, 2);
//            int bitLength = epc.length() * 4;
//
//            RfidEpcFilter rfid_cmd_009 = new RfidEpcFilter();
//            rfid_cmd_009.EPCPattern1 = epc;
//            rfid_cmd_009.Enable = 0x01;
//            rfid_cmd_009.EPCPattern2 = null;
//            rfid_cmd_009.Scheme = (byte) Integer.parseInt(header, 16);
//            rfid_cmd_009.Startbit_MSB = 0;
//            rfid_cmd_009.Startbit_LSB = 0;
//            rfid_cmd_009.PatternLength_MSB = (byte) (bitLength << 8);
//            rfid_cmd_009.PatternLength_LSB = (byte) (bitLength & 0xFF);
//
//            helper.SetIncludedEPCFilter(rfid_cmd_009);
//        }
//    }
//
//    public void AssignImage(int position) {
//        TypedArray typedArray = getResources().obtainTypedArray(R.array.sign_imgs);
//        //typedArray.recycle();
//        Ctrl_Signal.setImageResource(typedArray.getResourceId(position, 0));
//    }
//
//    @Override
//    public void onPause() {
//
//        if (isReceiverRegistered) {
//            try {
//                unregisterReceiver(mMessageReceiver);
//            } catch (IllegalArgumentException e) {
//                e.getStackTrace();
//            }
//            isReceiverRegistered = false;
//        }
//        super.onPause();
//    }
//
//    @Override
//    public void onResume() {
//
//        if (helper.GetConnectionStatus()) {
//            helper.SetRFIDMode(RFIDMode.Inventory);
//        }
//
//        if (!isReceiverRegistered) {
//            IntentFilter filter = new IntentFilter();
//            filter.addAction(GeneralString.Intent_RFIDSERVICE_TAG_DATA);
//            filter.addAction(GeneralString.Intent_GUN_Attached);
//            filter.addAction(GeneralString.Intent_GUN_Unattached);
//            filter.addAction(GlobalDescribe.SEND_TIMER_CHANGE);
//            registerReceiver(mMessageReceiver, filter);
//            isReceiverRegistered = true;
//        }
//        super.onResume();
//    }
//
//    @Override
//    public boolean onCreateOptionsMenu(Menu menu) {
//
//        getMenuInflater().inflate(R.menu.menu_read, menu);
//        return true;
//    }
//
//    @Override
//    public boolean onOptionsItemSelected(MenuItem item) {
//
//        if (item.getItemId() == R.id.action_reset) {
//            preIndex = -1;
//            currentEPC = "";
//            Ctrl_EPC.setText("");
//            ;SetEPCTarget(null);
//            SetImage(0);
//            Ctrl_Max.setSelection(1);
//        }
//
//        return super.onOptionsItemSelected(item);
//    }
//
//    @Override
//    public boolean dispatchKeyEvent(KeyEvent event) {
//
//        if (event.getKeyCode() == 545) {
//            int keyaction = event.getAction();
//            if (keyaction == KeyEvent.ACTION_DOWN) {
//                Ctrl_Max.setEnabled(false);
//                isKeyPressed = true;
//            } else if (keyaction == KeyEvent.ACTION_UP) {
//                Ctrl_Max.setEnabled(true);
//                isKeyPressed = false;
//                SetImage(0);
//            }
//        }
//        return super.dispatchKeyEvent(event);
//    }
//
//    private void SetImage(int index) {
//        if (index == preIndex)
//            return;
//
//        if (index != -1) {
//            AssignImage(index);
//        }
//        preIndex = index;
//    }
//
//    private void Calculation(int index) {
//        double max;
//        switch (index) {
//            default:
//            case 0:
//                max = -35;
//                break;
//            case 1:
//                max = -40;
//                break;
//            case 2:
//                max = -45;
//                break;
//        }
//
//        boundary = null;
//        boundary = new double[40];
//        double interval = (max - (-80.0)) / 40;
//        for (int i = 0; i < 40; i++) {
//            boundary[i] = max - interval * i;
//        }
//    }
//
//    private void ShowRSSI(double db) {
//
//        if (db > boundary[0])
//            SetImage(40);
//        else if (db >= boundary[1] && db < boundary[0])
//            SetImage(39);
//        else if (db >= boundary[2] && db < boundary[1])
//            SetImage(38);
//        else if (db >= boundary[3] && db < boundary[2])
//            SetImage(37);
//        else if (db >= boundary[4] && db < boundary[3])
//            SetImage(36);
//        else if (db >= boundary[5] && db < boundary[4])
//            SetImage(35);
//        else if (db >= boundary[6] && db < boundary[5])
//            SetImage(34);
//        else if (db >= boundary[7] && db < boundary[6])
//            SetImage(33);
//        else if (db >= boundary[8] && db < boundary[7])
//            SetImage(32);
//        else if (db >= boundary[9] && db < boundary[8])
//            SetImage(31);
//        else if (db >= boundary[10] && db < boundary[9])
//            SetImage(30);
//        else if (db >= boundary[11] && db < boundary[10])
//            SetImage(29);
//        else if (db >= boundary[12] && db < boundary[11])
//            SetImage(28);
//        else if (db >= boundary[13] && db < boundary[12])
//            SetImage(27);
//        else if (db >= boundary[14] && db < boundary[13])
//            SetImage(26);
//        else if (db >= boundary[15] && db < boundary[14])
//            SetImage(25);
//        else if (db >= boundary[16] && db < boundary[15])
//            SetImage(24);
//        else if (db >= boundary[17] && db < boundary[16])
//            SetImage(23);
//        else if (db >= boundary[18] && db < boundary[17])
//            SetImage(22);
//        else if (db >= boundary[19] && db < boundary[18])
//            SetImage(21);
//        else if (db >= boundary[20] && db < boundary[19])
//            SetImage(20);
//        else if (db >= boundary[21] && db < boundary[20])
//            SetImage(19);
//        else if (db >= boundary[22] && db < boundary[21])
//            SetImage(18);
//        else if (db >= boundary[23] && db < boundary[22])
//            SetImage(17);
//        else if (db >= boundary[24] && db < boundary[23])
//            SetImage(16);
//        else if (db >= boundary[25] && db < boundary[24])
//            SetImage(15);
//        else if (db >= boundary[26] && db < boundary[25])
//            SetImage(14);
//        else if (db >= boundary[27] && db < boundary[26])
//            SetImage(13);
//        else if (db >= boundary[28] && db < boundary[27])
//            SetImage(12);
//        else if (db >= boundary[29] && db < boundary[28])
//            SetImage(11);
//        else if (db >= boundary[30] && db < boundary[29])
//            SetImage(10);
//        else if (db >= boundary[31] && db < boundary[30])
//            SetImage(9);
//        else if (db >= boundary[32] && db < boundary[31])
//            SetImage(8);
//        else if (db >= boundary[33] && db < boundary[32])
//            SetImage(7);
//        else if (db >= boundary[34] && db < boundary[33])
//            SetImage(6);
//        else if (db >= boundary[35] && db < boundary[34])
//            SetImage(5);
//        else if (db >= boundary[36] && db < boundary[35])
//            SetImage(4);
//        else if (db >= boundary[37] && db < boundary[36])
//            SetImage(3);
//        else if (db >= boundary[38] && db < boundary[37])
//            SetImage(2);
//        else if (db >= boundary[39] && db < boundary[38])
//            SetImage(1);
//        else
//            SetImage(0);
//    }
//
//    private final BroadcastReceiver mMessageReceiver = new BroadcastReceiver() {
//
//        @Override
//        public void onReceive(Context context, Intent intent) {
//
//            String action = intent.getAction();
//            if (action == null)
//                return;
//            switch (action) {
//                case GeneralString.Intent_RFIDSERVICE_TAG_DATA:
//                    int response = intent.getIntExtra(GeneralString.EXTRA_RESPONSE, -1);
//                    switch (response) {
//                        case GeneralString.RESPONSE_OPERATION_SUCCESS:
//                            String EPC = intent.getStringExtra(GeneralString.EXTRA_EPC);
//                            if (EPC != null) {
//                                if (isKeyPressed) {
//                                    String field = Ctrl_EPC.getText().toString();
//                                    if (StringEX.IsNullOrEmpty(field))
//                                        Ctrl_EPC.setText(EPC);
//
//                                    double rssi = intent.getDoubleExtra(GeneralString.EXTRA_DATA_RSSI, 0);
//                                    if (currentEPC != null) {
//                                        if (currentEPC.equals(EPC)) {
//                                            ShowRSSI(rssi);
//                                        }
//                                    }
//                                }
//                            }
//                            break;
//                        case GeneralString.RESPONSE_OPERATION_FINISH:
//                            helper.WriteLog("OPERATION_FINISH");
//                            StringEX.ShowMessage(context, R.string.MSG_OperationSuccess);
//                            break;
//                        case GeneralString.RESPONSE_OPERATION_FAIL:
//                        case GeneralString.RESPONSE_OPERATION_TIMEOUT_FAIL:
//                            helper.WriteLog("OPERATION_FAIL");
//                            StringEX.ShowMessage(context, R.string.MSG_OperationFail);
//                            break;
//                        case 3: /* TAG_LOCK */
//                            helper.WriteLog("TAG_LOCK");
//                            StringEX.ShowMessage(context, R.string.MSG_TagLocked);
//                            break;
//                        case GeneralString.RESPONSE_PASSWORD_FAIL:
//                            helper.WriteLog("Access Password Fail");
//                            StringEX.ShowMessage(context, R.string.MSG_AccessPasswordFail);
//                            break;
//                        case GeneralString.RESPONSE_DEVICE_BUSY:
//                            helper.WriteLog("DEVICE_BUSY");
//                            StringEX.ShowMessage(context, R.string.MSG_OperationFail);
//                            break;
//                        default:
//                            helper.WriteLog("response = " + response);
//                            break;
//                    }
//                    break;
//                case GeneralString.Intent_GUN_Attached:
//                    helper.WriteLog("Intent_GUN_Attached");
//
//                    break;
//                case GeneralString.Intent_GUN_Unattached:
//                    helper.WriteLog("Intent_GUN_Unattached");
//                    break;
//                case GlobalDescribe.SEND_TIMER_CHANGE:
//                    SetImage(0);
//                    break;
//            }
//        }
//    };
//}
