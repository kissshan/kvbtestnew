@isTest
public class TestUtility {
    public static genesis__Applications__c newApp;
    public static Account acc;
    public static genesis__Applications__c intialSetUp(String productName,boolean createParty){
        clcommon__CL_Product__c product = new clcommon__CL_Product__c(clcommon__Product_Name__c=productName);
        insert product;
        acc = new Account(firstName='Venu',LastName='Gopal', Employment_Type__c = 'Salaried',Jocata_TxnId__c = '12345');
        insert acc;
        Account acc1 = new Account(firstName='Venu1',LastName='Gopal1', Employment_Type__c = 'Self-Employed Businessman',Jocata_TxnId__c = '12345');
        insert acc1;
        
        if(createParty){
            genesis__Application_Parties__c party =new genesis__Application_Parties__c();
            
            
            party.Key_Contact__c = acc.id;
            party.genesis__Party_Account_Name__c=acc.id;
            party.genesis__Party_Type__c = Constants.Co_Borrower;
            party.Active__c = true;
            insert party;
            
            genesis__Application_Parties__c party1 =new genesis__Application_Parties__c();
            
            party1.Key_Contact__c = acc1.id;
            party1.genesis__Party_Account_Name__c=acc1.id;
            party1.genesis__Party_Type__c = Constants.Co_Borrower;
            party1.Active__c = true;
            insert party1;
        }
        
        newApp = new genesis__Applications__c();
        newApp.genesis__Loan_Amount__c = 100000;
        newApp.genesis__Term__c =12;
        newApp.genesis__Amortization_Term__c = 12;
        newApp.genesis__Loan_Number__c = 'TS123'; 
        newApp.genesis__Interest_Rate__c = 15;
        newApp.genesis__Payment_Frequency__c = 'Monthly';
        newApp.genesis__Account__c =acc.id;
        newApp.genesis__CL_Product__c = product.id;
        newApp.Sub_Stage__c = 'Disbursement Rejected';
        newApp.Branch_City__c = '1858';
        newApp.branch_Code__c = '1858';
        newApp.Flags_Raised__c=false;
        newApp.Charges_Processed__c=true;
        
        INSERT newApp;
        System.debug('@AJ+newApp:::'+newApp.genesis__Account__c);
        System.debug(newApp.genesis__Account__r.Id+'==='+newApp.genesis__Account__r.Jocata_TxnId__c+'=='+newApp.genesis__Account__r.Name);
        //newApp.genesis__Account__r.Jocata_TxnId__c = 'asas';//acc.Jocata_TxnId__c;
        //newApp.Application_Stage__c = 'Sanction complete- Final Sanction';
        
        //insert newApp;
        return  newApp;
        
        
    }
    
    // Parties creation
    
    public static genesis__Application_Parties__c createAppParties(String AccID,string CoAppID){
        genesis__Application_Parties__c gap = new genesis__Application_Parties__c();
        gap.Key_Contact__c = CoAppID;
        gap.genesis__Party_Account_Name__c=AccID;
        gap.genesis__Party_Type__c = Constants.Co_Borrower;
        
        return gap;
    }
    
    Public static void webserviceRequest(String url,String method,Blob body){
        
        RestRequest req=new RestRequest();
        RestResponse res=new RestResponse();
        req.requestURI=url;
        req.requestBody=body;
        req.httpMethod=method;
        RestContext.request=req;
        RestContext.response=res;
    }
    public static genesis__Document_Category__c createDocumentCat(String genesisCategoryName){
        genesis__Document_Category__c newDoc = new genesis__Document_Category__c();
        newDoc.genesis__Category_Name__c = genesisCategoryName;
        INSERT newDoc;
        RETURN newDoc;
    }
    
    // create M68 Balance Sheet Data
    public static M68_Balance_Sheet_Analysis__c createM68_Balance_Sheet_Analysis(String accId, String financialType, String fiscalYear, Decimal netSales, Decimal purchase, Decimal sundryCreditor, Decimal sundryDebtor){
        
        M68_Balance_Sheet_Analysis__c m68 = new M68_Balance_Sheet_Analysis__c();
        m68.Account__c = accId;
        m68.Financial_type__c = financialType;
        m68.Fiscal_Year__c = fiscalYear;
        m68.Net_sales__c = netSales;
        m68.Purchases__c = purchase;
        m68.Sundry_Creditors__c = sundryCreditor;
        m68.Sundry_Debtors__c = sundryDebtor;
        
        
        return m68;
    }
    
    //method to create user
    /* public static User createUser(String LName ,String FName,String UEmail ,String UName , String empCode,String profileName, String callpreference, String MobilePhone, String phone){
Profile p = [SELECT Id, Name FROM Profile WHERE Name =: profileName]; 
//UserRole userRMRol = [SELECT DeveloperName,Id FROM UserRole WHERE DeveloperName =: role]; 
User userData = new User(Alias = 'standt1', 
Email= UEmail, 
EmailEncodingKey='UTF-8', 
FirstName = FName,
LastName = LName, 
EmployeeNumber = empCode,                                   
LanguageLocaleKey='en_US', 
LocaleSidKey='en_AU', 
TimeZoneSidKey = 'Asia/Kolkata',
CommunityNickname = LName,
ProfileId = p.Id, 
MobilePhone = MobilePhone,
phone = phone,
UserName= UName
);
return userData;
}*/
    
    
}