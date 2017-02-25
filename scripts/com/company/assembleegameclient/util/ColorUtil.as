package com.company.assembleegameclient.util {
    public class ColorUtil {
         
        
        public function ColorUtil() {
            super();
        }
        
        public static function rangeRandomSmart(param1:uint, param2:uint) : Number {
            var _local_3:uint = param1 >> 16 & 255;
            var _local_4:uint = param1 >> 8 & 255;
            var _local_5:uint = param1 & 255;
            var _local_6:uint = param2 >> 16 & 255;
            var _local_7:uint = param2 >> 8 & 255;
            var _local_8:uint = param2 & 255;
            var _local_9:* = _local_6 + Math.random() * (_local_3 - _local_6);
            var _local_10:* = _local_7 + Math.random() * (_local_4 - _local_7);
            var _local_11:* = _local_8 + Math.random() * (_local_5 - _local_8);
            return _local_9 << 16 | _local_10 << 8 | _local_11;
        }
        
        public static function rangeRandomMix(param1:uint, param2:uint) : Number {
            var _local_3:uint = param1 >> 16 & 255;
            var _local_4:uint = param1 >> 8 & 255;
            var _local_5:uint = param1 & 255;
            var _local_6:uint = param2 >> 16 & 255;
            var _local_7:uint = param2 >> 8 & 255;
            var _local_8:uint = param2 & 255;
            var _local_9:Number = Math.random();
            var _local_10:* = _local_6 + _local_9 * (_local_3 - _local_6);
            var _local_11:* = _local_7 + _local_9 * (_local_4 - _local_7);
            var _local_12:* = _local_8 + _local_9 * (_local_5 - _local_8);
            return _local_10 << 16 | _local_11 << 8 | _local_12;
        }
        
        public static function rangeRandom(param1:uint, param2:uint) : Number {
            return param2 + Math.random() * (param1 - param2);
        }
    }
}
