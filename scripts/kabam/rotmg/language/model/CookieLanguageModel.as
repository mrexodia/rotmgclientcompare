package kabam.rotmg.language.model {
    import flash.net.SharedObject;
    import flash.utils.Dictionary;
    
    public class CookieLanguageModel implements LanguageModel {
        
        public static const DEFAULT_LOCALE:String = "en";
         
        
        private var cookie:SharedObject;
        
        private var language:String;
        
        private var availableLanguages:Dictionary;
        
        public function CookieLanguageModel() {
            this.availableLanguages = this.makeAvailableLanguages();
            super();
            try {
                this.cookie = SharedObject.getLocal("RotMG","/");
                return;
            }
            catch(error:Error) {
                return;
            }
        }
        
        public function getLanguage() : String {
            return this.language = this.language || this.readLanguageFromCookie();
        }
        
        private function readLanguageFromCookie() : String {
            return this.cookie.data.locale || DEFAULT_LOCALE;
        }
        
        public function setLanguage(param1:String) : void {
            this.language = param1;
            try {
                this.cookie.data.locale = param1;
                this.cookie.flush();
                return;
            }
            catch(error:Error) {
                return;
            }
        }
        
        public function getLanguageFamily() : String {
            return this.getLanguage().substr(0,2).toLowerCase();
        }
        
        public function getLanguageNames() : Vector.<String> {
            var _local_2:* = null;
            var _local_1:Vector.<String> = new Vector.<String>();
            for(_local_2 in this.availableLanguages) {
                _local_1.push(_local_2);
            }
            return _local_1;
        }
        
        public function getLanguageCodeForName(param1:String) : String {
            return this.availableLanguages[param1];
        }
        
        public function getNameForLanguageCode(param1:String) : String {
            var _local_2:String = null;
            var _local_3:* = null;
            for(_local_3 in this.availableLanguages) {
                if(this.availableLanguages[_local_3] == param1) {
                    _local_2 = _local_3;
                }
            }
            return _local_2;
        }
        
        private function makeAvailableLanguages() : Dictionary {
            var _local_1:Dictionary = new Dictionary();
            _local_1["Languages.English"] = "en";
            _local_1["Languages.French"] = "fr";
            _local_1["Languages.Spanish"] = "es";
            _local_1["Languages.Italian"] = "it";
            _local_1["Languages.German"] = "de";
            _local_1["Languages.Turkish"] = "tr";
            _local_1["Languages.Russian"] = "ru";
            return _local_1;
        }
    }
}
