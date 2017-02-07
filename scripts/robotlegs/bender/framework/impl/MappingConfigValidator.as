package robotlegs.bender.framework.impl {
    import robotlegs.bender.framework.api.MappingConfigError;
    
    public class MappingConfigValidator {
         
        
        private const CANT_CHANGE_GUARDS_AND_HOOKS:String = "You can\'t change the guards and hooks on an existing mapping. Unmap first.";
        
        private const STORED_ERROR_EXPLANATION:String = " The stacktrace for this error was stored at the time when you duplicated the mapping - you may have failed to add guards and hooks that were already present.";
        
        private var _guards:Array;
        
        private var _hooks:Array;
        
        private var _trigger;
        
        private var _action;
        
        private var _storedError:MappingConfigError;
        
        private var _valid:Boolean = false;
        
        public function MappingConfigValidator(param1:Array, param2:Array, param3:*, param4:*) {
            this._guards = param1;
            this._hooks = param2;
            this._trigger = param3;
            this._action = param4;
            super();
        }
        
        public function get valid() : Boolean {
            return this._valid;
        }
        
        public function invalidate() : void {
            this._valid = false;
            this._storedError = new MappingConfigError(this.CANT_CHANGE_GUARDS_AND_HOOKS + this.STORED_ERROR_EXPLANATION,this._trigger,this._action);
        }
        
        public function validate(param1:Array, param2:Array) : void {
            if(!this.arraysMatch(this._guards,param1) || !this.arraysMatch(this._hooks,param2)) {
                this.throwStoredError() || this.throwMappingError();
            }
            this._valid = true;
            this._storedError = null;
        }
        
        public function checkGuards(param1:Array) : void {
            if(this.changesContent(this._guards,param1)) {
                this.throwMappingError();
            }
        }
        
        public function checkHooks(param1:Array) : void {
            if(this.changesContent(this._hooks,param1)) {
                this.throwMappingError();
            }
        }
        
        private function changesContent(param1:Array, param2:Array) : Boolean {
            var _local_3:* = undefined;
            param2 = this.flatten(param2);
            for each(_local_3 in param2) {
                if(param1.indexOf(_local_3) == -1) {
                    return true;
                }
            }
            return false;
        }
        
        private function arraysMatch(param1:Array, param2:Array) : Boolean {
            var _local_3:int = 0;
            param1 = param1.slice();
            if(param1.length != param2.length) {
                return false;
            }
            var _local_4:uint = param2.length;
            var _local_5:uint = 0;
            while(_local_5 < _local_4) {
                _local_3 = param1.indexOf(param2[_local_5]);
                if(_local_3 == -1) {
                    return false;
                }
                param1.splice(_local_3,1);
                _local_5++;
            }
            return true;
        }
        
        public function flatten(param1:Array) : Array {
            var _local_3:* = undefined;
            var _local_2:Array = [];
            for each(_local_3 in param1) {
                if(_local_3 is Array) {
                    _local_2 = _local_2.concat(this.flatten(_local_3 as Array));
                } else {
                    _local_2.push(_local_3);
                }
            }
            return _local_2;
        }
        
        private function throwMappingError() : void {
            throw new MappingConfigError(this.CANT_CHANGE_GUARDS_AND_HOOKS,this._trigger,this._action);
        }
        
        private function throwStoredError() : Boolean {
            if(this._storedError) {
                throw this._storedError;
            }
            return false;
        }
    }
}
