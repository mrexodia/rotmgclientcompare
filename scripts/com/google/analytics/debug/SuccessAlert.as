package com.google.analytics.debug {
    public class SuccessAlert extends Alert {
         
        
        public function SuccessAlert(param1:DebugConfiguration, param2:String, param3:Array) {
            var _local_4:Align = Align.bottomLeft;
            var _local_5:Boolean = true;
            var _local_6:Boolean = false;
            if(param1.verbose) {
                param2 = "<u><span class=\"uiAlertTitle\">Success</span>" + spaces(18) + "</u>\n\n" + param2;
                _local_4 = Align.center;
                _local_5 = false;
                _local_6 = true;
            }
            super(param2,param3,"uiSuccess",Style.successColor,_local_4,_local_5,_local_6);
        }
    }
}
