package com.company.assembleegameclient.objects {
    import com.company.assembleegameclient.map.Map;
    import com.company.util.PointUtil;
    import flash.utils.Dictionary;
    import kabam.rotmg.messaging.impl.incoming.AccountList;
    
    public class Party {
        
        public static const NUM_MEMBERS:int = 6;
        
        private static const SORT_ON_FIELDS:Array = ["starred_","distSqFromThisPlayer_","objectId_"];
        
        private static const SORT_ON_PARAMS:Array = [Array.NUMERIC | Array.DESCENDING,Array.NUMERIC,Array.NUMERIC];
        
        private static const PARTY_DISTANCE_SQ:int = 50 * 50;
         
        
        public var map_:Map;
        
        public var members_:Array;
        
        private var starred_:Dictionary;
        
        private var ignored_:Dictionary;
        
        private var lastUpdate_:int = -2147483648;
        
        public function Party(param1:Map) {
            this.members_ = [];
            this.starred_ = new Dictionary(true);
            this.ignored_ = new Dictionary(true);
            super();
            this.map_ = param1;
        }
        
        public function update(param1:int, param2:int) : void {
            var _local_4:GameObject = null;
            var _local_5:Player = null;
            if(param1 < this.lastUpdate_ + 500) {
                return;
            }
            this.lastUpdate_ = param1;
            this.members_.length = 0;
            var _local_3:Player = this.map_.player_;
            if(_local_3 == null) {
                return;
            }
            for each(_local_4 in this.map_.goDict_) {
                _local_5 = _local_4 as Player;
                if(!(_local_5 == null || _local_5 == _local_3)) {
                    _local_5.starred_ = this.starred_[_local_5.accountId_] != undefined;
                    _local_5.ignored_ = this.ignored_[_local_5.accountId_] != undefined;
                    _local_5.distSqFromThisPlayer_ = PointUtil.distanceSquaredXY(_local_3.x_,_local_3.y_,_local_5.x_,_local_5.y_);
                    if(!(_local_5.distSqFromThisPlayer_ > PARTY_DISTANCE_SQ && !_local_5.starred_)) {
                        this.members_.push(_local_5);
                    }
                }
            }
            this.members_.sortOn(SORT_ON_FIELDS,SORT_ON_PARAMS);
            if(this.members_.length > NUM_MEMBERS) {
                this.members_.length = NUM_MEMBERS;
            }
        }
        
        public function lockPlayer(param1:Player) : void {
            this.starred_[param1.accountId_] = 1;
            this.lastUpdate_ = int.MIN_VALUE;
            this.map_.gs_.gsc_.editAccountList(0,true,param1.objectId_);
        }
        
        public function unlockPlayer(param1:Player) : void {
            delete this.starred_[param1.accountId_];
            param1.starred_ = false;
            this.lastUpdate_ = int.MIN_VALUE;
            this.map_.gs_.gsc_.editAccountList(0,false,param1.objectId_);
        }
        
        public function setStars(param1:AccountList) : void {
            var _local_3:String = null;
            var _local_2:int = 0;
            while(_local_2 < param1.accountIds_.length) {
                _local_3 = param1.accountIds_[_local_2];
                this.starred_[_local_3] = 1;
                this.lastUpdate_ = int.MIN_VALUE;
                _local_2++;
            }
        }
        
        public function removeStars(param1:AccountList) : void {
            var _local_3:String = null;
            var _local_2:int = 0;
            while(_local_2 < param1.accountIds_.length) {
                _local_3 = param1.accountIds_[_local_2];
                delete this.starred_[_local_3];
                this.lastUpdate_ = int.MIN_VALUE;
                _local_2++;
            }
        }
        
        public function ignorePlayer(param1:Player) : void {
            this.ignored_[param1.accountId_] = 1;
            this.lastUpdate_ = int.MIN_VALUE;
            this.map_.gs_.gsc_.editAccountList(1,true,param1.objectId_);
        }
        
        public function unignorePlayer(param1:Player) : void {
            delete this.ignored_[param1.accountId_];
            param1.ignored_ = false;
            this.lastUpdate_ = int.MIN_VALUE;
            this.map_.gs_.gsc_.editAccountList(1,false,param1.objectId_);
        }
        
        public function setIgnores(param1:AccountList) : void {
            var _local_3:String = null;
            this.ignored_ = new Dictionary(true);
            var _local_2:int = 0;
            while(_local_2 < param1.accountIds_.length) {
                _local_3 = param1.accountIds_[_local_2];
                this.ignored_[_local_3] = 1;
                this.lastUpdate_ = int.MIN_VALUE;
                _local_2++;
            }
        }
    }
}
