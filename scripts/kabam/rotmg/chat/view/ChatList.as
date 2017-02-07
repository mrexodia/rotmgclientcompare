package kabam.rotmg.chat.view {
    import flash.display.Sprite;
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    import kabam.rotmg.chat.model.ChatModel;
    
    public class ChatList extends Sprite {
         
        
        private var listItems:Vector.<ChatListItem>;
        
        private var visibleItems:Vector.<ChatListItem>;
        
        private var visibleItemCount:int;
        
        private var index:int;
        
        private var isCurrent:Boolean;
        
        private const timer:Timer = new Timer(1000);
        
        private const itemsToRemove:Vector.<ChatListItem> = new Vector.<ChatListItem>();
        
        private var ignoreTimeOuts:Boolean = false;
        
        private var maxLength:int;
        
        public function ChatList(param1:int = 7, param2:uint = 150) {
            super();
            mouseEnabled = true;
            mouseChildren = true;
            this.listItems = new Vector.<ChatListItem>();
            this.visibleItems = new Vector.<ChatListItem>();
            this.visibleItemCount = param1;
            this.maxLength = param2;
            this.index = 0;
            this.isCurrent = true;
            this.timer.addEventListener(TimerEvent.TIMER,this.onCheckTimeout);
            this.timer.start();
        }
        
        private function onCheckTimeout(param1:TimerEvent) : void {
            var _local_2:ChatListItem = null;
            var _local_3:ChatListItem = null;
            for each(_local_2 in this.visibleItems) {
                if(_local_2.isTimedOut() && !this.ignoreTimeOuts) {
                    this.itemsToRemove.push(_local_2);
                    continue;
                }
                break;
            }
            while(this.itemsToRemove.length > 0) {
                this.onItemTimedOut(this.itemsToRemove.pop());
                if(!this.isCurrent) {
                    _local_3 = this.listItems[this.index++];
                    if(!_local_3.isTimedOut()) {
                        this.addNewItem(_local_3);
                        this.isCurrent = this.index == this.listItems.length;
                        this.positionItems();
                    }
                }
            }
        }
        
        public function setup(param1:ChatModel) : void {
            this.visibleItemCount = param1.visibleItemCount;
        }
        
        public function addMessage(param1:ChatListItem) : void {
            var _local_2:ChatListItem = null;
            if(this.listItems.length > this.maxLength) {
                _local_2 = this.listItems.shift();
                this.onItemTimedOut(_local_2);
                this.index--;
                if(!this.isCurrent && this.index < this.visibleItemCount) {
                    this.pageDown();
                }
            }
            this.listItems.push(param1);
            if(this.isCurrent) {
                this.displayNewItem(param1);
            }
        }
        
        private function onItemTimedOut(param1:ChatListItem) : void {
            var _local_2:int = this.visibleItems.indexOf(param1);
            if(_local_2 != -1) {
                removeChild(param1);
                this.visibleItems.splice(_local_2,1);
                this.isCurrent = this.index == this.listItems.length;
            }
        }
        
        private function displayNewItem(param1:ChatListItem) : void {
            this.index++;
            this.addNewItem(param1);
            this.removeOldestVisibleIfNeeded();
            this.positionItems();
        }
        
        public function scrollUp() : void {
            if(this.ignoreTimeOuts && this.canScrollUp()) {
                this.scrollItemsUp();
            } else {
                this.showAvailable();
            }
            this.ignoreTimeOuts = true;
        }
        
        public function showAvailable() : void {
            var _local_4:ChatListItem = null;
            var _local_1:int = this.index - this.visibleItems.length - 1;
            var _local_2:int = Math.max(0,this.index - this.visibleItemCount - 1);
            var _local_3:int = _local_1;
            while(_local_3 > _local_2) {
                _local_4 = this.listItems[_local_3];
                if(this.visibleItems.indexOf(_local_4) == -1) {
                    this.addOldItem(_local_4);
                }
                _local_3--;
            }
            this.positionItems();
        }
        
        public function scrollDown() : void {
            if(this.ignoreTimeOuts) {
                this.ignoreTimeOuts = false;
                this.scrollToCurrent();
                this.onCheckTimeout(null);
            }
            if(!this.isCurrent) {
                this.scrollItemsDown();
            } else if(this.ignoreTimeOuts) {
                this.ignoreTimeOuts = false;
            }
        }
        
        public function scrollToCurrent() : void {
            while(!this.isCurrent) {
                this.scrollItemsDown();
            }
        }
        
        public function pageUp() : void {
            var _local_1:int = 0;
            if(!this.ignoreTimeOuts) {
                this.showAvailable();
                this.ignoreTimeOuts = true;
            } else {
                _local_1 = 0;
                while(_local_1 < this.visibleItemCount) {
                    if(this.canScrollUp()) {
                        this.scrollItemsUp();
                        _local_1++;
                        continue;
                    }
                    break;
                }
            }
        }
        
        public function pageDown() : void {
            var _local_1:int = 0;
            while(_local_1 < this.visibleItemCount) {
                if(!this.isCurrent) {
                    this.scrollItemsDown();
                    _local_1++;
                    continue;
                }
                this.ignoreTimeOuts = false;
                break;
            }
        }
        
        private function addNewItem(param1:ChatListItem) : void {
            this.visibleItems.push(param1);
            addChild(param1);
        }
        
        private function removeOldestVisibleIfNeeded() : void {
            if(this.visibleItems.length > this.visibleItemCount) {
                removeChild(this.visibleItems.shift());
            }
        }
        
        private function canScrollUp() : Boolean {
            return this.index > this.visibleItemCount;
        }
        
        private function scrollItemsUp() : void {
            var _local_1:ChatListItem = this.listItems[--this.index - this.visibleItemCount];
            this.addOldItem(_local_1);
            this.removeNewestVisibleIfNeeded();
            this.positionItems();
            this.isCurrent = false;
        }
        
        private function scrollItemsDown() : void {
            if(this.index < 0) {
                this.index = 0;
            }
            var _local_1:ChatListItem = this.listItems[this.index];
            this.index++;
            this.addNewItem(_local_1);
            this.removeOldestVisibleIfNeeded();
            this.isCurrent = this.index == this.listItems.length;
            this.positionItems();
        }
        
        private function addOldItem(param1:ChatListItem) : void {
            this.visibleItems.unshift(param1);
            addChild(param1);
        }
        
        private function removeNewestVisibleIfNeeded() : void {
            if(this.visibleItems.length > this.visibleItemCount) {
                removeChild(this.visibleItems.pop());
            }
        }
        
        private function positionItems() : void {
            var _local_3:ChatListItem = null;
            var _local_1:int = 0;
            var _local_2:int = this.visibleItems.length;
            while(_local_2--) {
                _local_3 = this.visibleItems[_local_2];
                _local_3.y = _local_1;
                _local_1 = _local_1 - _local_3.height;
            }
        }
    }
}
