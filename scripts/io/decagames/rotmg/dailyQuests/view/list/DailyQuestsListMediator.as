package io.decagames.rotmg.dailyQuests.view.list {
    import flash.events.Event;
    import io.decagames.rotmg.dailyQuests.model.DailyQuest;
    import io.decagames.rotmg.dailyQuests.model.DailyQuestsModel;
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    public class DailyQuestsListMediator extends Mediator {
         
        
        [Inject]
        public var view:DailyQuestsList;
        
        [Inject]
        public var model:DailyQuestsModel;
        
        public function DailyQuestsListMediator() {
            super();
        }
        
        override public function initialize() : void {
            var _local_3:DailyQuest = null;
            var _local_4:DailyQuestListElement = null;
            var _local_1:Vector.<DailyQuest> = this.model.questsList;
            var _local_2:Boolean = true;
            for each(_local_3 in _local_1) {
                _local_4 = new DailyQuestListElement(_local_3.id,_local_3.name,_local_3.completed);
                if(_local_2) {
                    _local_4.isSelected = true;
                }
                _local_2 = false;
                this.view.addQuestToList(_local_4);
            }
            this.view.scrollBar.addEventListener(Event.CHANGE,this.onScrollBarChange);
        }
        
        override public function destroy() : void {
            this.view.scrollBar.removeEventListener(Event.CHANGE,this.onScrollBarChange);
        }
        
        private function onScrollBarChange(param1:Event) : void {
            this.view.list.y = DailyQuestsList.SCROLL_TOP_MARGIN - this.view.scrollBar.pos() * (this.view.list.height - this.view.scrollHeight);
        }
    }
}
