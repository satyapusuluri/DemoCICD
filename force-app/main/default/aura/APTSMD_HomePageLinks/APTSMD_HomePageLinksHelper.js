({
	getListViewDetail: function(component, objectName , viewName,compId) {        
        var action = component.get("c.getListViewDetail");
        action.setParams({
        	"objectName": objectName,
            "viewName": viewName
        });
        action.setCallback(this, function(response) {
        	var state = response.getState();            
        	if (state === "SUCCESS") {
        		component.set("v."+compId, response.getReturnValue());                
        	}
        });
        $A.enqueueAction(action);
    }
})