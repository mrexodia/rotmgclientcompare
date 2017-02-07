package com.company.assembleegameclient.util {
    import com.company.assembleegameclient.map.GroundLibrary;
    import com.company.assembleegameclient.map.GroundProperties;
    import com.company.assembleegameclient.map.Map;
    import com.company.assembleegameclient.map.Square#55;
    import com.company.assembleegameclient.parameters.Parameters;
    import com.company.util.AssetLibrary;
    import com.company.util.BitmapUtil;
    import com.company.util.ImageSet;
    import com.company.util.PointUtil;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.ByteArray;
    
    public class TileRedrawer {
        
        private static const rect0:Rectangle = new Rectangle(0,0,4,4);
        
        private static const p0:Point = new Point(0,0);
        
        private static const rect1:Rectangle = new Rectangle(4,0,4,4);
        
        private static const p1:Point = new Point(4,0);
        
        private static const rect2:Rectangle = new Rectangle(0,4,4,4);
        
        private static const p2:Point = new Point(0,4);
        
        private static const rect3:Rectangle = new Rectangle(4,4,4,4);
        
        private static const p3:Point = new Point(4,4);
        
        private static const INNER:int = 0;
        
        private static const SIDE0:int = 1;
        
        private static const SIDE1:int = 2;
        
        private static const OUTER:int = 3;
        
        private static const INNERP1:int = 4;
        
        private static const INNERP2:int = 5;
        
        private static const mlist_:Vector.<Vector.<ImageSet>> = getMasks();
        
        private static var cache_:Vector.<Object> = new <Object>[null,new Object()];
        
        private static const RECT01:Rectangle = new Rectangle(0,0,8,4);
        
        private static const RECT13:Rectangle = new Rectangle(4,0,4,8);
        
        private static const RECT23:Rectangle = new Rectangle(0,4,8,4);
        
        private static const RECT02:Rectangle = new Rectangle(0,0,4,8);
        
        private static const RECT0:Rectangle = new Rectangle(0,0,4,4);
        
        private static const RECT1:Rectangle = new Rectangle(4,0,4,4);
        
        private static const RECT2:Rectangle = new Rectangle(0,4,4,4);
        
        private static const RECT3:Rectangle = new Rectangle(4,4,4,4);
        
        private static const POINT0:Point = new Point(0,0);
        
        private static const POINT1:Point = new Point(4,0);
        
        private static const POINT2:Point = new Point(0,4);
        
        private static const POINT3:Point = new Point(4,4);
         
        
        public function TileRedrawer() {
            super();
        }
        
        public static function redraw(param1:Square#55, param2:Boolean) : BitmapData {
            var _local_3:ByteArray = null;
            var _local_5:BitmapData = null;
            if(Parameters.blendType_ == 0) {
                return null;
            }
            if(param1.tileType_ == 253) {
                _local_3 = getCompositeSig(param1);
            } else if(param1.props_.hasEdge_) {
                _local_3 = getEdgeSig(param1);
            } else {
                _local_3 = getSig(param1);
            }
            if(_local_3 == null) {
                return null;
            }
            var _local_4:Object = cache_[Parameters.blendType_];
            if(_local_4.hasOwnProperty(_local_3)) {
                return _local_4[_local_3];
            }
            if(param1.tileType_ == 253) {
                _local_5 = buildComposite(_local_3);
                _local_4[_local_3] = _local_5;
                return _local_5;
            }
            if(param1.props_.hasEdge_) {
                _local_5 = drawEdges(_local_3);
                _local_4[_local_3] = _local_5;
                return _local_5;
            }
            var _local_6:Boolean = false;
            var _local_7:Boolean = false;
            var _local_8:Boolean = false;
            var _local_9:Boolean = false;
            if(_local_3[1] != _local_3[4]) {
                _local_6 = true;
                _local_7 = true;
            }
            if(_local_3[3] != _local_3[4]) {
                _local_6 = true;
                _local_8 = true;
            }
            if(_local_3[5] != _local_3[4]) {
                _local_7 = true;
                _local_9 = true;
            }
            if(_local_3[7] != _local_3[4]) {
                _local_8 = true;
                _local_9 = true;
            }
            if(!_local_6 && _local_3[0] != _local_3[4]) {
                _local_6 = true;
            }
            if(!_local_7 && _local_3[2] != _local_3[4]) {
                _local_7 = true;
            }
            if(!_local_8 && _local_3[6] != _local_3[4]) {
                _local_8 = true;
            }
            if(!_local_9 && _local_3[8] != _local_3[4]) {
                _local_9 = true;
            }
            if(!_local_6 && !_local_7 && !_local_8 && !_local_9) {
                _local_4[_local_3] = null;
                return null;
            }
            var _local_10:BitmapData = GroundLibrary.getBitmapData(param1.tileType_);
            if(param2) {
                _local_5 = _local_10.clone();
            } else {
                _local_5 = new BitmapDataSpy(_local_10.width,_local_10.height,true,0);
            }
            if(_local_6) {
                redrawRect(_local_5,rect0,p0,mlist_[0],_local_3[4],_local_3[3],_local_3[0],_local_3[1]);
            }
            if(_local_7) {
                redrawRect(_local_5,rect1,p1,mlist_[1],_local_3[4],_local_3[1],_local_3[2],_local_3[5]);
            }
            if(_local_8) {
                redrawRect(_local_5,rect2,p2,mlist_[2],_local_3[4],_local_3[7],_local_3[6],_local_3[3]);
            }
            if(_local_9) {
                redrawRect(_local_5,rect3,p3,mlist_[3],_local_3[4],_local_3[5],_local_3[8],_local_3[7]);
            }
            _local_4[_local_3] = _local_5;
            return _local_5;
        }
        
        private static function redrawRect(param1:BitmapData, param2:Rectangle, param3:Point, param4:Vector.<ImageSet>, param5:uint, param6:uint, param7:uint, param8:uint) : void {
            var _local_9:BitmapData = null;
            var _local_10:BitmapData = null;
            if(param5 == param6 && param5 == param8) {
                _local_10 = param4[OUTER].random();
                _local_9 = GroundLibrary.getBitmapData(param7);
            } else if(param5 != param6 && param5 != param8) {
                if(param6 != param8) {
                    param1.copyPixels(GroundLibrary.getBitmapData(param6),param2,param3,param4[INNERP1].random(),p0,true);
                    param1.copyPixels(GroundLibrary.getBitmapData(param8),param2,param3,param4[INNERP2].random(),p0,true);
                    return;
                }
                _local_10 = param4[INNER].random();
                _local_9 = GroundLibrary.getBitmapData(param6);
            } else if(param5 != param6) {
                _local_10 = param4[SIDE0].random();
                _local_9 = GroundLibrary.getBitmapData(param6);
            } else {
                _local_10 = param4[SIDE1].random();
                _local_9 = GroundLibrary.getBitmapData(param8);
            }
            param1.copyPixels(_local_9,param2,param3,_local_10,p0,true);
        }
        
        private static function getSig(param1:Square#55) : ByteArray {
            var _local_6:int = 0;
            var _local_7:Square = null;
            var _local_2:ByteArray = new ByteArray();
            var _local_3:Map = param1.map_;
            var _local_4:uint = param1.tileType_;
            var _local_5:int = param1.y_ - 1;
            while(_local_5 <= param1.y_ + 1) {
                _local_6 = param1.x_ - 1;
                while(_local_6 <= param1.x_ + 1) {
                    if(_local_6 < 0 || _local_6 >= _local_3.width_ || _local_5 < 0 || _local_5 >= _local_3.height_ || _local_6 == param1.x_ && _local_5 == param1.y_) {
                        _local_2.writeByte(_local_4);
                    } else {
                        _local_7 = _local_3.squares_[_local_6 + _local_5 * _local_3.width_];
                        if(_local_7 == null || _local_7.props_.blendPriority_ <= param1.props_.blendPriority_) {
                            _local_2.writeByte(_local_4);
                        } else {
                            _local_2.writeByte(_local_7.tileType_);
                        }
                    }
                    _local_6++;
                }
                _local_5++;
            }
            return _local_2;
        }
        
        private static function getMasks() : Vector.<Vector.<ImageSet>> {
            var _local_1:Vector.<Vector.<ImageSet>> = new Vector.<Vector.<ImageSet>>();
            addMasks(_local_1,AssetLibrary.getImageSet("inner_mask"),AssetLibrary.getImageSet("sides_mask"),AssetLibrary.getImageSet("outer_mask"),AssetLibrary.getImageSet("innerP1_mask"),AssetLibrary.getImageSet("innerP2_mask"));
            return _local_1;
        }
        
        private static function addMasks(param1:Vector.<Vector.<ImageSet>>, param2:ImageSet, param3:ImageSet, param4:ImageSet, param5:ImageSet, param6:ImageSet) : void {
            var _local_7:int = 0;
            for each(_local_7 in [-1,0,2,1]) {
                param1.push(new <ImageSet>[rotateImageSet(param2,_local_7),rotateImageSet(param3,_local_7 - 1),rotateImageSet(param3,_local_7),rotateImageSet(param4,_local_7),rotateImageSet(param5,_local_7),rotateImageSet(param6,_local_7)]);
            }
        }
        
        private static function rotateImageSet(param1:ImageSet, param2:int) : ImageSet {
            var _local_4:BitmapData = null;
            var _local_3:ImageSet = new ImageSet();
            for each(_local_4 in param1.images_) {
                _local_3.add(BitmapUtil.rotateBitmapData(_local_4,param2));
            }
            return _local_3;
        }
        
        private static function getCompositeSig(param1:Square#55) : ByteArray {
            var _local_14:Square = null;
            var _local_15:Square = null;
            var _local_16:Square = null;
            var _local_17:Square = null;
            var _local_2:ByteArray = new ByteArray();
            _local_2.length = 4;
            var _local_3:Map = param1.map_;
            var _local_4:int = param1.x_;
            var _local_5:int = param1.y_;
            var _local_6:Square = _local_3.lookupSquare(_local_4,_local_5 - 1);
            var _local_7:Square = _local_3.lookupSquare(_local_4 - 1,_local_5);
            var _local_8:Square = _local_3.lookupSquare(_local_4 + 1,_local_5);
            var _local_9:Square = _local_3.lookupSquare(_local_4,_local_5 + 1);
            var _local_10:int = _local_6 != null?int(_local_6.props_.compositePriority_):-1;
            var _local_11:int = _local_7 != null?int(_local_7.props_.compositePriority_):-1;
            var _local_12:int = _local_8 != null?int(_local_8.props_.compositePriority_):-1;
            var _local_13:int = _local_9 != null?int(_local_9.props_.compositePriority_):-1;
            if(_local_10 < 0 && _local_11 < 0) {
                _local_14 = _local_3.lookupSquare(_local_4 - 1,_local_5 - 1);
                _local_2[0] = _local_14 == null || _local_14.props_.compositePriority_ < 0?255:_local_14.tileType_;
            } else if(_local_10 < _local_11) {
                _local_2[0] = _local_7.tileType_;
            } else {
                _local_2[0] = _local_6.tileType_;
            }
            if(_local_10 < 0 && _local_12 < 0) {
                _local_15 = _local_3.lookupSquare(_local_4 + 1,_local_5 - 1);
                _local_2[1] = _local_15 == null || _local_15.props_.compositePriority_ < 0?255:_local_15.tileType_;
            } else if(_local_10 < _local_12) {
                _local_2[1] = _local_8.tileType_;
            } else {
                _local_2[1] = _local_6.tileType_;
            }
            if(_local_11 < 0 && _local_13 < 0) {
                _local_16 = _local_3.lookupSquare(_local_4 - 1,_local_5 + 1);
                _local_2[2] = _local_16 == null || _local_16.props_.compositePriority_ < 0?255:_local_16.tileType_;
            } else if(_local_11 < _local_13) {
                _local_2[2] = _local_9.tileType_;
            } else {
                _local_2[2] = _local_7.tileType_;
            }
            if(_local_12 < 0 && _local_13 < 0) {
                _local_17 = _local_3.lookupSquare(_local_4 + 1,_local_5 + 1);
                _local_2[3] = _local_17 == null || _local_17.props_.compositePriority_ < 0?255:_local_17.tileType_;
            } else if(_local_12 < _local_13) {
                _local_2[3] = _local_9.tileType_;
            } else {
                _local_2[3] = _local_8.tileType_;
            }
            return _local_2;
        }
        
        private static function buildComposite(param1:ByteArray) : BitmapData {
            var _local_3:BitmapData = null;
            var _local_2:BitmapData = new BitmapDataSpy(8,8,false,0);
            if(param1[0] != 255) {
                _local_3 = GroundLibrary.getBitmapData(param1[0]);
                _local_2.copyPixels(_local_3,RECT0,POINT0);
            }
            if(param1[1] != 255) {
                _local_3 = GroundLibrary.getBitmapData(param1[1]);
                _local_2.copyPixels(_local_3,RECT1,POINT1);
            }
            if(param1[2] != 255) {
                _local_3 = GroundLibrary.getBitmapData(param1[2]);
                _local_2.copyPixels(_local_3,RECT2,POINT2);
            }
            if(param1[3] != 255) {
                _local_3 = GroundLibrary.getBitmapData(param1[3]);
                _local_2.copyPixels(_local_3,RECT3,POINT3);
            }
            return _local_2;
        }
        
        private static function getEdgeSig(param1:Square#55) : ByteArray {
            var _local_7:int = 0;
            var _local_8:Square = null;
            var _local_9:Boolean = false;
            var _local_2:ByteArray = new ByteArray();
            var _local_3:Map = param1.map_;
            var _local_4:Boolean = false;
            var _local_5:Boolean = param1.props_.sameTypeEdgeMode_;
            var _local_6:int = param1.y_ - 1;
            while(_local_6 <= param1.y_ + 1) {
                _local_7 = param1.x_ - 1;
                while(_local_7 <= param1.x_ + 1) {
                    _local_8 = _local_3.lookupSquare(_local_7,_local_6);
                    if(_local_7 == param1.x_ && _local_6 == param1.y_) {
                        _local_2.writeByte(_local_8.tileType_);
                    } else {
                        if(_local_5) {
                            _local_9 = _local_8 == null || _local_8.tileType_ == param1.tileType_;
                        } else {
                            _local_9 = _local_8 == null || _local_8.tileType_ != 255;
                        }
                        _local_2.writeBoolean(_local_9);
                        _local_4 = _local_4 || !_local_9;
                    }
                    _local_7++;
                }
                _local_6++;
            }
            return !!_local_4?_local_2:null;
        }
        
        private static function drawEdges(param1:ByteArray) : BitmapData {
            var _local_2:BitmapData = GroundLibrary.getBitmapData(param1[4]);
            var _local_3:BitmapData = _local_2.clone();
            var _local_4:GroundProperties = GroundLibrary.propsLibrary_[param1[4]];
            var _local_5:Vector.<BitmapData> = _local_4.getEdges();
            var _local_6:Vector.<BitmapData> = _local_4.getInnerCorners();
            var _local_7:int = 1;
            while(_local_7 < 8) {
                if(!param1[_local_7]) {
                    _local_3.copyPixels(_local_5[_local_7],_local_5[_local_7].rect,PointUtil.ORIGIN,null,null,true);
                }
                _local_7 = _local_7 + 2;
            }
            if(_local_5[0] != null) {
                if(param1[3] && param1[1] && !param1[0]) {
                    _local_3.copyPixels(_local_5[0],_local_5[0].rect,PointUtil.ORIGIN,null,null,true);
                }
                if(param1[1] && param1[5] && !param1[2]) {
                    _local_3.copyPixels(_local_5[2],_local_5[2].rect,PointUtil.ORIGIN,null,null,true);
                }
                if(param1[5] && param1[7] && !param1[8]) {
                    _local_3.copyPixels(_local_5[8],_local_5[8].rect,PointUtil.ORIGIN,null,null,true);
                }
                if(param1[3] && param1[7] && !param1[6]) {
                    _local_3.copyPixels(_local_5[6],_local_5[6].rect,PointUtil.ORIGIN,null,null,true);
                }
            }
            if(_local_6 != null) {
                if(!param1[3] && !param1[1]) {
                    _local_3.copyPixels(_local_6[0],_local_6[0].rect,PointUtil.ORIGIN,null,null,true);
                }
                if(!param1[1] && !param1[5]) {
                    _local_3.copyPixels(_local_6[2],_local_6[2].rect,PointUtil.ORIGIN,null,null,true);
                }
                if(!param1[5] && !param1[7]) {
                    _local_3.copyPixels(_local_6[8],_local_6[8].rect,PointUtil.ORIGIN,null,null,true);
                }
                if(!param1[3] && !param1[7]) {
                    _local_3.copyPixels(_local_6[6],_local_6[6].rect,PointUtil.ORIGIN,null,null,true);
                }
            }
            return _local_3;
        }
    }
}
