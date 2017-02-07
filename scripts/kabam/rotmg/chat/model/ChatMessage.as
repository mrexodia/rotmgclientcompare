package kabam.rotmg.chat.model {
    public class ChatMessage {
         
        
        public var name:String;
        
        public var text:String;
        
        public var objectId:int = -1;
        
        public var numStars:int = -1;
        
        public var recipient:String = "";
        
        public var isToMe:Boolean;
        
        public var isWhisper:Boolean;
        
        public var tokens:Object;
        
        public function ChatMessage() {
            super();
        }
        
        public static function make(param1:String, param2:String, param3:int = -1, param4:int = -1, param5:String = "", param6:Boolean = false, param7:Object = null, param8:Boolean = false) : ChatMessage {
            var _local_9:ChatMessage = new ChatMessage();
            _local_9.name = param1;
            _local_9.text = param2;
            _local_9.objectId = param3;
            _local_9.numStars = param4;
            _local_9.recipient = param5;
            _local_9.isToMe = param6;
            _local_9.isWhisper = param8;
            _local_9.tokens = param7 == null?{}:param7;
            return _local_9;
        }
    }
}
