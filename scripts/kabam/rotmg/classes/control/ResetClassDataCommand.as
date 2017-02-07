package kabam.rotmg.classes.control {
    import kabam.rotmg.classes.model.CharacterClass;
    import kabam.rotmg.classes.model.CharacterSkin;
    import kabam.rotmg.classes.model.CharacterSkinState;
    import kabam.rotmg.classes.model.ClassesModel;
    
    public class ResetClassDataCommand {
         
        
        [Inject]
        public var classes:ClassesModel;
        
        public function ResetClassDataCommand() {
            super();
        }
        
        public function execute() : void {
            var _local_1:int = this.classes.getCount();
            var _local_2:int = 0;
            while(_local_2 < _local_1) {
                this.resetClass(this.classes.getClassAtIndex(_local_2));
                _local_2++;
            }
        }
        
        private function resetClass(param1:CharacterClass) : void {
            param1.setIsSelected(param1.id == ClassesModel.WIZARD_ID);
            this.resetClassSkins(param1);
        }
        
        private function resetClassSkins(param1:CharacterClass) : void {
            var _local_5:CharacterSkin = null;
            var _local_2:CharacterSkin = param1.skins.getDefaultSkin();
            var _local_3:int = param1.skins.getCount();
            var _local_4:int = 0;
            while(_local_4 < _local_3) {
                _local_5 = param1.skins.getSkinAt(_local_4);
                if(_local_5 != _local_2) {
                    this.resetSkin(param1.skins.getSkinAt(_local_4));
                }
                _local_4++;
            }
        }
        
        private function resetSkin(param1:CharacterSkin) : void {
            param1.setState(CharacterSkinState.LOCKED);
        }
    }
}
