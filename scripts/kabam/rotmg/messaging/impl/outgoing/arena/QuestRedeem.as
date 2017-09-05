package kabam.rotmg.messaging.impl.outgoing.arena {
    import flash.utils.IDataOutput;
    import kabam.rotmg.messaging.impl.data.SlotObjectData;
    import kabam.rotmg.messaging.impl.outgoing.OutgoingMessage;
    
    public class QuestRedeem extends OutgoingMessage {
         
        
        public var questID:String;
        
        public var slots:Vector.<SlotObjectData>;
        
        public function QuestRedeem(param1:uint, param2:Function) {
            super(param1,param2);
        }
        
        override public function writeToOutput(param1:IDataOutput) : void {
            var _local_2:SlotObjectData = null;
            param1.writeUTF(this.questID);
            param1.writeShort(this.slots.length);
            for each(_local_2 in this.slots) {
                _local_2.writeToOutput(param1);
            }
        }
    }
}
