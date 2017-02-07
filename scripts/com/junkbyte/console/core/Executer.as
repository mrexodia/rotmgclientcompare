package com.junkbyte.console.core {
    import com.junkbyte.console.vos.WeakObject;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.utils.getDefinitionByName;
    
    public class Executer extends EventDispatcher {
        
        public static const RETURNED:String = "returned";
        
        public static const CLASSES:String = "ExeValue|((com.junkbyte.console.core::)?Executer)";
        
        private static const VALKEY:String = "#";
         
        
        private var _values:Array;
        
        private var _running:Boolean;
        
        private var _scope;
        
        private var _returned;
        
        private var _saved:Object;
        
        private var _reserved:Array;
        
        public var autoScope:Boolean;
        
        public function Executer() {
            super();
        }
        
        public static function Exec(param1:Object, param2:String, param3:Object = null) : * {
            var _local_4:Executer = new Executer();
            _local_4.setStored(param3);
            return _local_4.exec(param1,param2);
        }
        
        public function get returned() : * {
            return this._returned;
        }
        
        public function get scope() : * {
            return this._scope;
        }
        
        public function setStored(param1:Object) : void {
            this._saved = param1;
        }
        
        public function setReserved(param1:Array) : void {
            this._reserved = param1;
        }
        
        public function exec(param1:*, param2:String) : * {
            var s:* = param1;
            var str:String = param2;
            if(this._running) {
                throw new Error("CommandExec.exec() is already runnnig. Does not support loop backs.");
            }
            this._running = true;
            this._scope = s;
            this._values = [];
            if(!this._saved) {
                this._saved = new Object();
            }
            if(!this._reserved) {
                this._reserved = new Array();
            }
            try {
                this._exec(str);
            }
            catch(e:Error) {
                reset();
                throw e;
            }
            this.reset();
            return this._returned;
        }
        
        private function reset() : void {
            this._saved = null;
            this._reserved = null;
            this._values = null;
            this._running = false;
        }
        
        private function _exec(param1:String) : void {
            var _local_5:String = null;
            var _local_6:String = null;
            var _local_7:String = null;
            var _local_8:int = 0;
            var _local_9:int = 0;
            var _local_10:String = null;
            var _local_11:* = undefined;
            var _local_2:RegExp = /''|""|('(.*?)[^\\]')|("(.*?)[^\\]")/;
            var _local_3:Object = _local_2.exec(param1);
            while(_local_3 != null) {
                _local_6 = _local_3[0];
                _local_7 = _local_6.charAt(0);
                _local_8 = _local_6.indexOf(_local_7);
                _local_9 = _local_6.lastIndexOf(_local_7);
                _local_10 = _local_6.substring(_local_8 + 1,_local_9).replace(/\\(.)/g,"$1");
                param1 = this.tempValue(param1,new ExeValue(_local_10),_local_3.index + _local_8,_local_3.index + _local_9 + 1);
                _local_3 = _local_2.exec(param1);
            }
            if(param1.search(/'|"/) >= 0) {
                throw new Error("Bad syntax extra quotation marks");
            }
            var _local_4:Array = param1.split(/\s*;\s*/);
            for each(_local_5 in _local_4) {
                if(_local_5.length) {
                    _local_11 = this._saved[RETURNED];
                    if(_local_11 && _local_5 == "/") {
                        this._scope = _local_11;
                        dispatchEvent(new Event(Event.COMPLETE));
                    } else {
                        this.execNest(_local_5);
                    }
                }
            }
        }
        
        private function execNest(param1:String) : * {
            var _local_3:int = 0;
            var _local_4:int = 0;
            var _local_5:int = 0;
            var _local_6:String = null;
            var _local_7:Boolean = false;
            var _local_8:int = 0;
            var _local_9:String = null;
            var _local_10:Array = null;
            var _local_11:* = null;
            var _local_12:ExeValue = null;
            var _local_13:* = null;
            param1 = this.ignoreWhite(param1);
            var _local_2:int = param1.lastIndexOf("(");
            while(_local_2 >= 0) {
                _local_3 = param1.indexOf(")",_local_2);
                if(param1.substring(_local_2 + 1,_local_3).search(/\w/) >= 0) {
                    _local_4 = _local_2;
                    _local_5 = _local_2 + 1;
                    while(_local_4 >= 0 && _local_4 < _local_5) {
                        _local_4++;
                        _local_4 = param1.indexOf("(",_local_4);
                        _local_5 = param1.indexOf(")",_local_5 + 1);
                    }
                    _local_6 = param1.substring(_local_2 + 1,_local_5);
                    _local_7 = false;
                    _local_8 = _local_2 - 1;
                    while(true) {
                        _local_9 = param1.charAt(_local_8);
                        if(_local_9.match(/[^\s]/) || _local_8 <= 0) {
                            break;
                        }
                        _local_8--;
                    }
                    if(_local_9.match(/\w/)) {
                        _local_7 = true;
                    }
                    if(_local_7) {
                        _local_10 = _local_6.split(",");
                        param1 = this.tempValue(param1,new ExeValue(_local_10),_local_2 + 1,_local_5);
                        for(_local_11 in _local_10) {
                            _local_10[_local_11] = this.execOperations(this.ignoreWhite(_local_10[_local_11])).value;
                        }
                    } else {
                        _local_12 = new ExeValue(_local_12);
                        param1 = this.tempValue(param1,_local_12,_local_2,_local_5 + 1);
                        _local_12.setValue(this.execOperations(this.ignoreWhite(_local_6)).value);
                    }
                }
                _local_2 = param1.lastIndexOf("(",_local_2 - 1);
            }
            this._returned = this.execOperations(param1).value;
            if(this._returned && this.autoScope) {
                _local_13 = typeof this._returned;
                if(_local_13 == "object" || _local_13 == "xml") {
                    this._scope = this._returned;
                }
            }
            dispatchEvent(new Event(Event.COMPLETE));
            return this._returned;
        }
        
        private function tempValue(param1:String, param2:*, param3:int, param4:int) : String {
            param1 = param1.substring(0,param3) + VALKEY + this._values.length + param1.substring(param4);
            this._values.push(param2);
            return param1;
        }
        
        private function execOperations(param1:String) : ExeValue {
            var _local_7:String = null;
            var _local_8:* = undefined;
            var _local_11:int = 0;
            var _local_12:int = 0;
            var _local_13:String = null;
            var _local_14:ExeValue = null;
            var _local_15:ExeValue = null;
            var _local_2:RegExp = /\s*(((\|\||\&\&|[+|\-|*|\/|\%|\||\&|\^]|\=\=?|\!\=|\>\>?\>?|\<\<?)\=?)|=|\~|\sis\s|typeof|delete\s)\s*/g;
            var _local_3:Object = _local_2.exec(param1);
            var _local_4:Array = [];
            if(_local_3 == null) {
                _local_4.push(param1);
            } else {
                _local_11 = 0;
                while(_local_3 != null) {
                    _local_12 = _local_3.index;
                    _local_13 = _local_3[0];
                    _local_3 = _local_2.exec(param1);
                    if(_local_3 == null) {
                        _local_4.push(param1.substring(_local_11,_local_12));
                        _local_4.push(this.ignoreWhite(_local_13));
                        _local_4.push(param1.substring(_local_12 + _local_13.length));
                    } else {
                        _local_4.push(param1.substring(_local_11,_local_12));
                        _local_4.push(this.ignoreWhite(_local_13));
                        _local_11 = _local_12 + _local_13.length;
                    }
                }
            }
            var _local_5:int = _local_4.length;
            var _local_6:int = 0;
            while(_local_6 < _local_5) {
                _local_4[_local_6] = this.execSimple(_local_4[_local_6]);
                _local_6 = _local_6 + 2;
            }
            var _local_9:RegExp = /((\|\||\&\&|[+|\-|*|\/|\%|\||\&|\^]|\>\>\>?|\<\<)\=)|=/;
            _local_6 = 1;
            while(_local_6 < _local_5) {
                _local_7 = _local_4[_local_6];
                if(_local_7.replace(_local_9,"") != "") {
                    _local_8 = this.operate(_local_4[_local_6 - 1],_local_7,_local_4[_local_6 + 1]);
                    _local_14 = ExeValue(_local_4[_local_6 - 1]);
                    _local_14.setValue(_local_8);
                    _local_4.splice(_local_6,2);
                    _local_6 = _local_6 - 2;
                    _local_5 = _local_5 - 2;
                }
                _local_6 = _local_6 + 2;
            }
            _local_4.reverse();
            var _local_10:ExeValue = _local_4[0];
            _local_6 = 1;
            while(_local_6 < _local_5) {
                _local_7 = _local_4[_local_6];
                if(_local_7.replace(_local_9,"") == "") {
                    _local_10 = _local_4[_local_6 - 1];
                    _local_15 = _local_4[_local_6 + 1];
                    if(_local_7.length > 1) {
                        _local_7 = _local_7.substring(0,_local_7.length - 1);
                    }
                    _local_8 = this.operate(_local_15,_local_7,_local_10);
                    _local_15.setValue(_local_8);
                }
                _local_6 = _local_6 + 2;
            }
            return _local_10;
        }
        
        private function execSimple(param1:String) : ExeValue {
            var firstparts:Array = null;
            var newstr:String = null;
            var defclose:int = 0;
            var newobj:* = undefined;
            var classstr:String = null;
            var def:* = undefined;
            var havemore:Boolean = false;
            var index:int = 0;
            var isFun:Boolean = false;
            var basestr:String = null;
            var newv:ExeValue = null;
            var newbase:* = undefined;
            var closeindex:int = 0;
            var paramstr:String = null;
            var params:Array = null;
            var nss:Array = null;
            var ns:Namespace = null;
            var nsv:* = undefined;
            var str:String = param1;
            var v:ExeValue = new ExeValue(this._scope);
            if(str.indexOf("new ") == 0) {
                newstr = str;
                defclose = str.indexOf(")");
                if(defclose >= 0) {
                    newstr = str.substring(0,defclose + 1);
                }
                newobj = this.makeNew(newstr.substring(4));
                str = this.tempValue(str,new ExeValue(newobj),0,newstr.length);
            }
            var reg:RegExp = /\.|\(/g;
            var result:Object = reg.exec(str);
            if(result == null || !isNaN(Number(str))) {
                return this.execValue(str,this._scope);
            }
            firstparts = String(str.split("(")[0]).split(".");
            if(firstparts.length > 0) {
                while(firstparts.length) {
                    classstr = firstparts.join(".");
                    try {
                        def = getDefinitionByName(this.ignoreWhite(classstr));
                        havemore = str.length > classstr.length;
                        str = this.tempValue(str,new ExeValue(def),0,classstr.length);
                        if(havemore) {
                            reg.lastIndex = 0;
                            result = reg.exec(str);
                            break;
                        }
                        return this.execValue(str);
                    }
                    catch(e:Error) {
                        firstparts.pop();
                        continue;
                    }
                }
            }
            var previndex:int = 0;
            while(true) {
                if(result == null) {
                    return v;
                }
                index = result.index;
                isFun = str.charAt(index) == "(";
                basestr = this.ignoreWhite(str.substring(previndex,index));
                newv = previndex == 0?this.execValue(basestr,v.value):new ExeValue(v.value,basestr);
                if(isFun) {
                    newbase = newv.value;
                    closeindex = str.indexOf(")",index);
                    paramstr = str.substring(index + 1,closeindex);
                    paramstr = this.ignoreWhite(paramstr);
                    params = [];
                    if(paramstr) {
                        params = this.execValue(paramstr).value;
                    }
                    if(!(newbase is Function)) {
                        try {
                            nss = [AS3];
                            for each(ns in nss) {
                                nsv = v.obj.ns::[basestr];
                                if(nsv is Function) {
                                    newbase = nsv;
                                    break;
                                }
                            }
                        }
                        catch(e:Error) {
                        }
                        if(!(newbase is Function)) {
                            break;
                        }
                    }
                    v.obj = (newbase as Function).apply(v.value,params);
                    v.prop = null;
                    index = closeindex + 1;
                } else {
                    v = newv;
                }
                previndex = index + 1;
                reg.lastIndex = index + 1;
                result = reg.exec(str);
                if(result == null) {
                    if(index + 1 < str.length) {
                        reg.lastIndex = str.length;
                        result = {"index":str.length};
                    }
                }
            }
            throw new Error(basestr + " is not a function.");
        }
        
        private function execValue(param1:String, param2:* = null) : ExeValue {
            var v:ExeValue = null;
            var vv:ExeValue = null;
            var key:String = null;
            var str:String = param1;
            var base:* = param2;
            v = new ExeValue();
            if(str == "true") {
                v.obj = true;
            } else if(str == "false") {
                v.obj = false;
            } else if(str == "this") {
                v.obj = this._scope;
            } else if(str == "null") {
                v.obj = null;
            } else if(!isNaN(Number(str))) {
                v.obj = Number(str);
            } else if(str.indexOf(VALKEY) == 0) {
                vv = this._values[str.substring(VALKEY.length)];
                v.obj = vv.value;
            } else if(str.charAt(0) == "$") {
                key = str.substring(1);
                if(this._reserved.indexOf(key) < 0) {
                    v.obj = this._saved;
                    v.prop = key;
                } else if(this._saved is WeakObject) {
                    v.obj = WeakObject(this._saved).get(key);
                } else {
                    v.obj = this._saved[key];
                }
            } else {
                try {
                    v.obj = getDefinitionByName(str);
                }
                catch(e:Error) {
                    v.obj = base;
                    v.prop = str;
                }
            }
            return v;
        }
        
        private function operate(param1:ExeValue, param2:String, param3:ExeValue) : * {
            switch(param2) {
                case "=":
                    return param3.value;
                case "+":
                    return param1.value + param3.value;
                case "-":
                    return param1.value - param3.value;
                case "*":
                    return param1.value * param3.value;
                case "/":
                    return param1.value / param3.value;
                case "%":
                    return param1.value % param3.value;
                case "^":
                    return param1.value ^ param3.value;
                case "&":
                    return param1.value & param3.value;
                case ">>":
                    return param1.value >> param3.value;
                case ">>>":
                    return param1.value >>> param3.value;
                case "<<":
                    return param1.value << param3.value;
                case "~":
                    return ~param3.value;
                case "|":
                    return param1.value | param3.value;
                case "!":
                    return !param3.value;
                case ">":
                    return param1.value > param3.value;
                case ">=":
                    return param1.value >= param3.value;
                case "<":
                    return param1.value < param3.value;
                case "<=":
                    return param1.value <= param3.value;
                case "||":
                    return param1.value || param3.value;
                case "&&":
                    return param1.value && param3.value;
                case "is":
                    return param1.value is param3.value;
                case "typeof":
                    return typeof param3.value;
                case "delete":
                    return delete param3.obj[param3.prop];
                case "==":
                    return param1.value == param3.value;
                case "===":
                    return param1.value === param3.value;
                case "!=":
                    return param1.value != param3.value;
                case "!==":
                    return param1.value !== param3.value;
                default:
                    return;
            }
        }
        
        private function makeNew(param1:String) : * {
            var _local_5:int = 0;
            var _local_6:String = null;
            var _local_7:Array = null;
            var _local_8:int = 0;
            var _local_2:int = param1.indexOf("(");
            var _local_3:String = _local_2 > 0?param1.substring(0,_local_2):param1;
            _local_3 = this.ignoreWhite(_local_3);
            var _local_4:* = this.execValue(_local_3).value;
            if(_local_2 > 0) {
                _local_5 = param1.indexOf(")",_local_2);
                _local_6 = param1.substring(_local_2 + 1,_local_5);
                _local_6 = this.ignoreWhite(_local_6);
                _local_7 = [];
                if(_local_6) {
                    _local_7 = this.execValue(_local_6).value;
                }
                _local_8 = _local_7.length;
                if(_local_8 == 0) {
                    return new _local_4();
                }
                if(_local_8 == 1) {
                    return new _local_4(_local_7[0]);
                }
                if(_local_8 == 2) {
                    return new _local_4(_local_7[0],_local_7[1]);
                }
                if(_local_8 == 3) {
                    return new _local_4(_local_7[0],_local_7[1],_local_7[2]);
                }
                if(_local_8 == 4) {
                    return new _local_4(_local_7[0],_local_7[1],_local_7[2],_local_7[3]);
                }
                if(_local_8 == 5) {
                    return new _local_4(_local_7[0],_local_7[1],_local_7[2],_local_7[3],_local_7[4]);
                }
                if(_local_8 == 6) {
                    return new _local_4(_local_7[0],_local_7[1],_local_7[2],_local_7[3],_local_7[4],_local_7[5]);
                }
                if(_local_8 == 7) {
                    return new _local_4(_local_7[0],_local_7[1],_local_7[2],_local_7[3],_local_7[4],_local_7[5],_local_7[6]);
                }
                if(_local_8 == 8) {
                    return new _local_4(_local_7[0],_local_7[1],_local_7[2],_local_7[3],_local_7[4],_local_7[5],_local_7[6],_local_7[7]);
                }
                if(_local_8 == 9) {
                    return new _local_4(_local_7[0],_local_7[1],_local_7[2],_local_7[3],_local_7[4],_local_7[5],_local_7[6],_local_7[7],_local_7[8]);
                }
                if(_local_8 == 10) {
                    return new _local_4(_local_7[0],_local_7[1],_local_7[2],_local_7[3],_local_7[4],_local_7[5],_local_7[6],_local_7[7],_local_7[8],_local_7[9]);
                }
                throw new Error("CommandLine can\'t create new class instances with more than 10 arguments.");
            }
            return null;
        }
        
        private function ignoreWhite(param1:String) : String {
            param1 = param1.replace(/\s*(.*)/,"$1");
            var _local_2:int = param1.length - 1;
            while(_local_2 > 0) {
                if(param1.charAt(_local_2).match(/\s/)) {
                    param1 = param1.substring(0,_local_2);
                    _local_2--;
                    continue;
                }
                break;
            }
            return param1;
        }
    }
}

class ExeValue {
     
    
    public var obj;
    
    public var prop:String;
    
    function ExeValue(param1:Object = null, param2:String = null) {
        super();
        this.obj = param1;
        this.prop = param2;
    }
    
    public function get value() : * {
        return !!this.prop?this.obj[this.prop]:this.obj;
    }
    
    public function setValue(param1:*) : void {
        if(this.prop) {
            this.obj[this.prop] = param1;
        } else {
            this.obj = param1;
        }
    }
}
