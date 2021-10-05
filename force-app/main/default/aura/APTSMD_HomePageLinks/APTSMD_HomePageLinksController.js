({
    doInit : function(component, event, helper) {
        helper.getListViewDetail(component, 'Apttus__APTS_Agreement__c','APTSMD_My_Agreements','myAgreementsList');               
        helper.getListViewDetail(component, 'Apttus__APTS_Template__c','Clauses','clausesList');               
	},
	createNDA: function (component, event, helper) {
        $A.get("e.force:navigateToURL").setParams({"url": '/apex/APTSMD_startWizard?type=NDA Wizard'}).fire();
    },
    createMSA: function (component, event, helper) {
        $A.get("e.force:navigateToURL").setParams({"url": '/apex/APTSMD_startWizard?type=MSA Wizard'}).fire();
    },
    createACW: function (component, event, helper) {
        $A.get("e.force:navigateToURL").setParams({"url": '/apex/APTSMD_startWizard?type=Agreement Creation Wizard'}).fire();
    },
    openPortal: function (component, event, helper) {
        $A.get("e.force:navigateToURL").setParams({"url": '/apex/APTSMD_RedirectToContractPortal'}).fire();
    },
    goToOfflineImport: function(component, event, helper) {
        $A.get("e.force:navigateToURL").setParams({"url": '/apex/Apttus__OfflineAgreement'}).fire();
    }, 
    gotoMyAgreements: function(component, event, helper) {       
        var listId = component.get("v.myAgreementsList");
        $A.get("e.force:navigateToURL").setParams({"url": '/lightning/o/Apttus__APTS_Agreement__c/list?filterName='+listId}).fire();
    } ,
    gotoClauses: function(component, event, helper) {
        var listId = component.get("v.clausesList");
        $A.get("e.force:navigateToURL").setParams({"url": '/lightning/o/Apttus__APTS_Template__c/list?filterName='+listId}).fire();
    } 
})