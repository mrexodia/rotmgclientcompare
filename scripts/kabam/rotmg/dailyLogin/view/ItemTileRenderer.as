package kabam.rotmg.dailyLogin.view {
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.EquipmentTile;
    import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.ItemTile;
    import com.company.assembleegameclient.ui.tooltip.EquipmentToolTip;
    import com.company.assembleegameclient.ui.tooltip.TextToolTip;
    import com.company.assembleegameclient.ui.tooltip.ToolTip;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.filters.ColorMatrixFilter;
    import flash.geom.Matrix;
    import kabam.rotmg.constants.ItemConstants;
    import kabam.rotmg.core.StaticInjectorContext;
    import kabam.rotmg.core.signals.HideTooltipsSignal;
    import kabam.rotmg.core.signals.ShowTooltipSignal;
    import kabam.rotmg.dailyLogin.config.CalendarSettings;
    import kabam.rotmg.text.model.TextKey;
    import kabam.rotmg.text.view.BitmapTextFactory;
    import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
    import org.swiftsuspenders.Injector;
    
    public class ItemTileRenderer extends Sprite {
        
        protected static const DIM_FILTER:Array = [new ColorMatrixFilter([0.4,0,0,0,0,0,0.4,0,0,0,0,0,0.4,0,0,0,0,0,1,0])];
        
        private static const IDENTITY_MATRIX:Matrix = new Matrix();
        
        private static const DOSE_MATRIX:Matrix = function():Matrix {
            var _local_1:* = new Matrix();
            _local_1.translate(10,5);
            return _local_1;
        }();
         
        
        private var itemId:int;
        
        private var bitmapFactory:BitmapTextFactory;
        
        private var tooltip:ToolTip;
        
        private var itemBitmap:Bitmap;
        
        public function ItemTileRenderer(param1:int) {
            super();
            this.itemId = param1;
            this.itemBitmap = new Bitmap();
            addChild(this.itemBitmap);
            this.drawTile();
            this.addEventListener(MouseEvent.MOUSE_OVER,this.onTileHover);
            this.addEventListener(MouseEvent.MOUSE_OUT,this.onTileOut);
        }
        
        private function onTileOut(param1:MouseEvent) : void {
            var _local_2:Injector = StaticInjectorContext.getInjector();
            var _local_3:HideTooltipsSignal = _local_2.getInstance(HideTooltipsSignal);
            _local_3.dispatch();
        }
        
        private function onTileHover(param1:MouseEvent) : void {
            if(!stage) {
                return;
            }
            var _local_2:ItemTile = param1.currentTarget as ItemTile;
            this.addToolTipToTile(_local_2);
        }
        
        private function addToolTipToTile(param1:ItemTile) : void {
            var _local_4:String = null;
            if(this.itemId > 0) {
                this.tooltip = new EquipmentToolTip(this.itemId,null,-1,"");
            } else {
                if(param1 is EquipmentTile) {
                    _local_4 = ItemConstants.itemTypeToName((param1 as EquipmentTile).itemType);
                } else {
                    _local_4 = TextKey.ITEM;
                }
                this.tooltip = new TextToolTip(3552822,10197915,null,TextKey.ITEM_EMPTY_SLOT,200,{"itemType":TextKey.wrapForTokenResolution(_local_4)});
            }
            this.tooltip.attachToTarget(param1);
            var _local_2:Injector = StaticInjectorContext.getInjector();
            var _local_3:ShowTooltipSignal = _local_2.getInstance(ShowTooltipSignal);
            _local_3.dispatch(this.tooltip);
        }
        
        public function drawTile() : void {
            var _local_2:BitmapData = null;
            var _local_3:XML = null;
            var _local_4:BitmapData = null;
            var _local_1:int = this.itemId;
            if(_local_1 != ItemConstants.NO_ITEM) {
                if(_local_1 >= 36864 && _local_1 < 61440) {
                    _local_1 = 36863;
                }
                _local_2 = ObjectLibrary.getRedrawnTextureFromType(_local_1,CalendarSettings.ITEM_SIZE,true);
                _local_3 = ObjectLibrary.xmlLibrary_[_local_1];
                if(_local_3 && _local_3.hasOwnProperty("Doses") && this.bitmapFactory) {
                    _local_2 = _local_2.clone();
                    _local_4 = this.bitmapFactory.make(new StaticStringBuilder(String(_local_3.Doses)),12,16777215,false,IDENTITY_MATRIX,false);
                    _local_2.draw(_local_4,DOSE_MATRIX);
                }
                if(_local_3 && _local_3.hasOwnProperty("Quantity") && this.bitmapFactory) {
                    _local_2 = _local_2.clone();
                    _local_4 = this.bitmapFactory.make(new StaticStringBuilder(String(_local_3.Quantity)),12,16777215,false,IDENTITY_MATRIX,false);
                    _local_2.draw(_local_4,DOSE_MATRIX);
                }
                this.itemBitmap.bitmapData = _local_2;
                this.itemBitmap.x = -_local_2.width / 2;
                this.itemBitmap.y = -_local_2.width / 2;
                visible = true;
            } else {
                visible = false;
            }
        }
    }
}
