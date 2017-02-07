package com.hurlant.crypto.hash {
    public class SHA1 extends SHABase implements IHash {
        
        public static const HASH_SIZE:int = 20;
         
        
        public function SHA1() {
            super();
        }
        
        override public function getHashSize() : uint {
            return HASH_SIZE;
        }
        
        override protected function core(param1:Array, param2:uint) : Array {
            var _local_10:uint = 0;
            var _local_11:uint = 0;
            var _local_12:uint = 0;
            var _local_13:uint = 0;
            var _local_14:uint = 0;
            var _local_15:uint = 0;
            var _local_16:uint = 0;
            param1[param2 >> 5] = param1[param2 >> 5] | 128 << 24 - param2 % 32;
            param1[(param2 + 64 >> 9 << 4) + 15] = param2;
            var _local_3:Array = [];
            var _local_4:uint = 1732584193;
            var _local_5:uint = 4023233417;
            var _local_6:uint = 2562383102;
            var _local_7:uint = 271733878;
            var _local_8:uint = 3285377520;
            var _local_9:uint = 0;
            while(_local_9 < param1.length) {
                _local_10 = _local_4;
                _local_11 = _local_5;
                _local_12 = _local_6;
                _local_13 = _local_7;
                _local_14 = _local_8;
                _local_15 = 0;
                while(_local_15 < 80) {
                    if(_local_15 < 16) {
                        _local_3[_local_15] = param1[_local_9 + _local_15] || 0;
                    } else {
                        _local_3[_local_15] = this.rol(_local_3[_local_15 - 3] ^ _local_3[_local_15 - 8] ^ _local_3[_local_15 - 14] ^ _local_3[_local_15 - 16],1);
                    }
                    _local_16 = this.rol(_local_4,5) + this.ft(_local_15,_local_5,_local_6,_local_7) + _local_8 + _local_3[_local_15] + this.kt(_local_15);
                    _local_8 = _local_7;
                    _local_7 = _local_6;
                    _local_6 = this.rol(_local_5,30);
                    _local_5 = _local_4;
                    _local_4 = _local_16;
                    _local_15++;
                }
                _local_4 = _local_4 + _local_10;
                _local_5 = _local_5 + _local_11;
                _local_6 = _local_6 + _local_12;
                _local_7 = _local_7 + _local_13;
                _local_8 = _local_8 + _local_14;
                _local_9 = _local_9 + 16;
            }
            return [_local_4,_local_5,_local_6,_local_7,_local_8];
        }
        
        private function rol(param1:uint, param2:uint) : uint {
            return param1 << param2 | param1 >>> 32 - param2;
        }
        
        private function ft(param1:uint, param2:uint, param3:uint, param4:uint) : uint {
            if(param1 < 20) {
                return param2 & param3 | ~param2 & param4;
            }
            if(param1 < 40) {
                return param2 ^ param3 ^ param4;
            }
            if(param1 < 60) {
                return param2 & param3 | param2 & param4 | param3 & param4;
            }
            return param2 ^ param3 ^ param4;
        }
        
        private function kt(param1:uint) : uint {
            return param1 < 20?uint(1518500249):param1 < 40?uint(1859775393):param1 < 60?uint(2400959708):uint(3395469782);
        }
        
        override public function toString() : String {
            return "sha1";
        }
    }
}
