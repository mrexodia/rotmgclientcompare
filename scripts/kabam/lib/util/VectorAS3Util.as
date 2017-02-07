package kabam.lib.util {
    public class VectorAS3Util {
         
        
        public function VectorAS3Util() {
            super();
        }
        
        public static function toArray(param1:Object) : Array {
            var _local_3:Object = null;
            var _local_2:Array = [];
            for each(_local_3 in param1) {
                _local_2.push(_local_3);
            }
            return _local_2;
        }
    }
}
