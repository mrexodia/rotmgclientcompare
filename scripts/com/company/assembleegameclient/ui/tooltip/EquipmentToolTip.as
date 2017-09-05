package com.company.assembleegameclient.ui.tooltip {
    import com.company.assembleegameclient.constants.InventoryOwnerTypes;
    import com.company.assembleegameclient.game.events.KeyInfoResponseSignal;
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import com.company.assembleegameclient.objects.Player;
    import com.company.assembleegameclient.parameters.Parameters;
    import com.company.assembleegameclient.ui.LineBreakDesign;
    import com.company.assembleegameclient.util.MathUtil;
    import com.company.util.BitmapUtil;
    import com.company.util.KeyCodes;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.filters.DropShadowFilter;
    import flash.utils.Dictionary;
    import kabam.rotmg.constants.ActivationType;
    import kabam.rotmg.core.StaticInjectorContext;
    import kabam.rotmg.messaging.impl.data.StatData;
    import kabam.rotmg.messaging.impl.incoming.KeyInfoResponse;
    import kabam.rotmg.text.model.TextKey;
    import kabam.rotmg.text.view.TextFieldDisplayConcrete;
    import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
    import kabam.rotmg.text.view.stringBuilder.StringBuilder;
    import kabam.rotmg.ui.model.HUDModel;
    
    public class EquipmentToolTip extends ToolTip {
        
        private static const MAX_WIDTH:int = 230;
        
        public static var keyInfo:Dictionary = new Dictionary();
         
        
        private var icon:Bitmap;
        
        public var titleText:TextFieldDisplayConcrete;
        
        private var tierText:TextFieldDisplayConcrete;
        
        private var descText:TextFieldDisplayConcrete;
        
        private var line1:LineBreakDesign;
        
        private var effectsText:TextFieldDisplayConcrete;
        
        private var line2:LineBreakDesign;
        
        private var line3:LineBreakDesign;
        
        private var restrictionsText:TextFieldDisplayConcrete;
        
        private var setInfoText:TextFieldDisplayConcrete;
        
        private var player:Player;
        
        private var isEquippable:Boolean = false;
        
        private var objectType:int;
        
        private var titleOverride:String;
        
        private var descriptionOverride:String;
        
        private var curItemXML:XML = null;
        
        private var objectXML:XML = null;
        
        private var slotTypeToTextBuilder:SlotComparisonFactory;
        
        private var restrictions:Vector.<Restriction>;
        
        private var setInfo:Vector.<Effect>;
        
        private var effects:Vector.<Effect>;
        
        private var uniqueEffects:Vector.<Effect>;
        
        private var itemSlotTypeId:int;
        
        private var invType:int;
        
        private var inventorySlotID:uint;
        
        private var inventoryOwnerType:String;
        
        private var isInventoryFull:Boolean;
        
        private var playerCanUse:Boolean;
        
        private var comparisonResults:SlotComparisonResult;
        
        private var powerText:TextFieldDisplayConcrete;
        
        private var keyInfoResponse:KeyInfoResponseSignal;
        
        private var originalObjectType:int;
        
        public function EquipmentToolTip(param1:int, param2:Player, param3:int, param4:String) {
            var _local_8:HUDModel = null;
            this.uniqueEffects = new Vector.<Effect>();
            this.objectType = param1;
            this.originalObjectType = this.objectType;
            this.player = param2;
            this.invType = param3;
            this.inventoryOwnerType = param4;
            this.isInventoryFull = !!param2?Boolean(param2.isInventoryFull()):false;
            if(this.objectType >= 36864 && this.objectType <= 61440) {
                this.objectType = 36863;
            }
            this.playerCanUse = !!param2?Boolean(ObjectLibrary.isUsableByPlayer(this.objectType,param2)):false;
            var _local_5:int = !!param2?int(ObjectLibrary.getMatchingSlotIndex(this.objectType,param2)):-1;
            var _local_6:uint = this.playerCanUse || this.player == null?uint(3552822):uint(6036765);
            var _local_7:uint = this.playerCanUse || param2 == null?uint(10197915):uint(10965039);
            super(_local_6,1,_local_7,1,true);
            this.slotTypeToTextBuilder = new SlotComparisonFactory();
            this.objectXML = ObjectLibrary.xmlLibrary_[this.objectType];
            this.isEquippable = _local_5 != -1;
            this.setInfo = new Vector.<Effect>();
            this.effects = new Vector.<Effect>();
            this.itemSlotTypeId = int(this.objectXML.SlotType);
            if(this.player == null) {
                this.curItemXML = this.objectXML;
            } else if(this.isEquippable) {
                if(this.player.equipment_[_local_5] != -1) {
                    this.curItemXML = ObjectLibrary.xmlLibrary_[this.player.equipment_[_local_5]];
                }
            }
            this.addIcon();
            if(this.originalObjectType >= 36864 && this.originalObjectType <= 61440) {
                if(keyInfo[this.originalObjectType] == null) {
                    this.addTitle();
                    this.addDescriptionText();
                    this.keyInfoResponse = StaticInjectorContext.getInjector().getInstance(KeyInfoResponseSignal);
                    this.keyInfoResponse.add(this.onKeyInfoResponse);
                    _local_8 = StaticInjectorContext.getInjector().getInstance(HUDModel);
                    _local_8.gameSprite.gsc_.keyInfoRequest(this.originalObjectType);
                } else {
                    this.titleOverride = keyInfo[this.originalObjectType][0] + " Key";
                    this.descriptionOverride = keyInfo[this.originalObjectType][1] + "\n" + "Created By: " + keyInfo[this.originalObjectType][2];
                    this.addTitle();
                    this.addDescriptionText();
                }
            } else {
                this.addTitle();
                this.addDescriptionText();
            }
            this.addTierText();
            this.handleWisMod();
            this.buildCategorySpecificText();
            this.addUniqueEffectsToList();
            this.addNumProjectilesTagsToEffectsList();
            this.addProjectileTagsToEffectsList();
            this.addActivateTagsToEffectsList();
            this.addActivateOnEquipTagsToEffectsList();
            this.addDoseTagsToEffectsList();
            this.addMpCostTagToEffectsList();
            this.addFameBonusTagToEffectsList();
            this.addCooldownTagToEffectsList();
            this.addSetInfo();
            this.makeSetInfoText();
            this.makeEffectsList();
            this.makeLineTwo();
            this.makeRestrictionList();
            this.makeRestrictionText();
            this.makeItemPowerText();
        }
        
        private function addSetInfo() : void {
            if(!this.objectXML.hasOwnProperty("@setType")) {
                return;
            }
            var _local_1:int = this.objectXML.attribute("setType");
            this.setInfo.push(new Effect("Part of {name}",{"name":"<b>" + this.objectXML.attribute("setName") + "</b>"}).setColor(TooltipHelper.SET_COLOR).setReplacementsColor(TooltipHelper.SET_COLOR));
            this.addSetActivateOnEquipTagsToEffectsList(_local_1);
        }
        
        private function addSetActivateOnEquipTagsToEffectsList(param1:int) : void {
            var _local_4:XML = null;
            var _local_2:uint = 8805920;
            var _local_3:XML = ObjectLibrary.getSetXMLFromType(param1);
            if(!_local_3.hasOwnProperty("ActivateOnEquipAll")) {
                return;
            }
            for each(_local_4 in _local_3.ActivateOnEquipAll) {
                if(_local_4.toString() == "ChangeSkin") {
                    if(this.player.skinId == int(_local_4.@skinType)) {
                        _local_2 = TooltipHelper.SET_COLOR;
                    }
                }
                if(_local_4.toString() == "IncrementStat") {
                    this.setInfo.push(new Effect(TextKey.INCREMENT_STAT,this.getComparedStatText(_local_4)).setColor(_local_2).setReplacementsColor(_local_2));
                }
            }
        }
        
        private function makeItemPowerText() : void {
            var _local_1:int = 0;
            if(this.objectXML.hasOwnProperty("feedPower")) {
                _local_1 = this.playerCanUse || this.player == null?16777215:16549442;
                this.powerText = new TextFieldDisplayConcrete().setSize(12).setColor(_local_1).setBold(true).setTextWidth(MAX_WIDTH - this.icon.width - 4 - 30).setWordWrap(true);
                this.powerText.setStringBuilder(new StaticStringBuilder().setString("Feed Power: " + this.objectXML.feedPower));
                this.powerText.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
                waiter.push(this.powerText.textChanged);
                addChild(this.powerText);
            }
        }
        
        private function onKeyInfoResponse(param1:KeyInfoResponse) : void {
            this.keyInfoResponse.remove(this.onKeyInfoResponse);
            this.removeTitle();
            this.removeDesc();
            this.titleOverride = param1.name;
            this.descriptionOverride = param1.description;
            keyInfo[this.originalObjectType] = [param1.name,param1.description,param1.creator];
            this.addTitle();
            this.addDescriptionText();
        }
        
        private function addUniqueEffectsToList() : void {
            var _local_1:XMLList = null;
            var _local_2:XML = null;
            var _local_3:String = null;
            var _local_4:String = null;
            var _local_5:String = null;
            var _local_6:AppendingLineBuilder = null;
            if(this.objectXML.hasOwnProperty("ExtraTooltipData")) {
                _local_1 = this.objectXML.ExtraTooltipData.EffectInfo;
                for each(_local_2 in _local_1) {
                    _local_3 = _local_2.attribute("name");
                    _local_4 = _local_2.attribute("description");
                    _local_5 = _local_3 && _local_4?": ":"\n";
                    _local_6 = new AppendingLineBuilder();
                    if(_local_3) {
                        _local_6.pushParams(_local_3);
                    }
                    if(_local_4) {
                        _local_6.pushParams(_local_4,{},TooltipHelper.getOpenTag(16777103),TooltipHelper.getCloseTag());
                    }
                    _local_6.setDelimiter(_local_5);
                    this.uniqueEffects.push(new Effect(TextKey.BLANK,{"data":_local_6}));
                }
            }
        }
        
        private function isEmptyEquipSlot() : Boolean {
            return this.isEquippable && this.curItemXML == null;
        }
        
        private function addIcon() : void {
            var _local_1:XML = ObjectLibrary.xmlLibrary_[this.objectType];
            var _local_2:int = 5;
            if(this.objectType == 4874 || this.objectType == 4618) {
                _local_2 = 8;
            }
            if(_local_1.hasOwnProperty("ScaleValue")) {
                _local_2 = _local_1.ScaleValue;
            }
            var _local_3:BitmapData = ObjectLibrary.getRedrawnTextureFromType(this.objectType,60,true,true,_local_2);
            _local_3 = BitmapUtil.cropToBitmapData(_local_3,4,4,_local_3.width - 8,_local_3.height - 8);
            this.icon = new Bitmap(_local_3);
            addChild(this.icon);
        }
        
        private function addTierText() : void {
            var _local_1:* = this.isPet() == false;
            var _local_2:* = this.objectXML.hasOwnProperty("Consumable") == false;
            var _local_3:* = this.objectXML.hasOwnProperty("Treasure") == false;
            var _local_4:Boolean = this.objectXML.hasOwnProperty("Tier");
            if(_local_1 && _local_2 && _local_3) {
                this.tierText = new TextFieldDisplayConcrete().setSize(16).setColor(16777215).setTextWidth(30).setBold(true);
                if(_local_4) {
                    this.tierText.setStringBuilder(new LineBuilder().setParams(TextKey.TIER_ABBR,{"tier":this.objectXML.Tier}));
                } else if(this.objectXML.hasOwnProperty("@setType")) {
                    this.tierText.setColor(TooltipHelper.SET_COLOR);
                    this.tierText.setStringBuilder(new StaticStringBuilder("ST"));
                } else {
                    this.tierText.setColor(TooltipHelper.UNTIERED_COLOR);
                    this.tierText.setStringBuilder(new LineBuilder().setParams(TextKey.UNTIERED_ABBR));
                }
                addChild(this.tierText);
            }
        }
        
        private function isPet() : Boolean {
            var activateTags:XMLList = null;
            activateTags = this.objectXML.Activate.(text() == "PermaPet");
            return activateTags.length() >= 1;
        }
        
        private function removeTitle() : * {
            removeChild(this.titleText);
        }
        
        private function removeDesc() : * {
            removeChild(this.descText);
        }
        
        private function addTitle() : void {
            var _local_1:int = this.playerCanUse || this.player == null?16777215:16549442;
            this.titleText = new TextFieldDisplayConcrete().setSize(16).setColor(_local_1).setBold(true).setTextWidth(MAX_WIDTH - this.icon.width - 4 - 30).setWordWrap(true);
            if(this.titleOverride) {
                this.titleText.setStringBuilder(new StaticStringBuilder(this.titleOverride));
            } else {
                this.titleText.setStringBuilder(new LineBuilder().setParams(ObjectLibrary.typeToDisplayId_[this.objectType]));
            }
            this.titleText.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
            waiter.push(this.titleText.textChanged);
            addChild(this.titleText);
        }
        
        private function buildUniqueTooltipData() : String {
            var _local_1:XMLList = null;
            var _local_2:Vector.<Effect> = null;
            var _local_3:XML = null;
            if(this.objectXML.hasOwnProperty("ExtraTooltipData")) {
                _local_1 = this.objectXML.ExtraTooltipData.EffectInfo;
                _local_2 = new Vector.<Effect>();
                for each(_local_3 in _local_1) {
                    _local_2.push(new Effect(_local_3.attribute("name"),_local_3.attribute("description")));
                }
            }
            return "";
        }
        
        private function makeEffectsList() : void {
            var _local_1:AppendingLineBuilder = null;
            if(this.effects.length != 0 || this.comparisonResults.lineBuilder != null || this.objectXML.hasOwnProperty("ExtraTooltipData")) {
                this.line1 = new LineBreakDesign(MAX_WIDTH - 12,0);
                this.effectsText = new TextFieldDisplayConcrete().setSize(14).setColor(11776947).setTextWidth(MAX_WIDTH).setWordWrap(true).setHTML(true);
                _local_1 = this.getEffectsStringBuilder();
                this.effectsText.setStringBuilder(_local_1);
                this.effectsText.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
                if(_local_1.hasLines()) {
                    addChild(this.line1);
                    addChild(this.effectsText);
                }
            }
        }
        
        private function getEffectsStringBuilder() : AppendingLineBuilder {
            var _local_1:AppendingLineBuilder = new AppendingLineBuilder();
            this.appendEffects(this.uniqueEffects,_local_1);
            if(this.comparisonResults.lineBuilder.hasLines()) {
                _local_1.pushParams(TextKey.BLANK,{"data":this.comparisonResults.lineBuilder});
            }
            this.appendEffects(this.effects,_local_1);
            return _local_1;
        }
        
        private function appendEffects(param1:Vector.<Effect>, param2:AppendingLineBuilder) : void {
            var _local_3:Effect = null;
            var _local_4:* = null;
            var _local_5:String = null;
            for each(_local_3 in param1) {
                _local_4 = "";
                _local_5 = "";
                if(_local_3.color_) {
                    _local_4 = "<font color=\"#" + _local_3.color_.toString(16) + "\">";
                    _local_5 = "</font>";
                }
                param2.pushParams(_local_3.name_,_local_3.getValueReplacementsWithColor(),_local_4,_local_5);
            }
        }
        
        private function addNumProjectilesTagsToEffectsList() : void {
            if(this.objectXML.hasOwnProperty("NumProjectiles") && this.comparisonResults.processedTags.hasOwnProperty(this.objectXML.NumProjectiles.toXMLString()) != true) {
                this.effects.push(new Effect(TextKey.SHOTS,{"numShots":this.objectXML.NumProjectiles}));
            }
        }
        
        private function addFameBonusTagToEffectsList() : void {
            var _local_1:int = 0;
            var _local_2:uint = 0;
            var _local_3:int = 0;
            if(this.objectXML.hasOwnProperty("FameBonus")) {
                _local_1 = int(this.objectXML.FameBonus);
                _local_2 = !!this.playerCanUse?uint(TooltipHelper.BETTER_COLOR):uint(TooltipHelper.NO_DIFF_COLOR);
                if(this.curItemXML != null && this.curItemXML.hasOwnProperty("FameBonus")) {
                    _local_3 = int(this.curItemXML.FameBonus.text());
                    _local_2 = TooltipHelper.getTextColor(_local_1 - _local_3);
                }
                this.effects.push(new Effect(TextKey.FAME_BONUS,{"percent":this.objectXML.FameBonus + "%"}).setReplacementsColor(_local_2));
            }
        }
        
        private function addMpCostTagToEffectsList() : void {
            var _local_1:int = 0;
            var _local_2:int = 0;
            if(this.objectXML.hasOwnProperty("MpEndCost")) {
                _local_1 = _local_2 = this.objectXML.MpEndCost;
                if(this.curItemXML && this.curItemXML.hasOwnProperty("MpEndCost")) {
                    _local_2 = this.curItemXML.MpEndCost;
                }
                this.effects.push(new Effect(TextKey.MP_COST,{"cost":TooltipHelper.compare(_local_1,_local_2,false)}));
            } else if(this.objectXML.hasOwnProperty("MpCost")) {
                _local_1 = _local_2 = this.objectXML.MpCost;
                if(this.curItemXML && this.curItemXML.hasOwnProperty("MpCost")) {
                    _local_2 = this.curItemXML.MpCost;
                }
                this.effects.push(new Effect(TextKey.MP_COST,{"cost":TooltipHelper.compare(_local_1,_local_2,false)}));
            }
        }
        
        private function addCooldownTagToEffectsList() : void {
            if(this.objectXML.hasOwnProperty("Cooldown")) {
                this.effects.push(new Effect("Cooldown: {cd}",{"cd":TooltipHelper.getPlural(this.objectXML.Cooldown,"second")}));
            }
        }
        
        private function addDoseTagsToEffectsList() : void {
            if(this.objectXML.hasOwnProperty("Doses")) {
                this.effects.push(new Effect(TextKey.DOSES,{"dose":this.objectXML.Doses}));
            }
            if(this.objectXML.hasOwnProperty("Quantity")) {
                this.effects.push(new Effect("Quantity: {quantity}",{"quantity":this.objectXML.Quantity}));
            }
        }
        
        private function addProjectileTagsToEffectsList() : void {
            var _local_1:XML = null;
            var _local_2:int = 0;
            var _local_3:int = 0;
            var _local_4:Number = NaN;
            var _local_5:XML = null;
            if(this.objectXML.hasOwnProperty("Projectile") && !this.comparisonResults.processedTags.hasOwnProperty(this.objectXML.Projectile.toXMLString())) {
                _local_1 = XML(this.objectXML.Projectile);
                _local_2 = int(_local_1.MinDamage);
                _local_3 = int(_local_1.MaxDamage);
                this.effects.push(new Effect(TextKey.DAMAGE,{"damage":(_local_2 == _local_3?_local_2:_local_2 + " - " + _local_3).toString()}));
                _local_4 = Number(_local_1.Speed) * Number(_local_1.LifetimeMS) / 10000;
                this.effects.push(new Effect(TextKey.RANGE,{"range":TooltipHelper.getFormattedRangeString(_local_4)}));
                if(this.objectXML.Projectile.hasOwnProperty("MultiHit")) {
                    this.effects.push(new Effect(TextKey.MULTIHIT,{}).setColor(TooltipHelper.NO_DIFF_COLOR));
                }
                if(this.objectXML.Projectile.hasOwnProperty("PassesCover")) {
                    this.effects.push(new Effect(TextKey.PASSES_COVER,{}).setColor(TooltipHelper.NO_DIFF_COLOR));
                }
                if(this.objectXML.Projectile.hasOwnProperty("ArmorPiercing")) {
                    this.effects.push(new Effect(TextKey.ARMOR_PIERCING,{}).setColor(TooltipHelper.NO_DIFF_COLOR));
                }
                for each(_local_5 in _local_1.ConditionEffect) {
                    if(this.comparisonResults.processedTags[_local_5.toXMLString()] == null) {
                        this.effects.push(new Effect(TextKey.SHOT_EFFECT,{"effect":""}));
                        this.effects.push(new Effect(TextKey.EFFECT_FOR_DURATION,{
                            "effect":this.objectXML.Projectile.ConditionEffect,
                            "duration":this.objectXML.Projectile.ConditionEffect.@duration
                        }).setColor(TooltipHelper.NO_DIFF_COLOR));
                    }
                }
            }
        }
        
        private function addActivateTagsToEffectsList() : void {
            var activateXML:XML = null;
            var val:String = null;
            var stat:int = 0;
            var amt:int = 0;
            var test:String = null;
            var activationType:String = null;
            var compareXML:XML = null;
            var effectColor:uint = 0;
            var current:XML = null;
            var tokens:Object = null;
            var template:String = null;
            var effectColor2:uint = 0;
            var current2:XML = null;
            var statStr:String = null;
            var tokens2:Object = null;
            var template2:String = null;
            var replaceParams:Object = null;
            var rNew:Number = NaN;
            var rCurrent:Number = NaN;
            var dNew:Number = NaN;
            var dCurrent:Number = NaN;
            var comparer:Number = NaN;
            var rNew2:Number = NaN;
            var rCurrent2:Number = NaN;
            var dNew2:Number = NaN;
            var dCurrent2:Number = NaN;
            var aNew2:Number = NaN;
            var aCurrent2:Number = NaN;
            var comparer2:Number = NaN;
            var alb:AppendingLineBuilder = null;
            for each(activateXML in this.objectXML.Activate) {
                test = this.comparisonResults.processedTags[activateXML.toXMLString()];
                if(this.comparisonResults.processedTags[activateXML.toXMLString()] == true) {
                    continue;
                }
                activationType = activateXML.toString();
                compareXML = this.curItemXML == null?null:this.curItemXML.Activate.(text() == activationType)[0];
                switch(activationType) {
                    case ActivationType.COND_EFFECT_AURA:
                        this.effects.push(new Effect(TextKey.PARTY_EFFECT,{"effect":new AppendingLineBuilder().pushParams(TextKey.WITHIN_SQRS,{"range":activateXML.@range},TooltipHelper.getOpenTag(TooltipHelper.NO_DIFF_COLOR),TooltipHelper.getCloseTag())}));
                        this.effects.push(new Effect(TextKey.EFFECT_FOR_DURATION,{
                            "effect":activateXML.@effect,
                            "duration":activateXML.@duration
                        }).setColor(TooltipHelper.NO_DIFF_COLOR));
                        continue;
                    case ActivationType.COND_EFFECT_SELF:
                        this.effects.push(new Effect(TextKey.EFFECT_ON_SELF,{"effect":""}));
                        this.effects.push(new Effect(TextKey.EFFECT_FOR_DURATION,{
                            "effect":activateXML.@effect,
                            "duration":activateXML.@duration
                        }));
                        continue;
                    case ActivationType.HEAL:
                        this.effects.push(new Effect(TextKey.INCREMENT_STAT,{
                            "statAmount":"+" + activateXML.@amount + " ",
                            "statName":new LineBuilder().setParams(TextKey.STATUS_BAR_HEALTH_POINTS)
                        }));
                        continue;
                    case ActivationType.HEAL_NOVA:
                        this.effects.push(new Effect(TextKey.PARTY_HEAL,{"effect":new AppendingLineBuilder().pushParams(TextKey.HP_WITHIN_SQRS,{
                            "amount":activateXML.@amount,
                            "range":activateXML.@range
                        },TooltipHelper.getOpenTag(TooltipHelper.NO_DIFF_COLOR),TooltipHelper.getCloseTag())}));
                        continue;
                    case ActivationType.MAGIC:
                        this.effects.push(new Effect(TextKey.INCREMENT_STAT,{
                            "statAmount":"+" + activateXML.@amount + " ",
                            "statName":new LineBuilder().setParams(TextKey.STATUS_BAR_MANA_POINTS)
                        }));
                        continue;
                    case ActivationType.MAGIC_NOVA:
                        this.effects.push(new Effect(TextKey.FILL_PARTY_MAGIC,activateXML.@amount + " MP at " + activateXML.@range + " sqrs"));
                        continue;
                    case ActivationType.TELEPORT:
                        this.effects.push(new Effect(TextKey.BLANK,{"data":new LineBuilder().setParams(TextKey.TELEPORT_TO_TARGET)}));
                        continue;
                    case ActivationType.VAMPIRE_BLAST:
                        this.getSkull(activateXML,compareXML);
                        continue;
                    case ActivationType.TRAP:
                        this.getTrap(activateXML,compareXML);
                        continue;
                    case ActivationType.STASIS_BLAST:
                        this.effects.push(new Effect(TextKey.STASIS_GROUP,{"stasis":new AppendingLineBuilder().pushParams(TextKey.SEC_COUNT,{"duration":activateXML.@duration},TooltipHelper.getOpenTag(TooltipHelper.NO_DIFF_COLOR),TooltipHelper.getCloseTag())}));
                        continue;
                    case ActivationType.DECOY:
                        this.effects.push(new Effect(TextKey.DECOY,{"data":new AppendingLineBuilder().pushParams(TextKey.SEC_COUNT,{"duration":activateXML.@duration},TooltipHelper.getOpenTag(TooltipHelper.NO_DIFF_COLOR),TooltipHelper.getCloseTag())}));
                        continue;
                    case ActivationType.LIGHTNING:
                        this.getLightning(activateXML,compareXML);
                        continue;
                    case ActivationType.POISON_GRENADE:
                        this.effects.push(new Effect(TextKey.POISON_GRENADE,{"data":""}));
                        this.effects.push(new Effect(TextKey.POISON_GRENADE_DATA,{
                            "damage":activateXML.@totalDamage,
                            "duration":activateXML.@duration,
                            "radius":activateXML.@radius
                        }).setColor(TooltipHelper.NO_DIFF_COLOR));
                        continue;
                    case ActivationType.REMOVE_NEG_COND:
                        this.effects.push(new Effect(TextKey.REMOVES_NEGATIVE,{}).setColor(TooltipHelper.NO_DIFF_COLOR));
                        continue;
                    case ActivationType.REMOVE_NEG_COND_SELF:
                        this.effects.push(new Effect(TextKey.REMOVES_NEGATIVE,{}).setColor(TooltipHelper.NO_DIFF_COLOR));
                        continue;
                    case ActivationType.GENERIC_ACTIVATE:
                        effectColor = 16777103;
                        if(this.curItemXML != null) {
                            current = this.getEffectTag(this.curItemXML,activateXML.@effect);
                            if(current != null) {
                                rNew = Number(activateXML.@range);
                                rCurrent = Number(current.@range);
                                dNew = Number(activateXML.@duration);
                                dCurrent = Number(current.@duration);
                                comparer = rNew - rCurrent + (dNew - dCurrent);
                                if(comparer > 0) {
                                    effectColor = 65280;
                                } else if(comparer < 0) {
                                    effectColor = 16711680;
                                }
                            }
                        }
                        tokens = {
                            "range":activateXML.@range,
                            "effect":activateXML.@effect,
                            "duration":activateXML.@duration
                        };
                        template = "Within {range} sqrs {effect} for {duration} seconds";
                        if(activateXML.@target != "enemy") {
                            this.effects.push(new Effect(TextKey.PARTY_EFFECT,{"effect":LineBuilder.returnStringReplace(template,tokens)}).setReplacementsColor(effectColor));
                        } else {
                            this.effects.push(new Effect(TextKey.ENEMY_EFFECT,{"effect":LineBuilder.returnStringReplace(template,tokens)}).setReplacementsColor(effectColor));
                        }
                        continue;
                    case ActivationType.STAT_BOOST_AURA:
                        effectColor2 = 16777103;
                        if(this.curItemXML != null) {
                            current2 = this.getStatTag(this.curItemXML,activateXML.@stat);
                            if(current2 != null) {
                                rNew2 = Number(activateXML.@range);
                                rCurrent2 = Number(current2.@range);
                                dNew2 = Number(activateXML.@duration);
                                dCurrent2 = Number(current2.@duration);
                                aNew2 = Number(activateXML.@amount);
                                aCurrent2 = Number(current2.@amount);
                                comparer2 = rNew2 - rCurrent2 + (dNew2 - dCurrent2) + (aNew2 - aCurrent2);
                                if(comparer2 > 0) {
                                    effectColor2 = 65280;
                                } else if(comparer2 < 0) {
                                    effectColor2 = 16711680;
                                }
                            }
                        }
                        stat = int(activateXML.@stat);
                        statStr = LineBuilder.getLocalizedString2(StatData.statToName(stat));
                        tokens2 = {
                            "range":activateXML.@range,
                            "stat":statStr,
                            "amount":activateXML.@amount,
                            "duration":activateXML.@duration
                        };
                        template2 = "Within {range} sqrs increase {stat} by {amount} for {duration} seconds";
                        this.effects.push(new Effect(TextKey.PARTY_EFFECT,{"effect":LineBuilder.returnStringReplace(template2,tokens2)}).setReplacementsColor(effectColor2));
                        continue;
                    case ActivationType.INCREMENT_STAT:
                        stat = int(activateXML.@stat);
                        amt = int(activateXML.@amount);
                        replaceParams = {};
                        if(stat != StatData.HP_STAT && stat != StatData.MP_STAT) {
                            val = TextKey.PERMANENTLY_INCREASES;
                            replaceParams["statName"] = new LineBuilder().setParams(StatData.statToName(stat));
                            this.effects.push(new Effect(val,replaceParams).setColor(16777103));
                        } else {
                            val = TextKey.BLANK;
                            alb = new AppendingLineBuilder().setDelimiter(" ");
                            alb.pushParams(TextKey.BLANK,{"data":new StaticStringBuilder("+" + amt)});
                            alb.pushParams(StatData.statToName(stat));
                            replaceParams["data"] = alb;
                            this.effects.push(new Effect(val,replaceParams));
                        }
                        continue;
                    default:
                        continue;
                }
            }
        }
        
        private function getSkull(param1:XML, param2:XML = null) : void {
            var _local_18:Number = NaN;
            var _local_3:int = this.player != null?int(this.player.wisdom_):10;
            var _local_4:int = this.GetIntArgument(param1,"wisPerRad",10);
            var _local_5:Number = this.GetFloatArgument(param1,"incrRad",0.5);
            var _local_6:int = this.GetIntArgument(param1,"wisDamageBase",0);
            var _local_7:int = this.GetIntArgument(param1,"wisMin",50);
            var _local_8:int = Math.max(0,_local_3 - _local_7);
            var _local_9:int = _local_6 / 10 * _local_8;
            var _local_10:Number = MathUtil.round(int(_local_8 / _local_4) * _local_5,2);
            var _local_11:ComPair = new ComPair(param1,param2,"totalDamage");
            _local_11.add(_local_9);
            var _local_12:ComPair = new ComPair(param1,param2,"radius");
            var _local_13:ComPair = new ComPair(param1,param2,"healRange",5);
            _local_13.add(_local_10);
            var _local_14:ComPair = new ComPair(param1,param2,"heal");
            var _local_15:ComPair = new ComPair(param1,param2,"ignoreDef",0);
            var _local_16:* = this.colorUntiered("Skull: ");
            _local_16 = _local_16 + ("{damage}" + this.colorWisBonus(_local_9) + " damage\n");
            _local_16 = _local_16 + "within {radius} squares\n";
            _local_16 = _local_16 + "Steals {heal} HP";
            if(_local_15.a) {
                _local_16 = _local_16 + " and ignores {ignoreDef} defense";
            }
            _local_16 = _local_16 + ("\nHeals allies within {healRange}" + this.colorWisBonus(_local_10) + " squares");
            this.effects.push(new Effect(_local_16,{
                "damage":TooltipHelper.compare(_local_11.a,_local_11.b),
                "radius":TooltipHelper.compare(_local_12.a,_local_12.b),
                "heal":TooltipHelper.compare(_local_14.a,_local_14.b),
                "ignoreDef":TooltipHelper.compare(_local_15.a,_local_15.b),
                "healRange":TooltipHelper.compare(MathUtil.round(_local_13.a,2),MathUtil.round(_local_13.b,2))
            }));
            var _local_17:String = param1.@condEffect;
            if(_local_17) {
                _local_18 = this.GetFloatArgument(param1,"condDuration",2.5);
                this.effects.push(new Effect("{condition} for {duration} ",{
                    "condition":_local_17,
                    "duration":TooltipHelper.getPlural(_local_18,"second")
                }));
            }
        }
        
        private function getTrap(param1:XML, param2:XML = null) : void {
            var _local_12:ComPair = null;
            var _local_13:String = null;
            var _local_3:ComPair = new ComPair(param1,param2,"totalDamage");
            var _local_4:ComPair = new ComPair(param1,param2,"radius");
            var _local_5:ComPair = new ComPair(param1,param2,"duration",20);
            var _local_6:ComPair = new ComPair(param1,param2,"tilArmed",1);
            var _local_7:ComPair = new ComPair(param1,param2,"sensitivity",0.5);
            var _local_8:Number = MathUtil.round(_local_4.a * _local_7.a,2);
            var _local_9:Number = MathUtil.round(_local_4.b * _local_7.b,2);
            var _local_10:* = this.colorUntiered("Trap: ");
            _local_10 = _local_10 + "{damage} damage within {radius} squares";
            this.effects.push(new Effect(_local_10,{
                "damage":TooltipHelper.compare(_local_3.a,_local_3.b),
                "radius":TooltipHelper.compare(_local_4.a,_local_4.b)
            }));
            var _local_11:String = !!param1.hasOwnProperty("@condEffect")?param1.@condEffect:"Slowed";
            if(_local_11 != "Nothing") {
                _local_12 = new ComPair(param1,param2,"condDuration",5);
                if(param2) {
                    _local_13 = !!param2.hasOwnProperty("@condEffect")?param2.@condEffect:"Slowed";
                    if(_local_13 == "Nothing") {
                        _local_12.b = 0;
                    }
                }
                this.effects.push(new Effect("Inflicts {condition} for {duration} ",{
                    "condition":_local_11,
                    "duration":TooltipHelper.compareAndGetPlural(_local_12.a,_local_12.b,"second")
                }));
            }
            this.effects.push(new Effect("{tilArmed} to arm for {duration} ",{
                "tilArmed":TooltipHelper.compareAndGetPlural(_local_6.a,_local_6.b,"second",false),
                "duration":TooltipHelper.compareAndGetPlural(_local_5.a,_local_5.b,"second")
            }));
            this.effects.push(new Effect("Triggers within {triggerRadius} squares",{"triggerRadius":TooltipHelper.compare(_local_8,_local_9)}));
        }
        
        private function getLightning(param1:XML, param2:XML = null) : void {
            var _local_15:Number = NaN;
            var _local_3:int = this.player != null?int(this.player.wisdom_):10;
            var _local_4:ComPair = new ComPair(param1,param2,"decrDamage",0);
            var _local_5:int = this.GetIntArgument(param1,"wisPerTarget",10);
            var _local_6:int = this.GetIntArgument(param1,"wisDamageBase",_local_4.a);
            var _local_7:int = this.GetIntArgument(param1,"wisMin",50);
            var _local_8:int = Math.max(0,_local_3 - _local_7);
            var _local_9:int = _local_8 / _local_5;
            var _local_10:int = _local_6 / 10 * _local_8;
            var _local_11:ComPair = new ComPair(param1,param2,"maxTargets");
            _local_11.add(_local_9);
            var _local_12:ComPair = new ComPair(param1,param2,"totalDamage");
            _local_12.add(_local_10);
            var _local_13:* = this.colorUntiered("Lightning: ");
            _local_13 = _local_13 + ("{targets}" + this.colorWisBonus(_local_9) + " targets\n");
            _local_13 = _local_13 + ("{damage}" + this.colorWisBonus(_local_10) + " damage");
            if(_local_4.a) {
                _local_13 = _local_13 + ", reduced by \n{decrDamage} for each subsequent target";
            }
            this.effects.push(new Effect(_local_13,{
                "targets":TooltipHelper.compare(_local_11.a,_local_11.b),
                "damage":TooltipHelper.compare(_local_12.a,_local_12.b),
                "decrDamage":TooltipHelper.compare(_local_4.a,_local_4.b,false)
            }));
            var _local_14:String = param1.@condEffect;
            if(_local_14) {
                _local_15 = this.GetFloatArgument(param1,"condDuration",5);
                this.effects.push(new Effect("{condition} for {duration} ",{
                    "condition":_local_14,
                    "duration":TooltipHelper.getPlural(_local_15,"second")
                }));
            }
        }
        
        private function GetIntArgument(param1:XML, param2:String, param3:int = 0) : int {
            return !!param1.hasOwnProperty("@" + param2)?int(param1[param2]):int(param3);
        }
        
        private function GetFloatArgument(param1:XML, param2:String, param3:Number = 0) : Number {
            return !!param1.hasOwnProperty("@" + param2)?Number(param1[param2]):Number(param3);
        }
        
        private function GetStringArgument(param1:XML, param2:String, param3:String = "") : String {
            return !!param1.hasOwnProperty("@" + param2)?param1[param2]:param3;
        }
        
        private function colorWisBonus(param1:Number) : String {
            if(param1) {
                return TooltipHelper.wrapInFontTag(" (+" + param1 + ")","#" + TooltipHelper.WIS_BONUS_COLOR.toString(16));
            }
            return "";
        }
        
        private function colorUntiered(param1:String) : String {
            var _local_2:Boolean = this.objectXML.hasOwnProperty("Tier");
            var _local_3:Boolean = this.objectXML.hasOwnProperty("@setType");
            if(_local_3) {
                return TooltipHelper.wrapInFontTag(param1,"#" + TooltipHelper.SET_COLOR.toString(16));
            }
            if(!_local_2) {
                return TooltipHelper.wrapInFontTag(param1,"#" + TooltipHelper.UNTIERED_COLOR.toString(16));
            }
            return param1;
        }
        
        private function getEffectTag(param1:XML, param2:String) : XML {
            var matches:XMLList = null;
            var tag:XML = null;
            var xml:XML = param1;
            var effectValue:String = param2;
            matches = xml.Activate.(text() == ActivationType.GENERIC_ACTIVATE);
            for each(tag in matches) {
                if(tag.@effect == effectValue) {
                    return tag;
                }
            }
            return null;
        }
        
        private function getStatTag(param1:XML, param2:String) : XML {
            var matches:XMLList = null;
            var tag:XML = null;
            var xml:XML = param1;
            var statValue:String = param2;
            matches = xml.Activate.(text() == ActivationType.STAT_BOOST_AURA);
            for each(tag in matches) {
                if(tag.@stat == statValue) {
                    return tag;
                }
            }
            return null;
        }
        
        private function addActivateOnEquipTagsToEffectsList() : void {
            var _local_1:XML = null;
            var _local_2:Boolean = true;
            for each(_local_1 in this.objectXML.ActivateOnEquip) {
                if(_local_2) {
                    this.effects.push(new Effect(TextKey.ON_EQUIP,""));
                    _local_2 = false;
                }
                if(_local_1.toString() == "IncrementStat") {
                    this.effects.push(new Effect(TextKey.INCREMENT_STAT,this.getComparedStatText(_local_1)).setReplacementsColor(this.getComparedStatColor(_local_1)));
                }
            }
        }
        
        private function getComparedStatText(param1:XML) : Object {
            var _local_2:int = int(param1.@stat);
            var _local_3:int = int(param1.@amount);
            var _local_4:String = _local_3 > -1?"+":"";
            return {
                "statAmount":_local_4 + String(_local_3) + " ",
                "statName":new LineBuilder().setParams(StatData.statToName(_local_2))
            };
        }
        
        private function getComparedStatColor(param1:XML) : uint {
            var match:XML = null;
            var otherAmount:int = 0;
            var activateXML:XML = param1;
            var stat:int = int(activateXML.@stat);
            var amount:int = int(activateXML.@amount);
            var textColor:uint = !!this.playerCanUse?uint(TooltipHelper.BETTER_COLOR):uint(TooltipHelper.NO_DIFF_COLOR);
            var otherMatches:XMLList = null;
            if(this.curItemXML != null) {
                otherMatches = this.curItemXML.ActivateOnEquip.(@stat == stat);
            }
            if(otherMatches != null && otherMatches.length() == 1) {
                match = XML(otherMatches[0]);
                otherAmount = int(match.@amount);
                textColor = TooltipHelper.getTextColor(amount - otherAmount);
            }
            if(amount < 0) {
                textColor = 16711680;
            }
            return textColor;
        }
        
        private function addEquipmentItemRestrictions() : void {
            if(this.objectXML.hasOwnProperty("Treasure") == false) {
                this.restrictions.push(new Restriction(TextKey.EQUIP_TO_USE,11776947,false));
                if(this.isInventoryFull || this.inventoryOwnerType == InventoryOwnerTypes.CURRENT_PLAYER) {
                    this.restrictions.push(new Restriction(TextKey.DOUBLE_CLICK_EQUIP,11776947,false));
                } else {
                    this.restrictions.push(new Restriction(TextKey.DOUBLE_CLICK_TAKE,11776947,false));
                }
            }
        }
        
        private function addAbilityItemRestrictions() : void {
            this.restrictions.push(new Restriction(TextKey.KEYCODE_TO_USE,16777215,false));
        }
        
        private function addConsumableItemRestrictions() : void {
            this.restrictions.push(new Restriction(TextKey.CONSUMED_WITH_USE,11776947,false));
            if(this.isInventoryFull || this.inventoryOwnerType == InventoryOwnerTypes.CURRENT_PLAYER) {
                this.restrictions.push(new Restriction(TextKey.DOUBLE_CLICK_OR_SHIFT_CLICK_TO_USE,16777215,false));
            } else {
                this.restrictions.push(new Restriction(TextKey.DOUBLE_CLICK_TAKE_SHIFT_CLICK_USE,16777215,false));
            }
        }
        
        private function addReusableItemRestrictions() : void {
            this.restrictions.push(new Restriction(TextKey.CAN_BE_USED_MULTIPLE_TIMES,11776947,false));
            this.restrictions.push(new Restriction(TextKey.DOUBLE_CLICK_OR_SHIFT_CLICK_TO_USE,16777215,false));
        }
        
        private function makeRestrictionList() : void {
            var _local_2:XML = null;
            var _local_3:Boolean = false;
            var _local_4:int = 0;
            var _local_5:int = 0;
            this.restrictions = new Vector.<Restriction>();
            if(this.objectXML.hasOwnProperty("VaultItem") && this.invType != -1 && this.invType != ObjectLibrary.idToType_["Vault Chest"]) {
                this.restrictions.push(new Restriction(TextKey.STORE_IN_VAULT,16549442,true));
            }
            if(this.objectXML.hasOwnProperty("Soulbound")) {
                this.restrictions.push(new Restriction(TextKey.ITEM_SOULBOUND,11776947,false));
            }
            if(this.playerCanUse) {
                if(this.objectXML.hasOwnProperty("Usable")) {
                    this.addAbilityItemRestrictions();
                    this.addEquipmentItemRestrictions();
                } else if(this.objectXML.hasOwnProperty("Consumable")) {
                    this.addConsumableItemRestrictions();
                } else if(this.objectXML.hasOwnProperty("InvUse")) {
                    this.addReusableItemRestrictions();
                } else {
                    this.addEquipmentItemRestrictions();
                }
            } else if(this.player != null) {
                this.restrictions.push(new Restriction(TextKey.NOT_USABLE_BY,16549442,true));
            }
            var _local_1:Vector.<String> = ObjectLibrary.usableBy(this.objectType);
            if(_local_1 != null) {
                this.restrictions.push(new Restriction(TextKey.USABLE_BY,11776947,false));
            }
            for each(_local_2 in this.objectXML.EquipRequirement) {
                _local_3 = ObjectLibrary.playerMeetsRequirement(_local_2,this.player);
                if(_local_2.toString() == "Stat") {
                    _local_4 = int(_local_2.@stat);
                    _local_5 = int(_local_2.@value);
                    this.restrictions.push(new Restriction("Requires " + StatData.statToName(_local_4) + " of " + _local_5,!!_local_3?uint(11776947):uint(16549442),!!_local_3?false:true));
                }
            }
        }
        
        private function makeLineTwo() : void {
            this.line2 = new LineBreakDesign(MAX_WIDTH - 12,0);
            addChild(this.line2);
        }
        
        private function makeLineThree() : void {
            this.line3 = new LineBreakDesign(MAX_WIDTH - 12,0);
            addChild(this.line3);
        }
        
        private function makeRestrictionText() : void {
            if(this.restrictions.length != 0) {
                this.restrictionsText = new TextFieldDisplayConcrete().setSize(14).setColor(11776947).setTextWidth(MAX_WIDTH - 4).setIndent(-10).setLeftMargin(10).setWordWrap(true).setHTML(true);
                this.restrictionsText.setStringBuilder(this.buildRestrictionsLineBuilder());
                this.restrictionsText.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
                waiter.push(this.restrictionsText.textChanged);
                addChild(this.restrictionsText);
            }
        }
        
        private function makeSetInfoText() : void {
            if(this.setInfo.length != 0) {
                this.setInfoText = new TextFieldDisplayConcrete().setSize(14).setColor(11776947).setTextWidth(MAX_WIDTH - 4).setIndent(-10).setLeftMargin(10).setWordWrap(true).setHTML(true);
                this.setInfoText.setStringBuilder(this.getSetBonusStringBuilder());
                this.setInfoText.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
                waiter.push(this.setInfoText.textChanged);
                addChild(this.setInfoText);
                this.makeLineThree();
            }
        }
        
        private function getSetBonusStringBuilder() : AppendingLineBuilder {
            var _local_1:AppendingLineBuilder = new AppendingLineBuilder();
            this.appendEffects(this.setInfo,_local_1);
            return _local_1;
        }
        
        private function buildRestrictionsLineBuilder() : StringBuilder {
            var _local_2:Restriction = null;
            var _local_3:String = null;
            var _local_4:String = null;
            var _local_5:String = null;
            var _local_1:AppendingLineBuilder = new AppendingLineBuilder();
            for each(_local_2 in this.restrictions) {
                _local_3 = !!_local_2.bold_?"<b>":"";
                _local_3 = _local_3.concat("<font color=\"#" + _local_2.color_.toString(16) + "\">");
                _local_4 = "</font>";
                _local_4 = _local_4.concat(!!_local_2.bold_?"</b>":"");
                _local_5 = !!this.player?ObjectLibrary.typeToDisplayId_[this.player.objectType_]:"";
                _local_1.pushParams(_local_2.text_,{
                    "unUsableClass":_local_5,
                    "usableClasses":this.getUsableClasses(),
                    "keyCode":KeyCodes.CharCodeStrings[Parameters.data_.useSpecial]
                },_local_3,_local_4);
            }
            return _local_1;
        }
        
        private function getUsableClasses() : StringBuilder {
            var _local_3:String = null;
            var _local_1:Vector.<String> = ObjectLibrary.usableBy(this.objectType);
            var _local_2:AppendingLineBuilder = new AppendingLineBuilder();
            _local_2.setDelimiter(", ");
            for each(_local_3 in _local_1) {
                _local_2.pushParams(_local_3);
            }
            return _local_2;
        }
        
        private function addDescriptionText() : void {
            this.descText = new TextFieldDisplayConcrete().setSize(14).setColor(11776947).setTextWidth(MAX_WIDTH).setWordWrap(true);
            if(this.descriptionOverride) {
                this.descText.setStringBuilder(new StaticStringBuilder(this.descriptionOverride));
            } else {
                this.descText.setStringBuilder(new LineBuilder().setParams(String(this.objectXML.Description)));
            }
            this.descText.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
            waiter.push(this.descText.textChanged);
            addChild(this.descText);
        }
        
        override protected function alignUI() : void {
            this.titleText.x = this.icon.width + 4;
            this.titleText.y = this.icon.height / 2 - this.titleText.height / 2;
            if(this.tierText) {
                this.tierText.y = this.icon.height / 2 - this.tierText.height / 2;
                this.tierText.x = MAX_WIDTH - 30;
            }
            this.descText.x = 4;
            this.descText.y = this.icon.height + 2;
            if(contains(this.line1)) {
                this.line1.x = 8;
                this.line1.y = this.descText.y + this.descText.height + 8;
                this.effectsText.x = 4;
                this.effectsText.y = this.line1.y + 8;
            } else {
                this.line1.y = this.descText.y + this.descText.height;
                this.effectsText.y = this.line1.y;
            }
            if(this.setInfoText) {
                this.line3.x = 8;
                this.line3.y = this.effectsText.y + this.effectsText.height + 8;
                this.setInfoText.x = 4;
                this.setInfoText.y = this.line3.y + 8;
                this.line2.x = 8;
                this.line2.y = this.setInfoText.y + this.setInfoText.height + 8;
            } else {
                this.line2.x = 8;
                this.line2.y = this.effectsText.y + this.effectsText.height + 8;
            }
            var _local_1:uint = this.line2.y + 8;
            if(this.restrictionsText) {
                this.restrictionsText.x = 4;
                this.restrictionsText.y = _local_1;
                _local_1 = _local_1 + this.restrictionsText.height;
            }
            if(this.powerText) {
                if(contains(this.powerText)) {
                    this.powerText.x = 4;
                    this.powerText.y = _local_1;
                }
            }
        }
        
        private function buildCategorySpecificText() : void {
            if(this.curItemXML != null) {
                this.comparisonResults = this.slotTypeToTextBuilder.getComparisonResults(this.objectXML,this.curItemXML);
            } else {
                this.comparisonResults = new SlotComparisonResult();
            }
        }
        
        private function handleWisMod() : void {
            var _local_3:XML = null;
            var _local_4:XML = null;
            var _local_5:String = null;
            var _local_6:String = null;
            if(this.player == null) {
                return;
            }
            var _local_1:Number = this.player.wisdom_ + this.player.wisdomBoost_;
            if(_local_1 < 30) {
                return;
            }
            var _local_2:Vector.<XML> = new Vector.<XML>();
            if(this.curItemXML != null) {
                this.curItemXML = this.curItemXML.copy();
                _local_2.push(this.curItemXML);
            }
            if(this.objectXML != null) {
                this.objectXML = this.objectXML.copy();
                _local_2.push(this.objectXML);
            }
            for each(_local_4 in _local_2) {
                for each(_local_3 in _local_4.Activate) {
                    _local_5 = _local_3.toString();
                    if(_local_3.@effect == "Stasis") {
                        continue;
                    }
                    _local_6 = _local_3.@useWisMod;
                    if(_local_6 == "" || _local_6 == "false" || _local_6 == "0" || _local_3.@effect == "Stasis") {
                        continue;
                    }
                    switch(_local_5) {
                        case ActivationType.HEAL_NOVA:
                            _local_3.@amount = this.modifyWisModStat(_local_3.@amount,0);
                            _local_3.@range = this.modifyWisModStat(_local_3.@range);
                            continue;
                        case ActivationType.COND_EFFECT_AURA:
                            _local_3.@duration = this.modifyWisModStat(_local_3.@duration);
                            _local_3.@range = this.modifyWisModStat(_local_3.@range);
                            continue;
                        case ActivationType.COND_EFFECT_SELF:
                            _local_3.@duration = this.modifyWisModStat(_local_3.@duration);
                            continue;
                        case ActivationType.STAT_BOOST_AURA:
                            _local_3.@amount = this.modifyWisModStat(_local_3.@amount,0);
                            _local_3.@duration = this.modifyWisModStat(_local_3.@duration);
                            _local_3.@range = this.modifyWisModStat(_local_3.@range);
                            continue;
                        case ActivationType.GENERIC_ACTIVATE:
                            _local_3.@duration = this.modifyWisModStat(_local_3.@duration);
                            _local_3.@range = this.modifyWisModStat(_local_3.@range);
                            continue;
                        default:
                            continue;
                    }
                }
            }
        }
        
        private function modifyWisModStat(param1:String, param2:Number = 1) : String {
            var _local_5:Number = NaN;
            var _local_6:int = 0;
            var _local_7:Number = NaN;
            var _local_3:String = "-1";
            var _local_4:Number = this.player.wisdom_ + this.player.wisdomBoost_;
            if(_local_4 < 30) {
                _local_3 = param1;
            } else {
                _local_5 = Number(param1);
                _local_6 = _local_5 < 0?-1:1;
                _local_7 = _local_5 * _local_4 / 150 + _local_5 * _local_6;
                _local_7 = Math.floor(_local_7 * Math.pow(10,param2)) / Math.pow(10,param2);
                if(_local_7 - int(_local_7) * _local_6 >= 1 / Math.pow(10,param2) * _local_6) {
                    _local_3 = _local_7.toFixed(1);
                } else {
                    _local_3 = _local_7.toFixed(0);
                }
            }
            return _local_3;
        }
    }
}

