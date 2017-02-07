package com.gskinner.motion {
    import flash.display.Shape;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.utils.Dictionary;
    import flash.utils.getTimer;
    
    public class GTween extends EventDispatcher {
        
        public static var version:Number = 2.01;
        
        public static var defaultDispatchEvents:Boolean = false;
        
        public static var defaultEase:Function = linearEase;
        
        public static var pauseAll:Boolean = false;
        
        public static var timeScaleAll:Number = 1;
        
        protected static var hasStarPlugins:Boolean = false;
        
        protected static var plugins:Object = {};
        
        protected static var shape:Shape;
        
        protected static var time:Number;
        
        protected static var tickList:Dictionary = new Dictionary(true);
        
        protected static var gcLockList:Dictionary = new Dictionary(false);
         {
            staticInit();
        }
        
        protected var _delay:Number = 0;
        
        protected var _values:Object;
        
        protected var _paused:Boolean = true;
        
        protected var _position:Number;
        
        protected var _inited:Boolean;
        
        protected var _initValues:Object;
        
        protected var _rangeValues:Object;
        
        protected var _proxy:TargetProxy;
        
        public var autoPlay:Boolean = true;
        
        public var data;
        
        public var duration:Number;
        
        public var ease:Function;
        
        public var nextTween:GTween;
        
        public var pluginData:Object;
        
        public var reflect:Boolean;
        
        public var repeatCount:int = 1;
        
        public var target:Object;
        
        public var useFrames:Boolean;
        
        public var timeScale:Number = 1;
        
        public var positionOld:Number;
        
        public var ratio:Number;
        
        public var ratioOld:Number;
        
        public var calculatedPosition:Number;
        
        public var calculatedPositionOld:Number;
        
        public var suppressEvents:Boolean;
        
        public var dispatchEvents:Boolean;
        
        public var onComplete:Function;
        
        public var onChange:Function;
        
        public var onInit:Function;
        
        public function GTween(param1:Object = null, param2:Number = 1, param3:Object = null, param4:Object = null, param5:Object = null) {
            var _local_6:Boolean = false;
            super();
            this.ease = defaultEase;
            this.dispatchEvents = defaultDispatchEvents;
            this.target = param1;
            this.duration = param2;
            this.pluginData = this.copy(param5,{});
            if(param4) {
                _local_6 = param4.swapValues;
                delete param4.swapValues;
            }
            this.copy(param4,this);
            this.resetValues(param3);
            if(_local_6) {
                this.swapValues();
            }
            if(this.duration == 0 && this.delay == 0 && this.autoPlay) {
                this.position = 0;
            }
        }
        
        public static function installPlugin(param1:Object, param2:Array, param3:Boolean = false) : void {
            var _local_5:String = null;
            var _local_4:uint = 0;
            while(_local_4 < param2.length) {
                _local_5 = param2[_local_4];
                if(_local_5 == "*") {
                    hasStarPlugins = true;
                }
                if(plugins[_local_5] == null) {
                    plugins[_local_5] = [param1];
                } else if(param3) {
                    plugins[_local_5].unshift(param1);
                } else {
                    plugins[_local_5].push(param1);
                }
                _local_4++;
            }
        }
        
        public static function linearEase(param1:Number, param2:Number, param3:Number, param4:Number) : Number {
            return param1;
        }
        
        protected static function staticInit() : void {
            (shape = new Shape()).addEventListener(Event.ENTER_FRAME,staticTick);
            time = getTimer() / 1000;
        }
        
        protected static function staticTick(param1:Event) : void {
            var _local_4:* = null;
            var _local_5:GTween = null;
            var _local_2:Number = time;
            time = getTimer() / 1000;
            if(pauseAll) {
                return;
            }
            var _local_3:Number = (time - _local_2) * timeScaleAll;
            for(_local_4 in tickList) {
                _local_5 = _local_4 as GTween;
                _local_5.position = _local_5._position + (!!_local_5.useFrames?timeScaleAll:_local_3) * _local_5.timeScale;
            }
        }
        
        public function get paused() : Boolean {
            return this._paused;
        }
        
        public function set paused(param1:Boolean) : void {
            if(param1 == this._paused) {
                return;
            }
            this._paused = param1;
            if(this._paused) {
                delete tickList[this];
                if(this.target is IEventDispatcher) {
                    this.target.removeEventListener("_",this.invalidate);
                }
                delete gcLockList[this];
            } else {
                if(isNaN(this._position) || this.repeatCount != 0 && this._position >= this.repeatCount * this.duration) {
                    this._inited = false;
                    this.calculatedPosition = this.calculatedPositionOld = this.ratio = this.ratioOld = this.positionOld = 0;
                    this._position = -this.delay;
                }
                tickList[this] = true;
                if(this.target is IEventDispatcher) {
                    this.target.addEventListener("_",this.invalidate);
                } else {
                    gcLockList[this] = true;
                }
            }
        }
        
        public function get position() : Number {
            return this._position;
        }
        
        public function set position(param1:Number) : void {
            var _local_4:* = null;
            var _local_5:Number = NaN;
            var _local_6:Number = NaN;
            var _local_7:Number = NaN;
            var _local_8:Array = null;
            var _local_9:uint = 0;
            var _local_10:uint = 0;
            this.positionOld = this._position;
            this.ratioOld = this.ratio;
            this.calculatedPositionOld = this.calculatedPosition;
            var _local_2:Number = this.repeatCount * this.duration;
            var _local_3:Boolean = param1 >= _local_2 && this.repeatCount > 0;
            if(_local_3) {
                if(this.calculatedPositionOld == _local_2) {
                    return;
                }
                this._position = _local_2;
                this.calculatedPosition = this.reflect && !(this.repeatCount & 1)?Number(0):Number(this.duration);
            } else {
                this._position = param1;
                this.calculatedPosition = this._position < 0?Number(0):Number(this._position % this.duration);
                if(this.reflect && this._position / this.duration & 1) {
                    this.calculatedPosition = this.duration - this.calculatedPosition;
                }
            }
            this.ratio = this.duration == 0 && this._position >= 0?Number(1):Number(this.ease(this.calculatedPosition / this.duration,0,1,1));
            if(this.target && (this._position >= 0 || this.positionOld >= 0) && this.calculatedPosition != this.calculatedPositionOld) {
                if(!this._inited) {
                    this.init();
                }
                for(_local_4 in this._values) {
                    _local_5 = this._initValues[_local_4];
                    _local_6 = this._rangeValues[_local_4];
                    _local_7 = _local_5 + _local_6 * this.ratio;
                    _local_8 = plugins[_local_4];
                    if(_local_8) {
                        _local_9 = _local_8.length;
                        _local_10 = 0;
                        while(_local_10 < _local_9) {
                            _local_7 = _local_8[_local_10].tween(this,_local_4,_local_7,_local_5,_local_6,this.ratio,_local_3);
                            _local_10++;
                        }
                        if(!isNaN(_local_7)) {
                            this.target[_local_4] = _local_7;
                        }
                    } else {
                        this.target[_local_4] = _local_7;
                    }
                }
            }
            if(hasStarPlugins) {
                _local_8 = plugins["*"];
                _local_9 = _local_8.length;
                _local_10 = 0;
                while(_local_10 < _local_9) {
                    _local_8[_local_10].tween(this,"*",NaN,NaN,NaN,this.ratio,_local_3);
                    _local_10++;
                }
            }
            if(!this.suppressEvents) {
                if(this.dispatchEvents) {
                    this.dispatchEvt("change");
                }
                if(this.onChange != null) {
                    this.onChange(this);
                }
            }
            if(_local_3) {
                this.paused = true;
                if(this.nextTween) {
                    this.nextTween.paused = false;
                }
                if(!this.suppressEvents) {
                    if(this.dispatchEvents) {
                        this.dispatchEvt("complete");
                    }
                    if(this.onComplete != null) {
                        this.onComplete(this);
                    }
                }
            }
        }
        
        public function get delay() : Number {
            return this._delay;
        }
        
        public function set delay(param1:Number) : void {
            if(this._position <= 0) {
                this._position = -param1;
            }
            this._delay = param1;
        }
        
        public function get proxy() : TargetProxy {
            if(this._proxy == null) {
                this._proxy = new TargetProxy(this);
            }
            return this._proxy;
        }
        
        public function setValue(param1:String, param2:Number) : void {
            this._values[param1] = param2;
            this.invalidate();
        }
        
        public function getValue(param1:String) : Number {
            return this._values[param1];
        }
        
        public function deleteValue(param1:String) : Boolean {
            delete this._rangeValues[param1];
            delete this._initValues[param1];
            return delete this._values[param1];
        }
        
        public function setValues(param1:Object) : void {
            this.copy(param1,this._values,true);
            this.invalidate();
        }
        
        public function resetValues(param1:Object = null) : void {
            this._values = {};
            this.setValues(param1);
        }
        
        public function getValues() : Object {
            return this.copy(this._values,{});
        }
        
        public function getInitValue(param1:String) : Number {
            return this._initValues[param1];
        }
        
        public function swapValues() : void {
            var _local_2:* = null;
            var _local_3:Number = NaN;
            if(!this._inited) {
                this.init();
            }
            var _local_1:Object = this._values;
            this._values = this._initValues;
            this._initValues = _local_1;
            for(_local_2 in this._rangeValues) {
                this._rangeValues[_local_2] = this._rangeValues[_local_2] * -1;
            }
            if(this._position < 0) {
                _local_3 = this.positionOld;
                this.position = 0;
                this._position = this.positionOld;
                this.positionOld = _local_3;
            } else {
                this.position = this._position;
            }
        }
        
        public function init() : void {
            var _local_1:* = null;
            var _local_2:Array = null;
            var _local_3:uint = 0;
            var _local_4:Number = NaN;
            var _local_5:uint = 0;
            this._inited = true;
            this._initValues = {};
            this._rangeValues = {};
            for(_local_1 in this._values) {
                if(plugins[_local_1]) {
                    _local_2 = plugins[_local_1];
                    _local_3 = _local_2.length;
                    _local_4 = _local_1 in this.target?Number(this.target[_local_1]):Number(NaN);
                    _local_5 = 0;
                    while(_local_5 < _local_3) {
                        _local_4 = _local_2[_local_5].init(this,_local_1,_local_4);
                        _local_5++;
                    }
                    if(!isNaN(_local_4)) {
                        this._rangeValues[_local_1] = this._values[_local_1] - (this._initValues[_local_1] = _local_4);
                    }
                } else {
                    this._rangeValues[_local_1] = this._values[_local_1] - (this._initValues[_local_1] = this.target[_local_1]);
                }
            }
            if(hasStarPlugins) {
                _local_2 = plugins["*"];
                _local_3 = _local_2.length;
                _local_5 = 0;
                while(_local_5 < _local_3) {
                    _local_2[_local_5].init(this,"*",NaN);
                    _local_5++;
                }
            }
            if(!this.suppressEvents) {
                if(this.dispatchEvents) {
                    this.dispatchEvt("init");
                }
                if(this.onInit != null) {
                    this.onInit(this);
                }
            }
        }
        
        public function beginning() : void {
            this.position = 0;
            this.paused = true;
        }
        
        public function end() : void {
            this.position = this.repeatCount > 0?Number(this.repeatCount * this.duration):Number(this.duration);
        }
        
        protected function invalidate() : void {
            this._inited = false;
            if(this._position > 0) {
                this._position = 0;
            }
            if(this.autoPlay) {
                this.paused = false;
            }
        }
        
        protected function copy(param1:Object, param2:Object, param3:Boolean = false) : Object {
            var _local_4:* = null;
            for(_local_4 in param1) {
                if(param3 && param1[_local_4] == null) {
                    delete param2[_local_4];
                } else {
                    param2[_local_4] = param1[_local_4];
                }
            }
            return param2;
        }
        
        protected function dispatchEvt(param1:String) : void {
            if(hasEventListener(param1)) {
                dispatchEvent(new Event(param1));
            }
        }
    }
}

import com.gskinner.motion.GTween;
import flash.utils.Proxy;
import flash.utils.flash_proxy;

dynamic class TargetProxy extends Proxy {
     
    
    private var tween:GTween;
    
    function TargetProxy(param1:GTween) {
        super();
        this.tween = param1;
    }
    
    override flash_proxy function callProperty(param1:*, ... rest) : * {
        return this.tween.target[param1].apply(null,rest);
    }
    
    override flash_proxy function getProperty(param1:*) : * {
        var _local_2:Number = this.tween.getValue(param1);
        return !!isNaN(_local_2)?this.tween.target[param1]:_local_2;
    }
    
    override flash_proxy function setProperty(param1:*, param2:*) : void {
        if(param2 is Boolean || param2 is String || isNaN(param2)) {
            this.tween.target[param1] = param2;
        } else {
            this.tween.setValue(String(param1),Number(param2));
        }
    }
    
    override flash_proxy function deleteProperty(param1:*) : Boolean {
        this.tween.deleteValue(param1);
        return true;
    }
}
