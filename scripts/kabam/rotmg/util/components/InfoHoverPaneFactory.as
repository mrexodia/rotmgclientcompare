package kabam.rotmg.util.components {
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import kabam.rotmg.pets.view.components.PopupWindowBackground;
    
    public class InfoHoverPaneFactory extends Sprite {
         
        
        public function InfoHoverPaneFactory() {
            super();
        }
        
        public static function make(param1:DisplayObject) : Sprite {
            var _local_4:PopupWindowBackground = null;
            if(param1 == null) {
                return null;
            }
            var _local_2:Sprite = new Sprite();
            var _local_3:int = 8;
            param1.width = 291 - _local_3;
            param1.height = 598 - _local_3 * 2 - 2;
            _local_2.addChild(param1);
            _local_4 = new PopupWindowBackground();
            _local_4.draw(param1.width,param1.height + 2,PopupWindowBackground.TYPE_TRANSPARENT_WITHOUT_HEADER);
            _local_4.x = param1.x;
            _local_4.y = param1.y - 1;
            _local_2.addChild(_local_4);
            return _local_2;
        }
    }
}
