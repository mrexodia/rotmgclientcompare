package com.company.assembleegameclient.objects {
    import com.company.assembleegameclient.game.GameSprite;
    import com.company.assembleegameclient.ui.panels.Panel;
    import com.company.assembleegameclient.ui.tooltip.TextToolTip;
    import com.company.assembleegameclient.ui.tooltip.ToolTip;
    import com.company.assembleegameclient.util.AnimatedChar;
    import com.company.assembleegameclient.util.AnimatedChars;
    import com.company.assembleegameclient.util.MaskedImage;
    import kabam.rotmg.core.StaticInjectorContext;
    import kabam.rotmg.game.signals.TextPanelMessageUpdateSignal;
    import kabam.rotmg.pets.data.PetVO;
    import kabam.rotmg.pets.data.PetsModel;
    import kabam.rotmg.pets.view.petPanel.PetPanel;
    import kabam.rotmg.text.model.TextKey;
    
    public class Pet extends GameObject implements IInteractiveObject {
         
        
        private var textPanelUpdateSignal:TextPanelMessageUpdateSignal;
        
        public var vo:PetVO;
        
        public var skin:AnimatedChar;
        
        public var defaultSkin:AnimatedChar;
        
        public var skinId:int;
        
        public var isDefaultAnimatedChar:Boolean = false;
        
        private var petsModel:PetsModel;
        
        public function Pet(param1:XML) {
            super(param1);
            isInteractive_ = true;
            this.textPanelUpdateSignal = StaticInjectorContext.getInjector().getInstance(TextPanelMessageUpdateSignal);
            this.petsModel = StaticInjectorContext.getInjector().getInstance(PetsModel);
            this.petsModel.getActivePet();
        }
        
        public function getTooltip() : ToolTip {
            var _local_1:ToolTip = new TextToolTip(3552822,10197915,TextKey.CLOSEDGIFTCHEST_TITLE,TextKey.TEXTPANEL_GIFTCHESTISEMPTY,200);
            return _local_1;
        }
        
        public function getPanel(param1:GameSprite) : Panel {
            return new PetPanel(param1,this.vo);
        }
        
        public function setSkin(param1:int) : void {
            var _local_5:MaskedImage = null;
            this.skinId = param1;
            var _local_2:XML = ObjectLibrary.getXMLfromId(ObjectLibrary.getIdFromType(param1));
            var _local_3:String = _local_2.AnimatedTexture.File;
            var _local_4:int = _local_2.AnimatedTexture.Index;
            if(this.skin == null) {
                this.isDefaultAnimatedChar = true;
                this.skin = AnimatedChars.getAnimatedChar(_local_3,_local_4);
                this.defaultSkin = this.skin;
            } else {
                this.skin = AnimatedChars.getAnimatedChar(_local_3,_local_4);
            }
            this.isDefaultAnimatedChar = this.skin == this.defaultSkin;
            _local_5 = this.skin.imageFromAngle(0,AnimatedChar.STAND,0);
            animatedChar_ = this.skin;
            texture_ = _local_5.image_;
            mask_ = _local_5.mask_;
        }
        
        public function setDefaultSkin() : void {
            var _local_1:MaskedImage = null;
            this.skinId = -1;
            if(this.defaultSkin == null) {
                return;
            }
            _local_1 = this.defaultSkin.imageFromAngle(0,AnimatedChar.STAND,0);
            this.isDefaultAnimatedChar = true;
            animatedChar_ = this.defaultSkin;
            texture_ = _local_1.image_;
            mask_ = _local_1.mask_;
        }
    }
}
