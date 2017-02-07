package robotlegs.bender.extensions.logging.impl {
    public class LogMessageParser {
         
        
        public function LogMessageParser() {
            super();
        }
        
        public function parseMessage(param1:String, param2:Array) : String {
            var _local_3:int = 0;
            var _local_4:int = 0;
            if(param2) {
                _local_3 = param2.length;
                _local_4 = 0;
                while(_local_4 < _local_3) {
                    param1 = param1.split("{" + _local_4 + "}").join(param2[_local_4]);
                    _local_4++;
                }
            }
            return param1;
        }
    }
}
