package com.junkbyte.console.core {
    import com.junkbyte.console.Cc;
    import com.junkbyte.console.Console;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.utils.ByteArray;
    import flash.utils.describeType;
    import flash.utils.getQualifiedClassName;
    
    public class ConsoleTools extends ConsoleCore {
         
        
        public function ConsoleTools(param1:Console) {
            super(param1);
        }
        
        public function map(param1:DisplayObjectContainer, param2:uint = 0, param3:String = null) : void {
            var _local_5:Boolean = false;
            var _local_9:DisplayObject = null;
            var _local_10:String = null;
            var _local_11:DisplayObjectContainer = null;
            var _local_12:int = 0;
            var _local_13:int = 0;
            var _local_14:DisplayObject = null;
            var _local_15:uint = 0;
            var _local_16:* = null;
            if(!param1) {
                report("Not a DisplayObjectContainer.",10,true,param3);
                return;
            }
            var _local_4:int = 0;
            var _local_6:int = 0;
            var _local_7:DisplayObject = null;
            var _local_8:Array = new Array();
            _local_8.push(param1);
            while(_local_6 < _local_8.length) {
                _local_9 = _local_8[_local_6];
                _local_6++;
                if(_local_9 is DisplayObjectContainer) {
                    _local_11 = _local_9 as DisplayObjectContainer;
                    _local_12 = _local_11.numChildren;
                    _local_13 = 0;
                    while(_local_13 < _local_12) {
                        _local_14 = _local_11.getChildAt(_local_13);
                        _local_8.splice(_local_6 + _local_13,0,_local_14);
                        _local_13++;
                    }
                }
                if(_local_7) {
                    if(_local_7 is DisplayObjectContainer && (_local_7 as DisplayObjectContainer).contains(_local_9)) {
                        _local_4++;
                    } else {
                        while(_local_7) {
                            _local_7 = _local_7.parent;
                            if(_local_7 is DisplayObjectContainer) {
                                if(_local_4 > 0) {
                                    _local_4--;
                                }
                                if((_local_7 as DisplayObjectContainer).contains(_local_9)) {
                                    _local_4++;
                                    break;
                                }
                            }
                        }
                    }
                }
                _local_10 = "";
                _local_13 = 0;
                while(_local_13 < _local_4) {
                    _local_10 = _local_10 + (_local_13 == _local_4 - 1?" ∟ ":" - ");
                    _local_13++;
                }
                if(param2 <= 0 || _local_4 <= param2) {
                    _local_5 = false;
                    _local_15 = console.refs.setLogRef(_local_9);
                    _local_16 = _local_9.name;
                    if(_local_15) {
                        _local_16 = "<a href=\'event:cl_" + _local_15 + "\'>" + _local_16 + "</a>";
                    }
                    if(_local_9 is DisplayObjectContainer) {
                        _local_16 = "<b>" + _local_16 + "</b>";
                    } else {
                        _local_16 = "<i>" + _local_16 + "</i>";
                    }
                    _local_10 = _local_10 + (_local_16 + " " + console.refs.makeRefTyped(_local_9));
                    report(_local_10,_local_9 is DisplayObjectContainer?5:2,true,param3);
                } else if(!_local_5) {
                    _local_5 = true;
                    report(_local_10 + "...",5,true,param3);
                }
                _local_7 = _local_9;
            }
            report(param1.name + ":" + console.refs.makeRefTyped(param1) + " has " + (_local_8.length - 1) + " children/sub-children.",9,true,param3);
            if(config.commandLineAllowed) {
                report("Click on the child display\'s name to set scope.",-2,true,param3);
            }
        }
        
        public function explode(param1:Object, param2:int = 3, param3:int = 9) : String {
            var _local_6:XMLList = null;
            var _local_7:String = null;
            var _local_9:XML = null;
            var _local_10:XML = null;
            var _local_11:* = null;
            var _local_4:* = typeof param1;
            if(param1 == null) {
                return "<p-2>" + param1 + "</p-2>";
            }
            if(param1 is String) {
                return "\"" + LogReferences.EscHTML(param1 as String) + "\"";
            }
            if(_local_4 != "object" || param2 == 0 || param1 is ByteArray) {
                return console.refs.makeString(param1);
            }
            if(param3 < 0) {
                param3 = 0;
            }
            var _local_5:XML = describeType(param1);
            var _local_8:Array = [];
            _local_6 = _local_5["accessor"];
            for each(_local_9 in _local_6) {
                _local_7 = _local_9.@name;
                if(_local_9.@access != "writeonly") {
                    try {
                        _local_8.push(this.stepExp(param1,_local_7,param2,param3));
                    }
                    catch(e:Error) {
                    }
                } else {
                    _local_8.push(_local_7);
                }
            }
            _local_6 = _local_5["variable"];
            for each(_local_10 in _local_6) {
                _local_7 = _local_10.@name;
                _local_8.push(this.stepExp(param1,_local_7,param2,param3));
            }
            try {
                for(_local_11 in param1) {
                    _local_8.push(this.stepExp(param1,_local_11,param2,param3));
                }
            }
            catch(e:Error) {
            }
            return "<p" + param3 + ">{" + LogReferences.ShortClassName(param1) + "</p" + param3 + "> " + _local_8.join(", ") + "<p" + param3 + ">}</p" + param3 + ">";
        }
        
        private function stepExp(param1:*, param2:String, param3:int, param4:int) : String {
            return param2 + ":" + this.explode(param1[param2],param3 - 1,param4 - 1);
        }
        
        public function getStack(param1:int, param2:int) : String {
            var _local_3:Error = new Error();
            var _local_4:String = !!_local_3.hasOwnProperty("getStackTrace")?_local_3.getStackTrace():null;
            if(!_local_4) {
                return "";
            }
            var _local_5:String = "";
            var _local_6:Array = _local_4.split(/\n\sat\s/);
            var _local_7:int = _local_6.length;
            var _local_8:RegExp = new RegExp("Function|" + getQualifiedClassName(Console) + "|" + getQualifiedClassName(Cc));
            var _local_9:Boolean = false;
            var _local_10:int = 2;
            while(_local_10 < _local_7) {
                if(!_local_9 && _local_6[_local_10].search(_local_8) != 0) {
                    _local_9 = true;
                }
                if(_local_9) {
                    _local_5 = _local_5 + ("\n<p" + param2 + "> @ " + _local_6[_local_10] + "</p" + param2 + ">");
                    if(param2 > 0) {
                        param2--;
                    }
                    param1--;
                    if(param1 <= 0) {
                        break;
                    }
                }
                _local_10++;
            }
            return _local_5;
        }
    }
}
