declare module "@salesforce/apex/NewProductController.getManufacturer" {
  export default function getManufacturer(param: {selectedType: any}): Promise<any>;
}
declare module "@salesforce/apex/NewProductController.getYear" {
  export default function getYear(param: {strManuId: any, selectedType: any}): Promise<any>;
}
declare module "@salesforce/apex/NewProductController.getMVStatus" {
  export default function getMVStatus(param: {strManuId: any}): Promise<any>;
}
declare module "@salesforce/apex/NewProductController.getModel" {
  export default function getModel(param: {selectedType: any, strManuId: any, selectedYear: any, MVStatus: any}): Promise<any>;
}
declare module "@salesforce/apex/NewProductController.getModelVariantApex" {
  export default function getModelVariantApex(param: {selectedType: any, strManuId: any, selectedYear: any, selectedModel: any}): Promise<any>;
}
declare module "@salesforce/apex/NewProductController.getProductPriceApex" {
  export default function getProductPriceApex(param: {SelectedType: any, selectedManu: any, selectedYear: any, selectedModel: any, selectedModelVariant: any, MVStatus: any}): Promise<any>;
}
declare module "@salesforce/apex/NewProductController.getDealerPriceApex" {
  export default function getDealerPriceApex(): Promise<any>;
}
declare module "@salesforce/apex/NewProductController.getProduct" {
  export default function getProduct(param: {ProId: any}): Promise<any>;
}
