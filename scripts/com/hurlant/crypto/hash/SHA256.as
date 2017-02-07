package com.hurlant.crypto.hash {
    public class SHA256 extends SHABase implements IHash {
        
        protected static const k:Array = [1116352408,1899447441,3049323471,3921009573,961987163,1508970993,2453635748,2870763221,3624381080,310598401,607225278,1426881987,1925078388,2162078206,2614888103,3248222580,3835390401,4022224774,264347078,604807628,770255983,1249150122,1555081692,1996064986,2554220882,2821834349,2952996808,3210313671,3336571891,3584528711,113926993,338241895,666307205,773529912,1294757372,1396182291,1695183700,1986661051,2177026350,2456956037,2730485921,2820302411,3259730800,3345764771,3516065817,3600352804,4094571909,275423344,430227734,506948616,659060556,883997877,958139571,1322822218,1537002063,1747873779,1955562222,2024104815,2227730452,2361852424,2428436474,2756734187,3204031479,3329325298];
         
        
        protected var h:Array;
        
        public function SHA256() {
            this.h = [1779033703,3144134277,1013904242,2773480762,1359893119,2600822924,528734635,1541459225];
            super();
        }
        
        override public function getHashSize() : uint {
            return 32;
        }
        
        override protected function core(param1:Array, param2:uint) : Array {
            var _local_13:uint = 0;
            var _local_14:uint = 0;
            var _local_15:uint = 0;
            var _local_16:uint = 0;
            var _local_17:uint = 0;
            var _local_18:uint = 0;
            var _local_19:uint = 0;
            var _local_20:uint = 0;
            var _local_21:uint = 0;
            var _local_22:uint = 0;
            var _local_23:uint = 0;
            var _local_24:uint = 0;
            var _local_25:uint = 0;
            param1[param2 >> 5] = param1[param2 >> 5] | 128 << 24 - param2 % 32;
            param1[(param2 + 64 >> 9 << 4) + 15] = param2;
            var _local_3:Array = [];
            var _local_4:uint = this.h[0];
            var _local_5:uint = this.h[1];
            var _local_6:uint = this.h[2];
            var _local_7:uint = this.h[3];
            var _local_8:uint = this.h[4];
            var _local_9:uint = this.h[5];
            var _local_10:uint = this.h[6];
            var _local_11:uint = this.h[7];
            var _local_12:uint = 0;
            while(_local_12 < param1.length) {
                _local_13 = _local_4;
                _local_14 = _local_5;
                _local_15 = _local_6;
                _local_16 = _local_7;
                _local_17 = _local_8;
                _local_18 = _local_9;
                _local_19 = _local_10;
                _local_20 = _local_11;
                _local_21 = 0;
                while(_local_21 < 64) {
                    if(_local_21 < 16) {
                        _local_3[_local_21] = param1[_local_12 + _local_21] || 0;
                    } else {
                        _local_24 = this.rrol(_local_3[_local_21 - 15],7) ^ this.rrol(_local_3[_local_21 - 15],18) ^ _local_3[_local_21 - 15] >>> 3;
                        _local_25 = this.rrol(_local_3[_local_21 - 2],17) ^ this.rrol(_local_3[_local_21 - 2],19) ^ _local_3[_local_21 - 2] >>> 10;
                        _local_3[_local_21] = _local_3[_local_21 - 16] + _local_24 + _local_3[_local_21 - 7] + _local_25;
                    }
                    _local_22 = (this.rrol(_local_4,2) ^ this.rrol(_local_4,13) ^ this.rrol(_local_4,22)) + (_local_4 & _local_5 ^ _local_4 & _local_6 ^ _local_5 & _local_6);
                    _local_23 = _local_11 + (this.rrol(_local_8,6) ^ this.rrol(_local_8,11) ^ this.rrol(_local_8,25)) + (_local_8 & _local_9 ^ _local_10 & ~_local_8) + k[_local_21] + _local_3[_local_21];
                    _local_11 = _local_10;
                    _local_10 = _local_9;
                    _local_9 = _local_8;
                    _local_8 = _local_7 + _local_23;
                    _local_7 = _local_6;
                    _local_6 = _local_5;
                    _local_5 = _local_4;
                    _local_4 = _local_23 + _local_22;
                    _local_21++;
                }
                _local_4 = _local_4 + _local_13;
                _local_5 = _local_5 + _local_14;
                _local_6 = _local_6 + _local_15;
                _local_7 = _local_7 + _local_16;
                _local_8 = _local_8 + _local_17;
                _local_9 = _local_9 + _local_18;
                _local_10 = _local_10 + _local_19;
                _local_11 = _local_11 + _local_20;
                _local_12 = _local_12 + 16;
            }
            return [_local_4,_local_5,_local_6,_local_7,_local_8,_local_9,_local_10,_local_11];
        }
        
        protected function rrol(param1:uint, param2:uint) : uint {
            return param1 << 32 - param2 | param1 >>> param2;
        }
        
        override public function toString() : String {
            return "sha256";
        }
    }
}
