declare module "@salesforce/apex/InventoryCustomViewLightning.fetchAllInventories" {
  export default function fetchAllInventories(): Promise<any>;
}
declare module "@salesforce/apex/InventoryCustomViewLightning.getInventoryRecordType" {
  export default function getInventoryRecordType(): Promise<any>;
}
declare module "@salesforce/apex/InventoryCustomViewLightning.getInventoryBoatType" {
  export default function getInventoryBoatType(param: {Type: any}): Promise<any>;
}
declare module "@salesforce/apex/InventoryCustomViewLightning.getInventoryStage" {
  export default function getInventoryStage(param: {Type: any}): Promise<any>;
}
declare module "@salesforce/apex/InventoryCustomViewLightning.getInventoryYear" {
  export default function getInventoryYear(param: {Type: any}): Promise<any>;
}
declare module "@salesforce/apex/InventoryCustomViewLightning.getYearCount" {
  export default function getYearCount(param: {Type: any}): Promise<any>;
}
declare module "@salesforce/apex/InventoryCustomViewLightning.getInventoryModle" {
  export default function getInventoryModle(param: {Type: any, Make: any}): Promise<any>;
}
declare module "@salesforce/apex/InventoryCustomViewLightning.getInventoryMake" {
  export default function getInventoryMake(param: {Type: any}): Promise<any>;
}
declare module "@salesforce/apex/InventoryCustomViewLightning.SerchingOfInventory" {
  export default function SerchingOfInventory(param: {strSearch: any}): Promise<any>;
}
declare module "@salesforce/apex/InventoryCustomViewLightning.fetchInventory" {
  export default function fetchInventory(param: {Type: any, stage: any, year: any, Modle: any, BoatType: any, Make: any, StoreLoc: any}): Promise<any>;
}
