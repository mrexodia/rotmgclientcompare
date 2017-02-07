package kabam.rotmg.arena.view {
    import flash.display.Sprite;
    import flash.events.TimerEvent;
    import flash.filters.DropShadowFilter;
    import flash.utils.Timer;
    import kabam.rotmg.text.view.StaticTextDisplay;
    import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
    
    public class ArenaTimer extends Sprite {
         
        
        private const timerText:StaticTextDisplay = this.makeTimerText();
        
        private const timerStringBuilder:StaticStringBuilder = new StaticStringBuilder();
        
        private var secs:Number = 0;
        
        private const timer:Timer = new Timer(1000);
        
        public function ArenaTimer() {
            super();
        }
        
        public function start() : void {
            this.updateTimer(null);
            this.timer.addEventListener(TimerEvent.TIMER,this.updateTimer);
            this.timer.start();
        }
        
        public function stop() : void {
            this.timer.removeEventListener(TimerEvent.TIMER,this.updateTimer);
            this.timer.stop();
        }
        
        private function updateTimer(param1:TimerEvent) : void {
            var _local_2:int = this.secs / 60;
            var _local_3:int = this.secs % 60;
            var _local_4:String = _local_2 < 10?"0":"";
            _local_4 = _local_4 + (_local_2 + ":");
            _local_4 = _local_4 + (_local_3 < 10?"0":"");
            _local_4 = _local_4 + _local_3;
            this.timerText.setStringBuilder(this.timerStringBuilder.setString(_local_4));
            this.secs++;
        }
        
        private function makeTimerText() : StaticTextDisplay {
            var _local_1:StaticTextDisplay = new StaticTextDisplay();
            _local_1.setSize(24).setBold(true).setColor(16777215);
            _local_1.filters = [new DropShadowFilter(0,0,0,1,8,8)];
            addChild(_local_1);
            return _local_1;
        }
    }
}
