public with sharing class NumberToWordMethod {
     @InvocableMethod  
    public static List<String> getApplication(List<ID> ids){
        List<String> accountNames = new List<String>();
        List<genesis__Applications__c> listApp = new List<genesis__Applications__c>();
      // List<clcommon__Collateral_Insurance__c> listIns = new List<clcommon__Collateral_Insurance__c>();
        NumberToWordConversion ntw = new NumberToWordConversion();

        listApp = [Select Id, genesis__Loan_Amount__c,Amount_in_Words_And_Figures__c,Sanction_Amount_Words__c,Sanction_Authority_Limit__c,
                  genesis__Interest_Rate__c From genesis__Applications__c Where ID IN: ids];
        //system.debug('@@@@@@@'+listApp);        
        for(genesis__Applications__c app : listApp){

            if(app.genesis__Loan_Amount__c<>null){
            app.Amount_in_Words_And_Figures__c = ntw.getNumberTOWordConvertion(app.genesis__Loan_Amount__c);
            }
            if(App.Sanction_Authority_Limit__c<>null){
                 app.Sanction_Amount_Words__c = ntw.getNumberTOWordConvertion(app.Sanction_Authority_Limit__c);
            }
         
        }
      
        try{
            update listApp;
           // update listIns;
        }Catch(Exception e){system.debug('****NumberToWord Failed****');}
        return accountNames;
    }
    

}