package kabam.rotmg.arena.component {
    import com.company.assembleegameclient.ui.GuildText;
    import com.company.assembleegameclient.ui.panels.itemgrids.EquippedGrid;
    import com.company.assembleegameclient.ui.tooltip.ToolTip;
    import flash.display.Bitmap;
    import kabam.rotmg.arena.model.ArenaLeaderboardEntry;
    import kabam.rotmg.text.view.StaticTextDisplay;
    import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
    
    public class AbridgedPlayerTooltip extends ToolTip {
         
        
        public function AbridgedPlayerTooltip(param1:ArenaLeaderboardEntry) {
            var _local_3:StaticTextDisplay = null;
            var _local_5:GuildText = null;
            var _local_2:Bitmap = new Bitmap();
            _local_2.bitmapData = param1.playerBitmap;
            _local_2.scaleX = 0.75;
            _local_2.scaleY = 0.75;
            _local_2.y = 5;
            addChild(_local_2);
            _local_3 = new StaticTextDisplay();
            _local_3.setSize(14).setBold(true).setColor(16777215);
            _local_3.setStringBuilder(new StaticStringBuilder(param1.name));
            _local_3.x = 40;
            _local_3.y = 5;
            addChild(_local_3);
            if(param1.guildName) {
                _local_5 = new GuildText(param1.guildName,param1.guildRank);
                _local_5.x = 40;
                _local_5.y = 20;
                addChild(_local_5);
            }
            super(3552822,0.5,16777215,1);
            var _local_4:EquippedGrid = new EquippedGrid(null,param1.slotTypes,null);
            _local_4.x = 5;
            _local_4.y = !!_local_5?Number(_local_5.y + _local_5.height - 5):Number(55);
            _local_4.setItems(param1.equipment);
            addChild(_local_4);
        }
    }
}
