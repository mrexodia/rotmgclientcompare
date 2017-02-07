package com.hurlant.crypto.prng {
    import com.hurlant.util.Memory;
    import flash.system.Capabilities;
    import flash.system.System;
    import flash.text.Font;
    import flash.utils.ByteArray;
    import flash.utils.getTimer;
    
    public class Random {
         
        
        private var state:IPRNG;
        
        private var ready:Boolean = false;
        
        private var pool:ByteArray;
        
        private var psize:int;
        
        private var pptr:int;
        
        private var seeded:Boolean = false;
        
        public function Random(param1:Class = null) {
            var _local_2:uint = 0;
            super();
            if(param1 == null) {
                param1 = ARC4;
            }
            this.state = new param1() as IPRNG;
            this.psize = this.state.getPoolSize();
            this.pool = new ByteArray();
            this.pptr = 0;
            while(this.pptr < this.psize) {
                _local_2 = 65536 * Math.random();
                this.pool[this.pptr++] = _local_2 >>> 8;
                this.pool[this.pptr++] = _local_2 & 255;
            }
            this.pptr = 0;
            this.seed();
        }
        
        public function seed(param1:int = 0) : void {
            if(param1 == 0) {
                param1 = new Date().getTime();
            }
            var _local_2:* = this.pptr++;
            this.pool[_local_2] = this.pool[_local_2] ^ param1 & 255;
            this.pool[this.pptr++] = this.pool[_local_3] ^ param1 >> 8 & 255;
            this.pool[this.pptr++] = this.pool[this.pptr++] ^ param1 >> 16 & 255;
            this.pool[this.pptr++] = this.pool[this.pptr++] ^ param1 >> 24 & 255;
            this.pptr = this.pptr % this.psize;
            this.seeded = true;
        }
        
        public function autoSeed() : void {
            var _local_3:Font = null;
            var _local_1:ByteArray = new ByteArray();
            _local_1.writeUnsignedInt(System.totalMemory);
            _local_1.writeUTF(Capabilities.serverString);
            _local_1.writeUnsignedInt(getTimer());
            _local_1.writeUnsignedInt(new Date().getTime());
            var _local_2:Array = Font.enumerateFonts(true);
            for each(_local_3 in _local_2) {
                _local_1.writeUTF(_local_3.fontName);
                _local_1.writeUTF(_local_3.fontStyle);
                _local_1.writeUTF(_local_3.fontType);
            }
            _local_1.position = 0;
            while(_local_1.bytesAvailable >= 4) {
                this.seed(_local_1.readUnsignedInt());
            }
        }
        
        public function nextBytes(param1:ByteArray, param2:int) : void {
            while(param2--) {
                param1.writeByte(this.nextByte());
            }
        }
        
        public function nextByte() : int {
            if(!this.ready) {
                if(!this.seeded) {
                    this.autoSeed();
                }
                this.state.init(this.pool);
                this.pool.length = 0;
                this.pptr = 0;
                this.ready = true;
            }
            return this.state.next();
        }
        
        public function dispose() : void {
            var _local_1:uint = 0;
            while(_local_1 < this.pool.length) {
                this.pool[_local_1] = Math.random() * 256;
                _local_1++;
            }
            this.pool.length = 0;
            this.pool = null;
            this.state.dispose();
            this.state = null;
            this.psize = 0;
            this.pptr = 0;
            Memory.gc();
        }
        
        public function toString() : String {
            return "random-" + this.state.toString();
        }
    }
}
