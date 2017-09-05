package kabam.rotmg.arena.component {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import kabam.rotmg.arena.view.HostQueryDialog;
    
    public class ArenaQueryDialogHost extends Sprite {
         
        
        private const speechBubble:HostQuerySpeechBubble = this.makeSpeechBubble();
        
        private const detailBubble:HostQueryDetailBubble = this.makeDetailBubble();
        
        private const icon:Bitmap = this.makeHostIcon();
        
        public function ArenaQueryDialogHost() {
            super();
        }
        
        private function makeSpeechBubble() : HostQuerySpeechBubble {
            var _local_1:HostQuerySpeechBubble = null;
            _local_1 = new HostQuerySpeechBubble(HostQueryDialog.QUERY);
            _local_1.x = 60;
            addChild(_local_1);
            return _local_1;
        }
        
        private function makeDetailBubble() : HostQueryDetailBubble {
            var _local_1:HostQueryDetailBubble = null;
            _local_1 = new HostQueryDetailBubble();
            _local_1.y = 60;
            return _local_1;
        }
        
        private function makeHostIcon() : Bitmap {
            var _local_1:Bitmap = null;
            _local_1 = new Bitmap(this.makeDebugBitmapData());
            _local_1.x = 0;
            _local_1.y = 0;
            addChild(_local_1);
            return _local_1;
        }
        
        private function makeDebugBitmapData() : BitmapData {
            return new BitmapData(42,42,true,4278255360);
        }
        
        public function showDetail(param1:String) : void {
            this.detailBubble.setText(param1);
            removeChild(this.speechBubble);
            addChild(this.detailBubble);
        }
        
        public function showSpeech() : void {
            removeChild(this.detailBubble);
            addChild(this.speechBubble);
        }
        
        public function setHostIcon(param1:BitmapData) : void {
            this.icon.bitmapData = param1;
        }
    }
}
