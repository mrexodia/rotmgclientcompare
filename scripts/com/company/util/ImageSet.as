package com.company.util {
    import flash.display.BitmapData;
    
    public class ImageSet {
         
        
        public var images_:Vector.<BitmapData>;
        
        public function ImageSet() {
            super();
            this.images_ = new Vector.<BitmapData>();
        }
        
        public function add(param1:BitmapData) : void {
            this.images_.push(param1);
        }
        
        public function random() : BitmapData {
            return this.images_[int(Math.random() * this.images_.length)];
        }
        
        public function addFromBitmapData(param1:BitmapData, param2:int, param3:int) : void {
            var _local_7:int = 0;
            var _local_4:int = param1.width / param2;
            var _local_5:int = param1.height / param3;
            var _local_6:int = 0;
            while(_local_6 < _local_5) {
                _local_7 = 0;
                while(_local_7 < _local_4) {
                    this.images_.push(BitmapUtil.cropToBitmapData(param1,_local_7 * param2,_local_6 * param3,param2,param3));
                    _local_7++;
                }
                _local_6++;
            }
        }
    }
}
