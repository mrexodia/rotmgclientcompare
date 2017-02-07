package com.company.assembleegameclient.objects.particles {
    import com.company.assembleegameclient.objects.GameObject;
    import com.company.assembleegameclient.util.FreeList;
    
    public class FountainEffect extends ParticleEffect {
         
        
        public var go_:GameObject;
        
        public var lastUpdate_:int = -1;
        
        public function FountainEffect(param1:GameObject) {
            super();
            this.go_ = param1;
        }
        
        override public function update(param1:int, param2:int) : Boolean {
            var _local_4:int = 0;
            var _local_5:FountainParticle = null;
            if(this.go_.map_ == null) {
                return false;
            }
            if(this.lastUpdate_ < 0) {
                this.lastUpdate_ = Math.max(0,param1 - 400);
            }
            x_ = this.go_.x_;
            y_ = this.go_.y_;
            var _local_3:int = this.lastUpdate_ / 50;
            while(_local_3 < param1 / 50) {
                _local_4 = _local_3 * 50;
                _local_5 = FreeList.newObject(FountainParticle) as FountainParticle;
                _local_5.restart(_local_4,param1);
                map_.addObj(_local_5,x_,y_);
                _local_3++;
            }
            this.lastUpdate_ = param1;
            return true;
        }
    }
}

import com.company.assembleegameclient.objects.particles.Particle;
import com.company.assembleegameclient.util.FreeList;
import flash.geom.Vector3D;

class FountainParticle extends Particle {
    
    private static const G:Number = -4.9;
    
    private static const VI:Number = 6.5;
    
    private static const ZI:Number = 0.75;
     
    
    public var startTime_:int;
    
    protected var moveVec_:Vector3D;
    
    function FountainParticle() {
        this.moveVec_ = new Vector3D();
        super(4285909,ZI,100);
    }
    
    public function restart(param1:int, param2:int) : void {
        var _local_4:int = 0;
        var _local_3:Number = 2 * Math.PI * Math.random();
        this.moveVec_.x = Math.cos(_local_3);
        this.moveVec_.y = Math.sin(_local_3);
        this.startTime_ = param1;
        _local_4 = param2 - this.startTime_;
        x_ = x_ + this.moveVec_.x * _local_4 * 0.0008;
        y_ = y_ + this.moveVec_.y * _local_4 * 0.0008;
        var _local_5:Number = (param2 - this.startTime_) / 1000;
        z_ = 0.75 + VI * _local_5 + G * (_local_5 * _local_5);
    }
    
    override public function removeFromMap() : void {
        super.removeFromMap();
        FreeList.deleteObject(this);
    }
    
    override public function update(param1:int, param2:int) : Boolean {
        var _local_3:Number = (param1 - this.startTime_) / 1000;
        moveTo(x_ + this.moveVec_.x * param2 * 0.0008,y_ + this.moveVec_.y * param2 * 0.0008);
        z_ = 0.75 + VI * _local_3 + G * (_local_3 * _local_3);
        return z_ > 0;
    }
}
