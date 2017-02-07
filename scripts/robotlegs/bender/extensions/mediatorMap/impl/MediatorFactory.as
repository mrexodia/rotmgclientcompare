package robotlegs.bender.extensions.mediatorMap.impl {
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    import org.swiftsuspenders.Injector;
    import robotlegs.bender.extensions.matching.ITypeFilter;
    import robotlegs.bender.extensions.mediatorMap.api.IMediatorFactory;
    import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
    import robotlegs.bender.extensions.mediatorMap.api.MediatorFactoryEvent;
    import robotlegs.bender.framework.impl.applyHooks;
    import robotlegs.bender.framework.impl.guardsApprove;
    
    public class MediatorFactory extends EventDispatcher implements IMediatorFactory {
         
        
        private const _mediators:Dictionary = new Dictionary();
        
        private var _injector:Injector;
        
        public function MediatorFactory(param1:Injector) {
            super();
            this._injector = param1;
        }
        
        public function getMediator(param1:Object, param2:IMediatorMapping) : Object {
            return !!this._mediators[param1]?this._mediators[param1][param2]:null;
        }
        
        public function createMediators(param1:Object, param2:Class, param3:Array) : Array {
            var _local_5:ITypeFilter = null;
            var _local_6:Object = null;
            var _local_7:IMediatorMapping = null;
            var _local_4:Array = [];
            for each(_local_7 in param3) {
                _local_6 = this.getMediator(param1,_local_7);
                if(!_local_6) {
                    _local_5 = _local_7.matcher;
                    this.mapTypeForFilterBinding(_local_5,param2,param1);
                    _local_6 = this.createMediator(param1,_local_7);
                    this.unmapTypeForFilterBinding(_local_5,param2,param1);
                }
                if(_local_6) {
                    _local_4.push(_local_6);
                }
            }
            return _local_4;
        }
        
        public function removeMediators(param1:Object) : void {
            var _local_3:* = null;
            var _local_2:Dictionary = this._mediators[param1];
            if(!_local_2) {
                return;
            }
            if(hasEventListener(MediatorFactoryEvent.MEDIATOR_REMOVE)) {
                for(_local_3 in _local_2) {
                    dispatchEvent(new MediatorFactoryEvent(MediatorFactoryEvent.MEDIATOR_REMOVE,_local_2[_local_3],param1,_local_3 as IMediatorMapping,this));
                }
            }
            delete this._mediators[param1];
        }
        
        public function removeAllMediators() : void {
            var _local_1:* = null;
            for(_local_1 in this._mediators) {
                this.removeMediators(_local_1);
            }
        }
        
        private function createMediator(param1:Object, param2:IMediatorMapping) : Object {
            var _local_3:Object = this.getMediator(param1,param2);
            if(_local_3) {
                return _local_3;
            }
            if(guardsApprove(param2.guards,this._injector)) {
                _local_3 = this._injector.getInstance(param2.mediatorClass);
                this._injector.map(param2.mediatorClass).toValue(_local_3);
                applyHooks(param2.hooks,this._injector);
                this._injector.unmap(param2.mediatorClass);
                this.addMediator(_local_3,param1,param2);
            }
            return _local_3;
        }
        
        private function addMediator(param1:Object, param2:Object, param3:IMediatorMapping) : void {
            this._mediators[param2] = this._mediators[param2] || new Dictionary();
            this._mediators[param2][param3] = param1;
            if(hasEventListener(MediatorFactoryEvent.MEDIATOR_CREATE)) {
                dispatchEvent(new MediatorFactoryEvent(MediatorFactoryEvent.MEDIATOR_CREATE,param1,param2,param3,this));
            }
        }
        
        private function mapTypeForFilterBinding(param1:ITypeFilter, param2:Class, param3:Object) : void {
            var _local_4:Class = null;
            var _local_5:Vector.<Class> = this.requiredTypesFor(param1,param2);
            for each(_local_4 in _local_5) {
                this._injector.map(_local_4).toValue(param3);
            }
        }
        
        private function unmapTypeForFilterBinding(param1:ITypeFilter, param2:Class, param3:Object) : void {
            var _local_4:Class = null;
            var _local_5:Vector.<Class> = this.requiredTypesFor(param1,param2);
            for each(_local_4 in _local_5) {
                if(this._injector.satisfiesDirectly(_local_4)) {
                    this._injector.unmap(_local_4);
                }
            }
        }
        
        private function requiredTypesFor(param1:ITypeFilter, param2:Class) : Vector.<Class> {
            var _local_3:Vector.<Class> = param1.allOfTypes.concat(param1.anyOfTypes);
            if(_local_3.indexOf(param2) == -1) {
                _local_3.push(param2);
            }
            return _local_3;
        }
    }
}
