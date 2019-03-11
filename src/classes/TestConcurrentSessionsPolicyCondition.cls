@isTest 

private class TestConcurrentSessionsPolicyCondition {
	
	@isTest
	public static  void testRunAs() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; //(SeeAllData=true)
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@vignu.com');

        System.runAs(u) {
            
            String uId= UserInfo.getUserId();
			
			/*AuthSession authSes= new AuthSession();
			authSes.UsersId= uId;
 			insert authSes;*/
 			List<AuthSession> authSes= [select UsersId, Id FROM AuthSession ];   //where UsersId=:uId       
            /*LoginHistory loginHistoryObj = [ SELECT Platform FROM LoginHistory where UserId=: uId  Limit 1];
				LoginHistory loginHistoryObj = new LoginHistory();
				insert loginHistoryObj;*/

                /* Create a map for the event we’re going to build. */
                Map<String, String> eventData = new Map<String, String>();
                /* Insert the LoginHistoryId into the event data map. */
                //eventData.put('LoginHistoryId', loginHistoryObj.id);
            	eventData.put('UserId', uId);
            
             TxnSecurity.Event e = new TxnSecurity.Event(
                  UserInfo.getOrganizationId(), /* organizationId */
                  UserInfo.getUserId(), /* userId */
                  'AuthSession', /* entityName */
                  'Login', /* action */
                  'LoginHistory', /* resourceName */
                  '01pR00000009D2H',/*, authSes[0].Id  entityId */
                  Datetime.newInstance(2016, 2, 15), /* timeStamp */
                  eventData);
            
            test.startTest();
            ConcurrentSessionsPolicyConditionCustom secu= new ConcurrentSessionsPolicyConditionCustom();
            ConcurrentSessionsPolicyConditionCustom.getCover();
            secu.evaluate(e);
            test.stopTest();

        }
    }
 

	
}