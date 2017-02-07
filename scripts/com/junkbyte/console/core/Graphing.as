package com.junkbyte.console.core {
    import com.junkbyte.console.Console;
    import com.junkbyte.console.vos.GraphGroup;
    import com.junkbyte.console.vos.GraphInterest;
    import flash.geom.Rectangle;
    import flash.system.System;
    import flash.utils.ByteArray;
    import flash.utils.getTimer;
    
    public class Graphing extends ConsoleCore {
         
        
        private var _groups:Array;
        
        private var _map:Object;
        
        private var _fpsGroup:GraphGroup;
        
        private var _memGroup:GraphGroup;
        
        private var _hadGraph:Boolean;
        
        private var _previousTime:Number = -1;
        
        public function Graphing(param1:Console) {
            var m:Console = param1;
            this._groups = [];
            this._map = {};
            super(m);
            remoter.registerCallback("fps",function(param1:ByteArray):void {
                fpsMonitor = param1.readBoolean();
            });
            remoter.registerCallback("mem",function(param1:ByteArray):void {
                memoryMonitor = param1.readBoolean();
            });
            remoter.registerCallback("removeGroup",function(param1:ByteArray):void {
                removeGroup(param1.readUTF());
            });
            remoter.registerCallback("graph",this.handleRemoteGraph,true);
        }
        
        public function add(param1:String, param2:Object, param3:String, param4:Number = -1, param5:String = null, param6:Rectangle = null, param7:Boolean = false) : void {
            var newGroup:Boolean = false;
            var i:GraphInterest = null;
            var n:String = param1;
            var obj:Object = param2;
            var prop:String = param3;
            var col:Number = param4;
            var key:String = param5;
            var rect:Rectangle = param6;
            var inverse:Boolean = param7;
            if(obj == null) {
                report("ERROR: Graph [" + n + "] received a null object to graph property [" + prop + "].",10);
                return;
            }
            var group:GraphGroup = this._map[n];
            if(!group) {
                newGroup = true;
                group = new GraphGroup(n);
            }
            var interests:Array = group.interests;
            if(isNaN(col) || col < 0) {
                if(interests.length <= 5) {
                    col = config.style["priority" + (10 - interests.length * 2)];
                } else {
                    col = Math.random() * 16777215;
                }
            }
            if(key == null) {
                key = prop;
            }
            for each(i in interests) {
                if(i.key == key) {
                    report("Graph with key [" + key + "] already exists in [" + n + "]",10);
                    return;
                }
            }
            if(rect) {
                group.rect = rect;
            }
            if(inverse) {
                group.inv = inverse;
            }
            var interest:GraphInterest = new GraphInterest(key,col);
            var v:Number = NaN;
            try {
                v = interest.setObject(obj,prop);
            }
            catch(e:Error) {
                report("Error with graph value for [" + key + "] in [" + n + "]. " + e,10);
                return;
            }
            if(isNaN(v)) {
                report("Graph value for key [" + key + "] in [" + n + "] is not a number (NaN).",10);
            } else {
                group.interests.push(interest);
                if(newGroup) {
                    this._map[n] = group;
                    this._groups.push(group);
                }
            }
        }
        
        public function fixRange(param1:String, param2:Number = NaN, param3:Number = NaN) : void {
            var _local_4:GraphGroup = this._map[param1];
            if(!_local_4) {
                return;
            }
            _local_4.low = param2;
            _local_4.hi = param3;
            _local_4.fixed = !(isNaN(param2) || isNaN(param3));
        }
        
        public function remove(param1:String, param2:Object = null, param3:String = null) : void {
            var _local_4:Array = null;
            var _local_5:int = 0;
            var _local_6:GraphInterest = null;
            if(param2 == null && param3 == null) {
                this.removeGroup(param1);
            } else if(this._map[param1]) {
                _local_4 = this._map[param1].interests;
                _local_5 = _local_4.length - 1;
                while(_local_5 >= 0) {
                    _local_6 = _local_4[_local_5];
                    if((param2 == null || _local_6.obj == param2) && (param3 == null || _local_6.prop == param3)) {
                        _local_4.splice(_local_5,1);
                    }
                    _local_5--;
                }
                if(_local_4.length == 0) {
                    this.removeGroup(param1);
                }
            }
        }
        
        private function removeGroup(param1:String) : void {
            var _local_2:ByteArray = null;
            var _local_3:GraphGroup = null;
            var _local_4:int = 0;
            if(remoter.remoting == Remoting.RECIEVER) {
                _local_2 = new ByteArray();
                _local_2.writeUTF(param1);
                remoter.send("removeGroup",_local_2);
            } else {
                _local_3 = this._map[param1];
                _local_4 = this._groups.indexOf(_local_3);
                if(_local_4 >= 0) {
                    this._groups.splice(_local_4,1);
                }
                delete this._map[param1];
            }
        }
        
        public function get fpsMonitor() : Boolean {
            if(remoter.remoting == Remoting.RECIEVER) {
                return console.panels.fpsMonitor;
            }
            return this._fpsGroup != null;
        }
        
        public function set fpsMonitor(param1:Boolean) : void {
            var _local_2:ByteArray = null;
            var _local_3:int = 0;
            if(remoter.remoting == Remoting.RECIEVER) {
                _local_2 = new ByteArray();
                _local_2.writeBoolean(param1);
                remoter.send("fps",_local_2);
            } else if(param1 != this.fpsMonitor) {
                if(param1) {
                    this._fpsGroup = this.addSpecialGroup(GraphGroup.FPS);
                    this._fpsGroup.low = 0;
                    this._fpsGroup.fixed = true;
                    this._fpsGroup.averaging = 30;
                } else {
                    this._previousTime = -1;
                    _local_3 = this._groups.indexOf(this._fpsGroup);
                    if(_local_3 >= 0) {
                        this._groups.splice(_local_3,1);
                    }
                    this._fpsGroup = null;
                }
                console.panels.mainPanel.updateMenu();
            }
        }
        
        public function get memoryMonitor() : Boolean {
            if(remoter.remoting == Remoting.RECIEVER) {
                return console.panels.memoryMonitor;
            }
            return this._memGroup != null;
        }
        
        public function set memoryMonitor(param1:Boolean) : void {
            var _local_2:ByteArray = null;
            var _local_3:int = 0;
            if(remoter.remoting == Remoting.RECIEVER) {
                _local_2 = new ByteArray();
                _local_2.writeBoolean(param1);
                remoter.send("mem",_local_2);
            } else if(param1 != this.memoryMonitor) {
                if(param1) {
                    this._memGroup = this.addSpecialGroup(GraphGroup.MEM);
                    this._memGroup.freq = 20;
                } else {
                    _local_3 = this._groups.indexOf(this._memGroup);
                    if(_local_3 >= 0) {
                        this._groups.splice(_local_3,1);
                    }
                    this._memGroup = null;
                }
                console.panels.mainPanel.updateMenu();
            }
        }
        
        private function addSpecialGroup(param1:int) : GraphGroup {
            var _local_2:GraphGroup = new GraphGroup("special");
            _local_2.type = param1;
            this._groups.push(_local_2);
            var _local_3:GraphInterest = new GraphInterest("special");
            if(param1 == GraphGroup.FPS) {
                _local_3.col = 16724787;
            } else {
                _local_3.col = 5267711;
            }
            _local_2.interests.push(_local_3);
            return _local_2;
        }
        
        public function update(param1:Number = 0) : Array {
            var _local_2:GraphInterest = null;
            var _local_3:Number = NaN;
            var _local_4:GraphGroup = null;
            var _local_5:Boolean = false;
            var _local_6:uint = 0;
            var _local_7:uint = 0;
            var _local_8:Array = null;
            var _local_9:int = 0;
            var _local_10:Number = NaN;
            var _local_11:uint = 0;
            var _local_12:ByteArray = null;
            var _local_13:uint = 0;
            for each(_local_4 in this._groups) {
                _local_5 = true;
                if(_local_4.freq > 1) {
                    _local_4.idle++;
                    if(_local_4.idle < _local_4.freq) {
                        _local_5 = false;
                    } else {
                        _local_4.idle = 0;
                    }
                }
                if(_local_5) {
                    _local_6 = _local_4.type;
                    _local_7 = _local_4.averaging;
                    _local_8 = _local_4.interests;
                    if(_local_6 == GraphGroup.FPS) {
                        _local_4.hi = param1;
                        _local_2 = _local_8[0];
                        _local_9 = getTimer();
                        if(this._previousTime >= 0) {
                            _local_10 = _local_9 - this._previousTime;
                            _local_3 = 1000 / _local_10;
                            _local_2.setValue(_local_3,_local_7);
                        }
                        this._previousTime = _local_9;
                    } else if(_local_6 == GraphGroup.MEM) {
                        _local_2 = _local_8[0];
                        _local_3 = Math.round(System.totalMemory / 10485.76) / 100;
                        _local_4.updateMinMax(_local_3);
                        _local_2.setValue(_local_3,_local_7);
                    } else {
                        this.updateExternalGraphGroup(_local_4);
                    }
                }
            }
            if(remoter.canSend && (this._hadGraph || this._groups.length)) {
                _local_11 = this._groups.length;
                _local_12 = new ByteArray();
                _local_13 = 0;
                while(_local_13 < _local_11) {
                    GraphGroup(this._groups[_local_13]).toBytes(_local_12);
                    _local_13++;
                }
                remoter.send("graph",_local_12);
                this._hadGraph = this._groups.length > 0;
            }
            return this._groups;
        }
        
        private function updateExternalGraphGroup(param1:GraphGroup) : void {
            var i:GraphInterest = null;
            var v:Number = NaN;
            var group:GraphGroup = param1;
            for each(i in group.interests) {
                try {
                    v = i.getCurrentValue();
                    i.setValue(v,group.averaging);
                }
                catch(e:Error) {
                    report("Error with graph value for key [" + i.key + "] in [" + group.name + "]. " + e,10);
                    remove(group.name,i.obj,i.prop);
                }
                group.updateMinMax(v);
            }
        }
        
        private function handleRemoteGraph(param1:ByteArray = null) : void {
            var _local_2:Array = null;
            if(param1 && param1.length) {
                param1.position = 0;
                _local_2 = new Array();
                while(param1.bytesAvailable) {
                    _local_2.push(GraphGroup.FromBytes(param1));
                }
                console.panels.updateGraphs(_local_2);
            } else {
                console.panels.updateGraphs(new Array());
            }
        }
    }
}
