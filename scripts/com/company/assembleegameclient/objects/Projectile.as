package com.company.assembleegameclient.objects {
    import com.company.assembleegameclient.engine3d.Point3D;
    import com.company.assembleegameclient.map.Camera;
    import com.company.assembleegameclient.map.Map;
    import com.company.assembleegameclient.map.Square#58;
    import com.company.assembleegameclient.objects.particles.HitEffect;
    import com.company.assembleegameclient.objects.particles.SparkParticle;
    import com.company.assembleegameclient.parameters.Parameters;
    import com.company.assembleegameclient.tutorial.Tutorial;
    import com.company.assembleegameclient.tutorial.doneAction;
    import com.company.assembleegameclient.util.BloodComposition;
    import com.company.assembleegameclient.util.FreeList;
    import com.company.assembleegameclient.util.RandomUtil;
    import com.company.assembleegameclient.util.TextureRedrawer;
    import com.company.util.GraphicsUtil;
    import com.company.util.Trig;
    import flash.display.BitmapData;
    import flash.display.GradientType;
    import flash.display.GraphicsGradientFill;
    import flash.display.GraphicsPath;
    import flash.display.IGraphicsData;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Vector3D;
    import flash.utils.Dictionary;
    
    public class Projectile extends BasicObject {
        
        private static var objBullIdToObjId_:Dictionary = new Dictionary();
         
        
        public var props_:ObjectProperties;
        
        public var containerProps_:ObjectProperties;
        
        public var projProps_:ProjectileProperties;
        
        public var texture_:BitmapData;
        
        public var bulletId_:uint;
        
        public var ownerId_:int;
        
        public var containerType_:int;
        
        public var bulletType_:uint;
        
        public var damagesEnemies_:Boolean;
        
        public var damagesPlayers_:Boolean;
        
        public var damage_:int;
        
        public var sound_:String;
        
        public var startX_:Number;
        
        public var startY_:Number;
        
        public var startTime_:int;
        
        public var angle_:Number = 0;
        
        public var multiHitDict_:Dictionary;
        
        public var p_:Point3D;
        
        private var staticPoint_:Point;
        
        private var staticVector3D_:Vector3D;
        
        protected var shadowGradientFill_:GraphicsGradientFill;
        
        protected var shadowPath_:GraphicsPath;
        
        public function Projectile() {
            this.p_ = new Point3D(100);
            this.staticPoint_ = new Point();
            this.staticVector3D_ = new Vector3D();
            this.shadowGradientFill_ = new GraphicsGradientFill(GradientType.RADIAL,[0,0],[0.5,0],null,new Matrix());
            this.shadowPath_ = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS,new Vector.<Number>());
            super();
        }
        
        public static function findObjId(param1:int, param2:uint) : int {
            return objBullIdToObjId_[param2 << 24 | param1];
        }
        
        public static function getNewObjId(param1:int, param2:uint) : int {
            var _local_3:int = getNextFakeObjectId();
            objBullIdToObjId_[param2 << 24 | param1] = _local_3;
            return _local_3;
        }
        
        public static function removeObjId(param1:int, param2:uint) : void {
            delete objBullIdToObjId_[param2 << 24 | param1];
        }
        
        public static function dispose() : void {
            objBullIdToObjId_ = new Dictionary();
        }
        
        public function reset(param1:int, param2:int, param3:int, param4:int, param5:Number, param6:int, param7:String = "", param8:String = "") : void {
            var _local_11:Number = NaN;
            clear();
            this.containerType_ = param1;
            this.bulletType_ = param2;
            this.ownerId_ = param3;
            this.bulletId_ = param4;
            this.angle_ = Trig.boundToPI(param5);
            this.startTime_ = param6;
            objectId_ = getNewObjId(this.ownerId_,this.bulletId_);
            z_ = 0.5;
            this.containerProps_ = ObjectLibrary.propsLibrary_[this.containerType_];
            this.projProps_ = this.containerProps_.projectiles_[param2];
            var _local_9:String = param7 != "" && this.projProps_.objectId_ == param8?param7:this.projProps_.objectId_;
            this.props_ = ObjectLibrary.getPropsFromId(_local_9);
            hasShadow_ = this.props_.shadowSize_ > 0;
            var _local_10:TextureData = ObjectLibrary.typeToTextureData_[this.props_.type_];
            this.texture_ = _local_10.getTexture(objectId_);
            this.damagesPlayers_ = this.containerProps_.isEnemy_;
            this.damagesEnemies_ = !this.damagesPlayers_;
            this.sound_ = this.containerProps_.oldSound_;
            this.multiHitDict_ = !!this.projProps_.multiHit_?new Dictionary():null;
            if(this.projProps_.size_ >= 0) {
                _local_11 = this.projProps_.size_;
            } else {
                _local_11 = ObjectLibrary.getSizeFromType(this.containerType_);
            }
            this.p_.setSize(8 * (_local_11 / 100));
            this.damage_ = 0;
        }
        
        public function setDamage(param1:int) : void {
            this.damage_ = param1;
        }
        
        override public function addTo(param1:Map, param2:Number, param3:Number) : Boolean {
            var _local_4:Player = null;
            this.startX_ = param2;
            this.startY_ = param3;
            if(!super.addTo(param1,param2,param3)) {
                return false;
            }
            if(!this.containerProps_.flying_ && square_.sink_) {
                z_ = 0.1;
            } else {
                _local_4 = param1.goDict_[this.ownerId_] as Player;
                if(_local_4 != null && _local_4.sinkLevel_ > 0) {
                    z_ = 0.5 - 0.4 * (_local_4.sinkLevel_ / Parameters.MAX_SINK_LEVEL);
                }
            }
            return true;
        }
        
        public function moveTo(param1:Number, param2:Number) : Boolean {
            var _local_3:Square = map_.getSquare(param1,param2);
            if(_local_3 == null) {
                return false;
            }
            x_ = param1;
            y_ = param2;
            square_ = _local_3;
            return true;
        }
        
        override public function removeFromMap() : void {
            super.removeFromMap();
            removeObjId(this.ownerId_,this.bulletId_);
            this.multiHitDict_ = null;
            FreeList.deleteObject(this);
        }
        
        private function positionAt(param1:int, param2:Point) : void {
            var _local_5:Number = NaN;
            var _local_6:Number = NaN;
            var _local_7:Number = NaN;
            var _local_8:Number = NaN;
            var _local_9:Number = NaN;
            var _local_10:Number = NaN;
            var _local_11:Number = NaN;
            var _local_12:Number = NaN;
            var _local_13:Number = NaN;
            var _local_14:Number = NaN;
            param2.x = this.startX_;
            param2.y = this.startY_;
            var _local_3:Number = param1 * (this.projProps_.speed_ / 10000);
            var _local_4:Number = this.bulletId_ % 2 == 0?Number(0):Number(Math.PI);
            if(this.projProps_.wavy_) {
                _local_5 = 6 * Math.PI;
                _local_6 = Math.PI / 64;
                _local_7 = this.angle_ + _local_6 * Math.sin(_local_4 + _local_5 * param1 / 1000);
                param2.x = param2.x + _local_3 * Math.cos(_local_7);
                param2.y = param2.y + _local_3 * Math.sin(_local_7);
            } else if(this.projProps_.parametric_) {
                _local_8 = param1 / this.projProps_.lifetime_ * 2 * Math.PI;
                _local_9 = Math.sin(_local_8) * (!!(this.bulletId_ % 2)?1:-1);
                _local_10 = Math.sin(2 * _local_8) * (this.bulletId_ % 4 < 2?1:-1);
                _local_11 = Math.sin(this.angle_);
                _local_12 = Math.cos(this.angle_);
                param2.x = param2.x + (_local_9 * _local_12 - _local_10 * _local_11) * this.projProps_.magnitude_;
                param2.y = param2.y + (_local_9 * _local_11 + _local_10 * _local_12) * this.projProps_.magnitude_;
            } else {
                if(this.projProps_.boomerang_) {
                    _local_13 = this.projProps_.lifetime_ * (this.projProps_.speed_ / 10000) / 2;
                    if(_local_3 > _local_13) {
                        _local_3 = _local_13 - (_local_3 - _local_13);
                    }
                }
                param2.x = param2.x + _local_3 * Math.cos(this.angle_);
                param2.y = param2.y + _local_3 * Math.sin(this.angle_);
                if(this.projProps_.amplitude_ != 0) {
                    _local_14 = this.projProps_.amplitude_ * Math.sin(_local_4 + param1 / this.projProps_.lifetime_ * this.projProps_.frequency_ * 2 * Math.PI);
                    param2.x = param2.x + _local_14 * Math.cos(this.angle_ + Math.PI / 2);
                    param2.y = param2.y + _local_14 * Math.sin(this.angle_ + Math.PI / 2);
                }
            }
        }
        
        override public function update(param1:int, param2:int) : Boolean {
            var _local_5:Vector.<uint> = null;
            var _local_7:Player = null;
            var _local_8:* = false;
            var _local_9:Boolean = false;
            var _local_10:Boolean = false;
            var _local_11:int = 0;
            var _local_12:Boolean = false;
            var _local_3:int = param1 - this.startTime_;
            if(_local_3 > this.projProps_.lifetime_) {
                return false;
            }
            var _local_4:Point = this.staticPoint_;
            this.positionAt(_local_3,_local_4);
            if(!this.moveTo(_local_4.x,_local_4.y) || square_.tileType_ == 65535) {
                if(this.damagesPlayers_) {
                    map_.gs_.gsc_.squareHit(param1,this.bulletId_,this.ownerId_);
                } else if(square_.obj_ != null) {
                    if(!Parameters.data_.noParticlesMaster) {
                        _local_5 = BloodComposition.getColors(this.texture_);
                        map_.addObj(new HitEffect(_local_5,100,3,this.angle_,this.projProps_.speed_),_local_4.x,_local_4.y);
                    }
                }
                return false;
            }
            if(square_.obj_ != null && (!square_.obj_.props_.isEnemy_ || !this.damagesEnemies_) && (square_.obj_.props_.enemyOccupySquare_ || !this.projProps_.passesCover_ && square_.obj_.props_.occupySquare_)) {
                if(this.damagesPlayers_) {
                    map_.gs_.gsc_.otherHit(param1,this.bulletId_,this.ownerId_,square_.obj_.objectId_);
                } else if(!Parameters.data_.noParticlesMaster) {
                    _local_5 = BloodComposition.getColors(this.texture_);
                    map_.addObj(new HitEffect(_local_5,100,3,this.angle_,this.projProps_.speed_),_local_4.x,_local_4.y);
                }
                return false;
            }
            var _local_6:GameObject = this.getHit(_local_4.x,_local_4.y);
            if(_local_6 != null) {
                _local_7 = map_.player_;
                _local_8 = _local_7 != null;
                _local_9 = _local_6.props_.isEnemy_;
                _local_10 = _local_8 && !_local_7.isPaused() && (this.damagesPlayers_ || _local_9 && this.ownerId_ == _local_7.objectId_);
                if(_local_10) {
                    _local_11 = GameObject.damageWithDefense(this.damage_,_local_6.defense_,this.projProps_.armorPiercing_,_local_6.condition_);
                    _local_12 = false;
                    if(_local_6.hp_ <= _local_11) {
                        _local_12 = true;
                        if(_local_6.props_.isEnemy_) {
                            doneAction(map_.gs_,Tutorial.KILL_ACTION);
                        }
                    }
                    if(_local_6 == _local_7) {
                        map_.gs_.gsc_.playerHit(this.bulletId_,this.ownerId_);
                        _local_6.damage(true,_local_11,this.projProps_.effects_,false,this);
                    } else if(_local_6.props_.isEnemy_) {
                        map_.gs_.gsc_.enemyHit(param1,this.bulletId_,_local_6.objectId_,_local_12);
                        _local_6.damage(true,_local_11,this.projProps_.effects_,_local_12,this);
                    } else if(!this.projProps_.multiHit_) {
                        map_.gs_.gsc_.otherHit(param1,this.bulletId_,this.ownerId_,_local_6.objectId_);
                    }
                }
                if(this.projProps_.multiHit_) {
                    this.multiHitDict_[_local_6] = true;
                } else {
                    return false;
                }
            }
            return true;
        }
        
        public function getHit(param1:Number, param2:Number) : GameObject {
            var _local_5:GameObject = null;
            var _local_6:Number = NaN;
            var _local_7:Number = NaN;
            var _local_8:Number = NaN;
            var _local_9:Number = NaN;
            var _local_3:Number = Number.MAX_VALUE;
            var _local_4:GameObject = null;
            for each(_local_5 in map_.goDict_) {
                if(!_local_5.isInvincible()) {
                    if(!_local_5.isStasis()) {
                        if(this.damagesEnemies_ && _local_5.props_.isEnemy_ || this.damagesPlayers_ && _local_5.props_.isPlayer_) {
                            if(!(_local_5.dead_ || _local_5.isPaused())) {
                                _local_6 = _local_5.x_ > param1?Number(_local_5.x_ - param1):Number(param1 - _local_5.x_);
                                _local_7 = _local_5.y_ > param2?Number(_local_5.y_ - param2):Number(param2 - _local_5.y_);
                                if(!(_local_6 > _local_5.radius_ || _local_7 > _local_5.radius_)) {
                                    if(!(this.projProps_.multiHit_ && this.multiHitDict_[_local_5] != null)) {
                                        if(_local_5 == map_.player_) {
                                            return _local_5;
                                        }
                                        _local_8 = Math.sqrt(_local_6 * _local_6 + _local_7 * _local_7);
                                        _local_9 = _local_6 * _local_6 + _local_7 * _local_7;
                                        if(_local_9 < _local_3) {
                                            _local_3 = _local_9;
                                            _local_4 = _local_5;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return _local_4;
        }
        
        override public function draw(param1:Vector.<IGraphicsData>, param2:Camera, param3:int) : void {
            var _local_8:uint = 0;
            var _local_9:uint = 0;
            var _local_10:int = 0;
            var _local_11:int = 0;
            if(!Parameters.drawProj_) {
                return;
            }
            var _local_4:BitmapData = this.texture_;
            if(Parameters.projColorType_ != 0) {
                switch(Parameters.projColorType_) {
                    case 1:
                        _local_8 = 16777100;
                        _local_9 = 16777215;
                        break;
                    case 2:
                        _local_8 = 16777100;
                        _local_9 = 16777100;
                        break;
                    case 3:
                        _local_8 = 16711680;
                        _local_9 = 16711680;
                        break;
                    case 4:
                        _local_8 = 255;
                        _local_9 = 255;
                        break;
                    case 5:
                        _local_8 = 16777215;
                        _local_9 = 16777215;
                        break;
                    case 6:
                        _local_8 = 0;
                        _local_9 = 0;
                }
                _local_4 = TextureRedrawer.redraw(_local_4,120,true,_local_9);
            }
            var _local_5:Number = this.props_.rotation_ == 0?Number(0):Number(param3 / this.props_.rotation_);
            this.staticVector3D_.x = x_;
            this.staticVector3D_.y = y_;
            this.staticVector3D_.z = z_;
            var _local_6:Number = !!this.projProps_.faceDir_?Number(this.getDirectionAngle(param3)):Number(this.angle_);
            var _local_7:Number = !!this.projProps_.noRotation_?Number(param2.angleRad_ + this.props_.angleCorrection_):Number(_local_6 - param2.angleRad_ + this.props_.angleCorrection_ + _local_5);
            this.p_.draw(param1,this.staticVector3D_,_local_7,param2.wToS_,param2,_local_4);
            if(!Parameters.data_.noParticlesMaster && this.projProps_.particleTrail_) {
                _local_10 = this.projProps_.particleTrailLifetimeMS != -1?int(this.projProps_.particleTrailLifetimeMS):600;
                _local_11 = 0;
                for(; _local_11 < 3; _local_11++) {
                    if(map_ != null && map_.player_.objectId_ != this.ownerId_) {
                        if(this.projProps_.particleTrailIntensity_ == -1 && Math.random() * 100 > this.projProps_.particleTrailIntensity_) {
                            continue;
                        }
                    }
                    map_.addObj(new SparkParticle(100,this.projProps_.particleTrailColor_,_local_10,0.5,RandomUtil.plusMinus(3),RandomUtil.plusMinus(3)),x_,y_);
                }
            }
        }
        
        private function getDirectionAngle(param1:*) : Number {
            var _local_2:int = param1 - this.startTime_;
            var _local_3:Point = new Point();
            this.positionAt(_local_2 + 16,_local_3);
            var _local_4:Number = _local_3.x - x_;
            var _local_5:Number = _local_3.y - y_;
            return Math.atan2(_local_5,_local_4);
        }
        
        override public function drawShadow(param1:Vector.<IGraphicsData>, param2:Camera, param3:int) : void {
            if(!Parameters.drawProj_) {
                return;
            }
            var _local_4:Number = this.props_.shadowSize_ / 400;
            var _local_5:Number = 30 * _local_4;
            var _local_6:Number = 15 * _local_4;
            this.shadowGradientFill_.matrix.createGradientBox(_local_5 * 2,_local_6 * 2,0,posS_[0] - _local_5,posS_[1] - _local_6);
            param1.push(this.shadowGradientFill_);
            this.shadowPath_.data.length = 0;
            Vector.<Number>(this.shadowPath_.data).push(posS_[0] - _local_5,posS_[1] - _local_6,posS_[0] + _local_5,posS_[1] - _local_6,posS_[0] + _local_5,posS_[1] + _local_6,posS_[0] - _local_5,posS_[1] + _local_6);
            param1.push(this.shadowPath_);
            param1.push(GraphicsUtil.END_FILL);
        }
    }
}
