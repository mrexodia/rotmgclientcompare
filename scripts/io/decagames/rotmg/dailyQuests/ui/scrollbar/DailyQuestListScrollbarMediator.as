package io.decagames.rotmg.dailyQuests.ui.scrollbar {
    import flash.events.Event;
    import flash.events.MouseEvent;
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    public class DailyQuestListScrollbarMediator extends Mediator {
         
        
        [Inject]
        public var view:DailyQuestListScrollbar;
        
        private var startDragging:Boolean;
        
        private var startY:Number;
        
        public function DailyQuestListScrollbarMediator() {
            super();
        }
        
        override public function initialize() : void {
            this.view.addEventListener(Event.ENTER_FRAME,this.onUpdateHandler);
            this.view.slider.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            WebMain.STAGE.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
        }
        
        private function onMouseDown(param1:Event) : void {
            this.startDragging = true;
            this.startY = WebMain.STAGE.mouseY;
        }
        
        private function onMouseUp(param1:Event) : void {
            this.startDragging = false;
        }
        
        override public function destroy() : void {
            this.view.removeEventListener(Event.ENTER_FRAME,this.onUpdateHandler);
            this.view.slider.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            WebMain.STAGE.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
        }
        
        private function onUpdateHandler(param1:Event) : void {
            if(this.startDragging) {
                this.view.updatePosition(WebMain.STAGE.mouseY - this.startY);
                this.startY = WebMain.STAGE.mouseY;
            }
        }
    }
}
