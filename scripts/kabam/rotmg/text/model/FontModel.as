package kabam.rotmg.text.model {
    import flash.text.Font;
    import flash.text.TextField;
    import flash.text.TextFormat;
    
    public class FontModel {
        
        public static const MyriadPro:Class = FontModel_MyriadPro;
        
        public static const MyriadPro_Bold:Class = FontModel_MyriadPro_Bold;
         
        
        private var fontInfo:FontInfo;
        
        public function FontModel() {
            super();
            Font.registerFont(MyriadPro);
            Font.registerFont(MyriadPro_Bold);
            var _local_1:Font = new MyriadPro();
            this.fontInfo = new FontInfo();
            this.fontInfo.setName(_local_1.fontName);
        }
        
        public function getFont() : FontInfo {
            return this.fontInfo;
        }
        
        public function apply(param1:TextField, param2:int, param3:uint, param4:Boolean, param5:Boolean = false) : TextFormat {
            var _local_6:TextFormat = param1.defaultTextFormat;
            _local_6.size = param2;
            _local_6.color = param3;
            _local_6.font = this.getFont().getName();
            _local_6.bold = param4;
            if(param5) {
                _local_6.align = "center";
            }
            param1.defaultTextFormat = _local_6;
            param1.setTextFormat(_local_6);
            return _local_6;
        }
        
        public function getFormat(param1:TextField, param2:int, param3:uint, param4:Boolean) : TextFormat {
            var _local_5:TextFormat = param1.defaultTextFormat;
            _local_5.size = param2;
            _local_5.color = param3;
            _local_5.font = this.getFont().getName();
            _local_5.bold = param4;
            return _local_5;
        }
    }
}
