declare module "@salesforce/apex/PurchaseOrderLightningController.fetchManuDetailsApex" {
  export default function fetchManuDetailsApex(param: {strManuId: any, strPoId: any}): Promise<any>;
}
declare module "@salesforce/apex/PurchaseOrderLightningController.getLineItems" {
  export default function getLineItems(param: {strPOId: any}): Promise<any>;
}
declare module "@salesforce/apex/PurchaseOrderLightningController.searchPartsfromInventoryAndParts" {
  export default function searchPartsfromInventoryAndParts(param: {searchStr: any}): Promise<any>;
}
declare module "@salesforce/apex/PurchaseOrderLightningController.updatePOwithLineItems" {
  export default function updatePOwithLineItems(param: {strPOId: any, strLineItems: any}): Promise<any>;
}
declare module "@salesforce/apex/PurchaseOrderLightningController.getPORecordTypeId" {
  export default function getPORecordTypeId(): Promise<any>;
}
declare module "@salesforce/apex/PurchaseOrderLightningController.generateOrderApex" {
  export default function generateOrderApex(param: {strRecId: any}): Promise<any>;
}
