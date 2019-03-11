/*
* Name     : SMELoan_Helper_Handler
* Company  : ET Marlabs
* Purpose  : This class is used as a handler for SMELoan_Helper_Handler.
* Author   : Raushan
*/
public class SMELoan_Helper_Handler {
    
    public static List<genesis__AppDocCatAttachmentJunction__c> listOfAppDocAttachmentObj   = new List<genesis__AppDocCatAttachmentJunction__c>();
    public static List<genesis__AppDocCatAttachmentJunction__c> listOfAppDocAttachmentObj_Delete    = new List<genesis__AppDocCatAttachmentJunction__c>();
    public static List<Perfios__c>  listOfPerfios           = new List<Perfios__c>();
    public static List<Perfios__c>  listOfPerfios_Delete    = new List<Perfios__c>();
    public static Map<String,Perfios__c> mapOfPerfiosEntity = new Map<String,Perfios__c>();
    public static Map<String,genesis__AppDocCatAttachmentJunction__c> mapOfAppDoc   = new  Map<String,genesis__AppDocCatAttachmentJunction__c>();
    public static String UserId = '' ;
    public static Boolean isCheckListCreate = false ;
    public static String Application_Type   = '';
    public static List<Current_Account__c> listOfCurrentAccount         =   new List<Current_Account__c>();
    public static List<Current_Account__c> listOfUpdateCurrentAccount   =   new List<Current_Account__c>();
    public static List<Current_Account__c> listOfCurrentAccountToDelete   =   new List<Current_Account__c>();
    public static Decimal mclrRate =Underwriting_CTRL_Helper.getMCLRValuesFromMaster();
    public static map<String,Security_Requirement_Master__c> securityMap= SOQL_Util.securityMasterMap();
    //New lOan Faicilty Creation.
    public static void createFacilityForNewLoan(Customer360view.cls_NEW_LOAN_FACILITY_DETAILS   newLoanFacilityWrrpObj, String appId,String accSFId){
        
        Id devRecordTypeId = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
        
        Id devRecordTypeId_Perfios = Schema.SObjectType.Perfios__c.getRecordTypeInfosByName().get('SME New Loan Perfios').getRecordTypeId();
        
        If(newLoanFacilityWrrpObj !=null && appId !=null && appId !='') {
            try {
                genesis__Applications__c    appObject   = [select id,OwnerId,Type__c from genesis__Applications__c where Id =:appId];
                If(appObject !=null && appObject.OwnerId !=null){
                    UserId  = appObject.OwnerId;
                }
                //List<Perfios__c>
                List<Perfios__c>    listOfPerfiosObj    =   [Select id,Application__c,Transaction_Id__c,Perfios_Status__c,Entity_Id__c,RecordType.DeveloperName from Perfios__c where Application__c =:appId AND  RecordType.DeveloperName = 'SME_New_Loan_Perfios'AND Perfios_Status__c != 'Completed'];
                If(listOfPerfiosObj !=null && listOfPerfiosObj.size() > 0){
                    for(Perfios__c perfiosObj   : listOfPerfiosObj){
                        If(perfiosObj !=null && perfiosObj.Entity_Id__c !=null){
                            mapOfPerfiosEntity.put(perfiosObj.Transaction_Id__c,perfiosObj);
                        }
                    }
                }
                /* List<genesis__AppDocCatAttachmentJunction__c> listAppDocCat = [select id,genesis__Application_Document_Category__c,genesis__Application_Document_Category__r.genesis__Application__c,Dms_Uuid__c,Entity_Id__c,Transaction_Id__c from genesis__AppDocCatAttachmentJunction__c where genesis__Application_Document_Category__r.genesis__Application__c =:appId AND Transaction_Id__c !=null]; 
                    If(listAppDocCat !=null && !listAppDocCat.isEmpty()){ //mapOfAppDoc
                        for(genesis__AppDocCatAttachmentJunction__c appDocCatObj    :   listAppDocCat){
                            if(appDocCatObj !=null && appDocCatObj.Entity_Id__c !=null){
                                mapOfAppDoc.put(appDocCatObj.Entity_Id__c, appDocCatObj);    
                            }
                        }       
                    } */
                //WC_WITH_KVB
                /* If(newLoanFacilityWrrpObj.WC_WITH_KVB !=null && newLoanFacilityWrrpObj.WC_WITH_KVB.size() > 0){
                        List<Customer360view.cls_WC_WITH_KVB>   listOfWCFacilityWithKvb = newLoanFacilityWrrpObj.WC_WITH_KVB;
                            If(listOfWCFacilityWithKvb !=null && listOfWCFacilityWithKvb.size() > 0){
                                createWCWithFacility(listOfWCFacilityWithKvb,appId,devRecordTypeId);        
                            }
                        } */
                //APP_WC_WITH_KVB
                If(newLoanFacilityWrrpObj.APP_WC_WITH_KVB !=null && newLoanFacilityWrrpObj.APP_WC_WITH_KVB.size() > 0){
                    List<Customer360view.cls_APP_WC_WITH_KVB>   listOfWCAppFacilityWithKvb = newLoanFacilityWrrpObj.APP_WC_WITH_KVB;
                    If(listOfWCAppFacilityWithKvb !=null && listOfWCAppFacilityWithKvb.size() > 0){
                        updateWCWithFacility(listOfWCAppFacilityWithKvb, appId,devRecordTypeId);        
                    }
                }
                //TL_WITH_OTHER_BANK
                /*if(newLoanFacilityWrrpObj.TL_WITH_OTHER_BANK !=null){
                    createORUpdateOtherTLfacilities(newLoanFacilityWrrpObj.TL_WITH_OTHER_BANK, accSFId);
                }*/
                //WC_WITH_OTHER_BANK
                //System.debug('createORUpdateOtherFacilities===== 66'); 
                If(newLoanFacilityWrrpObj.WC_WITH_OTHER_BANK !=null){
                    Customer360view.cls_WC_WITH_OTHER_BANK  WCWithOtherBank = newLoanFacilityWrrpObj.WC_WITH_OTHER_BANK;
                    If(WCWithOtherBank !=null){
                        Id wcCurrAccRecordTypeId = Schema.SObjectType.Current_Account__c.getRecordTypeInfosByName().get('WC Other').getRecordTypeId();
                        createORUpdateOtherFacilities(WCWithOtherBank, appObject, wcCurrAccRecordTypeId, devRecordTypeId_Perfios, accSFId,'WC Others');   
                        //System.debug('createORUpdateOtherFacilities===== 70');    
                    }
                }else{
                    if(appObject.Type__c != Constants.ETB_CA_TAKEOVER || appObject.Type__c != Constants.NTB_TAKEOVER || appObject.Type__c != Constants.ETB_CA_NEW_TO_CREDIT || appObject.Type__c != Constants.NTB_NEW_TO_CREDIT){
                        if(appObject.Type__c == Constants.WC_CA){
                            Application_Type = Constants.ETB_CA_NEW_TO_CREDIT; 
                        }else if(appObject.Type__c == Constants.NTB){
                            Application_Type = Constants.NTB_NEW_TO_CREDIT;
                        }    
                    } 
                }
                // New TL facility TL_WITH_OTHER_BANK
                if(newLoanFacilityWrrpObj.TL_WITH_OTHER_BANK != null){
                    Customer360view.cls_WC_WITH_OTHER_BANK  TLWithOtherBank = newLoanFacilityWrrpObj.TL_WITH_OTHER_BANK;
                    If(TLWithOtherBank !=null){
                        Id tlCurrAccRecordTypeId = Schema.SObjectType.Current_Account__c.getRecordTypeInfosByName().get('Term Loan other').getRecordTypeId();
                        createORUpdateOtherFacilities(TLWithOtherBank, appObject, tlCurrAccRecordTypeId, devRecordTypeId_Perfios, accSFId,'TL Others');       
                    }

                }
                //NEW_LOAN_FACILTY
                If(newLoanFacilityWrrpObj.NEW_LOAN_FACILTY !=null){
                    Customer360view.cls_NEW_LOAN_FACILTY    newLoanFacilityObj = newLoanFacilityWrrpObj.NEW_LOAN_FACILTY;
                    If(newLoanFacilityObj !=null){
                        createNewLoanFacility(newLoanFacilityObj,appId,devRecordTypeId);        
                    }
                }
                //CURRENT_ACCOUNT_WITH_OTHER_BANKS
                If(newLoanFacilityWrrpObj.CURRENT_ACCOUNT_WITH_OTHER_BANKS !=null && newLoanFacilityWrrpObj.CURRENT_ACCOUNT_WITH_OTHER_BANKS.size() > 0){
                    List<Customer360view.cls_CURRENT_ACCOUNT_WITH_OTHER_BANKS>  listOfCurrentAccountWithOther = newLoanFacilityWrrpObj.CURRENT_ACCOUNT_WITH_OTHER_BANKS;
                    If(listOfCurrentAccountWithOther !=null && listOfCurrentAccountWithOther.size() > 0){
                        createCurrentAccountWithBank(listOfCurrentAccountWithOther,accSFId,appId,devRecordTypeId_Perfios);
                    }
                }
                //Security
                If(newLoanFacilityWrrpObj.SECURITY !=null && newLoanFacilityWrrpObj.SECURITY.size() > 0){
                    List<Customer360view.cls_NETWORTH_DETAILS>  listOfSecurityWrrp = newLoanFacilityWrrpObj.SECURITY;
                    If(listOfSecurityWrrp !=null && listOfSecurityWrrp.size() > 0){
                        map<String, Facility__c> FaiciltyWithSequenceMap= new map<String, Facility__c>();
                        List<Facility__c>   listOfFacilityForCollateral = [select id,Application__c,External_Id__c,Facility_Sequence_Number__c from Facility__c where Application__c =:appId];
                        for(Facility__c faci: listOfFacilityForCollateral){
                            FaiciltyWithSequenceMap.put(faci.Facility_Sequence_Number__c, faci);
                        }
                       getNEWCollateralDetails(listOfSecurityWrrp, appId, FaiciltyWithSequenceMap);
                        //getCollateralDetails(listOfSecurityWrrp, appId,listOfFacilityForCollateral);
                    }
                }
                //Update current Account
                If(listOfUpdateCurrentAccount.size() > 0){
                    update listOfUpdateCurrentAccount;
                }
                
                //Insert current Account
                If(listOfCurrentAccount.size() > 0){
                    insert listOfCurrentAccount;
                }
                if(listOfCurrentAccountToDelete.size()>0){
                    delete listOfCurrentAccountToDelete;
                }
                
            }catch(Exception ex){
                System.debug('Exception'+ex.getStackTraceString());
                System.debug('Exception Message'+ ex.getMessage());
            }
            try{
                //List of Perfios Existing record delete.
                If(listOfPerfios_Delete.size() > 0){
                    delete listOfPerfios_Delete;
                }
                //List of Perfios.
                If(listOfPerfios.size() > 0){
                    upsert listOfPerfios Transaction_Id__c;
                }
            }catch(Exception ex){
                System.debug('Exception'+ ex.getMessage() + 'Line Number'+ex.getStackTraceString());
            }
            try{
                //List of AppDOCAttachment Delete.
                /*If(listOfAppDocAttachmentObj_Delete.size() > 0){
                    // delete listOfAppDocAttachmentObj_Delete;
                  } */
                //List of AppDocAttachment
                If(listOfAppDocAttachmentObj.size() > 0 && !listOfAppDocAttachmentObj.isEmpty()){
                    //System.debug('List of App Doc Attachment'+ listOfAppDocAttachmentObj);
                    upsert listOfAppDocAttachmentObj Dms_Uuid__c;
                }
            }catch(Exception ex){
                System.debug('Exception'+ex.getStackTraceString() + 'Mesaage ::'+ ex.getMessage());  
            }
        }     
    }
    public static void createCurrentAccountWithBank(List<Customer360view.cls_CURRENT_ACCOUNT_WITH_OTHER_BANKS> listOfCurrentAccWithOther, String accountSFId, String appId, Id devRecordTypeId_Perfios){
        
        List<Current_Account__c> listOfDeleteCurrentAccount =   new List<Current_Account__c>();
        Id devRecordTypeId = Schema.SObjectType.Current_Account__c.getRecordTypeInfosByName().get('Current Account').getRecordTypeId();
        
        If(listOfCurrentAccWithOther !=null && listOfCurrentAccWithOther.size() > 0 && accountSFId !=null && accountSFId !=''){
            for(Customer360view.cls_CURRENT_ACCOUNT_WITH_OTHER_BANKS    currentAccountWithOtherBankObj : listOfCurrentAccWithOther){
                If(currentAccountWithOtherBankObj !=null){
                    Current_Account__c  currentAccObj       =   new Current_Account__c();
                    If(!Utility.ISStringBlankorNull(currentAccountWithOtherBankObj.BANK_NAME)){
                        currentAccObj.Bank_Name__c  = currentAccountWithOtherBankObj.BANK_NAME; 
                    }
                    If(!Utility.ISStringBlankorNull(currentAccountWithOtherBankObj.ACCOUNT_NUMBER)){
                        currentAccObj.Account_Number__c = currentAccountWithOtherBankObj.ACCOUNT_NUMBER;
                    }
                    If(!Utility.ISStringBlankorNull(currentAccountWithOtherBankObj.CURRENT_BALANCE)){
                        currentAccObj.Current_Balance__c    = Decimal.valueOf(currentAccountWithOtherBankObj.CURRENT_BALANCE);
                    }
                    If(!Utility.ISStringBlankorNull(currentAccountWithOtherBankObj.START_DATE)){
                        currentAccObj.Start_Date__c = currentAccountWithOtherBankObj.START_DATE;
                    }
                    If(!Utility.ISStringBlankorNull(currentAccountWithOtherBankObj.UNIQUE_NO)){
                        currentAccObj.Unique_Number__c  = currentAccountWithOtherBankObj.UNIQUE_NO;
                    }
                    If(!Utility.ISStringBlankorNull(currentAccountWithOtherBankObj.CURRENT_LOS_ID)){
                        currentAccObj.Id    = currentAccountWithOtherBankObj.CURRENT_LOS_ID;
                        if(currentAccountWithOtherBankObj.IS_DELETED !=null && (currentAccountWithOtherBankObj.IS_DELETED == 'Yes' || currentAccountWithOtherBankObj.IS_DELETED == 'True' || currentAccountWithOtherBankObj.IS_DELETED =='1')){
                            listOfDeleteCurrentAccount.add(currentAccObj);
                        }else{
                            listOfUpdateCurrentAccount.add(currentAccObj);    
                        }
                    }else{
                        currentAccObj.Account__c    =   (Id)accountSFId;
                        currentAccObj.RecordTypeId  = devRecordTypeId;
                        listOfCurrentAccount.add(currentAccObj);
                    }
                    //listOfUpdateCurrentAccount
                   If(currentAccountWithOtherBankObj.BANK_STATEMENT !=null && !currentAccountWithOtherBankObj.BANK_STATEMENT.isEmpty()){
                        List<Customer360view.cls_BANK_STATEMENT>  listBankStatementWrpp   =   currentAccountWithOtherBankObj.BANK_STATEMENT;
                        If(listBankStatementWrpp !=null && !listBankStatementWrpp.isEmpty()){
                            for(Customer360view.cls_BANK_STATEMENT	bankStatementWrpp	: listBankStatementWrpp){
                                If(bankStatementWrpp !=null){
                                    genesis__AppDocCatAttachmentJunction__c appDOcAttObj    =   new genesis__AppDocCatAttachmentJunction__c();
                                    Perfios__c  perfiosObj      =   new Perfios__c();
                                    If(!Utility.ISStringBlankorNull(bankStatementWrpp.TRANXN_ID)){
                                        perfiosObj.Transaction_Id__c    = bankStatementWrpp.TRANXN_ID;
                                        perfiosObj.Application__c       = (Id)appId;
                                        If(mapOfPerfiosEntity !=null && ! mapOfPerfiosEntity.isEmpty()){
                                            If(mapOfPerfiosEntity.containsKey(bankStatementWrpp.TRANXN_ID)){
                                                listOfPerfios_Delete.add(mapOfPerfiosEntity.get(bankStatementWrpp.TRANXN_ID));   
                                            }    
                                        }
                                        If(!Utility.ISStringBlankorNull(currentAccountWithOtherBankObj.UNIQUE_NO)){
                                            perfiosObj.Entity_Id__c     = currentAccountWithOtherBankObj.UNIQUE_NO;
                                        }
                                        perfiosObj.RecordTypeId         = devRecordTypeId_Perfios;
                                        perfiosObj.Perfios_Status__c    = 'Initiated';
                                        perfiosObj.OwnerId              =  (Id)UserId;
                                        listOfPerfios.add(perfiosObj);
                                        
                                        appDOcAttObj.Transaction_Id__c  =   bankStatementWrpp.TRANXN_ID;    
                                    }
                                    If(!Utility.ISStringBlankorNull(bankStatementWrpp.DOC_UUID)){
                                        appDOcAttObj.Dms_Uuid__c        =   bankStatementWrpp.DOC_UUID;
                                        If(!Utility.ISStringBlankorNull(bankStatementWrpp.CATEGORY_ID))
                                            appDOcAttObj.genesis__Application_Document_Category__c  =   (Id)bankStatementWrpp.CATEGORY_ID;
                                        If(!Utility.ISStringBlankorNull(currentAccountWithOtherBankObj.UNIQUE_NO)){
                                            appDOcAttObj.Entity_Id__c   =   currentAccountWithOtherBankObj.UNIQUE_NO;
                                            /*If(mapOfAppDoc !=null && mapOfAppDoc.size() > 0){
												If(mapOfAppDoc.containsKey(currentAccountWithOtherBankObj.UNIQUE_NO)){
													listOfAppDocAttachmentObj_Delete.add(mapOfAppDoc.get(currentAccountWithOtherBankObj.UNIQUE_NO));    
												}
											}*/
                                        }
                                        listOfAppDocAttachmentObj.add(appDOcAttObj);
                                    }
                                }    
                            }
                        }
                    }
                }
                
            }
            If(listOfDeleteCurrentAccount.size() > 0){
                delete listOfDeleteCurrentAccount;                    
            } 
        }    
    }
    //New Loan Facility Creation.
    
