declare module "@salesforce/apex/WODetailPageController.getPageLayoutFields" {
  export default function getPageLayoutFields(): Promise<any>;
}
declare module "@salesforce/apex/WODetailPageController.getWorkOrderJobs" {
  export default function getWorkOrderJobs(param: {woId: any}): Promise<any>;
}
declare module "@salesforce/apex/WODetailPageController.getNewWOJobInstance" {
  export default function getNewWOJobInstance(param: {woId: any}): Promise<any>;
}
declare module "@salesforce/apex/WODetailPageController.searchUsersApex" {
  export default function searchUsersApex(param: {searchStr: any}): Promise<any>;
}
declare module "@salesforce/apex/WODetailPageController.loadSrviceUsers" {
  export default function loadSrviceUsers(): Promise<any>;
}
declare module "@salesforce/apex/WODetailPageController.deleteJobFromWO" {
  export default function deleteJobFromWO(param: {woId: any}): Promise<any>;
}
declare module "@salesforce/apex/WODetailPageController.deleteJobLineItem" {
  export default function deleteJobLineItem(param: {jliId: any}): Promise<any>;
}
declare module "@salesforce/apex/WODetailPageController.saveWOJob" {
  export default function saveWOJob(param: {woDataJSON: any}): Promise<any>;
}
