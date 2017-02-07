package com.company.assembleegameclient.objects {
    import com.company.assembleegameclient.objects.animation.AnimationsData;
    import com.company.assembleegameclient.parameters.Parameters;
    import com.company.assembleegameclient.util.TextureRedrawer;
    import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
    import com.company.util.AssetLibrary;
    import com.company.util.ConversionUtil;
    import flash.display.BitmapData;
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;
    import kabam.rotmg.constants.GeneralConstants;
    import kabam.rotmg.constants.ItemConstants;
    import kabam.rotmg.messaging.impl.data.StatData;
    
    public class ObjectLibrary {
        
        public static var textureDataFactory:TextureDataFactory = new TextureDataFactory();
        
        public static const IMAGE_SET_NAME:String = "lofiObj3";
        
        public static const IMAGE_ID:int = 255;
        
        public static var playerChars_:Vector.<XML> = new Vector.<XML>();
        
        public static var hexTransforms_:Vector.<XML> = new Vector.<XML>();
        
        public static var playerClassAbbr_:Dictionary = new Dictionary();
        
        public static const propsLibrary_:Dictionary = new Dictionary();
        
        public static const xmlLibrary_:Dictionary = new Dictionary();
        
        public static const idToType_:Dictionary = new Dictionary();
        
        public static const typeToDisplayId_:Dictionary = new Dictionary();
        
        public static const typeToTextureData_:Dictionary = new Dictionary();
        
        public static const typeToTopTextureData_:Dictionary = new Dictionary();
        
        public static const typeToAnimationsData_:Dictionary = new Dictionary();
        
        public static const petXMLDataLibrary_:Dictionary = new Dictionary();
        
        public static const skinSetXMLDataLibrary_:Dictionary = new Dictionary();
        
        public static const defaultProps_:ObjectProperties = new ObjectProperties(null);
        
        public static const TYPE_MAP:Object = {
            "ArenaGuard":ArenaGuard,
            "ArenaPortal":ArenaPortal,
            "CaveWall":CaveWall,
            "Character":Character,
            "CharacterChanger":CharacterChanger,
            "ClosedGiftChest":ClosedGiftChest,
            "ClosedVaultChest":ClosedVaultChest,
            "ConnectedWall":ConnectedWall,
            "Container":Container,
            "DoubleWall":DoubleWall,
            "FortuneGround":FortuneGround,
            "FortuneTeller":FortuneTeller,
            "GameObject":GameObject,
            "GuildBoard":GuildBoard,
            "GuildChronicle":GuildChronicle,
            "GuildHallPortal":GuildHallPortal,
            "GuildMerchant":GuildMerchant,
            "GuildRegister":GuildRegister,
            "Merchant":Merchant,
            "MoneyChanger":MoneyChanger,
            "MysteryBoxGround":MysteryBoxGround,
            "NameChanger":NameChanger,
            "ReskinVendor":ReskinVendor,
            "OneWayContainer":OneWayContainer,
            "Player":Player,
            "Portal":Portal,
            "Projectile":Projectile,
            "QuestRewards":QuestRewards,
            "Sign":Sign,
            "SpiderWeb":SpiderWeb,
            "Stalagmite":Stalagmite,
            "Wall":Wall,
            "Pet":Pet,
            "PetUpgrader":PetUpgrader,
            "YardUpgrader":YardUpgrader
        };
         
        
        public function ObjectLibrary() {
            super();
        }
        
        public static function parseFromXML(param1:XML) : void {
            var _local_2:XML = null;
            var _local_3:String = null;
            var _local_4:String = null;
            var _local_5:int = 0;
            var _local_6:Boolean = false;
            var _local_7:int = 0;
            for each(_local_2 in param1.Object) {
                _local_3 = String(_local_2.@id);
                _local_4 = _local_3;
                if(_local_2.hasOwnProperty("DisplayId")) {
                    _local_4 = _local_2.DisplayId;
                }
                if(_local_2.hasOwnProperty("Group")) {
                    if(_local_2.Group == "Hexable") {
                        hexTransforms_.push(_local_2);
                    }
                }
                _local_5 = int(_local_2.@type);
                if(_local_2.hasOwnProperty("PetBehavior") || _local_2.hasOwnProperty("PetAbility")) {
                    petXMLDataLibrary_[_local_5] = _local_2;
                } else {
                    propsLibrary_[_local_5] = new ObjectProperties(_local_2);
                    xmlLibrary_[_local_5] = _local_2;
                    idToType_[_local_3] = _local_5;
                    typeToDisplayId_[_local_5] = _local_4;
                    if(String(_local_2.Class) == "Player") {
                        playerClassAbbr_[_local_5] = String(_local_2.@id).substr(0,2);
                        _local_6 = false;
                        _local_7 = 0;
                        while(_local_7 < playerChars_.length) {
                            if(int(playerChars_[_local_7].@type) == _local_5) {
                                playerChars_[_local_7] = _local_2;
                                _local_6 = true;
                            }
                            _local_7++;
                        }
                        if(!_local_6) {
                            playerChars_.push(_local_2);
                        }
                    }
                    typeToTextureData_[_local_5] = textureDataFactory.create(_local_2);
                    if(_local_2.hasOwnProperty("Top")) {
                        typeToTopTextureData_[_local_5] = textureDataFactory.create(XML(_local_2.Top));
                    }
                    if(_local_2.hasOwnProperty("Animation")) {
                        typeToAnimationsData_[_local_5] = new AnimationsData(_local_2);
                    }
                }
            }
        }
        
        public static function getIdFromType(param1:int) : String {
            var _local_2:XML = xmlLibrary_[param1];
            if(_local_2 == null) {
                return null;
            }
            return String(_local_2.@id);
        }
        
        public static function getPropsFromId(param1:String) : ObjectProperties {
            var _local_2:int = idToType_[param1];
            return propsLibrary_[_local_2];
        }
        
        public static function getXMLfromId(param1:String) : XML {
            var _local_2:int = idToType_[param1];
            return xmlLibrary_[_local_2];
        }
        
        public static function getObjectFromType(param1:int) : GameObject {
            var _local_2:XML = xmlLibrary_[param1];
            var _local_3:String = _local_2.Class;
            var _local_4:Class = TYPE_MAP[_local_3] || makeClass(_local_3);
            return new _local_4(_local_2);
        }
        
        private static function makeClass(param1:String) : Class {
            var _local_2:String = "com.company.assembleegameclient.objects." + param1;
            return getDefinitionByName(_local_2) as Class;
        }
        
        public static function getTextureFromType(param1:int) : BitmapData {
            var _local_2:TextureData = typeToTextureData_[param1];
            if(_local_2 == null) {
                return null;
            }
            return _local_2.getTexture();
        }
        
        public static function getBitmapData(param1:int) : BitmapData {
            var _local_2:TextureData = typeToTextureData_[param1];
            var _local_3:BitmapData = !!_local_2?_local_2.getTexture():null;
            if(_local_3) {
                return _local_3;
            }
            return AssetLibrary.getImageFromSet(IMAGE_SET_NAME,IMAGE_ID);
        }
        
        public static function getRedrawnTextureFromType(param1:int, param2:int, param3:Boolean, param4:Boolean = true, param5:Number = 5) : BitmapData {
            var _local_6:BitmapData = getBitmapData(param1);
            if(Parameters.itemTypes16.indexOf(param1) != -1) {
                param2 = param2 * 0.5;
            }
            var _local_7:TextureData = typeToTextureData_[param1];
            var _local_8:BitmapData = !!_local_7?_local_7.mask_:null;
            if(_local_8 == null) {
                return TextureRedrawer.redraw(_local_6,param2,param3,0,param4,param5);
            }
            var _local_9:XML = xmlLibrary_[param1];
            var _local_10:int = !!_local_9.hasOwnProperty("Tex1")?int(int(_local_9.Tex1)):0;
            var _local_11:int = !!_local_9.hasOwnProperty("Tex2")?int(int(_local_9.Tex2)):0;
            _local_6 = TextureRedrawer.resize(_local_6,_local_8,param2,param3,_local_10,_local_11,param5);
            _local_6 = GlowRedrawer.outlineGlow(_local_6,0);
            return _local_6;
        }
        
        public static function getSizeFromType(param1:int) : int {
            var _local_2:XML = xmlLibrary_[param1];
            if(!_local_2.hasOwnProperty("Size")) {
                return 100;
            }
            return int(_local_2.Size);
        }
        
        public static function getSlotTypeFromType(param1:int) : int {
            var _local_2:XML = xmlLibrary_[param1];
            if(!_local_2.hasOwnProperty("SlotType")) {
                return -1;
            }
            return int(_local_2.SlotType);
        }
        
        public static function isEquippableByPlayer(param1:int, param2:Player) : Boolean {
            if(param1 == ItemConstants.NO_ITEM) {
                return false;
            }
            var _local_3:XML = xmlLibrary_[param1];
            var _local_4:int = int(_local_3.SlotType.toString());
            var _local_5:uint = 0;
            while(_local_5 < GeneralConstants.NUM_EQUIPMENT_SLOTS) {
                if(param2.slotTypes_[_local_5] == _local_4) {
                    return true;
                }
                _local_5++;
            }
            return false;
        }
        
        public static function getMatchingSlotIndex(param1:int, param2:Player) : int {
            var _local_3:XML = null;
            var _local_4:int = 0;
            var _local_5:uint = 0;
            if(param1 != ItemConstants.NO_ITEM) {
                _local_3 = xmlLibrary_[param1];
                _local_4 = int(_local_3.SlotType);
                _local_5 = 0;
                while(_local_5 < GeneralConstants.NUM_EQUIPMENT_SLOTS) {
                    if(param2.slotTypes_[_local_5] == _local_4) {
                        return _local_5;
                    }
                    _local_5++;
                }
            }
            return -1;
        }
        
        public static function isUsableByPlayer(param1:int, param2:Player) : Boolean {
            if(param2 == null) {
                return true;
            }
            var _local_3:XML = xmlLibrary_[param1];
            if(_local_3 == null || !_local_3.hasOwnProperty("SlotType")) {
                return false;
            }
            var _local_4:int = _local_3.SlotType;
            if(_local_4 == ItemConstants.POTION_TYPE || _local_4 == ItemConstants.EGG_TYPE) {
                return true;
            }
            var _local_5:int = 0;
            while(_local_5 < param2.slotTypes_.length) {
                if(param2.slotTypes_[_local_5] == _local_4) {
                    return true;
                }
                _local_5++;
            }
            return false;
        }
        
        public static function isSoulbound(param1:int) : Boolean {
            var _local_2:XML = xmlLibrary_[param1];
            return _local_2 != null && _local_2.hasOwnProperty("Soulbound");
        }
        
        public static function usableBy(param1:int) : Vector.<String> {
            var _local_5:XML = null;
            var _local_6:Vector.<int> = null;
            var _local_7:int = 0;
            var _local_2:XML = xmlLibrary_[param1];
            if(_local_2 == null || !_local_2.hasOwnProperty("SlotType")) {
                return null;
            }
            var _local_3:int = _local_2.SlotType;
            if(_local_3 == ItemConstants.POTION_TYPE || _local_3 == ItemConstants.RING_TYPE || _local_3 == ItemConstants.EGG_TYPE) {
                return null;
            }
            var _local_4:Vector.<String> = new Vector.<String>();
            for each(_local_5 in playerChars_) {
                _local_6 = ConversionUtil.toIntVector(_local_5.SlotTypes);
                _local_7 = 0;
                while(_local_7 < _local_6.length) {
                    if(_local_6[_local_7] == _local_3) {
                        _local_4.push(typeToDisplayId_[int(_local_5.@type)]);
                        break;
                    }
                    _local_7++;
                }
            }
            return _local_4;
        }
        
        public static function playerMeetsRequirements(param1:int, param2:Player) : Boolean {
            var _local_4:XML = null;
            if(param2 == null) {
                return true;
            }
            var _local_3:XML = xmlLibrary_[param1];
            for each(_local_4 in _local_3.EquipRequirement) {
                if(!playerMeetsRequirement(_local_4,param2)) {
                    return false;
                }
            }
            return true;
        }
        
        public static function playerMeetsRequirement(param1:XML, param2:Player) : Boolean {
            var _local_3:int = 0;
            if(param1.toString() == "Stat") {
                _local_3 = int(param1.@value);
                switch(int(param1.@stat)) {
                    case StatData.MAX_HP_STAT:
                        return param2.maxHP_ >= _local_3;
                    case StatData.MAX_MP_STAT:
                        return param2.maxMP_ >= _local_3;
                    case StatData.LEVEL_STAT:
                        return param2.level_ >= _local_3;
                    case StatData.ATTACK_STAT:
                        return param2.attack_ >= _local_3;
                    case StatData.DEFENSE_STAT:
                        return param2.defense_ >= _local_3;
                    case StatData.SPEED_STAT:
                        return param2.speed_ >= _local_3;
                    case StatData.VITALITY_STAT:
                        return param2.vitality_ >= _local_3;
                    case StatData.WISDOM_STAT:
                        return param2.wisdom_ >= _local_3;
                    case StatData.DEXTERITY_STAT:
                        return param2.dexterity_ >= _local_3;
                }
            }
            return false;
        }
        
        public static function getPetDataXMLByType(param1:int) : XML {
            return petXMLDataLibrary_[param1];
        }
    }
}
