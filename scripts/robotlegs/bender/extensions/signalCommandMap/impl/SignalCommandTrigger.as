package robotlegs.bender.extensions.signalCommandMap.impl {
    import flash.utils.Dictionary;
    import flash.utils.describeType;
    import org.osflash.signals.ISignal;
    import org.swiftsuspenders.Injector;
    import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
    import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
    import robotlegs.bender.framework.impl.applyHooks;
    import robotlegs.bender.framework.impl.guardsApprove;
    
    public class SignalCommandTrigger implements ICommandTrigger {
         
        
        private const _mappings:Vector.<ICommandMapping> = new Vector.<ICommandMapping>();
        
        private var _signal:ISignal;
        
        private var _signalClass:Class;
        
        private var _once:Boolean;
        
        protected var _injector:Injector;
        
        protected var _signalMap:Dictionary;
        
        protected var _verifiedCommandClasses:Dictionary;
        
        public function SignalCommandTrigger(param1:Injector, param2:Class, param3:Boolean = false) {
            super();
            this._injector = param1;
            this._signalClass = param2;
            this._once = param3;
            this._signalMap = new Dictionary(false);
            this._verifiedCommandClasses = new Dictionary(false);
        }
        
        public function addMapping(param1:ICommandMapping) : void {
            this.verifyCommandClass(param1);
            this._mappings.push(param1);
            if(this._mappings.length == 1) {
                this.addSignal(param1.commandClass);
            }
        }
        
        public function removeMapping(param1:ICommandMapping) : void {
            var _local_2:int = this._mappings.indexOf(param1);
            if(_local_2 != -1) {
                this._mappings.splice(_local_2,1);
                if(this._mappings.length == 0) {
                    this.removeSignal(param1.commandClass);
                }
            }
        }
        
        protected function verifyCommandClass(param1:ICommandMapping) : void {
            var mapping:ICommandMapping = param1;
            if(this._verifiedCommandClasses[mapping.commandClass]) {
                return;
            }
            if(describeType(mapping.commandClass).factory.method.(@name == "execute").length() == 0) {
                throw new Error("Command Class must expose an execute method");
            }
            this._verifiedCommandClasses[mapping.commandClass] = true;
        }
        
        protected function routeSignalToCommand(param1:ISignal, param2:Array, param3:Class, param4:Boolean) : void {
            var _local_6:ICommandMapping = null;
            var _local_7:Boolean = false;
            var _local_8:Object = null;
            var _local_5:Vector.<ICommandMapping> = this._mappings.concat();
            for each(_local_6 in _local_5) {
                this.mapSignalValues(param1.valueClasses,param2);
                _local_7 = guardsApprove(_local_6.guards,this._injector);
                if(_local_7) {
                    this._once && this.removeMapping(_local_6);
                    this._injector.map(_local_6.commandClass).asSingleton();
                    _local_8 = this._injector.getInstance(_local_6.commandClass);
                    applyHooks(_local_6.hooks,this._injector);
                    this._injector.unmap(_local_6.commandClass);
                }
                this.unmapSignalValues(param1.valueClasses,param2);
                if(_local_7) {
                    _local_8.execute();
                }
            }
            if(this._once) {
                this.removeSignal(param3);
            }
        }
        
        protected function mapSignalValues(param1:Array, param2:Array) : void {
            var _local_3:uint = 0;
            while(_local_3 < param1.length) {
                this._injector.map(param1[_local_3]).toValue(param2[_local_3]);
                _local_3++;
            }
        }
        
        protected function unmapSignalValues(param1:Array, param2:Array) : void {
            var _local_3:uint = 0;
            while(_local_3 < param1.length) {
                this._injector.unmap(param1[_local_3]);
                _local_3++;
            }
        }
        
        protected function hasSignalCommand(param1:ISignal, param2:Class) : Boolean {
            var _local_3:Dictionary = this._signalMap[param1];
            if(_local_3 == null) {
                return false;
            }
            var _local_4:Function = _local_3[param2];
            return _local_4 != null;
        }
        
        private function addSignal(param1:Class) : void {
            var commandClass:Class = param1;
            if(this.hasSignalCommand(this._signal,commandClass)) {
                return;
            }
            this._signal = this._injector.getInstance(this._signalClass);
            this._injector.map(this._signalClass).toValue(this._signal);
            var signalCommandMap:Dictionary = this._signalMap[this._signal] = this._signalMap[this._signal] || new Dictionary(false);
            var callback:Function = function():void {
                routeSignalToCommand(_signal,arguments,commandClass,_once);
            };
            signalCommandMap[commandClass] = callback;
            this._signal.add(callback);
        }
        
        private function removeSignal(param1:Class) : void {
            var _local_2:Dictionary = this._signalMap[this._signal];
            if(_local_2 == null) {
                return;
            }
            var _local_3:Function = _local_2[param1];
            if(_local_3 == null) {
                return;
            }
            this._signal.remove(_local_3);
            delete _local_2[param1];
        }
    }
}
