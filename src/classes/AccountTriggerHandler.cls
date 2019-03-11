/*
* Name      : AccountTriggerHandler
* Company   : ET Marlabs
* Purpose   : Handler class for AccountTrigger Trigger 
* Author    : Raushan
*/
public class AccountTriggerHandler {
    public static Decimal exposureAmount ;
    public static boolean isAccountTrigger =false;
    private static AccountTriggerHandler instance;
    //Singleton class Method.
    public static AccountTriggerHandler getInstance(){
        if(instance==null){
            instance=new AccountTriggerHandler();
        }
        return instance;
    }
    
    //Method for Update Previous and Current Value.
    public  void beforeUpdate(Map<id,Account> newMapObj,Map<id,Account> oldMapObj,List<Account> newList){
        try{
            for(Account acc : oldMapObj.values()){
                if(oldMapObj.get(acc.id).Constitution__c != newMapObj.get(acc.id).Constitution__c && acc.Previous_Constitution__c==null){
                    newMapObj.get(acc.id).Previous_Constitution__c = oldMapObj.get(acc.Id).Constitution__c;
                }
                if(!newMapObj.get(acc.id).Firm_Company_was_Reconstituted__c && newMapObj.get(acc.id).Previous_Constitution__c != null){
                    newMapObj.get(acc.id).Constitution__c   = acc.Previous_Constitution__c;
                }
            } 
            updateApproveNMI(newList,oldMapObj);
            TaskFlow_Helper.CrTaskAcc(newList,oldMapObj);
        }Catch(Exception e){}  
    }
    //this 
    public void updateApproveNMI(List<Account> AccList,Map<id,Account> oldMapObj){
        
        Account acRec;
        Decimal i1 = 0.00;
        Decimal i2 = 0.00;
        Decimal i3 = 0.00;
        Decimal i4 = 0.00;
        Decimal i5 = 0.00;
        Decimal i6 = 0.00;
        Decimal min1 = 0.00;
        Decimal min2 = 0.00;
        Decimal min3 = 0.00;
        Decimal min4 = 0.00;
        Decimal min5 = 0.00;
        Decimal min6 = 0.00;
        Decimal v1   = 0.00;
        Decimal v2   = 0.00;
        Decimal v3   = 0.00;
        Decimal value = 0.00;
        Decimal oRec  = 0.00;
        for(Account ac : AccList){
            if((oldMapObj.get(ac.id).Salary_Credited_4__c != ac.Salary_Credited_4__c) || (oldMapObj.get(ac.id).Salary_Credited_5__c != ac.Salary_Credited_5__c) || (oldMapObj.get(ac.id).Salary_Credited_6__c != ac.Salary_Credited_6__c) || (oldMapObj.get(ac.id).Gross_Income_3__c >= 0 || ac.Gross_Income_3__c >= 0)){ //Net_Annual_Income3__c
                if(ac.Income_Computation_From__c == 'Bank Statement'){
                    if(ac.Salary_Credited_1__c != null || ac.Salary_Credited_2__c != null || ac.Salary_Credited_3__c != null || ac.Salary_Credited_4__c != null || ac.Salary_Credited_5__c != null || ac.Salary_Credited_6__c != null){
                        i1 = ac.Salary_Credited_1__c!=null?ac.Salary_Credited_1__c:0;
                        i2 = ac.Salary_Credited_2__c!=null?ac.Salary_Credited_2__c:0;
                        i3 = ac.Salary_Credited_3__c!=null?ac.Salary_Credited_3__c:0;
                        i4 = ac.Salary_Credited_4__c!=null?ac.Salary_Credited_4__c:0;
                        i5 = ac.Salary_Credited_5__c!=null?ac.Salary_Credited_5__c:0;
                        i6 = ac.Salary_Credited_6__c!=null?ac.Salary_Credited_6__c:0;
                        if(ac.Employment_Type__c == 'Salaried'){
                            min1 = math.min(i1,(1.3*math.min(math.min(math.min(math.min(math.min(i1,i2),i3),i4),i5),i6)));
                            min2 = math.min(i2,(1.3*math.min(math.min(math.min(math.min(math.min(i1,i2),i3),i4),i5),i6)));
                            min3 = math.min(i3,(1.3*math.min(math.min(math.min(math.min(math.min(i1,i2),i3),i4),i5),i6)));
                            min4 = math.min(i4,(1.3*math.min(math.min(math.min(math.min(math.min(i1,i2),i3),i4),i5),i6)));
                            min5 = math.min(i5,(1.3*math.min(math.min(math.min(math.min(math.min(i1,i2),i3),i4),i5),i6)));
                            min6 = math.min(i6,(1.3*math.min(math.min(math.min(math.min(math.min(i1,i2),i3),i4),i5),i6)));
                            oRec = ac.Annual_Other_Income_Recurring_Credits_IT__c!=null?ac.Annual_Other_Income_Recurring_Credits_IT__c:0;
                            ac.Approved_NMI_LAP__c = ((min1+min2+min3+min4+min5+min6)/6) +oRec;
                        }else if(ac.Employment_Type__c == 'Self-Employed Businessman'){
                            ac.Approved_NMI_LAP__c = ac.Estimated_Business_Income__c;
                        }
                    }   
                }else if(ac.Income_Computation_From__c == 'ITR'){
                    v1 = ac.Net_Annual_Income1__c!=null?ac.Net_Annual_Income1__c:0;
                    v2 = ac.Net_Annual_Income2__c!=null?ac.Net_Annual_Income2__c:0;
                    v3 = ac.Net_Annual_Income3__c!=null?ac.Net_Annual_Income3__c:0;
                    if(v1 == 0 && v2 == 0 && v3 == 0){
                        ac.Approved_NMI_LAP__c = 0;
                    }else{
                        value = (v1+v2+v3)/3;
                        v3 = ac.Net_Annual_Income3__c;
                        ac.Approved_NMI_LAP__c = Math.min(value,v1)/12;
                        
                    }
                    
                }else if(ac.Income_Computation_From__c == 'Form 26 AS'){
                    if(ac.Net_Amount_Paid__c <> null){
                        ac.Approved_NMI_LAP__c = ac.Net_Amount_Paid__c /6;
                    }else{
                        ac.Approved_NMI_LAP__c = 0;
                    }
                }
            }   
        }
    }
    
