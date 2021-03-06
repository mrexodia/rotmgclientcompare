package kabam.rotmg.messaging.impl.incoming {
    import flash.utils.IDataInput;
    
    public class TradeAccepted extends IncomingMessage {
         
        
        public var myOffer_:Vector.<Boolean>;
        
        public var yourOffer_:Vector.<Boolean>;
        
        public function TradeAccepted(param1:uint, param2:Function) {
            this.myOffer_ = new Vector.<Boolean>();
            this.yourOffer_ = new Vector.<Boolean>();
            super(param1,param2);
        }
        
        override public function parseFromInput(param1:IDataInput) : void {
            var _local_2:int = 0;
            this.myOffer_.length = 0;
            var _local_3:int = param1.readShort();
            _local_2 = 0;
            while(_local_2 < _local_3) {
                this.myOffer_.push(param1.readBoolean());
                _local_2++;
            }
            this.yourOffer_.length = 0;
            _local_3 = param1.readShort();
            _local_2 = 0;
            while(_local_2 < _local_3) {
                this.yourOffer_.push(param1.readBoolean());
                _local_2++;
            }
        }
        
        override public function toString() : String {
            return formatToString("TRADEACCEPTED","myOffer_","yourOffer_");
        }
    }
}
