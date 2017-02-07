package robotlegs.bender.extensions.viewManager.impl {
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    import flash.utils.getQualifiedClassName;
    
    public class StageObserver {
         
        
        private const _filter:RegExp = /^mx\.|^spark\.|^flash\./;
        
        private var _registry:ContainerRegistry;
        
        public function StageObserver(param1:ContainerRegistry) {
            var _local_2:ContainerBinding = null;
            super();
            this._registry = param1;
            this._registry.addEventListener(ContainerRegistryEvent.ROOT_CONTAINER_ADD,this.onRootContainerAdd);
            this._registry.addEventListener(ContainerRegistryEvent.ROOT_CONTAINER_REMOVE,this.onRootContainerRemove);
            for each(_local_2 in this._registry.rootBindings) {
                this.addRootListener(_local_2.container);
            }
        }
        
        public function destroy() : void {
            var _local_1:ContainerBinding = null;
            this._registry.removeEventListener(ContainerRegistryEvent.ROOT_CONTAINER_ADD,this.onRootContainerAdd);
            this._registry.removeEventListener(ContainerRegistryEvent.ROOT_CONTAINER_REMOVE,this.onRootContainerRemove);
            for each(_local_1 in this._registry.rootBindings) {
                this.removeRootListener(_local_1.container);
            }
        }
        
        private function onRootContainerAdd(param1:ContainerRegistryEvent) : void {
            this.addRootListener(param1.container);
        }
        
        private function onRootContainerRemove(param1:ContainerRegistryEvent) : void {
            this.removeRootListener(param1.container);
        }
        
        private function addRootListener(param1:DisplayObjectContainer) : void {
            param1.addEventListener(Event.ADDED_TO_STAGE,this.onViewAddedToStage,true);
            param1.addEventListener(Event.ADDED_TO_STAGE,this.onContainerRootAddedToStage);
        }
        
        private function removeRootListener(param1:DisplayObjectContainer) : void {
            param1.removeEventListener(Event.ADDED_TO_STAGE,this.onViewAddedToStage,true);
            param1.removeEventListener(Event.ADDED_TO_STAGE,this.onContainerRootAddedToStage);
        }
        
        private function onViewAddedToStage(param1:Event) : void {
            var _local_2:DisplayObject = null;
            var _local_3:String = null;
            _local_2 = param1.target as DisplayObject;
            _local_3 = getQualifiedClassName(_local_2);
            var _local_4:Boolean = this._filter.test(_local_3);
            if(_local_4) {
                return;
            }
            var _local_5:Class = _local_2["constructor"];
            var _local_6:ContainerBinding = this._registry.findParentBinding(_local_2);
            while(_local_6) {
                _local_6.handleView(_local_2,_local_5);
                _local_6 = _local_6.parent;
            }
        }
        
        private function onContainerRootAddedToStage(param1:Event) : void {
            var _local_2:DisplayObjectContainer = null;
            _local_2 = param1.target as DisplayObjectContainer;
            _local_2.removeEventListener(Event.ADDED_TO_STAGE,this.onContainerRootAddedToStage);
            var _local_3:Class = _local_2["constructor"];
            var _local_4:ContainerBinding = this._registry.getBinding(_local_2);
            _local_4.handleView(_local_2,_local_3);
        }
    }
}
