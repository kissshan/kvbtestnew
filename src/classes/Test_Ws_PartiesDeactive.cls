@isTest
public class Test_Ws_PartiesDeactive {
    Static genesis__Applications__c app;
    static Account acc;
    static Account acc1;
    
    static  List<genesis__Applications__c> app2list;
    //valid data
    @isTest
    public static void deativatePartiesValid() {
        app = TestUtility.intialSetUp('HomeLoan', true);
        acc = new Account(Name = 'TestName');
        insert acc;
        acc1 = new Account(Name = 'TestName1');
        insert acc1;
        genesis__Application_Parties__c parobj = TestUtility.createAppParties(acc.Id, acc1.id);
        insert parobj;
        app2list=VL_Test_Utility.intialSetUp(true,true);
        blob b = blob.valueOf(getdetails());
        TestUtility.webserviceRequest('services/apexrest/PartiesDeactivate', 'POST', b);
        Test.startTest();
        Ws_PartiesDeactive.Response par = new Ws_PartiesDeactive.Response();
        par = Ws_PartiesDeactive.deativateParties();
        Test.stopTest();
        System.assert(par != null);

    }
    //Null value
    @isTest
    public static void deativatePartiesNull() {
        app = TestUtility.intialSetUp('HomeLoan', true);
        TestUtility.webserviceRequest('services/apexrest/PartiesDeactivate', 'POST', null);
        Test.startTest();
        Ws_PartiesDeactive.deativateParties();
        Test.stopTest();

    }
    //Invalid Data
    @isTest
    public static void deativatePartiesInvalid() {
        app = TestUtility.intialSetUp('HomeLoan', true);
        acc = new Account(Name = 'TestName');
        insert acc;
        acc1 = new Account(Name = 'TestName1');
        insert acc1;
        genesis__Application_Parties__c parobj = TestUtility.createAppParties(acc.Id, acc1.id);
        insert parobj;
       // blob b = blob.valueOf(getdetails1());
         blob b = blob.valueOf(getdetails4()); 
        TestUtility.webserviceRequest('services/apexrest/PartiesDeactivate', 'POST', b);
        Test.startTest();
        Ws_PartiesDeactive.Response par = new Ws_PartiesDeactive.Response();
        par = Ws_PartiesDeactive.deativateParties();
        Test.stopTest();
        // System.assert(par!=null);

    }
    //Applicant deleted already
    @isTest
    public static void deativatePartiesDeleted() {
        app = TestUtility.intialSetUp('HomeLoan', true);
        acc = new Account(Name = 'TestName');
        insert acc;
        acc1 = new Account(Name = 'TestName1');
        insert acc1;
        genesis__Application_Parties__c parobj = TestUtility.createAppParties(acc.Id, acc1.id);
        insert parobj;
        genesis__Application_Parties__c parobj1 = [select Active__c, genesis__Party_Type__c from genesis__Application_Parties__c where id =: parobj.Id];
        parobj1.Active__c = false;
        update parobj1;
        blob b = blob.valueOf(getdetails());
        TestUtility.webserviceRequest('services/apexrest/PartiesDeactivate', 'POST', b);
        Test.startTest();
        Ws_PartiesDeactive.Response par = new Ws_PartiesDeactive.Response();
        par = Ws_PartiesDeactive.deativateParties();
        Test.stopTest();
        System.assert(par != null);

    }
    
    ///add
       @isTest
    public static void method1() {
       // app = TestUtility.intialSetUp('HomeLoan', true);
       /* acc = new Account(Name = 'TestName');
        insert acc;
        acc1 = new Account(Name = 'TestName1');
        insert acc1;*/
        
        app2list=VL_Test_Utility.intialSetUp(true,true);
        genesis__Applications__c appAcc=[select genesis__Account__c from genesis__Applications__c where id=:app2list[0].id];
        acc=[select id from Account where id=:appAcc.genesis__Account__c];
        blob b = blob.valueOf(getdetailsNew());
        TestUtility.webserviceRequest('services/apexrest/PartiesDeactivate', 'POST', b);
        Test.startTest();
        Ws_PartiesDeactive.Response par = new Ws_PartiesDeactive.Response();
        par = Ws_PartiesDeactive.deativateParties();
        Test.stopTest();
        System.assert(par != null);

    }
     @isTest
    public static void deativatePartiesInvalid2() {
        app = TestUtility.intialSetUp('HomeLoan', true);
        acc = new Account(Name = 'TestName');
        insert acc;
        acc1 = new Account(Name = 'TestName1');
        insert acc1;
        genesis__Application_Parties__c parobj = TestUtility.createAppParties(acc.Id, acc1.id);
        insert parobj;
        blob b = blob.valueOf(getdetails1());
        TestUtility.webserviceRequest('services/apexrest/PartiesDeactivate', 'POST', b);
        Test.startTest();
        Ws_PartiesDeactive.Response par = new Ws_PartiesDeactive.Response();
        par = Ws_PartiesDeactive.deativateParties();
        Test.stopTest();
        // System.assert(par!=null);

    }

    public static string getdetails() {
        String json =
            '{' +
            '"ApplicantID":"' + acc.id + '" ,' +
            '"ApplicationID":"'+ app.id   +'"'+
            '}';

        return json;
    }

    public static string getdetails1() {
        String json =
            '{' +
            '"ApplicantIDuu":"' + acc.id + '" ,' +
            '"action":"test" ' +
             
            '}';

        return json;
    }
    
      public static string getdetailsNew() {
        String json =
            '{' +
            '"ApplicantID":"' + acc.id + '" ,' +
            '"ApplicationID":"'+ app2list[0].id   +'"'+
            '}';

        return json;
    }
    public static string getdetails4() {
        String json =
            '{' +
            '"ApplicantID":"' + acc.id + '" ,' +
            
            '}';

        return json;
    }


}