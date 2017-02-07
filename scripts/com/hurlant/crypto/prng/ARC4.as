package com.hurlant.crypto.prng {
    import com.hurlant.crypto.symmetric.IStreamCipher;
    import com.hurlant.util.Memory;
    import flash.utils.ByteArray;
    
    public class ARC4 implements IPRNG, IStreamCipher {
         
        
        private var i:int = 0;
        
        private var j:int = 0;
        
        private var S:ByteArray;
        
        private const psize:uint = 256;
        
        public function ARC4(param1:ByteArray = null) {
            super();
            this.S = new ByteArray();
            if(param1) {
                this.init(param1);
            }
        }
        
        public function getPoolSize() : uint {
            return this.psize;
        }
        
        public function init(param1:ByteArray) : void {
            var _local_2:int = 0;
            var _local_3:* = 0;
            var _local_4:int = 0;
            _local_2 = 0;
            while(_local_2 < 256) {
                this.S[_local_2] = _local_2;
                _local_2++;
            }
            _local_3 = 0;
            _local_2 = 0;
            while(_local_2 < 256) {
                _local_3 = _local_3 + this.S[_local_2] + param1[_local_2 % param1.length] & 255;
                _local_4 = this.S[_local_2];
                this.S[_local_2] = this.S[_local_3];
                this.S[_local_3] = _local_4;
                _local_2++;
            }
            this.i = 0;
            this.j = 0;
        }
        
        public function next() : uint {
            var _local_1:int = 0;
            this.i = this.i + 1 & 255;
            this.j = this.j + this.S[this.i] & 255;
            _local_1 = this.S[this.i];
            this.S[this.i] = this.S[this.j];
            this.S[this.j] = _local_1;
            return this.S[_local_1 + this.S[this.i] & 255];
        }
        
        public function getBlockSize() : uint {
            return 1;
        }
        
        public function encrypt(param1:ByteArray) : void {
            var _local_2:uint = 0;
            while(_local_2 < param1.length) {
                param1[_local_2++] = param1[_local_2++] ^ this.next();
            }
        }
        
        public function decrypt(param1:ByteArray) : void {
            this.encrypt(param1);
        }
        
        public function dispose() : void {
            var _local_1:uint = 0;
            if(this.S != null) {
                _local_1 = 0;
                while(_local_1 < this.S.length) {
                    this.S[_local_1] = Math.random() * 256;
                    _local_1++;
                }
                this.S.length = 0;
                this.S = null;
            }
            this.i = 0;
            this.j = 0;
            Memory.gc();
        }
        
        public function toString() : String {
            return "rc4";
        }
    }
}
