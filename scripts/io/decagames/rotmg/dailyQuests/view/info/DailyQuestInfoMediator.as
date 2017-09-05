package io.decagames.rotmg.dailyQuests.view.info {
    import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.InventoryTile;
    import flash.events.MouseEvent;
    import io.decagames.rotmg.dailyQuests.model.DailyQuest;
    import io.decagames.rotmg.dailyQuests.model.DailyQuestsModel;
    import io.decagames.rotmg.dailyQuests.signal.LockQuestScreenSignal;
    import io.decagames.rotmg.dailyQuests.signal.QuestRedeemCompleteSignal;
    import io.decagames.rotmg.dailyQuests.signal.ShowQuestInfoSignal;
    import kabam.rotmg.game.view.components.BackpackTabContent;
    import kabam.rotmg.game.view.components.InventoryTabContent;
    import kabam.rotmg.messaging.impl.data.SlotObjectData;
    import kabam.rotmg.ui.model.HUDModel;
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    public class DailyQuestInfoMediator extends Mediator {
         
        
        [Inject]
        public var showInfoSignal:ShowQuestInfoSignal;
        
        [Inject]
        public var view:DailyQuestInfo;
        
        [Inject]
        public var model:DailyQuestsModel;
        
        [Inject]
        public var hud:HUDModel;
        
        [Inject]
        public var redeemCompleteSignal:QuestRedeemCompleteSignal;
        
        [Inject]
        public var lockScreen:LockQuestScreenSignal;
        
        public function DailyQuestInfoMediator() {
            super();
        }
        
        override public function initialize() : void {
            this.showInfoSignal.add(this.showQuestInfo);
            var _local_1:DailyQuest = this.model.first;
            if(_local_1) {
                this.showQuestInfo(_local_1.id);
            }
            this.view.completeButton.addEventListener(MouseEvent.CLICK,this.onCompleteButtonClickHandler);
        }
        
        override public function destroy() : void {
            this.view.completeButton.removeEventListener(MouseEvent.CLICK,this.onCompleteButtonClickHandler);
            this.showInfoSignal.remove(this.showQuestInfo);
        }
        
        private function showQuestInfo(param1:String) : void {
            this.view.clear();
            this.model.currentQuest = this.model.getQuestById(param1);
            this.view.show(this.model.currentQuest,this.model.playerItemsFromInventory);
        }
        
        private function tileToSlot(param1:InventoryTile) : SlotObjectData {
            var _local_2:SlotObjectData = null;
            _local_2 = new SlotObjectData();
            _local_2.objectId_ = param1.ownerGrid.owner.objectId_;
            _local_2.objectType_ = param1.getItemId();
            _local_2.slotId_ = param1.tileId;
            return _local_2;
        }
        
        private function onCompleteButtonClickHandler(param1:MouseEvent) : void {
            var _local_2:Vector.<SlotObjectData> = null;
            var _local_3:BackpackTabContent = null;
            var _local_4:InventoryTabContent = null;
            var _local_5:Vector.<int> = null;
            var _local_6:Vector.<InventoryTile> = null;
            var _local_7:int = 0;
            var _local_8:InventoryTile = null;
            if(this.view.completeButton.enabled && !this.view.completeButton.completed) {
                _local_2 = new Vector.<SlotObjectData>();
                _local_3 = this.hud.gameSprite.hudView.tabStrip.getTabView(BackpackTabContent);
                _local_4 = this.hud.gameSprite.hudView.tabStrip.getTabView(InventoryTabContent);
                _local_5 = this.model.currentQuest.requirements.concat();
                _local_6 = new Vector.<InventoryTile>();
                if(_local_3) {
                    _local_6 = _local_6.concat(_local_3.backpack.tiles);
                }
                if(_local_4) {
                    _local_6 = _local_6.concat(_local_4.storage.tiles);
                }
                for each(_local_7 in _local_5) {
                    for each(_local_8 in _local_6) {
                        if(_local_8.getItemId() == _local_7) {
                            _local_6.splice(_local_6.indexOf(_local_8),1);
                            _local_2.push(this.tileToSlot(_local_8));
                            break;
                        }
                    }
                }
                this.lockScreen.dispatch();
                this.hud.gameSprite.gsc_.questRedeem(this.model.currentQuest.id,_local_2);
            }
        }
    }
}
