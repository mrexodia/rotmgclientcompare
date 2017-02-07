package kabam.rotmg.util.components {
    import com.company.util.AssetLibrary;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    
    public class UIAssetsHelper {
        
        public static const LEFT_NEVIGATOR:String = "left";
        
        public static const RIGHT_NEVIGATOR:String = "right";
         
        
        public function UIAssetsHelper() {
            super();
        }
        
        public static function createLeftNevigatorIcon(param1:String = "left", param2:int = 4, param3:Number = 0) : Sprite {
            var _local_4:BitmapData = null;
            if(param1 == LEFT_NEVIGATOR) {
                _local_4 = AssetLibrary.getImageFromSet("lofiInterface",55);
            } else {
                _local_4 = AssetLibrary.getImageFromSet("lofiInterface",54);
            }
            var _local_5:Bitmap = new Bitmap(_local_4);
            _local_5.scaleX = param2;
            _local_5.scaleY = param2;
            _local_5.rotation = param3;
            var _local_6:Sprite = new Sprite();
            _local_6.addChild(_local_5);
            return _local_6;
        }
    }
}
