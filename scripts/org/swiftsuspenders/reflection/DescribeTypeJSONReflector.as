package org.swiftsuspenders.reflection {
    import avmplus.DescribeTypeJSON;
    import flash.utils.Dictionary;
    import flash.utils.getQualifiedClassName;
    import org.swiftsuspenders.InjectorError;
    import org.swiftsuspenders.typedescriptions.ConstructorInjectionPoint;
    import org.swiftsuspenders.typedescriptions.MethodInjectionPoint;
    import org.swiftsuspenders.typedescriptions.NoParamsConstructorInjectionPoint;
    import org.swiftsuspenders.typedescriptions.PostConstructInjectionPoint;
    import org.swiftsuspenders.typedescriptions.PreDestroyInjectionPoint;
    import org.swiftsuspenders.typedescriptions.PropertyInjectionPoint;
    import org.swiftsuspenders.typedescriptions.TypeDescription;
    
    public class DescribeTypeJSONReflector extends ReflectorBase implements Reflector {
         
        
        private const _descriptor:DescribeTypeJSON = new DescribeTypeJSON();
        
        public function DescribeTypeJSONReflector() {
            super();
        }
        
        public function typeImplements(param1:Class, param2:Class) : Boolean {
            if(param1 == param2) {
                return true;
            }
            var _local_3:String = getQualifiedClassName(param2);
            var _local_4:Object = this._descriptor.getInstanceDescription(param1).traits;
            return (_local_4.bases as Array).indexOf(_local_3) > -1 || (_local_4.interfaces as Array).indexOf(_local_3) > -1;
        }
        
        public function describeInjections(param1:Class) : TypeDescription {
            var _local_2:Object = null;
            _local_2 = this._descriptor.getInstanceDescription(param1);
            var _local_3:Object = _local_2.traits;
            var _local_4:String = _local_2.name;
            var _local_5:TypeDescription = new TypeDescription(false);
            this.addCtorInjectionPoint(_local_5,_local_3,_local_4);
            this.addFieldInjectionPoints(_local_5,_local_3.variables);
            this.addFieldInjectionPoints(_local_5,_local_3.accessors);
            this.addMethodInjectionPoints(_local_5,_local_3.methods,_local_4);
            this.addPostConstructMethodPoints(_local_5,_local_3.variables,_local_4);
            this.addPostConstructMethodPoints(_local_5,_local_3.accessors,_local_4);
            this.addPostConstructMethodPoints(_local_5,_local_3.methods,_local_4);
            this.addPreDestroyMethodPoints(_local_5,_local_3.methods,_local_4);
            return _local_5;
        }
        
        private function addCtorInjectionPoint(param1:TypeDescription, param2:Object, param3:String) : void {
            var _local_5:Dictionary = null;
            var _local_6:Array = null;
            var _local_4:Array = param2.constructor;
            if(!_local_4) {
                param1.ctor = param2.bases.length > 0?new NoParamsConstructorInjectionPoint():null;
                return;
            }
            _local_5 = this.extractTagParameters("Inject",param2.metadata);
            _local_6 = (_local_5 && _local_5.name || "").split(",");
            var _local_7:int = this.gatherMethodParameters(_local_4,_local_6,param3);
            param1.ctor = new ConstructorInjectionPoint(_local_4,_local_7,_local_5);
        }
        
        private function addMethodInjectionPoints(param1:TypeDescription, param2:Array, param3:String) : void {
            var _local_6:Object = null;
            var _local_7:Dictionary = null;
            var _local_8:* = false;
            var _local_9:Array = null;
            var _local_10:Array = null;
            var _local_11:uint = 0;
            var _local_12:MethodInjectionPoint = null;
            if(!param2) {
                return;
            }
            var _local_4:uint = param2.length;
            var _local_5:int = 0;
            while(_local_5 < _local_4) {
                _local_6 = param2[_local_5];
                _local_7 = this.extractTagParameters("Inject",_local_6.metadata);
                if(_local_7) {
                    _local_8 = _local_7.optional == "true";
                    _local_9 = (_local_7.name || "").split(",");
                    _local_10 = _local_6.parameters;
                    _local_11 = this.gatherMethodParameters(_local_10,_local_9,param3);
                    _local_12 = new MethodInjectionPoint(_local_6.name,_local_10,_local_11,_local_8,_local_7);
                    param1.addInjectionPoint(_local_12);
                }
                _local_5++;
            }
        }
        
        private function addPostConstructMethodPoints(param1:TypeDescription, param2:Array, param3:String) : void {
            var _local_4:Array = this.gatherOrderedInjectionPointsForTag(PostConstructInjectionPoint,"PostConstruct",param2,param3);
            var _local_5:int = 0;
            var _local_6:int = _local_4.length;
            while(_local_5 < _local_6) {
                param1.addInjectionPoint(_local_4[_local_5]);
                _local_5++;
            }
        }
        
        private function addPreDestroyMethodPoints(param1:TypeDescription, param2:Array, param3:String) : void {
            var _local_4:Array = this.gatherOrderedInjectionPointsForTag(PreDestroyInjectionPoint,"PreDestroy",param2,param3);
            if(!_local_4.length) {
                return;
            }
            param1.preDestroyMethods = _local_4[0];
            param1.preDestroyMethods.last = _local_4[0];
            var _local_5:int = 1;
            var _local_6:int = _local_4.length;
            while(_local_5 < _local_6) {
                param1.preDestroyMethods.last.next = _local_4[_local_5];
                param1.preDestroyMethods.last = _local_4[_local_5];
                _local_5++;
            }
        }
        
        private function addFieldInjectionPoints(param1:TypeDescription, param2:Array) : void {
            var _local_5:Object = null;
            var _local_6:Dictionary = null;
            var _local_7:String = null;
            var _local_8:* = false;
            var _local_9:PropertyInjectionPoint = null;
            if(!param2) {
                return;
            }
            var _local_3:uint = param2.length;
            var _local_4:int = 0;
            while(_local_4 < _local_3) {
                _local_5 = param2[_local_4];
                _local_6 = this.extractTagParameters("Inject",_local_5.metadata);
                if(_local_6) {
                    _local_7 = _local_6.name || "";
                    _local_8 = _local_6.optional == "true";
                    _local_9 = new PropertyInjectionPoint(_local_5.type + "|" + _local_7,_local_5.name,_local_8,_local_6);
                    param1.addInjectionPoint(_local_9);
                }
                _local_4++;
            }
        }
        
        private function gatherMethodParameters(param1:Array, param2:Array, param3:String) : uint {
            var _local_7:Object = null;
            var _local_8:String = null;
            var _local_9:String = null;
            var _local_4:uint = 0;
            var _local_5:uint = param1.length;
            var _local_6:int = 0;
            while(_local_6 < _local_5) {
                _local_7 = param1[_local_6];
                _local_8 = param2[_local_6] || "";
                _local_9 = _local_7.type;
                if(_local_9 == "*") {
                    if(!_local_7.optional) {
                        throw new InjectorError("Error in method definition of injectee \"" + param3 + ". Required parameters can\'t have type \"*\".");
                    }
                    _local_9 = null;
                }
                if(!_local_7.optional) {
                    _local_4++;
                }
                param1[_local_6] = _local_9 + "|" + _local_8;
                _local_6++;
            }
            return _local_4;
        }
        
        private function gatherOrderedInjectionPointsForTag(param1:Class, param2:String, param3:Array, param4:String) : Array {
            var _local_8:Object = null;
            var _local_9:Object = null;
            var _local_10:Array = null;
            var _local_11:Array = null;
            var _local_12:uint = 0;
            var _local_13:int = 0;
            var _local_5:Array = [];
            if(!param3) {
                return _local_5;
            }
            var _local_6:uint = param3.length;
            var _local_7:int = 0;
            while(_local_7 < _local_6) {
                _local_8 = param3[_local_7];
                _local_9 = this.extractTagParameters(param2,_local_8.metadata);
                if(_local_9) {
                    _local_10 = (_local_9.name || "").split(",");
                    _local_11 = _local_8.parameters;
                    if(_local_11) {
                        _local_12 = this.gatherMethodParameters(_local_11,_local_10,param4);
                    } else {
                        _local_11 = [];
                        _local_12 = 0;
                    }
                    _local_13 = parseInt(_local_9.order,10);
                    if(_local_13.toString(10) != _local_9.order) {
                        _local_13 = int.MAX_VALUE;
                    }
                    _local_5.push(new param1(_local_8.name,_local_11,_local_12,_local_13));
                }
                _local_7++;
            }
            if(_local_5.length > 0) {
                _local_5.sortOn("order",Array.NUMERIC);
            }
            return _local_5;
        }
        
        private function extractTagParameters(param1:String, param2:Array) : Dictionary {
            var _local_5:Object = null;
            var _local_6:Array = null;
            var _local_7:Dictionary = null;
            var _local_8:int = 0;
            var _local_9:int = 0;
            var _local_10:Object = null;
            var _local_3:uint = !!param2?uint(param2.length):uint(0);
            var _local_4:int = 0;
            while(_local_4 < _local_3) {
                _local_5 = param2[_local_4];
                if(_local_5.name == param1) {
                    _local_6 = _local_5.value;
                    _local_7 = new Dictionary();
                    _local_8 = _local_6.length;
                    _local_9 = 0;
                    while(_local_9 < _local_8) {
                        _local_10 = _local_6[_local_9];
                        _local_7[_local_10.key] = !!_local_7[_local_10.key]?_local_7[_local_10.key] + "," + _local_10.value:_local_10.value;
                        _local_9++;
                    }
                    return _local_7;
                }
                _local_4++;
            }
            return null;
        }
    }
}
