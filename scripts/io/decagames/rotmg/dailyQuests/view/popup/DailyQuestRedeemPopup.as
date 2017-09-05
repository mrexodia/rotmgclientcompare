package io.decagames.rotmg.dailyQuests.view.popup {
    import com.company.util.GraphicsUtil;
    import flash.display.Bitmap;
    import flash.display.CapsStyle;
    import flash.display.GraphicsPath;
    import flash.display.GraphicsSolidFill;
    import flash.display.GraphicsStroke;
    import flash.display.IGraphicsData;
    import flash.display.JointStyle;
    import flash.display.LineScaleMode;
    import flash.display.Sprite;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormatAlign;
    import io.decagames.rotmg.dailyQuests.data.DailyQuestItemSlotType;
    import io.decagames.rotmg.dailyQuests.model.DailyQuest;
    import io.decagames.rotmg.dailyQuests.utils.SlotsRendered;
    import io.decagames.rotmg.dailyQuests.view.slot.DailyQuestItemSlot;
    import kabam.rotmg.text.view.TextFieldDisplayConcrete;
    import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
    import kabam.rotmg.util.components.SimpleButton;
    
    public class DailyQuestRedeemPopup extends Sprite {
        
        public static var dailyQuestBanner:Class = DailyQuestRedeemPopup_dailyQuestBanner;
         
        
        private var titleFill_:GraphicsSolidFill;
        
        private var backgroundFill_:GraphicsSolidFill;
        
        private var outlineFill_:GraphicsSolidFill;
        
        private var lineStyle_:GraphicsStroke;
        
        private var path1_:GraphicsPath;
        
        private var path2_:GraphicsPath;
        
        private const graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[this.backgroundFill_,this.path2_,GraphicsUtil.END_FILL,this.titleFill_,this.path1_,GraphicsUtil.END_FILL,this.lineStyle_,this.path2_,GraphicsUtil.END_STROKE];
        
        private var w_:int = 288;
        
        private var h_:int = 100;
        
        private var _thanksButton:SimpleButton;
        
        private var slots:Vector.<DailyQuestItemSlot>;
        
        private var slotContainerPosition:int = 35;
        
        public function DailyQuestRedeemPopup(param1:int, param2:int, param3:DailyQuest) {
            var _local_6:TextFieldDisplayConcrete = null;
            this.titleFill_ = new GraphicsSolidFill(5066061,1);
            this.backgroundFill_ = new GraphicsSolidFill(3552822,1);
            this.outlineFill_ = new GraphicsSolidFill(16777215,1);
            this.lineStyle_ = new GraphicsStroke(1,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,this.outlineFill_);
            this.path1_ = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
            this.path2_ = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
            super();
            this.w_ = param1;
            this.h_ = param2;
            this.slots = new Vector.<DailyQuestItemSlot>();
            this.draw();
            this._thanksButton = new SimpleButton("Thanks!");
            addChild(this._thanksButton);
            this._thanksButton.x = Math.round((param1 - this._thanksButton.width) / 2);
            this._thanksButton.y = param2 - this._thanksButton.height - 20;
            var _local_4:Bitmap = new dailyQuestBanner();
            addChild(_local_4);
            _local_4.x = Math.round((param1 - _local_4.width) / 2);
            _local_4.y = -Math.round(_local_4.height / 2);
            var _local_5:Sprite = new Sprite();
            addChild(_local_5);
            SlotsRendered.renderSlots(param3.rewards,new Vector.<int>(),DailyQuestItemSlotType.REWARD,_local_5,this.slotContainerPosition,4,param1,this.slots);
            _local_6 = new TextFieldDisplayConcrete().setSize(14).setColor(16682752).setBold(true).setTextWidth(param1).setAutoSize(TextFieldAutoSize.CENTER).setHorizontalAlign(TextFormatAlign.CENTER);
            _local_6.setStringBuilder(new StaticStringBuilder("has been sent to the Gift Chest!"));
            _local_6.y = _local_5.y + _local_5.height;
            addChild(_local_6);
        }
        
        private function draw() : void {
            graphics.clear();
            GraphicsUtil.clearPath(this.path2_);
            GraphicsUtil.drawCutEdgeRect(-6,-6,this.w_,this.h_,4,[1,1,1,1],this.path2_);
            graphics.drawGraphicsData(this.graphicsData_);
        }
        
        public function get thanksButton() : SimpleButton {
            return this._thanksButton;
        }
    }
}
