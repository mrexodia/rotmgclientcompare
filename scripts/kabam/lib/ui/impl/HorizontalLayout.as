package kabam.lib.ui.impl {
    import flash.display.DisplayObject;
    import kabam.lib.ui.api.Layout;
    
    public class HorizontalLayout implements Layout {
         
        
        private var padding:int = 0;
        
        public function HorizontalLayout() {
            super();
        }
        
        public function getPadding() : int {
            return this.padding;
        }
        
        public function setPadding(param1:int) : void {
            this.padding = param1;
        }
        
        public function layout(param1:Vector.<DisplayObject>, param2:int = 0) : void {
            var _local_6:DisplayObject = null;
            var _local_3:int = param2;
            var _local_4:int = param1.length;
            var _local_5:int = 0;
            while(_local_5 < _local_4) {
                _local_6 = param1[_local_5];
                _local_6.x = _local_3;
                _local_3 = _local_3 + (_local_6.width + this.padding);
                _local_5++;
            }
        }
    }
}
