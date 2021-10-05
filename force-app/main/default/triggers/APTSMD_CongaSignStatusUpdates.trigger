trigger APTSMD_CongaSignStatusUpdates on APXT_CongaSign__Transaction__c (after update) {
    if(Trigger.New.size() > 1){
        return;
    }
    
    APXT_CongaSign__Transaction__c congaSignTransaction = Trigger.New[0];
    APXT_CongaSign__Transaction__c congaSignTransactionOld = Trigger.Old[0];
    
    if(congaSignTransaction.Parent_a0C__c != null) {
        if(congaSignTransaction.APXT_CongaSign__Status__c != congaSignTransactionOld.APXT_CongaSign__Status__c
            && congaSignTransaction.APXT_CongaSign__Status__c == 'SENT'){
            update new Apttus__APTS_Agreement__c(Id = congaSignTransaction.Parent_a0C__c, Apttus__Status__c = 'Other Party Signatures', Apttus__Status_Category__c = 'In Signatures');
        }
        
        if(congaSignTransaction.APXT_CongaSign__Status__c != congaSignTransactionOld.APXT_CongaSign__Status__c
            && congaSignTransaction.APXT_CongaSign__Status__c == 'COMPLETE'){
            update new Apttus__APTS_Agreement__c(Id = congaSignTransaction.Parent_a0C__c, Apttus__Status__c = 'Fully Signed', Apttus__Status_Category__c = 'In Signatures');
            APTSMD_CloneClausesHandler.cloneAgreementClauses(congaSignTransaction.Parent_a0C__c);
        }
    }else if(congaSignTransaction.Parent_a1X__c != null) {
        if(congaSignTransaction.APXT_CongaSign__Status__c != congaSignTransactionOld.APXT_CongaSign__Status__c
            && congaSignTransaction.APXT_CongaSign__Status__c == 'COMPLETE'){
            update new Apttus_Proposal__Proposal__c(Id = congaSignTransaction.Parent_a1X__c, Apttus_Proposal__Approval_Stage__c = 'Presented');
        }
    }   
}