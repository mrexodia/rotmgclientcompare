package com.junkbyte.console.view {
    import com.junkbyte.console.Console;
    import com.junkbyte.console.vos.GraphGroup;
    import flash.events.Event;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    
    public class PanelsManager {
         
        
        private var console:Console;
        
        private var _mainPanel:MainPanel;
        
        private var _ruler:Ruler;
        
        private var _chsPanel:ChannelsPanel;
        
        private var _fpsPanel:GraphingPanel;
        
        private var _memPanel:GraphingPanel;
        
        private var _graphsMap:Object;
        
        private var _graphPlaced:uint = 0;
        
        private var _tooltipField:TextField;
        
        private var _canDraw:Boolean;
        
        public function PanelsManager(param1:Console) {
            this._graphsMap = {};
            super();
            this.console = param1;
            this._mainPanel = new MainPanel(this.console);
            this._tooltipField = this.mainPanel.makeTF("tooltip",true);
            this._tooltipField.mouseEnabled = false;
            this._tooltipField.autoSize = TextFieldAutoSize.CENTER;
            this._tooltipField.multiline = true;
            this.addPanel(this._mainPanel);
        }
        
        public function addPanel(param1:ConsolePanel) : void {
            if(this.console.contains(this._tooltipField)) {
                this.console.addChildAt(param1,this.console.getChildIndex(this._tooltipField));
            } else {
                this.console.addChild(param1);
            }
            param1.addEventListener(ConsolePanel.DRAGGING_STARTED,this.onPanelStartDragScale,false,0,true);
            param1.addEventListener(ConsolePanel.SCALING_STARTED,this.onPanelStartDragScale,false,0,true);
        }
        
        public function removePanel(param1:String) : void {
            var _local_2:ConsolePanel = this.console.getChildByName(param1) as ConsolePanel;
            if(_local_2) {
                _local_2.close();
            }
        }
        
        public function getPanel(param1:String) : ConsolePanel {
            return this.console.getChildByName(param1) as ConsolePanel;
        }
        
        public function get mainPanel() : MainPanel {
            return this._mainPanel;
        }
        
        public function panelExists(param1:String) : Boolean {
            return !!(this.console.getChildByName(param1) as ConsolePanel)?true:false;
        }
        
        public function setPanelArea(param1:String, param2:Rectangle) : void {
            var _local_3:ConsolePanel = this.getPanel(param1);
            if(_local_3) {
                _local_3.x = param2.x;
                _local_3.y = param2.y;
                if(param2.width) {
                    _local_3.width = param2.width;
                }
                if(param2.height) {
                    _local_3.height = param2.height;
                }
            }
        }
        
        public function updateMenu() : void {
            this._mainPanel.updateMenu();
            var _local_1:ChannelsPanel = this.getPanel(ChannelsPanel.NAME) as ChannelsPanel;
            if(_local_1) {
                _local_1.update();
            }
        }
        
        public function update(param1:Boolean, param2:Boolean) : void {
            this._canDraw = !param1;
            this._mainPanel.update(!param1 && param2);
            if(!param1) {
                if(param2 && this._chsPanel != null) {
                    this._chsPanel.update();
                }
            }
        }
        
        public function updateGraphs(param1:Array) : void {
            var _local_2:Object = null;
            var _local_3:GraphGroup = null;
            var _local_4:GraphGroup = null;
            var _local_5:GraphGroup = null;
            var _local_6:* = null;
            var _local_7:String = null;
            var _local_8:GraphingPanel = null;
            var _local_9:Rectangle = null;
            var _local_10:Number = NaN;
            var _local_11:Number = NaN;
            var _local_12:int = 0;
            var _local_13:int = 0;
            this._graphPlaced = 0;
            for each(_local_5 in param1) {
                if(_local_5.type == GraphGroup.FPS) {
                    _local_3 = _local_5;
                } else if(_local_5.type == GraphGroup.MEM) {
                    _local_4 = _local_5;
                } else {
                    _local_7 = _local_5.name;
                    _local_8 = this._graphsMap[_local_7] as GraphingPanel;
                    if(!_local_8) {
                        _local_9 = _local_5.rect;
                        if(_local_9 == null) {
                            _local_9 = new Rectangle(NaN,NaN,0,0);
                        }
                        _local_10 = 100;
                        if(isNaN(_local_9.x) || isNaN(_local_9.y)) {
                            if(this._mainPanel.width < 150) {
                                _local_10 = 50;
                            }
                            _local_11 = Math.floor(this._mainPanel.width / _local_10) - 1;
                            if(_local_11 <= 1) {
                                _local_11 = 2;
                            }
                            _local_12 = this._graphPlaced % _local_11;
                            _local_13 = Math.floor(this._graphPlaced / _local_11);
                            _local_9.x = this._mainPanel.x + _local_10 + _local_12 * _local_10;
                            _local_9.y = this._mainPanel.y + _local_10 * 0.6 + _local_13 * _local_10;
                            this._graphPlaced++;
                        }
                        if(_local_9.width <= 0 || isNaN(_local_9.width)) {
                            _local_9.width = _local_10;
                        }
                        if(_local_9.height <= 0 || isNaN(_local_9.height)) {
                            _local_9.height = _local_10;
                        }
                        _local_8 = new GraphingPanel(this.console,_local_9.width,_local_9.height);
                        _local_8.x = _local_9.x;
                        _local_8.y = _local_9.y;
                        _local_8.name = "graph_" + _local_7;
                        this._graphsMap[_local_7] = _local_8;
                        this.addPanel(_local_8);
                    }
                    if(_local_2 == null) {
                        _local_2 = {};
                    }
                    _local_2[_local_7] = true;
                    _local_8.update(_local_5,this._canDraw);
                }
            }
            for(_local_6 in this._graphsMap) {
                if(_local_2 == null || !_local_2[_local_6]) {
                    this._graphsMap[_local_6].close();
                    delete this._graphsMap[_local_6];
                }
            }
            if(_local_3 != null) {
                if(this._fpsPanel == null) {
                    this._fpsPanel = new GraphingPanel(this.console,80,40,GraphingPanel.FPS);
                    this._fpsPanel.name = GraphingPanel.FPS;
                    this._fpsPanel.x = this._mainPanel.x + this._mainPanel.width - 160;
                    this._fpsPanel.y = this._mainPanel.y + 15;
                    this.addPanel(this._fpsPanel);
                    this._mainPanel.updateMenu();
                }
                this._fpsPanel.update(_local_3,this._canDraw);
            } else if(this._fpsPanel != null) {
                this.removePanel(GraphingPanel.FPS);
                this._fpsPanel = null;
            }
            if(_local_4 != null) {
                if(this._memPanel == null) {
                    this._memPanel = new GraphingPanel(this.console,80,40,GraphingPanel.MEM);
                    this._memPanel.name = GraphingPanel.MEM;
                    this._memPanel.x = this._mainPanel.x + this._mainPanel.width - 80;
                    this._memPanel.y = this._mainPanel.y + 15;
                    this.addPanel(this._memPanel);
                    this._mainPanel.updateMenu();
                }
                this._memPanel.update(_local_4,this._canDraw);
            } else if(this._memPanel != null) {
                this.removePanel(GraphingPanel.MEM);
                this._memPanel = null;
            }
            this._canDraw = false;
        }
        
        public function removeGraph(param1:GraphGroup) : void {
            var _local_2:GraphingPanel = null;
            if(this._fpsPanel && param1 == this._fpsPanel.group) {
                this._fpsPanel.close();
                this._fpsPanel = null;
            } else if(this._memPanel && param1 == this._memPanel.group) {
                this._memPanel.close();
                this._memPanel = null;
            } else {
                _local_2 = this._graphsMap[param1.name];
                if(_local_2) {
                    _local_2.close();
                    delete this._graphsMap[param1.name];
                }
            }
        }
        
        public function get displayRoller() : Boolean {
            return !!(this.getPanel(RollerPanel.NAME) as RollerPanel)?true:false;
        }
        
        public function set displayRoller(param1:Boolean) : void {
            var _local_2:RollerPanel = null;
            if(this.displayRoller != param1) {
                if(param1) {
                    if(this.console.config.displayRollerEnabled) {
                        _local_2 = new RollerPanel(this.console);
                        _local_2.x = this._mainPanel.x + this._mainPanel.width - 180;
                        _local_2.y = this._mainPanel.y + 55;
                        this.addPanel(_local_2);
                    } else {
                        this.console.report("Display roller is disabled in config.",9);
                    }
                } else {
                    this.removePanel(RollerPanel.NAME);
                }
                this._mainPanel.updateMenu();
            }
        }
        
        public function get channelsPanel() : Boolean {
            return this._chsPanel != null;
        }
        
        public function set channelsPanel(param1:Boolean) : void {
            if(this.channelsPanel != param1) {
                this.console.logs.cleanChannels();
                if(param1) {
                    this._chsPanel = new ChannelsPanel(this.console);
                    this._chsPanel.x = this._mainPanel.x + this._mainPanel.width - 332;
                    this._chsPanel.y = this._mainPanel.y - 2;
                    this.addPanel(this._chsPanel);
                    this._chsPanel.update();
                    this.updateMenu();
                } else {
                    this.removePanel(ChannelsPanel.NAME);
                    this._chsPanel = null;
                }
                this.updateMenu();
            }
        }
        
        public function get memoryMonitor() : Boolean {
            return this._memPanel != null;
        }
        
        public function get fpsMonitor() : Boolean {
            return this._fpsPanel != null;
        }
        
        public function tooltip(param1:String = null, param2:ConsolePanel = null) : void {
            var _local_3:Array = null;
            var _local_4:Rectangle = null;
            var _local_5:Rectangle = null;
            var _local_6:Number = NaN;
            var _local_7:Number = NaN;
            var _local_8:Number = NaN;
            if(param1 && !this.rulerActive) {
                _local_3 = param1.split("::");
                param1 = _local_3[0];
                if(_local_3.length > 1) {
                    param1 = param1 + ("<br/><low>" + _local_3[1] + "</low>");
                }
                this.console.addChild(this._tooltipField);
                this._tooltipField.wordWrap = false;
                this._tooltipField.htmlText = "<tt>" + param1 + "</tt>";
                if(this._tooltipField.width > 120) {
                    this._tooltipField.width = 120;
                    this._tooltipField.wordWrap = true;
                }
                this._tooltipField.x = this.console.mouseX - this._tooltipField.width / 2;
                this._tooltipField.y = this.console.mouseY + 20;
                if(param2) {
                    _local_4 = this._tooltipField.getBounds(this.console);
                    _local_5 = new Rectangle(param2.x,param2.y,param2.width,param2.height);
                    _local_6 = _local_4.bottom - _local_5.bottom;
                    if(_local_6 > 0) {
                        if(this._tooltipField.y - _local_6 > this.console.mouseY + 15) {
                            this._tooltipField.y = this._tooltipField.y - _local_6;
                        } else if(_local_5.y < this.console.mouseY - 24 && _local_4.y > _local_5.bottom) {
                            this._tooltipField.y = this.console.mouseY - this._tooltipField.height - 15;
                        }
                    }
                    _local_7 = _local_4.left - _local_5.left;
                    _local_8 = _local_4.right - _local_5.right;
                    if(_local_7 < 0) {
                        this._tooltipField.x = this._tooltipField.x - _local_7;
                    } else if(_local_8 > 0) {
                        this._tooltipField.x = this._tooltipField.x - _local_8;
                    }
                }
            } else if(this.console.contains(this._tooltipField)) {
                this.console.removeChild(this._tooltipField);
            }
        }
        
        public function startRuler() : void {
            if(this.rulerActive) {
                return;
            }
            this._ruler = new Ruler(this.console);
            this._ruler.addEventListener(Event.COMPLETE,this.onRulerExit,false,0,true);
            this.console.addChild(this._ruler);
            this._mainPanel.updateMenu();
        }
        
        public function get rulerActive() : Boolean {
            return this._ruler && this.console.contains(this._ruler)?true:false;
        }
        
        private function onRulerExit(param1:Event) : void {
            if(this._ruler && this.console.contains(this._ruler)) {
                this.console.removeChild(this._ruler);
            }
            this._ruler = null;
            this._mainPanel.updateMenu();
        }
        
        private function onPanelStartDragScale(param1:Event) : void {
            var _local_3:Array = null;
            var _local_4:Array = null;
            var _local_5:int = 0;
            var _local_6:int = 0;
            var _local_7:ConsolePanel = null;
            var _local_2:ConsolePanel = param1.currentTarget as ConsolePanel;
            if(this.console.config.style.panelSnapping) {
                _local_3 = [0];
                _local_4 = [0];
                if(this.console.stage) {
                    _local_3.push(this.console.stage.stageWidth);
                    _local_4.push(this.console.stage.stageHeight);
                }
                _local_5 = this.console.numChildren;
                _local_6 = 0;
                while(_local_6 < _local_5) {
                    _local_7 = this.console.getChildAt(_local_6) as ConsolePanel;
                    if(_local_7 && _local_7.visible) {
                        _local_3.push(_local_7.x,_local_7.x + _local_7.width);
                        _local_4.push(_local_7.y,_local_7.y + _local_7.height);
                    }
                    _local_6++;
                }
                _local_2.registerSnaps(_local_3,_local_4);
            }
        }
    }
}
