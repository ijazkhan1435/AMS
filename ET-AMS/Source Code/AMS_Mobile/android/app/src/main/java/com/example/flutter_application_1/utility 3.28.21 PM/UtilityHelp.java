package com.example.flutter_application_1.utility;

import android.content.Context;
import android.media.MediaScannerConnection;
import android.os.Environment;
import android.util.Base64;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Type;
import java.math.BigInteger;
import java.security.spec.AlgorithmParameterSpec;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

public class UtilityHelp {

    private final static String VectorData = "8647116687323300";
    private final static String AESKey = "2305851823058518";

    public static byte[] hexStringToByteArray(String s) {
        int len = s.length();
        byte[] data = new byte[len / 2];
        for (int i = 0; i < len; i += 2) {
            data[i / 2] = (byte) ((Character.digit(s.charAt(i), 16) << 4) + Character
                    .digit(s.charAt(i + 1), 16));
        }
        return data;
    }

    final protected static char[] hexArray = "0123456789ABCDEF".toCharArray();

    public static String bytesToHex(byte[] bytes) {
        char[] hexChars = new char[bytes.length * 2];
        for (int j = 0; j < bytes.length; j++) {
            int v = bytes[j] & 0xFF;
            hexChars[j * 2] = hexArray[v >>> 4];
            hexChars[j * 2 + 1] = hexArray[v & 0x0F];
        }
        return new String(hexChars);
    }

    public static String hexToString(String txtInHex, String encode) {
        byte[] txtInByte = new byte[txtInHex.length() / 2];
        int j = 0;
        for (int i = 0; i < txtInHex.length(); i += 2) {
            txtInByte[j++] = (byte) Integer.parseInt(
                    txtInHex.substring(i, i + 2), 16);
        }
        try {
            return new String(txtInByte, encode);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            return new String(txtInByte);
        }
    }

