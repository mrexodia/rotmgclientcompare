package io.decagames.rotmg.dailyQuests.view.list {
    import com.company.assembleegameclient.ui.Scrollbar;
    import flash.display.Sprite;
    import io.decagames.rotmg.ui.panels.FramedPanel;
    import io.decagames.rotmg.utils.colors.AlphaColor;
    
    public class DailyQuestsList extends Sprite {
        
        public static const LIST_HEIGHT:int = 434;
        
        public static const LIST_WIDTH:int = 230;
        
        public static const SCROLL_WIDTH:int = 14;
        
        public static const SCROLL_TOP_MARGIN:int = 12;
        
        public static const SCROLL_RIGHT_MARGIN:int = 4;
        
        public static const QUEST_ELEMENTS_MARGIN:int = 6;
        
        public static const QUEST_ELEMENTS_LEFT_MARGIN:int = 9;
         
        
        private var _scrollBar:Scrollbar;
        
        private var _list:Sprite;
        
        private var _scrollHeight:int;
        
        public function DailyQuestsList() {
            super();
            var _local_1:FramedPanel = new FramedPanel(LIST_WIDTH,LIST_HEIGHT,5,new AlphaColor(3745793,0.7),new AlphaColor(0,0.7));
            addChild(_local_1);
            this._scrollHeight = LIST_HEIGHT - 2 * SCROLL_TOP_MARGIN;
            this._list = new Sprite();
            addChild(this._list);
            this._list.y = SCROLL_TOP_MARGIN;
            this._list.x = QUEST_ELEMENTS_LEFT_MARGIN;
            var _local_2:Sprite = new Sprite();
            _local_2.graphics.beginFill(16711680);
            _local_2.graphics.drawRect(0,0,LIST_WIDTH,this._scrollHeight);
            _local_2.y = SCROLL_TOP_MARGIN;
            _local_2.x = QUEST_ELEMENTS_LEFT_MARGIN;
            addChild(_local_2);
            this._list.mask = _local_2;
            this._scrollBar = new Scrollbar(SCROLL_WIDTH,this._scrollHeight,0.1,this._list);
            this._scrollBar.x = LIST_WIDTH - SCROLL_WIDTH - SCROLL_RIGHT_MARGIN;
            this._scrollBar.y = SCROLL_TOP_MARGIN;
            this._scrollBar.setIndicatorSize(this._scrollHeight,this._list.height);
            addChild(this._scrollBar);
        }
        
        public function addQuestToList(param1:DailyQuestListElement) : void {
            param1.y = this._list.height + (this._list.numChildren == 0?0:QUEST_ELEMENTS_MARGIN);
            this._list.addChild(param1);
            this._scrollBar.setIndicatorSize(this._scrollHeight,this._list.height);
        }
        
        public function get scrollBar() : Scrollbar {
            return this._scrollBar;
        }
        
        public function get list() : Sprite {
            return this._list;
        }
        
        public function get scrollHeight() : int {
            return this._scrollHeight;
        }
    }
}
