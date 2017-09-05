package io.decagames.rotmg.dailyQuests.view.list {
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import io.decagames.rotmg.dailyQuests.assets.DailyQuestAssets;
    import kabam.rotmg.text.view.TextFieldDisplayConcrete;
    import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
    
    public class DailyQuestListElement extends Sprite {
         
        
        private var _id:String;
        
        private var _questName:String;
        
        private var _completed:Boolean;
        
        private var selectedBorder:Sprite;
        
        private var _isSelected:Boolean;
        
        private var ready:Boolean;
        
        private var background:Sprite;
        
        private var questNameTextfield:TextFieldDisplayConcrete;
        
        public function DailyQuestListElement(param1:String, param2:String, param3:Boolean, param4:Boolean) {
            this.background = new Sprite();
            super();
            this._id = param1;
            this._questName = param2;
            this._completed = param3;
            this.ready = param4;
            this.selectedBorder = new Sprite();
            this.draw();
        }
        
        public function set isSelected(param1:Boolean) : void {
            this._isSelected = param1;
            this.drawBackground();
            this.setElements();
        }
        
        private function setElements() : void {
            if(this.questNameTextfield && this.questNameTextfield.parent) {
                removeChild(this.questNameTextfield);
            }
            this.questNameTextfield = new TextFieldDisplayConcrete().setSize(14).setColor(this._completed || this._isSelected?uint(16777215):uint(13619151)).setBold(true);
            this.questNameTextfield.alpha = this._completed || this._isSelected?Number(1):Number(0.5);
            this.questNameTextfield.setStringBuilder(new StaticStringBuilder(this._questName));
            this.questNameTextfield.x = 24;
            this.questNameTextfield.y = 8;
            addChild(this.questNameTextfield);
        }
        
        private function draw() : void {
            this.drawBackground();
            this.setElements();
        }
        
        private function drawBackground() : void {
            var _local_1:Bitmap = null;
            if(this.background.parent) {
                removeChild(this.background);
            }
            this.background = new Sprite();
            if(this._completed) {
                _local_1 = new DailyQuestAssets.DailyQuestsListCompleteIcon();
            } else if(this.ready) {
                _local_1 = new DailyQuestAssets.DailyQuestsListReadyIcon();
            } else {
                _local_1 = new DailyQuestAssets.DailyQuestsListAvailableIcon();
            }
            _local_1.x = 5;
            _local_1.y = 5;
            if(this._isSelected) {
                this.background.addChild(new DailyQuestAssets.DailyQuestsListElementOrange());
            } else if(this._completed) {
                this.background.addChild(new DailyQuestAssets.DailyQuestsListElementGreen());
            } else {
                this.background.addChild(new DailyQuestAssets.DailyQuestsListElementGrey());
            }
            addChild(this.background);
            addChild(_local_1);
        }
        
        public function get id() : String {
            return this._id;
        }
        
        public function get questName() : String {
            return this._questName;
        }
    }
}
