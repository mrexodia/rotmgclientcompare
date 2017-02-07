package kabam.rotmg.pets.controller {
    import kabam.lib.console.signals.RegisterConsoleActionSignal;
    import kabam.lib.console.vo.ConsoleAction;
    
    public class AddPetsConsoleActionsCommand {
         
        
        [Inject]
        public var register:RegisterConsoleActionSignal;
        
        [Inject]
        public var openCaretakerQuerySignal:OpenCaretakerQueryDialogSignal;
        
        public function AddPetsConsoleActionsCommand() {
            super();
        }
        
        public function execute() : void {
            var _local_1:ConsoleAction = null;
            _local_1 = new ConsoleAction();
            _local_1.name = "caretaker";
            _local_1.description = "opens the pets caretaker query UI";
            this.register.dispatch(_local_1,this.openCaretakerQuerySignal);
        }
    }
}
