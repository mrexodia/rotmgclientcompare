package kabam.rotmg.classes.view {
    import com.company.assembleegameclient.constants.ScreenTypes;
    import com.company.assembleegameclient.screens.AccountScreen;
    import com.company.assembleegameclient.screens.TitleMenuOption;
    import com.company.rotmg.graphics.ScreenGraphic;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.text.TextFieldAutoSize;
    import kabam.rotmg.core.StaticInjectorContext;
    import kabam.rotmg.core.model.PlayerModel;
    import kabam.rotmg.game.view.CreditDisplay;
    import kabam.rotmg.text.view.TextFieldDisplayConcrete;
    import kabam.rotmg.ui.view.SignalWaiter;
    import kabam.rotmg.ui.view.components.ScreenBase;
    import org.osflash.signals.Signal;
    import org.osflash.signals.natives.NativeMappedSignal;
    
    public class CharacterSkinView extends Sprite {
         
        
        private const base:ScreenBase = this.makeScreenBase();
        
        private const account:AccountScreen = this.makeAccountScreen();
        
        private const lines:Shape = this.makeLines();
        
        private const creditsDisplay:CreditDisplay = this.makeCreditDisplay();
        
        private const graphic:ScreenGraphic = this.makeScreenGraphic();
        
        private const playBtn:TitleMenuOption = this.makePlayButton();
        
        private const backBtn:TitleMenuOption = this.makeBackButton();
        
        private const list:CharacterSkinListView = this.makeListView();
        
        private const detail:ClassDetailView = this.makeClassDetailView();
        
        public const play:Signal = new NativeMappedSignal(this.playBtn,MouseEvent.CLICK);
        
        public const back:Signal = new NativeMappedSignal(this.backBtn,MouseEvent.CLICK);
        
        public const waiter:SignalWaiter = this.makeSignalWaiter();
        
        public function CharacterSkinView() {
            super();
        }
        
        private function makeScreenBase() : ScreenBase {
            var _local_1:ScreenBase = new ScreenBase();
            addChild(_local_1);
            return _local_1;
        }
        
        private function makeAccountScreen() : AccountScreen {
            var _local_1:AccountScreen = new AccountScreen();
            addChild(_local_1);
            return _local_1;
        }
        
        private function makeCreditDisplay() : CreditDisplay {
            var _local_1:CreditDisplay = null;
            _local_1 = new CreditDisplay(null,true,true);
            var _local_2:PlayerModel = StaticInjectorContext.getInjector().getInstance(PlayerModel);
            if(_local_2 != null) {
                _local_1.draw(_local_2.getCredits(),_local_2.getFame(),_local_2.getTokens());
            }
            _local_1.x = 800;
            _local_1.y = 20;
            addChild(_local_1);
            return _local_1;
        }
        
        private function makeLines() : Shape {
            var _local_1:Shape = new Shape();
            _local_1.graphics.clear();
            _local_1.graphics.lineStyle(2,5526612);
            _local_1.graphics.moveTo(0,105);
            _local_1.graphics.lineTo(800,105);
            _local_1.graphics.moveTo(346,105);
            _local_1.graphics.lineTo(346,526);
            addChild(_local_1);
            return _local_1;
        }
        
        private function makeScreenGraphic() : ScreenGraphic {
            var _local_1:ScreenGraphic = new ScreenGraphic();
            addChild(_local_1);
            return _local_1;
        }
        
        private function makePlayButton() : TitleMenuOption {
            var _local_1:TitleMenuOption = null;
            _local_1 = new TitleMenuOption(ScreenTypes.PLAY,36,false);
            _local_1.setAutoSize(TextFieldAutoSize.CENTER);
            _local_1.setVerticalAlign(TextFieldDisplayConcrete.MIDDLE);
            _local_1.x = 400 - _local_1.width / 2;
            _local_1.y = 550;
            addChild(_local_1);
            return _local_1;
        }
        
        private function makeBackButton() : TitleMenuOption {
            var _local_1:TitleMenuOption = null;
            _local_1 = new TitleMenuOption(ScreenTypes.BACK,22,false);
            _local_1.setVerticalAlign(TextFieldDisplayConcrete.MIDDLE);
            _local_1.x = 30;
            _local_1.y = 550;
            addChild(_local_1);
            return _local_1;
        }
        
        private function makeListView() : CharacterSkinListView {
            var _local_1:CharacterSkinListView = null;
            _local_1 = new CharacterSkinListView();
            _local_1.x = 351;
            _local_1.y = 110;
            addChild(_local_1);
            return _local_1;
        }
        
        private function makeClassDetailView() : ClassDetailView {
            var _local_1:ClassDetailView = null;
            _local_1 = new ClassDetailView();
            _local_1.x = 5;
            _local_1.y = 110;
            addChild(_local_1);
            return _local_1;
        }
        
        public function setPlayButtonEnabled(param1:Boolean) : void {
            if(!param1) {
                this.playBtn.deactivate();
            }
        }
        
        private function makeSignalWaiter() : SignalWaiter {
            var _local_1:SignalWaiter = new SignalWaiter();
            _local_1.push(this.playBtn.changed);
            _local_1.complete.add(this.positionOptions);
            return _local_1;
        }
        
        private function positionOptions() : void {
            this.playBtn.x = stage.stageWidth / 2;
        }
    }
}
