public with sharing class CreateUnique_App {
    
    public static boolean AppFlag = False;
    
    public static Boolean checkuniqApp(String PanNumber){
        
        List<genesis__Applications__c> ListApps = [Select id, Record_Type_Name__c,Application_Stage__c,Sub_Stage__c,genesis__Account__r.Pan_Number__c from genesis__Applications__c where genesis__Account__r.Pan_Number__c =: PanNumber and Sub_Stage__c <> 'Terms and Conditions Accepted' and Application_Stage__c = 'Saved Applications'];       
        
        try{
            
            if(ListApps.size() > 0){
                AppFlag = True;
            }else{
                AppFlag = False;
            }
            
        }catch(Exception e){
            
            system.debug('##### Error to Create Application '+ e.getCause());
            HandleBusinessException.captureError('CreateUnique_App', 'checkuniqApp', e);
            
        }
        return AppFlag; 
    }
    
    // KVB EMI Calculation method
    public static Decimal KVBEmi = 0;
    public static string KvbEmiCalculation(String AccId){
        
        //Date TodayDat = system.today();
        //TodayDat = TodayDat.addMonths(-5);
        //set<id> AccIds = new set<id>();
        List<String> AccTypes = new List<String>{Constants.TUHL,Constants.TUPL,Constants.TULAP};
            List<String> Stages = new List<String>{'MOD Applications','Disbursement Applications','Disbursed application'};
                List<String> LoanTypes = new List<String>{Constants.PERSONALLOAN,Constants.LAPLOAN,Constants.HOMELOAN};
                    String NonKVB = Constants.NONKVB;
        String TnCStage = Constants.APPLICATION_STATGE_TNC_ACCEPTED;
        String AppNames = '';
        String ListofApps = '';
        List<genesis__Applications__c> ListApp;
        List<Account> PanNumber = [Select id,Pan_Number__c from Account where id=:AccId limit 1];
        Date Todat = system.today();
        Todat = Todat.addMonths(-Constants.NMONTHS);
        integer AppCnt = 0;
        system.debug('##DataLog### --- > '+ PanNumber);
        if(PanNumber.size() > 0){
            ListApp = [Select id,Name, Record_Type_Name__c,Sanctioned_EMI__c,genesis__Payment_Amount__c,Sanction_Authority_Limit__c,genesis__Account__r.Pan_Number__c,Perfios_Captured__c,Application_Stage__c,Sub_Stage__c,CreatedDate from genesis__Applications__c where  genesis__Account__r.Pan_Number__c =:PanNumber[0].Pan_Number__c AND CreatedDate >=:Todat AND Record_Type_Name__c IN: LoanTypes AND (Application_Stage__c IN:Stages OR Sub_Stage__c=:TnCStage)];
        }
        //Account Act = new Account();
        //List<Account> ListAct = new List<Account>();
        
        genesis__Application_Parties__c Act = new genesis__Application_Parties__c();
        List<genesis__Application_Parties__c> ListAct = new List<genesis__Application_Parties__c>();
        
        List<genesis__Application_Parties__c> parts= [Select id,genesis__Party_Account_Name__r.id from genesis__Application_Parties__c where genesis__Party_Account_Name__r.id =:AccId And Active__c=true AND Company__c = false AND (genesis__Party_Type__c=:Constants.PRIMARY_APP OR genesis__Party_Type__c=:Constants.Co_Borrower OR genesis__Party_Type__c=: Constants.Gurantor) order by CreatedDate DESC limit 1];
        
        system.debug('##DataLog parts ### --- > '+ parts);
        
        List<ints__TransUnion_Credit_Report__c> TUData = [Select id,Account__c,Sanction_Date__c,CreatedDate from ints__TransUnion_Credit_Report__c where Account__c =: AccId order by CreatedDate desc limit 1];
        
        List<TU_Account__c> TUAcc =[Select Account_Number__c,Actual_Payment_Amount__c,Account_Type__c,High_Credit_Or_Sanctioned_Amount__c,Reporting_Member_Short_Name__c,Emi_Amount__c,TU_Credit_Report__c,TU_Credit_Report__r.Sanction_Date__c,TU_Credit_Report__r.Sanctioned_Amount__c,TU_Credit_Report__r.Account__c,TU_Credit_Report__r.CreatedDate from TU_Account__c where TU_Credit_Report__c =: TUData AND Account_Type__c IN: AccTypes AND Reporting_Member_Short_Name__c !=: NonKVB];
        system.debug('##DataLog### --- > '+ TUAcc + ' '+TUData);
        if(ListApp.size() > 0){
            system.debug('##DataLog### --- > '+ ListApp.size());
            for(genesis__Applications__c gapp: ListApp){
                AppCnt ++;
                Decimal TempEmi = 0;    
                if(TUAcc.size() > 0){
                    for(TU_Account__c tacc:TUAcc){
                        if(tacc.High_Credit_Or_Sanctioned_Amount__c <> null )
                        {   
                            Decimal EmiAmounts =  tacc.Emi_Amount__c!= null ? Decimal.valueOf(tacc.Emi_Amount__c) : tacc.Actual_Payment_Amount__c!= null ? Decimal.valueOf(tacc.Actual_Payment_Amount__c) : 0;
                            system.debug('##DataLog### --- > '+ EmiAmounts);
                            if( (gapp.Sanctioned_EMI__c <> null && gapp.Sanction_Authority_Limit__c <>null) && (EmiAmounts == gapp.Sanctioned_EMI__c || EmiAmounts == gapp.Sanctioned_EMI__c) && ( Decimal.valueOf(tacc.High_Credit_Or_Sanctioned_Amount__c) == gapp.Sanction_Authority_Limit__c) )
                            {   
                                system.debug('## KVBEmi Match found### --- > '+ KVBEmi);
                                TempEmi = 0;
                                AppNames = '';
                                break;
                            }else{
                                system.debug('##DataLog ### --- > Record Found ');
                                if(gapp.Sub_Stage__c == TnCStage && (gapp.Sanctioned_EMI__c == null || gapp.Sanctioned_EMI__c == 0) ){
                                    TempEmi =  gapp.genesis__Payment_Amount__c != null ? gapp.genesis__Payment_Amount__c : 0;
                                }else{
                                    TempEmi = gapp.Sanctioned_EMI__c != null ? gapp.Sanctioned_EMI__c : 0;
                                }
                                AppNames = gapp.Name;
                                //break;
                            }
                        }
                    }
                }else{ // There is no TU Account records either Experion or TU nagetive.
                    if(gapp.Sub_Stage__c == TnCStage){
                        system.debug('## Term and Conditions ### --- > ' );
                        TempEmi =  gapp.genesis__Payment_Amount__c != null ? gapp.genesis__Payment_Amount__c : 0;
                    }else{
                        system.debug('## No TnC ### --- > ' );
                        TempEmi = gapp.Sanctioned_EMI__c != null ? gapp.Sanctioned_EMI__c : 0;
                    }
                    AppNames = gapp.Name;
                }   
                system.debug('## Application loop ### --- > ' + KVBEmi);
                KVBEmi +=TempEmi;
                ListofApps +=AppNames+',';
                if(math.mod(AppCnt,12) == 0)
                    ListofApps +='\n';
            }
            try{
                system.debug('## KVBEmi before upate ### --- > '+ KVBEmi);
                Act.KVB_EMI__c = KVBEmi;
                Act.id = parts[0].id; //gapp.genesis__Account__r.id;
                ListofApps = ListofApps.replace('APP-', '');
                Act.KVB_Emi_Help__c = KVBEmi != 0 ? ListofApps : '';
                ListAct.add(Act);
                database.update(ListAct,false);
                system.debug('## KVBEmi ### after update --- > '+ KVBEmi);
            }catch(Exception e){
                system.debug('##DataLog### Exception --- > '+ e.getLineNumber() + ' ' +e.getCause());
                HandleBusinessException.captureError('CreateUnique_App', 'KvbEmiCalculation', e);
            }
        }
        return null;
    }
}