package com.hurlant.util.der {
    import flash.utils.ByteArray;
    
    public dynamic class Sequence extends Array implements IAsn1Type {
         
        
        protected var type:uint;
        
        protected var len:uint;
        
        public function Sequence(param1:uint = 48, param2:uint = 0) {
            super();
            this.type = param1;
            this.len = param2;
        }
        
        public function getLength() : uint {
            return this.len;
        }
        
        public function getType() : uint {
            return this.type;
        }
        
        public function toDER() : ByteArray {
            var _local_3:IAsn1Type = null;
            var _local_1:ByteArray = new ByteArray();
            var _local_2:int = 0;
            while(_local_2 < length) {
                _local_3 = this[_local_2];
                if(_local_3 == null) {
                    _local_1.writeByte(5);
                    _local_1.writeByte(0);
                } else {
                    _local_1.writeBytes(_local_3.toDER());
                }
                _local_2++;
            }
            return DER.wrapDER(this.type,_local_1);
        }
        
        public function toString() : String {
            var _local_4:Boolean = false;
            var _local_5:* = null;
            var _local_1:String = DER.indent;
            DER.indent = DER.indent + "    ";
            var _local_2:String = "";
            var _local_3:int = 0;
            while(_local_3 < length) {
                if(this[_local_3] != null) {
                    _local_4 = false;
                    for(_local_5 in this) {
                        if(_local_3.toString() != _local_5 && this[_local_3] == this[_local_5]) {
                            _local_2 = _local_2 + (_local_5 + ": " + this[_local_3] + "\n");
                            _local_4 = true;
                            break;
                        }
                    }
                    if(!_local_4) {
                        _local_2 = _local_2 + (this[_local_3] + "\n");
                    }
                }
                _local_3++;
            }
            DER.indent = _local_1;
            return DER.indent + "Sequence[" + this.type + "][" + this.len + "][\n" + _local_2 + "\n" + _local_1 + "]";
        }
        
        public function findAttributeValue(param1:String) : IAsn1Type {
            var _local_2:* = undefined;
            var _local_3:* = undefined;
            var _local_4:* = undefined;
            var _local_5:ObjectIdentifier = null;
            for each(_local_2 in this) {
                if(_local_2 is Set) {
                    _local_3 = _local_2[0];
                    if(_local_3 is Sequence) {
                        _local_4 = _local_3[0];
                        if(_local_4 is ObjectIdentifier) {
                            _local_5 = _local_4 as ObjectIdentifier;
                            if(_local_5.toString() == param1) {
                                return _local_3[1] as IAsn1Type;
                            }
                        }
                    }
                }
            }
            return null;
        }
    }
}
