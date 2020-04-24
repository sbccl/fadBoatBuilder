public class ServiceScheduleController {
    @AuraEnabled
    public static List<String> getUsersSLocation() {
        List<String> lstObj = new List<String>();
        Schema.DescribeFieldResult fieldResult = User.BOATBUILDING__Store_Location__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            lstObj.add(pickListVal.getLabel());
        }  
        return lstObj;
    }

    @AuraEnabled
    public static List<User> getUserList(String sLoaction){
        List<User> lstUser = new List<User>();
        //Where isActive = true
        Set<String> setUserRole = new Set<String>();
        setUserRole.add('Service Tech');
        BOATBUILDING__System_Configure__c objSC = BOATBUILDING__System_Configure__c.getOrgDefaults();
        if(objSC != null && String.isNotBlank(objSC.BOATBUILDING__Schedule_Resource_Grid_User_Role__c)) {
            if(objSC.BOATBUILDING__Schedule_Resource_Grid_User_Role__c.contains(',')) {
                String [] strSplt = objSC.BOATBUILDING__Schedule_Resource_Grid_User_Role__c.split(',');
                for(String str: strSplt) {
                    setUserRole.add(str);
                }
            } else {
                setUserRole.add(objSC.BOATBUILDING__Schedule_Resource_Grid_User_Role__c);
            }
        }
        Map<Id, UserRole> mapUR = new Map<Id, UserRole>([Select Id, Name From UserRole Where Name IN: setUserRole]);
        if(sLoaction == 'All') {
            lstUser = [Select Id, Name, BOATBUILDING__Schedule_Texted_Color_Code__c, BOATBUILDING__Schedule_Color_Code__c, BOATBUILDING__Store_Location__c From User WHERE UserRoleId IN: mapUR.keySet() AND IsActive = true ORDER BY Name ASC  Limit 1000 ];
        } else {
            lstUser = [Select Id, Name, BOATBUILDING__Schedule_Texted_Color_Code__c, BOATBUILDING__Schedule_Color_Code__c, BOATBUILDING__Store_Location__c From User 
                        WHERE UserRoleId IN: mapUR.keySet() AND IsActive = true AND BOATBUILDING__Store_Location__c =: sLoaction ORDER BY Name ASC  Limit 1000 ];
        }
        return lstUser; 
    }  

    @AuraEnabled
    public static List<UserSLGroupList> getUserListSLGroup(String sLoaction){
        List<User> lstUser = getUserList(sLoaction);
        Map<String, List<User>> mapVal = new Map<String, List<User>>();
        if(!lstUser.isEmpty()) { 
            for(User objUser: lstUser) { 
                if(String.isNotBlank(objUser.BOATBUILDING__Store_Location__c) && !mapVal.containsKey(objUser.BOATBUILDING__Store_Location__c)) {
                    mapVal.put(objUser.BOATBUILDING__Store_Location__c, new List<User>());
                }
                if(String.isNotBlank(objUser.BOATBUILDING__Store_Location__c) && mapVal.containsKey(objUser.BOATBUILDING__Store_Location__c)) {
                    mapVal.get(objUser.BOATBUILDING__Store_Location__c).add(objUser);
                }
                if(String.isBlank(objUser.BOATBUILDING__Store_Location__c) && !mapVal.containsKey('-None-')) {
                    mapVal.put('-None-', new List<User>());
                }
                if(String.isBlank(objUser.BOATBUILDING__Store_Location__c) && mapVal.containsKey('-None-')) {
                    mapVal.get('-None-').add(objUser);  
                }
            }
        }
        List<UserSLGroupList> lstUserSLGroupList = new List<UserSLGroupList>();
        for(String strKey: mapVal.keySet()) {
            UserSLGroupList objUserSLGroupList = new UserSLGroupList();
            objUserSLGroupList.sLocation = strKey;
            objUserSLGroupList.lstUser = mapVal.get(strKey);
            lstUserSLGroupList.add(objUserSLGroupList);
        } 
        System.debug('>>>>>>>>>>>: '+lstUserSLGroupList);
        return lstUserSLGroupList;
    }

    public class UserSLGroupList {
        @AuraEnabled public String sLocation { get; set; }
        @AuraEnabled public List<User> lstUser { get; set; }
        
    }

    @AuraEnabled
    public static string getrecordType(){
        return ScheduleController.getrecordType();
    }

    @AuraEnabled
    public static List<BOATBUILDING__Time_Management__c> fetchRelatedEvents(String strUserId, String type) {
        System.debug('>>>>>>>>strUserId: '+strUserId);
        System.debug('>>>>>>>>type: '+type);
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
    @AuraEnabled
    public static String openWO(String strTMId) {
        try {
            BOATBUILDING__Time_Management__c objTM = [SELECT 
                                                                Id, Name, BOATBUILDING__Work_Order__c, BOATBUILDING__Technician__c, BOATBUILDING__Related_Work_Order_Job__c,
                                                                BOATBUILDING__Related_Work_Order_Job__c.BOATBUILDING__Work_Order_Warranty_Work_Order__c        
                                                    FROM 
                                                                BOATBUILDING__Time_Management__c Where Id =: strTMId];
            if(objTM.BOATBUILDING__Work_Order__c != null) {
                return objTM.BOATBUILDING__Work_Order__c;
            }
            if(objTM.BOATBUILDING__Related_Work_Order_Job__c != null) {
                return objTM.BOATBUILDING__Related_Work_Order_Job__c.BOATBUILDING__Work_Order_Warranty_Work_Order__c;
            }
            return 'NONE';
        } catch(Exception ex) {
            System.debug('Error: '+ex.getMessage()+' Line Number: '+ex.getLineNumber());
            return 'Error: '+ex.getMessage()+' Line Number: '+ex.getLineNumber()+' : '+ex.getStackTraceString();
        }
    }
}