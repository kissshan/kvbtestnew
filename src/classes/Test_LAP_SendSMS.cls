//modified by:-prashant singh
//code coverage:-77%
@isTest
public class Test_LAP_SendSMS {
  public static Id appID;
    public static void init(){
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        String user_id = userinfo.getUserId();
        Profile p = [SELECT Id FROM Profile WHERE Name='BR_MGR_SMALL']; 
        User dummyUser = new User();
        dummyUser.Alias = 'abcuser';
        dummyUser.Email='tfistandarduser@testorg.com';
        dummyUser.EmailEncodingKey='UTF-8';
        dummyUser.LastName='Testing';
        dummyUser.LanguageLocaleKey='en_US';
        dummyUser.LocaleSidKey='en_IN';
        dummyUser.ProfileId = p.Id;
        dummyUser.TimeZoneSidKey='Asia/Kolkata';
        dummyUser.UserName='niladri.kundu7003084139@etmarlabs.com';
        dummyUser.Branch_Name__c='karur';
       // dummyUser.Role_Name__c='Branch manager';
        insert dummyUser;
        
        Account acc=new Account();
        acc.FirstName='test1';
        acc.LastName='test2';
        acc.Full_Name__c='ttttkkkkkk';
        acc.PersonMobilePhone='917003083139';
        acc.PersonEmail='niladrikundu1993@gmail.com';
        insert acc;
        System.debug('**acc'+acc);
        Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('LAP').getRecordTypeId(); 
        genesis__Applications__c appObj  =  new genesis__Applications__c();
        appObj.Branch_Code__c='1857';//'1857'
        appObj.genesis__Account__c = acc.id;
        appObj.Sub_Stage__c = 'Terms and Conditions Accepted';
        appObj.RecordTypeId = RecordTypeIdgenApp;
        appObj.Sanctioned_Tenure__c = 36;
        appObj.Sanctioned_EMI__c = 2400;
        appObj.genesis__Interest_Rate__c = 12;
        appObj.genesis__Disbursement_Date__c = Date.today();
        appObj.BankYear__c=5;
        appObj.Max_CIBIL_Score__c=755;
        appObj.Active__c = true;
        appObj.Weighted_Average_Income__c=25;
        appObj.Branch_Name__c='karur';
        insert appObj;
        System.debug('*****appObj'+appObj);
        appID=appObj.id;
        System.debug('llllllll'+appObj.genesis__Account__r.name);
        System.debug('eeeeeee'+appObj.Primary_Applicant__c);
        genesis__Application_Parties__c genAppPart= SME_TestUtil.creategenAppPartiForRetail(appObj.Id,acc.Id,'Co-Borrower','Pending');
        genAppPart.Active__c=True;
        genAppPart.Company__c= False;
        insert genAppPart;
        clcommon__Collateral__c cc=new clcommon__Collateral__c();
        cc.Advances_Paid__c=100;
        cc.Branch_Name__c='san';
        cc.Dealer_name__c='test';
        cc.Dealer_Email__c='cc@gmail.com';
        cc.genesis__Application__c=appObj.Id;
        cc.clcommon__Manufacturer__c='ooie';
        cc.clcommon__Model__c='iwej';
        cc.Variant__c='jsdj';
        cc.clcommon__Collateral_Name__c='test123';
        insert cc;
    }
    
    ///personal loan
    
