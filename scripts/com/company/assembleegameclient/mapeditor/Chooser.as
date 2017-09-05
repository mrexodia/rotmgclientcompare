package com.company.assembleegameclient.mapeditor {
    import com.adobe.images.PNGEncoder;
    import com.company.assembleegameclient.ui.Scrollbar;
    import com.company.util.GraphicsUtil;
    import flash.display.BitmapData;
    import flash.display.CapsStyle;
    import flash.display.GraphicsPath;
    import flash.display.GraphicsSolidFill;
    import flash.display.GraphicsStroke;
    import flash.display.IGraphicsData;
    import flash.display.JointStyle;
    import flash.display.LineScaleMode;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.net.FileReference;
    import flash.utils.ByteArray;
    
    class Chooser extends Sprite {
        
        public static const WIDTH:int = 136;
        
        public static const HEIGHT:int = 430;
        
        private static const SCROLLBAR_WIDTH:int = 20;
         
        
        public var layer_:int;
        
        public var selected_:Element;
        
        protected var elementSprite_:Sprite;
        
        protected var scrollBar_:Scrollbar;
        
        private var mask_:Shape;
        
        private var elements_:Vector.<Element>;
        
        private var outlineFill_:GraphicsSolidFill;
        
        private var lineStyle_:GraphicsStroke;
        
        private var backgroundFill_:GraphicsSolidFill;
        
        private var path_:GraphicsPath;
        
        private const graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[this.lineStyle_,this.backgroundFill_,this.path_,GraphicsUtil.END_FILL,GraphicsUtil.END_STROKE];
        
        function Chooser(param1:int) {
            this.elements_ = new Vector.<Element>();
            this.outlineFill_ = new GraphicsSolidFill(16777215,1);
            this.lineStyle_ = new GraphicsStroke(1,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,this.outlineFill_);
            this.backgroundFill_ = new GraphicsSolidFill(3552822,1);
            this.path_ = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
            super();
            this.layer_ = param1;
            this.drawBackground();
            this.elementSprite_ = new Sprite();
            this.elementSprite_.x = 4;
            this.elementSprite_.y = 6;
            addChild(this.elementSprite_);
            this.scrollBar_ = new Scrollbar(SCROLLBAR_WIDTH,HEIGHT - 8,0.1,this);
            this.scrollBar_.x = WIDTH - SCROLLBAR_WIDTH - 6;
            this.scrollBar_.y = 4;
            this.scrollBar_.addEventListener(Event.CHANGE,this.onScrollBarChange);
            var _local_2:Shape = new Shape();
            _local_2.graphics.beginFill(0);
            _local_2.graphics.drawRect(0,2,Chooser.WIDTH - SCROLLBAR_WIDTH - 4,Chooser.HEIGHT - 4);
            addChild(_local_2);
            this.elementSprite_.mask = _local_2;
            addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
        }
        
        public function selectedType() : int {
            return this.selected_.type_;
        }
        
        public function setSelectedType(param1:int) : void {
            var _local_2:Element = null;
            for each(_local_2 in this.elements_) {
                if(_local_2.type_ == param1) {
                    this.setSelected(_local_2);
                    return;
                }
            }
        }
        
        protected function addElement(param1:Element) : void {
            var _local_2:int = 0;
            _local_2 = this.elements_.length;
            param1.x = _local_2 % 2 == 0?Number(0):Number(2 + Element.WIDTH);
            param1.y = int(_local_2 / 2) * Element.HEIGHT + 6;
            this.elementSprite_.addChild(param1);
            if(_local_2 == 0) {
                this.setSelected(param1);
            }
            param1.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            this.elements_.push(param1);
        }
        
        protected function removeElements() : void {
            this.elements_ = new Vector.<Element>();
            removeChild(this.elementSprite_);
            this.elementSprite_ = new Sprite();
            this.elementSprite_.x = 4;
            this.elementSprite_.y = 6;
            var _local_1:Shape = new Shape();
            _local_1.graphics.beginFill(0);
            _local_1.graphics.drawRect(0,2,Chooser.WIDTH - SCROLLBAR_WIDTH - 4,Chooser.HEIGHT - 4);
            addChild(_local_1);
            this.elementSprite_.mask = _local_1;
            addChild(this.elementSprite_);
        }
        
        protected function onMouseDown(param1:MouseEvent) : void {
            var _local_2:Element = param1.currentTarget as Element;
            if(_local_2.downloadOnly) {
                this.downloadElement(_local_2);
            } else {
                this.setSelected(_local_2);
            }
        }
        
        protected function setSelected(param1:Element) : void {
            if(this.selected_ != null) {
                this.selected_.setSelected(false);
            }
            this.selected_ = param1;
            this.selected_.setSelected(true);
        }
        
        private function downloadElement(param1:Element) : void {
            var _local_3:ByteArray = null;
            var _local_4:FileReference = null;
            var _local_2:BitmapData = param1.objectBitmap;
            if(_local_2 != null) {
                _local_3 = PNGEncoder.encode(param1.objectBitmap);
                _local_4 = new FileReference();
                _local_4.save(_local_3,param1.type_ + ".png");
            }
        }
        
        protected function onScrollBarChange(param1:Event) : void {
            this.elementSprite_.y = 6 - this.scrollBar_.pos() * (this.elementSprite_.height + 12 - HEIGHT);
        }
        
        protected function onAddedToStage(param1:Event) : void {
            this.scrollBar_.setIndicatorSize(HEIGHT,this.elementSprite_.height);
            addChild(this.scrollBar_);
        }
        
        protected function onRemovedFromStage(param1:Event) : void {
            removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
            removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
        }
        
        private function drawBackground() : void {
            GraphicsUtil.clearPath(this.path_);
            GraphicsUtil.drawCutEdgeRect(0,0,WIDTH,HEIGHT,4,[1,1,1,1],this.path_);
            graphics.drawGraphicsData(this.graphicsData_);
        }
    }
}
