package io.decagames.rotmg.dailyQuests.view.info {
    import flash.display.Sprite;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormatAlign;
    import flashx.textLayout.formats.TextAlign;
    import io.decagames.rotmg.dailyQuests.data.DailyQuestItemSlotType;
    import io.decagames.rotmg.dailyQuests.model.DailyQuest;
    import io.decagames.rotmg.dailyQuests.utils.SlotsRendered;
    import io.decagames.rotmg.dailyQuests.view.slot.DailyQuestItemSlot;
    import kabam.rotmg.text.view.TextFieldDisplayConcrete;
    import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
    
    public class DailyQuestInfo extends Sprite {
        
        public static var INFO_WIDTH:int = 328;
        
        public static const INFO_HEIGHT:int = 434;
         
        
        private var questName:TextFieldDisplayConcrete;
        
        private var questDescription:TextFieldDisplayConcrete;
        
        private var slots:Vector.<DailyQuestItemSlot>;
        
        private var slotMargin:int = 4;
        
        private var requirementsTopMargin:int = 118;
        
        private var rewardsTopMargin:int = 261;
        
        private var requirementsContainer:Sprite;
        
        private var rewardsContainer:Sprite;
        
        private var _completeButton:DailyQuestCompleteButton;
        
        private var playerEquipment:Vector.<int>;
        
        public function DailyQuestInfo() {
            var _local_1:TextFieldDisplayConcrete = null;
            super();
            this.questName = new TextFieldDisplayConcrete().setSize(20).setColor(15241232).setBold(true).setTextWidth(INFO_WIDTH).setAutoSize(TextFieldAutoSize.CENTER).setHorizontalAlign(TextFormatAlign.CENTER);
            this.questName.y = 8;
            this.questName.x = 0;
            addChild(this.questName);
            this.requirementsContainer = new Sprite();
            addChild(this.requirementsContainer);
            this.rewardsContainer = new Sprite();
            addChild(this.rewardsContainer);
            this.questDescription = new TextFieldDisplayConcrete().setSize(16).setColor(13224136).setBold(true).setTextWidth(INFO_WIDTH - 30).setMultiLine(true).setWordWrap(true).setHorizontalAlign(TextAlign.CENTER);
            this.questDescription.y = 44;
            this.questDescription.x = 15;
            addChild(this.questDescription);
            _local_1 = new TextFieldDisplayConcrete().setSize(16).setColor(15395562).setBold(true).setTextWidth(120).setAutoSize(TextFieldAutoSize.CENTER).setHorizontalAlign(TextFormatAlign.CENTER);
            _local_1.y = 223;
            _local_1.x = 105;
            _local_1.setStringBuilder(new StaticStringBuilder("Rewards"));
            addChild(_local_1);
            this._completeButton = new DailyQuestCompleteButton();
            this._completeButton.x = 89;
            this._completeButton.y = 384;
        }
        
        public static function hasAllItems(param1:Vector.<int>, param2:Vector.<int>) : Boolean {
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
        
        public function clear() : void {
            var _local_1:DailyQuestItemSlot = null;
            for each(_local_1 in this.slots) {
                _local_1.parent.removeChild(_local_1);
            }
            this.slots = new Vector.<DailyQuestItemSlot>();
        }
        
        public function show(param1:DailyQuest, param2:Vector.<int>) : void {
            this.playerEquipment = param2.concat();
            this.questName.setStringBuilder(new StaticStringBuilder(param1.name));
            this.questDescription.setStringBuilder(new StaticStringBuilder(param1.description));
            SlotsRendered.renderSlots(param1.requirements,this.playerEquipment,DailyQuestItemSlotType.REQUIREMENT,this.requirementsContainer,this.requirementsTopMargin,this.slotMargin,INFO_WIDTH,this.slots);
            SlotsRendered.renderSlots(param1.rewards,this.playerEquipment,DailyQuestItemSlotType.REWARD,this.rewardsContainer,this.rewardsTopMargin,this.slotMargin,INFO_WIDTH,this.slots);
            this._completeButton.enabled = hasAllItems(param1.requirements,param2);
            this._completeButton.completed = param1.completed;
            this._completeButton.draw();
            addChild(this._completeButton);
        }
        
        public function get completeButton() : DailyQuestCompleteButton {
            return this._completeButton;
        }
    }
}
