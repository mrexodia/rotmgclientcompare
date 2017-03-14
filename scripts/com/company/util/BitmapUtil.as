package com.company.util {
    import flash.display.BitmapData;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;
    
    public class BitmapUtil {
         
        
        public function BitmapUtil(param1:StaticEnforcer#111) {
            super();
        }
        
        public static function mirror(param1:BitmapData, param2:int = 0) : BitmapData {
            var _local_5:int = 0;
            if(param2 == 0) {
                param2 = param1.width;
            }
            var _local_3:BitmapData = new BitmapData(param1.width,param1.height,true,0);
            var _local_4:int = 0;
            while(_local_4 < param2) {
                _local_5 = 0;
                while(_local_5 < param1.height) {
                    _local_3.setPixel32(param2 - _local_4 - 1,_local_5,param1.getPixel32(_local_4,_local_5));
                    _local_5++;
                }
                _local_4++;
            }
            return _local_3;
        }
        
        public static function rotateBitmapData(param1:BitmapData, param2:int) : BitmapData {
            var _local_3:Matrix = new Matrix();
            _local_3.translate(-param1.width / 2,-param1.height / 2);
            _local_3.rotate(param2 * Math.PI / 2);
            _local_3.translate(param1.height / 2,param1.width / 2);
            var _local_4:BitmapData = new BitmapData(param1.height,param1.width,true,0);
            _local_4.draw(param1,_local_3);
            return _local_4;
        }
        
        public static function cropToBitmapData(param1:BitmapData, param2:int, param3:int, param4:int, param5:int) : BitmapData {
            var _local_6:BitmapData = new BitmapData(param4,param5);
            _local_6.copyPixels(param1,new Rectangle(param2,param3,param4,param5),new Point(0,0));
            return _local_6;
        }
        
        public static function amountTransparent(param1:BitmapData) : Number {
            var _local_4:int = 0;
            var _local_5:* = 0;
            var _local_2:int = 0;
            var _local_3:int = 0;
            while(_local_3 < param1.width) {
                _local_4 = 0;
                while(_local_4 < param1.height) {
                    _local_5 = param1.getPixel32(_local_3,_local_4) & 4278190080;
                    if(_local_5 == 0) {
                        _local_2++;
                    }
                    _local_4++;
                }
                _local_3++;
            }
            return _local_2 / (param1.width * param1.height);
        }
        
        public static function mostCommonColor(param1:BitmapData) : uint {
            var _local_3:uint = 0;
            var _local_7:* = null;
            var _local_8:int = 0;
            var _local_9:int = 0;
            var _local_2:Dictionary = new Dictionary();
            var _local_4:int = 0;
            while(_local_4 < param1.width) {
                _local_8 = 0;
                while(_local_8 < param1.width) {
                    _local_3 = param1.getPixel32(_local_4,_local_8);
                    if((_local_3 & 4278190080) != 0) {
                        if(!_local_2.hasOwnProperty(_local_3)) {
                            _local_2[_local_3] = 1;
                        } else {
                            _local_2[_local_3]++;
                        }
                    }
                    _local_8++;
                }
                _local_4++;
            }
            var _local_5:uint = 0;
            var _local_6:uint = 0;
            for(_local_7 in _local_2) {
                _local_3 = uint(_local_7);
                _local_9 = _local_2[_local_7];
                if(_local_9 > _local_6 || _local_9 == _local_6 && _local_3 > _local_5) {
                    _local_5 = _local_3;
                    _local_6 = _local_9;
                }
            }
            return _local_5;
        }
        
        public static function lineOfSight(param1:BitmapData, param2:IntPoint, param3:IntPoint) : Boolean {
            var _local_11:int = 0;
            var _local_19:int = 0;
            var _local_20:int = 0;
            var _local_21:int = 0;
            var _local_4:int = param1.width;
            var _local_5:int = param1.height;
            var _local_6:int = param2.x();
            var _local_7:int = param2.y();
            var _local_8:int = param3.x();
            var _local_9:int = param3.y();
            var _local_10:* = (_local_7 > _local_9?_local_7 - _local_9:_local_9 - _local_7) > (_local_6 > _local_8?_local_6 - _local_8:_local_8 - _local_6);
            if(_local_10) {
                _local_11 = _local_6;
                _local_6 = _local_7;
                _local_7 = _local_11;
                _local_11 = _local_8;
                _local_8 = _local_9;
                _local_9 = _local_11;
                _local_11 = _local_4;
                _local_4 = _local_5;
                _local_5 = _local_11;
            }
            if(_local_6 > _local_8) {
                _local_11 = _local_6;
                _local_6 = _local_8;
                _local_8 = _local_11;
                _local_11 = _local_7;
                _local_7 = _local_9;
                _local_9 = _local_11;
            }
            var _local_12:int = _local_8 - _local_6;
            var _local_13:int = _local_7 > _local_9?int(_local_7 - _local_9):int(_local_9 - _local_7);
            var _local_14:int = -(_local_12 + 1) / 2;
            var _local_15:int = _local_7 > _local_9?-1:1;
            var _local_16:int = _local_8 > _local_4 - 1?int(_local_4 - 1):int(_local_8);
            var _local_17:int = _local_7;
            var _local_18:int = _local_6;
            if(_local_18 < 0) {
                _local_14 = _local_14 + _local_13 * -_local_18;
                if(_local_14 >= 0) {
                    _local_19 = _local_14 / _local_12 + 1;
                    _local_17 = _local_17 + _local_15 * _local_19;
                    _local_14 = _local_14 - _local_19 * _local_12;
                }
                _local_18 = 0;
            }
            if(_local_15 > 0 && _local_17 < 0 || _local_15 < 0 && _local_17 >= _local_5) {
                _local_20 = _local_15 > 0?int(-_local_17 - 1):int(_local_17 - _local_5);
                _local_14 = _local_14 - _local_12 * _local_20;
                _local_21 = -_local_14 / _local_13;
                _local_18 = _local_18 + _local_21;
                _local_14 = _local_14 + _local_21 * _local_13;
                _local_17 = _local_17 + _local_20 * _local_15;
            }
            while(_local_18 <= _local_16) {
                if(_local_15 > 0 && _local_17 >= _local_5 || _local_15 < 0 && _local_17 < 0) {
                    break;
                }
                if(_local_10) {
                    if(_local_17 >= 0 && _local_17 < _local_5 && param1.getPixel(_local_17,_local_18) == 0) {
                        return false;
                    }
                } else if(_local_17 >= 0 && _local_17 < _local_5 && param1.getPixel(_local_18,_local_17) == 0) {
                    return false;
                }
                _local_14 = _local_14 + _local_13;
                if(_local_14 >= 0) {
                    _local_17 = _local_17 + _local_15;
                    _local_14 = _local_14 - _local_12;
                }
                _local_18++;
            }
            return true;
        }
    }
}

class StaticEnforcer#111 {
     
    
    function StaticEnforcer#111() {
        super();
    }
}
