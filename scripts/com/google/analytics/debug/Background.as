package com.google.analytics.debug {
    import flash.display.Graphics;
    
    public class Background {
         
        
        public function Background() {
            super();
        }
        
        public static function drawRounded(param1:*, param2:Graphics, param3:uint = 0, param4:uint = 0) : void {
            var _local_5:uint = 0;
            var _local_6:uint = 0;
            var _local_7:uint = Style.roundedCorner;
            if(param3 > 0 && param4 > 0) {
                _local_5 = param3;
                _local_6 = param4;
            } else {
                _local_5 = param1.width;
                _local_6 = param1.height;
            }
            if(param1.stickToEdge && param1.alignement != Align.none) {
                switch(param1.alignement) {
                    case Align.top:
                        param2.drawRoundRectComplex(0,0,_local_5,_local_6,0,0,_local_7,_local_7);
                        break;
                    case Align.topLeft:
                        param2.drawRoundRectComplex(0,0,_local_5,_local_6,0,0,0,_local_7);
                        break;
                    case Align.topRight:
                        param2.drawRoundRectComplex(0,0,_local_5,_local_6,0,0,_local_7,0);
                        break;
                    case Align.bottom:
                        param2.drawRoundRectComplex(0,0,_local_5,_local_6,_local_7,_local_7,0,0);
                        break;
                    case Align.bottomLeft:
                        param2.drawRoundRectComplex(0,0,_local_5,_local_6,0,_local_7,0,0);
                        break;
                    case Align.bottomRight:
                        param2.drawRoundRectComplex(0,0,_local_5,_local_6,_local_7,0,0,0);
                        break;
                    case Align.left:
                        param2.drawRoundRectComplex(0,0,_local_5,_local_6,0,_local_7,0,_local_7);
                        break;
                    case Align.right:
                        param2.drawRoundRectComplex(0,0,_local_5,_local_6,_local_7,0,_local_7,0);
                        break;
                    case Align.center:
                        param2.drawRoundRect(0,0,_local_5,_local_6,_local_7,_local_7);
                }
            } else {
                param2.drawRoundRect(0,0,_local_5,_local_6,_local_7,_local_7);
            }
        }
    }
}
