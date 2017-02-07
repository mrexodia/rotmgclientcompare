package com.junkbyte.console.view {
    import com.junkbyte.console.Console;
    import com.junkbyte.console.KeyBind;
    import com.junkbyte.console.core.LogReferences;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.TextEvent;
    import flash.geom.Point;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.utils.Dictionary;
    
    public class RollerPanel extends ConsolePanel {
        
        public static const NAME:String = "rollerPanel";
         
        
        private var _settingKey:Boolean;
        
        public function RollerPanel(param1:Console) {
            super(param1);
            name = NAME;
            init(60,100,false);
            txtField = makeTF("rollerPrints");
            txtField.multiline = true;
            txtField.autoSize = TextFieldAutoSize.LEFT;
            registerTFRoller(txtField,this.onMenuRollOver,this.linkHandler);
            registerDragger(txtField);
            addChild(txtField);
            addEventListener(Event.ENTER_FRAME,this._onFrame);
            addEventListener(Event.REMOVED_FROM_STAGE,this.removeListeners);
        }
        
        private function removeListeners(param1:Event = null) : void {
            removeEventListener(Event.ENTER_FRAME,this._onFrame);
            removeEventListener(Event.REMOVED_FROM_STAGE,this.removeListeners);
            if(stage) {
                stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
            }
        }
        
        private function _onFrame(param1:Event) : void {
            if(!console.stage) {
                this.close();
                return;
            }
            if(this._settingKey) {
                txtField.htmlText = "<high><menu>Press a key to set [ <a href=\"event:cancel\"><b>cancel</b></a> ]</menu></high>";
            } else {
                txtField.htmlText = "<low>" + this.getMapString(false) + "</low>";
                txtField.autoSize = TextFieldAutoSize.LEFT;
                txtField.setSelection(0,0);
            }
            width = txtField.width + 4;
            height = txtField.height;
        }
        
        public function getMapString(param1:Boolean) : String {
            var _local_7:DisplayObject = null;
            var _local_8:String = null;
            var _local_9:Array = null;
            var _local_10:DisplayObjectContainer = null;
            var _local_11:uint = 0;
            var _local_12:uint = 0;
            var _local_13:DisplayObject = null;
            var _local_14:uint = 0;
            var _local_15:* = null;
            var _local_16:uint = 0;
            var _local_2:Stage = console.stage;
            var _local_3:* = "";
            if(!param1) {
                _local_8 = !!console.rollerCaptureKey?console.rollerCaptureKey.key:"unassigned";
                _local_3 = "<menu> <a href=\"event:close\"><b>X</b></a></menu> Capture key: <menu><a href=\"event:capture\">" + _local_8 + "</a></menu><br/>";
            }
            var _local_4:Point = new Point(_local_2.mouseX,_local_2.mouseY);
            if(_local_2.areInaccessibleObjectsUnderPoint(_local_4)) {
                _local_3 = _local_3 + "<p9>Inaccessible objects detected</p9><br/>";
            }
            var _local_5:Array = _local_2.getObjectsUnderPoint(_local_4);
            var _local_6:Dictionary = new Dictionary(true);
            if(_local_5.length == 0) {
                _local_5.push(_local_2);
            }
            for each(_local_7 in _local_5) {
                _local_9 = new Array(_local_7);
                _local_10 = _local_7.parent;
                while(_local_10) {
                    _local_9.unshift(_local_10);
                    _local_10 = _local_10.parent;
                }
                _local_11 = _local_9.length;
                _local_12 = 0;
                while(_local_12 < _local_11) {
                    _local_13 = _local_9[_local_12];
                    if(_local_6[_local_13] == undefined) {
                        _local_6[_local_13] = _local_12;
                        _local_14 = _local_12;
                        while(_local_14 > 0) {
                            _local_3 = _local_3 + (_local_14 == 1?" ∟":" -");
                            _local_14--;
                        }
                        _local_15 = _local_13.name;
                        if(param1 && console.config.useObjectLinking) {
                            _local_16 = console.refs.setLogRef(_local_13);
                            _local_15 = "<a href=\'event:cl_" + _local_16 + "\'>" + _local_15 + "</a> " + console.refs.makeRefTyped(_local_13);
                        } else {
                            _local_15 = _local_15 + " (" + LogReferences.ShortClassName(_local_13) + ")";
                        }
                        if(_local_13 == _local_2) {
                            _local_16 = console.refs.setLogRef(_local_2);
                            if(_local_16) {
                                _local_3 = _local_3 + ("<p3><a href=\'event:cl_" + _local_16 + "\'><i>Stage</i></a> ");
                            } else {
                                _local_3 = _local_3 + "<p3><i>Stage</i> ";
                            }
                            _local_3 = _local_3 + ("[" + _local_2.mouseX + "," + _local_2.mouseY + "]</p3><br/>");
                        } else if(_local_12 == _local_11 - 1) {
                            _local_3 = _local_3 + ("<p5>" + _local_15 + "</p5><br/>");
                        } else {
                            _local_3 = _local_3 + ("<p2><i>" + _local_15 + "</i></p2><br/>");
                        }
                    }
                    _local_12++;
                }
            }
            return _local_3;
        }
        
        override public function close() : void {
            this.cancelCaptureKeySet();
            this.removeListeners();
            super.close();
            console.panels.updateMenu();
        }
        
        private function onMenuRollOver(param1:TextEvent) : void {
            var _local_3:KeyBind = null;
            var _local_2:String = !!param1.text?param1.text.replace("event:",""):"";
            if(_local_2 == "close") {
                _local_2 = "Close";
            } else if(_local_2 == "capture") {
                _local_3 = console.rollerCaptureKey;
                if(_local_3) {
                    _local_2 = "Unassign key ::" + _local_3.key;
                } else {
                    _local_2 = "Assign key";
                }
            } else if(_local_2 == "cancel") {
                _local_2 = "Cancel assign key";
            } else {
                _local_2 = null;
            }
            console.panels.tooltip(_local_2,this);
        }
        
        protected function linkHandler(param1:TextEvent) : void {
            TextField(param1.currentTarget).setSelection(0,0);
            if(param1.text == "close") {
                this.close();
            } else if(param1.text == "capture") {
                if(console.rollerCaptureKey) {
                    console.setRollerCaptureKey(null);
                } else {
                    this._settingKey = true;
                    stage.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler,false,0,true);
                }
                console.panels.tooltip(null);
            } else if(param1.text == "cancel") {
                this.cancelCaptureKeySet();
                console.panels.tooltip(null);
            }
            param1.stopPropagation();
        }
        
        private function cancelCaptureKeySet() : void {
            this._settingKey = false;
            if(stage) {
                stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
            }
        }
        
        private function keyDownHandler(param1:KeyboardEvent) : void {
            if(!param1.charCode) {
                return;
            }
            var _local_2:String = String.fromCharCode(param1.charCode);
            this.cancelCaptureKeySet();
            console.setRollerCaptureKey(_local_2,param1.shiftKey,param1.ctrlKey,param1.altKey);
            console.panels.tooltip(null);
        }
    }
}
