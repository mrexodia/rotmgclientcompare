package kabam.rotmg.account.steam.services {
    import kabam.lib.tasks.BaseTask;
    import kabam.rotmg.account.core.Account;
    import kabam.rotmg.account.core.services.RegisterAccountTask;
    import kabam.rotmg.account.steam.SteamApi;
    import kabam.rotmg.account.web.model.AccountData;
    import kabam.rotmg.appengine.api.AppEngineClient;
    import robotlegs.bender.framework.api.ILogger;
    
    public class SteamRegisterAccountTask extends BaseTask implements RegisterAccountTask {
         
        
        [Inject]
        public var account:Account;
        
        [Inject]
        public var api:SteamApi;
        
        [Inject]
        public var data:AccountData;
        
        [Inject]
        public var logger:ILogger;
        
        [Inject]
        private var client:AppEngineClient;
        
        public function SteamRegisterAccountTask() {
            super();
        }
        
        override protected function startTask() : void {
            this.logger.debug("startTask");
            this.client.setMaxRetries(2);
            this.client.complete.addOnce(this.onComplete);
            this.client.sendRequest("/steamworks/register",this.makeDataPacket());
        }
        
        private function onComplete(param1:Boolean, param2:*) : void {
            if(param1) {
                this.onRegisterDone(param2);
            } else {
                this.onRegisterError(param2);
            }
        }
        
        private function makeDataPacket() : Object {
            var _local_1:Object = this.api.getSessionAuthentication();
            _local_1.newGUID = this.data.username;
            _local_1.newPassword = this.data.password;
            _local_1.entrytag = this.account.getEntryTag();
            return _local_1;
        }
        
        private function onRegisterDone(param1:String) : void {
            var _local_2:XML = new XML(param1);
            this.logger.debug("done - {0}",[_local_2.GUID]);
            this.account.updateUser(_local_2.GUID,_local_2.Secret);
            this.account.setPlatformToken(_local_2.PlatformToken);
            completeTask(true);
        }
        
        private function onRegisterError(param1:String) : void {
            this.logger.debug("error - {0}",[param1]);
            completeTask(false,param1);
        }
    }
}
