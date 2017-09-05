package com.company.assembleegameclient.ui.tooltip {
    public class TooltipHelper {
        
        public static const BETTER_COLOR:uint = 65280;
        
        public static const WORSE_COLOR:uint = 16711680;
        
        public static const NO_DIFF_COLOR:uint = 16777103;
        
        public static const WIS_BONUS_COLOR:uint = 4219875;
        
        public static const UNTIERED_COLOR:uint = 9055202;
        
        public static const SET_COLOR:uint = 16750848;
         
        
        public function TooltipHelper() {
            super();
        }
        
        public static function wrapInFontTag(param1:String, param2:String) : String {
            var _local_3:* = "<font color=\"" + param2 + "\">" + param1 + "</font>";
            return _local_3;
        }
        
        public static function getOpenTag(param1:uint) : String {
            return "<font color=\"#" + param1.toString(16) + "\">";
        }
        
        public static function getCloseTag() : String {
            return "</font>";
        }
        
        public static function getFormattedRangeString(param1:Number) : String {
            var _local_2:Number = param1 - int(param1);
            return int(_local_2 * 10) == 0?int(param1).toString():param1.toFixed(1);
        }
        
        public static function compareAndGetPlural(param1:Number, param2:Number, param3:String, param4:Boolean = true) : String {
            return wrapInFontTag(getPlural(param1,param3),"#" + getTextColor(!!param4?Number(param1 - param2):Number(param2 - param1)).toString(16));
        }
        
        public static function compare(param1:Number, param2:Number, param3:Boolean = true) : String {
            return wrapInFontTag("" + param1,"#" + getTextColor(!!param3?Number(param1 - param2):Number(param2 - param1)).toString(16));
        }
        
        public static function getPlural(param1:Number, param2:String) : * {
            var _local_3:String = param1 + " " + param2;
            if(param1 != 1) {
                return _local_3 + "s";
            }
            return _local_3;
        }
        
        public static function getTextColor(param1:Number) : uint {
            if(param1 < 0) {
                return WORSE_COLOR;
            }
            if(param1 > 0) {
                return BETTER_COLOR;
            }
            return NO_DIFF_COLOR;
        }
    }
}
