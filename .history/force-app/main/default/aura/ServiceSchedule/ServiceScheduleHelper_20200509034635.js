({
    loadEvents : function(component, event, usrId, type) {
        component.set("v.showSpinner", true);
        
        var lstUser = component.get("v.lstUser");
        console.log('lstUser: ',lstUser);
        var resources = [];
        lstUser.forEach(element => {
            var objRec = new Object();
            objRec.id = element.Id;
            objRec.title = element.Name;
            if(element.BOATBUILDING__Schedule_Color_Code__c != undefined) {   
                objRec.eventColor = element.BOATBUILDING__Schedule_Color_Code__c;
        }
        if(usrId == 'All' || usrId == element.Id) {
            resources.push(objRec);
        }
    });
    console.log('resources', resources);
    console.log('Script Loaded ',usrId, type);

    var action = component.get("c.fetchRelatedEvents");
    action.setParams({
        "strUserId" : usrId,
        "type" : type
    });
    action.setCallback(this, function(response){
    component.set("v.showSpinner", false);
    console.log('Response', response.getReturnValue());
    var result = response.getReturnValue();
    var newEvents = []; 
    if(result != null & result.length > 0) {
        
        for(var i = 0; i < result.length; i++) {
            
            var evtId = "", evtTitle = "", evtStart = "", eventEnd = "";
            if(result[i].BOATBUILDING__Schedule_Date_Time__c != undefined) {
                evtId = result[i].Id;
                if(result[i].BOATBUILDING__Event_Name__c != undefined) { 
                    evtTitle = result[i].BOATBUILDING__Event_Name__c;
                }
                
                var dt = new Date(result[i].BOATBUILDING__Schedule_Date_Time__c);
                var endDate = new Date(result[i].BOATBUILDING__End_Schedule_Date_Time__c);
                
                var sh = dt.getHours();
                var sm = dt.getMinutes();
                var ss = dt.getSeconds();
                var eh = endDate.getHours();
                var em = endDate.getMinutes();                                  
                var es = endDate.getSeconds();
                evtStart = dt.getFullYear() + "-" + this.pad(dt.getMonth()+1) + "-" + this.pad(dt.getDate())+"T"+this.pad(sh)+":"+this.pad(sm)+":"+this.pad(ss); 
                eventEnd = endDate.getFullYear() + "-" + this.pad(endDate.getMonth()+1) + "-" + this.pad(endDate.getDate())+"T"+this.pad(eh)+":"+this.pad(em)+":"+this.pad(es); 
                var newEvent = new Object(eventEnd);
                newEvent.id = evtId;
                newEvent.title = evtTitle;
                newEvent.start = evtStart;
                newEvent.end = eventEnd; 
                newEvent.allDay = false;
                
                if(result[i].BOATBUILDING__Related_Work_Order_Job__c != undefined) {
                    if(result[i].BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Completed__c == true) {
                        newEvent.color = 'red';  
                        newEvent.textColor = 'white';  
                    } else {
                        newEvent.textColor = 'black';  
                    }
                } else  if(result[i].BOATBUILDING__Work_Order__c != undefined) {
                    
                    if(result[i].BOATBUILDING__Work_Order__r.BOATBUILDING__Status__c != undefined 
                       && (result[i].BOATBUILDING__Work_Order__r.BOATBUILDING__Status__c == 'Closed' || result[i].BOATBUILDING__Work_Order__r.BOATBUILDING__Status__c == 'Closed Internal')) {
                        newEvent.color = 'red';
                    } else if(result[i].BOATBUILDING__Technician__c != undefined 
                              && result[i].BOATBUILDING__Technician__r.BOATBUILDING__Schedule_Color_Code__c != undefined
                              &&	result[i].BOATBUILDING__Technician__r.BOATBUILDING__Schedule_Texted_Color_Code__c != undefined) {
                        newEvent.color = result[i].BOATBUILDING__Technician__r.BOATBUILDING__Schedule_Color_Code__c;
                        newEvent.textColor = result[i].BOATBUILDING__Technician__r.BOATBUILDING__Schedule_Texted_Color_Code__c;
                    }else {
                        if(result[i].BOATBUILDING__Work_Order__r.RecordType.Name == 'Work Order') {
                            if(result[i].BOATBUILDING__Work_Order__r.BOATBUILDING__Status__c != undefined 
                               && (result[i].BOATBUILDING__Work_Order__r.BOATBUILDING__Status__c == 'Waiting On Payment' 
                                   || result[i].BOATBUILDING__Work_Order__r.BOATBUILDING__Status__c == 'Warranty Waiting on Payment')) {
                                newEvent.color = 'yellow';
                                newEvent.textColor = 'black';
                            } else {    
                                newEvent.color = 'green';
                            }
                        } else if(result[i].BOATBUILDING__Work_Order__r.RecordType.Name == 'Warranty Work Order') { 
                            if(result[i].BOATBUILDING__Work_Order__r.BOATBUILDING__Status__c != undefined 
                               && (result[i].BOATBUILDING__Work_Order__r.BOATBUILDING__Status__c == 'Waiting On Payment' 
                                   || result[i].BOATBUILDING__Work_Order__r.BOATBUILDING__Status__c == 'Warranty Waiting on Payment')) {
                                newEvent.color = 'yellow';
                                newEvent.textColor = 'black';
                            } else {     
                                newEvent.color = 'blue';
                            }     
                            
                        }
                    } 
                    
                    
                    
                } else if(result[i].BOATBUILDING__Technician__c != undefined 
                          && result[i].BOATBUILDING__Technician__r.BOATBUILDING__Schedule_Color_Code__c != undefined
                          &&	result[i].BOATBUILDING__Technician__r.BOATBUILDING__Schedule_Texted_Color_Code__c != undefined) {
                    newEvent.color = result[i].BOATBUILDING__Technician__r.BOATBUILDING__Schedule_Color_Code__c;
                    newEvent.textColor = result[i].BOATBUILDING__Technician__r.BOATBUILDING__Schedule_Texted_Color_Code__c;
                } 
                newEvent.resourceId = result[i].BOATBUILDING__Technician__c; 
                newEvents.push(newEvent);
                //  $('#calendar').fullCalendar( 'renderEvent', newEvent );
            }
        }
        console.log('newEvents', newEvents);
        //$('#calendar').fullCalendar( 'destroy' );
    }
    
    var calendarEl = document.getElementById('calendar');
    var d1 = new Date();
    var calendar = new FullCalendar.Calendar(calendarEl, {
        schedulerLicenseKey: 'GPL-My-Project-Is-Open-Source',
        plugins: [ 'interaction', 'resourceDayGrid', 'resourceTimeGrid' ],
        defaultView: 'resourceTimeGridDay',
        defaultDate: d1,
        editable: true, 
        selectable: true,
        eventLimit: true, // allow "more" link when too many events
        header: {
            left: 'prev,next today',
            center: 'title',
            right: 'resourceTimeGridDay,resourceTimeGridTwoDay,timeGridWeek,dayGridMonth'
        },
        views: {
            resourceTimeGridTwoDay: {
                type: 'resourceTimeGrid',
                duration: { days: 2 },
                buttonText: '2 days',
            } 
        },
        //// uncomment this line to hide the all-day slot
        //allDaySlot: false,
        resources: resources
        , 
        events: newEvents
        ,
        select: function(arg) {
            console.log(
                'select',
                arg.startStr,
                arg.endStr,
                arg.resource ? arg.resource.id : '(No resource)'
            );
            
            component.set("v.RecordId", "");
            component.set("v.isModalOpen", true);
            var recId = arg.resource ? arg.resource.id : '';
            
            component.find("techId").set("v.value", recId);
            console.log(">>>>1: ",arg.startStr);
            console.log(">>>>2: ",arg.endStr);
            component.find("sDate").set("v.value", arg.startStr);
            component.find("eDate").set("v.value", arg.endStr);

            var open = component.get("v.isModalOpen");
            if (open == true) {
                var calendarEl = document.getElementsByClassName('desktop');
                console.log('>>>>calenIDCheck', calendarEl);
                calendarEl[0].setAttribute('style', 'overflow: hidden;');
            }
            
        },
        dateClick: function(arg) {
            console.log(
                'dateClick',
                arg.date,
                arg.resource ? arg.resource.id : '(No  resource)'
            );
            
            component.set("v.RecordId", "");
            component.set("v.isModalOpen", true);
            var recId = arg.resource ? arg.resource.id : '';
            
            component.find("techId").set("v.value", recId);
            var open = component.get("v.isModalOpen");
            if (open == true) {
                var calendarEl = document.getElementsByClassName('desktop');
                console.log('>>>>calenIDCheck', calendarEl);
                calendarEl[0].setAttribute('style', 'overflow: hidden;');
            }
        },
        eventClick: function(arg) {
            console.log(arg.event.id);
            component.set("v.RecordId", arg.event.id);
            component.set("v.isModalOpen", true);
            var open = component.get("v.isModalOpen");
            if (open == true) {
                var calendarEl = document.getElementsByClassName('desktop');
                console.log('>>>>calenIDCheck', calendarEl);
                calendarEl[0].setAttribute('style', 'overflow: hidden;');
            }
        },
        eventDrop: function(arg) {

            console.log(">>>>1: ",arg.event.start);
            console.log(">>>>1event: ",arg.event);
            component.set("v.RecordId", arg.event.id);
            console.log(">>>>1>>: ",arg.event._instance.range.end.toLocaleString());
            console.log(">>>>2: ",arg.event.end);
            console.log(">>>>arg.resource.id: ",arg.resource.id);

            //2020-04-22T12:30:00
            var startDateT = arg.event.start.getYear()+'-'+arg.event.start.getMonth()+'-'+arg.event.start.getDate()+'T'+arg.event.start.getHours()+':'+arg.event.start.getMinutes()+':00';
            var endDateT = arg.event.start.getYear()+'-'+arg.event.start.getMonth()+'-'+arg.event.start.getDate()+'T'+arg.event.start.getHours()+':'+arg.event.start.getMinutes()+':00';
        },
        eventResize: function(arg) {
            console.log(">>>>1: ",arg.event.start);
            console.log(">>>>1event: ",arg.event);
            component.set("v.RecordId", arg.event.id);
            console.log(">>>>1>>: ",arg.event._instance.range.end.toLocaleString());
            console.log(">>>>2: ",arg.event.end);
            console.log(">>>>arg.resource.id: ",arg.resource.id);
            
        } 
    });
    
    calendar.render();
});
$A.enqueueAction(action);

},
    pad : function(val) {
        var valString = val + "";
        if(valString.length < 2) {
            return "0" + valString;
        }
        else {
            return valString;
        } 
    }
})