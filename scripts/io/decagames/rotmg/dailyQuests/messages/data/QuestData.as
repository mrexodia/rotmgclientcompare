package io.decagames.rotmg.dailyQuests.messages.data {
    import flash.utils.IDataInput;
    
    public class QuestData {
         
        
        public var id:String;
        
        public var name:String;
        
        public var description:String;
        
        public var requirements:Vector.<int>;
        
        public var rewards:Vector.<int>;
        
        public var completed:Boolean;
        
        public var category:int;
        
        public function QuestData() {
            this.requirements = new Vector.<int>();
            this.rewards = new Vector.<int>();
            super();
        }
        
        public function parseFromInput(param1:IDataInput) : void {
            this.id = param1.readUTF();
            this.name = param1.readUTF();
            this.description = param1.readUTF();
            this.category = param1.readInt();
            var _local_2:int = param1.readShort();
            var _local_3:int = 0;
            while(_local_3 < _local_2) {
                this.requirements.push(param1.readInt());
                _local_3++;
            }
            _local_2 = param1.readShort();
            _local_3 = 0;
            while(_local_3 < _local_2) {
                this.rewards.push(param1.readInt());
                _local_3++;
            }
            this.completed = param1.readBoolean();
        }
    }
}
