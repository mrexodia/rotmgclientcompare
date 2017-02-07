package kabam.rotmg.pets.view.components {
    import com.company.assembleegameclient.util.TextureRedrawer;
    import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import kabam.rotmg.pets.data.PetVO;
    
    public class PetIconFactory {
         
        
        public var outlineSize:Number = 1.4;
        
        public function PetIconFactory() {
            super();
        }
        
        public function create(param1:PetVO, param2:int) : PetIcon {
            var _local_3:BitmapData = this.getPetSkinTexture(param1,param2);
            var _local_4:Bitmap = new Bitmap(_local_3);
            var _local_5:PetIcon = new PetIcon(param1);
            _local_5.setBitmap(_local_4);
            return _local_5;
        }
        
        public function getPetSkinTexture(param1:PetVO, param2:int) : BitmapData {
            var _local_4:Number = NaN;
            var _local_5:BitmapData = null;
            var _local_3:BitmapData = !!param1.getSkinMaskedImage()?param1.getSkinMaskedImage().image_:null;
            if(_local_3) {
                _local_4 = (param2 - TextureRedrawer.minSize) / _local_3.width;
                _local_5 = TextureRedrawer.resize(_local_3,param1.getSkinMaskedImage().mask_,100,true,0,0,_local_4);
                _local_5 = GlowRedrawer.outlineGlow(_local_5,0,this.outlineSize);
                return _local_5;
            }
            return new BitmapDataSpy(param2,param2);
        }
    }
}
