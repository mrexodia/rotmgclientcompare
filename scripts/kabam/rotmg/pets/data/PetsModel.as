package kabam.rotmg.pets.data {
    import com.company.assembleegameclient.appengine.SavedCharacter;
    import com.company.assembleegameclient.map.AbstractMap;
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import kabam.rotmg.core.model.PlayerModel;
    import kabam.rotmg.pets.controller.NotifyActivePetUpdated;
    
    public class PetsModel {
         
        
        [Inject]
        public var notifyActivePetUpdated:NotifyActivePetUpdated;
        
        [Inject]
        public var playerModel:PlayerModel;
        
        private var hash:Object;
        
        private var pets:Vector.<PetVO>;
        
        private var yardXmlData:XML;
        
        private var type:int;
        
        private var activePet:PetVO;
        
        public function PetsModel() {
            this.hash = {};
            this.pets = new Vector.<PetVO>();
            super();
        }
        
        public function getPetVO(param1:int) : PetVO {
            var _local_2:PetVO = null;
            if(this.hash[param1] != null) {
                return this.hash[param1];
            }
            _local_2 = new PetVO(param1);
            this.pets.push(_local_2);
            this.hash[param1] = _local_2;
            return _local_2;
        }
        
        public function getCachedVOOnly(param1:int) : PetVO {
            return this.hash[param1];
        }
        
        public function getAllPets() : Vector.<PetVO> {
            return this.pets;
        }
        
        public function addPet(param1:PetVO) : void {
            this.pets.push(param1);
        }
        
        public function setActivePet(param1:PetVO) : void {
            this.activePet = param1;
            var _local_2:SavedCharacter = this.playerModel.getCharacterById(this.playerModel.currentCharId);
            if(_local_2) {
                _local_2.setPetVO(this.activePet);
            }
            this.notifyActivePetUpdated.dispatch();
        }
        
        public function getActivePet() : PetVO {
            return this.activePet;
        }
        
        public function removeActivePet() : void {
            var _local_1:SavedCharacter = this.playerModel.getCharacterById(this.playerModel.currentCharId);
            if(_local_1) {
                _local_1.setPetVO(null);
            }
            this.activePet = null;
            this.notifyActivePetUpdated.dispatch();
        }
        
        public function getPet(param1:int) : PetVO {
            var _local_2:int = this.getPetIndex(param1);
            if(_local_2 == -1) {
                return null;
            }
            return this.pets[_local_2];
        }
        
        private function getPetIndex(param1:int) : int {
            var _local_2:PetVO = null;
            var _local_3:uint = 0;
            while(_local_3 < this.pets.length) {
                _local_2 = this.pets[_local_3];
                if(_local_2.getID() == param1) {
                    return _local_3;
                }
                _local_3++;
            }
            return -1;
        }
        
        public function setPetYardType(param1:int) : void {
            this.type = param1;
            this.yardXmlData = ObjectLibrary.getXMLfromId(ObjectLibrary.getIdFromType(param1));
        }
        
        public function getPetYardRarity() : uint {
            return PetYardEnum.selectByValue(this.yardXmlData.@id).rarity.ordinal;
        }
        
        public function getPetYardType() : int {
            return !!this.yardXmlData?int(PetYardEnum.selectByValue(this.yardXmlData.@id).ordinal):1;
        }
        
        public function isMapNameYardName(param1:AbstractMap) : Boolean {
            return param1.name_ && param1.name_.substr(0,8) == "Pet Yard";
        }
        
        public function getPetYardUpgradeFamePrice() : int {
            return int(this.yardXmlData.Fame);
        }
        
        public function getPetYardUpgradeGoldPrice() : int {
            return int(this.yardXmlData.Price);
        }
        
        public function getPetYardObjectID() : int {
            return this.type;
        }
        
        public function deletePet(param1:int) : void {
            this.pets.splice(this.getPetIndex(param1),1);
        }
        
        public function clearPets() : void {
            this.hash = {};
            this.pets = new Vector.<PetVO>();
            this.removeActivePet();
        }
    }
}
