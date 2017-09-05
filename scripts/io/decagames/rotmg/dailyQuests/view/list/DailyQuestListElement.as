package io.decagames.rotmg.dailyQuests.view.list {
    import flash.display.Sprite;
    import kabam.rotmg.text.view.TextFieldDisplayConcrete;
    import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
    
    public class DailyQuestListElement extends Sprite {
         
        
        private var _id:String;
        
        private var _questName:String;
        
        private var _completed:Boolean;
        
        private var boxWidth:int = 199.0;
        
        private var boxHeight:int = 30;
        
        private var selectedBorder:Sprite;
        
        private var _isSelected:Boolean = false;
        
        private var background:Sprite;
        
        public function DailyQuestListElement(param1:String, param2:String, param3:Boolean) {
            this.background = new Sprite();
            super();
            this._id = param1;
            this._questName = param2;
            this._completed = param3;
            this.selectedBorder = new Sprite();
            this.draw();
        }
        
        public function set isSelected(param1:Boolean) : void {
            this._isSelected = param1;
            this.drawBackground();
        }
        
        private function setElements() : void {
            var _local_1:TextFieldDisplayConcrete = null;
            _local_1 = new TextFieldDisplayConcrete().setSize(14).setColor(!!this._completed?uint(16777215):uint(12171705)).setBold(true);
            _local_1.setStringBuilder(new StaticStringBuilder(this._questName));
            _local_1.x = 8;
            _local_1.y = 8;
            addChild(_local_1);
        }
        
        private function draw() : void {
            this.drawBackground();
            this.setElements();
        }
        
        private function drawBackground() : void {
            this.background.graphics.clear();
            var _local_1:int = 1;
            if(this._isSelected) {
                this.background.graphics.beginFill(16682752);
                this.background.graphics.drawRect(0,0,this.boxWidth,this.boxHeight);
                this.background.graphics.endFill();
            }
            this.background.graphics.beginFill(!!this._completed?uint(1286144):uint(6052956));
            this.background.graphics.drawRect(!!this._isSelected?Number(_local_1 * 2):Number(0),!!this._isSelected?Number(_local_1 * 2):Number(0),!!this._isSelected?Number(this.boxWidth - _local_1 * 4):Number(this.boxWidth),!!this._isSelected?Number(this.boxHeight - _local_1 * 4):Number(this.boxHeight));
            this.background.graphics.endFill();
            if(!this.background.parent) {
                addChild(this.background);
            }
        }
        
        public function get id() : String {
            return this._id;
        }
        
        public function get questName() : String {
            return this._questName;
        }
    }
}
