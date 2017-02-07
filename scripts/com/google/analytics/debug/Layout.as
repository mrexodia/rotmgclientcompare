package com.google.analytics.debug {
    import com.google.analytics.GATracker;
    import com.google.analytics.core.GIFRequest;
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.net.URLRequest;
    
    public class Layout implements ILayout {
         
        
        private var _display:DisplayObject;
        
        private var _infoQueue:Array;
        
        private var _maxCharPerLine:int = 85;
        
        private var _hasInfo:Boolean;
        
        private var _warningQueue:Array;
        
        private var _hasDebug:Boolean;
        
        private var _hasWarning:Boolean;
        
        private var _mainPanel:Panel;
        
        private var _GRAlertQueue:Array;
        
        private var _debug:DebugConfiguration;
        
        public var visualDebug:Debug;
        
        private var _hasGRAlert:Boolean;
        
        public function Layout(param1:DebugConfiguration, param2:DisplayObject) {
            super();
            _display = param2;
            _debug = param1;
            _hasWarning = false;
            _hasInfo = false;
            _hasDebug = false;
            _hasGRAlert = false;
            _warningQueue = [];
            _infoQueue = [];
            _GRAlertQueue = [];
        }
        
        private function onKey(param1:KeyboardEvent = null) : void {
            switch(param1.keyCode) {
                case _debug.showHideKey:
                    _mainPanel.visible = !_mainPanel.visible;
                    break;
                case _debug.destroyKey:
                    destroy();
            }
        }
        
        public function createWarning(param1:String) : void {
            if(_hasWarning || !isAvailable()) {
                _warningQueue.push(param1);
                return;
            }
            param1 = _filterMaxChars(param1);
            _hasWarning = true;
            var _local_2:Warning = new Warning(param1,_debug.warningTimeout);
            addToPanel("analytics",_local_2);
            _local_2.addEventListener(Event.REMOVED_FROM_STAGE,_clearWarning,false,0,true);
            if(_hasDebug) {
                visualDebug.writeBold(param1);
            }
        }
        
        public function bringToFront(param1:DisplayObject) : void {
            _display.stage.setChildIndex(param1,_display.stage.numChildren - 1);
        }
        
        public function createFailureAlert(param1:String) : void {
            var _local_2:AlertAction = null;
            if(_debug.verbose) {
                param1 = _filterMaxChars(param1);
                _local_2 = new AlertAction("Close","close","close");
            } else {
                _local_2 = new AlertAction("X","close","close");
            }
            var _local_3:Alert = new FailureAlert(_debug,param1,[_local_2]);
            addToPanel("analytics",_local_3);
            if(_hasDebug) {
                if(_debug.verbose) {
                    param1 = param1.split("\n").join("");
                    param1 = _filterMaxChars(param1,66);
                }
                visualDebug.writeBold(param1);
            }
        }
        
        public function init() : void {
            var _local_1:int = 10;
            var _local_2:uint = _display.stage.stageWidth - _local_1 * 2;
            var _local_3:uint = _display.stage.stageHeight - _local_1 * 2;
            var _local_4:Panel = new Panel("analytics",_local_2,_local_3);
            _local_4.alignement = Align.top;
            _local_4.stickToEdge = false;
            _local_4.title = "Google Analytics v" + GATracker.version;
            _mainPanel = _local_4;
            addToStage(_local_4);
            bringToFront(_local_4);
            if(_debug.minimizedOnStart) {
                _mainPanel.onToggle();
            }
            createVisualDebug();
            _display.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKey,false,0,true);
        }
        
        public function addToPanel(param1:String, param2:DisplayObject) : void {
            var _local_4:Panel = null;
            var _local_3:DisplayObject = _display.stage.getChildByName(param1);
            if(_local_3) {
                _local_4 = _local_3 as Panel;
                _local_4.addData(param2);
            } else {
                trace("panel \"" + param1 + "\" not found");
            }
        }
        
        private function _clearInfo(param1:Event) : void {
            _hasInfo = false;
            if(_infoQueue.length > 0) {
                createInfo(_infoQueue.shift());
            }
        }
        
        private function _filterMaxChars(param1:String, param2:int = 0) : String {
            var _local_6:String = null;
            var _local_3:String = "\n";
            var _local_4:Array = [];
            var _local_5:Array = param1.split(_local_3);
            if(param2 == 0) {
                param2 = _maxCharPerLine;
            }
            var _local_7:int = 0;
            while(_local_7 < _local_5.length) {
                _local_6 = _local_5[_local_7];
                while(_local_6.length > param2) {
                    _local_4.push(_local_6.substr(0,param2));
                    _local_6 = _local_6.substring(param2);
                }
                _local_4.push(_local_6);
                _local_7++;
            }
            return _local_4.join(_local_3);
        }
        
        private function _clearGRAlert(param1:Event) : void {
            _hasGRAlert = false;
            if(_GRAlertQueue.length > 0) {
                createGIFRequestAlert.apply(this,_GRAlertQueue.shift());
            }
        }
        
        public function createSuccessAlert(param1:String) : void {
            var _local_2:AlertAction = null;
            if(_debug.verbose) {
                param1 = _filterMaxChars(param1);
                _local_2 = new AlertAction("Close","close","close");
            } else {
                _local_2 = new AlertAction("X","close","close");
            }
            var _local_3:Alert = new SuccessAlert(_debug,param1,[_local_2]);
            addToPanel("analytics",_local_3);
            if(_hasDebug) {
                if(_debug.verbose) {
                    param1 = param1.split("\n").join("");
                    param1 = _filterMaxChars(param1,66);
                }
                visualDebug.writeBold(param1);
            }
        }
        
        public function isAvailable() : Boolean {
            return _display.stage != null;
        }
        
        public function createAlert(param1:String) : void {
            param1 = _filterMaxChars(param1);
            var _local_2:Alert = new Alert(param1,[new AlertAction("Close","close","close")]);
            addToPanel("analytics",_local_2);
            if(_hasDebug) {
                visualDebug.writeBold(param1);
            }
        }
        
        public function createInfo(param1:String) : void {
            if(_hasInfo || !isAvailable()) {
                _infoQueue.push(param1);
                return;
            }
            param1 = _filterMaxChars(param1);
            _hasInfo = true;
            var _local_2:Info = new Info(param1,_debug.infoTimeout);
            addToPanel("analytics",_local_2);
            _local_2.addEventListener(Event.REMOVED_FROM_STAGE,_clearInfo,false,0,true);
            if(_hasDebug) {
                visualDebug.write(param1);
            }
        }
        
        public function createGIFRequestAlert(param1:String, param2:URLRequest, param3:GIFRequest) : void {
            var message:String = param1;
            var request:URLRequest = param2;
            var ref:GIFRequest = param3;
            if(_hasGRAlert) {
                _GRAlertQueue.push([message,request,ref]);
                return;
            }
            _hasGRAlert = true;
            var f:Function = function():void {
                ref.sendRequest(request);
            };
            message = _filterMaxChars(message);
            var gra:GIFRequestAlert = new GIFRequestAlert(message,[new AlertAction("OK","ok",f),new AlertAction("Cancel","cancel","close")]);
            addToPanel("analytics",gra);
            gra.addEventListener(Event.REMOVED_FROM_STAGE,_clearGRAlert,false,0,true);
            if(_hasDebug) {
                if(_debug.verbose) {
                    message = message.split("\n").join("");
                    message = _filterMaxChars(message,66);
                }
                visualDebug.write(message);
            }
        }
        
        public function createVisualDebug() : void {
            if(!visualDebug) {
                visualDebug = new Debug();
                visualDebug.alignement = Align.bottom;
                visualDebug.stickToEdge = true;
                addToPanel("analytics",visualDebug);
                _hasDebug = true;
            }
        }
        
        public function addToStage(param1:DisplayObject) : void {
            _display.stage.addChild(param1);
        }
        
        private function _clearWarning(param1:Event) : void {
            _hasWarning = false;
            if(_warningQueue.length > 0) {
                createWarning(_warningQueue.shift());
            }
        }
        
        public function createPanel(param1:String, param2:uint, param3:uint) : void {
            var _local_4:Panel = new Panel(param1,param2,param3);
            _local_4.alignement = Align.center;
            _local_4.stickToEdge = false;
            addToStage(_local_4);
            bringToFront(_local_4);
        }
        
        public function destroy() : void {
            _mainPanel.close();
            _debug.layout = null;
        }
    }
}
