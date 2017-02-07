package com.hurlant.crypto {
    import com.hurlant.crypto.hash.HMAC;
    import com.hurlant.crypto.hash.IHash;
    import com.hurlant.crypto.hash.MAC;
    import com.hurlant.crypto.hash.MD2;
    import com.hurlant.crypto.hash.MD5;
    import com.hurlant.crypto.hash.SHA1;
    import com.hurlant.crypto.hash.SHA224;
    import com.hurlant.crypto.hash.SHA256;
    import com.hurlant.crypto.prng.ARC4;
    import com.hurlant.crypto.rsa.RSAKey;
    import com.hurlant.crypto.symmetric.AESKey;
    import com.hurlant.crypto.symmetric.BlowFishKey;
    import com.hurlant.crypto.symmetric.CBCMode;
    import com.hurlant.crypto.symmetric.CFB8Mode;
    import com.hurlant.crypto.symmetric.CFBMode;
    import com.hurlant.crypto.symmetric.CTRMode;
    import com.hurlant.crypto.symmetric.DESKey;
    import com.hurlant.crypto.symmetric.ECBMode;
    import com.hurlant.crypto.symmetric.ICipher;
    import com.hurlant.crypto.symmetric.IMode;
    import com.hurlant.crypto.symmetric.IPad;
    import com.hurlant.crypto.symmetric.ISymmetricKey;
    import com.hurlant.crypto.symmetric.IVMode;
    import com.hurlant.crypto.symmetric.NullPad;
    import com.hurlant.crypto.symmetric.OFBMode;
    import com.hurlant.crypto.symmetric.PKCS5;
    import com.hurlant.crypto.symmetric.SimpleIVMode;
    import com.hurlant.crypto.symmetric.TripleDESKey;
    import com.hurlant.crypto.symmetric.XTeaKey;
    import com.hurlant.util.Base64;
    import flash.utils.ByteArray;
    
    public class Crypto {
         
        
        private var b64:Base64;
        
        public function Crypto() {
            super();
        }
        
        public static function getCipher(param1:String, param2:ByteArray, param3:IPad = null) : ICipher {
            var _local_5:ICipher = null;
            var _local_4:Array = param1.split("-");
            switch(_local_4[0]) {
                case "simple":
                    _local_4.shift();
                    param1 = _local_4.join("-");
                    _local_5 = getCipher(param1,param2,param3);
                    if(_local_5 is IVMode) {
                        return new SimpleIVMode(_local_5 as IVMode);
                    }
                    return _local_5;
                case "aes":
                case "aes128":
                case "aes192":
                case "aes256":
                    _local_4.shift();
                    if(param2.length * 8 == _local_4[0]) {
                        _local_4.shift();
                    }
                    return getMode(_local_4[0],new AESKey(param2),param3);
                case "bf":
                case "blowfish":
                    _local_4.shift();
                    return getMode(_local_4[0],new BlowFishKey(param2),param3);
                case "des":
                    _local_4.shift();
                    if(_local_4[0] != "ede" && _local_4[0] != "ede3") {
                        return getMode(_local_4[0],new DESKey(param2),param3);
                    }
                    if(_local_4.length == 1) {
                        _local_4.push("ecb");
                    }
                case "3des":
                case "des3":
                    _local_4.shift();
                    return getMode(_local_4[0],new TripleDESKey(param2),param3);
                case "xtea":
                    _local_4.shift();
                    return getMode(_local_4[0],new XTeaKey(param2),param3);
                case "rc4":
                    _local_4.shift();
                    return new ARC4(param2);
                default:
                    return null;
            }
        }
        
        public static function getKeySize(param1:String) : uint {
            var _local_2:Array = param1.split("-");
            switch(_local_2[0]) {
                case "simple":
                    _local_2.shift();
                    return getKeySize(_local_2.join("-"));
                case "aes128":
                    return 16;
                case "aes192":
                    return 24;
                case "aes256":
                    return 32;
                case "aes":
                    _local_2.shift();
                    return parseInt(_local_2[0]) / 8;
                case "bf":
                case "blowfish":
                    return 16;
                case "des":
                    _local_2.shift();
                    switch(_local_2[0]) {
                        case "ede":
                            return 16;
                        case "ede3":
                            return 24;
                        default:
                            return 8;
                    }
                case "3des":
                case "des3":
                    return 24;
                case "xtea":
                    return 8;
                case "rc4":
                    if(parseInt(_local_2[1]) > 0) {
                        return parseInt(_local_2[1]) / 8;
                    }
                    return 16;
                default:
                    return 0;
            }
        }
        
        private static function getMode(param1:String, param2:ISymmetricKey, param3:IPad = null) : IMode {
            switch(param1) {
                case "ecb":
                    return new ECBMode(param2,param3);
                case "cfb":
                    return new CFBMode(param2,param3);
                case "cfb8":
                    return new CFB8Mode(param2,param3);
                case "ofb":
                    return new OFBMode(param2,param3);
                case "ctr":
                    return new CTRMode(param2,param3);
                case "cbc":
                default:
                    return new CBCMode(param2,param3);
            }
        }
        
        public static function getHash(param1:String) : IHash {
            switch(param1) {
                case "md2":
                    return new MD2();
                case "md5":
                    return new MD5();
                case "sha":
                case "sha1":
                    return new SHA1();
                case "sha224":
                    return new SHA224();
                case "sha256":
                    return new SHA256();
                default:
                    return null;
            }
        }
        
        public static function getHMAC(param1:String) : HMAC {
            var _local_2:Array = param1.split("-");
            if(_local_2[0] == "hmac") {
                _local_2.shift();
            }
            var _local_3:uint = 0;
            if(_local_2.length > 1) {
                _local_3 = parseInt(_local_2[1]);
            }
            return new HMAC(getHash(_local_2[0]),_local_3);
        }
        
        public static function getMAC(param1:String) : MAC {
            var _local_2:Array = param1.split("-");
            if(_local_2[0] == "mac") {
                _local_2.shift();
            }
            var _local_3:uint = 0;
            if(_local_2.length > 1) {
                _local_3 = parseInt(_local_2[1]);
            }
            return new MAC(getHash(_local_2[0]),_local_3);
        }
        
        public static function getPad(param1:String) : IPad {
            switch(param1) {
                case "null":
                    return new NullPad();
                case "pkcs5":
                default:
                    return new PKCS5();
            }
        }
        
        public static function getRSA(param1:String, param2:String) : RSAKey {
            return RSAKey.parsePublicKey(param2,param1);
        }
    }
}
