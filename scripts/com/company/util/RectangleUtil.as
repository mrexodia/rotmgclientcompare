package com.company.util {
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    public class RectangleUtil {
         
        
        public function RectangleUtil() {
            super();
        }
        
        public static function pointDist(param1:Rectangle, param2:Number, param3:Number) : Number {
            var _local_4:Number = param2;
            var _local_5:Number = param3;
            if(_local_4 < param1.x) {
                _local_4 = param1.x;
            } else if(_local_4 > param1.right) {
                _local_4 = param1.right;
            }
            if(_local_5 < param1.y) {
                _local_5 = param1.y;
            } else if(_local_5 > param1.bottom) {
                _local_5 = param1.bottom;
            }
            if(_local_4 == param2 && _local_5 == param3) {
                return 0;
            }
            return PointUtil.distanceXY(_local_4,_local_5,param2,param3);
        }
        
        public static function closestPoint(param1:Rectangle, param2:Number, param3:Number) : Point {
            var _local_4:Number = param2;
            var _local_5:Number = param3;
            if(_local_4 < param1.x) {
                _local_4 = param1.x;
            } else if(_local_4 > param1.right) {
                _local_4 = param1.right;
            }
            if(_local_5 < param1.y) {
                _local_5 = param1.y;
            } else if(_local_5 > param1.bottom) {
                _local_5 = param1.bottom;
            }
            return new Point(_local_4,_local_5);
        }
        
        public static function lineSegmentIntersectsXY(param1:Rectangle, param2:Number, param3:Number, param4:Number, param5:Number) : Boolean {
            var _local_8:Number = NaN;
            var _local_9:Number = NaN;
            var _local_10:Number = NaN;
            var _local_11:Number = NaN;
            if(param1.left > param2 && param1.left > param4 || param1.right < param2 && param1.right < param4 || param1.top > param3 && param1.top > param5 || param1.bottom < param3 && param1.bottom < param5) {
                return false;
            }
            if(param1.left < param2 && param2 < param1.right && param1.top < param3 && param3 < param1.bottom || param1.left < param4 && param4 < param1.right && param1.top < param5 && param5 < param1.bottom) {
                return true;
            }
            var _local_6:Number = (param5 - param3) / (param4 - param2);
            var _local_7:Number = param3 - _local_6 * param2;
            if(_local_6 > 0) {
                _local_8 = _local_6 * param1.left + _local_7;
                _local_9 = _local_6 * param1.right + _local_7;
            } else {
                _local_8 = _local_6 * param1.right + _local_7;
                _local_9 = _local_6 * param1.left + _local_7;
            }
            if(param3 < param5) {
                _local_11 = param3;
                _local_10 = param5;
            } else {
                _local_11 = param5;
                _local_10 = param3;
            }
            var _local_12:Number = _local_8 > _local_11?Number(_local_8):Number(_local_11);
            var _local_13:Number = _local_9 < _local_10?Number(_local_9):Number(_local_10);
            return _local_12 < _local_13 && !(_local_13 < param1.top || _local_12 > param1.bottom);
        }
        
        public static function lineSegmentIntersectXY(param1:Rectangle, param2:Number, param3:Number, param4:Number, param5:Number, param6:Point) : Boolean {
            var _local_7:Number = NaN;
            var _local_8:Number = NaN;
            var _local_9:Number = NaN;
            var _local_10:Number = NaN;
            if(param4 <= param1.x) {
                _local_7 = (param5 - param3) / (param4 - param2);
                _local_8 = param3 - param2 * _local_7;
                _local_9 = _local_7 * param1.x + _local_8;
                if(_local_9 >= param1.y && _local_9 <= param1.y + param1.height) {
                    param6.x = param1.x;
                    param6.y = _local_9;
                    return true;
                }
            } else if(param4 >= param1.x + param1.width) {
                _local_7 = (param5 - param3) / (param4 - param2);
                _local_8 = param3 - param2 * _local_7;
                _local_9 = _local_7 * (param1.x + param1.width) + _local_8;
                if(_local_9 >= param1.y && _local_9 <= param1.y + param1.height) {
                    param6.x = param1.x + param1.width;
                    param6.y = _local_9;
                    return true;
                }
            }
            if(param5 <= param1.y) {
                _local_7 = (param4 - param2) / (param5 - param3);
                _local_8 = param2 - param3 * _local_7;
                _local_10 = _local_7 * param1.y + _local_8;
                if(_local_10 >= param1.x && _local_10 <= param1.x + param1.width) {
                    param6.x = _local_10;
                    param6.y = param1.y;
                    return true;
                }
            } else if(param5 >= param1.y + param1.height) {
                _local_7 = (param4 - param2) / (param5 - param3);
                _local_8 = param2 - param3 * _local_7;
                _local_10 = _local_7 * (param1.y + param1.height) + _local_8;
                if(_local_10 >= param1.x && _local_10 <= param1.x + param1.width) {
                    param6.x = _local_10;
                    param6.y = param1.y + param1.height;
                    return true;
                }
            }
            return false;
        }
        
        public static function lineSegmentIntersect(param1:Rectangle, param2:IntPoint, param3:IntPoint) : Point {
            var _local_4:Number = NaN;
            var _local_5:Number = NaN;
            var _local_6:Number = NaN;
            var _local_7:Number = NaN;
            if(param3.x() <= param1.x) {
                _local_4 = (param3.y() - param2.y()) / (param3.x() - param2.x());
                _local_5 = param2.y() - param2.x() * _local_4;
                _local_6 = _local_4 * param1.x + _local_5;
                if(_local_6 >= param1.y && _local_6 <= param1.y + param1.height) {
                    return new Point(param1.x,_local_6);
                }
            } else if(param3.x() >= param1.x + param1.width) {
                _local_4 = (param3.y() - param2.y()) / (param3.x() - param2.x());
                _local_5 = param2.y() - param2.x() * _local_4;
                _local_6 = _local_4 * (param1.x + param1.width) + _local_5;
                if(_local_6 >= param1.y && _local_6 <= param1.y + param1.height) {
                    return new Point(param1.x + param1.width,_local_6);
                }
            }
            if(param3.y() <= param1.y) {
                _local_4 = (param3.x() - param2.x()) / (param3.y() - param2.y());
                _local_5 = param2.x() - param2.y() * _local_4;
                _local_7 = _local_4 * param1.y + _local_5;
                if(_local_7 >= param1.x && _local_7 <= param1.x + param1.width) {
                    return new Point(_local_7,param1.y);
                }
            } else if(param3.y() >= param1.y + param1.height) {
                _local_4 = (param3.x() - param2.x()) / (param3.y() - param2.y());
                _local_5 = param2.x() - param2.y() * _local_4;
                _local_7 = _local_4 * (param1.y + param1.height) + _local_5;
                if(_local_7 >= param1.x && _local_7 <= param1.x + param1.width) {
                    return new Point(_local_7,param1.y + param1.height);
                }
            }
            return null;
        }
        
        public static function getRotatedRectExtents2D(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : Extents2D {
            var _local_9:Point = null;
            var _local_11:int = 0;
            var _local_6:Matrix = new Matrix();
            _local_6.translate(-param4 / 2,-param5 / 2);
            _local_6.rotate(param3);
            _local_6.translate(param1,param2);
            var _local_7:Extents2D = new Extents2D();
            var _local_8:Point = new Point();
            var _local_10:int = 0;
            while(_local_10 <= 1) {
                _local_11 = 0;
                while(_local_11 <= 1) {
                    _local_8.x = _local_10 * param4;
                    _local_8.y = _local_11 * param5;
                    _local_9 = _local_6.transformPoint(_local_8);
                    _local_7.add(_local_9.x,_local_9.y);
                    _local_11++;
                }
                _local_10++;
            }
            return _local_7;
        }
    }
}
