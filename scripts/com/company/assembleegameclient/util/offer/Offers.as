package com.company.assembleegameclient.util.offer {
    public class Offers {
        
        private static const BEST_DEAL:String = "(Best deal)";
        
        private static const MOST_POPULAR:String = "(Most popular)";
         
        
        public var tok:String;
        
        public var exp:String;
        
        public var offerList:Vector.<Offer>;
        
        public function Offers(param1:XML) {
            super();
            this.tok = param1.Tok;
            this.exp = param1.Exp;
            this.makeOffers(param1);
        }
        
        private function makeOffers(param1:XML) : void {
            this.makeOfferList(param1);
            this.sortOfferList();
            this.defineBonuses();
            this.defineMostPopularTagline();
            this.defineBestDealTagline();
        }
        
        private function makeOfferList(param1:XML) : void {
            var _local_2:XML = null;
            this.offerList = new Vector.<Offer>(0);
            for each(_local_2 in param1.Offer) {
                this.offerList.push(this.makeOffer(_local_2));
            }
        }
        
        private function makeOffer(param1:XML) : Offer {
            var _local_2:String = param1.Id;
            var _local_3:Number = Number(param1.Price);
            var _local_4:int = int(param1.RealmGold);
            var _local_5:String = param1.CheckoutJWT;
            var _local_6:String = param1.Data;
            var _local_7:String = !!param1.hasOwnProperty("Currency")?param1.Currency:null;
            return new Offer(_local_2,_local_3,_local_4,_local_5,_local_6,_local_7);
        }
        
        private function sortOfferList() : void {
            this.offerList.sort(this.sortOffers);
        }
        
        private function defineBonuses() : void {
            var _local_5:int = 0;
            var _local_6:int = 0;
            var _local_7:Number = NaN;
            var _local_8:Number = NaN;
            if(this.offerList.length == 0) {
                return;
            }
            var _local_1:int = this.offerList[0].realmGold_;
            var _local_2:int = this.offerList[0].price_;
            var _local_3:Number = _local_1 / _local_2;
            var _local_4:int = 1;
            while(_local_4 < this.offerList.length) {
                _local_5 = this.offerList[_local_4].realmGold_;
                _local_6 = this.offerList[_local_4].price_;
                _local_7 = _local_6 * _local_3;
                _local_8 = _local_5 - _local_7;
                this.offerList[_local_4].bonus = _local_8 / _local_6;
                _local_4++;
            }
        }
        
        private function sortOffers(param1:Offer, param2:Offer) : int {
            return param1.price_ - param2.price_;
        }
        
        private function defineMostPopularTagline() : void {
            var _local_1:Offer = null;
            for each(_local_1 in this.offerList) {
                if(_local_1.price_ == 10) {
                    _local_1.tagline = MOST_POPULAR;
                }
            }
        }
        
        private function defineBestDealTagline() : void {
            this.offerList[this.offerList.length - 1].tagline = BEST_DEAL;
        }
    }
}
