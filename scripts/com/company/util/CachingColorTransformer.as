package com.company.util {
    import flash.display.BitmapData;
    import flash.filters.BitmapFilter;
    import flash.geom.ColorTransform;
    import flash.geom.Point;
    import flash.utils.Dictionary;
    
    public class CachingColorTransformer {
        
        private static var bds_:Dictionary = new Dictionary();
         
        
        public function CachingColorTransformer() {
            super();
        }
        
        public static function transformBitmapData(param1:BitmapData, param2:ColorTransform) : BitmapData {
            var _local_3:BitmapData = null;
            var _local_4:Object = bds_[param1];
            if(_local_4 != null) {
                _local_3 = _local_4[param2];
            } else {
                _local_4 = new Object();
                bds_[param1] = _local_4;
            }
            if(_local_3 == null) {
                _local_3 = param1.clone();
                _local_3.colorTransform(_local_3.rect,param2);
                _local_4[param2] = _local_3;
            }
            return _local_3;
        }
        
        public static function filterBitmapData(param1:BitmapData, param2:BitmapFilter) : BitmapData {
            var _local_3:BitmapData = null;
            var _local_4:Object = bds_[param1];
            if(_local_4 != null) {
                _local_3 = _local_4[param2];
            } else {
                _local_4 = new Object();
                bds_[param1] = _local_4;
            }
            if(_local_3 == null) {
                _local_3 = param1.clone();
                _local_3.applyFilter(_local_3,_local_3.rect,new Point(),param2);
                _local_4[param2] = _local_3;
            }
            return _local_3;
        }
        
        public static function alphaBitmapData(param1:BitmapData, param2:Number) : BitmapData {
            var _local_3:int = int(param2 * 100);
            var _local_4:ColorTransform = new ColorTransform(1,1,1,_local_3 / 100);
            return transformBitmapData(param1,_local_4);
        }
        
        public static function clear() : void {
            var _local_1:Object = null;
            var _local_2:BitmapData = null;
            for each(_local_1 in bds_) {
                for each(_local_2 in _local_1) {
                    _local_2.dispose();
                }
            }
            bds_ = new Dictionary();
        }
    }
}
