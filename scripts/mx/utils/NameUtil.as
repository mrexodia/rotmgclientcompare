package mx.utils {
    import flash.display.DisplayObject;
    import flash.utils.getQualifiedClassName;
    import mx.core.IRepeaterClient;
    import mx.core.mx_internal;
    
    use namespace mx_internal;
    
    public class NameUtil {
        
        mx_internal static const VERSION:String = "4.6.0.23201";
        
        private static var counter:int = 0;
         
        
        public function NameUtil() {
            super();
        }
        
        public static function createUniqueName(param1:Object) : String {
            if(!param1) {
                return null;
            }
            var _local_2:* = getQualifiedClassName(param1);
            var _local_3:int = _local_2.indexOf("::");
            if(_local_3 != -1) {
                _local_2 = _local_2.substr(_local_3 + 2);
            }
            var _local_4:int = _local_2.charCodeAt(_local_2.length - 1);
            if(_local_4 >= 48 && _local_4 <= 57) {
                _local_2 = _local_2 + "_";
            }
            return _local_2 + counter++;
        }
        
        public static function displayObjectToString(param1:DisplayObject) : String {
            var _local_2:String = null;
            var _local_3:DisplayObject = null;
            var _local_4:String = null;
            var _local_5:Array = null;
            try {
                _local_3 = param1;
                while(_local_3 != null) {
                    if(_local_3.parent && _local_3.stage && _local_3.parent == _local_3.stage) {
                        break;
                    }
                    _local_4 = "id" in _local_3 && _local_3["id"]?_local_3["id"]:_local_3.name;
                    if(_local_3 is IRepeaterClient) {
                        _local_5 = IRepeaterClient(_local_3).instanceIndices;
                        if(_local_5) {
                            _local_4 = _local_4 + ("[" + _local_5.join("][") + "]");
                        }
                    }
                    _local_2 = _local_2 == null?_local_4:_local_4 + "." + _local_2;
                    _local_3 = _local_3.parent;
                }
            }
            catch(e:SecurityError) {
            }
            return _local_2;
        }
        
        public static function getUnqualifiedClassName(param1:Object) : String {
            var _local_2:String = null;
            if(param1 is String) {
                _local_2 = param1 as String;
            } else {
                _local_2 = getQualifiedClassName(param1);
            }
            var _local_3:int = _local_2.indexOf("::");
            if(_local_3 != -1) {
                _local_2 = _local_2.substr(_local_3 + 2);
            }
            return _local_2;
        }
    }
}
