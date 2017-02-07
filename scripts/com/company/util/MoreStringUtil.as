package com.company.util {
    import flash.utils.ByteArray;
    
    public class MoreStringUtil {
         
        
        public function MoreStringUtil() {
            super();
        }
        
        public static function hexStringToByteArray(param1:String) : ByteArray {
            var _local_2:ByteArray = new ByteArray();
            var _local_3:int = 0;
            while(_local_3 < param1.length) {
                _local_2.writeByte(parseInt(param1.substr(_local_3,2),16));
                _local_3 = _local_3 + 2;
            }
            return _local_2;
        }
        
        public static function cmp(param1:String, param2:String) : Number {
            return param1.localeCompare(param2);
        }
    }
}
