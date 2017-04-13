package kabam.rotmg.news.view {
    import com.company.assembleegameclient.ui.Scrollbar;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.filters.DropShadowFilter;
    import flash.text.TextField;
    import kabam.rotmg.core.StaticInjectorContext;
    import kabam.rotmg.text.model.FontModel;
    import kabam.rotmg.text.view.TextFieldDisplayConcrete;
    
    public class NewsModalPage extends Sprite {
        
        public static const TEXT_MARGIN:int = 22;
        
        public static const TEXT_MARGIN_HTML:int = 26;
        
        public static const TEXT_TOP_MARGIN_HTML:int = 40;
        
        private static const SCROLLBAR_WIDTH:int = 10;
        
        public static const WIDTH:int = 136;
        
        public static const HEIGHT:int = 310;
         
        
        protected var scrollBar_:Scrollbar;
        
        private var innerModalWidth:int;
        
        private var htmlText:TextField;
        
        public function NewsModalPage(param1:String, param2:String) {
            var _local_4:Sprite = null;
            var _local_5:Sprite = null;
            super();
            this.doubleClickEnabled = false;
            this.mouseEnabled = false;
            this.innerModalWidth = NewsModal.MODAL_WIDTH - 2 - TEXT_MARGIN_HTML * 2;
            this.htmlText = new TextField();
            var _local_3:FontModel = StaticInjectorContext.getInjector().getInstance(FontModel);
            _local_3.apply(this.htmlText,16,15792127,false,false);
            this.htmlText.width = this.innerModalWidth;
            this.htmlText.multiline = true;
            this.htmlText.wordWrap = true;
            this.htmlText.htmlText = param2;
            this.htmlText.filters = [new DropShadowFilter(0,0,0)];
            this.htmlText.height = this.htmlText.textHeight + 8;
            _local_4 = new Sprite();
            _local_4.addChild(this.htmlText);
            _local_4.y = TEXT_TOP_MARGIN_HTML;
            _local_4.x = TEXT_MARGIN_HTML;
            _local_5 = new Sprite();
            _local_5.graphics.beginFill(16711680);
            _local_5.graphics.drawRect(0,0,this.innerModalWidth,HEIGHT);
            _local_5.x = TEXT_MARGIN_HTML;
            _local_5.y = TEXT_TOP_MARGIN_HTML;
            addChild(_local_5);
            _local_4.mask = _local_5;
            disableMouseOnText(this.htmlText);
            addChild(_local_4);
            var _local_6:TextFieldDisplayConcrete = NewsModal.getText(param1,TEXT_MARGIN,6,true);
            addChild(_local_6);
            if(this.htmlText.height >= HEIGHT) {
                this.scrollBar_ = new Scrollbar(SCROLLBAR_WIDTH,HEIGHT,0.1,_local_4);
                this.scrollBar_.x = NewsModal.MODAL_WIDTH - SCROLLBAR_WIDTH - 10;
                this.scrollBar_.y = TEXT_TOP_MARGIN_HTML;
                this.scrollBar_.setIndicatorSize(HEIGHT,_local_4.height);
                addChild(this.scrollBar_);
            }
            this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedHandler);
        }
        
        private static function disableMouseOnText(param1:TextField) : void {
            param1.mouseWheelEnabled = false;
        }
        
        protected function onScrollBarChange(param1:Event) : void {
            this.htmlText.y = -this.scrollBar_.pos() * (this.htmlText.height - HEIGHT);
        }
        
        private function onAddedHandler(param1:Event) : void {
            this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
            if(this.scrollBar_) {
                this.scrollBar_.addEventListener(Event.CHANGE,this.onScrollBarChange);
            }
        }
        
        private function onRemovedFromStage(param1:Event) : void {
            this.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
            this.removeEventListener(Event.ADDED_TO_STAGE,this.onAddedHandler);
            if(this.scrollBar_) {
                this.scrollBar_.removeEventListener(Event.CHANGE,this.onScrollBarChange);
            }
        }
    }
}
