package kabam.rotmg.messaging.impl.incoming {
    import flash.display.BitmapData;
    import flash.utils.ByteArray;
    import flash.utils.IDataInput;
    
    public class Pic extends IncomingMessage {
         
        
        public var bitmapData_:BitmapData = null;
        
        public function Pic(param1:uint, param2:Function) {
            super(param1,param2);
        }
        
        override public function parseFromInput(param1:IDataInput) : void {
            var _local_2:int = param1.readInt();
            var _local_3:int = param1.readInt();
            var _local_4:ByteArray = new ByteArray();
            param1.readBytes(_local_4,0,_local_2 * _local_3 * 4);
            this.bitmapData_ = new BitmapDataSpy(_local_2,_local_3);
            this.bitmapData_.setPixels(this.bitmapData_.rect,_local_4);
        }
        
        override public function toString() : String {
            return formatToString("PIC","bitmapData_");
        }
    }
}
