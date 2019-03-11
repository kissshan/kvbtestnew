global class NMICalculations {
    
    Webservice static void Calculations(String AppID){
        try{
            genesis__Applications__c App=[select id,AVG_Balance__c,Total_Cheque_Bounces__c,Existing_EMI_s__c,NMI_Approved__c,NMI_Claimed_By_Customer__c,
                (select id,name,Average_Balances_6_months__c,Employment_Types__c,Approved_NMI_From_ITR__c,
                Total_ChequeECS_bounces__c,genesis__Party_Type__c,Annual_Agriculture_Income_ITR__c,NMI_Approved__c,Approved_NMI_LAP__c,NMI_Claimed_By_Customer__c,Additional_Income_Amount1__c,Agriculture2__c,
                Financial_Applicant__c,NMI_as_per_26AS__c,NMI_as_per_BS__c,Computed_NMI__c,Max_Existing_EMI__c,Net_Monthly_Income__c,Existing_Emis__c,Perfios_Captured__c from genesis__Application_Parties__r 
                where Active__c=true AND ( genesis__Party_Type__c=:Constants.Co_Borrower OR genesis__Party_Type__c=:Constants.PRIMARY_APP)) from genesis__Applications__c where ID =:AppID];
            System.debug('app:::'+app);
            Decimal NMI_Approved=0;
            Decimal NMI_ClaimedCUST=0;
            Decimal Avgbalance6month=0;
            Decimal NoChequeBounce=0;
            decimal ExistingEmis=0;
            
            for(genesis__Application_Parties__c part:App.genesis__Application_Parties__r){
               
                if(part.Financial_Applicant__c){
                    if(part.NMI_Approved__c!=null){
                        NMI_Approved=NMI_Approved+part.NMI_Approved__c;
                    }
                    if(part.NMI_Claimed_By_Customer__c!=null){
                        NMI_ClaimedCUST=NMI_ClaimedCUST+part.NMI_Claimed_By_Customer__c;
                    }
                    if(part.Average_Balances_6_months__c!=Null){
                        Avgbalance6month=Avgbalance6month+part.Average_Balances_6_months__c;
                    }
                    if(part.Total_ChequeECS_bounces__c!=null){
                        NoChequeBounce=NoChequeBounce+part.Total_ChequeECS_bounces__c;
                    }
                     if(part.Existing_Emis__c!=null){
                        ExistingEmis=ExistingEmis+part.Existing_Emis__c;
                    }
                  
                } 
            }
           
            if(NMI_Approved!=0){
                app.NMI_Approved__c=NMI_Approved;
            }
            Decimal NMIClaimed = NMICal1(app,'Claimed');
            Decimal NMIApproved = NMICal1(app,'Approved');
            //app.NMI_Claimed_By_Customer__c=NMI_ClaimedCUST;
            app.NMI_Claimed_By_Customer__c= NMIClaimed;
            app.NMI_Approved__c = NMIApproved;
            app.AVG_Balance__c = Avgbalance6month;   
            app.Total_Cheque_Bounces__c = NoChequeBounce;
            app.Existing_EMI_s__c=ExistingEmis;
            system.debug('##### App Cheque bounce details '+ app);
            ApplicationTriggerHandler.IsFirstRun = False;
            update app;
            
        }
        catch(exception e){
            system.debug('Error '+e.getLineNumber()+' Msg: '+ e.getMessage() + ' -- '+e.getStackTraceString()+'----e.line---'+e.getLineNumber());
        }
    }
    Webservice static Decimal NMICal1(genesis__Applications__c App,String NMIType){        
        Decimal NmiClaimed = 0.00;
        Decimal NmiApproved = 0.00;
        
        if(NMIType == 'Claimed'){
 
            /////closing if
            for(genesis__Application_Parties__c PT : App.genesis__Application_Parties__r){
                 if(PT.Financial_Applicant__c){
                if(PT.Employment_Types__c == 'Agriculturist'){
                    NmiClaimed = NmiClaimed + (PT.Net_Monthly_Income__c != null ? PT.Net_Monthly_Income__c : 0)+ (PT.Additional_Income_Amount1__c != null ? PT.Additional_Income_Amount1__c/12 : 0);
                }
                else if(PT.Employment_Types__c != 'Agriculturist' && PT.Perfios_Captured__c == false){
                    Decimal minVal = Math.min((PT.Additional_Income_Amount1__c != null ? PT.Additional_Income_Amount1__c/12 : 0),(((PT.Net_Monthly_Income__c != null ? PT.Net_Monthly_Income__c : 0) /0.7)*0.3));
                    NmiClaimed = NmiClaimed + (PT.Net_Monthly_Income__c != null ? PT.Net_Monthly_Income__c : 0) + Math.min(minVal,200000/12);
                }
                else if(PT.Perfios_Captured__c == true){            
                    if(PT.NMI_as_per_26AS__c == PT.Computed_NMI__c || PT.NMI_as_per_BS__c == PT.Computed_NMI__c
){
                        Decimal minVal = Math.min((PT.Additional_Income_Amount1__c != null ? PT.Additional_Income_Amount1__c/12 : 0),(((PT.Net_Monthly_Income__c != null ? PT.Net_Monthly_Income__c : 0) /0.7)*0.3));
                        NmiClaimed = NmiClaimed + (PT.Net_Monthly_Income__c != null ? PT.Net_Monthly_Income__c : 0) + Math.min(minVal,200000/12); 
                    }else if(PT.Net_Monthly_Income__c == PT.Computed_NMI__c){
                        Decimal aVal = (PT.Net_Monthly_Income__c != null ? PT.Net_Monthly_Income__c : 0) - (PT.Annual_Agriculture_Income_ITR__c != null ? PT.Annual_Agriculture_Income_ITR__c : 0);
                        NmiClaimed = NmiClaimed + (aVal + Math.Min(((PT.Annual_Agriculture_Income_ITR__c != null ? PT.Annual_Agriculture_Income_ITR__c : 0) + (PT.Additional_Income_Amount1__c != null ? PT.Additional_Income_Amount1__c :0))/12,Math.Min(((aVal/0.7)*0.3),200000.00/12)));
                    }
                }
            }
            }
            return NmiClaimed;
        }else if(NMIType == 'Approved'){
            for(genesis__Application_Parties__c PT : App.genesis__Application_Parties__r){
                 if(PT.Financial_Applicant__c){
                     System.debug('NmiApproved:::'+NmiApproved);
                if(PT.Employment_Types__c == 'Agriculturist'){
                    NmiApproved = NmiApproved + (PT.Approved_NMI_From_ITR__c != null ? PT.Approved_NMI_From_ITR__c : 0)+ (PT.Agriculture2__c != null ? (PT.Agriculture2__c/12) : 0);
                }
                else if(PT.Employment_Types__c != 'Agriculturist' && PT.Perfios_Captured__c == false){
                    Decimal minVal = Math.min((PT.Agriculture2__c != null ? PT.Agriculture2__c/12 : 0),(((PT.Approved_NMI_From_ITR__c != null ? PT.Approved_NMI_From_ITR__c : 0) / 0.7)*0.3));
                    NmiApproved = NmiApproved + (PT.Approved_NMI_From_ITR__c != null ? PT.Approved_NMI_From_ITR__c : 0) + Math.min(minVal,200000/12);
                }
                else if(PT.Perfios_Captured__c == true){ 
                    System.debug('pt:::'+PT.Perfios_Captured__c);
                    if(PT.NMI_as_per_26AS__c == PT.Computed_NMI__c || PT.NMI_as_per_BS__c == PT.Computed_NMI__c){
                        System.debug('NMI_as_per_26AS__c:::'+pt.NMI_as_per_26AS__c+'::PT.NMI_as_per_BS__c:'+PT.NMI_as_per_BS__c);
                        Decimal minVal = Math.min((PT.Agriculture2__c != null ? PT.Agriculture2__c/12 : 0),(((PT.Approved_NMI_From_ITR__c != null ? PT.Approved_NMI_From_ITR__c : 0) /0.7)*0.3));
                        System.debug('minVal:::'+minVal+'::PT.Approved_NMI_From_ITR__c:'+PT.Approved_NMI_From_ITR__c);
                        NmiApproved = NmiApproved + (PT.Approved_NMI_From_ITR__c != null ? PT.Approved_NMI_From_ITR__c : 0) + Math.min(minVal,200000/12); 
                    }else if(PT.Approved_NMI_From_ITR__c == PT.Computed_NMI__c){
                        System.debug('Computed_NMI__c:::'+pt.Computed_NMI__c+'::PT.Approved_NMI_From_ITR__c :'+PT.Approved_NMI_From_ITR__c );
                        Decimal aVal = (PT.Approved_NMI_From_ITR__c != null ? PT.Approved_NMI_From_ITR__c : 0) - (PT.Annual_Agriculture_Income_ITR__c != null ? PT.Annual_Agriculture_Income_ITR__c : 0);
                        System.debug('aVal:::'+aVal+'::PT.Approved_NMI_From_ITR__c:'+PT.Approved_NMI_From_ITR__c);
                        NmiApproved = NmiApproved + (aVal + Math.Min(((PT.Annual_Agriculture_Income_ITR__c != null ? PT.Annual_Agriculture_Income_ITR__c : 0) + (PT.Agriculture2__c != null ? PT.Agriculture2__c : 0 ))/12,Math.Min(((aVal/0.7)*0.3),200000.00/12)));
                    }
                    
                }
            }
                System.debug('NmiApproved:::'+NmiApproved);
            }
            
            return NmiApproved;
        }
        return 0.00;
    }
    public static boolean Recursing=true;
    public static void CallNMI(List<genesis__Applications__c> APlist,Map<Id,genesis__Applications__c> oldApp){
        List<genesis__Applications__c> ApplicationList=new List<genesis__Applications__c>();
        for(genesis__Applications__c Ap:APlist){
            genesis__Applications__c oldPlan = oldApp.get(Ap.Id);
            // collateral structure changes-----on 28-11-2018  || ((oldPlan.Cost_Of_Construction__c!=Ap.Cost_Of_Construction__c || oldPlan.Cost_Of_Flat_House__c!=Ap.Cost_Of_Flat_House__c  || oldPlan.Cost_Of_Land__c!=Ap.Cost_Of_Land__c  || oldPlan.Cost_Of_Repair__c!=Ap.Cost_Of_Repair__c || oldPlan.Age_Of_The_Building__c!=Ap.Age_Of_The_Building__c  || oldPlan.Whether_The_Construction_Completed__c!=Ap.Whether_The_Construction_Completed__c) && ap.Record_Type_Name__c ==Constants.HOMELOAN)
            if(((oldPlan.Sub_Stage__c!=Ap.Sub_Stage__c && Ap.Sub_Stage__c==Constants.Sub_Stage_PropInfoCaptured) && (ap.Record_Type_Name__c ==Constants.LAPLOAN || ap.Record_Type_Name__c ==Constants.HOMELOAN  ))  || (oldPlan.Sub_Stage__c!=Ap.Sub_Stage__c && Ap.Sub_Stage__c==Constants.Sub_Stage_WorkInfoCaptured && ap.Record_Type_Name__c ==Constants.PERSONALLOAN ) ){     
                Calculations(ap.ID);
            }
        }
    }   
}