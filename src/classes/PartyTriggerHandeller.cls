/*
* Name      : PartyTriggerHandeller
* Company   : ET Marlabs
* Purpose   : Handler class for updateparty Trigger 
* Author    : Niladri 
*/

public class PartyTriggerHandeller {
    public static boolean isPartyTrigger =false;
    private static PartyTriggerHandeller instance;
    public static PartyTriggerHandeller getInstance(){
        if(instance==null){
            instance=new PartyTriggerHandeller();
        }
        return instance;
    }
    public void updateApproveNMI(List<genesis__Application_Parties__c> PartyList,Map<id,genesis__Application_Parties__c> oldMapObj){
        try{
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
            System.debug('#####:::::'+PartyList);
            
            Set<Id> accIds = new Set<Id>();
            Set<Id> partyId = new Set<Id>();
            Boolean recordTypeFlag = false;
            for(genesis__Application_Parties__c acc : PartyList){
                accIds.add(acc.Id);
                if(acc.Perfios_Captured__c && acc.Perfios_Captured__c!=oldMapObj.get(acc.id).Perfios_Captured__c && !oldMapObj.get(acc.id).Perfios_Captured__c){
                    acc.Is_Bank_Statement_required__c=false;
                    acc.Is_ITR_required__c=false;
                }
            }
            
            List<genesis__Application_Parties__c> appRec = [SELECT Id,  genesis__Application__r.Record_Type_Name__c FROM genesis__Application_Parties__c WHERE id=: accIds AND genesis__Application__r.Record_Type_Name__c = 'LAP'];
            //System.debug('**ppppp'+appRec[0].genesis__Application__r.Record_Type_Name__c);
            for(genesis__Application_Parties__c pparty : appRec){
                partyId.add(pparty.genesis__Application__r.Id);
            }
            /* if(appRec[0].genesis__Application__r.Record_Type_Name__c == 'LAP'){
recordTypeFlag = true;
} */
            System.debug('recordTypeFlag'+recordTypeFlag);
            if(partyId.size() > 0){
                for(genesis__Application_Parties__c ac : PartyList){
                    
                    if((oldMapObj.get(ac.id).Salary_Credited_4__c != ac.Salary_Credited_4__c) || (oldMapObj.get(ac.id).Salary_Credited_5__c != ac.Salary_Credited_5__c) || (oldMapObj.get(ac.id).Salary_Credited_6__c != ac.Salary_Credited_6__c) || (oldMapObj.get(ac.id).Gross_Income3__c >= 0 || ac.Gross_Income3__c >= 0) ){ //Net_Annual_Income3__c
                        System.debug('#####:::::'+ac);
                        if(ac.Active__c ==True && ac.Company__c==false){
                            if(ac.Income_Computation_From__c == 'Bank Statement'){
                                System.debug('#@#@#@Bank statement');
                                if(ac.Salary_Credited_1__c != null || ac.Salary_Credited_2__c != null || ac.Salary_Credited_3__c != null || ac.Salary_Credited_4__c != null || ac.Salary_Credited_5__c != null || ac.Salary_Credited_6__c != null){
                                    System.debug('&&&&Salary');
                                    i1 = ac.Salary_Credited_1__c!=null?ac.Salary_Credited_1__c:0;
                                    i2 = ac.Salary_Credited_2__c!=null?ac.Salary_Credited_2__c:0;
                                    i3 = ac.Salary_Credited_3__c!=null?ac.Salary_Credited_3__c:0;
                                    i4 = ac.Salary_Credited_4__c!=null?ac.Salary_Credited_4__c:0;
                                    i5 = ac.Salary_Credited_5__c!=null?ac.Salary_Credited_5__c:0;
                                    i6 = ac.Salary_Credited_6__c!=null?ac.Salary_Credited_6__c:0;
                                    if(ac.Employment_Types__c == 'Salaried'){
                                        System.debug(i1 +'%%%%Salaried emp%%%%'+i2);
                                        System.debug(i3 +'%%%%Salaried emp%%%%'+i4);
                                        System.debug(i5 +'%%%%Salaried emp%%%%'+i6);
                                        min1 = math.min(i1,(1.3*math.min(math.min(math.min(math.min(math.min(i1,i2),i3),i4),i5),i6)));
                                        min2 = math.min(i2,(1.3*math.min(math.min(math.min(math.min(math.min(i1,i2),i3),i4),i5),i6)));
                                        min3 = math.min(i3,(1.3*math.min(math.min(math.min(math.min(math.min(i1,i2),i3),i4),i5),i6)));
                                        min4 = math.min(i4,(1.3*math.min(math.min(math.min(math.min(math.min(i1,i2),i3),i4),i5),i6)));
                                        min5 = math.min(i5,(1.3*math.min(math.min(math.min(math.min(math.min(i1,i2),i3),i4),i5),i6)));
                                        min6 = math.min(i6,(1.3*math.min(math.min(math.min(math.min(math.min(i1,i2),i3),i4),i5),i6)));
                                        oRec = ac.Annual_Other_IncomeRecurring_CreditsITR__c!=null?ac.Annual_Other_IncomeRecurring_CreditsITR__c:0;
                                        ac.Approved_NMI_LAP__c = ((min1+min2+min3+min4+min5+min6)/6) +oRec;
                                    }else if(ac.Employment_Types__c == 'Self-Employed Businessman'){
                                        System.debug('****Business****');
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
                    ////closing for loop
                }
            } 
            //closing for
        }
        catch(Exception e){
            System.debug('e'+e);
            HandleBusinessException.captureError('PartyTriggerHandeller', 'updateApproveNMI', e);
        }
    }
    public  void updateITRAndBankStatement(List<genesis__Application_Parties__c> newList, Map<Id,genesis__Application_Parties__c> OldMap){
        
        try{
            
            List<genesis__Application_Parties__c> partyList = new List<genesis__Application_Parties__c>();
            genesis__Application_Parties__c parRec;
            for(genesis__Application_Parties__c acc : newList){
                System.debug('acc:::'+acc);
                if(acc.Net_Monthly_Income__c != oldMap.get(acc.id).Computed_NMI__c){
                    parRec = new genesis__Application_Parties__c(Id=acc.Id);
                    parRec.Perfios_Captured__c = false;
                    // parRec.Is_Bank_Statement_required__c = true;
                    //  parRec.Is_ITR_required__c = true;
                    
                    partyList.add(parRec);
                }else if(acc.Net_Monthly_Income__c > 0){
                    parRec = new genesis__Application_Parties__c(Id=acc.Id);
                    parRec.Is_Bank_Statement_required__c = false;
                    parRec.Is_ITR_required__c = false;
                    parRec.Perfios_Captured__c = True;
                    parRec.Id = acc.Id;
                    partyList.add(parRec);
                }
                
                
            }
            if(!partyList.isEmpty()){
                isPartyTrigger = true;
                System.debug('@@@@'+partyList);
                update partyList;            
            }
        }
        catch(Exception e){
            System.debug('e'+e);
            HandleBusinessException.captureError('PartyTriggerHandeller', 'updateITRAndBankStatement', e);
        }
    }
    
    //Added by Raushan.
    //For SME APllication Auto BRE Run
    public void checkConditionForBRE_Run_OR_Cibil_Score(List<genesis__Application_Parties__c> newList,List<genesis__Application_Parties__c> oldList,Map<Id,genesis__Application_Parties__c> newMap,Map<Id,genesis__Application_Parties__c> oldMap){
        Set<id> setOfApplicationId	=	new Set<id>();
        try{
            for(genesis__Application_Parties__c	appParty	:	newList){
                
                if(appParty.genesis__Application__c !=null && appParty.Record_Type_Name__c != 'SME Renewal' && appParty.Record_Type_Name__c.contains('SME')){
                    if(appParty.CIBIL_Scores__c !=null && appParty.CIBIL_Scores__c != oldMap.get(appParty.Id).CIBIL_Scores__c){
                        setOfApplicationId.add(appParty.genesis__Application__c);
                    }
                }
            }
            if(setOfApplicationId.size() > 0){
                Map<id,genesis__Applications__c> mapOfApplication	=	new Map<id,genesis__Applications__c>([Select id,Name,BRE_Done__c,RecordType_Developer_Name__c from genesis__Applications__c where id IN : setOfApplicationId]);
                if(mapOfApplication !=null && mapOfApplication.size() > 0){
                    for(Id ids  : mapOfApplication.keySet()){
                        if(mapOfApplication.get(ids).RecordType_Developer_Name__c != 'SME_Renewal' && mapOfApplication.get(ids).RecordType_Developer_Name__c != 'SME_Exceeding'){
                            YearDataConstant.getCibilScore_Reject_New(ids);    
                        }
                        if(mapOfApplication.get(ids).RecordType_Developer_Name__c != 'SME_Renewal' && mapOfApplication.get(ids).RecordType_Developer_Name__c.contains('SME_')){
                            if(!mapOfApplication.get(ids).BRE_Done__c){
                                SME_BRE_Score_Calculator.runBRERule(mapOfApplication.get(ids),false);	    
                            }
                        }
                    }
                }
            }
        }catch(Exception ex){
            HandleBusinessException.captureError('PartyTriggerHandeller', 'checkConditionForBRE_Run_OR_Cibil_Score', ex);    
        }    
    }
    
}