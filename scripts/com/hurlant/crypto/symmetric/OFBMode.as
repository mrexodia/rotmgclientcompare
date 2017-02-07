package com.hurlant.crypto.symmetric {
    import flash.utils.ByteArray;
    
    public class OFBMode extends IVMode implements IMode {
         
        
        public function OFBMode(param1:ISymmetricKey, param2:IPad = null) {
            super(param1,null);
        }
        
        public function encrypt(param1:ByteArray) : void {
            var _local_2:ByteArray = getIV4e();
            this.core(param1,_local_2);
        }
        
        public function decrypt(param1:ByteArray) : void {
            var _local_2:ByteArray = getIV4d();
            this.core(param1,_local_2);
        }
        
        private function core(param1:ByteArray, param2:ByteArray) : void {
            var _local_6:uint = 0;
            var _local_7:uint = 0;
            var _local_3:uint = param1.length;
            var _local_4:ByteArray = new ByteArray();
            var _local_5:uint = 0;
            while(_local_5 < param1.length) {
                key.encrypt(param2);
                _local_4.position = 0;
                _local_4.writeBytes(param2);
                _local_6 = _local_5 + blockSize < _local_3?uint(blockSize):uint(_local_3 - _local_5);
                _local_7 = 0;
                while(_local_7 < _local_6) {
                    param1[_local_5 + _local_7] = param1[_local_5 + _local_7] ^ param2[_local_7];
                    _local_7++;
                }
                param2.position = 0;
                param2.writeBytes(_local_4);
                _local_5 = _local_5 + blockSize;
            }
        }
        
        public function toString() : String {
            return key.toString() + "-ofb";
        }
    }
}
