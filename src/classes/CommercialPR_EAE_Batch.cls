/*
* Name     : CommercialPR_EAE_Batch
* Company  : ET Marlabs
* Purpose  : Batch Class  to send CommercialPRCallout request to APIGEE and get Response. 
* Author   : Raushan
*/
public class CommercialPR_EAE_Batch {
    
    public static List<Account> listAccount =  new List<Account>();
    public static Account accCRILCObj       = new Account();
    public static List < ints__TransUnion_Credit_Report__c > listTransUnion = new List < ints__TransUnion_Credit_Report__c > ();
    //Credit Profile
    public static List < Credit_Profile__c > listcreditProfile = new List < Credit_Profile__c > ();
    
    //Enquiry Summary
    public static List < Enquiry_Summary__c > listenquirySummary = new List < Enquiry_Summary__c > ();
    
    //DerogatoryInformation Parent
    public static List < Derogatory_Information__c > listderogatoryInformationParent = new List < Derogatory_Information__c > ();
    
    //DerogatoryInformation Child
    public static List < Derogatory_Information__c > listderogatoryInformation = new List < Derogatory_Information__c > ();
    
    //OustandingBalancebyCF
    public static List < OustandingBalancebyCF__c > listOustandingBalancebyCF = new List < OustandingBalancebyCF__c > ();
    
    //Location Detail
    public static List < Location_Detail__c > listlocationDetail = new List < Location_Detail__c > ();
    
    //Relationship Detail
    public static List < Relationship_Detail__c > listRelationshipDetail = new List < Relationship_Detail__c > ();
    
    //Credit Facility Detail
    public static List < Credit_Facility_Detail__c > listCreditFacilityDetail = new List < Credit_Facility_Detail__c > ();
    
    //Message
    public static List < TU_Message__c > listMessage = new List < TU_Message__c > ();
    
    //TU CFHistory
    public static List < TU_CFHistory__c > listTUCFHistory = new List < TU_CFHistory__c > ();
    
    //TU IDs
    public static List < TU_ID_s__c > listTUIDs = new List < TU_ID_s__c > ();
    
    //RankVec
    public static List < RankVec__c > listRankVecObj = new List < RankVec__c > ();
    //Borrower Delinquency Report
    public static List<Borrower_Delinquency_Report__c> listBorrowerDelinquencyReport  = new List<Borrower_Delinquency_Report__c>();
    
    //Credit facility Details as Guarantor
    public static List<Credit_facility_Details_as_Guarantor__c> listCreditfacilityDetailsGuarantor    = new List<Credit_facility_Details_as_Guarantor__c>();
    
    //Guarantor Addesss
    public static List<Guarantor_Address__c> listGuarantorAddress     =   new List<Guarantor_Address__c>();
    
    //SuitFilled
    public static List<SuitFilled__c> listSuitFilled      =   new List<SuitFilled__c>();
    
    //Credit Rating Summary
    public static List<Credit_Rating_Summary__c>  listCreditRatingSummary     =   new  List<Credit_Rating_Summary__c>();
    
    //Summary of Credit Facility
    public static List<Summary_Credit_Facility__c> listSummaryCreditFacility  =   new List<Summary_Credit_Facility__c>();
    
    public static List<String> extIdList = new List<String>();
    
    //TU Error
    public static List<TU_Error__c> listTUError =   new List<TU_Error__c>();
    
    // For ID Segments
    //public static List<TU_ID_s__c> listIDsegments = new List<TU_ID_s__c>(); 
    // For telephone Segments
    public static List<TU_Telephone__c>    listTelephonesegment = new List<TU_Telephone__c>(); 
    // For EMail Segments
    public static List<TU_Email__c>    listEmailsegment = new List<TU_Email__c>(); 
    // For TU Account
    public static List<TU_Account__c>    listTUAccount = new List<TU_Account__c>(); 
    // For TU scores    
    public static List<TU_Score__c>   listTUscores= new List<TU_Score__c>();
    
