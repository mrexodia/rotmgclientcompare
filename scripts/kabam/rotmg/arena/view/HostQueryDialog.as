package kabam.rotmg.arena.view {
    import com.company.assembleegameclient.ui.DeprecatedTextButton;
    import flash.display.BitmapData;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.text.TextFieldAutoSize;
    import kabam.rotmg.arena.component.ArenaQueryDialogHost;
    import kabam.rotmg.arena.util.ArenaViewAssetFactory;
    import kabam.rotmg.pets.view.components.PopupWindowBackground;
    import kabam.rotmg.text.view.TextFieldDisplayConcrete;
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    import kabam.rotmg.ui.view.SignalWaiter;
    import kabam.rotmg.util.graphics.ButtonLayoutHelper;
    import org.osflash.signals.natives.NativeSignal;
    
    public class HostQueryDialog extends Sprite {
        
        public static const WIDTH:int = 274;
        
        public static const HEIGHT:int = 338;
        
        public static const TITLE:String = "ArenaQueryPanel.title";
        
        public static const CLOSE:String = "Close.text";
        
        public static const QUERY:String = "ArenaQueryDialog.info";
        
        public static const BACK:String = "Screens.back";
         
        
        private const layoutWaiter:SignalWaiter = this.makeDeferredLayout();
        
        private const container:DisplayObjectContainer = this.makeContainer();
        
        private const background:PopupWindowBackground = this.makeBackground();
        
        private const host:ArenaQueryDialogHost = this.makeHost();
        
        private const title:TextFieldDisplayConcrete = this.makeTitle();
        
        private const backButton:DeprecatedTextButton = this.makeBackButton();
        
        public const backClick:NativeSignal = new NativeSignal(this.backButton,MouseEvent.CLICK);
        
        public function HostQueryDialog() {
            super();
        }
        
        private function makeDeferredLayout() : SignalWaiter {
            var _local_1:SignalWaiter = new SignalWaiter();
            _local_1.complete.addOnce(this.onLayout);
            return _local_1;
        }
        
        private function onLayout() : void {
            var _local_1:ButtonLayoutHelper = new ButtonLayoutHelper();
            _local_1.layout(WIDTH,this.backButton);
        }
        
        private function makeContainer() : DisplayObjectContainer {
            var _local_1:Sprite = null;
            _local_1 = new Sprite();
            _local_1.x = (800 - WIDTH) / 2;
            _local_1.y = (600 - HEIGHT) / 2;
            addChild(_local_1);
            return _local_1;
        }
        
        private function makeBackground() : PopupWindowBackground {
            var _local_1:PopupWindowBackground = new PopupWindowBackground();
            _local_1.draw(WIDTH,HEIGHT);
            _local_1.divide(PopupWindowBackground.HORIZONTAL_DIVISION,34);
            this.container.addChild(_local_1);
            return _local_1;
        }
        
        private function makeHost() : ArenaQueryDialogHost {
            var _local_1:ArenaQueryDialogHost = null;
            _local_1 = new ArenaQueryDialogHost();
            _local_1.x = 20;
            _local_1.y = 50;
            this.container.addChild(_local_1);
            return _local_1;
        }
        
        private function makeTitle() : TextFieldDisplayConcrete {
            var _local_1:TextFieldDisplayConcrete = null;
            _local_1 = ArenaViewAssetFactory.returnTextfield(16777215,18,true);
            _local_1.setStringBuilder(new LineBuilder().setParams(TITLE));
            _local_1.setAutoSize(TextFieldAutoSize.CENTER);
            _local_1.x = WIDTH / 2;
            _local_1.y = 24;
            this.container.addChild(_local_1);
            return _local_1;
        }
        
        private function makeBackButton() : DeprecatedTextButton {
            var _local_1:DeprecatedTextButton = null;
            _local_1 = new DeprecatedTextButton(16,BACK,80);
            this.container.addChild(_local_1);
            this.layoutWaiter.push(_local_1.textChanged);
            _local_1.y = 292;
            return _local_1;
        }
        
        private function makeCloseButton() : DeprecatedTextButton {
            var _local_1:DeprecatedTextButton = null;
            _local_1 = new DeprecatedTextButton(16,CLOSE,110);
            _local_1.y = 292;
            this.container.addChild(_local_1);
            this.layoutWaiter.push(_local_1.textChanged);
            return _local_1;
        }
        
        public function setHostIcon(param1:BitmapData) : void {
            this.host.setHostIcon(param1);
        }
    }
}
