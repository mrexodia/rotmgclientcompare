package org.osflash.signals.natives {
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.utils.getQualifiedClassName;
    import org.osflash.signals.SlotList;
    
    public class NativeMappedSignal extends NativeRelaySignal {
         
        
        private var _mappingFunction:Function = null;
        
        public function NativeMappedSignal(param1:IEventDispatcher, param2:String, param3:Class = null, ... rest) {
            super(param1,param2,param3);
            this.valueClasses = rest;
        }
        
        protected function get mappingFunction() : Function {
            return this._mappingFunction;
        }
        
        override public function get eventClass() : Class {
            return _eventClass;
        }
        
        override public function set eventClass(param1:Class) : void {
            _eventClass = param1;
        }
        
        override public function set valueClasses(param1:Array) : void {
            _valueClasses = !!param1?param1.slice():[];
            var _local_2:int = _valueClasses.length;
            while(_local_2--) {
                if(!(_valueClasses[_local_2] is Class)) {
                    throw new ArgumentError("Invalid valueClasses argument: " + "item at index " + _local_2 + " should be a Class but was:<" + _valueClasses[_local_2] + ">." + getQualifiedClassName(_valueClasses[_local_2]));
                }
            }
        }
        
        public function mapTo(... rest) : NativeMappedSignal {
            var objectListOrFunction:Array = rest;
            if(objectListOrFunction.length == 1 && objectListOrFunction[0] is Function) {
                this._mappingFunction = objectListOrFunction[0] as Function;
                if(this._mappingFunction.length > 1) {
                    throw new ArgumentError("Mapping function has " + this._mappingFunction.length + " arguments but it needs zero or one of type Event");
                }
            } else {
                this._mappingFunction = function():Object {
                    return objectListOrFunction;
                };
            }
            return this;
        }
        
        protected function mapEvent(param1:Event) : Object {
            if(this.mappingFunction != null) {
                if(this.mappingFunction.length == 1) {
                    return this.mappingFunction(param1);
                }
                return this.mappingFunction();
            }
            if(valueClasses.length == 0) {
                return [];
            }
            throw new ArgumentError("There are valueClasses set to be dispatched <" + valueClasses + "> but mappingFunction is null.");
        }
        
        override public function dispatchEvent(param1:Event) : Boolean {
            var _local_4:Array = null;
            var _local_5:Object = null;
            var _local_6:Class = null;
            var _local_7:int = 0;
            var _local_2:Object = this.mapEvent(param1);
            var _local_3:int = valueClasses.length;
            if(_local_2 is Array) {
                _local_4 = _local_2 as Array;
                _local_7 = 0;
                while(_local_7 < _local_3) {
                    _local_5 = _local_4[_local_7];
                    _local_6 = valueClasses[_local_7];
                    if(_local_5 === null || _local_5 is _local_6) {
                        _local_7++;
                        continue;
                    }
                    throw new ArgumentError("Value object <" + _local_5 + "> is not an instance of <" + _local_6 + ">.");
                }
            } else {
                if(_local_3 > 1) {
                    throw new ArgumentError("Expected more than one value.");
                }
                if(!(_local_2 is valueClasses[0])) {
                    throw new ArgumentError("Mapping returned " + getQualifiedClassName(_local_2) + ", expected " + valueClasses[0] + ".");
                }
            }
            return super.dispatchEvent(param1);
        }
        
        override protected function onNativeEvent(param1:Event) : void {
            var _local_4:Array = null;
            var _local_2:Object = this.mapEvent(param1);
            var _local_3:SlotList = slots;
            if(_local_2 is Array) {
                if(valueClasses.length == 1 && valueClasses[0] == Array) {
                    while(_local_3.nonEmpty) {
                        _local_3.head.execute1(_local_2);
                        _local_3 = _local_3.tail;
                    }
                } else {
                    _local_4 = _local_2 as Array;
                    while(_local_3.nonEmpty) {
                        _local_3.head.execute(_local_4);
                        _local_3 = _local_3.tail;
                    }
                }
            } else {
                while(_local_3.nonEmpty) {
                    _local_3.head.execute1(_local_2);
                    _local_3 = _local_3.tail;
                }
            }
        }
    }
}
