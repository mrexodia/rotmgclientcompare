package com.company.assembleegameclient.ui.tooltip.slotcomparisons {
    import com.company.assembleegameclient.ui.tooltip.TooltipHelper;
    import kabam.rotmg.text.model.TextKey;
    import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    
    public class SkullComparison extends SlotComparison {
         
        
        public function SkullComparison() {
            super();
        }
        
        override protected function compareSlots(param1:XML, param2:XML) : void {
            var _local_3:XML = null;
            var _local_4:XML = null;
            var _local_5:Number = NaN;
            var _local_6:Number = NaN;
            var _local_7:int = 0;
            var _local_8:int = 0;
            var _local_9:Number = NaN;
            var _local_10:Number = NaN;
            _local_3 = this.getVampireBlastTag(param1);
            _local_4 = this.getVampireBlastTag(param2);
            comparisonStringBuilder = new AppendingLineBuilder();
            if(_local_3 != null && _local_4 != null) {
                _local_5 = Number(_local_3.@radius);
                _local_6 = Number(_local_4.@radius);
                _local_7 = int(_local_3.@totalDamage);
                _local_8 = int(_local_4.@totalDamage);
                _local_9 = 0.5 * _local_5 + 0.5 * _local_7;
                _local_10 = 0.5 * _local_6 + 0.5 * _local_8;
                comparisonStringBuilder.pushParams(TextKey.STEAL,{"effect":new LineBuilder().setParams(TextKey.HP_WITHIN_SQRS,{
                    "amount":_local_7,
                    "range":_local_5
                }).setPrefix(TooltipHelper.getOpenTag(getTextColor(_local_9 - _local_10))).setPostfix(TooltipHelper.getCloseTag())});
                processedTags[_local_3.toXMLString()] = true;
            }
        }
        
        private function getVampireBlastTag(param1:XML) : XML {
            var matches:XMLList = null;
            var xml:XML = param1;
            matches = xml.Activate.(text() == ActivationType.VAMPIRE_BLAST);
            return matches.length() >= 1?matches[0]:null;
        }
    }
}
