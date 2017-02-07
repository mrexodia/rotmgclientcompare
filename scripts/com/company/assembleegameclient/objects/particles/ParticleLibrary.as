package com.company.assembleegameclient.objects.particles {
    public class ParticleLibrary {
        
        public static const propsLibrary_:Object = {};
         
        
        public function ParticleLibrary() {
            super();
        }
        
        public static function parseFromXML(param1:XML) : void {
            var _local_2:XML = null;
            for each(_local_2 in param1.Particle) {
                propsLibrary_[_local_2.@id] = new ParticleProperties(_local_2);
            }
        }
    }
}
