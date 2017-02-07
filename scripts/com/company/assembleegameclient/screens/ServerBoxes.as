package com.company.assembleegameclient.screens {
    import com.company.assembleegameclient.parameters.Parameters;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import kabam.rotmg.servers.api.Server;
    
    public class ServerBoxes extends Sprite {
         
        
        private var boxes_:Vector.<ServerBox>;
        
        public function ServerBoxes(param1:Vector.<Server>) {
            var _local_2:ServerBox = null;
            var _local_3:int = 0;
            var _local_4:Server = null;
            this.boxes_ = new Vector.<ServerBox>();
            super();
            _local_2 = new ServerBox(null);
            _local_2.setSelected(true);
            _local_2.x = ServerBox.WIDTH / 2 + 2;
            _local_2.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            addChild(_local_2);
            this.boxes_.push(_local_2);
            _local_3 = 2;
            for each(_local_4 in param1) {
                _local_2 = new ServerBox(_local_4);
                if(_local_4.name == Parameters.data_.preferredServer) {
                    this.setSelected(_local_2);
                }
                _local_2.x = _local_3 % 2 * (ServerBox.WIDTH + 4);
                _local_2.y = int(_local_3 / 2) * (ServerBox.HEIGHT + 4);
                _local_2.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
                addChild(_local_2);
                this.boxes_.push(_local_2);
                _local_3++;
            }
        }
        
        private function onMouseDown(param1:MouseEvent) : void {
            var _local_2:ServerBox = param1.currentTarget as ServerBox;
            if(_local_2 == null) {
                return;
            }
            this.setSelected(_local_2);
            Parameters.data_.preferredServer = _local_2.value_;
            Parameters.save();
        }
        
        private function setSelected(param1:ServerBox) : void {
            var _local_2:ServerBox = null;
            for each(_local_2 in this.boxes_) {
                _local_2.setSelected(false);
            }
            param1.setSelected(true);
        }
    }
}
