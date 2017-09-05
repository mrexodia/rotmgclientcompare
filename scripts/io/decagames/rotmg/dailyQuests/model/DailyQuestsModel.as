package io.decagames.rotmg.dailyQuests.model {
    public class DailyQuestsModel {
         
        
        private var _questsList:Vector.<DailyQuest>;
        
        public var currentQuest:DailyQuest;
        
        public var isPopupOpened:Boolean;
        
        public function DailyQuestsModel() {
            this._questsList = new Vector.<DailyQuest>();
            super();
        }
        
        public function clear() : void {
            this._questsList = new Vector.<DailyQuest>();
        }
        
        public function addQuest(param1:DailyQuest) : void {
            this._questsList.push(param1);
        }
        
        public function markAsCompleted(param1:String) : void {
            var _local_2:DailyQuest = null;
            for each(_local_2 in this._questsList) {
                if(_local_2.id == param1) {
                    _local_2.completed = true;
                }
            }
        }
        
        public function hasQuests() : Boolean {
            return this._questsList.length > 0;
        }
        
        public function get questsList() : Vector.<DailyQuest> {
            var _local_1:Vector.<DailyQuest> = this._questsList.concat();
            return _local_1.sort(this.questsCompleteSort);
        }
        
        private function questsNameSort(param1:DailyQuest, param2:DailyQuest) : int {
            if(param1.name > param2.name) {
                return 1;
            }
            return -1;
        }
        
        private function questsCategorySort(param1:DailyQuest, param2:DailyQuest) : int {
            if(param1.category > param2.category) {
                return 1;
            }
            if(param1.category == param2.category) {
                return this.questsNameSort(param1,param2);
            }
            return -1;
        }
        
        private function questsCompleteSort(param1:DailyQuest, param2:DailyQuest) : int {
            if(param1.completed && !param2.completed) {
                return 1;
            }
            if(param1.completed && param2.completed) {
                return this.questsCategorySort(param1,param2);
            }
            if(!param1.completed && !param2.completed) {
                return this.questsCategorySort(param1,param2);
            }
            return -1;
        }
        
        public function getQuestById(param1:String) : DailyQuest {
            var _local_2:DailyQuest = null;
            for each(_local_2 in this._questsList) {
                if(_local_2.id == param1) {
                    return _local_2;
                }
            }
            return null;
        }
        
        public function get first() : DailyQuest {
            if(this._questsList.length > 0) {
                return this._questsList[0];
            }
            return null;
        }
    }
}
