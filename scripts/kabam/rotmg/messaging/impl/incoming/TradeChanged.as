package kabam.rotmg.messaging.impl.incoming {
    import flash.utils.IDataInput;
    
    public class TradeChanged extends IncomingMessage {
         
        
        public var offer_:Vector.<Boolean>;
        
        public function TradeChanged(param1:uint, param2:Function) {
            this.offer_ = new Vector.<Boolean>();
            super(param1,param2);
        }
        
        override public function parseFromInput(param1:IDataInput) : void {
            this.offer_.length = 0;
            var _local_2:int = param1.readShort();
            var _local_3:int = 0;
            while(_local_3 < _local_2) {
                this.offer_.push(param1.readBoolean());
                _local_3++;
            }
        }
        
        override public function toString() : String {
            return formatToString("TRADECHANGED","offer_");
        }
    }
}
