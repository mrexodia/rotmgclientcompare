package com.company.assembleegameclient.account.ui.components {
    public class SelectionGroup {
         
        
        private var selectables:Vector.<Selectable>;
        
        private var selected:Selectable;
        
        public function SelectionGroup(param1:Vector.<Selectable>) {
            super();
            this.selectables = param1;
        }
        
        public function setSelected(param1:String) : void {
            var _local_2:Selectable = null;
            for each(_local_2 in this.selectables) {
                if(_local_2.getValue() == param1) {
                    this.replaceSelected(_local_2);
                    return;
                }
            }
        }
        
        public function getSelected() : Selectable {
            return this.selected;
        }
        
        private function replaceSelected(param1:Selectable) : void {
            if(this.selected != null) {
                this.selected.setSelected(false);
            }
            this.selected = param1;
            this.selected.setSelected(true);
        }
    }
}
