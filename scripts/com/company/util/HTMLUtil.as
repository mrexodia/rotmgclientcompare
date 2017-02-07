package com.company.util {
    import flash.external.ExternalInterface;
    import flash.xml.XMLDocument;
    import flash.xml.XMLNode;
    import flash.xml.XMLNodeType;
    
    public class HTMLUtil {
         
        
        public function HTMLUtil() {
            super();
        }
        
        public static function unescape(param1:String) : String {
            return new XMLDocument(param1).firstChild.nodeValue;
        }
        
        public static function escape(param1:String) : String {
            return XML(new XMLNode(XMLNodeType.TEXT_NODE,param1)).toXMLString();
        }
        
        public static function refreshPageNoParams() : void {
            var _local_1:String = null;
            var _local_2:Array = null;
            var _local_3:String = null;
            if(ExternalInterface.available) {
                _local_1 = ExternalInterface.call("window.location.toString");
                _local_2 = _local_1.split("?");
                if(_local_2.length > 0) {
                    _local_3 = _local_2[0];
                    if(_local_3.indexOf("www.kabam") != -1) {
                        _local_3 = "http://www.realmofthemadgod.com";
                    }
                    ExternalInterface.call("window.location.assign",_local_3);
                }
            }
        }
    }
}
