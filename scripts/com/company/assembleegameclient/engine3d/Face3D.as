package com.company.assembleegameclient.engine3d {
    import com.company.assembleegameclient.map.Camera;
    import com.company.assembleegameclient.util.TextureRedrawer;
    import com.company.util.GraphicsUtil;
    import com.company.util.Triangle;
    import flash.display.BitmapData;
    import flash.display.GraphicsBitmapFill;
    import flash.display.GraphicsPath;
    import flash.display.GraphicsPathCommand;
    import flash.display.GraphicsSolidFill;
    import flash.display.IGraphicsData;
    import flash.geom.Utils3D;
    import flash.geom.Vector3D;
    
    public class Face3D {
        
        private static const blackOutFill_:GraphicsSolidFill = new GraphicsSolidFill(0,1);
         
        
        public var origTexture_:BitmapData;
        
        public var vin_:Vector.<Number>;
        
        public var uvt_:Vector.<Number>;
        
        public var vout_:Vector.<Number>;
        
        public var backfaceCull_:Boolean;
        
        public var shade_:Number = 1.0;
        
        public var blackOut_:Boolean = false;
        
        private var needGen_:Boolean = true;
        
        private var textureMatrix_:TextureMatrix = null;
        
        public var bitmapFill_:GraphicsBitmapFill;
        
        private var path_:GraphicsPath;
        
        public function Face3D(param1:BitmapData, param2:Vector.<Number>, param3:Vector.<Number>, param4:Boolean = false, param5:Boolean = false) {
            var _local_7:Vector3D = null;
            this.vout_ = new Vector.<Number>();
            this.bitmapFill_ = new GraphicsBitmapFill(null,null,false,false);
            this.path_ = new GraphicsPath(new Vector.<int>(),null);
            super();
            this.origTexture_ = param1;
            this.vin_ = param2;
            this.uvt_ = param3;
            this.backfaceCull_ = param4;
            if(param5) {
                _local_7 = new Vector3D();
                Plane3D.computeNormalVec(param2,_local_7);
                this.shade_ = Lighting3D.shadeValue(_local_7,0.75);
            }
            this.path_.commands.push(GraphicsPathCommand.MOVE_TO);
            var _local_6:int = 3;
            while(_local_6 < this.vin_.length) {
                this.path_.commands.push(GraphicsPathCommand.LINE_TO);
                _local_6 = _local_6 + 3;
            }
            this.path_.data = this.vout_;
        }
        
        public function dispose() : void {
            this.origTexture_ = null;
            this.vin_ = null;
            this.uvt_ = null;
            this.vout_ = null;
            this.textureMatrix_ = null;
            this.bitmapFill_ = null;
            this.path_.commands = null;
            this.path_.data = null;
            this.path_ = null;
        }
        
        public function setTexture(param1:BitmapData) : void {
            if(this.origTexture_ == param1) {
                return;
            }
            this.origTexture_ = param1;
            this.needGen_ = true;
        }
        
        public function setUVT(param1:Vector.<Number>) : void {
            this.uvt_ = param1;
            this.needGen_ = true;
        }
        
        public function maxY() : Number {
            var _local_1:Number = -Number.MAX_VALUE;
            var _local_2:int = this.vout_.length;
            var _local_3:int = 0;
            while(_local_3 < _local_2) {
                if(this.vout_[_local_3 + 1] > _local_1) {
                    _local_1 = this.vout_[_local_3 + 1];
                }
                _local_3 = _local_3 + 2;
            }
            return _local_1;
        }
        
        public function draw(param1:Vector.<IGraphicsData>, param2:Camera) : Boolean {
            var _local_10:Vector.<Number> = null;
            var _local_11:Number = NaN;
            var _local_12:Number = NaN;
            var _local_13:Number = NaN;
            var _local_14:Number = NaN;
            var _local_15:int = 0;
            Utils3D.projectVectors(param2.wToS_,this.vin_,this.vout_,this.uvt_);
            if(this.backfaceCull_) {
                _local_10 = this.vout_;
                _local_11 = _local_10[2] - _local_10[0];
                _local_12 = _local_10[3] - _local_10[1];
                _local_13 = _local_10[4] - _local_10[0];
                _local_14 = _local_10[5] - _local_10[1];
                if(_local_11 * _local_14 - _local_12 * _local_13 > 0) {
                    return false;
                }
            }
            var _local_3:Number = param2.clipRect_.x - 10;
            var _local_4:Number = param2.clipRect_.y - 10;
            var _local_5:Number = param2.clipRect_.right + 10;
            var _local_6:Number = param2.clipRect_.bottom + 10;
            var _local_7:Boolean = true;
            var _local_8:int = this.vout_.length;
            var _local_9:int = 0;
            while(_local_9 < _local_8) {
                _local_15 = _local_9 + 1;
                if(this.vout_[_local_9] >= _local_3 && this.vout_[_local_9] <= _local_5 && this.vout_[_local_15] >= _local_4 && this.vout_[_local_15] <= _local_6) {
                    _local_7 = false;
                    break;
                }
                _local_9 = _local_9 + 2;
            }
            if(_local_7) {
                return false;
            }
            if(this.blackOut_) {
                param1.push(blackOutFill_);
                param1.push(this.path_);
                param1.push(GraphicsUtil.END_FILL);
                return true;
            }
            if(this.needGen_) {
                this.generateTextureMatrix();
            }
            this.textureMatrix_.calculateTextureMatrix(this.vout_);
            this.bitmapFill_.bitmapData = this.textureMatrix_.texture_;
            this.bitmapFill_.matrix = this.textureMatrix_.tToS_;
            param1.push(this.bitmapFill_);
            param1.push(this.path_);
            param1.push(GraphicsUtil.END_FILL);
            return true;
        }
        
        public function contains(param1:Number, param2:Number) : Boolean {
            if(Triangle.containsXY(this.vout_[0],this.vout_[1],this.vout_[2],this.vout_[3],this.vout_[4],this.vout_[5],param1,param2)) {
                return true;
            }
            if(this.vout_.length == 8 && Triangle.containsXY(this.vout_[0],this.vout_[1],this.vout_[4],this.vout_[5],this.vout_[6],this.vout_[7],param1,param2)) {
                return true;
            }
            return false;
        }
        
        private function generateTextureMatrix() : void {
            var _local_1:BitmapData = TextureRedrawer.redrawFace(this.origTexture_,this.shade_);
            if(this.textureMatrix_ == null) {
                this.textureMatrix_ = new TextureMatrix(_local_1,this.uvt_);
            } else {
                this.textureMatrix_.texture_ = _local_1;
                this.textureMatrix_.calculateUVMatrix(this.uvt_);
            }
            this.needGen_ = false;
        }
    }
}
