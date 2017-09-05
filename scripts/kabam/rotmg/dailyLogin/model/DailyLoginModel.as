package kabam.rotmg.dailyLogin.model {
    public class DailyLoginModel {
        
        public static const DAY_IN_MILLISECONDS:Number = 24 * 60 * 60 * 1000;
         
        
        public var shouldDisplayCalendarAtStartup:Boolean;
        
        public var currentDisplayedCaledar:String;
        
        private var serverTimestamp:Number;
        
        private var serverMeasureTime:Number;
        
        private var daysConfig:Object;
        
        private var userDayConfig:Object;
        
        private var currentDayConfig:Object;
        
        private var maxDayConfig:Object;
        
        private var _initialized:Boolean;
        
        private var _currentDay:int = -1;
        
        private var sortAsc:Function;
        
        public function DailyLoginModel() {
            this.daysConfig = {};
            this.userDayConfig = {};
            this.currentDayConfig = {};
            this.maxDayConfig = {};
            this.sortAsc = function(param1:CalendarDayModel, param2:CalendarDayModel):Number {
                if(param1.dayNumber < param2.dayNumber) {
                    return -1;
                }
                if(param1.dayNumber > param2.dayNumber) {
                    return 1;
                }
                return 0;
            };
            super();
            this.clear();
        }
        
        public function setServerTime(param1:Number) : void {
            this.serverTimestamp = param1;
            this.serverMeasureTime = new Date().getTime();
        }
        
        public function hasCalendar(param1:String) : Boolean {
            return this.daysConfig[param1].length > 0;
        }
        
        public function getServerUTCTime() : Date {
            var _local_1:Date = new Date();
            _local_1.setUTCMilliseconds(this.serverTimestamp);
            return _local_1;
        }
        
        public function getServerTime() : Date {
            var _local_1:Date = new Date();
            _local_1.setTime(this.serverTimestamp + (_local_1.getTime() - this.serverMeasureTime));
            return _local_1;
        }
        
        public function getTimestampDay() : int {
            return Math.floor(this.getServerTime().getTime() / DailyLoginModel.DAY_IN_MILLISECONDS);
        }
        
        private function getDayCount(param1:int, param2:int) : int {
            var _local_3:Date = new Date(param1,param2,0);
            return _local_3.getDate();
        }
        
        public function get daysLeftToCalendarEnd() : int {
            var _local_1:Date = this.getServerTime();
            var _local_2:int = _local_1.getDate();
            var _local_3:int = this.getDayCount(_local_1.fullYear,_local_1.month + 1);
            return _local_3 - _local_2;
        }
        
        public function addDay(param1:CalendarDayModel, param2:String) : void {
            this._initialized = true;
            this.daysConfig[param2].push(param1);
        }
        
        public function setUserDay(param1:int, param2:String) : void {
            this.userDayConfig[param2] = param1;
        }
        
        public function calculateCalendar(param1:String) : void {
            var _local_6:CalendarDayModel = null;
            var _local_2:Vector.<CalendarDayModel> = this.sortCalendar(this.daysConfig[param1]);
            var _local_3:int = _local_2.length;
            this.daysConfig[param1] = _local_2;
            this.maxDayConfig[param1] = _local_2[_local_3 - 1].dayNumber;
            var _local_4:Vector.<CalendarDayModel> = new Vector.<CalendarDayModel>();
            var _local_5:int = 1;
            while(_local_5 <= this.maxDayConfig[param1]) {
                _local_6 = this.getDayByNumber(param1,_local_5);
                if(_local_5 == this.userDayConfig[param1]) {
                    _local_6.isCurrent = true;
                }
                _local_4.push(_local_6);
                _local_5++;
            }
            this.daysConfig[param1] = _local_4;
        }
        
        private function getDayByNumber(param1:String, param2:int) : CalendarDayModel {
            var _local_3:CalendarDayModel = null;
            for each(_local_3 in this.daysConfig[param1]) {
                if(_local_3.dayNumber == param2) {
                    return _local_3;
                }
            }
            return new CalendarDayModel(param2,-1,0,0,false,param1);
        }
        
        public function getDaysConfig(param1:String) : Vector.<CalendarDayModel> {
            return this.daysConfig[param1];
        }
        
        public function getMaxDays(param1:String) : int {
            return this.maxDayConfig[param1];
        }
        
        public function get overallMaxDays() : int {
            var _local_2:int = 0;
            var _local_1:int = 0;
            for each(_local_2 in this.maxDayConfig) {
                if(_local_2 > _local_1) {
                    _local_1 = _local_2;
                }
            }
            return _local_1;
        }
        
        public function markAsClaimed(param1:int, param2:String) : void {
            this.daysConfig[param2][param1 - 1].isClaimed = true;
        }
        
        private function sortCalendar(param1:Vector.<CalendarDayModel>) : Vector.<CalendarDayModel> {
            return param1.sort(this.sortAsc);
        }
        
        public function get initialized() : Boolean {
            return this._initialized;
        }
        
        public function clear() : void {
            this.daysConfig[CalendarTypes.CONSECUTIVE] = new Vector.<CalendarDayModel>();
            this.daysConfig[CalendarTypes.NON_CONSECUTIVE] = new Vector.<CalendarDayModel>();
            this.daysConfig[CalendarTypes.UNLOCK] = new Vector.<CalendarDayModel>();
            this.shouldDisplayCalendarAtStartup = false;
        }
        
        public function getCurrentDay(param1:String) : int {
            return this.currentDayConfig[param1];
        }
        
        public function setCurrentDay(param1:String, param2:int) : void {
            this.currentDayConfig[param1] = param2;
        }
    }
}
