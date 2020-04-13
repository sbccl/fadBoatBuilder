({
    doInit : function(component, event, helper) {
        var action = component.get("c.getInventoryRecordType");
        action.setCallback(this, function(response){
            if(response.getState() == "SUCCESS"){
            console.log('???'+ response.getReturnValue());
            component.set("v.recordTypLst", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);

       var getYear = component.get("c.getInventoryYear");
        getYear.setCallback(this, function(response){
            if(response.getState() == "SUCCESS"){
                console.log("From server: " + JSON.stringify(response.getReturnValue()));
              //  component.set("v.fetchData", response.getReturnValue());
                component.set("v.year",response.getReturnValue());


            }

         });
         $A.enqueueAction(getYear);
         
         var getModle = component.get("c.getInventoryModle");
         getModle.setParams({
            "Type" :  component.find("select").get("v.value"),

            "Make" :  component.find("MakeId").get("v.value")
        });
         getModle.setCallback(this, function(response){
             if(response.getState() == "SUCCESS"){
                 //console.log("From server: " + JSON.stringify(response.getReturnValue()));
                 component.set("v.modle",response.getReturnValue());
 
 
             }
 
          });
          $A.enqueueAction(getModle);

          var getMake = component.get("c.getInventoryMake");
          getMake.setParams({

            "Type" :  component.find("select").get("v.value")
        });
          getMake.setCallback(this, function(response){
              if(response.getState() == "SUCCESS"){
                  console.log("Make: " + JSON.stringify(response.getReturnValue()));
                  component.set("v.Make",response.getReturnValue());
  
  
              }
  
           });
           $A.enqueueAction(getMake);

           var getBT = component.get("c.getInventoryBoatType");
           getBT.setParams({
        
            "Type" :  component.find("select").get("v.value")
        });
           getBT.setCallback(this, function(response){
               if(response.getState() == "SUCCESS"){
                   component.set("v.BoatType",response.getReturnValue());
   
   
               }
   
            });
            $A.enqueueAction(getBT);


                var action =  component.get("c.getInventoryStage");
                action.setParams({
        
                    "Type" :  component.find("select").get("v.value")
                });
                
                action.setCallback(this, function(response){
                    if(response.getState() == "SUCCESS"){
                        console.log("v.Status"+ JSON.stringify(response.getReturnValue()));
                        component.set("v.Status",response.getReturnValue());
                    }
        
                });
                $A.enqueueAction(action);

            var action = component.get("c.fetchInventory");
            action.setParams({
                "Type" : component.find("select").get("v.value"),
                "stage" : component.find("stage").get("v.value"),
                "year"  :  component.find("Year").get("v.value"),
                "Modle" :  component.find("Modle").get("v.value"),
                "BoatType" :  component.find("BoatType").get("v.value")

                });
                component.set("v.myBoolean",true);
            action.setCallback(this, function(response){
                var state = response.getState();
                if(response.getState() == "SUCCESS"){
                    var result = response.getReturnValue(); 
                   // alert("From server: " + JSON.stringify(response.getReturnValue()));
                    component.set("v.fetchData", response.getReturnValue());
    
                }
                 
    
            });
            $A.enqueueAction(action);
         
         

    },

    getStatusValues : function(component, event, helper) {
        var action =  component.get("c.getInventoryStage");
        component.set("v.spinner", true); 
        action.setParams({

            "Type" :  component.find("select").get("v.value")
        });
        
        action.setCallback(this, function(response){
            if(response.getState() == "SUCCESS"){
                component.set("v.spinner", false);
                console.log("v.Status"+ JSON.stringify(response.getReturnValue()));
                component.set("v.Status",response.getReturnValue());
            }

        });
        $A.enqueueAction(action);

        var getYear = component.get("c.getInventoryYear");
        component.set("v.spinner", true); 
        getYear.setParams({

            "Type" :  component.find("select").get("v.value")
        });
        getYear.setCallback(this, function(response){
            if(response.getState() == "SUCCESS"){
                component.set("v.spinner", false);
                console.log("From server: " + JSON.stringify(response.getReturnValue()));
                component.set("v.year",response.getReturnValue());


            }

         });
         $A.enqueueAction(getYear);

         var getModleforType = component.get("c.getInventoryMake");
         component.set("v.spinner", true); 
         getModleforType.setParams({

            "Type" :  component.find("select").get("v.value")
        });
        getModleforType.setCallback(this, function(response){
            if(response.getState() == "SUCCESS"){
                component.set("v.spinner", false);
                console.log("From server: Make " + JSON.stringify(response.getReturnValue()));
                component.set("v.Make",response.getReturnValue());


            }

         });
         $A.enqueueAction(getModleforType);
         var getBT = component.get("c.getInventoryBoatType");
         getBT.setParams({
      
          "Type" :  component.find("select").get("v.value")
      });
         getBT.setCallback(this, function(response){
             if(response.getState() == "SUCCESS"){
                 component.set("v.BoatType",response.getReturnValue());
 
 
             }
 
          });
          $A.enqueueAction(getBT);
         helper.getAllData(component, event, helper);



    },
    getModleValues : function(component, event, helper) {
        var getMake = component.get("c.getInventoryModle");
        getMake.setParams({
            "Type" :  component.find("select").get("v.value"),

            "Make" :  component.find("MakeId").get("v.value")
        });
        getMake.setCallback(this, function(response){
            if(response.getState() == "SUCCESS"){
                console.log("From server modle : " + JSON.stringify(response.getReturnValue()));
                component.set("v.modle",response.getReturnValue());


            }

         });
         $A.enqueueAction(getMake);
         helper.getAllData(component, event, helper);

    },
    getdata : function(component, event, helper) {
        var action = component.get("c.fetchInventory");
        component.set("v.spinner", true); 
        action.setParams({
            "Type" : component.find("select").get("v.value"),
            "stage" : component.find("stage").get("v.value"),
            "year"  :  component.find("Year").get("v.value"),
            "Modle" :  component.find("Modle").get("v.value"),
           "BoatType" :  component.find("BoatType").get("v.value"),
            "Make" :  component.find("MakeId").get("v.value"),
            "StoreLoc" :  component.find("storeId").get("v.value")

            });
            component.set("v.myBoolean",true);
        action.setCallback(this, function(response){
            var state = response.getState();
            if(response.getState() == "SUCCESS"){
                var result = response.getReturnValue(); 
                component.set("v.spinner", false);
               // alert("From server: " + JSON.stringify(response.getReturnValue()));
                component.set("v.fetchData", response.getReturnValue());
                if(result == 0 ){
                    component.set("v.Message",true);
                }else {
                    component.set("v.Message", false);
                }

            }
             

        });
        $A.enqueueAction(action);

    },

   
    redirect : function(component, event, helper) {
        var recId =  event.target.getAttribute("title");
        window.open('https://stws-dev-org-dev-ed.lightning.force.com/lightning/r/BOATBUILDING__Inventory__c/'+recId+'/view', '_Blank');
      // window.open('/'+recId, '_self');
    },
    getSearchData : function(component, event, helper) {
    
        var action = component.get("c.SerchingOfInventory");
        var strValue =  component.get('v.value');
        component.set("v.spinner", true); 
        if(typeof strValue != "undefined"  && strValue.length > 3){
        action.setParams({
            
            "strSearch" : component.get('v.value')
            
            });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(response.getState() == "SUCCESS"){
                component.set("v.spinner", false);
                var strresult = response.getReturnValue()[0];
               // alert('$#$#$#'+JSON.stringify(response.getReturnValue()));
                component.set("v.fetchData", response.getReturnValue()[0]);
                if(strresult == 0 ){
                    component.set("v.Message",true);
                }else {
                    component.set("v.Message", false);
                }
                

            }
             

        });
        $A.enqueueAction(action);
    }else{
        helper.getAllData(component, event, helper);


    }
       

    },
     // function automatic called by aura:waiting event  
     showSpinner: function(component, event, helper) {
        // make Spinner attribute true for displaying loading spinner 
        component.set("v.spinner", true); 
    },
     
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hiding loading spinner    
        component.set("v.spinner", false);
    }
   
    


})