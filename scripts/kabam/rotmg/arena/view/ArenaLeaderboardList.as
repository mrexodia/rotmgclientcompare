package kabam.rotmg.arena.view {
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import kabam.lib.ui.api.Size;
    import kabam.rotmg.arena.model.ArenaLeaderboardEntry;
    import kabam.rotmg.util.components.VerticalScrollingList;
    
    public class ArenaLeaderboardList extends Sprite {
         
        
        private const MAX_SIZE:int = 20;
        
        private var listItemPool:Vector.<DisplayObject>;
        
        private var scrollList:VerticalScrollingList;
        
        public function ArenaLeaderboardList() {
            this.listItemPool = new Vector.<DisplayObject>(this.MAX_SIZE);
            this.scrollList = new VerticalScrollingList();
            super();
            var _local_1:int = 0;
            while(_local_1 < this.MAX_SIZE) {
                this.listItemPool[_local_1] = new ArenaLeaderboardListItem();
                _local_1++;
            }
            this.scrollList.setSize(new Size(786,400));
            addChild(this.scrollList);
        }
        
        public function setItems(param1:Vector.<ArenaLeaderboardEntry>, param2:Boolean) : void {
            var _local_4:ArenaLeaderboardEntry = null;
            var _local_5:ArenaLeaderboardListItem = null;
            var _local_3:int = 0;
            while(_local_3 < this.listItemPool.length) {
                _local_4 = _local_3 < param1.length?param1[_local_3]:null;
                _local_5 = this.listItemPool[_local_3] as ArenaLeaderboardListItem;
                _local_5.apply(_local_4,param2);
                _local_3++;
            }
            this.scrollList.setItems(this.listItemPool);
        }
    }
}
