package io.decagames.rotmg.utils.colors {
    public class AlphaColor {
         
        
        private var _color:uint;
        
        private var _alpha:Number;
        
        public function AlphaColor(param1:uint, param2:Number = 1.0) {
            super();
            this._color = param1;
            this._alpha = param2;
        }
        
        public function get color() : uint {
            return this._color;
        }
        
        public function set color(param1:uint) : void {
            this._color = param1;
        }
        
        public function get alpha() : Number {
            return this._alpha;
        }
        
        public function set alpha(param1:Number) : void {
            this._alpha = param1;
        }
    }
}
