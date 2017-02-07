package ion.utils.png {
    import flash.display.BitmapData;
    import flash.utils.ByteArray;
    
    public class PNGDecoder {
        
        private static const IHDR:int = 1229472850;
        
        private static const IDAT:int = 1229209940;
        
        private static const tEXt:int = 1950701684;
        
        private static const iTXt:int = 1767135348;
        
        private static const zTXt:int = 2052348020;
        
        private static const IEND:int = 1229278788;
        
        private static var infoWidth:uint;
        
        private static var infoHeight:uint;
        
        private static var infoBitDepth:int;
        
        private static var infoColourType:int;
        
        private static var infoCompressionMethod:int;
        
        private static var infoFilterMethod:int;
        
        private static var infoInterlaceMethod:int;
        
        private static var fileIn:ByteArray;
        
        private static var buffer:ByteArray;
        
        private static var scanline:int;
        
        private static var samples:int;
         
        
        public function PNGDecoder() {
            super();
        }
        
        public static function decodeImage(param1:ByteArray) : BitmapData {
            var _local_4:Boolean = false;
            var _local_5:int = 0;
            if(param1 == null) {
                return null;
            }
            fileIn = param1;
            buffer = new ByteArray();
            samples = 4;
            fileIn.position = 0;
            if(fileIn.readUnsignedInt() != 2303741511) {
                return invalidPNG();
            }
            if(fileIn.readUnsignedInt() != 218765834) {
                return invalidPNG();
            }
            var _local_2:Array = getChunks();
            var _local_3:int = 0;
            _local_5 = 0;
            while(_local_5 < _local_2.length) {
                fileIn.position = _local_2[_local_5].position;
                _local_4 = true;
                if(_local_2[_local_5].type == IHDR) {
                    _local_3++;
                    if(_local_5 == 0) {
                        _local_4 = processIHDR(_local_2[_local_5].length);
                    } else {
                        _local_4 = false;
                    }
                }
                if(_local_2[_local_5].type == IDAT) {
                    buffer.writeBytes(fileIn,fileIn.position,_local_2[_local_5].length);
                }
                if(!_local_4 || _local_3 > 1) {
                    return invalidPNG();
                }
                _local_5++;
            }
            var _local_6:BitmapData = processIDAT();
            fileIn = null;
            buffer = null;
            return _local_6;
        }
        
        public static function decodeInfo(param1:ByteArray) : XML {
            var _local_4:int = 0;
            if(param1 == null) {
                return null;
            }
            fileIn = param1;
            fileIn.position = 0;
            if(fileIn.readUnsignedInt() != 2303741511) {
                fileIn = null;
                return null;
            }
            if(fileIn.readUnsignedInt() != 218765834) {
                fileIn = null;
                return null;
            }
            var _local_2:Array = getChunks();
            var _local_3:XML = <information/>;
            _local_4 = 0;
            while(_local_4 < _local_2.length) {
                if(_local_2[_local_4].type == tEXt) {
                    _local_3.appendChild(gettEXt(_local_2[_local_4].position,_local_2[_local_4].length));
                }
                if(_local_2[_local_4].type == iTXt) {
                    _local_3.appendChild(getiTXt(_local_2[_local_4].position,_local_2[_local_4].length));
                }
                if(_local_2[_local_4].type == zTXt) {
                    _local_3.appendChild(getzTXt(_local_2[_local_4].position,_local_2[_local_4].length));
                }
                _local_4++;
            }
            fileIn = null;
            return _local_3;
        }
        
        private static function gettEXt(param1:int, param2:int) : XML {
            var _local_3:XML = <tEXt/>;
            var _local_4:String = "";
            var _local_5:String = "";
            var _local_6:int = -1;
            fileIn.position = param1;
            while(fileIn.position < param1 + param2) {
                _local_6 = fileIn.readUnsignedByte();
                if(_local_6 > 0) {
                    _local_4 = _local_4 + String.fromCharCode(_local_6);
                    continue;
                }
                break;
            }
            _local_5 = fileIn.readUTFBytes(param1 + param2 - fileIn.position);
            _local_3.appendChild(<keyword>{_local_4}</keyword>);
            _local_3.appendChild(<text>{_local_5}</text>);
            return _local_3;
        }
        
        private static function getzTXt(param1:int, param2:int) : XML {
            var _local_8:ByteArray = null;
            var _local_3:XML = <zTXt/>;
            var _local_4:String = "";
            var _local_5:String = "";
            var _local_6:int = -1;
            fileIn.position = param1;
            while(fileIn.position < param1 + param2) {
                _local_6 = fileIn.readUnsignedByte();
                if(_local_6 > 0) {
                    _local_4 = _local_4 + String.fromCharCode(_local_6);
                    continue;
                }
                break;
            }
            var _local_7:int = fileIn.readUnsignedByte();
            if(_local_7 == 0) {
                _local_8 = new ByteArray();
                _local_8.writeBytes(fileIn,fileIn.position,param1 + param2 - fileIn.position);
                _local_8.uncompress();
                _local_5 = _local_8.readUTFBytes(_local_8.length);
            }
            _local_3.appendChild(<keyword>{_local_4}</keyword>);
            _local_3.appendChild(<text>{_local_5}</text>);
            return _local_3;
        }
        
        private static function getiTXt(param1:int, param2:int) : XML {
            var _local_11:ByteArray = null;
            var _local_3:XML = <iTXt/>;
            var _local_4:String = "";
            var _local_5:String = "";
            var _local_6:String = "";
            var _local_7:String = "";
            var _local_8:int = -1;
            fileIn.position = param1;
            while(fileIn.position < param1 + param2) {
                _local_8 = fileIn.readUnsignedByte();
                if(_local_8 > 0) {
                    _local_4 = _local_4 + String.fromCharCode(_local_8);
                    continue;
                }
                break;
            }
            var _local_9:* = fileIn.readUnsignedByte() == 1;
            var _local_10:int = fileIn.readUnsignedByte();
            while(fileIn.position < param1 + param2) {
                _local_8 = fileIn.readUnsignedByte();
                if(_local_8 > 0) {
                    _local_5 = _local_5 + String.fromCharCode(_local_8);
                    continue;
                }
                break;
            }
            while(fileIn.position < param1 + param2) {
                _local_8 = fileIn.readUnsignedByte();
                if(_local_8 > 0) {
                    _local_6 = _local_6 + String.fromCharCode(_local_8);
                    continue;
                }
                break;
            }
            if(_local_9) {
                if(_local_10 == 0) {
                    _local_11 = new ByteArray();
                    _local_11.writeBytes(fileIn,fileIn.position,param1 + param2 - fileIn.position);
                    _local_11.uncompress();
                    _local_7 = _local_11.readUTFBytes(_local_11.length);
                }
            } else {
                _local_7 = fileIn.readUTFBytes(param1 + param2 - fileIn.position);
            }
            _local_3.appendChild(<keyword>{_local_4}</keyword>);
            _local_3.appendChild(<text>{_local_7}</text>);
            _local_3.appendChild(<languageTag>{_local_5}</languageTag>);
            _local_3.appendChild(<translatedKeyword>{_local_6}</translatedKeyword>);
            return _local_3;
        }
        
        private static function invalidPNG() : BitmapData {
            fileIn = null;
            buffer = null;
            return null;
        }
        
        private static function getChunks() : Array {
            var _local_2:uint = 0;
            var _local_3:int = 0;
            var _local_1:Array = [];
            do {
                _local_2 = fileIn.readUnsignedInt();
                _local_3 = fileIn.readInt();
                _local_1.push({
                    "type":_local_3,
                    "position":fileIn.position,
                    "length":_local_2
                });
                fileIn.position = fileIn.position + (_local_2 + 4);
            }
            while(_local_3 != IEND && fileIn.bytesAvailable > 0);
            
            return _local_1;
        }
        
        private static function processIHDR(param1:int) : Boolean {
            if(param1 != 13) {
                return false;
            }
            infoWidth = fileIn.readUnsignedInt();
            infoHeight = fileIn.readUnsignedInt();
            infoBitDepth = fileIn.readUnsignedByte();
            infoColourType = fileIn.readUnsignedByte();
            infoCompressionMethod = fileIn.readUnsignedByte();
            infoFilterMethod = fileIn.readUnsignedByte();
            infoInterlaceMethod = fileIn.readUnsignedByte();
            if(infoWidth <= 0 || infoHeight <= 0) {
                return false;
            }
            switch(infoBitDepth) {
                case 1:
                case 2:
                case 4:
                case 8:
                case 16:
                    switch(infoColourType) {
                        case 0:
                            if(infoBitDepth != 1 && infoBitDepth != 2 && infoBitDepth != 4 && infoBitDepth != 8 && infoBitDepth != 16) {
                                return false;
                            }
                            break;
                        case 2:
                        case 4:
                        case 6:
                            if(infoBitDepth != 8 && infoBitDepth != 16) {
                                return false;
                            }
                            break;
                        case 3:
                            if(infoBitDepth != 1 && infoBitDepth != 2 && infoBitDepth != 4 && infoBitDepth != 8) {
                                return false;
                            }
                            break;
                        default:
                            return false;
                    }
                    if(infoCompressionMethod != 0 || infoFilterMethod != 0) {
                        return false;
                    }
                    if(infoInterlaceMethod != 0 && infoInterlaceMethod != 1) {
                        return false;
                    }
                    return true;
                default:
                    return false;
            }
        }
        
        private static function processIDAT() : BitmapData {
            var bufferLen:uint = 0;
            var filter:int = 0;
            var i:int = 0;
            var r:uint = 0;
            var g:uint = 0;
            var b:uint = 0;
            var a:uint = 0;
            var bd:BitmapData = new BitmapData(infoWidth,infoHeight);
            try {
                buffer.uncompress();
            }
            catch(err:*) {
                return null;
            }
            scanline = 0;
            bufferLen = buffer.length;
            while(buffer.position < bufferLen) {
                filter = buffer.readUnsignedByte();
                if(filter == 0) {
                    i = 0;
                    while(i < infoWidth) {
                        r = noSample() << 16;
                        g = noSample() << 8;
                        b = noSample();
                        a = noSample() << 24;
                        bd.setPixel32(i,scanline,a + r + g + b);
                        i++;
                    }
                } else if(filter == 1) {
                    i = 0;
                    while(i < infoWidth) {
                        r = subSample() << 16;
                        g = subSample() << 8;
                        b = subSample();
                        a = subSample() << 24;
                        bd.setPixel32(i,scanline,a + r + g + b);
                        i++;
                    }
                } else if(filter == 2) {
                    i = 0;
                    while(i < infoWidth) {
                        r = upSample() << 16;
                        g = upSample() << 8;
                        b = upSample();
                        a = upSample() << 24;
                        bd.setPixel32(i,scanline,a + r + g + b);
                        i++;
                    }
                } else if(filter == 3) {
                    i = 0;
                    while(i < infoWidth) {
                        r = averageSample() << 16;
                        g = averageSample() << 8;
                        b = averageSample();
                        a = averageSample() << 24;
                        bd.setPixel32(i,scanline,a + r + g + b);
                        i++;
                    }
                } else if(filter == 4) {
                    i = 0;
                    while(i < infoWidth) {
                        r = paethSample() << 16;
                        g = paethSample() << 8;
                        b = paethSample();
                        a = paethSample() << 24;
                        bd.setPixel32(i,scanline,a + r + g + b);
                        i++;
                    }
                } else {
                    buffer.position = buffer.position + samples * infoWidth;
                }
                scanline++;
            }
            return bd;
        }
        
        private static function noSample() : uint {
            return buffer[buffer.position++];
        }
        
        private static function subSample() : uint {
            var _local_1:uint = buffer[buffer.position] + byteA();
            _local_1 = _local_1 & 255;
            var _local_2:* = buffer.position++;
            buffer[_local_2] = _local_1;
            return _local_1;
        }
        
        private static function upSample() : uint {
            var _local_1:uint = buffer[buffer.position] + byteB();
            _local_1 = _local_1 & 255;
            var _local_2:* = buffer.position++;
            buffer[_local_2] = _local_1;
            return _local_1;
        }
        
        private static function averageSample() : uint {
            var _local_1:uint = buffer[buffer.position] + Math.floor((byteA() + byteB()) / 2);
            _local_1 = _local_1 & 255;
            var _local_2:* = buffer.position++;
            buffer[_local_2] = _local_1;
            return _local_1;
        }
        
        private static function paethSample() : uint {
            var _local_1:uint = buffer[buffer.position] + paethPredictor();
            _local_1 = _local_1 & 255;
            var _local_2:* = buffer.position++;
            buffer[_local_2] = _local_1;
            return _local_1;
        }
        
        private static function paethPredictor() : uint {
            var _local_1:uint = byteA();
            var _local_2:uint = byteB();
            var _local_3:uint = byteC();
            var _local_4:int = 0;
            var _local_5:int = 0;
            var _local_6:int = 0;
            var _local_7:int = 0;
            var _local_8:int = 0;
            _local_4 = _local_1 + _local_2 - _local_3;
            _local_5 = Math.abs(_local_4 - _local_1);
            _local_6 = Math.abs(_local_4 - _local_2);
            _local_7 = Math.abs(_local_4 - _local_3);
            if(_local_5 <= _local_6 && _local_5 <= _local_7) {
                _local_8 = _local_1;
            } else if(_local_6 <= _local_7) {
                _local_8 = _local_2;
            } else {
                _local_8 = _local_3;
            }
            return _local_8;
        }
        
        private static function byteA() : uint {
            var _local_1:int = scanline * (infoWidth * samples + 1);
            var _local_2:int = buffer.position - samples;
            if(_local_2 <= _local_1) {
                return 0;
            }
            return buffer[_local_2];
        }
        
        private static function byteB() : uint {
            var _local_1:int = buffer.position - (infoWidth * samples + 1);
            if(_local_1 < 0) {
                return 0;
            }
            return buffer[_local_1];
        }
        
        private static function byteC() : uint {
            var _local_1:int = buffer.position - (infoWidth * samples + 1);
            if(_local_1 < 0) {
                return 0;
            }
            var _local_2:int = (scanline - 1) * (infoWidth * samples + 1);
            _local_1 = _local_1 - samples;
            if(_local_1 <= _local_2) {
                return 0;
            }
            return buffer[_local_1];
        }
    }
}
