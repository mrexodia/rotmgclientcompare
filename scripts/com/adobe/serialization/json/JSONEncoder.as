package com.adobe.serialization.json {
    import flash.utils.describeType;
    
    public class JSONEncoder {
         
        
        private var jsonString:String;
        
        public function JSONEncoder(param1:*) {
            super();
            this.jsonString = this.convertToString(param1);
        }
        
        public function getString() : String {
            return this.jsonString;
        }
        
        private function convertToString(param1:*) : String {
            if(param1 is String) {
                return this.escapeString(param1 as String);
            }
            if(param1 is Number) {
                return !!isFinite(param1 as Number)?param1.toString():"null";
            }
            if(param1 is Boolean) {
                return !!param1?"true":"false";
            }
            if(param1 is Array) {
                return this.arrayToString(param1 as Array);
            }
            if(param1 is Object && param1 != null) {
                return this.objectToString(param1);
            }
            return "null";
        }
        
        private function escapeString(param1:String) : String {
            var _local_3:String = null;
            var _local_6:String = null;
            var _local_7:String = null;
            var _local_2:* = "";
            var _local_4:Number = param1.length;
            var _local_5:int = 0;
            while(_local_5 < _local_4) {
                _local_3 = param1.charAt(_local_5);
                switch(_local_3) {
                    case "\"":
                        _local_2 = _local_2 + "\\\"";
                        break;
                    case "\\":
                        _local_2 = _local_2 + "\\\\";
                        break;
                    case "\b":
                        _local_2 = _local_2 + "\\b";
                        break;
                    case "\f":
                        _local_2 = _local_2 + "\\f";
                        break;
                    case "\n":
                        _local_2 = _local_2 + "\\n";
                        break;
                    case "\r":
                        _local_2 = _local_2 + "\\r";
                        break;
                    case "\t":
                        _local_2 = _local_2 + "\\t";
                        break;
                    default:
                        if(_local_3 < " ") {
                            _local_6 = _local_3.charCodeAt(0).toString(16);
                            _local_7 = _local_6.length == 2?"00":"000";
                            _local_2 = _local_2 + ("\\u" + _local_7 + _local_6);
                        } else {
                            _local_2 = _local_2 + _local_3;
                        }
                }
                _local_5++;
            }
            return "\"" + _local_2 + "\"";
        }
        
        private function arrayToString(param1:Array) : String {
            var _local_2:* = "";
            var _local_3:int = 0;
            while(_local_3 < param1.length) {
                if(_local_2.length > 0) {
                    _local_2 = _local_2 + ",";
                }
                _local_2 = _local_2 + this.convertToString(param1[_local_3]);
                _local_3++;
            }
            return "[" + _local_2 + "]";
        }
        
        private function objectToString(param1:Object) : String {
            var value:Object = null;
            var key:String = null;
            var v:XML = null;
            var o:Object = param1;
            var s:String = "";
            var classInfo:XML = describeType(o);
            if(classInfo.@name.toString() == "Object") {
                for(key in o) {
                    value = o[key];
                    if(!(value is Function)) {
                        if(s.length > 0) {
                            s = s + ",";
                        }
                        s = s + (this.escapeString(key) + ":" + this.convertToString(value));
                    }
                }
            } else {
                for each(v in classInfo..*.(name() == "variable" || name() == "accessor")) {
                    if(s.length > 0) {
                        s = s + ",";
                    }
                    s = s + (this.escapeString(v.@name.toString()) + ":" + this.convertToString(o[v.@name]));
                }
            }
            return "{" + s + "}";
        }
    }
}
