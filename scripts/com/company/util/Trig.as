package com.company.util {
    public class Trig {
        
        public static const toDegrees:Number = 180 / Math.PI;
        
        public static const toRadians:Number = Math.PI / 180;
         
        
        public function Trig(param1:StaticEnforcer#134) {
            super();
        }
        
        public static function slerp(param1:Number, param2:Number, param3:Number) : Number {
            var _local_4:Number = Number.MAX_VALUE;
            if(param1 > param2) {
                if(param1 - param2 > Math.PI) {
                    _local_4 = param1 * (1 - param3) + (param2 + 2 * Math.PI) * param3;
                } else {
                    _local_4 = param1 * (1 - param3) + param2 * param3;
                }
            } else if(param2 - param1 > Math.PI) {
                _local_4 = (param1 + 2 * Math.PI) * (1 - param3) + param2 * param3;
            } else {
                _local_4 = param1 * (1 - param3) + param2 * param3;
            }
            if(_local_4 < -Math.PI || _local_4 > Math.PI) {
                _local_4 = boundToPI(_local_4);
            }
            return _local_4;
        }
        
        public static function angleDiff(param1:Number, param2:Number) : Number {
            if(param1 > param2) {
                if(param1 - param2 > Math.PI) {
                    return param2 + 2 * Math.PI - param1;
                }
                return param1 - param2;
            }
            if(param2 - param1 > Math.PI) {
                return param1 + 2 * Math.PI - param2;
            }
            return param2 - param1;
        }
        
        public static function sin(param1:Number) : Number {
            var _local_2:Number = NaN;
            if(param1 < -Math.PI || param1 > Math.PI) {
                param1 = boundToPI(param1);
            }
            if(param1 < 0) {
                _local_2 = 1.27323954 * param1 + 0.405284735 * param1 * param1;
                if(_local_2 < 0) {
                    _local_2 = 0.225 * (_local_2 * -_local_2 - _local_2) + _local_2;
                } else {
                    _local_2 = 0.225 * (_local_2 * _local_2 - _local_2) + _local_2;
                }
            } else {
                _local_2 = 1.27323954 * param1 - 0.405284735 * param1 * param1;
                if(_local_2 < 0) {
                    _local_2 = 0.225 * (_local_2 * -_local_2 - _local_2) + _local_2;
                } else {
                    _local_2 = 0.225 * (_local_2 * _local_2 - _local_2) + _local_2;
                }
            }
            return _local_2;
        }
        
        public static function cos(param1:Number) : Number {
            return sin(param1 + Math.PI / 2);
        }
        
        public static function atan2(param1:Number, param2:Number) : Number {
            var _local_3:Number = NaN;
            if(param2 == 0) {
                if(param1 < 0) {
                    return -Math.PI / 2;
                }
                if(param1 > 0) {
                    return Math.PI / 2;
                }
                return undefined;
            }
            if(param1 == 0) {
                if(param2 < 0) {
                    return Math.PI;
                }
                return 0;
            }
            if((param2 > 0?param2:-param2) > (param1 > 0?param1:-param1)) {
                _local_3 = (param2 < 0?-Math.PI:0) + atan2Helper(param1,param2);
            } else {
                _local_3 = (param1 > 0?Math.PI / 2:-Math.PI / 2) - atan2Helper(param2,param1);
            }
            if(_local_3 < -Math.PI || _local_3 > Math.PI) {
                _local_3 = boundToPI(_local_3);
            }
            return _local_3;
        }
        
        public static function atan2Helper(param1:Number, param2:Number) : Number {
            var _local_3:Number = param1 / param2;
            var _local_4:Number = _local_3;
            var _local_5:Number = _local_3;
            var _local_6:Number = 1;
            var _local_7:int = 1;
            do {
                _local_6 = _local_6 + 2;
                _local_7 = _local_7 > 0?-1:1;
                _local_5 = _local_5 * _local_3 * _local_3;
                _local_4 = _local_4 + _local_7 * _local_5 / _local_6;
            }
            while((_local_5 > 0.01 || _local_5 < -0.01) && _local_6 <= 11);
            
            return _local_4;
        }
        
        public static function boundToPI(param1:Number) : Number {
            var _local_2:int = 0;
            if(param1 < -Math.PI) {
                _local_2 = (int(param1 / -Math.PI) + 1) / 2;
                param1 = param1 + _local_2 * 2 * Math.PI;
            } else if(param1 > Math.PI) {
                _local_2 = (int(param1 / Math.PI) + 1) / 2;
                param1 = param1 - _local_2 * 2 * Math.PI;
            }
            return param1;
        }
        
        public static function boundTo180(param1:Number) : Number {
            var _local_2:int = 0;
            if(param1 < -180) {
                _local_2 = (int(param1 / -180) + 1) / 2;
                param1 = param1 + _local_2 * 360;
            } else if(param1 > 180) {
                _local_2 = (int(param1 / 180) + 1) / 2;
                param1 = param1 - _local_2 * 360;
            }
            return param1;
        }
        
        public static function unitTest() : Boolean {
            trace("STARTING UNITTEST: Trig");
            var _local_1:Boolean = testFunc1(Math.sin,sin) && testFunc1(Math.cos,cos) && testFunc2(Math.atan2,atan2);
            if(!_local_1) {
                trace("Trig Unit Test FAILED!");
            }
            trace("FINISHED UNITTEST: Trig");
            return _local_1;
        }
        
        public static function testFunc1(param1:Function, param2:Function) : Boolean {
            var _local_5:Number = NaN;
            var _local_6:Number = NaN;
            var _local_3:Random = new Random();
            var _local_4:int = 0;
            while(_local_4 < 1000) {
                _local_5 = _local_3.nextInt() % 2000 - 1000 + _local_3.nextDouble();
                _local_6 = Math.abs(param1(_local_5) - param2(_local_5));
                if(_local_6 > 0.1) {
                    return false;
                }
                _local_4++;
            }
            return true;
        }
        
        public static function testFunc2(param1:Function, param2:Function) : Boolean {
            var _local_5:Number = NaN;
            var _local_6:Number = NaN;
            var _local_7:Number = NaN;
            var _local_3:Random = new Random();
            var _local_4:int = 0;
            while(_local_4 < 1000) {
                _local_5 = _local_3.nextInt() % 2000 - 1000 + _local_3.nextDouble();
                _local_6 = _local_3.nextInt() % 2000 - 1000 + _local_3.nextDouble();
                _local_7 = Math.abs(param1(_local_5,_local_6) - param2(_local_5,_local_6));
                if(_local_7 > 0.1) {
                    return false;
                }
                _local_4++;
            }
            return true;
        }
    }
}

class StaticEnforcer#134 {
     
    
    function StaticEnforcer#134() {
        super();
    }
}
