package com.company.assembleegameclient.ui.tooltip {
    import com.company.assembleegameclient.objects.Player;
    import com.company.assembleegameclient.ui.GameObjectListItem;
    import flash.filters.DropShadowFilter;
    import kabam.rotmg.text.model.TextKey;
    import kabam.rotmg.text.view.TextFieldDisplayConcrete;
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    
    public class PlayerGroupToolTip extends ToolTip {
         
        
        public var players_:Vector.<Player> = null;
        
        private var playerPanels_:Vector.<GameObjectListItem>;
        
        private var clickMessage_:TextFieldDisplayConcrete;
        
        public function PlayerGroupToolTip(param1:Vector.<Player>, param2:Boolean = true) {
            this.playerPanels_ = new Vector.<GameObjectListItem>();
            super(3552822,0.5,16777215,1,param2);
            this.clickMessage_ = new TextFieldDisplayConcrete().setSize(12).setColor(11776947);
            this.clickMessage_.setStringBuilder(new LineBuilder().setParams(TextKey.PLAYER_TOOL_TIP_CLICK_MESSAGE));
            this.clickMessage_.filters = [new DropShadowFilter(0,0,0)];
            addChild(this.clickMessage_);
            this.setPlayers(param1);
            if(!param2) {
                filters = [];
            }
            waiter.push(this.clickMessage_.textChanged);
        }
        
        public function setPlayers(param1:Vector.<Player>) : void {
            var _local_3:Player = null;
            var _local_4:GameObjectListItem = null;
            this.clear();
            this.players_ = param1.slice();
            if(this.players_ == null || this.players_.length == 0) {
                return;
            }
            var _local_2:int = 0;
            for each(_local_3 in param1) {
                _local_4 = new GameObjectListItem(11776947,true,_local_3);
                _local_4.x = 0;
                _local_4.y = _local_2;
                addChild(_local_4);
                this.playerPanels_.push(_local_4);
                _local_2 = _local_2 + 32;
            }
            this.clickMessage_.x = width / 2 - this.clickMessage_.width / 2;
            this.clickMessage_.y = _local_2;
            draw();
        }
        
        private function clear() : void {
            var _local_1:GameObjectListItem = null;
            graphics.clear();
            for each(_local_1 in this.playerPanels_) {
                removeChild(_local_1);
            }
            this.playerPanels_.length = 0;
        }
    }
}
