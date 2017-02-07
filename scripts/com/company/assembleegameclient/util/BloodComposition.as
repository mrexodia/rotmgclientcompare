package com.company.assembleegameclient.util {
    import flash.display.BitmapData;
    import flash.utils.Dictionary;
    
    public class BloodComposition {
        
        private static var idDict_:Dictionary = new Dictionary();
        
        private static var imageDict_:Dictionary = new Dictionary();
         
        
        public function BloodComposition() {
            super();
        }
        
        public static function getBloodComposition(param1:int, param2:BitmapData, param3:Number, param4:uint) : Vector.<uint> {
            var _local_5:Vector.<uint> = idDict_[param1];
            if(_local_5 != null) {
                return _local_5;
            }
            _local_5 = new Vector.<uint>();
            var _local_6:Vector.<uint> = getColors(param2);
            var _local_7:int = 0;
            while(_local_7 < _local_6.length) {
                if(Math.random() < param3) {
                    _local_5.push(param4);
                } else {
                    _local_5.push(_local_6[int(_local_6.length * Math.random())]);
                }
                _local_7++;
            }
            return _local_5;
        }
        
        public static function getColors(param1:BitmapData) : Vector.<uint> {
            var _local_2:Vector.<uint> = imageDict_[param1];
            if(_local_2 == null) {
                _local_2 = buildColors(param1);
                imageDict_[param1] = _local_2;
            }
            return _local_2;
        }
        
        private static function buildColors(param1:BitmapData) : Vector.<uint> {
            var _local_4:int = 0;
            var _local_5:uint = 0;
            var _local_2:Vector.<uint> = new Vector.<uint>();
            var _local_3:int = 0;
            while(_local_3 < param1.width) {
                _local_4 = 0;
                while(_local_4 < param1.height) {
                    _local_5 = param1.getPixel32(_local_3,_local_4);
                    if((_local_5 & 4278190080) != 0) {
                        _local_2.push(_local_5);
                    }
                    _local_4++;
                }
                _local_3++;
            }
            return _local_2;
        }
    }
}
