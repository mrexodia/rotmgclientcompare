package io.decagames.rotmg.utils.display {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    
    public class ScaleBitmap extends Bitmap {
         
        
        protected var _originalBitmap:BitmapData;
        
        protected var _scale9Grid:Rectangle = null;
        
        public function ScaleBitmap(param1:BitmapData = null, param2:String = "auto", param3:Boolean = false) {
            super(param1,param2,param3);
            this._originalBitmap = param1.clone();
        }
        
        override public function set bitmapData(param1:BitmapData) : void {
            this._originalBitmap = param1.clone();
            if(this._scale9Grid != null) {
                if(!this.validGrid(this._scale9Grid)) {
                    this._scale9Grid = null;
                }
                this.setSize(param1.width,param1.height);
            } else {
                this.assignBitmapData(this._originalBitmap.clone());
            }
        }
        
        override public function set width(param1:Number) : void {
            if(param1 != width) {
                this.setSize(param1,height);
            }
        }
        
        override public function set height(param1:Number) : void {
            if(param1 != height) {
                this.setSize(width,param1);
            }
        }
        
        override public function set scale9Grid(param1:Rectangle) : void {
            var _local_2:Number = NaN;
            var _local_3:Number = NaN;
            if(this._scale9Grid == null && param1 != null || this._scale9Grid != null && !this._scale9Grid.equals(param1)) {
                if(param1 == null) {
                    _local_2 = width;
                    _local_3 = height;
                    this._scale9Grid = null;
                    this.assignBitmapData(this._originalBitmap.clone());
                    this.setSize(_local_2,_local_3);
                } else {
                    if(!this.validGrid(param1)) {
                        throw new Error("#001 - The _scale9Grid does not match the original BitmapData");
                    }
                    this._scale9Grid = param1.clone();
                    this.resizeBitmap(width,height);
                    scaleX = 1;
                    scaleY = 1;
                }
            }
        }
        
        private function assignBitmapData(param1:BitmapData) : void {
            super.bitmapData.dispose();
            super.bitmapData = param1;
        }
        
        private function validGrid(param1:Rectangle) : Boolean {
            return param1.right <= this._originalBitmap.width && param1.bottom <= this._originalBitmap.height;
        }
        
        override public function get scale9Grid() : Rectangle {
            return this._scale9Grid;
        }
        
        public function setSize(param1:Number, param2:Number) : void {
            if(this._scale9Grid == null) {
                super.width = param1;
                super.height = param2;
            } else {
                param1 = Math.max(param1,this._originalBitmap.width - this._scale9Grid.width);
                param2 = Math.max(param2,this._originalBitmap.height - this._scale9Grid.height);
                this.resizeBitmap(param1,param2);
            }
        }
        
        public function getOriginalBitmapData() : BitmapData {
            return this._originalBitmap;
        }
        
        protected function resizeBitmap(param1:Number, param2:Number) : void {
            var _local_8:Rectangle = null;
            var _local_9:Rectangle = null;
            var _local_12:int = 0;
            var _local_3:BitmapData = new BitmapData(param1,param2,true,0);
            var _local_4:Array = [0,this._scale9Grid.top,this._scale9Grid.bottom,this._originalBitmap.height];
            var _local_5:Array = [0,this._scale9Grid.left,this._scale9Grid.right,this._originalBitmap.width];
            var _local_6:Array = [0,this._scale9Grid.top,param2 - (this._originalBitmap.height - this._scale9Grid.bottom),param2];
            var _local_7:Array = [0,this._scale9Grid.left,param1 - (this._originalBitmap.width - this._scale9Grid.right),param1];
            var _local_10:Matrix = new Matrix();
            var _local_11:int = 0;
            while(_local_11 < 3) {
                _local_12 = 0;
                while(_local_12 < 3) {
                    _local_8 = new Rectangle(_local_5[_local_11],_local_4[_local_12],_local_5[_local_11 + 1] - _local_5[_local_11],_local_4[_local_12 + 1] - _local_4[_local_12]);
                    _local_9 = new Rectangle(_local_7[_local_11],_local_6[_local_12],_local_7[_local_11 + 1] - _local_7[_local_11],_local_6[_local_12 + 1] - _local_6[_local_12]);
                    _local_10.identity();
                    _local_10.a = _local_9.width / _local_8.width;
                    _local_10.d = _local_9.height / _local_8.height;
                    _local_10.tx = _local_9.x - _local_8.x * _local_10.a;
                    _local_10.ty = _local_9.y - _local_8.y * _local_10.d;
                    _local_3.draw(this._originalBitmap,_local_10,null,null,_local_9,smoothing);
                    _local_12++;
                }
                _local_11++;
            }
            this.assignBitmapData(_local_3);
        }
    }
}
