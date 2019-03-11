/*
* Name    : Rerun_Bre
* Company : ET Marlabs
* Purpose : This class will be used to re call the eligibility calculation and BRE for 3rd time from Skuid.
* Author  : Subas
*/ 
Global class Rerun_Bre {
    //Calling from Skuid for BRE re run (Subas) 
    //prashant singh deleted the fields  on 22-11-2018-------Cost_Of_Construction__c...
    Webservice static void recallEligibility(String AppId, String typeProd){
                   List<genesis__Applications__c> listapp =[select id,Sub_Type__c,Retail_BRE_Hit__c,GMRA_Amount__c,Is_GMRA_Policy_Selected__c,genesis__CL_Product__c,Sub_Stage__c,Branch_Code__c,PMax__c, PMin__c,
                                                             genesis__Account__r.Total_Annual_other_Income_Approved__c,FI_Status__c,Total_Cheque_Bounces__c,Application_Stage__c,Record_Type_Name__c,PreClosure_Interest_Rate__c,Holiday_Period__c,Preclosure_Charges__c,Penal_Interest__c,genesis__Interest_Calculation_Method__c,
                                                     Sanctioned_EMI__c,ValidateTask__c,Sanctioned_Tenure__c,Sanction_Authority_Limit__c,genesis__Payment_Amount__c,MCLR_Type__c,genesis__Margin__c,Interest_Variation__c,
                                                     genesis__Loan_Amount__c,genesis__Term__c,genesis__Account__r.Employment_Type__c,genesis__Account__r.NMI_Approved__c,genesis__Account__r.Approved_NMI_From_ITR__c,Excess_MCLR__c,
                                                     genesis__Account__r.NMI_Claimed_By_Customer__c,
                                                     genesis__Account__r.Age__c,genesis__Account__r.Additional_Income_Amount1__c,Loan_Purpose__c,genesis__Account__r.Existing_Emis__c,
                                                     Pre_approved_flag__c,genesis__Interest_Rate__c,genesis__Account__r.Financial_Applicant__c,genesis__Account__r.Agriculture2__c,Maturity_Time__c,NMI_Approved__c,
                                                     genesis__Account__r.Net_Monthly_Income__c,genesis__Account__r.Max_Existing_EMI__c,genesis__CL_Product__r.Existing_Margin__c,
                                                     (select id, genesis__Party_Type__c, Additional_Income_Amount1__c, Total_Annual_other_Income_Approved__c, Employment_Types__c,  NMI_Approved__c,
                                        			 Approved_NMI_From_ITR__c, NMI_Claimed_By_Customer__c,Age__c, Existing_Emis__c, Financial_Applicant__c, Agriculture2__c, Net_Monthly_Income__c,
                                       				 Max_Existing_EMI__c from genesis__Application_Parties__r where Active__c=true),(select id,clcommon__City__c,Cost_Of_Flat_House__c,Total_Market_value__c,
                                                     Cost_Of_Repair__c,Total_cost_incurred_till_date__c,Market_valueProposedRepairs_Renovation__c,Market_value_Proposed_Repair_Renovation2__c,Cost_Of_Construction__c,Market_Value_Of_The_Building__c,Market_Value_Of_The_Building2__c,Valuation_Applicable__c,Double_Valuation_Charge__c,Cost_Of_Land__c,Cost_of_Property__c,Age_Of_The_Building__c,Residual_Life_of_Property__c,Approved_Cost_incurred_in_last_6_Months__c,Approved_Total_Cost_Incurred__c from genesis__Collaterals__r where Active__c=true) ,
                                                      (select id,Approved_Takeover_Outstanding_Loan_Tenur__c,Existing_HL_Sanctioned_Amount__c,Takeover_Outstanding_Loan_Tenure_months__c,Takeover_Outstanding_Loan_Amount__c,Existing_HL_Outstanding_Tenure__c,Approved_Takeover_Outstanding_Loan_Amoun__c,Existing_HL_Oustanding_Balance__c,Approved_Takeover_Loans_EMI__c from Facilities__r where Selected_for_Top_Up__c=:true) from genesis__Applications__c where ID =: appid];

        if(typeProd == 'LAP'){
            Retry_Task_call.calculateEligibilityLAP(listapp[0],'3');   
        }else if(typeProd == 'HL'){
            Retry_Task_call.calculateEligibility(listapp[0],'3');
        }else if(typeProd == 'PL'){
            Retry_Task_call.calculateEligibilityPL(listapp[0],'3');
        }else if(typeProd == 'VL'){
            Retry_Task_call_VL.RecalculateEligibilityVL(listapp[0],'3');
        }
        if(typeProd == 'VELAP'){
            Retry_Task_call.calculateEligibilityLAP(listapp[0],typeProd);   
        }else if(typeProd == 'VEHL'){
            Retry_Task_call.calculateEligibility(listapp[0],typeProd);
        }else if(typeProd == 'VEPL'){
            Retry_Task_call.calculateEligibilityPL(listapp[0],typeProd);
        }else if(typeProd == 'VEVL'){
            Retry_Task_call_VL.RecalculateEligibilityVL(listapp[0],typeProd);
        }     
    }
}