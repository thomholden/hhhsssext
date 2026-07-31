function signStr = doHMAC_SHA512(str, key)
    import java.net.*;
    import javax.crypto.*;
    import javax.crypto.spec.*;
    import org.apache.commons.codec.binary.*
    algorithm = 'HmacSHA512';

    keyStr = java.lang.String(key);
    key = SecretKeySpec(keyStr.getBytes('UTF-8'), algorithm);
    mac = Mac.getInstance(algorithm);
    mac.init(key);
    toSignStr = java.lang.String(str);
    signStr = java.lang.String(Hex.encodeHex( mac.doFinal( toSignStr.getBytes('UTF-8'))));
end