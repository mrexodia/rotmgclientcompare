package com.hurlant.crypto.hash {
    import flash.utils.ByteArray;
    
    public class MD2 implements IHash {
        
        public static const HASH_SIZE:int = 16;
        
        private static const S:Array = [41,46,67,201,162,216,124,1,61,54,84,161,236,240,6,19,98,167,5,243,192,199,115,140,152,147,43,217,188,76,130,202,30,155,87,60,253,212,224,22,103,66,111,24,138,23,229,18,190,78,196,214,218,158,222,73,160,251,245,142,187,47,238,122,169,104,121,145,21,178,7,63,148,194,16,137,11,34,95,33,128,127,93,154,90,144,50,39,53,62,204,231,191,247,151,3,255,25,48,179,72,165,181,209,215,94,146,42,172,86,170,198,79,184,56,210,150,164,125,182,118,252,107,226,156,116,4,241,69,157,112,89,100,113,135,32,134,91,207,101,230,45,168,2,27,96,37,173,174,176,185,246,28,70,97,105,52,64,126,15,85,71,163,35,221,81,175,58,195,92,249,206,186,197,234,38,44,83,13,110,133,40,132,9,211,223,205,244,65,129,77,82,106,220,55,200,108,193,171,250,36,225,123,8,12,189,177,74,120,136,149,139,227,99,232,109,233,203,213,254,59,0,29,57,242,239,183,14,102,88,208,228,166,119,114,248,235,117,75,10,49,68,80,180,143,237,31,26,219,153,141,51,159,17,131,20];
         
        
        public var pad_size:int = 48;
        
        public function MD2() {
            super();
        }
        
        public function getInputSize() : uint {
            return 16;
        }
        
        public function getPadSize() : int {
            return this.pad_size;
        }
        
        public function getHashSize() : uint {
            return HASH_SIZE;
        }
        
        public function hash(param1:ByteArray) : ByteArray {
            var _local_8:uint = 0;
            var _local_9:uint = 0;
            var _local_10:uint = 0;
            var _local_2:uint = param1.length;
            var _local_3:uint = uint(16 - param1.length % 16) || uint(16);
            do {
                param1[param1.length] = _local_3;
            }
            while(param1.length % 16 != 0);
            
            var _local_4:uint = param1.length;
            var _local_5:ByteArray = new ByteArray();
            var _local_6:uint = 0;
            _local_3 = 0;
            while(_local_3 < _local_4) {
                _local_8 = 0;
                while(_local_8 < 16) {
                    _local_6 = _local_5[_local_8] = _local_5[_local_8] ^ S[param1[_local_3 + _local_8] ^ _local_6];
                    _local_8++;
                }
                _local_3 = _local_3 + 16;
            }
            param1.position = param1.length;
            param1.writeBytes(_local_5);
            _local_4 = _local_4 + 16;
            var _local_7:ByteArray = new ByteArray();
            _local_3 = 0;
            while(_local_3 < _local_4) {
                _local_8 = 0;
                while(_local_8 < 16) {
                    _local_7[32 + _local_8] = (_local_7[16 + _local_8] = param1[_local_3 + _local_8]) ^ _local_7[_local_8];
                    _local_8++;
                }
                _local_9 = 0;
                _local_8 = 0;
                while(_local_8 < 18) {
                    _local_10 = 0;
                    while(_local_10 < 48) {
                        _local_7[_local_10] = _local_9 = _local_7[_local_10] ^ S[_local_9];
                        _local_10++;
                    }
                    _local_9 = _local_9 + _local_8 & 255;
                    _local_8++;
                }
                _local_3 = _local_3 + 16;
            }
            _local_7.length = 16;
            param1.length = _local_2;
            return _local_7;
        }
        
        public function toString() : String {
            return "md2";
        }
    }
}
