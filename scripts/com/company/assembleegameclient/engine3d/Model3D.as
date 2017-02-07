package com.company.assembleegameclient.engine3d {
    import com.company.util.ConversionUtil;
    import flash.display3D.Context3D;
    import flash.utils.ByteArray;
    import kabam.rotmg.stage3D.Object3D.Model3D_stage3d;
    import kabam.rotmg.stage3D.Object3D.Object3DStage3D;
    
    public class Model3D {
        
        private static var modelLib_:Object = new Object();
        
        private static var models:Object = new Object();
         
        
        public var vL_:Vector.<Number>;
        
        public var uvts_:Vector.<Number>;
        
        public var faces_:Vector.<ModelFace3D>;
        
        public function Model3D() {
            this.vL_ = new Vector.<Number>();
            this.uvts_ = new Vector.<Number>();
            this.faces_ = new Vector.<ModelFace3D>();
            super();
        }
        
        public static function parse3DOBJ(param1:String, param2:ByteArray) : void {
            var _local_3:Model3D_stage3d = new Model3D_stage3d();
            _local_3.readBytes(param2);
            models[param1] = _local_3;
        }
        
        public static function Create3dBuffer(param1:Context3D) : void {
            var _local_2:Model3D_stage3d = null;
            for each(_local_2 in models) {
                _local_2.CreatBuffer(param1);
            }
        }
        
        public static function parseFromOBJ(param1:String, param2:String) : void {
            var _local_11:String = null;
            var _local_12:Model3D = null;
            var _local_13:String = null;
            var _local_14:int = 0;
            var _local_15:Array = null;
            var _local_16:String = null;
            var _local_17:String = null;
            var _local_18:Array = null;
            var _local_19:Array = null;
            var _local_20:String = null;
            var _local_21:Vector.<int> = null;
            var _local_22:int = 0;
            var _local_3:Array = param2.split(/\s*\n\s*/);
            var _local_4:Array = [];
            var _local_5:Array = [];
            var _local_6:Array = [];
            var _local_7:Object = {};
            var _local_8:Array = [];
            var _local_9:String = null;
            var _local_10:Array = [];
            for each(_local_11 in _local_3) {
                if(_local_11.charAt(0) == "#" || _local_11.length == 0) {
                    continue;
                }
                _local_15 = _local_11.split(/\s+/);
                if(_local_15.length == 0) {
                    continue;
                }
                _local_16 = _local_15.shift();
                if(_local_16.length == 0) {
                    continue;
                }
                switch(_local_16) {
                    case "v":
                        if(_local_15.length != 3) {
                            return;
                        }
                        _local_4.push(_local_15);
                        continue;
                    case "vt":
                        if(_local_15.length != 2) {
                            return;
                        }
                        _local_5.push(_local_15);
                        continue;
                    case "f":
                        if(_local_15.length < 3) {
                            return;
                        }
                        _local_8.push(_local_15);
                        _local_10.push(_local_9);
                        for each(_local_17 in _local_15) {
                            if(!_local_7.hasOwnProperty(_local_17)) {
                                _local_7[_local_17] = _local_6.length;
                                _local_6.push(_local_17);
                            }
                        }
                        continue;
                    case "usemtl":
                        if(_local_15.length != 1) {
                            return;
                        }
                        _local_9 = _local_15[0];
                        continue;
                    default:
                        continue;
                }
            }
            _local_12 = new Model3D();
            for each(_local_13 in _local_6) {
                _local_18 = _local_13.split("/");
                ConversionUtil.addToNumberVector(_local_4[int(_local_18[0]) - 1],_local_12.vL_);
                if(_local_18.length > 1 && _local_18[1].length > 0) {
                    ConversionUtil.addToNumberVector(_local_5[int(_local_18[1]) - 1],_local_12.uvts_);
                    _local_12.uvts_.push(0);
                } else {
                    _local_12.uvts_.push(0,0,0);
                }
            }
            _local_14 = 0;
            while(_local_14 < _local_8.length) {
                _local_19 = _local_8[_local_14];
                _local_20 = _local_10[_local_14];
                _local_21 = new Vector.<int>();
                _local_22 = 0;
                while(_local_22 < _local_19.length) {
                    _local_21.push(_local_7[_local_19[_local_22]]);
                    _local_22++;
                }
                _local_12.faces_.push(new ModelFace3D(_local_12,_local_21,_local_20 == null || _local_20.substr(0,5) != "Solid"));
                _local_14++;
            }
            _local_12.orderFaces();
            modelLib_[param1] = _local_12;
        }
        
        public static function getModel(param1:String) : Model3D {
            return modelLib_[param1];
        }
        
        public static function getObject3D(param1:String) : Object3D {
            var _local_2:Model3D = modelLib_[param1];
            if(_local_2 == null) {
                return null;
            }
            return new Object3D(_local_2);
        }
        
        public static function getStage3dObject3D(param1:String) : Object3DStage3D {
            var _local_2:Model3D_stage3d = models[param1];
            if(_local_2 == null) {
                return null;
            }
            return new Object3DStage3D(_local_2);
        }
        
        public function toString() : String {
            var _local_1:String = "";
            _local_1 = _local_1 + ("vL(" + this.vL_.length + "): " + this.vL_.join() + "\n");
            _local_1 = _local_1 + ("uvts(" + this.uvts_.length + "): " + this.uvts_.join() + "\n");
            _local_1 = _local_1 + ("faces_(" + this.faces_.length + "): " + this.faces_.join() + "\n");
            return _local_1;
        }
        
        public function orderFaces() : void {
            this.faces_.sort(ModelFace3D.compare);
        }
    }
}
