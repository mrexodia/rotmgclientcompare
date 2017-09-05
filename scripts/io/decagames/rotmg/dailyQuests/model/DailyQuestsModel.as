package io.decagames.rotmg.dailyQuests.model {
    import io.decagames.rotmg.dailyQuests.view.info.DailyQuestInfo;
    import kabam.rotmg.constants.GeneralConstants;
    import kabam.rotmg.ui.model.HUDModel;
    
    public class DailyQuestsModel {
         
        
        private var _questsList:Vector.<DailyQuest>;
        
        public var currentQuest:DailyQuest;
        
        public var isPopupOpened:Boolean;
        
        [Inject]
        public var hud:HUDModel;
        
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
        
        public function get playerItemsFromInventory() : Vector.<int> {
            return !!this.hud.gameSprite.map.player_?this.hud.gameSprite.map.player_.equipment_.slice(GeneralConstants.NUM_EQUIPMENT_SLOTS - 1,GeneralConstants.NUM_EQUIPMENT_SLOTS + GeneralConstants.NUM_INVENTORY_SLOTS * 2):new Vector.<int>();
        }
        
        public function hasQuests() : Boolean {
            return this._questsList.length > 0;
        }
        
        public function get numberOfActiveQuests() : int {
            return this._questsList.length;
        }
        
        public function get numberOfCompletedQuests() : int {
            var _local_2:DailyQuest = null;
            var _local_1:int = 0;
            for each(_local_2 in this._questsList) {
                if(_local_2.completed) {
                    _local_1++;
                }
            }
            return _local_1;
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
        
        private function questsReadySort(param1:DailyQuest, param2:DailyQuest) : int {
            var _local_3:Boolean = DailyQuestInfo.hasAllItems(param1.requirements,this.playerItemsFromInventory);
            var _local_4:Boolean = DailyQuestInfo.hasAllItems(param2.requirements,this.playerItemsFromInventory);
            if(_local_3 && !_local_4) {
                return -1;
            }
            if(_local_3 && _local_4) {
                return this.questsNameSort(param1,param2);
            }
            return 1;
        }
        
        private function questsCompleteSort(param1:DailyQuest, param2:DailyQuest) : int {
            if(param1.completed && !param2.completed) {
                return 1;
            }
            if(param1.completed && param2.completed) {
                return this.questsReadySort(param1,param2);
            }
            if(!param1.completed && !param2.completed) {
                return this.questsReadySort(param1,param2);
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
                return this.questsList[0];
            }
            return null;
        }
    }
}
