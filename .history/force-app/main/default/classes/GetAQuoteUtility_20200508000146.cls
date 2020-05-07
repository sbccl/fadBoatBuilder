public class GetAQuoteUtility {
    public static Quote__c generateQuote(String strAccountId, 
                                                String strInvId,   
                                                        List<String> lstProductPrice, 
                                                                        List<String> lstDealerOption, 
                                                                                        Quote__c objQT,
                                                                                                    Boolean zipCodeExist) {
        Quote__c objQuote = new Quote__c();
        try {
            System.debug('Debug Log For strAccountId: '+strAccountId);
            System.debug('Debug Log For strInvId: '+strInvId);
            System.debug('Debug Log For lstProductPrice: '+lstProductPrice); 
            System.debug('Debug Log For lstDealerOption: '+lstDealerOption);
            System.debug('Debug Log For objQT: '+objQT);
            
            String selectedType = '';
            Decimal yourPriceThirdPageForProductPrice = 0.00;
            Decimal totalPrice = 0.00;
            Decimal MfgOptTota = 0.00;
            Decimal dealerOptionTotal = 0.00;
            String smVrnt = '';
            String strSupraName = '';
            String ManufacturerCheck = '';
            String selectedManufacture = '';
            String selectedModel = '';
            String selectedModelVariant = '';
            String manufacturerStatus = '';
            String dealerStatus = '';
            Boolean modelVarientFlag = false; 
            
            Item__c objItem = new Item__c(); 
            
            objQuote = objQT;
            objQuote.BOATBUILDING__State__c = objQT.BOATBUILDING__State__c;
            List<Quote_Line_Item__c> lstQLI = new List<Quote_Line_Item__c>();
            //Product__c objProduct = new Product__c();
            Inventory__c objInventory = new Inventory__c();
            Contact objContact = new Contact();
            Account objAccount = new Account();
            
            List<Contact> listConToProcess = [SELECT Id, FirstName,LastName,MailingStreet,AccountId, MailingCity, MailingState, MailingCountry,
                                              Email, Phone FROM Contact where Id =: strAccountId limit 1 ];
            
            if(!listConToProcess.isEmpty()){
                objContact = listConToProcess[0];             
            }
            if(objContact!= null && objContact.AccountId != null) {
                objAccount = [SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode, ShippingStreet, ShippingCity, ShippingState, ShippingCountry, ShippingPostalCode, Email__c,
                              Phone FROM Account where Id =:objContact.AccountId];
            } 
            
            if(strInvId != null) { 
                objInventory = [Select b.RecordType.Name, b.BOATBUILDING__Our_Instant_Quote_Price__c ,b.RecordTypeId, b.OwnerId, b.Name, b.LastModifiedDate, b.LastModifiedById, b.Id, b.CreatedDate, b.CreatedById, 
                                        b.BOATBUILDING__Year__c, b.BOATBUILDING__Window_sticker_Term__c, b.BOATBUILDING__Window_Sticker_Your_Price__c, b.BOATBUILDING__Window_Sticker_Payment__c, 
                                        b.BOATBUILDING__Window_Sticker_Our_Discount__c, b.BOATBUILDING__Window_Sticker_MSRP__c, b.BOATBUILDING__Window_Sticker_Interest_Rate__c, b.BOATBUILDING__Website__c, 
                                        b.BOATBUILDING__Website_Page_Name__c, b.BOATBUILDING__Web_width__c, b.BOATBUILDING__Web_Year__c, b.BOATBUILDING__Web_Video__c, b.BOATBUILDING__Web_Term__c, 
                                        b.BOATBUILDING__Web_Propulsion__c, b.BOATBUILDING__Web_Product_Name__c, b.BOATBUILDING__Web_Product_ID__c, b.BOATBUILDING__Web_Price__c, b.BOATBUILDING__Web_Payment__c, 
                                        b.BOATBUILDING__Web_Payment_Formula__c, b.BOATBUILDING__Web_Part_Price__c, b.BOATBUILDING__Web_Part_Number__c, b.BOATBUILDING__Web_Part_Name__c, b.BOATBUILDING__Web_Part_Description__c, 
                                        b.BOATBUILDING__Web_Page_Name__c, b.BOATBUILDING__Web_Model__c, b.BOATBUILDING__Web_Make__c, b.BOATBUILDING__Web_MSRP__c, b.BOATBUILDING__Web_Location__c, 
                                        b.BOATBUILDING__Web_Interest_Rate__c, b.BOATBUILDING__Web_Hull_Material__c, b.BOATBUILDING__Web_Fuel_Type__c, b.BOATBUILDING__Web_Engine__c, b.BOATBUILDING__Web_Engine_HP__c, 
                                        b.BOATBUILDING__Web_Down_Payment__c, b.BOATBUILDING__Web_Description__c, b.BOATBUILDING__Web_Condition__c, b.BOATBUILDING__Web_Color__c, b.BOATBUILDING__Web_Boat_Length__c, 
                                        b.BOATBUILDING__Web_360_Video__c, b.BOATBUILDING__Walkthrough__c, b.BOATBUILDING__Vendor__c, b.BOATBUILDING__Vehicle_Type__c, b.BOATBUILDING__UsedBoatStatus__c, 
                                        b.BOATBUILDING__Underwater_lights__c, b.BOATBUILDING__Transom_remote__c, b.BOATBUILDING__Transom__c, b.BOATBUILDING__Transmission_Gearbox_SN__c, b.BOATBUILDING__Trailer_wheels__c, 
                                        b.BOATBUILDING__Trailer_Year__c, b.BOATBUILDING__Trailer_VIN__c, b.BOATBUILDING__Trailer_Model__c, b.BOATBUILDING__Trailer_Make__c, b.BOATBUILDING__Trailer_ID__c, 
                                        b.BOATBUILDING__Trailer_Axles__c, b.BOATBUILDING__Tower_speakers__c, b.BOATBUILDING__Total_Profit__c, b.BOATBUILDING__Total_MSRP_Price__c, b.BOATBUILDING__Total_Inventory_MSRP__c, 
                                        b.BOATBUILDING__Total_Inventory_Cost__c, b.BOATBUILDING__Total_Dealer_Price__c, b.BOATBUILDING__Tied_Up_Cash__c, b.BOATBUILDING__Taxable__c, b.BOATBUILDING__Surf_system__c, 
                                        b.BOATBUILDING__Suggested_List_Price__c, b.BOATBUILDING__Sub_Class_Pick_List__c, b.BOATBUILDING__Store_Location__c, b.BOATBUILDING__Steering_wheel_controls__c, 
                                        b.BOATBUILDING__Status_for_Interest_Start_Date__c, b.BOATBUILDING__Status_for_Days_on_the_Lot__c, b.BOATBUILDING__Status_for_Curtailment_Start_Date__c, b.BOATBUILDING__Status__c, 
                                        b.BOATBUILDING__Stage__c, b.BOATBUILDING__Speed_Wakeplate_levers__c, b.BOATBUILDING__Sold_Date__c, b.BOATBUILDING__Sold_By__c, b.BOATBUILDING__Size__c, b.BOATBUILDING__Side__c, 
                                        b.BOATBUILDING__Serial_Number_2__c, b.BOATBUILDING__Running_gear__c, b.BOATBUILDING__Rigging_Cost__c, b.BOATBUILDING__Quantity__c, b.BOATBUILDING__Phone_holder__c, 
                                        b.BOATBUILDING__Payment_base_on_financing__c, b.BOATBUILDING__Part__c, b.BOATBUILDING__Part_Number__c, b.BOATBUILDING__Part_Name__c, b.BOATBUILDING__Part_MSRP_Price__c, 
                                        b.BOATBUILDING__Part_Location__c, b.BOATBUILDING__Owner__c, b.BOATBUILDING__Order_Number__c, b.BOATBUILDING__Net_Weight__c, b.BOATBUILDING__Model__c, b.BOATBUILDING__Model_Variant__c, 
                                        b.BOATBUILDING__Model_Image__c, b.BOATBUILDING__Minimum_Sell_Price__c, b.BOATBUILDING__Minimum_Amount__c, b.BOATBUILDING__Min_ACV_Difference__c, b.BOATBUILDING__Mfg_Invoice__c, 
                                        b.BOATBUILDING__Map_Price__c, b.BOATBUILDING__Manufacturer__c, b.BOATBUILDING__Manufacture_Invoice__c, b.BOATBUILDING__Manufacture_Invoice2__c, b.BOATBUILDING__Location__c, 
                                        b.BOATBUILDING__Invoice_Number__c, b.BOATBUILDING__Inventory_Deposit_Account__c, b.BOATBUILDING__Interior_Design_Bow__c, b.BOATBUILDING__Interest_Start_Date__c, 
                                        b.BOATBUILDING__Hull_Material__c, b.BOATBUILDING__Hull_ID__c, b.BOATBUILDING__HIN_Number__c, b.BOATBUILDING__Floor_Plan_Bank__c, b.BOATBUILDING__Family__c, 
                                        b.BOATBUILDING__Extra_Pic_one__c, b.BOATBUILDING__Extra_Pic_Two__c, b.BOATBUILDING__Extra_Pic_Three__c, b.BOATBUILDING__Extra_Pic_Four__c, b.BOATBUILDING__Engine_compartment__c, 
                                        b.BOATBUILDING__Engine__c, b.BOATBUILDING__Engine_Year__c, b.BOATBUILDING__Engine_SN__c, b.BOATBUILDING__Engine_Model__c, b.BOATBUILDING__Engine_Make__c, 
                                        b.BOATBUILDING__Engine_Key_Number__c, b.BOATBUILDING__Display_On_Web__c, b.BOATBUILDING__Discount__c, b.BOATBUILDING__Description__c, b.BOATBUILDING__Dealer__c, 
                                        b.BOATBUILDING__Dealer_Stock__c, b.BOATBUILDING__Dealer_Status__c, b.BOATBUILDING__Dealer_Prep__c, b.BOATBUILDING__Dealer_Flat_Discount__c, b.BOATBUILDING__Dealer_Discount__c, 
                                        b.BOATBUILDING__Dealer_Comments__c, b.BOATBUILDING__Dealer_COD_Discount__c, b.BOATBUILDING__Dealer_Base_Price__c, b.BOATBUILDING__Days_on_Lot__c, 
                                        b.BOATBUILDING__Date_on_FloorPlan__c, b.BOATBUILDING__Date_First_on_Sales_Lot__c, b.BOATBUILDING__Date_Arrived__c, b.BOATBUILDING__Dash_cluster__c, b.BOATBUILDING__Dash_Screen__c, 
                                        b.BOATBUILDING__Curtailment_Start_Date__c, b.BOATBUILDING__Costline__c, b.BOATBUILDING__Costline_Value__c, b.BOATBUILDING__Costline_Points__c, b.BOATBUILDING__Cost__c, 
                                        b.BOATBUILDING__Cooler__c, b.BOATBUILDING__Convertible_seating__c, b.BOATBUILDING__Color__c, b.BOATBUILDING__Category__c, b.BOATBUILDING__Cabin__c, b.BOATBUILDING__Bow__c, 
                                        b.BOATBUILDING__Boat_Weight__c, b.BOATBUILDING__Boat_Weight_Maximum_Capacity__c, b.BOATBUILDING__Boat_Type__c, b.BOATBUILDING__Boat_Seating_Capacity__c, 
                                        b.BOATBUILDING__Boat_Overall_Length__c, b.BOATBUILDING__Boat_Length_in_feets__c, b.BOATBUILDING__Boat_Fuel_Capacity__c, b.BOATBUILDING__Boat_EST_Arrival_Date__c, 
                                        b.BOATBUILDING__Boat_Draft__c, b.BOATBUILDING__Boat_Costline__c, b.BOATBUILDING__Boat_Cargo_Capacity__c, b.BOATBUILDING__Boat_Capacities__c, 
                                        b.BOATBUILDING__Boat_Ballast_Weight__c, b.BOATBUILDING__Board_racks__c, b.BOATBUILDING__Bin__c, b.BOATBUILDING__Beam__c, b.BOATBUILDING__Backup_Camera__c, 
                                        b.BOATBUILDING__B_roll__c, b.BOATBUILDING__Amount_Boat_Is_Floored__c, b.BOATBUILDING__ACV__c, b.BOATBUILDING__ACV_Floored_Difference__c,
                                        (
                                            Select 
                                                    Id, IsDeleted, Name, Name__c, Related_to_Inventory__c, Item_Description__c, Discount__c, Dealer_Price__c, 
                                                    Option_Category__c, Price__c, Product_Code__c, Quantity__c, Non_Taxable__c 
                                            From   
                                                    BOATBUILDING__Inventory_Line_Items__r
                                        )
                                            From BOATBUILDING__Inventory__c b Where Id =: strInvId Limit 1];
                
                
                objQuote.BOATBUILDING__Our_Instant_Quote_Price__c = objInventory.BOATBUILDING__Our_Instant_Quote_Price__c;
                objQuote.BOATBUILDING__Map_Price__c = objInventory.BOATBUILDING__Map_Price__c;
                if(objInventory.Engine_SN__c != null){             
                    objQuote.Mapped_Engine_SN__c = objInventory.Engine_SN__c;
                }
                if(objInventory.Boat_Length_in_feets__c != null){             
                    objQuote.Mapped_Boat_Length__c = objInventory.Boat_Length_in_feets__c;
                }             
                if(objInventory.HIN_Number__c != null && objInventory.HIN_Number__c != ''){             
                    objQuote.Mapped_HIN__c = objInventory.HIN_Number__c;
                }
                else if(objInventory.Hull_ID__c != null && objInventory.Hull_ID__c != '') {
                    objQuote.Mapped_HIN__c = objInventory.Hull_ID__c;
                }
                if(objInventory.Trailer_VIN__c != null){             
                    objQuote.Mapped_Trailer_VIN__c = objInventory.Trailer_VIN__c;
                }
                if(objInventory.Transmission_Gearbox_SN__c != null){             
                    objQuote.Transmission_Gearbox_SN__c = objInventory.Transmission_Gearbox_SN__c; 
                }
                
                if(objInventory.RecordType.Name != null && objInventory.RecordType.Name == 'New Boats') {
                    selectedType = 'New Boat'; 
                } else if(objInventory.RecordType.Name != null && objInventory.RecordType.Name == 'Used Boats') {
                    selectedType = 'Used Boat';
                } else {
                    selectedType = objInventory.RecordType.Name; 
                }
                
                List<RecordType> lstRecTT = [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__Inventory__c' AND Name = 'New Boats'];
                
                if(zipCodeExist && objInventory.BOATBUILDING__Our_Instant_Quote_Price__c != null) {
                    yourPriceThirdPageForProductPrice = objInventory.BOATBUILDING__Our_Instant_Quote_Price__c;
                } else {
                    if(lstRecTT[0].Id == objInventory.RecordTypeId) {
                        if(objInventory.Cost__c != null){                                                      
                            yourPriceThirdPageForProductPrice = objInventory.Cost__c;
                        }else{  
                            yourPriceThirdPageForProductPrice = 0.00;
                        }
                    } else {
                        if(objInventory.Suggested_List_Price__c != null){                                                      
                            yourPriceThirdPageForProductPrice = objInventory.Suggested_List_Price__c;
                        }else{
                            yourPriceThirdPageForProductPrice = 0.00;
                        }
                    }  
                }
                totalPrice += yourPriceThirdPageForProductPrice;
                System.debug('Debug Log For totalPrice: '+totalPrice);
                
                if(objInventory.Model_Variant__c != null){
                    smVrnt = objInventory.Model_Variant__c;
                }
                if(objInventory.Manufacturer__c != null){
                    strSupraName = objInventory.Manufacturer__c;
                    BOATBUILDING__Manufacturer__c objManufacurer = [Select Id,Name, BOATBUILDING__Model_Variant__c from BOATBUILDING__Manufacturer__c where Name =: objInventory.Manufacturer__c limit 1];
                    if(objManufacurer != null) {
                        selectedManufacture = objManufacurer.Name;
                        modelVarientFlag = objManufacurer.BOATBUILDING__Model_Variant__c;
                    }
                    
                }
                if(objInventory.Model__c != null){
                    selectedModel = objInventory.Model__c;
                }
                if(objInventory.Model_Variant__c!=null){
                    selectedModelVariant = objInventory.Model_Variant__c;
                }
            } 
            
            if(objAccount.Id != null){
                if(String.valueOf(objAccount.Name).removeStartIgnoreCase(' ').removeEndIgnoreCase(' ').containsIgnoreCase(' ')){
                    String[] strConName = String.valueOf(objAccount.Name).split(' ');
                    objContact.FirstName = strConName[0];
                    objContact.LastName = strConName[1];
                }else{
                    objContact.LastName = String.valueOf(objAccount.Name);
                }
                objContact.AccountId = objAccount.Id;
                
                objContact.MailingStreet = objAccount.BillingStreet;
                objContact.MailingPostalCode = objAccount.BillingPostalCode;
                objContact.OtherStreet = objAccount.ShippingStreet;
                objContact.Phone = objAccount.Phone;
                objContact.Email = objAccount.Email__c; 
                upsert objContact;
            }
            if(objContact.Id != null && objContact.Email != null && objContact.AccountId != null) {
                List<Contact> lstConForDel = [SELECT Id From Contact WHERE Id <>: objContact.Id AND Email =: objContact.Email AND AccountId =: objContact.AccountId LIMIT 1];
                if(lstConForDel.size() > 0) {    
                    delete lstConForDel[0];
                }
            }
            if(objContact.Id != null){
                objQuote.Contact_Name__c = objContact.Id; 
            }
            
            if(objAccount.Id != null){
                objQuote.Account_Name__c = objAccount.Id;
            }
            if(objInventory.Cost__c != null){
                objQuote.Quote_Total_MSRP__c = objInventory.Cost__c;
            }
            if(objAccount.Name != null && objAccount.Name != ''){
                objQuote.Name = 'Quote For '+objAccount.Name;   
            }else{
                if(objContact.FirstName != null && objContact.FirstName != ''){
                    objQuote.Name = 'Quote For '+objContact.FirstName + ' ' + objContact.LastName;
                }else{
                    objQuote.Name = 'Quote For '+objInventory.Name;
                }
            }
            if(objContact.FirstName != null && objContact.FirstName != ''){
                objQuote.Quote_To_Name__c = objContact.FirstName + ' ' + objContact.LastName;
            }else{
                objQuote.Quote_To_Name__c = objContact.LastName;
            }
            objQuote.Quote_To_Address__c = ' ';
            
            if(objContact.Email != null && objContact.Email != ''){
                objQuote.Email__c = objContact.Email;
            }else if(objAccount.Email__c != null && objAccount.Email__c != ''){
                objQuote.Email__c = objAccount.Email__c;
            }else{
                objQuote.Email__c = ' ';
            }
            
            if(objContact.Phone != null && objContact.Phone != ''){
                objQuote.Phone__c = objContact.Phone;
            }else if(objAccount.Phone != null && objAccount.Phone !=''){
                objQuote.Phone__c = objAccount.Phone;
            }else{
                objQuote.Phone__c = ' ';
            }
            
           //Id, IsDeleted, Name, Name__c, Related_to_Inventory__c, Item_Description__c, Discount__c, Dealer_Price__c,  Option_Category__c, Price__c, Product_Code__c, Quantity__c, Non_Taxable__c 
            if(!objInventory.BOATBUILDING__Inventory_Line_Items__r.isEmpty()) {
                
                for(BOATBUILDING__Inventory_Line_Item__c objInventoryLineItem : objInventory.BOATBUILDING__Inventory_Line_Items__r) {
                //for(BOATBUILDING__ProductPrice__c objProductPriceForSelectedCategory: lstPP) {
                    BOATBUILDING__Quote_Line_Item__c objQLI = new BOATBUILDING__Quote_Line_Item__c();
                    objQLI.Name__c = objInventoryLineItem.Name__c;
                    objQLI.Name = 'QLI';
                    objQLI.Option_Category__c = objInventoryLineItem.Option_Category__c;
                    objQLI.Total_Price__c = objInventoryLineItem.Price__c;
                    objQLI.Date__c =  Date.today();
                    objQLI.Product_Code__c = objInventoryLineItem.Product_Code__c ;
                    objQLI.Dealer_Price__c = objInventoryLineItem.Dealer_Price__c;
                    if(objInventory.RecordType.Name == 'New Boats') {
                        objQLI.Product_Type__c = 'New Boat';
                    } else if(objInventory.RecordType.Name == 'Used Boats') {
                        objQLI.Product_Type__c = 'Used Boat';
                    }else {
                        objQLI.Product_Type__c = objInventory.RecordType.Name;
                    }
                    lstQLI.add(objQLI);
                    MfgOptTota += objInventoryLineItem.Price__c;
                }
                totalPrice += MfgOptTota;
                System.debug('Debug Log For MfgOptTota: '+MfgOptTota);
                System.debug('Debug Log For totalPrice: '+totalPrice);
            }
            
            
            if(totalPrice != null){
                objQuote.Quote_Sale_Price__c = totalPrice;
                objQuote.Total_Price_Quote__c = totalPrice;
            }else{
                objQuote.Quote_Sale_Price__c = 0.00;
                objQuote.Total_Price_Quote__c = 0.00;
            }    
            
            
            //if(objProduct.State__c!= 'None'){
            //objQuote.State__c= objProduct.State__c;
            //}
            //String regFee, String docFee, String trlRegFee
            
            if(strInvId != '0') {
                objQuote.BOATBUILDING__Test_2__c = strInvId;
            }
            insert objQuote;
            for(BOATBUILDING__Quote_Line_Item__c qli : lstQLI){
                qli.Quote__c = objQuote.Id; 
            } 
            
            insert lstQLI;
            
            return objQuote;
        } catch(Exception ex) {
            System.debug('Debug log for exception: '+ex.getStackTraceString()+' : '+ex.getLineNumber()+'messagr'+ex.getCause()+ex.getMessage()); 
            //SendEmailUtility.sendQuickEmail('Email For objQuote: '+objQuote);
            return null;    
        }
    }
}
