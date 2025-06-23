package com.example.flutter_application_1;
import android.content.Context;
import android.os.Environment;

import com.cipherlab.rfid.AuthenticateIncRepLen;
import com.cipherlab.rfid.AuthenticateSenRep;
import com.cipherlab.rfid.DeviceResponse;
import com.cipherlab.rfid.DeviceVoltageInfo;
import com.cipherlab.rfid.InventoryType;
import com.cipherlab.rfid.LockTarget;
import com.cipherlab.rfid.RFIDMemoryBank;
import com.cipherlab.rfid.RFIDMode;
import com.cipherlab.rfid.RfidEpcFilter;
import com.cipherlab.rfid.ScanMode;
import com.cipherlab.rfid.UntraceableRange;
import com.cipherlab.rfid.UntraceableTID;
import com.cipherlab.rfid.UntraceableU;
import com.cipherlab.rfid.UntraceableUser;
import com.cipherlab.rfid.WorkMode;
import com.cipherlab.rfidapi.RfidManager;

import java.io.File;
import java.util.Locale;

import com.example.flutter_application_1.describe.EditSettings;
import com.example.flutter_application_1.describe.GlobalDescribe;
import com.example.flutter_application_1.utility.LogHelp;
import com.example.flutter_application_1.utility.UtilityHelp;

public class AppHelper {

    private static Context mContext;
    private static RfidManager mManager = null;
    private static volatile AppHelper instance = null;
    private static EditSettings mUISetting;
    private static final LogHelp mRecorder = LogHelp.getInstance();
    private static String mFolderPath = null;
    private static String mEPC = "";
    private static boolean mSoftInventory = false;
    private final int RETRY_COUNT = 5;

    private AppHelper() {

    }

    public static synchronized AppHelper getInstance() {
        if (instance == null) {
            instance = new AppHelper();
        }
        return instance;
    }

    public static boolean Initial(Context context) {
        mContext = context;

        String root = Environment.getExternalStorageDirectory().getAbsolutePath();
        mFolderPath = String.format("%s%s", root, GlobalDescribe.DEFAULT_FOLDER);
        File dir = new File(mFolderPath);
        if (dir.exists() && dir.isDirectory()) {
            // do something here
        } else {
            dir.mkdirs();
        }
        mRecorder.Initial();

        mManager = RfidManager.InitInstance(context);
        return true;
    }

    public void Release() {
        if (mManager != null) {
            mManager.Release();
        }
    }

    public Context getContext() {
        return mContext;
    }

    public boolean ReadLogStatus() {
        String str = String.format("%s/%s", mFolderPath, GlobalDescribe.FILENAME);
        File dir = new File(str);
        if (dir.exists()) {
            mUISetting = (EditSettings) UtilityHelp.DeserializeJson(
                    str, EditSettings.class);
        }

        if (mUISetting == null) {
            mUISetting = new EditSettings();
            WriteSetting();
        }

        return mUISetting.LogFile;
    }

    public boolean ReadEncodeEPC() {
        if (mUISetting == null)
            return false;

        return mUISetting.Encode_EPC;
    }

    public void WriteSetting() {
        String str = String.format("%s/%s", mFolderPath, GlobalDescribe.FILENAME);
        UtilityHelp.SerializeJson(mContext, str, mUISetting, EditSettings.class);
    }

    public EditSettings GetSetting() {
        if (mUISetting == null) {
            mUISetting = new EditSettings();
        }

        return mUISetting;
    }

    public boolean GetConnectionStatus() {
        if (mManager == null)
            return false;

        return mManager.GetConnectionStatus();
    }

    public void SetSoftwareTrigger(boolean flag) {
        if (mManager == null)
            return;

        int ret = mManager.SoftScanTrigger(flag);
        if (ret != 0) {
            mRecorder.Write("SoftScanTrigger = " + mManager.GetLastError());
        } else {
            mSoftInventory = flag;
            mRecorder.Write("SoftScanTrigger = " + flag);
        }
    }

    public boolean GetSoftwareTriggerStatus() {
        return mSoftInventory;
    }

    public void SetRFIDMode(RFIDMode mode) {
        if (mManager == null)
            return;

        int ret = mManager.SetRFIDMode(mode);
        if (ret != 0) {
            mRecorder.Write("SetRFIDMode = " + mManager.GetLastError());
        } else {
            mRecorder.Write("SetRFIDMode = " + mode);
        }
    }

    public int getReaderBatterylife() {
        DeviceVoltageInfo batteryInfo = new DeviceVoltageInfo();
        return mManager.GetBatteryLifePercent(batteryInfo);
    }


    public RFIDMode GetRFIDMode() {
        if (mManager == null)
            return RFIDMode.Err;

        RFIDMode mode = mManager.GetRFIDMode();
        mRecorder.Write("SetRFIDMode = " + mode);
        return mode;
    }

