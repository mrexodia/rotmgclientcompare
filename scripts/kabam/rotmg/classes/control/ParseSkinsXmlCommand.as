package kabam.rotmg.classes.control {
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import kabam.rotmg.assets.EmbeddedData;
    import kabam.rotmg.assets.model.CharacterTemplate;
    import kabam.rotmg.classes.model.CharacterClass;
    import kabam.rotmg.classes.model.CharacterSkin;
    import kabam.rotmg.classes.model.ClassesModel;
    
    public class ParseSkinsXmlCommand {
         
        
        [Inject]
        public var model:ClassesModel;
        
        public function ParseSkinsXmlCommand() {
            super();
        }
        
        private static function parseNodeEquipment(param1:XML) : void {
            var _local_2:XMLList = null;
            var _local_3:XML = null;
            var _local_4:int = 0;
            var _local_5:int = 0;
            _local_2 = param1.children();
            for each(_local_3 in _local_2) {
                if(_local_3.attribute("skinType").length() != 0) {
                    _local_4 = int(_local_3.@skinType);
                    _local_5 = 16766720;
                    if(_local_3.attribute("color").length() != 0) {
                        _local_5 = int(_local_3.@color);
                    }
                    ObjectLibrary.skinSetXMLDataLibrary_[_local_4] = _local_3;
                }
            }
        }
        
        public function execute() : void {
            var _local_1:XML = null;
            var _local_2:XMLList = null;
            var _local_3:XML = null;
            _local_1 = EmbeddedData.skinsXML;
            _local_2 = _local_1.children();
            for each(_local_3 in _local_2) {
                this.parseNode(_local_3);
            }
            _local_1 = EmbeddedData.skinsEquipmentSetsXML;
            _local_2 = _local_1.children();
            for each(_local_3 in _local_2) {
                parseNodeEquipment(_local_3);
            }
        }
        
        private function parseNode(param1:XML) : void {
            var _local_2:String = param1.AnimatedTexture.File;
            var _local_3:int = param1.AnimatedTexture.Index;
            var _local_4:CharacterSkin = new CharacterSkin();
            _local_4.id = param1.@type;
            _local_4.name = param1.DisplayId;
            _local_4.unlockLevel = param1.UnlockLevel;
            if(param1.hasOwnProperty("NoSkinSelect")) {
                _local_4.skinSelectEnabled = false;
            }
            if(param1.hasOwnProperty("UnlockSpecial")) {
                _local_4.unlockSpecial = param1.UnlockSpecial;
            }
            _local_4.template = new CharacterTemplate(_local_2,_local_3);
            if(_local_2.indexOf("16") >= 0) {
                _local_4.is16x16 = true;
            }
            var _local_5:CharacterClass = this.model.getCharacterClass(param1.PlayerClassType);
            _local_5.skins.addSkin(_local_4);
        }
    }
}
