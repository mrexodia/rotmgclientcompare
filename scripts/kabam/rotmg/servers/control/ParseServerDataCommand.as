package kabam.rotmg.servers.control {
    import com.company.assembleegameclient.parameters.Parameters;
    import kabam.rotmg.servers.api.Server;
    import kabam.rotmg.servers.api.ServerModel;
    
    public class ParseServerDataCommand {
         
        
        [Inject]
        public var servers:ServerModel;
        
        [Inject]
        public var data:XML;
        
        public function ParseServerDataCommand() {
            super();
        }
        
        public function execute() : void {
            this.servers.setServers(this.makeListOfServers());
        }
        
        private function makeListOfServers() : Vector.<Server> {
            var _local_3:XML = null;
            var _local_1:XMLList = this.data.child("Servers").child("Server");
            var _local_2:Vector.<Server> = new Vector.<Server>(0);
            for each(_local_3 in _local_1) {
                _local_2.push(this.makeServer(_local_3));
            }
            return _local_2;
        }
        
        private function makeServer(param1:XML) : Server {
            return new Server().setName(param1.Name).setAddress(param1.DNS).setPort(Parameters.PORT).setLatLong(Number(param1.Lat),Number(param1.Long)).setUsage(param1.Usage).setIsAdminOnly(param1.hasOwnProperty("AdminOnly"));
        }
    }
}
