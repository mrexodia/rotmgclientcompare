package com.hurlant.util.der {
    import flash.utils.ByteArray;
    
    public class DER {
        
        public static var indent:String = "";
         
        
        public function DER() {
            super();
        }
        
        public static function parse(param1:ByteArray, param2:* = null) : IAsn1Type {
            var _local_3:* = 0;
            var _local_5:* = 0;
            var _local_6:ByteArray = null;
            var _local_7:* = 0;
            var _local_8:int = 0;
            var _local_9:Sequence = null;
            var _local_10:Array = null;
            var _local_11:Set = null;
            var _local_12:ByteString = null;
            var _local_13:PrintableString = null;
            var _local_14:UTCTime = null;
            var _local_15:Object = null;
            var _local_16:* = false;
            var _local_17:Boolean = false;
            var _local_18:String = null;
            var _local_19:* = undefined;
            var _local_20:IAsn1Type = null;
            var _local_21:int = 0;
            var _local_22:ByteArray = null;
            _local_3 = int(param1.readUnsignedByte());
            var _local_4:* = (_local_3 & 32) != 0;
            _local_3 = _local_3 & 31;
            _local_5 = int(param1.readUnsignedByte());
            if(_local_5 >= 128) {
                _local_7 = _local_5 & 127;
                _local_5 = 0;
                while(_local_7 > 0) {
                    _local_5 = _local_5 << 8 | param1.readUnsignedByte();
                    _local_7--;
                }
            }
            switch(_local_3) {
                case 0:
                case 16:
                    _local_8 = param1.position;
                    _local_9 = new Sequence(_local_3,_local_5);
                    _local_10 = param2 as Array;
                    if(_local_10 != null) {
                        _local_10 = _local_10.concat();
                    }
                    while(param1.position < _local_8 + _local_5) {
                        _local_15 = null;
                        if(_local_10 != null) {
                            _local_15 = _local_10.shift();
                        }
                        if(_local_15 != null) {
                            while(_local_15 && _local_15.optional) {
                                _local_16 = _local_15.value is Array;
                                _local_17 = isConstructedType(param1);
                                if(_local_16 != _local_17) {
                                    _local_9.push(_local_15.defaultValue);
                                    _local_9[_local_15.name] = _local_15.defaultValue;
                                    _local_15 = _local_10.shift();
                                    continue;
                                }
                                break;
                            }
                        }
                        if(_local_15 != null) {
                            _local_18 = _local_15.name;
                            _local_19 = _local_15.value;
                            if(_local_15.extract) {
                                _local_21 = getLengthOfNextElement(param1);
                                _local_22 = new ByteArray();
                                _local_22.writeBytes(param1,param1.position,_local_21);
                                _local_9[_local_18 + "_bin"] = _local_22;
                            }
                            _local_20 = DER.parse(param1,_local_19);
                            _local_9.push(_local_20);
                            _local_9[_local_18] = _local_20;
                        } else {
                            _local_9.push(DER.parse(param1));
                        }
                    }
                    return _local_9;
                case 17:
                    _local_8 = param1.position;
                    _local_11 = new Set(_local_3,_local_5);
                    while(param1.position < _local_8 + _local_5) {
                        _local_11.push(DER.parse(param1));
                    }
                    return _local_11;
                case 2:
                    _local_6 = new ByteArray();
                    param1.readBytes(_local_6,0,_local_5);
                    _local_6.position = 0;
                    return new Integer(_local_3,_local_5,_local_6);
                case 6:
                    _local_6 = new ByteArray();
                    param1.readBytes(_local_6,0,_local_5);
                    _local_6.position = 0;
                    return new ObjectIdentifier(_local_3,_local_5,_local_6);
                default:
                    trace("I DONT KNOW HOW TO HANDLE DER stuff of TYPE " + _local_3);
                case 3:
                    if(param1[param1.position] == 0) {
                        param1.position++;
                        _local_5--;
                    }
                case 4:
                    _local_12 = new ByteString(_local_3,_local_5);
                    param1.readBytes(_local_12,0,_local_5);
                    return _local_12;
                case 5:
                    return null;
                case 19:
                    _local_13 = new PrintableString(_local_3,_local_5);
                    _local_13.setString(param1.readMultiByte(_local_5,"US-ASCII"));
                    return _local_13;
                case 34:
                case 20:
                    _local_13 = new PrintableString(_local_3,_local_5);
                    _local_13.setString(param1.readMultiByte(_local_5,"latin1"));
                    return _local_13;
                case 23:
                    _local_14 = new UTCTime(_local_3,_local_5);
                    _local_14.setUTCTime(param1.readMultiByte(_local_5,"US-ASCII"));
                    return _local_14;
            }
        }
        
        private static function getLengthOfNextElement(param1:ByteArray) : int {
            var _local_4:* = 0;
            var _local_2:uint = param1.position;
            param1.position++;
            var _local_3:* = int(param1.readUnsignedByte());
            if(_local_3 >= 128) {
                _local_4 = _local_3 & 127;
                _local_3 = 0;
                while(_local_4 > 0) {
                    _local_3 = _local_3 << 8 | param1.readUnsignedByte();
                    _local_4--;
                }
            }
            _local_3 = int(_local_3 + (param1.position - _local_2));
            param1.position = _local_2;
            return _local_3;
        }
        
        private static function isConstructedType(param1:ByteArray) : Boolean {
            var _local_2:int = param1[param1.position];
            return (_local_2 & 32) != 0;
        }
        
        public static function wrapDER(param1:int, param2:ByteArray) : ByteArray {
            var _local_3:ByteArray = new ByteArray();
            _local_3.writeByte(param1);
            var _local_4:int = param2.length;
            if(_local_4 < 128) {
                _local_3.writeByte(_local_4);
            } else if(_local_4 < 256) {
                _local_3.writeByte(1 | 128);
                _local_3.writeByte(_local_4);
            } else if(_local_4 < 65536) {
                _local_3.writeByte(2 | 128);
                _local_3.writeByte(_local_4 >> 8);
                _local_3.writeByte(_local_4);
            } else if(_local_4 < 65536 * 256) {
                _local_3.writeByte(3 | 128);
                _local_3.writeByte(_local_4 >> 16);
                _local_3.writeByte(_local_4 >> 8);
                _local_3.writeByte(_local_4);
            } else {
                _local_3.writeByte(4 | 128);
                _local_3.writeByte(_local_4 >> 24);
                _local_3.writeByte(_local_4 >> 16);
                _local_3.writeByte(_local_4 >> 8);
                _local_3.writeByte(_local_4);
            }
            _local_3.writeBytes(param2);
            _local_3.position = 0;
            return _local_3;
        }
    }
}
