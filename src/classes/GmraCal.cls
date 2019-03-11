/*
* Name    : GmraCal
* Company : ET Marlabs
* Purpose : This class is used to calculate GMRA amount
* Author  : Subas
*/
public class GmraCal {
    
    
    public static decimal preApprvGmraVar; // For Pre-Approved loan 
    //Public static List<GMRA_Master__c> gmrList = GMRA_Master__c.getAll().values();
    Public static List<String> RecordTyps = new List<String>{Constants.LAPLOAN,Constants.HOMELOAN,Constants.PERSONALLOAN};
        public static List<string> partyTypes=new List<string>{Constants.PRIMARY_APP,Constants.Co_Borrower};
            public static List<GMRA__c> GmraCalculations(String AppId){
                try{
                    Decimal GMRAAmount=Gmra1(AppId,null,null);
                    preApprvGmraVar=GMRAAmount;
                    system.debug('GMRAAmount:-'+GMRAAmount);
                    if(GMRAAmount!=null && GMRAAmount !=0){
                        List<GMRA_Master__c> gmrList = new List<GMRA_Master__c>();                  
                        List<GMRA__c> delgmraList = new List<GMRA__c>();
                        delgmraList = [Select Id From GMRA__c Where Application__c =:AppId];
                        if(delgmraList.size()>0){
                            Delete delgmraList;
                        }
                        List<GMRA__c> gmraList = new List<GMRA__c>();
                        GMRA__c gm = new GMRA__c();
                        gm.Name = 	System.Label.GMRA_LABEL;
                        gm.Application__c =AppId;
                        gm.Amount__c = GMRAAmount;
                        gmraList.add(gm);
                        Insert gmraList;
                        return gmraList;
                    }
                    return null;
                }
                catch(exception e){
                    system.debug('error'+e.getLineNumber()+'tracetag'+e.getMessage()+'sasasss'+e.getStackTraceString());
                    HandleBusinessException.captureError('GmraCal', 'GmraCalculations', e);
                    return null;
                }
                
                
            }
    
