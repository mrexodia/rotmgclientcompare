package com.company.assembleegameclient.objects.particles {
    import com.company.assembleegameclient.objects.GameObject;
    import flash.geom.Point;
    import kabam.rotmg.messaging.impl.data.WorldPosData;
    
    public class BurstEffect extends ParticleEffect {
         
        
        public var center_:Point;
        
        public var edgePoint_:Point;
        
        public var color_:int;
        
        public function BurstEffect(param1:GameObject, param2:WorldPosData, param3:WorldPosData, param4:int) {
            super();
            this.center_ = new Point(param2.x_,param2.y_);
            this.edgePoint_ = new Point(param3.x_,param3.y_);
            this.color_ = param4;
        }
        
        override public function runNormalRendering(param1:int, param2:int) : Boolean {
            var _local_7:Number = NaN;
            var _local_8:Point = null;
            var _local_9:Particle = null;
            x_ = this.center_.x;
            y_ = this.center_.y;
            var _local_3:Number = Point.distance(this.center_,this.edgePoint_);
            var _local_4:int = 100;
            var _local_5:int = 24;
            var _local_6:int = 0;
            while(_local_6 < _local_5) {
                _local_7 = _local_6 * 2 * Math.PI / _local_5;
                _local_8 = new Point(this.center_.x + _local_3 * Math.cos(_local_7),this.center_.y + _local_3 * Math.sin(_local_7));
                _local_9 = new SparkerParticle(_local_4,this.color_,100 + Math.random() * 200,this.center_,_local_8);
                map_.addObj(_local_9,x_,y_);
                _local_6++;
            }
            return false;
        }
        
        override public function runEasyRendering(param1:int, param2:int) : Boolean {
            var _local_7:Number = NaN;
            var _local_8:Point = null;
            var _local_9:Particle = null;
            x_ = this.center_.x;
            y_ = this.center_.y;
            var _local_3:Number = Point.distance(this.center_,this.edgePoint_);
            var _local_4:int = 10;
            var _local_5:int = 10;
            var _local_6:int = 0;
            while(_local_6 < _local_5) {
                _local_7 = _local_6 * 2 * Math.PI / _local_5;
                _local_8 = new Point(this.center_.x + _local_3 * Math.cos(_local_7),this.center_.y + _local_3 * Math.sin(_local_7));
                _local_9 = new SparkerParticle(_local_4,this.color_,50 + Math.random() * 20,this.center_,_local_8);
                map_.addObj(_local_9,x_,y_);
                _local_6++;
            }
            return false;
        }
    }
}
