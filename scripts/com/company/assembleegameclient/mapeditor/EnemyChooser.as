package com.company.assembleegameclient.mapeditor {
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import com.company.util.MoreStringUtil;
    import flash.utils.Dictionary;
    
    class EnemyChooser extends Chooser {
         
        
        private var cache:Dictionary;
        
        private var lastSearch:String = "";
        
        private var filterTypes:Dictionary;
        
        function EnemyChooser(param1:String = "") {
            this.filterTypes = new Dictionary(true);
            super(Layer.OBJECT);
            this.cache = new Dictionary();
            this.reloadObjects(param1,"",0,-1,true);
            this.filterTypes[ObjectLibrary.ENEMY_FILTER_LIST[0]] = "";
            this.filterTypes[ObjectLibrary.ENEMY_FILTER_LIST[1]] = "MaxHitPoints";
            this.filterTypes[ObjectLibrary.ENEMY_FILTER_LIST[2]] = ObjectLibrary.ENEMY_FILTER_LIST[2];
        }
        
        public function getLastSearch() : String {
            return this.lastSearch;
        }
        
        public function reloadObjects(param1:String, param2:String = "", param3:Number = 0, param4:Number = -1, param5:Boolean = false) : void {
            var _local_8:XML = null;
            var _local_11:RegExp = null;
            var _local_13:String = null;
            var _local_14:int = 0;
            var _local_15:ObjectElement = null;
            if(!param5) {
                removeElements();
            }
            this.lastSearch = param1;
            var _local_6:Boolean = true;
            var _local_7:Boolean = true;
            var _local_9:Number = -1;
            var _local_10:Vector.<String> = new Vector.<String>();
            if(param1 != "") {
                _local_11 = new RegExp(param1,"gix");
            }
            if(param2 != "") {
                param2 = this.filterTypes[param2];
            }
            var _local_12:Dictionary = GroupDivider.GROUPS["Enemies"];
            for each(_local_8 in _local_12) {
                _local_13 = String(_local_8.@id);
                if(!(_local_11 != null && _local_13.search(_local_11) < 0)) {
                    if(param2 != "") {
                        _local_9 = !!_local_8.hasOwnProperty(param2)?Number(Number(_local_8.elements(param2))):Number(-1);
                        if(_local_9 < 0) {
                            continue;
                        }
                        _local_6 = _local_9 < param3?false:true;
                        _local_7 = param4 > 0 && _local_9 > param4?false:true;
                    }
                    if(_local_6 && _local_7) {
                        _local_10.push(_local_13);
                    }
                }
            }
            _local_10.sort(MoreStringUtil.cmp);
            for each(_local_13 in _local_10) {
                _local_14 = ObjectLibrary.idToType_[_local_13];
                if(!this.cache[_local_14]) {
                    _local_15 = new ObjectElement(ObjectLibrary.xmlLibrary_[_local_14]);
                    this.cache[_local_14] = _local_15;
                } else {
                    _local_15 = this.cache[_local_14];
                }
                addElement(_local_15);
            }
            scrollBar_.setIndicatorSize(HEIGHT,elementSprite_.height,true);
        }
    }
}
