package com.google.analytics.utils {
    public class Version {
         
        
        private var _revision:uint;
        
        private var _maxBuild:uint = 255;
        
        private var _maxMinor:uint = 15;
        
        private var _maxMajor:uint = 15;
        
        private var _separator:String = ".";
        
        private var _maxRevision:uint = 65535;
        
        private var _build:uint;
        
        private var _major:uint;
        
        private var _minor:uint;
        
        public function Version(param1:uint = 0, param2:uint = 0, param3:uint = 0, param4:uint = 0) {
            var _local_5:Version = null;
            super();
            if(param1 > _maxMajor && param2 == 0 && param3 == 0 && param4 == 0) {
                _local_5 = Version.fromNumber(param1);
                param1 = _local_5.major;
                param2 = _local_5.minor;
                param3 = _local_5.build;
                param4 = _local_5.revision;
            }
            this.major = param1;
            this.minor = param2;
            this.build = param3;
            this.revision = param4;
        }
        
        public static function fromString(param1:String = "", param2:String = ".") : Version {
            var _local_4:Array = null;
            var _local_3:Version = new Version();
            if(param1 == "" || param1 == null) {
                return _local_3;
            }
            if(param1.indexOf(param2) > -1) {
                _local_4 = param1.split(param2);
                _local_3.major = parseInt(_local_4[0]);
                _local_3.minor = parseInt(_local_4[1]);
                _local_3.build = parseInt(_local_4[2]);
                _local_3.revision = parseInt(_local_4[3]);
            } else {
                _local_3.major = parseInt(param1);
            }
            return _local_3;
        }
        
        public static function fromNumber(param1:Number = 0) : Version {
            var _local_2:Version = new Version();
            if(isNaN(param1) || param1 == 0 || param1 < 0 || param1 == Number.MAX_VALUE || param1 == Number.POSITIVE_INFINITY || param1 == Number.NEGATIVE_INFINITY) {
                return _local_2;
            }
            _local_2.major = param1 >>> 28;
            _local_2.minor = (param1 & 251658240) >>> 24;
            _local_2.build = (param1 & 16711680) >>> 16;
            _local_2.revision = param1 & 65535;
            return _local_2;
        }
        
        public function toString(param1:int = 0) : String {
            var _local_2:Array = null;
            if(param1 <= 0 || param1 > 4) {
                param1 = getFields();
            }
            switch(param1) {
                case 1:
                    _local_2 = [major];
                    break;
                case 2:
                    _local_2 = [major,minor];
                    break;
                case 3:
                    _local_2 = [major,minor,build];
                    break;
                case 4:
                default:
                    _local_2 = [major,minor,build,revision];
            }
            return _local_2.join(_separator);
        }
        
        public function set revision(param1:uint) : void {
            _revision = Math.min(param1,_maxRevision);
        }
        
        public function get revision() : uint {
            return _revision;
        }
        
        public function set build(param1:uint) : void {
            _build = Math.min(param1,_maxBuild);
        }
        
        public function set minor(param1:uint) : void {
            _minor = Math.min(param1,_maxMinor);
        }
        
        public function get build() : uint {
            return _build;
        }
        
        public function set major(param1:uint) : void {
            _major = Math.min(param1,_maxMajor);
        }
        
        public function get minor() : uint {
            return _minor;
        }
        
        private function getFields() : int {
            var _local_1:int = 4;
            if(revision == 0) {
                _local_1--;
            }
            if(_local_1 == 3 && build == 0) {
                _local_1--;
            }
            if(_local_1 == 2 && minor == 0) {
                _local_1--;
            }
            return _local_1;
        }
        
        public function valueOf() : uint {
            return major << 28 | minor << 24 | build << 16 | revision;
        }
        
        public function get major() : uint {
            return _major;
        }
        
        public function equals(param1:*) : Boolean {
            if(!(param1 is Version)) {
                return false;
            }
            if(param1.major == major && param1.minor == minor && param1.build == build && param1.revision == revision) {
                return true;
            }
            return false;
        }
    }
}
