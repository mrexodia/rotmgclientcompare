package com.adobe.utils {
    import flash.utils.Dictionary;
    
    public class DictionaryUtil {
         
        
        public function DictionaryUtil() {
            super();
        }
        
        public static function getKeys(param1:Dictionary) : Array {
            var _local_3:* = null;
            var _local_2:Array = new Array();
            for(_local_3 in param1) {
                _local_2.push(_local_3);
            }
            return _local_2;
        }
        
        public static function getValues(param1:Dictionary) : Array {
            var _local_3:Object = null;
            var _local_2:Array = new Array();
            for each(_local_3 in param1) {
                _local_2.push(_local_3);
            }
            return _local_2;
        }
    }
}
