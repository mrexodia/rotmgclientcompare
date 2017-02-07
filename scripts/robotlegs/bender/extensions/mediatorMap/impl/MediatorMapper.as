package robotlegs.bender.extensions.mediatorMap.impl {
    import flash.utils.Dictionary;
    import robotlegs.bender.extensions.matching.ITypeFilter;
    import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
    import robotlegs.bender.extensions.mediatorMap.api.IMediatorViewHandler;
    import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMapper;
    import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMappingConfig;
    import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMappingFinder;
    import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorUnmapper;
    
    public class MediatorMapper implements IMediatorMapper, IMediatorMappingFinder, IMediatorUnmapper {
         
        
        private const _mappings:Dictionary = new Dictionary();
        
        private var _matcher:ITypeFilter;
        
        private var _handler:IMediatorViewHandler;
        
        public function MediatorMapper(param1:ITypeFilter, param2:IMediatorViewHandler) {
            super();
            this._matcher = param1;
            this._handler = param2;
        }
        
        public function toMediator(param1:Class) : IMediatorMappingConfig {
            return this.lockedMappingFor(param1) || this.createMapping(param1);
        }
        
        public function forMediator(param1:Class) : IMediatorMapping {
            return this._mappings[param1];
        }
        
        public function fromMediator(param1:Class) : void {
            var _local_2:IMediatorMapping = this._mappings[param1];
            delete this._mappings[param1];
            this._handler.removeMapping(_local_2);
        }
        
        public function fromMediators() : void {
            var _local_1:IMediatorMapping = null;
            for each(_local_1 in this._mappings) {
                delete this._mappings[_local_1.mediatorClass];
                this._handler.removeMapping(_local_1);
            }
        }
        
        private function createMapping(param1:Class) : MediatorMapping {
            var _local_2:MediatorMapping = new MediatorMapping(this._matcher,param1);
            this._handler.addMapping(_local_2);
            this._mappings[param1] = _local_2;
            return _local_2;
        }
        
        private function lockedMappingFor(param1:Class) : MediatorMapping {
            var _local_2:MediatorMapping = this._mappings[param1];
            if(_local_2) {
                _local_2.invalidate();
            }
            return _local_2;
        }
    }
}
