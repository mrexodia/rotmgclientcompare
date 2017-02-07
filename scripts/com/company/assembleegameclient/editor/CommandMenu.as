package com.company.assembleegameclient.editor {
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.utils.Dictionary;
    
    public class CommandMenu extends Sprite {
         
        
        private var keyCodeDict_:Dictionary;
        
        private var yOffset_:int = 0;
        
        private var selected_:CommandMenuItem = null;
        
        public function CommandMenu() {
            this.keyCodeDict_ = new Dictionary();
            super();
            addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
        }
        
        public function getCommand() : int {
            return this.selected_.command_;
        }
        
        public function setCommand(param1:int) : void {
            var _local_3:CommandMenuItem = null;
            var _local_2:int = 0;
            while(_local_2 < numChildren) {
                _local_3 = getChildAt(_local_2) as CommandMenuItem;
                if(_local_3 != null) {
                    if(_local_3.command_ == param1) {
                        this.setSelected(_local_3);
                        break;
                    }
                }
                _local_2++;
            }
        }
        
        protected function setSelected(param1:CommandMenuItem) : void {
            if(this.selected_ != null) {
                this.selected_.setSelected(false);
            }
            this.selected_ = param1;
            this.selected_.setSelected(true);
        }
        
        private function onAddedToStage(param1:Event) : void {
            stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
        }
        
        private function onRemovedFromStage(param1:Event) : void {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
        }
        
        private function onKeyDown(param1:KeyboardEvent) : void {
            if(stage.focus != null) {
                return;
            }
            var _local_2:CommandMenuItem = this.keyCodeDict_[param1.keyCode];
            if(_local_2 == null) {
                return;
            }
            _local_2.callback_(_local_2);
        }
        
        protected function addCommandMenuItem(param1:String, param2:int, param3:Function, param4:int) : void {
            var _local_5:CommandMenuItem = new CommandMenuItem(param1,param3,param4);
            _local_5.y = this.yOffset_;
            addChild(_local_5);
            this.keyCodeDict_[param2] = _local_5;
            if(this.selected_ == null) {
                this.setSelected(_local_5);
            }
            this.yOffset_ = this.yOffset_ + 30;
        }
        
        protected function addBreak() : void {
            this.yOffset_ = this.yOffset_ + 30;
        }
    }
}
