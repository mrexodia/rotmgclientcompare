package kabam.rotmg.arena.util {
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import flash.display.Bitmap;
    import flash.filters.DropShadowFilter;
    import kabam.rotmg.text.view.TextFieldDisplayConcrete;
    
    public class ArenaViewAssetFactory {
         
        
        public function ArenaViewAssetFactory() {
            super();
        }
        
        public static function returnTextfield(param1:int, param2:int, param3:Boolean, param4:Boolean = false) : TextFieldDisplayConcrete {
            var _local_5:TextFieldDisplayConcrete = new TextFieldDisplayConcrete();
            _local_5.setSize(param2).setColor(param1).setBold(param3);
            _local_5.setVerticalAlign(TextFieldDisplayConcrete.BOTTOM);
            _local_5.filters = !!param4?[new DropShadowFilter(0,0,0)]:[];
            return _local_5;
        }
        
        public static function returnHostBitmap(param1:uint) : Bitmap {
            return new Bitmap(ObjectLibrary.getRedrawnTextureFromType(param1,80,true));
        }
    }
}
