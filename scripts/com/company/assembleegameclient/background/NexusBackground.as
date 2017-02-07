package com.company.assembleegameclient.background {
    import com.company.assembleegameclient.map.Camera;
    import com.company.util.GraphicsUtil;
    import flash.display.BitmapData;
    import flash.display.BitmapDataChannel;
    import flash.display.GraphicsBitmapFill;
    import flash.display.GraphicsPath;
    import flash.display.IGraphicsData;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    public class NexusBackground extends Background {
        
        public static const MOVEMENT:Point = new Point(0.01,0.01);
         
        
        private var water_:BitmapData;
        
        private var islands_:Vector.<Island>;
        
        protected var graphicsData_:Vector.<IGraphicsData>;
        
        private var bitmapFill_:GraphicsBitmapFill;
        
        private var path_:GraphicsPath;
        
        public function NexusBackground() {
            this.islands_ = new Vector.<Island>();
            this.graphicsData_ = new Vector.<IGraphicsData>();
            this.bitmapFill_ = new GraphicsBitmapFill(null,new Matrix(),true,false);
            this.path_ = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS,new Vector.<Number>());
            super();
            this.water_ = new BitmapDataSpy(1024,1024,false,0);
            this.water_.perlinNoise(1024,1024,8,Math.random(),true,true,BitmapDataChannel.BLUE,false,null);
        }
        
        override public function draw(param1:Camera, param2:int) : void {
            this.graphicsData_.length = 0;
            var _local_3:Matrix = this.bitmapFill_.matrix;
            _local_3.identity();
            _local_3.translate(param2 * MOVEMENT.x,param2 * MOVEMENT.y);
            _local_3.rotate(-param1.angleRad_);
            this.bitmapFill_.bitmapData = this.water_;
            this.graphicsData_.push(this.bitmapFill_);
            this.path_.data.length = 0;
            var _local_4:Rectangle = param1.clipRect_;
            this.path_.data.push(_local_4.left,_local_4.top,_local_4.right,_local_4.top,_local_4.right,_local_4.bottom,_local_4.left,_local_4.bottom);
            this.graphicsData_.push(this.path_);
            this.graphicsData_.push(GraphicsUtil.END_FILL);
            this.drawIslands(param1,param2);
            graphics.clear();
            graphics.drawGraphicsData(this.graphicsData_);
        }
        
        private function drawIslands(param1:Camera, param2:int) : void {
            var _local_4:Island = null;
            var _local_3:int = 0;
            while(_local_3 < this.islands_.length) {
                _local_4 = this.islands_[_local_3];
                _local_4.draw(param1,param2,this.graphicsData_);
                _local_3++;
            }
        }
    }
}

import com.company.assembleegameclient.background.NexusBackground;
import com.company.assembleegameclient.map.Camera;
import com.company.util.AssetLibrary;
import com.company.util.GraphicsUtil;
import flash.display.BitmapData;
import flash.display.GraphicsBitmapFill;
import flash.display.GraphicsPath;
import flash.display.IGraphicsData;
import flash.geom.Matrix;
import flash.geom.Point;

class Island {
     
    
    public var center_:Point;
    
    public var startTime_:int;
    
    public var bitmapData_:BitmapData;
    
    private var bitmapFill_:GraphicsBitmapFill;
    
    private var path_:GraphicsPath;
    
    function Island(param1:Number, param2:Number, param3:int) {
        this.bitmapFill_ = new GraphicsBitmapFill(null,new Matrix(),true,false);
        this.path_ = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS,new Vector.<Number>());
        super();
        this.center_ = new Point(param1,param2);
        this.startTime_ = param3;
        this.bitmapData_ = AssetLibrary.getImage("stars");
    }
    
    public function draw(param1:Camera, param2:int, param3:Vector.<IGraphicsData>) : void {
        var _local_4:int = param2 - this.startTime_;
        var _local_5:Number = this.center_.x + _local_4 * NexusBackground.MOVEMENT.x;
        var _local_6:Number = this.center_.y + _local_4 * NexusBackground.MOVEMENT.y;
        var _local_7:Matrix = this.bitmapFill_.matrix;
        _local_7.identity();
        _local_7.translate(_local_5,_local_6);
        _local_7.rotate(-param1.angleRad_);
        this.bitmapFill_.bitmapData = this.bitmapData_;
        param3.push(this.bitmapFill_);
        this.path_.data.length = 0;
        var _local_8:Point = _local_7.transformPoint(new Point(_local_5,_local_6));
        var _local_9:Point = _local_7.transformPoint(new Point(_local_5 + this.bitmapData_.width,_local_6 + this.bitmapData_.height));
        this.path_.data.push(_local_8.x,_local_8.y,_local_9.x,_local_8.y,_local_9.x,_local_9.y,_local_8.x,_local_9.y);
        param3.push(this.path_);
        param3.push(GraphicsUtil.END_FILL);
    }
}
