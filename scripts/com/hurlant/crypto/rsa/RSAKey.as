package com.hurlant.crypto.rsa {
    import com.hurlant.crypto.prng.Random;
    import com.hurlant.crypto.tls.TLSError;
    import com.hurlant.math.BigInteger;
    import com.hurlant.util.Memory;
    import flash.utils.ByteArray;
    
    public class RSAKey {
         
        
        public var e:int;
        
        public var n:BigInteger;
        
        public var d:BigInteger;
        
        public var p:BigInteger;
        
        public var q:BigInteger;
        
        public var dmp1:BigInteger;
        
        public var dmq1:BigInteger;
        
        public var coeff:BigInteger;
        
        protected var canDecrypt:Boolean;
        
        protected var canEncrypt:Boolean;
        
        public function RSAKey(param1:BigInteger, param2:int, param3:BigInteger = null, param4:BigInteger = null, param5:BigInteger = null, param6:BigInteger = null, param7:BigInteger = null, param8:BigInteger = null) {
            super();
            this.n = param1;
            this.e = param2;
            this.d = param3;
            this.p = param4;
            this.q = param5;
            this.dmp1 = param6;
            this.dmq1 = param7;
            this.coeff = param8;
            this.canEncrypt = this.n != null && this.e != 0;
            this.canDecrypt = this.canEncrypt && this.d != null;
        }
        
        public static function parsePublicKey(param1:String, param2:String) : RSAKey {
            return new RSAKey(new BigInteger(param1,16,true),parseInt(param2,16));
        }
        
        public static function parsePrivateKey(param1:String, param2:String, param3:String, param4:String = null, param5:String = null, param6:String = null, param7:String = null, param8:String = null) : RSAKey {
            if(param4 == null) {
                return new RSAKey(new BigInteger(param1,16,true),parseInt(param2,16),new BigInteger(param3,16,true));
            }
            return new RSAKey(new BigInteger(param1,16,true),parseInt(param2,16),new BigInteger(param3,16,true),new BigInteger(param4,16,true),new BigInteger(param5,16,true),new BigInteger(param6,16,true),new BigInteger(param7,16,true),new BigInteger(param8,16,true));
        }
        
        public static function generate(param1:uint, param2:String) : RSAKey {
            var _local_7:BigInteger = null;
            var _local_8:BigInteger = null;
            var _local_9:BigInteger = null;
            var _local_10:BigInteger = null;
            var _local_3:Random = new Random();
            var _local_4:uint = param1 >> 1;
            var _local_5:RSAKey = new RSAKey(null,0,null);
            _local_5.e = parseInt(param2,16);
            var _local_6:BigInteger = new BigInteger(param2,16,true);
            do {
                do {
                    _local_5.p = bigRandom(param1 - _local_4,_local_3);
                }
                while(!(_local_5.p.subtract(BigInteger.ONE).gcd(_local_6).compareTo(BigInteger.ONE) == 0 && _local_5.p.isProbablePrime(10)));
                
                do {
                    _local_5.q = bigRandom(_local_4,_local_3);
                }
                while(!(_local_5.q.subtract(BigInteger.ONE).gcd(_local_6).compareTo(BigInteger.ONE) == 0 && _local_5.q.isProbablePrime(10)));
                
                if(_local_5.p.compareTo(_local_5.q) <= 0) {
                    _local_10 = _local_5.p;
                    _local_5.p = _local_5.q;
                    _local_5.q = _local_10;
                }
                _local_7 = _local_5.p.subtract(BigInteger.ONE);
                _local_8 = _local_5.q.subtract(BigInteger.ONE);
                _local_9 = _local_7.multiply(_local_8);
            }
            while(_local_9.gcd(_local_6).compareTo(BigInteger.ONE) != 0);
            
            _local_5.n = _local_5.p.multiply(_local_5.q);
            _local_5.d = _local_6.modInverse(_local_9);
            _local_5.dmp1 = _local_5.d.mod(_local_7);
            _local_5.dmq1 = _local_5.d.mod(_local_8);
            _local_5.coeff = _local_5.q.modInverse(_local_5.p);
            return _local_5;
        }
        
        protected static function bigRandom(param1:int, param2:Random) : BigInteger {
            if(param1 < 2) {
                return BigInteger.nbv(1);
            }
            var _local_3:ByteArray = new ByteArray();
            param2.nextBytes(_local_3,param1 >> 3);
            _local_3.position = 0;
            var _local_4:BigInteger = new BigInteger(_local_3,0,true);
            _local_4.primify(param1,1);
            return _local_4;
        }
        
        public function getBlockSize() : uint {
            return (this.n.bitLength() + 7) / 8;
        }
        
        public function dispose() : void {
            this.e = 0;
            this.n.dispose();
            this.n = null;
            Memory.gc();
        }
        
        public function encrypt(param1:ByteArray, param2:ByteArray, param3:uint, param4:Function = null) : void {
            this._encrypt(this.doPublic,param1,param2,param3,param4,2);
        }
        
        public function decrypt(param1:ByteArray, param2:ByteArray, param3:uint, param4:Function = null) : void {
            this._decrypt(this.doPrivate2,param1,param2,param3,param4,2);
        }
        
        public function sign(param1:ByteArray, param2:ByteArray, param3:uint, param4:Function = null) : void {
            this._encrypt(this.doPrivate2,param1,param2,param3,param4,1);
        }
        
        public function verify(param1:ByteArray, param2:ByteArray, param3:uint, param4:Function = null) : void {
            this._decrypt(this.doPublic,param1,param2,param3,param4,1);
        }
        
        private function _encrypt(param1:Function, param2:ByteArray, param3:ByteArray, param4:uint, param5:Function, param6:int) : void {
            var _local_9:BigInteger = null;
            var _local_10:BigInteger = null;
            if(param5 == null) {
                param5 = this.pkcs1pad;
            }
            if(param2.position >= param2.length) {
                param2.position = 0;
            }
            var _local_7:uint = this.getBlockSize();
            var _local_8:int = param2.position + param4;
            while(param2.position < _local_8) {
                _local_9 = new BigInteger(param5(param2,_local_8,_local_7,param6),_local_7,true);
                _local_10 = param1(_local_9);
                _local_10.toArray(param3);
            }
        }
        
        private function _decrypt(param1:Function, param2:ByteArray, param3:ByteArray, param4:uint, param5:Function, param6:int) : void {
            var _local_9:BigInteger = null;
            var _local_10:BigInteger = null;
            var _local_11:ByteArray = null;
            if(param5 == null) {
                param5 = this.pkcs1unpad;
            }
            if(param2.position >= param2.length) {
                param2.position = 0;
            }
            var _local_7:uint = this.getBlockSize();
            var _local_8:int = param2.position + param4;
            while(param2.position < _local_8) {
                _local_9 = new BigInteger(param2,_local_7,true);
                _local_10 = param1(_local_9);
                _local_11 = param5(_local_10,_local_7,param6);
                if(_local_11 == null) {
                    throw new TLSError("Decrypt error - padding function returned null!",TLSError.decode_error);
                }
                param3.writeBytes(_local_11);
            }
        }
        
        private function pkcs1pad(param1:ByteArray, param2:int, param3:uint, param4:uint = 2) : ByteArray {
            var _local_8:Random = null;
            var _local_9:int = 0;
            var _local_5:ByteArray = new ByteArray();
            var _local_6:uint = param1.position;
            param2 = Math.min(param2,param1.length,_local_6 + param3 - 11);
            param1.position = param2;
            var _local_7:int = param2 - 1;
            while(_local_7 >= _local_6 && param3 > 11) {
                _local_5[--param3] = param1[_local_7--];
            }
            _local_5[--param3] = 0;
            if(param4 == 2) {
                _local_8 = new Random();
                _local_9 = 0;
                while(param3 > 2) {
                    do {
                        _local_9 = _local_8.nextByte();
                    }
                    while(_local_9 == 0);
                    
                    _local_5[--param3] = _local_9;
                }
            } else {
                while(param3 > 2) {
                    _local_5[--param3] = 255;
                }
            }
            _local_5[--param3] = param4;
            var _local_12:* = --param3;
            _local_5[_local_12] = 0;
            return _local_5;
        }
        
        private function pkcs1unpad(param1:BigInteger, param2:uint, param3:uint = 2) : ByteArray {
            var _local_4:ByteArray = param1.toByteArray();
            var _local_5:ByteArray = new ByteArray();
            _local_4.position = 0;
            var _local_6:int = 0;
            while(_local_6 < _local_4.length && _local_4[_local_6] == 0) {
                _local_6++;
            }
            if(_local_4.length - _local_6 != param2 - 1 || _local_4[_local_6] != param3) {
                trace("PKCS#1 unpad: i=" + _local_6 + ", expected b[i]==" + param3 + ", got b[i]=" + _local_4[_local_6].toString(16));
                return null;
            }
            _local_6++;
            while(_local_4[_local_6] != 0) {
                if(++_local_6 >= _local_4.length) {
                    trace("PKCS#1 unpad: i=" + _local_6 + ", b[i-1]!=0 (=" + _local_4[_local_6 - 1].toString(16) + ")");
                    return null;
                }
            }
            while(++_local_6 < _local_4.length) {
                _local_5.writeByte(_local_4[_local_6]);
            }
            _local_5.position = 0;
            return _local_5;
        }
        
        public function rawpad(param1:ByteArray, param2:int, param3:uint, param4:uint = 0) : ByteArray {
            return param1;
        }
        
        public function rawunpad(param1:BigInteger, param2:uint, param3:uint = 0) : ByteArray {
            return param1.toByteArray();
        }
        
        public function toString() : String {
            return "rsa";
        }
        
        public function dump() : String {
            var _local_1:* = "N=" + this.n.toString(16) + "\n" + "E=" + this.e.toString(16) + "\n";
            if(this.canDecrypt) {
                _local_1 = _local_1 + ("D=" + this.d.toString(16) + "\n");
                if(this.p != null && this.q != null) {
                    _local_1 = _local_1 + ("P=" + this.p.toString(16) + "\n");
                    _local_1 = _local_1 + ("Q=" + this.q.toString(16) + "\n");
                    _local_1 = _local_1 + ("DMP1=" + this.dmp1.toString(16) + "\n");
                    _local_1 = _local_1 + ("DMQ1=" + this.dmq1.toString(16) + "\n");
                    _local_1 = _local_1 + ("IQMP=" + this.coeff.toString(16) + "\n");
                }
            }
            return _local_1;
        }
        
        protected function doPublic(param1:BigInteger) : BigInteger {
            return param1.modPowInt(this.e,this.n);
        }
        
        protected function doPrivate2(param1:BigInteger) : BigInteger {
            if(this.p == null && this.q == null) {
                return param1.modPow(this.d,this.n);
            }
            var _local_2:BigInteger = param1.mod(this.p).modPow(this.dmp1,this.p);
            var _local_3:BigInteger = param1.mod(this.q).modPow(this.dmq1,this.q);
            while(_local_2.compareTo(_local_3) < 0) {
                _local_2 = _local_2.add(this.p);
            }
            var _local_4:BigInteger = _local_2.subtract(_local_3).multiply(this.coeff).mod(this.p).multiply(this.q).add(_local_3);
            return _local_4;
        }
        
        protected function doPrivate(param1:BigInteger) : BigInteger {
            if(this.p == null || this.q == null) {
                return param1.modPow(this.d,this.n);
            }
            var _local_2:BigInteger = param1.mod(this.p).modPow(this.dmp1,this.p);
            var _local_3:BigInteger = param1.mod(this.q).modPow(this.dmq1,this.q);
            while(_local_2.compareTo(_local_3) < 0) {
                _local_2 = _local_2.add(this.p);
            }
            return _local_2.subtract(_local_3).multiply(this.coeff).mod(this.p).multiply(this.q).add(_local_3);
        }
    }
}
