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
        
        public function NewsModel() {
            super();
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
        
        public function hasValidNews() : Boolean {
            return this.news[0] != null && this.news[1] != null && this.news[2] != null;
        }
        
        public function hasValidModalNews() : Boolean {
            var _local_1:int = 0;
            while(_local_1 < MODAL_PAGE_COUNT) {
                if(this.modalPageData[_local_1] == null) {
                    return false;
                }
                _local_1++;
            }
            return true;
        }
        
        private function sortByPriority(param1:Vector.<NewsCellVO>) : void {
            var _local_2:NewsCellVO = null;
            for each(_local_2 in param1) {
                if(this.isNewsTimely(_local_2) && this.isValidForPlatform(_local_2)) {
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
        
        public function buildModalPages() : void {
            if(!this.hasValidModalNews()) {
                return;
            }
            this.modalPages = new Vector.<NewsModalPage>(MODAL_PAGE_COUNT,true);
            var _local_1:int = 0;
            while(_local_1 < MODAL_PAGE_COUNT) {
                this.modalPages[_local_1] = new NewsModalPage((this.modalPageData[_local_1] as NewsCellVO).headline,(this.modalPageData[_local_1] as NewsCellVO).linkDetail);
                _local_1++;
            }
        }
        
        public function getModalPage(param1:int) : NewsModalPage {
            if(this.modalPages != null && param1 > 0 && param1 <= this.modalPages.length && this.modalPages[param1 - 1] != null) {
                return this.modalPages[param1 - 1];
            }
            return new NewsModalPage("No new information","Please check back later.");
        }
        
        private function isValidForPlatform(param1:NewsCellVO) : Boolean {
            var _local_2:String = this.account.gameNetwork();
            return param1.networks.indexOf(_local_2) != -1;
        }
    }
}