    public static Decimal Gmra1(String AppId,Decimal MaxLoanamt,Decimal EmiMAX){
        try{
            decimal GMRAValue=0;
            map<Integer,Decimal> AgeValue=new map<Integer,decimal>();
            List<genesis__Applications__c> applicationList = [Select Id,Sanctioned_Tenure__c,EMI_Max__c,genesis__Account__r.Gender__pc,genesis__Account__r.age__c,genesis__Interest_Rate__c,
                                                              genesis__Term__c,genesis__Loan_Amount__c,GMRA_Amount__c,Record_Type_Name__c,                                                             
                                                              (SELECT ID,Eligible_EMI1__c,Age__c,Approve_Elgibile_EMI__c FROM genesis__Application_Parties__r Where genesis__Party_Type__c In:partyTypes AND Active__c =: true AND Company__c =: false AND Financial_Applicant__c=:true) 
                                                              From genesis__Applications__c Where Id =:AppId AND Record_Type_Name__c IN:RecordTyps];                                                                                                                      
            if(applicationList.size() >0){
                
                Decimal Term;
                String Product;
                Decimal ApproveEMIMAX;
                if(!Utility.ISStringBlankorNull(string.valueof(applicationList[0].Sanctioned_Tenure__c))){
                    Term=applicationList[0].Sanctioned_Tenure__c;
                }
                else{
                    Term=applicationList[0].genesis__Term__c;
                }
                
                if(applicationList[0].Record_Type_Name__c== Constants.HOMELOAN || applicationList[0].Record_Type_Name__c== Constants.LAPLOAN){
                    Product='HL';
                }
                else if(applicationList[0].Record_Type_Name__c== Constants.PERSONALLOAN){
                    Product='PL';
                }
                if(!Utility.ISStringBlankorNull(Product) && !Utility.ISStringBlankorNull(string.valueof(Term))){
                    List<GMRA_Value__mdt> GMRAList=[select id,GMRA_Value__c,Terms__r.Max_Term__c,Terms__r.Min_Term__c,Product__c,AGE__c,Terms__c,AGE__r.Applicant_Age__c from GMRA_Value__mdt where (Terms__r.Max_Term__c >=: Term AND Terms__r.Min_Term__c <=: Term) AND Product__c=:Product];
                    system.debug(GMRAList);
                    system.debug(GMRAList.size());
                    for(GMRA_Value__mdt Gm:GMRAList){
                        if(AgeValue.containsKey(integer.valueOf(Gm.AGE__r.Applicant_Age__c))){
                            AgeValue.get(integer.valueOf(Gm.AGE__r.Applicant_Age__c));
                        }else{
                            AgeValue.put(integer.valueOf(Gm.AGE__r.Applicant_Age__c),Gm.GMRA_Value__c);
                        }
                    }
                    System.debug('AgeValue'+AgeValue);
                    
                    if(AgeValue!=null){
                        system.debug('applicationList[0].genesis__Application_Parties__r:---'+applicationList[0].genesis__Application_Parties__r.size());
                        for(genesis__Application_Parties__c Part:applicationList[0].genesis__Application_Parties__r){
                            ApproveEMIMAX=(ApproveEMIMAX!= null ? ApproveEMIMAX : 0)+(Part.Approve_Elgibile_EMI__c!= null ? Part.Approve_Elgibile_EMI__c : 0);
                        }
                        
                        for(genesis__Application_Parties__c Part:applicationList[0].genesis__Application_Parties__r){
                            system.debug('Eligible EMI'+Part.Eligible_EMI1__c);
                            system.debug('EMI mAx'+applicationList[0].EMI_Max__c);
                            system.debug('Loan AMount'+applicationList[0].genesis__Loan_Amount__c);
                            
                            Decimal Percent;
                            Decimal FinalGMRA;
                            try{
                                if(MaxLoanamt==null && EmiMAX==null){
                                    Percent=Part.Eligible_EMI1__c/applicationList[0].EMI_Max__c;
                                    system.debug(Percent);
                                    system.debug(Part.Age__c);   
                                    system.debug('ajkdhajahd'+AgeValue.get(integer.valueOf(Part.Age__c)));
                                    system.debug('applicationList[0].genesis__Loan_Amount__c:-'+applicationList[0].genesis__Loan_Amount__c+' Part.Age__c:-'+Part.Age__c);
                                    FinalGMRA =((((applicationList[0].genesis__Loan_Amount__c * Percent)/1000)* AgeValue.get(integer.valueOf(Part.Age__c)))) * 1.18;
                                    system.debug('FinalGMRA:-'+FinalGMRA);
                                }
                                else if(MaxLoanamt !=null && EmiMAX!= null){
                                    Percent=Part.Approve_Elgibile_EMI__c/(applicationList[0].Record_Type_Name__c==Constants.PERSONALLOAN ?EmiMAX:ApproveEMIMAX);
                                    system.debug(Percent);
                                    system.debug(Part.Age__c);   
                                    system.debug('ajkdhajahd'+AgeValue.get(integer.valueOf(Part.Age__c)));
                                    
                                    FinalGMRA =((((MaxLoanamt * Percent)/1000)* AgeValue.get(integer.valueOf(Part.Age__c)))) * 1.18;
                                }
                                GMRAValue=GMRAValue+FinalGMRA;
                                GMRAValue=GMRAValue.setscale(0);
                            }catch(exception e){
                                system.debug('error'+e.getLineNumber()+'tracetag'+e.getMessage()+'sasasss'+e.getStackTraceString());
                                HandleBusinessException.captureError('GmraCal', 'Gmra1', e);
                                return GMRAValue;
                            }
                        }
                    }
                } 
            }
            system.debug('GMRAValue:-'+GMRAValue);
            return GMRAValue; 
        }
        catch(exception e){
            system.debug('error'+e.getLineNumber()+'tracetag'+e.getMessage()+'sasasss'+e.getStackTraceString());
            HandleBusinessException.captureError('GmraCal', 'Gmra1', e);
            return null;
        }
        
    }
}