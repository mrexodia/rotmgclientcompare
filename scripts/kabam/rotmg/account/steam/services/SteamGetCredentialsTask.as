package kabam.rotmg.account.steam.services {
    import com.company.assembleegameclient.ui.dialogs.DebugDialog;
    import kabam.lib.tasks.BaseTask;
    import kabam.rotmg.account.core.Account;
    import kabam.rotmg.account.steam.SteamApi;
    import kabam.rotmg.appengine.api.AppEngineClient;
    import kabam.rotmg.dialogs.control.OpenDialogSignal;
    
    public class SteamGetCredentialsTask extends BaseTask {
        
        private static const ERROR_TEMPLATE:String = "Error: ${error}";
         
        
        [Inject]
        public var account:Account;
        
        [Inject]
        public var steam:SteamApi;
        
        [Inject]
        public var openDialog:OpenDialogSignal;
        
        [Inject]
        public var client:AppEngineClient;
        
        public function SteamGetCredentialsTask() {
            super();
        }
        
        override protected function startTask() : void {
            var _local_1:Object = this.steam.getSessionAuthentication();
            this.client.setMaxRetries(2);
            this.client.complete.addOnce(this.onComplete);
            this.client.sendRequest("/steamworks/getcredentials",_local_1);
        }
        
        private function onComplete(param1:Boolean, param2:*) : void {
            if(param1) {
                this.onGetCredentialsDone(param2);
            } else {
                this.onGetCredentialsError(param2);
            }
            completeTask(param1,param2);
        }
        
        private function onGetCredentialsDone(param1:String) : void {
            var _local_2:XML = new XML(param1);
            this.account.updateUser(_local_2.GUID,_local_2.Secret,"");
            this.account.setPlatformToken(_local_2.PlatformToken);
        }
        
        private function onGetCredentialsError(param1:String) : void {
            var _local_2:String = ERROR_TEMPLATE.replace("${error}",param1);
            var _local_3:DebugDialog = new DebugDialog(_local_2);
            this.openDialog.dispatch(_local_3);
        }
    }
}
