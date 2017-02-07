package kabam.rotmg.messaging.impl.incoming {
    import com.company.assembleegameclient.util.FreeList;
    import flash.utils.IDataInput;
    import kabam.rotmg.messaging.impl.data.ObjectStatusData;
    
    public class NewTick extends IncomingMessage {
         
        
        public var tickId_:int;
        
        public var tickTime_:int;
        
        public var statuses_:Vector.<ObjectStatusData>;
        
        public function NewTick(param1:uint, param2:Function) {
            this.statuses_ = new Vector.<ObjectStatusData>();
            super(param1,param2);
        }
        
        override public function parseFromInput(param1:IDataInput) : void {
            var _local_3:int = 0;
            this.tickId_ = param1.readInt();
            this.tickTime_ = param1.readInt();
            var _local_2:int = param1.readShort();
            _local_3 = _local_2;
            while(_local_3 < this.statuses_.length) {
                FreeList.deleteObject(this.statuses_[_local_3]);
                _local_3++;
            }
            this.statuses_.length = Math.min(_local_2,this.statuses_.length);
            while(this.statuses_.length < _local_2) {
                this.statuses_.push(FreeList.newObject(ObjectStatusData) as ObjectStatusData);
            }
            _local_3 = 0;
            while(_local_3 < _local_2) {
                this.statuses_[_local_3].parseFromInput(param1);
                _local_3++;
            }
        }
        
        override public function toString() : String {
            return formatToString("NEW_TICK","tickId_","tickTime_","statuses_");
        }
    }
}
