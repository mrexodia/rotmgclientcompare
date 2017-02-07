package kabam.rotmg.util.graphics {
    import flash.display.Graphics;
    
    public class GraphicsHelper {
         
        
        public function GraphicsHelper() {
            super();
        }
        
        public function drawBevelRect(param1:int, param2:int, param3:BevelRect, param4:Graphics) : void {
            var _local_5:int = param1 + param3.width;
            var _local_6:int = param2 + param3.height;
            var _local_7:int = param3.bevel;
            if(param3.topLeftBevel) {
                param4.moveTo(param1,param2 + _local_7);
                param4.lineTo(param1 + _local_7,param2);
            } else {
                param4.moveTo(param1,param2);
            }
            if(param3.topRightBevel) {
                param4.lineTo(_local_5 - _local_7,param2);
                param4.lineTo(_local_5,param2 + _local_7);
            } else {
                param4.lineTo(_local_5,param2);
            }
            if(param3.bottomRightBevel) {
                param4.lineTo(_local_5,_local_6 - _local_7);
                param4.lineTo(_local_5 - _local_7,_local_6);
            } else {
                param4.lineTo(_local_5,_local_6);
            }
            if(param3.bottomLeftBevel) {
                param4.lineTo(param1 + _local_7,_local_6);
                param4.lineTo(param1,_local_6 - _local_7);
            } else {
                param4.lineTo(param1,_local_6);
            }
        }
    }
}
