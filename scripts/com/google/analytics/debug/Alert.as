package com.google.analytics.debug {
    import flash.events.TextEvent;
    
    public class Alert extends Label {
         
        
        public var autoClose:Boolean = true;
        
        public var actionOnNextLine:Boolean = true;
        
        private var _actions:Array;
        
        public function Alert(param1:String, param2:Array, param3:String = "uiAlert", param4:uint = 0, param5:Align = null, param6:Boolean = false, param7:Boolean = true) {
            if(param4 == 0) {
                param4 = Style.alertColor;
            }
            if(param5 == null) {
                param5 = Align.center;
            }
            super(param1,param3,param4,param5,param6);
            this.selectable = true;
            super.mouseChildren = true;
            this.buttonMode = true;
            this.mouseEnabled = true;
            this.useHandCursor = true;
            this.actionOnNextLine = param7;
            _actions = [];
            var _local_8:int = 0;
            while(_local_8 < param2.length) {
                param2[_local_8].container = this;
                _actions.push(param2[_local_8]);
                _local_8++;
            }
        }
        
        private function _defineActions() : void {
            var _local_3:AlertAction = null;
            var _local_1:* = "";
            if(actionOnNextLine) {
                _local_1 = _local_1 + "\n";
            } else {
                _local_1 = _local_1 + " |";
            }
            _local_1 = _local_1 + " ";
            var _local_2:Array = [];
            var _local_4:int = 0;
            while(_local_4 < _actions.length) {
                _local_3 = _actions[_local_4];
                _local_2.push("<a href=\"event:" + _local_3.activator + "\">" + _local_3.name + "</a>");
                _local_4++;
            }
            _local_1 = _local_1 + _local_2.join(" | ");
            appendText(_local_1,"uiAlertAction");
        }
        
        protected function isValidAction(param1:String) : Boolean {
            var _local_2:int = 0;
            while(_local_2 < _actions.length) {
                if(param1 == _actions[_local_2].activator) {
                    return true;
                }
                _local_2++;
            }
            return false;
        }
        
        override protected function layout() : void {
            super.layout();
            _defineActions();
        }
        
        protected function getAction(param1:String) : AlertAction {
            var _local_2:int = 0;
            while(_local_2 < _actions.length) {
                if(param1 == _actions[_local_2].activator) {
                    return _actions[_local_2];
                }
                _local_2++;
            }
            return null;
        }
        
        protected function spaces(param1:int) : String {
            var _local_2:String = "";
            var _local_3:String = "          ";
            var _local_4:int = 0;
            while(_local_4 < param1 + 1) {
                _local_2 = _local_2 + _local_3;
                _local_4++;
            }
            return _local_2;
        }
        
        override public function onLink(param1:TextEvent) : void {
            var _local_2:AlertAction = null;
            if(isValidAction(param1.text)) {
                _local_2 = getAction(param1.text);
                if(_local_2) {
                    _local_2.execute();
                }
            }
            if(autoClose) {
                close();
            }
        }
        
        public function close() : void {
            if(parent != null) {
                parent.removeChild(this);
            }
        }
    }
}
