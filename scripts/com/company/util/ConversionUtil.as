package com.company.util {
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.geom.Vector3D;
    
    public class ConversionUtil {
         
        
        public function ConversionUtil(param1:StaticEnforcer#112) {
            super();
        }
        
        public static function toIntArray(param1:Object, param2:String = ",") : Array {
            if(param1 == null) {
                return new Array();
            }
            var _local_3:Array = param1.toString().split(param2).map(mapParseInt);
            return _local_3;
        }
        
        public static function toNumberArray(param1:Object, param2:String = ",") : Array {
            if(param1 == null) {
                return new Array();
            }
            var _local_3:Array = param1.toString().split(param2).map(mapParseFloat);
            return _local_3;
        }
        
        public static function toIntVector(param1:Object, param2:String = ",") : Vector.<int> {
            if(param1 == null) {
                return new Vector.<int>();
            }
            var _local_3:Vector.<int> = Vector.<int>(param1.toString().split(param2).map(mapParseInt));
            return _local_3;
        }
        
        public static function toNumberVector(param1:Object, param2:String = ",") : Vector.<Number> {
            if(param1 == null) {
                return new Vector.<Number>();
            }
            var _local_3:Vector.<Number> = Vector.<Number>(param1.toString().split(param2).map(mapParseFloat));
            return _local_3;
        }
        
        public static function toStringArray(param1:Object, param2:String = ",") : Array {
            if(param1 == null) {
                return new Array();
            }
            var _local_3:Array = param1.toString().split(param2);
            return _local_3;
        }
        
        public static function toRectangle(param1:Object, param2:String = ",") : Rectangle {
            if(param1 == null) {
                return new Rectangle();
            }
            var _local_3:Array = param1.toString().split(param2).map(mapParseFloat);
            return _local_3 == null || _local_3.length < 4?new Rectangle():new Rectangle(_local_3[0],_local_3[1],_local_3[2],_local_3[3]);
        }
        
        public static function toPoint(param1:Object, param2:String = ",") : Point {
            if(param1 == null) {
                return new Point();
            }
            var _local_3:Array = param1.toString().split(param2).map(ConversionUtil.mapParseFloat);
            return _local_3 == null || _local_3.length < 2?new Point():new Point(_local_3[0],_local_3[1]);
        }
        
        public static function toPointPair(param1:Object, param2:String = ",") : Array {
            var _local_3:Array = new Array();
            if(param1 == null) {
                _local_3.push(new Point());
                _local_3.push(new Point());
                return _local_3;
            }
            var _local_4:Array = param1.toString().split(param2).map(ConversionUtil.mapParseFloat);
            if(_local_4 == null || _local_4.length < 4) {
                _local_3.push(new Point());
                _local_3.push(new Point());
                return _local_3;
            }
            _local_3.push(new Point(_local_4[0],_local_4[1]));
            _local_3.push(new Point(_local_4[2],_local_4[3]));
            return _local_3;
        }
        
        public static function toVector3D(param1:Object, param2:String = ",") : Vector3D {
            if(param1 == null) {
                return new Vector3D();
            }
            var _local_3:Array = param1.toString().split(param2).map(ConversionUtil.mapParseFloat);
            return _local_3 == null || _local_3.length < 3?new Vector3D():new Vector3D(_local_3[0],_local_3[1],_local_3[2]);
        }
        
        public static function toCharCodesVector(param1:Object, param2:String = ",") : Vector.<int> {
            if(param1 == null) {
                return new Vector.<int>();
            }
            var _local_3:Vector.<int> = Vector.<int>(param1.toString().split(param2).map(mapParseCharCode));
            return _local_3;
        }
        
        public static function addToNumberVector(param1:Object, param2:Vector.<Number>, param3:String = ",") : void {
            var _local_5:Number = NaN;
            if(param1 == null) {
                return;
            }
            var _local_4:Array = param1.toString().split(param3).map(mapParseFloat);
            for each(_local_5 in _local_4) {
                param2.push(_local_5);
            }
        }
        
        public static function addToIntVector(param1:Object, param2:Vector.<int>, param3:String = ",") : void {
            var _local_5:int = 0;
            if(param1 == null) {
                return;
            }
            var _local_4:Array = param1.toString().split(param3).map(mapParseFloat);
            for each(_local_5 in _local_4) {
                param2.push(_local_5);
            }
        }
        
        public static function mapParseFloat(param1:*, ... rest) : Number {
            return parseFloat(param1);
        }
        
        public static function mapParseInt(param1:*, ... rest) : Number {
            return parseInt(param1);
        }
        
        public static function mapParseCharCode(param1:*, ... rest) : Number {
            return String(param1).charCodeAt();
        }
        
        public static function vector3DToShaderParameter(param1:Vector3D) : Array {
            return [param1.x,param1.y,param1.z];
        }
    }
}

class StaticEnforcer#112 {
     
    
    function StaticEnforcer#112() {
        super();
    }
}
