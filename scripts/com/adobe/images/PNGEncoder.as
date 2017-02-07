package com.adobe.images {
    import flash.display.BitmapData;
    import flash.utils.ByteArray;
    
    public class PNGEncoder {
        
        private static var crcTable:Array;
        
        private static var crcTableComputed:Boolean = false;
         
        
        public function PNGEncoder() {
            super();
        }
        
        public static function encode(param1:BitmapData) : ByteArray {
            var _local_6:uint = 0;
            var _local_7:int = 0;
            var _local_2:ByteArray = new ByteArray();
            _local_2.writeUnsignedInt(2303741511);
            _local_2.writeUnsignedInt(218765834);
            var _local_3:ByteArray = new ByteArray();
            _local_3.writeInt(param1.width);
            _local_3.writeInt(param1.height);
            _local_3.writeUnsignedInt(134610944);
            _local_3.writeByte(0);
            writeChunk(_local_2,1229472850,_local_3);
            var _local_4:ByteArray = new ByteArray();
            var _local_5:int = 0;
            while(_local_5 < param1.height) {
                _local_4.writeByte(0);
                if(!param1.transparent) {
                    _local_7 = 0;
                    while(_local_7 < param1.width) {
                        _local_6 = param1.getPixel(_local_7,_local_5);
                        _local_4.writeUnsignedInt(uint((_local_6 & 16777215) << 8 | 255));
                        _local_7++;
                    }
                } else {
                    _local_7 = 0;
                    while(_local_7 < param1.width) {
                        _local_6 = param1.getPixel32(_local_7,_local_5);
                        _local_4.writeUnsignedInt(uint((_local_6 & 16777215) << 8 | _local_6 >>> 24));
                        _local_7++;
                    }
                }
                _local_5++;
            }
            _local_4.compress();
            writeChunk(_local_2,1229209940,_local_4);
            writeChunk(_local_2,1229278788,null);
            return _local_2;
        }
        
        private static function writeChunk(param1:ByteArray, param2:uint, param3:ByteArray) : void {
            var _local_8:uint = 0;
            var _local_9:uint = 0;
            var _local_10:uint = 0;
            if(!crcTableComputed) {
                crcTableComputed = true;
                crcTable = [];
                _local_9 = 0;
                while(_local_9 < 256) {
                    _local_8 = _local_9;
                    _local_10 = 0;
                    while(_local_10 < 8) {
                        if(_local_8 & 1) {
                            _local_8 = uint(uint(3988292384) ^ uint(_local_8 >>> 1));
                        } else {
                            _local_8 = uint(_local_8 >>> 1);
                        }
                        _local_10++;
                    }
                    crcTable[_local_9] = _local_8;
                    _local_9++;
                }
            }
            var _local_4:uint = 0;
            if(param3 != null) {
                _local_4 = param3.length;
            }
            param1.writeUnsignedInt(_local_4);
            var _local_5:uint = param1.position;
            param1.writeUnsignedInt(param2);
            if(param3 != null) {
                param1.writeBytes(param3);
            }
            var _local_6:uint = param1.position;
            param1.position = _local_5;
            _local_8 = 4294967295;
            var _local_7:int = 0;
            while(_local_7 < _local_6 - _local_5) {
                _local_8 = uint(crcTable[(_local_8 ^ param1.readUnsignedByte()) & uint(255)] ^ uint(_local_8 >>> 8));
                _local_7++;
            }
            _local_8 = uint(_local_8 ^ uint(4294967295));
            param1.position = _local_6;
            param1.writeUnsignedInt(_local_8);
        }
    }
}
