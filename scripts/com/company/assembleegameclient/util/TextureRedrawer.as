package com.company.assembleegameclient.util {
    import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
    import com.company.util.AssetLibrary;
    import com.company.util.PointUtil;
    import flash.display.BitmapData;
    import flash.display.Shader;
    import flash.filters.BitmapFilterQuality;
    import flash.filters.GlowFilter;
    import flash.filters.ShaderFilter;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    
    public class TextureRedrawer {
        
        public static const magic:int = 12;
        
        public static const minSize:int = 2 * magic;
        
        private static const BORDER:int = 4;
        
        public static const OUTLINE_FILTER:GlowFilter = new GlowFilter(0,0.8,1.4,1.4,255,BitmapFilterQuality.LOW,false,false);
        
        private static var cache_:Dictionary = new Dictionary();
        
        private static var faceCache_:Dictionary = new Dictionary();
        
        private static var redrawCaches:Dictionary = new Dictionary();
        
        public static var sharedTexture_:BitmapData = null;
        
        private static var textureShaderEmbed_:Class = TextureRedrawer_textureShaderEmbed_;
        
        private static var textureShaderData_:ByteArray = new textureShaderEmbed_() as ByteArray;
        
        private static var colorTexture1:BitmapData = new BitmapDataSpy(1,1,false);
        
        private static var colorTexture2:BitmapData = new BitmapDataSpy(1,1,false);
         
        
        public function TextureRedrawer() {
            super();
        }
        
        public static function redraw(param1:BitmapData, param2:int, param3:Boolean, param4:uint, param5:Boolean = true, param6:Number = 5) : BitmapData {
            var _local_7:String = getHash(param2,param3,param4,param6);
            if(param5 && isCached(param1,_local_7)) {
                return redrawCaches[param1][_local_7];
            }
            var _local_8:BitmapData = resize(param1,null,param2,param3,0,0,param6);
            _local_8 = GlowRedrawer.outlineGlow(_local_8,param4,1.4,param5);
            if(param5) {
                cache(param1,_local_7,_local_8);
            }
            return _local_8;
        }
        
        private static function getHash(param1:int, param2:Boolean, param3:uint, param4:Number) : String {
            return param1.toString() + "," + param3.toString() + "," + param2 + "," + param4;
        }
        
        private static function cache(param1:BitmapData, param2:String, param3:BitmapData) : void {
            if(!(param1 in redrawCaches)) {
                redrawCaches[param1] = {};
            }
            redrawCaches[param1][param2] = param3;
        }
        
        private static function isCached(param1:BitmapData, param2:String) : Boolean {
            if(param1 in redrawCaches) {
                if(param2 in redrawCaches[param1]) {
                    return true;
                }
            }
            return false;
        }
        
        public static function resize(param1:BitmapData, param2:BitmapData, param3:int, param4:Boolean, param5:int, param6:int, param7:Number = 5) : BitmapData {
            if(param2 != null && (param5 != 0 || param6 != 0)) {
                param1 = retexture(param1,param2,param5,param6);
                param3 = param3 / 5;
            }
            var _local_8:int = param7 * (param3 / 100) * param1.width;
            var _local_9:int = param7 * (param3 / 100) * param1.height;
            var _local_10:Matrix = new Matrix();
            _local_10.scale(_local_8 / param1.width,_local_9 / param1.height);
            _local_10.translate(magic,magic);
            var _local_11:BitmapData = new BitmapDataSpy(_local_8 + minSize,_local_9 + (!!param4?magic:1) + magic,true,0);
            _local_11.draw(param1,_local_10);
            return _local_11;
        }
        
        public static function redrawSolidSquare(param1:uint, param2:int) : BitmapData {
            var _local_3:Dictionary = cache_[param2];
            if(_local_3 == null) {
                _local_3 = new Dictionary();
                cache_[param2] = _local_3;
            }
            var _local_4:BitmapData = _local_3[param1];
            if(_local_4 != null) {
                return _local_4;
            }
            _local_4 = new BitmapDataSpy(param2 + 4 + 4,param2 + 4 + 4,true,0);
            _local_4.fillRect(new Rectangle(4,4,param2,param2),4278190080 | param1);
            _local_4.applyFilter(_local_4,_local_4.rect,PointUtil.ORIGIN,OUTLINE_FILTER);
            _local_3[param1] = _local_4;
            return _local_4;
        }
        
        public static function clearCache() : void {
            var _local_1:BitmapData = null;
            var _local_2:Dictionary = null;
            var _local_3:Dictionary = null;
            for each(_local_2 in cache_) {
                for each(_local_1 in _local_2) {
                    _local_1.dispose();
                }
            }
            cache_ = new Dictionary();
            for each(_local_3 in faceCache_) {
                for each(_local_1 in _local_3) {
                    _local_1.dispose();
                }
            }
            faceCache_ = new Dictionary();
        }
        
        public static function redrawFace(param1:BitmapData, param2:Number) : BitmapData {
            if(param2 == 1) {
                return param1;
            }
            var _local_3:Dictionary = faceCache_[param2];
            if(_local_3 == null) {
                _local_3 = new Dictionary();
                faceCache_[param2] = _local_3;
            }
            var _local_4:BitmapData = _local_3[param1];
            if(_local_4 != null) {
                return _local_4;
            }
            _local_4 = param1.clone();
            _local_4.colorTransform(_local_4.rect,new ColorTransform(param2,param2,param2));
            _local_3[param1] = _local_4;
            return _local_4;
        }
        
        private static function getTexture(param1:int, param2:BitmapData) : BitmapData {
            var _local_3:BitmapData = null;
            var _local_4:* = param1 >> 24 & 255;
            var _local_5:* = param1 & 16777215;
            switch(_local_4) {
                case 0:
                    _local_3 = param2;
                    break;
                case 1:
                    param2.setPixel(0,0,_local_5);
                    _local_3 = param2;
                    break;
                case 4:
                    _local_3 = AssetLibrary.getImageFromSet("textile4x4",_local_5);
                    break;
                case 5:
                    _local_3 = AssetLibrary.getImageFromSet("textile5x5",_local_5);
                    break;
                case 9:
                    _local_3 = AssetLibrary.getImageFromSet("textile9x9",_local_5);
                    break;
                case 10:
                    _local_3 = AssetLibrary.getImageFromSet("textile10x10",_local_5);
                    break;
                case 255:
                    _local_3 = sharedTexture_;
                    break;
                default:
                    _local_3 = param2;
            }
            return _local_3;
        }
        
        private static function retexture(param1:BitmapData, param2:BitmapData, param3:int, param4:int) : BitmapData {
            var _local_5:Matrix = new Matrix();
            _local_5.scale(5,5);
            var _local_6:BitmapData = new BitmapDataSpy(param1.width * 5,param1.height * 5,true,0);
            _local_6.draw(param1,_local_5);
            var _local_7:BitmapData = getTexture(param3,colorTexture1);
            var _local_8:BitmapData = getTexture(param4,colorTexture2);
            var _local_9:Shader = new Shader(textureShaderData_);
            _local_9.data.src.input = _local_6;
            _local_9.data.mask.input = param2;
            _local_9.data.texture1.input = _local_7;
            _local_9.data.texture2.input = _local_8;
            _local_9.data.texture1Size.value = [param3 == 0?0:_local_7.width];
            _local_9.data.texture2Size.value = [param4 == 0?0:_local_8.width];
            _local_6.applyFilter(_local_6,_local_6.rect,PointUtil.ORIGIN,new ShaderFilter(_local_9));
            return _local_6;
        }
        
        private static function getDrawMatrix() : Matrix {
            var _local_1:Matrix = new Matrix();
            _local_1.scale(8,8);
            _local_1.translate(BORDER,BORDER);
            return _local_1;
        }
    }
}
