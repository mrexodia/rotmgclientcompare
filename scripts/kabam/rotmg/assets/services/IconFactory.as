package kabam.rotmg.assets.services {
    import com.company.assembleegameclient.util.TextureRedrawer;
    import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
    import com.company.util.AssetLibrary;
    import com.company.util.BitmapUtil;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    
    public class IconFactory {
         
        
        public function IconFactory() {
            super();
        }
        
        public static function makeCoin(param1:int = 40) : BitmapData {
            var _local_2:BitmapData = TextureRedrawer.resize(AssetLibrary.getImageFromSet("lofiObj3",225),null,param1,true,0,0);
            return cropAndGlowIcon(_local_2);
        }
        
        public static function makeFortune() : BitmapData {
            var _local_1:BitmapData = TextureRedrawer.resize(AssetLibrary.getImageFromSet("lofiCharBig",32),null,20,true,0,0);
            return cropAndGlowIcon(_local_1);
        }
        
        public static function makeFame() : BitmapData {
            var _local_1:BitmapData = TextureRedrawer.resize(AssetLibrary.getImageFromSet("lofiObj3",224),null,40,true,0,0);
            return cropAndGlowIcon(_local_1);
        }
        
        public static function makeGuildFame() : BitmapData {
            var _local_1:BitmapData = TextureRedrawer.resize(AssetLibrary.getImageFromSet("lofiObj3",226),null,40,true,0,0);
            return cropAndGlowIcon(_local_1);
        }
        
        private static function cropAndGlowIcon(param1:BitmapData) : BitmapData {
            param1 = GlowRedrawer.outlineGlow(param1,4294967295);
            param1 = BitmapUtil.cropToBitmapData(param1,10,10,param1.width - 20,param1.height - 20);
            return param1;
        }
        
        public function makeIconBitmap(param1:int) : Bitmap {
            var _local_2:BitmapData = AssetLibrary.getImageFromSet("lofiInterfaceBig",param1);
            _local_2 = TextureRedrawer.redraw(_local_2,320 / _local_2.width,true,0);
            return new Bitmap(_local_2);
        }
    }
}
