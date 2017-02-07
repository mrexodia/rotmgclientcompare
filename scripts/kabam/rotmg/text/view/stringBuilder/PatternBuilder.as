package kabam.rotmg.text.view.stringBuilder {
    import kabam.rotmg.language.model.StringMap;
    
    public class PatternBuilder implements StringBuilder {
         
        
        private const PATTERN:RegExp = /(\{([^\{]+?)\})/gi;
        
        private var pattern:String = "";
        
        private var keys:Array;
        
        private var provider:StringMap;
        
        public function PatternBuilder() {
            super();
        }
        
        public function setPattern(param1:String) : PatternBuilder {
            this.pattern = param1;
            return this;
        }
        
        public function setStringMap(param1:StringMap) : void {
            this.provider = param1;
        }
        
        public function getString() : String {
            var _local_2:String = null;
            this.keys = this.pattern.match(this.PATTERN);
            var _local_1:String = this.pattern;
            for each(_local_2 in this.keys) {
                _local_1 = _local_1.replace(_local_2,this.provider.getValue(_local_2.substr(1,_local_2.length - 2)));
            }
            return _local_1.replace(/\\n/g,"\n");
        }
    }
}
