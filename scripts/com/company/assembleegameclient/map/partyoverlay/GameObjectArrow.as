package com.company.assembleegameclient.map.partyoverlay {
    import com.company.assembleegameclient.map.Camera;
    import com.company.assembleegameclient.objects.GameObject;
    import com.company.assembleegameclient.ui.menu.Menu;
    import com.company.assembleegameclient.ui.tooltip.ToolTip;
    import com.company.util.RectangleUtil;
    import com.company.util.Trig;
    import flash.display.DisplayObjectContainer;
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.filters.DropShadowFilter;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    public class GameObjectArrow extends Sprite {
        
        public static const SMALL_SIZE:int = 8;
        
        public static const BIG_SIZE:int = 11;
        
        public static const DIST:int = 3;
        
        private static var menu_:Menu = null;
         
        
        public var menuLayer:DisplayObjectContainer;
        
        public var lineColor_:uint;
        
        public var fillColor_:uint;
        
        public var go_:GameObject = null;
        
        public var extraGOs_:Vector.<GameObject>;
        
        public var mouseOver_:Boolean = false;
        
        private var big_:Boolean;
        
        private var arrow_:Shape;
        
        protected var tooltip_:ToolTip = null;
        
        private var tempPoint:Point;
        
        public function GameObjectArrow(param1:uint, param2:uint, param3:Boolean) {
            this.extraGOs_ = new Vector.<GameObject>();
            this.arrow_ = new Shape();
            this.tempPoint = new Point();
            super();
            this.lineColor_ = param1;
            this.fillColor_ = param2;
            this.big_ = param3;
            addChild(this.arrow_);
            this.drawArrow();
            addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
            addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
            addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            filters = [new DropShadowFilter(0,0,0,1,8,8)];
            visible = false;
        }
        
        public static function removeMenu() : void {
            if(menu_ != null) {
                if(menu_.parent != null) {
                    menu_.parent.removeChild(menu_);
                }
                menu_ = null;
            }
        }
        
        protected function onMouseOver(param1:MouseEvent) : void {
            this.mouseOver_ = true;
            this.drawArrow();
        }
        
        protected function onMouseOut(param1:MouseEvent) : void {
            this.mouseOver_ = false;
            this.drawArrow();
        }
        
        protected function onMouseDown(param1:MouseEvent) : void {
            param1.stopImmediatePropagation();
        }
        
        protected function setToolTip(param1:ToolTip) : void {
            this.removeTooltip();
            this.tooltip_ = param1;
            if(this.tooltip_ != null) {
                addChild(this.tooltip_);
                this.positionTooltip(this.tooltip_);
            }
        }
        
        protected function removeTooltip() : void {
            if(this.tooltip_ != null) {
                if(this.tooltip_.parent != null) {
                    this.tooltip_.parent.removeChild(this.tooltip_);
                }
                this.tooltip_ = null;
            }
        }
        
        protected function setMenu(param1:Menu) : void {
            this.removeTooltip();
            menu_ = param1;
            this.menuLayer.addChild(menu_);
        }
        
        public function setGameObject(param1:GameObject) : void {
            if(this.go_ != param1) {
                this.go_ = param1;
            }
            this.extraGOs_.length = 0;
            if(this.go_ == null) {
                visible = false;
            }
        }
        
        public function addGameObject(param1:GameObject) : void {
            this.extraGOs_.push(param1);
        }
        
        public function draw(param1:int, param2:Camera) : void {
            var _local_3:Rectangle = null;
            var _local_4:Number = NaN;
            var _local_5:Number = NaN;
            if(this.go_ == null) {
                visible = false;
                return;
            }
            this.go_.computeSortVal(param2);
            _local_3 = param2.clipRect_;
            _local_4 = this.go_.posS_[0];
            _local_5 = this.go_.posS_[1];
            if(!RectangleUtil.lineSegmentIntersectXY(param2.clipRect_,0,0,_local_4,_local_5,this.tempPoint)) {
                this.go_ = null;
                visible = false;
                return;
            }
            x = this.tempPoint.x;
            y = this.tempPoint.y;
            var _local_6:Number = Trig.boundTo180(270 - Trig.toDegrees * Math.atan2(_local_4,_local_5));
            if(this.tempPoint.x < _local_3.left + 5) {
                if(_local_6 > 45) {
                    _local_6 = 45;
                }
                if(_local_6 < -45) {
                    _local_6 = -45;
                }
            } else if(this.tempPoint.x > _local_3.right - 5) {
                if(_local_6 > 0) {
                    if(_local_6 < 135) {
                        _local_6 = 135;
                    }
                } else if(_local_6 > -135) {
                    _local_6 = -135;
                }
            }
            if(this.tempPoint.y < _local_3.top + 5) {
                if(_local_6 < 45) {
                    _local_6 = 45;
                }
                if(_local_6 > 135) {
                    _local_6 = 135;
                }
            } else if(this.tempPoint.y > _local_3.bottom - 5) {
                if(_local_6 > -45) {
                    _local_6 = -45;
                }
                if(_local_6 < -135) {
                    _local_6 = -135;
                }
            }
            this.arrow_.rotation = _local_6;
            if(this.tooltip_ != null) {
                this.positionTooltip(this.tooltip_);
            }
            visible = true;
        }
        
        private function positionTooltip(param1:ToolTip) : void {
            var _local_5:Number = NaN;
            var _local_8:Number = NaN;
            var _local_9:Number = NaN;
            var _local_2:Number = this.arrow_.rotation;
            var _local_3:int = DIST + BIG_SIZE + 12;
            var _local_4:Number = _local_3 * Math.cos(_local_2 * Trig.toRadians);
            _local_5 = _local_3 * Math.sin(_local_2 * Trig.toRadians);
            var _local_6:Number = param1.contentWidth_;
            var _local_7:Number = param1.contentHeight_;
            if(_local_2 >= 45 && _local_2 <= 135) {
                _local_8 = _local_4 + _local_6 / Math.tan(_local_2 * Trig.toRadians);
                param1.x = (_local_4 + _local_8) / 2 - _local_6 / 2;
                param1.y = _local_5;
            } else if(_local_2 <= -45 && _local_2 >= -135) {
                _local_8 = _local_4 - _local_6 / Math.tan(_local_2 * Trig.toRadians);
                param1.x = (_local_4 + _local_8) / 2 - _local_6 / 2;
                param1.y = _local_5 - _local_7;
            } else if(_local_2 < 45 && _local_2 > -45) {
                param1.x = _local_4;
                _local_9 = _local_5 + _local_7 * Math.tan(_local_2 * Trig.toRadians);
                param1.y = (_local_5 + _local_9) / 2 - _local_7 / 2;
            } else {
                param1.x = _local_4 - _local_6;
                _local_9 = _local_5 - _local_7 * Math.tan(_local_2 * Trig.toRadians);
                param1.y = (_local_5 + _local_9) / 2 - _local_7 / 2;
            }
        }
        
        private function drawArrow() : void {
            var _local_1:Graphics = this.arrow_.graphics;
            _local_1.clear();
            var _local_2:int = this.big_ || this.mouseOver_?int(BIG_SIZE):int(SMALL_SIZE);
            _local_1.lineStyle(1,this.lineColor_);
            _local_1.beginFill(this.fillColor_);
            _local_1.moveTo(DIST,0);
            _local_1.lineTo(_local_2 + DIST,_local_2);
            _local_1.lineTo(_local_2 + DIST,-_local_2);
            _local_1.lineTo(DIST,0);
            _local_1.endFill();
            _local_1.lineStyle();
        }
    }
}
