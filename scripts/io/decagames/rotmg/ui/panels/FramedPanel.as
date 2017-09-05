package io.decagames.rotmg.ui.panels {
    import flash.display.Sprite;
    import flash.filters.BitmapFilterQuality;
    import flash.filters.GlowFilter;
    import io.decagames.rotmg.utils.colors.AlphaColor;
    
    public class FramedPanel extends Sprite {
         
        
        public function FramedPanel(param1:int, param2:int, param3:int, param4:AlphaColor, param5:AlphaColor) {
            super();
            this.drawBackground(param1,param2,param4,param5,param3);
        }
        
        private function drawBackground(param1:int, param2:int, param3:AlphaColor, param4:AlphaColor, param5:int) : void {
            var _local_6:Sprite = new Sprite();
            _local_6.graphics.beginFill(param4.color,param4.alpha);
            _local_6.graphics.drawRect(0,0,param1,param2);
            _local_6.graphics.endFill();
            _local_6.filters = [new GlowFilter(param3.color,param3.alpha,param5 * 2,param5 * 2,255,BitmapFilterQuality.LOW)];
            _local_6.cacheAsBitmap = true;
            addChild(_local_6);
        }
    }
}
