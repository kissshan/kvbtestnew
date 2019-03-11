/*
    @purpose    : get Test User record for Test Class
    @return Type: User
    */
public class Utility_Test {
   
    public static User createUser(string dummyusername){
        String user_id = userinfo.getUserId();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User dummyUser = new User(Alias = 'abcuser', Email='tfistandarduser@testorg.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_IN', ProfileId = p.Id,TimeZoneSidKey='Asia/Kolkata',UserName=dummyusername);
        return dummyUser;
    }
    
    public static Account createAccount(String name, String Branch_Code, String CBS_CustomerId){
        Account  acc = new Account(Name=name,Branch_Code__c=Branch_Code,CBS_Customer_ID__c=CBS_CustomerId);
        return acc;
    }
    public static genesis__Applications__c createApplication(String Branch_Code,Id accID){
    	genesis__Applications__c	appObj	=	new genesis__Applications__c(Branch_Code__c=Branch_Code,genesis__Account__c=accID);
    	return appObj;
    }
 }