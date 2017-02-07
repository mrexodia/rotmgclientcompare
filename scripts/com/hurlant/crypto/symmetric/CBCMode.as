package com.hurlant.crypto.symmetric {
    import flash.utils.ByteArray;
    
    public class CBCMode extends IVMode implements IMode {
         
        
        public function CBCMode(param1:ISymmetricKey, param2:IPad = null) {
            super(param1,param2);
        }
        
        public function encrypt(param1:ByteArray) : void {
            var _local_4:uint = 0;
            padding.pad(param1);
            var _local_2:ByteArray = getIV4e();
            var _local_3:uint = 0;
            while(_local_3 < param1.length) {
                _local_4 = 0;
                while(_local_4 < blockSize) {
                    param1[_local_3 + _local_4] = param1[_local_3 + _local_4] ^ _local_2[_local_4];
                    _local_4++;
                }
                key.encrypt(param1,_local_3);
                _local_2.position = 0;
                _local_2.writeBytes(param1,_local_3,blockSize);
                _local_3 = _local_3 + blockSize;
            }
        }
        
        public function decrypt(param1:ByteArray) : void {
            var _local_5:uint = 0;
            var _local_2:ByteArray = getIV4d();
            var _local_3:ByteArray = new ByteArray();
            var _local_4:uint = 0;
            while(_local_4 < param1.length) {
                _local_3.position = 0;
                _local_3.writeBytes(param1,_local_4,blockSize);
                key.decrypt(param1,_local_4);
                _local_5 = 0;
                while(_local_5 < blockSize) {
                    param1[_local_4 + _local_5] = param1[_local_4 + _local_5] ^ _local_2[_local_5];
                    _local_5++;
                }
                _local_2.position = 0;
                _local_2.writeBytes(_local_3,0,blockSize);
                _local_4 = _local_4 + blockSize;
            }
            padding.unpad(param1);
        }
        
        public function toString() : String {
            return key.toString() + "-cbc";
        }
    }
}
