package com.adobe.serialization.json {
    public class JSON {
         
        
        public function JSON() {
            super();
        }
        
        public static function encode(param1:Object) : String {
            var _local_2:JSONEncoder = new JSONEncoder(param1);
            return _local_2.getString();
        }
        
        public static function decode(param1:String) : * {
            var _local_2:JSONDecoder = new JSONDecoder(param1);
            return _local_2.getValue();
        }
    }
}
