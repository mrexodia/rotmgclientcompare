package robotlegs.bender.framework.impl {
    import org.swiftsuspenders.Injector;
    
    public function applyHooks(param1:Array, param2:Injector = null) : void {
        var _local_3:Object = null;
        for each(_local_3 in param1) {
            if(_local_3 is Function) {
                (_local_3 as Function)();
            } else {
                if(_local_3 is Class) {
                    _local_3 = !!param2?param2.getInstance(_local_3 as Class):new (_local_3 as Class)();
                }
                _local_3.hook();
            }
        }
    }
}
