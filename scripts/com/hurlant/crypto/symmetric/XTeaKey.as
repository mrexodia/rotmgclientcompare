package com.hurlant.crypto.symmetric {
    import com.hurlant.crypto.prng.Random;
    import com.hurlant.util.Memory;
    import flash.utils.ByteArray;
    
    public class XTeaKey implements ISymmetricKey {
         
        
        public const NUM_ROUNDS:uint = 64;
        
        private var k:Array;
        
        public function XTeaKey(param1:ByteArray) {
            super();
            param1.position = 0;
            this.k = [param1.readUnsignedInt(),param1.readUnsignedInt(),param1.readUnsignedInt(),param1.readUnsignedInt()];
        }
        
        public static function parseKey(param1:String) : XTeaKey {
            var _local_2:ByteArray = new ByteArray();
            _local_2.writeUnsignedInt(parseInt(param1.substr(0,8),16));
            _local_2.writeUnsignedInt(parseInt(param1.substr(8,8),16));
            _local_2.writeUnsignedInt(parseInt(param1.substr(16,8),16));
            _local_2.writeUnsignedInt(parseInt(param1.substr(24,8),16));
            _local_2.position = 0;
            return new XTeaKey(_local_2);
        }
        
        public function getBlockSize() : uint {
            return 8;
        }
        
        public function encrypt(param1:ByteArray, param2:uint = 0) : void {
            var _local_5:uint = 0;
            param1.position = param2;
            var _local_3:uint = param1.readUnsignedInt();
            var _local_4:uint = param1.readUnsignedInt();
            var _local_6:uint = 0;
            var _local_7:uint = 2654435769;
            _local_5 = 0;
            while(_local_5 < this.NUM_ROUNDS) {
                _local_3 = _local_3 + ((_local_4 << 4 ^ _local_4 >> 5) + _local_4 ^ _local_6 + this.k[_local_6 & 3]);
                _local_6 = _local_6 + _local_7;
                _local_4 = _local_4 + ((_local_3 << 4 ^ _local_3 >> 5) + _local_3 ^ _local_6 + this.k[_local_6 >> 11 & 3]);
                _local_5++;
            }
            param1.position = param1.position - 8;
            param1.writeUnsignedInt(_local_3);
            param1.writeUnsignedInt(_local_4);
        }
        
        public function decrypt(param1:ByteArray, param2:uint = 0) : void {
            var _local_5:uint = 0;
            param1.position = param2;
            var _local_3:uint = param1.readUnsignedInt();
            var _local_4:uint = param1.readUnsignedInt();
            var _local_6:uint = 2654435769;
            var _local_7:uint = _local_6 * this.NUM_ROUNDS;
            _local_5 = 0;
            while(_local_5 < this.NUM_ROUNDS) {
                _local_4 = _local_4 - ((_local_3 << 4 ^ _local_3 >> 5) + _local_3 ^ _local_7 + this.k[_local_7 >> 11 & 3]);
                _local_7 = _local_7 - _local_6;
                _local_3 = _local_3 - ((_local_4 << 4 ^ _local_4 >> 5) + _local_4 ^ _local_7 + this.k[_local_7 & 3]);
                _local_5++;
            }
            param1.position = param1.position - 8;
            param1.writeUnsignedInt(_local_3);
            param1.writeUnsignedInt(_local_4);
        }
        
        public function dispose() : void {
            var _local_1:Random = new Random();
            var _local_2:uint = 0;
            while(_local_2 < this.k.length) {
                this.k[_local_2] = _local_1.nextByte();
                delete this.k[_local_2];
                _local_2++;
            }
            this.k = null;
            Memory.gc();
        }
        
        public function toString() : String {
            return "xtea";
        }
    }
}
