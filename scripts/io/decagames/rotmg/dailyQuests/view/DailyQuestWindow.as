package io.decagames.rotmg.dailyQuests.view {
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormatAlign;
    import flashx.textLayout.formats.TextAlign;
    import io.decagames.rotmg.dailyQuests.assets.DailyQuestAssets;
    import io.decagames.rotmg.dailyQuests.model.DailyQuest;
    import io.decagames.rotmg.dailyQuests.view.info.DailyQuestInfo;
    import io.decagames.rotmg.dailyQuests.view.list.DailyQuestsList;
    import io.decagames.rotmg.dailyQuests.view.popup.DailyQuestRedeemPopup;
    import kabam.rotmg.text.view.TextFieldDisplayConcrete;
    import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
    
    public class DailyQuestWindow extends Sprite {
        
        public static var dailyQuestBanner:Class = DailyQuestWindow_dailyQuestBanner;
        
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
            var _local_4:TextFieldDisplayConcrete = null;
            super();
            _local_1 = new DailyQuestAssets.DailyQuestsWindowBackground();
            _local_1.y = 1;
            addChild(_local_1);
            var _local_2:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(32).setColor(15395562).setBold(true).setTextWidth(270).setHorizontalAlign(TextAlign.CENTER);
            _local_2.x = 204;
            _local_2.y = 47;
            _local_2.setStringBuilder(new StaticStringBuilder("Daily Quests"));
            addChild(_local_2);
            this._closeButton = new Sprite();
            this._closeButton.addChild(new DailyQuestAssets.DailyQuestsCloseButton());
            this._closeButton.x = 546;
            this._closeButton.y = 46;
            addChild(this._closeButton);
            var _local_3:Sprite = new Sprite();
            _local_3.addChild(new DailyQuestAssets.DailyQuestsInfoButton());
            _local_3.x = 16;
            _local_3.y = this._closeButton.y;
            addChild(_local_3);
            this.renderQuestInfo();
            this.renderList();
            this.questRefreshText = new TextFieldDisplayConcrete().setSize(14).setColor(10724259).setBold(true).setTextWidth(234).setAutoSize(TextFieldAutoSize.CENTER).setHorizontalAlign(TextFormatAlign.CENTER);
            this.questRefreshText.y = 503;
            this.questRefreshText.x = 10;
            addChild(this.questRefreshText);
            _local_4 = new TextFieldDisplayConcrete().setSize(16).setColor(13224136).setBold(true).setTextWidth(160).setHorizontalAlign(TextFormatAlign.LEFT);
            _local_4.y = 533;
            _local_4.x = 24;
            _local_4.setStringBuilder(new StaticStringBuilder("Quest completed"));
            addChild(_local_4);
        }
        
        public function setCompletedCounter(param1:int, param2:int) : void {
            var _local_3:TextFieldDisplayConcrete = null;
            _local_3 = new TextFieldDisplayConcrete().setSize(16).setColor(13224136).setBold(true).setTextWidth(50).setHorizontalAlign(TextFormatAlign.RIGHT);
            _local_3.y = 533;
            _local_3.x = 207;
            _local_3.setStringBuilder(new StaticStringBuilder(param1 + "/" + param2));
            addChild(_local_3);
        }
        
        public function setQuestRefreshHeader(param1:String) : void {
            this.questRefreshText.setStringBuilder(new StaticStringBuilder(param1));
        }
        
        public function renderQuestInfo() : void {
            if(this.questInfo && this.questInfo.parent) {
                removeChild(this.questInfo);
            }
            this.questInfo = new DailyQuestInfo();
            this.questInfo.x = 256;
            this.questInfo.y = 121;
            addChild(this.questInfo);
        }
        
        public function renderList() : void {
            if(this.questList && this.questList.parent) {
                removeChild(this.questList);
            }
            this.questList = new DailyQuestsList();
            this.questList.x = 18;
            this.questList.y = 134;
            addChild(this.questList);
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
            this.rewardPopup = new DailyQuestRedeemPopup(param1);
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
