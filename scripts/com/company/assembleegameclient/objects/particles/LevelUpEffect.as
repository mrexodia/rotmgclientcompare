package com.company.assembleegameclient.objects.particles {
    import com.company.assembleegameclient.objects.GameObject;
    
    public class LevelUpEffect extends ParticleEffect {
        
        private static const LIFETIME:int = 2000;
         
        
        public var go_:GameObject;
        
        public var parts1_:Vector.<LevelUpParticle>;
        
        public var parts2_:Vector.<LevelUpParticle>;
        
        public var startTime_:int = -1;
        
        public function LevelUpEffect(param1:GameObject, param2:uint, param3:int) {
            var _local_4:LevelUpParticle = null;
            this.parts1_ = new Vector.<LevelUpParticle>();
            this.parts2_ = new Vector.<LevelUpParticle>();
            super();
            this.go_ = param1;
            var _local_5:int = 0;
            while(_local_5 < param3) {
                _local_4 = new LevelUpParticle(param2,100);
                this.parts1_.push(_local_4);
                _local_4 = new LevelUpParticle(param2,100);
                this.parts2_.push(_local_4);
                _local_5++;
            }
        }
        
        override public function update(param1:int, param2:int) : Boolean {
            if(this.go_.map_ == null) {
                this.endEffect();
                return false;
            }
            x_ = this.go_.x_;
            y_ = this.go_.y_;
            if(this.startTime_ < 0) {
                this.startTime_ = param1;
            }
            var _local_3:Number = (param1 - this.startTime_) / LIFETIME;
            if(_local_3 >= 1) {
                this.endEffect();
                return false;
            }
            this.updateSwirl(this.parts1_,1,0,_local_3);
            this.updateSwirl(this.parts2_,1,Math.PI,_local_3);
            return true;
        }
        
        private function endEffect() : void {
            var _local_1:LevelUpParticle = null;
            for each(_local_1 in this.parts1_) {
                _local_1.alive_ = false;
            }
            for each(_local_1 in this.parts2_) {
                _local_1.alive_ = false;
            }
        }
        
        public function updateSwirl(param1:Vector.<LevelUpParticle>, param2:Number, param3:Number, param4:Number) : void {
            var _local_5:int = 0;
            var _local_6:LevelUpParticle = null;
            var _local_7:Number = NaN;
            var _local_8:Number = NaN;
            var _local_9:Number = NaN;
            _local_5 = 0;
            while(_local_5 < param1.length) {
                _local_6 = param1[_local_5];
                _local_6.z_ = param4 * 2 - 1 + _local_5 / param1.length;
                if(_local_6.z_ >= 0) {
                    if(_local_6.z_ > 1) {
                        _local_6.alive_ = false;
                    } else {
                        _local_7 = param2 * (2 * Math.PI * (_local_5 / param1.length) + 2 * Math.PI * param4 + param3);
                        _local_8 = this.go_.x_ + 0.5 * Math.cos(_local_7);
                        _local_9 = this.go_.y_ + 0.5 * Math.sin(_local_7);
                        if(_local_6.map_ == null) {
                            map_.addObj(_local_6,_local_8,_local_9);
                        } else {
                            _local_6.moveTo(_local_8,_local_9);
                        }
                    }
                }
                _local_5++;
            }
        }
    }
}

import com.company.assembleegameclient.objects.particles.Particle;

class LevelUpParticle extends Particle {
     
    
    public var alive_:Boolean = true;
    
    function LevelUpParticle(param1:uint, param2:int) {
        super(param1,0,param2);
    }
    
    override public function update(param1:int, param2:int) : Boolean {
        return this.alive_;
    }
}
