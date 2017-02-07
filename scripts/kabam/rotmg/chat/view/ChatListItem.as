package kabam.rotmg.chat.view {
    import com.company.assembleegameclient.objects.Player;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import flash.utils.getTimer;
    import kabam.rotmg.core.StaticInjectorContext;
    import kabam.rotmg.ui.model.HUDModel;
    
    public class ChatListItem extends Sprite {
        
        private static const CHAT_ITEM_TIMEOUT:uint = 20000;
         
        
        private var itemWidth:int;
        
        private var list:Vector.<DisplayObject>;
        
        private var count:uint;
        
        private var layoutHeight:uint;
        
        private var creationTime:uint;
        
        private var timedOutOverride:Boolean;
        
        public var playerObjectId:int;
        
        public var playerName:String = "";
        
        public var fromGuild:Boolean = false;
        
        public var isTrade:Boolean = false;
        
        public function ChatListItem(param1:Vector.<DisplayObject>, param2:int, param3:int, param4:Boolean, param5:int, param6:String, param7:Boolean, param8:Boolean) {
            super();
            mouseEnabled = true;
            this.itemWidth = param2;
            this.layoutHeight = param3;
            this.list = param1;
            this.count = param1.length;
            this.creationTime = getTimer();
            this.timedOutOverride = param4;
            this.playerObjectId = param5;
            this.playerName = param6;
            this.fromGuild = param7;
            this.isTrade = param8;
            this.layoutItems();
            this.addItems();
            addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,this.onRightMouseDown);
        }
        
        public function onRightMouseDown(param1:MouseEvent) : void {
            var hmod:HUDModel = null;
            var aPlayer:Player = null;
            var e:MouseEvent = param1;
            try {
                hmod = StaticInjectorContext.getInjector().getInstance(HUDModel);
                if(hmod.gameSprite.map.goDict_[this.playerObjectId] != null && hmod.gameSprite.map.goDict_[this.playerObjectId] is Player && hmod.gameSprite.map.player_.objectId_ != this.playerObjectId) {
                    aPlayer = hmod.gameSprite.map.goDict_[this.playerObjectId] as Player;
                    hmod.gameSprite.addChatPlayerMenu(aPlayer,e.stageX,e.stageY);
                } else if(!this.isTrade && this.playerName != null && this.playerName != "" && hmod.gameSprite.map.player_.name_ != this.playerName) {
                    hmod.gameSprite.addChatPlayerMenu(null,e.stageX,e.stageY,this.playerName,this.fromGuild);
                } else if(this.isTrade && this.playerName != null && this.playerName != "" && hmod.gameSprite.map.player_.name_ != this.playerName) {
                    hmod.gameSprite.addChatPlayerMenu(null,e.stageX,e.stageY,this.playerName,false,true);
                }
                return;
            }
            catch(e:Error) {
                return;
            }
        }
        
        public function isTimedOut() : Boolean {
            return getTimer() > this.creationTime + CHAT_ITEM_TIMEOUT || this.timedOutOverride;
        }
        
        private function layoutItems() : void {
            var _local_1:int = 0;
            var _local_3:DisplayObject = null;
            var _local_4:Rectangle = null;
            var _local_5:int = 0;
            _local_1 = 0;
            var _local_2:int = 0;
            while(_local_2 < this.count) {
                _local_3 = this.list[_local_2];
                _local_4 = _local_3.getRect(_local_3);
                _local_3.x = _local_1;
                _local_3.y = (this.layoutHeight - _local_4.height) * 0.5 - this.layoutHeight;
                if(_local_1 + _local_4.width > this.itemWidth) {
                    _local_3.x = 0;
                    _local_1 = 0;
                    _local_5 = 0;
                    while(_local_5 < _local_2) {
                        this.list[_local_5].y = this.list[_local_5].y - this.layoutHeight;
                        _local_5++;
                    }
                }
                _local_1 = _local_1 + _local_4.width;
                _local_2++;
            }
        }
        
        private function addItems() : void {
            var _local_1:DisplayObject = null;
            for each(_local_1 in this.list) {
                addChild(_local_1);
            }
        }
    }
}
