package org.swiftsuspenders.typedescriptions {
    import avmplus.getQualifiedClassName;
    import flash.utils.Dictionary;
    import org.swiftsuspenders.Injector;
    import org.swiftsuspenders.dependencyproviders.DependencyProvider;
    import org.swiftsuspenders.errors.InjectorMissingMappingError;
    import org.swiftsuspenders.utils.SsInternal;
    
    public class MethodInjectionPoint extends InjectionPoint {
        
        private static const _parameterValues:Array = [];
         
        
        protected var _parameterMappingIDs:Array;
        
        protected var _requiredParameters:int;
        
        private var _isOptional:Boolean;
        
        private var _methodName:String;
        
        public function MethodInjectionPoint(param1:String, param2:Array, param3:uint, param4:Boolean, param5:Dictionary) {
            super();
            this._methodName = param1;
            this._parameterMappingIDs = param2;
            this._requiredParameters = param3;
            this._isOptional = param4;
            this.injectParameters = param5;
        }
        
        override public function applyInjection(param1:Object, param2:Class, param3:Injector) : void {
            var _local_4:Array = this.gatherParameterValues(param1,param2,param3);
            if(_local_4.length >= this._requiredParameters) {
                (param1[this._methodName] as Function).apply(param1,_local_4);
            }
            _local_4.length = 0;
        }
        
        protected function gatherParameterValues(param1:Object, param2:Class, param3:Injector) : Array {
            var _local_7:String = null;
            var _local_8:DependencyProvider = null;
            var _local_4:int = this._parameterMappingIDs.length;
            var _local_5:Array = _parameterValues;
            _local_5.length = _local_4;
            var _local_6:int = 0;
            while(_local_6 < _local_4) {
                _local_7 = this._parameterMappingIDs[_local_6];
                _local_8 = param3.SsInternal::getProvider(_local_7);
                if(!_local_8) {
                    if(_local_6 >= this._requiredParameters || this._isOptional) {
                        break;
                    }
                    throw new InjectorMissingMappingError("Injector is missing a mapping to handle injection into target \"" + param1 + "\" of type \"" + getQualifiedClassName(param2) + "\". \t\t\t\t\t\tTarget dependency: " + _local_7 + ", method: " + this._methodName + ", parameter: " + (_local_6 + 1));
                }
                _local_5[_local_6] = _local_8.apply(param2,param3,injectParameters);
                _local_6++;
            }
            return _local_5;
        }
    }
}
