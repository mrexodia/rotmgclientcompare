package com.hurlant.crypto.symmetric {
    import com.hurlant.util.Memory;
    import flash.utils.ByteArray;
    
    public class ECBMode implements IMode, ICipher {
         
        
        private var key:ISymmetricKey;
        
        private var padding:IPad;
        
        public function ECBMode(param1:ISymmetricKey, param2:IPad = null) {
            super();
            this.key = param1;
            if(param2 == null) {
                param2 = new PKCS5(param1.getBlockSize());
            } else {
                param2.setBlockSize(param1.getBlockSize());
            }
            this.padding = param2;
        }
        
        public function getBlockSize() : uint {
            return this.key.getBlockSize();
        }
        
        public function encrypt(param1:ByteArray) : void {
            this.padding.pad(param1);
            param1.position = 0;
            var _local_2:uint = this.key.getBlockSize();
            var _local_3:ByteArray = new ByteArray();
            var _local_4:ByteArray = new ByteArray();
            var _local_5:uint = 0;
            while(_local_5 < param1.length) {
                _local_3.length = 0;
                param1.readBytes(_local_3,0,_local_2);
                this.key.encrypt(_local_3);
                _local_4.writeBytes(_local_3);
                _local_5 = _local_5 + _local_2;
            }
            param1.length = 0;
            param1.writeBytes(_local_4);
        }
        
        public function decrypt(param1:ByteArray) : void {
            param1.position = 0;
            var _local_2:uint = this.key.getBlockSize();
            if(param1.length % _local_2 != 0) {
                throw new Error("ECB mode cipher length must be a multiple of blocksize " + _local_2);
            }
            var _local_3:ByteArray = new ByteArray();
            var _local_4:ByteArray = new ByteArray();
            var _local_5:uint = 0;
            while(_local_5 < param1.length) {
                _local_3.length = 0;
                param1.readBytes(_local_3,0,_local_2);
                this.key.decrypt(_local_3);
                _local_4.writeBytes(_local_3);
                _local_5 = _local_5 + _local_2;
            }
            this.padding.unpad(_local_4);
            param1.length = 0;
            param1.writeBytes(_local_4);
        }
        
        public function dispose() : void {
            this.key.dispose();
            this.key = null;
            this.padding = null;
            Memory.gc();
        }
        
        public function toString() : String {
            return this.key.toString() + "-ecb";
        }
    }
}
