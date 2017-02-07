package kabam.rotmg.text.view.stringBuilder {
    import kabam.rotmg.language.model.StringMap;
    
    public class TemplateBuilder implements StringBuilder {
         
        
        private var template:String;
        
        private var tokens:Object;
        
        private var postfix:String = "";
        
        private var prefix:String = "";
        
        private var provider:StringMap;
        
        public function TemplateBuilder() {
            super();
        }
        
        public function setTemplate(param1:String, param2:Object = null) : TemplateBuilder {
            this.template = param1;
            this.tokens = param2;
            return this;
        }
        
        public function setPrefix(param1:String) : TemplateBuilder {
            this.prefix = param1;
            return this;
        }
        
        public function setPostfix(param1:String) : TemplateBuilder {
            this.postfix = param1;
            return this;
        }
        
        public function setStringMap(param1:StringMap) : void {
            this.provider = param1;
        }
        
        public function getString() : String {
            var _local_2:* = null;
            var _local_3:String = null;
            var _local_1:String = this.template;
            for(_local_2 in this.tokens) {
                _local_3 = this.tokens[_local_2];
                if(_local_3.charAt(0) == "{" && _local_3.charAt(_local_3.length - 1) == "}") {
                    _local_3 = this.provider.getValue(_local_3.substr(1,_local_3.length - 2));
                }
                _local_1 = _local_1.replace("{" + _local_2 + "}",_local_3);
            }
            _local_1 = _local_1.replace(/\\n/g,"\n");
            return this.prefix + _local_1 + this.postfix;
        }
    }
}
