package kabam.rotmg.assets.services {
    import com.company.assembleegameclient.util.AnimatedChar;
    import com.company.assembleegameclient.util.AnimatedChars;
    import com.company.assembleegameclient.util.MaskedImage;
    import com.company.assembleegameclient.util.TextureRedrawer;
    import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
    import com.company.util.BitmapUtil;
    import flash.display.BitmapData;
    import kabam.rotmg.assets.model.Animation;
    import kabam.rotmg.assets.model.CharacterTemplate;
    
    public class CharacterFactory {
         
        
        private var texture1:int;
        
        private var texture2:int;
        
        private var size:int;
        
        public function CharacterFactory() {
            super();
        }
        
        public function makeCharacter(param1:CharacterTemplate) : AnimatedChar {
            return AnimatedChars.getAnimatedChar(param1.file,param1.index);
        }
        
        public function makeIcon(param1:CharacterTemplate, param2:int = 100, param3:int = 0, param4:int = 0) : BitmapData {
            this.texture1 = param3;
            this.texture2 = param4;
            this.size = param2;
            var _local_5:AnimatedChar = this.makeCharacter(param1);
            var _local_6:BitmapData = this.makeFrame(_local_5,AnimatedChar.STAND,0);
            _local_6 = GlowRedrawer.outlineGlow(_local_6,0);
            _local_6 = BitmapUtil.cropToBitmapData(_local_6,6,6,_local_6.width - 12,_local_6.height - 6);
            return _local_6;
        }
        
        public function makeWalkingIcon(param1:CharacterTemplate, param2:int = 100, param3:int = 0, param4:int = 0) : Animation {
            this.texture1 = param3;
            this.texture2 = param4;
            this.size = param2;
            var _local_5:AnimatedChar = this.makeCharacter(param1);
            var _local_6:BitmapData = this.makeFrame(_local_5,AnimatedChar.WALK,0.5);
            _local_6 = GlowRedrawer.outlineGlow(_local_6,0);
            var _local_7:BitmapData = this.makeFrame(_local_5,AnimatedChar.WALK,0);
            _local_7 = GlowRedrawer.outlineGlow(_local_7,0);
            var _local_8:Animation = new Animation();
            _local_8.setFrames(_local_6,_local_7);
            return _local_8;
        }
        
        private function makeFrame(param1:AnimatedChar, param2:int, param3:Number) : BitmapData {
            var _local_4:MaskedImage = param1.imageFromDir(AnimatedChar.RIGHT,param2,param3);
            return TextureRedrawer.resize(_local_4.image_,_local_4.mask_,this.size,false,this.texture1,this.texture2);
        }
    }
}
