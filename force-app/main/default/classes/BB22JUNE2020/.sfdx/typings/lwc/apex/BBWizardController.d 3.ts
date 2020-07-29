declare module "@salesforce/apex/BBWizardController.getApprovalCheck" {
  export default function getApprovalCheck(param: {AcvId: any}): Promise<any>;
}
declare module "@salesforce/apex/BBWizardController.generateQuote" {
  export default function generateQuote(param: {strAccountId: any, strInvId: any, ProId: any, ACVId: any, regFee: any, docFee: any, trlRegFee: any, lstProductPrice: any, lstDealerOption: any, objQT: any, lstDO: any}): Promise<any>;
}
declare module "@salesforce/apex/BBWizardController.getState" {
  export default function getState(): Promise<any>;
}
declare module "@salesforce/apex/BBWizardController.updateStateApex" {
  export default function updateStateApex(param: {quoteId: any, state: any}): Promise<any>;
}
declare module "@salesforce/apex/BBWizardController.isNoSalesmanWithoutCost" {
  export default function isNoSalesmanWithoutCost(): Promise<any>;
}
