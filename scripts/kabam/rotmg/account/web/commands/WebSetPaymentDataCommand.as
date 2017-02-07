package kabam.rotmg.account.web.commands {
    import kabam.rotmg.account.core.Account;
    import kabam.rotmg.account.web.WebAccount;
    
    public class WebSetPaymentDataCommand {
         
        
        [Inject]
        public var characterListData:XML;
        
        [Inject]
        public var account:Account;
        
        public function WebSetPaymentDataCommand() {
            super();
        }
        
        public function execute() : void {
            var _local_2:XML = null;
            var _local_1:WebAccount = this.account as WebAccount;
            if(this.characterListData.hasOwnProperty("KabamPaymentInfo")) {
                _local_2 = XML(this.characterListData.KabamPaymentInfo);
                _local_1.signedRequest = _local_2.signedRequest;
                _local_1.kabamId = _local_2.naid;
            }
        }
    }
}
