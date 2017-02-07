package com.company.assembleegameclient.objects.particles {
    import com.company.assembleegameclient.objects.GameObject;
    import flash.geom.Point;
    import kabam.rotmg.messaging.impl.data.WorldPosData;
    
    public class CollapseEffect extends ParticleEffect {
         
        
        public var center_:Point;
        
        public var edgePoint_:Point;
        
        public var color_:int;
        
        public function CollapseEffect(param1:GameObject, param2:WorldPosData, param3:WorldPosData, param4:int) {
            super();
            this.center_ = new Point(param2.x_,param2.y_);
            this.edgePoint_ = new Point(param3.x_,param3.y_);
            this.color_ = param4;
        }
        
        override public function runNormalRendering(param1:int, param2:int) : Boolean {
            var _local_8:Number = NaN;
            var _local_9:Point = null;
            var _local_10:Particle = null;
            x_ = this.center_.x;
            y_ = this.center_.y;
            var _local_3:Number = Point.distance(this.center_,this.edgePoint_);
            var _local_4:int = 300;
            var _local_5:int = 200;
            var _local_6:int = 24;
            var _local_7:int = 0;
            while(_local_7 < _local_6) {
                _local_8 = _local_7 * 2 * Math.PI / _local_6;
                _local_9 = new Point(this.center_.x + _local_3 * Math.cos(_local_8),this.center_.y + _local_3 * Math.sin(_local_8));
                _local_10 = new SparkerParticle(_local_4,this.color_,_local_5,_local_9,this.center_);
                map_.addObj(_local_10,x_,y_);
                _local_7++;
            }
            return false;
        }
        
        override public function runEasyRendering(param1:int, param2:int) : Boolean {
            var _local_8:Number = NaN;
            var _local_9:Point = null;
            var _local_10:Particle = null;
            x_ = this.center_.x;
            y_ = this.center_.y;
            var _local_3:Number = Point.distance(this.center_,this.edgePoint_);
            var _local_4:int = 50;
            var _local_5:int = 150;
            var _local_6:int = 8;
            var _local_7:int = 0;
            while(_local_7 < _local_6) {
                _local_8 = _local_7 * 2 * Math.PI / _local_6;
                _local_9 = new Point(this.center_.x + _local_3 * Math.cos(_local_8),this.center_.y + _local_3 * Math.sin(_local_8));
                _local_10 = new SparkerParticle(_local_4,this.color_,_local_5,_local_9,this.center_);
                map_.addObj(_local_10,x_,y_);
                _local_7++;
            }
            return false;
        }
    }
}
