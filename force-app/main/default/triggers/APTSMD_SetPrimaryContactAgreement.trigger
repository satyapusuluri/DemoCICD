/*
    Created By   : Archil Prajapati
    Creted Date  : 1st Jan 2019
    Description  : Sets Primary Contact On New Agreements Or Updated Agreements Where Primary Contact = NULL
*/

trigger APTSMD_SetPrimaryContactAgreement on Apttus__APTS_Agreement__c (before insert,before update) {
    
    List<id> agreementAccountIds = new List<id>();
    Map<Id,Account> allAccountcontacts;
    List<Contact> matchedContact;
    Map<id,id> primaryContactMap;
    
    //Fetch accountid of the agreement
    for(Apttus__APTS_Agreement__c agmnt : trigger.new){
        if(agmnt.Apttus__Primary_Contact__c == null){
            agreementAccountIds.add(agmnt.Apttus__Account__c);
        }
    }
    
    //get contacts linked to that account
    //it returns result in map format. Map between account and its related contacts. 
    allAccountcontacts = new Map<ID, Account>([Select id,Name,(select Name from Contacts ORDER by APTSMD_Is_Primary_Contact__c DESC) FROM Account]);// Query

    //fetch default primary contact from presales config settings
    APTSMD_Apttus_PreSales_Config_Settings2__c presalesSetting = [select APTSMD_Default_Primary_Contact__c from APTSMD_Apttus_PreSales_Config_Settings2__c];//Query
        
    //set the primary contact id in agreement
    for(Apttus__APTS_Agreement__c agmnt : trigger.new){
        if(agmnt.Apttus__Primary_Contact__c == null && allAccountcontacts.get(agmnt.Apttus__Account__c) != null){
            if(!allAccountcontacts.get(agmnt.Apttus__Account__c).Contacts.isEmpty()){//check if map has contact, then set it
                agmnt.Apttus__Primary_Contact__c = allAccountcontacts.get(agmnt.Apttus__Account__c).Contacts[0].id;
            }else{//else resort to default from presales config setting
                matchedContact = [select id,name from Contact where name =: presalesSetting.APTSMD_Default_Primary_Contact__c Limit 1];
                
                if(!matchedContact.isEmpty()){
                    agmnt.Apttus__Primary_Contact__c = matchedContact[0].id;
                }else{
                    agmnt.Apttus__Primary_Contact__c = '';
                }
            }
        }
    }
}