package kabam.rotmg.dialogs.model {
    import com.company.assembleegameclient.parameters.Parameters;
    import org.osflash.signals.Signal;
    
    public class DialogsModel {
         
        
        private var popupPriority:Array;
        
        private var queue:Vector.<PopupQueueEntry>;
        
        public function DialogsModel() {
            this.popupPriority = [PopupNamesConfig.BEGINNERS_OFFER_POPUP,PopupNamesConfig.NEWS_POPUP,PopupNamesConfig.DAILY_LOGIN_POPUP,PopupNamesConfig.PACKAGES_OFFER_POPUP];
            this.queue = new Vector.<PopupQueueEntry>();
            super();
        }
        
        public function addPopupToStartupQueue(param1:String, param2:Signal, param3:int, param4:Object) : void {
            if(param3 == -1 || this.canDisplayPopupToday(param1)) {
                this.queue.push(new PopupQueueEntry(param1,param2,param3,param4));
                this.sortQueue();
            }
        }
        
        private function sortQueue() : void {
            this.queue.sort(function(param1:PopupQueueEntry, param2:PopupQueueEntry):* {
                var _local_3:int = getPopupPriorityByName(param1.name);
                var _local_4:int = getPopupPriorityByName(param2.name);
                if(_local_3 < _local_4) {
                    return -1;
                }
                return 1;
            });
        }
        
        public function flushStartupQueue() : PopupQueueEntry {
            if(this.queue.length == 0) {
                return null;
            }
            var _local_1:PopupQueueEntry = this.queue.shift();
            Parameters.data_[_local_1.name] = new Date().time;
            return _local_1;
        }
        
        public function canDisplayPopupToday(param1:String) : Boolean {
            var _local_2:int = 0;
            var _local_3:int = 0;
            if(!Parameters.data_[param1]) {
                return true;
            }
            _local_2 = Math.floor(Number(Parameters.data_[param1]) / 86400000);
            _local_3 = Math.floor(new Date().time / 86400000);
            return _local_3 > _local_2;
        }
        
        public function getPopupPriorityByName(param1:String) : int {
            var _local_2:int = this.popupPriority.indexOf(param1);
            if(_local_2 < 0) {
                _local_2 = int.MAX_VALUE;
            }
            return _local_2;
        }
    }
}
