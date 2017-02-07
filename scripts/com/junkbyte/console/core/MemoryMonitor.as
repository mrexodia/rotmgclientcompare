package com.junkbyte.console.core {
    import com.junkbyte.console.Console;
    import flash.system.System;
    import flash.utils.Dictionary;
    import flash.utils.getQualifiedClassName;
    import flash.utils.getTimer;
    
    public class MemoryMonitor extends ConsoleCore {
         
        
        private var _namesList:Object;
        
        private var _objectsList:Dictionary;
        
        private var _count:uint;
        
        public function MemoryMonitor(param1:Console) {
            super(param1);
            this._namesList = new Object();
            this._objectsList = new Dictionary(true);
            console.remoter.registerCallback("gc",this.gc);
        }
        
        public function watch(param1:Object, param2:String) : String {
            var _local_3:String = getQualifiedClassName(param1);
            if(!param2) {
                param2 = _local_3 + "@" + getTimer();
            }
            if(this._objectsList[param1]) {
                if(this._namesList[this._objectsList[param1]]) {
                    this.unwatch(this._objectsList[param1]);
                }
            }
            if(this._namesList[param2]) {
                if(this._objectsList[param1] == param2) {
                    this._count--;
                } else {
                    param2 = param2 + "@" + getTimer() + "_" + Math.floor(Math.random() * 100);
                }
            }
            this._namesList[param2] = true;
            this._count++;
            this._objectsList[param1] = param2;
            return param2;
        }
        
        public function unwatch(param1:String) : void {
            var _local_2:* = null;
            for(_local_2 in this._objectsList) {
                if(this._objectsList[_local_2] == param1) {
                    delete this._objectsList[_local_2];
                }
            }
            if(this._namesList[param1]) {
                delete this._namesList[param1];
                this._count--;
            }
        }
        
        public function update() : void {
            var _local_3:* = null;
            var _local_4:* = null;
            if(this._count == 0) {
                return;
            }
            var _local_1:Array = new Array();
            var _local_2:Object = new Object();
            for(_local_3 in this._objectsList) {
                _local_2[this._objectsList[_local_3]] = true;
            }
            for(_local_4 in this._namesList) {
                if(!_local_2[_local_4]) {
                    _local_1.push(_local_4);
                    delete this._namesList[_local_4];
                    this._count--;
                }
            }
            if(_local_1.length) {
                report("<b>GARBAGE COLLECTED " + _local_1.length + " item(s): </b>" + _local_1.join(", "),-2);
            }
        }
        
        public function get count() : uint {
            return this._count;
        }
        
        public function gc() : void {
            var ok:Boolean = false;
            var str:String = null;
            if(remoter.remoting == Remoting.RECIEVER) {
                try {
                    remoter.send("gc");
                }
                catch(e:Error) {
                    report(e,10);
                }
            } else {
                try {
                    if(System["gc"] != null) {
                        System["gc"]();
                        ok = true;
                    }
                }
                catch(e:Error) {
                }
                str = "Manual garbage collection " + (!!ok?"successful.":"FAILED. You need debugger version of flash player.");
                report(str,!!ok?-1:10);
            }
        }
    }
}
