package kabam.rotmg.packages.view {
    import com.company.assembleegameclient.util.TextureRedrawer;
    import com.company.util.AssetLibrary;
    import com.company.util.BitmapUtil;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    import kabam.rotmg.text.view.TextFieldDisplayConcrete;
    
    public class BasePackageButton extends Sprite {
        
        public static const IMAGE_NAME:String = "redLootBag";
        
        public static const IMAGE_ID:int = 0;
         
        
        public function BasePackageButton() {
            super();
        }
        
        protected static function makeIcon() : DisplayObject {
            var _local_2:DisplayObject = null;
            var _local_1:BitmapData = AssetLibrary.getImageFromSet(IMAGE_NAME,IMAGE_ID);
            _local_1 = TextureRedrawer.redraw(_local_1,40,true,0);
            _local_1 = BitmapUtil.cropToBitmapData(_local_1,10,10,_local_1.width - 20,_local_1.height - 20);
            _local_2 = new Bitmap(_local_1);
            _local_2.x = 3;
            _local_2.y = 3;
            return _local_2;
        }
        
        protected function positionText(param1:DisplayObject, param2:TextFieldDisplayConcrete) : void {
            var _local_4:Number = NaN;
            var _local_3:Rectangle = param1.getBounds(this);
            _local_4 = _local_3.top + _local_3.height / 2;
            param2.x = _local_3.right;
            param2.y = _local_4 - param2.height / 2;
        }
    }
}
