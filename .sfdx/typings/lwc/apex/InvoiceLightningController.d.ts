declare module "@salesforce/apex/InvoiceLightningController.getLineItems" {
  export default function getLineItems(param: {strPOId: any}): Promise<any>;
}
declare module "@salesforce/apex/InvoiceLightningController.deleteInvoiceLineItem" {
  export default function deleteInvoiceLineItem(param: {invoiceLineItemId: any}): Promise<any>;
}
declare module "@salesforce/apex/InvoiceLightningController.searchPartsfromInvoiceAndParts" {
  export default function searchPartsfromInvoiceAndParts(param: {searchStr: any}): Promise<any>;
}
declare module "@salesforce/apex/InvoiceLightningController.getSalesTaxCustomSetting" {
  export default function getSalesTaxCustomSetting(): Promise<any>;
}
declare module "@salesforce/apex/InvoiceLightningController.searchPartsfromInventoryAndParts" {
  export default function searchPartsfromInventoryAndParts(param: {searchStr: any}): Promise<any>;
}
declare module "@salesforce/apex/InvoiceLightningController.InvRecordTypeId" {
  export default function InvRecordTypeId(): Promise<any>;
}
declare module "@salesforce/apex/InvoiceLightningController.UpdateInvoicewithLineItems" {
  export default function UpdateInvoicewithLineItems(param: {strInvId: any, strLineItems: any}): Promise<any>;
}
