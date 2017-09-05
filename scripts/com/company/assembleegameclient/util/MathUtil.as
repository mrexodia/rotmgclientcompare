package com.company.assembleegameclient.util {
    public class MathUtil {
         
        
        public function MathUtil() {
            super();
        }
        
        public static function round(param1:Number, param2:int = 0) : Number {
            var _local_3:int = Math.pow(10,param2);
            return Math.round(param1 * _local_3) / _local_3;
        }
    }
}
