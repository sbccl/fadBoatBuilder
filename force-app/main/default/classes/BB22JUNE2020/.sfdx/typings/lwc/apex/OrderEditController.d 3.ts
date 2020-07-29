declare module "@salesforce/apex/OrderEditController.addInventory" {
  export default function addInventory(param: {strOrderId: any, lstlistItem: any}): Promise<any>;
}
declare module "@salesforce/apex/OrderEditController.addToInventoryWithBackOrder" {
  export default function addToInventoryWithBackOrder(param: {strOrderId: any, lstlistItem: any}): Promise<any>;
}
declare module "@salesforce/apex/OrderEditController.getLineItemDetail" {
  export default function getLineItemDetail(param: {recordOrderId: any}): Promise<any>;
}
declare module "@salesforce/apex/OrderEditController.getOrderDetail" {
  export default function getOrderDetail(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/OrderEditController.getRecTypeId" {
  export default function getRecTypeId(): Promise<any>;
}
declare module "@salesforce/apex/OrderEditController.getSlocationDetails" {
  export default function getSlocationDetails(): Promise<any>;
}
