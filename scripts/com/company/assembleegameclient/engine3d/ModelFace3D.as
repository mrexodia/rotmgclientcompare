package com.company.assembleegameclient.engine3d {
    public class ModelFace3D {
         
        
        public var model_:Model3D;
        
        public var indicies_:Vector.<int>;
        
        public var useTexture_:Boolean;
        
        public function ModelFace3D(param1:Model3D, param2:Vector.<int>, param3:Boolean) {
            super();
            this.model_ = param1;
            this.indicies_ = param2;
            this.useTexture_ = param3;
        }
        
        public static function compare(param1:ModelFace3D, param2:ModelFace3D) : Number {
            var _local_3:Number = NaN;
            var _local_4:int = 0;
            var _local_5:Number = Number.MAX_VALUE;
            var _local_6:Number = Number.MIN_VALUE;
            _local_4 = 0;
            while(_local_4 < param1.indicies_.length) {
                _local_3 = param2.model_.vL_[param1.indicies_[_local_4] * 3 + 2];
                _local_5 = _local_3 < _local_5?Number(_local_3):Number(_local_5);
                _local_6 = _local_3 > _local_6?Number(_local_3):Number(_local_6);
                _local_4++;
            }
            var _local_7:Number = Number.MAX_VALUE;
            var _local_8:Number = Number.MIN_VALUE;
            _local_4 = 0;
            while(_local_4 < param2.indicies_.length) {
                _local_3 = param2.model_.vL_[param2.indicies_[_local_4] * 3 + 2];
                _local_7 = _local_3 < _local_7?Number(_local_3):Number(_local_7);
                _local_8 = _local_3 > _local_8?Number(_local_3):Number(_local_8);
                _local_4++;
            }
            if(_local_7 > _local_5) {
                return -1;
            }
            if(_local_7 < _local_5) {
                return 1;
            }
            if(_local_8 > _local_6) {
                return -1;
            }
            if(_local_8 < _local_6) {
                return 1;
            }
            return 0;
        }
    }
}
