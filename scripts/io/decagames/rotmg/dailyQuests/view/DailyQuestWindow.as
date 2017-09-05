package io.decagames.rotmg.dailyQuests.view {
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormatAlign;
    import io.decagames.rotmg.dailyQuests.model.DailyQuest;
    import io.decagames.rotmg.dailyQuests.view.info.DailyQuestInfo;
    import io.decagames.rotmg.dailyQuests.view.list.DailyQuestsList;
    import io.decagames.rotmg.dailyQuests.view.popup.DailyQuestRedeemPopup;
    import kabam.rotmg.text.view.TextFieldDisplayConcrete;
    import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
    
    public class DailyQuestWindow extends Sprite {
        
        public static var dailyQuestBanner:Class = DailyQuestWindow_dailyQuestBanner;
        
        public static var CloseButtonAsset:Class = DailyQuestWindow_CloseButtonAsset;
        
        public static const MODAL_WIDTH:int = 600;
        
        public static const MODAL_FULL_WIDTH:int = 800;
        
        public static const MODAL_HEIGHT:int = 600;
         
        
        private var fade:Sprite;
        
        private var rewardPopup:DailyQuestRedeemPopup;
        
        private var _closeButton:Sprite;
        
        private var questList:DailyQuestsList;
        
        private var questInfo:DailyQuestInfo;
        
        private var questRefreshText:TextFieldDisplayConcrete;
        
        public function DailyQuestWindow() {
            var _local_1:Bitmap = null;
            var _local_2:int = 0;
            super();
            graphics.beginFill(0,0.7);
            graphics.drawRect(0,0,MODAL_WIDTH,MODAL_HEIGHT);
            graphics.endFill();
            _local_1 = new dailyQuestBanner();
            addChild(_local_1);
            _local_1.y = 8;
            _local_1.x = Math.round((600 - _local_1.width) / 2);
            this.renderList();
            this.renderQuestInfo();
            this._closeButton = new Sprite();
            this._closeButton.addChild(new CloseButtonAsset());
            addChild(this._closeButton);
            _local_2 = 4;
            this._closeButton.x = MODAL_WIDTH - this._closeButton.width - _local_2;
            this._closeButton.y = _local_2;
            this.questRefreshText = new TextFieldDisplayConcrete().setSize(16).setColor(12262929).setBold(true).setTextWidth(DailyQuestsList.LIST_WIDTH).setAutoSize(TextFieldAutoSize.CENTER).setHorizontalAlign(TextFormatAlign.CENTER);
            this.questRefreshText.y = 100;
            this.questRefreshText.x = 10;
            addChild(this.questRefreshText);
        }
        
        public function setQuestRefreshHeader(param1:String) : void {
            this.questRefreshText.setStringBuilder(new StaticStringBuilder(param1));
        }
        
        public function renderQuestInfo() : void {
            if(this.questInfo && this.questInfo.parent) {
                removeChild(this.questInfo);
            }
            this.questInfo = new DailyQuestInfo();
            this.questInfo.x = 255;
            this.questInfo.y = 130;
            addChildAt(this.questInfo,0);
        }
        
        public function renderList() : void {
            if(this.questList && this.questList.parent) {
                removeChild(this.questList);
            }
            this.questList = new DailyQuestsList();
            this.questList.x = 10;
            this.questList.y = 130;
            addChildAt(this.questList,0);
        }
        
        public function showFade(param1:int = 1381653) : void {
            this.fade = new Sprite();
            this.fade.graphics.clear();
            this.fade.graphics.beginFill(param1,0.6);
            this.fade.graphics.drawRect(0,0,MODAL_FULL_WIDTH,MODAL_HEIGHT);
            addChild(this.fade);
        }
        
        public function hideFade() : void {
            if(this.fade && this.fade.parent) {
                removeChild(this.fade);
            }
        }
        
        public function hideRewardsPopup() : void {
            if(this.rewardPopup && this.rewardPopup.parent) {
                removeChild(this.rewardPopup);
            }
        }
        
        public function showRewardsPopup(param1:DailyQuest) : DailyQuestRedeemPopup {
            this.rewardPopup = new DailyQuestRedeemPopup(280,190,param1);
            addChild(this.rewardPopup);
            this.rewardPopup.x = Math.round((MODAL_WIDTH - this.rewardPopup.width) / 2);
            this.rewardPopup.y = Math.round((MODAL_HEIGHT - this.rewardPopup.height) / 2);
            return this.rewardPopup;
        }
        
        public function get closeButton() : Sprite {
            return this._closeButton;
        }
    }
}