    public static void init2(){
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        String user_id = userinfo.getUserId();
        Profile p = [SELECT Id FROM Profile WHERE Name='BR_MGR_SMALL']; 
        User dummyUser = new User();
        dummyUser.Alias = 'abcuser';
        dummyUser.Email='tfistandarduser@testorg.com';
        dummyUser.EmailEncodingKey='UTF-8';
        dummyUser.LastName='Testing';
        dummyUser.LanguageLocaleKey='en_US';
        dummyUser.LocaleSidKey='en_IN';
        dummyUser.ProfileId = p.Id;
        dummyUser.TimeZoneSidKey='Asia/Kolkata';
        dummyUser.UserName='niladri.kundu7003084139@etmarlabs.com';
        dummyUser.Branch_Name__c='karur';
       // dummyUser.Role_Name__c='Branch manager';
        insert dummyUser;
        
        Account acc=new Account();
        acc.FirstName='test1';
        acc.LastName='test2';
        acc.Full_Name__c='ttttkkkkkk';
        acc.PersonMobilePhone='917003083139';
        acc.PersonEmail='niladrikundu1993@gmail.com';
        insert acc;
        System.debug('**acc'+acc);
        Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Personal Loan').getRecordTypeId(); 
        genesis__Applications__c appObj  =  new genesis__Applications__c();
        appObj.Branch_Code__c='1857';//'1857'
        appObj.genesis__Account__c = acc.id;
        appObj.Sub_Stage__c = 'Terms and Conditions Accepted';
        appObj.RecordTypeId = RecordTypeIdgenApp;
        appObj.Sanctioned_Tenure__c = 36;
        appObj.Sanctioned_EMI__c = 2400;
        appObj.genesis__Interest_Rate__c = 12;
        appObj.genesis__Disbursement_Date__c = Date.today();
        appObj.BankYear__c=5;
        appObj.Max_CIBIL_Score__c=755;
        appObj.Active__c = true;
        appObj.Weighted_Average_Income__c=25;
        appObj.Branch_Name__c='karur';
        appObj.Disbursement_Account_Number__c='62536718973651';
        appObj.Disbursement_Account_Bank_Name__c='45678987654';
        appObj.SI_Account_Number__c='34543';
        appObj.Loan_Account_Number__c='56789000';
        appObj.SI_Bank_Name__c='psit';
        appObj.Sanction_Authority_Limit__c=100000;
        insert appObj;
        System.debug('*****appObj'+appObj);
        appID=appObj.id;
        System.debug('llllllll'+appObj.genesis__Account__r.name);
        System.debug('eeeeeee'+appObj.Primary_Applicant__c);
        genesis__Application_Parties__c genAppPart= SME_TestUtil.creategenAppPartiForRetail(appObj.Id,acc.Id,'Co-Borrower','Pending');
        genAppPart.Active__c=True;
        genAppPart.Company__c= False;
        insert genAppPart;
        clcommon__Collateral__c cc=new clcommon__Collateral__c();
        cc.Advances_Paid__c=100;
        cc.Branch_Name__c='san';
        cc.Dealer_name__c='test';
        cc.Dealer_Email__c='cc@gmail.com';
        cc.genesis__Application__c=appObj.Id;
        cc.clcommon__Manufacturer__c='ooie';
        cc.clcommon__Model__c='iwej';
        cc.Variant__c='jsdj';
        cc.clcommon__Collateral_Name__c='test123';
        insert cc;
    }
    
   
    @istest
    public static void method1(){
        init();
        System.debug('appid'+appID);
        genesis__Applications__c appObj1=[select id,Primary_Applicant_Mobile__c,Person_Email__c,genesis__Account__r.name,Primary_Applicant__c,name,RecordTypeId,Record_Type_Name__c,Sub_Stage__c,genesis__Interest_Rate__c,(select id,name,Applicant_Name__c from genesis__Application_Parties__r) from genesis__Applications__c where id =:appID];
         appObj1.Sub_Stage__c='Terms and Conditions Accepted';
        update appObj1;
        System.debug('appid'+appObj1);
        LAP_SendSMS.sendSMSSubstage(JSON.serialize(appObj1));
        
    }
     @istest
    public static void method2(){
        init();
        genesis__Applications__c appObj1=[select id,Primary_Applicant_Mobile__c,Person_Email__c,genesis__Account__r.PersonEmail,genesis__Account__r.name,Primary_Applicant__c,name,RecordTypeId,Record_Type_Name__c,Sub_Stage__c,genesis__Interest_Rate__c,(select id,name,Applicant_Name__c from genesis__Application_Parties__r) from genesis__Applications__c where id =:appID];

        appObj1.Sub_Stage__c='Loan Sanctioned Non-STP';
        update appObj1;
        System.debug('**Primary_Applicant__c'+appObj1.Primary_Applicant__c);
        LAP_SendSMS.sendSMSSubstage(JSON.serialize(appObj1));
        
    }
    @istest
    public static void method3(){
        init();
      
        genesis__Applications__c appObj1=[select id,Primary_Applicant_Mobile__c,Person_Email__c,genesis__Account__r.PersonEmail,genesis__Account__r.name,Primary_Applicant__c,name,RecordTypeId,Record_Type_Name__c,Sub_Stage__c,genesis__Interest_Rate__c,(select id,name,Applicant_Name__c from genesis__Application_Parties__r) from genesis__Applications__c where id =:appID];
        appObj1.Sub_Stage__c='Disbursement Documents Esigned';
        update appObj1;
        System.debug('**Primary_Applicant__c'+appObj1.Primary_Applicant__c);
        LAP_SendSMS.sendSMSSubstage(JSON.serialize(appObj1));
        
    }
    @istest
    public static void method4(){
        init();
         genesis__Applications__c appObj1=[select id,Branch_Name__c,Primary_Applicant_Mobile__c,Person_Email__c,genesis__Account__r.PersonEmail,genesis__Account__r.name,Primary_Applicant__c,name,RecordTypeId,Record_Type_Name__c,Sub_Stage__c,genesis__Interest_Rate__c,(select id,name,Applicant_Name__c from genesis__Application_Parties__r) from genesis__Applications__c where id =:appID];
        appObj1.Sub_Stage__c='SI details captured';
        update appObj1;
        System.debug('**Primary_Applicant__c'+appObj1.Primary_Applicant__c);
        LAP_SendSMS.sendSMSSubstage(JSON.serialize(appObj1));
        
    }
     @istest
    public static void method5(){
        init();
         genesis__Applications__c appObj1=[select id,Branch_Name__c,Primary_Applicant_Mobile__c,Person_Email__c,genesis__Account__r.PersonEmail,genesis__Account__r.name,Primary_Applicant__c,name,RecordTypeId,Record_Type_Name__c,Sub_Stage__c,genesis__Interest_Rate__c,(select id,name,Applicant_Name__c from genesis__Application_Parties__r) from genesis__Applications__c where id =:appID];
        appObj1.Sub_Stage__c='Loan account opened';
        update appObj1;
        System.debug('**Primary_Applicant__c'+appObj1.Primary_Applicant__c);
        LAP_SendSMS.sendSMSSubstage(JSON.serialize(appObj1));
        
    }

