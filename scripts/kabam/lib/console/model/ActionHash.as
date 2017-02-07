package kabam.lib.console.model {
    import org.osflash.signals.Signal;
    
    final class ActionHash {
         
        
        private var signalMap:Object;
        
        private var descriptionMap:Object;
        
        function ActionHash() {
            super();
            this.signalMap = {};
            this.descriptionMap = {};
        }
        
        public function register(param1:String, param2:String, param3:Signal) : void {
            this.signalMap[param1] = param3;
            this.descriptionMap[param1] = param2;
        }
        
        public function getNames() : Vector.<String> {
            var _local_2:* = null;
            var _local_1:Vector.<String> = new Vector.<String>(0);
            for(_local_2 in this.signalMap) {
                _local_1.push(_local_2 + " - " + this.descriptionMap[_local_2]);
            }
            return _local_1;
        }
        
        public function execute(param1:String) : void {
            var _local_2:Array = param1.split(" ");
            if(_local_2.length == 0) {
                return;
            }
            var _local_3:String = _local_2.shift();
            var _local_4:Signal = this.signalMap[_local_3];
            if(!_local_4) {
                return;
            }
            if(_local_2.length > 0) {
                _local_4.dispatch.apply(this,_local_2.join(" ").split(","));
            } else {
                _local_4.dispatch.apply(this);
            }
        }
        
        public function has(param1:String) : Boolean {
            var _local_2:Array = param1.split(" ");
            return _local_2.length > 0 && this.signalMap[_local_2[0]] != null;
        }
    }
}
