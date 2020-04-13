public class ServiceScheduleController {

    @AuraEnabled
    public static List<User> getUserList(){
        List<User> lstUser = new List<User>();
        //Where isActive = true
        Map<Id, UserRole> mapUR = new Map<Id, UserRole>([Select Id, Name From UserRole Where Name LIKE '%Service%']);
        lstUser = [Select Id, Name, BOATBUILDING__Schedule_Texted_Color_Code__c, BOATBUILDING__Schedule_Color_Code__c From User WHERE UserRoleId IN: mapUR.keySet()  Limit 1000 ];
        return lstUser;
    }  

    @AuraEnabled
    public static string getrecordType(){
        return ScheduleController.getrecordType();
    }

    @AuraEnabled
    public static List<BOATBUILDING__Time_Management__c> fetchRelatedEvents(String strUserId, String type) {
        List<BOATBUILDING__Time_Management__c> lstTM = new List<BOATBUILDING__Time_Management__c>();
        if(strUserId == 'All') {
            if(type == '0' || type == 'All') {
                lstTM = [SELECT
                         Technician__r.Name, Id, Event_Name__c, Description__c, Inventory__c, BOATBUILDING__Work_Order__r.RecordType.Name, BOATBUILDING__Work_Order__r.Status__c, Related_Work_Order_Job__c, BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Completed__c, End_Schedule_Date_Time__c, Technician__c, Schedule_Date_Time__c, Work_Order__c, Technician__r.Schedule_Color_Code__c, Technician__r.Schedule_Texted_Color_Code__c  
                         FROM  
                         BOATBUILDING__Time_Management__c
                         WHERE  
                         RecordType.DeveloperName = 'Schedule'];  
                
                for(BOATBUILDING__Time_Management__c obj : lstTM) {
                    obj.Schedule_Date_Time__c = obj.Schedule_Date_Time__c;
                    obj.End_Schedule_Date_Time__c = obj.End_Schedule_Date_Time__c;
                }    
            } else {
                lstTM = [SELECT 
                         Technician__r.Name, Id, Event_Name__c, Description__c, Inventory__c, BOATBUILDING__Work_Order__r.RecordType.Name, BOATBUILDING__Work_Order__r.Status__c, Related_Work_Order_Job__c, BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Completed__c, End_Schedule_Date_Time__c, Technician__c, Schedule_Date_Time__c, Work_Order__c, Technician__r.Schedule_Color_Code__c, Technician__r.Schedule_Texted_Color_Code__c  
                         FROM  
                         BOATBUILDING__Time_Management__c
                         WHERE  
                         RecordType.DeveloperName = 'Schedule'
                         AND 
                         Type__c =: type];  
                
                for(BOATBUILDING__Time_Management__c obj : lstTM) {
                    obj.Schedule_Date_Time__c = obj.Schedule_Date_Time__c;
                    obj.End_Schedule_Date_Time__c = obj.End_Schedule_Date_Time__c;
                }
            } 
        } else {
            if(type == '0' || type == 'All') {
                lstTM = [SELECT 
                         Technician__r.Name, Id, Event_Name__c, Description__c, Inventory__c, BOATBUILDING__Work_Order__r.RecordType.Name, BOATBUILDING__Work_Order__r.Status__c, Related_Work_Order_Job__c, BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Completed__c, End_Schedule_Date_Time__c, Technician__c, Schedule_Date_Time__c, Work_Order__c, Technician__r.Schedule_Color_Code__c, Technician__r.Schedule_Texted_Color_Code__c  
                         FROM  
                         BOATBUILDING__Time_Management__c
                         WHERE  
                         Technician__c =: strUserId
                         AND 
                         RecordType.DeveloperName = 'Schedule'];  
                
                for(BOATBUILDING__Time_Management__c obj : lstTM) {
                    obj.Schedule_Date_Time__c = obj.Schedule_Date_Time__c;
                    obj.End_Schedule_Date_Time__c = obj.End_Schedule_Date_Time__c;
                }    
            } else {
                lstTM = [SELECT 
                         Id, Event_Name__c, Description__c, Inventory__c, BOATBUILDING__Work_Order__r.RecordType.Name, BOATBUILDING__Work_Order__r.Status__c, Related_Work_Order_Job__c, BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Completed__c, End_Schedule_Date_Time__c, Technician__c, Schedule_Date_Time__c, Work_Order__c, Technician__r.Schedule_Color_Code__c, Technician__r.Schedule_Texted_Color_Code__c  
                         FROM  
                         BOATBUILDING__Time_Management__c
                         WHERE  
                         Technician__c =: strUserId
                         AND 
                         RecordType.DeveloperName = 'Schedule'
                         AND 
                         Type__c =: type];  
                
                for(BOATBUILDING__Time_Management__c obj : lstTM) {
                    obj.Schedule_Date_Time__c = obj.Schedule_Date_Time__c;
                    obj.End_Schedule_Date_Time__c = obj.End_Schedule_Date_Time__c;
                }
            }
        }
        
        return lstTM;  
    } 
    @AuraEnabled
    public static String updateTechOnALlJobs(String strTMId) {
        try {
            BOATBUILDING__Time_Management__c objTM = [SELECT 
                                                                Id, Name, BOATBUILDING__Work_Order__c, BOATBUILDING__Technician__c, BOATBUILDING__Related_Work_Order_Job__c 
                                                    FROM 
                                                                BOATBUILDING__Time_Management__c Where Id =: strTMId];
            if(objTM.BOATBUILDING__Related_Work_Order_Job__c != null) {
                objTM.BOATBUILDING__Work_Order__c = null;
                update objTM;
            }
            if(objTM.BOATBUILDING__Work_Order__c != null) {
                List<BOATBUILDING__Work_Order_Job__c> lstJB = [SELECT Id FROM BOATBUILDING__Work_Order_Job__c WHERE BOATBUILDING__Completed__c = false AND BOATBUILDING__Work_Order_Warranty_Work_Order__c =: objTM.BOATBUILDING__Work_Order__c];  
                if(!lstJB.isEmpty()) {
                    for(BOATBUILDING__Work_Order_Job__c objJB: lstJB) {
                        objJB.BOATBUILDING__Technician__c = objTM.BOATBUILDING__Technician__c;
                    }
                    update lstJB;
                }
            } 
            
            return 'SUCCESS';
        } catch(Exception ex) {
            System.debug('Error: '+ex.getMessage()+' Line Number: '+ex.getLineNumber());
            return 'Error: '+ex.getMessage()+' Line Number: '+ex.getLineNumber()+' : '+ex.getStackTraceString();
        }
    }
}