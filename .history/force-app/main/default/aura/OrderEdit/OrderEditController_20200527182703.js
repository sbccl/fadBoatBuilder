({
    doinit: function(component, event, helper) {
        var action = component.get("c.getOrderDetail");
       
        action.setParams({"recordId" : component.get("v.attrRecordId")});
        action.setCallback(this, function(response) {
            console.log(response.getReturnValue());
            component.set("v.vendorRecordId", response.getReturnValue().BOATBUILDING__Vendor_Name__c);
        });
        $A.enqueueAction(action);
        var action2 = component.get("c.getLineItemDetail");
        action2.setParams({"recordOrderId" : component.get("v.attrRecordId")});
        action2.setCallback(this, function(res) {
            console.log('>>>>>: '+JSON.stringify(res.getReturnValue()));
            component.set("v.listlineItem", res.getReturnValue());
        });
        $A.enqueueAction(action2);
        helper.getStoreLocationAndCount(component);
    },
    handleSuccess: function(component, event, helper) {
        var payload = event.getParams().response;
        var type = component.get("v.clickType")
        console.log('>>>>>>: '+type);
        if(type == 'AddIWithB') {
            console.log("addToInventoryWithBackOrder");
            component.set('v.showSpinner', true);
            var objListItem = component.get("v.listlineItem");
            objListItem.forEach(element => {
                element.backOrderQuantity = element.quantity - element.received;
            });
                console.log('>>>>>:addtoinventory '+JSON.stringify(objListItem));
                var action= component.get("c.addToInventoryWithBackOrder");
                //send objListItem as a parameter to addToInventoryWithBackOrder method
                action.setParams({
                "strOrderId": component.get("v.attrRecordId"),
                "lstlistItem" : objListItem
            });
            action.setCallback(this, function(response) {
                component.set("v.clickType", "");
                component.set('v.showSpinner', false);
                console.log('>>>>>methodCalling '+ response.getReturnValue());
                if(response.getReturnValue().includes("Error")) {
                    var errorEvent = $A.get("e.force:showToast");
                    errorEvent.setParams({
                        "type" : "error",
                        "title": "Error!",
                        "message": response.getReturnValue()
                    });
                    errorEvent.fire();
                } else {
                    var urlEvent = $A.get("e.force:navigateToURL");
                    var urlStr = "/"+component.get("v.attrRecordId");
                    urlEvent.setParams({
                        "url": urlStr
                    });
                    urlEvent.fire();
                }
            });
            $A.enqueueAction(action);
        }
        else if(type == 'AddI') {
            console.log("addInventory");
            component.set('v.showSpinner', true);
            var objListItem = component.get("v.listlineItem");
            console.log('>>>>>:addtoinventory '+JSON.stringify(objListItem));
            debugger;
            var action= component.get("c.addInventory");
            //send objListItem as a parameter to addInventory method
            action.setParams({
                "strOrderId": component.get("v.attrRecordId"),
                "lstlistItem" : objListItem
            });
            
            action.setCallback(this, function(response) {
                component.set("v.clickType", "");
                console.log('>>>>>methodCalling '+ response.getReturnValue());
                var state = response.getState();
                if(state == 'ERROR') {
                    var errors = response.getError();
                    var message = 'Unknown error'; // Default error message
                    // Retrieve the error message sent by the server
                    if (errors && Array.isArray(errors) && errors.length > 0) {
                        message = errors[0].message;
                    }
                    // Display the message
                    console.error(message);
                    var errorEvent = $A.get("e.force:showToast");
                    errorEvent.setParams({
                        "type" : "error",
                        "title": "Error!",
                        "message": message
                    });
                    errorEvent.fire();
                } else {
                    var urlEvent = $A.get("e.force:navigateToURL");
                    var urlStr = "/"+component.get("v.attrRecordId");
                    urlEvent.setParams({
                        "url": urlStr
                    });
                    urlEvent.fire();
                    var errorEvent = $A.get("e.force:showToast");
                    errorEvent.setParams({ 
                        "type" : "success",
                        "title": "Success!",
                        "message": "Inventory Successfully  Added"
                    });
                    errorEvent.fire(); 
                }
            });
            
            
            $A.enqueueAction(action);
        }else {
            if(payload.id != undefined && payload.id != null) {
                var SuccessEvent = $A.get("e.force:showToast");
                SuccessEvent.setParams({ 
                    "type" : "success",
                    "title": "Success!",
                    "message": "Order Status Successfully Updated"
                });
                SuccessEvent.fire(); 
            }
            else {
                var errorEvent = $A.get("e.force:showToast");
                errorEvent.setParams({
                    "type" : "error",
                    "title": "Error!",
                    "message": response.getReturnValue()
                });
                errorEvent.fire();
            }
        }
     },
    addToInventoryWithBackOrderjs : function(component,event,helper){
        component.set("v.clickType", "AddIWithB");
        component.find("recordEditForm").submit();
    },
    //JS for Add to inventory method component.set('v.showSpinner', true);
    addToInventoryjs:function(component,event,helper){
        
        component.set("v.clickType", "AddI");
        component.find("recordEditForm").submit();
    },
    
    calculate: function(component,event,helper){
        var objListItem = component.get("v.listlineItem");
        console.log('>>>>>: '+objListItem.length);
        
        var quantity= 0;
        var cost = 0;
        var total = 0;
        var totalReceived=0;
        var backOrderQuantity = 0;
        var backOrderAmount = 0;
        var amount= 0;
        objListItem.forEach(objVal => {
            if(objVal.received <= objVal.quantity){
            if(objVal.received !='' ){
            totalReceived += parseInt(objVal.received);
        }
                            backOrderQuantity += objVal.quantity-objVal.received;
                            amount += objVal.received *objVal.cost;
                            backOrderAmount += (objVal.quantity-objVal.received)*objVal.cost;
                quantity += objVal.quantity;
                cost += objVal.cost;
                total += objVal.quantity*objVal.cost; 
            }
            
            
        });
        var shipping = 0.00;
        if(component.find("shippingCharge").get("v.value") != '' && component.find("shippingCharge").get("v.value") != null)
            shipping = parseFloat(component.find("shippingCharge").get("v.value"));
        console.log('>>>>>shipping'+shipping);
        var discount = 0.00;
        if(component.find("discount").get("v.value") != '' && component.find("discount").get("v.value") != null)
            discount = parseFloat(component.find("discount").get("v.value"));
        console.log('>>>>>discount'+discount);
        console.log('>>>>>amount'+amount);
        var grandTotal = parseFloat(amount) + parseFloat(shipping) - parseFloat(discount);
        
        component.set("v.orderGrandTotal",grandTotal);
        component.set("v.totalOfReceived",totalReceived);
        component.set("v.totalOfAmount",amount);
        component.set("v.totalOfBackOrderQuantity",backOrderQuantity);
        component.set("v.totalOfBackOrderAmount",backOrderAmount);
        console.log('>>'+quantity );
        component.set("v.totalOfTotal",total);
        component.set("v.totalOfQuantity",quantity);
        component.set("v.totalOfCost",cost);
    },
    onLoadCalculation: function(component,event,helper){
        var objListItem = component.get("v.listlineItem");
        console.log('>>>>>: '+objListItem.length);
        
        var quantity= 0;
        var cost = 0;
        var total = 0;
        var totalReceived= 0;
        var backOrderQuantity = 0;
        var backOrderAmount = 0;
        var amount= 0;   
        
        objListItem.forEach(objVal => {
            if(objVal.received !=''){
            totalReceived += parseInt(objVal.received);
        }
                            backOrderQuantity += objVal.quantity-objVal.received;
                            amount += objVal.received *objVal.cost;
                            backOrderAmount += (objVal.quantity-objVal.received)*objVal.cost;
            quantity += objVal.quantity;
            cost += objVal.cost;
            total += objVal.quantity*objVal.cost; 
        });
        var shipping = component.find("shippingCharge").get("v.value");
        console.log('>>>>>shipping'+shipping);
        var discount = component.find("discount").get("v.value");

        var grandTotal = amount + shipping -discount ;

        component.set("v.orderGrandTotal",grandTotal);


        component.set("v.totalOfBackOrderQuantity",backOrderQuantity);
        component.set("v.totalOfBackOrderAmount",backOrderAmount);
        console.log('>>'+quantity );
        component.set("v.totalOfTotal",total);
        component.set("v.totalOfQuantity",quantity);
        component.set("v.totalOfCost",cost);

    },
    save : function(component,event,helper) {
        component.find("recordEditForm").submit();
    },
    send: function(component,event,helper){
        var orderId = event.getSource().get('v.name');  
        var vfUrl = '/apex/BOATBUILDING__SendOrderDetailPage?Id='+orderId;
        window.parent.location =vfUrl;
        
    },
    print: function(component,event,helper){
        var orderId = event.getSource().get('v.name'); 
        var btnStatus= event.getSource().get('v.title'); 
        var vfUrl = '/apex/BOATBUILDING__Order_As_PDF_Exampleskp?Id='+orderId +'&btnStatus='+btnStatus;
        window.parent.location =vfUrl;
        
    },
    ReceiveAll : function(component,event,helper) {
        var objListItem = component.get("v.listlineItem");
        console.log('>>>>>:addtoinventory '+JSON.stringify(objListItem));
        var recId = component.get("v.attrRecordId");
    },
    receiveAllPartAtLocation : function(component,event,helper) {
        component.set('v.ShowStoreLocation',true);         
    }
})