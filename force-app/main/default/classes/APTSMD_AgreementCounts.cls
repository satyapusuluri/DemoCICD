public class APTSMD_AgreementCounts {
    @AuraEnabled
    public static Integer getActionRequiredCount(){
        List<Apttus__APTS_Agreement__c> agreementList =  [SELECT id
                       FROM Apttus__APTS_Agreement__c
                       WHERE ownerid =: userinfo.getUserId()
                       AND Apttus__Status__c='Other Party Review'];
        return agreementList.size();
    }
    @AuraEnabled
    public static Integer getNeedsAttentionCount(){
        List<Apttus__APTS_Agreement__c> agreementList =  [SELECT id
                       FROM Apttus__APTS_Agreement__c
                       WHERE APTSMD_Days_Until_Contract_Expiration__c <= 30
                       And APTSMD_Days_Until_Contract_Expiration__c > 0];
        
        if(!agreementList.isEmpty()){
            return agreementList.size();
        }
        
        if(UserInfo.getUserName() != 'master-htm@mdo.com'){
            Datetime orgCreationDate = [Select CreatedDate from Organization].CreatedDate;
            List<Apttus__APTS_Agreement__c> agreementListToUpdate =  [SELECT id
                           FROM Apttus__APTS_Agreement__c
                           WHERE APTSMD_Days_Until_Contract_Expiration__c <= 30
                           And CreatedDate = :orgCreationDate
                           And Name like '%MSA ABC Corporation%'
                           Order BY CreatedDate Desc Limit 10];
            for(Apttus__APTS_Agreement__c agreement : agreementListToUpdate){
                agreement.Apttus__Contract_End_Date__c = Date.today() + 25;
            }
            update agreementListToUpdate;
            
            return agreementListToUpdate.size();
		}

        return 0;
    }
    @AuraEnabled
    public static String getListViewDetail(String objectName,String viewName){
        return APTSMD_ListViewIdGeneric.getListViewDetail(objectName,viewName);
    }
}