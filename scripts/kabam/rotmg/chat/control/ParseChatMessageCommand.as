package kabam.rotmg.chat.control {
    import com.company.assembleegameclient.parameters.Parameters;
    import com.company.util.MoreObjectUtil;
    import kabam.rotmg.account.core.Account;
    import kabam.rotmg.appengine.api.AppEngineClient;
    import kabam.rotmg.build.api.BuildData;
    import kabam.rotmg.chat.model.ChatMessage;
    import kabam.rotmg.dailyLogin.model.DailyLoginModel;
    import kabam.rotmg.game.signals.AddTextLineSignal;
    import kabam.rotmg.text.model.TextKey;
    import kabam.rotmg.ui.model.HUDModel;
    
    public class ParseChatMessageCommand {
         
        
        [Inject]
        public var data:String;
        
        [Inject]
        public var hudModel:HUDModel;
        
        [Inject]
        public var addTextLine:AddTextLineSignal;
        
        [Inject]
        public var client:AppEngineClient;
        
        [Inject]
        public var account:Account;
        
        [Inject]
        public var buildData:BuildData;
        
        [Inject]
        public var dailyLoginModel:DailyLoginModel;
        
        public function ParseChatMessageCommand() {
            super();
        }
        
        public function execute() : void {
            var _local_1:Object = null;
            switch(this.data) {
                case "/resetDailyQuests":
                    if("production".toLowerCase() != "testing" || "production".toLowerCase() != "localhost") {
                        _local_1 = {};
                        MoreObjectUtil.addToObject(_local_1,this.account.getCredentials());
                        this.client.sendRequest("/dailyquest/resetDailyQuests",_local_1);
                        this.addTextLine.dispatch(ChatMessage.make(Parameters.SERVER_CHAT_NAME,"Restarting daily quests..."));
                    }
                    break;
                case "/help":
                    this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME,TextKey.HELP_COMMAND));
                    break;
                default:
                    this.hudModel.gameSprite.gsc_.playerText(this.data);
            }
        }
    }
}
