package kabam.rotmg.legends.model {
    import com.company.util.ConversionUtil;
    import kabam.rotmg.assets.services.CharacterFactory;
    import kabam.rotmg.classes.model.CharacterClass;
    import kabam.rotmg.classes.model.CharacterSkin;
    import kabam.rotmg.classes.model.ClassesModel;
    import kabam.rotmg.core.model.PlayerModel;
    
    public class LegendFactory {
         
        
        [Inject]
        public var playerModel:PlayerModel;
        
        [Inject]
        public var classesModel:ClassesModel;
        
        [Inject]
        public var factory:CharacterFactory;
        
        private var ownAccountId:String;
        
        private var legends:Vector.<Legend>;
        
        public function LegendFactory() {
            super();
        }
        
        public function makeLegends(param1:XML) : Vector.<Legend> {
            this.ownAccountId = this.playerModel.getAccountId();
            this.legends = new Vector.<Legend>(0);
            this.makeLegendsFromList(param1.FameListElem,false);
            this.makeLegendsFromList(param1.MyFameListElem,true);
            return this.legends;
        }
        
        private function makeLegendsFromList(param1:XMLList, param2:Boolean) : void {
            var _local_3:XML = null;
            var _local_4:Legend = null;
            for each(_local_3 in param1) {
                if(!this.legendsContains(_local_3)) {
                    _local_4 = this.makeLegend(_local_3);
                    _local_4.isOwnLegend = _local_3.@accountId == this.ownAccountId;
                    _local_4.isFocus = param2;
                    this.legends.push(_local_4);
                }
            }
        }
        
        private function legendsContains(param1:XML) : Boolean {
            var _local_2:Legend = null;
            for each(_local_2 in this.legends) {
                if(_local_2.accountId == param1.@accountId && _local_2.charId == param1.@charId) {
                    return true;
                }
            }
            return false;
        }
        
        public function makeLegend(param1:XML) : Legend {
            var _local_2:int = param1.ObjectType;
            var _local_3:int = param1.Texture;
            var _local_4:CharacterClass = this.classesModel.getCharacterClass(_local_2);
            var _local_5:CharacterSkin = _local_4.skins.getSkin(_local_3);
            var _local_6:int = !!param1.hasOwnProperty("Tex1")?int(param1.Tex1):0;
            var _local_7:int = !!param1.hasOwnProperty("Tex2")?int(param1.Tex2):0;
            var _local_8:int = !!_local_5.is16x16?50:100;
            var _local_9:Legend = new Legend();
            _local_9.accountId = param1.@accountId;
            _local_9.charId = param1.@charId;
            _local_9.name = param1.Name;
            _local_9.totalFame = param1.TotalFame;
            _local_9.character = this.factory.makeIcon(_local_5.template,_local_8,_local_6,_local_7);
            _local_9.equipmentSlots = _local_4.slotTypes;
            _local_9.equipment = ConversionUtil.toIntVector(param1.Equipment);
            return _local_9;
        }
    }
}