    public static void getCommercialPR_EAE_Request(List<String> listCustId,String Type,String appId) {
        
        genesis__Applications__c appObject = [select id,Type__c,CommercialPR_Stage__c,BRE_Done__c,genesis__Account__c,genesis__Account__r.Pan_Number__c,genesis__Account__r.CBS_Customer_ID__c,RecordType.DeveloperName from genesis__Applications__c where Id =: appId];
        
        If(listCustId !=null && listCustId.size() > 0){
            
            for(String  custID  :   listCustId) {
                If(custID !=null){
                    extIdList.add(custID);
                    CommercialPR_EAE_Request commercialEAEObj   =   sendRequest(custID,Type,appId);
                    sendRequestAPIGEE(commercialEAEObj);
                }    
            }
        }
        
        If(listTransUnion.size() > 0){
            If(appObject != null && appObject.RecordType.DeveloperName !=  Constants.LAPLOAN && appObject.genesis__Account__r.Pan_Number__c !=null && appObject.genesis__Account__r.Pan_Number__c !=''){
                accCRILCObj     = WS_CRILC_API.getRequest(appObject.genesis__Account__r.Id, appObject.genesis__Account__r.Pan_Number__c);  
            }
        }else{
            If(appObject != null && appObject.RecordType.DeveloperName !=  Constants.LAPLOAN && appObject.genesis__Account__r.Pan_Number__c !=null && appObject.genesis__Account__r.Pan_Number__c !=''){
               accCRILCObj     = WS_CRILC_API.getRequest(appObject.genesis__Account__r.Id, appObject.genesis__Account__r.Pan_Number__c);  
            }
        }
        //Savepoint sp = Database.setSavepoint();
        try{
            If(listTUError !=null && listTUError.size() >0){
                System.debug('CommercialPR_EAE_Batch/listTUError=======> '+listTUError);
                insert listTUError;
                
            }
                If(listTransUnion.size() > 0){
                    System.debug('CommercialPR_EAE_Batch/listTransUnion=======> '+listTransUnion);
                    insert listTransUnion;
                    
                    If(appObject!=null && appObject.RecordType.DeveloperName != Constants.LAPLOAN){
                        
                        appObject.CommercialPR_Stage__c = Constants.COMPLETED;
                        ApplicationTriggerHandler.IsFirstRun = false;   
                        update appObject;
                        if(!appObject.BRE_Done__c && appObject.RecordType.DeveloperName !=  Constants.LAPLOAN){
                            SME_BRE_Score_Calculator.runBRERule(appObject,false);
                        } 
                    }
                    If(listcreditProfile.size() > 0)
                        insert listcreditProfile;
                    
                    If(listenquirySummary.size() > 0)
                        insert listenquirySummary;
                    
                    If(listderogatoryInformationParent.size() > 0)
                        insert listderogatoryInformationParent;
                    
                    If(listderogatoryInformation.size() > 0)
                        insert listderogatoryInformation;
                    
                    If(listOustandingBalancebyCF.size() > 0)
                        insert listOustandingBalancebyCF;
                    
                    If(listCreditfacilityDetailsGuarantor.size() > 0)
                        insert listCreditfacilityDetailsGuarantor;
                    
                    If(listlocationDetail.size() > 0)
                        insert listlocationDetail;
                    
                    If(listRelationshipDetail.size() > 0)
                        insert listRelationshipDetail;
                    
                    If(listCreditFacilityDetail.size() > 0)
                        insert listCreditFacilityDetail;
                    
                    If(listTUIDs.size() > 0)
                        insert listTUIDs;
                    
                    If(listRankVecObj.size() > 0)
                        insert listRankVecObj;
                    
                    If(listMessage.size() > 0)
                        insert listMessage;
                    
                    If(listGuarantorAddress.size()>0)
                        insert listGuarantorAddress; 
                    
                    If(listSuitFilled.size() > 0)
                        insert listSuitFilled;
                    
                    If(listCreditRatingSummary.size()>0)
                        insert listCreditRatingSummary;
                    
                    If(listSummaryCreditFacility.size()>0)
                        insert listSummaryCreditFacility;
                    
                    If(listTUCFHistory.size() > 0)
                        insert listTUCFHistory;
                    
                    If(listBorrowerDelinquencyReport.size() > 0)
                        insert listBorrowerDelinquencyReport;
                    
                    //for Individual
                    If(listTUscores !=null && listTUscores.size()>0){
                        insert listTUscores;
                    }
                    If(listTelephonesegment !=null && listTelephonesegment.size()>0){
                        insert listTelephonesegment;
                    }
                    If(listAccount.size()> 0){
                        AccountTriggerHandler.isAccountTrigger = false;
                        upsert listAccount CBS_Customer_ID__c;
                        
                        if(appObject !=null){
                            List<genesis__Application_Parties__c> listOfAppParty	=	[select id,genesis__Application__c,genesis__Party_Account_Name__c from genesis__Application_Parties__c where genesis__Application__c =: appObject.id AND Active__c = true];
                            Map<Id,Account> mapOfPartyAccount		=	new Map<Id,Account>();                            
                            if(listOfAppParty !=null && listOfAppParty.size() > 0){                                                                
                                for(Account	accObj	:	listAccount){                                                                        
                                    if(accObj.CIBIL_Score__c !=null && accObj.CIBIL_Status__pc !=null && accObj.CIBIL_Status__pc =='Complete'){
                                        mapOfPartyAccount.put(accObj.Id,accObj);
                                    }    
                                }
                                if(mapOfPartyAccount !=null && mapOfPartyAccount.size() > 0){
                                    for(genesis__Application_Parties__c appPartyObj : listOfAppParty){
                                        if(mapOfPartyAccount.containsKey(appPartyObj.genesis__Party_Account_Name__c)){
                                        	appPartyObj.CIBIL_Scores__c		=	mapOfPartyAccount.get(appPartyObj.genesis__Party_Account_Name__c).CIBIL_Score__c;    	    
                                        }    
                                    }    
                                }
                                update listOfAppParty;
                            }
                        }
                    }
                    
                }    
       
        }catch(Exception ex){
            
            //Database.rollback(sp);
            System.debug('Exception'+ ex.getMessage()+''+ex.getStackTraceString());
            System.debug('Line Number'+ex.getLineNumber());
        }
        //For CRILIC Data Update.
         try{
            If(accCRILCObj.id !=null){
                AccountTriggerHandler.isAccountTrigger = false;
                update accCRILCObj;
            }
        }catch(Exception Ex){
            System.debug('Exception'+ ex.getMessage());
            System.debug('Line Number'+ex.getLineNumber()); 
        }
    }
    public static CommercialPR_EAE_Request sendRequest(String CustId,String Type, String appId){
        
        CommercialPR_EAE_Request commercialEAEObj   =   CommercialPR_EAE_Request_Handler.getRequest(CustId,Type,appId);
        return commercialEAEObj;
    }
    public static void sendRequestAPIGEE(CommercialPR_EAE_Request commercialEAEObj){
        
        try{
            
            Map<String,String> headerMap                            = new Map<String,String>();
            
            headerMap.put('Content-Type','application/json');
            System.debug('=========>'+headerMap);
            headerMap.put('Authorization',WS_ApiGatewayAccToken.getAccTkn());
            
            HTTPResponse response                                       = new HTTPResponse();
            //String endPoint                                               = 'https://kvb-dev.apigee.net/next/v1/commercial/report';
            response = HttpUtility.sendHTTPRequest(Utility.getCommercialPR_APIGEE_Endpoint('CommercialPR_Apigee'), 'GET', null,JSON.serialize(commercialEAEObj),headerMap,null);
             
            If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                String jsonData                                     = response.getBody();
                CommercialPR_EAE_Response commercialObj             = CommercialPR_EAE_Response.parse(jsonData);
                If(commercialObj !=null) {
                    try{
                        CommercialPR_EAE_Response_Handler.getResponse(commercialObj);  
                    }catch(Exception ex){
                        System.debug(ex.getLineNumber());
                        System.debug(ex.getStackTraceString());
                    }   
                }
            }else{                
                throw new CustomException('Status Code-'+response.getStatusCode()+' Status-'+response.getStatus());
            }
            
        }catch(Exception ex){
            String error = ex.getMessage();
            System.debug('Error Message'+error);
            System.debug('Exception'+ex.getStackTraceString());
        } 
    }
    
}