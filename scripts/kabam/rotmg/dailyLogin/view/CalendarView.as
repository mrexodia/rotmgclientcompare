package kabam.rotmg.dailyLogin.view {
    import flash.display.Sprite;
    import kabam.rotmg.dailyLogin.config.CalendarSettings;
    import kabam.rotmg.dailyLogin.model.CalendarDayModel;
    
    public class CalendarView extends Sprite {
         
        
        public function CalendarView() {
            super();
        }
        
        public function init(param1:Vector.<CalendarDayModel>, param2:int, param3:int) : void {
            var _local_7:CalendarDayModel = null;
            var _local_8:int = 0;
            var _local_9:CalendarDayBox = null;
            var _local_4:int = 0;
            var _local_5:int = 0;
            var _local_6:int = 0;
            for each(_local_7 in param1) {
                _local_9 = new CalendarDayBox(_local_7,param2,_local_4 + 1 == param3);
                addChild(_local_9);
                _local_9.x = _local_5 * CalendarSettings.BOX_WIDTH;
                if(_local_5 > 0) {
                    _local_9.x = _local_9.x + _local_5 * CalendarSettings.BOX_MARGIN;
                }
                _local_9.y = _local_6 * CalendarSettings.BOX_HEIGHT;
                if(_local_6 > 0) {
                    _local_9.y = _local_9.y + _local_6 * CalendarSettings.BOX_MARGIN;
                }
                _local_5++;
                _local_4++;
                if(_local_4 % CalendarSettings.NUMBER_OF_COLUMNS == 0) {
                    _local_5 = 0;
                    _local_6++;
                }
            }
            _local_8 = CalendarSettings.BOX_WIDTH * CalendarSettings.NUMBER_OF_COLUMNS + (CalendarSettings.NUMBER_OF_COLUMNS - 1) * CalendarSettings.BOX_MARGIN;
            this.x = (this.parent.width - _local_8) / 2;
            this.y = CalendarSettings.DAILY_LOGIN_TABS_PADDING + CalendarSettings.TABS_HEIGHT;
        }
    }
}
