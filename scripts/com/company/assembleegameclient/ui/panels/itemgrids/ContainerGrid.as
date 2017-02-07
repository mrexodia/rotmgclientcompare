package com.company.assembleegameclient.ui.panels.itemgrids {
    import com.company.assembleegameclient.objects.GameObject;
    import com.company.assembleegameclient.objects.Player;
    import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.InteractiveItemTile;
    
    public class ContainerGrid extends ItemGrid {
         
        
        private const NUM_SLOTS:uint = 8;
        
        private var tiles:Vector.<InteractiveItemTile>;
        
        public function ContainerGrid(param1:GameObject, param2:Player) {
            var _local_4:InteractiveItemTile = null;
            super(param1,param2,0);
            this.tiles = new Vector.<InteractiveItemTile>(this.NUM_SLOTS);
            var _local_3:int = 0;
            while(_local_3 < this.NUM_SLOTS) {
                _local_4 = new InteractiveItemTile(_local_3 + indexOffset,this,interactive);
                addToGrid(_local_4,2,_local_3);
                this.tiles[_local_3] = _local_4;
                _local_3++;
            }
        }
        
        override public function setItems(param1:Vector.<int>, param2:int = 0) : void {
            var _local_3:Boolean = false;
            var _local_4:int = 0;
            var _local_5:int = 0;
            if(param1) {
                _local_3 = false;
                _local_4 = param1.length;
                _local_5 = 0;
                while(_local_5 < this.NUM_SLOTS) {
                    if(_local_5 + indexOffset < _local_4) {
                        if(this.tiles[_local_5].setItem(param1[_local_5 + indexOffset])) {
                            _local_3 = true;
                        }
                    } else if(this.tiles[_local_5].setItem(-1)) {
                        _local_3 = true;
                    }
                    _local_5++;
                }
                if(_local_3) {
                    refreshTooltip();
                }
            }
        }
    }
}
