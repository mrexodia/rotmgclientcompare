package kabam.rotmg.news.model {
    import com.company.assembleegameclient.parameters.Parameters;
    import kabam.rotmg.account.core.Account;
    import kabam.rotmg.news.controller.NewsButtonRefreshSignal;
    import kabam.rotmg.news.controller.NewsDataUpdatedSignal;
    import kabam.rotmg.news.view.NewsModalPage;
    
    public class NewsModel {
        
        private static const COUNT:int = 3;
        
        public static const MODAL_PAGE_COUNT:int = 4;
         
        
        [Inject]
        public var update:NewsDataUpdatedSignal;
        
        [Inject]
        public var updateNoParams:NewsButtonRefreshSignal;
        
        [Inject]
        public var account:Account;
        
        public var news:Vector.<NewsCellVO>;
        
        public var modalPages:Vector.<NewsModalPage>;
        
        public var modalPageData:Vector.<NewsCellVO>;
        
        private var inGameNews:Vector.<InGameNews>;
        
        public function NewsModel() {
            this.inGameNews = new Vector.<InGameNews>();
            super();
        }
        
        public function addInGameNews(param1:InGameNews) : void {
            if(this.isValidForPlatform(param1)) {
                this.inGameNews.push(param1);
            }
            this.sortNews();
        }
        
        private function sortNews() : * {
            this.inGameNews.sort(function(param1:InGameNews, param2:InGameNews):* {
                if(param1.weight > param2.weight) {
                    return -1;
                }
                if(param1.weight == param2.weight) {
                    return 0;
                }
                return 1;
            });
        }
        
        public function markAsRead() : void {
            var _local_1:InGameNews = this.getFirstNews();
            if(_local_1 != null) {
                Parameters.data_["lastNewsKey"] = _local_1.newsKey;
                Parameters.save();
            }
        }
        
        public function hasUpdates() : Boolean {
            var _local_1:InGameNews = this.getFirstNews();
            if(_local_1 == null || Parameters.data_["lastNewsKey"] == _local_1.newsKey) {
                return false;
            }
            return true;
        }
        
        public function getFirstNews() : InGameNews {
            if(this.inGameNews && this.inGameNews.length > 0) {
                return this.inGameNews[0];
            }
            return null;
        }
        
        public function initNews() : void {
            this.news = new Vector.<NewsCellVO>(COUNT,true);
            var _local_1:int = 0;
            while(_local_1 < COUNT) {
                this.news[_local_1] = new DefaultNewsCellVO(_local_1);
                _local_1++;
            }
        }
        
        public function updateNews(param1:Vector.<NewsCellVO>) : void {
            var _local_3:NewsCellVO = null;
            var _local_4:int = 0;
            var _local_5:int = 0;
            this.initNews();
            var _local_2:Vector.<NewsCellVO> = new Vector.<NewsCellVO>();
            this.modalPageData = new Vector.<NewsCellVO>(4,true);
            for each(_local_3 in param1) {
                if(_local_3.slot <= 3) {
                    _local_2.push(_local_3);
                } else {
                    _local_4 = _local_3.slot - 4;
                    _local_5 = _local_4 + 1;
                    this.modalPageData[_local_4] = _local_3;
                    if(Parameters.data_["newsTimestamp" + _local_5] != _local_3.endDate) {
                        Parameters.data_["newsTimestamp" + _local_5] = _local_3.endDate;
                        Parameters.data_["hasNewsUpdate" + _local_5] = true;
                    }
                }
            }
            this.sortByPriority(_local_2);
            this.update.dispatch(this.news);
            this.updateNoParams.dispatch();
        }
        
        private function sortByPriority(param1:Vector.<NewsCellVO>) : void {
            var _local_2:NewsCellVO = null;
            for each(_local_2 in param1) {
                if(this.isNewsTimely(_local_2) && this.isValidForPlatformGlobal(_local_2)) {
                    this.prioritize(_local_2);
                }
            }
        }
        
        private function prioritize(param1:NewsCellVO) : void {
            var _local_2:uint = param1.slot - 1;
            if(this.news[_local_2]) {
                param1 = this.comparePriority(this.news[_local_2],param1);
            }
            this.news[_local_2] = param1;
        }
        
        private function comparePriority(param1:NewsCellVO, param2:NewsCellVO) : NewsCellVO {
            return param1.priority < param2.priority?param1:param2;
        }
        
        private function isNewsTimely(param1:NewsCellVO) : Boolean {
            var _local_2:Number = new Date().getTime();
            return param1.startDate < _local_2 && _local_2 < param1.endDate;
        }
        
        public function hasValidNews() : Boolean {
            return this.news[0] != null && this.news[1] != null && this.news[2] != null;
        }
        
        public function hasValidModalNews() : Boolean {
            return this.inGameNews.length > 0;
        }
        
        public function get numberOfNews() : int {
            return this.inGameNews.length;
        }
        
        public function getModalPage(param1:int) : NewsModalPage {
            var _local_2:InGameNews = null;
            if(this.hasValidModalNews()) {
                _local_2 = this.inGameNews[param1 - 1];
                return new NewsModalPage(_local_2.title,_local_2.text);
            }
            return new NewsModalPage("No new information","Please check back later.");
        }
        
        private function isValidForPlatformGlobal(param1:NewsCellVO) : Boolean {
            var _local_2:String = this.account.gameNetwork();
            return param1.networks.indexOf(_local_2) != -1;
        }
        
        private function isValidForPlatform(param1:InGameNews) : Boolean {
            var _local_2:String = this.account.gameNetwork();
            return param1.platform.indexOf(_local_2) != -1;
        }
    }
}
