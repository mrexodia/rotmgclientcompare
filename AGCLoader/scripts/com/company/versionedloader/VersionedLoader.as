package com.company.versionedloader {
    import com.company.logo.AnimatedLogo;
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.TimerEvent;
    import flash.net.LocalConnection;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.URLVariables;
    import flash.system.Security;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.utils.Timer;
    
    public class VersionedLoader extends Sprite {
        
        private static const ALLOWED_DOMAINS:Array = ["testing.realmofthemadgod.com","www.realmofthemadgod.com","realmofthemadgod.appspot.com","realmofthemadgodhrd.appspot.com","rotmgtesting.appspot.com","rotmghrdtesting.appspot.com","realmtesting2.appspot.com","localhost"];
        
        private static const DEFAULT_BYTES_TOTAL:int = 1 << 20;
         
        
        private var domain_:String;
        
        private var swfPrefix_:String;
        
        private var logo_:AnimatedLogo;
        
        private var status_:TextField;
        
        private var urlLoader_:URLLoader;
        
        private var loader_:Loader;
        
        private var game_:Sprite;
        
        private var protocol_:String = "http:";
        
        public function VersionedLoader(param1:String) {
            var _local_3:String = null;
            var _local_4:Object = null;
            super();
            this.logo_ = new AnimatedLogo();
            addChild(this.logo_);
            var _local_2:LocalConnection = new LocalConnection();
            this.domain_ = "www.realmofthemadgod.com";
            for each(_local_3 in ALLOWED_DOMAINS) {
                if(_local_2.domain == _local_3) {
                    this.domain_ = _local_3;
                }
            }
            this.swfPrefix_ = param1;
            Security.allowDomain("*");
            _local_4 = LoaderInfo(this.loaderInfo).parameters;
            if(_local_4.rotmg_loader_protocol == "https:") {
                this.protocol_ = _local_4.rotmg_loader_protocol;
            }
            if(_local_4.rotmg_loader_port != null) {
                this.domain_ = this.domain_ + _local_4.rotmg_loader_port;
            }
            this.status_ = new TextField();
            this.status_.selectable = false;
            var _local_5:TextFormat = new TextFormat();
            _local_5.size = 10;
            _local_5.color = 4286545791;
            this.status_.defaultTextFormat = _local_5;
            this.status_.width = 800;
            this.status_.y = 360;
            this.setStatus("initializing");
            this.urlLoader_ = new URLLoader();
            this.urlLoader_.addEventListener(Event.COMPLETE,this.onVersionComplete);
            this.urlLoader_.addEventListener(IOErrorEvent.IO_ERROR,this.onVersionIOError);
            this.urlLoader_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onVersionSecurityError);
            this.loadVersion();
        }
        
        private function setStatus(param1:String) : void {
            addChild(this.status_);
            this.status_.htmlText = "<p align=\"center\">" + param1 + "</p>";
        }
        
        private function removeStatus() : void {
            removeChild(this.logo_);
            removeChild(this.status_);
        }
        
        private function loadVersion() : void {
            var _local_1:String = "";
            if(this.domain_ == "www.realmofthemadgod.com") {
                _local_1 = "realmofthemadgodhrd.appspot.com";
            } else if(this.domain_ == "testing.realmofthemadgod.com") {
                _local_1 = "rotmghrdtesting.appspot.com";
            } else {
                _local_1 = this.domain_;
            }
            var _local_2:* = this.protocol_ + "//" + _local_1 + "/version.txt";
            var _local_3:URLRequest = new URLRequest(_local_2);
            _local_3.data = new URLVariables("time=" + Number(new Date().getTime()));
            this.urlLoader_.load(_local_3);
            this.setStatus("loading version");
        }
        
        private function onVersionComplete(param1:Event) : void {
            var _local_2:String = this.urlLoader_.data;
            this.loadSWF(_local_2);
        }
        
        private function onVersionIOError(param1:IOErrorEvent) : void {
            this.retryLoadVersion();
        }
        
        private function onVersionSecurityError(param1:SecurityErrorEvent) : void {
            this.retryLoadVersion();
        }
        
        private function retryLoadVersion() : void {
            this.setStatus("version loading error, retrying...");
            var _local_1:Timer = new Timer(1000,1);
            _local_1.addEventListener(TimerEvent.TIMER_COMPLETE,this.onWaitDone);
        }
        
        private function onWaitDone(param1:TimerEvent) : void {
            this.loadVersion();
        }
        
        private function loadSWF(param1:String) : void {
            var _local_2:* = this.protocol_ + "//" + this.domain_ + "/" + this.swfPrefix_ + param1 + ".swf";
            var _local_3:URLRequest = new URLRequest(_local_2);
            this.loader_ = new Loader();
            this.loader_.load(_local_3);
            this.loader_.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onSWFProgress);
            this.loader_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onSWFComplete);
            this.loader_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onSWFIOError);
            this.setStatus("loading SWF");
        }
        
        private function onSWFProgress(param1:ProgressEvent) : void {
            var _local_2:Number = param1.bytesTotal == 0?Number(DEFAULT_BYTES_TOTAL):Number(param1.bytesTotal);
            var _local_3:Number = Math.min(1,param1.bytesLoaded / _local_2);
            this.setStatus(int(_local_3 * 100).toString() + "%");
        }
        
        private function onSWFComplete(param1:Event) : void {
            this.removeLoaderListeners();
            this.runSWF();
        }
        
        private function onSWFIOError(param1:Event) : void {
            this.removeLoaderListeners();
            this.restart();
        }
        
        private function removeLoaderListeners() : void {
            this.loader_.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onSWFProgress);
            this.loader_.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onSWFComplete);
            this.loader_.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onSWFIOError);
        }
        
        private function runSWF() : void {
            this.removeStatus();
            this.game_ = Sprite(this.loader_.content);
            this.game_.addEventListener(Event.COMPLETE,this.onGameComplete);
            addChild(this.game_);
        }
        
        private function onGameComplete(param1:Event) : void {
            this.restart();
        }
        
        private function restart() : void {
            if(this.game_ != null) {
                this.game_.removeEventListener(Event.COMPLETE,this.onGameComplete);
                removeChild(this.game_);
                this.game_ = null;
            }
            if(this.loader_ != null) {
                this.loader_.unloadAndStop(true);
                this.loader_ = null;
            }
            this.loadVersion();
        }
    }
}
