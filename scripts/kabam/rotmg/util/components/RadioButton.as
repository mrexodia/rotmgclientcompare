package kabam.rotmg.util.components {
    import com.company.util.GraphicsUtil;
    import flash.display.CapsStyle;
    import flash.display.Graphics;
    import flash.display.GraphicsPath;
    import flash.display.GraphicsSolidFill;
    import flash.display.GraphicsStroke;
    import flash.display.IGraphicsData;
    import flash.display.JointStyle;
    import flash.display.LineScaleMode;
    import flash.display.Shape;
    import flash.display.Sprite;
    import org.osflash.signals.Signal;
    
    public class RadioButton extends Sprite {
         
        
        public const changed:Signal = new Signal(Boolean);
        
        private const WIDTH:int = 28;
        
        private const HEIGHT:int = 28;
        
        private var unselected:Shape;
        
        private var selected:Shape;
        
        public function RadioButton() {
            super();
            addChild(this.unselected = this.makeUnselected());
            addChild(this.selected = this.makeSelected());
            this.setSelected(false);
        }
        
        public function setSelected(param1:Boolean) : void {
            this.unselected.visible = !param1;
            this.selected.visible = param1;
            this.changed.dispatch(param1);
        }
        
        private function makeUnselected() : Shape {
            var _local_1:Shape = new Shape();
            this.drawOutline(_local_1.graphics);
            return _local_1;
        }
        
        private function makeSelected() : Shape {
            var _local_1:Shape = new Shape();
            this.drawOutline(_local_1.graphics);
            this.drawFill(_local_1.graphics);
            return _local_1;
        }
        
        private function drawOutline(param1:Graphics) : void {
            var _local_2:GraphicsSolidFill = new GraphicsSolidFill(0,0.01);
            var _local_3:GraphicsSolidFill = new GraphicsSolidFill(16777215,1);
            var _local_4:GraphicsStroke = new GraphicsStroke(2,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,_local_3);
            var _local_5:GraphicsPath = new GraphicsPath();
            GraphicsUtil.drawCutEdgeRect(0,0,this.WIDTH,this.HEIGHT,4,GraphicsUtil.ALL_CUTS,_local_5);
            var _local_6:Vector.<IGraphicsData> = new <IGraphicsData>[_local_4,_local_2,_local_5,GraphicsUtil.END_FILL,GraphicsUtil.END_STROKE];
            param1.drawGraphicsData(_local_6);
        }
        
        private function drawFill(param1:Graphics) : void {
            var _local_2:GraphicsSolidFill = new GraphicsSolidFill(16777215,1);
            var _local_3:GraphicsPath = new GraphicsPath();
            GraphicsUtil.drawCutEdgeRect(4,4,this.WIDTH - 8,this.HEIGHT - 8,2,GraphicsUtil.ALL_CUTS,_local_3);
            var _local_4:Vector.<IGraphicsData> = new <IGraphicsData>[_local_2,_local_3,GraphicsUtil.END_FILL];
            param1.drawGraphicsData(_local_4);
        }
    }
}
