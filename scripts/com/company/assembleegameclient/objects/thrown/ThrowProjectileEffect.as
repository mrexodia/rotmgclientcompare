package com.company.assembleegameclient.objects.thrown {
    import com.company.assembleegameclient.objects.particles.ParticleEffect;
    import flash.geom.Point;
    
    public class ThrowProjectileEffect extends ParticleEffect {
         
        
        public var start_:Point;
        
        public var end_:Point;
        
        public var id_:uint;
        
        public function ThrowProjectileEffect(param1:int, param2:Point, param3:Point) {
            super();
            this.start_ = param2;
            this.end_ = param3;
            this.id_ = param1;
        }
        
        override public function update(param1:int, param2:int) : Boolean {
            x_ = this.start_.x;
            y_ = this.start_.y;
            var _local_3:int = 10000;
            var _local_4:ThrownProjectile = new ThrownProjectile(this.id_,1500,this.start_,this.end_);
            map_.addObj(_local_4,x_,y_);
            return false;
        }
    }
}
