package robotlegs.bender.framework.impl {
    import org.swiftsuspenders.Injector;
    
    public function guardsApprove(param1:Array, param2:Injector = null) : Boolean {
        var _local_3:Object = null;
        for each(_local_3 in param1) {
            if(_local_3 is Function) {
                if((_local_3 as Function)()) {
                    continue;
                }
                return false;
            }
            if(_local_3 is Class) {
                _local_3 = !!param2?param2.getInstance(_local_3 as Class):new (_local_3 as Class)();
            }
            if(_local_3.approve() == false) {
                return false;
            }
        }
        return true;
    }
}
