package com.company.assembleegameclient.objects.particles {
    import com.company.assembleegameclient.objects.GameObject;
    import com.company.assembleegameclient.util.RandomUtil;
    import flash.geom.Point;
    import kabam.rotmg.messaging.impl.data.WorldPosData;
    
    public class LineEffect extends ParticleEffect {
         
        
        public var start_:Point;
        
        public var end_:Point;
        
        public var color_:int;
        
        public function LineEffect(param1:GameObject, param2:WorldPosData, param3:int) {
            super();
            this.start_ = new Point(param1.x_,param1.y_);
            this.end_ = new Point(param2.x_,param2.y_);
            this.color_ = param3;
        }
        
        override public function runNormalRendering(param1:int, param2:int) : Boolean {
            var _local_5:Point = null;
            var _local_6:Particle = null;
            x_ = this.start_.x;
            y_ = this.start_.y;
            var _local_3:int = 30;
            var _local_4:int = 0;
            while(_local_4 < _local_3) {
                _local_5 = Point.interpolate(this.start_,this.end_,_local_4 / _local_3);
                _local_6 = new SparkParticle(100,this.color_,700,0.5,RandomUtil.plusMinus(1),RandomUtil.plusMinus(1));
                map_.addObj(_local_6,_local_5.x,_local_5.y);
                _local_4++;
            }
            return false;
        }
        
        override public function runEasyRendering(param1:int, param2:int) : Boolean {
            var _local_5:Point = null;
            var _local_6:Particle = null;
            x_ = this.start_.x;
            y_ = this.start_.y;
            var _local_3:int = 5;
            var _local_4:int = 0;
            while(_local_4 < _local_3) {
                _local_5 = Point.interpolate(this.start_,this.end_,_local_4 / _local_3);
                _local_6 = new SparkParticle(100,this.color_,200,0.5,RandomUtil.plusMinus(1),RandomUtil.plusMinus(1));
                map_.addObj(_local_6,_local_5.x,_local_5.y);
                _local_4++;
            }
            return false;
        }
    }
}
