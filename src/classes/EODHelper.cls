/*
 * Name     : EODHelper
 * Company  : ET Marlabs
 * Purpose  : This class is used as a helper for WS_AccountEODDeltaChange Webservice.
 * Author   : Raushan
*/
public with sharing class EODHelper {
    /*public static void accountEODResponse(AccountEODResponse accEODRes){
        AccountEODResponse.cls_outmap outmapObj                             =   accEODRes.outmap;
        List<AccountEODResponse.cls_CUSTOMERS> listcustomer                 =   outmapObj.CUSTOMERS;
        List<Account> listaccount                                           =   new List<Account>();                
        If(listcustomer !=null && listcustomer.size() > 0){
            for(AccountEODResponse.cls_CUSTOMERS customerObj                :   listcustomer){
                Account accObj                                              =   new Account();
                accObj.Chief_Person_Designation__c                          =   customerObj.CHIEF_PERSON;
                accObj.AccountNumber                                        =   customerObj.ACCT_NO;
                accObj.CBS_Customer_ID__c                                   =   customerObj.CUST_CODE;
                
                List<AccountEODResponse.cls_COMP_GROUP_CONCERN> listcompgroup   =   customerObj.COMP_GROUP_CONCERN;
                If(listcompgroup !=null && listcompgroup.size() >0){
                    for(AccountEODResponse.cls_COMP_GROUP_CONCERN comGroup  :   listcompgroup){
                        
                    }
                }
                List<AccountEODResponse.cls_PROMOTORS> listpromotors        =   customerObj.PROMOTORS;
                If(listpromotors !=null && listpromotors.size() >0){
                    for(AccountEODResponse.cls_PROMOTORS promotorsObj       :   listpromotors){
                        
                        Account accPromotor                                 =   new Account();
                        accPromotor.CBS_Customer_ID__c                      =   String.valueOf(promotorsObj.V_CUST_CODE);
                        accPromotor.Name__c                                 =   promotorsObj.CUSTOMER_NAME;
                        accPromotor.Pan_Number__c                           =   promotorsObj.PAN_NO;
                        accPromotor.PersonBirthdate                         =   Date.valueOf(promotorsObj.DOB);
                        accPromotor.Gender__pc                              =   promotorsObj.SEX;
                        accPromotor.Father_Name__pc                         =   promotorsObj.FATHER_NAME;
                        accPromotor.Marital_Status__pc                      =   String.valueOf(promotorsObj.MARITAL_STATUS);
                        accPromotor.Spouse_Name__pc                         =   promotorsObj.SPOUSE_NAME;
                        accPromotor.Signatories__pc                         =   Boolean.valueOf(promotorsObj.SIGNATORIES);
                        accPromotor.Caste__pc                               =   promotorsObj.CASTE;
                        accPromotor.Religion__c                             =   promotorsObj.RELIGION;
                        accPromotor.Nationality__pc                         =   promotorsObj.TXT_CUST_NATNLTY;
                        accPromotor.Percentage_of_holding__pc               =   Double.valueOf(promotorsObj.PERC_HOLDING);
                        
                        listaccount.add(accPromotor);
                    }   
                }
                List<AccountEODResponse.cls_FACILITY> listfacility          =   customerObj.FACILITY;
                If(listfacility !=null && listfacility.size() >0){
                    for(AccountEODResponse.cls_FACILITY facilityObj         :   listfacility){
                        
                    }       
                }
                List<AccountEODResponse.cls_COMP_BRANCHES> listcompbranch   =   customerObj.COMP_BRANCHES;
                If(listcompbranch !=null && listcompbranch.size() > 0){
                    for(AccountEODResponse.cls_COMP_BRANCHES branchObj      :   listcompbranch){
                        
                    }
                }
                List<AccountEODResponse.cls_GUARANTOR>  listguarantor       =   customerObj.GUARANTOR;
                If(listguarantor !=null && listguarantor.size() > 0){
                    for(AccountEODResponse.cls_GUARANTOR guarantorObj       :   listguarantor){
                        Account accGuarantor                                =   new Account();
                        accGuarantor.CBS_Customer_ID__c                     =   String.valueOf(guarantorObj.V_CUST_CODE);
                        accGuarantor.Aadhaar_Number__pc                     =   guarantorObj.AADHAR;
                        accGuarantor.Name__c                                =   guarantorObj.CUSTOMER_NAME;
                        accGuarantor.Pan_Number__c                          =   guarantorObj.PAN_NO;
                        accGuarantor.PersonBirthdate                        =   Date.valueOf(guarantorObj.DOB);
                        accGuarantor.Gender__pc                             =   guarantorObj.SEX;
                        accGuarantor.Father_Name__pc                        =   guarantorObj.FATHER_NAME;
                        accGuarantor.Marital_Status__pc                     =   String.valueOf(guarantorObj.MARITAL_STATUS);
                        accGuarantor.Spouse_Name__pc                        =   guarantorObj.SPOUSE_NAME;
                        accGuarantor.Signatories__pc                        =   Boolean.valueOf(guarantorObj.SIGNATORIES);
                        accGuarantor.Caste__pc                              =   guarantorObj.CASTE;
                        accGuarantor.Religion__c                            =   guarantorObj.RELIGION;
                        accGuarantor.Nationality__pc                        =   guarantorObj.TXT_CUST_NATNLTY;
                        
                        listaccount.add(accGuarantor);
                    }
                }               
            }
        }
    }
    */
}