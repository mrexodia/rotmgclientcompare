package com.company.assembleegameclient.mapeditor {
    import com.company.assembleegameclient.map.GroundLibrary;
    import com.company.assembleegameclient.map.RegionLibrary;
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import com.company.util.AssetLibrary;
    import com.company.util.IntPoint;
    import com.company.util.KeyCodes;
    import com.company.util.PointUtil;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import flash.ui.Keyboard;
    import flash.utils.Dictionary;
    
    class MEMap extends Sprite {
        
        private static var transbackgroundEmbed_:Class = MEMap_transbackgroundEmbed_;
        
        private static var transbackgroundBD_:BitmapData = new transbackgroundEmbed_().bitmapData;
        
        public static const NUM_SQUARES:int = 512;
        
        public static const SQUARE_SIZE:int = 16;
        
        public static const SIZE:int = 512;
        
        public static const MIN_ZOOM:Number = 0.0625;
        
        public static const MAX_ZOOM:Number = 16;
         
        
        public var tileDict_:Dictionary;
        
        public var fullMap_:BigBitmapData;
        
        public var regionMap_:BitmapData;
        
        public var map_:BitmapData;
        
        public var overlay_:Shape;
        
        public var posT_:IntPoint;
        
        public var zoom_:Number = 1;
        
        private var mouseRectAnchorT_:IntPoint = null;
        
        private var mouseMoveAnchorT_:IntPoint = null;
        
        private var rectWidthOverride:int = 0;
        
        private var rectHeightOverride:int = 0;
        
        private var invisibleTexture_:BitmapData;
        
        private var replaceTexture_:BitmapData;
        
        public var anchorLock:Boolean = false;
        
        function MEMap() {
            this.tileDict_ = new Dictionary();
            this.fullMap_ = new BigBitmapData(NUM_SQUARES * SQUARE_SIZE,NUM_SQUARES * SQUARE_SIZE,true,0);
            this.regionMap_ = new BitmapDataSpy(NUM_SQUARES,NUM_SQUARES,true,0);
            this.map_ = new BitmapDataSpy(SIZE,SIZE,true,0);
            this.overlay_ = new Shape();
            super();
            graphics.beginBitmapFill(transbackgroundBD_,null,true);
            graphics.drawRect(0,0,SIZE,SIZE);
            addChild(new Bitmap(this.map_));
            addChild(this.overlay_);
            this.posT_ = new IntPoint(NUM_SQUARES / 2 - this.sizeInTiles() / 2,NUM_SQUARES / 2 - this.sizeInTiles() / 2);
            this.invisibleTexture_ = AssetLibrary.getImageFromSet("invisible",0);
            this.replaceTexture_ = AssetLibrary.getImageFromSet("lofiObj3",255);
            this.draw();
            addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
        }
        
        public function getType(param1:int, param2:int, param3:int) : int {
            var _local_4:METile = this.getTile(param1,param2);
            if(_local_4 == null) {
                return -1;
            }
            return _local_4.types_[param3];
        }
        
        public function getTile(param1:int, param2:int) : METile {
            return this.tileDict_[param1 + param2 * NUM_SQUARES];
        }
        
        public function modifyTile(param1:int, param2:int, param3:int, param4:int) : void {
            var _local_5:METile = this.getOrCreateTile(param1,param2);
            if(_local_5.types_[param3] == param4) {
                return;
            }
            _local_5.types_[param3] = param4;
            this.drawTile(param1,param2,_local_5);
        }
        
        public function getObjectName(param1:int, param2:int) : String {
            var _local_3:METile = this.getTile(param1,param2);
            if(_local_3 == null) {
                return null;
            }
            return _local_3.objName_;
        }
        
        public function modifyObjectName(param1:int, param2:int, param3:String) : void {
            var _local_4:METile = this.getOrCreateTile(param1,param2);
            _local_4.objName_ = param3;
        }
        
        public function getAllTiles() : Vector.<IntPoint> {
            var _local_2:* = null;
            var _local_3:int = 0;
            var _local_1:Vector.<IntPoint> = new Vector.<IntPoint>();
            for(_local_2 in this.tileDict_) {
                _local_3 = int(_local_2);
                _local_1.push(new IntPoint(_local_3 % NUM_SQUARES,_local_3 / NUM_SQUARES));
            }
            return _local_1;
        }
        
        public function setTile(param1:int, param2:int, param3:METile) : void {
            param3 = param3.clone();
            this.tileDict_[param1 + param2 * NUM_SQUARES] = param3;
            this.drawTile(param1,param2,param3);
        }
        
        public function eraseTile(param1:int, param2:int) : void {
            this.clearTile(param1,param2);
            this.drawTile(param1,param2,null);
        }
        
        public function clear() : void {
            var _local_1:* = null;
            var _local_2:int = 0;
            for(_local_1 in this.tileDict_) {
                _local_2 = int(_local_1);
                this.eraseTile(_local_2 % NUM_SQUARES,_local_2 / NUM_SQUARES);
            }
        }
        
        public function getTileBounds() : Rectangle {
            var _local_5:* = null;
            var _local_6:METile = null;
            var _local_7:int = 0;
            var _local_8:int = 0;
            var _local_9:int = 0;
            var _local_1:int = NUM_SQUARES;
            var _local_2:int = NUM_SQUARES;
            var _local_3:int = 0;
            var _local_4:int = 0;
            for(_local_5 in this.tileDict_) {
                _local_6 = this.tileDict_[_local_5];
                if(!_local_6.isEmpty()) {
                    _local_7 = int(_local_5);
                    _local_8 = _local_7 % NUM_SQUARES;
                    _local_9 = _local_7 / NUM_SQUARES;
                    if(_local_8 < _local_1) {
                        _local_1 = _local_8;
                    }
                    if(_local_9 < _local_2) {
                        _local_2 = _local_9;
                    }
                    if(_local_8 + 1 > _local_3) {
                        _local_3 = _local_8 + 1;
                    }
                    if(_local_9 + 1 > _local_4) {
                        _local_4 = _local_9 + 1;
                    }
                }
            }
            if(_local_1 > _local_3) {
                return null;
            }
            return new Rectangle(_local_1,_local_2,_local_3 - _local_1,_local_4 - _local_2);
        }
        
        private function sizeInTiles() : int {
            return SIZE / (SQUARE_SIZE * this.zoom_);
        }
        
        private function modifyZoom(param1:Number) : void {
            if(param1 > 1 && this.zoom_ >= MAX_ZOOM || param1 < 1 && this.zoom_ <= MIN_ZOOM) {
                return;
            }
            var _local_2:IntPoint = this.mousePosT();
            this.zoom_ = this.zoom_ * param1;
            var _local_3:IntPoint = this.mousePosT();
            this.movePosT(_local_2.x_ - _local_3.x_,_local_2.y_ - _local_3.y_);
        }
        
        private function canMove() : Boolean {
            return this.mouseRectAnchorT_ == null && this.mouseMoveAnchorT_ == null;
        }
        
        private function increaseZoom() : void {
            if(!this.canMove()) {
                return;
            }
            this.modifyZoom(2);
            this.draw();
        }
        
        private function decreaseZoom() : void {
            if(!this.canMove()) {
                return;
            }
            this.modifyZoom(0.5);
            this.draw();
        }
        
        private function moveLeft() : void {
            if(!this.canMove()) {
                return;
            }
            this.movePosT(-1,0);
            this.draw();
        }
        
        private function moveRight() : void {
            if(!this.canMove()) {
                return;
            }
            this.movePosT(1,0);
            this.draw();
        }
        
        private function moveUp() : void {
            if(!this.canMove()) {
                return;
            }
            this.movePosT(0,-1);
            this.draw();
        }
        
        private function moveDown() : void {
            if(!this.canMove()) {
                return;
            }
            this.movePosT(0,1);
            this.draw();
        }
        
        private function movePosT(param1:int, param2:int) : void {
            var _local_3:int = 0;
            var _local_4:int = NUM_SQUARES - this.sizeInTiles();
            this.posT_.x_ = Math.max(_local_3,Math.min(_local_4,this.posT_.x_ + param1));
            this.posT_.y_ = Math.max(_local_3,Math.min(_local_4,this.posT_.y_ + param2));
        }
        
        private function mousePosT() : IntPoint {
            var _local_1:int = Math.max(0,Math.min(SIZE - 1,mouseX));
            var _local_2:int = Math.max(0,Math.min(SIZE - 1,mouseY));
            return new IntPoint(this.posT_.x_ + _local_1 / (SQUARE_SIZE * this.zoom_),this.posT_.y_ + _local_2 / (SQUARE_SIZE * this.zoom_));
        }
        
        public function mouseRectT() : Rectangle {
            var _local_1:IntPoint = this.mousePosT();
            if(this.mouseRectAnchorT_ == null) {
                return new Rectangle(_local_1.x_,_local_1.y_,1,1);
            }
            return new Rectangle(Math.min(_local_1.x_,this.mouseRectAnchorT_.x_),Math.min(_local_1.y_,this.mouseRectAnchorT_.y_),Math.abs(_local_1.x_ - this.mouseRectAnchorT_.x_) + 1,Math.abs(_local_1.y_ - this.mouseRectAnchorT_.y_) + 1);
        }
        
        private function posTToPosP(param1:IntPoint) : IntPoint {
            return new IntPoint((param1.x_ - this.posT_.x_) * SQUARE_SIZE * this.zoom_,(param1.y_ - this.posT_.y_) * SQUARE_SIZE * this.zoom_);
        }
        
        private function sizeTToSizeP(param1:int) : Number {
            return param1 * this.zoom_ * SQUARE_SIZE;
        }
        
        private function mouseRectP() : Rectangle {
            var _local_1:Rectangle = this.mouseRectT();
            var _local_2:IntPoint = this.posTToPosP(new IntPoint(_local_1.x,_local_1.y));
            _local_1.x = _local_2.x_;
            _local_1.y = _local_2.y_;
            _local_1.width = this.sizeTToSizeP(_local_1.width) - 1;
            _local_1.height = this.sizeTToSizeP(_local_1.height) - 1;
            return _local_1;
        }
        
        private function onAddedToStage(param1:Event) : void {
            addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
            addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
            stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
            stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
        }
        
        private function onRemovedFromStage(param1:Event) : void {
            removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
            removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
            stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
        }
        
        private function onKeyDown(param1:KeyboardEvent) : void {
            switch(param1.keyCode) {
                case Keyboard.SHIFT:
                    if(this.mouseRectAnchorT_ != null) {
                        break;
                    }
                    this.mouseRectAnchorT_ = this.mousePosT();
                    break;
                case Keyboard.CONTROL:
                    if(this.mouseMoveAnchorT_ != null) {
                        break;
                    }
                    this.mouseMoveAnchorT_ = this.mousePosT();
                    break;
                case Keyboard.LEFT:
                    this.moveLeft();
                    break;
                case Keyboard.RIGHT:
                    this.moveRight();
                    break;
                case Keyboard.UP:
                    this.moveUp();
                    break;
                case Keyboard.DOWN:
                    this.moveDown();
                    break;
                case KeyCodes.MINUS:
                    this.decreaseZoom();
                    break;
                case KeyCodes.EQUAL:
                    this.increaseZoom();
            }
            this.draw();
        }
        
        private function onKeyUp(param1:KeyboardEvent) : void {
            switch(param1.keyCode) {
                case Keyboard.SHIFT:
                    this.mouseRectAnchorT_ = null;
                    break;
                case Keyboard.CONTROL:
                    this.mouseMoveAnchorT_ = null;
            }
            this.draw();
        }
        
        private function onMouseWheel(param1:MouseEvent) : void {
            if(param1.delta > 0) {
                this.increaseZoom();
            } else if(param1.delta < 0) {
                this.decreaseZoom();
            }
        }
        
        private function onMouseDown(param1:MouseEvent) : void {
            var _local_7:int = 0;
            var _local_2:Rectangle = this.mouseRectT();
            var _local_3:Vector.<IntPoint> = new Vector.<IntPoint>();
            var _local_4:int = Math.max(_local_2.x + this.rectWidthOverride,_local_2.right);
            var _local_5:int = Math.max(_local_2.y + this.rectHeightOverride,_local_2.bottom);
            var _local_6:int = _local_2.x;
            while(_local_6 < _local_4) {
                _local_7 = _local_2.y;
                while(_local_7 < _local_5) {
                    _local_3.push(new IntPoint(_local_6,_local_7));
                    _local_7++;
                }
                _local_6++;
            }
            dispatchEvent(new TilesEvent(_local_3));
        }
        
        public function freezeSelect() : void {
            var _local_1:Rectangle = this.mouseRectT();
            this.rectWidthOverride = _local_1.width;
            this.rectHeightOverride = _local_1.height;
        }
        
        public function clearSelect() : void {
            this.rectHeightOverride = 0;
            this.rectWidthOverride = 0;
        }
        
        private function onMouseMove(param1:MouseEvent) : void {
            var _local_2:IntPoint = null;
            if(!param1.shiftKey) {
                this.mouseRectAnchorT_ = null;
            } else if(this.mouseRectAnchorT_ == null) {
                this.mouseRectAnchorT_ = this.mousePosT();
            }
            if(!param1.ctrlKey) {
                this.mouseMoveAnchorT_ = null;
            } else if(this.mouseMoveAnchorT_ == null) {
                this.mouseMoveAnchorT_ = this.mousePosT();
            }
            if(param1.buttonDown) {
                dispatchEvent(new TilesEvent(new <IntPoint>[this.mousePosT()]));
            }
            if(this.mouseMoveAnchorT_ != null) {
                _local_2 = this.mousePosT();
                this.movePosT(this.mouseMoveAnchorT_.x_ - _local_2.x_,this.mouseMoveAnchorT_.y_ - _local_2.y_);
                this.draw();
            } else {
                this.drawOverlay();
            }
        }
        
        private function getOrCreateTile(param1:int, param2:int) : METile {
            var _local_3:int = param1 + param2 * NUM_SQUARES;
            var _local_4:METile = this.tileDict_[_local_3];
            if(_local_4 != null) {
                return _local_4;
            }
            _local_4 = new METile();
            this.tileDict_[_local_3] = _local_4;
            return _local_4;
        }
        
        private function clearTile(param1:int, param2:int) : void {
            delete this.tileDict_[param1 + param2 * NUM_SQUARES];
        }
        
        private function drawTile(param1:int, param2:int, param3:METile) : void {
            var _local_5:BitmapData = null;
            var _local_6:BitmapData = null;
            var _local_7:uint = 0;
            var _local_4:Rectangle = new Rectangle(param1 * SQUARE_SIZE,param2 * SQUARE_SIZE,SQUARE_SIZE,SQUARE_SIZE);
            this.fullMap_.erase(_local_4);
            this.regionMap_.setPixel32(param1,param2,0);
            if(param3 == null) {
                return;
            }
            if(param3.types_[Layer.GROUND] != -1) {
                _local_5 = GroundLibrary.getBitmapData(param3.types_[Layer.GROUND]);
                this.fullMap_.copyTo(_local_5,_local_5.rect,_local_4);
            }
            if(param3.types_[Layer.OBJECT] != -1) {
                _local_6 = ObjectLibrary.getTextureFromType(param3.types_[Layer.OBJECT]);
                if(_local_6 == null || _local_6 == this.invisibleTexture_) {
                    this.fullMap_.copyTo(this.replaceTexture_,this.replaceTexture_.rect,_local_4);
                } else {
                    this.fullMap_.copyTo(_local_6,_local_6.rect,_local_4);
                }
            }
            if(param3.types_[Layer.REGION] != -1) {
                _local_7 = RegionLibrary.getColor(param3.types_[Layer.REGION]);
                this.regionMap_.setPixel32(param1,param2,1593835520 | _local_7);
            }
        }
        
        private function drawOverlay() : void {
            var _local_1:Rectangle = this.mouseRectP();
            var _local_2:Graphics = this.overlay_.graphics;
            _local_2.clear();
            _local_2.lineStyle(1,16777215);
            _local_2.beginFill(16777215,0.1);
            _local_2.drawRect(_local_1.x,_local_1.y,_local_1.width,_local_1.height);
            _local_2.endFill();
            _local_2.lineStyle();
        }
        
        public function draw() : void {
            var _local_2:Matrix = null;
            var _local_3:int = 0;
            var _local_4:BitmapData = null;
            var _local_1:int = SIZE / this.zoom_;
            this.map_.fillRect(this.map_.rect,0);
            this.fullMap_.copyFrom(new Rectangle(this.posT_.x_ * SQUARE_SIZE,this.posT_.y_ * SQUARE_SIZE,_local_1,_local_1),this.map_,this.map_.rect);
            _local_2 = new Matrix();
            _local_2.identity();
            _local_3 = SQUARE_SIZE * this.zoom_;
            if(this.zoom_ > 2) {
                _local_4 = new BitmapDataSpy(SIZE / _local_3,SIZE / _local_3);
                _local_4.copyPixels(this.regionMap_,new Rectangle(this.posT_.x_,this.posT_.y_,_local_1,_local_1),PointUtil.ORIGIN);
                _local_2.scale(_local_3,_local_3);
                this.map_.draw(_local_4,_local_2);
            } else {
                _local_2.translate(-this.posT_.x_,-this.posT_.y_);
                _local_2.scale(_local_3,_local_3);
                this.map_.draw(this.regionMap_,_local_2,null,null,this.map_.rect);
            }
            this.drawOverlay();
        }
    }
}
