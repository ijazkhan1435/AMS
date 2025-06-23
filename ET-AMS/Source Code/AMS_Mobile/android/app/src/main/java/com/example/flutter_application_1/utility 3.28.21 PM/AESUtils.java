package com.example.flutter_application_1.utility;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;

public class AESUtils {

    private static final String ALGORITHM = "AES";

    //private static final String ALGORITHM_STR = "AES/ECB/PKCS5Padding";
    private static final String ALGORITHM_STR = "AES/ECB/NoPadding";

    private SecretKeySpec key;

    public AESUtils(String hexKey) {
        byte[] temp;
        try {
            temp = org.apache.commons.codec.binary.Hex.decodeHex(hexKey.toCharArray());
            key = new SecretKeySpec(temp, ALGORITHM);
        }
        catch (Exception ee)
        {
            key = null;
        }
    }

    public String decryptData(String Data) throws Exception{
        if(key == null)
          return "";

        Cipher cipher = Cipher.getInstance(ALGORITHM_STR);
        cipher.init(Cipher.DECRYPT_MODE, key);

        byte[] text = org.apache.commons.codec.binary.Hex.decodeHex(Data.toCharArray());
        byte[] decryptedText = cipher.doFinal(text);
        return UtilityHelp.bytes2hex(decryptedText);
    }
}
