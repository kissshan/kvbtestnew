/*
* Name      : WS_CBS_Create_CustID
* Compnay   : ET Marlabs
* Purpose   : For HL Service(Customer ID creation from CBS) 
* Author    : Subas
*/

public class WS_CBS_Create_CustID {
    @future (Callout=true)
    public Static void getCBSIDF(String AppId){
        getCBSID(AppId);
    }
    public Static Void getCBSID(String AppId){
        List <Account> accList = queryService.accList(AppId);
        Ws_CBS_CustdetailsModification.partymap(AppId);//............v1.1
        genesis__Applications__c application = new genesis__Applications__c();
        application = queryService.getApp(appId);        
        system.debug('####'+accList.size());        
        CBS_CustomerID_Creation_Handler cbs = new CBS_CustomerID_Creation_Handler();
        cbs.InputVariables  = new CBS_CustomerID_Creation_Handler.cls_inputVariables();
        CBS_CustomerID_Creation_Handler.cls_inputVariables cbsID = new CBS_CustomerID_Creation_Handler.cls_inputVariables();        
        cbsID.in_msg = new CBS_CustomerID_Creation_Handler.cls_in_msg();
        cbs.InputVariables=cbsID;        
        cbsID.in_msg.ApplicationId = AppId;
        cbsID.in_msg.serviceName = 'Customer_ID_Creation_HL';
        cbsID.in_msg.CustIDDetails = new List<CBS_CustomerID_Creation_Handler.cls_CustIDDetails>();
        for(Account acc : accList){
            if(acc.CBS_Customer_ID__c == null || acc.CBS_Customer_ID__c ==''){
                CBS_CustomerID_Creation_Handler.cls_CustIDDetails rq = new CBS_CustomerID_Creation_Handler.cls_CustIDDetails();
                rq.TransactionBranch = application.Branch_Code__c;
                rq.DOB = String.ValueOf(date.valueOf(acc.PersonBirthdate).format()) != null ? String.ValueOf(date.valueOf(acc.PersonBirthdate).format()) : ''; //'19821111';
                rq.NRICity = ''; 
                rq.NRIState = '';
                rq.busnstyp = '';
                rq.codCustIc = acc.Customer_IC__c.toUpperCase();
                rq.countryResidence = 'IN'; //
                rq.custtyp =  'RESIDENT INDIAN' ; //acc.Customer_Type__c;
                rq.empId = ''; 
                rq.fathername = acc.Father_Name__pc;
                rq.firstName = acc.FirstName;
                rq.flgStaff = 'N';
                rq.fullName = acc.Name;
                rq.gender = acc.Gender__pc;
                rq.husbandname = acc.Husband_Name__pc;
                rq.introId = ''; 
                rq.introcat = '1'; 
                rq.lang = 'Eng';
                rq.lastName = acc.LastName;
                rq.mailAddr1 = acc.PersonOtherStreet; //current
                rq.mailAddr2 = '.';
                rq.mailAddr3 = '.';
                rq.mailCity = acc.PersonOtherCity;//queryService.getCode(acc.PersonOtherCity,'3'); //
                rq.mailCtry = queryService.getCode(acc.PersonOtherCountry,'1'); //
                rq.mailEmail = acc.PersonEmail;
                string MobNumber;
                if(acc.PersonMobilePhone!=null && (acc.PersonMobilePhone).length()==12){
                    MobNumber = acc.PersonMobilePhone;
                }
                else if(acc.PersonMobilePhone!=null && (acc.PersonMobilePhone).length()==10){
                     MobNumber ='91'+acc.PersonMobilePhone;
                }
                else{
                    MobNumber='';
                }
                rq.mailMobno = MobNumber;
                rq.mailPhRes = acc.Phone;
                rq.mailPin = acc.PersonOtherPostalCode;
                rq.mailState = queryService.getCode(acc.PersonOtherState,'2'); //
                rq.maritalStatus = acc.Marital_Status__pc;
                rq.middleName = acc.MiddleName;
                rq.namePrefix = acc.PersonTitle!= null ? acc.PersonTitle.replace('.','') : ''; //required
                rq.nationality = 'IN';
                rq.nonCustType = '8';
                rq.nonCustdtls = 'KYC Provided';
     //         rq.proffCode = acc.CBS_Prof_Code__C;
                rq.proffCode =Ws_CBS_CustdetailsModification.partyMap.get(acc.id).CBS_Prof_Code__c; //............v1.1
                rq.shrtName = acc.Name; //doubt
                
                rq.spousename = acc.Spouse_Name__pc;
                rq.ApplicantID = acc.Id;
                cbsID.in_msg.CustIDDetails.add(rq); 
            }
        }
        
        callCUSTID(JSON.serialize(cbs),AppId);
    }
    //@future (Callout=true)
    public static void callCUSTID(string CustIDcr, String AppId){
        System.debug('#######'+CustIDcr);
        KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('CBS_Bulk_API');
        Map<String,String> headerMap                            = new Map<String,String>();
        headerMap.put('Content-Type','application/json');
        HTTPResponse response                                   = new HTTPResponse();
        String endPoint                                         = kvb.Endpoint_URL__c;
        response = HttpUtility.sendHTTPRequest(endPoint, 'POST', null,CustIDcr,headerMap,label.CA_CERTIFICATE);
        system.debug('#####'+response);
        system.debug('$$$$'+response.getBody());
        try{
            If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                String jsonString = response.getBody();            
                CBS_CustomerID_Creation_Handler.CBS_CustomerID_Creation_response res = (CBS_CustomerID_Creation_Handler.CBS_CustomerID_Creation_response)Json.deserialize(jsonString,CBS_CustomerID_Creation_Handler.CBS_CustomerID_Creation_response.class);
                System.debug(res);
                if(res.out_msg.Status_Desc != 'Success'){
                    CBS_API_Log__c log = new CBS_API_Log__c();    
                    log.Application__c = AppId;
                    log.API_Name__c = 'Customer_ID_Creation_HL';
                    log.Status__c = 'Failure';
                    log.Success_Error_Message__c = res.out_msg.Status_Desc;
                    log.Sequence_No__c = '3';  
                    insert log; 
                }			
            }else{
                    CBS_API_Log__c log = new CBS_API_Log__c();    
                    log.Application__c = AppId;
                    log.API_Name__c = 'Customer_ID_Creation_HL';
                    log.Status__c = 'Failure';
                    log.Success_Error_Message__c = 'CustomerIdCreation_CBS_Error_No_Hit';
                    log.Sequence_No__c = '3';  
                    insert log;             
            }
        }catch(Exception e){
            HandleBusinessException.captureError('Customer_ID_Creation_HL','callCUSTID', e);
        }    
    }
}