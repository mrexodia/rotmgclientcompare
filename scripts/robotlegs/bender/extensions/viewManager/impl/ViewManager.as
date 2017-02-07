package robotlegs.bender.extensions.viewManager.impl {
    import flash.display.DisplayObjectContainer;
    import flash.events.EventDispatcher;
    import robotlegs.bender.extensions.viewManager.api.IViewHandler;
    import robotlegs.bender.extensions.viewManager.api.IViewManager;
    
    public class ViewManager extends EventDispatcher implements IViewManager {
         
        
        private const _containers:Vector.<DisplayObjectContainer> = new Vector.<DisplayObjectContainer>();
        
        private const _handlers:Vector.<IViewHandler> = new Vector.<IViewHandler>();
        
        private var _registry:ContainerRegistry;
        
        public function ViewManager(param1:ContainerRegistry) {
            super();
            this._registry = param1;
        }
        
        public function get containers() : Vector.<DisplayObjectContainer> {
            return this._containers;
        }
        
        public function addContainer(param1:DisplayObjectContainer) : void {
            var _local_2:IViewHandler = null;
            if(!this.validContainer(param1)) {
                return;
            }
            this._containers.push(param1);
            for each(_local_2 in this._handlers) {
                this._registry.addContainer(param1).addHandler(_local_2);
            }
            dispatchEvent(new ViewManagerEvent(ViewManagerEvent.CONTAINER_ADD,param1));
        }
        
        public function removeContainer(param1:DisplayObjectContainer) : void {
            var _local_4:IViewHandler = null;
            var _local_2:int = this._containers.indexOf(param1);
            if(_local_2 == -1) {
                return;
            }
            this._containers.splice(_local_2,1);
            var _local_3:ContainerBinding = this._registry.getBinding(param1);
            for each(_local_4 in this._handlers) {
                _local_3.removeHandler(_local_4);
            }
            dispatchEvent(new ViewManagerEvent(ViewManagerEvent.CONTAINER_REMOVE,param1));
        }
        
        public function addViewHandler(param1:IViewHandler) : void {
            var _local_2:DisplayObjectContainer = null;
            if(this._handlers.indexOf(param1) != -1) {
                return;
            }
            this._handlers.push(param1);
            for each(_local_2 in this._containers) {
                this._registry.addContainer(_local_2).addHandler(param1);
            }
            dispatchEvent(new ViewManagerEvent(ViewManagerEvent.HANDLER_ADD,null,param1));
        }
        
        public function removeViewHandler(param1:IViewHandler) : void {
            var _local_3:DisplayObjectContainer = null;
            var _local_2:int = this._handlers.indexOf(param1);
            if(_local_2 == -1) {
                return;
            }
            this._handlers.splice(_local_2,1);
            for each(_local_3 in this._containers) {
                this._registry.getBinding(_local_3).removeHandler(param1);
            }
            dispatchEvent(new ViewManagerEvent(ViewManagerEvent.HANDLER_REMOVE,null,param1));
        }
        
        public function removeAllHandlers() : void {
            var _local_1:DisplayObjectContainer = null;
            var _local_2:ContainerBinding = null;
            var _local_3:IViewHandler = null;
            for each(_local_1 in this._containers) {
                _local_2 = this._registry.getBinding(_local_1);
                for each(_local_3 in this._handlers) {
                    _local_2.removeHandler(_local_3);
                }
            }
        }
        
        private function validContainer(param1:DisplayObjectContainer) : Boolean {
            var _local_2:DisplayObjectContainer = null;
            for each(_local_2 in this._containers) {
                if(param1 == _local_2) {
                    return false;
                }
                if(_local_2.contains(param1) || param1.contains(_local_2)) {
                    throw new Error("Containers can not be nested");
                }
            }
            return true;
        }
    }
}
