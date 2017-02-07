package ru.inspirit.net {
    import flash.errors.IllegalOperationError;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.net.URLRequestHeader;
    import flash.net.URLRequestMethod;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.Endian;
    import flash.utils.clearInterval;
    import flash.utils.setTimeout;
    import ru.inspirit.net.events.MultipartURLLoaderEvent;
    
    public class MultipartURLLoader extends EventDispatcher {
        
        public static var BLOCK_SIZE:uint = 64 * 1024;
         
        
        private var _loader:URLLoader;
        
        private var _boundary:String;
        
        private var _variableNames:Array;
        
        private var _fileNames:Array;
        
        private var _variables:Dictionary;
        
        private var _files:Dictionary;
        
        private var _async:Boolean = false;
        
        private var _path:String;
        
        private var _data:ByteArray;
        
        private var _prepared:Boolean = false;
        
        private var asyncWriteTimeoutId:Number;
        
        private var asyncFilePointer:uint = 0;
        
        private var totalFilesSize:uint = 0;
        
        private var writtenBytes:uint = 0;
        
        public var requestHeaders:Array;
        
        public function MultipartURLLoader() {
            super();
            this._fileNames = new Array();
            this._files = new Dictionary();
            this._variableNames = new Array();
            this._variables = new Dictionary();
            this._loader = new URLLoader();
            this.requestHeaders = new Array();
        }
        
        public function load(param1:String, param2:Boolean = false) : void {
            if(param1 == null || param1 == "") {
                throw new IllegalOperationError("You cant load without specifing PATH");
            }
            this._path = param1;
            this._async = param2;
            if(this._async) {
                if(!this._prepared) {
                    this.constructPostDataAsync();
                } else {
                    this.doSend();
                }
            } else {
                this._data = this.constructPostData();
                this.doSend();
            }
        }
        
        public function startLoad() : void {
            if(this._path == null || this._path == "" || this._async == false) {
                throw new IllegalOperationError("You can use this method only if loading asynchronous.");
            }
            if(!this._prepared && this._async) {
                throw new IllegalOperationError("You should prepare data before sending when using asynchronous.");
            }
            this.doSend();
        }
        
        public function prepareData() : void {
            this.constructPostDataAsync();
        }
        
        public function close() : void {
            try {
                this._loader.close();
                return;
            }
            catch(e:Error) {
                return;
            }
        }
        
        public function addVariable(param1:String, param2:Object = "") : void {
            if(this._variableNames.indexOf(param1) == -1) {
                this._variableNames.push(param1);
            }
            this._variables[param1] = param2;
            this._prepared = false;
        }
        
        public function addFile(param1:ByteArray, param2:String, param3:String = "Filedata", param4:String = "application/octet-stream") : void {
            var _local_5:FilePart = null;
            if(this._fileNames.indexOf(param2) == -1) {
                this._fileNames.push(param2);
                this._files[param2] = new FilePart(param1,param2,param3,param4);
                this.totalFilesSize = this.totalFilesSize + param1.length;
            } else {
                _local_5 = this._files[param2] as MultipartURLLoader;
                this.totalFilesSize = this.totalFilesSize - _local_5.fileContent.length;
                _local_5.fileContent = param1;
                _local_5.fileName = param2;
                _local_5.dataField = param3;
                _local_5.contentType = param4;
                this.totalFilesSize = this.totalFilesSize + param1.length;
            }
            this._prepared = false;
        }
        
        public function clearVariables() : void {
            this._variableNames = new Array();
            this._variables = new Dictionary();
            this._prepared = false;
        }
        
        public function clearFiles() : void {
            var _local_1:String = null;
            for each(_local_1 in this._fileNames) {
                (this._files[_local_1] as MultipartURLLoader).dispose();
            }
            this._fileNames = new Array();
            this._files = new Dictionary();
            this.totalFilesSize = 0;
            this._prepared = false;
        }
        
        public function dispose() : void {
            clearInterval(this.asyncWriteTimeoutId);
            this.removeListener();
            this.close();
            this._loader = null;
            this._boundary = null;
            this._variableNames = null;
            this._variables = null;
            this._fileNames = null;
            this._files = null;
            this.requestHeaders = null;
            this._data = null;
        }
        
        public function getBoundary() : String {
            var _local_1:int = 0;
            if(this._boundary == null) {
                this._boundary = "";
                _local_1 = 0;
                while(_local_1 < 32) {
                    this._boundary = this._boundary + String.fromCharCode(int(97 + Math.random() * 25));
                    _local_1++;
                }
            }
            return this._boundary;
        }
        
        public function get ASYNC() : Boolean {
            return this._async;
        }
        
        public function get PREPARED() : Boolean {
            return this._prepared;
        }
        
        public function get dataFormat() : String {
            return this._loader.dataFormat;
        }
        
        public function set dataFormat(param1:String) : void {
            if(param1 != URLLoaderDataFormat.BINARY && param1 != URLLoaderDataFormat.TEXT && param1 != URLLoaderDataFormat.VARIABLES) {
                throw new IllegalOperationError("Illegal URLLoader Data Format");
            }
            this._loader.dataFormat = param1;
        }
        
        public function get loader() : URLLoader {
            return this._loader;
        }
        
        private function doSend() : void {
            var _local_1:URLRequest = new URLRequest();
            _local_1.url = this._path;
            _local_1.method = URLRequestMethod.POST;
            _local_1.data = this._data;
            _local_1.requestHeaders.push(new URLRequestHeader("Content-type","multipart/form-data; boundary=" + this.getBoundary()));
            if(this.requestHeaders.length) {
                _local_1.requestHeaders = _local_1.requestHeaders.concat(this.requestHeaders);
            }
            this.addListener();
            this._loader.load(_local_1);
        }
        
        private function constructPostDataAsync() : void {
            clearInterval(this.asyncWriteTimeoutId);
            this._data = new ByteArray();
            this._data.endian = Endian.BIG_ENDIAN;
            this._data = this.constructVariablesPart(this._data);
            this.asyncFilePointer = 0;
            this.writtenBytes = 0;
            this._prepared = false;
            if(this._fileNames.length) {
                this.nextAsyncLoop();
            } else {
                this._data = this.closeDataObject(this._data);
                this._prepared = true;
                dispatchEvent(new MultipartURLLoaderEvent(MultipartURLLoaderEvent.DATA_PREPARE_COMPLETE));
            }
        }
        
        private function constructPostData() : ByteArray {
            var _local_1:ByteArray = new ByteArray();
            _local_1.endian = Endian.BIG_ENDIAN;
            _local_1 = this.constructVariablesPart(_local_1);
            _local_1 = this.constructFilesPart(_local_1);
            _local_1 = this.closeDataObject(_local_1);
            return _local_1;
        }
        
        private function closeDataObject(param1:ByteArray) : ByteArray {
            param1 = this.BOUNDARY(param1);
            param1 = this.DOUBLEDASH(param1);
            return param1;
        }
        
        private function constructVariablesPart(param1:ByteArray) : ByteArray {
            var _local_2:uint = 0;
            var _local_3:* = null;
            var _local_4:String = null;
            for each(_local_4 in this._variableNames) {
                param1 = this.BOUNDARY(param1);
                param1 = this.LINEBREAK(param1);
                _local_3 = "Content-Disposition: form-data; name=\"" + _local_4 + "\"";
                _local_2 = 0;
                while(_local_2 < _local_3.length) {
                    param1.writeByte(_local_3.charCodeAt(_local_2));
                    _local_2++;
                }
                param1 = this.LINEBREAK(param1);
                param1 = this.LINEBREAK(param1);
                param1.writeUTFBytes(this._variables[_local_4]);
                param1 = this.LINEBREAK(param1);
            }
            return param1;
        }
        
        private function constructFilesPart(param1:ByteArray) : ByteArray {
            var _local_2:uint = 0;
            var _local_3:String = null;
            var _local_4:String = null;
            if(this._fileNames.length) {
                for each(_local_4 in this._fileNames) {
                    param1 = this.getFilePartHeader(param1,this._files[_local_4] as MultipartURLLoader);
                    param1 = this.getFilePartData(param1,this._files[_local_4] as MultipartURLLoader);
                    if(_local_2 != this._fileNames.length - 1) {
                        param1 = this.LINEBREAK(param1);
                    }
                    _local_2++;
                }
                param1 = this.closeFilePartsData(param1);
            }
            return param1;
        }
        
        private function closeFilePartsData(param1:ByteArray) : ByteArray {
            var _local_2:uint = 0;
            var _local_3:String = null;
            param1 = this.LINEBREAK(param1);
            param1 = this.BOUNDARY(param1);
            param1 = this.LINEBREAK(param1);
            _local_3 = "Content-Disposition: form-data; name=\"Upload\"";
            _local_2 = 0;
            while(_local_2 < _local_3.length) {
                param1.writeByte(_local_3.charCodeAt(_local_2));
                _local_2++;
            }
            param1 = this.LINEBREAK(param1);
            param1 = this.LINEBREAK(param1);
            _local_3 = "Submit Query";
            _local_2 = 0;
            while(_local_2 < _local_3.length) {
                param1.writeByte(_local_3.charCodeAt(_local_2));
                _local_2++;
            }
            param1 = this.LINEBREAK(param1);
            return param1;
        }
        
        private function getFilePartHeader(param1:ByteArray, param2:FilePart) : ByteArray {
            var _local_3:uint = 0;
            var _local_4:* = null;
            param1 = this.BOUNDARY(param1);
            param1 = this.LINEBREAK(param1);
            _local_4 = "Content-Disposition: form-data; name=\"Filename\"";
            _local_3 = 0;
            while(_local_3 < _local_4.length) {
                param1.writeByte(_local_4.charCodeAt(_local_3));
                _local_3++;
            }
            param1 = this.LINEBREAK(param1);
            param1 = this.LINEBREAK(param1);
            param1.writeUTFBytes(param2.fileName);
            param1 = this.LINEBREAK(param1);
            param1 = this.BOUNDARY(param1);
            param1 = this.LINEBREAK(param1);
            _local_4 = "Content-Disposition: form-data; name=\"" + param2.dataField + "\"; filename=\"";
            _local_3 = 0;
            while(_local_3 < _local_4.length) {
                param1.writeByte(_local_4.charCodeAt(_local_3));
                _local_3++;
            }
            param1.writeUTFBytes(param2.fileName);
            param1 = this.QUOTATIONMARK(param1);
            param1 = this.LINEBREAK(param1);
            _local_4 = "Content-Type: " + param2.contentType;
            _local_3 = 0;
            while(_local_3 < _local_4.length) {
                param1.writeByte(_local_4.charCodeAt(_local_3));
                _local_3++;
            }
            param1 = this.LINEBREAK(param1);
            param1 = this.LINEBREAK(param1);
            return param1;
        }
        
        private function getFilePartData(param1:ByteArray, param2:FilePart) : ByteArray {
            param1.writeBytes(param2.fileContent,0,param2.fileContent.length);
            return param1;
        }
        
        private function onProgress(param1:ProgressEvent) : void {
            dispatchEvent(param1);
        }
        
        private function onComplete(param1:Event) : void {
            this.removeListener();
            dispatchEvent(param1);
        }
        
        private function onIOError(param1:IOErrorEvent) : void {
            this.removeListener();
            dispatchEvent(param1);
        }
        
        private function onSecurityError(param1:SecurityErrorEvent) : void {
            this.removeListener();
            dispatchEvent(param1);
        }
        
        private function onHTTPStatus(param1:HTTPStatusEvent) : void {
            dispatchEvent(param1);
        }
        
        private function addListener() : void {
            this._loader.addEventListener(Event.COMPLETE,this.onComplete,false,0,false);
            this._loader.addEventListener(ProgressEvent.PROGRESS,this.onProgress,false,0,false);
            this._loader.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError,false,0,false);
            this._loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.onHTTPStatus,false,0,false);
            this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError,false,0,false);
        }
        
        private function removeListener() : void {
            this._loader.removeEventListener(Event.COMPLETE,this.onComplete);
            this._loader.removeEventListener(ProgressEvent.PROGRESS,this.onProgress);
            this._loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
            this._loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS,this.onHTTPStatus);
            this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
        }
        
        private function BOUNDARY(param1:ByteArray) : ByteArray {
            var _local_2:int = this.getBoundary().length;
            param1 = this.DOUBLEDASH(param1);
            var _local_3:int = 0;
            while(_local_3 < _local_2) {
                param1.writeByte(this._boundary.charCodeAt(_local_3));
                _local_3++;
            }
            return param1;
        }
        
        private function LINEBREAK(param1:ByteArray) : ByteArray {
            param1.writeShort(3338);
            return param1;
        }
        
        private function QUOTATIONMARK(param1:ByteArray) : ByteArray {
            param1.writeByte(34);
            return param1;
        }
        
        private function DOUBLEDASH(param1:ByteArray) : ByteArray {
            param1.writeShort(11565);
            return param1;
        }
        
        private function nextAsyncLoop() : void {
            var _local_1:FilePart = null;
            if(this.asyncFilePointer < this._fileNames.length) {
                _local_1 = this._files[this._fileNames[this.asyncFilePointer]] as MultipartURLLoader;
                this._data = this.getFilePartHeader(this._data,_local_1);
                this.asyncWriteTimeoutId = setTimeout(this.writeChunkLoop,10,this._data,_local_1.fileContent,0);
                this.asyncFilePointer++;
            } else {
                this._data = this.closeFilePartsData(this._data);
                this._data = this.closeDataObject(this._data);
                this._prepared = true;
                dispatchEvent(new MultipartURLLoaderEvent(MultipartURLLoaderEvent.DATA_PREPARE_PROGRESS,this.totalFilesSize,this.totalFilesSize));
                dispatchEvent(new MultipartURLLoaderEvent(MultipartURLLoaderEvent.DATA_PREPARE_COMPLETE));
            }
        }
        
        private function writeChunkLoop(param1:ByteArray, param2:ByteArray, param3:uint = 0) : void {
            var _local_4:uint = Math.min(BLOCK_SIZE,param2.length - param3);
            param1.writeBytes(param2,param3,_local_4);
            if(_local_4 < BLOCK_SIZE || param3 + _local_4 >= param2.length) {
                param1 = this.LINEBREAK(param1);
                this.nextAsyncLoop();
                return;
            }
            param3 = param3 + _local_4;
            this.writtenBytes = this.writtenBytes + _local_4;
            if(this.writtenBytes % BLOCK_SIZE * 2 == 0) {
                dispatchEvent(new MultipartURLLoaderEvent(MultipartURLLoaderEvent.DATA_PREPARE_PROGRESS,this.writtenBytes,this.totalFilesSize));
            }
            this.asyncWriteTimeoutId = setTimeout(this.writeChunkLoop,10,param1,param2,param3);
        }
    }
}

import flash.utils.ByteArray;

class FilePart {
     
    
    public var fileContent:ByteArray;
    
    public var fileName:String;
    
    public var dataField:String;
    
    public var contentType:String;
    
    function FilePart(param1:ByteArray, param2:String, param3:String = "Filedata", param4:String = "application/octet-stream") {
        super();
        this.fileContent = param1;
        this.fileName = param2;
        this.dataField = param3;
        this.contentType = param4;
    }
    
    public function dispose() : void {
        this.fileContent = null;
        this.fileName = null;
        this.dataField = null;
        this.contentType = null;
    }
}
