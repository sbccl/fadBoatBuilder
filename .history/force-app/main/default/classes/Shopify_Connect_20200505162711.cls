global with sharing class Shopify_Connect {
	
	@AuraEnabled
	global static String savePartsToShopifyLightning(String strPartId) {
		String res = savePartsToShopify(strPartId);
		return res;
	}
	@future(callout=true) 
 	webservice static String savePartsToShopify(String strPartId) { 
 		try {
	         BOATBUILDING__ShopifyConfig__c objSC = BOATBUILDING__ShopifyConfig__c.getOrgDefaults();
	         if(objSC != null) {
	         	
	             Part__c objPart = [Select 
	         								b.SystemModstamp, b.RecordTypeId, b.OwnerId, b.Name, b.LastViewedDate, b.BOATBUILDING__Vendor_Name__r.Name, b.Quantity__c,
	         								b.LastReferencedDate, b.LastModifiedDate, b.LastModifiedById, b.LastActivityDate, b.BOATBUILDING__Weight__c, b.Id, BOATBUILDING__Web_Description_long__c,
	         								b.BOATBUILDING__Web_Product_Name__c, b.BOATBUILDING__Web_Price__c, b.BOATBUILDING__Web_Part_Number__c, b.BOATBUILDING__Shopify_Product_Id__c,
	         								b.BOATBUILDING__Web_Description__c, b.BOATBUILDING__Vendor_Name__c, b.BOATBUILDING__This_is_a_Physical_Product__c, b.BOATBUILDING__Sub_Family__c,
	         								b.BOATBUILDING__Taxable__c, b.BOATBUILDING__Store_Location__c, b.BOATBUILDING__SKU__c, b.BOATBUILDING__Retail_Price__c, 
	         								b.BOATBUILDING__Part_Size__c, b.BOATBUILDING__Part_Number__c, b.BOATBUILDING__Part_Cost__c, b.BOATBUILDING__Part_Color__c, 
	         								b.BOATBUILDING__Minimum_Amount__c, b.BOATBUILDING__Map_Price__c, b.BOATBUILDING__Location__c, b.BOATBUILDING__Family1__c, 
	         								b.BOATBUILDING__Discount__c, b.BOATBUILDING__Dealer_Price__c, b.BOATBUILDING__Category1__c, b.BOATBUILDING__Bin__c, b.BOATBUILDING__Barcode__c,
	         								(
		                                       Select
		                                               RecordTypeId, OwnerId, Name, BOATBUILDING__Vendor_Name__r.Name, Quantity__c,
		                                               BOATBUILDING__Weight__c, Id,BOATBUILDING__Part__c,BOATBUILDING__Push_Image__c,
		                                               BOATBUILDING__Web_Product_Name__c, BOATBUILDING__Web_Price__c, BOATBUILDING__Web_Part_Number__c, BOATBUILDING__WooCommerce_Id__c,
		                                               BOATBUILDING__Web_Description__c, BOATBUILDING__Vendor_Name__c, BOATBUILDING__This_is_a_Physical_Product__c, BOATBUILDING__Web_Description_long__c, 
		                                               BOATBUILDING__Taxable__c, BOATBUILDING__Store_Location__c, BOATBUILDING__SKU__c, BOATBUILDING__Retail_Price__c, Sub_Family__c,
		                                               BOATBUILDING__Part_Size__c, BOATBUILDING__Part_Number__c, BOATBUILDING__Part_Cost__c, BOATBUILDING__Part_Color__c, 
		                                               BOATBUILDING__Minimum_Amount__c, BOATBUILDING__Map_Price__c, BOATBUILDING__Location__c, BOATBUILDING__Family1__c, 
		                                               BOATBUILDING__Discount__c, BOATBUILDING__Dealer_Price__c, BOATBUILDING__Category1__c, BOATBUILDING__Bin__c, BOATBUILDING__Barcode__c
		                                       From 
		                                               Part_Variation__r
		                                    ) 
	         								 
	 								From 
	 										BOATBUILDING__Part__c b
	 								Where 	
	 										Id =: strPartId];
	 			System.debug('Debug Log For objPart: '+objPart);
                Set<String> setPVId = new Set<String>(); 
                if(!objPart.Part_Variation__r.isEmpty()) {
                    for(Part__c objPrt: objPart.Part_Variation__r) {
                        setPVId.add(objPrt.Id); 
                    }
                }
                Map<String, Map<String,Set<String>>> mapAttOption = new Map<String, Map<String,Set<String>>>();
                Map<String, Set<String>> mapAttNameOptionForPro = new Map<String, Set<String>>();
                List<BOATBUILDING__Woocom_Variant_Option__c> lstWVO = [Select 
                                                                                Id, Name, BOATBUILDING__Option__c, BOATBUILDING__Part__c, BOATBUILDING__Woocommerce_Attribute__c
                                                                        From 
                                                                                BOATBUILDING__Woocom_Variant_Option__c 
                                                                        Where 
                                                                                BOATBUILDING__Part__c IN: setPVId];
                System.debug('Debug Log For lstWVO: '+lstWVO);
                
                Map<String, String> MapWVO_PId = new Map<String, String>(); 
                if(!lstWVO.isEmpty()) {
                    for(Part__c objPrt: objPart.Part_Variation__r) {
                        for(BOATBUILDING__Woocom_Variant_Option__c objWVO: lstWVO) {
                            if(objWVO.BOATBUILDING__Part__c == objPrt.Id) {
                                MapWVO_PId.put(objWVO.BOATBUILDING__Woocommerce_Attribute__c, objWVO.BOATBUILDING__Part__c);
                            }
                        }
                    }
                }
                
                List<BOATBUILDING__Woocommerce_Attribute__c> lstWA = [Select 
                                                                                Id, Name, BOATBUILDING__WooCom_Attribute_Id__c 
                                                                        From 
                                                                                BOATBUILDING__Woocommerce_Attribute__c 
                                                                        Where 
                                                                                Id IN: MapWVO_PId.keySet()];
                
                
                System.debug('Debug Log For lstWA: '+lstWA);
                
                if(!lstWA.isEmpty()) {
                    for(Part__c objPrt: objPart.Part_Variation__r) {
                        if(!mapAttOption.containsKey(objPart.Id)) {
                            mapAttOption.put(objPrt.Id, new Map<String, Set<String>>());
                        }
                        if(mapAttOption.containsKey(objPrt.Id)) {
                            for(Woocommerce_Attribute__c objWA: lstWA) {
                                for(BOATBUILDING__Woocom_Variant_Option__c objWVO: lstWVO) {
                                    if(objWVO.BOATBUILDING__Woocommerce_Attribute__c == objWA.Id && objWVO.Part__c == objPrt.Id) {          
                                        if(!mapAttOption.get(objPrt.Id).containsKey(objWA.Name)) {
                                            mapAttOption.get(objPrt.Id).put(objWA.Name, new Set<String>());
                                            if(!mapAttNameOptionForPro.containsKey(objWA.Name))
                                                mapAttNameOptionForPro.put(objWA.Name, new Set<String>());
                                        }
                                        if(mapAttOption.get(objPrt.Id).containsKey(objWA.Name)) {
                                            mapAttOption.get(objPrt.Id).get(objWA.Name).add(objWVO.Option__c);
                                            if(mapAttNameOptionForPro.containsKey(objWA.Name))
                                                mapAttNameOptionForPro.get(objWA.Name).add(objWVO.Option__c);
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                }
                System.debug('Debug Log For mapAttOption: '+mapAttOption);
                System.debug('Debug Log For mapAttNameOptionForPro: '+mapAttNameOptionForPro);
                  
	 			List<Attachment> lstAttachment = [SELECT 
	                                                        Id,
	                                                        Name,
	                                                        Body
	                                                FROM
	                                                        Attachment
	                                                WHERE
	                                                        ParentId =: strPartId];
	             
	             List<ContentDocumentLink> lstContentDocLink = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =:strPartId];
	             Set<String> setCDLId = new Set<String>();
	             for(ContentDocumentLink cdl: lstContentDocLink){
	                 setCDLId.add(cdl.ContentDocumentId);
	             }
	             
	             //List<ContentDocument> lstContentDoc = [SELECT Id FROM ContentDocument WHERE Id In :lstContentDocLink];
				
	             List<ContentVersion> lstContentVersion = [select id,FileType, Title,FileExtension, Versiondata from ContentVersion where islatest=true AND ContentDocumentId IN : setCDLId];
	 			
	             List<String> lstAttBase64 = new List<String>(); 
	             if(!lstAttachment.isEmpty()) {
	                 for(Attachment objAtt: lstAttachment) {
	                     if(objAtt.Body != null) {
	                         String strBase64 = EncodingUtil.base64Encode(objAtt.Body);
	                         lstAttBase64.add(strBase64);
	                     }
	                 }
	             }	
	             
	             if(!lstContentVersion.isEmpty()) {
	                 for(ContentVersion objAtt: lstContentVersion) {
	                     if(objAtt.Versiondata != null) {
	                         String strBase64 = EncodingUtil.base64Encode(objAtt.Versiondata);
	                         lstAttBase64.add(strBase64);
	                     }
	                 }
	             }	
	             System.debug('lstAttBase64---'+lstAttBase64);
	             List<Part__c> lstPart = new List<Part__c>();
	             if(String.isNotBlank(objPart.BOATBUILDING__Category1__c)) {
	                 String ProductId = '';
	                 String strResponse = pushPartToShopify(objPart, objSC, lstAttBase64, mapAttOption, mapAttNameOptionForPro);
	                 if(String.isNotBlank(strResponse)) {
	                 	 ShopifyProductParse objShopifyProductParse = ShopifyProductParse.parse(strResponse);
	                 	 ProductId = String.valueOf(objShopifyProductParse.product.id);
		                 System.debug('ProductId: '+ProductId);
		                 objPart.BOATBUILDING__Shopify_Product_Id__c = ProductId;
		                 lstPart.add(objPart);
		                 if(!objPart.Part_Variation__r.isEmpty()) {
		                 	for(ShopifyProductParse.Variants objVar: objShopifyProductParse.Product.variants) {
		                 		for(Part__c objP: objPart.Part_Variation__r) {
		                 			if(objP.SKU__c != null && objP.SKU__c == objVar.sku) {
		                 				objP.BOATBUILDING__Shopify_Product_Id__c = String.valueOf(objVar.id);
		                 				lstPart.add(objP);
		                 			} 
		                 		}
		                 	}
		                 }
		                 String Category = objPart.BOATBUILDING__Category1__c.toUpperCase();
		                 Map<String, String> mapCollectionNameId = getShopifyCollections(objSC);
		                 if(!Test.isRunningTest() && !mapCollectionNameId.containsKey(Category) && String.isNotBlank(ProductId)) {
		                     Map<String, String> mapNewCollection = createCustomCollectionToShopify(Category, objSC);//Take into a map;
		                     System.debug('mapNewCollection: '+mapNewCollection);
		                     mapCollectionNameId.putAll(mapNewCollection); 
		                 }
		                 System.debug('Debug Log For mapCollectionNameId: '+mapCollectionNameId);
		                 
		                 if(!Test.isRunningTest() &&  String.isNotBlank(ProductId)) {
		                     addProductToCollection(ProductId, mapCollectionNameId.get(Category), objSC);
		                     update lstPart;
		                 } else {
		                     return 'Something went wrong please try again.';
		                 }
		                 
		                 return 'SUCCESS';
	                 } else {
	                 	return 'Error JSON: '+strResponse;
	                 }
	             } else {
	                 return 'Please select the category.';
	             }
	         } else {
	             return 'Please Configure Shopify Settings.';
	         }
 		} catch(Exception ex) {
			 System.debug('>>>>>: '+ ex.getMessage() + ' : ' + ex.getLineNumber()+'--'+ex.getStackTraceString());
 			SendEmailUtility.sendQuickEmail('Email For Shopify: ' + ex.getMessage() + ' : ' + ex.getLineNumber()+'--'+ex.getStackTraceString());
 			if(ex.getMessage().containsIgnoreCase('invalid') && ex.getMessage().containsIgnoreCase('conversion')) {
 				return 'Please referesh shopifyId. This part is not synced with shopify.';
 			} else {
 				return 'Email For Shopify: ' + ex.getMessage() + ' : ' + ex.getLineNumber()+'--'+ex.getStackTraceString();
 			}
 		}
        //return null; 
        
    }    
    
    /***************************** Adding product to collection ****************************************************************/
    
    private static void addProductToCollection(String ProductId, String CollectionId, BOATBUILDING__ShopifyConfig__c objSC) {
        String CustomCollectionWithProduct = '{"custom_collection": {"id": '+CollectionId+',"collects": [{"product_id": '+ProductId+'}]  }}';
        HttpRequest req = new HttpRequest();
        req.setMethod('PUT');
        String authStr = objSC.BOATBUILDING__API_Key__c + ':' + objSC.BOATBUILDING__Password__c;
        String covStr = EncodingUtil.base64Encode(Blob.valueOf(authStr));
        req.setHeader('Authorization', 'Basic '+covStr);
        req.setheader('Content-Type', 'application/json');
        req.setBody(CustomCollectionWithProduct);
        req.setEndPoint(objSC.BOATBUILDING__ShopBaseUrl__c+'/admin/custom_collections/'+CollectionId+'.json');
        
        Http h = new Http(); 
        HttpResponse res = h.send(req);
        System.debug('Response: '+res.getBody());
        
    }
    
    /***************************** Creating part as shopify products ****************************************************************/
    
    private static String pushPartToShopify(Part__c objPart, BOATBUILDING__ShopifyConfig__c objSC, List<String> lstAttBase64, Map<String, Map<String,Set<String>>> mapAttOption, Map<String, Set<String>> mapAttNameOptionForPro) {
        String Attachment = '';
        if(!lstAttBase64.isEmpty()) {
            Attachment = '"images": [';
            for(String styBase64: lstAttBase64) {
                Attachment += '{';
                Attachment += 	'"attachment": "' + styBase64 + '"';
                Attachment += '},';
            }
            
            Attachment = Attachment.subString(0, Attachment.length()-1);
            Attachment += ']';
        }
    		
    	String Options = '';	
    	if(!mapAttNameOptionForPro.isEmpty()) {
    		Options = '"options": [';
    		Integer position = 1;
    		for(String strAttName: mapAttNameOptionForPro.keySet()) {
    			Options += '{';
                Options += 	'"name": "' + strAttName + '",';
                Options += '"position":' + position;
                Options += '},';
                position++;
    		}
    		Options = Options.subString(0, Options.length()-1);
            Options += ']';
    	}	
    	System.debug('Options>>>: '+Options);	
	 	String Title = objPart.Name;
	 	String Product_Type = objPart.BOATBUILDING__Category1__c;
	 	String Vendor = '';
		String Tags = '';
		String SubTags = '';
	 	String Pricing = '0.00';
	 	String Compare_Price = '0.00';
	 	String SKU = '';
	 	String Barcode = '';
	 	Boolean This_is_a_Physical_Product = objPart.BOATBUILDING__This_is_a_Physical_Product__c;
	 	String Weight = '0';
	 	String Images = '';
	 	String Quantity = '0';
	 	String Description = '';
	 	String ShopifyId = '';
        String partCost = '0';
        String partNumber = '';
	 	
	 	if(objPart.Vendor_Name__c != null) {
	 		Vendor = objPart.Vendor_Name__r.Name;
	 	}
	 	if(objPart.Family1__c != null) {
	 		Tags = objPart.Family1__c;
	 	}
	 	if(objPart.Retail_Price__c != null) {
	 		Pricing = String.valueOf(objPart.Retail_Price__c);
	 	}
		if(objPart.BOATBUILDING__Sub_Family__c != null) {
			Tags += ','+objPart.BOATBUILDING__Sub_Family__c;
	 	}  
	 	if(objPart.SKU__c != null) {
	 		SKU = objPart.SKU__c;
	 	}
	 	if(objPart.BOATBUILDING__Part_Number__c != null) {
	 		Barcode = objPart.BOATBUILDING__Part_Number__c;
	 	}
	 	
	 	if(objPart.Weight__c != null && objPart.Weight__c.containsIgnoreCase('lbs')) {
	 		Weight = objPart.Weight__c.toLowerCase().replace('lbs','');
	 	} else {
	 		Weight = objPart.Weight__c; 
	 	}
	 	
	 	if(objPart.Quantity__c != null) {
	 		Quantity = String.valueOf(objPart.Quantity__c);
	 	}
	 	if(objPart.BOATBUILDING__Web_Description_long__c != null) {
	 		Description = String.valueOf(objPart.BOATBUILDING__Web_Description_long__c).replaceAll('\r\n', '\\\\n');
	 	}
	 	
	 	if(objPart.BOATBUILDING__Shopify_Product_Id__c != null) {
	 		ShopifyId = String.valueOf(objPart.BOATBUILDING__Shopify_Product_Id__c);
	 	}
        
        if(objPart.BOATBUILDING__Part_Cost__c != null) { 
	 		partCost = String.valueOf(objPart.BOATBUILDING__Part_Cost__c);
	 	}
	 	
	 	 
	 	String str_Product_JSON = '{';
	 	str_Product_JSON += '"product": {';
	 	
	 	str_Product_JSON += 					'"title": "' + Title.replaceAll('"','\\\\"') + '",';
	 	str_Product_JSON += 					'"vendor": "' + Vendor.replaceAll('"','\\\\"') + '",';
	 	str_Product_JSON += 					'"product_type": "' + Product_Type.replaceAll('"','\\\\"') + '",';
	 	str_Product_JSON += 					'"tags": "' + Tags + '",';
	 	if(String.isNotBlank(ShopifyId)) {
	 		str_Product_JSON += 					'"id": "' + ShopifyId + '",';
	 	}
	 	str_Product_JSON += 					'"body_html": "' + Description.replaceAll('"','\\\\"') + '",';
	 	
	 	if(objPart.Part_Variation__r.isEmpty()) {
		 	str_Product_JSON += 					'"variants": ['; 
	      	str_Product_JSON += 									'{';
	        str_Product_JSON += 										'"price": "' + Pricing + '",';
	   		str_Product_JSON += 										'"sku": "' + SKU + '",';
	   		str_Product_JSON +=										'"barcode": "' + Barcode + '",';
	   		str_Product_JSON +=										'"weight": "' + Weight + '",';
	   		str_Product_JSON +=										'"requires_shipping": ' + String.valueOf(This_is_a_Physical_Product) + ',';
	   		str_Product_JSON += 										'"inventory_management": "shopify",';
		 	str_Product_JSON += 										'"inventory_policy": "continue",';
		 	str_Product_JSON += 										'"inventory_quantity": ' + Quantity + ''; 
	       	str_Product_JSON += 									'}';
	   		str_Product_JSON += 									']'; 
	 	} 
	 	else 
	 	{
	 		str_Product_JSON += 					'"variants": [';
	 		for(Part__c objPrt : objPart.Part_Variation__r) {
	 			String strPricing = '0.00';
	 			if(objPrt.Retail_Price__c != null) {
			 		strPricing = String.valueOf(objPrt.Retail_Price__c);
			 	}
	 			String strSKU = '';
	 			if(objPrt.SKU__c != null) {
			 		strSKU = objPrt.SKU__c;
			 	}
	 			String strBarcode = '';
	 			if(objPrt.BOATBUILDING__Part_Number__c != null) {
			 		strBarcode = objPrt.BOATBUILDING__Part_Number__c;
			 	}
	 			String strWeight = '0';
	 			if(objPrt.Weight__c != null && objPrt.Weight__c.containsIgnoreCase('lbs')) {
			 		strWeight = objPrt.Weight__c.toLowerCase().replace('lbs','');
			 	} else {
			 		strWeight = objPrt.Weight__c; 
			 	}
	 			Boolean strThis_is_a_Physical_Product = objPrt.BOATBUILDING__This_is_a_Physical_Product__c;
	 			String strQuantity = '0.00';
	 			if(objPrt.Quantity__c != null) {
			 		strQuantity = String.valueOf(objPrt.Quantity__c);
			 	}
		      	str_Product_JSON += 									'{';
		        str_Product_JSON += 										'"price": "' + strPricing + '",';
		   		str_Product_JSON += 										'"sku": "' + strSKU + '",';
		   		str_Product_JSON +=										'"barcode": "' + strBarcode + '",';
		   		str_Product_JSON +=										'"weight": "' + strWeight + '",';
		   		str_Product_JSON +=										'"requires_shipping": ' + String.valueOf(strThis_is_a_Physical_Product) + ',';
		   		str_Product_JSON += 										'"inventory_management": "shopify",';
			 	str_Product_JSON += 										'"inventory_policy": "continue",';
			 	Map<String, Set<String>> mapOptions = mapAttOption.get(objPrt.Id);
			 	Integer countOptions = 1; 
			 	for(Set<String> strVals: mapOptions.values()) {
			 		if(countOptions <= 3) {
				 		for(String strSetVal: strVals) {
					 		str_Product_JSON += '"option'+countOptions+'": "' + strSetVal + '",';
					 		countOptions ++;
				 		}
			 		}
			 	} 
			 	str_Product_JSON += 										'"inventory_quantity": ' + strQuantity + '';
		       	str_Product_JSON += 									'},';
	 		}	
	 		str_Product_JSON = str_Product_JSON.subString(0, str_Product_JSON.length()-1);
	 		str_Product_JSON += 								']';
	 	}
	 	
	 	if(Attachment != '') { 
	 		str_Product_JSON += 							',';
	 		str_Product_JSON += Attachment;
	 	}
	 	
	 	if(Options != '') {  
	 		str_Product_JSON += 							',';
	 		str_Product_JSON += Options;
	 	}  
	 	
	 	str_Product_JSON += 			  '}';
 		str_Product_JSON += 		   '}';
	 	
	 	System.debug('str_Product_JSON: '+str_Product_JSON);
	 	
	 	HttpRequest req = new HttpRequest();
	 	if(String.isNotBlank(ShopifyId)) {
			req.setMethod('PUT');
	 	} else {
	 		req.setMethod('POST');
	 	}
		String authStr = objSC.BOATBUILDING__API_Key__c + ':' + objSC.BOATBUILDING__Password__c;
		String covStr = EncodingUtil.base64Encode(Blob.valueOf(authStr));
		req.setHeader('Authorization', 'Basic '+covStr);
		req.setheader('Content-Type', 'application/json');
		req.setBody(str_Product_JSON);
		
		if(String.isNotBlank(ShopifyId)) {
			req.setEndPoint(objSC.BOATBUILDING__ShopBaseUrl__c+'/admin/products/'+ShopifyId+'.json');
		} else {
			req.setEndPoint(objSC.BOATBUILDING__ShopBaseUrl__c+'/admin/products.json');
		}
		
		Http h = new Http(); 
		HttpResponse res = h.send(req);
		System.debug('>>>Product Creation: '+res.getBody());
	 	//SendEmailUtility.sendQuickEmail('Email For Shopify: ' + res.getBody());
	 	Map<String, Object> mapRepdata = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
		 
		for(String strKey: mapRepdata.keySet()) {
			System.debug(strKey);
			if(strKey != 'error') {
				Map<String, Object> mpObjData = (Map<String, Object>)mapRepdata.get(strKey);
				return res.getBody(); 
				//return String.valueOf(mpObjData.get('id'));	
			} 	 
		}
	 	
    		return '';
    }
    
    /***************************** Creating categries as shopify collections ****************************************************************/
    
    private static Map<String, String> createCustomCollectionToShopify(String strCollectionTitle, BOATBUILDING__ShopifyConfig__c objSC) {
        try {
            Map<String, String> mapCollectionNameId = new Map<String, String>();
            String str_Collection_JSON = '{';
            str_Collection_JSON += '"custom_collection":';
            str_Collection_JSON += '{';
            str_Collection_JSON += '"title":"'+strCollectionTitle+'"';
            str_Collection_JSON += '}';
            str_Collection_JSON += '}';
            System.debug('Log str_Collection_JSON: '+str_Collection_JSON);
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            String authStr = objSC.BOATBUILDING__API_Key__c + ':' + objSC.BOATBUILDING__Password__c;
            String covStr = EncodingUtil.base64Encode(Blob.valueOf(authStr));
            req.setHeader('Authorization', 'Basic '+covStr);
            req.setheader('Content-Type', 'application/json');
            req.setBody(str_Collection_JSON);
            req.setEndPoint(objSC.BOATBUILDING__ShopBaseUrl__c+'/admin/custom_collections.json');
            
            Http h = new Http();
            HttpResponse res = h.send(req);
            System.debug('>>>Collection Creation: '+res.getBody());
            
            Map<String, Object> mapRepdata = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            
            for(String strKey: mapRepdata.keySet()) {
                System.debug(strKey);
                Map<String, Object> mpObjData = (Map<String, Object>)mapRepdata.get(strKey);
                String strId = String.valueOf(mpObjData.get('id'));
                String strName = String.valueOf(mpObjData.get('title'));
                mapCollectionNameId.put(strName.toUpperCase(), strId);
            }
            
            return mapCollectionNameId;
        } catch(Exception ex) {
            System.debug('Exception: '+ex);
            return null;
        }
    }
    
    /***************************** Fetching list of all collections from shopify ****************************************************************/
    
    private static Map<String, String> getShopifyCollections(BOATBUILDING__ShopifyConfig__c objSC) {
        Map<String, String> mapCollectionNameId = new Map<String, String>();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        String authStr = objSC.BOATBUILDING__API_Key__c + ':' + objSC.BOATBUILDING__Password__c;
        String covStr = EncodingUtil.base64Encode(Blob.valueOf(authStr));
		req.setHeader('Authorization', 'Basic '+covStr);
		req.setEndPoint(objSC.BOATBUILDING__ShopBaseUrl__c+'/admin/custom_collections.json');
		
		Http h = new Http();
		HttpResponse res = h.send(req);
		
		System.debug('>>>: '+res.getBody());
		
		
		Map<String, Object> mapRepdata = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
        if(Test.isRunningTest()){
            return null;
        }
		for(String strKey: mapRepdata.keySet()) {
			System.debug(strKey);
			List<Object> lstCollection = (List<Object>)mapRepdata.get(strKey);
			if(!lstCollection.isEmpty()) {
				for(Object objKey: lstCollection) {
					System.debug('Object: '+objKey);
					Map<String, Object> mpObjData = (Map<String, Object>)objKey;
					String strId = String.valueOf(mpObjData.get('id'));
					String strName = String.valueOf(mpObjData.get('title'));
					mapCollectionNameId.put(strName.toUpperCase(), strId);
				}
			}
		}
		return mapCollectionNameId;
    }
    
}