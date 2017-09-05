package io.decagames.rotmg.dailyQuests.view.info {
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormatAlign;
    import flashx.textLayout.formats.TextAlign;
    import io.decagames.rotmg.dailyQuests.data.DailyQuestItemSlotType;
    import io.decagames.rotmg.dailyQuests.model.DailyQuest;
    import io.decagames.rotmg.dailyQuests.utils.SlotsRendered;
    import io.decagames.rotmg.dailyQuests.view.slot.DailyQuestItemSlot;
    import io.decagames.rotmg.ui.panels.FramedPanel;
    import io.decagames.rotmg.utils.colors.AlphaColor;
    import kabam.rotmg.text.view.TextFieldDisplayConcrete;
    import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
    
    public class DailyQuestInfo extends Sprite {
        
        public static var INFO_WIDTH:int = 330;
        
        public static const INFO_HEIGHT:int = 434;
        
        public static var rewardsBanner:Class = DailyQuestInfo_rewardsBanner;
         
        
        private var questName:TextFieldDisplayConcrete;
        
        private var questDescription:TextFieldDisplayConcrete;
        
        private var slots:Vector.<DailyQuestItemSlot>;
        
        private var slotMargin:int = 4;
        
        private var requirementsTopMargin:int = 80;
        
        private var rewardsTopMargin:int = 250;
        
        private var requirementsContainer:Sprite;
        
        private var rewardsContainer:Sprite;
        
        private var banner:Bitmap;
        
        private var _completeButton:DailyQuestCompleteButton;
        
        private var playerEquipment:Vector.<int>;
        
        public function DailyQuestInfo() {
            super();
            var _local_1:FramedPanel = new FramedPanel(INFO_WIDTH,INFO_HEIGHT,5,new AlphaColor(3745793,0.7),new AlphaColor(0,0.7));
            addChild(_local_1);
            this.questName = new TextFieldDisplayConcrete().setSize(24).setColor(16682752).setBold(true).setTextWidth(INFO_WIDTH + 10).setAutoSize(TextFieldAutoSize.CENTER).setHorizontalAlign(TextFormatAlign.CENTER);
            this.questName.y = -36;
            this.questName.x = -5;
            addChild(this.questName);
            this.questDescription = new TextFieldDisplayConcrete().setSize(16).setColor(13224136).setBold(true).setTextWidth(INFO_WIDTH - 60).setMultiLine(true).setWordWrap(true).setHorizontalAlign(TextAlign.CENTER);
            this.questDescription.y = 20;
            this.questDescription.x = 30;
            addChild(this.questDescription);
            this.requirementsContainer = new Sprite();
            addChild(this.requirementsContainer);
            this.rewardsContainer = new Sprite();
            addChild(this.rewardsContainer);
            this.banner = new rewardsBanner();
            this.banner.x = Math.round((INFO_WIDTH - this.banner.width) / 2);
            this.banner.y = 189;
            this._completeButton = new DailyQuestCompleteButton();
            this._completeButton.x = Math.round((INFO_WIDTH - DailyQuestCompleteButton.BUTTON_WIDTH) / 2);
            this._completeButton.y = 351;
        }
        
        public function clear() : void {
            var _local_1:DailyQuestItemSlot = null;
            for each(_local_1 in this.slots) {
                _local_1.parent.removeChild(_local_1);
            }
            this.slots = new Vector.<DailyQuestItemSlot>();
        }
        
        private function hasAllItems(param1:Vector.<int>, param2:Vector.<int>) : Boolean {
            var _local_4:int = 0;
            var _local_5:int = 0;
            var _local_3:Vector.<int> = param1.concat();
            for each(_local_4 in param2) {
                _local_5 = _local_3.indexOf(_local_4);
                if(_local_5 >= 0) {
                    _local_3.splice(_local_5,1);
                }
            }
            return _local_3.length == 0;
        }
        
        public function show(param1:DailyQuest, param2:Vector.<int>) : void {
            this.playerEquipment = param2.concat();
            this.questName.setStringBuilder(new StaticStringBuilder(param1.name));
            this.questDescription.setStringBuilder(new StaticStringBuilder(param1.description));
            SlotsRendered.renderSlots(param1.requirements,this.playerEquipment,DailyQuestItemSlotType.REQUIREMENT,this.requirementsContainer,this.requirementsTopMargin,this.slotMargin,INFO_WIDTH,this.slots);
            SlotsRendered.renderSlots(param1.rewards,this.playerEquipment,DailyQuestItemSlotType.REWARD,this.rewardsContainer,this.rewardsTopMargin,this.slotMargin,INFO_WIDTH,this.slots);
            addChild(this.banner);
            this._completeButton.enabled = this.hasAllItems(param1.requirements,param2);
            this._completeButton.completed = param1.completed;
            this._completeButton.draw();
            addChild(this._completeButton);
        }
        
        public function get completeButton() : DailyQuestCompleteButton {
            return this._completeButton;
        }
    }
}
