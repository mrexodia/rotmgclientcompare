package kabam.rotmg.text.view.stringBuilder {
    import kabam.rotmg.language.model.StringMap;
    
    public class AppendingLineBuilder implements StringBuilder {
         
        
        private var data:Vector.<LineData>;
        
        private var delimiter:String = "\n";
        
        private var provider:StringMap;
        
        public function AppendingLineBuilder() {
            this.data = new Vector.<LineData>();
            super();
        }
        
        public function pushParams(param1:String, param2:Object = null, param3:String = "", param4:String = "") : AppendingLineBuilder {
            this.data.push(new LineData().setKey(param1).setTokens(param2).setOpeningTags(param3).setClosingTags(param4));
            return this;
        }
        
        public function setDelimiter(param1:String) : AppendingLineBuilder {
            this.delimiter = param1;
            return this;
        }
        
        public function setStringMap(param1:StringMap) : void {
            this.provider = param1;
        }
        
        public function getString() : String {
            var _local_2:LineData = null;
            var _local_1:Vector.<String> = new Vector.<String>();
            for each(_local_2 in this.data) {
                _local_1.push(_local_2.getString(this.provider));
            }
            return _local_1.join(this.delimiter);
        }
        
        public function hasLines() : Boolean {
            return this.data.length != 0;
        }
        
        public function clear() : void {
            this.data = new Vector.<LineData>();
        }
    }
}

import kabam.rotmg.language.model.StringMap;
import kabam.rotmg.text.model.TextKey;
import kabam.rotmg.text.view.stringBuilder.StringBuilder;

class LineData {
     
    
    public var key:String;
    
    public var tokens:Object;
    
    public var openingHTMLTags:String = "";
    
    public var closingHTMLTags:String = "";
    
    function LineData() {
        super();
    }
    
    public function setKey(param1:String) : LineData {
        this.key = param1;
        return this;
    }
    
    public function setTokens(param1:Object) : LineData {
        this.tokens = param1;
        return this;
    }
    
    public function setOpeningTags(param1:String) : LineData {
        this.openingHTMLTags = param1;
        return this;
    }
    
    public function setClosingTags(param1:String) : LineData {
        this.closingHTMLTags = param1;
        return this;
    }
    
    public function getString(param1:StringMap) : String {
        var _local_3:String = null;
        var _local_4:* = null;
        var _local_5:StringBuilder = null;
        var _local_6:String = null;
        var _local_2:String = this.openingHTMLTags;
        if((_local_3 = param1.getValue(TextKey.stripCurlyBrackets(this.key))) == null) {
            _local_3 = this.key;
        }
        _local_2 = _local_2.concat(_local_3);
        for(_local_4 in this.tokens) {
            if(this.tokens[_local_4] is StringBuilder) {
                _local_5 = StringBuilder(this.tokens[_local_4]);
                _local_5.setStringMap(param1);
                _local_2 = _local_2.replace("{" + _local_4 + "}",_local_5.getString());
            } else {
                _local_6 = this.tokens[_local_4];
                if(_local_6.length > 0 && _local_6.charAt(0) == "{" && _local_6.charAt(_local_6.length - 1) == "}") {
                    _local_6 = param1.getValue(_local_6.substr(1,_local_6.length - 2));
                }
                _local_2 = _local_2.replace("{" + _local_4 + "}",_local_6);
            }
        }
        _local_2 = _local_2.replace(/\\n/g,"\n");
        _local_2 = _local_2.concat(this.closingHTMLTags);
        return _local_2;
    }
}
