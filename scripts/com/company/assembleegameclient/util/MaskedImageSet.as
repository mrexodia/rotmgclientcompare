package com.company.assembleegameclient.util {
    import com.company.util.ImageSet;
    import flash.display.BitmapData;
    
    public class MaskedImageSet {
         
        
        public var images_:Vector.<MaskedImage>;
        
        public function MaskedImageSet() {
            this.images_ = new Vector.<MaskedImage>();
            super();
        }
        
        public function addFromBitmapData(param1:BitmapData, param2:BitmapData, param3:int, param4:int) : void {
            var _local_5:ImageSet = new ImageSet();
            _local_5.addFromBitmapData(param1,param3,param4);
            var _local_6:ImageSet = null;
            if(param2 != null) {
                _local_6 = new ImageSet();
                _local_6.addFromBitmapData(param2,param3,param4);
            }
            var _local_7:int = 0;
            while(_local_7 < _local_5.images_.length) {
                this.images_.push(new MaskedImage(_local_5.images_[_local_7],_local_6 == null?null:_local_6.images_[_local_7]));
                _local_7++;
            }
        }
        
        public function addFromMaskedImage(param1:MaskedImage, param2:int, param3:int) : void {
            this.addFromBitmapData(param1.image_,param1.mask_,param2,param3);
        }
    }
}
