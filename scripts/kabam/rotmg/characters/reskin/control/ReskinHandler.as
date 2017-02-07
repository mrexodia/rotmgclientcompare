package kabam.rotmg.characters.reskin.control {
    import com.company.assembleegameclient.objects.Player;
    import kabam.rotmg.assets.services.CharacterFactory;
    import kabam.rotmg.classes.model.CharacterClass;
    import kabam.rotmg.classes.model.CharacterSkin;
    import kabam.rotmg.classes.model.ClassesModel;
    import kabam.rotmg.game.model.GameModel;
    import kabam.rotmg.messaging.impl.outgoing.Reskin;
    
    public class ReskinHandler {
         
        
        [Inject]
        public var model:GameModel;
        
        [Inject]
        public var classes:ClassesModel;
        
        [Inject]
        public var factory:CharacterFactory;
        
        public function ReskinHandler() {
            super();
        }
        
        public function execute(param1:Reskin) : void {
            var _local_2:Player = null;
            var _local_3:int = 0;
            var _local_4:CharacterClass = null;
            _local_2 = param1.player || this.model.player;
            _local_3 = param1.skinID;
            _local_4 = this.classes.getCharacterClass(_local_2.objectType_);
            var _local_5:CharacterSkin = _local_4.skins.getSkin(_local_3);
            _local_2.skinId = _local_3;
            _local_2.skin = this.factory.makeCharacter(_local_5.template);
            _local_2.isDefaultAnimatedChar = false;
        }
    }
}
