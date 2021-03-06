package com.company.assembleegameclient.util {
    public class Currency {
        
        public static const INVALID:int = -1;
        
        public static const GOLD:int = 0;
        
        public static const FAME:int = 1;
        
        public static const GUILD_FAME:int = 2;
        
        public static const FORTUNE:int = 3;
         
        
        public function Currency() {
            super();
        }
        
        public static function typeToName(param1:int) : String {
            switch(param1) {
                case GOLD:
                    return "Gold";
                case FAME:
                    return "Fame";
                case GUILD_FAME:
                    return "Guild Fame";
                case FORTUNE:
                    return "Fortune Token";
                default:
                    return "";
            }
        }
    }
}
