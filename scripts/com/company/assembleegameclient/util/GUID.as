package com.company.assembleegameclient.util {
    import flash.system.Capabilities;
    
    public class GUID {
        
        private static var counter:Number = 0;
         
        
        public function GUID() {
            super();
        }
        
        public static function create() : String {
            var _local_1:Date = new Date();
            var _local_2:Number = _local_1.getTime();
            var _local_3:Number = Math.random() * Number.MAX_VALUE;
            var _local_4:String = Capabilities.serverString;
            return calculate(_local_2 + _local_4 + _local_3 + counter++).toUpperCase();
        }
        
        private static function calculate(param1:String) : String {
            return hex_sha1(param1);
        }
        
        private static function hex_sha1(param1:String) : String {
            return binb2hex(core_sha1(str2binb(param1),param1.length * 8));
        }
        
        private static function core_sha1(param1:Array, param2:Number) : Array {
            var _local_10:Number = NaN;
            var _local_11:Number = NaN;
            var _local_12:Number = NaN;
            var _local_13:Number = NaN;
            var _local_14:Number = NaN;
            var _local_15:Number = NaN;
            var _local_16:Number = NaN;
            param1[param2 >> 5] = param1[param2 >> 5] | 128 << 24 - param2 % 32;
            param1[(param2 + 64 >> 9 << 4) + 15] = param2;
            var _local_3:Array = new Array(80);
            var _local_4:Number = 1732584193;
            var _local_5:Number = -271733879;
            var _local_6:Number = -1732584194;
            var _local_7:Number = 271733878;
            var _local_8:Number = -1009589776;
            var _local_9:Number = 0;
            while(_local_9 < param1.length) {
                _local_10 = _local_4;
                _local_11 = _local_5;
                _local_12 = _local_6;
                _local_13 = _local_7;
                _local_14 = _local_8;
                _local_15 = 0;
                while(_local_15 < 80) {
                    if(_local_15 < 16) {
                        _local_3[_local_15] = param1[_local_9 + _local_15];
                    } else {
                        _local_3[_local_15] = rol(_local_3[_local_15 - 3] ^ _local_3[_local_15 - 8] ^ _local_3[_local_15 - 14] ^ _local_3[_local_15 - 16],1);
                    }
                    _local_16 = safe_add(safe_add(rol(_local_4,5),sha1_ft(_local_15,_local_5,_local_6,_local_7)),safe_add(safe_add(_local_8,_local_3[_local_15]),sha1_kt(_local_15)));
                    _local_8 = _local_7;
                    _local_7 = _local_6;
                    _local_6 = rol(_local_5,30);
                    _local_5 = _local_4;
                    _local_4 = _local_16;
                    _local_15++;
                }
                _local_4 = safe_add(_local_4,_local_10);
                _local_5 = safe_add(_local_5,_local_11);
                _local_6 = safe_add(_local_6,_local_12);
                _local_7 = safe_add(_local_7,_local_13);
                _local_8 = safe_add(_local_8,_local_14);
                _local_9 = _local_9 + 16;
            }
            return new Array(_local_4,_local_5,_local_6,_local_7,_local_8);
        }
        
        private static function sha1_ft(param1:Number, param2:Number, param3:Number, param4:Number) : Number {
            if(param1 < 20) {
                return param2 & param3 | ~param2 & param4;
            }
            if(param1 < 40) {
                return param2 ^ param3 ^ param4;
            }
            if(param1 < 60) {
                return param2 & param3 | param2 & param4 | param3 & param4;
            }
            return param2 ^ param3 ^ param4;
        }
        
        private static function sha1_kt(param1:Number) : Number {
            return param1 < 20?Number(1518500249):param1 < 40?Number(1859775393):param1 < 60?Number(-1894007588):Number(-899497514);
        }
        
        private static function safe_add(param1:Number, param2:Number) : Number {
            var _local_3:Number = (param1 & 65535) + (param2 & 65535);
            var _local_4:Number = (param1 >> 16) + (param2 >> 16) + (_local_3 >> 16);
            return _local_4 << 16 | _local_3 & 65535;
        }
        
        private static function rol(param1:Number, param2:Number) : Number {
            return param1 << param2 | param1 >>> 32 - param2;
        }
        
        private static function str2binb(param1:String) : Array {
            var _local_2:Array = new Array();
            var _local_3:Number = 1 << 8 - 1;
            var _local_4:Number = 0;
            while(_local_4 < param1.length * 8) {
                _local_2[_local_4 >> 5] = _local_2[_local_4 >> 5] | (param1.charCodeAt(_local_4 / 8) & _local_3) << 24 - _local_4 % 32;
                _local_4 = _local_4 + 8;
            }
            return _local_2;
        }
        
        private static function binb2hex(param1:Array) : String {
            var _local_2:String = new String("");
            var _local_3:String = new String("0123456789abcdef");
            var _local_4:Number = 0;
            while(_local_4 < param1.length * 4) {
                _local_2 = _local_2 + (_local_3.charAt(param1[_local_4 >> 2] >> (3 - _local_4 % 4) * 8 + 4 & 15) + _local_3.charAt(param1[_local_4 >> 2] >> (3 - _local_4 % 4) * 8 & 15));
                _local_4++;
            }
            return _local_2;
        }
    }
}
