package robotlegs.bender.extensions.eventCommandMap.impl {
    import flash.events.Event;
    import org.swiftsuspenders.Injector;
    import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
    import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
    import robotlegs.bender.extensions.commandCenter.impl.CommandMappingList;
    
    public class EventCommandExecutor {
         
        
        private var _trigger:ICommandTrigger;
        
        private var _mappings:Vector.<ICommandMapping>;
        
        private var _mappingList:CommandMappingList;
        
        private var _injector:Injector;
        
        private var _eventClass:Class;
        
        private var _factory:EventCommandFactory;
        
        public function EventCommandExecutor(param1:ICommandTrigger, param2:CommandMappingList, param3:Injector, param4:Class) {
            super();
            this._trigger = param1;
            this._mappingList = param2;
            this._injector = param3.createChildInjector();
            this._eventClass = param4;
            this._factory = new EventCommandFactory(this._injector);
        }
        
        public function execute(param1:Event) : void {
            var _local_2:Class = param1["constructor"] as Class;
            if(this.isTriggerEvent(_local_2)) {
                this.runCommands(param1,_local_2);
            }
        }
        
        private function isTriggerEvent(param1:Class) : Boolean {
            return !this._eventClass || param1 == this._eventClass;
        }
        
        private function isStronglyTyped(param1:Class) : Boolean {
            return param1 != Event;
        }
        
        private function mapEventForInjection(param1:Event, param2:Class) : void {
            this._injector.map(Event).toValue(param1);
            if(this.isStronglyTyped(param2)) {
                this._injector.map(this._eventClass || param2).toValue(param1);
            }
        }
        
        private function unmapEventAfterInjection(param1:Class) : void {
            this._injector.unmap(Event);
            if(this.isStronglyTyped(param1)) {
                this._injector.unmap(this._eventClass || param1);
            }
        }
        
        private function runCommands(param1:Event, param2:Class) : void {
            var _local_3:Object = null;
            var _local_4:ICommandMapping = this._mappingList.head;
            while(_local_4) {
                _local_4.validate();
                this.mapEventForInjection(param1,param2);
                _local_3 = this._factory.create(_local_4);
                this.unmapEventAfterInjection(param2);
                if(_local_3) {
                    this.removeFireOnceMapping(_local_4);
                    _local_3.execute();
                }
                _local_4 = _local_4.next;
            }
        }
        
        private function removeFireOnceMapping(param1:ICommandMapping) : void {
            if(param1.fireOnce) {
                this._trigger.removeMapping(param1);
            }
        }
    }
}
