package kabam.rotmg.classes.view {
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import kabam.lib.ui.api.Size;
    import kabam.rotmg.util.components.VerticalScrollingList;
    
    public class CharacterSkinListView extends Sprite {
        
        public static const PADDING:int = 5;
        
        public static const WIDTH:int = 442;
        
        public static const HEIGHT:int = 400;
         
        
        private const list:VerticalScrollingList = this.makeList();
        
        private var items:Vector.<DisplayObject>;
        
        public function CharacterSkinListView() {
            super();
        }
        
        private function makeList() : VerticalScrollingList {
            var _local_1:VerticalScrollingList = new VerticalScrollingList();
            _local_1.setSize(new Size(WIDTH,HEIGHT));
            _local_1.scrollStateChanged.add(this.onScrollStateChanged);
            _local_1.setPadding(PADDING);
            addChild(_local_1);
            return _local_1;
        }
        
        public function setItems(param1:Vector.<DisplayObject>) : void {
            this.items = param1;
            this.list.setItems(param1);
            this.onScrollStateChanged(this.list.isScrollbarVisible());
        }
        
        private function onScrollStateChanged(param1:Boolean) : void {
            var _local_3:CharacterSkinListItem = null;
            var _local_2:int = CharacterSkinListItem.WIDTH;
            if(!param1) {
                _local_2 = _local_2 + VerticalScrollingList.SCROLLBAR_GUTTER;
            }
            for each(_local_3 in this.items) {
                _local_3.setWidth(_local_2);
            }
        }
        
        public function getListHeight() : Number {
            return this.list.getListHeight();
        }
    }
}
