package com.company.assembleegameclient.ui.panels.itemgrids {
    import com.company.assembleegameclient.objects.GameObject;
    import com.company.assembleegameclient.objects.Player;
    import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.EquipmentTile;
    import com.company.util.ArrayIterator;
    import com.company.util.IIterator;
    import kabam.lib.util.VectorAS3Util;
    
    public class EquippedGrid extends ItemGrid {
        
        public static const NUM_SLOTS:uint = 4;
         
        
        private var tiles:Vector.<EquipmentTile>;
        
        public function EquippedGrid(param1:GameObject, param2:Vector.<int>, param3:Player, param4:int = 0) {
            var _local_6:EquipmentTile = null;
            super(param1,param3,param4);
            this.tiles = new Vector.<EquipmentTile>(NUM_SLOTS);
            var _local_5:int = 0;
            while(_local_5 < NUM_SLOTS) {
                _local_6 = new EquipmentTile(_local_5,this,interactive);
                addToGrid(_local_6,1,_local_5);
                _local_6.setType(param2[_local_5]);
                this.tiles[_local_5] = _local_6;
                _local_5++;
            }
        }
        
        public function createInteractiveItemTileIterator() : IIterator {
            return new ArrayIterator(VectorAS3Util.toArray(this.tiles));
        }
        
        override public function setItems(param1:Vector.<int>, param2:int = 0) : void {
            var _local_3:int = 0;
            var _local_4:int = 0;
            if(param1) {
                _local_3 = param1.length;
                _local_4 = 0;
                while(_local_4 < this.tiles.length) {
                    if(_local_4 + param2 < _local_3) {
                        this.tiles[_local_4].setItem(param1[_local_4 + param2]);
                    } else {
                        this.tiles[_local_4].setItem(-1);
                    }
                    this.tiles[_local_4].updateDim(curPlayer);
                    _local_4++;
                }
            }
        }
    }
}
