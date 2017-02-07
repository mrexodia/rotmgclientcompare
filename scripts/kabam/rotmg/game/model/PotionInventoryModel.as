package kabam.rotmg.game.model {
    import flash.utils.Dictionary;
    import kabam.rotmg.ui.model.PotionModel;
    import org.osflash.signals.Signal;
    
    public class PotionInventoryModel {
        
        public static const HEALTH_POTION_ID:int = 2594;
        
        public static const HEALTH_POTION_SLOT:int = 254;
        
        public static const MAGIC_POTION_ID:int = 2595;
        
        public static const MAGIC_POTION_SLOT:int = 255;
         
        
        public var potionModels:Dictionary;
        
        public var updatePosition:Signal;
        
        public function PotionInventoryModel() {
            super();
            this.potionModels = new Dictionary();
            this.updatePosition = new Signal(int);
        }
        
        public static function getPotionSlot(param1:int) : int {
            switch(param1) {
                case HEALTH_POTION_ID:
                    return HEALTH_POTION_SLOT;
                case MAGIC_POTION_ID:
                    return MAGIC_POTION_SLOT;
                default:
                    return -1;
            }
        }
        
        public function initializePotionModels(param1:XML) : void {
            var _local_6:int = 0;
            var _local_7:PotionModel = null;
            var _local_2:int = param1.PotionPurchaseCooldown;
            var _local_3:int = param1.PotionPurchaseCostCooldown;
            var _local_4:int = param1.MaxStackablePotions;
            var _local_5:Array = new Array();
            for each(_local_6 in param1.PotionPurchaseCosts.cost) {
                _local_5.push(_local_6);
            }
            _local_7 = new PotionModel();
            _local_7.purchaseCooldownMillis = _local_2;
            _local_7.priceCooldownMillis = _local_3;
            _local_7.maxPotionCount = _local_4;
            _local_7.objectId = HEALTH_POTION_ID;
            _local_7.position = 0;
            _local_7.costs = _local_5;
            this.potionModels[_local_7.position] = _local_7;
            _local_7.update.add(this.update);
            _local_7 = new PotionModel();
            _local_7.purchaseCooldownMillis = _local_2;
            _local_7.priceCooldownMillis = _local_3;
            _local_7.maxPotionCount = _local_4;
            _local_7.objectId = MAGIC_POTION_ID;
            _local_7.position = 1;
            _local_7.costs = _local_5;
            this.potionModels[_local_7.position] = _local_7;
            _local_7.update.add(this.update);
        }
        
        public function getPotionModel(param1:uint) : PotionModel {
            var _local_2:* = null;
            for(_local_2 in this.potionModels) {
                if(this.potionModels[_local_2].objectId == param1) {
                    return this.potionModels[_local_2];
                }
            }
            return null;
        }
        
        private function update(param1:int) : void {
            this.updatePosition.dispatch(param1);
        }
    }
}
