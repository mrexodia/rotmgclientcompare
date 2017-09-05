package io.decagames.rotmg.dailyQuests.messages.incoming {
    import flash.utils.IDataInput;
    import io.decagames.rotmg.dailyQuests.messages.data.QuestData;
    import kabam.rotmg.messaging.impl.incoming.IncomingMessage;
    
    public class QuestFetchResponse extends IncomingMessage {
         
        
        public var quests:Vector.<QuestData>;
        
        public function QuestFetchResponse(param1:uint, param2:Function) {
            this.quests = new Vector.<QuestData>();
            super(param1,param2);
        }
        
        override public function parseFromInput(param1:IDataInput) : void {
            var _local_2:int = param1.readShort();
            var _local_3:int = 0;
            while(_local_3 < _local_2) {
                this.quests[_local_3] = new QuestData();
                this.quests[_local_3].parseFromInput(param1);
                _local_3++;
            }
        }
        
        override public function toString() : String {
            return formatToString("QUESTFETCHRESPONSE");
        }
    }
}
