package com.company.assembleegameclient.objects.particles {
    import com.company.assembleegameclient.objects.GameObject;
    import com.company.assembleegameclient.util.FreeList;
    
    public class VentEffect extends ParticleEffect {
        
        private static const BUBBLE_PERIOD:int = 50;
         
        
        public var go_:GameObject;
        
        public var lastUpdate_:int = -1;
        
        public function VentEffect(param1:GameObject) {
            super();
            this.go_ = param1;
        }
        
        override public function update(param1:int, param2:int) : Boolean {
            var _local_4:int = 0;
            var _local_5:VentParticle = null;
            var _local_6:Number = NaN;
            var _local_7:Number = NaN;
            var _local_8:Number = NaN;
            var _local_9:Number = NaN;
            if(this.go_.map_ == null) {
                return false;
            }
            if(this.lastUpdate_ < 0) {
                this.lastUpdate_ = Math.max(0,param1 - 400);
            }
            x_ = this.go_.x_;
            y_ = this.go_.y_;
            var _local_3:int = int(this.lastUpdate_ / BUBBLE_PERIOD);
            while(_local_3 < int(param1 / BUBBLE_PERIOD)) {
                _local_4 = _local_3 * BUBBLE_PERIOD;
                _local_5 = FreeList.newObject(VentParticle) as VentParticle;
                _local_5.restart(_local_4,param1);
                _local_6 = Math.random() * Math.PI;
                _local_7 = Math.random() * 0.4;
                _local_8 = this.go_.x_ + _local_7 * Math.cos(_local_6);
                _local_9 = this.go_.y_ + _local_7 * Math.sin(_local_6);
                map_.addObj(_local_5,_local_8,_local_9);
                _local_3++;
            }
            this.lastUpdate_ = param1;
            return true;
        }
    }
}

import com.company.assembleegameclient.objects.particles.Particle;
import com.company.assembleegameclient.util.FreeList;

class VentParticle extends Particle {
     
    
    public var startTime_:int;
    
    public var speed_:int;
    
    function VentParticle() {
        var _local_1:Number = Math.random();
        super(2542335,0,75 + _local_1 * 50);
        this.speed_ = 2.5 - _local_1 * 1.5;
    }
    
    public function restart(param1:int, param2:int) : void {
        this.startTime_ = param1;
        var _local_3:Number = (param2 - this.startTime_) / 1000;
        z_ = 0 + this.speed_ * _local_3;
    }
    
    override public function removeFromMap() : void {
        super.removeFromMap();
        FreeList.deleteObject(this);
    }
    
    override public function update(param1:int, param2:int) : Boolean {
        var _local_3:Number = (param1 - this.startTime_) / 1000;
        z_ = 0 + this.speed_ * _local_3;
        return z_ < 1;
    }
}