    public static void createNewLoanFacility(Customer360view.cls_NEW_LOAN_FACILTY NewfacilityWrrpObj, String appId,Id devRecordTypeId){
        
        List<Facility__c>   listOffacility              = new List<Facility__c>();
        List<Facility__c>   listOfFacilityUpdate        = new List<Facility__c>();
        List<Facility__c>   listOfFacilityDelete        = new List<Facility__c>();
        
        If(NewfacilityWrrpObj !=null && appId != null && appId !=''){
            
            try{
                If(NewfacilityWrrpObj.NEW_FACILITIES !=null){
                    List<Customer360view.cls_NEW_FACILITIES> listOfNewFacilities    = NewfacilityWrrpObj.NEW_FACILITIES;
                    If(listOfNewFacilities !=null){
                        for(Customer360view.cls_NEW_FACILITIES  newFacilitiesWrrp   :   listOfNewFacilities){
                            If(newFacilitiesWrrp !=null){
                                Facility__c    facObj        = new Facility__c();
                                If(!Utility.ISStringBlankorNull(newFacilitiesWrrp.REQUESTED_AMOUNT))
                                    facObj.New_Limit_Amount__c  = Decimal.valueOf(newFacilitiesWrrp.REQUESTED_AMOUNT);
                                If(!Utility.ISStringBlankorNull(newFacilitiesWrrp.FUNDED_NON_FUNDED))
                                    facObj.NTB_Product_Type__c  = newFacilitiesWrrp.FUNDED_NON_FUNDED;
                                If(!Utility.ISStringBlankorNull(newFacilitiesWrrp.UNIQUE_NO))
                                    facObj.Unique_Number_for_NTB__c = newFacilitiesWrrp.UNIQUE_NO;
                                If(!Utility.ISStringBlankorNull(newFacilitiesWrrp.NATURE_OF_ADVANCE))
                                    facObj.NTB_Facility_Category__c = newFacilitiesWrrp.NATURE_OF_ADVANCE;
                                If(!Utility.ISStringBlankorNull(newFacilitiesWrrp.APP_FACILITY_TYPE))
                                    facObj.App_Facility_Type__c = newFacilitiesWrrp.APP_FACILITY_TYPE;
                                
                                
                                /* Added for Term LOAN Changes*/
                                if(!Utility.ISStringBlankorNull(newFacilitiesWrrp.SEQUENCE_NO)){
                                    facObj.Facility_Sequence_Number__c= newFacilitiesWrrp.SEQUENCE_NO;
                                }

                                if(!Utility.ISStringBlankorNull(newFacilitiesWrrp.REPAYMENT_TYPE)){
                                   facObj.Repayment_Type__c= newFacilitiesWrrp.REPAYMENT_TYPE;
                                }
                                if(!Utility.ISStringBlankorNull(newFacilitiesWrrp.PURPOSE_OF_LOAN)){
                                    facObj.Purpose_of_Loan__c= newFacilitiesWrrp.PURPOSE_OF_LOAN;
                                }
                                if(!Utility.ISStringBlankorNull(newFacilitiesWrrp.TENURE)){
                                    facObj.Tenure__c= Decimal.valueOf(newFacilitiesWrrp.TENURE);
                                }
                                if(!Utility.ISStringBlankorNull(newFacilitiesWrrp.EMI_NMI)){
                                    facObj.EMINMI__c= Decimal.valueOf(newFacilitiesWrrp.EMI_NMI);
                                }
                                if(!Utility.ISStringBlankorNull(newFacilitiesWrrp.HOLIDAY_PERIOD)){
                                    facObj.Holiday_Period__c= Decimal.valueOf(newFacilitiesWrrp.HOLIDAY_PERIOD);
                                }
                                if(!Utility.ISStringBlankorNull(newFacilitiesWrrp.NATURE_OF_FACILITY)){
                                    facObj.Nature_of_Facility__c= newFacilitiesWrrp.NATURE_OF_FACILITY;
                                }
                                if(!Utility.ISStringBlankorNull(newFacilitiesWrrp.APPLICANT_CONTRIBUTION)){
                                    facObj.Applicant_Contribution__c= Decimal.valueOf(newFacilitiesWrrp.APPLICANT_CONTRIBUTION);
                                }
                                if(!Utility.ISStringBlankorNull(newFacilitiesWrrp.ONE_TIME_LC_BG)){
                                    facObj.One_Time_LC_BG__c= newFacilitiesWrrp.ONE_TIME_LC_BG;
                                }
                                if(!Utility.ISStringBlankorNull(newFacilitiesWrrp.FACILITY_NAME)){
                                    facObj.NTB_Facility_Category__c= newFacilitiesWrrp.FACILITY_NAME;
                                }

                                if(newFacilitiesWrrp.FACILITY_NAME!=null && securityMap.containskey(newFacilitiesWrrp.FACILITY_NAME)){
                                    facObj.Primary_Security_Requested__c = securityMap.get(newFacilitiesWrrp.FACILITY_NAME).Primary_Security_Requested__c;
                                    facObj.Collateral_Security_Requested__c = securityMap.get(newFacilitiesWrrp.FACILITY_NAME).Collateral_Security_Requested__c;
                                    System.debug('securityMap.get(newFacilitiesWrrp.FACILITY_NAME).Primary_Security_Requested__c====> '+securityMap.get(newFacilitiesWrrp.FACILITY_NAME).Primary_Security_Requested__c);
                                    System.debug('securityMap.get(newFacilitiesWrrp.FACILITY_NAME).Collateral_Security_Requested__c====> '+securityMap.get(newFacilitiesWrrp.FACILITY_NAME).Collateral_Security_Requested__c);
                                }
                                
                                System.debug('newFacilitiesWrrp.BANK_INSTITUTION===> '+newFacilitiesWrrp.BANK_INSTITUTION);
                                If(!Utility.ISStringBlankorNull(newFacilitiesWrrp.BANK_INSTITUTION))
                                    facObj.Bank_Institution__c = newFacilitiesWrrp.BANK_INSTITUTION;
                                If(!Utility.ISStringBlankorNull(newFacilitiesWrrp.TYPE_OF_REQUEST))
                                    facObj.Type_Of_Request__c = newFacilitiesWrrp.TYPE_OF_REQUEST;
                                If(!Utility.ISStringBlankorNull(newFacilitiesWrrp.EXISTING_LIMIT))
                                    facObj.Existing_Limit__c = Decimal.valueOf(newFacilitiesWrrp.EXISTING_LIMIT);   


                                If(!Utility.ISStringBlankorNull(newFacilitiesWrrp.FACILITY_ID)){
                                    facObj.Id   = (Id) newFacilitiesWrrp.FACILITY_ID;
                                    If(newFacilitiesWrrp.IS_DELETED !=null && (newFacilitiesWrrp.IS_DELETED =='YES' || newFacilitiesWrrp.IS_DELETED =='1' || newFacilitiesWrrp.IS_DELETED == 'True')){
                                        listOfFacilityDelete.add(facObj);    
                                    }else {
                                        listOfFacilityUpdate.add(facObj);
                                    }         
                                }else {
                                    facObj.Application__c           = (id)appId;
                                    facObj.RecordTypeId             = devRecordTypeId;
                                    facObj.NTB_Facility_Type__c     = 'New';
                                    facObj.OwnerId                  =  (Id)UserId;
                                    if(mclrRate != null){
                                        facObj.MCLR_Rate__c = mclrRate;
                                    }
                                    
                                    /*facObj.Existing_Rate__c       = 12;
                                        facObj.Existing_Processing_Charge__c = 0.4;
                                        facObj.MCLR_Rate__c             = 8.5;
                                        facObj.Existing_Spread__c       = 3.5;
                                        facObj.Existing_Margin_Receivables__c = 12;
                                        facObj.Existing_Margin_Stock_Manufacturing__c = 14;
                                        facObj.Existing_Margin_Stock_Trading__c = 15;
                                    */
                                    if(newFacilitiesWrrp.TYPE_OF_REQUEST=='Fresh Loan'){
                                        facObj.Type_Of_Request__c= newFacilitiesWrrp.TYPE_OF_REQUEST;
                                        listOffacility.add(facObj);
                                    }
                                        
                                }
                            }
                        }
                    }
                }
                If(listOfFacilityDelete.size() > 0){
                    delete listOfFacilityDelete;
                }
                If(listOfFacilityUpdate.size() > 0){
                    update listOfFacilityUpdate; 
                }
                If(listOffacility.Size() > 0){
                    //System.debug('listOffacility====> '+listOffacility);
                    //System.debug('listOffacility Size====> '+listOffacility.size());
                    insert listOffacility;
                }
                If(NewfacilityWrrpObj.SUPPORTING_DOCS_DETAILS !=null){
                    List<Customer360view.cls_SUPPORTING_DOCS_DETAILS> listOfSuportingDoc =  NewfacilityWrrpObj.SUPPORTING_DOCS_DETAILS;
                    If(listOfSuportingDoc !=null && !listOfSuportingDoc.isEmpty()){
                        for(Customer360view.cls_SUPPORTING_DOCS_DETAILS supportingDocWrppObj    : listOfSuportingDoc){
                            If(supportingDocWrppObj !=null){
                                genesis__AppDocCatAttachmentJunction__c appDocObj   =   new genesis__AppDocCatAttachmentJunction__c();
                                If(!Utility.ISStringBlankorNull(supportingDocWrppObj.CATEGORY_ID))
                                    appDocObj.genesis__Application_Document_Category__c = (Id)supportingDocWrppObj.CATEGORY_ID;
                                If(!Utility.ISStringBlankorNull(supportingDocWrppObj.DOC_UUID)){
                                    appDocObj.Dms_Uuid__c = supportingDocWrppObj.DOC_UUID;
                                    appDocObj.Entity_Id__c = (id)appId;    
                                }
                                listOfAppDocAttachmentObj.add(appDocObj);
                            }
                        }
                    }
                }
                
            }catch(Exception ex){
                System.debug('Exception'+ex.getStackTraceString());
                System.debug('Exception Message'+ex.getMessage());
            }
            
        }
        
    }
    //facility create WC With KVB Type.
    /*public static void createWCWithFacility(List<Customer360view.cls_WC_WITH_KVB> listOfWCFacilityWithKvb,String appId, Id devRecordTypeId){
        
        If(listOfWCFacilityWithKvb !=null && !listOfWCFacilityWithKvb.isEmpty() && appId !=null && appId !=''){
            List<Facility__c>   listOfFacilityInsert        =   new List<Facility__c>();
            
            try{
                for(Customer360view.cls_WC_WITH_KVB wcFacilityWithKvbObj : listOfWCFacilityWithKvb){
                    If(wcFacilityWithKvbObj !=null){
                        Facility__c  facObj     =   new Facility__c();
                        If(!Utility.ISStringBlankorNull(wcFacilityWithKvbObj.LOAN_ACCOUNT_NUMBER))
                            facObj.Account_Number__c    = wcFacilityWithKvbObj.LOAN_ACCOUNT_NUMBER;
                        
                        If(!Utility.ISStringBlankorNull(wcFacilityWithKvbObj.MARGIN))
                            facObj.Margin__c            = Decimal.valueOf(wcFacilityWithKvbObj.MARGIN);
                        If(!Utility.ISStringBlankorNull(wcFacilityWithKvbObj.INTEREST_RATE))
                            facObj.Existing_Rate__c     = Decimal.valueOf(wcFacilityWithKvbObj.INTEREST_RATE);
                        If(!Utility.ISStringBlankorNull(wcFacilityWithKvbObj.REASON_FOR_ENHANCEMENT))
                            facObj.Reason_for_Enhancement__c    = wcFacilityWithKvbObj.REASON_FOR_ENHANCEMENT;
                        If(!Utility.ISStringBlankorNull(wcFacilityWithKvbObj.PURPOSE_OF_LOAN))
                            facObj.Loan_Purpose__c  = wcFacilityWithKvbObj.PURPOSE_OF_LOAN;
                        If(!Utility.ISStringBlankorNull(wcFacilityWithKvbObj.CURRENT_LIMIT))
                            facObj.Existing_Limit__c    = Decimal.valueOf(wcFacilityWithKvbObj.CURRENT_LIMIT);
                        If(!Utility.ISStringBlankorNull(wcFacilityWithKvbObj.PROPOSED_LIMIT))
                            facObj.New_Limit_Amount__c  = Decimal.valueOf(wcFacilityWithKvbObj.PROPOSED_LIMIT);
                        
                        If(!Utility.ISStringBlankorNull(wcFacilityWithKvbObj.UNIQUE_NO))
                            facObj.Unique_Number_for_NTB__c     = wcFacilityWithKvbObj.UNIQUE_NO;
                        
                        facObj.Application__c           = (id)appId;    
                        facObj.RecordTypeId             = devRecordTypeId;
                        facObj.NTB_Facility_Type__c     = 'WC KVB';
                        facObj.OwnerId                  =  (Id)UserId;
                        facObj.Is_KVB_Bank__c = true;                                
                        facObj.Existing_Rate__c         = 12;
                        facObj.Existing_Processing_Charge__c = 0.4;
                        facObj.MCLR_Rate__c             = 8.5;
                        facObj.Existing_Spread__c       = 3.5;
                        facObj.Existing_Margin_Receivables__c = 12;
                        facObj.Existing_Margin_Stock_Manufacturing__c = 14;
                        facObj.Existing_Margin_Stock_Trading__c = 15;
                        
                        listOfFacilityInsert.add(facObj);
                    }   
                }
                If(listOfFacilityInsert.size() > 0){
                    insert listOfFacilityInsert;
                    
                }
            }catch(Exception ex){
                System.debug('Exception'+ex.getStackTraceString());
            }    
        }
        
    } */
    