class ComPair {
     
    
    public var a:Number;
    
    public var b:Number;
    
    function ComPair(param1:XML, param2:XML, param3:String, param4:Number = 0) {
        super();
        this.a = this.b = !!param1.hasOwnProperty("@" + param3)?Number(param1[param3]):Number(param4);
        if(param2) {
            this.b = !!param2.hasOwnProperty("@" + param3)?Number(param2[param3]):Number(param4);
        }
    }
    
    public function add(param1:Number) : void {
        this.a = this.a + param1;
        this.b = this.b + param1;
    }
}

import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

class Effect {
     
    
    public var name_:String;
    
    public var valueReplacements_:Object;
    
    public var replacementColor_:uint = 16777103;
    
    public var color_:uint = 11776947;
    
    function Effect(param1:String, param2:Object) {
        super();
        this.name_ = param1;
        this.valueReplacements_ = param2;
    }
    
    public function setColor(param1:uint) : Effect {
        this.color_ = param1;
        return this;
    }
    
    public function setReplacementsColor(param1:uint) : Effect {
        this.replacementColor_ = param1;
        return this;
    }
    
    public function getValueReplacementsWithColor() : Object {
        var _local_4:* = null;
        var _local_5:LineBuilder = null;
        var _local_1:Object = {};
        var _local_2:* = "";
        var _local_3:* = "";
        if(this.replacementColor_) {
            _local_2 = "</font><font color=\"#" + this.replacementColor_.toString(16) + "\">";
            _local_3 = "</font><font color=\"#" + this.color_.toString(16) + "\">";
        }
        for(_local_4 in this.valueReplacements_) {
            if(this.valueReplacements_[_local_4] is AppendingLineBuilder) {
                _local_1[_local_4] = this.valueReplacements_[_local_4];
            } else if(this.valueReplacements_[_local_4] is LineBuilder) {
                _local_5 = this.valueReplacements_[_local_4] as LineBuilder;
                _local_5.setPrefix(_local_2).setPostfix(_local_3);
                _local_1[_local_4] = _local_5;
            } else {
                _local_1[_local_4] = _local_2 + this.valueReplacements_[_local_4] + _local_3;
            }
        }
        return _local_1;
    }
}

class Restriction {
     
    
    public var text_:String;
    
    public var color_:uint;
    
    public var bold_:Boolean;
    
    function Restriction(param1:String, param2:uint, param3:Boolean) {
        super();
        this.text_ = param1;
        this.color_ = param2;
        this.bold_ = param3;
    }
}
