package com.company.assembleegameclient.map.serialization {
    import com.company.assembleegameclient.map.GroundLibrary;
    import com.company.assembleegameclient.map.Map;
    import com.company.assembleegameclient.objects.BasicObject;
    import com.company.assembleegameclient.objects.GameObject;
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import com.company.util.IntPoint;
    import com.hurlant.util.Base64;
    import flash.utils.ByteArray;
    import kabam.lib.json.JsonParser;
    import kabam.rotmg.core.StaticInjectorContext;
    
    public class MapDecoder {
         
        
        public function MapDecoder() {
            super();
        }
        
        private static function get json() : JsonParser {
            return StaticInjectorContext.getInjector().getInstance(JsonParser);
        }
        
        public static function decodeMap(param1:String) : Map {
            var _local_2:Object = json.parse(param1);
            var _local_3:Map = new Map(null);
            _local_3.setProps(_local_2["width"],_local_2["height"],_local_2["name"],_local_2["back"],false,false);
            _local_3.initialize();
            writeMapInternal(_local_2,_local_3,0,0);
            return _local_3;
        }
        
        public static function writeMap(param1:String, param2:Map, param3:int, param4:int) : void {
            var _local_5:Object = json.parse(param1);
            writeMapInternal(_local_5,param2,param3,param4);
        }
        
        public static function getSize(param1:String) : IntPoint {
            var _local_2:Object = json.parse(param1);
            return new IntPoint(_local_2["width"],_local_2["height"]);
        }
        
        private static function writeMapInternal(param1:Object, param2:Map, param3:int, param4:int) : void {
            var _local_7:int = 0;
            var _local_8:int = 0;
            var _local_9:Object = null;
            var _local_10:Array = null;
            var _local_11:int = 0;
            var _local_12:Object = null;
            var _local_13:GameObject = null;
            var _local_5:ByteArray = Base64.decodeToByteArray(param1["data"]);
            _local_5.uncompress();
            var _local_6:Array = param1["dict"];
            _local_7 = param4;
            while(_local_7 < param4 + param1["height"]) {
                _local_8 = param3;
                while(_local_8 < param3 + param1["width"]) {
                    _local_9 = _local_6[_local_5.readShort()];
                    if(!(_local_8 < 0 || _local_8 >= param2.width_ || _local_7 < 0 || _local_7 >= param2.height_)) {
                        if(_local_9.hasOwnProperty("ground")) {
                            _local_11 = GroundLibrary.idToType_[_local_9["ground"]];
                            param2.setGroundTile(_local_8,_local_7,_local_11);
                        }
                        _local_10 = _local_9["objs"];
                        if(_local_10 != null) {
                            for each(_local_12 in _local_10) {
                                _local_13 = getGameObject(_local_12);
                                _local_13.objectId_ = BasicObject.getNextFakeObjectId();
                                param2.addObj(_local_13,_local_8 + 0.5,_local_7 + 0.5);
                            }
                        }
                    }
                    _local_8++;
                }
                _local_7++;
            }
        }
        
        public static function getGameObject(param1:Object) : GameObject {
            var _local_2:int = ObjectLibrary.idToType_[param1["id"]];
            var _local_3:XML = ObjectLibrary.xmlLibrary_[_local_2];
            var _local_4:GameObject = ObjectLibrary.getObjectFromType(_local_2);
            _local_4.size_ = !!param1.hasOwnProperty("size")?int(param1["size"]):int(_local_4.props_.getSize());
            return _local_4;
        }
    }
}
