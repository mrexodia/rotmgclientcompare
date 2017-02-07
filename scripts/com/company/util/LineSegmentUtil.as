package com.company.util {
    import flash.geom.Point;
    
    public class LineSegmentUtil {
         
        
        public function LineSegmentUtil() {
            super();
        }
        
        public static function intersection(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : Point {
            var _local_9:Number = (param8 - param6) * (param3 - param1) - (param7 - param5) * (param4 - param2);
            if(_local_9 == 0) {
                return null;
            }
            var _local_10:Number = ((param7 - param5) * (param2 - param6) - (param8 - param6) * (param1 - param5)) / _local_9;
            var _local_11:Number = ((param3 - param1) * (param2 - param6) - (param4 - param2) * (param1 - param5)) / _local_9;
            if(_local_10 > 1 || _local_10 < 0 || _local_11 > 1 || _local_11 < 0) {
                return null;
            }
            var _local_12:Point = new Point(param1 + _local_10 * (param3 - param1),param2 + _local_10 * (param4 - param2));
            return _local_12;
        }
        
        public static function pointDistance(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : Number {
            var _local_10:Number = NaN;
            var _local_11:Number = NaN;
            var _local_12:Number = NaN;
            var _local_7:Number = param5 - param3;
            var _local_8:Number = param6 - param4;
            var _local_9:Number = _local_7 * _local_7 + _local_8 * _local_8;
            if(_local_9 < 0.001) {
                _local_10 = param3;
                _local_11 = param4;
            } else {
                _local_12 = ((param1 - param3) * _local_7 + (param2 - param4) * _local_8) / _local_9;
                if(_local_12 < 0) {
                    _local_10 = param3;
                    _local_11 = param4;
                } else if(_local_12 > 1) {
                    _local_10 = param5;
                    _local_11 = param6;
                } else {
                    _local_10 = param3 + _local_12 * _local_7;
                    _local_11 = param4 + _local_12 * _local_8;
                }
            }
            _local_7 = param1 - _local_10;
            _local_8 = param2 - _local_11;
            return Math.sqrt(_local_7 * _local_7 + _local_8 * _local_8);
        }
    }
}
