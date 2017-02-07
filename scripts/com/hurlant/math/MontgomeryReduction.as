package com.hurlant.math {
    use namespace bi_internal;
    
    class MontgomeryReduction implements IReduction {
         
        
        private var m:BigInteger;
        
        private var mp:int;
        
        private var mpl:int;
        
        private var mph:int;
        
        private var um:int;
        
        private var mt2:int;
        
        function MontgomeryReduction(param1:BigInteger) {
            super();
            this.m = param1;
            this.mp = param1.invDigit();
            this.mpl = this.mp & 32767;
            this.mph = this.mp >> 15;
            this.um = 1 << BigInteger.DB - 15 - 1;
            this.mt2 = 2 * param1.t;
        }
        
        public function convert(param1:BigInteger) : BigInteger {
            var _local_2:BigInteger = new BigInteger();
            param1.abs().dlShiftTo(this.m.t,_local_2);
            _local_2.divRemTo(this.m,null,_local_2);
            if(param1.s < 0 && _local_2.compareTo(BigInteger.ZERO) > 0) {
                this.m.subTo(_local_2,_local_2);
            }
            return _local_2;
        }
        
        public function revert(param1:BigInteger) : BigInteger {
            var _local_2:BigInteger = new BigInteger();
            param1.copyTo(_local_2);
            this.reduce(_local_2);
            return _local_2;
        }
        
        public function reduce(param1:BigInteger) : void {
            var _local_3:* = 0;
            var _local_4:* = 0;
            while(param1.t <= this.mt2) {
                param1.a[param1.t++] = 0;
            }
            var _local_2:int = 0;
            while(_local_2 < this.m.t) {
                _local_3 = param1.a[_local_2] & 32767;
                _local_4 = _local_3 * this.mpl + ((_local_3 * this.mph + (param1.a[_local_2] >> 15) * this.mpl & this.um) << 15) & BigInteger.DM;
                _local_3 = int(_local_2 + this.m.t);
                param1.a[_local_3] = param1.a[_local_3] + this.m.am(0,_local_4,param1,_local_2,0,this.m.t);
                while(param1.a[_local_3] >= BigInteger.DV) {
                    param1.a[_local_3] = param1.a[_local_3] - BigInteger.DV;
                    param1.a[++_local_3]++;
                }
                _local_2++;
            }
            param1.clamp();
            param1.drShiftTo(this.m.t,param1);
            if(param1.compareTo(this.m) >= 0) {
                param1.subTo(this.m,param1);
            }
        }
        
        public function sqrTo(param1:BigInteger, param2:BigInteger) : void {
            param1.squareTo(param2);
            this.reduce(param2);
        }
        
        public function mulTo(param1:BigInteger, param2:BigInteger, param3:BigInteger) : void {
            param1.multiplyTo(param2,param3);
            this.reduce(param3);
        }
    }
}
