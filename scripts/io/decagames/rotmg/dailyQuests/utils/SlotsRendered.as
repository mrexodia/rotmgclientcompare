package io.decagames.rotmg.dailyQuests.utils {
    import flash.display.Sprite;
    import io.decagames.rotmg.dailyQuests.data.DailyQuestItemSlotType;
    import io.decagames.rotmg.dailyQuests.view.slot.DailyQuestItemSlot;
    
    public class SlotsRendered {
         
        
        public function SlotsRendered() {
            super();
        }
        
        public static function renderSlots(param1:Vector.<int>, param2:Vector.<int>, param3:String, param4:Sprite, param5:int, param6:int, param7:int, param8:Vector.<DailyQuestItemSlot>) : void {
            var _local_17:Sprite = null;
            var _local_18:int = 0;
            var _local_19:int = 0;
            var _local_20:int = 0;
            var _local_21:int = 0;
            var _local_22:DailyQuestItemSlot = null;
            var _local_9:int = 0;
            var _local_10:int = 4;
            var _local_11:int = 0;
            var _local_12:int = 0;
            var _local_13:int = 0;
            var _local_14:Boolean = false;
            var _local_15:Sprite = new Sprite();
            var _local_16:Sprite = new Sprite();
            _local_17 = _local_15;
            param4.addChild(_local_15);
            param4.addChild(_local_16);
            _local_16.y = DailyQuestItemSlot.SLOT_SIZE + param6;
            for each(_local_18 in param1) {
                if(!_local_14) {
                    _local_12++;
                } else {
                    _local_13++;
                }
                _local_21 = param2.indexOf(_local_18);
                if(_local_21 >= 0) {
                    param2.splice(_local_21,1);
                }
                _local_22 = new DailyQuestItemSlot(_local_18,param3,param3 == DailyQuestItemSlotType.REWARD?false:_local_21 >= 0);
                _local_22.x = _local_9 * (DailyQuestItemSlot.SLOT_SIZE + param6);
                _local_17.addChild(_local_22);
                param8.push(_local_22);
                _local_9++;
                if(_local_9 >= _local_10) {
                    _local_17 = _local_16;
                    _local_9 = 0;
                    _local_14 = true;
                }
            }
            _local_19 = _local_12 * DailyQuestItemSlot.SLOT_SIZE + (_local_12 - 1) * param6;
            _local_20 = _local_13 * DailyQuestItemSlot.SLOT_SIZE + (_local_13 - 1) * param6;
            param4.y = param5;
            if(!_local_14) {
                param4.y = param4.y + Math.round(DailyQuestItemSlot.SLOT_SIZE / 2 + param6 / 2);
            }
            _local_15.x = Math.round((param7 - _local_19) / 2);
            _local_16.x = Math.round((param7 - _local_20) / 2);
        }
    }
}
