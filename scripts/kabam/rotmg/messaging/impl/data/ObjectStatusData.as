package kabam.rotmg.messaging.impl.data {
    import com.company.assembleegameclient.util.FreeList;
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;
    
    public class ObjectStatusData {
         
        
        public var objectId_:int;
        
        public var pos_:WorldPosData;
        
        public var stats_:Vector.<StatData>;
        
        public function ObjectStatusData() {
            this.pos_ = new WorldPosData();
            this.stats_ = new Vector.<StatData>();
            super();
        }
        
        public function parseFromInput(param1:IDataInput) : void {
            var _local_3:int = 0;
            this.objectId_ = param1.readInt();
            this.pos_.parseFromInput(param1);
            var _local_2:int = param1.readShort();
            _local_3 = _local_2;
            while(_local_3 < this.stats_.length) {
                FreeList.deleteObject(this.stats_[_local_3]);
                _local_3++;
            }
            this.stats_.length = Math.min(_local_2,this.stats_.length);
            while(this.stats_.length < _local_2) {
                this.stats_.push(FreeList.newObject(StatData) as StatData);
            }
            _local_3 = 0;
            while(_local_3 < _local_2) {
                this.stats_[_local_3].parseFromInput(param1);
                _local_3++;
            }
        }
        
        public function writeToOutput(param1:IDataOutput) : void {
            param1.writeInt(this.objectId_);
            this.pos_.writeToOutput(param1);
            param1.writeShort(this.stats_.length);
            var _local_2:int = 0;
            while(_local_2 < this.stats_.length) {
                this.stats_[_local_2].writeToOutput(param1);
                _local_2++;
            }
        }
        
        public function toString() : String {
            return "objectId_: " + this.objectId_ + " pos_: " + this.pos_ + " stats_: " + this.stats_;
        }
    }
}
