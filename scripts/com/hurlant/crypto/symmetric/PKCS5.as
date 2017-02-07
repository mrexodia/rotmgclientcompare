package com.hurlant.crypto.symmetric {
    import flash.utils.ByteArray;
    
    public class PKCS5 implements IPad {
         
        
        private var blockSize:uint;
        
        public function PKCS5(param1:uint = 0) {
            super();
            this.blockSize = param1;
        }
        
        public function pad(param1:ByteArray) : void {
            var _local_2:uint = this.blockSize - param1.length % this.blockSize;
            var _local_3:uint = 0;
            while(_local_3 < _local_2) {
                param1[param1.length] = _local_2;
                _local_3++;
            }
        }
        
        public function unpad(param1:ByteArray) : void {
            var _local_4:uint = 0;
            var _local_2:uint = param1.length % this.blockSize;
            if(_local_2 != 0) {
                throw new Error("PKCS#5::unpad: ByteArray.length isn\'t a multiple of the blockSize");
            }
            _local_2 = param1[param1.length - 1];
            var _local_3:uint = _local_2;
            while(_local_3 > 0) {
                _local_4 = param1[param1.length - 1];
                param1.length--;
                if(_local_2 != _local_4) {
                    throw new Error("PKCS#5:unpad: Invalid padding value. expected [" + _local_2 + "], found [" + _local_4 + "]");
                }
                _local_3--;
            }
        }
        
        public function setBlockSize(param1:uint) : void {
            this.blockSize = param1;
        }
    }
}
