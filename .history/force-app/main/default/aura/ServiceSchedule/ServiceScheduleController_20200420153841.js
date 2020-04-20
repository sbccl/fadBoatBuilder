({
    doInit : function(component, event, helper) {
        var actionRec = component.get("c.getrecordType");
        actionRec.setCallback(this, function(response) {
            console.log('recordTypeId ', response.getReturnValue());
            component.set("v.recordTypeId", response.getReturnValue());
        });
        $A.enqueueAction(actionRec);
        
        var action = component.get("c.getUsersSLocation");
        action.setCallback(this, function(response) {
            console.log('sLocation ', response.getReturnValue());
            component.set("v.sLocation", response.getReturnValue());
        });
        $A.enqueueAction(action);
         
    },
    scriptsLoaded : function(component, event, helper) {
        var action = component.get("c.getUserList");
        action.setCallback(this, function(response) {
            console.log('User List Response ', response.getReturnValue());
            component.set("v.lstUser", response.getReturnValue());
            var selectedUser = component.get("v.selectedUser");
            var typeP = component.get("v.typeP");
            var calendarEl = document.getElementById('calendar');
            calendarEl.innerHTML =  '' ;
            helper.loadEvents(component, event, selectedUser, typeP);

            var action2 = component.get("c.getUserListSLGroup");
            action2.setCallback(this, function(response2) {
                console.log('User List Response Group: ', response2.getReturnValue());
                component.set("v.lstUserGrp", response2.getReturnValue());
            });
            $A.enqueueAction(action2);

        });
        $A.enqueueAction(action);
        
    }, 
    openModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.RecordId", "");
        component.set("v.isModalOpen", true); 
     },
    
     closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
        component.find("techId").set("v.value", "");
        component.set("v.RecordId", "");
         var open = component.get("v.isModalOpen");
                if (open == false) {
                   var calendarEl = document.getElementsByClassName('desktop');
                    console.log('>>>>calenIDCheck', calendarEl);
                    calendarEl[0].setAttribute('style', 'overflow: scroll-y;');
                }
            //component.find("sDate").set("v.value", "");
            //component.find("eDate").set("v.value", "");
     },
    
     submitDetails: function(component, event, helper) {
        // Set isModalOpen attribute to false
        //Add your code to call apex method or do some processing
        component.find("techId").set("v.value", "");
        component.set("v.isModalOpen", false);
        component.set("v.RecordId", ""); 
     },
     onRecordSuccess : function(component, event, helper) {
        console.log('Success');
        component.set("v.type", 'Work Order/Jobs');
        var payload = event.getParams().response;
        console.log(payload.id);
        component.set("v.showSpinner", true);
        var action = component.get("c.updateTechOnALlJobs");
        action.setParams({
            strTMId : payload.id
        });
        action.setCallback(this, function(response) {
            component.set("v.showSpinner", false);
            if(response.getReturnValue().includes("Error")) {
                var errorEvent = $A.get("e.force:showToast");
                errorEvent.setParams({
                    "type" : "error",
                    "title": "Error!",
                    "message": response.getReturnValue()
                });
                errorEvent.fire();
            } else {
                var event = $A.get("e.force:showToast");
                event.setParams({
                    "type" : "success",
                    "title": "Success!",
                    "message": "Event created."
                });
                event.fire();
                component.set("v.isModalOpen", false);
                var selectedUser = component.get("v.selectedUser");
                var typeP = component.get("v.typeP");
                var calendarEl = document.getElementById('calendar');
                calendarEl.innerHTML =  '' ;
                helper.loadEvents(component, event, selectedUser, typeP);
            }
        }); 
        $A.enqueueAction(action);
     },
     updateCustomerlookup : function(component, event, helper) { 
        var type = component.find("type").get("v.value");
        if(type == 'Pickup' || type == 'Drop') {
            component.set("v.isPD", true);
        } else {
            component.set("v.isPD", false);
        }
    },
    getRelatedTMDetails : function(component, event, helper) { 
        var selectedUser = component.get("v.selectedUser");
        var typeP = component.get("v.typeP");
        var calendarEl = document.getElementById('calendar');
        calendarEl.innerHTML =  '' ;
        helper.loadEvents(component, event, selectedUser, typeP);
    },
    dateTileValueChange : function(component, event, helper) {
        var dateVal = component.find("sDate").get("v.value");
        console.log("Schedule dateVal ",dateVal);
        var tmpDate = new Date(dateVal);
        console.log("Schedule tmpDate ",tmpDate);
        //component.find("eDate").set("v.value", dateVal);
    }
})