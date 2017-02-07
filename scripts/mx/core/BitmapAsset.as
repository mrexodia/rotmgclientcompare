package mx.core {
    import flash.display.BitmapData;
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.system.ApplicationDomain;
    
    use namespace mx_internal;
    
    public class BitmapAsset extends FlexBitmap implements IFlexAsset, IFlexDisplayObject, ILayoutDirectionElement {
        
        mx_internal static const VERSION:String = "4.6.0.23201";
        
        private static var FlexVersionClass:Class;
        
        private static var MatrixUtilClass:Class;
         
        
        private var layoutFeaturesClass:Class;
        
        private var layoutFeatures:IAssetLayoutFeatures;
        
        private var _height:Number;
        
        private var _layoutDirection:String = "ltr";
        
        public function BitmapAsset(param1:BitmapData = null, param2:String = "auto", param3:Boolean = false) {
            var _local_4:ApplicationDomain = null;
            super(param1,param2,param3);
            if(FlexVersionClass == null) {
                _local_4 = ApplicationDomain.currentDomain;
                if(_local_4.hasDefinition("mx.core::FlexVersion")) {
                    FlexVersionClass = Class(_local_4.getDefinition("mx.core::FlexVersion"));
                }
            }
            if(FlexVersionClass && FlexVersionClass["compatibilityVersion"] >= FlexVersionClass["VERSION_4_0"]) {
                this.addEventListener(Event.ADDED,this.addedHandler);
            }
        }
        
        override public function get x() : Number {
            return this.layoutFeatures == null?Number(super.x):Number(this.layoutFeatures.layoutX);
        }
        
        override public function set x(param1:Number) : void {
            if(this.x == param1) {
                return;
            }
            if(this.layoutFeatures == null) {
                super.x = param1;
            } else {
                this.layoutFeatures.layoutX = param1;
                this.validateTransformMatrix();
            }
        }
        
        override public function get y() : Number {
            return this.layoutFeatures == null?Number(super.y):Number(this.layoutFeatures.layoutY);
        }
        
        override public function set y(param1:Number) : void {
            if(this.y == param1) {
                return;
            }
            if(this.layoutFeatures == null) {
                super.y = param1;
            } else {
                this.layoutFeatures.layoutY = param1;
                this.validateTransformMatrix();
            }
        }
        
        override public function get z() : Number {
            return this.layoutFeatures == null?Number(super.z):Number(this.layoutFeatures.layoutZ);
        }
        
        override public function set z(param1:Number) : void {
            if(this.z == param1) {
                return;
            }
            if(this.layoutFeatures == null) {
                super.z = param1;
            } else {
                this.layoutFeatures.layoutZ = param1;
                this.validateTransformMatrix();
            }
        }
        
        override public function get width() : Number {
            var _local_1:Point = null;
            if(this.layoutFeatures == null) {
                return super.width;
            }
            if(MatrixUtilClass != null) {
                _local_1 = MatrixUtilClass["transformSize"](this.layoutFeatures.layoutWidth,this._height,transform.matrix);
            }
            return !!_local_1?Number(_local_1.x):Number(super.width);
        }
        
        override public function set width(param1:Number) : void {
            if(this.width == param1) {
                return;
            }
            if(this.layoutFeatures == null) {
                super.width = param1;
            } else {
                this.layoutFeatures.layoutWidth = param1;
                this.layoutFeatures.layoutScaleX = this.measuredWidth != 0?Number(param1 / this.measuredWidth):Number(0);
                this.validateTransformMatrix();
            }
        }
        
        override public function get height() : Number {
            var _local_1:Point = null;
            if(this.layoutFeatures == null) {
                return super.height;
            }
            if(MatrixUtilClass != null) {
                _local_1 = MatrixUtilClass["transformSize"](this.layoutFeatures.layoutWidth,this._height,transform.matrix);
            }
            return !!_local_1?Number(_local_1.y):Number(super.height);
        }
        
        override public function set height(param1:Number) : void {
            if(this.height == param1) {
                return;
            }
            if(this.layoutFeatures == null) {
                super.height = param1;
            } else {
                this._height = param1;
                this.layoutFeatures.layoutScaleY = this.measuredHeight != 0?Number(param1 / this.measuredHeight):Number(0);
                this.validateTransformMatrix();
            }
        }
        
        override public function get rotationX() : Number {
            return this.layoutFeatures == null?Number(super.rotationX):Number(this.layoutFeatures.layoutRotationX);
        }
        
        override public function set rotationX(param1:Number) : void {
            if(this.rotationX == param1) {
                return;
            }
            if(this.layoutFeatures == null) {
                super.rotationX = param1;
            } else {
                this.layoutFeatures.layoutRotationX = param1;
                this.validateTransformMatrix();
            }
        }
        
        override public function get rotationY() : Number {
            return this.layoutFeatures == null?Number(super.rotationY):Number(this.layoutFeatures.layoutRotationY);
        }
        
        override public function set rotationY(param1:Number) : void {
            if(this.rotationY == param1) {
                return;
            }
            if(this.layoutFeatures == null) {
                super.rotationY = param1;
            } else {
                this.layoutFeatures.layoutRotationY = param1;
                this.validateTransformMatrix();
            }
        }
        
        override public function get rotationZ() : Number {
            return this.layoutFeatures == null?Number(super.rotationZ):Number(this.layoutFeatures.layoutRotationZ);
        }
        
        override public function set rotationZ(param1:Number) : void {
            if(this.rotationZ == param1) {
                return;
            }
            if(this.layoutFeatures == null) {
                super.rotationZ = param1;
            } else {
                this.layoutFeatures.layoutRotationZ = param1;
                this.validateTransformMatrix();
            }
        }
        
        override public function get rotation() : Number {
            return this.layoutFeatures == null?Number(super.rotation):Number(this.layoutFeatures.layoutRotationZ);
        }
        
        override public function set rotation(param1:Number) : void {
            if(this.rotation == param1) {
                return;
            }
            if(this.layoutFeatures == null) {
                super.rotation = param1;
            } else {
                this.layoutFeatures.layoutRotationZ = param1;
                this.validateTransformMatrix();
            }
        }
        
        override public function get scaleX() : Number {
            return this.layoutFeatures == null?Number(super.scaleX):Number(this.layoutFeatures.layoutScaleX);
        }
        
        override public function set scaleX(param1:Number) : void {
            if(this.scaleX == param1) {
                return;
            }
            if(this.layoutFeatures == null) {
                super.scaleX = param1;
            } else {
                this.layoutFeatures.layoutScaleX = param1;
                this.layoutFeatures.layoutWidth = Math.abs(param1) * this.measuredWidth;
                this.validateTransformMatrix();
            }
        }
        
        override public function get scaleY() : Number {
            return this.layoutFeatures == null?Number(super.scaleY):Number(this.layoutFeatures.layoutScaleY);
        }
        
        override public function set scaleY(param1:Number) : void {
            if(this.scaleY == param1) {
                return;
            }
            if(this.layoutFeatures == null) {
                super.scaleY = param1;
            } else {
                this.layoutFeatures.layoutScaleY = param1;
                this._height = Math.abs(param1) * this.measuredHeight;
                this.validateTransformMatrix();
            }
        }
        
        override public function get scaleZ() : Number {
            return this.layoutFeatures == null?Number(super.scaleZ):Number(this.layoutFeatures.layoutScaleZ);
        }
        
        override public function set scaleZ(param1:Number) : void {
            if(this.scaleZ == param1) {
                return;
            }
            if(this.layoutFeatures == null) {
                super.scaleZ = param1;
            } else {
                this.layoutFeatures.layoutScaleZ = param1;
                this.validateTransformMatrix();
            }
        }
        
        public function get layoutDirection() : String {
            return this._layoutDirection;
        }
        
        public function set layoutDirection(param1:String) : void {
            if(param1 == this._layoutDirection) {
                return;
            }
            this._layoutDirection = param1;
            this.invalidateLayoutDirection();
        }
        
        public function get measuredHeight() : Number {
            if(bitmapData) {
                return bitmapData.height;
            }
            return 0;
        }
        
        public function get measuredWidth() : Number {
            if(bitmapData) {
                return bitmapData.width;
            }
            return 0;
        }
        
        public function invalidateLayoutDirection() : void {
            var _local_2:Boolean = false;
            var _local_1:DisplayObjectContainer = parent;
            while(_local_1) {
                if(_local_1 is ILayoutDirectionElement) {
                    _local_2 = this._layoutDirection != null && ILayoutDirectionElement(_local_1).layoutDirection != null && this._layoutDirection != ILayoutDirectionElement(_local_1).layoutDirection;
                    if(_local_2 && this.layoutFeatures == null) {
                        this.initAdvancedLayoutFeatures();
                        if(this.layoutFeatures != null) {
                            this.layoutFeatures.mirror = _local_2;
                            this.validateTransformMatrix();
                        }
                    } else if(!_local_2 && this.layoutFeatures) {
                        this.layoutFeatures.mirror = _local_2;
                        this.validateTransformMatrix();
                        this.layoutFeatures = null;
                    }
                    break;
                }
                _local_1 = _local_1.parent;
            }
        }
        
        public function move(param1:Number, param2:Number) : void {
            this.x = param1;
            this.y = param2;
        }
        
        public function setActualSize(param1:Number, param2:Number) : void {
            this.width = param1;
            this.height = param2;
        }
        
        private function addedHandler(param1:Event) : void {
            this.invalidateLayoutDirection();
        }
        
        private function initAdvancedLayoutFeatures() : void {
            var _local_1:ApplicationDomain = null;
            var _local_2:IAssetLayoutFeatures = null;
            if(this.layoutFeaturesClass == null) {
                _local_1 = ApplicationDomain.currentDomain;
                if(_local_1.hasDefinition("mx.core::AdvancedLayoutFeatures")) {
                    this.layoutFeaturesClass = Class(_local_1.getDefinition("mx.core::AdvancedLayoutFeatures"));
                }
                if(MatrixUtilClass == null) {
                    if(_local_1.hasDefinition("mx.utils::MatrixUtil")) {
                        MatrixUtilClass = Class(_local_1.getDefinition("mx.utils::MatrixUtil"));
                    }
                }
            }
            if(this.layoutFeaturesClass != null) {
                _local_2 = new this.layoutFeaturesClass();
                _local_2.layoutScaleX = this.scaleX;
                _local_2.layoutScaleY = this.scaleY;
                _local_2.layoutScaleZ = this.scaleZ;
                _local_2.layoutRotationX = this.rotationX;
                _local_2.layoutRotationY = this.rotationY;
                _local_2.layoutRotationZ = this.rotation;
                _local_2.layoutX = this.x;
                _local_2.layoutY = this.y;
                _local_2.layoutZ = this.z;
                _local_2.layoutWidth = this.width;
                this._height = this.height;
                this.layoutFeatures = _local_2;
            }
        }
        
        private function validateTransformMatrix() : void {
            if(this.layoutFeatures != null) {
                if(this.layoutFeatures.is3D) {
                    super.transform.matrix3D = this.layoutFeatures.computedMatrix3D;
                } else {
                    super.transform.matrix = this.layoutFeatures.computedMatrix;
                }
            }
        }
    }
}
