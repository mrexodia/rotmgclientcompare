package robotlegs.bender.extensions.viewManager.impl {
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.events.EventDispatcher;
    import robotlegs.bender.extensions.viewManager.api.IViewHandler;
    
    public class ContainerBinding extends EventDispatcher {
         
        
        private var _parent:ContainerBinding;
        
        private var _container:DisplayObjectContainer;
        
        private const _handlers:Vector.<IViewHandler> = new Vector.<IViewHandler>();
        
        public function ContainerBinding(param1:DisplayObjectContainer) {
            super();
            this._container = param1;
        }
        
        public function get parent() : ContainerBinding {
            return this._parent;
        }
        
        public function set parent(param1:ContainerBinding) : void {
            this._parent = param1;
        }
        
        public function get container() : DisplayObjectContainer {
            return this._container;
        }
        
        public function get numHandlers() : uint {
            return this._handlers.length;
        }
        
        public function addHandler(param1:IViewHandler) : void {
            if(this._handlers.indexOf(param1) > -1) {
                return;
            }
            this._handlers.push(param1);
        }
        
        public function removeHandler(param1:IViewHandler) : void {
            var _local_2:int = this._handlers.indexOf(param1);
            if(_local_2 > -1) {
                this._handlers.splice(_local_2,1);
                if(this._handlers.length == 0) {
                    dispatchEvent(new ContainerBindingEvent(ContainerBindingEvent.BINDING_EMPTY));
                }
            }
        }
        
        public function handleView(param1:DisplayObject, param2:Class) : void {
            var _local_5:IViewHandler = null;
            var _local_3:uint = this._handlers.length;
            var _local_4:int = 0;
            while(_local_4 < _local_3) {
                _local_5 = this._handlers[_local_4] as IViewHandler;
                _local_5.handleView(param1,param2);
                _local_4++;
            }
        }
    }
}
