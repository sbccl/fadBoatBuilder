({
    doInit: function( component, event, helper ) {
        var userName = $A.get("$SObjectType.CurrentUser.Id");
        helper.showSpinner(component,event,helper);
       
        //console.log('userName', JSON.stringify(userName));
        //console.log('recorddddddId', component.get("v.recordId"));
        //console.log('recordddddd', JSON.parse(JSON.stringify(component.get("v.woRecordData"))));
         
        if(userName === "0056F000006aoMiQAI"){
            component.set("v.isDevOrg",true);
        }
        
        var action = component.get("c.getPageLayoutFields");
        action.setCallback(this, function(response) {
            //console.log("v.layoutSections", response.getReturnValue() );
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                component.set("v.layoutSections", response.getReturnValue() );
                helper.hideSpinner(component,event,helper);
                //helper.getWOJobs(component, event, helper);
                
               
                
            }
            else if (state === "INCOMPLETE") {
                component.set("v.progress", 100);
                helper.hideSpinner(component,event,helper);
            } else if (state === "ERROR") {
                
                //var errors = response.getErrors();
                //console.log( errors );
                helper.hideSpinner(component,event,helper);
            }
        });
        
        $A.enqueueAction(action);
        
        //helper.taxCalculation(component, event, helper); 
        
        //console.log('after before Button',component.get("v.woJobsWithWJL"));
        
    },
    onRender : function(component, event, helper){
        
    },
    recordLoaded : function(component, event, helper){
        
        component.set("v.recordType",component.get("v.targetRecord.recordTypeInfo.name"));
        component.set("v.recordTypeId",component.get("v.targetRecord.recordTypeInfo.id"));
      
        //console.log("recorddddAttribute",JSON.stringify(component.get("v.targetRecord")));
        if(component.get("v.recordType") == 'Work Request'){
           // component.set("v.toggleSpinner", false);   
        }else{
            
            helper.getWOJobs(component, event, helper);
        }
       
    },
    handleSectionToggle: function (cmp, event) {
        var openSections = event.getParam('openSections');
        
        if (openSections.length === 0) {
            cmp.set('v.activeSectionsMessage', "All sections are closed");
        } else {
            cmp.set('v.activeSectionsMessage', "Open sections: " + openSections.join(', '));
        }
    },
    
    handleSuccess : function(component, event, helper) {
        component.set("v.toggleSpinner2", true);    
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The Work Order has been updated. Saving the Job details now.",
            "type": "success"
        });
        //toastEvent.fire();

        
        var woJobs = component.get("v.woJobsWithWJL");
        var finalDataArray = [];
        if(typeof woJobs != "undefined"){
            for(var i = 0; i < woJobs.length; i++){
                finalDataArray.push(woJobs[i].objWOJ.finalJobData);
            }
        }
      
       // console.log('finalDataArray', JSON.stringify(finalDataArray));
        var action =  component.get("c.saveWOJob");
        action.setParams({
            "woDataJSON" : JSON.stringify(finalDataArray)
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            //console.log('state');
            if(state === "SUCCESS"){
                
                
                
                //console.log('responsedata', response.getReturnValue());
                
                //helper.getWOJobs(component, event, helper);
                component.set("v.toggleSpinner2", true);  
                component.set("v.woJobsWithWJL",response.getReturnValue());
                helper.taxCalculation(component, event, helper); 
                //alert('hi this is before setting false');
                var toastEventJobSuccess = $A.get("e.force:showToast");
                toastEventJobSuccess.setParams({
                    "title": "Success!",
                    "message": "The Work Order is  saved successfully!",
                    "type": "success"
                });
                toastEventJobSuccess.fire(); 
                
                component.set("v.toggleSpinner2", false);    
                //component.set("v.toggleSpinner2", false);

               
            }
            else{
                var toastEventJobError = $A.get("e.force:showToast");
                toastEventJobError.stopPropagation();
                toastEventJobError.setParams({
                    "title": "Error!",
                    "message": "There was an error",
                    "type": "error"
                });
                toastEventJobError.fire();
                console.log('responsedataERROR', response.getError());
                component.set("v.toggleSpinner2", false);
            }
        });
        $A.enqueueAction(action);
        component.set("v.toggleSpinner2", true); 
        //component.set("v.toggleSpinner2", false);
        
    },
    handleLoad : function(component, event, helper) {
        component.set("v.toggleSpinner", false);   
    },
    handleSubmit : function(component, event, helper) {
        component.set("v.toggleSpinner2", true);
        //helper.showSpinner(component,event,helper);
    },
    addNewJob : function(component, event, helper){
        component.set("v.toggleSpinner2", true);
        helper.getNewWOJ(component, event, helper);
        
    },
    handleRemove : function(component, event, helper) {
        var self = this;  // safe reference
        
        var index = event.target.dataset.index;
        var value = event.target.dataset.value;
        //console.log(index +'----'+value);
        helper.removeJobsHelper(component, index, helper);
        if(typeof value != "undefined"){
            var deleteAction = component.get("c.deleteJobFromWO");
            deleteAction.setParams({
                "woId" : value
            });
            deleteAction.setCallback(this, function(response){
               
                
                var state = response.getState();
                
                if(state === "SUCCESS"){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "The Job has been deleted from Work Order!",
                        "type": "success"
                    });
                    toastEvent.fire();
            
                }else{
                    component.set("v.toggleSpinner2", false);
                }
            });
            $A.enqueueAction(deleteAction);
        }
       
        //need to write delete lead code here
    },
    saveJobs : function(component, event, helper){
        component.set("v.toggleSpinner2", true);
        //console.log('stringify data', JSON.stringify(component.get("v.woJobsWithWJL")));
        //helper.taxCalculation(component, event, helper); 
        //component.set("v.toggleSpinner2", false);
        var appEvent = $A.get("e.c:SaveWorkOrderJobs");
        appEvent.fire();
        component.find("woRecordEditForm").submit();
        ////console.log('storeLocation2', document.getElementsByName('BOATBUILDING__Store_Location__c')[0].value);
    },
    calculateAllJobs : function(component, event, helper){
        
        //console.log('calculateAllJobs method called'); 
        helper.calculateTotalJobs(component, event, helper);
    },
    uplaodFinished : function(component, event, helper){
        var childCmp = component.find("photoCmp")
        //console.log('photoCMP4photoCMP4', childCmp);
        childCmp.refreshChild();
    },
    recalculateTax : function(component, event, helper){
        if(component.get("v.woRecordData.RecordType.Name") != 'Warranty Work Order'){
           
            helper.taxCalculation(component, event, helper); 
            component.set("v.toggleSpinner2", false);
        }
    }
    
})