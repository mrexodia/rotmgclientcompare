package com.company.assembleegameclient.tutorial {
    import com.company.util.ConversionUtil;
    import flash.display.Graphics;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    public class UIDrawBox {
         
        
        public var rect_:Rectangle;
        
        public var color_:uint;
        
        public const ANIMATION_MS:int = 500;
        
        public const ORIGIN:Point = new Point(250,200);
        
        public function UIDrawBox(param1:XML) {
            super();
            this.rect_ = ConversionUtil.toRectangle(param1);
            this.color_ = uint(param1.@color);
        }
        
        public function draw(param1:int, param2:Graphics, param3:int) : void {
            var _local_4:Number = NaN;
            var _local_5:Number = NaN;
            var _local_6:Number = this.rect_.width - param1;
            var _local_7:Number = this.rect_.height - param1;
            if(param3 < this.ANIMATION_MS) {
                _local_4 = this.ORIGIN.x + (this.rect_.x - this.ORIGIN.x) * param3 / this.ANIMATION_MS;
                _local_5 = this.ORIGIN.y + (this.rect_.y - this.ORIGIN.y) * param3 / this.ANIMATION_MS;
                _local_6 = _local_6 * (param3 / this.ANIMATION_MS);
                _local_7 = _local_7 * (param3 / this.ANIMATION_MS);
            } else {
                _local_4 = this.rect_.x + param1 / 2;
                _local_5 = this.rect_.y + param1 / 2;
            }
            param2.lineStyle(param1,this.color_);
            param2.drawRect(_local_4,_local_5,_local_6,_local_7);
        }
    }
}
