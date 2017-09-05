package com.company.assembleegameclient.mapeditor {
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import com.company.util.MoreStringUtil;
    import flash.utils.Dictionary;
    
    class AllObjectChooser extends Chooser {
         
        
        private var cache:Dictionary;
        
        private var lastSearch:String = "";
        
        function AllObjectChooser(param1:String = "", param2:String = "All Map Objects") {
            super(Layer.OBJECT);
            this.cache = new Dictionary();
            this.reloadObjects(param1,true,param2);
        }
        
        public function getLastSearch() : String {
            return this.lastSearch;
        }
        
        public function reloadObjects(param1:String = "", param2:Boolean = false, param3:String = "All Map Objects") : void {
            var _local_5:RegExp = null;
            var _local_7:String = null;
            var _local_8:int = 0;
            var _local_9:XML = null;
            var _local_10:int = 0;
            var _local_11:ObjectElement = null;
            if(!param2) {
                removeElements();
            }
            this.lastSearch = param1;
            var _local_4:Vector.<String> = new Vector.<String>();
            if(param1 != "") {
                _local_5 = new RegExp(param1,"gix");
            }
            var _local_6:Dictionary = GroupDivider.GROUPS[param3];
            for each(_local_9 in _local_6) {
                _local_7 = String(_local_9.@id);
                _local_8 = int(_local_9.@type);
                if(_local_5 == null || _local_7.search(_local_5) >= 0 || _local_8 == int(param1)) {
                    _local_4.push(_local_7);
                }
            }
            _local_4.sort(MoreStringUtil.cmp);
            for each(_local_7 in _local_4) {
                _local_10 = ObjectLibrary.idToType_[_local_7];
                _local_9 = ObjectLibrary.xmlLibrary_[_local_10];
                if(!this.cache[_local_10]) {
                    _local_11 = new ObjectElement(_local_9);
                    if(param3 == "All Game Objects") {
                        _local_11.downloadOnly = true;
                    }
                    this.cache[_local_10] = _local_11;
                } else {
                    _local_11 = this.cache[_local_10];
                }
                addElement(_local_11);
            }
            scrollBar_.setIndicatorSize(HEIGHT,elementSprite_.height,true);
        }
    }
}
