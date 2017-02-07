package com.company.assembleegameclient.mapeditor {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    
    public class BigBitmapData {
        
        private static const CHUNK_SIZE:int = 256;
         
        
        public var width_:int;
        
        public var height_:int;
        
        public var fillColor_:uint;
        
        private var maxChunkX_:int;
        
        private var maxChunkY_:int;
        
        private var chunks_:Vector.<BitmapData>;
        
        public function BigBitmapData(param1:int, param2:int, param3:Boolean, param4:uint) {
            var _local_6:int = 0;
            var _local_7:int = 0;
            var _local_8:int = 0;
            super();
            this.width_ = param1;
            this.height_ = param2;
            this.fillColor_ = param4;
            this.maxChunkX_ = Math.ceil(this.width_ / CHUNK_SIZE);
            this.maxChunkY_ = Math.ceil(this.height_ / CHUNK_SIZE);
            this.chunks_ = new Vector.<BitmapData>(this.maxChunkX_ * this.maxChunkY_,true);
            var _local_5:int = 0;
            while(_local_5 < this.maxChunkX_) {
                _local_6 = 0;
                while(_local_6 < this.maxChunkY_) {
                    _local_7 = Math.min(CHUNK_SIZE,this.width_ - _local_5 * CHUNK_SIZE);
                    _local_8 = Math.min(CHUNK_SIZE,this.height_ - _local_6 * CHUNK_SIZE);
                    this.chunks_[_local_5 + _local_6 * this.maxChunkX_] = new BitmapDataSpy(_local_7,_local_8,param3,this.fillColor_);
                    _local_6++;
                }
                _local_5++;
            }
        }
        
        public function copyTo(param1:BitmapData, param2:Rectangle, param3:Rectangle) : void {
            var _local_12:int = 0;
            var _local_13:BitmapData = null;
            var _local_14:Rectangle = null;
            var _local_4:Number = param3.width / param2.width;
            var _local_5:Number = param3.height / param2.height;
            var _local_6:int = int(param3.x / CHUNK_SIZE);
            var _local_7:int = int(param3.y / CHUNK_SIZE);
            var _local_8:int = Math.ceil(param3.right / CHUNK_SIZE);
            var _local_9:int = Math.ceil(param3.bottom / CHUNK_SIZE);
            var _local_10:Matrix = new Matrix();
            var _local_11:int = _local_6;
            while(_local_11 < _local_8) {
                _local_12 = _local_7;
                while(_local_12 < _local_9) {
                    _local_13 = this.chunks_[_local_11 + _local_12 * this.maxChunkX_];
                    _local_10.identity();
                    _local_10.scale(_local_4,_local_5);
                    _local_10.translate(param3.x - _local_11 * CHUNK_SIZE - param2.x * _local_4,param3.y - _local_12 * CHUNK_SIZE - param2.x * _local_5);
                    _local_14 = new Rectangle(param3.x - _local_11 * CHUNK_SIZE,param3.y - _local_12 * CHUNK_SIZE,param3.width,param3.height);
                    _local_13.draw(param1,_local_10,null,null,_local_14,false);
                    _local_12++;
                }
                _local_11++;
            }
        }
        
        public function copyFrom(param1:Rectangle, param2:BitmapData, param3:Rectangle) : void {
            var _local_13:int = 0;
            var _local_14:BitmapData = null;
            var _local_4:Number = param3.width / param1.width;
            var _local_5:Number = param3.height / param1.height;
            var _local_6:int = Math.max(0,int(param1.x / CHUNK_SIZE));
            var _local_7:int = Math.max(0,int(param1.y / CHUNK_SIZE));
            var _local_8:int = Math.min(this.maxChunkX_ - 1,int(param1.right / CHUNK_SIZE));
            var _local_9:int = Math.min(this.maxChunkY_ - 1,int(param1.bottom / CHUNK_SIZE));
            var _local_10:Rectangle = new Rectangle();
            var _local_11:Matrix = new Matrix();
            var _local_12:int = _local_6;
            while(_local_12 <= _local_8) {
                _local_13 = _local_7;
                while(_local_13 <= _local_9) {
                    _local_14 = this.chunks_[_local_12 + _local_13 * this.maxChunkX_];
                    _local_11.identity();
                    _local_11.translate(param3.x / _local_4 - param1.x + _local_12 * CHUNK_SIZE,param3.y / _local_5 - param1.y + _local_13 * CHUNK_SIZE);
                    _local_11.scale(_local_4,_local_5);
                    param2.draw(_local_14,_local_11,null,null,param3,false);
                    _local_13++;
                }
                _local_12++;
            }
        }
        
        public function erase(param1:Rectangle) : void {
            var _local_8:int = 0;
            var _local_9:BitmapData = null;
            var _local_2:int = int(param1.x / CHUNK_SIZE);
            var _local_3:int = int(param1.y / CHUNK_SIZE);
            var _local_4:int = Math.ceil(param1.right / CHUNK_SIZE);
            var _local_5:int = Math.ceil(param1.bottom / CHUNK_SIZE);
            var _local_6:Rectangle = new Rectangle();
            var _local_7:int = _local_2;
            while(_local_7 < _local_4) {
                _local_8 = _local_3;
                while(_local_8 < _local_5) {
                    _local_9 = this.chunks_[_local_7 + _local_8 * this.maxChunkX_];
                    _local_6.x = param1.x - _local_7 * CHUNK_SIZE;
                    _local_6.y = param1.y - _local_8 * CHUNK_SIZE;
                    _local_6.right = param1.right - _local_7 * CHUNK_SIZE;
                    _local_6.bottom = param1.bottom - _local_8 * CHUNK_SIZE;
                    _local_9.fillRect(_local_6,this.fillColor_);
                    _local_8++;
                }
                _local_7++;
            }
        }
        
        public function getDebugSprite() : Sprite {
            var _local_3:int = 0;
            var _local_4:BitmapData = null;
            var _local_5:Bitmap = null;
            var _local_1:Sprite = new Sprite();
            var _local_2:int = 0;
            while(_local_2 < this.maxChunkX_) {
                _local_3 = 0;
                while(_local_3 < this.maxChunkY_) {
                    _local_4 = this.chunks_[_local_2 + _local_3 * this.maxChunkX_];
                    _local_5 = new Bitmap(_local_4);
                    _local_5.x = _local_2 * CHUNK_SIZE;
                    _local_5.y = _local_3 * CHUNK_SIZE;
                    _local_1.addChild(_local_5);
                    _local_3++;
                }
                _local_2++;
            }
            return _local_1;
        }
    }
}
