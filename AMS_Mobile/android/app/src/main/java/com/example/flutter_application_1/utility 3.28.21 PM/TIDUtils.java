package com.example.flutter_application_1.utility;

import android.util.Log;

import java.math.BigInteger;
import java.util.Hashtable;

import com.example.flutter_application_1.describe.GlobalDescribe;
import com.example.flutter_application_1.describe.TIDInfo;

public class TIDUtils {

    private static volatile TIDUtils instance = null;

    private static final Hashtable<String, String> DatabaseMDID = new Hashtable<String, String>() {
        {
            put("000000001", "Impinj");
            put("000000010", "Texas Instruments");
            put("000000011", "Alien Technology");
            put("000000100", "Intelleflex");
            put("000000101", "Atmel");
            put("000000110", "NXP Semiconductors");
            put("000000111", "ST Microelectronics ");
            put("000001000", "EP Microelectronics ");
            put("000001001", "Motorola");
            put("000001010", "Sentech Snd Bhd ");
            put("000001011", "EM Microelectronics ");
            put("000001100", "Renesas Technology Corp.");
            put("000001101", "Mstar");
            put("000001110", "Tyco International");
            put("000001111", "Quanray Electronics");
            put("000010000", "Fujitsu");
            put("000010001", "LSIS");
            put("000010010", "CAEN RFID srl");
            put("000010011", "Productivity Engineering GmbH");
            put("000010100", "Federal Electric Corp.");
            put("000010101", "ON Semiconductor");
            put("000010110", "Ramtron");
            put("000010111", "Tego");
            put("000011000", "Ceitec S.A.");
            put("000011001", "CPA Wernher von Braun");
            put("000011010", "TransCore");
            put("000011011", "Nationz");
            put("000011100", "Invengo");
            put("000011101", "Kiloway");
            put("000011110", "Longjing Microelectronics Co. Ltd.");
            put("000011111", "Chipus Microelectronics");
            put("000100000", "ORIDAO");
            put("000100001", "Maintag");
            put("000100010", "Yangzhou Daoyuan Microelectronics Co. Ltd");
            put("000100011", "Gate Elektronik");
            put("000100100", "RFMicron, Inc.");
            put("000100101", "RST-Invent LLC");
            put("000100110", "Crystone Technology");
            put("000100111", "Shanghai Fudan Microelectronics Group ");
            put("000101000", "Farsens");
            put("000101001", "Giesecke & Devrient GmbH");
            put("000101010", "AWID");
            put("000101011", "Unitec Semicondutores S/A");
            put("000101100", "Q-Free ASA");
            put("000101101", "Valid S.A.");
            put("000101110", "Fraunhofer IPMS");
            put("000101111", "ams AG");
            put("000110000", "Angstrem JSC");
            put("000110001", "Honeywell");
            put("000110010", "Huada Semiconductor Co. Ltd (HDSC)");
            put("000110011", "Lapis Semiconductor Co., Ltd.");
            put("000110100", "PJSC Mikron");
            put("000110101", "Hangzhou Landa Microelectronics Co., Ltd.");
            put("000110110", "Nanjing NARI Micro-Electronic Technology Co., Ltd.");
            put("000110111", "Southwest Integrated Circuit Design Co., Ltd.");
            put("000111000", "Silictec");
            put("000111001", "Nation RFID");
            put("000111010", "Asygn");
            put("000111011", "Suzhou HCTech Technology Co., Ltd.");
            put("000111100", "AXEM Technology");
        }
    };

    private static final Hashtable<String, String> DatabaseImpinj = new Hashtable<String, String>() {
        {
            put("000101110000", "Monza R6-P");
            put("000101110001", "Monza S6-C");
            put("000101100000", "Monza R6");
            put("000100110000", "Monza 5");
            put("000100000000", "Monza 4D");
            put("000100001100", "Monza 4E");
            put("000100000101", "Monza 4QT");
            put("000100010100", "Monza 4i");
            put("000101000000", "Monza X-2K");
            put("000101010000", "Monza X-8K");
            put("000010010011", "Monza 3");
        }
    };

    private static final Hashtable<String, String> DatabaseNXP = new Hashtable<String, String>() {
        {
            put("000000000001", "UCODE EPC G2");
            put("000000000011", "UCODE G2XM");
            put("000000000100", "UCODE G2XL");
            put("100010010000", "UCODE 7");
            put("100010010001", "UCODE 7m");
            put("100010010100", "UCODE 8");
            put("100110010100", "UCODE 8m");
            put("100000001101", "UCODE I2c");
            put("100010001101", "UCODE I2c");
            put("100000001010", "UCODE G2iM");
            put("100000001011", "UCODE G2iM+");
            put("100000000110", "UCODE G2iL");
            put("100100000110", "UCODE G2iL");
            put("101100000110", "UCODE G2iL");
            put("100000000111", "UCODE G2iL+");
            put("100100000111", "UCODE G2iL+");
            put("101100000111", "UCODE G2iL+");
            put("100010010010", "UCODE DNA");
        }
    };

    public TIDUtils() {

    }

    public static synchronized TIDUtils getInstance() {
        if (instance == null) {
            instance = new TIDUtils();
        }
        return instance;
    }

//    public static TIDInfo Decode(String str)
//    {
//        String header1 = str.substring(0, 2).toUpperCase();
//        if (header1.equals("E2")) {
//            Log.d(GlobalDescribe.TAG, "TID:" + str);
//            if(str.length() < 6)
//                return null;
//
//            TIDInfo record = new TIDInfo();
//            String temp = UtilityHelp.Hex2Binary(str.substring(2, 8));
//            String XTID = temp.substring(0, 1);
//            String MDID = temp.substring(3, 12);
//            if (DatabaseMDID.containsKey(MDID)) {
//                record.Company = DatabaseMDID.get(MDID);
//
//                if (MDID.equals("000000001")) {
//                    String TMD = temp.substring(12, 24);
//                    if (DatabaseImpinj.containsKey(TMD)) {
//                        record.Model = DatabaseImpinj.get(TMD);
//                    }
//                } else if (MDID.equals("000000110")) {
//                    String TMD = temp.substring(12, 24);
//                    if (DatabaseNXP.containsKey(TMD)) {
//                        record.Model = DatabaseNXP.get(TMD);
//                    }
//                }
//
//                if (XTID.equals("1")) {
//                    try {
//                        String Serial = str.substring(12, 24);
//                        BigInteger intPattern = new BigInteger(Serial, 16);
//                        record.ExtendArea = true;
//                        record.SerialNumber = intPattern.toString();
//                    } catch (Exception e) {
//                        e.getStackTrace();
//                    }
//                }
//                else
//                {
//                    try {
//                        String Serial = str.substring(8);
//                        BigInteger intPattern = new BigInteger(Serial, 16);
//                        record.ExtendArea = false;
//                        record.SerialNumber = intPattern.toString();
//                    } catch (Exception e) {
//                        e.getStackTrace();
//                    }
//                }
//            }
//
//            return record;
//        }
//        return  null;
//    }
}