    //method to check by comparing that Net_Monthly_Income__c and Computed_NMI__c, and update value of Is_Bank_Statement_required and Is_ITR_required
    public  void updateITRAndBankStatement(List<Account> newList, Map<Id,Account> OldMap){
        List<Account> accList = new List<Account>();
        Account accRec;
        for(Account acc : newList){
            if(acc.Net_Monthly_Income__c != oldMap.get(acc.id).Computed_NMI__c){
                accRec = new Account(Id=acc.Id);
                accRec.Perfios_Captured__c = false;
                //accRec.Is_Bank_Statement_required__c = true;
                //accRec.Is_ITR_required__c = true;
                accList.add(accRec);
            }else if(acc.Net_Monthly_Income__c > 0){
                accRec = new Account(Id=acc.Id);
                //accRec.Is_Bank_Statement_required__c = false;
                //accRec.Is_ITR_required__c = false;
                accRec.Perfios_Captured__c = True;
                accRec.Id = acc.Id;
                accList.add(accRec);
            }
            
            
        }
        if(!accList.isEmpty()){
            isAccountTrigger = true;
            System.debug('@@@@'+accList);
            update accList;            
        }
        
        /*try{
List<Account> accList = new List<Account>();
System.debug('newList:::'+newList);
Account accRec;
for(Account acc : newList){
accRec = new Account();            
System.debug('acc:::'+acc);
if(acc.Net_Monthly_Income__c != oldMap.get(acc.id).Computed_NMI__c){
//acc.Is_Bank_Statement_required__c = true;
//acc.Is_ITR_required__c = true;
System.debug('@@@@'+'inside if');
accRec.Perfios_Captured__c = true;
accRec.Id = acc.Id;
}else{
System.debug('@@@@'+'inside else');
//acc.Is_Bank_Statement_required__c = false;
//acc.Is_ITR_required__c = false;
accRec.Perfios_Captured__c = false;
accRec.Id = acc.Id;
}
accList.add(accRec);
}
if(!accList.isEmpty())
update accList;
}catch(Exception e){
System.debug('@@@@'+e.getMessage()+' AT '+e.getLineNumber());
}*/
    }
    
