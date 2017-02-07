package com.company.assembleegameclient.objects {
    import com.company.assembleegameclient.util.TextureRedrawer;
    import com.company.util.AssetLibrary;
    import flash.display.BitmapData;
    
    public class ImageFactory {
         
        
        public function ImageFactory() {
            super();
        }
        
        public function getImageFromSet(param1:String, param2:int) : BitmapData {
            return AssetLibrary.getImageFromSet(param1,param2);
        }
        
        public function getTexture(param1:int, param2:int) : BitmapData {
            var _local_4:Number = NaN;
            var _local_5:BitmapData = null;
            var _local_3:BitmapData = ObjectLibrary.getBitmapData(param1);
            if(_local_3) {
                _local_4 = (param2 - TextureRedrawer.minSize) / _local_3.width;
                _local_5 = ObjectLibrary.getRedrawnTextureFromType(param1,100,true,false,_local_4);
                return _local_5;
            }
            return new BitmapDataSpy(param2,param2);
        }
    }
}