    public static boolean SerializeJson(Context context, String filename,
                                        Object obj, Type type) {
        boolean ret = false;
        String state = Environment.getExternalStorageState();
        if (Environment.MEDIA_MOUNTED.equals(state)) {
            Gson json = new GsonBuilder().setPrettyPrinting().create();
            String jsonStrUser = json.toJson(obj, type);
            FileOutputStream fos = null;
            try {
                fos = new FileOutputStream(filename);
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            }

            try {
                if (fos != null) {
                    byte[] buff = jsonStrUser.getBytes();
                    fos.write(buff, 0, buff.length);
                    fos.flush();
                    ret = true;
                }
            } catch (Exception e) {
                e.printStackTrace();
                ret = false;
            } finally {
                if (fos != null) {
                    try {
                        fos.close();
                        MediaScannerConnection.scanFile(context,
                                new String[]{filename}, null, null);

                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }

        return ret;
    }

    public static Object DeserializeJson(String filename, Type type) {

        Object obj = null;
        String state = Environment.getExternalStorageState();
        if (Environment.MEDIA_MOUNTED.equals(state)) {

            FileInputStream fin = null;
            File file = new File(filename);
            try {
                fin = new FileInputStream(file);
                Gson json = new Gson();
                Reader reader = new InputStreamReader(fin);
                obj = json.fromJson(reader, type);

            } catch (Exception e) {
                e.printStackTrace();

            } finally {
                if (fin != null) {
                    try {
                        fin.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }

        return obj;
    }

    public static String EncryptAES(String input) {

        byte[] iv = VectorData.getBytes();
        byte[] key = AESKey.getBytes();
        byte[] text = input.getBytes();

        try {
            AlgorithmParameterSpec mAlgorithmParameterSpec = new IvParameterSpec(
                    iv);
            SecretKeySpec mSecretKeySpec = new SecretKeySpec(key, "AES");
            Cipher mCipher = null;
            mCipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            mCipher.init(Cipher.ENCRYPT_MODE, mSecretKeySpec,
                    mAlgorithmParameterSpec);

            byte[] out = mCipher.doFinal(text);
            return Base64.encodeToString(out, Base64.DEFAULT);
        } catch (Exception ex) {
            ex.printStackTrace();
            return new String("");
        }
    }

    public static String DecryptAES(String input) {

        byte[] iv = VectorData.getBytes();
        byte[] key = AESKey.getBytes();
        byte[] text;
        try {
            text = Base64.decode(input.getBytes("UTF-8"), Base64.DEFAULT);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            return new String("");
        }

        try {
            AlgorithmParameterSpec mAlgorithmParameterSpec = new IvParameterSpec(
                    iv);
            SecretKeySpec mSecretKeySpec = new SecretKeySpec(key, "AES");
            Cipher mCipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            mCipher.init(Cipher.DECRYPT_MODE, mSecretKeySpec,
                    mAlgorithmParameterSpec);

            byte[] out = mCipher.doFinal(text);
            return new String(out);
        } catch (Exception ex) {
            ex.printStackTrace();
            return new String("");
        }
    }

    public static String bytes2hex(byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < bytes.length; i++) {
            String temp = (Integer.toHexString(bytes[i] & 0XFF));
            if (temp.length() == 1) {
                temp = "0" + temp;
            }
            sb.append(temp);
            //sb.append(" ");
        }
        return sb.toString().toUpperCase();
    }

    public static boolean isFileByExt(File file, String ext) {
        if (ext.length() > 0) {
            String fileName = file.getName();
            int idxExt = fileName.lastIndexOf(ext);

            if (idxExt >= 0) {
                return true;
            }
        }

        return false;
    }

    public static String Hex2Binary(String hex) {
        String binary = "";

        for (int i = 0; i < hex.length(); i++) {
            Character ch = hex.charAt(i);
            int intValue = Integer.parseInt(ch.toString(), 16);
            binary += PadLeft(Integer.toBinaryString(intValue), 4, '0');
        }
        return binary;
    }

    public static String Binary2Hex(String binary) {
        String hex = "";

        int rest = binary.length() % 4;
        binary = PadLeft(binary, rest, '0'); // pad the length out to by
        // divideable by 4

        for (int i = 0; i <= binary.length() - 4; i += 4) {
            String temp = binary.substring(i, 4);
            hex += String.format("%1$", temp.getBytes());
        }

        return hex;
    }

    final static byte[] HEX_CHAR_TABLE = {(byte) '0', (byte) '1', (byte) '2',
            (byte) '3', (byte) '4', (byte) '5', (byte) '6', (byte) '7',
            (byte) '8', (byte) '9', (byte) 'a', (byte) 'b', (byte) 'c',
            (byte) 'd', (byte) 'e', (byte) 'f'};

    public static String Hex2Binary(byte[] raw) throws UnsupportedEncodingException {
        byte[] hex = new byte[2 * raw.length];
        int index = 0;

        for (byte b : raw) {
            int v = b & 0xFF;
            hex[index++] = HEX_CHAR_TABLE[v >>> 4];
            hex[index++] = HEX_CHAR_TABLE[v & 0xF];
        }
        return new String(hex, "ASCII");
    }

    // Since Int64.TryParse() is not supported on the Windows Mobile platform,
    // We use our own TryParse method.
    /*
     * public static boolean TryParseInt64(String source, Long result) { try {
     * result = Long.parseLong(source, 16); } catch (Exception e) { return
     * false; } return true; }
     */

    public static BigInteger TryParseInt64(String source) {
        BigInteger result;
        try {
            result = new BigInteger(source);
        } catch (Exception e) {
            result = null;
        }
        return result;
    }

    public static int NearestMultiplesOf8(int n) {
        return ((n + 7) & ~7);
    }

    public static int NearestMultiplesOf(int n, int multiple) {
        return ((n + multiple - 1) / multiple) * multiple;
    }

    public static String PadLeft(String in, int totalWidth, char paddingChar) {
        if (in == null || in.length() == 0)
            return null;

        int appendLen = totalWidth - in.length();
        StringBuffer retvalue = new StringBuffer();
        for (int i = 0; i < appendLen; i++) {
            retvalue.append(paddingChar);
        }

        return retvalue.append(in).toString();
    }

    public static String PadRight(String in, int totalWidth, char paddingChar) {
        if (in == null || in.length() == 0)
            return null;

        StringBuffer padded = new StringBuffer(in);
        while (padded.length() < totalWidth) {
            padded.append(paddingChar);
        }
        return padded.toString();
    }

    public static int unsignedToBytes(byte b) {
        return b & 0xFF;
    }

    public static byte[] StringToByteArray(String hex) throws Exception {
        if (hex == null) {
            throw new Exception("The binary key is empty");
        }
        int len = hex.length();
        if (len % 2 == 1) {
            throw new Exception(
                    "The binary key cannot have an odd number of digits");
        }

        byte[] ba = new byte[len / 2];
        for (int i = 0; i < ba.length; i++)
            ba[i] = (byte) Integer
                    .parseInt(hex.substring(2 * i, 2 * i + 2), 16);
        return ba;
    }

    public static String ByteArrayToString(byte[] ba) {
        if (ba == null || ba.length == 0)
            return null;

        StringBuffer sb = new StringBuffer(ba.length * 2);
        String hexNumber;
        for (int x = 0; x < ba.length; x++) {
            hexNumber = "0" + Integer.toHexString(0xff & ba[x]);
            sb.append(hexNumber.substring(hexNumber.length() - 2));
        }
        return sb.toString();
    }
}
