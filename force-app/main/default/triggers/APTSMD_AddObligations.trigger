trigger APTSMD_AddObligations on Apttus__Agreement_Clause__c (after insert) {
    
    List<APTSMD_Master_Obligation__c> masterObligationList = new List<APTSMD_Master_Obligation__c>();
    list<APTSMD_Apttus_PreSales_Config_Settings2__c> presaleConfigList = [SELECT id,APTSMD_Agreement_Clause_Actions__c FROM APTSMD_Apttus_PreSales_Config_Settings2__c WHERE Name='System Properties'];
    //Map<id,id> clauseIdTpTemplateIdMap = new Map<id,id>();
    List<String> clauseName = new List<String>();
    List<Apttus__Obligation__c> obligationListToInsert = new List<Apttus__Obligation__c>(); 
    List<Task> taskListToInsert = new List<Task>();
    
    for(Apttus__Agreement_Clause__c eachAgreementClause : trigger.new){
        //clauseIdTpTemplateIdMap.put(eachAgreementClause.Id,eachAgreementClause.Apttus__Template__c);
        clauseName.add(eachAgreementClause.Apttus__Clause__c);
    }
    
    if(clauseName.size()>0){
        masterObligationList = [SELECT Id,
                                 APTSMD_Obligation_Extract__c,
                                 APTSMD_Obligation_Topic_Description__c,
                                 APTSMD_Obligation_Type__c,
                                 APTSMD_Agreement_RecordType__c,
                                 APTSMD_Active__c
                                 FROM APTSMD_Master_Obligation__c
                                 WHERE APTSMD_Active__c =: True AND APTSMD_Clause_Name__c in :clauseName];
    }
    
    if(masterObligationList.size()>0){
        for(Apttus__Agreement_Clause__c eachAgreementClause : trigger.new){
           if(presaleConfigList[0].APTSMD_Agreement_Clause_Actions__c.contains(eachAgreementClause.Apttus__Action__c)){
                
                integer i = 0;
                for(APTSMD_Master_Obligation__c eachMo : masterObligationList){
                    if(eachAgreementClause.APTSMD_Agreement_Record_Type_Name__c==eachMo.APTSMD_Agreement_RecordType__c){ //thisAgreement.RecordType.Name
                        Apttus__Obligation__c thisObligation = new Apttus__Obligation__c();
                        thisObligation.APTSMD_Agreement__c = eachAgreementClause.Apttus__Agreement__c;
                        thisObligation.APTSMD_Agreement_Clause__c = eachAgreementClause.Id;
                        thisObligation.APTSMD_Master_Obligation__c = eachMo.Id;
                        thisObligation.APTSMD_Template__c = eachAgreementClause.Apttus__Template__c;
                        thisObligation.APTSMD_Obligation_Extract__c = eachMo.APTSMD_Obligation_Extract__c;
                        thisObligation.APTSMD_Obligation_Topic_Description__c = eachMo.APTSMD_Obligation_Topic_Description__c;
                        thisObligation.APTSMD_Obligation_Type__c = eachMo.APTSMD_Obligation_Type__c; 
                        thisObligation.Apttus__StartDate__c = Date.today();
                        thisObligation.Apttus__EndDate__c = Date.today() + 364;
                        if(i==0){
                            thisObligation.APTSMD_Status__c = 'Completed';
                            thisObligation.APTSMD_Date_Completed__c = Date.today() - 1;
                            thisObligation.APTSMD_Due_Date__c = Date.today() + 7;
                        }
                        else if(i==2){
                            thisObligation.APTSMD_Status__c = 'In Progress';
                            thisObligation.APTSMD_Due_Date__c = Date.today() + 3;
                        }
                        else{
                            thisObligation.APTSMD_Status__c = 'Not Started';
                            thisObligation.APTSMD_Due_Date__c = Date.today() + 7;
                        }
                        thisObligation.APTSMD_Active__c = true;
                        thisObligation.APTSMD_Recurrence__c = 'One-Time';
                        
                        obligationListToInsert.add(thisObligation);
                        i++;
                        }
            }
           }
         }
         if(obligationListToInsert.size()>0){
             insert obligationListToInsert;
             if(obligationListToInsert.size()>0){
                 for(Apttus__Obligation__c eachObligation : obligationListToInsert){
                        Task thisTask = new Task();
                        thisTask.WhatId = eachObligation.Id;
                        thisTask.Subject = 'Weekly Checkpoint';
                        thisTask.priority = 'Normal';
                        thisTask.status = 'Not Started';
                        thisTask.description = 'New  Work';
                        thisTask.IsRecurrence = true;
                        thisTask.RecurrenceInterval = 7;
                        thisTask.RecurrenceStartDateOnly = System.today();
                        thisTask.RecurrenceEndDateOnly = System.today()+30;
                        thisTask.RecurrenceType = 'RecursDaily';
                        taskListToInsert.add(thisTask);
                 }
             }
             if(taskListToInsert.size()>0){
                 insert taskListToInsert;
             }
         }
     }
}