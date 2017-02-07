package kabam.rotmg.pets.data {
    public class FusionCalculator {
        
        private static var ranges:Object = makeRanges();
         
        
        public function FusionCalculator() {
            super();
        }
        
        private static function makeRanges() : Object {
            ranges = {};
            ranges[PetRarityEnum.COMMON.value] = 30;
            ranges[PetRarityEnum.UNCOMMON.value] = 20;
            ranges[PetRarityEnum.RARE.value] = 20;
            ranges[PetRarityEnum.LEGENDARY.value] = 20;
            return ranges;
        }
        
        public static function getStrengthPercentage(param1:PetVO, param2:PetVO) : Number {
            var _local_3:Number = getRarityPointsPercentage(param1);
            var _local_4:Number = getRarityPointsPercentage(param2);
            return average(_local_3,_local_4);
        }
        
        private static function average(param1:Number, param2:Number) : Number {
            return (param1 + param2) / 2;
        }
        
        private static function getRarityPointsPercentage(param1:PetVO) : Number {
            var _local_2:int = ranges[param1.getRarity()];
            var _local_3:int = param1.getMaxAbilityPower() - _local_2;
            var _local_4:int = param1.abilityList[0].level - _local_3;
            return _local_4 / _local_2;
        }
    }
}
