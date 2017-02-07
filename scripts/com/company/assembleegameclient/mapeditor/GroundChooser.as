package com.company.assembleegameclient.mapeditor {
    import com.company.assembleegameclient.map.GroundLibrary;
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import com.company.util.MoreStringUtil;
    import flash.utils.Dictionary;
    
    class GroundChooser extends Chooser {
         
        
        private var cache:Dictionary;
        
        private var lastSearch:String = "";
        
        function GroundChooser(param1:String = "") {
            super(Layer.GROUND);
            this.cache = new Dictionary();
            this.reloadObjects(param1,"",true);
        }
        
        public function getLastSearch() : String {
            return this.lastSearch;
        }
        
        public function reloadObjects(param1:String, param2:String = "ALL", param3:Boolean = false) : void {
            var _local_5:RegExp = null;
            var _local_7:String = null;
            var _local_8:XML = null;
            var _local_9:int = 0;
            var _local_10:GroundElement = null;
            if(!param3) {
                removeElements();
            }
            this.lastSearch = param1;
            var _local_4:Vector.<String> = new Vector.<String>();
            if(param1 != "") {
                _local_5 = new RegExp(param1,"gix");
            }
            var _local_6:Dictionary = GroupDivider.GROUPS["Ground"];
            for each(_local_8 in _local_6) {
                _local_7 = String(_local_8.@id);
                if(!(param2 != "ALL" && !this.runFilter(_local_8,param2))) {
                    if(_local_5 == null || _local_7.search(_local_5) >= 0) {
                        _local_4.push(_local_7);
                    }
                }
            }
            _local_4.sort(MoreStringUtil.cmp);
            for each(_local_7 in _local_4) {
                _local_9 = GroundLibrary.idToType_[_local_7];
                _local_8 = GroundLibrary.xmlLibrary_[_local_9];
                if(!this.cache[_local_9]) {
                    _local_10 = new GroundElement(_local_8);
                    this.cache[_local_9] = _local_10;
                } else {
                    _local_10 = this.cache[_local_9];
                }
                addElement(_local_10);
            }
            scrollBar_.setIndicatorSize(HEIGHT,elementSprite_.height,true);
        }
        
        private function runFilter(param1:XML, param2:String) : Boolean {
            var _local_3:int = 0;
            switch(param2) {
                case ObjectLibrary.TILE_FILTER_LIST[1]:
                    return !param1.hasOwnProperty("NoWalk");
                case ObjectLibrary.TILE_FILTER_LIST[2]:
                    return param1.hasOwnProperty("NoWalk");
                case ObjectLibrary.TILE_FILTER_LIST[3]:
                    return param1.hasOwnProperty("Speed") && Number(param1.elements("Speed")) < 1;
                case ObjectLibrary.TILE_FILTER_LIST[4]:
                    return !param1.hasOwnProperty("Speed") || Number(param1.elements("Speed")) >= 1;
                default:
                    return true;
            }
        }
    }
}
