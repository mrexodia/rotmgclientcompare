package kabam.rotmg.appengine.impl {
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;
    import flash.utils.ByteArray;
    import flash.utils.getTimer;
    import kabam.rotmg.appengine.api.RetryLoader;
    import org.osflash.signals.OnceSignal;
    
    public class AppEngineRetryLoader implements RetryLoader {
         
        
        private const _complete:OnceSignal = new OnceSignal(Boolean);
        
        private var maxRetries:int;
        
        private var dataFormat:String;
        
        private var url:String;
        
        private var params:Object;
        
        private var urlRequest:URLRequest;
        
        private var urlLoader:URLLoader;
        
        private var retriesLeft:int;
        
        private var inProgress:Boolean;
        
        public function AppEngineRetryLoader() {
            super();
            this.inProgress = false;
            this.maxRetries = 0;
            this.dataFormat = URLLoaderDataFormat.TEXT;
        }
        
        public function get complete() : OnceSignal {
            return this._complete;
        }
        
        public function isInProgress() : Boolean {
            return this.inProgress;
        }
        
        public function setDataFormat(param1:String) : void {
            this.dataFormat = param1;
        }
        
        public function setMaxRetries(param1:int) : void {
            this.maxRetries = param1;
        }
        
        public function sendRequest(param1:String, param2:Object) : void {
            this.url = param1;
            this.params = param2;
            this.retriesLeft = this.maxRetries;
            this.inProgress = true;
            this.internalSendRequest();
        }
        
        private function internalSendRequest() : void {
            this.cancelPendingRequest();
            this.urlRequest = this.makeUrlRequest();
            this.urlLoader = this.makeUrlLoader();
            this.urlLoader.load(this.urlRequest);
        }
        
        private function makeUrlRequest() : URLRequest {
            var _local_1:URLRequest = new URLRequest(this.url);
            _local_1.method = URLRequestMethod.POST;
            _local_1.data = this.makeUrlVariables();
            return _local_1;
        }
        
        private function makeUrlVariables() : URLVariables {
            var _local_2:* = null;
            var _local_1:URLVariables = new URLVariables();
            _local_1.ignore = getTimer();
            for(_local_2 in this.params) {
                _local_1[_local_2] = this.params[_local_2];
            }
            return _local_1;
        }
        
        private function makeUrlLoader() : URLLoader {
            var _local_1:URLLoader = new URLLoader();
            _local_1.dataFormat = this.dataFormat;
            _local_1.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
            _local_1.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
            _local_1.addEventListener(Event.COMPLETE,this.onComplete);
            return _local_1;
        }
        
        private function onIOError(param1:IOErrorEvent) : void {
            this.inProgress = false;
            var _local_2:String = this.urlLoader.data;
            if(_local_2.length == 0) {
                _local_2 = "Unable to contact server";
            }
            this.retryOrReportError(_local_2);
        }
        
        private function onSecurityError(param1:SecurityErrorEvent) : void {
            this.inProgress = false;
            this.cleanUpAndComplete(false,"Security Error");
        }
        
        private function retryOrReportError(param1:String) : void {
            if(this.retriesLeft-- > 0) {
                this.internalSendRequest();
            } else {
                this.cleanUpAndComplete(false,param1);
            }
        }
        
        private function onComplete(param1:Event) : void {
            this.inProgress = false;
            if(this.dataFormat == URLLoaderDataFormat.TEXT) {
                this.handleTextResponse(this.urlLoader.data);
            } else {
                this.cleanUpAndComplete(true,ByteArray(this.urlLoader.data));
            }
        }
        
        private function handleTextResponse(param1:String) : void {
            if(param1.substring(0,7) == "<Error>") {
                this.retryOrReportError(param1);
            } else if(param1.substring(0,12) == "<FatalError>") {
                this.cleanUpAndComplete(false,param1);
            } else {
                this.cleanUpAndComplete(true,param1);
            }
        }
        
        private function cleanUpAndComplete(param1:Boolean, param2:*) : void {
            if(!param1 && param2 is String) {
                param2 = this.parseXML(param2);
            }
            this.cancelPendingRequest();
            this._complete.dispatch(param1,param2);
        }
        
        private function parseXML(param1:String) : String {
            var _local_2:Array = param1.match("<.*>(.*)</.*>");
            return _local_2 && _local_2.length > 1?_local_2[1]:param1;
        }
        
        private function cancelPendingRequest() : void {
            if(this.urlLoader) {
                this.urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
                this.urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
                this.urlLoader.removeEventListener(Event.COMPLETE,this.onComplete);
                this.closeLoader();
                this.urlLoader = null;
            }
        }
        
        private function closeLoader() : void {
            try {
                this.urlLoader.close();
                return;
            }
            catch(e:Error) {
                return;
            }
        }
    }
}
