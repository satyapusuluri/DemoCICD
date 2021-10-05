trigger AgreementJITTrigger on Apttus__APTS_Agreement__c (after update) {
    if (Trigger.isAfter && Trigger.isUpdate && APTSMD_JITNotificationInput.isFirstTime) {
        APTSMD_JITNotificationInput.isFirstTime = false;
        for(Apttus__APTS_Agreement__c p : Trigger.New) {  
            system.debug('#### got a trigger for ' + p.Name);
            List<APTSMD_JITNotificationInput> inputs = new List<APTSMD_JITNotificationInput>();
            APTSMD_JITNotificationInput input = new APTSMD_JITNotificationInput();
            
            input.objectId = p.Id;
            input.objectName = 'agreement';
            input.lookupResult = p;
            
            inputs.add(input);
            APTSMD_MaxResolveQuery.resolveReferenceQuery(inputs);
        }
    }
}