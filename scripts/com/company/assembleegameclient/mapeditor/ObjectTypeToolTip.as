package com.company.assembleegameclient.mapeditor {
    import com.company.assembleegameclient.ui.tooltip.ToolTip;
    import com.company.ui.BaseSimpleText;
    import flash.filters.DropShadowFilter;
    
    public class ObjectTypeToolTip extends ToolTip {
        
        private static const MAX_WIDTH:int = 180;
         
        
        private var titleText_:BaseSimpleText;
        
        private var descText_:BaseSimpleText;
        
        public function ObjectTypeToolTip(param1:XML) {
            var _local_3:XML = null;
            super(3552822,1,10197915,1,true);
            this.titleText_ = new BaseSimpleText(16,16777215,false,MAX_WIDTH - 4,0);
            this.titleText_.setBold(true);
            this.titleText_.wordWrap = true;
            this.titleText_.text = String(param1.@id);
            this.titleText_.useTextDimensions();
            this.titleText_.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
            this.titleText_.x = 0;
            this.titleText_.y = 0;
            addChild(this.titleText_);
            var _local_2:* = "";
            if(param1.hasOwnProperty("Group")) {
                _local_2 = _local_2 + ("Group: " + param1.Group + "\n");
            }
            if(param1.hasOwnProperty("Static")) {
                _local_2 = _local_2 + "Static\n";
            }
            if(param1.hasOwnProperty("Enemy")) {
                _local_2 = _local_2 + "Enemy\n";
                if(param1.hasOwnProperty("MaxHitPoints")) {
                    _local_2 = _local_2 + ("MaxHitPoints: " + param1.MaxHitPoints + "\n");
                }
                if(param1.hasOwnProperty("Defense")) {
                    _local_2 = _local_2 + ("Defense: " + param1.Defense + "\n");
                }
            }
            if(param1.hasOwnProperty("God")) {
                _local_2 = _local_2 + "God\n";
            }
            if(param1.hasOwnProperty("Quest")) {
                _local_2 = _local_2 + "Quest\n";
            }
            if(param1.hasOwnProperty("Hero")) {
                _local_2 = _local_2 + "Hero\n";
            }
            if(param1.hasOwnProperty("Encounter")) {
                _local_2 = _local_2 + "Encounter\n";
            }
            if(param1.hasOwnProperty("Level")) {
                _local_2 = _local_2 + ("Level: " + param1.Level + "\n");
            }
            if(param1.hasOwnProperty("Terrain")) {
                _local_2 = _local_2 + ("Terrain: " + param1.Terrain + "\n");
            }
            for each(_local_3 in param1.Projectile) {
                _local_2 = _local_2 + ("Projectile " + _local_3.@id + ": " + _local_3.ObjectId + "\n" + "\tDamage: " + _local_3.Damage + "\n" + "\tSpeed: " + _local_3.Speed + "\n");
                if(_local_3.hasOwnProperty("PassesCover")) {
                    _local_2 = _local_2 + "\tPassesCover\n";
                }
                if(_local_3.hasOwnProperty("MultiHit")) {
                    _local_2 = _local_2 + "\tMultiHit\n";
                }
                if(_local_3.hasOwnProperty("ConditionEffect")) {
                    _local_2 = _local_2 + ("\t" + _local_3.ConditionEffect + " for " + _local_3.ConditionEffect.@duration + " secs\n");
                }
                if(_local_3.hasOwnProperty("Parametric")) {
                    _local_2 = _local_2 + "\tParametric\n";
                }
            }
            this.descText_ = new BaseSimpleText(14,11776947,false,MAX_WIDTH,0);
            this.descText_.wordWrap = true;
            this.descText_.text = String(_local_2);
            this.descText_.useTextDimensions();
            this.descText_.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
            this.descText_.x = 0;
            this.descText_.y = this.titleText_.height + 2;
            addChild(this.descText_);
        }
    }
}
