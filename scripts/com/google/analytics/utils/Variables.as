package com.google.analytics.utils {
    import flash.net.URLVariables;
    
    public dynamic class Variables {
         
        
        public var post:Array;
        
        public var URIencode:Boolean;
        
        public var pre:Array;
        
        public var sort:Boolean = true;
        
        public function Variables(param1:String = null, param2:Array = null, param3:Array = null) {
            pre = [];
            post = [];
            super();
            if(param1) {
                decode(param1);
            }
            if(param2) {
                this.pre = param2;
            }
            if(param3) {
                this.post = param3;
            }
        }
        
        private function _join(param1:Variables) : void {
            var _local_2:* = null;
            if(!param1) {
                return;
            }
            for(_local_2 in param1) {
                this[_local_2] = param1[_local_2];
            }
        }
        
        public function join(... rest) : void {
            var _local_2:int = rest.length;
            var _local_3:int = 0;
            while(_local_3 < _local_2) {
                if(rest[_local_3] is Variables) {
                    _join(rest[_local_3]);
                }
                _local_3++;
            }
        }
        
        public function toString() : String {
            var _local_2:String = null;
            var _local_3:* = null;
            var _local_4:String = null;
            var _local_5:int = 0;
            var _local_6:int = 0;
            var _local_7:String = null;
            var _local_8:String = null;
            var _local_1:Array = [];
            for(_local_3 in this) {
                _local_2 = this[_local_3];
                if(URIencode) {
                    _local_2 = encodeURI(_local_2);
                }
                _local_1.push(_local_3 + "=" + _local_2);
            }
            if(sort) {
                _local_1.sort();
            }
            if(pre.length > 0) {
                pre.reverse();
                _local_5 = 0;
                while(_local_5 < pre.length) {
                    _local_7 = pre[_local_5];
                    _local_6 = 0;
                    while(_local_6 < _local_1.length) {
                        _local_4 = _local_1[_local_6];
                        if(_local_4.indexOf(_local_7) == 0) {
                            _local_1.unshift(_local_1.splice(_local_6,1)[0]);
                        }
                        _local_6++;
                    }
                    _local_5++;
                }
                pre.reverse();
            }
            if(post.length > 0) {
                _local_5 = 0;
                while(_local_5 < post.length) {
                    _local_8 = post[_local_5];
                    _local_6 = 0;
                    while(_local_6 < _local_1.length) {
                        _local_4 = _local_1[_local_6];
                        if(_local_4.indexOf(_local_8) == 0) {
                            _local_1.push(_local_1.splice(_local_6,1)[0]);
                        }
                        _local_6++;
                    }
                    _local_5++;
                }
            }
            return _local_1.join("&");
        }
        
        public function decode(param1:String) : void {
            var _local_2:Array = null;
            var _local_3:String = null;
            var _local_4:String = null;
            var _local_5:String = null;
            var _local_6:Array = null;
            if(param1 == "") {
                return;
            }
            if(param1.charAt(0) == "?") {
                param1 = param1.substr(1,param1.length);
            }
            if(param1.indexOf("&") > -1) {
                _local_2 = param1.split("&");
            } else {
                _local_2 = [param1];
            }
            var _local_7:int = 0;
            while(_local_7 < _local_2.length) {
                _local_3 = _local_2[_local_7];
                if(_local_3.indexOf("=") > -1) {
                    _local_6 = _local_3.split("=");
                    _local_4 = _local_6[0];
                    _local_5 = decodeURI(_local_6[1]);
                    this[_local_4] = _local_5;
                }
                _local_7++;
            }
        }
        
        public function toURLVariables() : URLVariables {
            var _local_2:* = null;
            var _local_1:URLVariables = new URLVariables();
            for(_local_2 in this) {
                _local_1[_local_2] = this[_local_2];
            }
            return _local_1;
        }
    }
}
