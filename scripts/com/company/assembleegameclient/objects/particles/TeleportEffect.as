package com.company.assembleegameclient.objects.particles {
    public class TeleportEffect extends ParticleEffect {
         
        
        public function TeleportEffect() {
            super();
        }
        
        override public function runNormalRendering(param1:int, param2:int) : Boolean {
            var _local_5:Number = NaN;
            var _local_6:Number = NaN;
            var _local_7:int = 0;
            var _local_8:TeleportParticle = null;
            var _local_3:int = 20;
            var _local_4:int = 0;
            while(_local_4 < _local_3) {
                _local_5 = 2 * Math.PI * Math.random();
                _local_6 = 0.7 * Math.random();
                _local_7 = 500 + 1000 * Math.random();
                _local_8 = new TeleportParticle(255,50,0.1,_local_7);
                map_.addObj(_local_8,x_ + _local_6 * Math.cos(_local_5),y_ + _local_6 * Math.sin(_local_5));
                _local_4++;
            }
            return false;
        }
        
        override public function runEasyRendering(param1:int, param2:int) : Boolean {
            var _local_5:Number = NaN;
            var _local_6:Number = NaN;
            var _local_7:int = 0;
            var _local_8:TeleportParticle = null;
            var _local_3:int = 10;
            var _local_4:int = 0;
            while(_local_4 < _local_3) {
                _local_5 = 2 * Math.PI * Math.random();
                _local_6 = 0.7 * Math.random();
                _local_7 = 5 + 500 * Math.random();
                _local_8 = new TeleportParticle(255,50,0.1,_local_7);
                map_.addObj(_local_8,x_ + _local_6 * Math.cos(_local_5),y_ + _local_6 * Math.sin(_local_5));
                _local_4++;
            }
            return false;
        }
    }
}

import com.company.assembleegameclient.objects.particles.Particle;
import flash.geom.Vector3D;

class TeleportParticle extends Particle {
     
    
    public var timeLeft_:int;
    
    protected var moveVec_:Vector3D;
    
    function TeleportParticle(param1:uint, param2:int, param3:Number, param4:int) {
        this.moveVec_ = new Vector3D();
        super(param1,0,param2);
        this.moveVec_.z = param3;
        this.timeLeft_ = param4;
    }
    
    override public function update(param1:int, param2:int) : Boolean {
        this.timeLeft_ = this.timeLeft_ - param2;
        if(this.timeLeft_ <= 0) {
            return false;
        }
        z_ = z_ + this.moveVec_.z * param2 * 0.008;
        return true;
    }
}
