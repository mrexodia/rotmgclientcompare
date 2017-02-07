package kabam.rotmg.friends.model {
    import com.company.assembleegameclient.objects.Player;
    import com.company.assembleegameclient.parameters.Parameters;
    import com.company.assembleegameclient.util.FameUtil;
    import flash.utils.Dictionary;
    import kabam.rotmg.core.StaticInjectorContext;
    import kabam.rotmg.friends.service.FriendDataRequestTask;
    import kabam.rotmg.servers.api.Server;
    import kabam.rotmg.servers.api.ServerModel;
    import org.osflash.signals.Signal;
    import org.swiftsuspenders.Injector;
    
    public class FriendModel {
         
        
        [Inject]
        public var serverModel:ServerModel;
        
        public var friendsTask:FriendDataRequestTask;
        
        public var invitationsTask:FriendDataRequestTask;
        
        private var _onlineFriends:Vector.<FriendVO>;
        
        private var _offlineFriends:Vector.<FriendVO>;
        
        private var _friends:Dictionary;
        
        private var _invitations:Dictionary;
        
        private var _friendsLoadInProcess:Boolean;
        
        private var _invitationsLoadInProgress:Boolean;
        
        private var _friendTotal:int;
        
        private var _invitationTotal:int;
        
        private var _isFriDataOK:Boolean;
        
        private var _isInvDataOK:Boolean;
        
        private var _serverDict:Dictionary;
        
        private var _currentServer:Server;
        
        public var errorStr:String;
        
        public var dataSignal:Signal;
        
        public function FriendModel() {
            this.dataSignal = new Signal(Boolean);
            super();
            this._friendTotal = 0;
            this._invitationTotal = 0;
            this._invitationTotal = 0;
            this._friends = new Dictionary(true);
            this._onlineFriends = new Vector.<FriendVO>();
            this._offlineFriends = new Vector.<FriendVO>();
            this._friendsLoadInProcess = false;
            this._invitationsLoadInProgress = false;
            this.loadData();
        }
        
        public function setCurrentServer(param1:Server) : void {
            this._currentServer = param1;
        }
        
        public function getCurrentServerName() : String {
            var _local_1:String = !!this._currentServer?this._currentServer.name:"";
            return _local_1;
        }
        
        public function loadData() : void {
            if(this._friendsLoadInProcess || this._invitationsLoadInProgress) {
                return;
            }
            var _local_1:Injector = StaticInjectorContext.getInjector();
            this._friendsLoadInProcess = true;
            this.friendsTask = _local_1.getInstance(FriendDataRequestTask);
            this.loadList(this.friendsTask,FriendConstant.getURL(FriendConstant.FRIEND_LIST),this.onFriendListResponse);
            this._invitationsLoadInProgress = true;
            this.invitationsTask = _local_1.getInstance(FriendDataRequestTask);
            this.loadList(this.invitationsTask,FriendConstant.getURL(FriendConstant.INVITE_LIST),this.onInvitationListResponse);
        }
        
        private function loadList(param1:FriendDataRequestTask, param2:String, param3:Function) : void {
            param1.requestURL = param2;
            param1.finished.addOnce(param3);
            param1.start();
        }
        
        private function onFriendListResponse(param1:FriendDataRequestTask, param2:Boolean, param3:String = "") : void {
            if(param2) {
                this.seedFriends(param1.xml);
            }
            this._isFriDataOK = param2;
            this.errorStr = param3;
            param1.reset();
            this._friendsLoadInProcess = false;
            this.reportTasksComplete();
        }
        
        private function onInvitationListResponse(param1:FriendDataRequestTask, param2:Boolean, param3:String = "") : void {
            if(param2) {
                this.seedInvitations(param1.xml);
            }
            this._isInvDataOK = param2;
            this.errorStr = param3;
            param1.reset();
            this._invitationsLoadInProgress = false;
            this.reportTasksComplete();
        }
        
        private function reportTasksComplete() : void {
            if(this._friendsLoadInProcess == false && this._invitationsLoadInProgress == false) {
                this.dataSignal.dispatch(this._isFriDataOK && this._isInvDataOK);
            }
        }
        
        public function seedFriends(param1:XML) : void {
            var _local_2:String = null;
            var _local_3:String = null;
            var _local_4:String = null;
            var _local_5:FriendVO = null;
            var _local_6:XML = null;
            this._onlineFriends.length = 0;
            this._offlineFriends.length = 0;
            for each(_local_6 in param1.Account) {
                _local_2 = _local_6.Name;
                _local_5 = this._friends[_local_2] != null?this._friends[_local_2].vo as FriendVO:new FriendVO(Player.fromPlayerXML(_local_2,_local_6.Character[0]));
                if(_local_6.hasOwnProperty("Online")) {
                    _local_4 = String(_local_6.Online);
                    _local_3 = this.serverNameDictionary()[_local_4];
                    _local_5.online(_local_3,_local_4);
                    this._onlineFriends.push(_local_5);
                    this._friends[_local_5.getName()] = {
                        "vo":_local_5,
                        "list":this._onlineFriends
                    };
                } else {
                    _local_5.offline();
                    this._offlineFriends.push(_local_5);
                    this._friends[_local_5.getName()] = {
                        "vo":_local_5,
                        "list":this._offlineFriends
                    };
                }
            }
            this._onlineFriends.sort(this.sortFriend);
            this._offlineFriends.sort(this.sortFriend);
            this._friendTotal = this._onlineFriends.length + this._offlineFriends.length;
        }
        
        public function seedInvitations(param1:XML) : void {
            var _local_2:String = null;
            var _local_3:XML = null;
            var _local_4:Player = null;
            this._invitations = new Dictionary(true);
            this._invitationTotal = 0;
            for each(_local_3 in param1.Account) {
                if(this.starFilter(int(_local_3.Character[0].ObjectType),int(_local_3.Character[0].CurrentFame),_local_3.Stats[0])) {
                    _local_2 = _local_3.Name;
                    _local_4 = Player.fromPlayerXML(_local_2,_local_3.Character[0]);
                    this._invitations[_local_2] = new FriendVO(_local_4);
                    this._invitationTotal++;
                }
            }
        }
        
        public function isMyFriend(param1:String) : Boolean {
            return this._friends[param1] != null;
        }
        
        public function updateFriendVO(param1:String, param2:Player) : void {
            var _local_3:Object = null;
            var _local_4:FriendVO = null;
            if(this.isMyFriend(param1)) {
                _local_3 = this._friends[param1];
                _local_4 = _local_3.vo as FriendVO;
                _local_4.updatePlayer(param2);
            }
        }
        
        public function getFilterFriends(param1:String) : Vector.<FriendVO> {
            var _local_3:FriendVO = null;
            var _local_2:RegExp = new RegExp(param1,"gix");
            var _local_4:Vector.<FriendVO> = new Vector.<FriendVO>();
            var _local_5:int = 0;
            while(_local_5 < this._onlineFriends.length) {
                _local_3 = this._onlineFriends[_local_5];
                if(_local_3.getName().search(_local_2) >= 0) {
                    _local_4.push(_local_3);
                }
                _local_5++;
            }
            _local_5 = 0;
            while(_local_5 < this._offlineFriends.length) {
                _local_3 = this._offlineFriends[_local_5];
                if(_local_3.getName().search(_local_2) >= 0) {
                    _local_4.push(_local_3);
                }
                _local_5++;
            }
            return _local_4;
        }
        
        public function ifReachMax() : Boolean {
            return this._friendTotal >= FriendConstant.FRIEMD_MAX_CAP;
        }
        
        public function getAllFriends() : Vector.<FriendVO> {
            return this._onlineFriends.concat(this._offlineFriends);
        }
        
        public function getAllInvitations() : Vector.<FriendVO> {
            var _local_2:FriendVO = null;
            var _local_1:* = new Vector.<FriendVO>();
            for each(_local_2 in this._invitations) {
                _local_1.push(_local_2);
            }
            _local_1.sort(this.sortFriend);
            return _local_1;
        }
        
        public function removeFriend(param1:String) : Boolean {
            var _local_2:Object = this._friends[param1];
            if(_local_2) {
                this.removeFromList(_local_2.list,param1);
                this._friends[param1] = null;
                delete this._friends[param1];
                return true;
            }
            return false;
        }
        
        public function removeInvitation(param1:String) : Boolean {
            if(this._invitations[param1] != null) {
                this._invitations[param1] = null;
                delete this._invitations[param1];
                return true;
            }
            return false;
        }
        
        private function removeFromList(param1:Vector.<FriendVO>, param2:String) : * {
            var _local_3:FriendVO = null;
            var _local_4:int = 0;
            while(_local_4 < param1.length) {
                _local_3 = param1[_local_4];
                if(_local_3.getName() == param2) {
                    param1.slice(_local_4,1);
                    return;
                }
                _local_4++;
            }
        }
        
        private function sortFriend(param1:FriendVO, param2:FriendVO) : Number {
            if(param1.getName() < param2.getName()) {
                return -1;
            }
            if(param1.getName() > param2.getName()) {
                return 1;
            }
            return 0;
        }
        
        private function serverNameDictionary() : Dictionary {
            var _local_2:Server = null;
            if(this._serverDict) {
                return this._serverDict;
            }
            var _local_1:Vector.<Server> = this.serverModel.getServers();
            this._serverDict = new Dictionary(true);
            for each(_local_2 in _local_1) {
                this._serverDict[_local_2.address] = _local_2.name;
            }
            return this._serverDict;
        }
        
        private function starFilter(param1:int, param2:int, param3:XML) : Boolean {
            return FameUtil.numAllTimeStars(param1,param2,param3) >= Parameters.data_.friendStarRequirement;
        }
    }
}
