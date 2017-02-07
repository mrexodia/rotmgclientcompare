package com.company.util {
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    public class Triangle {
         
        
        public var x0_:Number;
        
        public var y0_:Number;
        
        public var x1_:Number;
        
        public var y1_:Number;
        
        public var x2_:Number;
        
        public var y2_:Number;
        
        public var vx1_:Number;
        
        public var vy1_:Number;
        
        public var vx2_:Number;
        
        public var vy2_:Number;
        
        public function Triangle(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) {
            super();
            this.x0_ = param1;
            this.y0_ = param2;
            this.x1_ = param3;
            this.y1_ = param4;
            this.x2_ = param5;
            this.y2_ = param6;
            this.vx1_ = this.x1_ - this.x0_;
            this.vy1_ = this.y1_ - this.y0_;
            this.vx2_ = this.x2_ - this.x0_;
            this.vy2_ = this.y2_ - this.y0_;
        }
        
        public static function containsXY(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : Boolean {
            var _local_9:Number = param3 - param1;
            var _local_10:Number = param4 - param2;
            var _local_11:Number = param5 - param1;
            var _local_12:Number = param6 - param2;
            var _local_13:Number = (param7 * _local_12 - param8 * _local_11 - (param1 * _local_12 - param2 * _local_11)) / (_local_9 * _local_12 - _local_10 * _local_11);
            var _local_14:Number = -(param7 * _local_10 - param8 * _local_9 - (param1 * _local_10 - param2 * _local_9)) / (_local_9 * _local_12 - _local_10 * _local_11);
            return _local_13 >= 0 && _local_14 >= 0 && _local_13 + _local_14 <= 1;
        }
        
        public static function intersectTriAABB(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number) : Boolean {
            if(param7 > param1 && param7 > param3 && param7 > param5 || param9 < param1 && param9 < param3 && param9 < param5 || param8 > param2 && param8 > param4 && param8 > param6 || param10 < param2 && param10 < param4 && param10 < param6) {
                return false;
            }
            if(param7 < param1 && param1 < param9 && param8 < param2 && param2 < param10 || param7 < param3 && param3 < param9 && param8 < param4 && param4 < param10 || param7 < param5 && param5 < param9 && param8 < param6 && param6 < param10) {
                return true;
            }
            return lineRectIntersect(param1,param2,param3,param4,param7,param8,param9,param10) || lineRectIntersect(param3,param4,param5,param6,param7,param8,param9,param10) || lineRectIntersect(param5,param6,param1,param2,param7,param8,param9,param10);
        }
        
        private static function lineRectIntersect(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : Boolean {
            var _local_11:Number = NaN;
            var _local_12:Number = NaN;
            var _local_13:Number = NaN;
            var _local_14:Number = NaN;
            var _local_9:Number = (param4 - param2) / (param3 - param1);
            var _local_10:Number = param2 - _local_9 * param1;
            if(_local_9 > 0) {
                _local_11 = _local_9 * param5 + _local_10;
                _local_12 = _local_9 * param7 + _local_10;
            } else {
                _local_11 = _local_9 * param7 + _local_10;
                _local_12 = _local_9 * param5 + _local_10;
            }
            if(param2 < param4) {
                _local_13 = param2;
                _local_14 = param4;
            } else {
                _local_13 = param4;
                _local_14 = param2;
            }
            var _local_15:Number = _local_11 > _local_13?Number(_local_11):Number(_local_13);
            var _local_16:Number = _local_12 < _local_14?Number(_local_12):Number(_local_14);
            return _local_15 < _local_16 && !(_local_16 < param6 || _local_15 > param8);
        }
        
        public function aabb() : Rectangle {
            var _local_1:Number = Math.min(this.x0_,this.x1_,this.x2_);
            var _local_2:Number = Math.max(this.x0_,this.x1_,this.x2_);
            var _local_3:Number = Math.min(this.y0_,this.y1_,this.y2_);
            var _local_4:Number = Math.max(this.y0_,this.y1_,this.y2_);
            return new Rectangle(_local_1,_local_3,_local_2 - _local_1,_local_4 - _local_3);
        }
        
        public function area() : Number {
            return Math.abs((this.x0_ * (this.y1_ - this.y2_) + this.x1_ * (this.y2_ - this.y0_) + this.x2_ * (this.y0_ - this.y1_)) / 2);
        }
        
        public function incenter(param1:Point) : void {
            var _local_2:Number = PointUtil.distanceXY(this.x1_,this.y1_,this.x2_,this.y2_);
            var _local_3:Number = PointUtil.distanceXY(this.x0_,this.y0_,this.x2_,this.y2_);
            var _local_4:Number = PointUtil.distanceXY(this.x0_,this.y0_,this.x1_,this.y1_);
            param1.x = (_local_2 * this.x0_ + _local_3 * this.x1_ + _local_4 * this.x2_) / (_local_2 + _local_3 + _local_4);
            param1.y = (_local_2 * this.y0_ + _local_3 * this.y1_ + _local_4 * this.y2_) / (_local_2 + _local_3 + _local_4);
        }
        
        public function contains(param1:Number, param2:Number) : Boolean {
            var _local_3:Number = (param1 * this.vy2_ - param2 * this.vx2_ - (this.x0_ * this.vy2_ - this.y0_ * this.vx2_)) / (this.vx1_ * this.vy2_ - this.vy1_ * this.vx2_);
            var _local_4:Number = -(param1 * this.vy1_ - param2 * this.vx1_ - (this.x0_ * this.vy1_ - this.y0_ * this.vx1_)) / (this.vx1_ * this.vy2_ - this.vy1_ * this.vx2_);
            return _local_3 >= 0 && _local_4 >= 0 && _local_3 + _local_4 <= 1;
        }
        
        public function distance(param1:Number, param2:Number) : Number {
            if(this.contains(param1,param2)) {
                return 0;
            }
            return Math.min(LineSegmentUtil.pointDistance(param1,param2,this.x0_,this.y0_,this.x1_,this.y1_),LineSegmentUtil.pointDistance(param1,param2,this.x1_,this.y1_,this.x2_,this.y2_),LineSegmentUtil.pointDistance(param1,param2,this.x0_,this.y0_,this.x2_,this.y2_));
        }
        
        public function intersectAABB(param1:Number, param2:Number, param3:Number, param4:Number) : Boolean {
            return intersectTriAABB(this.x0_,this.y0_,this.x1_,this.y1_,this.x2_,this.y2_,param1,param2,param3,param4);
        }
    }
}
