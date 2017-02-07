package robotlegs.bender.extensions.eventCommandMap.impl {
    import org.swiftsuspenders.Injector;
    import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
    import robotlegs.bender.framework.impl.applyHooks;
    import robotlegs.bender.framework.impl.guardsApprove;
    
    public class EventCommandFactory {
         
        
        private var _injector:Injector;
        
        public function EventCommandFactory(param1:Injector) {
            super();
            this._injector = param1;
        }
        
        public function create(param1:ICommandMapping) : Object {
            var _local_2:Class = null;
            var _local_3:Object = null;
            if(guardsApprove(param1.guards,this._injector)) {
                _local_2 = param1.commandClass;
                this._injector.map(_local_2).asSingleton();
                _local_3 = this._injector.getInstance(_local_2);
                applyHooks(param1.hooks,this._injector);
                this._injector.unmap(_local_2);
                return _local_3;
            }
            return null;
        }
    }
}
