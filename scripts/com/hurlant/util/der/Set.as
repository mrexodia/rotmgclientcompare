package com.hurlant.util.der {
    public dynamic class Set extends Sequence implements IAsn1Type {
         
        
        public function Set(param1:uint = 49, param2:uint = 0) {
            super(param1,param2);
        }
        
        override public function toString() : String {
            var _local_1:String = null;
            _local_1 = DER.indent;
            DER.indent = DER.indent + "    ";
            var _local_2:String = join("\n");
            DER.indent = _local_1;
            return DER.indent + "Set[" + type + "][" + len + "][\n" + _local_2 + "\n" + _local_1 + "]";
        }
    }
}
