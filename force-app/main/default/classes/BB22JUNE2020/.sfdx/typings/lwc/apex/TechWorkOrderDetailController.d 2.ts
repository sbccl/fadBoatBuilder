declare module "@salesforce/apex/TechWorkOrderDetailController.getWorkOrderDetail" {
  export default function getWorkOrderDetail(param: {strRecId: any}): Promise<any>;
}
declare module "@salesforce/apex/TechWorkOrderDetailController.updateclockout" {
  export default function updateclockout(param: {JobId: any, tmid: any}): Promise<any>;
}
declare module "@salesforce/apex/TechWorkOrderDetailController.insertclockin" {
  export default function insertclockin(param: {JobId: any}): Promise<any>;
}
declare module "@salesforce/apex/TechWorkOrderDetailController.completeToggle" {
  export default function completeToggle(param: {strRecId: any, ischecked: any}): Promise<any>;
}
declare module "@salesforce/apex/TechWorkOrderDetailController.getTMHistory" {
  export default function getTMHistory(param: {jobId: any}): Promise<any>;
}