    //Update or Delete WC_With_facility Type.
    public static void updateWCWithFacility(List<Customer360view.cls_APP_WC_WITH_KVB> listOfAppWCWithObj, String appId,Id devRecordTypeId){
        
        List<Facility__c>   listOfFacilityUpdate        =   new List<Facility__c>();
        List<Facility__c>   listOfFacilityDelete        =   new List<Facility__c>();
        
        
        If(listOfAppWCWithObj !=null && !listOfAppWCWithObj.isEmpty()){
            try{
                for(Customer360view.cls_APP_WC_WITH_KVB wcFacilityWithKvbObj : listOfAppWCWithObj){
                    If(wcFacilityWithKvbObj !=null){
                        Facility__c  facObj     =   new Facility__c();
                        If(!Utility.ISStringBlankorNull(wcFacilityWithKvbObj.LOAN_ACCOUNT_NUMBER))
                            facObj.Account_Number__c    = wcFacilityWithKvbObj.LOAN_ACCOUNT_NUMBER;
                        If(!Utility.ISStringBlankorNull(wcFacilityWithKvbObj.MARGIN))
                            facObj.Margin__c            = Decimal.valueOf(wcFacilityWithKvbObj.MARGIN);
                        If(!Utility.ISStringBlankorNull(wcFacilityWithKvbObj.INTEREST_RATE))
                            facObj.Existing_Rate__c     = Decimal.valueOf(wcFacilityWithKvbObj.INTEREST_RATE);
                        If(!Utility.ISStringBlankorNull(wcFacilityWithKvbObj.REASON_FOR_ENHANCEMENT))
                            facObj.Reason_for_Enhancement__c    = wcFacilityWithKvbObj.REASON_FOR_ENHANCEMENT;
                        If(!Utility.ISStringBlankorNull(wcFacilityWithKvbObj.PURPOSE_OF_LOAN))
                            facObj.Loan_Purpose__c  = wcFacilityWithKvbObj.PURPOSE_OF_LOAN;
                        If(!Utility.ISStringBlankorNull(wcFacilityWithKvbObj.CURRENT_LIMIT))
                            facObj.Existing_Limit__c    = Decimal.valueOf(wcFacilityWithKvbObj.CURRENT_LIMIT);
                        If(!Utility.ISStringBlankorNull(wcFacilityWithKvbObj.PROPOSED_LIMIT)){
                            facObj.New_Limit_Amount__c  = Decimal.valueOf(wcFacilityWithKvbObj.PROPOSED_LIMIT);
                        }
                        if(!Utility.ISStringBlankorNull(wcFacilityWithKvbObj.SEQUENCE_NO)){
                            facObj.Facility_Sequence_Number__c= wcFacilityWithKvbObj.SEQUENCE_NO;
                        }
                        If(!Utility.ISStringBlankorNull(wcFacilityWithKvbObj.UNIQUE_NO))
                            facObj.Unique_Number_for_NTB__c = wcFacilityWithKvbObj.UNIQUE_NO;
                        If(!Utility.ISStringBlankorNull(wcFacilityWithKvbObj.PRODUCT_ID))
                            facObj.CL_Product__c        = wcFacilityWithKvbObj.PRODUCT_ID;
                        If(!Utility.ISStringBlankorNull(wcFacilityWithKvbObj.TENURE))
                            facObj.Tenure__c   = Decimal.valueOf(wcFacilityWithKvbObj.TENURE);
                        If(!Utility.ISStringBlankorNull(wcFacilityWithKvbObj.FACILITY_ID)){
                            facObj.Id   = (Id) wcFacilityWithKvbObj.FACILITY_ID;
                        
                            If(wcFacilityWithKvbObj.IS_DELETED !=null && (wcFacilityWithKvbObj.IS_DELETED =='YES' || wcFacilityWithKvbObj.IS_DELETED =='1' || wcFacilityWithKvbObj.IS_DELETED == 'True')){
                                listOfFacilityDelete.add(facObj);    
                            }else {
                                if(wcFacilityWithKvbObj.APPLY_FOR_ENHANCEMENT !=null && (wcFacilityWithKvbObj.APPLY_FOR_ENHANCEMENT =='YES' || wcFacilityWithKvbObj.APPLY_FOR_ENHANCEMENT =='1' || wcFacilityWithKvbObj.APPLY_FOR_ENHANCEMENT == 'True')){
                                    facObj.NTB_Facility_Type__c     = 'WC KVB';
                                    facObj.Type_Of_Request__c= 'Enhancement';
                                }else{
                                    //System.debug('inside renewal');   
                                    facObj.NTB_Facility_Type__c     = 'Renewal';
                                    facObj.New_Limit_Amount__c          = 0.0;
                                }
                                listOfFacilityUpdate.add(facObj);
                                //System.debug('List of Facility Update'+ listOfFacilityUpdate); 
                            }         
                        }    
                        If(wcFacilityWithKvbObj.SUPPORTING_DOCS_DETAILS !=null){
                            List<Customer360view.cls_SUPPORTING_DOCS_DETAILS> listOfSuportingDoc =  wcFacilityWithKvbObj.SUPPORTING_DOCS_DETAILS;
                            If(listOfSuportingDoc !=null && !listOfSuportingDoc.isEmpty()){
                                for(Customer360view.cls_SUPPORTING_DOCS_DETAILS supportingDocWrppObj    : listOfSuportingDoc){
                                    If(supportingDocWrppObj !=null){
                                        genesis__AppDocCatAttachmentJunction__c appDocObj   =   new genesis__AppDocCatAttachmentJunction__c();
                                        If(!Utility.ISStringBlankorNull(supportingDocWrppObj.CATEGORY_ID))
                                            appDocObj.genesis__Application_Document_Category__c = (Id)supportingDocWrppObj.CATEGORY_ID;
                                        If(!Utility.ISStringBlankorNull(supportingDocWrppObj.DOC_UUID))
                                            appDocObj.Dms_Uuid__c = supportingDocWrppObj.DOC_UUID;
                                        appDocObj.Entity_Id__c = facObj.Application__c;
                                        
                                        listOfAppDocAttachmentObj.add(appDocObj);
                                    }
                                }
                            }
                        }
                    }
                }  
                
                If(listOfFacilityDelete.size() > 0){
                    delete listOfFacilityDelete;
                }
                If(listOfFacilityUpdate.size() > 0){
                    
                    update listOfFacilityUpdate; 
                }
            }catch(Exception ex){
                System.debug('Exception'+ex.getStackTraceString()+ex.getMessage()+' AT '+ex.getLineNumber());  
            }
        }    
    }
    //Create OR Update Other TL Facility.
    /*public static void createORUpdateOtherTLfacilities(Customer360view.cls_TL_WITH_OTHER_BANK tlWithOtherBankObj, String accSFId){
        if(tlWithOtherBankObj!= null && tlWithOtherBankObj.TL_FACILITY_OTHER!= null && tlWithOtherBankObj.TL_FACILITY_OTHER.isEmpty()){
             //List<Customer360view.cls_FACILITY_OTHER> listOfTLFacilityOtherWrrp =   tlWithOtherBankObj.TL_FACILITY_OTHER;
             Id devRecordTypeId_Term = Schema.SObjectType.Current_Account__c.getRecordTypeInfosByName().get('Term Loan other').getRecordTypeId();
             for(Customer360view.cls_FACILITY_OTHER tlFacilityOtherWrppObj: tlWithOtherBankObj.TL_FACILITY_OTHER){
                Current_Account__c  currentAccObj       =   new Current_Account__c();
                
                currentAccObj.Facility_Name__c          =   tlFacilityOtherWrppObj.FACILITY_NAME;
                If(!Utility.ISStringBlankorNull(tlFacilityOtherWrppObj.SANCTION_LIMIT))
                    currentAccObj.Sanctioned_Amount__c  = Decimal.valueOf(tlFacilityOtherWrppObj.SANCTION_LIMIT);
                If(!Utility.ISStringBlankorNull(tlFacilityOtherWrppObj.BANK_NAME))
                    currentAccObj.Bank_Name__c  = tlFacilityOtherWrppObj.BANK_NAME;
                If(!Utility.ISStringBlankorNull(tlFacilityOtherWrppObj.BALANCE_OUTSTANDING))
                    currentAccObj.Current_outstanding__c    = Decimal.valueOf(tlFacilityOtherWrppObj.BALANCE_OUTSTANDING);
                If(!Utility.ISStringBlankorNull(tlFacilityOtherWrppObj.INTEREST_RATE))
                    currentAccObj.Interest_Rate__c  = Decimal.valueOf(tlFacilityOtherWrppObj.INTEREST_RATE);
                If(!Utility.ISStringBlankorNull(tlFacilityOtherWrppObj.MARGIN))
                    currentAccObj.Margin__c = Decimal.valueOf(tlFacilityOtherWrppObj.MARGIN);
                 Created for New Term Loan
                If(!Utility.ISStringBlankorNull(tlFacilityOtherWrppObj.TENURE))
                    currentAccObj.Tenure__c = Integer.valueOf(tlFacilityOtherWrppObj.TENURE);
                If(!Utility.ISStringBlankorNull(tlFacilityOtherWrppObj.HOLIDAY_PERIOD))
                    currentAccObj.Holiday_Period__c = Integer.valueOf(tlFacilityOtherWrppObj.HOLIDAY_PERIOD);
                If(!Utility.ISStringBlankorNull(tlFacilityOtherWrppObj.CURRENT_OUTSTANDING))
                    currentAccObj.Current_outstanding__c = Decimal.valueOf(tlFacilityOtherWrppObj.CURRENT_OUTSTANDING);
                If(!Utility.ISStringBlankorNull(tlFacilityOtherWrppObj.NATURE_OF_FACILITY))
                    currentAccObj.Nature_of_Facility__c = tlFacilityOtherWrppObj.NATURE_OF_FACILITY;
                If(!Utility.ISStringBlankorNull(tlFacilityOtherWrppObj.ACCOUNT_NUMBER))
                    currentAccObj.Account_Number__c = tlFacilityOtherWrppObj.ACCOUNT_NUMBER;
                If(!Utility.ISStringBlankorNull(tlFacilityOtherWrppObj.CURRENT_BALANCE))
                    currentAccObj.Current_Balance__c = Decimal.valueOf(tlFacilityOtherWrppObj.CURRENT_BALANCE);

                If(!Utility.ISStringBlankorNull(tlFacilityOtherWrppObj.FACILITY_ID)){
                    currentAccObj.Id    = tlFacilityOtherWrppObj.FACILITY_ID;
                    listOfUpdateCurrentAccount.add(currentAccObj);
                }else{
                    currentAccObj.Account__c    =   (Id)accSFId;
                    currentAccObj.RecordTypeId = devRecordTypeId_Term;                  
                    listOfCurrentAccount.add(currentAccObj);    
                }
             }
        }

    }*/

