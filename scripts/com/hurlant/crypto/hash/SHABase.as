package com.hurlant.crypto.hash {
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    
    public class SHABase implements IHash {
         
        
        public var pad_size:int = 40;
        
        public function SHABase() {
            super();
        }
        
        public function getInputSize() : uint {
            return 64;
        }
        
        public function getHashSize() : uint {
            return 0;
        }
        
        public function getPadSize() : int {
            return this.pad_size;
        }
        
        public function hash(param1:ByteArray) : ByteArray {
            var _local_2:uint = param1.length;
            var _local_3:String = param1.endian;
            param1.endian = Endian.BIG_ENDIAN;
            var _local_4:uint = _local_2 * 8;
            while(param1.length % 4 != 0) {
                param1[param1.length] = 0;
            }
            param1.position = 0;
            var _local_5:Array = [];
            var _local_6:uint = 0;
            while(_local_6 < param1.length) {
                _local_5.push(param1.readUnsignedInt());
                _local_6 = _local_6 + 4;
            }
            var _local_7:Array = this.core(_local_5,_local_4);
            var _local_8:ByteArray = new ByteArray();
            var _local_9:uint = this.getHashSize() / 4;
            _local_6 = 0;
            while(_local_6 < _local_9) {
                _local_8.writeUnsignedInt(_local_7[_local_6]);
                _local_6++;
            }
            param1.length = _local_2;
            param1.endian = _local_3;
            return _local_8;
        }
        
        protected function core(param1:Array, param2:uint) : Array {
            return null;
        }
        
        public function toString() : String {
            return "sha";
        }
    }
}
