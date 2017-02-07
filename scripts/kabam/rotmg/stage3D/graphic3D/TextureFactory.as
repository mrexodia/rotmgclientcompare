package kabam.rotmg.stage3D.graphic3D {
    import flash.display.BitmapData;
    import flash.display3D.Context3DTextureFormat;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.utils.Dictionary;
    import kabam.rotmg.stage3D.proxies.Context3DProxy;
    import kabam.rotmg.stage3D.proxies.TextureProxy;
    
    public class TextureFactory {
        
        private static var textures:Dictionary = new Dictionary();
        
        private static var flippedTextures:Dictionary = new Dictionary();
        
        private static var count:int = 0;
         
        
        [Inject]
        public var context3D:Context3DProxy;
        
        public function TextureFactory() {
            super();
        }
        
        public static function GetFlippedBitmapData(param1:BitmapData) : BitmapData {
            var _local_2:BitmapData = null;
            if(param1 in flippedTextures) {
                return flippedTextures[param1];
            }
            _local_2 = flipBitmapData(param1,"y");
            flippedTextures[param1] = _local_2;
            return _local_2;
        }
        
        private static function flipBitmapData(param1:BitmapData, param2:String = "x") : BitmapData {
            var _local_4:Matrix = null;
            var _local_3:BitmapData = new BitmapData(param1.width,param1.height,true,0);
            if(param2 == "x") {
                _local_4 = new Matrix(-1,0,0,1,param1.width,0);
            } else {
                _local_4 = new Matrix(1,0,0,-1,0,param1.height);
            }
            _local_3.draw(param1,_local_4,null,null,null,true);
            return _local_3;
        }
        
        private static function getNextPowerOf2(param1:int) : Number {
            param1--;
            param1 = param1 | param1 >> 1;
            param1 = param1 | param1 >> 2;
            param1 = param1 | param1 >> 4;
            param1 = param1 | param1 >> 8;
            param1 = param1 | param1 >> 16;
            param1++;
            return param1;
        }
        
        public static function disposeTextures() : void {
            var _local_1:TextureProxy = null;
            var _local_2:BitmapData = null;
            for each(_local_1 in textures) {
                _local_1.dispose();
            }
            textures = new Dictionary();
            for each(_local_2 in flippedTextures) {
                _local_2.dispose();
            }
            flippedTextures = new Dictionary();
            count = 0;
        }
        
        public static function disposeNormalTextures() : void {
            var _local_1:TextureProxy = null;
            for each(_local_1 in textures) {
                _local_1.dispose();
            }
            textures = new Dictionary();
        }
        
        public function make(param1:BitmapData) : TextureProxy {
            var _local_2:int = 0;
            var _local_3:int = 0;
            var _local_4:TextureProxy = null;
            var _local_5:BitmapData = null;
            if(param1 == null) {
                return null;
            }
            if(param1 in textures) {
                return textures[param1];
            }
            _local_2 = getNextPowerOf2(param1.width);
            _local_3 = getNextPowerOf2(param1.height);
            _local_4 = this.context3D.createTexture(_local_2,_local_3,Context3DTextureFormat.BGRA,false);
            _local_5 = new BitmapData(_local_2,_local_3,true,0);
            _local_5.copyPixels(param1,param1.rect,new Point(0,0));
            _local_4.uploadFromBitmapData(_local_5);
            if(count > 1000) {
                disposeNormalTextures();
                count = 0;
            }
            textures[param1] = _local_4;
            count++;
            return _local_4;
        }
    }
}
