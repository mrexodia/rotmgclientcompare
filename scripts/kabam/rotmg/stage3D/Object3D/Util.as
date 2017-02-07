package kabam.rotmg.stage3D.Object3D {
    import flash.geom.Matrix3D;
    import flash.utils.ByteArray;
    
    public class Util {
         
        
        public function Util() {
            super();
        }
        
        public static function perspectiveProjection(param1:Number = 90, param2:Number = 1, param3:Number = 1, param4:Number = 2048) : Matrix3D {
            var _local_5:Number = param3 * Math.tan(param1 * Math.PI / 360);
            var _local_6:Number = -_local_5;
            var _local_7:Number = _local_6 * param2;
            var _local_8:Number = _local_5 * param2;
            var _local_9:Number = 2 * param3 / (_local_8 - _local_7);
            var _local_10:Number = 2 * param3 / (_local_5 - _local_6);
            var _local_11:Number = (_local_8 + _local_7) / (_local_8 - _local_7);
            var _local_12:Number = (_local_5 + _local_6) / (_local_5 - _local_6);
            var _local_13:Number = -(param4 + param3) / (param4 - param3);
            var _local_14:Number = -2 * (param4 * param3) / (param4 - param3);
            return new Matrix3D(Vector.<Number>([_local_9,0,0,0,0,_local_10,0,0,_local_11,_local_12,_local_13,-1,0,0,_local_14,0]));
        }
        
        public static function readString(param1:ByteArray, param2:int) : String {
            var _local_5:uint = 0;
            var _local_3:String = "";
            var _local_4:int = 0;
            while(_local_4 < param2) {
                _local_5 = param1.readUnsignedByte();
                if(_local_5 === 0) {
                    param1.position = param1.position + Math.max(0,param2 - (_local_4 + 1));
                    break;
                }
                _local_3 = _local_3 + String.fromCharCode(_local_5);
                _local_4++;
            }
            return _local_3;
        }
        
        public static function upperPowerOfTwo(param1:uint) : uint {
            param1--;
            param1 = param1 | param1 >> 1;
            param1 = param1 | param1 >> 2;
            param1 = param1 | param1 >> 4;
            param1 = param1 | param1 >> 8;
            param1 = param1 | param1 >> 16;
            param1++;
            return param1;
        }
    }
}
