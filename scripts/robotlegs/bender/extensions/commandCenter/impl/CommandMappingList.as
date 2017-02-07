package robotlegs.bender.extensions.commandCenter.impl {
    import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
    
    public class CommandMappingList {
         
        
        protected var _head:ICommandMapping;
        
        public function CommandMappingList() {
            super();
        }
        
        public function get head() : ICommandMapping {
            return this._head;
        }
        
        public function set head(param1:ICommandMapping) : void {
            if(param1 !== this._head) {
                this._head = param1;
            }
        }
        
        public function get tail() : ICommandMapping {
            if(!this._head) {
                return null;
            }
            var _local_1:ICommandMapping = this._head;
            while(_local_1.next) {
                _local_1 = _local_1.next;
            }
            return _local_1;
        }
        
        public function remove(param1:ICommandMapping) : void {
            var _local_2:ICommandMapping = this._head;
            if(_local_2 == param1) {
                this._head = param1.next;
            }
            while(_local_2) {
                if(_local_2.next == param1) {
                    _local_2.next = param1.next;
                }
                _local_2 = _local_2.next;
            }
        }
    }
}
