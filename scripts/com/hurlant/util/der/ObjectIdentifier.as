package com.hurlant.util.der {
    import flash.net.registerClassAlias;
    import flash.utils.ByteArray;
    
    public class ObjectIdentifier implements IAsn1Type {
         {
            registerClassAlias("com.hurlant.util.der.ObjectIdentifier",ObjectIdentifier);
        }
        
        private var type:uint;
        
        private var len:uint;
        
        private var oid:Array;
        
        public function ObjectIdentifier(param1:uint = 0, param2:uint = 0, param3:* = null) {
            super();
            this.type = param1;
            this.len = param2;
            if(param3 is ByteArray) {
                this.parse(param3 as ByteArray);
            } else if(param3 is String) {
                this.generate(param3 as String);
            } else {
                throw new Error("Invalid call to new ObjectIdentifier");
            }
        }
        
        private function generate(param1:String) : void {
            this.oid = param1.split(".");
        }
        
        private function parse(param1:ByteArray) : void {
            var _local_5:* = false;
            var _local_2:uint = param1.readUnsignedByte();
            var _local_3:Array = [];
            _local_3.push(uint(_local_2 / 40));
            _local_3.push(uint(_local_2 % 40));
            var _local_4:uint = 0;
            while(param1.bytesAvailable > 0) {
                _local_2 = param1.readUnsignedByte();
                _local_5 = (_local_2 & 128) == 0;
                _local_2 = _local_2 & 127;
                _local_4 = _local_4 * 128 + _local_2;
                if(_local_5) {
                    _local_3.push(_local_4);
                    _local_4 = 0;
                }
            }
            this.oid = _local_3;
        }
        
        public function getLength() : uint {
            return this.len;
        }
        
        public function getType() : uint {
            return this.type;
        }
        
        public function toDER() : ByteArray {
            var _local_4:int = 0;
            var _local_1:Array = [];
            _local_1[0] = this.oid[0] * 40 + this.oid[1];
            var _local_2:int = 2;
            while(_local_2 < this.oid.length) {
                _local_4 = parseInt(this.oid[_local_2]);
                if(_local_4 < 128) {
                    _local_1.push(_local_4);
                } else if(_local_4 < 128 * 128) {
                    _local_1.push(_local_4 >> 7 | 128);
                    _local_1.push(_local_4 & 127);
                } else if(_local_4 < 128 * 128 * 128) {
                    _local_1.push(_local_4 >> 14 | 128);
                    _local_1.push(_local_4 >> 7 & 127 | 128);
                    _local_1.push(_local_4 & 127);
                } else if(_local_4 < 128 * 128 * 128 * 128) {
                    _local_1.push(_local_4 >> 21 | 128);
                    _local_1.push(_local_4 >> 14 & 127 | 128);
                    _local_1.push(_local_4 >> 7 & 127 | 128);
                    _local_1.push(_local_4 & 127);
                } else {
                    throw new Error("OID element bigger than we thought. :(");
                }
                _local_2++;
            }
            this.len = _local_1.length;
            if(this.type == 0) {
                this.type = 6;
            }
            _local_1.unshift(this.len);
            _local_1.unshift(this.type);
            var _local_3:ByteArray = new ByteArray();
            _local_2 = 0;
            while(_local_2 < _local_1.length) {
                _local_3[_local_2] = _local_1[_local_2];
                _local_2++;
            }
            return _local_3;
        }
        
        public function toString() : String {
            return DER.indent + this.oid.join(".");
        }
        
        public function dump() : String {
            return "OID[" + this.type + "][" + this.len + "][" + this.toString() + "]";
        }
    }
}
