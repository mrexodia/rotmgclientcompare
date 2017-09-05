package kabam.rotmg.messaging.impl {
    import com.company.assembleegameclient.game.AGameSprite;
    import com.company.assembleegameclient.game.events.GuildResultEvent;
    import com.company.assembleegameclient.game.events.KeyInfoResponseSignal;
    import com.company.assembleegameclient.game.events.NameResultEvent;
    import com.company.assembleegameclient.game.events.ReconnectEvent;
    import com.company.assembleegameclient.map.AbstractMap;
    import com.company.assembleegameclient.map.GroundLibrary;
    import com.company.assembleegameclient.map.mapoverlay.CharacterStatusText;
    import com.company.assembleegameclient.objects.Container;
    import com.company.assembleegameclient.objects.FlashDescription;
    import com.company.assembleegameclient.objects.GameObject;
    import com.company.assembleegameclient.objects.Merchant;
    import com.company.assembleegameclient.objects.NameChanger;
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import com.company.assembleegameclient.objects.ObjectProperties;
    import com.company.assembleegameclient.objects.Pet;
    import com.company.assembleegameclient.objects.Player;
    import com.company.assembleegameclient.objects.Portal;
    import com.company.assembleegameclient.objects.Projectile;
    import com.company.assembleegameclient.objects.ProjectileProperties;
    import com.company.assembleegameclient.objects.SellableObject;
    import com.company.assembleegameclient.objects.particles.AOEEffect;
    import com.company.assembleegameclient.objects.particles.BurstEffect;
    import com.company.assembleegameclient.objects.particles.CollapseEffect;
    import com.company.assembleegameclient.objects.particles.ConeBlastEffect;
    import com.company.assembleegameclient.objects.particles.FlowEffect;
    import com.company.assembleegameclient.objects.particles.HealEffect;
    import com.company.assembleegameclient.objects.particles.LightningEffect;
    import com.company.assembleegameclient.objects.particles.LineEffect;
    import com.company.assembleegameclient.objects.particles.NovaEffect;
    import com.company.assembleegameclient.objects.particles.ParticleEffect;
    import com.company.assembleegameclient.objects.particles.PoisonEffect;
    import com.company.assembleegameclient.objects.particles.RingEffect;
    import com.company.assembleegameclient.objects.particles.RisingFuryEffect;
    import com.company.assembleegameclient.objects.particles.ShockeeEffect;
    import com.company.assembleegameclient.objects.particles.ShockerEffect;
    import com.company.assembleegameclient.objects.particles.StreamEffect;
    import com.company.assembleegameclient.objects.particles.TeleportEffect;
    import com.company.assembleegameclient.objects.particles.ThrowEffect;
    import com.company.assembleegameclient.objects.thrown.ThrowProjectileEffect;
    import com.company.assembleegameclient.parameters.Parameters;
    import com.company.assembleegameclient.sound.SoundEffectLibrary;
    import com.company.assembleegameclient.ui.PicView;
    import com.company.assembleegameclient.ui.dialogs.Dialog;
    import com.company.assembleegameclient.ui.dialogs.NotEnoughFameDialog;
    import com.company.assembleegameclient.ui.panels.GuildInvitePanel;
    import com.company.assembleegameclient.ui.panels.TradeRequestPanel;
    import com.company.assembleegameclient.util.ConditionEffect;
    import com.company.assembleegameclient.util.Currency;
    import com.company.assembleegameclient.util.FreeList;
    import com.company.util.MoreStringUtil;
    import com.company.util.Random;
    import com.hurlant.crypto.Crypto;
    import com.hurlant.crypto.rsa.RSAKey;
    import com.hurlant.crypto.symmetric.ICipher;
    import com.hurlant.util.Base64;
    import com.hurlant.util.der.PEM;
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.geom.Point;
    import flash.net.FileReference;
    import flash.utils.ByteArray;
    import flash.utils.Timer;
    import flash.utils.getTimer;
    import kabam.lib.net.api.MessageMap;
    import kabam.lib.net.api.MessageProvider;
    import kabam.lib.net.impl.Message;
    import kabam.lib.net.impl.SocketServer;
    import kabam.rotmg.account.core.Account;
    import kabam.rotmg.account.core.view.PurchaseConfirmationDialog;
    import kabam.rotmg.arena.control.ArenaDeathSignal;
    import kabam.rotmg.arena.control.ImminentArenaWaveSignal;
    import kabam.rotmg.arena.model.CurrentArenaRunModel;
    import kabam.rotmg.arena.view.BattleSummaryDialog;
    import kabam.rotmg.arena.view.ContinueOrQuitDialog;
    import kabam.rotmg.chat.model.ChatMessage;
    import kabam.rotmg.classes.model.CharacterClass;
    import kabam.rotmg.classes.model.CharacterSkin;
    import kabam.rotmg.classes.model.CharacterSkinState;
    import kabam.rotmg.classes.model.ClassesModel;
    import kabam.rotmg.constants.GeneralConstants;
    import kabam.rotmg.constants.ItemConstants;
    import kabam.rotmg.core.StaticInjectorContext;
    import kabam.rotmg.dailyLogin.message.ClaimDailyRewardMessage;
    import kabam.rotmg.dailyLogin.message.ClaimDailyRewardResponse;
    import kabam.rotmg.dailyLogin.signal.ClaimDailyRewardResponseSignal;
    import kabam.rotmg.death.control.HandleDeathSignal;
    import kabam.rotmg.death.control.ZombifySignal;
    import kabam.rotmg.dialogs.control.CloseDialogsSignal;
    import kabam.rotmg.dialogs.control.OpenDialogSignal;
    import kabam.rotmg.friends.model.FriendModel;
    import kabam.rotmg.game.focus.control.SetGameFocusSignal;
    import kabam.rotmg.game.model.GameModel;
    import kabam.rotmg.game.model.PotionInventoryModel;
    import kabam.rotmg.game.signals.AddSpeechBalloonSignal;
    import kabam.rotmg.game.signals.AddTextLineSignal;
    import kabam.rotmg.game.signals.GiftStatusUpdateSignal;
    import kabam.rotmg.game.view.components.QueuedStatusText;
    import kabam.rotmg.maploading.signals.ChangeMapSignal;
    import kabam.rotmg.maploading.signals.HideMapLoadingSignal;
    import kabam.rotmg.messaging.impl.data.GroundTileData;
    import kabam.rotmg.messaging.impl.data.ObjectData;
    import kabam.rotmg.messaging.impl.data.ObjectStatusData;
    import kabam.rotmg.messaging.impl.data.StatData;
    import kabam.rotmg.messaging.impl.incoming.AccountList;
    import kabam.rotmg.messaging.impl.incoming.AllyShoot;
    import kabam.rotmg.messaging.impl.incoming.Aoe;
    import kabam.rotmg.messaging.impl.incoming.BuyResult;
    import kabam.rotmg.messaging.impl.incoming.ClientStat;
    import kabam.rotmg.messaging.impl.incoming.CreateSuccess;
    import kabam.rotmg.messaging.impl.incoming.Damage;
    import kabam.rotmg.messaging.impl.incoming.Death;
    import kabam.rotmg.messaging.impl.incoming.EnemyShoot;
    import kabam.rotmg.messaging.impl.incoming.EvolvedMessageHandler;
    import kabam.rotmg.messaging.impl.incoming.EvolvedPetMessage;
    import kabam.rotmg.messaging.impl.incoming.Failure;
    import kabam.rotmg.messaging.impl.incoming.File;
    import kabam.rotmg.messaging.impl.incoming.GlobalNotification;
    import kabam.rotmg.messaging.impl.incoming.Goto;
    import kabam.rotmg.messaging.impl.incoming.GuildResult;
    import kabam.rotmg.messaging.impl.incoming.InvResult;
    import kabam.rotmg.messaging.impl.incoming.InvitedToGuild;
    import kabam.rotmg.messaging.impl.incoming.KeyInfoResponse;
    import kabam.rotmg.messaging.impl.incoming.MapInfo;
    import kabam.rotmg.messaging.impl.incoming.NameResult;
    import kabam.rotmg.messaging.impl.incoming.NewAbilityMessage;
    import kabam.rotmg.messaging.impl.incoming.NewTick;
    import kabam.rotmg.messaging.impl.incoming.Notification;
    import kabam.rotmg.messaging.impl.incoming.PasswordPrompt;
    import kabam.rotmg.messaging.impl.incoming.Pic;
    import kabam.rotmg.messaging.impl.incoming.Ping;
    import kabam.rotmg.messaging.impl.incoming.PlaySound;
    import kabam.rotmg.messaging.impl.incoming.QuestFetchResponse;
    import kabam.rotmg.messaging.impl.incoming.QuestObjId;
    import kabam.rotmg.messaging.impl.incoming.QuestRedeemResponse;
    import kabam.rotmg.messaging.impl.incoming.Reconnect;
    import kabam.rotmg.messaging.impl.incoming.ReskinUnlock;
    import kabam.rotmg.messaging.impl.incoming.ServerPlayerShoot;
    import kabam.rotmg.messaging.impl.incoming.ShowEffect;
    import kabam.rotmg.messaging.impl.incoming.TradeAccepted;
    import kabam.rotmg.messaging.impl.incoming.TradeChanged;
    import kabam.rotmg.messaging.impl.incoming.TradeDone;
    import kabam.rotmg.messaging.impl.incoming.TradeRequested;
    import kabam.rotmg.messaging.impl.incoming.TradeStart;
    import kabam.rotmg.messaging.impl.incoming.Update;
    import kabam.rotmg.messaging.impl.incoming.VerifyEmail;
    import kabam.rotmg.messaging.impl.incoming.arena.ArenaDeath;
    import kabam.rotmg.messaging.impl.incoming.arena.ImminentArenaWave;
    import kabam.rotmg.messaging.impl.incoming.pets.DeletePetMessage;
    import kabam.rotmg.messaging.impl.incoming.pets.HatchPetMessage;
    import kabam.rotmg.messaging.impl.outgoing.AcceptTrade;
    import kabam.rotmg.messaging.impl.outgoing.ActivePetUpdateRequest;
    import kabam.rotmg.messaging.impl.outgoing.AoeAck;
    import kabam.rotmg.messaging.impl.outgoing.Buy;
    import kabam.rotmg.messaging.impl.outgoing.CancelTrade;
    import kabam.rotmg.messaging.impl.outgoing.ChangeGuildRank;
    import kabam.rotmg.messaging.impl.outgoing.ChangeTrade;
    import kabam.rotmg.messaging.impl.outgoing.CheckCredits;
    import kabam.rotmg.messaging.impl.outgoing.ChooseName;
    import kabam.rotmg.messaging.impl.outgoing.Create;
    import kabam.rotmg.messaging.impl.outgoing.CreateGuild;
    import kabam.rotmg.messaging.impl.outgoing.EditAccountList;
    import kabam.rotmg.messaging.impl.outgoing.EnemyHit;
    import kabam.rotmg.messaging.impl.outgoing.Escape;
    import kabam.rotmg.messaging.impl.outgoing.GoToQuestRoom;
    import kabam.rotmg.messaging.impl.outgoing.GotoAck;
    import kabam.rotmg.messaging.impl.outgoing.GroundDamage;
    import kabam.rotmg.messaging.impl.outgoing.GuildInvite;
    import kabam.rotmg.messaging.impl.outgoing.GuildRemove;
    import kabam.rotmg.messaging.impl.outgoing.Hello;
    import kabam.rotmg.messaging.impl.outgoing.InvDrop;
    import kabam.rotmg.messaging.impl.outgoing.InvSwap;
    import kabam.rotmg.messaging.impl.outgoing.JoinGuild;
    import kabam.rotmg.messaging.impl.outgoing.KeyInfoRequest;
    import kabam.rotmg.messaging.impl.outgoing.Load;
    import kabam.rotmg.messaging.impl.outgoing.Move;
    import kabam.rotmg.messaging.impl.outgoing.OtherHit;
    import kabam.rotmg.messaging.impl.outgoing.OutgoingMessage;
    import kabam.rotmg.messaging.impl.outgoing.PlayerHit;
    import kabam.rotmg.messaging.impl.outgoing.PlayerShoot;
    import kabam.rotmg.messaging.impl.outgoing.PlayerText;
    import kabam.rotmg.messaging.impl.outgoing.Pong;
    import kabam.rotmg.messaging.impl.outgoing.RequestTrade;
    import kabam.rotmg.messaging.impl.outgoing.Reskin;
    import kabam.rotmg.messaging.impl.outgoing.SetCondition;
    import kabam.rotmg.messaging.impl.outgoing.ShootAck;
    import kabam.rotmg.messaging.impl.outgoing.SquareHit;
    import kabam.rotmg.messaging.impl.outgoing.Teleport;
    import kabam.rotmg.messaging.impl.outgoing.UseItem;
    import kabam.rotmg.messaging.impl.outgoing.UsePortal;
    import kabam.rotmg.messaging.impl.outgoing.arena.EnterArena;
    import kabam.rotmg.messaging.impl.outgoing.arena.QuestRedeem;
    import kabam.rotmg.minimap.control.UpdateGameObjectTileSignal;
    import kabam.rotmg.minimap.control.UpdateGroundTileSignal;
    import kabam.rotmg.minimap.model.UpdateGroundTileVO;
    import kabam.rotmg.pets.controller.DeletePetSignal;
    import kabam.rotmg.pets.controller.HatchPetSignal;
    import kabam.rotmg.pets.controller.NewAbilitySignal;
    import kabam.rotmg.pets.controller.PetFeedResultSignal;
    import kabam.rotmg.pets.controller.UpdateActivePet;
    import kabam.rotmg.pets.controller.UpdatePetYardSignal;
    import kabam.rotmg.pets.data.PetsModel;
    import kabam.rotmg.questrewards.controller.QuestFetchCompleteSignal;
    import kabam.rotmg.questrewards.controller.QuestRedeemCompleteSignal;
    import kabam.rotmg.servers.api.Server;
    import kabam.rotmg.text.model.TextKey;
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    import kabam.rotmg.ui.model.Key;
    import kabam.rotmg.ui.model.UpdateGameObjectTileVO;
    import kabam.rotmg.ui.signals.ShowHideKeyUISignal;
    import kabam.rotmg.ui.signals.ShowKeySignal;
    import kabam.rotmg.ui.signals.UpdateBackpackTabSignal;
    import kabam.rotmg.ui.view.NotEnoughGoldDialog;
    import kabam.rotmg.ui.view.TitleView;
    import org.swiftsuspenders.Injector;
    import robotlegs.bender.framework.api.ILogger;
    
    public class GameServerConnectionConcrete extends GameServerConnection {
        
        private static const TO_MILLISECONDS:int = 1000;
         
        
        private var petUpdater:PetUpdater;
        
        private var messages:MessageProvider;
        
        private var playerId_:int = -1;
        
        private var player:Player;
        
        private var retryConnection_:Boolean = true;
        
        private var rand_:Random = null;
        
        private var giftChestUpdateSignal:GiftStatusUpdateSignal;
        
        private var death:Death;
        
        private var retryTimer_:Timer;
        
        private var delayBeforeReconnect:int = 2;
        
        private var addTextLine:AddTextLineSignal;
        
        private var addSpeechBalloon:AddSpeechBalloonSignal;
        
        private var updateGroundTileSignal:UpdateGroundTileSignal;
        
        private var updateGameObjectTileSignal:UpdateGameObjectTileSignal;
        
        private var logger:ILogger;
        
        private var handleDeath:HandleDeathSignal;
        
        private var zombify:ZombifySignal;
        
        private var setGameFocus:SetGameFocusSignal;
        
        private var updateBackpackTab:UpdateBackpackTabSignal;
        
        private var petFeedResult:PetFeedResultSignal;
        
        private var closeDialogs:CloseDialogsSignal;
        
        private var openDialog:OpenDialogSignal;
        
        private var arenaDeath:ArenaDeathSignal;
        
        private var imminentWave:ImminentArenaWaveSignal;
        
        private var questFetchComplete:QuestFetchCompleteSignal;
        
        private var questRedeemComplete:QuestRedeemCompleteSignal;
        
        private var keyInfoResponse:KeyInfoResponseSignal;
        
        private var claimDailyRewardResponse:ClaimDailyRewardResponseSignal;
        
        private var currentArenaRun:CurrentArenaRunModel;
        
        private var classesModel:ClassesModel;
        
        private var injector:Injector;
        
        private var model:GameModel;
        
        private var updateActivePet:UpdateActivePet;
        
        private var petsModel:PetsModel;
        
        private var friendModel:FriendModel;
        
        public function GameServerConnectionConcrete(param1:AGameSprite, param2:Server, param3:int, param4:Boolean, param5:int, param6:int, param7:ByteArray, param8:String, param9:Boolean) {
            super();
            this.injector = StaticInjectorContext.getInjector();
            this.giftChestUpdateSignal = this.injector.getInstance(GiftStatusUpdateSignal);
            this.addTextLine = this.injector.getInstance(AddTextLineSignal);
            this.addSpeechBalloon = this.injector.getInstance(AddSpeechBalloonSignal);
            this.updateGroundTileSignal = this.injector.getInstance(UpdateGroundTileSignal);
            this.updateGameObjectTileSignal = this.injector.getInstance(UpdateGameObjectTileSignal);
            this.petFeedResult = this.injector.getInstance(PetFeedResultSignal);
            this.updateBackpackTab = StaticInjectorContext.getInjector().getInstance(UpdateBackpackTabSignal);
            this.updateActivePet = this.injector.getInstance(UpdateActivePet);
            this.petsModel = this.injector.getInstance(PetsModel);
            this.friendModel = this.injector.getInstance(FriendModel);
            this.closeDialogs = this.injector.getInstance(CloseDialogsSignal);
            changeMapSignal = this.injector.getInstance(ChangeMapSignal);
            this.openDialog = this.injector.getInstance(OpenDialogSignal);
            this.arenaDeath = this.injector.getInstance(ArenaDeathSignal);
            this.imminentWave = this.injector.getInstance(ImminentArenaWaveSignal);
            this.questFetchComplete = this.injector.getInstance(QuestFetchCompleteSignal);
            this.questRedeemComplete = this.injector.getInstance(QuestRedeemCompleteSignal);
            this.keyInfoResponse = this.injector.getInstance(KeyInfoResponseSignal);
            this.claimDailyRewardResponse = this.injector.getInstance(ClaimDailyRewardResponseSignal);
            this.logger = this.injector.getInstance(ILogger);
            this.handleDeath = this.injector.getInstance(HandleDeathSignal);
            this.zombify = this.injector.getInstance(ZombifySignal);
            this.setGameFocus = this.injector.getInstance(SetGameFocusSignal);
            this.classesModel = this.injector.getInstance(ClassesModel);
            serverConnection = this.injector.getInstance(SocketServer);
            this.messages = this.injector.getInstance(MessageProvider);
            this.model = this.injector.getInstance(GameModel);
            this.currentArenaRun = this.injector.getInstance(CurrentArenaRunModel);
            gs_ = param1;
            server_ = param2;
            gameId_ = param3;
            createCharacter_ = param4;
            charId_ = param5;
            keyTime_ = param6;
            key_ = param7;
            mapJSON_ = param8;
            isFromArena_ = param9;
            this.friendModel.setCurrentServer(server_);
            this.getPetUpdater();
            instance = this;
        }
        
        private static function isStatPotion(param1:int) : Boolean {
            return param1 == 2591 || param1 == 5465 || param1 == 9064 || (param1 == 2592 || param1 == 5466 || param1 == 9065) || (param1 == 2593 || param1 == 5467 || param1 == 9066) || (param1 == 2612 || param1 == 5468 || param1 == 9067) || (param1 == 2613 || param1 == 5469 || param1 == 9068) || (param1 == 2636 || param1 == 5470 || param1 == 9069) || (param1 == 2793 || param1 == 5471 || param1 == 9070) || (param1 == 2794 || param1 == 5472 || param1 == 9071);
        }
        
        private function getPetUpdater() : void {
            this.injector.map(AGameSprite).toValue(gs_);
            this.petUpdater = this.injector.getInstance(PetUpdater);
            this.injector.unmap(AGameSprite);
        }
        
        override public function disconnect() : void {
            this.removeServerConnectionListeners();
            this.unmapMessages();
            serverConnection.disconnect();
        }
        
        private function removeServerConnectionListeners() : void {
            serverConnection.connected.remove(this.onConnected);
            serverConnection.closed.remove(this.onClosed);
            serverConnection.error.remove(this.onError);
        }
        
        override public function connect() : void {
            this.addServerConnectionListeners();
            this.mapMessages();
            var _local_1:ChatMessage = new ChatMessage();
            _local_1.name = Parameters.CLIENT_CHAT_NAME;
            _local_1.text = TextKey.CHAT_CONNECTING_TO;
            var _local_2:String = server_.name;
            if(_local_2 == "{\"text\":\"server.vault\"}") {
                _local_2 = "server.vault";
            }
            _local_2 = LineBuilder.getLocalizedStringFromKey(_local_2);
            _local_1.tokens = {"serverName":_local_2};
            this.addTextLine.dispatch(_local_1);
            serverConnection.connect(server_.address,server_.port);
        }
        
        public function addServerConnectionListeners() : void {
            serverConnection.connected.add(this.onConnected);
            serverConnection.closed.add(this.onClosed);
            serverConnection.error.add(this.onError);
        }
        
        public function mapMessages() : void {
            var _local_1:MessageMap = this.injector.getInstance(MessageMap);
            _local_1.map(CREATE).toMessage(Create);
            _local_1.map(PLAYERSHOOT).toMessage(PlayerShoot);
            _local_1.map(MOVE).toMessage(Move);
            _local_1.map(PLAYERTEXT).toMessage(PlayerText);
            _local_1.map(UPDATEACK).toMessage(Message);
            _local_1.map(INVSWAP).toMessage(InvSwap);
            _local_1.map(USEITEM).toMessage(UseItem);
            _local_1.map(HELLO).toMessage(Hello);
            _local_1.map(INVDROP).toMessage(InvDrop);
            _local_1.map(PONG).toMessage(Pong);
            _local_1.map(LOAD).toMessage(Load);
            _local_1.map(SETCONDITION).toMessage(SetCondition);
            _local_1.map(TELEPORT).toMessage(Teleport);
            _local_1.map(USEPORTAL).toMessage(UsePortal);
            _local_1.map(BUY).toMessage(Buy);
            _local_1.map(PLAYERHIT).toMessage(PlayerHit);
            _local_1.map(ENEMYHIT).toMessage(EnemyHit);
            _local_1.map(AOEACK).toMessage(AoeAck);
            _local_1.map(SHOOTACK).toMessage(ShootAck);
            _local_1.map(OTHERHIT).toMessage(OtherHit);
            _local_1.map(SQUAREHIT).toMessage(SquareHit);
            _local_1.map(GOTOACK).toMessage(GotoAck);
            _local_1.map(GROUNDDAMAGE).toMessage(GroundDamage);
            _local_1.map(CHOOSENAME).toMessage(ChooseName);
            _local_1.map(CREATEGUILD).toMessage(CreateGuild);
            _local_1.map(GUILDREMOVE).toMessage(GuildRemove);
            _local_1.map(GUILDINVITE).toMessage(GuildInvite);
            _local_1.map(REQUESTTRADE).toMessage(RequestTrade);
            _local_1.map(CHANGETRADE).toMessage(ChangeTrade);
            _local_1.map(ACCEPTTRADE).toMessage(AcceptTrade);
            _local_1.map(CANCELTRADE).toMessage(CancelTrade);
            _local_1.map(CHECKCREDITS).toMessage(CheckCredits);
            _local_1.map(ESCAPE).toMessage(Escape);
            _local_1.map(QUEST_ROOM_MSG).toMessage(GoToQuestRoom);
            _local_1.map(JOINGUILD).toMessage(JoinGuild);
            _local_1.map(CHANGEGUILDRANK).toMessage(ChangeGuildRank);
            _local_1.map(EDITACCOUNTLIST).toMessage(EditAccountList);
            _local_1.map(ACTIVE_PET_UPDATE_REQUEST).toMessage(ActivePetUpdateRequest);
            _local_1.map(PETUPGRADEREQUEST).toMessage(PetUpgradeRequest);
            _local_1.map(ENTER_ARENA).toMessage(EnterArena);
            _local_1.map(ACCEPT_ARENA_DEATH).toMessage(OutgoingMessage);
            _local_1.map(QUEST_FETCH_ASK).toMessage(OutgoingMessage);
            _local_1.map(QUEST_REDEEM).toMessage(QuestRedeem);
            _local_1.map(KEY_INFO_REQUEST).toMessage(KeyInfoRequest);
            _local_1.map(PET_CHANGE_FORM_MSG).toMessage(ReskinPet);
            _local_1.map(CLAIM_LOGIN_REWARD_MSG).toMessage(ClaimDailyRewardMessage);
            _local_1.map(FAILURE).toMessage(Failure).toMethod(this.onFailure);
            _local_1.map(CREATE_SUCCESS).toMessage(CreateSuccess).toMethod(this.onCreateSuccess);
            _local_1.map(SERVERPLAYERSHOOT).toMessage(ServerPlayerShoot).toMethod(this.onServerPlayerShoot);
            _local_1.map(DAMAGE).toMessage(Damage).toMethod(this.onDamage);
            _local_1.map(UPDATE).toMessage(Update).toMethod(this.onUpdate);
            _local_1.map(NOTIFICATION).toMessage(Notification).toMethod(this.onNotification);
            _local_1.map(GLOBAL_NOTIFICATION).toMessage(GlobalNotification).toMethod(this.onGlobalNotification);
            _local_1.map(NEWTICK).toMessage(NewTick).toMethod(this.onNewTick);
            _local_1.map(SHOWEFFECT).toMessage(ShowEffect).toMethod(this.onShowEffect);
            _local_1.map(GOTO).toMessage(Goto).toMethod(this.onGoto);
            _local_1.map(INVRESULT).toMessage(InvResult).toMethod(this.onInvResult);
            _local_1.map(RECONNECT).toMessage(Reconnect).toMethod(this.onReconnect);
            _local_1.map(PING).toMessage(Ping).toMethod(this.onPing);
            _local_1.map(MAPINFO).toMessage(MapInfo).toMethod(this.onMapInfo);
            _local_1.map(PIC).toMessage(Pic).toMethod(this.onPic);
            _local_1.map(DEATH).toMessage(Death).toMethod(this.onDeath);
            _local_1.map(BUYRESULT).toMessage(BuyResult).toMethod(this.onBuyResult);
            _local_1.map(AOE).toMessage(Aoe).toMethod(this.onAoe);
            _local_1.map(ACCOUNTLIST).toMessage(AccountList).toMethod(this.onAccountList);
            _local_1.map(QUESTOBJID).toMessage(QuestObjId).toMethod(this.onQuestObjId);
            _local_1.map(NAMERESULT).toMessage(NameResult).toMethod(this.onNameResult);
            _local_1.map(GUILDRESULT).toMessage(GuildResult).toMethod(this.onGuildResult);
            _local_1.map(ALLYSHOOT).toMessage(AllyShoot).toMethod(this.onAllyShoot);
            _local_1.map(ENEMYSHOOT).toMessage(EnemyShoot).toMethod(this.onEnemyShoot);
            _local_1.map(TRADEREQUESTED).toMessage(TradeRequested).toMethod(this.onTradeRequested);
            _local_1.map(TRADESTART).toMessage(TradeStart).toMethod(this.onTradeStart);
            _local_1.map(TRADECHANGED).toMessage(TradeChanged).toMethod(this.onTradeChanged);
            _local_1.map(TRADEDONE).toMessage(TradeDone).toMethod(this.onTradeDone);
            _local_1.map(TRADEACCEPTED).toMessage(TradeAccepted).toMethod(this.onTradeAccepted);
            _local_1.map(CLIENTSTAT).toMessage(ClientStat).toMethod(this.onClientStat);
            _local_1.map(FILE).toMessage(File).toMethod(this.onFile);
            _local_1.map(INVITEDTOGUILD).toMessage(InvitedToGuild).toMethod(this.onInvitedToGuild);
            _local_1.map(PLAYSOUND).toMessage(PlaySound).toMethod(this.onPlaySound);
            _local_1.map(ACTIVEPETUPDATE).toMessage(ActivePet).toMethod(this.onActivePetUpdate);
            _local_1.map(NEW_ABILITY).toMessage(NewAbilityMessage).toMethod(this.onNewAbility);
            _local_1.map(PETYARDUPDATE).toMessage(PetYard).toMethod(this.onPetYardUpdate);
            _local_1.map(EVOLVE_PET).toMessage(EvolvedPetMessage).toMethod(this.onEvolvedPet);
            _local_1.map(DELETE_PET).toMessage(DeletePetMessage).toMethod(this.onDeletePet);
            _local_1.map(HATCH_PET).toMessage(HatchPetMessage).toMethod(this.onHatchPet);
            _local_1.map(IMMINENT_ARENA_WAVE).toMessage(ImminentArenaWave).toMethod(this.onImminentArenaWave);
            _local_1.map(ARENA_DEATH).toMessage(ArenaDeath).toMethod(this.onArenaDeath);
            _local_1.map(VERIFY_EMAIL).toMessage(VerifyEmail).toMethod(this.onVerifyEmail);
            _local_1.map(RESKIN_UNLOCK).toMessage(ReskinUnlock).toMethod(this.onReskinUnlock);
            _local_1.map(PASSWORD_PROMPT).toMessage(PasswordPrompt).toMethod(this.onPasswordPrompt);
            _local_1.map(QUEST_FETCH_RESPONSE).toMessage(QuestFetchResponse).toMethod(this.onQuestFetchResponse);
            _local_1.map(QUEST_REDEEM_RESPONSE).toMessage(QuestRedeemResponse).toMethod(this.onQuestRedeemResponse);
            _local_1.map(KEY_INFO_RESPONSE).toMessage(KeyInfoResponse).toMethod(this.onKeyInfoResponse);
            _local_1.map(LOGIN_REWARD_MSG).toMessage(ClaimDailyRewardResponse).toMethod(this.onLoginRewardResponse);
        }
        
        private function onHatchPet(param1:HatchPetMessage) : void {
            var _local_2:HatchPetSignal = this.injector.getInstance(HatchPetSignal);
            _local_2.dispatch(param1.petName,param1.petSkin);
        }
        
        private function onDeletePet(param1:DeletePetMessage) : void {
            var _local_2:DeletePetSignal = this.injector.getInstance(DeletePetSignal);
            _local_2.dispatch(param1.petID);
        }
        
        private function onNewAbility(param1:NewAbilityMessage) : void {
            var _local_2:NewAbilitySignal = this.injector.getInstance(NewAbilitySignal);
            _local_2.dispatch(param1.type);
        }
        
        private function onPetYardUpdate(param1:PetYard) : void {
            var _local_2:UpdatePetYardSignal = StaticInjectorContext.getInjector().getInstance(UpdatePetYardSignal);
            _local_2.dispatch(param1.type);
        }
        
        private function onEvolvedPet(param1:EvolvedPetMessage) : void {
            var _local_2:EvolvedMessageHandler = this.injector.getInstance(EvolvedMessageHandler);
            _local_2.handleMessage(param1);
        }
        
        private function onActivePetUpdate(param1:ActivePet) : void {
            this.updateActivePet.dispatch(param1.instanceID);
            var _local_2:String = param1.instanceID > 0?this.petsModel.getPet(param1.instanceID).getName():"";
            var _local_3:String = param1.instanceID < 0?TextKey.PET_NOT_FOLLOWING:TextKey.PET_FOLLOWING;
            this.addTextLine.dispatch(ChatMessage.make(Parameters.SERVER_CHAT_NAME,_local_3,-1,-1,"",false,{"petName":_local_2}));
        }
        
        private function unmapMessages() : void {
            var _local_1:MessageMap = this.injector.getInstance(MessageMap);
            _local_1.unmap(CREATE);
            _local_1.unmap(PLAYERSHOOT);
            _local_1.unmap(MOVE);
            _local_1.unmap(PLAYERTEXT);
            _local_1.unmap(UPDATEACK);
            _local_1.unmap(INVSWAP);
            _local_1.unmap(USEITEM);
            _local_1.unmap(HELLO);
            _local_1.unmap(INVDROP);
            _local_1.unmap(PONG);
            _local_1.unmap(LOAD);
            _local_1.unmap(SETCONDITION);
            _local_1.unmap(TELEPORT);
            _local_1.unmap(USEPORTAL);
            _local_1.unmap(BUY);
            _local_1.unmap(PLAYERHIT);
            _local_1.unmap(ENEMYHIT);
            _local_1.unmap(AOEACK);
            _local_1.unmap(SHOOTACK);
            _local_1.unmap(OTHERHIT);
            _local_1.unmap(SQUAREHIT);
            _local_1.unmap(GOTOACK);
            _local_1.unmap(GROUNDDAMAGE);
            _local_1.unmap(CHOOSENAME);
            _local_1.unmap(CREATEGUILD);
            _local_1.unmap(GUILDREMOVE);
            _local_1.unmap(GUILDINVITE);
            _local_1.unmap(REQUESTTRADE);
            _local_1.unmap(CHANGETRADE);
            _local_1.unmap(ACCEPTTRADE);
            _local_1.unmap(CANCELTRADE);
            _local_1.unmap(CHECKCREDITS);
            _local_1.unmap(ESCAPE);
            _local_1.unmap(QUEST_ROOM_MSG);
            _local_1.unmap(JOINGUILD);
            _local_1.unmap(CHANGEGUILDRANK);
            _local_1.unmap(EDITACCOUNTLIST);
            _local_1.unmap(FAILURE);
            _local_1.unmap(CREATE_SUCCESS);
            _local_1.unmap(SERVERPLAYERSHOOT);
            _local_1.unmap(DAMAGE);
            _local_1.unmap(UPDATE);
            _local_1.unmap(NOTIFICATION);
            _local_1.unmap(GLOBAL_NOTIFICATION);
            _local_1.unmap(NEWTICK);
            _local_1.unmap(SHOWEFFECT);
            _local_1.unmap(GOTO);
            _local_1.unmap(INVRESULT);
            _local_1.unmap(RECONNECT);
            _local_1.unmap(PING);
            _local_1.unmap(MAPINFO);
            _local_1.unmap(PIC);
            _local_1.unmap(DEATH);
            _local_1.unmap(BUYRESULT);
            _local_1.unmap(AOE);
            _local_1.unmap(ACCOUNTLIST);
            _local_1.unmap(QUESTOBJID);
            _local_1.unmap(NAMERESULT);
            _local_1.unmap(GUILDRESULT);
            _local_1.unmap(ALLYSHOOT);
            _local_1.unmap(ENEMYSHOOT);
            _local_1.unmap(TRADEREQUESTED);
            _local_1.unmap(TRADESTART);
            _local_1.unmap(TRADECHANGED);
            _local_1.unmap(TRADEDONE);
            _local_1.unmap(TRADEACCEPTED);
            _local_1.unmap(CLIENTSTAT);
            _local_1.unmap(FILE);
            _local_1.unmap(INVITEDTOGUILD);
            _local_1.unmap(PLAYSOUND);
        }
        
        private function encryptConnection() : void {
            var _local_1:ICipher = null;
            var _local_2:ICipher = null;
            if(Parameters.ENABLE_ENCRYPTION) {
                _local_1 = Crypto.getCipher("rc4",MoreStringUtil.hexStringToByteArray("311f80691451c71d09a13a2a6e"));
                _local_2 = Crypto.getCipher("rc4",MoreStringUtil.hexStringToByteArray("72c5583cafb6818995cdd74b80"));
                serverConnection.setOutgoingCipher(_local_1);
                serverConnection.setIncomingCipher(_local_2);
            }
        }
        
        override public function getNextDamage(param1:uint, param2:uint) : uint {
            return this.rand_.nextIntRange(param1,param2);
        }
        
        override public function enableJitterWatcher() : void {
            if(jitterWatcher_ == null) {
                jitterWatcher_ = new JitterWatcher();
            }
        }
        
        override public function disableJitterWatcher() : void {
            if(jitterWatcher_ != null) {
                jitterWatcher_ = null;
            }
        }
        
        private function create() : void {
            var _local_1:CharacterClass = this.classesModel.getSelected();
            var _local_2:Create = this.messages.require(CREATE) as Create;
            _local_2.classType = _local_1.id;
            _local_2.skinType = _local_1.skins.getSelectedSkin().id;
            serverConnection.sendMessage(_local_2);
        }
        
        private function load() : void {
            var _local_1:Load = this.messages.require(LOAD) as Load;
            _local_1.charId_ = charId_;
            _local_1.isFromArena_ = isFromArena_;
            serverConnection.sendMessage(_local_1);
            if(isFromArena_) {
                this.openDialog.dispatch(new BattleSummaryDialog());
            }
        }
        
        override public function playerShoot(param1:int, param2:Projectile) : void {
            var _local_3:PlayerShoot = this.messages.require(PLAYERSHOOT) as PlayerShoot;
            _local_3.time_ = param1;
            _local_3.bulletId_ = param2.bulletId_;
            _local_3.containerType_ = param2.containerType_;
            _local_3.startingPos_.x_ = param2.x_;
            _local_3.startingPos_.y_ = param2.y_;
            _local_3.angle_ = param2.angle_;
            serverConnection.sendMessage(_local_3);
        }
        
        override public function playerHit(param1:int, param2:int) : void {
            var _local_3:PlayerHit = this.messages.require(PLAYERHIT) as PlayerHit;
            _local_3.bulletId_ = param1;
            _local_3.objectId_ = param2;
            serverConnection.sendMessage(_local_3);
        }
        
        override public function enemyHit(param1:int, param2:int, param3:int, param4:Boolean) : void {
            var _local_5:EnemyHit = this.messages.require(ENEMYHIT) as EnemyHit;
            _local_5.time_ = param1;
            _local_5.bulletId_ = param2;
            _local_5.targetId_ = param3;
            _local_5.kill_ = param4;
            serverConnection.sendMessage(_local_5);
        }
        
        override public function otherHit(param1:int, param2:int, param3:int, param4:int) : void {
            var _local_5:OtherHit = this.messages.require(OTHERHIT) as OtherHit;
            _local_5.time_ = param1;
            _local_5.bulletId_ = param2;
            _local_5.objectId_ = param3;
            _local_5.targetId_ = param4;
            serverConnection.sendMessage(_local_5);
        }
        
        override public function squareHit(param1:int, param2:int, param3:int) : void {
            var _local_4:SquareHit = this.messages.require(SQUAREHIT) as SquareHit;
            _local_4.time_ = param1;
            _local_4.bulletId_ = param2;
            _local_4.objectId_ = param3;
            serverConnection.sendMessage(_local_4);
        }
        
        public function aoeAck(param1:int, param2:Number, param3:Number) : void {
            var _local_4:AoeAck = this.messages.require(AOEACK) as AoeAck;
            _local_4.time_ = param1;
            _local_4.position_.x_ = param2;
            _local_4.position_.y_ = param3;
            serverConnection.sendMessage(_local_4);
        }
        
        override public function groundDamage(param1:int, param2:Number, param3:Number) : void {
            var _local_4:GroundDamage = this.messages.require(GROUNDDAMAGE) as GroundDamage;
            _local_4.time_ = param1;
            _local_4.position_.x_ = param2;
            _local_4.position_.y_ = param3;
            serverConnection.sendMessage(_local_4);
        }
        
        public function shootAck(param1:int) : void {
            var _local_2:ShootAck = this.messages.require(SHOOTACK) as ShootAck;
            _local_2.time_ = param1;
            serverConnection.sendMessage(_local_2);
        }
        
        override public function playerText(param1:String) : void {
            var _local_2:PlayerText = this.messages.require(PLAYERTEXT) as PlayerText;
            _local_2.text_ = param1;
            serverConnection.sendMessage(_local_2);
        }
        
        override public function invSwap(param1:Player, param2:GameObject, param3:int, param4:int, param5:GameObject, param6:int, param7:int) : Boolean {
            if(!gs_) {
                return false;
            }
            var _local_8:InvSwap = this.messages.require(INVSWAP) as InvSwap;
            _local_8.time_ = gs_.lastUpdate_;
            _local_8.position_.x_ = param1.x_;
            _local_8.position_.y_ = param1.y_;
            _local_8.slotObject1_.objectId_ = param2.objectId_;
            _local_8.slotObject1_.slotId_ = param3;
            _local_8.slotObject1_.objectType_ = param4;
            _local_8.slotObject2_.objectId_ = param5.objectId_;
            _local_8.slotObject2_.slotId_ = param6;
            _local_8.slotObject2_.objectType_ = param7;
            serverConnection.sendMessage(_local_8);
            var _local_9:int = param2.equipment_[param3];
            param2.equipment_[param3] = param5.equipment_[param6];
            param5.equipment_[param6] = _local_9;
            SoundEffectLibrary.play("inventory_move_item");
            return true;
        }
        
        override public function invSwapPotion(param1:Player, param2:GameObject, param3:int, param4:int, param5:GameObject, param6:int, param7:int) : Boolean {
            if(!gs_) {
                return false;
            }
            var _local_8:InvSwap = this.messages.require(INVSWAP) as InvSwap;
            _local_8.time_ = gs_.lastUpdate_;
            _local_8.position_.x_ = param1.x_;
            _local_8.position_.y_ = param1.y_;
            _local_8.slotObject1_.objectId_ = param2.objectId_;
            _local_8.slotObject1_.slotId_ = param3;
            _local_8.slotObject1_.objectType_ = param4;
            _local_8.slotObject2_.objectId_ = param5.objectId_;
            _local_8.slotObject2_.slotId_ = param6;
            _local_8.slotObject2_.objectType_ = param7;
            param2.equipment_[param3] = ItemConstants.NO_ITEM;
            if(param4 == PotionInventoryModel.HEALTH_POTION_ID) {
                param1.healthPotionCount_++;
            } else if(param4 == PotionInventoryModel.MAGIC_POTION_ID) {
                param1.magicPotionCount_++;
            }
            serverConnection.sendMessage(_local_8);
            SoundEffectLibrary.play("inventory_move_item");
            return true;
        }
        
        override public function invDrop(param1:GameObject, param2:int, param3:int) : void {
            var _local_4:InvDrop = this.messages.require(INVDROP) as InvDrop;
            _local_4.slotObject_.objectId_ = param1.objectId_;
            _local_4.slotObject_.slotId_ = param2;
            _local_4.slotObject_.objectType_ = param3;
            serverConnection.sendMessage(_local_4);
            if(param2 != PotionInventoryModel.HEALTH_POTION_SLOT && param2 != PotionInventoryModel.MAGIC_POTION_SLOT) {
                param1.equipment_[param2] = ItemConstants.NO_ITEM;
            }
        }
        
        override public function useItem(param1:int, param2:int, param3:int, param4:int, param5:Number, param6:Number, param7:int) : void {
            var _local_8:UseItem = this.messages.require(USEITEM) as UseItem;
            _local_8.time_ = param1;
            _local_8.slotObject_.objectId_ = param2;
            _local_8.slotObject_.slotId_ = param3;
            _local_8.slotObject_.objectType_ = param4;
            _local_8.itemUsePos_.x_ = param5;
            _local_8.itemUsePos_.y_ = param6;
            _local_8.useType_ = param7;
            serverConnection.sendMessage(_local_8);
        }
        
        override public function useItem_new(param1:GameObject, param2:int) : Boolean {
            var _local_4:XML = null;
            var _local_3:int = param1.equipment_[param2];
            if(_local_3 >= 36864 && _local_3 < 61440) {
                _local_4 = ObjectLibrary.xmlLibrary_[36863];
            } else {
                _local_4 = ObjectLibrary.xmlLibrary_[_local_3];
            }
            if(_local_4 && !param1.isPaused() && (_local_4.hasOwnProperty("Consumable") || _local_4.hasOwnProperty("InvUse"))) {
                if(!this.validStatInc(_local_3,param1)) {
                    this.addTextLine.dispatch(ChatMessage.make("",_local_4.attribute("id") + " not consumed. Already at Max."));
                    return false;
                }
                if(isStatPotion(_local_3)) {
                    this.addTextLine.dispatch(ChatMessage.make("",_local_4.attribute("id") + " Consumed ++"));
                }
                this.applyUseItem(param1,param2,_local_3,_local_4);
                SoundEffectLibrary.play("use_potion");
                return true;
            }
            SoundEffectLibrary.play("error");
            return false;
        }
        
        private function validStatInc(param1:int, param2:GameObject) : Boolean {
            var p:Player = null;
            var itemId:int = param1;
            var itemOwner:GameObject = param2;
            try {
                if(itemOwner is Player) {
                    p = itemOwner as Player;
                } else {
                    p = this.player;
                }
                if((itemId == 2591 || itemId == 5465 || itemId == 9064) && p.attackMax_ == p.attack_ - p.attackBoost_ || (itemId == 2592 || itemId == 5466 || itemId == 9065) && p.defenseMax_ == p.defense_ - p.defenseBoost_ || (itemId == 2593 || itemId == 5467 || itemId == 9066) && p.speedMax_ == p.speed_ - p.speedBoost_ || (itemId == 2612 || itemId == 5468 || itemId == 9067) && p.vitalityMax_ == p.vitality_ - p.vitalityBoost_ || (itemId == 2613 || itemId == 5469 || itemId == 9068) && p.wisdomMax_ == p.wisdom_ - p.wisdomBoost_ || (itemId == 2636 || itemId == 5470 || itemId == 9069) && p.dexterityMax_ == p.dexterity_ - p.dexterityBoost_ || (itemId == 2793 || itemId == 5471 || itemId == 9070) && p.maxHPMax_ == p.maxHP_ - p.maxHPBoost_ || (itemId == 2794 || itemId == 5472 || itemId == 9071) && p.maxMPMax_ == p.maxMP_ - p.maxMPBoost_) {
                    return false;
                }
            }
            catch(err:Error) {
                logger.error("PROBLEM IN STAT INC " + err.getStackTrace());
            }
            return true;
        }
        
        private function applyUseItem(param1:GameObject, param2:int, param3:int, param4:XML) : void {
            var _local_5:UseItem = this.messages.require(USEITEM) as UseItem;
            _local_5.time_ = getTimer();
            _local_5.slotObject_.objectId_ = param1.objectId_;
            _local_5.slotObject_.slotId_ = param2;
            _local_5.slotObject_.objectType_ = param3;
            _local_5.itemUsePos_.x_ = 0;
            _local_5.itemUsePos_.y_ = 0;
            serverConnection.sendMessage(_local_5);
            if(param4.hasOwnProperty("Consumable")) {
                param1.equipment_[param2] = -1;
                if(param4.hasOwnProperty("Activate") && param4.Activate == "UnlockSkin") {
                }
            }
        }
        
        override public function setCondition(param1:uint, param2:Number) : void {
            var _local_3:SetCondition = this.messages.require(SETCONDITION) as SetCondition;
            _local_3.conditionEffect_ = param1;
            _local_3.conditionDuration_ = param2;
            serverConnection.sendMessage(_local_3);
        }
        
        public function move(param1:int, param2:Player) : void {
            var _local_7:int = 0;
            var _local_8:int = 0;
            var _local_3:Number = -1;
            var _local_4:Number = -1;
            if(param2 && !param2.isPaused()) {
                _local_3 = param2.x_;
                _local_4 = param2.y_;
            }
            var _local_5:Move = this.messages.require(MOVE) as Move;
            _local_5.tickId_ = param1;
            _local_5.time_ = gs_.lastUpdate_;
            _local_5.newPosition_.x_ = _local_3;
            _local_5.newPosition_.y_ = _local_4;
            var _local_6:int = gs_.moveRecords_.lastClearTime_;
            _local_5.records_.length = 0;
            if(_local_6 >= 0 && _local_5.time_ - _local_6 > 125) {
                _local_7 = Math.min(10,gs_.moveRecords_.records_.length);
                _local_8 = 0;
                while(_local_8 < _local_7) {
                    if(gs_.moveRecords_.records_[_local_8].time_ >= _local_5.time_ - 25) {
                        break;
                    }
                    _local_5.records_.push(gs_.moveRecords_.records_[_local_8]);
                    _local_8++;
                }
            }
            gs_.moveRecords_.clear(_local_5.time_);
            serverConnection.sendMessage(_local_5);
            param2 && param2.onMove();
        }
        
        override public function teleport(param1:int) : void {
            var _local_2:Teleport = this.messages.require(TELEPORT) as Teleport;
            _local_2.objectId_ = param1;
            serverConnection.sendMessage(_local_2);
        }
        
        override public function usePortal(param1:int) : void {
            var _local_2:UsePortal = this.messages.require(USEPORTAL) as UsePortal;
            _local_2.objectId_ = param1;
            serverConnection.sendMessage(_local_2);
            this.checkDavyKeyRemoval();
        }
        
        private function checkDavyKeyRemoval() : void {
            if(gs_.map && gs_.map.name_ == "Davy Jones\' Locker") {
                ShowHideKeyUISignal.instance.dispatch();
            }
        }
        
        override public function buy(param1:int, param2:int) : void {
            var sObj:SellableObject = null;
            var converted:Boolean = false;
            var sellableObjectId:int = param1;
            var quantity:int = param2;
            if(outstandingBuy_ != null) {
                return;
            }
            sObj = gs_.map.goDict_[sellableObjectId];
            if(sObj == null) {
                return;
            }
            converted = false;
            if(sObj.currency_ == Currency.GOLD) {
                converted = gs_.model.getConverted() || this.player.credits_ > 100 || sObj.price_ > this.player.credits_;
            }
            if(sObj.soldObjectName() == TextKey.VAULT_CHEST) {
                this.openDialog.dispatch(new PurchaseConfirmationDialog(function():* {
                    buyConfirmation(sObj,converted,sellableObjectId,quantity);
                }));
            } else {
                this.buyConfirmation(sObj,converted,sellableObjectId,quantity);
            }
        }
        
        private function buyConfirmation(param1:SellableObject, param2:Boolean, param3:int, param4:int) : * {
            outstandingBuy_ = new OutstandingBuy(param1.soldObjectInternalName(),param1.price_,param1.currency_,param2);
            var _local_5:Buy = this.messages.require(BUY) as Buy;
            _local_5.objectId_ = param3;
            _local_5.quantity_ = param4;
            serverConnection.sendMessage(_local_5);
        }
        
        public function gotoAck(param1:int) : void {
            var _local_2:GotoAck = this.messages.require(GOTOACK) as GotoAck;
            _local_2.time_ = param1;
            serverConnection.sendMessage(_local_2);
        }
        
        override public function editAccountList(param1:int, param2:Boolean, param3:int) : void {
            var _local_4:EditAccountList = this.messages.require(EDITACCOUNTLIST) as EditAccountList;
            _local_4.accountListId_ = param1;
            _local_4.add_ = param2;
            _local_4.objectId_ = param3;
            serverConnection.sendMessage(_local_4);
        }
        
        override public function chooseName(param1:String) : void {
            var _local_2:ChooseName = this.messages.require(CHOOSENAME) as ChooseName;
            _local_2.name_ = param1;
            serverConnection.sendMessage(_local_2);
        }
        
        override public function createGuild(param1:String) : void {
            var _local_2:CreateGuild = this.messages.require(CREATEGUILD) as CreateGuild;
            _local_2.name_ = param1;
            serverConnection.sendMessage(_local_2);
        }
        
        override public function guildRemove(param1:String) : void {
            var _local_2:GuildRemove = this.messages.require(GUILDREMOVE) as GuildRemove;
            _local_2.name_ = param1;
            serverConnection.sendMessage(_local_2);
        }
        
        override public function guildInvite(param1:String) : void {
            var _local_2:GuildInvite = this.messages.require(GUILDINVITE) as GuildInvite;
            _local_2.name_ = param1;
            serverConnection.sendMessage(_local_2);
        }
        
        override public function requestTrade(param1:String) : void {
            var _local_2:RequestTrade = this.messages.require(REQUESTTRADE) as RequestTrade;
            _local_2.name_ = param1;
            serverConnection.sendMessage(_local_2);
        }
        
        override public function changeTrade(param1:Vector.<Boolean>) : void {
            var _local_2:ChangeTrade = this.messages.require(CHANGETRADE) as ChangeTrade;
            _local_2.offer_ = param1;
            serverConnection.sendMessage(_local_2);
        }
        
        override public function acceptTrade(param1:Vector.<Boolean>, param2:Vector.<Boolean>) : void {
            var _local_3:AcceptTrade = this.messages.require(ACCEPTTRADE) as AcceptTrade;
            _local_3.myOffer_ = param1;
            _local_3.yourOffer_ = param2;
            serverConnection.sendMessage(_local_3);
        }
        
        override public function cancelTrade() : void {
            serverConnection.sendMessage(this.messages.require(CANCELTRADE));
        }
        
        override public function checkCredits() : void {
            serverConnection.sendMessage(this.messages.require(CHECKCREDITS));
        }
        
        override public function escape() : void {
            if(this.playerId_ == -1) {
                return;
            }
            if(gs_.map && gs_.map.name_ == "Arena") {
                serverConnection.sendMessage(this.messages.require(ACCEPT_ARENA_DEATH));
            } else {
                serverConnection.sendMessage(this.messages.require(ESCAPE));
                this.checkDavyKeyRemoval();
            }
        }
        
        override public function gotoQuestRoom() : void {
            serverConnection.sendMessage(this.messages.require(QUEST_ROOM_MSG));
        }
        
        override public function joinGuild(param1:String) : void {
            var _local_2:JoinGuild = this.messages.require(JOINGUILD) as JoinGuild;
            _local_2.guildName_ = param1;
            serverConnection.sendMessage(_local_2);
        }
        
        override public function changeGuildRank(param1:String, param2:int) : void {
            var _local_3:ChangeGuildRank = this.messages.require(CHANGEGUILDRANK) as ChangeGuildRank;
            _local_3.name_ = param1;
            _local_3.guildRank_ = param2;
            serverConnection.sendMessage(_local_3);
        }
        
        private function rsaEncrypt(param1:String) : String {
            var _local_2:RSAKey = PEM.readRSAPublicKey(Parameters.RSA_PUBLIC_KEY);
            var _local_3:ByteArray = new ByteArray();
            _local_3.writeUTFBytes(param1);
            var _local_4:ByteArray = new ByteArray();
            _local_2.encrypt(_local_3,_local_4,_local_3.length);
            return Base64.encodeByteArray(_local_4);
        }
        
        private function onConnected() : void {
            var _local_1:Account = StaticInjectorContext.getInjector().getInstance(Account);
            this.addTextLine.dispatch(ChatMessage.make(Parameters.CLIENT_CHAT_NAME,TextKey.CHAT_CONNECTED));
            this.encryptConnection();
            var _local_2:Hello = this.messages.require(HELLO) as Hello;
            _local_2.buildVersion_ = Parameters.BUILD_VERSION + "." + "0";
            _local_2.gameId_ = gameId_;
            _local_2.guid_ = this.rsaEncrypt(_local_1.getUserId());
            _local_2.password_ = this.rsaEncrypt(_local_1.getPassword());
            _local_2.secret_ = this.rsaEncrypt(_local_1.getSecret());
            _local_2.keyTime_ = keyTime_;
            _local_2.key_.length = 0;
            key_ != null && _local_2.key_.writeBytes(key_);
            _local_2.mapJSON_ = mapJSON_ == null?"":mapJSON_;
            _local_2.entrytag_ = _local_1.getEntryTag();
            _local_2.gameNet = _local_1.gameNetwork();
            _local_2.gameNetUserId = _local_1.gameNetworkUserId();
            _local_2.playPlatform = _local_1.playPlatform();
            _local_2.platformToken = _local_1.getPlatformToken();
            _local_2.userToken = _local_1.getToken();
            serverConnection.sendMessage(_local_2);
        }
        
        private function onCreateSuccess(param1:CreateSuccess) : void {
            this.playerId_ = param1.objectId_;
            charId_ = param1.charId_;
            gs_.initialize();
            createCharacter_ = false;
        }
        
        private function onDamage(param1:Damage) : void {
            var _local_5:int = 0;
            var _local_2:AbstractMap = gs_.map;
            var _local_3:Projectile = null;
            if(param1.objectId_ >= 0 && param1.bulletId_ > 0) {
                _local_5 = Projectile.findObjId(param1.objectId_,param1.bulletId_);
                _local_3 = _local_2.boDict_[_local_5] as Projectile;
                if(_local_3 != null && !_local_3.projProps_.multiHit_) {
                    _local_2.removeObj(_local_5);
                }
            }
            var _local_4:GameObject = _local_2.goDict_[param1.targetId_];
            if(_local_4 != null) {
                _local_4.damage(-1,param1.damageAmount_,param1.effects_,param1.kill_,_local_3);
            }
        }
        
        private function onServerPlayerShoot(param1:ServerPlayerShoot) : void {
            var _local_2:* = param1.ownerId_ == this.playerId_;
            var _local_3:GameObject = gs_.map.goDict_[param1.ownerId_];
            if(_local_3 == null || _local_3.dead_) {
                if(_local_2) {
                    this.shootAck(-1);
                }
                return;
            }
            if(_local_3.objectId_ != this.playerId_ && Parameters.data_.disableAllyParticles) {
                return;
            }
            var _local_4:Projectile = FreeList.newObject(Projectile) as Projectile;
            var _local_5:Player = _local_3 as Player;
            if(_local_5 != null) {
                _local_4.reset(param1.containerType_,0,param1.ownerId_,param1.bulletId_,param1.angle_,gs_.lastUpdate_,_local_5.projectileIdSetOverrideNew,_local_5.projectileIdSetOverrideOld);
            } else {
                _local_4.reset(param1.containerType_,0,param1.ownerId_,param1.bulletId_,param1.angle_,gs_.lastUpdate_);
            }
            _local_4.setDamage(param1.damage_);
            gs_.map.addObj(_local_4,param1.startingPos_.x_,param1.startingPos_.y_);
            if(_local_2) {
                this.shootAck(gs_.lastUpdate_);
            }
        }
        
        private function onAllyShoot(param1:AllyShoot) : void {
            var _local_2:GameObject = gs_.map.goDict_[param1.ownerId_];
            if(_local_2 == null || _local_2.dead_ || Parameters.data_.disableAllyParticles) {
                return;
            }
            var _local_3:Projectile = FreeList.newObject(Projectile) as Projectile;
            var _local_4:Player = _local_2 as Player;
            if(_local_4 != null) {
                _local_3.reset(param1.containerType_,0,param1.ownerId_,param1.bulletId_,param1.angle_,gs_.lastUpdate_,_local_4.projectileIdSetOverrideNew,_local_4.projectileIdSetOverrideOld);
            } else {
                _local_3.reset(param1.containerType_,0,param1.ownerId_,param1.bulletId_,param1.angle_,gs_.lastUpdate_);
            }
            gs_.map.addObj(_local_3,_local_2.x_,_local_2.y_);
            _local_2.setAttack(param1.containerType_,param1.angle_);
        }
        
        private function onReskinUnlock(param1:ReskinUnlock) : void {
            var _local_2:* = null;
            var _local_3:CharacterSkin = null;
            for(_local_2 in this.model.player.lockedSlot) {
                if(this.model.player.lockedSlot[_local_2] == param1.skinID) {
                    this.model.player.lockedSlot[_local_2] = 0;
                }
            }
            _local_3 = this.classesModel.getCharacterClass(this.model.player.objectType_).skins.getSkin(param1.skinID);
            _local_3.setState(CharacterSkinState.OWNED);
        }
        
        private function onEnemyShoot(param1:EnemyShoot) : void {
            var _local_4:Projectile = null;
            var _local_5:Number = NaN;
            var _local_2:GameObject = gs_.map.goDict_[param1.ownerId_];
            if(_local_2 == null || _local_2.dead_) {
                this.shootAck(-1);
                return;
            }
            var _local_3:int = 0;
            while(_local_3 < param1.numShots_) {
                _local_4 = FreeList.newObject(Projectile) as Projectile;
                _local_5 = param1.angle_ + param1.angleInc_ * _local_3;
                _local_4.reset(_local_2.objectType_,param1.bulletType_,param1.ownerId_,(param1.bulletId_ + _local_3) % 256,_local_5,gs_.lastUpdate_);
                _local_4.setDamage(param1.damage_);
                gs_.map.addObj(_local_4,param1.startingPos_.x_,param1.startingPos_.y_);
                _local_3++;
            }
            this.shootAck(gs_.lastUpdate_);
            _local_2.setAttack(_local_2.objectType_,param1.angle_ + param1.angleInc_ * ((param1.numShots_ - 1) / 2));
        }
        
        private function onTradeRequested(param1:TradeRequested) : void {
            if(!Parameters.data_.chatTrade) {
                return;
            }
            if(Parameters.data_.tradeWithFriends && !this.friendModel.isMyFriend(param1.name_)) {
                return;
            }
            if(Parameters.data_.showTradePopup) {
                gs_.hudView.interactPanel.setOverride(new TradeRequestPanel(gs_,param1.name_));
            }
            this.addTextLine.dispatch(ChatMessage.make("",param1.name_ + " wants to " + "trade with you.  Type \"/trade " + param1.name_ + "\" to trade."));
        }
        
        private function onTradeStart(param1:TradeStart) : void {
            gs_.hudView.startTrade(gs_,param1);
        }
        
        private function onTradeChanged(param1:TradeChanged) : void {
            gs_.hudView.tradeChanged(param1);
        }
        
        private function onTradeDone(param1:TradeDone) : void {
            var _local_3:Object = null;
            var _local_4:Object = null;
            gs_.hudView.tradeDone();
            var _local_2:String = "";
            try {
                _local_4 = JSON.parse(param1.description_);
                _local_2 = _local_4.key;
                _local_3 = _local_4.tokens;
            }
            catch(e:Error) {
            }
            this.addTextLine.dispatch(ChatMessage.make(Parameters.SERVER_CHAT_NAME,_local_2,-1,-1,"",false,_local_3));
        }
        
        private function onTradeAccepted(param1:TradeAccepted) : void {
            gs_.hudView.tradeAccepted(param1);
        }
        
        private function addObject(param1:ObjectData) : void {
            var _local_2:AbstractMap = gs_.map;
            var _local_3:GameObject = ObjectLibrary.getObjectFromType(param1.objectType_);
            if(_local_3 == null) {
                return;
            }
            var _local_4:ObjectStatusData = param1.status_;
            _local_3.setObjectId(_local_4.objectId_);
            _local_2.addObj(_local_3,_local_4.pos_.x_,_local_4.pos_.y_);
            if(_local_3 is Player) {
                this.handleNewPlayer(_local_3 as Player,_local_2);
            }
            this.processObjectStatus(_local_4,0,-1);
            if(_local_3.props_.static_ && _local_3.props_.occupySquare_ && !_local_3.props_.noMiniMap_) {
                this.updateGameObjectTileSignal.dispatch(new UpdateGameObjectTileVO(_local_3.x_,_local_3.y_,_local_3));
            }
        }
        
        private function handleNewPlayer(param1:Player, param2:AbstractMap) : void {
            this.setPlayerSkinTemplate(param1,0);
            if(param1.objectId_ == this.playerId_) {
                this.player = param1;
                this.model.player = param1;
                param2.player_ = param1;
                gs_.setFocus(param1);
                this.setGameFocus.dispatch(this.playerId_.toString());
            }
        }
        
        private function onUpdate(param1:Update) : void {
            var _local_3:int = 0;
            var _local_4:GroundTileData = null;
            var _local_2:Message = this.messages.require(UPDATEACK);
            serverConnection.sendMessage(_local_2);
            _local_3 = 0;
            while(_local_3 < param1.tiles_.length) {
                _local_4 = param1.tiles_[_local_3];
                gs_.map.setGroundTile(_local_4.x_,_local_4.y_,_local_4.type_);
                this.updateGroundTileSignal.dispatch(new UpdateGroundTileVO(_local_4.x_,_local_4.y_,_local_4.type_));
                _local_3++;
            }
            _local_3 = 0;
            while(_local_3 < param1.newObjs_.length) {
                this.addObject(param1.newObjs_[_local_3]);
                _local_3++;
            }
            _local_3 = 0;
            while(_local_3 < param1.drops_.length) {
                gs_.map.removeObj(param1.drops_[_local_3]);
                _local_3++;
            }
        }
        
        private function onNotification(param1:Notification) : void {
            var _local_3:LineBuilder = null;
            var _local_4:CharacterStatusText = null;
            var _local_5:QueuedStatusText = null;
            var _local_2:GameObject = gs_.map.goDict_[param1.objectId_];
            if(_local_2 != null) {
                _local_3 = LineBuilder.fromJSON(param1.message);
                if(_local_3.key == "server.plus_symbol") {
                    _local_4 = new CharacterStatusText(_local_2,param1.color_,1000);
                    _local_4.setStringBuilder(_local_3);
                    gs_.map.mapOverlay_.addStatusText(_local_4);
                } else {
                    _local_5 = new QueuedStatusText(_local_2,_local_3,param1.color_,2000);
                    gs_.map.mapOverlay_.addQueuedText(_local_5);
                    if(_local_2 == this.player && _local_3.key == "server.quest_complete") {
                        gs_.map.quest_.completed();
                    }
                }
            }
        }
        
        private function onGlobalNotification(param1:GlobalNotification) : void {
            switch(param1.text) {
                case "yellow":
                    ShowKeySignal.instance.dispatch(Key.YELLOW);
                    break;
                case "red":
                    ShowKeySignal.instance.dispatch(Key.RED);
                    break;
                case "green":
                    ShowKeySignal.instance.dispatch(Key.GREEN);
                    break;
                case "purple":
                    ShowKeySignal.instance.dispatch(Key.PURPLE);
                    break;
                case "showKeyUI":
                    ShowHideKeyUISignal.instance.dispatch();
                    break;
                case "giftChestOccupied":
                    this.giftChestUpdateSignal.dispatch(GiftStatusUpdateSignal.HAS_GIFT);
                    break;
                case "giftChestEmpty":
                    this.giftChestUpdateSignal.dispatch(GiftStatusUpdateSignal.HAS_NO_GIFT);
                    break;
                case "beginnersPackage":
            }
        }
        
        private function onNewTick(param1:NewTick) : void {
            var _local_2:ObjectStatusData = null;
            if(jitterWatcher_ != null) {
                jitterWatcher_.record();
            }
            this.move(param1.tickId_,this.player);
            for each(_local_2 in param1.statuses_) {
                this.processObjectStatus(_local_2,param1.tickTime_,param1.tickId_);
            }
            lastTickId_ = param1.tickId_;
        }
        
        private function canShowEffect(param1:GameObject) : Boolean {
            if(param1 != null) {
                return true;
            }
            var _local_2:* = param1.objectId_ == this.playerId_;
            if(!_local_2 && param1.props_.isPlayer_ && Parameters.data_.disableAllyParticles) {
                return false;
            }
            return true;
        }
        
        private function onShowEffect(param1:ShowEffect) : void {
            var _local_3:GameObject = null;
            var _local_4:ParticleEffect = null;
            var _local_5:Point = null;
            var _local_6:uint = 0;
            var _local_2:AbstractMap = gs_.map;
            switch(param1.effectType_) {
                case ShowEffect.HEAL_EFFECT_TYPE:
                    _local_3 = _local_2.goDict_[param1.targetObjectId_];
                    if(_local_3 == null || !this.canShowEffect(_local_3)) {
                        break;
                    }
                    _local_2.addObj(new HealEffect(_local_3,param1.color_),_local_3.x_,_local_3.y_);
                    break;
                case ShowEffect.TELEPORT_EFFECT_TYPE:
                    _local_2.addObj(new TeleportEffect(),param1.pos1_.x_,param1.pos1_.y_);
                    break;
                case ShowEffect.STREAM_EFFECT_TYPE:
                    _local_4 = new StreamEffect(param1.pos1_,param1.pos2_,param1.color_);
                    _local_2.addObj(_local_4,param1.pos1_.x_,param1.pos1_.y_);
                    break;
                case ShowEffect.THROW_EFFECT_TYPE:
                    _local_3 = _local_2.goDict_[param1.targetObjectId_];
                    _local_5 = _local_3 != null?new Point(_local_3.x_,_local_3.y_):param1.pos2_.toPoint();
                    if(_local_3 != null && !this.canShowEffect(_local_3)) {
                        break;
                    }
                    _local_4 = new ThrowEffect(_local_5,param1.pos1_.toPoint(),param1.color_,param1.duration_ * 1000);
                    _local_2.addObj(_local_4,_local_5.x,_local_5.y);
                    break;
                case ShowEffect.NOVA_EFFECT_TYPE:
                    _local_3 = _local_2.goDict_[param1.targetObjectId_];
                    if(_local_3 == null || !this.canShowEffect(_local_3)) {
                        break;
                    }
                    _local_4 = new NovaEffect(_local_3,param1.pos1_.x_,param1.color_);
                    _local_2.addObj(_local_4,_local_3.x_,_local_3.y_);
                    break;
                case ShowEffect.POISON_EFFECT_TYPE:
                    _local_3 = _local_2.goDict_[param1.targetObjectId_];
                    if(_local_3 == null || !this.canShowEffect(_local_3)) {
                        break;
                    }
                    _local_4 = new PoisonEffect(_local_3,param1.color_);
                    _local_2.addObj(_local_4,_local_3.x_,_local_3.y_);
                    break;
                case ShowEffect.LINE_EFFECT_TYPE:
                    _local_3 = _local_2.goDict_[param1.targetObjectId_];
                    if(_local_3 == null || !this.canShowEffect(_local_3)) {
                        break;
                    }
                    _local_4 = new LineEffect(_local_3,param1.pos1_,param1.color_);
                    _local_2.addObj(_local_4,param1.pos1_.x_,param1.pos1_.y_);
                    break;
                case ShowEffect.BURST_EFFECT_TYPE:
                    _local_3 = _local_2.goDict_[param1.targetObjectId_];
                    if(_local_3 == null || !this.canShowEffect(_local_3)) {
                        break;
                    }
                    _local_4 = new BurstEffect(_local_3,param1.pos1_,param1.pos2_,param1.color_);
                    _local_2.addObj(_local_4,param1.pos1_.x_,param1.pos1_.y_);
                    break;
                case ShowEffect.FLOW_EFFECT_TYPE:
                    _local_3 = _local_2.goDict_[param1.targetObjectId_];
                    if(_local_3 == null || !this.canShowEffect(_local_3)) {
                        break;
                    }
                    _local_4 = new FlowEffect(param1.pos1_,_local_3,param1.color_);
                    _local_2.addObj(_local_4,param1.pos1_.x_,param1.pos1_.y_);
                    break;
                case ShowEffect.RING_EFFECT_TYPE:
                    _local_3 = _local_2.goDict_[param1.targetObjectId_];
                    if(_local_3 == null || !this.canShowEffect(_local_3)) {
                        break;
                    }
                    _local_4 = new RingEffect(_local_3,param1.pos1_.x_,param1.color_);
                    _local_2.addObj(_local_4,_local_3.x_,_local_3.y_);
                    break;
                case ShowEffect.LIGHTNING_EFFECT_TYPE:
                    _local_3 = _local_2.goDict_[param1.targetObjectId_];
                    if(_local_3 == null || !this.canShowEffect(_local_3)) {
                        break;
                    }
                    _local_4 = new LightningEffect(_local_3,param1.pos1_,param1.color_,param1.pos2_.x_);
                    _local_2.addObj(_local_4,_local_3.x_,_local_3.y_);
                    break;
                case ShowEffect.COLLAPSE_EFFECT_TYPE:
                    _local_3 = _local_2.goDict_[param1.targetObjectId_];
                    if(_local_3 == null || !this.canShowEffect(_local_3)) {
                        break;
                    }
                    _local_4 = new CollapseEffect(_local_3,param1.pos1_,param1.pos2_,param1.color_);
                    _local_2.addObj(_local_4,param1.pos1_.x_,param1.pos1_.y_);
                    break;
                case ShowEffect.CONEBLAST_EFFECT_TYPE:
                    _local_3 = _local_2.goDict_[param1.targetObjectId_];
                    if(_local_3 == null || !this.canShowEffect(_local_3)) {
                        break;
                    }
                    _local_4 = new ConeBlastEffect(_local_3,param1.pos1_,param1.pos2_.x_,param1.color_);
                    _local_2.addObj(_local_4,_local_3.x_,_local_3.y_);
                    break;
                case ShowEffect.JITTER_EFFECT_TYPE:
                    gs_.camera_.startJitter();
                    break;
                case ShowEffect.FLASH_EFFECT_TYPE:
                    _local_3 = _local_2.goDict_[param1.targetObjectId_];
                    if(_local_3 == null || !this.canShowEffect(_local_3)) {
                        break;
                    }
                    _local_3.flash_ = new FlashDescription(getTimer(),param1.color_,param1.pos1_.x_,param1.pos1_.y_);
                    break;
                case ShowEffect.THROW_PROJECTILE_EFFECT_TYPE:
                    _local_5 = param1.pos1_.toPoint();
                    if(_local_3 != null && !this.canShowEffect(_local_3)) {
                        break;
                    }
                    _local_4 = new ThrowProjectileEffect(param1.color_,param1.pos2_.toPoint(),param1.pos1_.toPoint());
                    _local_2.addObj(_local_4,_local_5.x,_local_5.y);
                    break;
                case ShowEffect.SHOCKER_EFFECT_TYPE:
                    _local_3 = _local_2.goDict_[param1.targetObjectId_];
                    if(_local_3 == null || !this.canShowEffect(_local_3)) {
                        break;
                    }
                    if(_local_3 && _local_3.shockEffect) {
                        _local_3.shockEffect.destroy();
                    }
                    _local_4 = new ShockerEffect(_local_3);
                    _local_3.shockEffect = ShockerEffect(_local_4);
                    gs_.map.addObj(_local_4,_local_3.x_,_local_3.y_);
                    break;
                case ShowEffect.SHOCKEE_EFFECT_TYPE:
                    _local_3 = _local_2.goDict_[param1.targetObjectId_];
                    if(_local_3 == null || !this.canShowEffect(_local_3)) {
                        break;
                    }
                    _local_4 = new ShockeeEffect(_local_3);
                    gs_.map.addObj(_local_4,_local_3.x_,_local_3.y_);
                    break;
                case ShowEffect.RISING_FURY_EFFECT_TYPE:
                    _local_3 = _local_2.goDict_[param1.targetObjectId_];
                    if(_local_3 == null || !this.canShowEffect(_local_3)) {
                        break;
                    }
                    _local_6 = param1.pos1_.x_ * 1000;
                    _local_4 = new RisingFuryEffect(_local_3,_local_6);
                    gs_.map.addObj(_local_4,_local_3.x_,_local_3.y_);
                    break;
            }
        }
        
        private function onGoto(param1:Goto) : void {
            this.gotoAck(gs_.lastUpdate_);
            var _local_2:GameObject = gs_.map.goDict_[param1.objectId_];
            if(_local_2 == null) {
                return;
            }
            _local_2.onGoto(param1.pos_.x_,param1.pos_.y_,gs_.lastUpdate_);
        }
        
        private function updateGameObject(param1:GameObject, param2:Vector.<StatData>, param3:Boolean) : void {
            var _local_7:StatData = null;
            var _local_8:int = 0;
            var _local_9:int = 0;
            var _local_10:int = 0;
            var _local_4:Player = param1 as Player;
            var _local_5:Merchant = param1 as Merchant;
            var _local_6:Pet = param1 as Pet;
            if(_local_6) {
                this.petUpdater.updatePet(_local_6,param2);
                if(gs_.map.isPetYard) {
                    this.petUpdater.updatePetVOs(_local_6,param2);
                }
                return;
            }
            for each(_local_7 in param2) {
                _local_8 = _local_7.statValue_;
                switch(_local_7.statType_) {
                    case StatData.MAX_HP_STAT:
                        param1.maxHP_ = _local_8;
                        continue;
                    case StatData.HP_STAT:
                        param1.hp_ = _local_8;
                        continue;
                    case StatData.SIZE_STAT:
                        param1.size_ = _local_8;
                        continue;
                    case StatData.MAX_MP_STAT:
                        _local_4.maxMP_ = _local_8;
                        continue;
                    case StatData.MP_STAT:
                        _local_4.mp_ = _local_8;
                        continue;
                    case StatData.NEXT_LEVEL_EXP_STAT:
                        _local_4.nextLevelExp_ = _local_8;
                        continue;
                    case StatData.EXP_STAT:
                        _local_4.exp_ = _local_8;
                        continue;
                    case StatData.LEVEL_STAT:
                        param1.level_ = _local_8;
                        continue;
                    case StatData.ATTACK_STAT:
                        _local_4.attack_ = _local_8;
                        continue;
                    case StatData.DEFENSE_STAT:
                        param1.defense_ = _local_8;
                        continue;
                    case StatData.SPEED_STAT:
                        _local_4.speed_ = _local_8;
                        continue;
                    case StatData.DEXTERITY_STAT:
                        _local_4.dexterity_ = _local_8;
                        continue;
                    case StatData.VITALITY_STAT:
                        _local_4.vitality_ = _local_8;
                        continue;
                    case StatData.WISDOM_STAT:
                        _local_4.wisdom_ = _local_8;
                        continue;
                    case StatData.CONDITION_STAT:
                        param1.condition_[ConditionEffect.CE_FIRST_BATCH] = _local_8;
                        continue;
                    case StatData.INVENTORY_0_STAT:
                    case StatData.INVENTORY_1_STAT:
                    case StatData.INVENTORY_2_STAT:
                    case StatData.INVENTORY_3_STAT:
                    case StatData.INVENTORY_4_STAT:
                    case StatData.INVENTORY_5_STAT:
                    case StatData.INVENTORY_6_STAT:
                    case StatData.INVENTORY_7_STAT:
                    case StatData.INVENTORY_8_STAT:
                    case StatData.INVENTORY_9_STAT:
                    case StatData.INVENTORY_10_STAT:
                    case StatData.INVENTORY_11_STAT:
                        _local_9 = _local_7.statType_ - StatData.INVENTORY_0_STAT;
                        if(_local_8 != -1) {
                            param1.lockedSlot[_local_9] = 0;
                        }
                        param1.equipment_[_local_9] = _local_8;
                        continue;
                    case StatData.NUM_STARS_STAT:
                        _local_4.numStars_ = _local_8;
                        continue;
                    case StatData.NAME_STAT:
                        if(param1.name_ != _local_7.strStatValue_) {
                            param1.name_ = _local_7.strStatValue_;
                            param1.nameBitmapData_ = null;
                        }
                        continue;
                    case StatData.TEX1_STAT:
                        _local_8 >= 0 && param1.setTex1(_local_8);
                        continue;
                    case StatData.TEX2_STAT:
                        _local_8 >= 0 && param1.setTex2(_local_8);
                        continue;
                    case StatData.MERCHANDISE_TYPE_STAT:
                        _local_5.setMerchandiseType(_local_8);
                        continue;
                    case StatData.CREDITS_STAT:
                        _local_4.setCredits(_local_8);
                        continue;
                    case StatData.MERCHANDISE_PRICE_STAT:
                        (param1 as SellableObject).setPrice(_local_8);
                        continue;
                    case StatData.ACTIVE_STAT:
                        (param1 as Portal).active_ = _local_8 != 0;
                        continue;
                    case StatData.ACCOUNT_ID_STAT:
                        _local_4.accountId_ = _local_7.strStatValue_;
                        continue;
                    case StatData.FAME_STAT:
                        _local_4.fame_ = _local_8;
                        continue;
                    case StatData.FORTUNE_TOKEN_STAT:
                        _local_4.setTokens(_local_8);
                        continue;
                    case StatData.MERCHANDISE_CURRENCY_STAT:
                        (param1 as SellableObject).setCurrency(_local_8);
                        continue;
                    case StatData.CONNECT_STAT:
                        param1.connectType_ = _local_8;
                        continue;
                    case StatData.MERCHANDISE_COUNT_STAT:
                        _local_5.count_ = _local_8;
                        _local_5.untilNextMessage_ = 0;
                        continue;
                    case StatData.MERCHANDISE_MINS_LEFT_STAT:
                        _local_5.minsLeft_ = _local_8;
                        _local_5.untilNextMessage_ = 0;
                        continue;
                    case StatData.MERCHANDISE_DISCOUNT_STAT:
                        _local_5.discount_ = _local_8;
                        _local_5.untilNextMessage_ = 0;
                        continue;
                    case StatData.MERCHANDISE_RANK_REQ_STAT:
                        (param1 as SellableObject).setRankReq(_local_8);
                        continue;
                    case StatData.MAX_HP_BOOST_STAT:
                        _local_4.maxHPBoost_ = _local_8;
                        continue;
                    case StatData.MAX_MP_BOOST_STAT:
                        _local_4.maxMPBoost_ = _local_8;
                        continue;
                    case StatData.ATTACK_BOOST_STAT:
                        _local_4.attackBoost_ = _local_8;
                        continue;
                    case StatData.DEFENSE_BOOST_STAT:
                        _local_4.defenseBoost_ = _local_8;
                        continue;
                    case StatData.SPEED_BOOST_STAT:
                        _local_4.speedBoost_ = _local_8;
                        continue;
                    case StatData.VITALITY_BOOST_STAT:
                        _local_4.vitalityBoost_ = _local_8;
                        continue;
                    case StatData.WISDOM_BOOST_STAT:
                        _local_4.wisdomBoost_ = _local_8;
                        continue;
                    case StatData.DEXTERITY_BOOST_STAT:
                        _local_4.dexterityBoost_ = _local_8;
                        continue;
                    case StatData.OWNER_ACCOUNT_ID_STAT:
                        (param1 as Container).setOwnerId(_local_7.strStatValue_);
                        continue;
                    case StatData.RANK_REQUIRED_STAT:
                        (param1 as NameChanger).setRankRequired(_local_8);
                        continue;
                    case StatData.NAME_CHOSEN_STAT:
                        _local_4.nameChosen_ = _local_8 != 0;
                        param1.nameBitmapData_ = null;
                        continue;
                    case StatData.CURR_FAME_STAT:
                        _local_4.currFame_ = _local_8;
                        continue;
                    case StatData.NEXT_CLASS_QUEST_FAME_STAT:
                        _local_4.nextClassQuestFame_ = _local_8;
                        continue;
                    case StatData.LEGENDARY_RANK_STAT:
                        _local_4.legendaryRank_ = _local_8;
                        continue;
                    case StatData.SINK_LEVEL_STAT:
                        if(!param3) {
                            _local_4.sinkLevel_ = _local_8;
                        }
                        continue;
                    case StatData.ALT_TEXTURE_STAT:
                        param1.setAltTexture(_local_8);
                        continue;
                    case StatData.GUILD_NAME_STAT:
                        _local_4.setGuildName(_local_7.strStatValue_);
                        continue;
                    case StatData.GUILD_RANK_STAT:
                        _local_4.guildRank_ = _local_8;
                        continue;
                    case StatData.BREATH_STAT:
                        _local_4.breath_ = _local_8;
                        continue;
                    case StatData.XP_BOOSTED_STAT:
                        _local_4.xpBoost_ = _local_8;
                        continue;
                    case StatData.XP_TIMER_STAT:
                        _local_4.xpTimer = _local_8 * TO_MILLISECONDS;
                        continue;
                    case StatData.LD_TIMER_STAT:
                        _local_4.dropBoost = _local_8 * TO_MILLISECONDS;
                        continue;
                    case StatData.LT_TIMER_STAT:
                        _local_4.tierBoost = _local_8 * TO_MILLISECONDS;
                        continue;
                    case StatData.HEALTH_POTION_STACK_STAT:
                        _local_4.healthPotionCount_ = _local_8;
                        continue;
                    case StatData.MAGIC_POTION_STACK_STAT:
                        _local_4.magicPotionCount_ = _local_8;
                        continue;
                    case StatData.TEXTURE_STAT:
                        _local_4.skinId != _local_8 && _local_8 >= 0 && this.setPlayerSkinTemplate(_local_4,_local_8);
                        continue;
                    case StatData.HASBACKPACK_STAT:
                        (param1 as Player).hasBackpack_ = Boolean(_local_8);
                        if(param3) {
                            this.updateBackpackTab.dispatch(Boolean(_local_8));
                        }
                        continue;
                    case StatData.BACKPACK_0_STAT:
                    case StatData.BACKPACK_1_STAT:
                    case StatData.BACKPACK_2_STAT:
                    case StatData.BACKPACK_3_STAT:
                    case StatData.BACKPACK_4_STAT:
                    case StatData.BACKPACK_5_STAT:
                    case StatData.BACKPACK_6_STAT:
                    case StatData.BACKPACK_7_STAT:
                        _local_10 = _local_7.statType_ - StatData.BACKPACK_0_STAT + GeneralConstants.NUM_EQUIPMENT_SLOTS + GeneralConstants.NUM_INVENTORY_SLOTS;
                        (param1 as Player).equipment_[_local_10] = _local_8;
                        continue;
                    case StatData.NEW_CON_STAT:
                        param1.condition_[ConditionEffect.CE_SECOND_BATCH] = _local_8;
                        continue;
                    default:
                        continue;
                }
            }
        }
        
        private function setPlayerSkinTemplate(param1:Player, param2:int) : void {
            var _local_3:Reskin = this.messages.require(RESKIN) as Reskin;
            _local_3.skinID = param2;
            _local_3.player = param1;
            _local_3.consume();
        }
        
        private function processObjectStatus(param1:ObjectStatusData, param2:int, param3:int) : void {
            var _local_8:int = 0;
            var _local_9:int = 0;
            var _local_10:int = 0;
            var _local_11:CharacterClass = null;
            var _local_12:XML = null;
            var _local_13:String = null;
            var _local_14:String = null;
            var _local_15:int = 0;
            var _local_16:ObjectProperties = null;
            var _local_17:ProjectileProperties = null;
            var _local_18:Array = null;
            var _local_4:AbstractMap = gs_.map;
            var _local_5:GameObject = _local_4.goDict_[param1.objectId_];
            if(_local_5 == null) {
                return;
            }
            var _local_6:* = param1.objectId_ == this.playerId_;
            if(param2 != 0 && !_local_6) {
                _local_5.onTickPos(param1.pos_.x_,param1.pos_.y_,param2,param3);
            }
            var _local_7:Player = _local_5 as Player;
            if(_local_7 != null) {
                _local_8 = _local_7.level_;
                _local_9 = _local_7.exp_;
                _local_10 = _local_7.skinId;
            }
            this.updateGameObject(_local_5,param1.stats_,_local_6);
            if(_local_7) {
                if(_local_6) {
                    _local_11 = this.classesModel.getCharacterClass(_local_7.objectType_);
                    if(_local_11.getMaxLevelAchieved() < _local_7.level_) {
                        _local_11.setMaxLevelAchieved(_local_7.level_);
                    }
                }
                if(_local_7.skinId != _local_10) {
                    if(ObjectLibrary.skinSetXMLDataLibrary_[_local_7.skinId] != null) {
                        _local_12 = ObjectLibrary.skinSetXMLDataLibrary_[_local_7.skinId] as XML;
                        _local_13 = _local_12.attribute("color");
                        _local_14 = _local_12.attribute("bulletType");
                        if(_local_8 != -1 && _local_13.length > 0) {
                            _local_7.levelUpParticleEffect(uint(_local_13));
                        }
                        if(_local_14.length > 0) {
                            _local_7.projectileIdSetOverrideNew = _local_14;
                            _local_15 = _local_7.equipment_[0];
                            _local_16 = ObjectLibrary.propsLibrary_[_local_15];
                            _local_17 = _local_16.projectiles_[0];
                            _local_7.projectileIdSetOverrideOld = _local_17.objectId_;
                        }
                    } else if(ObjectLibrary.skinSetXMLDataLibrary_[_local_7.skinId] == null) {
                        _local_7.projectileIdSetOverrideNew = "";
                        _local_7.projectileIdSetOverrideOld = "";
                    }
                }
                if(_local_8 != -1 && _local_7.level_ > _local_8) {
                    if(_local_6) {
                        _local_18 = gs_.model.getNewUnlocks(_local_7.objectType_,_local_7.level_);
                        _local_7.handleLevelUp(_local_18.length != 0);
                    } else {
                        _local_7.levelUpEffect(TextKey.PLAYER_LEVELUP);
                    }
                } else if(_local_8 != -1 && _local_7.exp_ > _local_9) {
                    _local_7.handleExpUp(_local_7.exp_ - _local_9);
                }
                this.friendModel.updateFriendVO(_local_7.getName(),_local_7);
            }
        }
        
        private function onInvResult(param1:InvResult) : void {
            if(param1.result_ != 0) {
                this.handleInvFailure();
            }
        }
        
        private function handleInvFailure() : void {
            SoundEffectLibrary.play("error");
            gs_.hudView.interactPanel.redraw();
        }
        
        private function onReconnect(param1:Reconnect) : void {
            var _local_2:Server = new Server().setName(param1.name_).setAddress(param1.host_ != ""?param1.host_:server_.address).setPort(param1.host_ != ""?int(param1.port_):int(server_.port));
            var _local_3:int = param1.gameId_;
            var _local_4:Boolean = createCharacter_;
            var _local_5:int = charId_;
            var _local_6:int = param1.keyTime_;
            var _local_7:ByteArray = param1.key_;
            isFromArena_ = param1.isFromArena_;
            var _local_8:ReconnectEvent = new ReconnectEvent(_local_2,_local_3,_local_4,_local_5,_local_6,_local_7,isFromArena_);
            gs_.dispatchEvent(_local_8);
        }
        
        private function onPing(param1:Ping) : void {
            var _local_2:Pong = this.messages.require(PONG) as Pong;
            _local_2.serial_ = param1.serial_;
            _local_2.time_ = getTimer();
            serverConnection.sendMessage(_local_2);
        }
        
        private function parseXML(param1:String) : void {
            var _local_2:XML = XML(param1);
            GroundLibrary.parseFromXML(_local_2);
            ObjectLibrary.parseFromXML(_local_2);
            ObjectLibrary.parseFromXML(_local_2);
        }
        
        private function onMapInfo(param1:MapInfo) : void {
            var _local_2:String = null;
            var _local_3:String = null;
            for each(_local_2 in param1.clientXML_) {
                this.parseXML(_local_2);
            }
            for each(_local_3 in param1.extraXML_) {
                this.parseXML(_local_3);
            }
            changeMapSignal.dispatch();
            this.closeDialogs.dispatch();
            gs_.applyMapInfo(param1);
            this.rand_ = new Random(param1.fp_);
            if(createCharacter_) {
                this.create();
            } else {
                this.load();
            }
        }
        
        private function onPic(param1:Pic) : void {
            gs_.addChild(new PicView(param1.bitmapData_));
        }
        
        private function onDeath(param1:Death) : void {
            this.death = param1;
            var _local_2:BitmapData = new BitmapDataSpy(gs_.stage.stageWidth,gs_.stage.stageHeight);
            _local_2.draw(gs_);
            param1.background = _local_2;
            if(!gs_.isEditor) {
                this.handleDeath.dispatch(param1);
            }
            this.checkDavyKeyRemoval();
        }
        
        private function onBuyResult(param1:BuyResult) : void {
            if(param1.result_ == BuyResult.SUCCESS_BRID) {
                if(outstandingBuy_ != null) {
                    outstandingBuy_.record();
                }
            }
            outstandingBuy_ = null;
            this.handleBuyResultType(param1);
        }
        
        private function handleBuyResultType(param1:BuyResult) : void {
            var _local_2:ChatMessage = null;
            switch(param1.result_) {
                case BuyResult.UNKNOWN_ERROR_BRID:
                    _local_2 = ChatMessage.make(Parameters.SERVER_CHAT_NAME,param1.resultString_);
                    this.addTextLine.dispatch(_local_2);
                    break;
                case BuyResult.NOT_ENOUGH_GOLD_BRID:
                    this.openDialog.dispatch(new NotEnoughGoldDialog());
                    break;
                case BuyResult.NOT_ENOUGH_FAME_BRID:
                    this.openDialog.dispatch(new NotEnoughFameDialog());
                    break;
                default:
                    this.handleDefaultResult(param1);
            }
        }
        
        private function handleDefaultResult(param1:BuyResult) : void {
            var _local_2:LineBuilder = LineBuilder.fromJSON(param1.resultString_);
            var _local_3:Boolean = param1.result_ == BuyResult.SUCCESS_BRID || param1.result_ == BuyResult.PET_FEED_SUCCESS_BRID;
            var _local_4:ChatMessage = ChatMessage.make(!!_local_3?Parameters.SERVER_CHAT_NAME:Parameters.ERROR_CHAT_NAME,_local_2.key);
            _local_4.tokens = _local_2.tokens;
            this.addTextLine.dispatch(_local_4);
        }
        
        private function onAccountList(param1:AccountList) : void {
            if(param1.accountListId_ == 0) {
                if(param1.lockAction_ != -1) {
                    if(param1.lockAction_ == 1) {
                        gs_.map.party_.setStars(param1);
                    } else {
                        gs_.map.party_.removeStars(param1);
                    }
                } else {
                    gs_.map.party_.setStars(param1);
                }
            } else if(param1.accountListId_ == 1) {
                gs_.map.party_.setIgnores(param1);
            }
        }
        
        private function onQuestObjId(param1:QuestObjId) : void {
            gs_.map.quest_.setObject(param1.objectId_);
        }
        
        private function onAoe(param1:Aoe) : void {
            var _local_4:int = 0;
            var _local_5:Vector.<uint> = null;
            if(this.player == null) {
                this.aoeAck(gs_.lastUpdate_,0,0);
                return;
            }
            var _local_2:AOEEffect = new AOEEffect(param1.pos_.toPoint(),param1.radius_,param1.color_);
            gs_.map.addObj(_local_2,param1.pos_.x_,param1.pos_.y_);
            if(this.player.isInvincible() || this.player.isPaused()) {
                this.aoeAck(gs_.lastUpdate_,this.player.x_,this.player.y_);
                return;
            }
            var _local_3:* = this.player.distTo(param1.pos_) < param1.radius_;
            if(_local_3) {
                _local_4 = GameObject.damageWithDefense(param1.damage_,this.player.defense_,false,this.player.condition_);
                _local_5 = null;
                if(param1.effect_ != 0) {
                    _local_5 = new Vector.<uint>();
                    _local_5.push(param1.effect_);
                }
                this.player.damage(param1.origType_,_local_4,_local_5,false,null);
            }
            this.aoeAck(gs_.lastUpdate_,this.player.x_,this.player.y_);
        }
        
        private function onNameResult(param1:NameResult) : void {
            gs_.dispatchEvent(new NameResultEvent(param1));
        }
        
        private function onGuildResult(param1:GuildResult) : void {
            var _local_2:LineBuilder = null;
            if(param1.lineBuilderJSON == "") {
                gs_.dispatchEvent(new GuildResultEvent(param1.success_,"",{}));
            } else {
                _local_2 = LineBuilder.fromJSON(param1.lineBuilderJSON);
                this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME,_local_2.key,-1,-1,"",false,_local_2.tokens));
                gs_.dispatchEvent(new GuildResultEvent(param1.success_,_local_2.key,_local_2.tokens));
            }
        }
        
        private function onClientStat(param1:ClientStat) : void {
            var _local_2:Account = StaticInjectorContext.getInjector().getInstance(Account);
            _local_2.reportIntStat(param1.name_,param1.value_);
        }
        
        private function onFile(param1:File) : void {
            new FileReference().save(param1.file_,param1.filename_);
        }
        
        private function onInvitedToGuild(param1:InvitedToGuild) : void {
            if(Parameters.data_.showGuildInvitePopup) {
                gs_.hudView.interactPanel.setOverride(new GuildInvitePanel(gs_,param1.name_,param1.guildName_));
            }
            this.addTextLine.dispatch(ChatMessage.make("","You have been invited by " + param1.name_ + " to join the guild " + param1.guildName_ + ".\n  If you wish to join type \"/join " + param1.guildName_ + "\""));
        }
        
        private function onPlaySound(param1:PlaySound) : void {
            var _local_2:GameObject = gs_.map.goDict_[param1.ownerId_];
            _local_2 && _local_2.playSound(param1.soundId_);
        }
        
        private function onImminentArenaWave(param1:ImminentArenaWave) : void {
            this.imminentWave.dispatch(param1.currentRuntime);
        }
        
        private function onArenaDeath(param1:ArenaDeath) : void {
            this.currentArenaRun.costOfContinue = param1.cost;
            this.openDialog.dispatch(new ContinueOrQuitDialog(param1.cost,false));
            this.arenaDeath.dispatch();
        }
        
        private function onVerifyEmail(param1:VerifyEmail) : void {
            TitleView.queueEmailConfirmation = true;
            if(gs_ != null) {
                gs_.closed.dispatch();
            }
            var _local_2:HideMapLoadingSignal = StaticInjectorContext.getInjector().getInstance(HideMapLoadingSignal);
            if(_local_2 != null) {
                _local_2.dispatch();
            }
        }
        
        private function onPasswordPrompt(param1:PasswordPrompt) : void {
            if(param1.cleanPasswordStatus == 3) {
                TitleView.queuePasswordPromptFull = true;
            } else if(param1.cleanPasswordStatus == 2) {
                TitleView.queuePasswordPrompt = true;
            } else if(param1.cleanPasswordStatus == 4) {
                TitleView.queueRegistrationPrompt = true;
            }
            if(gs_ != null) {
                gs_.closed.dispatch();
            }
            var _local_2:HideMapLoadingSignal = StaticInjectorContext.getInjector().getInstance(HideMapLoadingSignal);
            if(_local_2 != null) {
                _local_2.dispatch();
            }
        }
        
        override public function questFetch() : void {
            serverConnection.sendMessage(this.messages.require(QUEST_FETCH_ASK));
        }
        
        private function onQuestFetchResponse(param1:QuestFetchResponse) : void {
            this.questFetchComplete.dispatch(param1);
        }
        
        private function onQuestRedeemResponse(param1:QuestRedeemResponse) : void {
            this.questRedeemComplete.dispatch(param1);
        }
        
        override public function questRedeem(param1:int, param2:int, param3:int) : void {
            var _local_4:QuestRedeem = this.messages.require(QUEST_REDEEM) as QuestRedeem;
            _local_4.slotObject.objectId_ = param1;
            _local_4.slotObject.slotId_ = param2;
            _local_4.slotObject.objectType_ = param3;
            serverConnection.sendMessage(_local_4);
        }
        
        override public function keyInfoRequest(param1:int) : void {
            var _local_2:KeyInfoRequest = this.messages.require(KEY_INFO_REQUEST) as KeyInfoRequest;
            _local_2.itemType_ = param1;
            serverConnection.sendMessage(_local_2);
        }
        
        private function onKeyInfoResponse(param1:KeyInfoResponse) : void {
            this.keyInfoResponse.dispatch(param1);
        }
        
        private function onLoginRewardResponse(param1:ClaimDailyRewardResponse) : void {
            this.claimDailyRewardResponse.dispatch(param1);
        }
        
        private function onClosed() : void {
            var _local_1:HideMapLoadingSignal = null;
            if(this.playerId_ != -1) {
                gs_.closed.dispatch();
            } else if(this.retryConnection_) {
                if(this.delayBeforeReconnect < 10) {
                    if(this.delayBeforeReconnect == 6) {
                        _local_1 = StaticInjectorContext.getInjector().getInstance(HideMapLoadingSignal);
                        _local_1.dispatch();
                    }
                    this.retry(this.delayBeforeReconnect++);
                    this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME,"Connection failed!  Retrying..."));
                } else {
                    gs_.closed.dispatch();
                }
            }
        }
        
        private function retry(param1:int) : void {
            this.retryTimer_ = new Timer(param1 * 1000,1);
            this.retryTimer_.addEventListener(TimerEvent.TIMER_COMPLETE,this.onRetryTimer);
            this.retryTimer_.start();
        }
        
        private function onRetryTimer(param1:TimerEvent) : void {
            serverConnection.connect(server_.address,server_.port);
        }
        
        private function onError(param1:String) : void {
            this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME,param1));
        }
        
        private function onFailure(param1:Failure) : void {
            switch(param1.errorId_) {
                case Failure.INCORRECT_VERSION:
                    this.handleIncorrectVersionFailure(param1);
                    break;
                case Failure.BAD_KEY:
                    this.handleBadKeyFailure(param1);
                    break;
                case Failure.INVALID_TELEPORT_TARGET:
                    this.handleInvalidTeleportTarget(param1);
                    break;
                case Failure.EMAIL_VERIFICATION_NEEDED:
                    this.handleEmailVerificationNeeded(param1);
                    break;
                default:
                    this.handleDefaultFailure(param1);
            }
        }
        
        private function handleEmailVerificationNeeded(param1:Failure) : void {
            this.retryConnection_ = false;
            gs_.closed.dispatch();
        }
        
        private function handleInvalidTeleportTarget(param1:Failure) : void {
            var _local_2:String = LineBuilder.getLocalizedStringFromJSON(param1.errorDescription_);
            if(_local_2 == "") {
                _local_2 = param1.errorDescription_;
            }
            this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME,_local_2));
            this.player.nextTeleportAt_ = 0;
        }
        
        private function handleBadKeyFailure(param1:Failure) : void {
            var _local_2:String = LineBuilder.getLocalizedStringFromJSON(param1.errorDescription_);
            if(_local_2 == "") {
                _local_2 = param1.errorDescription_;
            }
            this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME,_local_2));
            this.retryConnection_ = false;
            gs_.closed.dispatch();
        }
        
        private function handleIncorrectVersionFailure(param1:Failure) : void {
            var _local_2:Dialog = new Dialog(TextKey.CLIENT_UPDATE_TITLE,"",TextKey.CLIENT_UPDATE_LEFT_BUTTON,null,"/clientUpdate");
            _local_2.setTextParams(TextKey.CLIENT_UPDATE_DESCRIPTION,{
                "client":Parameters.BUILD_VERSION,
                "server":param1.errorDescription_
            });
            _local_2.addEventListener(Dialog.LEFT_BUTTON,this.onDoClientUpdate);
            gs_.stage.addChild(_local_2);
            this.retryConnection_ = false;
        }
        
        private function handleDefaultFailure(param1:Failure) : void {
            var _local_2:String = LineBuilder.getLocalizedStringFromJSON(param1.errorDescription_);
            if(_local_2 == "") {
                _local_2 = param1.errorDescription_;
            }
            this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME,_local_2));
        }
        
        private function onDoClientUpdate(param1:Event) : void {
            var _local_2:Dialog = param1.currentTarget as Dialog;
            _local_2.parent.removeChild(_local_2);
            gs_.closed.dispatch();
        }
        
        override public function isConnected() : Boolean {
            return serverConnection.isConnected();
        }
    }
}
