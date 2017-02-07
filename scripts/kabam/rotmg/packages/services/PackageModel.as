package kabam.rotmg.packages.services {
    import kabam.rotmg.packages.model.PackageInfo;
    import org.osflash.signals.Signal;
    
    public class PackageModel {
         
        
        public var numSpammed:int = 0;
        
        public var dataChanged:Signal;
        
        private var models:Object;
        
        private var initialized:Boolean;
        
        public function PackageModel() {
            this.dataChanged = new Signal();
            super();
        }
        
        public function getInitialized() : Boolean {
            return this.initialized;
        }
        
        public function getPackageById(param1:int) : PackageInfo {
            return this.models[param1];
        }
        
        public function hasPackage(param1:int) : Boolean {
            return param1 in this.models;
        }
        
        public function setPackages(param1:Array) : void {
            var _local_2:PackageInfo = null;
            this.models = {};
            for each(_local_2 in param1) {
                _local_2.dataChanged.add(this.onDataChanged);
                this.models[_local_2.packageID] = _local_2;
            }
            this.initialized = true;
            this.dataChanged.dispatch();
        }
        
        private function onDataChanged() : void {
            this.dataChanged.dispatch();
        }
        
        public function canPurchasePackage(param1:int) : Boolean {
            var _local_2:PackageInfo = this.models[param1];
            return _local_2 && _local_2.canPurchase();
        }
        
        public function getPriorityPackage() : PackageInfo {
            var _local_2:PackageInfo = null;
            var _local_1:PackageInfo = null;
            for each(_local_2 in this.models) {
                if(_local_1 == null || _local_2.priority < _local_1.priority) {
                    _local_1 = _local_2;
                }
            }
            return _local_2;
        }
        
        public function shouldSpam() : Boolean {
            return this.numSpammed == 0 && "production".toLowerCase() != "localhost";
        }
        
        public function hasPackages() : Boolean {
            var _local_1:Object = null;
            for each(_local_1 in this.models) {
                return true;
            }
            return false;
        }
    }
}