    public WorkMode GetWorkMode() {
        if (mManager == null)
            return null;

        WorkMode mode = mManager.GetWorkMode();
        mRecorder.Write("GetWorkMode = " + mode.toString());
        return mode;
    }

    public void SetWorkMode(WorkMode mode) {
        if (mManager == null)
            return;

        int ret = mManager.SetWorkMode(mode);
        if (ret != 0) {
            mRecorder.Write("SetWorkMode = " + mManager.GetLastError());
        } else {
            mRecorder.Write("SetWorkMode = " + mode.toString());
        }
    }

    public ScanMode GetScanMode() {
        if (mManager == null)
            return ScanMode.Err;

        ScanMode mode = mManager.GetScanMode();
        mRecorder.Write("GetScanMode = " + mode.toString());
        return mode;
    }

    public void SetScanMode(ScanMode mode) {
        if (mManager == null)
            return;

        int ret = mManager.SetScanMode(mode);
        if (ret != 0) {
            mRecorder.Write("SetScanMode = " + mManager.GetLastError());
        } else {
            mRecorder.Write("SetScanMode = " + mode.toString());
        }
    }

    public void SetHardwareTriggerStatus(boolean enable) {
        if (mManager == null)
            return;

        int ret = mManager.EnableDeviceTrigger(enable);
        if (ret != 0) {
            mRecorder.Write("EnableDeviceTrigger = " + mManager.GetLastError());
        } else {
            mRecorder.Write("EnableDeviceTrigger = " + enable);
        }

    }

    public boolean GetTriggerStatus() {
        if (mManager == null)
            return false;

        int Status = mManager.DeviceTriggerStatus();
        if (Status == -1) {
            mRecorder.Write("DeviceTriggerStatus = " + mManager.GetLastError());
        } else {
            mRecorder.Write("DeviceTriggerStatus = " + Status);
        }

        return Status == 1;
    }

    public void Inventory() {
        if (mManager == null)
            return;

        int ret = mManager.RFIDDirectStartInventoryRound(InventoryType.EPC_AND_TID, 1);
        if (ret != 0) {
            mRecorder.Write("RFIDDirectStartInventoryRound = " + mManager.GetLastError());
        } else {
            mRecorder.Write("RFIDDirectStartInventoryRound");
        }
    }

    public void CancelInventory() {
        if (mManager == null)
            return;

        int ret = mManager.RFIDDirectCancelInventoryRound();
        if (ret != 0) {
            mRecorder.Write("RFIDDirectCancelInventoryRound = " + mManager.GetLastError());
        } else {
            mRecorder.Write("RFIDDirectCancelInventoryRound");
        }
    }

    public boolean ReadTag(byte[] password, byte[] epc, RFIDMemoryBank bank, int start, int length) {
        if (mManager == null)
            return false;

        int ret = mManager.RFIDDirectReadTagByEPC(password, epc, bank, start, length, RETRY_COUNT);
        if (ret != 0) {
            mRecorder.Write("RFIDDirectReadTagByEPC = " + mManager.GetLastError());
        } else {
            mRecorder.Write(String.format(Locale.getDefault(), "RFIDDirectReadTagByEPC bank=%s start=%d length=%d",
                    bank.toString(), start, length));
            return true;
        }

        return false;
    }

    public boolean WriteTag(byte[] password, byte[] epc, RFIDMemoryBank bank, int start, byte[] data) {
        if (mManager == null)
            return false;

        DeviceResponse ret = mManager.RFIDDirectWriteTagByEPC(password, epc, bank, start, RETRY_COUNT, data);
        if (ret != DeviceResponse.OperationSuccess) {
            mRecorder.Write("RFIDDirectWriteTagByEPC = " + mManager.GetLastError());
        } else {
            mRecorder.Write(String.format(Locale.getDefault(), "RFIDDirectWriteTagByEPC bank=%s start=%d data len=%d bytes",
                    bank.toString(), start, data.length));
            return true;
        }

        return false;
    }

    public boolean WriteReservedBank(byte[] password, byte[] epc, int start, byte[] data) {
        if (mManager == null)
            return false;

        DeviceResponse ret = mManager.RFIDDirectWriteTagByEPC(password, epc, RFIDMemoryBank.Reserved, start, RETRY_COUNT, data);
        if (ret != DeviceResponse.OperationSuccess) {
            mRecorder.Write("RFIDDirectWriteTagByEPC = " + mManager.GetLastError());
        } else {
            mRecorder.Write(String.format(Locale.getDefault(), "RFIDDirectWriteTagByEPC start=%d data=%s",
                    start, data));
            return true;
        }

        return false;
    }

    public boolean LockTag(byte[] password, byte[] epc, LockTarget target) {
        if (mManager == null)
            return false;

        DeviceResponse ret = mManager.RFIDDirectLockTag(password, epc, target);
        if (ret != DeviceResponse.OperationSuccess) {
            mRecorder.Write("RFIDDirectLockTag = " + mManager.GetLastError());
        } else {
            mRecorder.Write(String.format(Locale.getDefault(), "RFIDDirectLockTag target=%s", target.toString()));
            return true;
        }

        return false;
    }

