package com.hurlant.math {
    import com.hurlant.crypto.prng.Random;
    import com.hurlant.util.Hex;
    import com.hurlant.util.Memory;
    import flash.utils.ByteArray;
    
    use namespace bi_internal;
    
    public class BigInteger {
        
        public static const DB:int = 30;
        
        public static const DV:int = 1 << DB;
        
        public static const DM:int = DV - 1;
        
        public static const BI_FP:int = 52;
        
        public static const FV:Number = Math.pow(2,BI_FP);
        
        public static const F1:int = BI_FP - DB;
        
        public static const F2:int = 2 * DB - BI_FP;
        
        public static const ZERO:BigInteger = nbv(0);
        
        public static const ONE:BigInteger = nbv(1);
        
        public static const lowprimes:Array = [2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97,101,103,107,109,113,127,131,137,139,149,151,157,163,167,173,179,181,191,193,197,199,211,223,227,229,233,239,241,251,257,263,269,271,277,281,283,293,307,311,313,317,331,337,347,349,353,359,367,373,379,383,389,397,401,409,419,421,431,433,439,443,449,457,461,463,467,479,487,491,499,503,509];
        
        public static const lplim:int = (1 << 26) / lowprimes[lowprimes.length - 1];
         
        
        public var t:int;
        
        bi_internal var s:int;
        
        bi_internal var a:Array;
        
        public function BigInteger(param1:* = null, param2:int = 0, param3:Boolean = false) {
            var _local_4:ByteArray = null;
            var _local_5:int = 0;
            super();
            this.a = new Array();
            if(param1 is String) {
                if(param2 && param2 != 16) {
                    throw new Error("BigInteger construction with radix!=16 is not supported.");
                }
                param1 = Hex.toArray(param1);
                param2 = 0;
            }
            if(param1 is ByteArray) {
                _local_4 = param1 as ByteArray;
                _local_5 = int(param2) || int(_local_4.length - _local_4.position);
                this.fromArray(_local_4,_local_5,param3);
            }
        }
        
        public static function nbv(param1:int) : BigInteger {
            var _local_2:BigInteger = new BigInteger();
            _local_2.fromInt(param1);
            return _local_2;
        }
        
        public function dispose() : void {
            var _local_1:Random = new Random();
            var _local_2:uint = 0;
            while(_local_2 < this.a.length) {
                this.a[_local_2] = _local_1.nextByte();
                delete this.a[_local_2];
                _local_2++;
            }
            this.a = null;
            this.t = 0;
            this.s = 0;
            Memory.gc();
        }
        
        public function toString(param1:Number = 16) : String {
            var _local_2:int = 0;
            if(this.s < 0) {
                return "-" + this.negate().toString(param1);
            }
            switch(param1) {
                case 2:
                    _local_2 = 1;
                    break;
                case 4:
                    _local_2 = 2;
                    break;
                case 8:
                    _local_2 = 3;
                    break;
                case 16:
                    _local_2 = 4;
                    break;
                case 32:
                    _local_2 = 5;
            }
            var _local_3:int = 1 << _local_2 - 1;
            var _local_4:* = 0;
            var _local_5:Boolean = false;
            var _local_6:String = "";
            var _local_7:int = this.t;
            var _local_8:int = DB - _local_7 * DB % _local_2;
            if(_local_7-- > 0) {
                if(_local_8 < DB && (_local_4 = int(this.a[_local_7] >> _local_8)) > 0) {
                    _local_5 = true;
                    _local_6 = _local_4.toString(36);
                }
                while(_local_7 >= 0) {
                    if(_local_8 < _local_2) {
                        _local_4 = (this.a[_local_7] & 1 << _local_8 - 1) << _local_2 - _local_8;
                        _local_4 = _local_4 | this.a[--_local_7] >> (_local_8 = _local_8 + (DB - _local_2));
                    } else {
                        _local_4 = this.a[_local_7] >> (_local_8 = _local_8 - _local_2) & _local_3;
                        if(_local_8 <= 0) {
                            _local_8 = _local_8 + DB;
                            _local_7--;
                        }
                    }
                    if(_local_4 > 0) {
                        _local_5 = true;
                    }
                    if(_local_5) {
                        _local_6 = _local_6 + _local_4.toString(36);
                    }
                }
            }
            return !!_local_5?_local_6:"0";
        }
        
        public function toArray(param1:ByteArray) : uint {
            var _local_2:int = 8;
            var _local_3:int = 1 << 8 - 1;
            var _local_4:* = 0;
            var _local_5:int = this.t;
            var _local_6:int = DB - _local_5 * DB % _local_2;
            var _local_7:Boolean = false;
            var _local_8:int = 0;
            if(_local_5-- > 0) {
                if(_local_6 < DB && (_local_4 = int(this.a[_local_5] >> _local_6)) > 0) {
                    _local_7 = true;
                    param1.writeByte(_local_4);
                    _local_8++;
                }
                while(_local_5 >= 0) {
                    if(_local_6 < _local_2) {
                        _local_4 = (this.a[_local_5] & 1 << _local_6 - 1) << _local_2 - _local_6;
                        _local_4 = _local_4 | this.a[--_local_5] >> (_local_6 = _local_6 + (DB - _local_2));
                    } else {
                        _local_4 = this.a[_local_5] >> (_local_6 = _local_6 - _local_2) & _local_3;
                        if(_local_6 <= 0) {
                            _local_6 = _local_6 + DB;
                            _local_5--;
                        }
                    }
                    if(_local_4 > 0) {
                        _local_7 = true;
                    }
                    if(_local_7) {
                        param1.writeByte(_local_4);
                        _local_8++;
                    }
                }
            }
            return _local_8;
        }
        
        public function valueOf() : Number {
            if(this.s == -1) {
                return -this.negate().valueOf();
            }
            var _local_1:Number = 1;
            var _local_2:Number = 0;
            var _local_3:uint = 0;
            while(_local_3 < this.t) {
                _local_2 = _local_2 + this.a[_local_3] * _local_1;
                _local_1 = _local_1 * DV;
                _local_3++;
            }
            return _local_2;
        }
        
        public function negate() : BigInteger {
            var _local_1:BigInteger = this.nbi();
            ZERO.subTo(this,_local_1);
            return _local_1;
        }
        
        public function abs() : BigInteger {
            return this.s < 0?this.negate():this;
        }
        
        public function compareTo(param1:BigInteger) : int {
            var _local_2:int = this.s - param1.s;
            if(_local_2 != 0) {
                return _local_2;
            }
            var _local_3:int = this.t;
            _local_2 = _local_3 - param1.t;
            if(_local_2 != 0) {
                return _local_2;
            }
            while(--_local_3 >= 0) {
                _local_2 = this.a[_local_3] - param1.a[_local_3];
                if(_local_2 != 0) {
                    return _local_2;
                }
            }
            return 0;
        }
        
        bi_internal function nbits(param1:int) : int {
            var _local_3:int = 0;
            var _local_2:int = 1;
            if((_local_3 = param1 >>> 16) != 0) {
                param1 = _local_3;
                _local_2 = _local_2 + 16;
            }
            if((_local_3 = param1 >> 8) != 0) {
                param1 = _local_3;
                _local_2 = _local_2 + 8;
            }
            if((_local_3 = param1 >> 4) != 0) {
                param1 = _local_3;
                _local_2 = _local_2 + 4;
            }
            if((_local_3 = param1 >> 2) != 0) {
                param1 = _local_3;
                _local_2 = _local_2 + 2;
            }
            if((_local_3 = param1 >> 1) != 0) {
                param1 = _local_3;
                _local_2 = _local_2 + 1;
            }
            return _local_2;
        }
        
        public function bitLength() : int {
            if(this.t <= 0) {
                return 0;
            }
            return DB * (this.t - 1) + this.nbits(this.a[this.t - 1] ^ this.s & DM);
        }
        
        public function mod(param1:BigInteger) : BigInteger {
            var _local_2:BigInteger = this.nbi();
            this.abs().divRemTo(param1,null,_local_2);
            if(this.s < 0 && _local_2.compareTo(ZERO) > 0) {
                param1.subTo(_local_2,_local_2);
            }
            return _local_2;
        }
        
        public function modPowInt(param1:int, param2:BigInteger) : BigInteger {
            var _local_3:IReduction = null;
            if(param1 < 256 || param2.isEven()) {
                _local_3 = new ClassicReduction(param2);
            } else {
                _local_3 = new MontgomeryReduction(param2);
            }
            return this.exp(param1,_local_3);
        }
        
        bi_internal function copyTo(param1:BigInteger) : void {
            var _local_2:int = this.t - 1;
            while(_local_2 >= 0) {
                param1.a[_local_2] = this.a[_local_2];
                _local_2--;
            }
            param1.t = this.t;
            param1.s = this.s;
        }
        
        bi_internal function fromInt(param1:int) : void {
            this.t = 1;
            this.s = param1 < 0?-1:0;
            if(param1 > 0) {
                this.a[0] = param1;
            } else if(param1 < -1) {
                this.a[0] = param1 + DV;
            } else {
                this.t = 0;
            }
        }
        
        bi_internal function fromArray(param1:ByteArray, param2:int, param3:Boolean = false) : void {
            var _local_8:int = 0;
            var _local_4:int = param1.position;
            var _local_5:int = _local_4 + param2;
            var _local_6:int = 0;
            var _local_7:int = 8;
            this.t = 0;
            this.s = 0;
            while(--_local_5 >= _local_4) {
                _local_8 = _local_5 < param1.length?int(param1[_local_5]):0;
                if(_local_6 == 0) {
                    this.a[this.t++] = _local_8;
                } else if(_local_6 + _local_7 > DB) {
                    this.a[this.t - 1] = this.a[this.t - 1] | (_local_8 & 1 << DB - _local_6 - 1) << _local_6;
                    this.a[this.t++] = _local_8 >> DB - _local_6;
                } else {
                    this.a[this.t - 1] = this.a[this.t - 1] | _local_8 << _local_6;
                }
                _local_6 = _local_6 + _local_7;
                if(_local_6 >= DB) {
                    _local_6 = _local_6 - DB;
                }
            }
            if(!param3 && (param1[0] & 128) == 128) {
                this.s = -1;
                if(_local_6 > 0) {
                    this.a[this.t - 1] = this.a[this.t - 1] | 1 << DB - _local_6 - 1 << _local_6;
                }
            }
            this.clamp();
            param1.position = Math.min(_local_4 + param2,param1.length);
        }
        
        bi_internal function clamp() : void {
            var _local_1:* = this.s & DM;
            while(this.t > 0 && this.a[this.t - 1] == _local_1) {
                this.t--;
            }
        }
        
        bi_internal function dlShiftTo(param1:int, param2:BigInteger) : void {
            var _local_3:int = 0;
            _local_3 = this.t - 1;
            while(_local_3 >= 0) {
                param2.a[_local_3 + param1] = this.a[_local_3];
                _local_3--;
            }
            _local_3 = param1 - 1;
            while(_local_3 >= 0) {
                param2.a[_local_3] = 0;
                _local_3--;
            }
            param2.t = this.t + param1;
            param2.s = this.s;
        }
        
        bi_internal function drShiftTo(param1:int, param2:BigInteger) : void {
            var _local_3:int = 0;
            _local_3 = param1;
            while(_local_3 < this.t) {
                param2.a[_local_3 - param1] = this.a[_local_3];
                _local_3++;
            }
            param2.t = Math.max(this.t - param1,0);
            param2.s = this.s;
        }
        
        bi_internal function lShiftTo(param1:int, param2:BigInteger) : void {
            var _local_8:int = 0;
            var _local_3:int = param1 % DB;
            var _local_4:int = DB - _local_3;
            var _local_5:int = 1 << _local_4 - 1;
            var _local_6:int = param1 / DB;
            var _local_7:* = this.s << _local_3 & DM;
            _local_8 = this.t - 1;
            while(_local_8 >= 0) {
                param2.a[_local_8 + _local_6 + 1] = this.a[_local_8] >> _local_4 | _local_7;
                _local_7 = (this.a[_local_8] & _local_5) << _local_3;
                _local_8--;
            }
            _local_8 = _local_6 - 1;
            while(_local_8 >= 0) {
                param2.a[_local_8] = 0;
                _local_8--;
            }
            param2.a[_local_6] = _local_7;
            param2.t = this.t + _local_6 + 1;
            param2.s = this.s;
            param2.clamp();
        }
        
        bi_internal function rShiftTo(param1:int, param2:BigInteger) : void {
            var _local_7:int = 0;
            param2.s = this.s;
            var _local_3:int = param1 / DB;
            if(_local_3 >= this.t) {
                param2.t = 0;
                return;
            }
            var _local_4:int = param1 % DB;
            var _local_5:int = DB - _local_4;
            var _local_6:int = 1 << _local_4 - 1;
            param2.a[0] = this.a[_local_3] >> _local_4;
            _local_7 = _local_3 + 1;
            while(_local_7 < this.t) {
                param2.a[_local_7 - _local_3 - 1] = param2.a[_local_7 - _local_3 - 1] | (this.a[_local_7] & _local_6) << _local_5;
                param2.a[_local_7 - _local_3] = this.a[_local_7] >> _local_4;
                _local_7++;
            }
            if(_local_4 > 0) {
                param2.a[this.t - _local_3 - 1] = param2.a[this.t - _local_3 - 1] | (this.s & _local_6) << _local_5;
            }
            param2.t = this.t - _local_3;
            param2.clamp();
        }
        
        bi_internal function subTo(param1:BigInteger, param2:BigInteger) : void {
            var _local_3:int = 0;
            var _local_4:* = 0;
            var _local_5:int = Math.min(param1.t,this.t);
            while(_local_3 < _local_5) {
                _local_4 = int(_local_4 + (this.a[_local_3] - param1.a[_local_3]));
                param2.a[_local_3++] = _local_4 & DM;
                _local_4 = _local_4 >> DB;
            }
            if(param1.t < this.t) {
                _local_4 = int(_local_4 - param1.s);
                while(_local_3 < this.t) {
                    _local_4 = int(_local_4 + this.a[_local_3]);
                    param2.a[_local_3++] = _local_4 & DM;
                    _local_4 = _local_4 >> DB;
                }
                _local_4 = int(_local_4 + this.s);
            } else {
                _local_4 = int(_local_4 + this.s);
                while(_local_3 < param1.t) {
                    _local_4 = int(_local_4 - param1.a[_local_3]);
                    param2.a[_local_3++] = _local_4 & DM;
                    _local_4 = _local_4 >> DB;
                }
                _local_4 = int(_local_4 - param1.s);
            }
            param2.s = _local_4 < 0?-1:0;
            if(_local_4 < -1) {
                param2.a[_local_3++] = DV + _local_4;
            } else if(_local_4 > 0) {
                param2.a[_local_3++] = _local_4;
            }
            param2.t = _local_3;
            param2.clamp();
        }
        
        bi_internal function am(param1:int, param2:int, param3:BigInteger, param4:int, param5:int, param6:int) : int {
            var _local_9:* = 0;
            var _local_10:* = 0;
            var _local_11:int = 0;
            var _local_7:* = param2 & 32767;
            var _local_8:* = param2 >> 15;
            while(--param6 >= 0) {
                _local_9 = this.a[param1] & 32767;
                _local_10 = this.a[param1++] >> 15;
                _local_11 = _local_8 * _local_9 + _local_10 * _local_7;
                _local_9 = int(_local_7 * _local_9 + ((_local_11 & 32767) << 15) + param3.a[param4] + (param5 & 1073741823));
                param5 = (_local_9 >>> 30) + (_local_11 >>> 15) + _local_8 * _local_10 + (param5 >>> 30);
                param3.a[param4++] = _local_9 & 1073741823;
            }
            return param5;
        }
        
        bi_internal function multiplyTo(param1:BigInteger, param2:BigInteger) : void {
            var _local_3:BigInteger = this.abs();
            var _local_4:BigInteger = param1.abs();
            var _local_5:int = _local_3.t;
            param2.t = _local_5 + _local_4.t;
            while(--_local_5 >= 0) {
                param2.a[_local_5] = 0;
            }
            _local_5 = 0;
            while(_local_5 < _local_4.t) {
                param2.a[_local_5 + _local_3.t] = _local_3.am(0,_local_4.a[_local_5],param2,_local_5,0,_local_3.t);
                _local_5++;
            }
            param2.s = 0;
            param2.clamp();
            if(this.s != param1.s) {
                ZERO.subTo(param2,param2);
            }
        }
        
        bi_internal function squareTo(param1:BigInteger) : void {
            var _local_4:int = 0;
            var _local_2:BigInteger = this.abs();
            var _local_3:int = param1.t = 2 * _local_2.t;
            while(--_local_3 >= 0) {
                param1.a[_local_3] = 0;
            }
            _local_3 = 0;
            while(_local_3 < _local_2.t - 1) {
                _local_4 = _local_2.am(_local_3,_local_2.a[_local_3],param1,2 * _local_3,0,1);
                if((param1.a[_local_3 + _local_2.t] = param1.a[_local_3 + _local_2.t] + _local_2.am(_local_3 + 1,2 * _local_2.a[_local_3],param1,2 * _local_3 + 1,_local_4,_local_2.t - _local_3 - 1)) >= DV) {
                    param1.a[_local_3 + _local_2.t] = param1.a[_local_3 + _local_2.t] - DV;
                    param1.a[_local_3 + _local_2.t + 1] = 1;
                }
                _local_3++;
            }
            if(param1.t > 0) {
                param1.a[param1.t - 1] = param1.a[param1.t - 1] + _local_2.am(_local_3,_local_2.a[_local_3],param1,2 * _local_3,0,1);
            }
            param1.s = 0;
            param1.clamp();
        }
        
        bi_internal function divRemTo(param1:BigInteger, param2:BigInteger = null, param3:BigInteger = null) : void {
            var qd:int = 0;
            var m:BigInteger = param1;
            var q:BigInteger = param2;
            var r:BigInteger = param3;
            var pm:BigInteger = m.abs();
            if(pm.t <= 0) {
                return;
            }
            var pt:BigInteger = this.abs();
            if(pt.t < pm.t) {
                if(q != null) {
                    q.fromInt(0);
                }
                if(r != null) {
                    this.copyTo(r);
                }
                return;
            }
            if(r == null) {
                r = this.nbi();
            }
            var y:BigInteger = this.nbi();
            var ts:int = this.s;
            var ms:int = m.s;
            var nsh:int = DB - this.nbits(pm.a[pm.t - 1]);
            if(nsh > 0) {
                pm.lShiftTo(nsh,y);
                pt.lShiftTo(nsh,r);
            } else {
                pm.copyTo(y);
                pt.copyTo(r);
            }
            var ys:int = y.t;
            var y0:int = y.a[ys - 1];
            if(y0 == 0) {
                return;
            }
            var yt:Number = y0 * (1 << F1) + (ys > 1?y.a[ys - 2] >> F2:0);
            var d1:Number = FV / yt;
            var d2:Number = (1 << F1) / yt;
            var e:Number = 1 << F2;
            var i:int = r.t;
            var j:int = i - ys;
            var t:BigInteger = q == null?this.nbi():q;
            y.dlShiftTo(j,t);
            if(r.compareTo(t) >= 0) {
                r.a[r.t++] = 1;
                r.subTo(t,r);
            }
            ONE.dlShiftTo(ys,t);
            t.subTo(y,y);
            while(y.t < ys) {
                while(§§hasnext(y,_local_6)) {
                    with(_local_9) {
                        
                        y.t++;
                        if(0) {
                            _local_5[_local_6] = _local_8;
                        }
                    }
                }
            }
            while(--j >= 0) {
                qd = r.a[--i] == y0?int(DM):int(Number(r.a[i]) * d1 + (Number(r.a[i - 1]) + e) * d2);
                if((r.a[i] = r.a[i] + y.am(0,qd,r,j,0,ys)) < qd) {
                    y.dlShiftTo(j,t);
                    r.subTo(t,r);
                    while(r.a[i] < --qd) {
                        r.subTo(t,r);
                    }
                    continue;
                }
            }
            if(q != null) {
                r.drShiftTo(ys,q);
                if(ts != ms) {
                    ZERO.subTo(q,q);
                }
            }
            r.t = ys;
            r.clamp();
            if(nsh > 0) {
                r.rShiftTo(nsh,r);
            }
            if(ts < 0) {
                ZERO.subTo(r,r);
            }
        }
        
        bi_internal function invDigit() : int {
            if(this.t < 1) {
                return 0;
            }
            var _local_1:int = this.a[0];
            if((_local_1 & 1) == 0) {
                return 0;
            }
            var _local_2:* = _local_1 & 3;
            _local_2 = _local_2 * (2 - (_local_1 & 15) * _local_2) & 15;
            _local_2 = _local_2 * (2 - (_local_1 & 255) * _local_2) & 255;
            _local_2 = _local_2 * (2 - ((_local_1 & 65535) * _local_2 & 65535)) & 65535;
            _local_2 = int(_local_2 * (2 - _local_1 * _local_2 % DV) % DV);
            return _local_2 > 0?int(DV - _local_2):int(-_local_2);
        }
        
        bi_internal function isEven() : Boolean {
            return (this.t > 0?this.a[0] & 1:this.s) == 0;
        }
        
        bi_internal function exp(param1:int, param2:IReduction) : BigInteger {
            var _local_7:BigInteger = null;
            if(param1 > 4294967295 || param1 < 1) {
                return ONE;
            }
            var _local_3:BigInteger = this.nbi();
            var _local_4:BigInteger = this.nbi();
            var _local_5:BigInteger = param2.convert(this);
            var _local_6:int = this.nbits(param1) - 1;
            _local_5.copyTo(_local_3);
            while(--_local_6 >= 0) {
                param2.sqrTo(_local_3,_local_4);
                if((param1 & 1 << _local_6) > 0) {
                    param2.mulTo(_local_4,_local_5,_local_3);
                } else {
                    _local_7 = _local_3;
                    _local_3 = _local_4;
                    _local_4 = _local_7;
                }
            }
            return param2.revert(_local_3);
        }
        
        bi_internal function intAt(param1:String, param2:int) : int {
            return parseInt(param1.charAt(param2),36);
        }
        
        protected function nbi() : * {
            return new BigInteger();
        }
        
        public function clone() : BigInteger {
            var _local_1:BigInteger = new BigInteger();
            this.copyTo(_local_1);
            return _local_1;
        }
        
        public function intValue() : int {
            if(this.s < 0) {
                if(this.t == 1) {
                    return this.a[0] - DV;
                }
                if(this.t == 0) {
                    return -1;
                }
            } else {
                if(this.t == 1) {
                    return this.a[0];
                }
                if(this.t == 0) {
                    return 0;
                }
            }
            return (this.a[1] & 1 << 32 - DB - 1) << DB | this.a[0];
        }
        
        public function byteValue() : int {
            return this.t == 0?int(this.s):this.a[0] << 24 >> 24;
        }
        
        public function shortValue() : int {
            return this.t == 0?int(this.s):this.a[0] << 16 >> 16;
        }
        
        protected function chunkSize(param1:Number) : int {
            return Math.floor(Math.LN2 * DB / Math.log(param1));
        }
        
        public function sigNum() : int {
            if(this.s < 0) {
                return -1;
            }
            if(this.t <= 0 || this.t == 1 && this.a[0] <= 0) {
                return 0;
            }
            return 1;
        }
        
        protected function toRadix(param1:uint = 10) : String {
            if(this.sigNum() == 0 || param1 < 2 || param1 > 32) {
                return "0";
            }
            var _local_2:int = this.chunkSize(param1);
            var _local_3:Number = Math.pow(param1,_local_2);
            var _local_4:BigInteger = nbv(_local_3);
            var _local_5:BigInteger = this.nbi();
            var _local_6:BigInteger = this.nbi();
            var _local_7:String = "";
            this.divRemTo(_local_4,_local_5,_local_6);
            while(_local_5.sigNum() > 0) {
                _local_7 = (_local_3 + _local_6.intValue()).toString(param1).substr(1) + _local_7;
                _local_5.divRemTo(_local_4,_local_5,_local_6);
            }
            return _local_6.intValue().toString(param1) + _local_7;
        }
        
        protected function fromRadix(param1:String, param2:int = 10) : void {
            var _local_9:int = 0;
            this.fromInt(0);
            var _local_3:int = this.chunkSize(param2);
            var _local_4:Number = Math.pow(param2,_local_3);
            var _local_5:Boolean = false;
            var _local_6:int = 0;
            var _local_7:int = 0;
            var _local_8:int = 0;
            while(_local_8 < param1.length) {
                _local_9 = this.intAt(param1,_local_8);
                if(_local_9 < 0) {
                    if(param1.charAt(_local_8) == "-" && this.sigNum() == 0) {
                        _local_5 = true;
                    }
                } else {
                    _local_7 = param2 * _local_7 + _local_9;
                    if(++_local_6 >= _local_3) {
                        this.dMultiply(_local_4);
                        this.dAddOffset(_local_7,0);
                        _local_6 = 0;
                        _local_7 = 0;
                    }
                }
                _local_8++;
            }
            if(_local_6 > 0) {
                this.dMultiply(Math.pow(param2,_local_6));
                this.dAddOffset(_local_7,0);
            }
            if(_local_5) {
                BigInteger.ZERO.subTo(this,this);
            }
        }
        
        public function toByteArray() : ByteArray {
            var _local_4:* = 0;
            var _local_1:int = this.t;
            var _local_2:ByteArray = new ByteArray();
            _local_2[0] = this.s;
            var _local_3:int = DB - _local_1 * DB % 8;
            var _local_5:int = 0;
            if(_local_1-- > 0) {
                if(_local_3 < DB && (_local_4 = int(this.a[_local_1] >> _local_3)) != (this.s & DM) >> _local_3) {
                    _local_2[_local_5++] = _local_4 | this.s << DB - _local_3;
                }
                while(_local_1 >= 0) {
                    if(_local_3 < 8) {
                        _local_4 = (this.a[_local_1] & 1 << _local_3 - 1) << 8 - _local_3;
                        _local_4 = _local_4 | this.a[--_local_1] >> (_local_3 = _local_3 + (DB - 8));
                    } else {
                        _local_4 = this.a[_local_1] >> (_local_3 = _local_3 - 8) & 255;
                        if(_local_3 <= 0) {
                            _local_3 = _local_3 + DB;
                            _local_1--;
                        }
                    }
                    if((_local_4 & 128) != 0) {
                        _local_4 = _local_4 | -256;
                    }
                    if(_local_5 == 0 && (this.s & 128) != (_local_4 & 128)) {
                        _local_5++;
                    }
                    if(_local_5 > 0 || _local_4 != this.s) {
                        _local_2[_local_5++] = _local_4;
                    }
                }
            }
            return _local_2;
        }
        
        public function equals(param1:BigInteger) : Boolean {
            return this.compareTo(param1) == 0;
        }
        
        public function min(param1:BigInteger) : BigInteger {
            return this.compareTo(param1) < 0?this:param1;
        }
        
        public function max(param1:BigInteger) : BigInteger {
            return this.compareTo(param1) > 0?this:param1;
        }
        
        protected function bitwiseTo(param1:BigInteger, param2:Function, param3:BigInteger) : void {
            var _local_4:int = 0;
            var _local_5:* = 0;
            var _local_6:int = Math.min(param1.t,this.t);
            _local_4 = 0;
            while(_local_4 < _local_6) {
                param3.a[_local_4] = param2(this.a[_local_4],param1.a[_local_4]);
                _local_4++;
            }
            if(param1.t < this.t) {
                _local_5 = param1.s & DM;
                _local_4 = _local_6;
                while(_local_4 < this.t) {
                    param3.a[_local_4] = param2(this.a[_local_4],_local_5);
                    _local_4++;
                }
                param3.t = this.t;
            } else {
                _local_5 = this.s & DM;
                _local_4 = _local_6;
                while(_local_4 < param1.t) {
                    param3.a[_local_4] = param2(_local_5,param1.a[_local_4]);
                    _local_4++;
                }
                param3.t = param1.t;
            }
            param3.s = param2(this.s,param1.s);
            param3.clamp();
        }
        
        private function op_and(param1:int, param2:int) : int {
            return param1 & param2;
        }
        
        public function and(param1:BigInteger) : BigInteger {
            var _local_2:BigInteger = new BigInteger();
            this.bitwiseTo(param1,this.op_and,_local_2);
            return _local_2;
        }
        
        private function op_or(param1:int, param2:int) : int {
            return param1 | param2;
        }
        
        public function or(param1:BigInteger) : BigInteger {
            var _local_2:BigInteger = new BigInteger();
            this.bitwiseTo(param1,this.op_or,_local_2);
            return _local_2;
        }
        
        private function op_xor(param1:int, param2:int) : int {
            return param1 ^ param2;
        }
        
        public function xor(param1:BigInteger) : BigInteger {
            var _local_2:BigInteger = new BigInteger();
            this.bitwiseTo(param1,this.op_xor,_local_2);
            return _local_2;
        }
        
        private function op_andnot(param1:int, param2:int) : int {
            return param1 & ~param2;
        }
        
        public function andNot(param1:BigInteger) : BigInteger {
            var _local_2:BigInteger = new BigInteger();
            this.bitwiseTo(param1,this.op_andnot,_local_2);
            return _local_2;
        }
        
        public function not() : BigInteger {
            var _local_1:BigInteger = new BigInteger();
            var _local_2:int = 0;
            while(_local_2 < this.t) {
                _local_1[_local_2] = DM & ~this.a[_local_2];
                _local_2++;
            }
            _local_1.t = this.t;
            _local_1.s = ~this.s;
            return _local_1;
        }
        
        public function shiftLeft(param1:int) : BigInteger {
            var _local_2:BigInteger = new BigInteger();
            if(param1 < 0) {
                this.rShiftTo(-param1,_local_2);
            } else {
                this.lShiftTo(param1,_local_2);
            }
            return _local_2;
        }
        
        public function shiftRight(param1:int) : BigInteger {
            var _local_2:BigInteger = new BigInteger();
            if(param1 < 0) {
                this.lShiftTo(-param1,_local_2);
            } else {
                this.rShiftTo(param1,_local_2);
            }
            return _local_2;
        }
        
        private function lbit(param1:int) : int {
            if(param1 == 0) {
                return -1;
            }
            var _local_2:int = 0;
            if((param1 & 65535) == 0) {
                param1 = param1 >> 16;
                _local_2 = _local_2 + 16;
            }
            if((param1 & 255) == 0) {
                param1 = param1 >> 8;
                _local_2 = _local_2 + 8;
            }
            if((param1 & 15) == 0) {
                param1 = param1 >> 4;
                _local_2 = _local_2 + 4;
            }
            if((param1 & 3) == 0) {
                param1 = param1 >> 2;
                _local_2 = _local_2 + 2;
            }
            if((param1 & 1) == 0) {
                _local_2++;
            }
            return _local_2;
        }
        
        public function getLowestSetBit() : int {
            var _local_1:int = 0;
            while(_local_1 < this.t) {
                if(this.a[_local_1] != 0) {
                    return _local_1 * DB + this.lbit(this.a[_local_1]);
                }
                _local_1++;
            }
            if(this.s < 0) {
                return this.t * DB;
            }
            return -1;
        }
        
        private function cbit(param1:int) : int {
            var _local_2:uint = 0;
            while(param1 != 0) {
                param1 = param1 & param1 - 1;
                _local_2++;
            }
            return _local_2;
        }
        
        public function bitCount() : int {
            var _local_1:int = 0;
            var _local_2:* = this.s & DM;
            var _local_3:int = 0;
            while(_local_3 < this.t) {
                _local_1 = _local_1 + this.cbit(this.a[_local_3] ^ _local_2);
                _local_3++;
            }
            return _local_1;
        }
        
        public function testBit(param1:int) : Boolean {
            var _local_2:int = Math.floor(param1 / DB);
            if(_local_2 >= this.t) {
                return this.s != 0;
            }
            return (this.a[_local_2] & 1 << param1 % DB) != 0;
        }
        
        protected function changeBit(param1:int, param2:Function) : BigInteger {
            var _local_3:BigInteger = BigInteger.ONE.shiftLeft(param1);
            this.bitwiseTo(_local_3,param2,_local_3);
            return _local_3;
        }
        
        public function setBit(param1:int) : BigInteger {
            return this.changeBit(param1,this.op_or);
        }
        
        public function clearBit(param1:int) : BigInteger {
            return this.changeBit(param1,this.op_andnot);
        }
        
        public function flipBit(param1:int) : BigInteger {
            return this.changeBit(param1,this.op_xor);
        }
        
        protected function addTo(param1:BigInteger, param2:BigInteger) : void {
            var _local_3:int = 0;
            var _local_4:* = 0;
            var _local_5:int = Math.min(param1.t,this.t);
            while(_local_3 < _local_5) {
                _local_4 = int(_local_4 + (this.a[_local_3] + param1.a[_local_3]));
                param2.a[_local_3++] = _local_4 & DM;
                _local_4 = _local_4 >> DB;
            }
            if(param1.t < this.t) {
                _local_4 = int(_local_4 + param1.s);
                while(_local_3 < this.t) {
                    _local_4 = int(_local_4 + this.a[_local_3]);
                    param2.a[_local_3++] = _local_4 & DM;
                    _local_4 = _local_4 >> DB;
                }
                _local_4 = int(_local_4 + this.s);
            } else {
                _local_4 = int(_local_4 + this.s);
                while(_local_3 < param1.t) {
                    _local_4 = int(_local_4 + param1.a[_local_3]);
                    param2.a[_local_3++] = _local_4 & DM;
                    _local_4 = _local_4 >> DB;
                }
                _local_4 = int(_local_4 + param1.s);
            }
            param2.s = _local_4 < 0?-1:0;
            if(_local_4 > 0) {
                param2.a[_local_3++] = _local_4;
            } else if(_local_4 < -1) {
                param2.a[_local_3++] = DV + _local_4;
            }
            param2.t = _local_3;
            param2.clamp();
        }
        
        public function add(param1:BigInteger) : BigInteger {
            var _local_2:BigInteger = new BigInteger();
            this.addTo(param1,_local_2);
            return _local_2;
        }
        
        public function subtract(param1:BigInteger) : BigInteger {
            var _local_2:BigInteger = new BigInteger();
            this.subTo(param1,_local_2);
            return _local_2;
        }
        
        public function multiply(param1:BigInteger) : BigInteger {
            var _local_2:BigInteger = new BigInteger();
            this.multiplyTo(param1,_local_2);
            return _local_2;
        }
        
        public function divide(param1:BigInteger) : BigInteger {
            var _local_2:BigInteger = new BigInteger();
            this.divRemTo(param1,_local_2,null);
            return _local_2;
        }
        
        public function remainder(param1:BigInteger) : BigInteger {
            var _local_2:BigInteger = new BigInteger();
            this.divRemTo(param1,null,_local_2);
            return _local_2;
        }
        
        public function divideAndRemainder(param1:BigInteger) : Array {
            var _local_2:BigInteger = new BigInteger();
            var _local_3:BigInteger = new BigInteger();
            this.divRemTo(param1,_local_2,_local_3);
            return [_local_2,_local_3];
        }
        
        bi_internal function dMultiply(param1:int) : void {
            this.a[this.t] = this.am(0,param1 - 1,this,0,0,this.t);
            this.t++;
            this.clamp();
        }
        
        bi_internal function dAddOffset(param1:int, param2:int) : void {
            while(this.t <= param2) {
                this.a[this.t++] = 0;
            }
            this.a[param2] = this.a[param2] + param1;
            while(this.a[param2] >= DV) {
                this.a[param2] = this.a[param2] - DV;
                if(++param2 >= this.t) {
                    this.a[this.t++] = 0;
                }
                this.a[param2]++;
            }
        }
        
        public function pow(param1:int) : BigInteger {
            return this.exp(param1,new NullReduction());
        }
        
        bi_internal function multiplyLowerTo(param1:BigInteger, param2:int, param3:BigInteger) : void {
            var _local_5:int = 0;
            var _local_4:int = Math.min(this.t + param1.t,param2);
            param3.s = 0;
            param3.t = _local_4;
            while(_local_4 > 0) {
                param3.a[--_local_4] = 0;
            }
            _local_5 = param3.t - this.t;
            while(_local_4 < _local_5) {
                param3.a[_local_4 + this.t] = this.am(0,param1.a[_local_4],param3,_local_4,0,this.t);
                _local_4++;
            }
            _local_5 = Math.min(param1.t,param2);
            while(_local_4 < _local_5) {
                this.am(0,param1.a[_local_4],param3,_local_4,0,param2 - _local_4);
                _local_4++;
            }
            param3.clamp();
        }
        
        bi_internal function multiplyUpperTo(param1:BigInteger, param2:int, param3:BigInteger) : void {
            param2--;
            var _local_4:int = param3.t = this.t + param1.t - param2;
            param3.s = 0;
            while(--_local_4 >= 0) {
                param3.a[_local_4] = 0;
            }
            _local_4 = Math.max(param2 - this.t,0);
            while(_local_4 < param1.t) {
                param3.a[this.t + _local_4 - param2] = this.am(param2 - _local_4,param1.a[_local_4],param3,0,0,this.t + _local_4 - param2);
                _local_4++;
            }
            param3.clamp();
            param3.drShiftTo(1,param3);
        }
        
        public function modPow(param1:BigInteger, param2:BigInteger) : BigInteger {
            var _local_4:int = 0;
            var _local_6:IReduction = null;
            var _local_12:* = 0;
            var _local_15:BigInteger = null;
            var _local_16:BigInteger = null;
            var _local_3:int = param1.bitLength();
            var _local_5:BigInteger = nbv(1);
            if(_local_3 <= 0) {
                return _local_5;
            }
            if(_local_3 < 18) {
                _local_4 = 1;
            } else if(_local_3 < 48) {
                _local_4 = 3;
            } else if(_local_3 < 144) {
                _local_4 = 4;
            } else if(_local_3 < 768) {
                _local_4 = 5;
            } else {
                _local_4 = 6;
            }
            if(_local_3 < 8) {
                _local_6 = new ClassicReduction(param2);
            } else if(param2.isEven()) {
                _local_6 = new BarrettReduction(param2);
            } else {
                _local_6 = new MontgomeryReduction(param2);
            }
            var _local_7:Array = [];
            var _local_8:int = 3;
            var _local_9:int = _local_4 - 1;
            var _local_10:int = 1 << _local_4 - 1;
            _local_7[1] = _local_6.convert(this);
            if(_local_4 > 1) {
                _local_16 = new BigInteger();
                _local_6.sqrTo(_local_7[1],_local_16);
                while(_local_8 <= _local_10) {
                    _local_7[_local_8] = new BigInteger();
                    _local_6.mulTo(_local_16,_local_7[_local_8 - 2],_local_7[_local_8]);
                    _local_8 = _local_8 + 2;
                }
            }
            var _local_11:int = param1.t - 1;
            var _local_13:Boolean = true;
            var _local_14:BigInteger = new BigInteger();
            _local_3 = this.nbits(param1.a[_local_11]) - 1;
            while(_local_11 >= 0) {
                if(_local_3 >= _local_9) {
                    _local_12 = param1.a[_local_11] >> _local_3 - _local_9 & _local_10;
                } else {
                    _local_12 = (param1.a[_local_11] & 1 << _local_3 + 1 - 1) << _local_9 - _local_3;
                    if(_local_11 > 0) {
                        _local_12 = _local_12 | param1.a[_local_11 - 1] >> DB + _local_3 - _local_9;
                    }
                }
                _local_8 = _local_4;
                while((_local_12 & 1) == 0) {
                    _local_12 = _local_12 >> 1;
                    _local_8--;
                }
                if((_local_3 = _local_3 - _local_8) < 0) {
                    _local_3 = _local_3 + DB;
                    _local_11--;
                }
                if(_local_13) {
                    _local_7[_local_12].copyTo(_local_5);
                    _local_13 = false;
                } else {
                    while(_local_8 > 1) {
                        _local_6.sqrTo(_local_5,_local_14);
                        _local_6.sqrTo(_local_14,_local_5);
                        _local_8 = _local_8 - 2;
                    }
                    if(_local_8 > 0) {
                        _local_6.sqrTo(_local_5,_local_14);
                    } else {
                        _local_15 = _local_5;
                        _local_5 = _local_14;
                        _local_14 = _local_15;
                    }
                    _local_6.mulTo(_local_14,_local_7[_local_12],_local_5);
                }
                while(_local_11 >= 0 && (param1.a[_local_11] & 1 << _local_3) == 0) {
                    _local_6.sqrTo(_local_5,_local_14);
                    _local_15 = _local_5;
                    _local_5 = _local_14;
                    _local_14 = _local_15;
                    if(--_local_3 < 0) {
                        _local_3 = DB - 1;
                        _local_11--;
                    }
                }
            }
            return _local_6.revert(_local_5);
        }
        
        public function gcd(param1:BigInteger) : BigInteger {
            var _local_6:BigInteger = null;
            var _local_2:BigInteger = this.s < 0?this.negate():this.clone();
            var _local_3:BigInteger = param1.s < 0?param1.negate():param1.clone();
            if(_local_2.compareTo(_local_3) < 0) {
                _local_6 = _local_2;
                _local_2 = _local_3;
                _local_3 = _local_6;
            }
            var _local_4:int = _local_2.getLowestSetBit();
            var _local_5:int = _local_3.getLowestSetBit();
            if(_local_5 < 0) {
                return _local_2;
            }
            if(_local_4 < _local_5) {
                _local_5 = _local_4;
            }
            if(_local_5 > 0) {
                _local_2.rShiftTo(_local_5,_local_2);
                _local_3.rShiftTo(_local_5,_local_3);
            }
            while(_local_2.sigNum() > 0) {
                if((_local_4 = _local_2.getLowestSetBit()) > 0) {
                    _local_2.rShiftTo(_local_4,_local_2);
                }
                if((_local_4 = _local_3.getLowestSetBit()) > 0) {
                    _local_3.rShiftTo(_local_4,_local_3);
                }
                if(_local_2.compareTo(_local_3) >= 0) {
                    _local_2.subTo(_local_3,_local_2);
                    _local_2.rShiftTo(1,_local_2);
                } else {
                    _local_3.subTo(_local_2,_local_3);
                    _local_3.rShiftTo(1,_local_3);
                }
            }
            if(_local_5 > 0) {
                _local_3.lShiftTo(_local_5,_local_3);
            }
            return _local_3;
        }
        
        protected function modInt(param1:int) : int {
            var _local_4:int = 0;
            if(param1 <= 0) {
                return 0;
            }
            var _local_2:int = DV % param1;
            var _local_3:int = this.s < 0?int(param1 - 1):0;
            if(this.t > 0) {
                if(_local_2 == 0) {
                    _local_3 = this.a[0] % param1;
                } else {
                    _local_4 = this.t - 1;
                    while(_local_4 >= 0) {
                        _local_3 = (_local_2 * _local_3 + this.a[_local_4]) % param1;
                        _local_4--;
                    }
                }
            }
            return _local_3;
        }
        
        public function modInverse(param1:BigInteger) : BigInteger {
            var _local_2:Boolean = param1.isEven();
            if(this.isEven() && _local_2 || param1.sigNum() == 0) {
                return BigInteger.ZERO;
            }
            var _local_3:BigInteger = param1.clone();
            var _local_4:BigInteger = this.clone();
            var _local_5:BigInteger = nbv(1);
            var _local_6:BigInteger = nbv(0);
            var _local_7:BigInteger = nbv(0);
            var _local_8:BigInteger = nbv(1);
            while(_local_3.sigNum() != 0) {
                while(_local_3.isEven()) {
                    _local_3.rShiftTo(1,_local_3);
                    if(_local_2) {
                        if(!_local_5.isEven() || !_local_6.isEven()) {
                            _local_5.addTo(this,_local_5);
                            _local_6.subTo(param1,_local_6);
                        }
                        _local_5.rShiftTo(1,_local_5);
                    } else if(!_local_6.isEven()) {
                        _local_6.subTo(param1,_local_6);
                    }
                    _local_6.rShiftTo(1,_local_6);
                }
                while(_local_4.isEven()) {
                    _local_4.rShiftTo(1,_local_4);
                    if(_local_2) {
                        if(!_local_7.isEven() || !_local_8.isEven()) {
                            _local_7.addTo(this,_local_7);
                            _local_8.subTo(param1,_local_8);
                        }
                        _local_7.rShiftTo(1,_local_7);
                    } else if(!_local_8.isEven()) {
                        _local_8.subTo(param1,_local_8);
                    }
                    _local_8.rShiftTo(1,_local_8);
                }
                if(_local_3.compareTo(_local_4) >= 0) {
                    _local_3.subTo(_local_4,_local_3);
                    if(_local_2) {
                        _local_5.subTo(_local_7,_local_5);
                    }
                    _local_6.subTo(_local_8,_local_6);
                } else {
                    _local_4.subTo(_local_3,_local_4);
                    if(_local_2) {
                        _local_7.subTo(_local_5,_local_7);
                    }
                    _local_8.subTo(_local_6,_local_8);
                }
            }
            if(_local_4.compareTo(BigInteger.ONE) != 0) {
                return BigInteger.ZERO;
            }
            if(_local_8.compareTo(param1) >= 0) {
                return _local_8.subtract(param1);
            }
            if(_local_8.sigNum() < 0) {
                _local_8.addTo(param1,_local_8);
                if(_local_8.sigNum() < 0) {
                    return _local_8.add(param1);
                }
                return _local_8;
            }
            return _local_8;
        }
        
        public function isProbablePrime(param1:int) : Boolean {
            var _local_2:int = 0;
            var _local_4:int = 0;
            var _local_5:int = 0;
            var _local_3:BigInteger = this.abs();
            if(_local_3.t == 1 && _local_3.a[0] <= lowprimes[lowprimes.length - 1]) {
                _local_2 = 0;
                while(_local_2 < lowprimes.length) {
                    if(_local_3[0] == lowprimes[_local_2]) {
                        return true;
                    }
                    _local_2++;
                }
                return false;
            }
            if(_local_3.isEven()) {
                return false;
            }
            _local_2 = 1;
            while(_local_2 < lowprimes.length) {
                _local_4 = lowprimes[_local_2];
                _local_5 = _local_2 + 1;
                while(_local_5 < lowprimes.length && _local_4 < lplim) {
                    _local_4 = _local_4 * lowprimes[_local_5++];
                }
                _local_4 = _local_3.modInt(_local_4);
                while(_local_2 < _local_5) {
                    if(_local_4 % lowprimes[_local_2++] == 0) {
                        return false;
                    }
                }
            }
            return _local_3.millerRabin(param1);
        }
        
        protected function millerRabin(param1:int) : Boolean {
            var _local_7:BigInteger = null;
            var _local_8:int = 0;
            var _local_2:BigInteger = this.subtract(BigInteger.ONE);
            var _local_3:int = _local_2.getLowestSetBit();
            if(_local_3 <= 0) {
                return false;
            }
            var _local_4:BigInteger = _local_2.shiftRight(_local_3);
            param1 = param1 + 1 >> 1;
            if(param1 > lowprimes.length) {
                param1 = int(lowprimes.length);
            }
            var _local_5:BigInteger = new BigInteger();
            var _local_6:int = 0;
            while(_local_6 < param1) {
                _local_5.fromInt(lowprimes[_local_6]);
                _local_7 = _local_5.modPow(_local_4,this);
                if(_local_7.compareTo(BigInteger.ONE) != 0 && _local_7.compareTo(_local_2) != 0) {
                    _local_8 = 1;
                    while(_local_8++ < _local_3 && _local_7.compareTo(_local_2) != 0) {
                        _local_7 = _local_7.modPowInt(2,this);
                        if(_local_7.compareTo(BigInteger.ONE) == 0) {
                            return false;
                        }
                    }
                    if(_local_7.compareTo(_local_2) != 0) {
                        return false;
                    }
                }
                _local_6++;
            }
            return true;
        }
        
        public function primify(param1:int, param2:int) : void {
            if(!this.testBit(param1 - 1)) {
                this.bitwiseTo(BigInteger.ONE.shiftLeft(param1 - 1),this.op_or,this);
            }
            if(this.isEven()) {
                this.dAddOffset(1,0);
            }
            while(!this.isProbablePrime(param2)) {
                this.dAddOffset(2,0);
                while(this.bitLength() > param1) {
                    this.subTo(BigInteger.ONE.shiftLeft(param1 - 1),this);
                }
            }
        }
    }
}
