package com.hurlant.crypto.hash {
    import flash.utils.ByteArray;
    
    public class HMAC implements IHMAC {
         
        
        private var hash:IHash;
        
        private var bits:uint;
        
        public function HMAC(param1:IHash, param2:uint = 0) {
            super();
            this.hash = param1;
            this.bits = param2;
        }
        
        public function getHashSize() : uint {
            if(this.bits != 0) {
                return this.bits / 8;
            }
            return this.hash.getHashSize();
        }
        
        public function compute(param1:ByteArray, param2:ByteArray) : ByteArray {
            var _local_3:ByteArray = null;
            if(param1.length > this.hash.getInputSize()) {
                _local_3 = this.hash.hash(param1);
            } else {
                _local_3 = new ByteArray();
                _local_3.writeBytes(param1);
            }
            while(_local_3.length < this.hash.getInputSize()) {
                _local_3[_local_3.length] = 0;
            }
            var _local_4:ByteArray = new ByteArray();
            var _local_5:ByteArray = new ByteArray();
            var _local_6:uint = 0;
            while(_local_6 < _local_3.length) {
                _local_4[_local_6] = _local_3[_local_6] ^ 54;
                _local_5[_local_6] = _local_3[_local_6] ^ 92;
                _local_6++;
            }
            _local_4.position = _local_3.length;
            _local_4.writeBytes(param2);
            var _local_7:ByteArray = this.hash.hash(_local_4);
            _local_5.position = _local_3.length;
            _local_5.writeBytes(_local_7);
            var _local_8:ByteArray = this.hash.hash(_local_5);
            if(this.bits > 0 && this.bits < 8 * _local_8.length) {
                _local_8.length = this.bits / 8;
            }
            return _local_8;
        }
        
        public function dispose() : void {
            this.hash = null;
            this.bits = 0;
        }
        
        public function toString() : String {
            return "hmac-" + (this.bits > 0?this.bits + "-":"") + this.hash.toString();
        }
    }
}
