package com.junkbyte.console.vos {
    import flash.utils.ByteArray;
    
    public class Log {
         
        
        public var line:uint;
        
        public var text:String;
        
        public var ch:String;
        
        public var priority:int;
        
        public var repeat:Boolean;
        
        public var html:Boolean;
        
        public var time:uint;
        
        public var timeStr:String;
        
        public var lineStr:String;
        
        public var chStr:String;
        
        public var next:Log;
        
        public var prev:Log;
        
        public function Log(param1:String, param2:String, param3:int, param4:Boolean = false, param5:Boolean = false) {
            super();
            this.text = param1;
            this.ch = param2;
            this.priority = param3;
            this.repeat = param4;
            this.html = param5;
        }
        
        public static function FromBytes(param1:ByteArray) : Log {
            var _local_2:String = param1.readUTFBytes(param1.readUnsignedInt());
            var _local_3:String = param1.readUTF();
            var _local_4:int = param1.readInt();
            var _local_5:Boolean = param1.readBoolean();
            return new Log(_local_2,_local_3,_local_4,_local_5,true);
        }
        
        public function toBytes(param1:ByteArray) : void {
            var _local_2:ByteArray = new ByteArray();
            _local_2.writeUTFBytes(this.text);
            param1.writeUnsignedInt(_local_2.length);
            param1.writeBytes(_local_2);
            param1.writeUTF(this.ch);
            param1.writeInt(this.priority);
            param1.writeBoolean(this.repeat);
        }
        
        public function plainText() : String {
            return this.text.replace(/<.*?>/g,"").replace(/&lt;/g,"<").replace(/&gt;/g,">");
        }
        
        public function toString() : String {
            return "[" + this.ch + "] " + this.plainText();
        }
        
        public function clone() : Log {
            var _local_1:Log = new Log(this.text,this.ch,this.priority,this.repeat,this.html);
            _local_1.line = this.line;
            _local_1.time = this.time;
            return _local_1;
        }
    }
}
