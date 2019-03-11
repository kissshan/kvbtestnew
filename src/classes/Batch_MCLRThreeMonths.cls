public class Batch_MCLRThreeMonths implements Database.Batchable<sObject>,Database.Stateful {
     String query;
     String finalstr;
  public Database.QueryLocator start(Database.BatchableContext BC) {
   String header = 'S.No, ACCT_NO, CUST_ID, NAM_CUST_SHRT, NAM_BRANCH, RAT_INT_CURRENT \n';
        finalstr = header;
        Integer CurrentMonth = system.Today().Month();
		query = 'SELECT Id,Primary_Applicant__c,Loan_Account_Number__c,genesis__Account__r.CBS_Customer_ID__c,Branch_Name__c,genesis__Interest_Rate__c FROM genesis__Applications__c where MCLR_Type__c =\'Three Months\' AND Record_Type_Name__c=\'Home Loan\' AND Loan_Account_Number__c!=null' ;
    
  return  Database.getQueryLocator(query);
  }
    
     public void execute(Database.BatchableContext BC, List<genesis__Applications__c> records) {
        integer i =1;
          for(genesis__Applications__c app: records) {
            String recordString = i+','+checkBlank(string.valueof('['+app.Loan_Account_Number__c+']'))+','+checkBlank(string.ValueOf(app.genesis__Account__r.CBS_Customer_ID__c))+','+checkBlank(string.ValueOf(app.Primary_Applicant__c))+','+checkBlank(string.ValueOf(app.Branch_Name__c))+','+checkBlank(string.ValueOf(app.genesis__Interest_Rate__c))+'\n';
            finalstr = finalstr +recordString;
            i++;//app.Primary_Applicant_Mobile__c
           // listApp.add(app);
        }
     }
     static string checkBlank(string param){
        return param!=null?param:'';
    }
     public void finish(Database.BatchableContext BC) {
          System.debug('finish- '+finalstr); 
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        Blob csvBlob = Blob.valueOf(finalstr);
        String csvname= 'KVB THreeMonthsMCLR Report_'+System.Today().Day()+'_'+System.Today().Month()+'_'+System.Today().Year()+'.csv';
        csvAttc.setFileName(csvname);
        csvAttc.setBody(csvBlob);
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
        String emailStr =System.label.ThreeMonthMCLRMail;
        List<String> emailList   = emailStr.split(',');
       // String[] toAddresses = new list<string> {emailList}; //Email id of Bank
            String subject ='KVB ThreeMonth MCLR Loan Account Report';
        email.setSubject(subject);
        email.setToAddresses( emailList );
        email.setPlainTextBody(subject);
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
     
     }
}