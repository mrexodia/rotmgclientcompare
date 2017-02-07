package com.company.assembleegameclient.mapeditor {
    import com.company.assembleegameclient.map.GroundLibrary;
    import com.company.util.MoreStringUtil;
    
    class GroundChooser extends Chooser {
         
        
        function GroundChooser() {
            var _local_1:* = null;
            var _local_3:int = 0;
            var _local_4:GroundElement = null;
            super(Layer.GROUND);
            var _local_2:Vector.<String> = new Vector.<String>();
            for(_local_1 in GroundLibrary.idToType_) {
                _local_2.push(_local_1);
            }
            _local_2.sort(MoreStringUtil.cmp);
            for each(_local_1 in _local_2) {
                _local_3 = GroundLibrary.idToType_[_local_1];
                _local_4 = new GroundElement(GroundLibrary.xmlLibrary_[_local_3]);
                addElement(_local_4);
            }
        }
    }
}
