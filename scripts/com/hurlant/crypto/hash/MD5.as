package com.hurlant.crypto.hash {
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    
    public class MD5 implements IHash {
        
        public static const HASH_SIZE:int = 16;
         
        
        public var pad_size:int = 48;
        
        public function MD5() {
            super();
        }
        
        public function getInputSize() : uint {
            return 64;
        }
        
        public function getHashSize() : uint {
            return HASH_SIZE;
        }
        
        public function getPadSize() : int {
            return this.pad_size;
        }
        
        public function hash(param1:ByteArray) : ByteArray {
            var _local_2:uint = param1.length * 8;
            var _local_3:String = param1.endian;
            while(param1.length % 4 != 0) {
                param1[param1.length] = 0;
            }
            param1.position = 0;
            var _local_4:Array = [];
            param1.endian = Endian.LITTLE_ENDIAN;
            var _local_5:uint = 0;
            while(_local_5 < param1.length) {
                _local_4.push(param1.readUnsignedInt());
                _local_5 = _local_5 + 4;
            }
            var _local_6:Array = this.core_md5(_local_4,_local_2);
            var _local_7:ByteArray = new ByteArray();
            _local_7.endian = Endian.LITTLE_ENDIAN;
            _local_5 = 0;
            while(_local_5 < 4) {
                _local_7.writeUnsignedInt(_local_6[_local_5]);
                _local_5++;
            }
            param1.length = _local_2 / 8;
            param1.endian = _local_3;
            return _local_7;
        }
        
        private function core_md5(param1:Array, param2:uint) : Array {
            var _local_8:uint = 0;
            var _local_9:uint = 0;
            var _local_10:uint = 0;
            var _local_11:uint = 0;
            param1[param2 >> 5] = param1[param2 >> 5] | 128 << param2 % 32;
            param1[(param2 + 64 >>> 9 << 4) + 14] = param2;
            var _local_3:uint = 1732584193;
            var _local_4:uint = 4023233417;
            var _local_5:uint = 2562383102;
            var _local_6:uint = 271733878;
            var _local_7:uint = 0;
            while(_local_7 < param1.length) {
                param1[_local_7] = param1[_local_7] || 0;
                param1[_local_7 + 1] = param1[_local_7 + 1] || 0;
                param1[_local_7 + 2] = param1[_local_7 + 2] || 0;
                param1[_local_7 + 3] = param1[_local_7 + 3] || 0;
                param1[_local_7 + 4] = param1[_local_7 + 4] || 0;
                param1[_local_7 + 5] = param1[_local_7 + 5] || 0;
                param1[_local_7 + 6] = param1[_local_7 + 6] || 0;
                param1[_local_7 + 7] = param1[_local_7 + 7] || 0;
                param1[_local_7 + 8] = param1[_local_7 + 8] || 0;
                param1[_local_7 + 9] = param1[_local_7 + 9] || 0;
                param1[_local_7 + 10] = param1[_local_7 + 10] || 0;
                param1[_local_7 + 11] = param1[_local_7 + 11] || 0;
                param1[_local_7 + 12] = param1[_local_7 + 12] || 0;
                param1[_local_7 + 13] = param1[_local_7 + 13] || 0;
                param1[_local_7 + 14] = param1[_local_7 + 14] || 0;
                param1[_local_7 + 15] = param1[_local_7 + 15] || 0;
                _local_8 = _local_3;
                _local_9 = _local_4;
                _local_10 = _local_5;
                _local_11 = _local_6;
                _local_3 = this.ff(_local_3,_local_4,_local_5,_local_6,param1[_local_7 + 0],7,3614090360);
                _local_6 = this.ff(_local_6,_local_3,_local_4,_local_5,param1[_local_7 + 1],12,3905402710);
                _local_5 = this.ff(_local_5,_local_6,_local_3,_local_4,param1[_local_7 + 2],17,606105819);
                _local_4 = this.ff(_local_4,_local_5,_local_6,_local_3,param1[_local_7 + 3],22,3250441966);
                _local_3 = this.ff(_local_3,_local_4,_local_5,_local_6,param1[_local_7 + 4],7,4118548399);
                _local_6 = this.ff(_local_6,_local_3,_local_4,_local_5,param1[_local_7 + 5],12,1200080426);
                _local_5 = this.ff(_local_5,_local_6,_local_3,_local_4,param1[_local_7 + 6],17,2821735955);
                _local_4 = this.ff(_local_4,_local_5,_local_6,_local_3,param1[_local_7 + 7],22,4249261313);
                _local_3 = this.ff(_local_3,_local_4,_local_5,_local_6,param1[_local_7 + 8],7,1770035416);
                _local_6 = this.ff(_local_6,_local_3,_local_4,_local_5,param1[_local_7 + 9],12,2336552879);
                _local_5 = this.ff(_local_5,_local_6,_local_3,_local_4,param1[_local_7 + 10],17,4294925233);
                _local_4 = this.ff(_local_4,_local_5,_local_6,_local_3,param1[_local_7 + 11],22,2304563134);
                _local_3 = this.ff(_local_3,_local_4,_local_5,_local_6,param1[_local_7 + 12],7,1804603682);
                _local_6 = this.ff(_local_6,_local_3,_local_4,_local_5,param1[_local_7 + 13],12,4254626195);
                _local_5 = this.ff(_local_5,_local_6,_local_3,_local_4,param1[_local_7 + 14],17,2792965006);
                _local_4 = this.ff(_local_4,_local_5,_local_6,_local_3,param1[_local_7 + 15],22,1236535329);
                _local_3 = this.gg(_local_3,_local_4,_local_5,_local_6,param1[_local_7 + 1],5,4129170786);
                _local_6 = this.gg(_local_6,_local_3,_local_4,_local_5,param1[_local_7 + 6],9,3225465664);
                _local_5 = this.gg(_local_5,_local_6,_local_3,_local_4,param1[_local_7 + 11],14,643717713);
                _local_4 = this.gg(_local_4,_local_5,_local_6,_local_3,param1[_local_7 + 0],20,3921069994);
                _local_3 = this.gg(_local_3,_local_4,_local_5,_local_6,param1[_local_7 + 5],5,3593408605);
                _local_6 = this.gg(_local_6,_local_3,_local_4,_local_5,param1[_local_7 + 10],9,38016083);
                _local_5 = this.gg(_local_5,_local_6,_local_3,_local_4,param1[_local_7 + 15],14,3634488961);
                _local_4 = this.gg(_local_4,_local_5,_local_6,_local_3,param1[_local_7 + 4],20,3889429448);
                _local_3 = this.gg(_local_3,_local_4,_local_5,_local_6,param1[_local_7 + 9],5,568446438);
                _local_6 = this.gg(_local_6,_local_3,_local_4,_local_5,param1[_local_7 + 14],9,3275163606);
                _local_5 = this.gg(_local_5,_local_6,_local_3,_local_4,param1[_local_7 + 3],14,4107603335);
                _local_4 = this.gg(_local_4,_local_5,_local_6,_local_3,param1[_local_7 + 8],20,1163531501);
                _local_3 = this.gg(_local_3,_local_4,_local_5,_local_6,param1[_local_7 + 13],5,2850285829);
                _local_6 = this.gg(_local_6,_local_3,_local_4,_local_5,param1[_local_7 + 2],9,4243563512);
                _local_5 = this.gg(_local_5,_local_6,_local_3,_local_4,param1[_local_7 + 7],14,1735328473);
                _local_4 = this.gg(_local_4,_local_5,_local_6,_local_3,param1[_local_7 + 12],20,2368359562);
                _local_3 = this.hh(_local_3,_local_4,_local_5,_local_6,param1[_local_7 + 5],4,4294588738);
                _local_6 = this.hh(_local_6,_local_3,_local_4,_local_5,param1[_local_7 + 8],11,2272392833);
                _local_5 = this.hh(_local_5,_local_6,_local_3,_local_4,param1[_local_7 + 11],16,1839030562);
                _local_4 = this.hh(_local_4,_local_5,_local_6,_local_3,param1[_local_7 + 14],23,4259657740);
                _local_3 = this.hh(_local_3,_local_4,_local_5,_local_6,param1[_local_7 + 1],4,2763975236);
                _local_6 = this.hh(_local_6,_local_3,_local_4,_local_5,param1[_local_7 + 4],11,1272893353);
                _local_5 = this.hh(_local_5,_local_6,_local_3,_local_4,param1[_local_7 + 7],16,4139469664);
                _local_4 = this.hh(_local_4,_local_5,_local_6,_local_3,param1[_local_7 + 10],23,3200236656);
                _local_3 = this.hh(_local_3,_local_4,_local_5,_local_6,param1[_local_7 + 13],4,681279174);
                _local_6 = this.hh(_local_6,_local_3,_local_4,_local_5,param1[_local_7 + 0],11,3936430074);
                _local_5 = this.hh(_local_5,_local_6,_local_3,_local_4,param1[_local_7 + 3],16,3572445317);
                _local_4 = this.hh(_local_4,_local_5,_local_6,_local_3,param1[_local_7 + 6],23,76029189);
                _local_3 = this.hh(_local_3,_local_4,_local_5,_local_6,param1[_local_7 + 9],4,3654602809);
                _local_6 = this.hh(_local_6,_local_3,_local_4,_local_5,param1[_local_7 + 12],11,3873151461);
                _local_5 = this.hh(_local_5,_local_6,_local_3,_local_4,param1[_local_7 + 15],16,530742520);
                _local_4 = this.hh(_local_4,_local_5,_local_6,_local_3,param1[_local_7 + 2],23,3299628645);
                _local_3 = this.ii(_local_3,_local_4,_local_5,_local_6,param1[_local_7 + 0],6,4096336452);
                _local_6 = this.ii(_local_6,_local_3,_local_4,_local_5,param1[_local_7 + 7],10,1126891415);
                _local_5 = this.ii(_local_5,_local_6,_local_3,_local_4,param1[_local_7 + 14],15,2878612391);
                _local_4 = this.ii(_local_4,_local_5,_local_6,_local_3,param1[_local_7 + 5],21,4237533241);
                _local_3 = this.ii(_local_3,_local_4,_local_5,_local_6,param1[_local_7 + 12],6,1700485571);
                _local_6 = this.ii(_local_6,_local_3,_local_4,_local_5,param1[_local_7 + 3],10,2399980690);
                _local_5 = this.ii(_local_5,_local_6,_local_3,_local_4,param1[_local_7 + 10],15,4293915773);
                _local_4 = this.ii(_local_4,_local_5,_local_6,_local_3,param1[_local_7 + 1],21,2240044497);
                _local_3 = this.ii(_local_3,_local_4,_local_5,_local_6,param1[_local_7 + 8],6,1873313359);
                _local_6 = this.ii(_local_6,_local_3,_local_4,_local_5,param1[_local_7 + 15],10,4264355552);
                _local_5 = this.ii(_local_5,_local_6,_local_3,_local_4,param1[_local_7 + 6],15,2734768916);
                _local_4 = this.ii(_local_4,_local_5,_local_6,_local_3,param1[_local_7 + 13],21,1309151649);
                _local_3 = this.ii(_local_3,_local_4,_local_5,_local_6,param1[_local_7 + 4],6,4149444226);
                _local_6 = this.ii(_local_6,_local_3,_local_4,_local_5,param1[_local_7 + 11],10,3174756917);
                _local_5 = this.ii(_local_5,_local_6,_local_3,_local_4,param1[_local_7 + 2],15,718787259);
                _local_4 = this.ii(_local_4,_local_5,_local_6,_local_3,param1[_local_7 + 9],21,3951481745);
                _local_3 = _local_3 + _local_8;
                _local_4 = _local_4 + _local_9;
                _local_5 = _local_5 + _local_10;
                _local_6 = _local_6 + _local_11;
                _local_7 = _local_7 + 16;
            }
            return [_local_3,_local_4,_local_5,_local_6];
        }
        
        private function rol(param1:uint, param2:uint) : uint {
            return param1 << param2 | param1 >>> 32 - param2;
        }
        
        private function cmn(param1:uint, param2:uint, param3:uint, param4:uint, param5:uint, param6:uint) : uint {
            return this.rol(param2 + param1 + param4 + param6,param5) + param3;
        }
        
        private function ff(param1:uint, param2:uint, param3:uint, param4:uint, param5:uint, param6:uint, param7:uint) : uint {
            return this.cmn(param2 & param3 | ~param2 & param4,param1,param2,param5,param6,param7);
        }
        
        private function gg(param1:uint, param2:uint, param3:uint, param4:uint, param5:uint, param6:uint, param7:uint) : uint {
            return this.cmn(param2 & param4 | param3 & ~param4,param1,param2,param5,param6,param7);
        }
        
        private function hh(param1:uint, param2:uint, param3:uint, param4:uint, param5:uint, param6:uint, param7:uint) : uint {
            return this.cmn(param2 ^ param3 ^ param4,param1,param2,param5,param6,param7);
        }
        
        private function ii(param1:uint, param2:uint, param3:uint, param4:uint, param5:uint, param6:uint, param7:uint) : uint {
            return this.cmn(param3 ^ (param2 | ~param4),param1,param2,param5,param6,param7);
        }
        
        public function toString() : String {
            return "md5";
        }
    }
}
