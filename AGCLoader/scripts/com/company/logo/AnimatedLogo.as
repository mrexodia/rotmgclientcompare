package com.company.logo {
    import com.company.rotmg.graphics.logo.Clouds;
    import com.company.rotmg.graphics.logo.Guy;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.BitmapDataChannel;
    import flash.display.BlendMode;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.ColorTransform;
    import flash.geom.Point;
    import flash.utils.getTimer;
    
    public class AnimatedLogo extends Sprite {
        
        private static const PERIOD:int = 2000;
         
        
        private var background_:Bitmap;
        
        private var overlay_:Sprite;
        
        private var startTime_:int = -1;
        
        public function AnimatedLogo() {
            super();
            this.background_ = getBackground();
            this.overlay_ = getOverlay();
            addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
        }
        
        private static function getBackground() : Bitmap {
            var _local_1:BitmapData = new BitmapData(256,256,false,4278190080);
            var _local_2:int = Math.random() * int.MAX_VALUE;
            _local_1.perlinNoise(_local_1.width,_local_1.height,8,_local_2,true,false,BitmapDataChannel.RED | BitmapDataChannel.GREEN | BitmapDataChannel.BLUE,true,null);
            var _local_3:ColorTransform = new ColorTransform(2,2,2,1,0,0,0,0);
            _local_1.colorTransform(_local_1.rect,_local_3);
            var _local_4:BitmapData = new BitmapData(_local_1.width * 2,_local_1.height,false);
            _local_4.copyPixels(_local_1,_local_1.rect,new Point(0,0));
            _local_4.copyPixels(_local_1,_local_1.rect,new Point(_local_1.width,0));
            _local_1.dispose();
            return new Bitmap(_local_4);
        }
        
        private static function getOverlay() : Sprite {
            var _local_1:Sprite = new Sprite();
            _local_1.blendMode = BlendMode.LAYER;
            _local_1.addChild(new Clouds());
            var _local_2:Guy = new Guy();
            _local_2.x = _local_1.width / 2 - _local_2.width / 2;
            _local_2.y = _local_1.height / 2 - _local_2.height / 2;
            _local_2.blendMode = BlendMode.ERASE;
            _local_1.addChild(_local_2);
            _local_1.x = 800 / 2 - _local_1.width / 2;
            _local_1.y = 600 / 2 - _local_1.height / 2;
            _local_1.blendMode = BlendMode.ERASE;
            var _local_3:Sprite = new Sprite();
            _local_3.blendMode = BlendMode.LAYER;
            _local_3.graphics.beginFill(0,1);
            _local_3.graphics.drawRect(0,0,800,600);
            _local_3.graphics.endFill();
            _local_3.addChild(_local_1);
            return _local_3;
        }
        
        private function onAddedToStage(param1:Event) : void {
            addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
        }
        
        private function onRemovedFromStage(param1:Event) : void {
            removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
        }
        
        private function onEnterFrame(param1:Event) : void {
            this.moveBackground();
        }
        
        private function moveBackground() : void {
            var _local_1:int = getTimer();
            if(this.startTime_ == -1) {
                this.startTime_ = _local_1;
                addChild(this.background_);
                addChild(this.overlay_);
            }
            var _local_2:Number = (_local_1 - this.startTime_) % PERIOD / PERIOD;
            this.background_.x = 256 * _local_2;
            this.background_.y = 600 / 2 - this.background_.height / 2;
        }
    }
}
