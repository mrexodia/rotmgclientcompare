package kabam.rotmg.news.services {
    import kabam.lib.tasks.BaseTask;
    import kabam.rotmg.appengine.api.AppEngineClient;
    import kabam.rotmg.dialogs.control.AddPopupToStartupQueueSignal;
    import kabam.rotmg.dialogs.control.OpenDialogSignal;
    import kabam.rotmg.dialogs.model.PopupNamesConfig;
    import kabam.rotmg.news.model.InGameNews;
    import kabam.rotmg.news.model.NewsModel;
    import kabam.rotmg.news.view.NewsModal;
    import robotlegs.bender.framework.api.ILogger;
    
    public class GetInGameNewsTask extends BaseTask {
         
        
        [Inject]
        public var logger:ILogger;
        
        [Inject]
        public var client:AppEngineClient;
        
        [Inject]
        public var model:NewsModel;
        
        [Inject]
        public var addToQueueSignal:AddPopupToStartupQueueSignal;
        
        [Inject]
        public var openDialogSignal:OpenDialogSignal;
        
        private var requestData:Object;
        
        public function GetInGameNewsTask() {
            super();
        }
        
        override protected function startTask() : void {
            this.logger.info("GetInGameNewsTask start");
            this.requestData = this.makeRequestData();
            this.sendRequest();
        }
        
        public function makeRequestData() : Object {
            var _local_1:Object = {};
            return _local_1;
        }
        
        private function sendRequest() : void {
            this.client.complete.addOnce(this.onComplete);
            this.client.sendRequest("/inGameNews/getNews",this.requestData);
        }
        
        private function onComplete(param1:Boolean, param2:*) : void {
            this.logger.info("String response from GetInGameNewsTask: " + param2);
            if(param1) {
                this.parseNews(param2);
            } else {
                completeTask(true);
            }
        }
        
        private function parseNews(param1:String) : * {
            var _local_3:Object = null;
            var _local_4:Object = null;
            var _local_5:InGameNews = null;
            this.logger.info("Parsing news");
            try {
                _local_3 = JSON.parse(param1);
                for each(_local_4 in _local_3) {
                    this.logger.info("Parse single news");
                    _local_5 = new InGameNews();
                    _local_5.newsKey = _local_4.newsKey;
                    _local_5.showAtStartup = _local_4.showAtStartup;
                    _local_5.startTime = _local_4.startTime;
                    _local_5.text = _local_4.text;
                    _local_5.title = _local_4.title;
                    _local_5.platform = _local_4.platform;
                    _local_5.weight = _local_4.weight;
                    this.model.addInGameNews(_local_5);
                }
            }
            catch(e:Error) {
            }
            var _local_2:InGameNews = this.model.getFirstNews();
            if(_local_2 && _local_2.showAtStartup && this.model.hasUpdates()) {
                this.addToQueueSignal.dispatch(PopupNamesConfig.NEWS_POPUP,this.openDialogSignal,-1,new NewsModal(true));
            }
            completeTask(true);
        }
    }
}
