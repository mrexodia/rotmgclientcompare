package kabam.rotmg.pets.data {
    import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.InteractiveItemTile;
    import flash.utils.Dictionary;
    import kabam.rotmg.messaging.impl.data.SlotObjectData;
    import kabam.rotmg.text.model.TextKey;
    
    public class PetFormModel {
         
        
        private var Data:Class;
        
        private var petsXML:XML;
        
        private var branches:Dictionary;
        
        private var selectedPet:PetVO;
        
        private var selectedSkin:int;
        
        public var slotObjectData:SlotObjectData;
        
        public function PetFormModel() {
            this.Data = PetFormModel_Data;
            this.petsXML = XML(new this.Data());
            super();
        }
        
        public function get petSkinGroupVOs() : Array {
            var _local_1:Array = [];
            _local_1[0] = new PetSkinGroupVO(TextKey.PET_RARITY_COMMON,this.getIconGroup("Common"),PetRarityEnum.COMMON,this.selectedPet.getSkinID());
            _local_1[1] = new PetSkinGroupVO(TextKey.PET_RARITY_RARE,this.getIconGroup("Rare"),PetRarityEnum.RARE,this.selectedPet.getSkinID());
            _local_1[2] = new PetSkinGroupVO(TextKey.PET_RARITY_DIVINE,this.getIconGroup("Divine"),PetRarityEnum.DIVINE,this.selectedPet.getSkinID());
            return _local_1;
        }
        
        public function createPetFamilyTree() : void {
            var _local_1:uint = 0;
            var _local_3:XML = null;
            var _local_2:uint = this.petsXML.Object.length();
            this.branches = new Dictionary();
            _local_1 = 0;
            while(_local_1 < _local_2) {
                _local_3 = this.petsXML.Object[_local_1];
                if(this.petIsInFamilyTree(_local_3)) {
                    this.addPetToAppropriateRarityList(_local_3);
                }
                _local_1++;
            }
        }
        
        private function addPetToAppropriateRarityList(param1:XML) : void {
            var _local_2:String = XMLList(param1.Rarity).valueOf();
            var _local_3:PetVO = this.convertXMLToPetVOForReskin(param1);
            if(this.branches[_local_2]) {
                this.branches[_local_2].push(_local_3);
            } else {
                this.branches[_local_2] = [_local_3];
            }
        }
        
        public function setSelectedPet(param1:PetVO) : void {
            this.selectedPet = param1;
        }
        
        private function convertXMLToPetVOForReskin(param1:XML) : PetVO {
            var _local_2:PetVO = new PetVO();
            _local_2.setType(param1.@type);
            _local_2.setID(param1.@id);
            _local_2.setSkin(this.fetchSkinTypeByID(param1.DefaultSkin[0]));
            return _local_2;
        }
        
        private function fetchSkinTypeByID(param1:String) : int {
            var _local_2:uint = 0;
            var _local_4:XML = null;
            var _local_5:String = null;
            var _local_3:uint = this.petsXML.Object.length();
            _local_2 = 0;
            while(_local_2 < _local_3) {
                _local_4 = this.petsXML.Object[_local_2];
                _local_5 = _local_4.@id;
                if(this.petNodeIsSkin(_local_4)) {
                    if(_local_5 == param1) {
                        return int(_local_4.@type);
                    }
                }
                _local_2++;
            }
            return -1;
        }
        
        private function petIsInFamilyTree(param1:XML) : Boolean {
            return param1.hasOwnProperty("Pet") && param1.Family == this.selectedPet.getFamily();
        }
        
        private function petNodeIsSkin(param1:XML) : Boolean {
            return param1.hasOwnProperty("PetSkin");
        }
        
        public function getSelectedPet() : PetVO {
            return this.selectedPet;
        }
        
        public function getIconGroup(param1:String) : Array {
            return this.branches[param1];
        }
        
        public function setSlotObject(param1:InteractiveItemTile) : void {
            this.slotObjectData = new SlotObjectData();
            this.slotObjectData.objectId_ = param1.ownerGrid.owner.objectId_;
            this.slotObjectData.objectType_ = param1.getItemId();
            this.slotObjectData.slotId_ = param1.tileId;
        }
        
        public function getSelectedSkin() : int {
            return this.selectedSkin;
        }
        
        public function setSelectedSkin(param1:int) : void {
            this.selectedSkin = param1;
        }
        
        public function getpetTypeFromSkinID(param1:int) : int {
            var _local_2:uint = 0;
            var _local_4:XML = null;
            var _local_5:int = 0;
            var _local_3:uint = this.petsXML.Object.length();
            _local_2 = 0;
            while(_local_2 < _local_3) {
                _local_4 = this.petsXML.Object[_local_2];
                _local_5 = _local_4.@type;
                if(_local_5 == param1) {
                    return this.fetchPetTypeBySkinID(_local_4.@id);
                }
                _local_2++;
            }
            return -1;
        }
        
        private function fetchPetTypeBySkinID(param1:String) : int {
            var _local_2:uint = 0;
            var _local_4:XML = null;
            var _local_5:String = null;
            var _local_3:uint = this.petsXML.Object.length();
            _local_2 = 0;
            while(_local_2 < _local_3) {
                _local_4 = this.petsXML.Object[_local_2];
                _local_5 = _local_4.DefaultSkin;
                if(_local_5 == param1) {
                    return _local_4.@type;
                }
                _local_2++;
            }
            return -1;
        }
    }
}
