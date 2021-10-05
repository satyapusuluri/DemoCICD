({
    doInit : function(component, event, helper){
		var agreementId = component.get("v.recordId");
        helper.getGrandTotal(component, agreementId);
        helper.getAgreement(component, agreementId);
        $A.get('e.force:refreshView').fire();
	},
    mergeDoc : function (component, event, helper){
        var agreementId = component.get("v.recordId");
        $A.get("e.force:navigateToURL").setParams({"url": '/apex/APTSMD_MergeDocumentstoPDF?action=Generate_Agreement&templateType=Agreement&id=' + agreementId}).fire();
    },
    myApprovals : function (component, event, helper){
        var agreementId = component.get("v.recordId");
        $A.get("e.force:navigateToURL").setParams({"url": '/apex/Apttus_Approval__MyApprovals?id=' + agreementId}).fire();
    },
    sendForApprovals : function (component, event, helper){
        var agreementId = component.get("v.recordId");
        $A.get("e.force:navigateToURL").setParams({"url": '/apex/Apttus_Approval__PreviewSubmitApprovals?id=' + agreementId}).fire();
    },
    loadObligation : function (component, event, helper){
        var agreementId = component.get("v.recordId");
        $A.get("e.force:navigateToURL").setParams({"url": '/apex/APTSMD_LoadObligation?id='+ agreementId}).fire();
    },
    inEffectView : function (component, event, helper){
        var agreementId = component.get("v.recordId");
        $A.get("e.force:navigateToURL").setParams({"url": '/apex/Apttus__AgreementInEffectView?id='+ agreementId}).fire();
    },
    agreementClausesAmend : function (component, event, helper){
        var agreementId = component.get("v.recordId");
        $A.get("e.force:navigateToURL").setParams({"url": '/apex/APTSMD_AddFinalClauses?id='+ agreementId}).fire();
    },
    launchAgreementHierarchy : function (component, event, helper){
        var agreementId = component.get("v.recordId");
        $A.get("e.force:navigateToURL").setParams({"url": '/apex/Apttus__AgreementHierarchy?id='+ agreementId}).fire();
    },
    configureProducts : function (component, event, helper) {
        var agreementId = component.get("v.recordId");
        $A.get("e.force:navigateToURL").setParams({"url": '/apex/Apttus_CMConfig__AgreementConfiguration?id=' + agreementId + '&useAdvancedApproval=true&useDealOptimizer=true&method=csrFlow&flow=Default'}).fire();
    }
})