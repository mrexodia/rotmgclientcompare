package com.company.assembleegameclient.objects {
    import com.company.assembleegameclient.map.Camera;
    import com.company.assembleegameclient.map.Square#61;
    import com.company.assembleegameclient.map.mapoverlay.CharacterStatusText;
    import com.company.assembleegameclient.objects.particles.HealingEffect;
    import com.company.assembleegameclient.objects.particles.LevelUpEffect;
    import com.company.assembleegameclient.parameters.Parameters;
    import com.company.assembleegameclient.sound.SoundEffectLibrary;
    import com.company.assembleegameclient.tutorial.Tutorial;
    import com.company.assembleegameclient.tutorial.doneAction;
    import com.company.assembleegameclient.util.AnimatedChar;
    import com.company.assembleegameclient.util.ConditionEffect;
    import com.company.assembleegameclient.util.FameUtil;
    import com.company.assembleegameclient.util.FreeList;
    import com.company.assembleegameclient.util.MaskedImage;
    import com.company.assembleegameclient.util.TextureRedrawer;
    import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
    import com.company.util.CachingColorTransformer;
    import com.company.util.ConversionUtil;
    import com.company.util.GraphicsUtil;
    import com.company.util.IntPoint;
    import com.company.util.MoreColorUtil;
    import com.company.util.PointUtil;
    import com.company.util.Trig;
    import flash.display.BitmapData;
    import flash.display.GraphicsPath;
    import flash.display.GraphicsSolidFill;
    import flash.display.IGraphicsData;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Vector3D;
    import flash.utils.Dictionary;
    import flash.utils.getTimer;
    import kabam.rotmg.assets.services.CharacterFactory;
    import kabam.rotmg.chat.model.ChatMessage;
    import kabam.rotmg.constants.ActivationType;
    import kabam.rotmg.constants.GeneralConstants;
    import kabam.rotmg.constants.UseType;
    import kabam.rotmg.core.StaticInjectorContext;
    import kabam.rotmg.game.model.PotionInventoryModel;
    import kabam.rotmg.game.signals.AddTextLineSignal;
    import kabam.rotmg.game.view.components.QueuedStatusText;
    import kabam.rotmg.messaging.impl.data.StatData;
    import kabam.rotmg.stage3D.GraphicsFillExtra;
    import kabam.rotmg.text.model.TextKey;
    import kabam.rotmg.text.view.BitmapTextFactory;
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
    import kabam.rotmg.text.view.stringBuilder.StringBuilder;
    import kabam.rotmg.ui.model.TabStripModel;
    import org.swiftsuspenders.Injector;
    
    public class Player extends Character {
        
        public static const MS_BETWEEN_TELEPORT:int = 10000;
        
        private static const MOVE_THRESHOLD:Number = 0.4;
        
        public static var isAdmin:Boolean = false;
        
        public static var isMod:Boolean = false;
        
        private static const NEARBY:Vector.<Point> = new <Point>[new Point(0,0),new Point(1,0),new Point(0,1),new Point(1,1)];
        
        private static var newP:Point = new Point();
        
        private static const RANK_OFFSET_MATRIX:Matrix = new Matrix(1,0,0,1,2,2);
        
        private static const NAME_OFFSET_MATRIX:Matrix = new Matrix(1,0,0,1,20,1);
        
        private static const MIN_MOVE_SPEED:Number = 0.004;
        
        private static const MAX_MOVE_SPEED:Number = 0.0096;
        
        private static const MIN_ATTACK_FREQ:Number = 0.0015;
        
        private static const MAX_ATTACK_FREQ:Number = 0.008;
        
        private static const MIN_ATTACK_MULT:Number = 0.5;
        
        private static const MAX_ATTACK_MULT:Number = 2;
         
        
        public var xpTimer:int;
        
        public var skinId:int;
        
        public var skin:AnimatedChar;
        
        public var isShooting:Boolean;
        
        public var accountId_:String = "";
        
        public var credits_:int = 0;
        
        public var tokens_:int = 0;
        
        public var numStars_:int = 0;
        
        public var fame_:int = 0;
        
        public var nameChosen_:Boolean = false;
        
        public var currFame_:int = 0;
        
        public var nextClassQuestFame_:int = -1;
        
        public var legendaryRank_:int = -1;
        
        public var guildName_:String = null;
        
        public var guildRank_:int = -1;
        
        public var isFellowGuild_:Boolean = false;
        
        public var breath_:int = -1;
        
        public var maxMP_:int = 200;
        
        public var mp_:Number = 0;
        
        public var nextLevelExp_:int = 1000;
        
        public var exp_:int = 0;
        
        public var attack_:int = 0;
        
        public var speed_:int = 0;
        
        public var dexterity_:int = 0;
        
        public var vitality_:int = 0;
        
        public var wisdom_:int = 0;
        
        public var maxHPBoost_:int = 0;
        
        public var maxMPBoost_:int = 0;
        
        public var attackBoost_:int = 0;
        
        public var defenseBoost_:int = 0;
        
        public var speedBoost_:int = 0;
        
        public var vitalityBoost_:int = 0;
        
        public var wisdomBoost_:int = 0;
        
        public var dexterityBoost_:int = 0;
        
        public var xpBoost_:int = 0;
        
        public var healthPotionCount_:int = 0;
        
        public var magicPotionCount_:int = 0;
        
        public var attackMax_:int = 0;
        
        public var defenseMax_:int = 0;
        
        public var speedMax_:int = 0;
        
        public var dexterityMax_:int = 0;
        
        public var vitalityMax_:int = 0;
        
        public var wisdomMax_:int = 0;
        
        public var maxHPMax_:int = 0;
        
        public var maxMPMax_:int = 0;
        
        public var hasBackpack_:Boolean = false;
        
        public var starred_:Boolean = false;
        
        public var ignored_:Boolean = false;
        
        public var distSqFromThisPlayer_:Number = 0;
        
        protected var rotate_:Number = 0;
        
        protected var relMoveVec_:Point = null;
        
        protected var moveMultiplier_:Number = 1;
        
        public var attackPeriod_:int = 0;
        
        public var nextAltAttack_:int = 0;
        
        public var nextTeleportAt_:int = 0;
        
        public var dropBoost:int = 0;
        
        public var tierBoost:int = 0;
        
        protected var healingEffect_:HealingEffect = null;
        
        protected var nearestMerchant_:Merchant = null;
        
        public var isDefaultAnimatedChar:Boolean = true;
        
        public var projectileIdSetOverrideNew:String = "";
        
        public var projectileIdSetOverrideOld:String = "";
        
        private var addTextLine:AddTextLineSignal;
        
        private var factory:CharacterFactory;
        
        private var ip_:IntPoint;
        
        private var breathBackFill_:GraphicsSolidFill = null;
        
        private var breathBackPath_:GraphicsPath = null;
        
        private var breathFill_:GraphicsSolidFill = null;
        
        private var breathPath_:GraphicsPath = null;
        
        public function Player(param1:XML) {
            this.ip_ = new IntPoint();
            var _local_2:Injector = StaticInjectorContext.getInjector();
            this.addTextLine = _local_2.getInstance(AddTextLineSignal);
            this.factory = _local_2.getInstance(CharacterFactory);
            super(param1);
            this.attackMax_ = int(param1.Attack.@max);
            this.defenseMax_ = int(param1.Defense.@max);
            this.speedMax_ = int(param1.Speed.@max);
            this.dexterityMax_ = int(param1.Dexterity.@max);
            this.vitalityMax_ = int(param1.HpRegen.@max);
            this.wisdomMax_ = int(param1.MpRegen.@max);
            this.maxHPMax_ = int(param1.MaxHitPoints.@max);
            this.maxMPMax_ = int(param1.MaxMagicPoints.@max);
            texturingCache_ = new Dictionary();
        }
        
        public static function fromPlayerXML(param1:String, param2:XML) : Player {
            var _local_3:int = int(param2.ObjectType);
            var _local_4:XML = ObjectLibrary.xmlLibrary_[_local_3];
            var _local_5:Player = new Player(_local_4);
            _local_5.name_ = param1;
            _local_5.level_ = int(param2.Level);
            _local_5.exp_ = int(param2.Exp);
            _local_5.equipment_ = ConversionUtil.toIntVector(param2.Equipment);
            _local_5.calculateStatBoosts();
            _local_5.lockedSlot = new Vector.<int>(_local_5.equipment_.length);
            _local_5.maxHP_ = _local_5.maxHPBoost_ + int(param2.MaxHitPoints);
            _local_5.hp_ = int(param2.HitPoints);
            _local_5.maxMP_ = _local_5.maxMPBoost_ + int(param2.MaxMagicPoints);
            _local_5.mp_ = int(param2.MagicPoints);
            _local_5.attack_ = _local_5.attackBoost_ + int(param2.Attack);
            _local_5.defense_ = _local_5.defenseBoost_ + int(param2.Defense);
            _local_5.speed_ = _local_5.speedBoost_ + int(param2.Speed);
            _local_5.dexterity_ = _local_5.dexterityBoost_ + int(param2.Dexterity);
            _local_5.vitality_ = _local_5.vitalityBoost_ + int(param2.HpRegen);
            _local_5.wisdom_ = _local_5.wisdomBoost_ + int(param2.MpRegen);
            _local_5.tex1Id_ = int(param2.Tex1);
            _local_5.tex2Id_ = int(param2.Tex2);
            _local_5.hasBackpack_ = int(param2.HasBackpack);
            return _local_5;
        }
        
        public function calculateStatBoosts() : void {
            var _local_2:int = 0;
            var _local_3:XML = null;
            var _local_4:XML = null;
            var _local_5:int = 0;
            var _local_6:int = 0;
            this.maxHPBoost_ = 0;
            this.maxMPBoost_ = 0;
            this.attackBoost_ = 0;
            this.defenseBoost_ = 0;
            this.speedBoost_ = 0;
            this.vitalityBoost_ = 0;
            this.wisdomBoost_ = 0;
            this.dexterityBoost_ = 0;
            var _local_1:uint = 0;
            while(_local_1 < GeneralConstants.NUM_EQUIPMENT_SLOTS) {
                if(equipment_ && equipment_.length > _local_1) {
                    _local_2 = equipment_[_local_1];
                    if(_local_2 != -1) {
                        _local_3 = ObjectLibrary.xmlLibrary_[_local_2];
                        if(_local_3 != null && _local_3.hasOwnProperty("ActivateOnEquip")) {
                            for each(_local_4 in _local_3.ActivateOnEquip) {
                                if(_local_4.toString() == "IncrementStat") {
                                    _local_5 = int(_local_4.@stat);
                                    _local_6 = int(_local_4.@amount);
                                    switch(_local_5) {
                                        case StatData.MAX_HP_STAT:
                                            this.maxHPBoost_ = this.maxHPBoost_ + _local_6;
                                            continue;
                                        case StatData.MAX_MP_STAT:
                                            this.maxMPBoost_ = this.maxMPBoost_ + _local_6;
                                            continue;
                                        case StatData.ATTACK_STAT:
                                            this.attackBoost_ = this.attackBoost_ + _local_6;
                                            continue;
                                        case StatData.DEFENSE_STAT:
                                            this.defenseBoost_ = this.defenseBoost_ + _local_6;
                                            continue;
                                        case StatData.SPEED_STAT:
                                            this.speedBoost_ = this.speedBoost_ + _local_6;
                                            continue;
                                        case StatData.VITALITY_STAT:
                                            this.vitalityBoost_ = this.vitalityBoost_ + _local_6;
                                            continue;
                                        case StatData.WISDOM_STAT:
                                            this.wisdomBoost_ = this.wisdomBoost_ + _local_6;
                                            continue;
                                        case StatData.DEXTERITY_STAT:
                                            this.dexterityBoost_ = this.dexterityBoost_ + _local_6;
                                            continue;
                                        default:
                                            continue;
                                    }
                                } else {
                                    continue;
                                }
                            }
                        }
                    }
                }
                _local_1++;
            }
        }
        
        public function setRelativeMovement(param1:Number, param2:Number, param3:Number) : void {
            var _local_4:Number = NaN;
            if(this.relMoveVec_ == null) {
                this.relMoveVec_ = new Point();
            }
            this.rotate_ = param1;
            this.relMoveVec_.x = param2;
            this.relMoveVec_.y = param3;
            if(isConfused()) {
                _local_4 = this.relMoveVec_.x;
                this.relMoveVec_.x = -this.relMoveVec_.y;
                this.relMoveVec_.y = -_local_4;
                this.rotate_ = -this.rotate_;
            }
        }
        
        public function setCredits(param1:int) : void {
            this.credits_ = param1;
        }
        
        public function setTokens(param1:int) : void {
            this.tokens_ = param1;
        }
        
        public function setGuildName(param1:String) : void {
            var _local_3:GameObject = null;
            var _local_4:Player = null;
            var _local_5:Boolean = false;
            this.guildName_ = param1;
            var _local_2:Player = map_.player_;
            if(_local_2 == this) {
                for each(_local_3 in map_.goDict_) {
                    _local_4 = _local_3 as Player;
                    if(_local_4 != null && _local_4 != this) {
                        _local_4.setGuildName(_local_4.guildName_);
                    }
                }
            } else {
                _local_5 = _local_2 != null && _local_2.guildName_ != null && _local_2.guildName_ != "" && _local_2.guildName_ == this.guildName_;
                if(_local_5 != this.isFellowGuild_) {
                    this.isFellowGuild_ = _local_5;
                    nameBitmapData_ = null;
                }
            }
        }
        
        public function isTeleportEligible(param1:Player) : Boolean {
            return !(param1.isPaused() || param1.isInvisible());
        }
        
        public function msUtilTeleport() : int {
            var _local_1:int = getTimer();
            return Math.max(0,this.nextTeleportAt_ - _local_1);
        }
        
        public function teleportTo(param1:Player) : Boolean {
            if(isPaused()) {
                this.addTextLine.dispatch(this.makeErrorMessage(TextKey.PLAYER_NOTELEPORTWHILEPAUSED));
                return false;
            }
            var _local_2:int = this.msUtilTeleport();
            if(_local_2 > 0) {
                this.addTextLine.dispatch(this.makeErrorMessage(TextKey.PLAYER_TELEPORT_COOLDOWN,{"seconds":int(_local_2 / 1000 + 1)}));
                return false;
            }
            if(!this.isTeleportEligible(param1)) {
                if(param1.isInvisible()) {
                    this.addTextLine.dispatch(this.makeErrorMessage(TextKey.TELEPORT_INVISIBLE_PLAYER,{"player":param1.name_}));
                } else {
                    this.addTextLine.dispatch(this.makeErrorMessage(TextKey.PLAYER_TELEPORT_TO_PLAYER,{"player":param1.name_}));
                }
                return false;
            }
            map_.gs_.gsc_.teleport(param1.objectId_);
            this.nextTeleportAt_ = getTimer() + MS_BETWEEN_TELEPORT;
            return true;
        }
        
        private function makeErrorMessage(param1:String, param2:Object = null) : ChatMessage {
            return ChatMessage.make(Parameters.ERROR_CHAT_NAME,param1,-1,-1,"",false,param2);
        }
        
        public function levelUpEffect(param1:String, param2:Boolean = true) : void {
            if(param2) {
                this.levelUpParticleEffect();
            }
            var _local_3:QueuedStatusText = new QueuedStatusText(this,new LineBuilder().setParams(param1),65280,2000);
            map_.mapOverlay_.addQueuedText(_local_3);
        }
        
        public function handleLevelUp(param1:Boolean) : void {
            SoundEffectLibrary.play("level_up");
            if(param1) {
                this.levelUpEffect(TextKey.PLAYER_NEWCLASSUNLOCKED,false);
                this.levelUpEffect(TextKey.PLAYER_LEVELUP);
            } else {
                this.levelUpEffect(TextKey.PLAYER_LEVELUP);
            }
        }
        
        public function levelUpParticleEffect(param1:uint = 4.27825536E9) : void {
            map_.addObj(new LevelUpEffect(this,param1,20),x_,y_);
        }
        
        public function handleExpUp(param1:int) : void {
            if(level_ == 20) {
                return;
            }
            var _local_2:CharacterStatusText = new CharacterStatusText(this,65280,1000);
            _local_2.setStringBuilder(new LineBuilder().setParams(TextKey.PLAYER_EXP,{"exp":param1}));
            map_.mapOverlay_.addStatusText(_local_2);
        }
        
        private function getNearbyMerchant() : Merchant {
            var _local_3:Point = null;
            var _local_4:Merchant = null;
            var _local_1:int = x_ - int(x_) > 0.5?1:-1;
            var _local_2:int = y_ - int(y_) > 0.5?1:-1;
            for each(_local_3 in NEARBY) {
                this.ip_.x_ = x_ + _local_1 * _local_3.x;
                this.ip_.y_ = y_ + _local_2 * _local_3.y;
                _local_4 = map_.merchLookup_[this.ip_];
                if(_local_4 != null) {
                    return PointUtil.distanceSquaredXY(_local_4.x_,_local_4.y_,x_,y_) < 1?_local_4:null;
                }
            }
            return null;
        }
        
        public function walkTo(param1:Number, param2:Number) : Boolean {
            this.modifyMove(param1,param2,newP);
            return this.moveTo(newP.x,newP.y);
        }
        
        override public function moveTo(param1:Number, param2:Number) : Boolean {
            var _local_3:Boolean = super.moveTo(param1,param2);
            if(map_.gs_.evalIsNotInCombatMapArea()) {
                this.nearestMerchant_ = this.getNearbyMerchant();
            }
            return _local_3;
        }
        
        public function modifyMove(param1:Number, param2:Number, param3:Point) : void {
            if(isParalyzed() || isPetrified()) {
                param3.x = x_;
                param3.y = y_;
                return;
            }
            var _local_4:Number = param1 - x_;
            var _local_5:Number = param2 - y_;
            if(_local_4 < MOVE_THRESHOLD && _local_4 > -MOVE_THRESHOLD && _local_5 < MOVE_THRESHOLD && _local_5 > -MOVE_THRESHOLD) {
                this.modifyStep(param1,param2,param3);
                return;
            }
            var _local_6:Number = MOVE_THRESHOLD / Math.max(Math.abs(_local_4),Math.abs(_local_5));
            var _local_7:Number = 0;
            param3.x = x_;
            param3.y = y_;
            var _local_8:Boolean = false;
            while(!_local_8) {
                if(_local_7 + _local_6 >= 1) {
                    _local_6 = 1 - _local_7;
                    _local_8 = true;
                }
                this.modifyStep(param3.x + _local_4 * _local_6,param3.y + _local_5 * _local_6,param3);
                _local_7 = _local_7 + _local_6;
            }
        }
        
        public function modifyStep(param1:Number, param2:Number, param3:Point) : void {
            var _local_6:Number = NaN;
            var _local_7:Number = NaN;
            var _local_4:Boolean = x_ % 0.5 == 0 && param1 != x_ || int(x_ / 0.5) != int(param1 / 0.5);
            var _local_5:Boolean = y_ % 0.5 == 0 && param2 != y_ || int(y_ / 0.5) != int(param2 / 0.5);
            if(!_local_4 && !_local_5 || this.isValidPosition(param1,param2)) {
                param3.x = param1;
                param3.y = param2;
                return;
            }
            if(_local_4) {
                _local_6 = param1 > x_?Number(int(param1 * 2) / 2):Number(int(x_ * 2) / 2);
                if(int(_local_6) > int(x_)) {
                    _local_6 = _local_6 - 0.01;
                }
            }
            if(_local_5) {
                _local_7 = param2 > y_?Number(int(param2 * 2) / 2):Number(int(y_ * 2) / 2);
                if(int(_local_7) > int(y_)) {
                    _local_7 = _local_7 - 0.01;
                }
            }
            if(!_local_4) {
                param3.x = param1;
                param3.y = _local_7;
                if(square_ != null && square_.props_.slideAmount_ != 0) {
                    this.resetMoveVector(false);
                }
                return;
            }
            if(!_local_5) {
                param3.x = _local_6;
                param3.y = param2;
                if(square_ != null && square_.props_.slideAmount_ != 0) {
                    this.resetMoveVector(true);
                }
                return;
            }
            var _local_8:Number = param1 > x_?Number(param1 - _local_6):Number(_local_6 - param1);
            var _local_9:Number = param2 > y_?Number(param2 - _local_7):Number(_local_7 - param2);
            if(_local_8 > _local_9) {
                if(this.isValidPosition(param1,_local_7)) {
                    param3.x = param1;
                    param3.y = _local_7;
                    return;
                }
                if(this.isValidPosition(_local_6,param2)) {
                    param3.x = _local_6;
                    param3.y = param2;
                    return;
                }
            } else {
                if(this.isValidPosition(_local_6,param2)) {
                    param3.x = _local_6;
                    param3.y = param2;
                    return;
                }
                if(this.isValidPosition(param1,_local_7)) {
                    param3.x = param1;
                    param3.y = _local_7;
                    return;
                }
            }
            param3.x = _local_6;
            param3.y = _local_7;
        }
        
        private function resetMoveVector(param1:Boolean) : void {
            moveVec_.scaleBy(-0.5);
            if(param1) {
                moveVec_.y = moveVec_.y * -1;
            } else {
                moveVec_.x = moveVec_.x * -1;
            }
        }
        
        public function isValidPosition(param1:Number, param2:Number) : Boolean {
            var _local_3:Square = map_.getSquare(param1,param2);
            if(square_ != _local_3 && (_local_3 == null || !_local_3.isWalkable())) {
                return false;
            }
            var _local_4:Number = param1 - int(param1);
            var _local_5:Number = param2 - int(param2);
            if(_local_4 < 0.5) {
                if(this.isFullOccupy(param1 - 1,param2)) {
                    return false;
                }
                if(_local_5 < 0.5) {
                    if(this.isFullOccupy(param1,param2 - 1) || this.isFullOccupy(param1 - 1,param2 - 1)) {
                        return false;
                    }
                } else if(_local_5 > 0.5) {
                    if(this.isFullOccupy(param1,param2 + 1) || this.isFullOccupy(param1 - 1,param2 + 1)) {
                        return false;
                    }
                }
            } else if(_local_4 > 0.5) {
                if(this.isFullOccupy(param1 + 1,param2)) {
                    return false;
                }
                if(_local_5 < 0.5) {
                    if(this.isFullOccupy(param1,param2 - 1) || this.isFullOccupy(param1 + 1,param2 - 1)) {
                        return false;
                    }
                } else if(_local_5 > 0.5) {
                    if(this.isFullOccupy(param1,param2 + 1) || this.isFullOccupy(param1 + 1,param2 + 1)) {
                        return false;
                    }
                }
            } else if(_local_5 < 0.5) {
                if(this.isFullOccupy(param1,param2 - 1)) {
                    return false;
                }
            } else if(_local_5 > 0.5) {
                if(this.isFullOccupy(param1,param2 + 1)) {
                    return false;
                }
            }
            return true;
        }
        
        public function isFullOccupy(param1:Number, param2:Number) : Boolean {
            var _local_3:Square = map_.lookupSquare(param1,param2);
            return _local_3 == null || _local_3.tileType_ == 255 || _local_3.obj_ != null && _local_3.obj_.props_.fullOccupy_;
        }
        
        override public function update(param1:int, param2:int) : Boolean {
            var _local_3:Number = NaN;
            var _local_4:Number = NaN;
            var _local_5:Number = NaN;
            var _local_6:Vector3D = null;
            var _local_7:Number = NaN;
            var _local_8:int = 0;
            var _local_9:Vector.<uint> = null;
            if(this.tierBoost && !isPaused()) {
                this.tierBoost = this.tierBoost - param2;
                if(this.tierBoost < 0) {
                    this.tierBoost = 0;
                }
            }
            if(this.dropBoost && !isPaused()) {
                this.dropBoost = this.dropBoost - param2;
                if(this.dropBoost < 0) {
                    this.dropBoost = 0;
                }
            }
            if(this.xpTimer && !isPaused()) {
                this.xpTimer = this.xpTimer - param2;
                if(this.xpTimer < 0) {
                    this.xpTimer = 0;
                }
            }
            if(isHealing() && !isPaused()) {
                if(this.healingEffect_ == null) {
                    this.healingEffect_ = new HealingEffect(this);
                    map_.addObj(this.healingEffect_,x_,y_);
                }
            } else if(this.healingEffect_ != null) {
                map_.removeObj(this.healingEffect_.objectId_);
                this.healingEffect_ = null;
            }
            if(map_.player_ == this && isPaused()) {
                return true;
            }
            if(this.relMoveVec_ != null) {
                _local_3 = Parameters.data_.cameraAngle;
                if(this.rotate_ != 0) {
                    _local_3 = _local_3 + param2 * Parameters.PLAYER_ROTATE_SPEED * this.rotate_;
                    Parameters.data_.cameraAngle = _local_3;
                }
                if(this.relMoveVec_.x != 0 || this.relMoveVec_.y != 0) {
                    _local_4 = this.getMoveSpeed();
                    _local_5 = Math.atan2(this.relMoveVec_.y,this.relMoveVec_.x);
                    if(square_.props_.slideAmount_ > 0) {
                        _local_6 = new Vector3D();
                        _local_6.x = _local_4 * Math.cos(_local_3 + _local_5);
                        _local_6.y = _local_4 * Math.sin(_local_3 + _local_5);
                        _local_6.z = 0;
                        _local_7 = _local_6.length;
                        _local_6.scaleBy(-1 * (square_.props_.slideAmount_ - 1));
                        moveVec_.scaleBy(square_.props_.slideAmount_);
                        if(moveVec_.length < _local_7) {
                            moveVec_ = moveVec_.add(_local_6);
                        }
                    } else {
                        moveVec_.x = _local_4 * Math.cos(_local_3 + _local_5);
                        moveVec_.y = _local_4 * Math.sin(_local_3 + _local_5);
                    }
                } else if(moveVec_.length > 0.00012 && square_.props_.slideAmount_ > 0) {
                    moveVec_.scaleBy(square_.props_.slideAmount_);
                } else {
                    moveVec_.x = 0;
                    moveVec_.y = 0;
                }
                if(square_ != null && square_.props_.push_) {
                    moveVec_.x = moveVec_.x - square_.props_.animate_.dx_ / 1000;
                    moveVec_.y = moveVec_.y - square_.props_.animate_.dy_ / 1000;
                }
                this.walkTo(x_ + param2 * moveVec_.x,y_ + param2 * moveVec_.y);
            } else if(!super.update(param1,param2)) {
                return false;
            }
            if(map_.player_ == this && square_.props_.maxDamage_ > 0 && square_.lastDamage_ + 500 < param1 && !isInvincible() && (square_.obj_ == null || !square_.obj_.props_.protectFromGroundDamage_)) {
                _local_8 = map_.gs_.gsc_.getNextDamage(square_.props_.minDamage_,square_.props_.maxDamage_);
                _local_9 = new Vector.<uint>();
                _local_9.push(ConditionEffect.GROUND_DAMAGE);
                damage(-1,_local_8,_local_9,hp_ <= _local_8,null);
                map_.gs_.gsc_.groundDamage(param1,x_,y_);
                square_.lastDamage_ = param1;
            }
            return true;
        }
        
        public function onMove() : void {
            if(map_ == null) {
                return;
            }
            var _local_1:Square = map_.getSquare(x_,y_);
            if(_local_1.props_.sinking_) {
                sinkLevel_ = Math.min(sinkLevel_ + 1,Parameters.MAX_SINK_LEVEL);
                this.moveMultiplier_ = 0.1 + (1 - sinkLevel_ / Parameters.MAX_SINK_LEVEL) * (_local_1.props_.speed_ - 0.1);
            } else {
                sinkLevel_ = 0;
                this.moveMultiplier_ = _local_1.props_.speed_;
            }
        }
        
        override protected function makeNameBitmapData() : BitmapData {
            var _local_1:StringBuilder = new StaticStringBuilder(name_);
            var _local_2:BitmapTextFactory = StaticInjectorContext.getInjector().getInstance(BitmapTextFactory);
            var _local_3:BitmapData = _local_2.make(_local_1,16,this.getNameColor(),true,NAME_OFFSET_MATRIX,true);
            _local_3.draw(FameUtil.numStarsToIcon(this.numStars_),RANK_OFFSET_MATRIX);
            return _local_3;
        }
        
        private function getNameColor() : uint {
            if(this.isFellowGuild_) {
                return Parameters.FELLOW_GUILD_COLOR;
            }
            if(this.nameChosen_) {
                return Parameters.NAME_CHOSEN_COLOR;
            }
            return 16777215;
        }
        
        protected function drawBreathBar(param1:Vector.<IGraphicsData>, param2:int) : void {
            var _local_7:Number = NaN;
            var _local_8:Number = NaN;
            if(this.breathPath_ == null) {
                this.breathBackFill_ = new GraphicsSolidFill();
                this.breathBackPath_ = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS,new Vector.<Number>());
                this.breathFill_ = new GraphicsSolidFill(2542335);
                this.breathPath_ = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS,new Vector.<Number>());
            }
            if(this.breath_ <= Parameters.BREATH_THRESH) {
                _local_7 = (Parameters.BREATH_THRESH - this.breath_) / Parameters.BREATH_THRESH;
                this.breathBackFill_.color = MoreColorUtil.lerpColor(5526612,16711680,Math.abs(Math.sin(param2 / 300)) * _local_7);
            } else {
                this.breathBackFill_.color = 5526612;
            }
            var _local_3:int = 20;
            var _local_4:int = 8;
            var _local_5:int = 6;
            var _local_6:Vector.<Number> = this.breathBackPath_.data as Vector.<Number>;
            _local_6.length = 0;
            _local_6.push(posS_[0] - _local_3,posS_[1] + _local_4,posS_[0] + _local_3,posS_[1] + _local_4,posS_[0] + _local_3,posS_[1] + _local_4 + _local_5,posS_[0] - _local_3,posS_[1] + _local_4 + _local_5);
            param1.push(this.breathBackFill_);
            param1.push(this.breathBackPath_);
            param1.push(GraphicsUtil.END_FILL);
            if(this.breath_ > 0) {
                _local_8 = this.breath_ / 100 * 2 * _local_3;
                this.breathPath_.data.length = 0;
                _local_6 = this.breathPath_.data as Vector.<Number>;
                _local_6.length = 0;
                _local_6.push(posS_[0] - _local_3,posS_[1] + _local_4,posS_[0] - _local_3 + _local_8,posS_[1] + _local_4,posS_[0] - _local_3 + _local_8,posS_[1] + _local_4 + _local_5,posS_[0] - _local_3,posS_[1] + _local_4 + _local_5);
                param1.push(this.breathFill_);
                param1.push(this.breathPath_);
                param1.push(GraphicsUtil.END_FILL);
            }
            GraphicsFillExtra.setSoftwareDrawSolid(this.breathFill_,true);
            GraphicsFillExtra.setSoftwareDrawSolid(this.breathBackFill_,true);
        }
        
        override public function draw(param1:Vector.<IGraphicsData>, param2:Camera, param3:int) : void {
            super.draw(param1,param2,param3);
            if(this != map_.player_) {
                if(!Parameters.screenShotMode_) {
                    drawName(param1,param2);
                }
            } else if(this.breath_ >= 0) {
                this.drawBreathBar(param1,param3);
            }
        }
        
        private function getMoveSpeed() : Number {
            if(isSlowed()) {
                return MIN_MOVE_SPEED * this.moveMultiplier_;
            }
            var _local_1:Number = MIN_MOVE_SPEED + this.speed_ / 75 * (MAX_MOVE_SPEED - MIN_MOVE_SPEED);
            if(isSpeedy() || isNinjaSpeedy()) {
                _local_1 = _local_1 * 1.5;
            }
            _local_1 = _local_1 * this.moveMultiplier_;
            return _local_1;
        }
        
        public function attackFrequency() : Number {
            if(isDazed()) {
                return MIN_ATTACK_FREQ;
            }
            var _local_1:Number = MIN_ATTACK_FREQ + this.dexterity_ / 75 * (MAX_ATTACK_FREQ - MIN_ATTACK_FREQ);
            if(isBerserk()) {
                _local_1 = _local_1 * 1.5;
            }
            return _local_1;
        }
        
        private function attackMultiplier() : Number {
            if(isWeak()) {
                return MIN_ATTACK_MULT;
            }
            var _local_1:Number = MIN_ATTACK_MULT + this.attack_ / 75 * (MAX_ATTACK_MULT - MIN_ATTACK_MULT);
            if(isDamaging()) {
                _local_1 = _local_1 * 1.5;
            }
            return _local_1;
        }
        
        private function makeSkinTexture() : void {
            var _local_1:MaskedImage = this.skin.imageFromAngle(0,AnimatedChar.STAND,0);
            animatedChar_ = this.skin;
            texture_ = _local_1.image_;
            mask_ = _local_1.mask_;
            this.isDefaultAnimatedChar = true;
        }
        
        private function setToRandomAnimatedCharacter() : void {
            var _local_1:Vector.<XML> = ObjectLibrary.hexTransforms_;
            var _local_2:uint = Math.floor(Math.random() * _local_1.length);
            var _local_3:int = _local_1[_local_2].@type;
            var _local_4:TextureData = ObjectLibrary.typeToTextureData_[_local_3];
            texture_ = _local_4.texture_;
            mask_ = _local_4.mask_;
            animatedChar_ = _local_4.animatedChar_;
            this.isDefaultAnimatedChar = false;
        }
        
        override protected function getTexture(param1:Camera, param2:int) : BitmapData {
            var _local_5:MaskedImage = null;
            var _local_10:int = 0;
            var _local_11:Dictionary = null;
            var _local_12:Number = NaN;
            var _local_13:int = 0;
            var _local_14:ColorTransform = null;
            var _local_3:Number = 0;
            var _local_4:int = AnimatedChar.STAND;
            if(this.isShooting || param2 < attackStart_ + this.attackPeriod_) {
                facing_ = attackAngle_;
                _local_3 = (param2 - attackStart_) % this.attackPeriod_ / this.attackPeriod_;
                _local_4 = AnimatedChar.ATTACK;
            } else if(moveVec_.x != 0 || moveVec_.y != 0) {
                _local_10 = 3.5 / this.getMoveSpeed();
                if(moveVec_.y != 0 || moveVec_.x != 0) {
                    facing_ = Math.atan2(moveVec_.y,moveVec_.x);
                }
                _local_3 = param2 % _local_10 / _local_10;
                _local_4 = AnimatedChar.WALK;
            }
            if(this.isHexed()) {
                this.isDefaultAnimatedChar && this.setToRandomAnimatedCharacter();
            } else if(!this.isDefaultAnimatedChar) {
                this.makeSkinTexture();
            }
            if(param1.isHallucinating_) {
                _local_5 = new MaskedImage(getHallucinatingTexture(),null);
            } else {
                _local_5 = animatedChar_.imageFromFacing(facing_,param1,_local_4,_local_3);
            }
            var _local_6:int = tex1Id_;
            var _local_7:int = tex2Id_;
            var _local_8:BitmapData = null;
            if(this.nearestMerchant_) {
                _local_11 = texturingCache_[this.nearestMerchant_];
                if(_local_11 == null) {
                    texturingCache_[this.nearestMerchant_] = new Dictionary();
                } else {
                    _local_8 = _local_11[_local_5];
                }
                _local_6 = this.nearestMerchant_.getTex1Id(tex1Id_);
                _local_7 = this.nearestMerchant_.getTex2Id(tex2Id_);
            } else {
                _local_8 = texturingCache_[_local_5];
            }
            if(_local_8 == null) {
                _local_8 = TextureRedrawer.resize(_local_5.image_,_local_5.mask_,size_,false,_local_6,_local_7);
                if(this.nearestMerchant_ != null) {
                    texturingCache_[this.nearestMerchant_][_local_5] = _local_8;
                } else {
                    texturingCache_[_local_5] = _local_8;
                }
            }
            if(hp_ < maxHP_ * 0.2) {
                _local_12 = int(Math.abs(Math.sin(param2 / 200)) * 10) / 10;
                _local_13 = 128;
                _local_14 = new ColorTransform(1,1,1,1,_local_12 * _local_13,-_local_12 * _local_13,-_local_12 * _local_13);
                _local_8 = CachingColorTransformer.transformBitmapData(_local_8,_local_14);
            }
            var _local_9:BitmapData = texturingCache_[_local_8];
            if(_local_9 == null) {
                _local_9 = GlowRedrawer.outlineGlow(_local_8,this.legendaryRank_ == -1?uint(0):uint(16711680));
                texturingCache_[_local_8] = _local_9;
            }
            if(isPaused() || isStasis() || isPetrified()) {
                _local_9 = CachingColorTransformer.filterBitmapData(_local_9,PAUSED_FILTER);
            } else if(isInvisible()) {
                _local_9 = CachingColorTransformer.alphaBitmapData(_local_9,0.4);
            }
            return _local_9;
        }
        
        override public function getPortrait() : BitmapData {
            var _local_1:MaskedImage = null;
            var _local_2:int = 0;
            if(portrait_ == null) {
                _local_1 = animatedChar_.imageFromDir(AnimatedChar.RIGHT,AnimatedChar.STAND,0);
                _local_2 = 4 / _local_1.image_.width * 100;
                portrait_ = TextureRedrawer.resize(_local_1.image_,_local_1.mask_,_local_2,true,tex1Id_,tex2Id_);
                portrait_ = GlowRedrawer.outlineGlow(portrait_,0);
            }
            return portrait_;
        }
        
        public function useAltWeapon(param1:Number, param2:Number, param3:int) : Boolean {
            var _local_7:XML = null;
            var _local_8:int = 0;
            var _local_9:Number = NaN;
            var _local_10:int = 0;
            var _local_11:int = 0;
            if(map_ == null || isPaused()) {
                return false;
            }
            var _local_4:int = equipment_[1];
            if(_local_4 == -1) {
                return false;
            }
            var _local_5:XML = ObjectLibrary.xmlLibrary_[_local_4];
            if(_local_5 == null || !_local_5.hasOwnProperty("Usable")) {
                return false;
            }
            if(isSilenced()) {
                SoundEffectLibrary.play("error");
                return false;
            }
            var _local_6:Point = map_.pSTopW(param1,param2);
            if(_local_6 == null) {
                SoundEffectLibrary.play("error");
                return false;
            }
            for each(_local_7 in _local_5.Activate) {
                if(_local_7.toString() == ActivationType.TELEPORT) {
                    if(!this.isValidPosition(_local_6.x,_local_6.y)) {
                        SoundEffectLibrary.play("error");
                        return false;
                    }
                }
            }
            _local_8 = getTimer();
            if(param3 == UseType.START_USE) {
                if(_local_8 < this.nextAltAttack_) {
                    SoundEffectLibrary.play("error");
                    return false;
                }
                _local_10 = int(_local_5.MpCost);
                if(_local_10 > this.mp_) {
                    SoundEffectLibrary.play("no_mana");
                    return false;
                }
                _local_11 = 500;
                if(_local_5.hasOwnProperty("Cooldown")) {
                    _local_11 = Number(_local_5.Cooldown) * 1000;
                }
                this.nextAltAttack_ = _local_8 + _local_11;
                map_.gs_.gsc_.useItem(_local_8,objectId_,1,_local_4,_local_6.x,_local_6.y,param3);
                if(_local_5.Activate == ActivationType.SHOOT) {
                    _local_9 = Math.atan2(param2,param1);
                    this.doShoot(_local_8,_local_4,_local_5,Parameters.data_.cameraAngle + _local_9,false);
                }
            } else if(_local_5.hasOwnProperty("MultiPhase")) {
                map_.gs_.gsc_.useItem(_local_8,objectId_,1,_local_4,_local_6.x,_local_6.y,param3);
                _local_10 = int(_local_5.MpEndCost);
                if(_local_10 <= this.mp_) {
                    _local_9 = Math.atan2(param2,param1);
                    this.doShoot(_local_8,_local_4,_local_5,Parameters.data_.cameraAngle + _local_9,false);
                }
            }
            return true;
        }
        
        public function attemptAttackAngle(param1:Number) : void {
            this.shoot(Parameters.data_.cameraAngle + param1);
        }
        
        override public function setAttack(param1:int, param2:Number) : void {
            var _local_3:XML = ObjectLibrary.xmlLibrary_[param1];
            if(_local_3 == null || !_local_3.hasOwnProperty("RateOfFire")) {
                return;
            }
            var _local_4:Number = Number(_local_3.RateOfFire);
            this.attackPeriod_ = 1 / this.attackFrequency() * (1 / _local_4);
            super.setAttack(param1,param2);
        }
        
        private function shoot(param1:Number) : void {
            if(map_ == null || isStunned() || isPaused() || isPetrified()) {
                return;
            }
            var _local_2:int = equipment_[0];
            if(_local_2 == -1) {
                this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME,TextKey.PLAYER_NO_WEAPON_EQUIPPED));
                return;
            }
            var _local_3:XML = ObjectLibrary.xmlLibrary_[_local_2];
            var _local_4:int = getTimer();
            var _local_5:Number = Number(_local_3.RateOfFire);
            this.attackPeriod_ = 1 / this.attackFrequency() * (1 / _local_5);
            if(_local_4 < attackStart_ + this.attackPeriod_) {
                return;
            }
            doneAction(map_.gs_,Tutorial.ATTACK_ACTION);
            attackAngle_ = param1;
            attackStart_ = _local_4;
            this.doShoot(attackStart_,_local_2,_local_3,attackAngle_,true);
        }
        
        private function doShoot(param1:int, param2:int, param3:XML, param4:Number, param5:Boolean) : void {
            var _local_11:uint = 0;
            var _local_12:Projectile = null;
            var _local_13:int = 0;
            var _local_14:int = 0;
            var _local_15:Number = NaN;
            var _local_16:int = 0;
            var _local_6:int = !!param3.hasOwnProperty("NumProjectiles")?int(int(param3.NumProjectiles)):1;
            var _local_7:Number = (!!param3.hasOwnProperty("ArcGap")?Number(param3.ArcGap):11.25) * Trig.toRadians;
            var _local_8:Number = _local_7 * (_local_6 - 1);
            var _local_9:Number = param4 - _local_8 / 2;
            this.isShooting = param5;
            var _local_10:int = 0;
            while(_local_10 < _local_6) {
                _local_11 = getBulletId();
                _local_12 = FreeList.newObject(Projectile) as Projectile;
                if(param5 && this.projectileIdSetOverrideNew != "") {
                    _local_12.reset(param2,0,objectId_,_local_11,_local_9,param1,this.projectileIdSetOverrideNew,this.projectileIdSetOverrideOld);
                } else {
                    _local_12.reset(param2,0,objectId_,_local_11,_local_9,param1);
                }
                _local_13 = int(_local_12.projProps_.minDamage_);
                _local_14 = int(_local_12.projProps_.maxDamage_);
                _local_15 = !!param5?Number(this.attackMultiplier()):Number(1);
                _local_16 = map_.gs_.gsc_.getNextDamage(_local_13,_local_14) * _local_15;
                if(param1 > map_.gs_.moveRecords_.lastClearTime_ + 600) {
                    _local_16 = 0;
                }
                _local_12.setDamage(_local_16);
                if(_local_10 == 0 && _local_12.sound_ != null) {
                    SoundEffectLibrary.play(_local_12.sound_,0.75,false);
                }
                map_.addObj(_local_12,x_ + Math.cos(param4) * 0.3,y_ + Math.sin(param4) * 0.3);
                map_.gs_.gsc_.playerShoot(param1,_local_12);
                _local_9 = _local_9 + _local_7;
                _local_10++;
            }
        }
        
        public function isHexed() : Boolean {
            return (condition_[ConditionEffect.CE_FIRST_BATCH] & ConditionEffect.HEXED_BIT) != 0;
        }
        
        public function isInventoryFull() : Boolean {
            if(equipment_ == null) {
                return false;
            }
            var _local_1:int = equipment_.length;
            var _local_2:uint = 4;
            while(_local_2 < _local_1) {
                if(equipment_[_local_2] <= 0) {
                    return false;
                }
                _local_2++;
            }
            return true;
        }
        
        public function nextAvailableInventorySlot() : int {
            var _local_1:int = !!this.hasBackpack_?int(equipment_.length):int(equipment_.length - GeneralConstants.NUM_INVENTORY_SLOTS);
            var _local_2:uint = 4;
            while(_local_2 < _local_1) {
                if(equipment_[_local_2] <= 0) {
                    return _local_2;
                }
                _local_2++;
            }
            return -1;
        }
        
        public function numberOfAvailableSlots() : int {
            var _local_1:int = !!this.hasBackpack_?int(equipment_.length):int(equipment_.length - GeneralConstants.NUM_INVENTORY_SLOTS);
            var _local_2:int = 0;
            var _local_3:uint = 4;
            while(_local_3 < _local_1) {
                if(equipment_[_local_3] <= 0) {
                    _local_2++;
                }
                _local_3++;
            }
            return _local_2;
        }
        
        public function swapInventoryIndex(param1:String) : int {
            var _local_2:int = 0;
            var _local_3:int = 0;
            if(!this.hasBackpack_) {
                return -1;
            }
            if(param1 == TabStripModel.BACKPACK) {
                _local_2 = GeneralConstants.NUM_EQUIPMENT_SLOTS;
                _local_3 = GeneralConstants.NUM_EQUIPMENT_SLOTS + GeneralConstants.NUM_INVENTORY_SLOTS;
            } else {
                _local_2 = GeneralConstants.NUM_EQUIPMENT_SLOTS + GeneralConstants.NUM_INVENTORY_SLOTS;
                _local_3 = equipment_.length;
            }
            var _local_4:uint = _local_2;
            while(_local_4 < _local_3) {
                if(equipment_[_local_4] <= 0) {
                    return _local_4;
                }
                _local_4++;
            }
            return -1;
        }
        
        public function getPotionCount(param1:int) : int {
            switch(param1) {
                case PotionInventoryModel.HEALTH_POTION_ID:
                    return this.healthPotionCount_;
                case PotionInventoryModel.MAGIC_POTION_ID:
                    return this.magicPotionCount_;
                default:
                    return 0;
            }
        }
        
        public function getTex1() : int {
            return tex1Id_;
        }
        
        public function getTex2() : int {
            return tex2Id_;
        }
    }
}
