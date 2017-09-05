package io.decagames.rotmg.dailyQuests.view {
    import flash.events.Event;
    import flash.events.MouseEvent;
    import io.decagames.rotmg.dailyQuests.model.DailyQuestsModel;
    import io.decagames.rotmg.dailyQuests.signal.CloseRedeemPopupSignal;
    import io.decagames.rotmg.dailyQuests.signal.LockQuestScreenSignal;
    import io.decagames.rotmg.dailyQuests.signal.QuestRedeemCompleteSignal;
    import io.decagames.rotmg.utils.date.TimeSpan;
    import kabam.rotmg.dailyLogin.model.DailyLoginModel;
    import kabam.rotmg.messaging.impl.incoming.QuestRedeemResponse;
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    public class DailyQuestWindowMediator extends Mediator {
         
        
        [Inject]
        public var view:DailyQuestWindow;
        
        [Inject]
        public var lockScreen:LockQuestScreenSignal;
        
        [Inject]
        public var redeemCompleteSignal:QuestRedeemCompleteSignal;
        
        [Inject]
        public var dailyQuestsModel:DailyQuestsModel;
        
        [Inject]
        public var closeRedeem:CloseRedeemPopupSignal;
        
        [Inject]
        public var dailyLoginModel:DailyLoginModel;
        
        public function DailyQuestWindowMediator() {
            super();
        }
        
        override public function initialize() : void {
            this.lockScreen.add(this.onLockScreen);
            this.redeemCompleteSignal.add(this.onRedeemComplete);
            this.closeRedeem.add(this.onRedeemClose);
            this.view.closeButton.addEventListener(MouseEvent.CLICK,this.onCloseClickHandler);
            this.view.addEventListener(Event.ENTER_FRAME,this.updateTimeHandler);
            this.view.setCompletedCounter(this.dailyQuestsModel.numberOfCompletedQuests,this.dailyQuestsModel.numberOfActiveQuests);
        }
        
        private function updateTimeHandler(param1:Event) : void {
            var _local_2:Date = this.dailyLoginModel.getServerTime();
            var _local_3:Date = new Date();
            _local_3.setTime(_local_2.valueOf() + 86400000);
            _local_3.setUTCHours(0);
            _local_3.setUTCMinutes(0);
            _local_3.setUTCSeconds(0);
            _local_3.setUTCMilliseconds(0);
            var _local_4:TimeSpan = new TimeSpan(_local_3.valueOf() - _local_2.valueOf());
            var _local_5:* = "Quests refresh in " + (_local_4.hours > 9?_local_4.hours.toString():"0" + _local_4.hours.toString()) + "h " + (_local_4.minutes > 9?_local_4.minutes.toString():"0" + _local_4.minutes.toString()) + "m";
            this.view.setQuestRefreshHeader(_local_5);
        }
        
        override public function destroy() : void {
            this.lockScreen.remove(this.onLockScreen);
            this.redeemCompleteSignal.remove(this.onRedeemComplete);
            this.closeRedeem.remove(this.onRedeemClose);
            this.view.closeButton.removeEventListener(MouseEvent.CLICK,this.onCloseClickHandler);
            this.view.removeEventListener(Event.ENTER_FRAME,this.updateTimeHandler);
            this.dailyQuestsModel.isPopupOpened = false;
        }
        
        private function onCloseClickHandler(param1:MouseEvent) : void {
            this.view.parent.removeChild(this.view);
        }
        
        private function onRedeemComplete(param1:QuestRedeemResponse) : void {
            if(param1.ok) {
                this.showRewardsPopup();
                this.dailyQuestsModel.markAsCompleted(this.dailyQuestsModel.currentQuest.id);
                this.dailyQuestsModel.currentQuest.completed = true;
                this.view.renderList();
                this.view.renderQuestInfo();
                this.view.setCompletedCounter(this.dailyQuestsModel.numberOfCompletedQuests,this.dailyQuestsModel.numberOfActiveQuests);
            }
        }
        
        private function onLockScreen() : void {
            this.view.showFade();
        }
        
        private function onRedeemClose() : void {
            this.view.hideFade();
            this.view.hideRewardsPopup();
        }
        
        private function showRewardsPopup() : void {
            this.view.showRewardsPopup(this.dailyQuestsModel.currentQuest);
        }
    }
}
