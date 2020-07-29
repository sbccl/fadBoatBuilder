declare module "@salesforce/apex/VoidPaymentApexController.getpayment" {
  export default function getpayment(param: {pageSize: any, pageNumber: any}): Promise<any>;
}
declare module "@salesforce/apex/VoidPaymentApexController.getsListofLaneIds" {
  export default function getsListofLaneIds(): Promise<any>;
}
declare module "@salesforce/apex/VoidPaymentApexController.doVoidTransaction" {
  export default function doVoidTransaction(param: {laneId: any, transactionId: any, paymentRecordId: any}): Promise<any>;
}
declare module "@salesforce/apex/VoidPaymentApexController.doReturnTransaction" {
  export default function doReturnTransaction(param: {laneId: any, transactionId: any, transactionAmount: any, paymenttype: any, paymentId: any}): Promise<any>;
}
declare module "@salesforce/apex/VoidPaymentApexController.doRefundTransaction" {
  export default function doRefundTransaction(param: {laneId: any, transactionAmount: any, paymentId: any}): Promise<any>;
}
declare module "@salesforce/apex/VoidPaymentApexController.doReversalTransaction" {
  export default function doReversalTransaction(param: {laneId: any, transactionId: any, transactionAmount: any, paymentType: any, paymentId: any}): Promise<any>;
}
