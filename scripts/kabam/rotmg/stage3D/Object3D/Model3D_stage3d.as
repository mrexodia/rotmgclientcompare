package kabam.rotmg.stage3D.Object3D {
    import flash.display3D.Context3D;
    import flash.display3D.VertexBuffer3D;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    
    public class Model3D_stage3d {
         
        
        public var name:String;
        
        public var groups:Vector.<OBJGroup>;
        
        public var vertexBuffer:VertexBuffer3D;
        
        protected var _materials:Dictionary;
        
        protected var _tupleIndex:uint;
        
        protected var _tupleIndices:Dictionary;
        
        protected var _vertices:Vector.<Number>;
        
        public function Model3D_stage3d() {
            super();
            this.groups = new Vector.<OBJGroup>();
            this._materials = new Dictionary();
            this._vertices = new Vector.<Number>();
        }
        
        public function dispose() : void {
            var _local_1:OBJGroup = null;
            for each(_local_1 in this.groups) {
                _local_1.dispose();
            }
            this.groups.length = 0;
            if(this.vertexBuffer !== null) {
                this.vertexBuffer.dispose();
                this.vertexBuffer = null;
            }
            this._vertices.length = 0;
            this._tupleIndex = 0;
            this._tupleIndices = new Dictionary();
        }
        
        public function CreatBuffer(param1:Context3D) : void {
            var _local_2:OBJGroup = null;
            for each(_local_2 in this.groups) {
                if(_local_2._indices.length > 0) {
                    _local_2.indexBuffer = param1.createIndexBuffer(_local_2._indices.length);
                    _local_2.indexBuffer.uploadFromVector(_local_2._indices,0,_local_2._indices.length);
                    _local_2._faces = null;
                }
            }
            this.vertexBuffer = param1.createVertexBuffer(this._vertices.length / 8,8);
            this.vertexBuffer.uploadFromVector(this._vertices,0,this._vertices.length / 8);
        }
        
        public function readBytes(param1:ByteArray) : void {
            var _local_2:Vector.<String> = null;
            var _local_3:OBJGroup = null;
            var _local_10:String = null;
            var _local_11:Array = null;
            var _local_12:String = null;
            var _local_13:int = 0;
            var _local_14:int = 0;
            this.dispose();
            var _local_4:String = "";
            var _local_5:Vector.<Number> = new Vector.<Number>();
            var _local_6:Vector.<Number> = new Vector.<Number>();
            var _local_7:Vector.<Number> = new Vector.<Number>();
            param1.position = 0;
            var _local_8:String = param1.readUTFBytes(param1.bytesAvailable);
            var _local_9:Array = _local_8.split(/[\r\n]+/);
            for each(_local_10 in _local_9) {
                _local_10 = _local_10.replace(/^\s*|\s*$/g,"");
                if(_local_10 == "" || _local_10.charAt(0) === "#") {
                    continue;
                }
                _local_11 = _local_10.split(/\s+/);
                switch(_local_11[0].toLowerCase()) {
                    case "v":
                        _local_5.push(parseFloat(_local_11[1]),parseFloat(_local_11[2]),parseFloat(_local_11[3]));
                        continue;
                    case "vn":
                        _local_6.push(parseFloat(_local_11[1]),parseFloat(_local_11[2]),parseFloat(_local_11[3]));
                        continue;
                    case "vt":
                        _local_7.push(parseFloat(_local_11[1]),1 - parseFloat(_local_11[2]));
                        continue;
                    case "f":
                        _local_2 = new Vector.<String>();
                        for each(_local_12 in _local_11.slice(1)) {
                            _local_2.push(_local_12);
                        }
                        if(_local_3 === null) {
                            _local_3 = new OBJGroup(null,_local_4);
                            this.groups.push(_local_3);
                        }
                        _local_3._faces.push(_local_2);
                        continue;
                    case "g":
                        _local_3 = new OBJGroup(_local_11[1],_local_4);
                        this.groups.push(_local_3);
                        continue;
                    case "o":
                        this.name = _local_11[1];
                        continue;
                    case "mtllib":
                        continue;
                    case "usemtl":
                        _local_4 = _local_11[1];
                        if(_local_3 !== null) {
                            _local_3.materialName = _local_4;
                        }
                        continue;
                    default:
                        continue;
                }
            }
            for each(_local_3 in this.groups) {
                _local_3._indices.length = 0;
                for each(_local_2 in _local_3._faces) {
                    _local_13 = _local_2.length - 1;
                    _local_14 = 1;
                    while(_local_14 < _local_13) {
                        _local_3._indices.push(this.mergeTuple(_local_2[_local_14],_local_5,_local_6,_local_7));
                        _local_3._indices.push(this.mergeTuple(_local_2[0],_local_5,_local_6,_local_7));
                        _local_3._indices.push(this.mergeTuple(_local_2[_local_14 + 1],_local_5,_local_6,_local_7));
                        _local_14++;
                    }
                }
                _local_3._faces = null;
            }
            this._tupleIndex = 0;
            this._tupleIndices = null;
        }
        
        protected function mergeTuple(param1:String, param2:Vector.<Number>, param3:Vector.<Number>, param4:Vector.<Number>) : uint {
            var _local_5:Array = null;
            var _local_6:uint = 0;
            if(this._tupleIndices[param1] !== undefined) {
                return this._tupleIndices[param1];
            }
            _local_5 = param1.split("/");
            _local_6 = parseInt(_local_5[0],10) - 1;
            this._vertices.push(param2[_local_6 * 3 + 0],param2[_local_6 * 3 + 1],param2[_local_6 * 3 + 2]);
            if(_local_5.length > 2 && _local_5[2].length > 0) {
                _local_6 = parseInt(_local_5[2],10) - 1;
                this._vertices.push(param3[_local_6 * 3 + 0],param3[_local_6 * 3 + 1],param3[_local_6 * 3 + 2]);
            } else {
                this._vertices.push(0,0,0);
            }
            if(_local_5.length > 1 && _local_5[1].length > 0) {
                _local_6 = parseInt(_local_5[1],10) - 1;
                this._vertices.push(param4[_local_6 * 2 + 0],param4[_local_6 * 2 + 1]);
            } else {
                this._vertices.push(0,0);
            }
            return this._tupleIndices[param1] = this._tupleIndex++;
        }
    }
}
