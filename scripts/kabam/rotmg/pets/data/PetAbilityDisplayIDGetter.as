package kabam.rotmg.pets.data {
    import com.company.assembleegameclient.objects.ObjectLibrary;
    
    public class PetAbilityDisplayIDGetter {
         
        
        public function PetAbilityDisplayIDGetter() {
            super();
        }
        
        public function getID(param1:int) : String {
            return String(ObjectLibrary.getPetDataXMLByType(param1).@id);
        }
    }
}
