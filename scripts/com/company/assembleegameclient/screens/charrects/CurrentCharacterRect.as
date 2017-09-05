package com.company.assembleegameclient.screens.charrects {
    import com.company.assembleegameclient.appengine.CharacterStats;
    import com.company.assembleegameclient.appengine.SavedCharacter;
    import com.company.assembleegameclient.screens.events.DeleteCharacterEvent;
    import com.company.assembleegameclient.ui.tooltip.MyPlayerToolTip;
    import com.company.assembleegameclient.util.FameUtil;
    import com.company.rotmg.graphics.DeleteXGraphic;
    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import kabam.rotmg.classes.model.CharacterClass;
    import kabam.rotmg.text.model.TextKey;
    import kabam.rotmg.text.view.TextFieldDisplayConcrete;
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
    import org.osflash.signals.Signal;
    
    public class CurrentCharacterRect extends CharacterRect {
        
        private static var toolTip_:MyPlayerToolTip = null;
         
        
        public const selected:Signal = new Signal();
        
        public const deleteCharacter:Signal = new Signal();
        
        public const showToolTip:Signal = new Signal(Sprite);
        
        public const hideTooltip:Signal = new Signal();
        
        public var charName:String;
        
        public var charStats:CharacterStats;
        
        public var char:SavedCharacter;
        
        public var myPlayerToolTipFactory:MyPlayerToolTipFactory;
        
        private var charType:CharacterClass;
        
        private var deleteButton:Sprite;
        
        private var icon:DisplayObject;
        
        private var petIcon:Bitmap;
        
        protected var statsMaxedText:TextFieldDisplayConcrete;
        
        public function CurrentCharacterRect(param1:String, param2:CharacterClass, param3:SavedCharacter, param4:CharacterStats) {
            this.myPlayerToolTipFactory = new MyPlayerToolTipFactory();
            super();
            this.charName = param1;
            this.charType = param2;
            this.char = param3;
            this.charStats = param4;
            var _local_5:String = param2.name;
            var _local_6:int = param3.charXML_.Level;
            super.className = new LineBuilder().setParams(TextKey.CURRENT_CHARACTER_DESCRIPTION,{
                "className":_local_5,
                "level":_local_6
            });
            super.color = 6052956;
            super.overColor = 8355711;
            super.init();
            this.makeTagline();
            this.makeDeleteButton();
            this.makePetIcon();
            this.makeStatsMaxedText();
            this.addEventListeners();
        }
        
        private function addEventListeners() : void {
            addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
            selectContainer.addEventListener(MouseEvent.CLICK,this.onSelect);
            this.deleteButton.addEventListener(MouseEvent.CLICK,this.onDelete);
        }
        
        private function onSelect(param1:MouseEvent) : void {
            this.selected.dispatch(this.char);
        }
        
        private function onDelete(param1:MouseEvent) : void {
            this.deleteCharacter.dispatch(this.char);
        }
        
        public function setIcon(param1:DisplayObject) : void {
            this.icon && selectContainer.removeChild(this.icon);
            this.icon = param1;
            this.icon.x = CharacterRectConstants.ICON_POS_X;
            this.icon.y = CharacterRectConstants.ICON_POS_Y;
            this.icon && selectContainer.addChild(this.icon);
        }
        
        private function makePetIcon() : void {
            var _local_1:* = this.char.getPetVO();
            if(_local_1) {
                this.petIcon = _local_1.getSkin();
                if(this.petIcon == null) {
                    return;
                }
                this.petIcon.x = CharacterRectConstants.PET_ICON_POS_X;
                this.petIcon.y = CharacterRectConstants.PET_ICON_POS_Y;
                selectContainer.addChild(this.petIcon);
            }
        }
        
        private function makeTagline() : void {
            if(this.getNextStarFame() > 0) {
                super.makeTaglineIcon();
                super.makeTaglineText(new LineBuilder().setParams(TextKey.CURRENT_CHARACTER_TAGLINE,{
                    "fame":this.char.fame(),
                    "nextStarFame":this.getNextStarFame()
                }));
                taglineText.x = taglineText.x + taglineIcon.width;
            } else {
                super.makeTaglineIcon();
                super.makeTaglineText(new LineBuilder().setParams(TextKey.CURRENT_CHARACTER_TAGLINE_NOQUEST,{"fame":this.char.fame()}));
                taglineText.x = taglineText.x + taglineIcon.width;
            }
        }
        
        private function getNextStarFame() : int {
            return FameUtil.nextStarFame(this.charStats == null?0:int(this.charStats.bestFame()),this.char.fame());
        }
        
        private function makeDeleteButton() : void {
            this.deleteButton = new DeleteXGraphic();
            this.deleteButton.addEventListener(MouseEvent.MOUSE_DOWN,this.onDeleteDown);
            this.deleteButton.x = WIDTH - 40;
            this.deleteButton.y = (HEIGHT - this.deleteButton.height) * 0.5;
            addChild(this.deleteButton);
        }
        
        private function makeStatsMaxedText() : void {
            var _local_1:int = this.getMaxedStats();
            var _local_2:uint = 11776947;
            if(_local_1 >= 8) {
                _local_2 = 16572160;
            }
            this.statsMaxedText = new TextFieldDisplayConcrete().setSize(18).setColor(16777215);
            this.statsMaxedText.setBold(true);
            this.statsMaxedText.setColor(_local_2);
            this.statsMaxedText.setStringBuilder(new StaticStringBuilder(_local_1 + "/8"));
            this.statsMaxedText.filters = makeDropShadowFilter();
            this.statsMaxedText.x = CharacterRectConstants.STATS_MAXED_POS_X;
            this.statsMaxedText.y = CharacterRectConstants.STATS_MAXED_POS_Y;
            selectContainer.addChild(this.statsMaxedText);
        }
        
        private function getMaxedStats() : int {
            var _local_1:int = 0;
            if(this.char.hp() == this.charType.hp.max) {
                _local_1++;
            }
            if(this.char.mp() == this.charType.mp.max) {
                _local_1++;
            }
            if(this.char.att() == this.charType.attack.max) {
                _local_1++;
            }
            if(this.char.def() == this.charType.defense.max) {
                _local_1++;
            }
            if(this.char.spd() == this.charType.speed.max) {
                _local_1++;
            }
            if(this.char.dex() == this.charType.dexterity.max) {
                _local_1++;
            }
            if(this.char.vit() == this.charType.hpRegeneration.max) {
                _local_1++;
            }
            if(this.char.wis() == this.charType.mpRegeneration.max) {
                _local_1++;
            }
            return _local_1;
        }
        
        override protected function onMouseOver(param1:MouseEvent) : void {
            super.onMouseOver(param1);
            this.removeToolTip();
            toolTip_ = this.myPlayerToolTipFactory.create(this.charName,this.char.charXML_,this.charStats);
            toolTip_.createUI();
            this.showToolTip.dispatch(toolTip_);
        }
        
        override protected function onRollOut(param1:MouseEvent) : void {
            super.onRollOut(param1);
            this.removeToolTip();
        }
        
        private function onRemovedFromStage(param1:Event) : void {
            this.removeToolTip();
        }
        
        private function removeToolTip() : void {
            this.hideTooltip.dispatch();
        }
        
        private function onDeleteDown(param1:MouseEvent) : void {
            param1.stopImmediatePropagation();
            dispatchEvent(new DeleteCharacterEvent(this.char));
        }
    }
}
