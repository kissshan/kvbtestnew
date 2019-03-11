/*
* Name     : SMELoan_Helper_Fetch_Handler
* Company  : ET Marlabs
* Purpose  : This class is used as a handler for SMELoan_Helper_Handler.
* Author   : Raushan
*/
public class SMELoan_Helper_Fetch_Handler {
    
    public static Customer360view.cls_NEW_LOAN_FACILITY_DETAILS getNewLoanFacilityDetails(Customer360view.cls_NEW_LOAN_FACILITY_DETAILS newLoanFacWrrpObj,String custSFId,String appId, List<Facility__c> listOfFacilityApp){
        
        If(custSFId !=null && custSFId !='' && appId !=null && appId !=''){
            
            try{
                
                Set<String> setOfUniqueNumber = new Set<String>();
                List<Facility__c> termLoanFacilityList= [select id,Facility_Sequence_Number__c,Account_Number__c,EMINMI__c,Application__r.RecordType_Developer_Name__c,Product_Name__c,Margin__c,MCLR_Rate__c,Existing_Rate__c,Existing_Limit__c,
                                                        Limit_end_date__c,Limit_Amount__c,Loan_Purpose__c,New_Limit_Amount__c,CL_Product__c,Unique_Number_for_NTB__c,Recommended_Limit__c,Recommended_Rate__c,
                                                        Recommended_Days__c,Tenure__c,Holiday_Period__c,Current_outstanding__c,Nature_of_Facility__c,Current_Balance__c
                                                        from Facility__c where Application__r.RecordType_Developer_Name__c='Term_Loan' AND Application__r.genesis__Account__r.Id=: custSFId]; 
                List<genesis__Applications__c> appLst= [select id,RecordType.DeveloperName from genesis__Applications__c where id=: appId];
                List<genesis__AppDocCatAttachmentJunction__c> listAppDocCat = new  List<genesis__AppDocCatAttachmentJunction__c>();
                // APP List of Facility 
                If(listOfFacilityApp !=null && !listOfFacilityApp.isEmpty()){
                    for(Facility__c facObj : listOfFacilityApp){
                        If(facObj !=null && facObj.Unique_Number_for_NTB__c !=null){
                            setOfUniqueNumber.add(facObj.Unique_Number_for_NTB__c);
                        }
                    }
                }
                
                //Credit_Facility_Detail__c
               /* List<Credit_Facility_Detail__c> listOfCreditFacility = [
                    select id,Name,Account_Number__c,Amount__c,Asset_Classification__c,CF_Member__c,CF_Type__c,Credit_Type__c,Current_Balance__c,
                    Outstanding_Balance__c,Over_Due__c,Status__c,Sanction_Date__c,Sanctioned_Amount__c,Tu_Credit_Report__c,Drawing_Power__c,
                    Tu_Credit_Report__r.Account__c from Credit_Facility_Detail__c where Tu_Credit_Report__r.Account__c =:custSFId 
                ]; */
                List<Current_Account__c> listOfCurrentAccount   = [select id,Original_Tenure__c,Date_of_Disbursement__c,Account__c,Unique_Number__c,Tenure__c,Holiday_Period__c,Account_Number__c,Bank_Name__c,Current_Balance__c,Start_Date__c,Current_outstanding__c,Interest_Rate__c,Margin__c,Nature_of_Facility__c,Sanctioned_Amount__c,Sanctioned_Year__c,End_Date__c,Purpose_of_Current_Account__c,Facility_Name__c,RecordType.DeveloperName from Current_Account__c where Account__c =:custSFId];
                If(listOfCurrentAccount !=null && listOfCurrentAccount.size() > 0){
                    for(Current_Account__c currentObj   :   listOfCurrentAccount){
                        if(currentObj !=null && currentObj.Unique_Number__c !=null){
                            setOfUniqueNumber.add(currentObj.Unique_Number__c);    
                        }
                    }
                }
                //set of Unique Number
                If(setOfUniqueNumber !=null && !setOfUniqueNumber.isEmpty()){
                    listAppDocCat = [select id,genesis__Application_Document_Category__c,Dms_Uuid__c,Entity_Id__c,Transaction_Id__c from genesis__AppDocCatAttachmentJunction__c where Entity_Id__c IN : setOfUniqueNumber OR Entity_Id__c =: appId]; 
                    System.debug('List of Application Documents'+ listAppDocCat);
                }
                //Document category list.
                List<String> docCatNameList                     = new List<String>{Constants.BANK_STATEMENT_CATEGORY,Constants.SANCTION_LETTER_CATEGORY,Constants.SUPPORTING_DOCS_CATEGORY};
                List<genesis__Application_Document_Category__c> docCatList = DocumentFetch.checkDocumentCategory(appId,docCatNameList);
                System.debug('docCatList@@@@'+ docCatList);
                newLoanFacWrrpObj   = new Customer360view.cls_NEW_LOAN_FACILITY_DETAILS();
                
                newLoanFacWrrpObj.IS_TASK_FAILED = '';
                newLoanFacWrrpObj.APPLICATION_EXPOSURE = '';
                
                newLoanFacWrrpObj.WC_WITH_KVB                  = new List<Customer360view.cls_WC_WITH_KVB>();
                
               /* If(listOfFacility !=null && listOfFacility.size()>0){
                    for(Facility__c facObj  :   listOfFacility){
                        If(facObj !=null){
                            
                            Customer360view.cls_WC_WITH_KVB    wcFacKvbWrrpObj     =   new Customer360view.cls_WC_WITH_KVB();
                            if(facObj.NTB_Facility_Type__c == 'Renewal'){
                                wcFacKvbWrrpObj.LOAN_ACCOUNT_NUMBER                     = Utility.getBlankStringIfNull(facObj.Account_Number__c);
                            wcFacKvbWrrpObj.FACILITY_NAME                           = Utility.getBlankStringIfNull(facObj.CL_Product__r.clcommon__Product_Name__c);
                            wcFacKvbWrrpObj.MARGIN                                  = Utility.getBlankStringIfNull(String.valueOf(facObj.Margin__c));
                            If(facObj.MCLR_Rate__c !=null && facObj.Existing_Rate__c !=null){
                                wcFacKvbWrrpObj.INTEREST_RATE                       = Utility.getBlankStringIfNull(String.valueOf(facObj.MCLR_Rate__c+facObj.Existing_Rate__c));    
                            }else{
                                wcFacKvbWrrpObj.INTEREST_RATE = '';
                            }
                            wcFacKvbWrrpObj.SANCTION_LIMIT                          = Utility.getBlankStringIfNull(String.valueOf(facObj.Existing_Limit__c));
                            wcFacKvbWrrpObj.END_DATE                                = Utility.getBlankStringIfNull(String.valueOf(facObj.Limit_end_date__c));
                            wcFacKvbWrrpObj.APPLY_FOR_ENHANCEMENT                   = '';
                            wcFacKvbWrrpObj.LIMIT_AMOUNT                            = Utility.getBlankStringIfNull(String.valueOf(facObj.Limit_Amount__c));
                            wcFacKvbWrrpObj.PURPOSE_OF_LOAN                         = Utility.getBlankStringIfNull(facObj.Loan_Purpose__c);
                            wcFacKvbWrrpObj.FACILITY_NAME                           = Utility.getBlankStringIfNull(facObj.Product_Name__c);
                            wcFacKvbWrrpObj.CURRENT_LIMIT                           = Utility.getBlankStringIfNull(String.valueOf(facObj.Existing_Limit__c));
                            wcFacKvbWrrpObj.PROPOSED_LIMIT                          = Utility.getBlankStringIfNull(String.valueOf(facObj.New_Limit_Amount__c));
                            wcFacKvbWrrpObj.PRODUCT_ID                              = Utility.getBlankStringIfNull(facObj.CL_Product__c);
                            wcFacKvbWrrpObj.UNIQUE_NO                               = facObj.id;
                            wcFacKvbWrrpObj.REASON_FOR_ENHANCEMENT                  = '';
                            wcFacKvbWrrpObj.FACILITY_ID                             = facObj.Id;
                            
                            newLoanFacWrrpObj.WC_WITH_KVB.add(wcFacKvbWrrpObj);    
                            }
                           
                        }
                    }
                } */
                newLoanFacWrrpObj.APP_WC_WITH_KVB                  = new List<Customer360view.cls_APP_WC_WITH_KVB>();
                
                If(listOfFacilityApp !=null && listOfFacilityApp.size()>0){
                    for(Facility__c facObj  :   listOfFacilityApp){
                        If(facObj !=null && (facObj.NTB_Facility_Type__c == Constants.WC_KVB || facObj.NTB_Facility_Type__c == 'Renewal')){
                            
                            Customer360view.cls_APP_WC_WITH_KVB    wcFacKvbWrrpObj     =   new Customer360view.cls_APP_WC_WITH_KVB();
                            
                            wcFacKvbWrrpObj.FACILITY_ID                 = facObj.Id;
                            wcFacKvbWrrpObj.LOAN_ACCOUNT_NUMBER         = Utility.getBlankStringIfNull(facObj.Account_Number__c);
                            wcFacKvbWrrpObj.FACILITY_NAME               = Utility.getBlankStringIfNull(facObj.Product_Name__c);
                            wcFacKvbWrrpObj.MARGIN                      = Utility.getBlankStringIfNull(String.valueOf(facObj.Margin__c));
                            If(facObj.MCLR_Rate__c !=null && facObj.Existing_Rate__c !=null){
                                wcFacKvbWrrpObj.INTEREST_RATE           = Utility.getBlankStringIfNull(String.valueOf(facObj.MCLR_Rate__c+facObj.Existing_Rate__c));    
                            }else{
                                wcFacKvbWrrpObj.INTEREST_RATE = '';
                            }
                            wcFacKvbWrrpObj.SANCTION_LIMIT              = Utility.getBlankStringIfNull(String.valueOf(facObj.Existing_Limit__c));
                            wcFacKvbWrrpObj.END_DATE                    = Utility.getBlankStringIfNull(String.valueOf(facObj.Limit_end_date__c));
                            wcFacKvbWrrpObj.APPLY_FOR_ENHANCEMENT       = '';
                            wcFacKvbWrrpObj.LIMIT_AMOUNT                = Utility.getBlankStringIfNull(String.valueOf(facObj.Limit_Amount__c));
                            wcFacKvbWrrpObj.PURPOSE_OF_LOAN             = Utility.getBlankStringIfNull(facObj.Loan_Purpose__c);
                            wcFacKvbWrrpObj.CURRENT_LIMIT               = Utility.getBlankStringIfNull(String.valueOf(facObj.Existing_Limit__c));
                            wcFacKvbWrrpObj.PROPOSED_LIMIT              = Utility.getBlankStringIfNull(String.valueOf(facObj.New_Limit_Amount__c));
                            wcFacKvbWrrpObj.PRODUCT_ID                  = Utility.getBlankStringIfNull(facObj.CL_Product__c);
                            wcFacKvbWrrpObj.UNIQUE_NO                   = Utility.getBlankStringIfNull(facObj.Unique_Number_for_NTB__c);
                            wcFacKvbWrrpObj.RECOMMENDED_LIMIT           = Utility.getBlankStringIfNull(String.valueOf(facObj.Recommended_Limit__c));
                            wcFacKvbWrrpObj.REASON_FOR_ENHANCEMENT      = ''; //RECOMMENDED_LIMIT
                            wcFacKvbWrrpObj.SEQUENCE_NO= Utility.getBlankStringIfNull(facObj.Facility_Sequence_Number__c);
                            wcFacKvbWrrpObj.TENURE= facObj.Tenure__c!=null? String.valueOf(facObj.Tenure__c):'';
                            /*Added for New Doc flow*/
                            wcFacKvbWrrpObj.MCLR_Rate= Utility.getBlankStringIfNull(String.Valueof(facObj.MCLR_Rate__c));
                            wcFacKvbWrrpObj.Loan_Rate_of_Interest= Utility.getBlankStringIfNull(String.Valueof(facObj.Recommended_Rate__c));
                            wcFacKvbWrrpObj.Validity_Period= (appLst[0].RecordType.DeveloperName== 'SME_Exceeding' || appLst[0].RecordType.DeveloperName== 'SME_AdHoc')? Utility.getBlankStringIfNull(String.valueOf(facObj.Recommended_Days__c)) :'365';
                            wcFacKvbWrrpObj.Preclosure_Charge= constants.Preclosure_Charge;
                            wcFacKvbWrrpObj.Penal_Charges= constants.Penal_Charges;

                            wcFacKvbWrrpObj.APPROVED_LIMIT= facObj.Recommended_Limit__c!=null? String.Valueof(facObj.Recommended_Limit__c):'' ;
                            wcFacKvbWrrpObj.NEW_LIMIT_AMT= facObj.New_Limit_Amount__c!=null? String.Valueof(facObj.New_Limit_Amount__c):'';


                            wcFacKvbWrrpObj.SUPPORTING_DOCS_DETAILS     = new List<Customer360view.cls_SUPPORTING_DOCS_DETAILS>();
                            
                        /*If(listAppDocCat !=null && !listAppDocCat.isEmpty()){
                                for(genesis__AppDocCatAttachmentJunction__c appDocCatObj  : listAppDocCat){
                                    If(appDocCatObj !=null && appDocCatObj.Entity_Id__c !=null && appDocCatObj.Transaction_Id__c == null){
                                        If(appDocCatObj.Entity_Id__c == facObj.Application__c){
                                            Customer360view.cls_SUPPORTING_DOCS_DETAILS suppotingDocWrrp = new Customer360view.cls_SUPPORTING_DOCS_DETAILS();
                                            suppotingDocWrrp.CATEGORY_ID    =  Utility.getBlankStringIfNull(appDocCatObj.genesis__Application_Document_Category__c);
                                            suppotingDocWrrp.DOC_UUID   =  Utility.getBlankStringIfNull(appDocCatObj.Dms_Uuid__c);
                                            suppotingDocWrrp.FACILITY_ID    =  Utility.getBlankStringIfNull(appDocCatObj.Entity_Id__c);
                                            
                                            wcFacKvbWrrpObj.SUPPORTING_DOCS_DETAILS.add(suppotingDocWrrp);    
                                        } 
                                    }
                                    
                                }
                            } */
                            newLoanFacWrrpObj.APP_WC_WITH_KVB.add(wcFacKvbWrrpObj);
                        }
                    }
                }

                /* Added for Term Loan*/
                newLoanFacWrrpObj.APP_TL_WITH_KVB                  = new List<Customer360view.cls_APP_WC_WITH_KVB>();
                if(termLoanFacilityList.size()>0){
                    for(Facility__c tlFaci  :termLoanFacilityList){
                        Customer360view.cls_APP_WC_WITH_KVB    tlFacKvbWrrpObj     =   new Customer360view.cls_APP_WC_WITH_KVB();
                            tlFacKvbWrrpObj.FACILITY_ID                 = tlFaci.Id;
                            tlFacKvbWrrpObj.LOAN_ACCOUNT_NUMBER         = Utility.getBlankStringIfNull(tlFaci.Account_Number__c);
                            tlFacKvbWrrpObj.FACILITY_NAME               = Utility.getBlankStringIfNull(tlFaci.Product_Name__c);
                            tlFacKvbWrrpObj.MARGIN                      = Utility.getBlankStringIfNull(String.valueOf(tlFaci.Margin__c));
                            If(tlFaci.MCLR_Rate__c !=null && tlFaci.Existing_Rate__c !=null){
                                tlFacKvbWrrpObj.INTEREST_RATE           = Utility.getBlankStringIfNull(String.valueOf(tlFaci.MCLR_Rate__c+tlFaci.Existing_Rate__c));    
                            }else{
                                tlFacKvbWrrpObj.INTEREST_RATE = '';
                            }
                            tlFacKvbWrrpObj.SANCTION_LIMIT              = Utility.getBlankStringIfNull(String.valueOf(tlFaci.Existing_Limit__c));
                            tlFacKvbWrrpObj.END_DATE                    = Utility.getBlankStringIfNull(String.valueOf(tlFaci.Limit_end_date__c));
                            tlFacKvbWrrpObj.APPLY_FOR_ENHANCEMENT       = '';
                            tlFacKvbWrrpObj.LIMIT_AMOUNT                = Utility.getBlankStringIfNull(String.valueOf(tlFaci.Limit_Amount__c));
                            tlFacKvbWrrpObj.PURPOSE_OF_LOAN             = Utility.getBlankStringIfNull(tlFaci.Loan_Purpose__c);
                            tlFacKvbWrrpObj.CURRENT_LIMIT               = Utility.getBlankStringIfNull(String.valueOf(tlFaci.Existing_Limit__c));
                            tlFacKvbWrrpObj.PROPOSED_LIMIT              = Utility.getBlankStringIfNull(String.valueOf(tlFaci.New_Limit_Amount__c));
                            tlFacKvbWrrpObj.PRODUCT_ID                  = Utility.getBlankStringIfNull(tlFaci.CL_Product__c);
                            tlFacKvbWrrpObj.UNIQUE_NO                   = Utility.getBlankStringIfNull(tlFaci.Unique_Number_for_NTB__c);
                            tlFacKvbWrrpObj.RECOMMENDED_LIMIT           = Utility.getBlankStringIfNull(String.valueOf(tlFaci.Recommended_Limit__c));
                            tlFacKvbWrrpObj.REASON_FOR_ENHANCEMENT      = ''; //RECOMMENDED_LIMIT

                            tlFacKvbWrrpObj.TENURE=Utility.getBlankStringIfNull(String.valueOf(tlFaci.Tenure__c));
                            tlFacKvbWrrpObj.HOLIDAY_PERIOD= Utility.getBlankStringIfNull(String.valueOf(tlFaci.Holiday_Period__c));
                            tlFacKvbWrrpObj.CURRENT_OUTSTANDING= Utility.getBlankStringIfNull(String.valueOf(tlFaci.Current_outstanding__c));
                            tlFacKvbWrrpObj.NATURE_OF_FACILITY= Utility.getBlankStringIfNull(tlFaci.Nature_of_Facility__c);
                            tlFacKvbWrrpObj.ACCOUNT_NUMBER= Utility.getBlankStringIfNull(tlFaci.Account_Number__c);
                            tlFacKvbWrrpObj.CURRENT_BALANCE= Utility.getBlankStringIfNull(String.valueOf(tlFaci.Current_Balance__c));
                            tlFacKvbWrrpObj.SEQUENCE_NO= Utility.getBlankStringIfNull(tlFaci.Facility_Sequence_Number__c);
                            tlFacKvbWrrpObj.APPROVED_LIMIT= tlFaci.Recommended_Limit__c!=null? String.Valueof(tlFaci.Recommended_Limit__c):'' ;
                            tlFacKvbWrrpObj.NEW_LIMIT_AMT= tlFaci.New_Limit_Amount__c!=null? String.Valueof(tlFaci.New_Limit_Amount__c):'';

                            /*Added for New Doc flow*/
                            tlFacKvbWrrpObj.MCLR_Rate= Utility.getBlankStringIfNull(String.Valueof(tlFaci.MCLR_Rate__c));
                            tlFacKvbWrrpObj.Loan_Rate_of_Interest= Utility.getBlankStringIfNull(String.Valueof(tlFaci.Recommended_Rate__c));
                            tlFacKvbWrrpObj.Validity_Period= '365';
                            tlFacKvbWrrpObj.Preclosure_Charge= constants.Preclosure_Charge;
                            tlFacKvbWrrpObj.Penal_Charges= constants.Penal_Charges;

                            newLoanFacWrrpObj.APP_TL_WITH_KVB.add(tlFacKvbWrrpObj);

                    }

                }
                /*If(listOfCreditFacility !=null && listOfCreditFacility.size()>0){
                    Decimal totalExposure   = 0.0;
                    for(Credit_Facility_Detail__c   creditfacilityObj   :   listOfCreditFacility){
                        If(creditfacilityObj !=null){
                            If(creditfacilityObj.Status__c !=null && creditfacilityObj.Status__c !=''){
                                List<String> listOfString = creditfacilityObj.Status__c.split(',');
                                If(listOfString[1] == 'Open'){
                                    If(creditfacilityObj.Sanctioned_Amount__c !=null && creditfacilityObj.Sanctioned_Amount__c !=''){
                                        totalExposure += Decimal.valueOf(creditfacilityObj.Sanctioned_Amount__c);    
                                    }    
                                }
                            }
                        } 
                    }
                    newLoanFacWrrpObj.TU_OVERALL_EXPOSURE = String.valueOf(totalExposure);    
                } */
                newLoanFacWrrpObj.CURRENT_ACCOUNT_WITH_OTHER_BANKS      = new List<Customer360view.cls_CURRENT_ACCOUNT_WITH_OTHER_BANKS>();
                
                map<String, Perfios__c> perfiosStatusMap= getPerfiosStatus(appId);
                Boolean noStageChange= false;
                Boolean isError = false;
                for(Perfios__c per: perfiosStatusMap.values()){
                    if(per.Application__r.RecordType_Developer_Name__c== 'SME_NEW_Loan'){
                        if(per.Perfios_Status__c== 'Initiated' || per.Perfios_Status__c=='Perfios Pending Process'){
                            noStageChange= true;
                            break;
                        }else if(per.Perfios_Status__c=='Error'){
                            isError = true;
                        }
                    }
                    
                }
                if(!noStageChange && isError){
                    genesis__Applications__c appRec= new genesis__Applications__c(Id= appId);
                    appRec.Sub_Stage__c='Perfios Error';
                    appRec.Application_UI_Stage__c='ExistingFacilitiesDetails';
                    
                    ApplicationTriggerHandler.IsFirstRun = false;
                    update appRec;
                }

                If(listOfCurrentAccount !=null && listOfCurrentAccount.size()>0){
                    
                    for(Current_Account__c  currentObj  :   listOfCurrentAccount){
                        If(currentObj !=null && currentObj.RecordType.DeveloperName == 'Current_Account'){
                            
                            Customer360view.cls_CURRENT_ACCOUNT_WITH_OTHER_BANKS  currentAccountWrrp = new Customer360view.cls_CURRENT_ACCOUNT_WITH_OTHER_BANKS();
                            currentAccountWrrp.BANK_NAME    = Utility.getBlankStringIfNull(currentObj.Bank_Name__c);
                            currentAccountWrrp.ACCOUNT_NUMBER   = Utility.getBlankStringIfNull(currentObj.Account_Number__c);
                            currentAccountWrrp.CURRENT_BALANCE  = Utility.getBlankStringIfNull(String.valueOf(currentObj.Current_Balance__c));
                            currentAccountWrrp.START_DATE   = Utility.getBlankStringIfNull(currentObj.Start_Date__c);
                            currentAccountWrrp.PURPOSE_OF_CA    = Utility.getBlankStringIfNull(currentObj.Purpose_of_Current_Account__c);
                            currentAccountWrrp.END_DATE = Utility.getBlankStringIfNull(currentObj.End_Date__c);
                            currentAccountWrrp.UNIQUE_NO    = Utility.getBlankStringIfNull(currentObj.Unique_Number__c);
                            currentAccountWrrp.CURRENT_LOS_ID= Utility.getBlankStringIfNull(currentObj.Id);
                            
                            currentAccountWrrp.BANK_STATEMENT = new List<Customer360view.cls_BANK_STATEMENT>();
                            
                            If(listAppDocCat !=null && !listAppDocCat.isEmpty()){
                                for(genesis__AppDocCatAttachmentJunction__c appDocCatObj  : listAppDocCat){
                                    Customer360view.cls_BANK_STATEMENT	bankStatObj = new Customer360view.cls_BANK_STATEMENT();
                                    If(appDocCatObj !=null && appDocCatObj.Entity_Id__c !=null && appDocCatObj.Transaction_Id__c != null){
                                        
                                        If(currentObj.Unique_Number__c !=null && appDocCatObj.Entity_Id__c == currentObj.Unique_Number__c){
                                            bankStatObj.CATEGORY_ID   =  Utility.getBlankStringIfNull(appDocCatObj.genesis__Application_Document_Category__c);
                                            bankStatObj.DOC_UUID      =  Utility.getBlankStringIfNull(appDocCatObj.Dms_Uuid__c);
                                            bankStatObj.TRANXN_ID     =  Utility.getBlankStringIfNull(appDocCatObj.Transaction_Id__c);

                                        }
                                        if(perfiosStatusMap.size()>0 && perfiosStatusMap.get(appDocCatObj.Transaction_Id__c)!=null && perfiosStatusMap.containsKey(appDocCatObj.Transaction_Id__c)){
                                			bankStatObj.PERFIOS_STATUS= perfiosStatusMap.get(appDocCatObj.Transaction_Id__c).Perfios_Status__c;
                            			}
                                      	currentAccountWrrp.BANK_STATEMENT.add(bankStatObj);  
                                    }
                                    
                                }
                                
                            }
                            newLoanFacWrrpObj.CURRENT_ACCOUNT_WITH_OTHER_BANKS.add(currentAccountWrrp);
                        }
                        
                    }
                }
                //NEW Loan Facility With Other Bank.
                
                newLoanFacWrrpObj.WC_WITH_OTHER_BANK                         = new Customer360view.cls_WC_WITH_OTHER_BANK();
                newLoanFacWrrpObj.WC_WITH_OTHER_BANK.REASON_FOR_SHIFTING     = '';
                newLoanFacWrrpObj.WC_WITH_OTHER_BANK.FACILITY_OTHER          = new List<Customer360view.cls_FACILITY_OTHER>();
                newLoanFacWrrpObj.WC_WITH_OTHER_BANK.SUPPORTING_DOCS_DETAILS = new List<Customer360view.cls_SUPPORTING_DOCS_DETAILS>();

                //Term Loan Facility With Other Bank.
                newLoanFacWrrpObj.TL_WITH_OTHER_BANK                         = new Customer360view.cls_WC_WITH_OTHER_BANK();
                newLoanFacWrrpObj.TL_WITH_OTHER_BANK.REASON_FOR_SHIFTING     = '';
                newLoanFacWrrpObj.TL_WITH_OTHER_BANK.FACILITY_OTHER          = new List<Customer360view.cls_FACILITY_OTHER>();
                newLoanFacWrrpObj.TL_WITH_OTHER_BANK.SUPPORTING_DOCS_DETAILS = new List<Customer360view.cls_SUPPORTING_DOCS_DETAILS>();
                
                If(listOfFacilityApp !=null && ! listOfFacilityApp.isEmpty()){
                    for(Facility__c facObj  : listOfFacilityApp){
                        If(facObj !=null){
                            
                            Customer360view.cls_FACILITY_OTHER  facilityOtherWrrp   = new Customer360view.cls_FACILITY_OTHER();
                            
                            facilityOtherWrrp.FACILITY_NAME              = Utility.getBlankStringIfNull(facObj.NTB_Facility_Category__c);
                            
                            facilityOtherWrrp.MARGIN                      = Utility.getBlankStringIfNull(String.valueOf(facObj.Margin__c));
                            If(facObj.Interest_Rate__c !=null){
                                facilityOtherWrrp.INTEREST_RATE           = Utility.getBlankStringIfNull(String.valueOf(facObj.Interest_Rate__c));    
                            }else{
                                facilityOtherWrrp.INTEREST_RATE = '';
                            }
                            facilityOtherWrrp.SANCTION_LIMIT              = Utility.getBlankStringIfNull(String.valueOf(facObj.Sanction_Limit__c));
                            facilityOtherWrrp.BALANCE_OUTSTANDING         = Utility.getBlankStringIfNull(String.valueOf(facObj.Balance_Outstandings__c));
                            facilityOtherWrrp.END_DATE                    = Utility.getBlankStringIfNull(String.valueOf(facObj.Limit_end_date__c));
                            facilityOtherWrrp.FACILITY_ID                 = facObj.Id;
                            facilityOtherWrrp.UNIQUE_NO                   = Utility.getBlankStringIfNull(facObj.Unique_Number_for_NTB__c);
                            facilityOtherWrrp.REQUESTED_AMOUNT            = Utility.getBlankStringIfNull(String.valueOf(facObj.New_Limit_Amount__c));
                            facilityOtherWrrp.BANK_NAME                   = Utility.getBlankStringIfNull(facObj.Bank_Name__c);
                            facilityOtherWrrp.RECOMMENDED_LIMIT           = Utility.getBlankStringIfNull(String.valueOf(facObj.Recommended_Limit__c));

                            /* Added for New Term Loan*/
                            facilityOtherWrrp.TENURE=Utility.getBlankStringIfNull(String.valueOf(facObj.Tenure__c));
                            facilityOtherWrrp.ORIGINAL_TENURE= Utility.getBlankStringIfNull(String.valueOf(facObj.Original_Tenure__c));
                            facilityOtherWrrp.HOLIDAY_PERIOD= Utility.getBlankStringIfNull(String.valueOf(facObj.Holiday_Period__c));
                            facilityOtherWrrp.CURRENT_OUTSTANDING= Utility.getBlankStringIfNull(String.valueOf(facObj.Current_outstanding__c));
                            facilityOtherWrrp.NATURE_OF_FACILITY= Utility.getBlankStringIfNull(facObj.Nature_of_Facility__c);
                            facilityOtherWrrp.ACCOUNT_NUMBER= Utility.getBlankStringIfNull(facObj.Account_Number__c);
                            facilityOtherWrrp.CURRENT_BALANCE= Utility.getBlankStringIfNull(String.valueOf(facObj.Current_Balance__c));
                            facilityOtherWrrp.FACILITY_PRODUCT_CATEGORY= Utility.getBlankStringIfNull(facObj.Facility_Product_category__c);
                            facilityOtherWrrp.APP_FACILITY_TYPE= Utility.getBlankStringIfNull(facObj.App_Facility_Type__c);
                            facilityOtherWrrp.PURPOSE_OF_LOAN             = Utility.getBlankStringIfNull(facObj.Purpose_of_Loan__c);
                            facilityOtherWrrp.DISBURSEMENT_DATE             = facObj.Date_of_Disbursement__c!=null ? String.valueOf(facObj.Date_of_Disbursement__c): '';
                            facilityOtherWrrp.SEQUENCE_NO= facObj.Facility_Sequence_Number__c!= null? facObj.Facility_Sequence_Number__c: ''; 
                            facilityOtherWrrp.APPROVED_LIMIT= facObj.Recommended_Limit__c!= null? string.valueof(facObj.Recommended_Limit__c) : '';
                            facilityOtherWrrp.NEW_LIMIT_AMT= facObj.Facility_Sequence_Number__c!= null? string.valueof(facObj.New_Limit_Amount__c): '';
                            
                            /*Added for New Doc Flow*/
                            facilityOtherWrrp.MCLR_Rate= Utility.getBlankStringIfNull(String.Valueof(facObj.MCLR_Rate__c));
                            facilityOtherWrrp.Loan_Rate_of_Interest= Utility.getBlankStringIfNull(String.Valueof(facObj.Recommended_Rate__c));
                            facilityOtherWrrp.Validity_Period= (appLst[0].RecordType.DeveloperName== 'SME_Exceeding' || appLst[0].RecordType.DeveloperName== 'SME_AdHoc')? Utility.getBlankStringIfNull(String.valueOf(facObj.Recommended_Days__c)) :'365';
                            facilityOtherWrrp.Preclosure_Charge= constants.Preclosure_Charge;
                            facilityOtherWrrp.Penal_Charges= constants.Penal_Charges;

                            facilityOtherWrrp.BANK_STATEMENT = new List<Customer360view.cls_BANK_STATEMENT>();
                            
                            If(listAppDocCat !=null && !listAppDocCat.isEmpty()){
                                for(genesis__AppDocCatAttachmentJunction__c appDocCatObj  : listAppDocCat){
                                    Customer360view.cls_BANK_STATEMENT bankStatObj = new Customer360view.cls_BANK_STATEMENT();
                                    If(appDocCatObj !=null && appDocCatObj.Entity_Id__c !=null && appDocCatObj.Transaction_Id__c != null){
                                        
                                        If(facObj.Unique_Number_for_NTB__c !=null && appDocCatObj.Entity_Id__c == facObj.Unique_Number_for_NTB__c){
                                           bankStatObj.CATEGORY_ID    =  Utility.getBlankStringIfNull(appDocCatObj.genesis__Application_Document_Category__c);
                                           bankStatObj.DOC_UUID       =  Utility.getBlankStringIfNull(appDocCatObj.Dms_Uuid__c);
                                           bankStatObj.TRANXN_ID      =  Utility.getBlankStringIfNull(appDocCatObj.Transaction_Id__c);
                                        }
                                        if(perfiosStatusMap.size()>0 && perfiosStatusMap.get(appDocCatObj.Transaction_Id__c)!=null && perfiosStatusMap.containsKey(appDocCatObj.Transaction_Id__c)){
                                            bankStatObj.PERFIOS_STATUS= perfiosStatusMap.get(appDocCatObj.Transaction_Id__c).Perfios_Status__c;
                                        }
                                        facilityOtherWrrp.BANK_STATEMENT.add(bankStatObj);
                                    }//bankStatObj
                                    
                                }
                            }
                            facilityOtherWrrp.SANCTION_LETTER = new Customer360view.cls_SANCTION_LETTER();
                            If(listAppDocCat !=null && !listAppDocCat.isEmpty()){
                                System.debug('List of Application Document'+listAppDocCat);
                                for(genesis__AppDocCatAttachmentJunction__c appDocCatObj  : listAppDocCat){
                                    
                                    If(appDocCatObj !=null && appDocCatObj.Entity_Id__c !=null && appDocCatObj.Transaction_Id__c == null){
                                        
                                        If(facObj.Unique_Number_for_NTB__c !=null && appDocCatObj.Entity_Id__c == facObj.Unique_Number_for_NTB__c){
                                            System.debug('Sanction Letter @@@@@'+appDocCatObj);
                                            facilityOtherWrrp.SANCTION_LETTER.CATEGORY_ID   =  Utility.getBlankStringIfNull(appDocCatObj.genesis__Application_Document_Category__c);
                                            facilityOtherWrrp.SANCTION_LETTER.DOC_UUID      =  Utility.getBlankStringIfNull(appDocCatObj.Dms_Uuid__c);
                                            facilityOtherWrrp.SANCTION_LETTER.FACILITY_ID   =  Utility.getBlankStringIfNull(appDocCatObj.Entity_Id__c);
                                            
                                            System.debug('facilityOtherWrrp.SANCTION_LETTER@@@@'+facilityOtherWrrp.SANCTION_LETTER);
                                        } 
                                    }
                                    
                                }
                            }
                            if(facObj.NTB_Facility_Type__c == Constants.WC_OTHERS){
                                newLoanFacWrrpObj.WC_WITH_OTHER_BANK.FACILITY_OTHER.add(facilityOtherWrrp);
                            }else if(facObj.NTB_Facility_Type__c == 'TL Others'){
                                newLoanFacWrrpObj.TL_WITH_OTHER_BANK.FACILITY_OTHER.add(facilityOtherWrrp);
                            }
                            
                            
                            //Supporting Documents
                           /*If(listAppDocCat !=null && !listAppDocCat.isEmpty()){
                                for(genesis__AppDocCatAttachmentJunction__c appDocCatObj  : listAppDocCat){
                                    If(appDocCatObj !=null && appDocCatObj.Entity_Id__c !=null && appDocCatObj.Transaction_Id__c == null){
                                        If(appDocCatObj.Entity_Id__c == facObj.Application__c) {
                                            Customer360view.cls_SUPPORTING_DOCS_DETAILS suppotingDocWrrp = new Customer360view.cls_SUPPORTING_DOCS_DETAILS();
                                            suppotingDocWrrp.CATEGORY_ID    =  Utility.getBlankStringIfNull(appDocCatObj.genesis__Application_Document_Category__c);
                                            suppotingDocWrrp.DOC_UUID   =  Utility.getBlankStringIfNull(appDocCatObj.Dms_Uuid__c);
                                            suppotingDocWrrp.FACILITY_ID    = facObj.Application__c;
                                            
                                            newLoanFacWrrpObj.WC_WITH_OTHER_BANK.SUPPORTING_DOCS_DETAILS.add(suppotingDocWrrp);    
                                        } 
                                    }
                                    
                                }
                            } */
                        }   
                    }    
                }
                If(listOfCurrentAccount !=null && listOfCurrentAccount.size()>0){
                    for(Current_Account__c  currentObj  :   listOfCurrentAccount){
                        If(currentObj !=null ){ //&& currentObj.RecordType.DeveloperName == 'Term_Loan_other'
                            System.debug('currentObj====> '+currentObj);
                            System.debug('currentObj.RecordType.DeveloperName====> '+currentObj.RecordType.DeveloperName);
                            if(currentObj.RecordType.DeveloperName == 'WC_Other'){//if(!currentObj.Facility_Name__c.contains('Term Loan')){  != 'Term Loan'
                                Customer360view.cls_FACILITY_OTHER  facilityOtherWrrp   = new Customer360view.cls_FACILITY_OTHER();
                            
                                facilityOtherWrrp.FACILITY_NAME         = Utility.getBlankStringIfNull(currentObj.Facility_Name__c);
                                facilityOtherWrrp.SANCTION_LIMIT        = Utility.getBlankStringIfNull(String.valueOf(currentObj.Sanctioned_Amount__c));
                                facilityOtherWrrp.BANK_NAME             = Utility.getBlankStringIfNull(currentObj.Bank_Name__c);
                                facilityOtherWrrp.FACILITY_ID           = Utility.getBlankStringIfNull(currentObj.id);
                                facilityOtherWrrp.BALANCE_OUTSTANDING   = Utility.getBlankStringIfNull(String.valueOf(currentObj.Current_outstanding__c));
                                facilityOtherWrrp.INTEREST_RATE         = Utility.getBlankStringIfNull(String.valueOf(currentObj.Interest_Rate__c));
                                facilityOtherWrrp.MARGIN                = Utility.getBlankStringIfNull(String.valueOf(currentObj.Margin__c));
                                facilityOtherWrrp.TENURE= Utility.getBlankStringIfNull(String.valueOf(currentObj.Tenure__c));
                                facilityOtherWrrp.HOLIDAY_PERIOD= Utility.getBlankStringIfNull(String.valueOf(currentObj.Holiday_Period__c));
                                facilityOtherWrrp.CURRENT_OUTSTANDING= Utility.getBlankStringIfNull(String.valueOf(currentObj.Current_outstanding__c)); 
                                facilityOtherWrrp.NATURE_OF_FACILITY= Utility.getBlankStringIfNull(currentObj.Nature_of_Facility__c);
                                facilityOtherWrrp.ACCOUNT_NUMBER= Utility.getBlankStringIfNull(currentObj.Account_Number__c);
                                facilityOtherWrrp.CURRENT_BALANCE= Utility.getBlankStringIfNull(String.valueOf(currentObj.Current_Balance__c));
                                facilityOtherWrrp.START_DATE= Utility.getBlankStringIfNull(String.valueOf(currentObj.Start_Date__c));
                                facilityOtherWrrp.UNIQUE_NO= Utility.getBlankStringIfNull(String.valueOf(currentObj.Unique_Number__c));
                                facilityOtherWrrp.DISBURSEMENT_DATE= currentObj.Date_of_Disbursement__c!=null ? String.valueOf(currentObj.Date_of_Disbursement__c): '';
                                facilityOtherWrrp.ORIGINAL_TENURE= Utility.getBlankStringIfNull(String.valueOf(currentObj.Original_Tenure__c));

                                newLoanFacWrrpObj.WC_WITH_OTHER_BANK.FACILITY_OTHER.add(facilityOtherWrrp);

                            }else if(currentObj.RecordType.DeveloperName == 'Term_Loan_other'){
                                System.debug('currentObj.RecordType.DeveloperName WC Other====> '+currentObj.RecordType.DeveloperName);
                                Customer360view.cls_FACILITY_OTHER  facilityTLotherWrrp   = new Customer360view.cls_FACILITY_OTHER();
                                facilityTLotherWrrp.FACILITY_NAME         = Utility.getBlankStringIfNull(currentObj.Facility_Name__c);
                                facilityTLotherWrrp.SANCTION_LIMIT        = Utility.getBlankStringIfNull(String.valueOf(currentObj.Sanctioned_Amount__c));
                                facilityTLotherWrrp.BANK_NAME             = Utility.getBlankStringIfNull(currentObj.Bank_Name__c);
                                facilityTLotherWrrp.FACILITY_ID           = Utility.getBlankStringIfNull(currentObj.id);
                                facilityTLotherWrrp.BALANCE_OUTSTANDING   = Utility.getBlankStringIfNull(String.valueOf(currentObj.Current_outstanding__c));
                                facilityTLotherWrrp.INTEREST_RATE         = Utility.getBlankStringIfNull(String.valueOf(currentObj.Interest_Rate__c));
                                facilityTLotherWrrp.MARGIN                = Utility.getBlankStringIfNull(String.valueOf(currentObj.Margin__c));
                                facilityTLotherWrrp.TENURE= Utility.getBlankStringIfNull(String.valueOf(currentObj.Tenure__c));
                                facilityTLotherWrrp.HOLIDAY_PERIOD= Utility.getBlankStringIfNull(String.valueOf(currentObj.Holiday_Period__c));
                                facilityTLotherWrrp.CURRENT_OUTSTANDING= Utility.getBlankStringIfNull(String.valueOf(currentObj.Current_outstanding__c)); 
                                facilityTLotherWrrp.NATURE_OF_FACILITY= Utility.getBlankStringIfNull(currentObj.Nature_of_Facility__c);
                                facilityTLotherWrrp.ACCOUNT_NUMBER= Utility.getBlankStringIfNull(currentObj.Account_Number__c);
                                facilityTLotherWrrp.CURRENT_BALANCE= Utility.getBlankStringIfNull(String.valueOf(currentObj.Current_Balance__c));
                                facilityTLotherWrrp.START_DATE= Utility.getBlankStringIfNull(String.valueOf(currentObj.Start_Date__c));
                                facilityTLotherWrrp.UNIQUE_NO= Utility.getBlankStringIfNull(String.valueOf(currentObj.Unique_Number__c));
                                facilityTLotherWrrp.DISBURSEMENT_DATE= currentObj.Date_of_Disbursement__c!=null ? String.valueOf(currentObj.Date_of_Disbursement__c): '';
                                facilityTLotherWrrp.ORIGINAL_TENURE= Utility.getBlankStringIfNull(String.valueOf(currentObj.Original_Tenure__c));
                                newLoanFacWrrpObj.TL_WITH_OTHER_BANK.FACILITY_OTHER.add(facilityTLotherWrrp);

                            }   
                        }
                        
                    }
                }
                //New Loan Facility
                newLoanFacWrrpObj.NEW_LOAN_FACILTY                      = new Customer360view.cls_NEW_LOAN_FACILTY();
                newLoanFacWrrpObj.NEW_LOAN_FACILTY.NEW_FACILITIES       = new List<Customer360view.cls_NEW_FACILITIES>();
                newLoanFacWrrpObj.NEW_LOAN_FACILTY.SUPPORTING_DOCS_DETAILS = new List<Customer360view.cls_SUPPORTING_DOCS_DETAILS>();
                
                If(listOfFacilityApp !=null && !listOfFacilityApp.isEmpty()){
                    for(Facility__c facObj  :   listOfFacilityApp){
                        If(facObj !=null && (Constants.newLoanTypeOfRequest.contains(facObj.Type_Of_Request__c))){ //facObj.NTB_Facility_Type__c == Constants.NEW_FACILITY){
                            Customer360view.cls_NEW_FACILITIES newFacilitiesWrrpObj =   new Customer360view.cls_NEW_FACILITIES();
                            newFacilitiesWrrpObj.FACILITY_ID                        = Utility.getBlankStringIfNull(facObj.Id);
                            newFacilitiesWrrpObj.UNIQUE_NO                          = Utility.getBlankStringIfNull(facObj.Unique_Number_for_NTB__c);
                            newFacilitiesWrrpObj.REQUESTED_AMOUNT                   = Utility.getBlankStringIfNull(String.valueOf(facObj.New_Limit_Amount__c));
                            newFacilitiesWrrpObj.FUNDED_NON_FUNDED                  = Utility.getBlankStringIfNull(facObj.NTB_Product_Type__c);
                            newFacilitiesWrrpObj.NATURE_OF_ADVANCE                  = Utility.getBlankStringIfNull(facObj.NTB_Facility_Category__c);
                            newFacilitiesWrrpObj.RECOMMENDED_LIMIT                  = Utility.getBlankStringIfNull(String.valueOf(facObj.Recommended_Limit__c));
                            newFacilitiesWrrpObj.FACILITY_TYPE                      = Utility.getBlankStringIfNull(String.valueOf(facObj.CL_Product__r.Facility_Code__c));
                            

                            /*Added for New Doc Flow*/
                            newFacilitiesWrrpObj.FACILITY_NAME = Utility.getBlankStringIfNull(facObj.NTB_Facility_Category__c);
                            newFacilitiesWrrpObj.MARGIN = Utility.getBlankStringIfNull(String.valueOf(facObj.Margin__c));
                            newFacilitiesWrrpObj.MCLR_Rate = Utility.getBlankStringIfNull(String.Valueof(facObj.MCLR_Rate__c));
                            newFacilitiesWrrpObj.Loan_Rate_of_Interest = Utility.getBlankStringIfNull(String.Valueof(facObj.Recommended_Rate__c));
                            newFacilitiesWrrpObj.Validity_Period = (appLst[0].RecordType.DeveloperName== 'SME_Exceeding' || appLst[0].RecordType.DeveloperName== 'SME_AdHoc')? Utility.getBlankStringIfNull(String.valueOf(facObj.Recommended_Days__c)) :'365';
                            newFacilitiesWrrpObj.Preclosure_Charge = constants.Preclosure_Charge;
                            newFacilitiesWrrpObj.Penal_Charges = constants.Penal_Charges;

                            /*added for the Term LOAN Change*/
                            newFacilitiesWrrpObj.TENURE= Utility.getBlankStringIfNull(String.valueOf(facObj.Tenure__c));
                            newFacilitiesWrrpObj.HOLIDAY_PERIOD= Utility.getBlankStringIfNull(String.valueOf(facObj.Holiday_Period__c));

                            newFacilitiesWrrpObj.SEQUENCE_NO= Utility.getBlankStringIfNull(String.valueOf(facObj.Facility_Sequence_Number__c));
                            newFacilitiesWrrpObj.REPAYMENT_TYPE= Utility.getBlankStringIfNull(String.valueOf(facObj.Repayment_Type__c));
                            newFacilitiesWrrpObj.PURPOSE_OF_LOAN= Utility.getBlankStringIfNull(String.valueOf(facObj.Purpose_of_Loan__c));
                            newFacilitiesWrrpObj.NATURE_OF_FACILITY= Utility.getBlankStringIfNull(String.valueOf(facObj.Nature_of_Facility__c));
                            newFacilitiesWrrpObj.APPLICANT_CONTRIBUTION= Utility.getBlankStringIfNull(String.valueOf(facObj.Applicant_Contribution__c));
                            newFacilitiesWrrpObj.ONE_TIME_LC_BG= Utility.getBlankStringIfNull(String.valueOf(facObj.One_Time_LC_BG__c));
                            newFacilitiesWrrpObj.EMI_NMI=Utility.getBlankStringIfNull(String.valueOf(facObj.EMINMI__c));
                            newFacilitiesWrrpObj.PRIMARY_SECURITY_REQUESTED= Utility.getBlankStringIfNull(facObj.Primary_Security_Requested__c);
                            newFacilitiesWrrpObj.COLLATERAL_SECURITY_REQUESTED= Utility.getBlankStringIfNull(facObj.Collateral_Security_Requested__c);
                            system.debug('facObj.Bank_Institution__c====> '+facObj.Bank_Institution__c);
                            newFacilitiesWrrpObj.BANK_INSTITUTION= facObj.Bank_Institution__c!=null ? facObj.Bank_Institution__c: (facObj.Bank_Name__c!=null? facObj.Bank_Name__c:'');
                            newFacilitiesWrrpObj.TYPE_OF_REQUEST= Utility.getBlankStringIfNull(facObj.Type_Of_Request__c);
                            if(facObj.Type_Of_Request__c== 'Takeover'){
                                newFacilitiesWrrpObj.EXISTING_LIMIT= Utility.getBlankStringIfNull(String.valueOf(facObj.Sanction_Limit__c));
                            }else{
                                newFacilitiesWrrpObj.EXISTING_LIMIT= Utility.getBlankStringIfNull(String.valueOf(facObj.Existing_Limit__c));
                            }
                            //newFacilitiesWrrpObj.EXISTING_LIMIT= Utility.getBlankStringIfNull(String.valueOf(facObj.Existing_Limit__c));
                            newFacilitiesWrrpObj.APP_FACILITY_TYPE= Utility.getBlankStringIfNull(facObj.App_Facility_Type__c);
                            newFacilitiesWrrpObj.APPROVED_LIMIT= Utility.getBlankStringIfNull(String.valueOf(facObj.Recommended_Limit__c));
                            newFacilitiesWrrpObj.NEW_LIMIT_AMT= Utility.getBlankStringIfNull(String.valueOf(facObj.New_Limit_Amount__c));


                            newLoanFacWrrpObj.NEW_LOAN_FACILTY.NEW_FACILITIES.add(newFacilitiesWrrpObj);
                            
                            //Supporting Documents
                           /* If(listAppDocCat !=null && !listAppDocCat.isEmpty()){
                                for(genesis__AppDocCatAttachmentJunction__c appDocCatObj  : listAppDocCat){
                                    If(appDocCatObj !=null && appDocCatObj.Entity_Id__c !=null && appDocCatObj.Transaction_Id__c == null){
                                        If(appDocCatObj.Entity_Id__c == facObj.Application__c){
                                            Customer360view.cls_SUPPORTING_DOCS_DETAILS suppotingDocWrrp = new Customer360view.cls_SUPPORTING_DOCS_DETAILS();
                                            suppotingDocWrrp.CATEGORY_ID    =  Utility.getBlankStringIfNull(appDocCatObj.genesis__Application_Document_Category__c);
                                            suppotingDocWrrp.DOC_UUID       =  Utility.getBlankStringIfNull(appDocCatObj.Dms_Uuid__c);
                                            suppotingDocWrrp.FACILITY_ID    =  facObj.Application__c;
                                            
                                            newLoanFacWrrpObj.NEW_LOAN_FACILTY.SUPPORTING_DOCS_DETAILS.add(suppotingDocWrrp);    
                                        } 
                                    }
                                    
                                }
                            } */
                        }
                    }
                }
                //Security Details
                newLoanFacWrrpObj.SECURITY                              = new List<Customer360view.cls_NETWORTH_DETAILS>();
                newLoanFacWrrpObj.SECURITY                              = getSecurityDeatils(appId);
                
                newLoanFacWrrpObj.SUPPORTING_DOCS_CATEGORY              = new Customer360view.cls_SUPPORTING_DOCS_CATEGORY();
                newLoanFacWrrpObj.BANK_STATEMENT_CATEGORY               = new Customer360view.cls_SUPPORTING_DOCS_CATEGORY();
                newLoanFacWrrpObj.SANCTION_LETTER_CATEGORY              = new Customer360view.cls_SUPPORTING_DOCS_CATEGORY();
                
                If(docCatList != null && !docCatList.isEmpty()){
                    for(genesis__Application_Document_Category__c appDocCatObj  : docCatList){
                        
                        If(appDocCatObj !=null){
                            If(appDocCatObj.Parent_Category_Name__c == Constants.SUPPORTING_DOCS_CATEGORY){
                                newLoanFacWrrpObj.SUPPORTING_DOCS_CATEGORY.CATEGORY_ID =   appDocCatObj.id;
                                newLoanFacWrrpObj.SUPPORTING_DOCS_CATEGORY.DOC_LABEL   =   appDocCatObj.Name;
                                
                            }else If(appDocCatObj.Parent_Category_Name__c == Constants.SANCTION_LETTER_CATEGORY){
                                newLoanFacWrrpObj.SANCTION_LETTER_CATEGORY.CATEGORY_ID =   appDocCatObj.Id;
                                newLoanFacWrrpObj.SANCTION_LETTER_CATEGORY.DOC_LABEL   =   appDocCatObj.Name;
                                
                            }else If(appDocCatObj.Parent_Category_Name__c == Constants.BANK_STATEMENT_CATEGORY){
                                newLoanFacWrrpObj.BANK_STATEMENT_CATEGORY.CATEGORY_ID =   appDocCatObj.Id;
                                newLoanFacWrrpObj.BANK_STATEMENT_CATEGORY.DOC_LABEL   =   appDocCatObj.Name;    
                            }
                        }
                        
                    }    
                }
                
            }catch(Exception ex){
                System.debug('Message'+ex.getMessage());
                System.debug('Exception Message'+ex.getStackTraceString());
                return null;
            }
        }
        return newLoanFacWrrpObj;
    }
    //Security Details and TITLE HOLDER
    public static List<Customer360view.cls_NETWORTH_DETAILS> getSecurityDeatils(String appId){
        try {
            
            List<Customer360view.cls_NETWORTH_DETAILS> collateralWithTitleHolder    = new List<Customer360view.cls_NETWORTH_DETAILS>();
            List<clcommon__Collateral__c> allColRecList                             = new List<clcommon__Collateral__c>();
            allColRecList                                                           = SOQL_Util.getCollateralWithTitleHolder(appId);
            map<Id, List<String>> collatMapWithFaciSeq= new map<Id,List<String>>();
            Map<Id,Map<String,String>> linkageMap= new Map<Id,Map<String,String>>();
            List<genesis__Application_Collateral__c> appCollatList= [Select id,genesis__Collateral__c,Security_Type__c,Application__c,Facility__c,Facility__r.Facility_Sequence_Number__c from genesis__Application_Collateral__c where Application__c=: appId];
            system.debug('appCollatList===> '+appCollatList);
            system.debug('appCollatList.size===> '+appCollatList.size());  
            if(appCollatList.size()>0){
                for(genesis__Application_Collateral__c appCollat:appCollatList){
                    if(collatMapWithFaciSeq.containskey(appCollat.genesis__Collateral__c)){
                        collatMapWithFaciSeq.get(appCollat.genesis__Collateral__c).add(appCollat.Facility__r.Facility_Sequence_Number__c);
                    }else{
                        collatMapWithFaciSeq.put(appCollat.genesis__Collateral__c,new List<String>{appCollat.Facility__r.Facility_Sequence_Number__c});
                    }
                }
                System.debug('collatMapWithFaciSeq=======> '+collatMapWithFaciSeq);
                for(genesis__Application_Collateral__c appCollat:appCollatList){
                    if(linkageMap.containsKey(appCollat.genesis__Collateral__c)){
                        if(appCollat.Facility__r.Facility_Sequence_Number__c!= null)
                        linkageMap.get(appCollat.genesis__Collateral__c).put(appCollat.Facility__r.Facility_Sequence_Number__c,appCollat.Security_Type__c);
                    }else{
                        if(appCollat.Facility__r.Facility_Sequence_Number__c!= null)
                        linkageMap.put(appCollat.genesis__Collateral__c, new Map<String,String>{appCollat.Facility__r.Facility_Sequence_Number__c=>appCollat.Security_Type__c});
                    }
                }
                System.debug('linkageMap=======> '+linkageMap);
            }
            
            Customer360view.cls_NETWORTH_DETAILS colWrap;
            if(allColRecList!=null && !allColRecList.isEmpty())
                for(clcommon__Collateral__c colRec:allColRecList){
                    
                    colWrap                                                             = new Customer360view.cls_NETWORTH_DETAILS();
                    
                    colWrap.LOS_PROPERTY_ID                                             = Utility.getBlankStringIfNull(String.valueOf(colRec.Id));
                    colWrap.NATURE_OF_PROPERTY                                          = Utility.getBlankStringIfNull(String.valueOf(colRec.Nature_of_Property__c));
                    
                    colWrap.SURVEY_NO                                                   = Utility.getBlankStringIfNull(String.valueOf(colRec.SurveyKhasraKhataPatta_No__c));
                    colWrap.MORTGAGE_DETAILS                                            = Utility.getBlankStringIfNull(String.valueOf(colRec.MORT_TYPE__c));
                    
                    colWrap.PERCENTAGE_OWNERSHIP                                        = Utility.getBlankStringIfNull(String.valueOf(colRec.Percentage_of_Ownership__c));
                    colWrap.ASSET_TYPE                                                  = Utility.getBlankStringIfNull(String.valueOf(colRec.Collateral_Category__c));
                    
                    colWrap.DOOR_NO                                                     = Utility.getBlankStringIfNull(String.valueOf(colRec.Door__c));
                    colWrap.NEAREST_LANDMARK                                            = Utility.getBlankStringIfNull(String.valueOf(colRec.Landmark__c));
                    
                    colWrap.PROPERTY_AREA                                               = Utility.getBlankStringIfNull(String.valueOf(colRec.Area_Square_Feet__c));
                    colWrap.OWNERSHIP_TYPE                                              = Utility.getBlankStringIfNull(String.valueOf(colRec.Ownership_Type__c));
                    
                    colWrap.PROPERTY_VALUE                                              = Utility.getBlankStringIfNull(String.valueOf(colRec.Total_Asset_Value__c));
                    /*Added for Term New LOAN*/
                        colWrap.NATURE_OF_MACHINERY= colRec.Nature_of_Machinery__c;  
                        colWrap.NATURE_OF_COMMERCIAL_VEHICLE= colRec.Nature_of_Commercial_Vehicle__c; 
                        colWrap.NATURE_OF_CONSTRUCTION_EQUIPMENT= colRec.Nature_of_Construction_Equipment__c; 
                        colWrap.NATURE_OF_PASSENGER_VEHICLE=  colRec.Nature_of_Passenger_Vehicle__c; 
                        colWrap.NATURE_OF_OTHERS= colRec.Nature_of_Others__c; 
                        colWrap.MACHINERY_COST= Utility.getBlankStringIfNull(String.valueOf(colRec.Machinery_Cost__c));  
                        colWrap.INSTALLATION_COST= Utility.getBlankStringIfNull(String.valueOf(colRec.Installation_Cost__c));    
                        colWrap.CHASSIS_COST= Utility.getBlankStringIfNull(String.valueOf(colRec.Chassis_Cost__c));
                        colWrap.CATEGORY_CV=Utility.getBlankStringIfNull(String.valueOf(coLRec.Commercial_Vehicle_Category__c));  
                        colWrap.BODY_BUILDING_COST= Utility.getBlankStringIfNull(String.valueOf(colRec.Body_Building_Cost__c));   
                        colWrap.GST_PAN= colRec.GST_PAN__c;
                        colWrap.DEALER_GST_NUMBER= colRec.Dealer_GST_Number__c;
                        colWrap.DEALER_PAN_NUMBER= colRec.Dealer_PAN_Number__c;
                        colWrap.MAKE= colRec.clcommon__Make__c;
                        colWrap.MODEL= colRec.clcommon__Model__c; 
                        colWrap.VARIANT= colRec.Variant__c; 
                        colWrap.DEALER_NAME= colRec.Dealer_name__c; 
                        colWrap.STATE= colRec.State__c; 
                        colWrap.CITY= colRec.clcommon__City__c; 
                        colWrap.PIN_CODE= colRec.Property_Pincode__c;
                        colWrap.ADDRESS_LINE_1 = colRec.clcommon__Address__c;
                        colWrap.ADDRESS_LINE_2 = colRec.Address_Line_2__c;
                        colWrap.OTHER_COST = colRec.Other_Cost__c!=null ? String.valueOf(colRec.Other_Cost__c) : '';
                        
                        colWrap.EXSHOWROOMPRICE_APG= Utility.getBlankStringIfNull(String.valueOf(colRec.ExshowRoomPrice_Api__c));
                        colWrap.EXSHOWROOMPRICE= Utility.getBlankStringIfNull(String.valueOf(colRec.ExShow_Room_Price__c));
                        colWrap.REGISTRATION_COST= Utility.getBlankStringIfNull(String.valueOf(colRec.Registration_cost__c)); 
                        colWrap.INSURANCE_AMOUNT= Utility.getBlankStringIfNull(String.valueOf(colRec.clcommon__Insurance_Amount__c)); 
                        colWrap.ADVANCES_PAID= Utility.getBlankStringIfNull(String.valueOf(colRec.Advances_Paid__c));
                        colWrap.COMMERCIAL_VEHICLE_APG= Utility.getBlankStringIfNull(String.valueOf(colRec.Commercial_Vehicle_Apg__c));
                        colWrap.COST_DEVIATION= Utility.getBlankStringIfNull(String.valueOf(colRec.Cost_Deviation__c));
                        colWrap.ACCESSORY_COST= Utility.getBlankStringIfNull(String.valueOf(colRec.Accessories_value__c)); 


                        colWrap.TAX= Utility.getBlankStringIfNull(String.valueOf(colRec.Tax__c));
                        colWrap.VARIANT_ID= Utility.getBlankStringIfNull(colRec.Variant_Id__c); 
                        colWrap.CITY_ID= Utility.getBlankStringIfNull(colRec.City_Id__c);  
                        colWrap.MAKE_ID= Utility.getBlankStringIfNull(colRec.Make_Id__c);
                        colWrap.RECORD_TYPE= Utility.getBlankStringIfNull(colRec.RecordType.Name);
                        colWrap.TL_INVESTMENT_PROPERTY= Utility.getBlankStringIfNull(String.valueOf(colRec.TL_Investment_Property__c)); 
                        colWrap.TYPE_OF_VEHICLE= Utility.getBlankStringIfNull(colRec.Type_of_Vehicle__c); 
                        colWrap.STATE_ID= Utility.getBlankStringIfNull(colRec.State_Id__c); 
                        colWrap.MODEL_ID= Utility.getBlankStringIfNull(colRec.Model_Id__c); 
                        colWrap.NUMBER_OF_EQUIPMENT= Utility.getBlankStringIfNull(String.valueOf(colRec.Number_Of_Equipment__c));
                        colWrap.CURRENTLY_MORTGAGED=  colRec.CURRENTLY_MORTGAGED__c== true ? 'Yes' : 'No';
                        colWrap.IS_TL_COLLATERAL = colRec.Is_TL_Collateral__c== true? 'True': 'False';

                        /*if(collatMapWithFaciSeq.size()>0 && collatMapWithFaciSeq.containskey(colRec.Id))
                        colWrap.FACILITY_SEQ_NO_LIST= collatMapWithFaciSeq.get(colRec.Id);*/

                        if(linkageMap.size()>0 && linkageMap.containskey(colRec.Id))
                            colWrap.FACILITY_LINKAGE_MAP= linkageMap.get(colRec.Id); 
                    colWrap.PROPERTY_TYPE                                               = Utility.getBlankStringIfNull(String.valueOf(''));
                    
                    colWrap.EXISTING_NETWORTH                                           = Utility.getBlankStringIfNull(String.valueOf(''));
                    colWrap.ADDRESS                                                     = new Customer360view.cls_ADDRESS();
                    
                    colWrap.ADDRESS.STREET                                              = Utility.getBlankStringIfNull(colRec.Street_NameNo__c);
                    colWrap.ADDRESS.CITY                                                = Utility.getBlankStringIfNull(colRec.clcommon__City__c);
                    colWrap.ADDRESS.STATE                                               = Utility.getBlankStringIfNull(colRec.State__c);
                    colWrap.ADDRESS.PIN_CODE                                            = Utility.getBlankStringIfNull(colRec.clcommon__Postal_Code__c);
                    colWrap.ADDRESS.COUNTRY                                             = Utility.getBlankStringIfNull(colRec.Country__c);
                    colWrap.ADDRESS.TALUK                                               = Utility.getBlankStringIfNull(colRec.TalukaTehsil__c);
                    
                    if(!colRec.Ownerships__r.isEmpty()){
                        colWrap.TILE_HOLDERS                                            = new List<Customer360view.cls_TITLE_HOLDER>();
                        Customer360view.cls_TITLE_HOLDER titleHolderWrap;
                        for(Ownership__c ownershiPrec :colRec.Ownerships__r){
                            
                            titleHolderWrap                                             = new Customer360view.cls_TITLE_HOLDER();
                            titleHolderWrap.LOS_TITLE_HOLDER_RECORD_ID                  = Utility.getBlankStringIfNull(ownershiPrec.Id);
                            titleHolderWrap.LOS_TITLE_HOLDER_ID                         = Utility.getBlankStringIfNull(ownershiPrec.Account__c);
                            titleHolderWrap.LOS_TITLE_HOLDER_NAME                       = Utility.getBlankStringIfNull(ownershiPrec.Account__r.Name);
                            
                            colWrap.TILE_HOLDERS.add(titleHolderWrap);
                        }
                    }else{
                        colWrap.TILE_HOLDERS                                            = new List<Customer360view.cls_TITLE_HOLDER>();
                    }
                    
                    collateralWithTitleHolder.add(colWrap);
                }
            return  collateralWithTitleHolder;
        } catch (Exception e) {
            System.debug('Error  Message-c--> ' + e.getMessage() + '---> ' + e.getCause() + 'Line no---> ' + e.getLineNumber() + 'StackTrace---> ' + e.getStackTraceString());
            return new List<Customer360view.cls_NETWORTH_DETAILS>();
        }  
    }   
    public Static Map<String, Perfios__c> getPerfiosStatus(String appId){
        List<Perfios__c> perfiosLst= [select id,Application__c,Application__r.RecordType_Developer_Name__c,Entity_Id__c,Transaction_Id__c,Perfios_Status__c,RecordTypeId,Error_Message__c,Failure_Reason__c,Bank_Name__c from Perfios__c where Application__c=: appId];
        map<String,Perfios__c> PerfiosMap= new map<String,Perfios__c>();
        for(Perfios__c per: perfiosLst){
            PerfiosMap.put(per.Transaction_Id__c, per);
        }
    return PerfiosMap;    
    }
    public static Boolean getSubmissionForRejectNTBusiness(String appId){
        if(appId !=null && appId !=''){
            try{
                Boolean isFinacialYear = true;
                List<genesis__Applications__c> listOfApp = [Select id,New_to_Business__c,RecordType.DeveloperName,genesis__Account__r.Date_of_Incorporation__c from genesis__Applications__c where Id =:appId];
                If(listOfApp !=null && listOfApp.size() > 0){
                    //List<String> listOfDeveloperName = new List<String>{'Indirect_Liablity_Retail','Indirect_Liablity_Group'};
                    List<Liablities__c> listOfliabilities = new List<Liablities__c>();
                    if(listOfApp[0].New_to_Business__c && listOfApp[0].genesis__Account__r.Date_of_Incorporation__c !=null){
                        listOfliabilities = [Select id,Application__c,Account_Number__c from Liablities__c where Application__c =:listOfApp[0].id]; //AND RecordType.DeveloperName IN : listOfDeveloperName
                        isFinacialYear = Application_AssessmentCtrl.calculateFinancialOneYear(listOfApp[0].genesis__Account__r.Date_of_Incorporation__c);
                        System.debug('isFinacialYear@@@@'+isFinacialYear);
                        System.debug('listOfliabilities@@@@@'+listOfliabilities);
                        if(!isFinacialYear && listOfliabilities.isEmpty()){
                            return true;    
                        }
                    }
                }
            }catch(Exception ex){
                System.debug('Exception Message'+ ex.getMessage() +'Line Number'+ ex.getLineNumber());    
            }
        } 
        return false;
    }
    public static Boolean checkLiabilitiesData(String appId){
        if(appId !=null && appId !=''){
            try{
                List<Liablities__c> listOfliabilities = [Select id,Application__c,Account_Number__c from Liablities__c where Application__c =:appId];
                if(listOfliabilities !=null && !listOfliabilities.isEmpty()){
                    return true;    
                }
            }catch(Exception ex){
                System.debug('Exception Message'+ ex.getMessage() +'Line Number'+ ex.getLineNumber());    
            }
        }
        return false;
    }
}