    //Create OR Update Other Facility.
    public static void createORUpdateOtherFacilities(Customer360view.cls_WC_WITH_OTHER_BANK wcWithOtherBankObj, genesis__Applications__c appObject, Id CurrentAccRecordTypeId, Id devRecordTypeId_Perfios, String accSFId,String facilityType){
        
        List<Facility__c>   listOfFacilityInsert        =   new List<Facility__c>();
        List<Facility__c>   listOfFacilityUpdate        =   new List<Facility__c>();
        List<Facility__c>   listOfFacilityDelete        =   new List<Facility__c>();
        //System.debug('createORUpdateOtherFacilities===== 464');
        // for new to credit flag
        Boolean isNewToCredit       = false;
        Id devRecordTypeId = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
        //Id devRecordTypeId_Term = Schema.SObjectType.Current_Account__c.getRecordTypeInfosByName().get('Term Loan other').getRecordTypeId();
        
        If(wcWithOtherBankObj !=null && appObject !=null){
            try{
                //wcWithOtherBankObj.REASON_FOR_SHIFTING
                If(wcWithOtherBankObj.FACILITY_OTHER !=null && ! wcWithOtherBankObj.FACILITY_OTHER.isEmpty()){
                    List<Customer360view.cls_FACILITY_OTHER> listOfFacilityOtherWrrp =   wcWithOtherBankObj.FACILITY_OTHER;
                    If(listOfFacilityOtherWrrp !=null && ! listOfFacilityOtherWrrp.isEmpty()){
                        for(Customer360view.cls_FACILITY_OTHER facilityOtherWrppObj :   listOfFacilityOtherWrrp) {
                            If(facilityOtherWrppObj !=null){
                                /* sugested by Komal*/
                                if(facilityOtherWrppObj.TAKEOVER == 'False'){//If(facilityOtherWrppObj.FACILITY_NAME != null && facilityOtherWrppObj.FACILITY_NAME.contains('Term Loan') ){ == 'Term Loan'
                                    Current_Account__c  currentAccObj       =   new Current_Account__c();
                                    
                                    currentAccObj.Facility_Name__c          =   facilityOtherWrppObj.FACILITY_NAME;
                                    
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.SANCTION_LIMIT))
                                        currentAccObj.Sanctioned_Amount__c  = Decimal.valueOf(facilityOtherWrppObj.SANCTION_LIMIT);
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.BANK_NAME))
                                        currentAccObj.Bank_Name__c  = facilityOtherWrppObj.BANK_NAME;
                                    //If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.NATURE_OF_FACILITY))
                                    //currentAccObj.Nature_of_Facility__c   = facilityOtherWrppObj.NATURE_OF_FACILITY;
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.BALANCE_OUTSTANDING))
                                        currentAccObj.Current_outstanding__c    = Decimal.valueOf(facilityOtherWrppObj.BALANCE_OUTSTANDING);
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.INTEREST_RATE))
                                        currentAccObj.Interest_Rate__c  = Decimal.valueOf(facilityOtherWrppObj.INTEREST_RATE);
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.MARGIN))
                                        currentAccObj.Margin__c = Decimal.valueOf(facilityOtherWrppObj.MARGIN);

                                    //System.debug('facilityOtherWrppObj.TENURE===> '+facilityOtherWrppObj.TENURE);
                                    /* Created for New Term Loan*/
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.TENURE))
                                        currentAccObj.Tenure__c = Integer.valueOf(facilityOtherWrppObj.TENURE);
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.HOLIDAY_PERIOD))
                                        currentAccObj.Holiday_Period__c = Integer.valueOf(facilityOtherWrppObj.HOLIDAY_PERIOD);
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.CURRENT_OUTSTANDING))
                                        currentAccObj.Current_outstanding__c = Decimal.valueOf(facilityOtherWrppObj.CURRENT_OUTSTANDING);
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.NATURE_OF_FACILITY))
                                        currentAccObj.Nature_of_Facility__c = facilityOtherWrppObj.NATURE_OF_FACILITY;
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.ACCOUNT_NUMBER))
                                        currentAccObj.Account_Number__c = facilityOtherWrppObj.ACCOUNT_NUMBER;
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.CURRENT_BALANCE))
                                        currentAccObj.Current_Balance__c = Decimal.valueOf(facilityOtherWrppObj.CURRENT_BALANCE);


                                    /*If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.TENURE_START_DATE))
                                        currentAccObj.Tenure_Start_Date__c = facilityOtherWrppObj.TENURE_START_DATE;*/
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.REQUESTED_AMOUNT))
                                        currentAccObj.Requested_Amount__c = Decimal.valueOf(facilityOtherWrppObj.REQUESTED_AMOUNT);
                                        if(facilityOtherWrppObj.isScannedStatement != null)
                                            currentAccObj.is_Scanned_Statement__c = facilityOtherWrppObj.isScannedStatement;
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.PASSWORD))
                                        currentAccObj.Password__c = facilityOtherWrppObj.PASSWORD;
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.UNIQUE_NO))
                                        currentAccObj.Unique_Number__c = facilityOtherWrppObj.UNIQUE_NO;
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.START_DATE))
                                        currentAccObj.Start_Date__c = facilityOtherWrppObj.START_DATE;
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.END_DATE))
                                        currentAccObj.End_Date__c = facilityOtherWrppObj.END_DATE;
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.DISBURSEMENT_DATE))
                                        currentAccObj.Date_of_Disbursement__c = Date.valueOf(facilityOtherWrppObj.DISBURSEMENT_DATE);
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.ORIGINAL_TENURE))
                                        currentAccObj.Original_Tenure__c = Integer.valueOf(facilityOtherWrppObj.ORIGINAL_TENURE);


                                    //System.debug('facilityOtherWrppObj.FACILITY_ID===> '+facilityOtherWrppObj.FACILITY_ID);
                                    if(!Utility.ISStringBlankorNull(facilityOtherWrppObj.FACILITY_ID) && Id.valueOf(facilityOtherWrppObj.FACILITY_ID).getsobjecttype()== Schema.Facility__c.getSObjectType()){
                                        Facility__c delFaci= new Facility__c(id= facilityOtherWrppObj.FACILITY_ID);
                                        listOfFacilityDelete.add(delFaci);
                                    }

                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.FACILITY_ID) && Id.valueOf(facilityOtherWrppObj.FACILITY_ID).getsobjecttype()== Schema.Current_Account__c.getSObjectType()){
                                        currentAccObj.Id    = facilityOtherWrppObj.FACILITY_ID;
                                        if(facilityOtherWrppObj.IS_DELETED== 'True'|| facilityOtherWrppObj.IS_DELETED== 'Yes'){
                                            listOfCurrentAccountToDelete.add(currentAccObj);

                                        }else{
                                            listOfUpdateCurrentAccount.add(currentAccObj);
                                        }

                                    }else{
                                        currentAccObj.Account__c    =   (Id)accSFId;
                                        currentAccObj.RecordTypeId = CurrentAccRecordTypeId;//devRecordTypeId_Term;                  
                                        listOfCurrentAccount.add(currentAccObj);    
                                    }

                                   If(facilityOtherWrppObj.BANK_STATEMENT !=null && !facilityOtherWrppObj.BANK_STATEMENT.isEmpty()){
                                        List<Customer360view.cls_BANK_STATEMENT>  listBankStatementWrpp   =    facilityOtherWrppObj.BANK_STATEMENT;
                                        If(listBankStatementWrpp !=null && !listBankStatementWrpp.isEmpty()){
                                            for(Customer360view.cls_BANK_STATEMENT	bankStatementWrpp : listBankStatementWrpp){
                                                If(bankStatementWrpp !=null){
                                                    genesis__AppDocCatAttachmentJunction__c appDOcAttObj    =   new genesis__AppDocCatAttachmentJunction__c();
                                                    Perfios__c  perfiosObj      =   new Perfios__c();
                                                    If(!Utility.ISStringBlankorNull(bankStatementWrpp.TRANXN_ID)){
                                                        perfiosObj.Transaction_Id__c    = bankStatementWrpp.TRANXN_ID;
                                                        perfiosObj.Application__c       = appObject.Id;
                                                        If(mapOfPerfiosEntity !=null && ! mapOfPerfiosEntity.isEmpty()){
                                                            If(mapOfPerfiosEntity.containsKey(bankStatementWrpp.TRANXN_ID)){
                                                                listOfPerfios_Delete.add(mapOfPerfiosEntity.get(bankStatementWrpp.TRANXN_ID));   
                                                            }    
                                                        }
                                                        If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.UNIQUE_NO)){
                                                            // mapOfPerfiosEntity
                                                            perfiosObj.Entity_Id__c         = facilityOtherWrppObj.UNIQUE_NO;
                                                        }
                                                        perfiosObj.RecordTypeId         = devRecordTypeId_Perfios;
                                                        perfiosObj.Perfios_Status__c    = 'Initiated';
                                                        perfiosObj.OwnerId              =  (Id)UserId;
                                                        listOfPerfios.add(perfiosObj);
                                                        
                                                        appDOcAttObj.Transaction_Id__c  =   bankStatementWrpp.TRANXN_ID;    
                                                    }
                                                    If(!Utility.ISStringBlankorNull(bankStatementWrpp.DOC_UUID))
                                                        appDOcAttObj.Dms_Uuid__c        =   bankStatementWrpp.DOC_UUID;
                                                    If(!Utility.ISStringBlankorNull(bankStatementWrpp.CATEGORY_ID))
                                                        appDOcAttObj.genesis__Application_Document_Category__c  =   (Id)bankStatementWrpp.CATEGORY_ID;
                                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.UNIQUE_NO)) {
                                                        appDOcAttObj.Entity_Id__c   =   facilityOtherWrppObj.UNIQUE_NO;
                                                        /*If(mapOfAppDoc !=null && mapOfAppDoc.size() > 0){
                                                         	If(mapOfAppDoc.containsKey(facilityOtherWrppObj.UNIQUE_NO)){
                                                            	listOfAppDocAttachmentObj_Delete.add(mapOfAppDoc.get(facilityOtherWrppObj.UNIQUE_NO));    
                                                            }
                                                        }*/
                                                    }
                                                    If(!Utility.ISStringBlankorNull(bankStatementWrpp.DOC_UUID)){
                                                        listOfAppDocAttachmentObj.add(appDOcAttObj);    
                                                    }
                                                }    
                                            }
                                        }
                                    } 
                                    If(facilityOtherWrppObj.SANCTION_LETTER !=null){
                                        Customer360view.cls_SANCTION_LETTER sanctionLetterObj   =  facilityOtherWrppObj.SANCTION_LETTER;
                                        If(sanctionLetterObj !=null){
                                            genesis__AppDocCatAttachmentJunction__c appDOcAttObj    =   new genesis__AppDocCatAttachmentJunction__c();
                                            
                                            If(!Utility.ISStringBlankorNull(sanctionLetterObj.DOC_UUID))
                                                appDOcAttObj.Dms_Uuid__c        =   sanctionLetterObj.DOC_UUID;
                                            If(!Utility.ISStringBlankorNull(sanctionLetterObj.CATEGORY_ID))
                                                appDOcAttObj.genesis__Application_Document_Category__c  =   (Id)sanctionLetterObj.CATEGORY_ID;
                                            If(!Utility.ISStringBlankorNull(sanctionLetterObj.FACILITY_ID))
                                                appDOcAttObj.Entity_Id__c   =   sanctionLetterObj.FACILITY_ID;
                                            
                                            listOfAppDocAttachmentObj.add(appDOcAttObj);    
                                        } 
                                    }

                                    
                                }else if(facilityOtherWrppObj.TAKEOVER == 'True') {
                                    Facility__c  facObj     =   new Facility__c(); //Bank_Name__c
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.FACILITY_NAME))
                                        facObj.NTB_Facility_Category__c = facilityOtherWrppObj.FACILITY_NAME;
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.MARGIN))
                                        facObj.Margin__c            = Decimal.valueOf(facilityOtherWrppObj.MARGIN);
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.INTEREST_RATE))
                                        facObj.Interest_Rate__c     = Decimal.valueOf(facilityOtherWrppObj.INTEREST_RATE);
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.SANCTION_LIMIT))
                                        facObj.Sanction_Limit__c    = Decimal.valueOf(facilityOtherWrppObj.SANCTION_LIMIT);
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.BALANCE_OUTSTANDING))
                                        facObj.Balance_Outstandings__c  = Decimal.valueOf(facilityOtherWrppObj.BALANCE_OUTSTANDING);
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.REQUESTED_AMOUNT))
                                        facObj.New_Limit_Amount__c  = Decimal.valueOf(facilityOtherWrppObj.REQUESTED_AMOUNT);
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.UNIQUE_NO))
                                        facObj.Unique_Number_for_NTB__c     = facilityOtherWrppObj.UNIQUE_NO;
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.BANK_NAME))
                                        facObj.Bank_Name__c     = facilityOtherWrppObj.BANK_NAME;

                                    //System.debug('facilityOtherWrppObj.TENURE===> '+facilityOtherWrppObj.TENURE);
                                    /* Created for New Term Loan*/
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.TENURE))
                                        facObj.Tenure__c = Integer.valueOf(facilityOtherWrppObj.TENURE);
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.ORIGINAL_TENURE))
                                        facObj.Original_Tenure__c = Integer.valueOf(facilityOtherWrppObj.ORIGINAL_TENURE);
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.HOLIDAY_PERIOD))
                                        facObj.Holiday_Period__c = Integer.valueOf(facilityOtherWrppObj.HOLIDAY_PERIOD);
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.CURRENT_OUTSTANDING))
                                        facObj.Current_outstanding__c = Decimal.valueOf(facilityOtherWrppObj.CURRENT_OUTSTANDING);
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.NATURE_OF_FACILITY))
                                        facObj.Nature_of_Facility__c = facilityOtherWrppObj.NATURE_OF_FACILITY;
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.ACCOUNT_NUMBER))
                                        facObj.Account_Number__c = facilityOtherWrppObj.ACCOUNT_NUMBER;
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.CURRENT_BALANCE))
                                        facObj.Current_Balance__c = Decimal.valueOf(facilityOtherWrppObj.CURRENT_BALANCE);

                                    /* sugested by Komal*/
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.FACILITY_PRODUCT_CATEGORY))
                                        facObj.Facility_Product_category__c = facilityOtherWrppObj.FACILITY_PRODUCT_CATEGORY;
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.APP_FACILITY_TYPE))
                                        facObj.App_Facility_Type__c = facilityOtherWrppObj.APP_FACILITY_TYPE;
                                    if(!Utility.ISStringBlankorNull(facilityOtherWrppObj.PURPOSE_OF_LOAN)){
                                        facObj.Purpose_of_Loan__c= facilityOtherWrppObj.PURPOSE_OF_LOAN; 
                                    }

                                    System.debug('facilityOtherWrppObj.BANK_INSTITUTION====> '+facilityOtherWrppObj.BANK_INSTITUTION);
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.BANK_INSTITUTION))
                                        facObj.Bank_Institution__c = facilityOtherWrppObj.BANK_INSTITUTION;
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.DISBURSEMENT_DATE))
                                        facObj.Date_of_Disbursement__c = Date.valueOf(facilityOtherWrppObj.DISBURSEMENT_DATE);

                                    /*If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.START_DATE))
                                        facObj.Limit_start_date__c = facilityOtherWrppObj.START_DATE;
                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.END_DATE))
                                        facObj.Limit_end_date__c = facilityOtherWrppObj.END_DATE;*/

                                    if(!Utility.ISStringBlankorNull(facilityOtherWrppObj.FACILITY_ID) && Id.valueOf(facilityOtherWrppObj.FACILITY_ID).getsobjecttype()== Schema.Current_Account__c.getSObjectType()){
                                        Current_Account__c delCurrAcc= new Current_Account__c(id= facilityOtherWrppObj.FACILITY_ID);
                                        listOfCurrentAccountToDelete.add(delCurrAcc);
                                    }

                                    if(facilityOtherWrppObj.FACILITY_NAME!=null && securityMap.containskey(facilityOtherWrppObj.FACILITY_NAME)){
                                        facObj.Primary_Security_Requested__c = securityMap.get(facilityOtherWrppObj.FACILITY_NAME).Primary_Security_Requested__c;
                                        facObj.Collateral_Security_Requested__c = securityMap.get(facilityOtherWrppObj.FACILITY_NAME).Collateral_Security_Requested__c;
                                    }
                                    if(facilityOtherWrppObj.SEQUENCE_NO!= null){
                                        facObj.Facility_Sequence_Number__c= facilityOtherWrppObj.SEQUENCE_NO;
                                    }

                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.FACILITY_ID) && Id.valueOf(facilityOtherWrppObj.FACILITY_ID).getsobjecttype()== Schema.Facility__c.getSObjectType()){
                                        facObj.Id   = (Id) facilityOtherWrppObj.FACILITY_ID;
                                        If(facilityOtherWrppObj.IS_DELETED !=null && (facilityOtherWrppObj.IS_DELETED =='YES' || facilityOtherWrppObj.IS_DELETED =='1' || facilityOtherWrppObj.IS_DELETED == 'True')){
                                            listOfFacilityDelete.add(facObj);    
                                        }else {
                                            isCheckListCreate               = true;
                                            listOfFacilityUpdate.add(facObj);
                                        }         
                                    }else{
                                        facObj.Application__c           = appObject.Id; 
                                        facObj.RecordTypeId             = devRecordTypeId;
                                        facObj.NTB_Facility_Type__c     = facilityType;
                                        facObj.Type_Of_Request__c= (facilityType== 'WC Others' || facilityType== 'TL Others'  ? 'Takeover' : null);
                                        facObj.OwnerId                  =  (Id)UserId;
                                        if(mclrRate != null){
                                            facObj.MCLR_Rate__c = mclrRate;
                                        }
                                        If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.TAKEOVER))
                                        facObj.Takeover__c= facilityOtherWrppObj.TAKEOVER== 'True'? true :false;
                                        
                                        /*facObj.Existing_Rate__c       = 12;
                                            facObj.Existing_Processing_Charge__c = 0.4;
                                            facObj.MCLR_Rate__c             = 8.5;
                                            facObj.Existing_Spread__c       = 3.5;
                                            facObj.Existing_Margin_Receivables__c = 12;
                                            facObj.Existing_Margin_Stock_Manufacturing__c = 14;
                                            facObj.Existing_Margin_Stock_Trading__c = 15;
                                        */
                                        
                                        isCheckListCreate               = true;
                                        
                                        If(appObject.Type__c != Constants.ETB_CA_TAKEOVER || appObject.Type__c != Constants.NTB_TAKEOVER ||  appObject.Type__c != Constants.ETB_WC_TAKEOVER){
                                            if(appObject.Type__c == Constants.WC_CA || appObject.Type__c == Constants.ETB_CA_NEW_TO_CREDIT){
                                                Application_Type = Constants.ETB_CA_TAKEOVER; 
                                            }else if(appObject.Type__c == Constants.NTB || appObject.Type__c == Constants.NTB_NEW_TO_CREDIT){
                                                Application_Type = Constants.NTB_TAKEOVER;
                                            }else if(appObject.Type__c == Constants.ETB_WC){
                                                Application_Type = Constants.ETB_WC_TAKEOVER;
                                            }
                                        }
                                        listOfFacilityInsert.add(facObj);
                                    }
                                  If(facilityOtherWrppObj.BANK_STATEMENT !=null && !facilityOtherWrppObj.BANK_STATEMENT.isEmpty()){
                                        List<Customer360view.cls_BANK_STATEMENT>  listBankStatementWrpp   =    facilityOtherWrppObj.BANK_STATEMENT;
                                        If(listBankStatementWrpp !=null && !listBankStatementWrpp.isEmpty()){
                                            for(Customer360view.cls_BANK_STATEMENT	bankStatementWrpp : listBankStatementWrpp){
                                                If(bankStatementWrpp !=null){
                                                    genesis__AppDocCatAttachmentJunction__c appDOcAttObj    =   new genesis__AppDocCatAttachmentJunction__c();
                                                    Perfios__c  perfiosObj      =   new Perfios__c();
                                                    If(!Utility.ISStringBlankorNull(bankStatementWrpp.TRANXN_ID)){
                                                        perfiosObj.Transaction_Id__c    = bankStatementWrpp.TRANXN_ID;
                                                        perfiosObj.Application__c       = appObject.Id;
                                                        If(mapOfPerfiosEntity !=null && ! mapOfPerfiosEntity.isEmpty()){
                                                            If(mapOfPerfiosEntity.containsKey(bankStatementWrpp.TRANXN_ID)){
                                                                listOfPerfios_Delete.add(mapOfPerfiosEntity.get(bankStatementWrpp.TRANXN_ID));   
                                                            }    
                                                        }
                                                        If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.UNIQUE_NO)){
                                                            perfiosObj.Entity_Id__c         = facilityOtherWrppObj.UNIQUE_NO;
                                                        }
                                                        perfiosObj.RecordTypeId         = devRecordTypeId_Perfios;
                                                        perfiosObj.Perfios_Status__c    = 'Initiated';
                                                        perfiosObj.OwnerId              =  (Id)UserId;
                                                        listOfPerfios.add(perfiosObj);
                                                        
                                                        appDOcAttObj.Transaction_Id__c  =   bankStatementWrpp.TRANXN_ID;    
                                                    }
                                                    If(!Utility.ISStringBlankorNull(bankStatementWrpp.DOC_UUID))
                                                        appDOcAttObj.Dms_Uuid__c        =   bankStatementWrpp.DOC_UUID;
                                                    If(!Utility.ISStringBlankorNull(bankStatementWrpp.CATEGORY_ID))
                                                        appDOcAttObj.genesis__Application_Document_Category__c  =   (Id)bankStatementWrpp.CATEGORY_ID;
                                                    If(!Utility.ISStringBlankorNull(facilityOtherWrppObj.UNIQUE_NO)) {
                                                        appDOcAttObj.Entity_Id__c   =   facilityOtherWrppObj.UNIQUE_NO;
                                                        /*If(mapOfAppDoc !=null && mapOfAppDoc.size() > 0){
                                                            If(mapOfAppDoc.containsKey(facilityOtherWrppObj.UNIQUE_NO)){
                                                                listOfAppDocAttachmentObj_Delete.add(mapOfAppDoc.get(facilityOtherWrppObj.UNIQUE_NO));    
                                                            }
                                                        }*/
                                                    }
                                                    If(!Utility.ISStringBlankorNull(bankStatementWrpp.DOC_UUID)){
                                                        listOfAppDocAttachmentObj.add(appDOcAttObj);    
                                                    }
                                                }    
                                            }
                                        }
                                    }
                                    If(facilityOtherWrppObj.SANCTION_LETTER !=null){
                                        Customer360view.cls_SANCTION_LETTER sanctionLetterObj   =  facilityOtherWrppObj.SANCTION_LETTER;
                                        If(sanctionLetterObj !=null){
                                            genesis__AppDocCatAttachmentJunction__c appDOcAttObj    =   new genesis__AppDocCatAttachmentJunction__c();
                                            
                                            If(!Utility.ISStringBlankorNull(sanctionLetterObj.DOC_UUID))
                                                appDOcAttObj.Dms_Uuid__c        =   sanctionLetterObj.DOC_UUID;
                                            If(!Utility.ISStringBlankorNull(sanctionLetterObj.CATEGORY_ID))
                                                appDOcAttObj.genesis__Application_Document_Category__c  =   (Id)sanctionLetterObj.CATEGORY_ID;
                                            If(!Utility.ISStringBlankorNull(sanctionLetterObj.FACILITY_ID))
                                                appDOcAttObj.Entity_Id__c   =   sanctionLetterObj.FACILITY_ID;
                                            
                                            listOfAppDocAttachmentObj.add(appDOcAttObj);    
                                        } 
                                    }
                                }
                            }
                        }     
                    }
                    //CheckList Create
                    If(isCheckListCreate){
                        //System.debug('Inside CheckList'+isCheckListCreate);
                        List<genesis__Checklist__c> existingCheckList       = new List<genesis__Checklist__c>();
                        existingCheckList       =   [select id,genesis__Application__c from genesis__Checklist__c where genesis__Application__c =: appObject.Id];
                        If(existingCheckList.isEmpty()){
                            List<genesis__Checklist__c> listOfCheckList         =   new List<genesis__Checklist__c>();    
                            List<New_Loan_CheckList__mdt> listnewLoanCheckMdt   =   [select id,Name__c from New_Loan_CheckList__mdt];
                            If(listnewLoanCheckMdt !=null && listnewLoanCheckMdt.size() > 0){
                                for(New_Loan_CheckList__mdt newLoanCheckObj :   listnewLoanCheckMdt) {
                                    If(newLoanCheckObj !=null){
                                        if(newLoanCheckObj.name__c =='Confidential opinion from existing bank' && checkifwctltakeoverFacilityexists(appObject.Id,'WC')){
                                            if(createchecklist(newLoanCheckObj,appObject.Id)!=null){
                                                listOfCheckList.add(createchecklist(newLoanCheckObj,appObject.Id));
                                            }
                                            
                                        }
                                        else if(newLoanCheckObj.name__c =='Due Date Certificate' && checkifwctltakeoverFacilityexists(appObject.Id,'TL')){
                                            if(createchecklist(newLoanCheckObj,appObject.Id)!=null){
                                                listOfCheckList.add(createchecklist(newLoanCheckObj,appObject.Id));
                                            }
                                        }
                                        else{
                                            if(createchecklist(newLoanCheckObj,appObject.Id)!=null){
                                                listOfCheckList.add(createchecklist(newLoanCheckObj,appObject.Id));
                                            }
                                        }
                                    }
                                }   
                            }
                            If(listOfCheckList.size() > 0){
                                insert listOfCheckList;
                                createdocumentcategory(listOfCheckList,appObject.Id);   
                            }    
                        }
                    }
                    If(listOfFacilityUpdate.size() > 0){
                        update listOfFacilityUpdate;
                        if(!isNewToCredit){
                            isNewToCredit = true;
                        }
                    }
                    If(listOfFacilityInsert.size() > 0){
                        insert listOfFacilityInsert;
                        if(!isNewToCredit){
                            isNewToCredit = true;
                        }
                    }
                    If(listOfFacilityDelete.size() > 0){
                        delete listOfFacilityDelete;
                        
                        List<Facility__c> listOfFacilityForTakeOver = [select id,NTB_Facility_Type__c from Facility__c where Application__c =: appObject.id AND NTB_Facility_Type__c = 'WC Others'];
                        if(listOfFacilityForTakeOver != null && !listOfFacilityForTakeOver.isEmpty()){
                            if(!isNewToCredit){
                                isNewToCredit = true;
                            } 
                        }else{ 
                            isNewToCredit = false;
                        }
                    }
                }
                if(!isNewToCredit){
                    if(appObject.Type__c != Constants.ETB_CA_TAKEOVER || appObject.Type__c != Constants.NTB_TAKEOVER || appObject.Type__c != Constants.ETB_CA_NEW_TO_CREDIT || appObject.Type__c != Constants.NTB_NEW_TO_CREDIT){
                        if(appObject.Type__c == Constants.WC_CA){
                            Application_Type = Constants.ETB_CA_NEW_TO_CREDIT; 
                        }else if(appObject.Type__c == Constants.NTB){
                            Application_Type = Constants.NTB_NEW_TO_CREDIT;
                        }    
                    }
                }
            }catch(Exception ex){
                System.debug('Exception'+ex.getStackTraceString() + 'Message'+ ex.getMessage());    
            }
        } 
        
    }
    //Security Details.
    public static void getNEWCollateralDetails(List<Customer360view.cls_NETWORTH_DETAILS>  listcollateralWrp, String LOS_APPLICATION_ID,Map<String,Facility__c> seqMapFacility){
        List<genesis__Application_Collateral__c> listAppCollateral      = new List<genesis__Application_Collateral__c>();
        List<clcommon__Collateral__c> listCollateralInsert              = new List<clcommon__Collateral__c>();
        List<clcommon__Collateral__c> listCollateralUpdate              = new List<clcommon__Collateral__c>(); 
        List<clcommon__Collateral__c> listCollateralDelete              = new List<clcommon__Collateral__c>();
        List<Ownership__c> ownerShipListToInsert                        = new List<Ownership__c>();
        List<Ownership__c> ownerShipListToUpdate                        = new List<Ownership__c>(); 

        //List<String> collatSeqNo;
        
        List<String> listDeveloperName                                  = new List<String>{'Land_And_Buildings_Other','Land_And_Building','Commercial_Machinery','Commercial_Vehicle','Passenger_Vehicle','Construction_Equipment','Other'};
            Map<String,id> recordtypeIdMap                              = Utility.getRecordTypeID(listDeveloperName);
        try{
            If(listcollateralWrp !=null){
                for(Customer360view.cls_NETWORTH_DETAILS    collObjWrp: listcollateralWrp) {
                    String externalIdForCollateral=   SOQL_Util.getRandomExternalIdForCollateral();
                    System.debug('getNEWCollateralDetails==> externalIdForCollateral====> '+externalIdForCollateral);
                    clcommon__Collateral__c  collObj=   new clcommon__Collateral__c();
                    
                    collObj.External_ID__c= externalIdForCollateral;

                    If(!Utility.ISStringBlankorNull(collObjWrp.LOS_PROPERTY_ID))
                        collObj.id                                  = collObjWrp.LOS_PROPERTY_ID;
                    If(!Utility.ISStringBlankorNull(collObjWrp.NATURE_OF_PROPERTY))
                        collObj.Nature_of_Property__c               = collObjWrp.NATURE_OF_PROPERTY;
                    If(!Utility.ISStringBlankorNull(collObjWrp.OWNERSHIP_TYPE))
                        collObj.Ownership_Type__c                   = collObjWrp.OWNERSHIP_TYPE;
                    If(!Utility.ISStringBlankorNull(collObjWrp.PERCENTAGE_OWNERSHIP))
                        collObj.Percentage_of_Ownership__c          = Decimal.valueOf(collObjWrp.PERCENTAGE_OWNERSHIP);
                    If(!Utility.ISStringBlankorNull(collObjWrp.PROPERTY_VALUE))
                        collObj.Total_Asset_Value__c                = SMELoan_Helper.currencyFormatter(collObjWrp.PROPERTY_VALUE);
                    If(!Utility.ISStringBlankorNull(collObjWrp.SURVEY_NO))
                        collObj.SurveyKhasraKhataPatta_No__c        = collObjWrp.SURVEY_NO;
                    /*If(!Utility.ISStringBlankorNull(collObjWrp.MORTGAGE_DETAILS))
                        collObj.MORT_TYPE__c                        = collObjWrp.MORTGAGE_DETAILS;*/
                    If(!Utility.ISStringBlankorNull(collObjWrp.ASSET_TYPE))
                        collObj.Collateral_Category__c              = collObjWrp.ASSET_TYPE;
                    If(!Utility.ISStringBlankorNull(collObjWrp.DOOR_NO))
                        collObj.Door__c                             = collObjWrp.DOOR_NO;
                    If(!Utility.ISStringBlankorNull(collObjWrp.NEAREST_LANDMARK))
                        collObj.Landmark__c                         = collObjWrp.NEAREST_LANDMARK;
                    If(!Utility.ISStringBlankorNull(collObjWrp.PROPERTY_AREA))
                        collObj.Area_Square_Feet__c                 = Decimal.valueOf(collObjWrp.PROPERTY_AREA);
                    if(externalIdForCollateral !=null && externalIdForCollateral !='') {
                        collObj.External_ID__c                      =   externalIdForCollateral;
                        collObj.clcommon__Collateral_Name__c        =   externalIdForCollateral;
                    }

                    If(!Utility.ISStringBlankorNull(collObjWrp.NATURE_OF_MACHINERY))
                        collObj.Nature_of_Machinery__c= collObjWrp.NATURE_OF_MACHINERY;
                    If(!Utility.ISStringBlankorNull(collObjWrp.NATURE_OF_COMMERCIAL_VEHICLE))
                        collObj.Nature_of_Commercial_Vehicle__c= collObjWrp.NATURE_OF_COMMERCIAL_VEHICLE;
                    If(!Utility.ISStringBlankorNull(collObjWrp.NATURE_OF_CONSTRUCTION_EQUIPMENT))
                        collObj.Nature_of_Construction_Equipment__c= collObjWrp.NATURE_OF_CONSTRUCTION_EQUIPMENT;
                    If(!Utility.ISStringBlankorNull(collObjWrp.NATURE_OF_PASSENGER_VEHICLE))
                        collObj.Nature_of_Passenger_Vehicle__c=  collObjWrp.NATURE_OF_PASSENGER_VEHICLE; 
                    If(!Utility.ISStringBlankorNull(collObjWrp.NATURE_OF_OTHERS))
                        collObj.Nature_of_Others__c= collObjWrp.NATURE_OF_OTHERS;
                    If(!Utility.ISStringBlankorNull(collObjWrp.MACHINERY_COST))
                        collObj.Machinery_Cost__c= Decimal.valueOf(collObjWrp.MACHINERY_COST);
                    If(!Utility.ISStringBlankorNull(collObjWrp.INSTALLATION_COST))
                        collObj.Installation_Cost__c= Decimal.valueOf(collObjWrp.INSTALLATION_COST);
                    If(!Utility.ISStringBlankorNull(collObjWrp.OTHER_COST))
                        collObj.Other_Cost__c= Decimal.valueOf(collObjWrp.OTHER_COST);
                    If(!Utility.ISStringBlankorNull(collObjWrp.CHASSIS_COST))
                        collObj.Chassis_Cost__c= Decimal.valueOf(collObjWrp.CHASSIS_COST);
                    If(!Utility.ISStringBlankorNull(collObjWrp.BODY_BUILDING_COST))
                        collObj.Body_Building_Cost__c= Decimal.valueOf(collObjWrp.BODY_BUILDING_COST);
                    If(!Utility.ISStringBlankorNull(collObjWrp.GST_PAN))
                        collObj.GST_PAN__c= collObjWrp.GST_PAN;
                    If(!Utility.ISStringBlankorNull(collObjWrp.DEALER_GST_NUMBER))
                       collObj.Dealer_GST_Number__c= collObjWrp.DEALER_GST_NUMBER;
                    If(!Utility.ISStringBlankorNull(collObjWrp.DEALER_PAN_NUMBER))
                        collObj.Dealer_PAN_Number__c= collObjWrp.DEALER_PAN_NUMBER;
                    
                    If(!Utility.ISStringBlankorNull(collObjWrp.MAKE))
                        collObj.clcommon__Make__c= collObjWrp.MAKE;
                    If(!Utility.ISStringBlankorNull(collObjWrp.MODEL))
                        collObj.clcommon__Model__c= collObjWrp.MODEL;
                    If(!Utility.ISStringBlankorNull(collObjWrp.VARIANT))
                        collObj.Variant__c= collObjWrp.VARIANT;
                    If(!Utility.ISStringBlankorNull(collObjWrp.DEALER_NAME))
                        collObj.Dealer_name__c= collObjWrp.DEALER_NAME;
                    
                    If(!Utility.ISStringBlankorNull(collObjWrp.STATE ))
                        collObj.State__c= collObjWrp.STATE;
                    If(!Utility.ISStringBlankorNull(collObjWrp.CITY ))
                        collObj.clcommon__City__c= collObjWrp.CITY;
                    If(!Utility.ISStringBlankorNull(collObjWrp.PIN_CODE))
                        collObj.Property_Pincode__c= collObjWrp.PIN_CODE;

                    If(!Utility.ISStringBlankorNull(collObjWrp.ADDRESS_LINE_1))
                        collObj.clcommon__Address__c= collObjWrp.ADDRESS_LINE_1;
                    If(!Utility.ISStringBlankorNull(collObjWrp.ADDRESS_LINE_2))
                        collObj.Address_Line_2__c= collObjWrp.ADDRESS_LINE_2;
                    If(!Utility.ISStringBlankorNull(collObjWrp.RECORD_TYPE))
                        collObj.RecordTypeId= recordtypeIdMap.get(collObjWrp.RECORD_TYPE);

                    If(!Utility.ISStringBlankorNull(collObjWrp.COMMERCIAL_VEHICLE_APG))
                        collObj.Commercial_Vehicle_Apg__c= Decimal.valueOf(collObjWrp.COMMERCIAL_VEHICLE_APG);

                    Decimal costDeviation=0.000;
                    if(!Utility.ISStringBlankorNull(collObjWrp.RECORD_TYPE)){
                        if(collObjWrp.RECORD_TYPE== 'Passenger Vehicle'){
                            if( collObjWrp.EXSHOWROOMPRICE!=null && Decimal.valueOf(collObjWrp.EXSHOWROOMPRICE)!= 0){
                                Decimal ex_apg = 0.000;
                                if(collObjWrp.EXSHOWROOMPRICE_APG != null && collObjWrp.EXSHOWROOMPRICE_APG!='' ){
                                    ex_apg = Decimal.valueOf(collObjWrp.EXSHOWROOMPRICE_APG);
                                }
                                if(ex_apg != 0.000){
                                    costDeviation=  (ex_apg/ Decimal.valueOf(collObjWrp.EXSHOWROOMPRICE))*100.000;
                                }
                            }
                        }else if(collObjWrp.RECORD_TYPE== 'Commercial Vehicle'){
                            Decimal chassis_bodyCost =0.000;

                            if(collObjWrp.CHASSIS_COST!= null && collObjWrp.CHASSIS_COST!= ''){
                                chassis_bodyCost = Decimal.valueOf(collObjWrp.CHASSIS_COST);
                            }
                            if(collObjWrp.BODY_BUILDING_COST!= null && collObjWrp.BODY_BUILDING_COST!= ''){
                                chassis_bodyCost += Decimal.valueOf(collObjWrp.BODY_BUILDING_COST);
                            }
                            if(chassis_bodyCost != 0.000){

                                if(collObjWrp.EXSHOWROOMPRICE != null && collObjWrp.EXSHOWROOMPRICE !=''){
                                    costDeviation = (chassis_bodyCost - (Decimal.valueOf(collObjWrp.EXSHOWROOMPRICE) / chassis_bodyCost))*100.000;
                                }else{
                                    costDeviation=0.000;
                                }
                            }else{
                                costDeviation=0.000;
                            }

                        }
                    }

                    collObj.Cost_Deviation__c= costDeviation.setScale(3);
                    If(!Utility.ISStringBlankorNull(collObjWrp.EXSHOWROOMPRICE_APG))
                        collObj.ExshowRoomPrice_Api__c= Decimal.valueOf(collObjWrp.EXSHOWROOMPRICE_APG);
                    If(!Utility.ISStringBlankorNull(collObjWrp.EXSHOWROOMPRICE))
                        collObj.ExShow_Room_Price__c= Decimal.valueOf(collObjWrp.EXSHOWROOMPRICE);
                    If(!Utility.ISStringBlankorNull(collObjWrp.REGISTRATION_COST))
                        collObj.Registration_cost__c= Decimal.valueOf(collObjWrp.REGISTRATION_COST);
                    If(!Utility.ISStringBlankorNull(collObjWrp.INSURANCE_AMOUNT))
                        collObj.clcommon__Insurance_Amount__c= Decimal.valueOf(collObjWrp.INSURANCE_AMOUNT);
                    If(!Utility.ISStringBlankorNull(collObjWrp.ADVANCES_PAID))
                        collObj.Advances_Paid__c= Decimal.valueOf(collObjWrp.ADVANCES_PAID); 
                    If(!Utility.ISStringBlankorNull(collObjWrp.ACCESSORY_COST))
                        collObj.Accessories_value__c= Decimal.valueOf(collObjWrp.ACCESSORY_COST);


                    If(!Utility.ISStringBlankorNull(collObjWrp.TAX))
                        collObj.Tax__c= Decimal.valueOf(collObjWrp.TAX);
                    If(!Utility.ISStringBlankorNull(collObjWrp.VARIANT_ID))
                        collObj.Variant_Id__c= collObjWrp.VARIANT_ID;
                    If(!Utility.ISStringBlankorNull(collObjWrp.CITY_ID))
                        collObj.City_Id__c= collObjWrp.CITY_ID;
                    If(!Utility.ISStringBlankorNull(collObjWrp.MAKE_ID))
                        collObj.Make_Id__c= collObjWrp.MAKE_ID;
                    If(!Utility.ISStringBlankorNull(collObjWrp.TL_INVESTMENT_PROPERTY))
                        collObj.TL_Investment_Property__c= Decimal.valueOf(collObjWrp.TL_INVESTMENT_PROPERTY);
                    If(!Utility.ISStringBlankorNull(collObjWrp.TYPE_OF_VEHICLE))
                        collObj.Type_of_Vehicle__c= collObjWrp.TYPE_OF_VEHICLE;
                    If(!Utility.ISStringBlankorNull(collObjWrp.STATE_ID))
                        collObj.State_Id__c= collObjWrp.STATE_ID;
                    If(!Utility.ISStringBlankorNull(collObjWrp.MODEL_ID))
                        collObj.Model_Id__c= collObjWrp.MODEL_ID;
                    If(!Utility.ISStringBlankorNull(collObjWrp.NUMBER_OF_EQUIPMENT))
                        collObj.Number_Of_Equipment__c= Decimal.valueOf(collObjWrp.NUMBER_OF_EQUIPMENT);
                    If(!Utility.ISStringBlankorNull(collObjWrp.IS_TL_COLLATERAL))
                        collObj.Is_TL_Collateral__c= collObjWrp.IS_TL_COLLATERAL== 'True'? true: false;
                    if(!Utility.ISStringBlankorNull(collObjWrp.CURRENTLY_MORTGAGED))
                        collObj.CURRENTLY_MORTGAGED__c= collObjWrp.CURRENTLY_MORTGAGED== 'Yes' ? true: false;
                    if(collObjWrp.TILE_HOLDERS != null &&  !(collObjWrp.TILE_HOLDERS).isEmpty()){
                            Ownership__c  ownerShipRec;
                            for(Customer360view.cls_TITLE_HOLDER titleHolderRec:collObjWrp.TILE_HOLDERS){
                                ownerShipRec= new Ownership__c();
                                if(!Utility.ISStringBlankorNull(titleHolderRec.LOS_TITLE_HOLDER_RECORD_ID)){
                                    ownerShipRec.Id                                 =   titleHolderRec.LOS_TITLE_HOLDER_RECORD_ID ;
                                    ownerShipRec.Account__c                         =   titleHolderRec.LOS_TITLE_HOLDER_ID;
                                    ownerShipListToUpdate.add(ownerShipRec);
                                }else{
                                    If(!Utility.ISStringBlankorNull(titleHolderRec.LOS_TITLE_HOLDER_ID)){
                                        System.debug('titleHolderRec.LOS_TITLE_HOLDER_ID===> '+titleHolderRec.LOS_TITLE_HOLDER_ID);
                                        ownerShipRec.Account__c                         =   titleHolderRec.LOS_TITLE_HOLDER_ID;
                                    }
                                    If(!Utility.ISStringBlankorNull(collObjWrp.LOS_PROPERTY_ID)){
                                        ownerShipRec.Collateral__c                  =   collObjWrp.LOS_PROPERTY_ID;    
                                    }else{
                                        ownerShipRec.Collateral__r                  =  new clcommon__Collateral__c(External_ID__c  =   externalIdForCollateral);
                                    }
                                    //ownerShipRec.Name       =   titleHolderRec.LOS_TITLE_HOLDER_NAME;
                                    ownerShipRec.OwnerId                    =  (Id)UserId;
                                    ownerShipListToInsert.add(ownerShipRec);
                                }
                            }
                        }
                        If(collObjWrp.ADDRESS !=null){
                            Customer360view.cls_ADDRESS  cusParAdd      = collObjWrp.ADDRESS;
                            If(!Utility.ISStringBlankorNull(cusParAdd.TALUK))
                                collObj.TalukaTehsil__c                 = cusParAdd.TALUK;
                            If(!Utility.ISStringBlankorNull(cusParAdd.STREET))
                                collObj.Street_NameNo__c                = cusParAdd.STREET;
                            If(!Utility.ISStringBlankorNull(cusParAdd.CITY))
                                collObj.clcommon__City__c               = cusParAdd.CITY;
                            If(!Utility.ISStringBlankorNull(cusParAdd.STATE))
                                collObj.State__c                        = cusParAdd.STATE;
                            If(!Utility.ISStringBlankorNull(cusParAdd.PIN_CODE))
                                collObj.clcommon__Postal_Code__c        = cusParAdd.PIN_CODE;
                            If(!Utility.ISStringBlankorNull(cusParAdd.COUNTRY))
                                collObj.Country__c                      = cusParAdd.COUNTRY;
                        }



                    If(collObjWrp.LOS_PROPERTY_ID !=null && collObjWrp.LOS_PROPERTY_ID !=''){
                        if(collObjWrp.IS_DELETED== 'True'){
                            listCollateralDelete.add(collObj);
                        }else{
                            listCollateralUpdate.add(collObj);
                        }
                    }else{
                        collObj.FE_Created__c= true;
                        collObj.OwnerId=  (Id)UserId;
                        listCollateralInsert.add(collObj);

                    }

                    /*if(collObjWrp.FACILITY_SEQ_NO_LIST!= null){
                        for(String str: collObjWrp.FACILITY_SEQ_NO_LIST){
                            genesis__Application_Collateral__c appCollat= new genesis__Application_Collateral__c();
                            appCollat.Application__c= LOS_APPLICATION_ID;
                            appCollat.genesis__Collateral__r=  new clcommon__Collateral__c(External_ID__c=   externalIdForCollateral);
                            if(seqMapFacility.size()>0 && seqMapFacility.containsKey(str)){
                                appCollat.Facility__c= seqMapFacility.get(str).Id;
                                //appCollat.External_ID__c=  externalIdForCollateral;
                                appCollat.OwnerId=  (Id)UserId;
                                listAppCollateral.add(appCollat);
                            }

                        }
                    }*/
                    if((collObjWrp.LOS_PROPERTY_ID=='' || collObjWrp.LOS_PROPERTY_ID== null) && collObjWrp.FACILITY_LINKAGE_MAP!= null && collObjWrp.IS_DELETED!='True'){
                        for(String str: collObjWrp.FACILITY_LINKAGE_MAP.keyset()){
                            genesis__Application_Collateral__c appCollat= new genesis__Application_Collateral__c();
                            appCollat.Application__c= LOS_APPLICATION_ID;
                            appCollat.genesis__Collateral__r=  new clcommon__Collateral__c(External_ID__c=   externalIdForCollateral);
                            if(seqMapFacility.size()>0 && seqMapFacility.containsKey(str)){
                                appCollat.Facility__c= seqMapFacility.get(str).Id;
                                appCollat.Security_Type__c= collObjWrp.FACILITY_LINKAGE_MAP.get(str)!= null? collObjWrp.FACILITY_LINKAGE_MAP.get(str):'';
                                //appCollat.External_ID__c=  externalIdForCollateral;
                                appCollat.OwnerId=  (Id)UserId;
                                listAppCollateral.add(appCollat);
                            }

                        }
                    }
                    

                }
                /*System.debug('########'+listCollateralDelete);
                System.debug('########'+listCollateralUpdate);
                System.debug('########'+listCollateralInsert);
                System.debug('########'+listAppCollateral);*/
                if(!listCollateralDelete.isEmpty()){
                    Delete listCollateralDelete;
                    List<genesis__Application_Collateral__c> appCollatLstToDlt= [SELECT Id from genesis__Application_Collateral__c where Application__c=:LOS_APPLICATION_ID AND (genesis__Collateral__c=null OR genesis__Collateral__c='')];
                    if(appCollatLstToDlt.size()>0){
                        delete appCollatLstToDlt;
                    }
                }
                if(!listCollateralUpdate.isEmpty()){
                    update listCollateralUpdate;
                }
                if(!listCollateralInsert.isEmpty()){
                    insert listCollateralInsert;
                }
                if(!listAppCollateral.isEmpty()){
                    insert listAppCollateral;
                }
                if(ownerShipListToInsert.size() > 0){
                    insert ownerShipListToInsert;
                }
                if(ownerShipListToUpdate.size() > 0){
                    update ownerShipListToUpdate;
                }
            }    
        }catch(Exception ex){
            System.debug('Exception'+ex.getMessage());
            System.debug('Exception Line Number'+ex.getLineNumber());
            System.debug('Exception StackTraceString'+ex.getStackTraceString());     
        }   
    }
    public static void getCollateralDetails(List<Customer360view.cls_NETWORTH_DETAILS>  listcollateralWrp, String LOS_APPLICATION_ID,List<Facility__c> listFacility){
        List<genesis__Application_Collateral__c> listAppCollateral      = new List<genesis__Application_Collateral__c>();
        List<clcommon__Collateral__c> listCollateralInsert              = new List<clcommon__Collateral__c>();
        List<clcommon__Collateral__c> listCollateralUpdate              = new List<clcommon__Collateral__c>();
        List<Ownership__c> ownerShipListToInsert                        = new List<Ownership__c>();
        List<Ownership__c> ownerShipListToUpdate                        = new List<Ownership__c>(); 
        
        List<String> listDeveloperName                                  = new List<String>{'Land_And_Buildings_Other'};
            Map<String,id> recordtypeIdMap                              = Utility.getRecordTypeID(listDeveloperName);
        try{
            If(listcollateralWrp !=null){
                for(Customer360view.cls_NETWORTH_DETAILS    collObjWrp      :   listcollateralWrp) {
                    String externalIdForCollateral                          =   SOQL_Util.getRandomExternalIdForCollateral();
                    //System.debug('externalIdForCollateral @@@@'+externalIdForCollateral);
                    clcommon__Collateral__c  collObj                        =   new clcommon__Collateral__c();
                    If(collObjWrp !=null){
                        If(!Utility.ISStringBlankorNull(collObjWrp.LOS_PROPERTY_ID))
                            collObj.id                                  = collObjWrp.LOS_PROPERTY_ID;
                        If(!Utility.ISStringBlankorNull(collObjWrp.NATURE_OF_PROPERTY))
                            collObj.Nature_of_Property__c               = collObjWrp.NATURE_OF_PROPERTY;
                        If(!Utility.ISStringBlankorNull(collObjWrp.OWNERSHIP_TYPE))
                            collObj.Ownership_Type__c                   = collObjWrp.OWNERSHIP_TYPE;
                        If(!Utility.ISStringBlankorNull(collObjWrp.PERCENTAGE_OWNERSHIP))
                            collObj.Percentage_of_Ownership__c          = Decimal.valueOf(collObjWrp.PERCENTAGE_OWNERSHIP);
                        If(!Utility.ISStringBlankorNull(collObjWrp.PROPERTY_VALUE))
                            collObj.Total_Asset_Value__c                = SMELoan_Helper.currencyFormatter(collObjWrp.PROPERTY_VALUE);
                        If(!Utility.ISStringBlankorNull(collObjWrp.SURVEY_NO))
                            collObj.SurveyKhasraKhataPatta_No__c        = collObjWrp.SURVEY_NO;
                        /*If(!Utility.ISStringBlankorNull(collObjWrp.MORTGAGE_DETAILS))
                            collObj.MORT_TYPE__c                        = collObjWrp.MORTGAGE_DETAILS;*/
                        If(!Utility.ISStringBlankorNull(collObjWrp.ASSET_TYPE))
                            collObj.Collateral_Category__c              = collObjWrp.ASSET_TYPE;
                        If(!Utility.ISStringBlankorNull(collObjWrp.DOOR_NO))
                            collObj.Door__c                             = collObjWrp.DOOR_NO;
                        If(!Utility.ISStringBlankorNull(collObjWrp.NEAREST_LANDMARK))
                            collObj.Landmark__c                         = collObjWrp.NEAREST_LANDMARK;
                        If(!Utility.ISStringBlankorNull(collObjWrp.PROPERTY_AREA))
                            collObj.Area_Square_Feet__c                 = Decimal.valueOf(collObjWrp.PROPERTY_AREA);
                        If(externalIdForCollateral !=null && externalIdForCollateral !='') {
                            collObj.External_ID__c                      =   externalIdForCollateral;
                            collObj.clcommon__Collateral_Name__c        =   externalIdForCollateral;
                        }
                        collObj.FE_Created__c                           = true;
                        
                        if(collObjWrp.TILE_HOLDERS != null &&  !(collObjWrp.TILE_HOLDERS).isEmpty()){
                            Ownership__c  ownerShipRec;
                            for(Customer360view.cls_TITLE_HOLDER titleHolderRec:collObjWrp.TILE_HOLDERS){
                                ownerShipRec= new Ownership__c();
                                if(!Utility.ISStringBlankorNull(titleHolderRec.LOS_TITLE_HOLDER_RECORD_ID)){
                                    ownerShipRec.Id                                 =   titleHolderRec.LOS_TITLE_HOLDER_RECORD_ID ;
                                    ownerShipRec.Account__c                         =   titleHolderRec.LOS_TITLE_HOLDER_ID;
                                    ownerShipListToUpdate.add(ownerShipRec);
                                }else{
                                    If(!Utility.ISStringBlankorNull(titleHolderRec.LOS_TITLE_HOLDER_ID))
                                        ownerShipRec.Account__c                         =   titleHolderRec.LOS_TITLE_HOLDER_ID;
                                    If(!Utility.ISStringBlankorNull(collObjWrp.LOS_PROPERTY_ID)){
                                        ownerShipRec.Collateral__c                  =   collObjWrp.LOS_PROPERTY_ID;    
                                    }else{
                                        ownerShipRec.Collateral__r                  =  new clcommon__Collateral__c(External_ID__c  =   externalIdForCollateral);
                                    }
                                    //ownerShipRec.Name       =   titleHolderRec.LOS_TITLE_HOLDER_NAME;
                                    ownerShipRec.OwnerId                    =  (Id)UserId;
                                    ownerShipListToInsert.add(ownerShipRec);
                                }
                            }
                        }
                        If(collObjWrp.ADDRESS !=null){
                            Customer360view.cls_ADDRESS  cusParAdd      = collObjWrp.ADDRESS;
                            If(!Utility.ISStringBlankorNull(cusParAdd.TALUK))
                                collObj.TalukaTehsil__c                 = cusParAdd.TALUK;
                            If(!Utility.ISStringBlankorNull(cusParAdd.STREET))
                                collObj.Street_NameNo__c                = cusParAdd.STREET;
                            If(!Utility.ISStringBlankorNull(cusParAdd.CITY))
                                collObj.clcommon__City__c               = cusParAdd.CITY;
                            If(!Utility.ISStringBlankorNull(cusParAdd.STATE))
                                collObj.State__c                        = cusParAdd.STATE;
                            If(!Utility.ISStringBlankorNull(cusParAdd.PIN_CODE))
                                collObj.clcommon__Postal_Code__c        = cusParAdd.PIN_CODE;
                            If(!Utility.ISStringBlankorNull(cusParAdd.COUNTRY))
                                collObj.Country__c                      = cusParAdd.COUNTRY;
                        }
                        collObj.RecordTypeId                            =   recordtypeIdMap.get('Land_And_Buildings_Other');
                        If(collObjWrp.LOS_PROPERTY_ID !=null && collObjWrp.LOS_PROPERTY_ID !=''){
                            listCollateralUpdate.add(collObj);
                        }else{
                            collObj.OwnerId                 =  (Id)UserId;
                            listCollateralInsert.add(collObj);
                            genesis__Application_Collateral__c appCollateralObj    =  new genesis__Application_Collateral__c();
                            appCollateralObj.genesis__Collateral__r      =  new clcommon__Collateral__c(External_ID__c  =   externalIdForCollateral);
                            appCollateralObj.Application__c              =  LOS_APPLICATION_ID;
                            appCollateralObj.External_ID__c              =  externalIdForCollateral;
                            If(!Utility.ISStringBlankorNull(collObjWrp.PROPERTY_TYPE))
                                appCollateralObj.Security_Type__c        =  collObjWrp.PROPERTY_TYPE;
                            
                            appCollateralObj.OwnerId                    =  (Id)UserId;
                            listAppCollateral.add(appCollateralObj);
                        }
                    }
                }
                If(listFacility !=null && !listFacility.isEmpty() && listAppCollateral !=null && !listAppCollateral.isEmpty()){
                    for(Facility__c facObj :    listFacility) {
                        for(genesis__Application_Collateral__c  appCollateralObject :   listAppCollateral){
                            appCollateralObject.Facility__c         =   facObj.Id;
                            appCollateralObject.External_ID__c      =   facObj.Id+'@'+appCollateralObject.External_ID__c;
                        }
                    }
                    
                }
                if(!listCollateralUpdate.isEmpty()){
                    update listCollateralUpdate;
                }
                if(!listCollateralInsert.isEmpty()){
                    insert listCollateralInsert;
                }
                if(!listAppCollateral.isEmpty()){
                    insert listAppCollateral;
                }
                if(ownerShipListToInsert.size() > 0){
                    insert ownerShipListToInsert;
                }
                if(ownerShipListToUpdate.size() > 0){
                    update ownerShipListToUpdate;
                }
            }    
        }catch(Exception ex){
            System.debug('Exception'+ex.getMessage());
            System.debug('Exception Line Number'+ex.getLineNumber());
            //HandleBusinessException.captureError('SMELoan_Helper_Handler', 'getBaseValueForSalesPurchase', ex);
        }   
    }
    //Update Liablities Records
    public static void updateBusinessLiablities(String appId,String accId,Customer360view.cls_BusinessLiabilityDetails businessLiabilityObj){
        try{
            List<Liablities__c> listOfLiablities = new List<Liablities__c>();
            if(appId !=null && appId !='' && accId !=null && accId !='' && businessLiabilityObj !=null){
                Account accObj  =   new Account();
                If(!Utility.ISStringBlankorNull(businessLiabilityObj.CustomerStatus)){
                    accObj.id       =   accId;
                    accObj.SMA_Classification__c =  businessLiabilityObj.CustomerStatus;
                }
                if(businessLiabilityObj.IndirectLiabilityGroup !=null && !businessLiabilityObj.IndirectLiabilityGroup.isEmpty()){
                    List<Customer360view.cls_IndirectLiabilityGroup> listOfIndirectLiabilityObj = businessLiabilityObj.IndirectLiabilityGroup;
                    Id devRecordTypeId = Schema.SObjectType.Liablities__c.getRecordTypeInfosByName().get('Indirect Liablity Group').getRecordTypeId();
                    if(listOfIndirectLiabilityObj !=null && listOfIndirectLiabilityObj.size() > 0){
                        for(Customer360view.cls_IndirectLiabilityGroup  indirectLiabilityGroupObj : listOfIndirectLiabilityObj){
                            Liablities__c  liabilitiesObj   =   utilityindirectLiaGroup(appId,indirectLiabilityGroupObj,devRecordTypeId);
                            If(liabilitiesObj !=null){
                                listOfLiablities.add(liabilitiesObj);    
                            }
                        }    
                    }
                }
                if(businessLiabilityObj.DirectLiabilityLongTerm !=null && !businessLiabilityObj.DirectLiabilityLongTerm.isEmpty()){
                    List<Customer360view.cls_DirectLiabilityLongTerm> listOfDirectLiabilityObj = businessLiabilityObj.DirectLiabilityLongTerm;
                    Id devRecordTypeId = Schema.SObjectType.Liablities__c.getRecordTypeInfosByName().get('Direct Liability Long Term').getRecordTypeId();
                    if(listOfDirectLiabilityObj !=null && listOfDirectLiabilityObj.size() > 0){
                        for(Customer360view.cls_DirectLiabilityLongTerm directLiabilityLongtermObj : listOfDirectLiabilityObj){
                            Liablities__c  liabilitiesObj   =   utilityDirectLiabilityLongTerm(appId,directLiabilityLongtermObj,devRecordTypeId);
                            If(liabilitiesObj !=null){
                                listOfLiablities.add(liabilitiesObj);    
                            }
                        }    
                    }
                }
                if(businessLiabilityObj.DirectLiabilityTemporary !=null && !businessLiabilityObj.DirectLiabilityTemporary.isEmpty()){
                    List<Customer360view.cls_DirectLiabilityTemporary> listOfDirectLiabilityTempObj = businessLiabilityObj.DirectLiabilityTemporary;
                    Id devRecordTypeId = Schema.SObjectType.Liablities__c.getRecordTypeInfosByName().get('Direct Liablity Temporary').getRecordTypeId();
                    if(listOfDirectLiabilityTempObj !=null && listOfDirectLiabilityTempObj.size() > 0){
                        for(Customer360view.cls_DirectLiabilityTemporary    directLiabilityTempObj : listOfDirectLiabilityTempObj){
                            Liablities__c  liabilitiesObj   =   utilityDirectLiabilityTemporary(appId,directLiabilityTempObj,devRecordTypeId);
                            If(liabilitiesObj !=null){
                                listOfLiablities.add(liabilitiesObj);    
                            }
                        }    
                    }    
                }
                if(businessLiabilityObj.IndirectLiabilityRetail !=null && !businessLiabilityObj.IndirectLiabilityRetail.isEmpty()){
                    List<Customer360view.cls_IndirectLiabilityRetail> listOfIndirectLiabilityRetailObj = businessLiabilityObj.IndirectLiabilityRetail;
                    Id devRecordTypeId = Schema.SObjectType.Liablities__c.getRecordTypeInfosByName().get('Indirect Liablity Retail').getRecordTypeId();
                    if(listOfIndirectLiabilityRetailObj !=null && listOfIndirectLiabilityRetailObj.size() > 0){
                        for(Customer360view.cls_IndirectLiabilityRetail indirectLiabilityRetailObj : listOfIndirectLiabilityRetailObj){
                            Liablities__c  liabilitiesObj   =   utilityIndirectLiabilityRetail(appId,indirectLiabilityRetailObj,devRecordTypeId);
                            listOfLiablities.add(liabilitiesObj);
                        }    
                    }    
                }
                If(accObj.Id !=null){
                   AccountTriggerHandler.isAccountTrigger = false; 
                   update accObj;
                }
                if(listOfLiablities !=null && !listOfLiablities.isEmpty()){
                    upsert listOfLiablities External_Id__c;
                }
            }
        }catch(Exception ex){
            System.debug('Exception '+ ex.getMessage() +'Line Number'+ex.getLineNumber());    
        }
    }
    public static void updateKeyPersonLiablities(String appId,List<Customer360view.cls_KeyPersonLiabilityDetails> listOfkeyPersonLiability){
        try{
            If(appId !=null && appId !='' && listOfkeyPersonLiability !=null && listOfkeyPersonLiability.size() > 0){
                List<Liablities__c> listOfLiablities = new List<Liablities__c>();
                for(Customer360view.cls_KeyPersonLiabilityDetails kPersonLiabilityObj : listOfkeyPersonLiability){
                    If(kPersonLiabilityObj !=null){
                        if(kPersonLiabilityObj.IndirectLiabilityGroup !=null && !kPersonLiabilityObj.IndirectLiabilityGroup.isEmpty()){
                            List<Customer360view.cls_IndirectLiabilityGroup> listOfIndirectLiabilityObj = kPersonLiabilityObj.IndirectLiabilityGroup;
                            Id devRecordTypeId = Schema.SObjectType.Liablities__c.getRecordTypeInfosByName().get('Indirect Liablity Group').getRecordTypeId();
                            if(listOfIndirectLiabilityObj !=null && listOfIndirectLiabilityObj.size() > 0){
                                for(Customer360view.cls_IndirectLiabilityGroup  indirectLiabilityGroupObj : listOfIndirectLiabilityObj){
                                    Liablities__c  liabilitiesObj   =   utilityindirectLiaGroup(appId,indirectLiabilityGroupObj,devRecordTypeId);
                                    If(liabilitiesObj !=null){
                                        listOfLiablities.add(liabilitiesObj);    
                                    }
                                }    
                            }
                        }
                        if(kPersonLiabilityObj.DirectLiabilityLongTerm !=null && !kPersonLiabilityObj.DirectLiabilityLongTerm.isEmpty()){
                            List<Customer360view.cls_DirectLiabilityLongTerm> listOfDirectLiabilityObj = kPersonLiabilityObj.DirectLiabilityLongTerm;
                            Id devRecordTypeId = Schema.SObjectType.Liablities__c.getRecordTypeInfosByName().get('Direct Liability Long Term').getRecordTypeId();
                            if(listOfDirectLiabilityObj !=null && listOfDirectLiabilityObj.size() > 0){
                                for(Customer360view.cls_DirectLiabilityLongTerm directLiabilityLongtermObj : listOfDirectLiabilityObj){
                                    Liablities__c  liabilitiesObj   =   utilityDirectLiabilityLongTerm(appId,directLiabilityLongtermObj,devRecordTypeId);
                                    If(liabilitiesObj !=null){
                                        listOfLiablities.add(liabilitiesObj);    
                                    }
                                }    
                            }
                        }
                        if(kPersonLiabilityObj.DirectLiabilityTemporary !=null && !kPersonLiabilityObj.DirectLiabilityTemporary.isEmpty()){
                            List<Customer360view.cls_DirectLiabilityTemporary> listOfDirectLiabilityTempObj = kPersonLiabilityObj.DirectLiabilityTemporary;
                            Id devRecordTypeId = Schema.SObjectType.Liablities__c.getRecordTypeInfosByName().get('Direct Liablity Temporary').getRecordTypeId();
                            if(listOfDirectLiabilityTempObj !=null && listOfDirectLiabilityTempObj.size() > 0){
                                for(Customer360view.cls_DirectLiabilityTemporary    directLiabilityTempObj : listOfDirectLiabilityTempObj){
                                    Liablities__c  liabilitiesObj   =   utilityDirectLiabilityTemporary(appId,directLiabilityTempObj,devRecordTypeId);
                                    If(liabilitiesObj !=null){
                                        listOfLiablities.add(liabilitiesObj);    
                                    }
                                }    
                            }    
                        }
                        if(kPersonLiabilityObj.IndirectLiabilityRetail !=null && !kPersonLiabilityObj.IndirectLiabilityRetail.isEmpty()){
                            List<Customer360view.cls_IndirectLiabilityRetail> listOfIndirectLiabilityRetailObj = kPersonLiabilityObj.IndirectLiabilityRetail;
                            Id devRecordTypeId = Schema.SObjectType.Liablities__c.getRecordTypeInfosByName().get('Indirect Liablity Retail').getRecordTypeId();
                            if(listOfIndirectLiabilityRetailObj !=null && listOfIndirectLiabilityRetailObj.size() > 0){
                                for(Customer360view.cls_IndirectLiabilityRetail indirectLiabilityRetailObj : listOfIndirectLiabilityRetailObj){
                                    Liablities__c  liabilitiesObj   =   utilityIndirectLiabilityRetail(appId,indirectLiabilityRetailObj,devRecordTypeId);
                                    listOfLiablities.add(liabilitiesObj);
                                }    
                            }    
                        }
                    }
                }
                if(listOfLiablities !=null && !listOfLiablities.isEmpty()){
                    //System.debug('listOfLiablities@@@@'+listOfLiablities);
                    upsert listOfLiablities External_Id__c;
                }
            }    
        }catch(Exception ex){
            System.debug('Exception '+ ex.getMessage() +'Line Number'+ex.getLineNumber());    
        }
    }
    public static Liablities__c utilityindirectLiaGroup(String appId,Customer360view.cls_IndirectLiabilityGroup indirectLiabilityGroupObj, String recordTypeIds){
        try{
            If(appId !=null && indirectLiabilityGroupObj !=null && recordTypeIds !=null){
                Liablities__c  liabilitiesObj   =   new Liablities__c();
                If(!Utility.ISStringBlankorNull(indirectLiabilityGroupObj.D_OPEN_DATE))
                    liabilitiesObj.Open_Date__c = indirectLiabilityGroupObj.D_OPEN_DATE;
                If(!Utility.ISStringBlankorNull(indirectLiabilityGroupObj.V_CUST_CODE))
                    liabilitiesObj.Customer_code__c = indirectLiabilityGroupObj.V_CUST_CODE;
                If(!Utility.ISStringBlankorNull(indirectLiabilityGroupObj.V_ACCT_NO)){
                    liabilitiesObj.Account_Number__c = indirectLiabilityGroupObj.V_ACCT_NO;
                    liabilitiesObj.External_Id__c = appId+'@'+indirectLiabilityGroupObj.V_ACCT_NO+'@'+recordTypeIds;
                }
                If(!Utility.ISStringBlankorNull(indirectLiabilityGroupObj.N_FALLBACK_BAL))
                    liabilitiesObj.Outstanding_Balance__c = Decimal.valueOf(indirectLiabilityGroupObj.N_FALLBACK_BAL);
                If(!Utility.ISStringBlankorNull(indirectLiabilityGroupObj.LIMITNO))
                    liabilitiesObj.Limit__c = Decimal.valueOf(indirectLiabilityGroupObj.LIMITNO);
                
                liabilitiesObj.Application__c = appId;
                liabilitiesObj.RecordTypeId = recordTypeIds;
                //System.debug('indirectLiabilityGroupObj @@@Liability'+liabilitiesObj);
                return liabilitiesObj;
            }
        }catch(Exception ex){
            System.debug('Exception '+ ex.getMessage() +'Line Number'+ex.getLineNumber());    
        }
        return null;
    }
    public static Liablities__c utilityDirectLiabilityLongTerm(String appId,Customer360view.cls_DirectLiabilityLongTerm directLiabilityLongTermObj, String recordTypeIds){
        try{
            If(appId !=null && directLiabilityLongTermObj !=null && recordTypeIds !=null){
                Liablities__c  liabilitiesObj   =   new Liablities__c();
                If(!Utility.ISStringBlankorNull(directLiabilityLongTermObj.COD_PROD))
                    liabilitiesObj.Product_Code__c = directLiabilityLongTermObj.COD_PROD;
                If(!Utility.ISStringBlankorNull(directLiabilityLongTermObj.COD_CC_BRN))
                    liabilitiesObj.Branch_Code__c = directLiabilityLongTermObj.COD_CC_BRN;
                If(!Utility.ISStringBlankorNull(directLiabilityLongTermObj.COD_ACCT_NO)){
                    liabilitiesObj.Account_Number__c = directLiabilityLongTermObj.COD_ACCT_NO;
                    liabilitiesObj.External_Id__c = appId+'@'+directLiabilityLongTermObj.COD_ACCT_NO+'@'+recordTypeIds;   
                }
                If(!Utility.ISStringBlankorNull(directLiabilityLongTermObj.BAL_AVAILABLE))
                    liabilitiesObj.Outstanding_Balance__c = Decimal.valueOf(directLiabilityLongTermObj.BAL_AVAILABLE);
                If(!Utility.ISStringBlankorNull(directLiabilityLongTermObj.LIMITNO))
                    liabilitiesObj.Limit__c = Decimal.valueOf(directLiabilityLongTermObj.LIMITNO);
                
                liabilitiesObj.Application__c = appId;
                liabilitiesObj.RecordTypeId = recordTypeIds;
                //System.debug('directLiabilityLongTermObj @@@Liability'+liabilitiesObj);
                return liabilitiesObj;
            }    
        }catch(Exception ex){
            System.debug('Exception '+ ex.getMessage() +'Line Number'+ex.getLineNumber());    
        }
        return null;
    }
    public static Liablities__c utilityIndirectLiabilityRetail(String appId,Customer360view.cls_IndirectLiabilityRetail indirectLiabilityRetailObj, String recordTypeIds){
        try{
            If(appId !=null && indirectLiabilityRetailObj !=null && recordTypeIds !=null){
                Liablities__c  liabilitiesObj   =   new Liablities__c();
                If(!Utility.ISStringBlankorNull(indirectLiabilityRetailObj.D_OPEN_DATE))
                    liabilitiesObj.Open_Date__c = indirectLiabilityRetailObj.D_OPEN_DATE;
                If(!Utility.ISStringBlankorNull(indirectLiabilityRetailObj.V_CUST_CODE))
                    liabilitiesObj.Customer_code__c = indirectLiabilityRetailObj.V_CUST_CODE;
                If(!Utility.ISStringBlankorNull(indirectLiabilityRetailObj.V_ACCT_NO)){
                    liabilitiesObj.Account_Number__c = indirectLiabilityRetailObj.V_ACCT_NO;
                    liabilitiesObj.External_Id__c = appId+'@'+indirectLiabilityRetailObj.V_ACCT_NO+'@'+recordTypeIds;
                }
                If(!Utility.ISStringBlankorNull(indirectLiabilityRetailObj.N_FALLBACK_BAL))
                    liabilitiesObj.Outstanding_Balance__c = Decimal.valueOf(indirectLiabilityRetailObj.N_FALLBACK_BAL);
                
                liabilitiesObj.Application__c = appId;
                liabilitiesObj.RecordTypeId = recordTypeIds;
                //System.debug('indirectLiabilityRetailObj @@@Liability'+liabilitiesObj);
                return liabilitiesObj;
            }
        }catch(Exception ex){
            System.debug('Exception '+ ex.getMessage() +'Line Number'+ex.getLineNumber());  
        }
        return null;
    }
    public static Liablities__c utilityDirectLiabilityTemporary(String appId,Customer360view.cls_DirectLiabilityTemporary directLiabilityTempObj, String recordTypeIds){
        try{
            If(appId !=null && directLiabilityTempObj !=null && recordTypeIds !=null){
                Liablities__c  liabilitiesObj   =   new Liablities__c();
                If(!Utility.ISStringBlankorNull(directLiabilityTempObj.COD_PROD))
                    liabilitiesObj.Product_Code__c = directLiabilityTempObj.COD_PROD;
                
                If(!Utility.ISStringBlankorNull(directLiabilityTempObj.COD_CC_BRN))
                    liabilitiesObj.Branch_Code__c = directLiabilityTempObj.COD_CC_BRN;
                
                If(!Utility.ISStringBlankorNull(directLiabilityTempObj.COD_ACCT_NO)){
                    liabilitiesObj.Account_Number__c = directLiabilityTempObj.COD_ACCT_NO;
                    liabilitiesObj.External_Id__c = appId+'@'+directLiabilityTempObj.COD_ACCT_NO+'@'+recordTypeIds;
                }
                If(!Utility.ISStringBlankorNull(directLiabilityTempObj.BAL_AVAILABLE))
                    liabilitiesObj.Outstanding_Balance__c = Decimal.valueOf(directLiabilityTempObj.BAL_AVAILABLE);
                If(!Utility.ISStringBlankorNull(directLiabilityTempObj.AMT_LIMIT))
                    liabilitiesObj.Limit__c = Decimal.valueOf(directLiabilityTempObj.AMT_LIMIT);
                
                liabilitiesObj.Application__c = appId;
                liabilitiesObj.RecordTypeId = recordTypeIds;
                //System.debug('directLiabilityTempObj @@@Liability'+liabilitiesObj); 
                return liabilitiesObj;
            }    
        }catch(Exception ex){
            System.debug('Exception '+ ex.getMessage() +'Line Number'+ex.getLineNumber());    
        }
        return null;
    }

    public static Boolean  checkifwctltakeoverFacilityexists(String appid,string facilitytype){
        Boolean tlwcfacilitypresent=false;
        try{
            List<Facility__c> faclist=[Select id from Facility__c where Application__r.id=:appid and App_Facility_Type__c=:facilitytype];
            if(faclist!=null && faclist.size()>0){
                tlwcfacilitypresent=true;
            }
        }
        catch(Exception ex){
            HandleBusinessException.captureError('SMELoan_Helper_Handler','checkifwctakeoverFacilityexists',ex);
            
        }
        return tlwcfacilitypresent;

    }
    public static genesis__Checklist__c createchecklist(New_Loan_CheckList__mdt metadata,String appid){
        genesis__Checklist__c   checkListObj    = new genesis__Checklist__c();
        checkListObj.genesis__Application__c    = appid;
        checkListObj.Name__c  = metadata.Name__c; 
        checkListObj.genesis__Message__c  = 'Package Message';
        checkListObj.genesis__Assessed_Record_Id__c = 'Package Assessed RecordID';
        
        return checkListObj;
    }
    public static void createdocumentcategory(List<genesis__Checklist__c> insertedchecklist,String appid){
    List<genesis__Application_Document_Category__c> parentCatg ;
    List<genesis__Application_Document_Category__c> appchecklistDocCategoryList = new List<genesis__Application_Document_Category__c>();
    Decimal flag=0;
    //System.debug(insertedchecklist);
    try{
    parentCatg=[select id,genesis__Application__r.ID from genesis__Application_Document_Category__c where genesis__Application__r.ID=:appid and genesis__Parent_Application_Document_Category__c=null];
    List<genesis__Document_Category__c> docCatList= [SELECT Id,Name,genesis__Category_Name__c,Required_for_Missing_Financial__c,CollateralDoc__c,Doc_Category_No__c,Document_Category__c FROM genesis__Document_Category__c WHERE Document_Category__c='Takeover checklists' order by Doc_Category_No__c];
    appchecklistDocCategoryList=[SELECT Id,Name,App_Doc_Category_No__c,genesis__Document_Category__r.Document_Category__c,Parent_Category_Name__c,(SELECT Id,Dms_Uuid__c FROM genesis__AppDocCatAttachmentJunctions__r) FROM genesis__Application_Document_Category__c WHERE genesis__Document_Category__r.Document_Category__c='Takeover checklists' AND genesis__Application__c =:appId];
    //System.debug(parentCatg);
    //System.debug(docCatList);
    //System.debug(appchecklistDocCategoryList);
    if(appchecklistDocCategoryList.isEmpty()){
        if(parentCatg!=null && parentCatg.size()==1){
            for(genesis__Checklist__c checllistrec:insertedchecklist){
                flag++;
                appchecklistDocCategoryList.add(new genesis__Application_Document_Category__c(Name ='CheckList'+' '+checllistrec.name__c, genesis__Application__c = appId , genesis__Document_Category__c = docCatList[0].Id, genesis__Parent_Application_Document_Category__c=parentCatg[0].id,App_Doc_Category_No__c=flag+docCatList[0].Doc_Category_No__c));
                //System.debug(appchecklistDocCategoryList);
            }
        }
        
    }
    //System.debug(appchecklistDocCategoryList);
    if(!appchecklistDocCategoryList.isEmpty()){
        insert appchecklistDocCategoryList;
    }
    }
    catch(Exception ex){
        HandleBusinessException.captureError('SMELoan_Helper_Handler','createdocumentcategory',ex);
    }
    //return appchecklistDocCategoryList;
    }
}