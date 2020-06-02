({
    searchParts : function(component, event, helper) {
        var searchAction = component.get("c.searchPartsfromInventoryAndParts");
        var vendorId = component.get("v.vendorVal");
        console.log('>>>>vendorVal:'+vendorId);
        var queryTerm = component.find('searchPrtInp').get('v.value');
        searchAction.setParams({
            "searchStr" : queryTerm,
            "vendorVal" : vendorId
        });
        searchAction.setCallback(this, function(response){
                console.log('searchResult',JSON.parse(response.getReturnValue()));
                component.set("v.searchResults", JSON.parse(response.getReturnValue()));
        });

        $A.enqueueAction(searchAction);

    },
    searchPartsforRecent : function(component, event, helper) {
        var searchAction = component.get("c.searchPartsfromInventoryAndParts"); 
        var vendorId = component.get("v.vendorVal");
        console.log('vendorVal>>>>: '+vendorId);
        var queryTerm = 'recentlyViewed'; 
        searchAction.setParams({
            "searchStr" : queryTerm,
            "vendorVal" : vendorId
        });
        searchAction.setCallback(this, function(response){
                console.log('searchResult',JSON.parse(response.getReturnValue()));
                component.set("v.searchResults", JSON.parse(response.getReturnValue()));
        });

        $A.enqueueAction(searchAction);

    } 
})