    public boolean UnlockTag(byte[] password, byte[] epc, LockTarget target) {
        if (mManager == null)
            return false;

        DeviceResponse ret = mManager.RFIDDirectUnlockTag(password, epc, target);
        if (ret != DeviceResponse.OperationSuccess) {
            mRecorder.Write("RFIDDirectUnlockTag = " + mManager.GetLastError());
        } else {
            mRecorder.Write(String.format(Locale.getDefault(), "RFIDDirectUnlockTag target=%s", target.toString()));
            return true;
        }

        return false;
    }

    public void SetUntraceableTag(byte[] password, byte[] epc, int value1, UntraceableTID value2, UntraceableUser value3) {
        if (mManager == null)
            return;

        DeviceResponse ret = mManager.RFIDDirectUntraceableTag(password,
                RFIDMemoryBank.EPC,
                4,
                epc,
                UntraceableU.DeassertU,
                value1,
                value2,
                value3,
                UntraceableRange.Normal,
                RETRY_COUNT);
        if (ret != DeviceResponse.OperationSuccess) {
            mRecorder.Write("RFIDDirectUntraceableTag = " + mManager.GetLastError());
        } else {
            mRecorder.Write("RFIDDirectUntraceableTag = success");
        }
    }

    public void SetAuthenticateTag(byte[] password, byte[] epc, byte[] message) {
        if (mManager == null)
            return;

        DeviceResponse ret = mManager.RFIDDirectAuthenticateTag(password,
                RFIDMemoryBank.EPC,
                4,
                epc,
                AuthenticateSenRep.Send,
                AuthenticateIncRepLen.Included_Length_From_Reply,
                message,
                RETRY_COUNT);
        if (ret != DeviceResponse.OperationSuccess) {
            mRecorder.Write("RFIDDirectAuthenticateTag = " + mManager.GetLastError());
        } else {
            mRecorder.Write("RFIDDirectAuthenticateTag = success");
        }
    }

    public boolean GetIncludedEPCFilter(RfidEpcFilter rfid_cmd) {
        if (mManager == null)
            return false;

        int ret = mManager.GetIncludedEPCFilter(rfid_cmd);
        if (ret != 0) {
            mRecorder.Write("GetIncludedEPCFilter = " + mManager.GetLastError());
        } else {
            mRecorder.Write(String.format(Locale.getDefault(), "GetIncludedEPCFilter Enable=%d Scheme=%d", rfid_cmd.Enable, rfid_cmd.Scheme));
            mRecorder.Write(String.format(Locale.getDefault(), "EPCPattern1=%s EPCPattern2=%s", rfid_cmd.EPCPattern1, rfid_cmd.EPCPattern2));
            mRecorder.Write(String.format(Locale.getDefault(), "Startbit_LSB=%d Startbit_MSB=%d", rfid_cmd.Startbit_LSB, rfid_cmd.Startbit_MSB));
            mRecorder.Write(String.format(Locale.getDefault(), "PatternLength_LSB=%d PatternLength_MSB=%d", rfid_cmd.PatternLength_LSB, rfid_cmd.PatternLength_MSB));
            return true;
        }

        return false;
    }

    public boolean SetIncludedEPCFilter(RfidEpcFilter rfid_cmd) {
        if (mManager == null)
            return false;

        int ret = mManager.SetIncludedEPCFilter(rfid_cmd);
        if (ret != 0) {
            mRecorder.Write("SetIncludedEPCFilter = " + mManager.GetLastError());
        } else {
            mRecorder.Write(String.format(Locale.getDefault(), "SetIncludedEPCFilter Enable=%d Scheme=%d", rfid_cmd.Enable, rfid_cmd.Scheme));
            mRecorder.Write(String.format(Locale.getDefault(), "EPCPattern1=%s EPCPattern2=%s", rfid_cmd.EPCPattern1, rfid_cmd.EPCPattern2));
            mRecorder.Write(String.format(Locale.getDefault(), "Startbit_LSB=%d Startbit_MSB=%d", rfid_cmd.Startbit_LSB, rfid_cmd.Startbit_MSB));
            mRecorder.Write(String.format(Locale.getDefault(), "PatternLength_LSB=%d PatternLength_MSB=%d", rfid_cmd.PatternLength_LSB, rfid_cmd.PatternLength_MSB));
            return true;
        }

        return false;
    }

    public void StartLog(boolean enable) {
        mRecorder.SetFlag(enable);
        mUISetting.LogFile = enable;
        WriteSetting();
    }

    public void WriteLog(String str) {
        mRecorder.Write(str);
    }

    public void SaveEPC(String str) {
        mEPC = str;
    }

    public String LoadEPC() {
        return mEPC;
    }
}