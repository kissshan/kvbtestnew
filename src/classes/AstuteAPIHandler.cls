/*
* Name    : AstuteAPIHandler 
* Company : ET Marlabs
* Purpose : This class is used to check applicant and co-borrower FI status and trigger astute.
* Author  : Braj Mohan
* Date    : 23-Aug-2018
-----------------------------------------------------------------------
Version     Date            Author          Remarks                                                 
=======     ==========      =============   ==================================
v1.1        27-Dec-2018     Braj            Rule based FI implemented for HL and LAP similar to VL
*******************************************************************************************/
public class AstuteAPIHandler {

    //method used to trigger field investigation
    @future (Callout=true)
    public static void AstuteCallHandler(string appId){
        System.debug('appId==>'+appId);
        try {
            genesis__Applications__c appObj=[select Id,Name,Sub_Stage__c,Record_Type_Name__c,Sanction_Class2_Check__c from genesis__Applications__c where id=:appId];
            System.debug('appObj==>'+appObj);
            if(appObj.Sanction_Class2_Check__c && (appObj.Record_Type_Name__c==Constants.VL2W || appObj.Record_Type_Name__c==Constants.VL4W || appObj.Record_Type_Name__c==Constants.HOMELOAN || appObj.Record_Type_Name__c==Constants.LAPLOAN)){
                System.debug('**inside AstuteAPIHandler for VL/HL/LAP');
                WS_AstuteCallingAPI.callAstute(appId,'','');
            } else if(appObj.Record_Type_Name__c==Constants.PERSONALLOAN) {
                System.debug('**inside AstuteAPIHandler for PL');
                WS_AstuteCallingAPI.callAstute(appId,'','');
            }
        
        } catch(Exception e) {
            System.debug('Class name'+e.getStackTraceString()+'Line number'+e.getLineNumber());
            HandleBusinessException.captureError('AstuteAPIHandler', 'AstuteCallHandler', e);
        }  
    }

    //method used to calculate field investigation for applicant if anyone from applicant or co-applicant have not done FI
    public static Boolean VL_FICheck(String applicationId){
        System.debug('VL_FICheck()-appId==>'+applicationId);
        try {
            Boolean isNotAllExempted = false;
            genesis__Applications__c appObj=[select Id,Name,Sub_Stage__c,Record_Type_Name__c,Perfios_Captured__c,(Select id,name,genesis__Application__c,genesis__Party_Account_Name__c,genesis__Application__r.FI_Status__c,genesis__Party_Account_Name__r.Customer_ID_Creation_Date__c,genesis__Application__r.Application_Stage__c,genesis__Party_Account_Name__r.Are_you_An_Existing_Customer__c,FI_Exempted__c,Reason_for_Exemption__c,CIBIL_Scores__c,Financial_Applicant__c,Active__c,Same_Present_Address_Permanent_Address__c,Company__c from genesis__Application_Parties__r where Active__c=true),Acknowledgement__c,Sanction_Class2_Check__c from genesis__Applications__c where id=:applicationId];

            //for vehicle loan
            if(appObj.Record_Type_Name__c==Constants.VL2W || appObj.Record_Type_Name__c==Constants.VL4W || appObj.Record_Type_Name__c==Constants.HOMELOAN || appObj.Record_Type_Name__c==Constants.LAPLOAN){
                System.debug('**inside AstuteAPIHandler for Vehicle Loan/Home Loan/LAP');
                
                List<genesis__Application_Parties__c> partyListToUpdate = new List<genesis__Application_Parties__c>();
                Map<Id,Boolean> exemptedAccMap = new Map<Id,Boolean>();

                //check FI condition for applicant and all co-borrower
                for(genesis__Application_Parties__c par:appObj.genesis__Application_Parties__r){
                    //if(par.Financial_Applicant__c) {//System will check all parties whether it financial or non-financial//comment-date:05-Sep-2018
                        if (!par.Company__c) {
                            System.debug('party Company false==>'+par);
                            if(par.Same_Present_Address_Permanent_Address__c && par.genesis__Party_Account_Name__r.Are_you_An_Existing_Customer__c && par.genesis__Party_Account_Name__r.Customer_ID_Creation_Date__c.monthsBetween(System.today()) > 6) {
                                par.FI_Exempted__c = true;
                                par.Reason_for_Exemption__c = 'ETB > 6 months';
                                exemptedAccMap.put(par.genesis__Party_Account_Name__c,true);
                                partyListToUpdate.add(par);
                            } else if(par.Same_Present_Address_Permanent_Address__c && par.genesis__Party_Account_Name__r.Are_you_An_Existing_Customer__c && par.genesis__Party_Account_Name__r.Customer_ID_Creation_Date__c.monthsBetween(System.today()) <= 6 && par.CIBIL_Scores__c >=775){
                                par.FI_Exempted__c = true;
                                par.Reason_for_Exemption__c = 'ETB <= 6 months && CIBIL score more than 775 cibil score';
                                exemptedAccMap.put(par.genesis__Party_Account_Name__c,true);
                                partyListToUpdate.add(par);
                            } else if (par.Same_Present_Address_Permanent_Address__c && !par.genesis__Party_Account_Name__r.Are_you_An_Existing_Customer__c && par.CIBIL_Scores__c >=775) {
                                par.FI_Exempted__c = true;
                                par.Reason_for_Exemption__c = 'NTB && CIBIL score more than 775 cibil score';
                                exemptedAccMap.put(par.genesis__Party_Account_Name__c,true);
                                partyListToUpdate.add(par);
                            } else {
                                isNotAllExempted = true;
                                exemptedAccMap.put(par.genesis__Party_Account_Name__c,false);
                            }
                        }
                        
                    //}
                }

                for(genesis__Application_Parties__c par:appObj.genesis__Application_Parties__r){
                    if(par.Company__c && exemptedAccMap.containsKey(par.genesis__Party_Account_Name__c)){
                        System.debug('party Company true==>'+par);
                        if (exemptedAccMap.get(par.genesis__Party_Account_Name__c)==true){
                            par.FI_Exempted__c = true;
                            par.Reason_for_Exemption__c = 'Applicant is Exempted';
                            partyListToUpdate.add(par);
                        }
                    }
                }

                System.debug('isNotAllExempted==>'+isNotAllExempted);
                if(partyListToUpdate.size()>0) {
                    System.debug(partyListToUpdate.size()+'<==partyListToUpdate==>'+partyListToUpdate);
                    update partyListToUpdate;
                }
                if(isNotAllExempted) {
                    appObj.Sanction_Class2_Check__c = isNotAllExempted;
                    update appObj;
                } else {
                    System.debug('FI Exempted for all');
                    if(appObj.Acknowledgement__c || appObj.Perfios_Captured__c) {
                        appObj.Sub_Stage__c = 'Loan Sanctioned STP';
                    }
                }
            }
            return true;            
        } catch(Exception e) {
            System.debug('Class name'+e.getStackTraceString()+'Line number'+e.getLineNumber());
            HandleBusinessException.captureError('AstuteAPIHandler', 'VL_FICheck', e);
            return null;
        }  
    }
}