    //method to calculate loan amount and loan exposure amount
    public static Boolean limitCalculation(genesis__Applications__c app){
        exposureAmount = 0;
        Decimal overAllExposure = KVB_Company_Details__c.getInstance().Overall_Exposure_Limit__c;
        List<String> recTypeList = new List<String>{'SME_Renewal','Term_Loan','SME_Exceeding','SME_AdHoc','SME_Enhancement',Constants.SME_NEW_LOAN_RECORD_TYPE};
            List<String> productCodeList = new List<String>{'WC','TL'};
                List<String> appStageList = new List<String>{'Application close-enhancement','Limit renewed/Application close'};
                    Decimal loanAmount = 0;
        
        List<genesis__Applications__c> appNew = [SELECT Id,RecordType.DeveloperName,genesis__CL_Product__r.Product_Code__c,(SELECT Id,Existing_Limit__c,Limit_Amount__c,Balance_Outstandings__c,Amount_Yet_disbursed__c FROM Facilities__r) FROM genesis__Applications__c WHERE RecordType.DeveloperName = 'Term_Loan' AND genesis__Account__c =: app.genesis__Account__c];
        loanAmount = loamAmountCalculation(app);
        exposureAmount += loanAmount;
        System.debug('exposureAmount:::'+exposureAmount);
        if(!appNew.isEmpty()){
            exposureAmount += exposureAmountCalculation(appNew[0]);
        }
        System.debug('exposureAmount:::'+exposureAmount);
        if(loanAmount <= overAllExposure && exposureAmount <= overAllExposure){
            RETURN true;
        }
        else
            RETURN false;
    }
    
    //Limit Amount calculation
    public static Decimal loamAmountCalculation(genesis__Applications__c app){
        Decimal loanAmount = 0.0;
        if(app != null && (app.RecordType.DeveloperName == 'SME_Renewal' || app.RecordType.DeveloperName == 'SME_Exceeding' || app.RecordType.DeveloperName == 'SME_AdHoc' || app.RecordType.DeveloperName == 'SME_Enhancement' || app.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE)){
            if(!app.Facilities__r.isEmpty()){
                for(Facility__c facility : app.Facilities__r){
                    if(facility.Limit_Amount__c!= null){
                        loanAmount += facility.Limit_Amount__c;
                    }
                }
            }
        }
        System.debug(loanAmount);
        RETURN loanAmount;
    }
    //Exposure Amount calculation
    public static Decimal exposureAmountCalculation(genesis__Applications__c app){
        Decimal exposureAmount = 0.0;
        if(app != null && app.RecordType.DeveloperName == 'Term_Loan'){
            if(!app.Facilities__r.isEmpty()){
                for(Facility__c facility : app.Facilities__r){
                    decimal balcOut        = 0;
                    decimal amtyetDis      = 0;
                    if(facility.Balance_Outstandings__c != null){
                        if(facility.Balance_Outstandings__c < 0){
                            balcOut = (-1)*facility.Balance_Outstandings__c;
                        }else{
                            balcOut = facility.Balance_Outstandings__c;
                        } 
                    }
                    if(facility.Amount_Yet_disbursed__c != null){
                        if(facility.Amount_Yet_disbursed__c < 0){
                            amtyetDis = (-1)*facility.Amount_Yet_disbursed__c;
                        }else{
                            amtyetDis = facility.Amount_Yet_disbursed__c;
                        }
                        
                    }
                    exposureAmount += balcOut + amtyetDis;
                }
            }
        }
        System.debug(exposureAmount);
        RETURN exposureAmount;
    }
    //method to check if thresold breached for flags
    public static Boolean checkFinancialFlagStatus(String appId){
        try{
            List<String> flagNames = new List<String>{'Sales trend (CAGR-3 yrs)','Operating Margin(%)'};
                List<Credit_Underwriting__c> cuFlagList = new List<Credit_Underwriting__c>();
            Boolean thresoldBreachedFlag = false;
            cuFlagList = [SELECT Id,Threshold_breached__c FROM Credit_Underwriting__c WHERE Variable_type__c IN : flagNames AND Underwriting_Variable__r.Application__r.Id =: appId];
            if(!cuFlagList.isEmpty()){
                for(Credit_Underwriting__c cuChild : cuFlagList){
                    if(cuChild.Threshold_breached__c){
                        thresoldBreachedFlag = true;
                        break;
                    }
                }
            }
            RETURN thresoldBreachedFlag;
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
            RETURN false;
        }
    }
}