package com.junkbyte.console.view {
    import com.junkbyte.console.Console;
    import com.junkbyte.console.vos.GraphGroup;
    import com.junkbyte.console.vos.GraphInterest;
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.events.TextEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;
    
    public class GraphingPanel extends ConsolePanel {
        
        public static const FPS:String = "fpsPanel";
        
        public static const MEM:String = "memoryPanel";
         
        
        private var _group:GraphGroup;
        
        private var _interest:GraphInterest;
        
        private var _infoMap:Object;
        
        private var _menuString:String;
        
        private var _type:String;
        
        private var _needRedraw:Boolean;
        
        private var underlay:Shape;
        
        private var graph:Shape;
        
        private var lowTxt:TextField;
        
        private var highTxt:TextField;
        
        public var startOffset:int = 5;
        
        public function GraphingPanel(param1:Console, param2:int, param3:int, param4:String = null) {
            this._infoMap = new Object();
            super(param1);
            this._type = param4;
            registerDragger(bg);
            minWidth = 32;
            minHeight = 26;
            var _local_5:TextFormat = new TextFormat();
            var _local_6:Object = style.styleSheet.getStyle("low");
            _local_5.font = _local_6.fontFamily;
            _local_5.size = _local_6.fontSize;
            _local_5.color = style.lowColor;
            this.lowTxt = new TextField();
            this.lowTxt.name = "lowestField";
            this.lowTxt.defaultTextFormat = _local_5;
            this.lowTxt.mouseEnabled = false;
            this.lowTxt.height = style.menuFontSize + 2;
            addChild(this.lowTxt);
            this.highTxt = new TextField();
            this.highTxt.name = "highestField";
            this.highTxt.defaultTextFormat = _local_5;
            this.highTxt.mouseEnabled = false;
            this.highTxt.height = style.menuFontSize + 2;
            this.highTxt.y = style.menuFontSize - 4;
            addChild(this.highTxt);
            txtField = makeTF("menuField");
            txtField.height = style.menuFontSize + 4;
            txtField.y = -3;
            registerTFRoller(txtField,this.onMenuRollOver,this.linkHandler);
            registerDragger(txtField);
            addChild(txtField);
            this.underlay = new Shape();
            addChild(this.underlay);
            this.graph = new Shape();
            this.graph.name = "graph";
            this.graph.y = style.menuFontSize;
            addChild(this.graph);
            this._menuString = "<menu>";
            if(this._type == MEM) {
                this._menuString = this._menuString + " <a href=\"event:gc\">G</a> ";
            }
            this._menuString = this._menuString + "<a href=\"event:reset\">R</a> <a href=\"event:close\">X</a></menu></low></r>";
            init(param2,param3,true);
        }
        
        private function stop() : void {
            if(this._group) {
                console.graphing.remove(this._group.name);
            }
        }
        
        public function get group() : GraphGroup {
            return this._group;
        }
        
        public function reset() : void {
            this._infoMap = {};
            this.graph.graphics.clear();
            if(!this._group.fixed) {
                this._group.low = NaN;
                this._group.hi = NaN;
            }
        }
        
        override public function set height(param1:Number) : void {
            super.height = param1;
            this.lowTxt.y = param1 - style.menuFontSize;
            this._needRedraw = true;
            var _local_2:Graphics = this.underlay.graphics;
            _local_2.clear();
            _local_2.lineStyle(1,style.controlColor,0.6);
            _local_2.moveTo(0,this.graph.y);
            _local_2.lineTo(width - this.startOffset,this.graph.y);
            _local_2.lineTo(width - this.startOffset,param1);
        }
        
        override public function set width(param1:Number) : void {
            super.width = param1;
            this.lowTxt.width = param1;
            this.highTxt.width = param1;
            txtField.width = param1;
            txtField.scrollH = txtField.maxScrollH;
            this.graph.graphics.clear();
            this._needRedraw = true;
        }
        
        public function update(param1:GraphGroup, param2:Boolean) : void {
            var _local_11:GraphInterest = null;
            var _local_12:* = null;
            var _local_13:String = null;
            var _local_14:Array = null;
            var _local_15:Array = null;
            var _local_16:int = 0;
            var _local_17:int = 0;
            var _local_18:int = 0;
            var _local_19:int = 0;
            var _local_20:int = 0;
            var _local_21:Number = NaN;
            var _local_22:Boolean = false;
            this._group = param1;
            var _local_3:int = 1;
            if(param1.idle > 0) {
                _local_3 = 0;
                if(!this._needRedraw) {
                    return;
                }
            }
            if(this._needRedraw) {
                param2 = true;
            }
            this._needRedraw = false;
            var _local_4:Array = param1.interests;
            var _local_5:int = width - this.startOffset;
            var _local_6:int = height - this.graph.y;
            var _local_7:Number = param1.low;
            var _local_8:Number = param1.hi;
            var _local_9:Number = _local_8 - _local_7;
            var _local_10:Boolean = false;
            if(param2) {
                TextField(!!param1.inv?this.highTxt:this.lowTxt).text = String(param1.low);
                TextField(!!param1.inv?this.lowTxt:this.highTxt).text = String(param1.hi);
                this.graph.graphics.clear();
            }
            for each(_local_11 in _local_4) {
                this._interest = _local_11;
                _local_13 = this._interest.key;
                _local_14 = this._infoMap[_local_13];
                if(_local_14 == null) {
                    _local_10 = true;
                    _local_14 = new Array(this._interest.col.toString(16),new Array());
                    this._infoMap[_local_13] = _local_14;
                }
                _local_15 = _local_14[1];
                if(_local_3 == 1) {
                    if(param1.type == GraphGroup.FPS) {
                        _local_17 = Math.floor(param1.hi / this._interest.v);
                        if(_local_17 > 30) {
                            _local_17 = 30;
                        }
                        while(_local_17 > 0) {
                            _local_15.push(this._interest.v);
                            _local_17--;
                        }
                    } else {
                        _local_15.push(this._interest.v);
                    }
                }
                _local_16 = Math.floor(_local_5) + 10;
                while(_local_15.length > _local_16) {
                    _local_15.shift();
                }
                if(param2) {
                    _local_18 = _local_15.length;
                    this.graph.graphics.lineStyle(1,this._interest.col);
                    _local_19 = _local_5 > _local_18?int(_local_18):int(_local_5);
                    _local_20 = 1;
                    while(_local_20 < _local_19) {
                        _local_21 = (!!_local_9?(_local_15[_local_18 - _local_20] - _local_7) / _local_9:0.5) * _local_6;
                        if(!param1.inv) {
                            _local_21 = _local_6 - _local_21;
                        }
                        if(_local_21 < 0) {
                            _local_21 = 0;
                        }
                        if(_local_21 > _local_6) {
                            _local_21 = _local_6;
                        }
                        if(_local_20 == 1) {
                            this.graph.graphics.moveTo(width,_local_21);
                        }
                        this.graph.graphics.lineTo(_local_5 - _local_20,_local_21);
                        _local_20++;
                    }
                    if(isNaN(this._interest.avg) && _local_9) {
                        _local_21 = (this._interest.avg - _local_7) / _local_9 * _local_6;
                        if(!param1.inv) {
                            _local_21 = _local_6 - _local_21;
                        }
                        if(_local_21 < 0) {
                            _local_21 = 0;
                        }
                        if(_local_21 > _local_6) {
                            _local_21 = _local_6;
                        }
                        this.graph.graphics.lineStyle(1,this._interest.col,0.3);
                        this.graph.graphics.moveTo(0,_local_21);
                        this.graph.graphics.lineTo(_local_5,_local_21);
                    }
                }
            }
            for(_local_12 in this._infoMap) {
                for each(_local_11 in _local_4) {
                    if(_local_11.key == _local_12) {
                        _local_22 = true;
                    }
                }
                if(!_local_22) {
                    _local_10 = true;
                    delete this._infoMap[_local_12];
                }
            }
            if(param2 && (_local_10 || this._type)) {
                this.updateKeyText();
            }
        }
        
        public function updateKeyText() : void {
            var _local_2:* = null;
            var _local_1:* = "<r><low>";
            if(this._type) {
                if(isNaN(this._interest.v)) {
                    _local_1 = _local_1 + "no input";
                } else if(this._type == FPS) {
                    _local_1 = _local_1 + this._interest.avg.toFixed(1);
                } else {
                    _local_1 = _local_1 + (this._interest.v + "mb");
                }
            } else {
                for(_local_2 in this._infoMap) {
                    _local_1 = _local_1 + (" <font color=\'#" + this._infoMap[_local_2][0] + "\'>" + _local_2 + "</font>");
                }
                _local_1 = _local_1 + " |";
            }
            txtField.htmlText = _local_1 + this._menuString;
            txtField.scrollH = txtField.maxScrollH;
        }
        
        protected function linkHandler(param1:TextEvent) : void {
            TextField(param1.currentTarget).setSelection(0,0);
            if(param1.text == "reset") {
                this.reset();
            } else if(param1.text == "close") {
                if(this._type == FPS) {
                    console.fpsMonitor = false;
                } else if(this._type == MEM) {
                    console.memoryMonitor = false;
                } else {
                    this.stop();
                }
                console.panels.removeGraph(this._group);
            } else if(param1.text == "gc") {
                console.gc();
            }
            param1.stopPropagation();
        }
        
        protected function onMenuRollOver(param1:TextEvent) : void {
            var _local_2:String = !!param1.text?param1.text.replace("event:",""):null;
            if(_local_2 == "gc") {
                _local_2 = "Garbage collect::Requires debugger version of flash player";
            }
            console.panels.tooltip(_local_2,this);
        }
    }
}
