package com.adobe.serialization.json {
    public class JSONTokenizer {
         
        
        private var obj:Object;
        
        private var jsonString:String;
        
        private var loc:int;
        
        private var ch:String;
        
        public function JSONTokenizer(param1:String) {
            super();
            this.jsonString = param1;
            this.loc = 0;
            this.nextChar();
        }
        
        public function getNextToken() : JSONToken {
            var _local_2:String = null;
            var _local_3:String = null;
            var _local_4:String = null;
            var _local_1:JSONToken = new JSONToken();
            this.skipIgnored();
            switch(this.ch) {
                case "{":
                    _local_1.type = JSONTokenType.LEFT_BRACE;
                    _local_1.value = "{";
                    this.nextChar();
                    break;
                case "}":
                    _local_1.type = JSONTokenType.RIGHT_BRACE;
                    _local_1.value = "}";
                    this.nextChar();
                    break;
                case "[":
                    _local_1.type = JSONTokenType.LEFT_BRACKET;
                    _local_1.value = "[";
                    this.nextChar();
                    break;
                case "]":
                    _local_1.type = JSONTokenType.RIGHT_BRACKET;
                    _local_1.value = "]";
                    this.nextChar();
                    break;
                case ",":
                    _local_1.type = JSONTokenType.COMMA;
                    _local_1.value = ",";
                    this.nextChar();
                    break;
                case ":":
                    _local_1.type = JSONTokenType.COLON;
                    _local_1.value = ":";
                    this.nextChar();
                    break;
                case "t":
                    _local_2 = "t" + this.nextChar() + this.nextChar() + this.nextChar();
                    if(_local_2 == "true") {
                        _local_1.type = JSONTokenType.TRUE;
                        _local_1.value = true;
                        this.nextChar();
                    } else {
                        this.parseError("Expecting \'true\' but found " + _local_2);
                    }
                    break;
                case "f":
                    _local_3 = "f" + this.nextChar() + this.nextChar() + this.nextChar() + this.nextChar();
                    if(_local_3 == "false") {
                        _local_1.type = JSONTokenType.FALSE;
                        _local_1.value = false;
                        this.nextChar();
                    } else {
                        this.parseError("Expecting \'false\' but found " + _local_3);
                    }
                    break;
                case "n":
                    _local_4 = "n" + this.nextChar() + this.nextChar() + this.nextChar();
                    if(_local_4 == "null") {
                        _local_1.type = JSONTokenType.NULL;
                        _local_1.value = null;
                        this.nextChar();
                    } else {
                        this.parseError("Expecting \'null\' but found " + _local_4);
                    }
                    break;
                case "\"":
                    _local_1 = this.readString();
                    break;
                default:
                    if(this.isDigit(this.ch) || this.ch == "-") {
                        _local_1 = this.readNumber();
                    } else {
                        if(this.ch == "") {
                            return null;
                        }
                        this.parseError("Unexpected " + this.ch + " encountered");
                    }
            }
            return _local_1;
        }
        
        private function readString() : JSONToken {
            var _local_3:String = null;
            var _local_4:int = 0;
            var _local_1:JSONToken = new JSONToken();
            _local_1.type = JSONTokenType.STRING;
            var _local_2:* = "";
            this.nextChar();
            while(this.ch != "\"" && this.ch != "") {
                if(this.ch == "\\") {
                    this.nextChar();
                    switch(this.ch) {
                        case "\"":
                            _local_2 = _local_2 + "\"";
                            break;
                        case "/":
                            _local_2 = _local_2 + "/";
                            break;
                        case "\\":
                            _local_2 = _local_2 + "\\";
                            break;
                        case "b":
                            _local_2 = _local_2 + "\b";
                            break;
                        case "f":
                            _local_2 = _local_2 + "\f";
                            break;
                        case "n":
                            _local_2 = _local_2 + "\n";
                            break;
                        case "r":
                            _local_2 = _local_2 + "\r";
                            break;
                        case "t":
                            _local_2 = _local_2 + "\t";
                            break;
                        case "u":
                            _local_3 = "";
                            _local_4 = 0;
                            while(_local_4 < 4) {
                                if(!this.isHexDigit(this.nextChar())) {
                                    this.parseError(" Excepted a hex digit, but found: " + this.ch);
                                }
                                _local_3 = _local_3 + this.ch;
                                _local_4++;
                            }
                            _local_2 = _local_2 + String.fromCharCode(parseInt(_local_3,16));
                            break;
                        default:
                            _local_2 = _local_2 + ("\\" + this.ch);
                    }
                } else {
                    _local_2 = _local_2 + this.ch;
                }
                this.nextChar();
            }
            if(this.ch == "") {
                this.parseError("Unterminated string literal");
            }
            this.nextChar();
            _local_1.value = _local_2;
            return _local_1;
        }
        
        private function readNumber() : JSONToken {
            var _local_1:JSONToken = new JSONToken();
            _local_1.type = JSONTokenType.NUMBER;
            var _local_2:* = "";
            if(this.ch == "-") {
                _local_2 = _local_2 + "-";
                this.nextChar();
            }
            if(!this.isDigit(this.ch)) {
                this.parseError("Expecting a digit");
            }
            if(this.ch == "0") {
                _local_2 = _local_2 + this.ch;
                this.nextChar();
                if(this.isDigit(this.ch)) {
                    this.parseError("A digit cannot immediately follow 0");
                }
            } else {
                while(this.isDigit(this.ch)) {
                    _local_2 = _local_2 + this.ch;
                    this.nextChar();
                }
            }
            if(this.ch == ".") {
                _local_2 = _local_2 + ".";
                this.nextChar();
                if(!this.isDigit(this.ch)) {
                    this.parseError("Expecting a digit");
                }
                while(this.isDigit(this.ch)) {
                    _local_2 = _local_2 + this.ch;
                    this.nextChar();
                }
            }
            if(this.ch == "e" || this.ch == "E") {
                _local_2 = _local_2 + "e";
                this.nextChar();
                if(this.ch == "+" || this.ch == "-") {
                    _local_2 = _local_2 + this.ch;
                    this.nextChar();
                }
                if(!this.isDigit(this.ch)) {
                    this.parseError("Scientific notation number needs exponent value");
                }
                while(this.isDigit(this.ch)) {
                    _local_2 = _local_2 + this.ch;
                    this.nextChar();
                }
            }
            var _local_3:Number = Number(_local_2);
            if(isFinite(_local_3) && !isNaN(_local_3)) {
                _local_1.value = _local_3;
                return _local_1;
            }
            this.parseError("Number " + _local_3 + " is not valid!");
            return null;
        }
        
        private function nextChar() : String {
            return this.ch = this.jsonString.charAt(this.loc++);
        }
        
        private function skipIgnored() : void {
            var _local_1:int = 0;
            do {
                _local_1 = this.loc;
                this.skipWhite();
                this.skipComments();
            }
            while(_local_1 != this.loc);
            
        }
        
        private function skipComments() : void {
            if(this.ch == "/") {
                this.nextChar();
                switch(this.ch) {
                    case "/":
                        do {
                            this.nextChar();
                        }
                        while(this.ch != "\n" && this.ch != "");
                        
                        this.nextChar();
                        break;
                    case "*":
                        this.nextChar();
                        while(true) {
                            if(this.ch == "*") {
                                this.nextChar();
                                if(this.ch == "/") {
                                    break;
                                }
                            } else {
                                this.nextChar();
                            }
                            if(this.ch == "") {
                                this.parseError("Multi-line comment not closed");
                            }
                        }
                        this.nextChar();
                        break;
                    default:
                        this.parseError("Unexpected " + this.ch + " encountered (expecting \'/\' or \'*\' )");
                }
            }
        }
        
        private function skipWhite() : void {
            while(this.isWhiteSpace(this.ch)) {
                this.nextChar();
            }
        }
        
        private function isWhiteSpace(param1:String) : Boolean {
            return param1 == " " || param1 == "\t" || param1 == "\n" || param1 == "\r";
        }
        
        private function isDigit(param1:String) : Boolean {
            return param1 >= "0" && param1 <= "9";
        }
        
        private function isHexDigit(param1:String) : Boolean {
            var _local_2:String = param1.toUpperCase();
            return this.isDigit(param1) || _local_2 >= "A" && _local_2 <= "F";
        }
        
        public function parseError(param1:String) : void {
            throw new JSONParseError(param1,this.loc,this.jsonString);
        }
    }
}
