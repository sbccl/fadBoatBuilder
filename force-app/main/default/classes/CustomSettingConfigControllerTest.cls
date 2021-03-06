@isTest
public class CustomSettingConfigControllerTest {
    testmethod static void TestController(){
        CustomSettingConfigController ObjC= new CustomSettingConfigController();
        BOATBUILDING__SalesTaxConfiguration__c ObjS= new BOATBUILDING__SalesTaxConfiguration__c();
        ObjS.Name = 'test';
        ObjS.BOATBUILDING__Regular_Sales_Tax__c = 1234;
        ObjS.BOATBUILDING__Tax_Capping_Amount__c=34535;
        ObjS.BOATBUILDING__Vehicle_Sales_Tax__c = 1213;
        insert ObjS;
        BOATBUILDING__ExternalNotificationEmail__c ObjE = new BOATBUILDING__ExternalNotificationEmail__c();
        ObjE.Name='testtt';
        insert ObjE;
        BOATBUILDING__ExternalDatabaseConfig__c ObjD = new BOATBUILDING__ExternalDatabaseConfig__c();
        ObjD.Name= 'test1';
        insert ObjD;
        BOATBUILDING__EndPointURL__c ObjU = new BOATBUILDING__EndPointURL__c();
        ObjU.Name = 'test2';
        insert ObjU;
        BOATBUILDING__OAuthService__c ObjA = new BOATBUILDING__OAuthService__c();
        ObjA.Name= 'test3';
        insert ObjA;
        BOATBUILDING__QBProductServiceConfig__c ObjG = new BOATBUILDING__QBProductServiceConfig__c();
        ObjG.Name= 'test4';
        insert ObjG;
        BOATBUILDING__Dealer_Option__c ObjI = new BOATBUILDING__Dealer_Option__c();
        ObjI.Name='test5';
        ObjI.BOATBUILDING__Part_Number__c = 'test6';
        insert ObjI;
        BOATBUILDING__LeadSourceToAccountRecordType__c ObjR = new BOATBUILDING__LeadSourceToAccountRecordType__c();
        ObjR.Name = 'test7';
        insert ObjR;
        BOATBUILDING__RoundRobin_Config__c ObjB = new BOATBUILDING__RoundRobin_Config__c();
        ObjB.Name = 'test8';
        insert ObjB;
        BOATBUILDING__Update_Customer_Notification__c ObjN = new BOATBUILDING__Update_Customer_Notification__c();
        ObjN.Name = 'testttttt'; 
        insert ObjN; 
        BOATBUILDING__UserRolesData__c OBjZ = new BOATBUILDING__UserRolesData__c(); 
        ObjZ.Name = 'testname';
        insert ObjZ;
        BOATBUILDING__WorkTypePricing__c ObjW = new BOATBUILDING__WorkTypePricing__c();
        ObjW.Name = 'test9';
        ObjW.BOATBUILDING__Price__c = 123;
        insert ObjW;
        BOATBUILDING__Shop_Supplies__c ObjP = new BOATBUILDING__Shop_Supplies__c();
        ObjP.Name = 'tetstt';
        ObjP.BOATBUILDING__Cap_Amount_for_percent__c = 12;
        ObjP.BOATBUILDING__Percentage__c = 120.0;
        insert ObjP;
        BOATBUILDING__Template_WhyBuyFromUS__c ObjF = new BOATBUILDING__Template_WhyBuyFromUS__c();
        ObjF.Name= 'testtt';
        insert ObjF;
        
        ObjC.editUserRecord();
        ObjC.updateUser();
        ObjC.getLstENE();
        ObjC.deleteENERecord();
        ObjC.saveENE();
        ObjC.getLstED();
        ObjC.deleteEDRecord();
        ObjC.saveED();
        ObjC.deleteENURecord();
        ObjC.saveENU();
        ObjC.getLstQBAuth();
        ObjC.deleteQBAuthRecord();
        ObjC.saveQBAuth();
        ObjC.getLstQBPSC();
        ObjC.deleteQBPSCRecord();
        ObjC.saveQBPSC();
        ObjC.getLstTWBFU();
        ObjC.deleteTWBFURecord();
        ObjC.deleteTWBFURecord();
        ObjC.getLstWTP();
        ObjC.deleteWTPRecord();
        ObjC.saveWTP();
        ObjC.getLstUDR();
        ObjC.deleteUDRRecord();
        ObjC.saveUDR();
        ObjC.getLstUCN();
        ObjC.deleteUCNRecord();
        ObjC.saveUCN();
        ObjC.saveStoreLocation();
        ObjC.editStoreLocation();
        ObjC.deleteStoreLocation();
        ObjC.saveShopSupplies();
        ObjC.editShopSupplies();
        ObjC.deleteShopSupplies();
        ObjC.getLstSTC();
        ObjC.saveSalesTax();
        ObjC.deleteSalesTaxRecord();
        ObjC.getLstDO();
        ObjC.deleteDORecord();
        ObjC.saveDealerOption();
        ObjC.saveCreditAppURLs();
        ObjC.editCreditAppURLs();
        ObjC.getLstLSTART();
        ObjC.deleteLSTARTRecord();
        ObjC.saveLSTART();
        ObjC.getLstRR();
        ObjC.deleteRRRecord();
        ObjC.saveRR();
        ObjC.editTriggerConfiguration();
        ObjC.saveTriggerConfig();
        ObjC.deleteTriggerConfig();
        ObjC.saveTWBFU();
        ObjC.deleteCreditAppURLs();
        ObjC.getLstENU();
        ObjC.strENEAccountCustomerType = 'true';
        
        
    }
    
}