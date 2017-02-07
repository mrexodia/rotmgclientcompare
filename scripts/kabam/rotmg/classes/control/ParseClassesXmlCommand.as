package kabam.rotmg.classes.control {
    import kabam.rotmg.assets.model.CharacterTemplate;
    import kabam.rotmg.classes.model.CharacterClass;
    import kabam.rotmg.classes.model.CharacterClassStat;
    import kabam.rotmg.classes.model.CharacterClassUnlock;
    import kabam.rotmg.classes.model.CharacterSkin;
    import kabam.rotmg.classes.model.CharacterSkinState;
    import kabam.rotmg.classes.model.ClassesModel;
    import kabam.rotmg.text.model.TextKey;
    
    public class ParseClassesXmlCommand {
         
        
        [Inject]
        public var data:XML;
        
        [Inject]
        public var classes:ClassesModel;
        
        public function ParseClassesXmlCommand() {
            super();
        }
        
        public function execute() : void {
            var _local_2:XML = null;
            var _local_1:XMLList = this.data.Object;
            for each(_local_2 in _local_1) {
                this.parseCharacterClass(_local_2);
            }
        }
        
        private function parseCharacterClass(param1:XML) : void {
            var _local_2:int = param1.@type;
            var _local_3:CharacterClass = this.classes.getCharacterClass(_local_2);
            this.populateCharacter(_local_3,param1);
        }
        
        private function populateCharacter(param1:CharacterClass, param2:XML) : void {
            var _local_3:XML = null;
            param1.id = param2.@type;
            param1.name = param2.DisplayId;
            param1.description = param2.Description;
            param1.hitSound = param2.HitSound;
            param1.deathSound = param2.DeathSound;
            param1.bloodProb = param2.BloodProb;
            param1.slotTypes = this.parseIntList(param2.SlotTypes);
            param1.defaultEquipment = this.parseIntList(param2.Equipment);
            param1.hp = this.parseCharacterStat(param2,"MaxHitPoints");
            param1.mp = this.parseCharacterStat(param2,"MaxMagicPoints");
            param1.attack = this.parseCharacterStat(param2,"Attack");
            param1.defense = this.parseCharacterStat(param2,"Defense");
            param1.speed = this.parseCharacterStat(param2,"Speed");
            param1.dexterity = this.parseCharacterStat(param2,"Dexterity");
            param1.hpRegeneration = this.parseCharacterStat(param2,"HpRegen");
            param1.mpRegeneration = this.parseCharacterStat(param2,"MpRegen");
            param1.unlockCost = param2.UnlockCost;
            for each(_local_3 in param2.UnlockLevel) {
                param1.unlocks.push(this.parseUnlock(_local_3));
            }
            param1.skins.addSkin(this.makeDefaultSkin(param2),true);
        }
        
        private function makeDefaultSkin(param1:XML) : CharacterSkin {
            var _local_2:String = param1.AnimatedTexture.File;
            var _local_3:int = param1.AnimatedTexture.Index;
            var _local_4:CharacterSkin = new CharacterSkin();
            _local_4.id = 0;
            _local_4.name = TextKey.CLASSIC_SKIN;
            _local_4.template = new CharacterTemplate(_local_2,_local_3);
            _local_4.setState(CharacterSkinState.OWNED);
            _local_4.setIsSelected(true);
            return _local_4;
        }
        
        private function parseUnlock(param1:XML) : CharacterClassUnlock {
            var _local_2:CharacterClassUnlock = new CharacterClassUnlock();
            _local_2.level = param1.@level;
            _local_2.character = this.classes.getCharacterClass(param1.@type);
            return _local_2;
        }
        
        private function parseCharacterStat(param1:XML, param2:String) : CharacterClassStat {
            var _local_4:XML = null;
            var _local_5:XML = null;
            var _local_6:CharacterClassStat = null;
            var _local_3:XML = param1[param2][0];
            for each(_local_5 in param1.LevelIncrease) {
                if(_local_5.text() == param2) {
                    _local_4 = _local_5;
                }
            }
            _local_6 = new CharacterClassStat();
            _local_6.initial = int(_local_3.toString());
            _local_6.max = _local_3.@max;
            _local_6.rampMin = !!_local_4?int(_local_4.@min):0;
            _local_6.rampMax = !!_local_4?int(_local_4.@max):0;
            return _local_6;
        }
        
        private function parseIntList(param1:String) : Vector.<int> {
            var _local_2:Array = param1.split(",");
            var _local_3:int = _local_2.length;
            var _local_4:Vector.<int> = new Vector.<int>(_local_3,true);
            var _local_5:int = 0;
            while(_local_5 < _local_3) {
                _local_4[_local_5] = int(_local_2[_local_5]);
                _local_5++;
            }
            return _local_4;
        }
    }
}
