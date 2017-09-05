package io.decagames.rotmg.dailyQuests.view.slot {
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Shape;
    import flash.display.Sprite;
    
    public class DailyQuestItemSlot extends Sprite {
        
        public static const SLOT_SIZE:int = 40;
         
        
        private var _itemID:int;
        
        private var _type:String;
        
        private var imageContainer:Sprite;
        
        public function DailyQuestItemSlot(param1:int, param2:String, param3:Boolean = false) {
            super();
            this._itemID = param1;
            this._type = param2;
            this.imageContainer = new Sprite();
            addChild(this.imageContainer);
            this.imageContainer.x = Math.round(SLOT_SIZE / 2);
            this.imageContainer.y = Math.round(SLOT_SIZE / 2);
            this.createBackground(param3);
            this.addItem();
        }
        
        private function createBackground(param1:Boolean = false) : void {
            var _local_2:Shape = new Shape();
            _local_2.graphics.beginFill(!!param1?uint(1286144):uint(4539717),1);
            _local_2.graphics.drawRect(0,0,SLOT_SIZE,SLOT_SIZE);
            _local_2.x = -Math.round(SLOT_SIZE / 2);
            _local_2.y = -Math.round(SLOT_SIZE / 2);
            this.imageContainer.addChild(_local_2);
        }
        
        private function addItem() : void {
            var _local_2:Bitmap = null;
            var _local_1:BitmapData = ObjectLibrary.getRedrawnTextureFromType(this._itemID,SLOT_SIZE * 2,true,false);
            _local_2 = new Bitmap(_local_1);
            _local_2.x = -Math.round(_local_2.width / 2);
            _local_2.y = -Math.round(_local_2.height / 2);
            this.imageContainer.addChild(_local_2);
        }
        
        public function get itemID() : int {
            return this._itemID;
        }
        
        public function get type() : String {
            return this._type;
        }
    }
}
