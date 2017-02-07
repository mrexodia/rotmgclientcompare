package com.google.analytics.data {
    public class X10 {
         
        
        private var _delimEnd:String = ")";
        
        private var _minimum:int;
        
        private var _delimSet:String = "*";
        
        private var _escapeChar:String = "\'";
        
        private var _delimBegin:String = "(";
        
        private var _delimNumValue:String = "!";
        
        private var _key:String = "k";
        
        private var _set:Array;
        
        private var _hasData:int;
        
        private var _escapeCharMap:Object;
        
        private var _projectData:Object;
        
        private var _value:String = "v";
        
        public function X10() {
            _set = [_key,_value];
            super();
            _projectData = {};
            _escapeCharMap = {};
            _escapeCharMap[_escapeChar] = "\'0";
            _escapeCharMap[_delimEnd] = "\'1";
            _escapeCharMap[_delimSet] = "\'2";
            _escapeCharMap[_delimNumValue] = "\'3";
            _minimum = 1;
        }
        
        private function _setInternal(param1:Number, param2:String, param3:Number, param4:String) : void {
            if(!hasProject(param1)) {
                _projectData[param1] = {};
            }
            if(_projectData[param1][param2] == undefined) {
                _projectData[param1][param2] = [];
            }
            _projectData[param1][param2][param3] = param4;
            _hasData = _hasData + 1;
        }
        
        private function _renderProject(param1:Object) : String {
            var _local_4:int = 0;
            var _local_5:Array = null;
            var _local_2:String = "";
            var _local_3:Boolean = false;
            var _local_6:int = _set.length;
            _local_4 = 0;
            while(_local_4 < _local_6) {
                _local_5 = param1[_set[_local_4]];
                if(_local_5) {
                    if(_local_3) {
                        _local_2 = _local_2 + _set[_local_4];
                    }
                    _local_2 = _local_2 + _renderDataType(_local_5);
                    _local_3 = false;
                } else {
                    _local_3 = true;
                }
                _local_4++;
            }
            return _local_2;
        }
        
        public function hasProject(param1:Number) : Boolean {
            return _projectData[param1];
        }
        
        public function clearKey(param1:Number) : void {
            _clearInternal(param1,_key);
        }
        
        private function _renderDataType(param1:Array) : String {
            var _local_3:String = null;
            var _local_4:int = 0;
            var _local_2:Array = [];
            _local_4 = 0;
            while(_local_4 < param1.length) {
                if(param1[_local_4] != undefined) {
                    _local_3 = "";
                    if(_local_4 != _minimum && param1[_local_4 - 1] == undefined) {
                        _local_3 = _local_3 + _local_4.toString();
                        _local_3 = _local_3 + _delimNumValue;
                    }
                    _local_3 = _local_3 + _escapeExtensibleValue(param1[_local_4]);
                    _local_2.push(_local_3);
                }
                _local_4++;
            }
            return _delimBegin + _local_2.join(_delimSet) + _delimEnd;
        }
        
        public function getKey(param1:Number, param2:Number) : String {
            return _getInternal(param1,_key,param2) as String;
        }
        
        public function hasData() : Boolean {
            return _hasData > 0;
        }
        
        public function renderMergedUrlString(param1:X10 = null) : String {
            var _local_3:* = null;
            if(!param1) {
                return renderUrlString();
            }
            var _local_2:Array = [param1.renderUrlString()];
            for(_local_3 in _projectData) {
                if(hasProject(Number(_local_3)) && !param1.hasProject(Number(_local_3))) {
                    _local_2.push(_local_3 + _renderProject(_projectData[_local_3]));
                }
            }
            return _local_2.join("");
        }
        
        public function setValue(param1:Number, param2:Number, param3:Number) : Boolean {
            if(Math.round(param3) != param3 || isNaN(param3) || param3 == Infinity) {
                return false;
            }
            _setInternal(param1,_value,param2,param3.toString());
            return true;
        }
        
        public function renderUrlString() : String {
            var _local_2:* = null;
            var _local_1:Array = [];
            for(_local_2 in _projectData) {
                if(hasProject(Number(_local_2))) {
                    _local_1.push(_local_2 + _renderProject(_projectData[_local_2]));
                }
            }
            return _local_1.join("");
        }
        
        private function _getInternal(param1:Number, param2:String, param3:Number) : Object {
            if(hasProject(param1) && _projectData[param1][param2] != undefined) {
                return _projectData[param1][param2][param3];
            }
            return undefined;
        }
        
        public function setKey(param1:Number, param2:Number, param3:String) : Boolean {
            _setInternal(param1,_key,param2,param3);
            return true;
        }
        
        public function clearValue(param1:Number) : void {
            _clearInternal(param1,_value);
        }
        
        private function _clearInternal(param1:Number, param2:String) : void {
            var _local_3:Boolean = false;
            var _local_4:int = 0;
            var _local_5:int = 0;
            if(hasProject(param1) && _projectData[param1][param2] != undefined) {
                _projectData[param1][param2] = undefined;
                _local_3 = true;
                _local_5 = _set.length;
                _local_4 = 0;
                while(_local_4 < _local_5) {
                    if(_projectData[param1][_set[_local_4]] != undefined) {
                        _local_3 = false;
                        break;
                    }
                    _local_4++;
                }
                if(_local_3) {
                    _projectData[param1] = undefined;
                    _hasData = _hasData - 1;
                }
            }
        }
        
        public function getValue(param1:Number, param2:Number) : * {
            var _local_3:* = _getInternal(param1,_value,param2);
            if(_local_3 == null) {
                return null;
            }
            return Number(_local_3);
        }
        
        private function _escapeExtensibleValue(param1:String) : String {
            var _local_3:int = 0;
            var _local_4:String = null;
            var _local_5:String = null;
            var _local_2:String = "";
            _local_3 = 0;
            while(_local_3 < param1.length) {
                _local_4 = param1.charAt(_local_3);
                _local_5 = _escapeCharMap[_local_4];
                if(_local_5) {
                    _local_2 = _local_2 + _local_5;
                } else {
                    _local_2 = _local_2 + _local_4;
                }
                _local_3++;
            }
            return _local_2;
        }
    }
}
