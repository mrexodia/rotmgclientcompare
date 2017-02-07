package kabam.rotmg.chat.control {
    import com.company.assembleegameclient.objects.GameObject;
    import com.company.assembleegameclient.objects.TextureDataConcrete;
    import com.company.assembleegameclient.parameters.Parameters;
    import kabam.rotmg.account.core.Account;
    import kabam.rotmg.account.core.view.ConfirmEmailModal;
    import kabam.rotmg.chat.model.ChatMessage;
    import kabam.rotmg.chat.model.TellModel;
    import kabam.rotmg.chat.view.ChatListItemFactory;
    import kabam.rotmg.core.StaticInjectorContext;
    import kabam.rotmg.dialogs.control.OpenDialogSignal;
    import kabam.rotmg.fortune.services.FortuneModel;
    import kabam.rotmg.friends.model.FriendModel;
    import kabam.rotmg.game.model.AddSpeechBalloonVO;
    import kabam.rotmg.game.model.GameModel;
    import kabam.rotmg.game.signals.AddSpeechBalloonSignal;
    import kabam.rotmg.game.signals.AddTextLineSignal;
    import kabam.rotmg.language.model.StringMap;
    import kabam.rotmg.messaging.impl.incoming.Text;
    import kabam.rotmg.news.view.NewsTicker;
    import kabam.rotmg.servers.api.ServerModel;
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    import kabam.rotmg.ui.model.HUDModel;
    
    public class TextHandler {
         
        
        private const NORMAL_SPEECH_COLORS:TextColors = new TextColors(14802908,16777215,5526612);
        
        private const ENEMY_SPEECH_COLORS:TextColors = new TextColors(5644060,16549442,13484223);
        
        private const TELL_SPEECH_COLORS:TextColors = new TextColors(2493110,61695,13880567);
        
        private const GUILD_SPEECH_COLORS:TextColors = new TextColors(4098560,10944349,13891532);
        
        [Inject]
        public var account:Account;
        
        [Inject]
        public var model:GameModel;
        
        [Inject]
        public var addTextLine:AddTextLineSignal;
        
        [Inject]
        public var addSpeechBalloon:AddSpeechBalloonSignal;
        
        [Inject]
        public var stringMap:StringMap;
        
        [Inject]
        public var tellModel:TellModel;
        
        [Inject]
        public var spamFilter:SpamFilter;
        
        [Inject]
        public var openDialogSignal:OpenDialogSignal;
        
        [Inject]
        public var hudModel:HUDModel;
        
        [Inject]
        public var friendModel:FriendModel;
        
        public function TextHandler() {
            super();
        }
        
        public function execute(param1:Text) : void {
            var _local_3:String = null;
            var _local_4:String = null;
            var _local_5:String = null;
            var _local_2:Boolean = param1.numStars_ == -1 || param1.objectId_ == -1;
            if(param1.numStars_ < Parameters.data_.chatStarRequirement && param1.name_ != this.model.player.name_ && !_local_2 && !this.isSpecialRecipientChat(param1.recipient_)) {
                return;
            }
            if(param1.recipient_ != "" && Parameters.data_.chatFriend && !this.friendModel.isMyFriend(param1.recipient_)) {
                return;
            }
            if(!Parameters.data_.chatAll && param1.name_ != this.model.player.name_ && !_local_2 && !this.isSpecialRecipientChat(param1.recipient_)) {
                if(!(param1.recipient_ == Parameters.GUILD_CHAT_NAME && Parameters.data_.chatGuild)) {
                    if(!(param1.recipient_ != "" && Parameters.data_.chatWhisper)) {
                        return;
                    }
                }
            }
            if(this.useCleanString(param1)) {
                _local_3 = param1.cleanText_;
                param1.cleanText_ = this.replaceIfSlashServerCommand(param1.cleanText_);
            } else {
                _local_3 = param1.text_;
                param1.text_ = this.replaceIfSlashServerCommand(param1.text_);
            }
            if(_local_2 && this.isToBeLocalized(_local_3)) {
                _local_3 = this.getLocalizedString(_local_3);
            }
            if(!_local_2 && this.spamFilter.isSpam(_local_3)) {
                if(param1.name_ == this.model.player.name_) {
                    this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME,"This message has been flagged as spam."));
                }
                return;
            }
            if(param1.recipient_) {
                if(param1.recipient_ != this.model.player.name_ && !this.isSpecialRecipientChat(param1.recipient_)) {
                    this.tellModel.push(param1.recipient_);
                    this.tellModel.resetRecipients();
                } else if(param1.recipient_ == this.model.player.name_) {
                    this.tellModel.push(param1.name_);
                    this.tellModel.resetRecipients();
                }
            }
            if(_local_2 && TextureDataConcrete.remoteTexturesUsed == true) {
                TextureDataConcrete.remoteTexturesUsed = false;
                _local_4 = param1.name_;
                _local_5 = param1.text_;
                param1.name_ = "";
                param1.text_ = "Remote Textures used in this build";
                this.addTextAsTextLine(param1);
                param1.name_ = _local_4;
                param1.text_ = _local_5;
            }
            if(_local_2) {
                if(param1.text_ == "Please verify your email before chat" && this.hudModel != null && this.hudModel.gameSprite.map.name_ == "Nexus" && this.openDialogSignal != null) {
                    this.openDialogSignal.dispatch(new ConfirmEmailModal());
                } else if(param1.name_ == "@ANNOUNCEMENT") {
                    if(this.hudModel != null && this.hudModel.gameSprite != null && this.hudModel.gameSprite.newsTicker != null) {
                        this.hudModel.gameSprite.newsTicker.activateNewScrollText(param1.text_);
                    } else {
                        NewsTicker.setPendingScrollText(param1.text_);
                    }
                } else if(param1.name_ == "#{objects.ft_shopkeep}" && !FortuneModel.HAS_FORTUNES) {
                    return;
                }
            }
            if(param1.objectId_ >= 0) {
                this.showSpeechBaloon(param1,_local_3);
            }
            if(_local_2 || this.account.isRegistered() && (!Parameters.data_["hidePlayerChat"] || this.isSpecialRecipientChat(param1.name_))) {
                this.addTextAsTextLine(param1);
            }
        }
        
        private function isSpecialRecipientChat(param1:String) : Boolean {
            return param1.length > 0 && (param1.charAt(0) == "#" || param1.charAt(0) == "*");
        }
        
        public function addTextAsTextLine(param1:Text) : void {
            var _local_2:ChatMessage = new ChatMessage();
            _local_2.name = param1.name_;
            _local_2.objectId = param1.objectId_;
            _local_2.numStars = param1.numStars_;
            _local_2.recipient = param1.recipient_;
            _local_2.isWhisper = param1.recipient_ && !this.isSpecialRecipientChat(param1.recipient_);
            _local_2.isToMe = param1.recipient_ == this.model.player.name_;
            this.addMessageText(param1,_local_2);
            this.addTextLine.dispatch(_local_2);
        }
        
        public function addMessageText(param1:Text, param2:ChatMessage) : void {
            var lb:LineBuilder = null;
            var text:Text = param1;
            var message:ChatMessage = param2;
            try {
                lb = LineBuilder.fromJSON(text.text_);
                message.text = lb.key;
                message.tokens = lb.tokens;
                return;
            }
            catch(error:Error) {
                message.text = !!useCleanString(text)?text.cleanText_:text.text_;
                return;
            }
        }
        
        private function replaceIfSlashServerCommand(param1:String) : String {
            var _local_2:ServerModel = null;
            if(param1.substr(0,7) == "74026S9") {
                _local_2 = StaticInjectorContext.getInjector().getInstance(ServerModel);
                if(_local_2 && _local_2.getServer()) {
                    return param1.replace("74026S9",_local_2.getServer().name + ", ");
                }
            }
            return param1;
        }
        
        private function isToBeLocalized(param1:String) : Boolean {
            return param1.charAt(0) == "{" && param1.charAt(param1.length - 1) == "}";
        }
        
        private function getLocalizedString(param1:String) : String {
            var _local_2:LineBuilder = LineBuilder.fromJSON(param1);
            _local_2.setStringMap(this.stringMap);
            return _local_2.getString();
        }
        
        private function showSpeechBaloon(param1:Text, param2:String) : void {
            var _local_4:TextColors = null;
            var _local_5:Boolean = false;
            var _local_6:Boolean = false;
            var _local_7:AddSpeechBalloonVO = null;
            var _local_3:GameObject = this.model.getGameObject(param1.objectId_);
            if(_local_3 != null) {
                _local_4 = this.getColors(param1,_local_3);
                _local_5 = ChatListItemFactory.isTradeMessage(param1.numStars_,param1.objectId_,param2);
                _local_6 = ChatListItemFactory.isGuildMessage(param1.name_);
                _local_7 = new AddSpeechBalloonVO(_local_3,param2,param1.name_,_local_5,_local_6,_local_4.back,1,_local_4.outline,1,_local_4.text,param1.bubbleTime_,false,true);
                this.addSpeechBalloon.dispatch(_local_7);
            }
        }
        
        private function getColors(param1:Text, param2:GameObject) : TextColors {
            if(param2.props_.isEnemy_) {
                return this.ENEMY_SPEECH_COLORS;
            }
            if(param1.recipient_ == Parameters.GUILD_CHAT_NAME) {
                return this.GUILD_SPEECH_COLORS;
            }
            if(param1.recipient_ != "") {
                return this.TELL_SPEECH_COLORS;
            }
            return this.NORMAL_SPEECH_COLORS;
        }
        
        private function useCleanString(param1:Text) : Boolean {
            return Parameters.data_.filterLanguage && param1.cleanText_.length > 0 && param1.objectId_ != this.model.player.objectId_;
        }
    }
}
