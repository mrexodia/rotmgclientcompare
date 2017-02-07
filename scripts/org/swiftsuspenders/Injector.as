package org.swiftsuspenders {
    import avmplus.DescribeTypeJSON;
    import flash.events.EventDispatcher;
    import flash.system.ApplicationDomain;
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    import org.swiftsuspenders.dependencyproviders.ClassProvider;
    import org.swiftsuspenders.dependencyproviders.DependencyProvider;
    import org.swiftsuspenders.dependencyproviders.LocalOnlyProvider;
    import org.swiftsuspenders.dependencyproviders.SoftDependencyProvider;
    import org.swiftsuspenders.errors.InjectorInterfaceConstructionError;
    import org.swiftsuspenders.errors.InjectorMissingMappingError;
    import org.swiftsuspenders.mapping.InjectionMapping;
    import org.swiftsuspenders.mapping.MappingEvent;
    import org.swiftsuspenders.reflection.DescribeTypeJSONReflector;
    import org.swiftsuspenders.reflection.DescribeTypeReflector;
    import org.swiftsuspenders.reflection.Reflector;
    import org.swiftsuspenders.typedescriptions.ConstructorInjectionPoint;
    import org.swiftsuspenders.typedescriptions.InjectionPoint;
    import org.swiftsuspenders.typedescriptions.PreDestroyInjectionPoint;
    import org.swiftsuspenders.typedescriptions.TypeDescription;
    import org.swiftsuspenders.utils.SsInternal;
    import org.swiftsuspenders.utils.TypeDescriptor;
    
    use namespace SsInternal;
    
    public class Injector extends EventDispatcher {
        
        private static var INJECTION_POINTS_CACHE:Dictionary = new Dictionary(true);
         
        
        private var _parentInjector:Injector;
        
        private var _applicationDomain:ApplicationDomain;
        
        private var _classDescriptor:TypeDescriptor;
        
        private var _mappings:Dictionary;
        
        private var _mappingsInProcess:Dictionary;
        
        private var _defaultProviders:Dictionary;
        
        private var _managedObjects:Dictionary;
        
        private var _reflector:Reflector;
        
        SsInternal const providerMappings:Dictionary = new Dictionary();
        
        public function Injector() {
            super();
            this._mappings = new Dictionary();
            this._mappingsInProcess = new Dictionary();
            this._defaultProviders = new Dictionary();
            this._managedObjects = new Dictionary();
            try {
                this._reflector = !!DescribeTypeJSON.available?new DescribeTypeJSONReflector():new DescribeTypeReflector();
            }
            catch(e:Error) {
                _reflector = new DescribeTypeReflector();
            }
            this._classDescriptor = new TypeDescriptor(this._reflector,INJECTION_POINTS_CACHE);
            this._applicationDomain = ApplicationDomain.currentDomain;
        }
        
        SsInternal static function purgeInjectionPointsCache() : void {
            INJECTION_POINTS_CACHE = new Dictionary(true);
        }
        
        public function map(param1:Class, param2:String = "") : InjectionMapping {
            var _local_3:String = getQualifiedClassName(param1) + "|" + param2;
            return this._mappings[_local_3] || this.createMapping(param1,param2,_local_3);
        }
        
        public function unmap(param1:Class, param2:String = "") : void {
            var _local_3:String = getQualifiedClassName(param1) + "|" + param2;
            var _local_4:InjectionMapping = this._mappings[_local_3];
            if(_local_4 && _local_4.isSealed) {
                throw new InjectorError("Can\'t unmap a sealed mapping");
            }
            if(!_local_4) {
                throw new InjectorError("Error while removing an injector mapping: " + "No mapping defined for dependency " + _local_3);
            }
            _local_4.getProvider().destroy();
            delete this._mappings[_local_3];
            delete this.providerMappings[_local_3];
            hasEventListener(MappingEvent.POST_MAPPING_REMOVE) && dispatchEvent(new MappingEvent(MappingEvent.POST_MAPPING_REMOVE,param1,param2,null));
        }
        
        public function satisfies(param1:Class, param2:String = "") : Boolean {
            return this.getProvider(getQualifiedClassName(param1) + "|" + param2) != null;
        }
        
        public function satisfiesDirectly(param1:Class, param2:String = "") : Boolean {
            return this.providerMappings[getQualifiedClassName(param1) + "|" + param2] != null;
        }
        
        public function getMapping(param1:Class, param2:String = "") : InjectionMapping {
            var _local_3:String = getQualifiedClassName(param1) + "|" + param2;
            var _local_4:InjectionMapping = this._mappings[_local_3];
            if(!_local_4) {
                throw new InjectorMissingMappingError("Error while retrieving an injector mapping: " + "No mapping defined for dependency " + _local_3);
            }
            return _local_4;
        }
        
        public function injectInto(param1:Object) : void {
            var _local_2:Class = this._reflector.getClass(param1);
            this.applyInjectionPoints(param1,_local_2,this._classDescriptor.getDescription(_local_2));
        }
        
        public function getInstance(param1:Class, param2:String = "", param3:Class = null) : * {
            var _local_4:String = null;
            var _local_6:ConstructorInjectionPoint = null;
            _local_4 = getQualifiedClassName(param1) + "|" + param2;
            var _local_5:DependencyProvider = this.getProvider(_local_4,false);
            if(_local_5) {
                _local_6 = this._classDescriptor.getDescription(param1).ctor;
                return _local_5.apply(param3,this,!!_local_6?_local_6.injectParameters:null);
            }
            if(param2) {
                throw new InjectorMissingMappingError("No mapping found for request " + _local_4 + ". getInstance only creates an unmapped instance if no name is given.");
            }
            return this.instantiateUnmapped(param1);
        }
        
        public function destroyInstance(param1:Object) : void {
            var _local_2:Class = null;
            if(!param1) {
                return;
            }
            _local_2 = this._reflector.getClass(param1);
            var _local_3:TypeDescription = this.getTypeDescription(_local_2);
            var _local_4:PreDestroyInjectionPoint = _local_3.preDestroyMethods;
            while(_local_4) {
                _local_4.applyInjection(param1,_local_2,this);
                _local_4 = PreDestroyInjectionPoint(_local_4.next);
            }
        }
        
        public function teardown() : void {
            var _local_1:InjectionMapping = null;
            var _local_2:Object = null;
            for each(_local_1 in this._mappings) {
                _local_1.getProvider().destroy();
            }
            for each(_local_2 in this._managedObjects) {
                this.destroyInstance(_local_2);
            }
            this._mappings = new Dictionary();
            this._mappingsInProcess = new Dictionary();
            this._defaultProviders = new Dictionary();
            this._managedObjects = new Dictionary();
        }
        
        public function createChildInjector(param1:ApplicationDomain = null) : Injector {
            var _local_2:Injector = new Injector();
            _local_2.applicationDomain = param1 || this.applicationDomain;
            _local_2.parentInjector = this;
            return _local_2;
        }
        
        public function set parentInjector(param1:Injector) : void {
            this._parentInjector = param1;
        }
        
        public function get parentInjector() : Injector {
            return this._parentInjector;
        }
        
        public function set applicationDomain(param1:ApplicationDomain) : void {
            this._applicationDomain = param1 || ApplicationDomain.currentDomain;
        }
        
        public function get applicationDomain() : ApplicationDomain {
            return this._applicationDomain;
        }
        
        public function addTypeDescription(param1:Class, param2:TypeDescription) : void {
            this._classDescriptor.addDescription(param1,param2);
        }
        
        public function getTypeDescription(param1:Class) : TypeDescription {
            return this._reflector.describeInjections(param1);
        }
        
        SsInternal function instantiateUnmapped(param1:Class) : Object {
            var _local_2:TypeDescription = this._classDescriptor.getDescription(param1);
            if(!_local_2.ctor) {
                throw new InjectorInterfaceConstructionError("Can\'t instantiate interface " + getQualifiedClassName(param1));
            }
            var _local_3:* = _local_2.ctor.createInstance(param1,this);
            hasEventListener(InjectionEvent.POST_INSTANTIATE) && dispatchEvent(new InjectionEvent(InjectionEvent.POST_INSTANTIATE,_local_3,param1));
            this.applyInjectionPoints(_local_3,param1,_local_2);
            return _local_3;
        }
        
        SsInternal function getProvider(param1:String, param2:Boolean = true) : DependencyProvider {
            var _local_3:DependencyProvider = null;
            var _local_5:DependencyProvider = null;
            var _local_4:Injector = this;
            while(_local_4) {
                _local_5 = _local_4.providerMappings[param1];
                if(_local_5) {
                    if(_local_5 is SoftDependencyProvider) {
                        _local_3 = _local_5;
                        _local_4 = _local_4.parentInjector;
                        continue;
                    }
                    if(_local_5 is LocalOnlyProvider && _local_4 !== this) {
                        _local_4 = _local_4.parentInjector;
                        continue;
                    }
                    return _local_5;
                }
                _local_4 = _local_4.parentInjector;
            }
            if(_local_3) {
                return _local_3;
            }
            return !!param2?this.getDefaultProvider(param1):null;
        }
        
        SsInternal function getDefaultProvider(param1:String) : DependencyProvider {
            var parts:Array = null;
            var definition:Object = null;
            var mappingId:String = param1;
            if(mappingId === "String|") {
                return null;
            }
            parts = mappingId.split("|");
            var name:String = parts.pop();
            if(name.length !== 0) {
                return null;
            }
            var typeName:String = parts.pop();
            try {
                definition = !!this._applicationDomain.hasDefinition(typeName)?this._applicationDomain.getDefinition(typeName):getDefinitionByName(typeName);
            }
            catch(e:Error) {
                return null;
            }
            if(!definition || !(definition is Class)) {
                return null;
            }
            var type:Class = Class(definition);
            var description:TypeDescription = this._classDescriptor.getDescription(type);
            if(!description.ctor) {
                return null;
            }
            return this._defaultProviders[type] = this._defaultProviders[type] || new ClassProvider(type);
        }
        
        private function createMapping(param1:Class, param2:String, param3:String) : InjectionMapping {
            var _local_4:InjectionMapping = null;
            if(this._mappingsInProcess[param3]) {
                throw new InjectorError("Can\'t change a mapping from inside a listener to it\'s creation event");
            }
            this._mappingsInProcess[param3] = true;
            hasEventListener(MappingEvent.PRE_MAPPING_CREATE) && dispatchEvent(new MappingEvent(MappingEvent.PRE_MAPPING_CREATE,param1,param2,null));
            _local_4 = new InjectionMapping(this,param1,param2,param3);
            this._mappings[param3] = _local_4;
            var _local_5:Object = _local_4.seal();
            hasEventListener(MappingEvent.POST_MAPPING_CREATE) && dispatchEvent(new MappingEvent(MappingEvent.POST_MAPPING_CREATE,param1,param2,_local_4));
            delete this._mappingsInProcess[param3];
            _local_4.unseal(_local_5);
            return _local_4;
        }
        
        private function applyInjectionPoints(param1:Object, param2:Class, param3:TypeDescription) : void {
            var _local_4:InjectionPoint = param3.injectionPoints;
            hasEventListener(InjectionEvent.PRE_CONSTRUCT) && dispatchEvent(new InjectionEvent(InjectionEvent.PRE_CONSTRUCT,param1,param2));
            while(_local_4) {
                _local_4.applyInjection(param1,param2,this);
                _local_4 = _local_4.next;
            }
            if(param3.preDestroyMethods) {
                this._managedObjects[param1] = param1;
            }
            hasEventListener(InjectionEvent.POST_CONSTRUCT) && dispatchEvent(new InjectionEvent(InjectionEvent.POST_CONSTRUCT,param1,param2));
        }
    }
}
