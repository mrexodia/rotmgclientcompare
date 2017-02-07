package kabam.rotmg.pets.view.dialogs.evolving.configuration {
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    
    public class EvolveTransitionConfiguration {
         
        
        public function EvolveTransitionConfiguration() {
            super();
        }
        
        public static function makeBackground() : DisplayObject {
            var _local_1:Sprite = new Sprite();
            _local_1.graphics.beginFill(16777215);
            _local_1.graphics.drawRect(0,0,262,183);
            _local_1.graphics.endFill();
            return _local_1;
        }
    }
}
