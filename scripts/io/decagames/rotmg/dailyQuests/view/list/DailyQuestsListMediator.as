package io.decagames.rotmg.dailyQuests.view.list {
    import io.decagames.rotmg.dailyQuests.model.DailyQuest;
    import io.decagames.rotmg.dailyQuests.model.DailyQuestsModel;
    import io.decagames.rotmg.dailyQuests.view.info.DailyQuestInfo;
    import kabam.rotmg.constants.GeneralConstants;
    import kabam.rotmg.ui.model.HUDModel;
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    public class DailyQuestsListMediator extends Mediator {
         
        
        [Inject]
        public var view:DailyQuestsList;
        
        [Inject]
        public var model:DailyQuestsModel;
        
        [Inject]
        public var hud:HUDModel;
        
        public function DailyQuestsListMediator() {
            super();
        }
        
        override public function initialize() : void {
            var _local_4:DailyQuest = null;
            var _local_5:DailyQuestListElement = null;
            var _local_1:Vector.<DailyQuest> = this.model.questsList;
            var _local_2:Boolean = true;
            var _local_3:Vector.<int> = !!this.hud.gameSprite.map.player_?this.hud.gameSprite.map.player_.equipment_.slice(GeneralConstants.NUM_EQUIPMENT_SLOTS - 1,GeneralConstants.NUM_EQUIPMENT_SLOTS + GeneralConstants.NUM_INVENTORY_SLOTS * 2):new Vector.<int>();
            for each(_local_4 in _local_1) {
                _local_5 = new DailyQuestListElement(_local_4.id,_local_4.name,_local_4.completed,DailyQuestInfo.hasAllItems(_local_4.requirements,_local_3));
                if(_local_2) {
                    _local_5.isSelected = true;
                }
                _local_2 = false;
                this.view.addQuestToList(_local_5);
            }
            this.view.scrollBar.update();
        }
        
        override public function destroy() : void {
        }
    }
}
