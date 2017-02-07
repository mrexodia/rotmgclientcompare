package kabam.lib.net.impl {
    public class MessagePool {
         
        
        public var type:Class;
        
        public var callback:Function;
        
        public var id:int;
        
        private var tail:Message;
        
        private var count:int = 0;
        
        public function MessagePool(param1:int, param2:Class, param3:Function) {
            super();
            this.type = param2;
            this.id = param1;
            this.callback = param3;
        }
        
        public function populate(param1:int) : MessagePool {
            var _local_2:Message = null;
            this.count = this.count + param1;
            while(param1--) {
                _local_2 = new this.type(this.id,this.callback);
                _local_2.pool = this;
                this.tail && (this.tail.next = _local_2);
                _local_2.prev = this.tail;
                this.tail = _local_2;
            }
            return this;
        }
        
        public function require() : Message {
            var _local_1:Message = this.tail;
            if(_local_1) {
                this.tail = this.tail.prev;
                _local_1.prev = null;
                _local_1.next = null;
            } else {
                _local_1 = new this.type(this.id,this.callback);
                _local_1.pool = this;
                this.count++;
            }
            return _local_1;
        }
        
        public function getCount() : int {
            return this.count;
        }
        
        function append(param1:Message) : void {
            this.tail && (this.tail.next = param1);
            param1.prev = this.tail;
            this.tail = param1;
        }
        
        public function dispose() : void {
            this.tail = null;
        }
    }
}
