package kabam.rotmg.news.model {
    public class DefaultNewsCellVO extends NewsCellVO {
         
        
        public function DefaultNewsCellVO(param1:int) {
            super();
            imageURL = "";
            linkDetail = "https://www.reddit.com/r/RotMG/search?sort=new&restrict_sr=on&q=flair%3AOfficial%2BDeca";
            headline = param1 == 0?"Official Deca Posts on Reddit":"Deca on Reddit";
            startDate = new Date().getTime() - 1000000000;
            endDate = new Date().getTime() + 1000000000;
            networks = ["kabam.com","kongregate","steam","rotmg"];
            linkType = NewsCellLinkType.OPENS_LINK;
            priority = 999999;
            slot = param1;
        }
    }
}
