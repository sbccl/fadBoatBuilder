public class PaymentsTriggerHandler {
    
    public Static void onBeforeInsert(List<Payments__c> listNewPayment){
    }
    
    public Static void onBeforeUpdate(List<Payments__c> listNewPayment, Map<Id, Payments__c> mapOldPayment){
    }
    
    public Static void onBeforeDelete(List<Payments__c> listOldPayment){
    }
    
    public Static void onAfterInsert(List<Payments__c> listNewPayment){
        updateQuoteDownPayment(listNewPayment);
        rollUpPaymentsToWorkOrder(listNewPayment);
    }
    
    public Static void onAfterUpdate(List<Payments__c> listNewPayment, Map<Id, Payments__c> mapNewPayment, Map<Id, Payments__c> mapOldPayment){
        updateQuoteDownPayment(listNewPayment);
        rollUpPaymentsToWorkOrder(listNewPayment);
        //WorkOrderPaymentHandler.createQBServicePayment(listNewPayment, mapOldPayment);
    }
    
    public Static void onAfterDelete(List<Payments__c> listOldPayment){
        rollUpPaymentsToWorkOrder(listOldPayment);
    }
    
    public Static void updateQuoteDownPayment(List<Payments__c> listNewPayment){
        Set<String> setQuoteId = new Set<String>();
        String strQuoteRecordTypeId = Schema.SObjectType.BOATBUILDING__Payments__c.getRecordTypeInfosByName().get('Quote').getRecordTypeId();
        for(Payments__c objPayment: listNewPayment) {
            if(String.isNotBlank(objPayment.Quote__c)) {
                setQuoteId.add(objPayment.Quote__c);
            }
        }
        
        
        List<Quote__c> listQuoteToProcess = [SELECT Id, BOATBUILDING__Quote_Down_Payment__c, 
                                             (SELECT Id, BOATBUILDING__Amount__c FROM BOATBUILDING__Payments__r 
                                              WHERE RecordTypeId =: strQuoteRecordTypeId) FROM BOATBUILDING__Quote__c 
                                             WHERE Id IN: setQuoteId];
        
        for(Quote__c objQt: listQuoteToProcess) {
            Decimal AmountCount = 0.00;
            if(!objQt.BOATBUILDING__Payments__r.isEmpty()) {
                for(BOATBUILDING__Payments__c objPt: objQt.BOATBUILDING__Payments__r) {
                    if(objPt.Amount__c != null) {
                        AmountCount += objPt.Amount__c;
                    }
                }
                objQt.BOATBUILDING__Quote_Down_Payment__c = AmountCount; 
            }
        } 
        
        update listQuoteToProcess;
    }
    
    public Static void rollUpPaymentsToWorkOrder(List<Payments__c> listNewPayment){
        RollUpSummaryUtility.fieldDefinition objRollUp = new RollUpSummaryUtility.fieldDefinition('SUM', 'BOATBUILDING__Amount__c', 'BOATBUILDING__Total_Payment_payment__c');
        List<RollUpSummaryUtility.fieldDefinition> fieldDefinitions = new List<RollUpSummaryUtility.fieldDefinition>();
        fieldDefinitions.add(objRollUp);
        RollUpSummaryUtility.rollUpTrigger(fieldDefinitions, listNewPayment,'BOATBUILDING__Payments__c','BOATBUILDING__Work_Warranty_Order__c','BOATBUILDING__Work_Order__c','');
    }
}