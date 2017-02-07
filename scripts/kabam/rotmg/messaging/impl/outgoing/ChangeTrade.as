package kabam.rotmg.messaging.impl.outgoing {
    import flash.utils.IDataOutput;
    
    public class ChangeTrade extends OutgoingMessage {
         
        
        public var offer_:Vector.<Boolean>;
        
        public function ChangeTrade(param1:uint, param2:Function) {
            this.offer_ = new Vector.<Boolean>();
            super(param1,param2);
        }
        
        override public function writeToOutput(param1:IDataOutput) : void {
            param1.writeShort(this.offer_.length);
            var _local_2:int = 0;
            while(_local_2 < this.offer_.length) {
                param1.writeBoolean(this.offer_[_local_2]);
                _local_2++;
            }
        }
        
        override public function toString() : String {
            return formatToString("CHANGETRADE","offer_");
        }
    }
}
