package com.company.assembleegameclient.util {
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import com.company.rotmg.graphics.StarGraphic;
    import com.company.util.AssetLibrary;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.filters.DropShadowFilter;
    import flash.geom.ColorTransform;
    
    public class FameUtil {
        
        public static const STARS:Vector.<int> = new <int>[20,150,400,800,2000];
        
        private static const lightBlueCT:ColorTransform = new ColorTransform(138 / 255,152 / 255,222 / 255);
        
        private static const darkBlueCT:ColorTransform = new ColorTransform(49 / 255,77 / 255,219 / 255);
        
        private static const redCT:ColorTransform = new ColorTransform(193 / 255,39 / 255,45 / 255);
        
        private static const orangeCT:ColorTransform = new ColorTransform(247 / 255,147 / 255,30 / 255);
        
        private static const yellowCT:ColorTransform = new ColorTransform(255 / 255,255 / 255,0 / 255);
        
        public static const COLORS:Vector.<ColorTransform> = new <ColorTransform>[lightBlueCT,darkBlueCT,redCT,orangeCT,yellowCT];
         
        
        public function FameUtil() {
            super();
        }
        
        public static function maxStars() : int {
            return ObjectLibrary.playerChars_.length * STARS.length;
        }
        
        public static function numStars(param1:int) : int {
            var _local_2:int = 0;
            while(_local_2 < STARS.length && param1 >= STARS[_local_2]) {
                _local_2++;
            }
            return _local_2;
        }
        
        public static function nextStarFame(param1:int, param2:int) : int {
            var _local_3:int = Math.max(param1,param2);
            var _local_4:int = 0;
            while(_local_4 < STARS.length) {
                if(STARS[_local_4] > _local_3) {
                    return STARS[_local_4];
                }
                _local_4++;
            }
            return -1;
        }
        
        public static function numAllTimeStars(param1:int, param2:int, param3:XML) : int {
            var _local_6:XML = null;
            var _local_4:int = 0;
            var _local_5:int = 0;
            for each(_local_6 in param3.ClassStats) {
                if(param1 == int(_local_6.@objectType)) {
                    _local_5 = int(_local_6.BestFame);
                } else {
                    _local_4 = _local_4 + FameUtil.numStars(_local_6.BestFame);
                }
            }
            _local_4 = _local_4 + FameUtil.numStars(Math.max(_local_5,param2));
            return _local_4;
        }
        
        public static function numStarsToBigImage(param1:int) : Sprite {
            var _local_2:Sprite = numStarsToImage(param1);
            _local_2.filters = [new DropShadowFilter(0,0,0,1,4,4,2)];
            _local_2.scaleX = 1.4;
            _local_2.scaleY = 1.4;
            return _local_2;
        }
        
        public static function numStarsToImage(param1:int) : Sprite {
            var _local_2:Sprite = new StarGraphic();
            if(param1 < ObjectLibrary.playerChars_.length) {
                _local_2.transform.colorTransform = lightBlueCT;
            } else if(param1 < ObjectLibrary.playerChars_.length * 2) {
                _local_2.transform.colorTransform = darkBlueCT;
            } else if(param1 < ObjectLibrary.playerChars_.length * 3) {
                _local_2.transform.colorTransform = redCT;
            } else if(param1 < ObjectLibrary.playerChars_.length * 4) {
                _local_2.transform.colorTransform = orangeCT;
            } else if(param1 < ObjectLibrary.playerChars_.length * 5) {
                _local_2.transform.colorTransform = yellowCT;
            }
            return _local_2;
        }
        
        public static function numStarsToIcon(param1:int) : Sprite {
            var _local_2:Sprite = null;
            var _local_3:Sprite = null;
            _local_2 = numStarsToImage(param1);
            _local_3 = new Sprite();
            _local_3.graphics.beginFill(0,0.4);
            var _local_4:int = _local_2.width / 2 + 2;
            var _local_5:int = _local_2.height / 2 + 2;
            _local_3.graphics.drawCircle(_local_4,_local_5,_local_4);
            _local_2.x = 2;
            _local_2.y = 1;
            _local_3.addChild(_local_2);
            _local_3.filters = [new DropShadowFilter(0,0,0,0.5,6,6,1)];
            return _local_3;
        }
        
        public static function getFameIcon() : BitmapData {
            var _local_1:BitmapData = AssetLibrary.getImageFromSet("lofiObj3",224);
            return TextureRedrawer.redraw(_local_1,40,true,0);
        }
    }
}
