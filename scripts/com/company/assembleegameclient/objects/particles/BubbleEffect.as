package com.company.assembleegameclient.objects.particles {
    import com.company.assembleegameclient.objects.GameObject;
    import com.company.assembleegameclient.util.FreeList;
    
    public class BubbleEffect extends ParticleEffect {
        
        private static const PERIOD_MAX:Number = 400;
         
        
        private var poolID:String;
        
        public var go_:GameObject;
        
        public var lastUpdate_:int = -1;
        
        public var rate_:Number;
        
        private var fxProps:EffectProperties;
        
        public function BubbleEffect(param1:GameObject, param2:EffectProperties) {
            super();
            this.go_ = param1;
            this.fxProps = param2;
            this.rate_ = (1 - param2.rate) * PERIOD_MAX + 1;
            this.poolID = "BubbleEffect_" + Math.random();
        }
        
        override public function update(param1:int, param2:int) : Boolean {
            var _local_3:int = 0;
            var _local_5:int = 0;
            var _local_6:Number = NaN;
            var _local_7:Number = NaN;
            var _local_9:Number = NaN;
            var _local_11:BubbleParticle = null;
            var _local_12:Number = NaN;
            var _local_13:Number = NaN;
            if(this.go_.map_ == null) {
                return false;
            }
            if(!this.lastUpdate_) {
                this.lastUpdate_ = param1;
                return true;
            }
            _local_3 = int(this.lastUpdate_ / this.rate_);
            var _local_4:int = int(param1 / this.rate_);
            var _local_8:Number = this.go_.x_;
            _local_9 = this.go_.y_;
            if(this.lastUpdate_ < 0) {
                this.lastUpdate_ = Math.max(0,param1 - PERIOD_MAX);
            }
            x_ = _local_8;
            y_ = _local_9;
            var _local_10:int = _local_3;
            while(_local_10 < _local_4) {
                _local_5 = _local_10 * this.rate_;
                _local_11 = BubbleParticle.create(this.poolID,this.fxProps.color,this.fxProps.speed,this.fxProps.life,this.fxProps.lifeVariance,this.fxProps.speedVariance,this.fxProps.spread);
                _local_11.restart(_local_5,param1);
                _local_6 = Math.random() * Math.PI;
                _local_7 = Math.random() * 0.4;
                _local_12 = _local_8 + _local_7 * Math.cos(_local_6);
                _local_13 = _local_9 + _local_7 * Math.sin(_local_6);
                map_.addObj(_local_11,_local_12,_local_13);
                _local_10++;
            }
            this.lastUpdate_ = param1;
            return true;
        }
        
        override public function removeFromMap() : void {
            super.removeFromMap();
            FreeList.dump(this.poolID);
        }
    }
}
