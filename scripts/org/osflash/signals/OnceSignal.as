package org.osflash.signals {
    import flash.errors.IllegalOperationError;
    import flash.utils.getQualifiedClassName;
    
    public class OnceSignal implements IOnceSignal {
         
        
        protected var _valueClasses:Array;
        
        protected var slots:SlotList;
        
        public function OnceSignal(... rest) {
            this.slots = SlotList.NIL;
            super();
            this.valueClasses = rest.length == 1 && rest[0] is Array?rest[0]:rest;
        }
        
        [ArrayElementType("Class")]
        public function get valueClasses() : Array {
            return this._valueClasses;
        }
        
        public function set valueClasses(param1:Array) : void {
            this._valueClasses = !!param1?param1.slice():[];
            var _local_2:int = this._valueClasses.length;
            while(_local_2--) {
                if(!(this._valueClasses[_local_2] is Class)) {
                    throw new ArgumentError("Invalid valueClasses argument: " + "item at index " + _local_2 + " should be a Class but was:<" + this._valueClasses[_local_2] + ">." + getQualifiedClassName(this._valueClasses[_local_2]));
                }
            }
        }
        
        public function get numListeners() : uint {
            return this.slots.length;
        }
        
        public function addOnce(param1:Function) : ISlot {
            return this.registerListener(param1,true);
        }
        
        public function remove(param1:Function) : ISlot {
            var _local_2:ISlot = this.slots.find(param1);
            if(!_local_2) {
                return null;
            }
            this.slots = this.slots.filterNot(param1);
            return _local_2;
        }
        
        public function removeAll() : void {
            this.slots = SlotList.NIL;
        }
        
        public function dispatch(... rest) : void {
            var _local_2:int = this._valueClasses.length;
            var _local_3:int = rest.length;
            if(_local_3 < _local_2) {
                throw new ArgumentError("Incorrect number of arguments. " + "Expected at least " + _local_2 + " but received " + _local_3 + ".");
            }
            var _local_4:int = 0;
            while(_local_4 < _local_2) {
                if(rest[_local_4] is this._valueClasses[_local_4] || rest[_local_4] === null) {
                    _local_4++;
                    continue;
                }
                throw new ArgumentError("Value object <" + rest[_local_4] + "> is not an instance of <" + this._valueClasses[_local_4] + ">.");
            }
            var _local_5:SlotList = this.slots;
            if(_local_5.nonEmpty) {
                while(_local_5.nonEmpty) {
                    _local_5.head.execute(rest);
                    _local_5 = _local_5.tail;
                }
            }
        }
        
        protected function registerListener(param1:Function, param2:Boolean = false) : ISlot {
            var _local_3:ISlot = null;
            if(this.registrationPossible(param1,param2)) {
                _local_3 = new Slot(param1,this,param2);
                this.slots = this.slots.prepend(_local_3);
                return _local_3;
            }
            return this.slots.find(param1);
        }
        
        protected function registrationPossible(param1:Function, param2:Boolean) : Boolean {
            if(!this.slots.nonEmpty) {
                return true;
            }
            var _local_3:ISlot = this.slots.find(param1);
            if(!_local_3) {
                return true;
            }
            if(_local_3.once != param2) {
                throw new IllegalOperationError("You cannot addOnce() then add() the same listener without removing the relationship first.");
            }
            return false;
        }
    }
}
