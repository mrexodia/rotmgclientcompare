package com.company.assembleegameclient.engine3d {
    import flash.geom.Vector3D;
    
    public class Lighting3D {
        
        public static const LIGHT_VECTOR:Vector3D = createLightVector();
         
        
        public function Lighting3D() {
            super();
        }
        
        public static function shadeValue(param1:Vector3D, param2:Number) : Number {
            var _local_3:Number = Math.max(0,param1.dotProduct(Lighting3D.LIGHT_VECTOR));
            return param2 + (1 - param2) * _local_3;
        }
        
        private static function createLightVector() : Vector3D {
            var _local_1:Vector3D = new Vector3D(1,3,2);
            _local_1.normalize();
            return _local_1;
        }
    }
}
