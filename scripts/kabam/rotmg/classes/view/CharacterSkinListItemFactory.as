package kabam.rotmg.classes.view {
    import com.company.assembleegameclient.parameters.Parameters;
    import com.company.assembleegameclient.util.Currency;
    import com.company.util.AssetLibrary;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import kabam.rotmg.assets.services.CharacterFactory;
    import kabam.rotmg.classes.model.CharacterSkin;
    import kabam.rotmg.classes.model.CharacterSkins;
    import kabam.rotmg.util.components.LegacyBuyButton;
    
    public class CharacterSkinListItemFactory {
         
        
        [Inject]
        public var characters:CharacterFactory;
        
        public function CharacterSkinListItemFactory() {
            super();
        }
        
        public function make(param1:CharacterSkins) : Vector.<DisplayObject> {
            var _local_2:Vector.<CharacterSkin> = null;
            var _local_3:int = 0;
            _local_2 = param1.getListedSkins();
            _local_3 = _local_2.length;
            var _local_4:Vector.<DisplayObject> = new Vector.<DisplayObject>(_local_3,true);
            var _local_5:int = 0;
            while(_local_5 < _local_3) {
                _local_4[_local_5] = this.makeCharacterSkinTile(_local_2[_local_5]);
                _local_5++;
            }
            return _local_4;
        }
        
        private function makeCharacterSkinTile(param1:CharacterSkin) : CharacterSkinListItem {
            var _local_2:CharacterSkinListItem = new CharacterSkinListItem();
            _local_2.setSkin(this.makeIcon(param1));
            _local_2.setModel(param1);
            _local_2.setLockIcon(AssetLibrary.getImageFromSet("lofiInterface2",5));
            _local_2.setBuyButton(this.makeBuyButton());
            return _local_2;
        }
        
        private function makeBuyButton() : LegacyBuyButton {
            return new LegacyBuyButton("",16,0,Currency.GOLD);
        }
        
        private function makeIcon(param1:CharacterSkin) : Bitmap {
            var _local_2:int = Parameters.skinTypes16.indexOf(param1.id) != -1?50:100;
            var _local_3:BitmapData = this.characters.makeIcon(param1.template,_local_2);
            return new Bitmap(_local_3);
        }
    }
}
