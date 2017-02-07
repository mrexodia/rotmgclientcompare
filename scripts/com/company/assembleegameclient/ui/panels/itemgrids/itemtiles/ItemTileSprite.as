package com.company.assembleegameclient.ui.panels.itemgrids.itemtiles {
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.filters.ColorMatrixFilter;
    import flash.geom.Matrix;
    import kabam.rotmg.constants.ItemConstants;
    import kabam.rotmg.text.view.BitmapTextFactory;
    import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
    
    public class ItemTileSprite extends Sprite {
        
        protected static const DIM_FILTER:Array = [new ColorMatrixFilter([0.4,0,0,0,0,0,0.4,0,0,0,0,0,0.4,0,0,0,0,0,1,0])];
        
        private static const IDENTITY_MATRIX:Matrix = new Matrix();
        
        private static const DOSE_MATRIX:Matrix = function():Matrix {
            var _local_1:* = new Matrix();
            _local_1.translate(10,5);
            return _local_1;
        }();
         
        
        public var itemId:int;
        
        public var itemBitmap:Bitmap;
        
        private var bitmapFactory:BitmapTextFactory;
        
        public function ItemTileSprite() {
            super();
            this.itemBitmap = new Bitmap();
            addChild(this.itemBitmap);
            this.itemId = -1;
        }
        
        public function setDim(param1:Boolean) : void {
            filters = !!param1?DIM_FILTER:null;
        }
        
        public function setType(param1:int) : void {
            this.itemId = param1;
            this.drawTile();
        }
        
        public function drawTile() : void {
            var _local_2:BitmapData = null;
            var _local_3:XML = null;
            var _local_4:BitmapData = null;
            var _local_1:int = this.itemId;
            if(_local_1 != ItemConstants.NO_ITEM) {
                if(_local_1 >= 36864 && _local_1 < 61440) {
                    _local_1 = 36863;
                }
                _local_2 = ObjectLibrary.getRedrawnTextureFromType(_local_1,80,true);
                _local_3 = ObjectLibrary.xmlLibrary_[_local_1];
                if(_local_3 && _local_3.hasOwnProperty("Doses") && this.bitmapFactory) {
                    _local_2 = _local_2.clone();
                    _local_4 = this.bitmapFactory.make(new StaticStringBuilder(String(_local_3.Doses)),12,16777215,false,IDENTITY_MATRIX,false);
                    _local_2.draw(_local_4,DOSE_MATRIX);
                }
                if(_local_3 && _local_3.hasOwnProperty("Quantity") && this.bitmapFactory) {
                    _local_2 = _local_2.clone();
                    _local_4 = this.bitmapFactory.make(new StaticStringBuilder(String(_local_3.Quantity)),12,16777215,false,IDENTITY_MATRIX,false);
                    _local_2.draw(_local_4,DOSE_MATRIX);
                }
                this.itemBitmap.bitmapData = _local_2;
                this.itemBitmap.x = -_local_2.width / 2;
                this.itemBitmap.y = -_local_2.height / 2;
                visible = true;
            } else {
                visible = false;
            }
        }
        
        public function setBitmapFactory(param1:BitmapTextFactory) : void {
            this.bitmapFactory = param1;
        }
    }
}
