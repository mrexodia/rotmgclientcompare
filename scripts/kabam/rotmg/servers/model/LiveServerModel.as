package kabam.rotmg.servers.model {
    import com.company.assembleegameclient.parameters.Parameters;
    import kabam.rotmg.core.model.PlayerModel;
    import kabam.rotmg.servers.api.LatLong;
    import kabam.rotmg.servers.api.Server;
    import kabam.rotmg.servers.api.ServerModel;
    
    public class LiveServerModel implements ServerModel {
         
        
        [Inject]
        public var model:PlayerModel;
        
        private var _descendingFlag:Boolean;
        
        private const servers:Vector.<Server> = new Vector.<Server>(0);
        
        public function LiveServerModel() {
            super();
        }
        
        public function setServers(param1:Vector.<Server>) : void {
            var _local_2:Server = null;
            this.servers.length = 0;
            for each(_local_2 in param1) {
                this.servers.push(_local_2);
            }
            this._descendingFlag = false;
            this.servers.sort(this.compareServerName);
        }
        
        public function getServers() : Vector.<Server> {
            return this.servers;
        }
        
        public function getServer() : Server {
            var _local_6:Server = null;
            var _local_7:int = 0;
            var _local_8:Number = NaN;
            var _local_1:Boolean = this.model.isAdmin();
            var _local_2:LatLong = this.model.getMyPos();
            var _local_3:Server = null;
            var _local_4:Number = Number.MAX_VALUE;
            var _local_5:int = int.MAX_VALUE;
            for each(_local_6 in this.servers) {
                if(!(_local_6.isFull() && !_local_1)) {
                    if(_local_6.name == Parameters.data_.preferredServer) {
                        return _local_6;
                    }
                    _local_7 = _local_6.priority();
                    _local_8 = LatLong.distance(_local_2,_local_6.latLong);
                    if(_local_7 < _local_5 || _local_7 == _local_5 && _local_8 < _local_4) {
                        _local_3 = _local_6;
                        _local_4 = _local_8;
                        _local_5 = _local_7;
                    }
                }
            }
            return _local_3;
        }
        
        public function getServerNameByAddress(param1:String) : String {
            var _local_2:Server = null;
            for each(_local_2 in this.servers) {
                if(_local_2.address == param1) {
                    return _local_2.name;
                }
            }
            return "";
        }
        
        public function isServerAvailable() : Boolean {
            return this.servers.length > 0;
        }
        
        private function compareServerName(param1:Server, param2:Server) : int {
            if(param1.name < param2.name) {
                return !!this._descendingFlag?-1:1;
            }
            if(param1.name > param2.name) {
                return !!this._descendingFlag?1:-1;
            }
            return 0;
        }
    }
}
