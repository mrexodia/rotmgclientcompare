package com.company.assembleegameclient.map.mapoverlay {
    import com.company.assembleegameclient.map.Camera;
    import flash.display.Sprite;
    import kabam.rotmg.game.view.components.QueuedStatusText;
    import kabam.rotmg.game.view.components.QueuedStatusTextList;
    
    public class MapOverlay extends Sprite {
         
        
        private const speechBalloons:Object = {};
        
        private const queuedText:Object = {};
        
        public function MapOverlay() {
            super();
            mouseEnabled = true;
            mouseChildren = true;
        }
        
        public function addSpeechBalloon(param1:SpeechBalloon) : void {
            var _local_2:int = param1.go_.objectId_;
            var _local_3:SpeechBalloon = this.speechBalloons[_local_2];
            if(_local_3 && contains(_local_3)) {
                removeChild(_local_3);
            }
            this.speechBalloons[_local_2] = param1;
            addChild(param1);
        }
        
        public function addStatusText(param1:CharacterStatusText) : void {
            addChild(param1);
        }
        
        public function addQueuedText(param1:QueuedStatusText) : void {
            var _local_2:int = param1.go_.objectId_;
            var _local_3:QueuedStatusTextList = this.queuedText[_local_2] = this.queuedText[_local_2] || this.makeQueuedStatusTextList();
            _local_3.append(param1);
        }
        
        private function makeQueuedStatusTextList() : QueuedStatusTextList {
            var _local_1:QueuedStatusTextList = new QueuedStatusTextList();
            _local_1.target = this;
            return _local_1;
        }
        
        public function draw(param1:Camera, param2:int) : void {
            var _local_4:IMapOverlayElement = null;
            var _local_3:int = 0;
            while(_local_3 < numChildren) {
                _local_4 = getChildAt(_local_3) as IMapOverlayElement;
                if(!_local_4 || _local_4.draw(param1,param2)) {
                    _local_3++;
                } else {
                    _local_4.dispose();
                }
            }
        }
    }
}