   ////personal loan
    @istest
    public static void method6(){
        init2();
        System.debug('appid'+appID);
        genesis__Applications__c appObj1=[select id,Primary_Applicant_Mobile__c,Person_Email__c,genesis__Account__r.name,Primary_Applicant__c,name,RecordTypeId,Record_Type_Name__c,Sub_Stage__c,genesis__Interest_Rate__c,(select id,name,Applicant_Name__c from genesis__Application_Parties__r) from genesis__Applications__c where id =:appID];
         appObj1.Sub_Stage__c='Terms and Conditions Accepted';
        update appObj1;
        System.debug('appid'+appObj1);
        LAP_SendSMS.sendSms(JSON.serialize(appObj1));
        
    }
     @istest
    public static void method7(){
        init2();
        genesis__Applications__c appObj1=[select id,Sanction_Authority_Limit__c,Primary_Applicant_Mobile__c,Person_Email__c,genesis__Account__r.PersonEmail,genesis__Account__r.name,Primary_Applicant__c,name,RecordTypeId,Record_Type_Name__c,Sub_Stage__c,genesis__Interest_Rate__c,(select id,name,Applicant_Name__c from genesis__Application_Parties__r) from genesis__Applications__c where id =:appID];

        appObj1.Sub_Stage__c='Loan Sanctioned Non-STP';
        update appObj1;
        System.debug('**Primary_Applicant__c'+appObj1.Primary_Applicant__c);
        LAP_SendSMS.sendSms(JSON.serialize(appObj1));
        
    } 

