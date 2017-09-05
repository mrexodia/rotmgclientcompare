package com.company.assembleegameclient.ui.panels.itemgrids {
    import com.company.assembleegameclient.objects.GameObject;
    import com.company.assembleegameclient.objects.Player;
    import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.InventoryTile;
    
    public class InventoryGrid extends ItemGrid {
         
        
        private const NUM_SLOTS:uint = 8;
        
        private var _tiles:Vector.<InventoryTile>;
        
        private var isBackpack:Boolean;
        
        public function InventoryGrid(param1:GameObject, param2:Player, param3:int = 0, param4:Boolean = false) {
            var _local_6:InventoryTile = null;
            super(param1,param2,param3);
            this._tiles = new Vector.<InventoryTile>(this.NUM_SLOTS);
            this.isBackpack = param4;
            var _local_5:int = 0;
            while(_local_5 < this.NUM_SLOTS) {
                _local_6 = new InventoryTile(_local_5 + indexOffset,this,interactive);
                _local_6.addTileNumber(_local_5 + 1);
                addToGrid(_local_6,2,_local_5);
                this._tiles[_local_5] = _local_6;
                _local_5++;
            }
        }
        
        public function getItemById(param1:int) : InventoryTile {
            var _local_2:InventoryTile = null;
            for each(_local_2 in this._tiles) {
                if(_local_2.getItemId() == param1) {
                    return _local_2;
                }
            }
            return null;
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
                        if(this._tiles[_local_5].setItem(param1[_local_5 + indexOffset])) {
                            _local_3 = true;
                        }
                    } else if(this._tiles[_local_5].setItem(-1)) {
                        _local_3 = true;
                    }
                    _local_5++;
                }
                if(_local_3) {
                    refreshTooltip();
                }
            }
        }
        
        public function get tiles() : Vector.<InventoryTile> {
            return this._tiles.concat();
        }
    }
}
