package com.company.assembleegameclient.map {
    import flash.utils.Dictionary;
    
    public class RegionLibrary {
        
        public static const xmlLibrary_:Dictionary = new Dictionary();
        
        public static var idToType_:Dictionary = new Dictionary();
         
        
        public function RegionLibrary() {
            super();
        }
        
        public static function parseFromXML(param1:XML) : void {
            var _local_2:XML = null;
            var _local_3:int = 0;
            for each(_local_2 in param1.Region) {
                _local_3 = int(_local_2.@type);
                xmlLibrary_[_local_3] = _local_2;
                idToType_[String(_local_2.@id)] = _local_3;
            }
        }
        
        public static function getIdFromType(param1:int) : String {
            var _local_2:XML = xmlLibrary_[param1];
            if(_local_2 == null) {
                return null;
            }
            return String(_local_2.@id);
        }
        
        public static function getColor(param1:int) : uint {
            var _local_2:XML = xmlLibrary_[param1];
            if(_local_2 == null) {
                return 0;
            }
            return uint(_local_2.Color);
        }
    }
}
