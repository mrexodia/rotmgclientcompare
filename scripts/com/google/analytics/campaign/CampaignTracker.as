package com.google.analytics.campaign {
    import com.google.analytics.utils.Variables;
    
    public class CampaignTracker {
         
        
        public var content:String;
        
        public var source:String;
        
        public var clickId:String;
        
        public var name:String;
        
        public var term:String;
        
        public var medium:String;
        
        public var id:String;
        
        public function CampaignTracker(param1:String = "", param2:String = "", param3:String = "", param4:String = "", param5:String = "", param6:String = "", param7:String = "") {
            super();
            this.id = param1;
            this.source = param2;
            this.clickId = param3;
            this.name = param4;
            this.medium = param5;
            this.term = param6;
            this.content = param7;
        }
        
        public function isValid() : Boolean {
            if(id != "" || source != "" || clickId != "") {
                return true;
            }
            return false;
        }
        
        public function toTrackerString() : String {
            var _local_1:Array = [];
            _addIfNotEmpty(_local_1,"utmcid=",id);
            _addIfNotEmpty(_local_1,"utmcsr=",source);
            _addIfNotEmpty(_local_1,"utmgclid=",clickId);
            _addIfNotEmpty(_local_1,"utmccn=",name);
            _addIfNotEmpty(_local_1,"utmcmd=",medium);
            _addIfNotEmpty(_local_1,"utmctr=",term);
            _addIfNotEmpty(_local_1,"utmcct=",content);
            return _local_1.join(CampaignManager.trackingDelimiter);
        }
        
        private function _addIfNotEmpty(param1:Array, param2:String, param3:String) : void {
            if(param3 != null && param3 != "") {
                param3 = param3.split("+").join("%20");
                param3 = param3.split(" ").join("%20");
                param1.push(param2 + param3);
            }
        }
        
        public function fromTrackerString(param1:String) : void {
            var _local_2:String = param1.split(CampaignManager.trackingDelimiter).join("&");
            var _local_3:Variables = new Variables(_local_2);
            if(_local_3.hasOwnProperty("utmcid")) {
                this.id = _local_3["utmcid"];
            }
            if(_local_3.hasOwnProperty("utmcsr")) {
                this.source = _local_3["utmcsr"];
            }
            if(_local_3.hasOwnProperty("utmccn")) {
                this.name = _local_3["utmccn"];
            }
            if(_local_3.hasOwnProperty("utmcmd")) {
                this.medium = _local_3["utmcmd"];
            }
            if(_local_3.hasOwnProperty("utmctr")) {
                this.term = _local_3["utmctr"];
            }
            if(_local_3.hasOwnProperty("utmcct")) {
                this.content = _local_3["utmcct"];
            }
            if(_local_3.hasOwnProperty("utmgclid")) {
                this.clickId = _local_3["utmgclid"];
            }
        }
    }
}
