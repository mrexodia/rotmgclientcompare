package com.google.analytics.debug {
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.Event;
    
    public class UISprite extends Sprite {
         
        
        private var _forcedWidth:uint;
        
        public var margin:Margin;
        
        protected var alignTarget:DisplayObject;
        
        protected var listenResize:Boolean;
        
        public var alignement:Align;
        
        private var _forcedHeight:uint;
        
        public function UISprite(param1:DisplayObject = null) {
            super();
            listenResize = false;
            alignement = Align.none;
            this.alignTarget = param1;
            margin = new Margin();
            addEventListener(Event.ADDED_TO_STAGE,_onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE,_onRemovedFromStage);
        }
        
        public function get forcedHeight() : uint {
            if(_forcedHeight) {
                return _forcedHeight;
            }
            return height;
        }
        
        private function _onAddedToStage(param1:Event) : void {
            layout();
            resize();
        }
        
        protected function dispose() : void {
            var _local_1:DisplayObject = null;
            var _local_2:int = 0;
            while(_local_2 < numChildren) {
                _local_1 = getChildAt(_local_2);
                if(_local_1) {
                    removeChild(_local_1);
                }
                _local_2++;
            }
        }
        
        public function set forcedHeight(param1:uint) : void {
            _forcedHeight = param1;
        }
        
        public function set forcedWidth(param1:uint) : void {
            _forcedWidth = param1;
        }
        
        protected function layout() : void {
        }
        
        public function get forcedWidth() : uint {
            if(_forcedWidth) {
                return _forcedWidth;
            }
            return width;
        }
        
        public function alignTo(param1:Align, param2:DisplayObject = null) : void {
            var _local_3:uint = 0;
            var _local_4:uint = 0;
            var _local_5:uint = 0;
            var _local_6:uint = 0;
            var _local_7:UISprite = null;
            if(param2 == null) {
                if(parent is Stage) {
                    param2 = this.stage;
                } else {
                    param2 = parent;
                }
            }
            if(param2 == this.stage) {
                if(this.stage == null) {
                    return;
                }
                _local_3 = this.stage.stageHeight;
                _local_4 = this.stage.stageWidth;
                _local_5 = 0;
                _local_6 = 0;
            } else {
                _local_7 = param2 as UISprite;
                if(_local_7.forcedHeight) {
                    _local_3 = _local_7.forcedHeight;
                } else {
                    _local_3 = _local_7.height;
                }
                if(_local_7.forcedWidth) {
                    _local_4 = _local_7.forcedWidth;
                } else {
                    _local_4 = _local_7.width;
                }
                _local_5 = 0;
                _local_6 = 0;
            }
            switch(param1) {
                case Align.top:
                    x = _local_4 / 2 - forcedWidth / 2;
                    y = _local_6 + margin.top;
                    break;
                case Align.bottom:
                    x = _local_4 / 2 - forcedWidth / 2;
                    y = _local_6 + _local_3 - forcedHeight - margin.bottom;
                    break;
                case Align.left:
                    x = _local_5 + margin.left;
                    y = _local_3 / 2 - forcedHeight / 2;
                    break;
                case Align.right:
                    x = _local_5 + _local_4 - forcedWidth - margin.right;
                    y = _local_3 / 2 - forcedHeight / 2;
                    break;
                case Align.center:
                    x = _local_4 / 2 - forcedWidth / 2;
                    y = _local_3 / 2 - forcedHeight / 2;
                    break;
                case Align.topLeft:
                    x = _local_5 + margin.left;
                    y = _local_6 + margin.top;
                    break;
                case Align.topRight:
                    x = _local_5 + _local_4 - forcedWidth - margin.right;
                    y = _local_6 + margin.top;
                    break;
                case Align.bottomLeft:
                    x = _local_5 + margin.left;
                    y = _local_6 + _local_3 - forcedHeight - margin.bottom;
                    break;
                case Align.bottomRight:
                    x = _local_5 + _local_4 - forcedWidth - margin.right;
                    y = _local_6 + _local_3 - forcedHeight - margin.bottom;
            }
            if(!listenResize && param1 != Align.none) {
                param2.addEventListener(Event.RESIZE,onResize,false,0,true);
                listenResize = true;
            }
            this.alignement = param1;
            this.alignTarget = param2;
        }
        
        private function _onRemovedFromStage(param1:Event) : void {
            removeEventListener(Event.ADDED_TO_STAGE,_onAddedToStage);
            removeEventListener(Event.REMOVED_FROM_STAGE,_onRemovedFromStage);
            dispose();
        }
        
        public function resize() : void {
            if(alignement != Align.none) {
                alignTo(alignement,alignTarget);
            }
        }
        
        protected function onResize(param1:Event) : void {
            resize();
        }
    }
}
