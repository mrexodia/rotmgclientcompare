package robotlegs.bender.framework.impl {
    import flash.utils.Dictionary;
    import robotlegs.bender.framework.api.IMessageDispatcher;
    
    public final class MessageDispatcher implements IMessageDispatcher {
         
        
        private const _handlers:Dictionary = new Dictionary();
        
        public function MessageDispatcher() {
            super();
        }
        
        public function addMessageHandler(param1:Object, param2:Function) : void {
            var _local_3:Array = this._handlers[param1];
            if(_local_3) {
                if(_local_3.indexOf(param2) == -1) {
                    _local_3.push(param2);
                }
            } else {
                this._handlers[param1] = [param2];
            }
        }
        
        public function hasMessageHandler(param1:Object) : Boolean {
            return this._handlers[param1];
        }
        
        public function removeMessageHandler(param1:Object, param2:Function) : void {
            var _local_3:Array = null;
            _local_3 = this._handlers[param1];
            var _local_4:int = !!_local_3?int(_local_3.indexOf(param2)):-1;
            if(_local_4 != -1) {
                _local_3.splice(_local_4,1);
                if(_local_3.length == 0) {
                    delete this._handlers[param1];
                }
            }
        }
        
        public function dispatchMessage(param1:Object, param2:Function = null, param3:Boolean = false) : void {
            var _local_4:Array = this._handlers[param1];
            if(_local_4) {
                _local_4 = _local_4.concat();
                param3 || _local_4.reverse();
                new MessageRunner(param1,_local_4,param2).run();
            } else {
                param2 && safelyCallBack(param2);
            }
        }
    }
}

import robotlegs.bender.framework.impl.safelyCallBack;

class MessageRunner {
     
    
    private var _message:Object;
    
    private var _handlers:Array;
    
    private var _callback:Function;
    
    function MessageRunner(param1:Object, param2:Array, param3:Function) {
        super();
        this._message = param1;
        this._handlers = param2;
        this._callback = param3;
    }
    
    public function run() : void {
        this.next();
    }
    
    private function next() : void {
        var handler:Function = null;
        var handled:Boolean = false;
        while(handler = this._handlers.pop()) {
            if(handler.length == 0) {
                handler();
                continue;
            }
            if(handler.length == 1) {
                handler(this._message);
                continue;
            }
            if(handler.length == 2) {
                handler(this._message,function(param1:Object = null, param2:Object = null):void {
                    if(handled) {
                        return;
                    }
                    handled = true;
                    if(param1 || _handlers.length == 0) {
                        _callback && safelyCallBack(_callback,param1,_message);
                    } else {
                        next();
                    }
                });
                return;
            }
            throw new Error("Bad handler signature");
        }
        this._callback && safelyCallBack(this._callback,null,this._message);
    }
}
