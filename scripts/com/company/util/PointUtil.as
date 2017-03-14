package com.company.util {
    import flash.geom.Point;
    
    public class PointUtil {
        
        public static const ORIGIN:Point = new Point(0,0);
         
        
        public function PointUtil(param1:StaticEnforcer#122) {
            super();
        }
        
        public static function roundPoint(param1:Point) : Point {
            var _local_2:Point = param1.clone();
            _local_2.x = Math.round(_local_2.x);
            _local_2.y = Math.round(_local_2.y);
            return _local_2;
        }
        
        public static function distanceSquared(param1:Point, param2:Point) : Number {
            return distanceSquaredXY(param1.x,param1.y,param2.x,param2.y);
        }
        
        public static function distanceSquaredXY(param1:Number, param2:Number, param3:Number, param4:Number) : Number {
            var _local_5:Number = param3 - param1;
            var _local_6:Number = param4 - param2;
            return _local_5 * _local_5 + _local_6 * _local_6;
        }
        
        public static function distanceXY(param1:Number, param2:Number, param3:Number, param4:Number) : Number {
            var _local_5:Number = param3 - param1;
            var _local_6:Number = param4 - param2;
            return Math.sqrt(_local_5 * _local_5 + _local_6 * _local_6);
        }
        
        public static function lerpXY(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : Point {
            return new Point(param1 + (param3 - param1) * param5,param2 + (param4 - param2) * param5);
        }
        
        public static function angleTo(param1:Point, param2:Point) : Number {
            return Math.atan2(param2.y - param1.y,param2.x - param1.x);
        }
        
        public static function pointAt(param1:Point, param2:Number, param3:Number) : Point {
            var _local_4:Point = new Point();
            _local_4.x = param1.x + param3 * Math.cos(param2);
            _local_4.y = param1.y + param3 * Math.sin(param2);
            return _local_4;
        }
    }
}

class StaticEnforcer#122 {
     
    
    function StaticEnforcer#122() {
        super();
    }
}
