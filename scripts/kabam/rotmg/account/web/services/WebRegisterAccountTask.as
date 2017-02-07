package kabam.rotmg.account.web.services {
    import kabam.lib.tasks.BaseTask;
    import kabam.rotmg.account.core.Account;
    import kabam.rotmg.account.core.services.RegisterAccountTask;
    import kabam.rotmg.account.web.model.AccountData;
    import kabam.rotmg.appengine.api.AppEngineClient;
    import kabam.rotmg.core.model.PlayerModel;
    
    public class WebRegisterAccountTask extends BaseTask implements RegisterAccountTask {
         
        
        [Inject]
        public var data:AccountData;
        
        [Inject]
        public var account:Account;
        
        [Inject]
        public var model:PlayerModel;
        
        [Inject]
        public var client:AppEngineClient;
        
        public function WebRegisterAccountTask() {
            super();
        }
        
        override protected function startTask() : void {
            this.client.complete.addOnce(this.onComplete);
            this.client.sendRequest("/account/register",this.makeDataPacket());
        }
        
        private function makeDataPacket() : Object {
            var _local_1:Object = {};
            _local_1.guid = this.account.getUserId();
            _local_1.newGUID = this.data.username;
            _local_1.newPassword = this.data.password;
            _local_1.entrytag = this.account.getEntryTag();
            _local_1.signedUpKabamEmail = this.data.signedUpKabamEmail;
            _local_1.isAgeVerified = 1;
            return _local_1;
        }
        
        private function onComplete(param1:Boolean, param2:*) : void {
            param1 && this.onRegisterDone(param2);
            completeTask(param1,param2);
        }
        
        private function onRegisterDone(param1:String) : void {
            this.model.setIsAgeVerified(true);
            var _local_2:XML = new XML(param1);
            if(_local_2.hasOwnProperty("token")) {
                this.data.token = _local_2.token;
                this.account.updateUser(this.data.username,this.data.password,_local_2.token);
            } else {
                this.account.updateUser(this.data.username,this.data.password,"");
            }
        }
    }
}
