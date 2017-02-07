package com.company.assembleegameclient.util {
    import com.company.assembleegameclient.map.Camera;
    import com.company.util.Trig;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;
    
    public class AnimatedChar {
        
        public static const RIGHT:int = 0;
        
        public static const LEFT:int = 1;
        
        public static const DOWN:int = 2;
        
        public static const UP:int = 3;
        
        public static const NUM_DIR:int = 4;
        
        public static const STAND:int = 0;
        
        public static const WALK:int = 1;
        
        public static const ATTACK:int = 2;
        
        public static const NUM_ACTION:int = 3;
        
        private static const SEC_TO_DIRS:Vector.<Vector.<int>> = new <Vector.<int>>[new <int>[LEFT,UP,DOWN],new <int>[UP,LEFT,DOWN],new <int>[UP,RIGHT,DOWN],new <int>[RIGHT,UP,DOWN],new <int>[RIGHT,DOWN],new <int>[DOWN,RIGHT],new <int>[DOWN,LEFT],new <int>[LEFT,DOWN]];
        
        private static const PIOVER4:Number = Math.PI / 4;
         
        
        public var origImage_:MaskedImage;
        
        private var width_:int;
        
        private var height_:int;
        
        private var firstDir_:int;
        
        private var dict_:Dictionary;
        
        public function AnimatedChar(param1:MaskedImage, param2:int, param3:int, param4:int) {
            this.dict_ = new Dictionary();
            super();
            this.origImage_ = param1;
            this.width_ = param2;
            this.height_ = param3;
            this.firstDir_ = param4;
            var _local_5:Dictionary = new Dictionary();
            var _local_6:MaskedImageSet = new MaskedImageSet();
            _local_6.addFromMaskedImage(param1,param2,param3);
            if(param4 == RIGHT) {
                this.dict_[RIGHT] = this.loadDir(0,false,false,_local_6);
                this.dict_[LEFT] = this.loadDir(0,true,false,_local_6);
                if(_local_6.images_.length >= 14) {
                    this.dict_[DOWN] = this.loadDir(7,false,true,_local_6);
                    if(_local_6.images_.length >= 21) {
                        this.dict_[UP] = this.loadDir(14,false,true,_local_6);
                    }
                }
            } else if(param4 == DOWN) {
                this.dict_[DOWN] = this.loadDir(0,false,true,_local_6);
                if(_local_6.images_.length >= 14) {
                    this.dict_[RIGHT] = this.loadDir(7,false,false,_local_6);
                    this.dict_[LEFT] = this.loadDir(7,true,false,_local_6);
                    if(_local_6.images_.length >= 21) {
                        this.dict_[UP] = this.loadDir(14,false,true,_local_6);
                    }
                }
            }
        }
        
        public function getFirstDirImage() : BitmapData {
            var _local_1:BitmapData = new BitmapDataSpy(this.width_ * 7,this.height_,true,0);
            var _local_2:Dictionary = this.dict_[this.firstDir_];
            var _local_3:Vector.<MaskedImage> = _local_2[STAND];
            if(_local_3.length > 0) {
                _local_1.copyPixels(_local_3[0].image_,_local_3[0].image_.rect,new Point(0,0));
            }
            _local_3 = _local_2[WALK];
            if(_local_3.length > 0) {
                _local_1.copyPixels(_local_3[0].image_,_local_3[0].image_.rect,new Point(this.width_,0));
            }
            if(_local_3.length > 1) {
                _local_1.copyPixels(_local_3[1].image_,_local_3[1].image_.rect,new Point(this.width_ * 2,0));
            }
            _local_3 = _local_2[ATTACK];
            if(_local_3.length > 0) {
                _local_1.copyPixels(_local_3[0].image_,_local_3[0].image_.rect,new Point(this.width_ * 4,0));
            }
            if(_local_3.length > 1) {
                _local_1.copyPixels(_local_3[1].image_,new Rectangle(this.width_,0,this.width_ * 2,this.height_),new Point(this.width_ * 5,0));
            }
            return _local_1;
        }
        
        public function imageVec(param1:int, param2:int) : Vector.<MaskedImage> {
            return this.dict_[param1][param2];
        }
        
        public function imageFromDir(param1:int, param2:int, param3:Number) : MaskedImage {
            var _local_4:Vector.<MaskedImage> = this.dict_[param1][param2];
            param3 = Math.max(0,Math.min(0.99999,param3));
            var _local_5:int = param3 * _local_4.length;
            return _local_4[_local_5];
        }
        
        public function imageFromAngle(param1:Number, param2:int, param3:Number) : MaskedImage {
            var _local_4:int = int(param1 / PIOVER4 + 4) % 8;
            var _local_5:Vector.<int> = SEC_TO_DIRS[_local_4];
            var _local_6:Dictionary = this.dict_[_local_5[0]];
            if(_local_6 == null) {
                _local_6 = this.dict_[_local_5[1]];
                if(_local_6 == null) {
                    _local_6 = this.dict_[_local_5[2]];
                }
            }
            var _local_7:Vector.<MaskedImage> = _local_6[param2];
            param3 = Math.max(0,Math.min(0.99999,param3));
            var _local_8:int = param3 * _local_7.length;
            return _local_7[_local_8];
        }
        
        public function imageFromFacing(param1:Number, param2:Camera, param3:int, param4:Number) : MaskedImage {
            var _local_5:Number = Trig.boundToPI(param1 - param2.angleRad_);
            var _local_6:int = int(_local_5 / PIOVER4 + 4) % 8;
            var _local_7:Vector.<int> = SEC_TO_DIRS[_local_6];
            var _local_8:Dictionary = this.dict_[_local_7[0]];
            if(_local_8 == null) {
                _local_8 = this.dict_[_local_7[1]];
                if(_local_8 == null) {
                    _local_8 = this.dict_[_local_7[2]];
                }
            }
            var _local_9:Vector.<MaskedImage> = _local_8[param3];
            param4 = Math.max(0,Math.min(0.99999,param4));
            var _local_10:int = param4 * _local_9.length;
            return _local_9[_local_10];
        }
        
        private function loadDir(param1:int, param2:Boolean, param3:Boolean, param4:MaskedImageSet) : Dictionary {
            var _local_14:Vector.<MaskedImage> = null;
            var _local_15:BitmapData = null;
            var _local_16:BitmapData = null;
            var _local_5:Dictionary = new Dictionary();
            var _local_6:MaskedImage = param4.images_[param1 + 0];
            var _local_7:MaskedImage = param4.images_[param1 + 1];
            var _local_8:MaskedImage = param4.images_[param1 + 2];
            if(_local_8.amountTransparent() == 1) {
                _local_8 = null;
            }
            var _local_9:MaskedImage = param4.images_[param1 + 4];
            var _local_10:MaskedImage = param4.images_[param1 + 5];
            if(_local_9.amountTransparent() == 1) {
                _local_9 = null;
            }
            if(_local_10.amountTransparent() == 1) {
                _local_10 = null;
            }
            var _local_11:MaskedImage = param4.images_[param1 + 6];
            if(_local_10 != null && _local_11.amountTransparent() != 1) {
                _local_15 = new BitmapDataSpy(this.width_ * 3,this.height_,true,0);
                _local_15.copyPixels(_local_10.image_,new Rectangle(0,0,this.width_,this.height_),new Point(this.width_,0));
                _local_15.copyPixels(_local_11.image_,new Rectangle(0,0,this.width_,this.height_),new Point(this.width_ * 2,0));
                _local_16 = null;
                if(_local_10.mask_ != null || _local_11.mask_ != null) {
                    _local_16 = new BitmapDataSpy(this.width_ * 3,this.height_,true,0);
                }
                if(_local_10.mask_ != null) {
                    _local_16.copyPixels(_local_10.mask_,new Rectangle(0,0,this.width_,this.height_),new Point(this.width_,0));
                }
                if(_local_11.mask_ != null) {
                    _local_16.copyPixels(_local_11.mask_,new Rectangle(0,0,this.width_,this.height_),new Point(this.width_ * 2,0));
                }
                _local_10 = new MaskedImage(_local_15,_local_16);
            }
            var _local_12:Vector.<MaskedImage> = new Vector.<MaskedImage>();
            _local_12.push(!!param2?_local_6.mirror():_local_6);
            _local_5[STAND] = _local_12;
            var _local_13:Vector.<MaskedImage> = new Vector.<MaskedImage>();
            _local_13.push(!!param2?_local_7.mirror():_local_7);
            if(_local_8 != null) {
                _local_13.push(!!param2?_local_8.mirror():_local_8);
            } else if(param3) {
                _local_13.push(!param2?_local_7.mirror(7):_local_7);
            } else {
                _local_13.push(!!param2?_local_6.mirror():_local_6);
            }
            _local_5[WALK] = _local_13;
            if(_local_9 == null && _local_10 == null) {
                _local_14 = _local_13;
            } else {
                _local_14 = new Vector.<MaskedImage>();
                if(_local_9 != null) {
                    _local_14.push(!!param2?_local_9.mirror():_local_9);
                }
                if(_local_10 != null) {
                    _local_14.push(!!param2?_local_10.mirror():_local_10);
                }
            }
            _local_5[ATTACK] = _local_14;
            return _local_5;
        }
    }
}
