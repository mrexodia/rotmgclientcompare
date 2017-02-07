package com.hurlant.util {
    import flash.utils.ByteArray;
    
    public class Hex {
         
        
        public function Hex() {
            super();
        }
        
        public static function toArray(param1:String) : ByteArray {
            param1 = param1.replace(/\s|:/gm,"");
            var _local_2:ByteArray = new ByteArray();
            if(param1.length & 1 == 1) {
                param1 = "0" + param1;
            }
            var _local_3:uint = 0;
            while(_local_3 < param1.length) {
                _local_2[_local_3 / 2] = parseInt(param1.substr(_local_3,2),16);
                _local_3 = _local_3 + 2;
            }
            return _local_2;
        }
        
        public static function fromArray(param1:ByteArray, param2:Boolean = false) : String {
            var _local_3:* = "";
            var _local_4:uint = 0;
            while(_local_4 < param1.length) {
                _local_3 = _local_3 + ("0" + param1[_local_4].toString(16)).substr(-2,2);
                if(param2) {
                    if(_local_4 < param1.length - 1) {
                        _local_3 = _local_3 + ":";
                    }
                }
                _local_4++;
            }
            return _local_3;
        }
        
        public static function toString(param1:String) : String {
            var _local_2:ByteArray = toArray(param1);
            return _local_2.readUTFBytes(_local_2.length);
        }
        
        public static function fromString(param1:String, param2:Boolean = false) : String {
            var _local_3:ByteArray = new ByteArray();
            _local_3.writeUTFBytes(param1);
            return fromArray(_local_3,param2);
        }
    }
}
