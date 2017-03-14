package kabam.rotmg.dailyLogin.view {
    import com.company.assembleegameclient.ui.DeprecatedTextButtonStatic;
    import com.company.assembleegameclient.util.TextureRedrawer;
    import com.company.util.AssetLibrary;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.filters.DropShadowFilter;
    import flash.geom.Rectangle;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormatAlign;
    import kabam.rotmg.dailyLogin.config.CalendarSettings;
    import kabam.rotmg.dailyLogin.model.DailyLoginModel;
    import kabam.rotmg.mysterybox.components.MysteryBoxSelectModal;
    import kabam.rotmg.pets.view.components.DialogCloseButton;
    import kabam.rotmg.pets.view.components.PopupWindowBackground;
    import kabam.rotmg.text.view.TextFieldDisplayConcrete;
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
    
    public class DailyLoginModal extends Sprite {
         
        
        private var content:Sprite;
        
        private var calendarView:CalendarView;
        
        private var titleTxt:TextFieldDisplayConcrete;
        
        private var serverTimeTxt:TextFieldDisplayConcrete;
        
        public var closeButton:DialogCloseButton;
        
        private var modalRectangle:Rectangle;
        
        private var daysLeft:int = 300;
        
        public var claimButton:DeprecatedTextButtonStatic;
        
        private var tabs:CalendarTabsView;
        
        public function DailyLoginModal() {
            this.calendarView = new CalendarView();
            this.closeButton = new DialogCloseButton();
            super();
        }
        
        public function init(param1:DailyLoginModel) : void {
            this.daysLeft = param1.daysLeftToCalendarEnd;
            this.modalRectangle = CalendarSettings.getCalendarModalRectangle(param1.overallMaxDays,this.daysLeft < CalendarSettings.CLAIM_WARNING_BEFORE_DAYS);
            this.content = new Sprite();
            addChild(this.content);
            this.createModalBox();
            this.tabs = new CalendarTabsView();
            addChild(this.tabs);
            this.tabs.y = CalendarSettings.TABS_Y_POSITION;
            if(this.daysLeft < CalendarSettings.CLAIM_WARNING_BEFORE_DAYS) {
                this.tabs.y = this.tabs.y + 20;
            }
            this.centerModal();
        }
        
        private function addClaimButton() : * {
            this.claimButton = new DeprecatedTextButtonStatic(16,"Go & Claim");
            this.claimButton.textChanged.addOnce(this.alignClaimButton);
            addChild(this.claimButton);
        }
        
        public function showLegend(param1:Boolean) : * {
            var _local_2:Sprite = null;
            var _local_6:Bitmap = null;
            var _local_7:Bitmap = null;
            _local_2 = new Sprite();
            _local_2.y = this.modalRectangle.height - 55;
            var _local_3:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(16).setColor(16777215).setTextWidth(this.modalRectangle.width).setHorizontalAlign(TextFormatAlign.LEFT);
            _local_3.setStringBuilder(new StaticStringBuilder(!!param1?"- Reward ready to claim. Click on day to claim reward.":"- Reward ready to claim."));
            var _local_4:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(16).setColor(16777215).setTextWidth(this.modalRectangle.width).setHorizontalAlign(TextFormatAlign.LEFT);
            _local_4.setStringBuilder(new StaticStringBuilder("- Item claimed already."));
            _local_3.x = 20;
            _local_3.y = 0;
            _local_4.x = 20;
            _local_4.y = 20;
            var _local_5:BitmapData = AssetLibrary.getImageFromSet("lofiInterface",52);
            _local_5.colorTransform(new Rectangle(0,0,_local_5.width,_local_5.height),CalendarSettings.GREEN_COLOR_TRANSFORM);
            _local_5 = TextureRedrawer.redraw(_local_5,40,true,0);
            _local_6 = new Bitmap(_local_5);
            _local_6.x = -Math.round(_local_6.width / 2) + 10;
            _local_6.y = -Math.round(_local_6.height / 2) + 9;
            _local_2.addChild(_local_6);
            _local_5 = AssetLibrary.getImageFromSet("lofiInterfaceBig",11);
            _local_5 = TextureRedrawer.redraw(_local_5,20,true,0);
            _local_7 = new Bitmap(_local_5);
            _local_7.x = -Math.round(_local_7.width / 2) + 10;
            _local_7.y = -Math.round(_local_7.height / 2) + 30;
            _local_2.addChild(_local_7);
            _local_2.addChild(_local_3);
            _local_2.addChild(_local_4);
            if(!param1) {
                this.addClaimButton();
                _local_2.x = CalendarSettings.DAILY_LOGIN_MODAL_PADDING + this.claimButton.width + 10;
            } else {
                _local_2.x = CalendarSettings.DAILY_LOGIN_MODAL_PADDING;
            }
            addChild(_local_2);
        }
        
        private function alignClaimButton() : void {
            this.claimButton.x = CalendarSettings.DAILY_LOGIN_MODAL_PADDING;
            this.claimButton.y = this.modalRectangle.height - this.claimButton.height - CalendarSettings.DAILY_LOGIN_MODAL_PADDING;
            if(this.daysLeft < CalendarSettings.CLAIM_WARNING_BEFORE_DAYS) {
            }
        }
        
        private function createModalBox() : * {
            var _local_1:DisplayObject = new MysteryBoxSelectModal.backgroundImageEmbed();
            _local_1.width = this.modalRectangle.width - 1;
            _local_1.height = this.modalRectangle.height - 27;
            _local_1.y = 27;
            _local_1.alpha = 0.95;
            this.content.addChild(_local_1);
            this.content.addChild(this.makeModalBackground(this.modalRectangle.width,this.modalRectangle.height));
        }
        
        private function makeModalBackground(param1:int, param2:int) : PopupWindowBackground {
            var _local_3:PopupWindowBackground = new PopupWindowBackground();
            _local_3.draw(param1,param2,PopupWindowBackground.TYPE_TRANSPARENT_WITH_HEADER);
            return _local_3;
        }
        
        public function addCloseButton() : void {
            this.closeButton.y = 4;
            this.closeButton.x = this.modalRectangle.width - this.closeButton.width - 5;
            addChild(this.closeButton);
        }
        
        public function addTitle(param1:String) : void {
            this.titleTxt = this.getText(param1,0,6,true).setSize(18);
            this.titleTxt.setColor(16768512);
            addChild(this.titleTxt);
        }
        
        public function showServerTime(param1:String, param2:String) : void {
            var _local_3:TextFieldDisplayConcrete = null;
            this.serverTimeTxt = new TextFieldDisplayConcrete().setSize(14).setColor(16777215).setTextWidth(this.modalRectangle.width);
            this.serverTimeTxt.setStringBuilder(new StaticStringBuilder("Server time: " + param1 + ", ends on: " + param2));
            this.serverTimeTxt.x = CalendarSettings.DAILY_LOGIN_MODAL_PADDING;
            if(this.daysLeft < CalendarSettings.CLAIM_WARNING_BEFORE_DAYS) {
                _local_3 = new TextFieldDisplayConcrete().setSize(14).setColor(16711680).setTextWidth(this.modalRectangle.width);
                _local_3.setStringBuilder(new StaticStringBuilder("Calendar will soon end, remember to claim before it ends."));
                _local_3.x = CalendarSettings.DAILY_LOGIN_MODAL_PADDING;
                _local_3.y = 40;
                this.serverTimeTxt.y = 60;
                this.calendarView.y = 90;
                addChild(_local_3);
            } else {
                this.calendarView.y = 70;
                this.serverTimeTxt.y = 40;
            }
            addChild(this.serverTimeTxt);
        }
        
        public function getText(param1:String, param2:int, param3:int, param4:Boolean = false) : TextFieldDisplayConcrete {
            var _local_5:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(16).setColor(16777215).setTextWidth(this.modalRectangle.width);
            _local_5.setBold(true);
            if(param4) {
                _local_5.setStringBuilder(new StaticStringBuilder(param1));
            } else {
                _local_5.setStringBuilder(new LineBuilder().setParams(param1));
            }
            _local_5.setWordWrap(true);
            _local_5.setMultiLine(true);
            _local_5.setAutoSize(TextFieldAutoSize.CENTER);
            _local_5.setHorizontalAlign(TextFormatAlign.CENTER);
            _local_5.filters = [new DropShadowFilter(0,0,0)];
            _local_5.x = param2;
            _local_5.y = param3;
            return _local_5;
        }
        
        private function centerModal() : void {
            this.x = WebMain.STAGE.stageWidth / 2 - this.width / 2;
            this.y = WebMain.STAGE.stageHeight / 2 - this.height / 2;
            this.tabs.x = CalendarSettings.DAILY_LOGIN_MODAL_PADDING;
        }
    }
}
