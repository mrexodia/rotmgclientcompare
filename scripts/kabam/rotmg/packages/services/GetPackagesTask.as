package kabam.rotmg.packages.services {
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    import kabam.lib.tasks.BaseTask;
    import kabam.rotmg.account.core.Account;
    import kabam.rotmg.appengine.api.AppEngineClient;
    import kabam.rotmg.language.model.LanguageModel;
    import kabam.rotmg.packages.model.PackageInfo;
    import robotlegs.bender.framework.api.ILogger;
    
    public class GetPackagesTask extends BaseTask {
        
        private static const HOUR:int = 1000 * 60 * 60;
         
        
        public var timer:Timer;
        
        [Inject]
        public var client:AppEngineClient;
        
        [Inject]
        public var packageModel:PackageModel;
        
        [Inject]
        public var account:Account;
        
        [Inject]
        public var logger:ILogger;
        
        [Inject]
        public var languageModel:LanguageModel;
        
        public function GetPackagesTask() {
            this.timer = new Timer(HOUR);
            super();
        }
        
        override protected function startTask() : void {
            var _local_1:Object = this.account.getCredentials();
            _local_1.language = this.languageModel.getLanguage();
            this.client.sendRequest("/package/getPackages",_local_1);
            this.client.complete.addOnce(this.onComplete);
        }
        
        private function onComplete(param1:Boolean, param2:*) : void {
            if(param1) {
                this.handleOkay(param2);
            } else {
                this.logger.warn("GetPackageTask.onComplete: Request failed.");
                completeTask(false);
            }
        }
        
        private function handleOkay(param1:*) : void {
            var _local_2:XML = null;
            if(this.hasNoPackage(param1)) {
                this.logger.info("GetPackageTask.onComplete: No package available, retrying in 1 hour.");
                this.timer.addEventListener(TimerEvent.TIMER,this.timer_timerHandler);
                this.timer.start();
                this.packageModel.setPackages([]);
            } else {
                _local_2 = XML(param1);
                this.parse(_local_2);
            }
            completeTask(true);
        }
        
        private function hasNoPackage(param1:*) : Boolean {
            var _local_2:XMLList = XML(param1).Packages;
            var _local_3:* = _local_2.length() == 0;
            return _local_3;
        }
        
        private function parse(param1:XML) : void {
            var _local_3:XML = null;
            var _local_4:int = 0;
            var _local_5:String = null;
            var _local_6:int = 0;
            var _local_7:int = 0;
            var _local_8:int = 0;
            var _local_9:int = 0;
            var _local_10:Date = null;
            var _local_11:String = null;
            var _local_12:int = 0;
            var _local_13:PackageInfo = null;
            var _local_2:Array = [];
            for each(_local_3 in param1.Packages.Package) {
                _local_4 = int(_local_3.@id);
                _local_5 = String(_local_3.Name);
                _local_6 = int(_local_3.Price);
                _local_7 = int(_local_3.Quantity);
                _local_8 = int(_local_3.MaxPurchase);
                _local_9 = int(_local_3.Weight);
                _local_10 = new Date(String(_local_3.EndDate));
                _local_11 = String(_local_3.BgURL);
                _local_12 = this.getNumPurchased(param1,_local_4);
                _local_13 = new PackageInfo();
                _local_13.setData(_local_4,_local_10,_local_5,_local_7,_local_8,_local_9,_local_6,_local_11,_local_12);
                _local_2.push(_local_13);
            }
            this.packageModel.setPackages(_local_2);
        }
        
        private function getNumPurchased(param1:XML, param2:int) : int {
            var packageHistory:XMLList = null;
            var packagesXML:XML = param1;
            var packageID:int = param2;
            var numPurchased:int = 0;
            var history:XMLList = packagesXML.History;
            if(history) {
                packageHistory = history.Package.(@id == packageID);
                if(packageHistory) {
                    numPurchased = int(packageHistory.Count);
                }
            }
            return numPurchased;
        }
        
        private function timer_timerHandler(param1:TimerEvent) : void {
            this.timer.removeEventListener(TimerEvent.TIMER,this.timer_timerHandler);
            this.timer.stop();
            this.startTask();
        }
    }
}
