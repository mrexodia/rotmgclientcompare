package com.company.util {
    import flash.geom.Matrix;
    import flash.geom.Point;
    
    public class IntPoint {
         
        
        public var x_:int;
        
        public var y_:int;
        
        public function IntPoint(param1:int = 0, param2:int = 0) {
            super();
            this.x_ = param1;
            this.y_ = param2;
        }
        
        public static function unitTest() : void {
            var _local_1:UnitTest = new UnitTest#2784();
        }
        
        public static function fromPoint(param1:Point) : IntPoint {
            return new IntPoint(Math.round(param1.x),Math.round(param1.y));
        }
        
        public function x() : int {
            return this.x_;
        }
        
        public function y() : int {
            return this.y_;
        }
        
        public function setX(param1:int) : void {
            this.x_ = param1;
        }
        
        public function setY(param1:int) : void {
            this.y_ = param1;
        }
        
        public function clone() : IntPoint {
            return new IntPoint(this.x_,this.y_);
        }
        
        public function same(param1:IntPoint) : Boolean {
            return this.x_ == param1.x_ && this.y_ == param1.y_;
        }
        
        public function distanceAsInt(param1:IntPoint) : int {
            var _local_2:int = param1.x_ - this.x_;
            var _local_3:int = param1.y_ - this.y_;
            return Math.round(Math.sqrt(_local_2 * _local_2 + _local_3 * _local_3));
        }
        
        public function distanceAsNumber(param1:IntPoint) : Number {
            var _local_2:int = param1.x_ - this.x_;
            var _local_3:int = param1.y_ - this.y_;
            return Math.sqrt(_local_2 * _local_2 + _local_3 * _local_3);
        }
        
        public function distanceToPoint(param1:Point) : Number {
            var _local_2:int = param1.x - this.x_;
            var _local_3:int = param1.y - this.y_;
            return Math.sqrt(_local_2 * _local_2 + _local_3 * _local_3);
        }
        
        public function trunc1000() : IntPoint {
            return new IntPoint(int(this.x_ / 1000) * 1000,int(this.y_ / 1000) * 1000);
        }
        
        public function round1000() : IntPoint {
            return new IntPoint(Math.round(this.x_ / 1000) * 1000,Math.round(this.y_ / 1000) * 1000);
        }
        
        public function distanceSquared(param1:IntPoint) : int {
            var _local_2:int = param1.x() - this.x_;
            var _local_3:int = param1.y() - this.y_;
            return _local_2 * _local_2 + _local_3 * _local_3;
        }
        
        public function toPoint() : Point {
            return new Point(this.x_,this.y_);
        }
        
        public function transform(param1:Matrix) : IntPoint {
            var _local_2:Point = param1.transformPoint(this.toPoint());
            return new IntPoint(Math.round(_local_2.x),Math.round(_local_2.y));
        }
        
        public function toString() : String {
            return "(" + this.x_ + ", " + this.y_ + ")";
        }
    }
}

import com.company.util.IntPoint;

class UnitTest#2784 {
     
    
    function UnitTest#2784() {
        var _local_1:IntPoint = null;
        var _local_2:IntPoint = null;
        var _local_3:Number = NaN;
        super();
        trace("STARTING UNITTEST: IntPoint");
        _local_1 = new IntPoint(999,1001);
        _local_2 = _local_1.round1000();
        if(_local_2.x() != 1000 || _local_2.y() != 1000) {
            trace("ERROR IN UNITTEST: IntPoint1");
        }
        _local_1 = new IntPoint(500,400);
        _local_2 = _local_1.round1000();
        if(_local_2.x() != 1000 || _local_2.y() != 0) {
            trace("ERROR IN UNITTEST: IntPoint2");
        }
        _local_1 = new IntPoint(-400,-500);
        _local_2 = _local_1.round1000();
        if(_local_2.x() != 0 || _local_2.y() != 0) {
            trace("ERROR IN UNITTEST: IntPoint3");
        }
        _local_1 = new IntPoint(-501,-999);
        _local_2 = _local_1.round1000();
        if(_local_2.x() != -1000 || _local_2.y() != -1000) {
            trace("ERROR IN UNITTEST: IntPoint4");
        }
        _local_1 = new IntPoint(-1000,-1001);
        _local_2 = _local_1.round1000();
        if(_local_2.x() != -1000 || _local_2.y() != -1000) {
            trace("ERROR IN UNITTEST: IntPoint5");
        }
        _local_1 = new IntPoint(999,1001);
        _local_2 = _local_1.trunc1000();
        if(_local_2.x() != 0 || _local_2.y() != 1000) {
            trace("ERROR IN UNITTEST: IntPoint6");
        }
        _local_1 = new IntPoint(500,400);
        _local_2 = _local_1.trunc1000();
        if(_local_2.x() != 0 || _local_2.y() != 0) {
            trace("ERROR IN UNITTEST: IntPoint7");
        }
        _local_1 = new IntPoint(-400,-500);
        _local_2 = _local_1.trunc1000();
        if(_local_2.x() != 0 || _local_2.y() != 0) {
            trace("ERROR IN UNITTEST: IntPoint8");
        }
        _local_1 = new IntPoint(-501,-999);
        _local_2 = _local_1.trunc1000();
        if(_local_2.x() != 0 || _local_2.y() != 0) {
            trace("ERROR IN UNITTEST: IntPoint9");
        }
        _local_1 = new IntPoint(-1000,-1001);
        _local_2 = _local_1.trunc1000();
        if(_local_2.x() != -1000 || _local_2.y() != -1000) {
            trace("ERROR IN UNITTEST: IntPoint10");
        }
        _local_3 = 0.9999998;
        if(int(_local_3) != 0) {
            trace("ERROR IN UNITTEST: IntPoint40");
        }
        _local_3 = 0.5;
        if(int(_local_3) != 0) {
            trace("ERROR IN UNITTEST: IntPoint41");
        }
        _local_3 = 0.499999;
        if(int(_local_3) != 0) {
            trace("ERROR IN UNITTEST: IntPoint42");
        }
        _local_3 = -0.499999;
        if(int(_local_3) != 0) {
            trace("ERROR IN UNITTEST: IntPoint43");
        }
        _local_3 = -0.5;
        if(int(_local_3) != 0) {
            trace("ERROR IN UNITTEST: IntPoint44");
        }
        _local_3 = -0.99999;
        if(int(_local_3) != 0) {
            trace("ERROR IN UNITTEST: IntPoint45");
        }
        trace("FINISHED UNITTEST: IntPoint");
    }
}
