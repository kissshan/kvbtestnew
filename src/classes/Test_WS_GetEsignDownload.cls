@isTest
public class Test_WS_GetEsignDownload {

      Static genesis__Applications__c app;
      static Document_Applicant__c documentApplicantobj;
    //valid data
    @isTest
    public static void getSMECustomersValid() {
        try{
        app = TestUtility.intialSetUp('HomeLoan', true);       
        Account acc=new Account(Name='TestName');
        insert acc;
        System.debug('**Account id'+acc.id);
        Digio_Document_ID__c docobj=new Digio_Document_ID__c(Application__c=app.id,Borrower__c=true,Document_ID__c='111',Guarantor__c=true,Stamp_Charges__c=100);
        insert docobj;
        System.debug('**docobj id'+docobj.id);
        documentApplicantobj=new Document_Applicant__c(Account__c=acc.id,Digio_Document_ID__c=docobj.id,eSigned__c=true);
        insert documentApplicantobj;
        System.debug('**documentApplicantobj'+documentApplicantobj.Id);
        blob b = blob.valueOf(getdetails());
        TestUtility.webserviceRequest('services/apexrest/getEsignDocument', 'POST', b);
        Test.startTest();
        WS_GetEsignDownload.getdocument();
        Test.stopTest();
        }Catch(Exception e){}
    }
    
    public static string getdetails() {
        String json =
            '{' +
            '"LOS_APPID":"Niladri" ,' +
            '"DOC_ID":"'+documentApplicantobj.id+'" ,'+
            '"IS_Complted":"Yes" ' +
            '}';

        return json;
    }
}