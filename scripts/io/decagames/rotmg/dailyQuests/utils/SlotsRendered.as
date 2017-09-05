package io.decagames.rotmg.dailyQuests.utils {
    import flash.display.Sprite;
    import io.decagames.rotmg.dailyQuests.data.DailyQuestItemSlotType;
    import io.decagames.rotmg.dailyQuests.view.slot.DailyQuestItemSlot;
    
    public class SlotsRendered {
         
        
        public function SlotsRendered() {
            super();
        }
        
        public static function renderSlots(param1:Vector.<int>, param2:Vector.<int>, param3:String, param4:Sprite, param5:int, param6:int, param7:int, param8:Vector.<DailyQuestItemSlot>) : void {
            var _local_13:int = 0;
            var _local_14:int = 0;
            var _local_15:int = 0;
            var _local_16:DailyQuestItemSlot = null;
            var _local_9:int = 0;
            var _local_10:int = 4;
            var _local_11:int = 0;
            var _local_12:Boolean = false;
            for each(_local_13 in param1) {
                _local_15 = param2.indexOf(_local_13);
                if(_local_15 >= 0) {
                    param2.splice(_local_15,1);
                }
                _local_16 = new DailyQuestItemSlot(_local_13,param3,param3 == DailyQuestItemSlotType.REWARD?false:_local_15 >= 0);
                _local_16.x = _local_9 * (DailyQuestItemSlot.SLOT_SIZE + param6);
                _local_16.y = _local_11;
                param4.addChild(_local_16);
                param8.push(_local_16);
                _local_9++;
                if(_local_9 >= _local_10) {
                    _local_9 = 0;
                    _local_11 = DailyQuestItemSlot.SLOT_SIZE + param6;
                    _local_12 = true;
                }
            }
            _local_14 = (!!_local_12?_local_10:param1.length) * DailyQuestItemSlot.SLOT_SIZE + (!!_local_12?_local_10:param1.length - 1) * param6;
            param4.y = param5;
            if(!_local_12) {
                param4.y = param4.y + Math.round(DailyQuestItemSlot.SLOT_SIZE / 2 + param6 / 2);
            }
            param4.x = Math.round((param7 - _local_14) / 2);
        }
    }
}