     @istest
    public static void method8(){
        init2();
      
        genesis__Applications__c appObj1=[select id,Primary_Applicant_Mobile__c,Person_Email__c,genesis__Account__r.PersonEmail,genesis__Account__r.name,Primary_Applicant__c,name,RecordTypeId,Record_Type_Name__c,Sub_Stage__c,genesis__Interest_Rate__c,(select id,name,Applicant_Name__c from genesis__Application_Parties__r) from genesis__Applications__c where id =:appID];
        appObj1.Sub_Stage__c='Disbursement Documents Esigned';
        update appObj1;
        System.debug('**Primary_Applicant__c'+appObj1.Primary_Applicant__c);
        LAP_SendSMS.sendSms(JSON.serialize(appObj1));
        
    }
    @istest
    public static void method9(){
        init2();
         genesis__Applications__c appObj1=[select id,SI_Bank_Name__c,SI_Account_Number__c,Disbursement_Account_Bank_Name__c,Disbursement_Account_Number__c,Branch_Name__c,Primary_Applicant_Mobile__c,Person_Email__c,genesis__Account__r.PersonEmail,genesis__Account__r.name,Primary_Applicant__c,name,RecordTypeId,Record_Type_Name__c,Sub_Stage__c,genesis__Interest_Rate__c,(select id,name,Applicant_Name__c from genesis__Application_Parties__r) from genesis__Applications__c where id =:appID];
        appObj1.Sub_Stage__c='SI details captured';
        update appObj1;
        System.debug('**Primary_Applicant__c'+appObj1.Primary_Applicant__c);
        LAP_SendSMS.sendSms(JSON.serialize(appObj1));
        
    }
     @istest
    public static void method10(){
        init2();
         genesis__Applications__c appObj1=[select id,Loan_Account_Number__c,Disbursement_Account_Number__c,Disbursement_Account_Bank_Name__c,Branch_Name__c,Primary_Applicant_Mobile__c,Person_Email__c,genesis__Account__r.PersonEmail,genesis__Account__r.name,Primary_Applicant__c,name,RecordTypeId,Record_Type_Name__c,Sub_Stage__c,genesis__Interest_Rate__c,(select id,name,Applicant_Name__c from genesis__Application_Parties__r) from genesis__Applications__c where id =:appID];
        appObj1.Sub_Stage__c='Loan account opened';
        update appObj1;
        System.debug('**Primary_Applicant__c'+appObj1.Primary_Applicant__c);
        LAP_SendSMS.sendSms(JSON.serialize(appObj1));
        
    }  
      @istest
    public static void method11(){
        init();
         genesis__Applications__c appObj1=[select id,Primary_Applicant_Mobile__c,Person_Email__c,genesis__Account__r.PersonEmail,genesis__Account__r.name,Primary_Applicant__c,name,RecordTypeId,Record_Type_Name__c,Sub_Stage__c,genesis__Interest_Rate__c,(select id,name,Applicant_Name__c from genesis__Application_Parties__r) from genesis__Applications__c where id =:appID];
        appObj1.Sub_Stage__c='Low CIBIL Score';
        update appObj1;
        System.debug('**Primary_Applicant__c'+appObj1.Primary_Applicant__c);
        LAP_SendSMS.sendSMSonCrt1(JSON.serialize(appObj1));
        
    }
    @istest
    public static void method12(){
        init2();
         genesis__Applications__c appObj1=[select id,Branch_Name__c,Primary_Applicant_Mobile__c,Person_Email__c,genesis__Account__r.PersonEmail,genesis__Account__r.name,Primary_Applicant__c,name,RecordTypeId,Record_Type_Name__c,Sub_Stage__c,genesis__Interest_Rate__c,(select id,name,Applicant_Name__c from genesis__Application_Parties__r) from genesis__Applications__c where id =:appID];
        appObj1.Sub_Stage__c='Application created';
        update appObj1;
        System.debug('**Primary_Applicant__c'+appObj1.Primary_Applicant__c);
        LAP_SendSMS.sendSms(JSON.serialize(appObj1));
        
    }
     @istest
    public static void method13(){
        init2();
         genesis__Applications__c appObj1=[select id,Branch_Name__c,Primary_Applicant_Mobile__c,Person_Email__c,genesis__Account__r.PersonEmail,genesis__Account__r.name,Primary_Applicant__c,name,RecordTypeId,Record_Type_Name__c,Sub_Stage__c,genesis__Interest_Rate__c,(select id,name,Applicant_Name__c from genesis__Application_Parties__r) from genesis__Applications__c where id =:appID];
        appObj1.Sub_Stage__c='Disbursement Info Captured';
        update appObj1;
        System.debug('**Primary_Applicant__c'+appObj1.Primary_Applicant__c);
        LAP_SendSMS.sendSms(JSON.serialize(appObj1));
        
    }
     @istest
    public static void method14(){
        init2();
         genesis__Applications__c appObj1=[select id,Branch_Name__c,Primary_Applicant_Mobile__c,Person_Email__c,genesis__Account__r.PersonEmail,genesis__Account__r.name,Primary_Applicant__c,name,RecordTypeId,Record_Type_Name__c,Sub_Stage__c,genesis__Interest_Rate__c,(select id,name,Applicant_Name__c from genesis__Application_Parties__r) from genesis__Applications__c where id =:appID];
        appObj1.Application_Stage__c='Application Rejected';
        update appObj1;
        System.debug('**Primary_Applicant__c'+appObj1.Primary_Applicant__c);
        LAP_SendSMS.sendSms(JSON.serialize(appObj1));
        
    }
         @istest
    public static void method15(){
 Account acc=new Account();
        acc.FirstName='test1';
        acc.LastName='test2';
        acc.Full_Name__c='ttttkkkkkk';
        acc.PersonMobilePhone='917003083139';
        acc.PersonEmail='niladrikundu1993@gmail.com';
        insert acc;
        System.debug('**acc'+acc);
        Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Personal Loan').getRecordTypeId(); 
        genesis__Applications__c appObj  =  new genesis__Applications__c();
        appObj.Branch_Code__c='1857';//'1857'
        appObj.genesis__Account__c = acc.id;
        appObj.Sub_Stage__c = 'Terms and Conditions Accepted';
        appObj.RecordTypeId = RecordTypeIdgenApp;
        appObj.Sanctioned_Tenure__c = 36;
        appObj.Sanctioned_EMI__c = 2400;
        appObj.genesis__Interest_Rate__c = 12;
        appObj.genesis__Disbursement_Date__c = Date.today();
        appObj.BankYear__c=5;
        appObj.Max_CIBIL_Score__c=755;
        appObj.Active__c = true;
        appObj.Weighted_Average_Income__c=25;
        appObj.Branch_Name__c='karur';
        insert appObj;
        System.debug('*****appObj'+appObj);
        appID=appObj.id;
        System.debug('llllllll'+appObj.genesis__Account__r.name);
        System.debug('eeeeeee'+appObj.Primary_Applicant__c);
        genesis__Application_Parties__c genAppPart= SME_TestUtil.creategenAppPartiForRetail(appObj.Id,acc.Id,'Guarantor','Pending');
        genAppPart.Active__c=True;
        genAppPart.Company__c= False;
        //genAppPart.genesis__Party_Type__c='Guarantor';
        //genAppPart.genesis__Application__c =appObj.id;
        insert genAppPart;
        genAppPart=[select id,Application_No__c,Applicant_Name__c,Party_Mobile_No__c,genesis__Party_Account_Name__r.PersonMobilePhone,genesis__Party_Type__c,genesis__Party_Account_Name__r.FirstName,genesis__Party_Account_Name__r.LastName from genesis__Application_Parties__c];
        system.debug('genAppPart:-'+genAppPart);
        LAP_SendSMS.sendSMSParties(json.serialize(genAppPart));

        
    } 
     @istest
    public static void method16(){
 Account acc=new Account();
        acc.FirstName='test1';
        acc.LastName='test2';
        acc.Full_Name__c='ttttkkkkkk';
        acc.PersonMobilePhone='917003083139';
        acc.PersonEmail='niladrikundu1993@gmail.com';
        insert acc;
        System.debug('**acc'+acc);
        Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Personal Loan').getRecordTypeId(); 
        genesis__Applications__c appObj  =  new genesis__Applications__c();
        appObj.Branch_Code__c='1857';//'1857'
        appObj.genesis__Account__c = acc.id;
        appObj.Sub_Stage__c = 'Terms and Conditions Accepted';
        appObj.RecordTypeId = RecordTypeIdgenApp;
        appObj.Sanctioned_Tenure__c = 36;
        appObj.Sanctioned_EMI__c = 2400;
        appObj.genesis__Interest_Rate__c = 12;
        appObj.genesis__Disbursement_Date__c = Date.today();
        appObj.BankYear__c=5;
        appObj.Max_CIBIL_Score__c=755;
        appObj.Active__c = true;
        appObj.Weighted_Average_Income__c=25;
        appObj.Branch_Name__c='karur';
        insert appObj;
        System.debug('*****appObj'+appObj);
        appID=appObj.id;
        System.debug('llllllll'+appObj.genesis__Account__r.name);
        System.debug('eeeeeee'+appObj.Primary_Applicant__c);
        genesis__Application_Parties__c genAppPart= SME_TestUtil.creategenAppPartiForRetail(appObj.Id,acc.Id,'Co-Borrower','Pending');
        genAppPart.Active__c=True;
        genAppPart.Company__c= False;
        //genAppPart.genesis__Party_Type__c='Guarantor';
        //genAppPart.genesis__Application__c =appObj.id;
        insert genAppPart;
        genAppPart=[select id,Application_No__c,Applicant_Name__c,Party_Mobile_No__c,genesis__Party_Account_Name__r.PersonMobilePhone,genesis__Party_Type__c,genesis__Party_Account_Name__r.FirstName,genesis__Party_Account_Name__r.LastName from genesis__Application_Parties__c];
        system.debug('genAppPart:-'+genAppPart);
        LAP_SendSMS.sendSMSParties(json.serialize(genAppPart));

        
    } 
    @istest
    public static void method17(){
 Account acc=new Account();
        acc.FirstName='test1';
        acc.LastName='test2';
        acc.Full_Name__c='ttttkkkkkk';
        acc.PersonMobilePhone='917003083139';
        acc.PersonEmail='niladrikundu1993@gmail.com';
        insert acc;
        System.debug('**acc'+acc);
        Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Personal Loan').getRecordTypeId(); 
        genesis__Applications__c appObj  =  new genesis__Applications__c();
        appObj.Branch_Code__c='1857';//'1857'
        appObj.genesis__Account__c = acc.id;
        appObj.Sub_Stage__c = 'Terms and Conditions Accepted';
        appObj.RecordTypeId = RecordTypeIdgenApp;
        appObj.Sanctioned_Tenure__c = 36;
        appObj.Sanctioned_EMI__c = 2400;
        appObj.genesis__Interest_Rate__c = 12;
        appObj.genesis__Disbursement_Date__c = Date.today();
        appObj.BankYear__c=5;
        appObj.Max_CIBIL_Score__c=755;
        appObj.Active__c = true;
        appObj.Weighted_Average_Income__c=25;
        appObj.Branch_Name__c='karur';
        insert appObj;
        appObj.Sub_Stage__c = 'Loan Account Open';
        System.debug('*****appObj'+appObj);
        appID=appObj.id;
        System.debug('llllllll'+appObj.genesis__Account__r.name);
        System.debug('eeeeeee'+appObj.Primary_Applicant__c);
        genesis__Application_Parties__c genAppPart= SME_TestUtil.creategenAppPartiForRetail(appObj.Id,acc.Id,'Co-Borrower','Pending');
        genAppPart.Active__c=True;
        genAppPart.Company__c= False;
        //genAppPart.genesis__Party_Type__c='Guarantor';
        //genAppPart.genesis__Application__c =appObj.id;
        insert genAppPart;
        genAppPart=[select id,Application_No__c,Applicant_Name__c,Party_Mobile_No__c,genesis__Party_Account_Name__r.PersonMobilePhone,genesis__Party_Type__c,genesis__Party_Account_Name__r.FirstName,genesis__Party_Account_Name__r.LastName from genesis__Application_Parties__c];
        system.debug('genAppPart:-'+genAppPart);
        List<id> appidlist=new List<id>();
        appidlist.add(appObj.id);
       /* genesis__Applications__History apphis=new genesis__Applications__History();
        apphis.parentId=appObj.id;
        apphis.Field='Sub_Stage__c';
        insert apphis;*/
        List<genesis__Applications__History> apphislist=[select field,OldValue from genesis__Applications__History where parentId=:appObj.id  AND Field='Sub_Stage__c' ];
           
        LAP_SendSMS.RejectSMS(appidlist);

        
    }
    
      @istest
    public static void method19(){
        init2();
           genesis__Applications__c appObj1=[select id,Application_Stage__c,Branch_Name__c,Primary_Applicant_Mobile__c,Person_Email__c,genesis__Account__r.PersonEmail,genesis__Account__r.name,Primary_Applicant__c,name,RecordTypeId,Record_Type_Name__c,Sub_Stage__c,genesis__Interest_Rate__c,(select id,name,Applicant_Name__c from genesis__Application_Parties__r) from genesis__Applications__c where id =:appID];
        appObj1.Sub_Stage__c='Low CIBIL Score';
        appObj1.Application_Stage__c='Application Rejected';
        update appObj1;
        System.debug('**Primary_Applicant__c'+appObj1.Primary_Applicant__c);
        LAP_SendSMS.sendSms(JSON.serialize(appObj1));
        }
}