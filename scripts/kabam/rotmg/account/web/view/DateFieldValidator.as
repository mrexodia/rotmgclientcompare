package kabam.rotmg.account.web.view {
    import kabam.rotmg.account.ui.components.DateField;
    
    public class DateFieldValidator {
         
        
        public function DateFieldValidator() {
            super();
        }
        
        public static function getPlayerAge(param1:DateField) : uint {
            var _local_2:Date = new Date(getBirthDate(param1));
            var _local_3:Date = new Date();
            var _local_4:uint = Number(_local_3.fullYear) - Number(_local_2.fullYear);
            if(_local_2.month > _local_3.month || _local_2.month == _local_3.month && _local_2.date > _local_3.date) {
                _local_4--;
            }
            return _local_4;
        }
        
        public static function getBirthDate(param1:DateField) : Number {
            var _local_2:String = param1.months.text + "/" + param1.days.text + "/" + param1.years.text;
            return Date.parse(_local_2);
        }
    }
}
