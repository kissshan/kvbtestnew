public class Batch_ProcessingFee implements Database.Batchable<sObject>,Database.Stateful {
    String query;
    String finalstr;
    List<genesis__Applications__c> listApp= new List<genesis__Applications__c>();
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        String header = 'S.No, Application, Customer Name, Customer mobile number, Product code, FE Transaction ID, PG Transaction ID, Date Time, Total amount, PG Status, Branch code, Processing fee, Processing fee GST, Legal, Legal GST, Valuation fee, Valuation fee GST, CIBIL fee, CIBIL fee GST,Stamp Paper Fee, Product Type \n';
        finalstr = header;
        Integer CurrentMonth = system.Today().Month();
		query = 'SELECT Id,Record_Type_Name__c,name,Primary_Applicant__c,Primary_Applicant_Mobile__c,Product_Code__c,FE_Transaction_ID__c,PG_Transaction_ID__c,Date_Time_Processing_Fee__c,Processing_Fee__c,PG_Status__c,Branch_Code__c,Processing_Charges__c,Processing_charges_with_GST__c,Legal_Charges__c,Legal_Opinion_with_GST__c,Valuation_Charges__c,Total_Stamp_Paper_Charge__c,Valuation_Charges_with_GST__c,Cibil_Charges__c,CIBIL_Charges_with_GST__c,Cersai_Charges__c,Cersai_Fee_with_GST__c,Charges_Processed__c FROM genesis__Applications__c where Charges_Processed__c =False AND Record_Type_Name__c in (\'Home Loan\' ,\'LAP\' ,\'Personal Loan\'  ) AND PG_Status__c =\'true\'';        
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<genesis__Applications__c> records) {
        integer i =1;
        for(genesis__Applications__c app: records) {
		String recordString = i+','+checkBlank(string.ValueOf(app.Name))+','+checkBlank(string.ValueOf(app.Primary_Applicant__c))+','+checkBlank(string.ValueOf(app.Primary_Applicant_Mobile__c))+','+checkBlank(string.ValueOf(app.Product_Code__c))+','+checkBlank(string.ValueOf(app.FE_Transaction_ID__c))+','+checkBlank(string.ValueOf(app.PG_Transaction_ID__c))+','+checkBlank(string.ValueOf(app.Date_Time_Processing_Fee__c))+','+checkBlank(string.ValueOf(app.Processing_Fee__c))+','+checkBlank(string.ValueOf(app.PG_Status__c))+','+checkBlank(string.ValueOf(app.Branch_Code__c))+','+checkBlank(string.ValueOf(app.Processing_Charges__c))+','+checkBlank(string.ValueOf(app.Processing_charges_with_GST__c))+','+checkBlank(string.ValueOf(app.Legal_Charges__c))+','+checkBlank(string.ValueOf(app.Legal_Opinion_with_GST__c))+','+checkBlank(string.ValueOf(app.Valuation_Charges__c))+','+checkBlank(string.ValueOf(app.Valuation_Charges_with_GST__c))+','+checkBlank(string.ValueOf(app.Cibil_Charges__c))+','+checkBlank(string.ValueOf(app.CIBIL_Charges_with_GST__c))+','+checkBlank(string.ValueOf(app.Total_Stamp_Paper_Charge__c))+','+checkBlank(string.ValueOf(app.Record_Type_Name__c))+'\n';       
           finalstr = finalstr +recordString;
            i++;//app.Primary_Applicant_Mobile__c
            listApp.add(app);
        }
    }
    
    static string checkBlank(string param){
        return param!=null?param:'';
    }
    public void finish(Database.BatchableContext BC) {
        System.debug('finish- '+finalstr); 
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        Blob csvBlob = Blob.valueOf(finalstr);
        String csvname= 'KVB Charges Report_'+System.Today().Day()+'_'+System.Today().Month()+'_'+System.Today().Year()+'.csv';
        csvAttc.setFileName(csvname);
        csvAttc.setBody(csvBlob);
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
        String emailStr = System.label.Bank_Email_for_Processing_fee;
        List<String> emailList   = emailStr.split(',');
       // String[] toAddresses = new list<string> {emailList}; //Email id of Bank
            String subject ='KVB Charges Report';
        email.setSubject(subject);
        email.setToAddresses( emailList );
        email.setPlainTextBody(subject);
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        /*for(genesis__Applications__c app: listApp){
            app.Charges_Processed__c = True;
        }
        ApplicationTriggerHandler.IsFirstRun = False;
        update listApp;*/
    }       
}