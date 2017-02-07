package com.junkbyte.console.vos {
    import flash.geom.Rectangle;
    import flash.utils.ByteArray;
    
    public class GraphGroup {
        
        public static const FPS:uint = 1;
        
        public static const MEM:uint = 2;
         
        
        public var type:uint;
        
        public var name:String;
        
        public var freq:int = 1;
        
        public var low:Number;
        
        public var hi:Number;
        
        public var fixed:Boolean;
        
        public var averaging:uint;
        
        public var inv:Boolean;
        
        public var interests:Array;
        
        public var rect:Rectangle;
        
        public var idle:int;
        
        public function GraphGroup(param1:String) {
            this.interests = [];
            super();
            this.name = param1;
        }
        
        public static function FromBytes(param1:ByteArray) : GraphGroup {
            var _local_2:GraphGroup = new GraphGroup(param1.readUTF());
            _local_2.type = param1.readUnsignedInt();
            _local_2.idle = param1.readUnsignedInt();
            _local_2.low = param1.readDouble();
            _local_2.hi = param1.readDouble();
            _local_2.inv = param1.readBoolean();
            var _local_3:uint = param1.readUnsignedInt();
            while(_local_3) {
                _local_2.interests.push(GraphInterest.FromBytes(param1));
                _local_3--;
            }
            return _local_2;
        }
        
        public function updateMinMax(param1:Number) : void {
            if(!isNaN(param1) && !this.fixed) {
                if(isNaN(this.low)) {
                    this.low = param1;
                    this.hi = param1;
                }
                if(param1 > this.hi) {
                    this.hi = param1;
                }
                if(param1 < this.low) {
                    this.low = param1;
                }
            }
        }
        
        public function toBytes(param1:ByteArray) : void {
            var _local_2:GraphInterest = null;
            param1.writeUTF(this.name);
            param1.writeUnsignedInt(this.type);
            param1.writeUnsignedInt(this.idle);
            param1.writeDouble(this.low);
            param1.writeDouble(this.hi);
            param1.writeBoolean(this.inv);
            param1.writeUnsignedInt(this.interests.length);
            for each(_local_2 in this.interests) {
                _local_2.toBytes(param1);
            }
        }
    }
}
