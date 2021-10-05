({
    createQuote : function (component, event, helper) {
        var oppId = component.get("v.recordId");
        $A.get("e.force:navigateToURL").setParams({"url": '/apex/APTSMD_CreateQuote?id=' + oppId}).fire();
    },
    createAgreement : function(component, event, helper){
        var oppId = component.get("v.recordId");
        $A.get("e.force:navigateToURL").setParams({"url": '/apex/Apttus__OpportunityAgreement?id=' + oppId}).fire(); 
    }
})