package com.hurlant.crypto.symmetric {
    import flash.utils.ByteArray;
    
    public class CTRMode extends IVMode implements IMode {
         
        
        public function CTRMode(param1:ISymmetricKey, param2:IPad = null) {
            super(param1,param2);
        }
        
        public function encrypt(param1:ByteArray) : void {
            padding.pad(param1);
            var _local_2:ByteArray = getIV4e();
            this.core(param1,_local_2);
        }
        
        public function decrypt(param1:ByteArray) : void {
            var _local_2:ByteArray = getIV4d();
            this.core(param1,_local_2);
            padding.unpad(param1);
        }
        
        private function core(param1:ByteArray, param2:ByteArray) : void {
            var _local_6:uint = 0;
            var _local_3:ByteArray = new ByteArray();
            var _local_4:ByteArray = new ByteArray();
            _local_3.writeBytes(param2);
            var _local_5:uint = 0;
            while(_local_5 < param1.length) {
                _local_4.position = 0;
                _local_4.writeBytes(_local_3);
                key.encrypt(_local_4);
                _local_6 = 0;
                while(_local_6 < blockSize) {
                    param1[_local_5 + _local_6] = param1[_local_5 + _local_6] ^ _local_4[_local_6];
                    _local_6++;
                }
                _local_6 = blockSize - 1;
                while(_local_6 >= 0) {
                    _local_3[_local_6]++;
                    if(_local_3[_local_6] != 0) {
                        break;
                    }
                    _local_6--;
                }
                _local_5 = _local_5 + blockSize;
            }
        }
        
        public function toString() : String {
            return key.toString() + "-ctr";
        }
    }
}
