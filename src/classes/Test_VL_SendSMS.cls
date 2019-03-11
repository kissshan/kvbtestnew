@isTest
public class Test_VL_SendSMS {
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
        Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('VL4W').getRecordTypeId(); 
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
    
    @istest
    public static void method1(){
        init();
        System.debug('appid'+appID);
        genesis__Applications__c appObj1=[select id,Primary_Applicant_Mobile__c,Person_Email__c,genesis__Account__r.name,Primary_Applicant__c,name,RecordTypeId,Record_Type_Name__c,Sub_Stage__c,genesis__Interest_Rate__c,(select id,name,Applicant_Name__c from genesis__Application_Parties__r) from genesis__Applications__c where id =:appID];
         appObj1.Sub_Stage__c='Terms and Conditions Accepted';
        update appObj1;
        System.debug('appid'+appObj1);
        VL_SendSMS.sendSMSSubstageVL(JSON.serialize(appObj1));
        
    }
     @istest
    public static void method2(){
        init();
        genesis__Applications__c appObj1=[select id,Primary_Applicant_Mobile__c,Person_Email__c,genesis__Account__r.PersonEmail,genesis__Account__r.name,Primary_Applicant__c,name,RecordTypeId,Record_Type_Name__c,Sub_Stage__c,genesis__Interest_Rate__c,(select id,name,Applicant_Name__c from genesis__Application_Parties__r) from genesis__Applications__c where id =:appID];

        appObj1.Sub_Stage__c='Loan Sanctioned Non-STP';
        update appObj1;
        System.debug('**Primary_Applicant__c'+appObj1.Primary_Applicant__c);
        VL_SendSMS.sendSMSSubstageVL(JSON.serialize(appObj1));
        
    }
    @istest
    public static void method3(){
        init();
      
        genesis__Applications__c appObj1=[select id,Primary_Applicant_Mobile__c,Person_Email__c,genesis__Account__r.PersonEmail,genesis__Account__r.name,Primary_Applicant__c,name,RecordTypeId,Record_Type_Name__c,Sub_Stage__c,genesis__Interest_Rate__c,(select id,name,Applicant_Name__c from genesis__Application_Parties__r) from genesis__Applications__c where id =:appID];
        appObj1.Sub_Stage__c='Disbursement Documents Esigned';
        update appObj1;
        System.debug('**Primary_Applicant__c'+appObj1.Primary_Applicant__c);
        VL_SendSMS.sendSMSSubstageVL(JSON.serialize(appObj1));
        
    }
    @istest
    public static void method4(){
        init();
         genesis__Applications__c appObj1=[select id,Branch_Name__c,Primary_Applicant_Mobile__c,Person_Email__c,genesis__Account__r.PersonEmail,genesis__Account__r.name,Primary_Applicant__c,name,RecordTypeId,Record_Type_Name__c,Sub_Stage__c,genesis__Interest_Rate__c,(select id,name,Applicant_Name__c from genesis__Application_Parties__r) from genesis__Applications__c where id =:appID];
        appObj1.Sub_Stage__c='SI details captured';
        update appObj1;
        System.debug('**Primary_Applicant__c'+appObj1.Primary_Applicant__c);
        VL_SendSMS.sendSMSSubstageVL(JSON.serialize(appObj1));
        
    }
     @istest
    public static void method5(){
        init();
         genesis__Applications__c appObj1=[select id,Branch_Name__c,Primary_Applicant_Mobile__c,Person_Email__c,genesis__Account__r.PersonEmail,genesis__Account__r.name,Primary_Applicant__c,name,RecordTypeId,Record_Type_Name__c,Sub_Stage__c,genesis__Interest_Rate__c,(select id,name,Applicant_Name__c from genesis__Application_Parties__r) from genesis__Applications__c where id =:appID];
        appObj1.Sub_Stage__c='Loan account opened';
        update appObj1;
        System.debug('**Primary_Applicant__c'+appObj1.Primary_Applicant__c);
        VL_SendSMS.sendSMSSubstageVL(JSON.serialize(appObj1));
        
    }
      @istest
    public static void method6(){
        init();
         genesis__Applications__c appObj1=[select id,Branch_Name__c,Primary_Applicant_Mobile__c,Person_Email__c,genesis__Account__r.PersonEmail,genesis__Account__r.name,Primary_Applicant__c,name,RecordTypeId,Record_Type_Name__c,Sub_Stage__c,genesis__Interest_Rate__c,(select id,name,Applicant_Name__c from genesis__Application_Parties__r) from genesis__Applications__c where id =:appID];
        appObj1.Sub_Stage__c='Low CIBIL Score';
        update appObj1;
        System.debug('**Primary_Applicant__c'+appObj1.Primary_Applicant__c);
        VL_SendSMS.sendSMSSubstageVL(JSON.serialize(appObj1));
        
    }
     @istest
    public static void method7(){
        init();
         genesis__Applications__c appObj1=[select id,Primary_Applicant_Mobile__c,Person_Email__c,genesis__Account__r.PersonEmail,genesis__Account__r.name,Primary_Applicant__c,name,RecordTypeId,Record_Type_Name__c,Sub_Stage__c,genesis__Interest_Rate__c,(select id,name,Applicant_Name__c from genesis__Application_Parties__r) from genesis__Applications__c where id =:appID];
        appObj1.Sub_Stage__c='Low CIBIL Score';
        update appObj1;
        System.debug('**Primary_Applicant__c'+appObj1.Primary_Applicant__c);
        VL_SendSMS.sendSMSonCrtVL(JSON.serialize(appObj1));
        
    }
    
     @istest
    public static void metho8(){
        init();
        genesis__Application_Parties__c genAppPart=[SELECT ID,genesis__Application__r.Record_Type_Name__c, Party_Email__c, Party_Mobile_No__c, genesis__Application__r.genesis__Loan_Amount__c, genesis__Application__r.Processing_Fee__c, genesis__Party_Account_Name__r.PersonEmail, genesis__Party_Account_Name__r.Name, genesis__Application__r.Name, genesis__Party_Account_Name__r.PersonMobilePhone, genesis__Party_Type__c, Applicant_Name__c, genesis__Party_Account_Name__r.salutation,genesis__Application__r.Primary_Applicant__c from genesis__Application_Parties__c WHERE  genesis__Application__c=:appID];               
        VL_SendSMS.sendSMSPartiesVL(JSON.serialize(genAppPart));
        
    }
       
}