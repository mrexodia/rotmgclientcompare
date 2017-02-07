package kabam.rotmg.account.transfer.services {
    import kabam.lib.tasks.BaseTask;
    import kabam.rotmg.account.core.Account;
    import kabam.rotmg.account.core.services.MigrateAccountTask;
    import kabam.rotmg.account.transfer.model.TransferAccountData;
    import kabam.rotmg.appengine.api.AppEngineClient;
    import kabam.rotmg.application.model.PlatformModel;
    import kabam.rotmg.application.model.PlatformType;
    import kabam.rotmg.core.StaticInjectorContext;
    import kabam.rotmg.core.model.PlayerModel;
    
    public class TransferAccountTask extends BaseTask implements MigrateAccountTask {
         
        
        [Inject]
        public var account:Account;
        
        [Inject]
        public var model:PlayerModel;
        
        [Inject]
        public var transferData:TransferAccountData;
        
        [Inject]
        public var client:AppEngineClient;
        
        public function TransferAccountTask() {
            super();
        }
        
        override protected function startTask() : void {
            this.client.complete.addOnce(this.onComplete);
            this.client.sendRequest("/kabam/link",this.makeDataPacket());
        }
        
        private function onComplete(param1:Boolean, param2:*) : void {
            param1 && this.onLinkDone(param2);
            completeTask(param1,param2);
        }
        
        private function makeDataPacket() : Object {
            var _local_1:Object = {};
            _local_1.kabamemail = this.transferData.currentEmail;
            _local_1.kabampassword = this.transferData.currentPassword;
            _local_1.email = this.transferData.newEmail;
            _local_1.password = this.transferData.newPassword;
            return _local_1;
        }
        
        private function onLinkDone(param1:String) : void {
            var _local_3:XML = null;
            var _local_2:PlatformModel = StaticInjectorContext.getInjector().getInstance(PlatformModel);
            if(_local_2.getPlatform() == PlatformType.WEB) {
                this.account.updateUser(this.transferData.newEmail,this.transferData.newPassword,"");
            } else {
                _local_3 = new XML(param1);
                this.account.updateUser(_local_3.GUID,_local_3.Secret,"");
                this.account.setPlatformToken(_local_3.PlatformToken);
            }
        }
    }
}
