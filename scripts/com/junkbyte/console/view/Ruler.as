package com.junkbyte.console.view {
    import com.junkbyte.console.Console;
    import com.junkbyte.console.ConsoleConfig;
    import com.junkbyte.console.ConsoleStyle;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.BlendMode;
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    import flash.ui.Mouse;
    
    public class Ruler extends Sprite {
         
        
        private var _master:Console;
        
        private var _config:ConsoleConfig;
        
        private var _area:Rectangle;
        
        private var _pointer:Shape;
        
        private var _posTxt:TextField;
        
        private var _zoom:Bitmap;
        
        private var _points:Array;
        
        public function Ruler(param1:Console) {
            super();
            this._master = param1;
            this._config = param1.config;
            buttonMode = true;
            this._points = new Array();
            this._pointer = new Shape();
            addChild(this._pointer);
            var _local_2:Point = new Point();
            _local_2 = globalToLocal(_local_2);
            this._area = new Rectangle(-param1.stage.stageWidth * 1.5 + _local_2.x,-param1.stage.stageHeight * 1.5 + _local_2.y,param1.stage.stageWidth * 3,param1.stage.stageHeight * 3);
            graphics.beginFill(this._config.style.backgroundColor,0.2);
            graphics.drawRect(this._area.x,this._area.y,this._area.width,this._area.height);
            graphics.endFill();
            this._posTxt = this._master.panels.mainPanel.makeTF("positionText",true);
            this._posTxt.autoSize = TextFieldAutoSize.LEFT;
            addChild(this._posTxt);
            this._zoom = new Bitmap();
            this._zoom.scaleY = this._zoom.scaleX = 2;
            addChild(this._zoom);
            addEventListener(MouseEvent.CLICK,this.onMouseClick,false,0,true);
            addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove,false,0,true);
            this.onMouseMove();
            if(this._config.rulerHidesMouse) {
                Mouse.hide();
            }
            this._master.report("<b>Ruler started. Click on two locations to measure.</b>",-1);
        }
        
        private function onMouseMove(param1:MouseEvent = null) : void {
            var m:Matrix = null;
            var e:MouseEvent = param1;
            this._pointer.graphics.clear();
            this._pointer.graphics.lineStyle(1,11193344,1);
            this._pointer.graphics.moveTo(this._area.x,mouseY);
            this._pointer.graphics.lineTo(this._area.x + this._area.width,mouseY);
            this._pointer.graphics.moveTo(mouseX,this._area.y);
            this._pointer.graphics.lineTo(mouseX,this._area.y + this._area.height);
            this._pointer.blendMode = BlendMode.INVERT;
            this._posTxt.text = "<low>" + mouseX + "," + mouseY + "</low>";
            var bmd:BitmapData = new BitmapData(30,30);
            try {
                m = new Matrix();
                m.tx = -stage.mouseX + 15;
                m.ty = -stage.mouseY + 15;
                bmd.draw(stage,m);
            }
            catch(err:Error) {
                bmd = null;
            }
            this._zoom.bitmapData = bmd;
            var d:int = 10;
            this._posTxt.x = mouseX - this._posTxt.width - d;
            this._posTxt.y = mouseY - this._posTxt.height - d;
            this._zoom.x = this._posTxt.x + this._posTxt.width - this._zoom.width;
            this._zoom.y = this._posTxt.y - this._zoom.height;
            if(this._posTxt.x < 16) {
                this._posTxt.x = mouseX + d;
                this._zoom.x = this._posTxt.x;
            }
            if(this._posTxt.y < 38) {
                this._posTxt.y = mouseY + d;
                this._zoom.y = this._posTxt.y + this._posTxt.height;
            }
        }
        
        private function onMouseClick(param1:MouseEvent) : void {
            var _local_2:Point = null;
            var _local_4:Point = null;
            var _local_5:Point = null;
            var _local_6:Point = null;
            var _local_7:Point = null;
            var _local_8:Point = null;
            var _local_9:Point = null;
            var _local_10:Number = NaN;
            var _local_11:Number = NaN;
            var _local_12:Number = NaN;
            var _local_13:TextField = null;
            var _local_14:Number = NaN;
            var _local_15:Number = NaN;
            param1.stopPropagation();
            var _local_3:ConsoleStyle = this._config.style;
            if(this._points.length == 0) {
                _local_2 = new Point(param1.localX,param1.localY);
                graphics.lineStyle(1,16711680);
                graphics.drawCircle(_local_2.x,_local_2.y,3);
                this._points.push(_local_2);
            } else if(this._points.length == 1) {
                this._zoom.bitmapData = null;
                if(this._config.rulerHidesMouse) {
                    Mouse.show();
                }
                removeChild(this._pointer);
                removeChild(this._posTxt);
                removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
                _local_2 = this._points[0];
                _local_4 = new Point(param1.localX,param1.localY);
                this._points.push(_local_4);
                graphics.clear();
                graphics.beginFill(_local_3.backgroundColor,0.4);
                graphics.drawRect(this._area.x,this._area.y,this._area.width,this._area.height);
                graphics.endFill();
                graphics.lineStyle(1.5,16711680);
                graphics.drawCircle(_local_2.x,_local_2.y,4);
                graphics.lineStyle(1.5,16750848);
                graphics.drawCircle(_local_4.x,_local_4.y,4);
                _local_5 = Point.interpolate(_local_2,_local_4,0.5);
                graphics.lineStyle(1,11184810);
                graphics.drawCircle(_local_5.x,_local_5.y,4);
                _local_6 = _local_2;
                _local_7 = _local_4;
                if(_local_2.x > _local_4.x) {
                    _local_6 = _local_4;
                    _local_7 = _local_2;
                }
                _local_8 = _local_2;
                _local_9 = _local_4;
                if(_local_2.y > _local_4.y) {
                    _local_8 = _local_4;
                    _local_9 = _local_2;
                }
                _local_10 = _local_7.x - _local_6.x;
                _local_11 = _local_9.y - _local_8.y;
                _local_12 = Point.distance(_local_2,_local_4);
                _local_13 = this.makeTxtField(_local_3.highColor);
                _local_13.text = this.round(_local_2.x) + "," + this.round(_local_2.y);
                _local_13.x = _local_2.x;
                _local_13.y = _local_2.y - (_local_8 == _local_2?14:0);
                addChild(_local_13);
                _local_13 = this.makeTxtField(_local_3.highColor);
                _local_13.text = this.round(_local_4.x) + "," + this.round(_local_4.y);
                _local_13.x = _local_4.x;
                _local_13.y = _local_4.y - (_local_8 == _local_4?14:0);
                addChild(_local_13);
                if(_local_10 > 40 || _local_11 > 25) {
                    _local_13 = this.makeTxtField(_local_3.lowColor);
                    _local_13.text = this.round(_local_5.x) + "," + this.round(_local_5.y);
                    _local_13.x = _local_5.x;
                    _local_13.y = _local_5.y;
                    addChild(_local_13);
                }
                graphics.lineStyle(1,11193344,0.5);
                graphics.moveTo(this._area.x,_local_8.y);
                graphics.lineTo(this._area.x + this._area.width,_local_8.y);
                graphics.moveTo(this._area.x,_local_9.y);
                graphics.lineTo(this._area.x + this._area.width,_local_9.y);
                graphics.moveTo(_local_6.x,this._area.y);
                graphics.lineTo(_local_6.x,this._area.y + this._area.height);
                graphics.moveTo(_local_7.x,this._area.y);
                graphics.lineTo(_local_7.x,this._area.y + this._area.height);
                _local_14 = this.round(this.angle(_local_2,_local_4),100);
                _local_15 = this.round(this.angle(_local_4,_local_2),100);
                graphics.lineStyle(1,11141120,0.8);
                this.drawCircleSegment(graphics,10,_local_2,_local_14,-90);
                graphics.lineStyle(1,13404160,0.8);
                this.drawCircleSegment(graphics,10,_local_4,_local_15,-90);
                graphics.lineStyle(2,65280,0.7);
                graphics.moveTo(_local_2.x,_local_2.y);
                graphics.lineTo(_local_4.x,_local_4.y);
                this._master.report("Ruler results: (red) <b>[" + _local_2.x + "," + _local_2.y + "]</b> to (orange) <b>[" + _local_4.x + "," + _local_4.y + "]</b>",-2);
                this._master.report("Distance: <b>" + this.round(_local_12,100) + "</b>",-2);
                this._master.report("Mid point: <b>[" + _local_5.x + "," + _local_5.y + "]</b>",-2);
                this._master.report("Width:<b>" + _local_10 + "</b>, Height: <b>" + _local_11 + "</b>",-2);
                this._master.report("Angle from first point (red): <b>" + _local_14 + "°</b>",-2);
                this._master.report("Angle from second point (orange): <b>" + _local_15 + "°</b>",-2);
            } else {
                this.exit();
            }
        }
        
        public function exit() : void {
            this._master = null;
            dispatchEvent(new Event(Event.COMPLETE));
        }
        
        private function makeTxtField(param1:Number, param2:Boolean = true) : TextField {
            var _local_3:TextFormat = new TextFormat(this._config.style.menuFont,this._config.style.menuFontSize,param1,param2,true,null,null,TextFormatAlign.RIGHT);
            var _local_4:TextField = new TextField();
            _local_4.autoSize = TextFieldAutoSize.RIGHT;
            _local_4.selectable = false;
            _local_4.defaultTextFormat = _local_3;
            return _local_4;
        }
        
        private function round(param1:Number, param2:uint = 10) : Number {
            return Math.round(param1 * param2) / param2;
        }
        
        private function angle(param1:Point, param2:Point) : Number {
            var _local_3:Number = Math.atan2(param2.y - param1.y,param2.x - param1.x) / Math.PI * 180;
            _local_3 = _local_3 + 90;
            if(_local_3 > 180) {
                _local_3 = _local_3 - 360;
            }
            return _local_3;
        }
        
        private function drawCircleSegment(param1:Graphics, param2:Number, param3:Point, param4:Number = 180, param5:Number = 0) : Point {
            var _local_12:Number = NaN;
            var _local_13:Number = NaN;
            var _local_14:Number = NaN;
            var _local_15:Point = null;
            var _local_6:Boolean = false;
            if(param4 < 0) {
                _local_6 = true;
                param4 = Math.abs(param4);
            }
            var _local_7:Number = param4 * Math.PI / 180;
            var _local_8:Number = param5 * Math.PI / 180;
            var _local_9:Point = this.getPointOnCircle(param2,_local_8);
            _local_9.offset(param3.x,param3.y);
            param1.moveTo(_local_9.x,_local_9.y);
            var _local_10:Number = 0;
            var _local_11:int = 1;
            while(_local_11 <= _local_7 + 1) {
                _local_12 = _local_11 <= _local_7?Number(_local_11):Number(_local_7);
                _local_13 = _local_12 - _local_10;
                _local_14 = 1 + 0.12 * _local_13 * _local_13;
                _local_15 = this.getPointOnCircle(param2 * _local_14,(_local_12 - _local_13 / 2) * (!!_local_6?-1:1) + _local_8);
                _local_15.offset(param3.x,param3.y);
                _local_9 = this.getPointOnCircle(param2,_local_12 * (!!_local_6?-1:1) + _local_8);
                _local_9.offset(param3.x,param3.y);
                param1.curveTo(_local_15.x,_local_15.y,_local_9.x,_local_9.y);
                _local_10 = _local_12;
                _local_11++;
            }
            return _local_9;
        }
        
        private function getPointOnCircle(param1:Number, param2:Number) : Point {
            return new Point(param1 * Math.cos(param2),param1 * Math.sin(param2));
        }
    }
}
