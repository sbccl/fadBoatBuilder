@RestResource(urlMapping = '/woocom/*')
global class GetInvJsonWoocommerce {
	@HttpGet
	global static String doGet() {
	    return 'Hey There Woocommerce';
	}
	
	@HttpPost
	global static void doPost() {
		
	}
   
}