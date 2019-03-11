/*
* Name      : WS_EthicsCall
* Compnay   : ET Marlabs
* Purpose   : For Ethics Data(Consume the data from MiddleWare). 
* Author    : Raushan
*/ 
global with sharing class WS_EthicsCall {
    //Soap Method.
    webservice static void getEthicsInfo(String accid){
        
        If(accid !=null){
            Account acc                         = SOQL_Util.getAccountAudit(accid);
            EthicsRequest erObj                 = getEthicsAcc(acc);
            String Response                     = getEthicsRes(erObj,acc);
            system.debug(erObj);
        }
    }
    // Get Request Body.  
    public static EthicsRequest getEthicsAcc(Account acc) {
        EthicsRequest erObj                         = new EthicsRequest();
        erObj.exe_tenantId                          = 'cuecent_tenant';
        erObj.owner_tenantId                        = 'cuecent_tenant';
        erObj.inputVariables                        = new EthicsRequest.cls_inputVariables();
        erObj.inputVariables.in_msg                 = new EthicsRequest.cls_in_msg();
        erObj.inputVariables.in_msg.REQ_APP         = '';
        erObj.inputVariables.in_msg.REQ_DATE        = '';
        erObj.inputVariables.in_msg.REQ_TIME        = '';
        erObj.inputVariables.in_msg.Branch_Code     = acc.Branch_Code__c;
        erObj.inputVariables.in_msg.Customer_ID     = acc.CBS_Customer_ID__c;
        erObj.inputVariables.in_msg.GL_Date         = Utility.dateFormatter();
            //String.valueOf(Date.newInstance(Utility.getCurrentYear(), 03, 31));       
        return erObj;
    }
    // Response Body.  
    public static string getEthicsRes(EthicsRequest erObj,Account acc) {
        
        try{
            Map<String,String> headerMap            = new Map<String,String>();
            headerMap.put('Content-Type','application/json');
            HTTPResponse response                   = new HTTPResponse();
            system.debug('JSON.serialize(erObj)'+JSON.serialize(erObj));
            String endPoint                         = Utility.getEndpoint('Ethics Data');
            response = HttpUtility.sendHTTPRequest(endPoint, 'POST', null,JSON.serialize(erObj),headerMap,label.CA_CERTIFICATE);
            System.debug('response'+response.getBody());
            System.debug('response code'+response.getStatusCode());
            if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                String jsonData = response.getBody();
                EthicsResponse eresObj = EthicsResponse.parse(jsonData);
                List<Audit__c> listaudit   = new List<Audit__c>();
                if(eresObj !=null) {
                    EthicsResponse.cls_out_msg outMsgObj    = eresObj.out_msg;
                    If(outMsgObj !=null) {
                             Audit__c    audit                  =   new Audit__c();
                             audit.Account_Name__c              =   acc.id;
                        If(!Utility.ISStringBlankorNull(outMsgObj.ErrorMessage)){
                             audit.Error_Message__c             =   outMsgObj.ErrorMessage;
                            }
                        listaudit.add(audit);
                        
                        List<EthicsResponse.cls_Ethics_Response>  listEthicsRes   = outMsgObj.Ethics_Response;
                        if(listEthicsRes != null && listEthicsRes.size() > 0) {
                            for(EthicsResponse.cls_Ethics_Response eres : listEthicsRes){   
                                listaudit.add(getEthicsObj(eres));
                            }
                        }
                        If(listaudit.size() > 0){
                          //System.debug('List of Audit--->'+listaudit);
                            insert listaudit;  
                        }
                            
                    }   
                }
                
            }else{
                
                throw new CustomException('Status Code-'+response.getStatusCode()+' Status-'+response.getStatus());
            }
            return 'success';
        }catch(Exception ex){
            String error = ex.getMessage();
            system.debug('exception :--'+ex.getLineNumber() +'exception message:-'+error+ 'stact trace:-'+ex.getStackTraceString() );
            return error;
            
        }
        
    }
    
    public static Audit__c getEthicsObj(EthicsResponse.cls_Ethics_Response eres){
        Audit__c    audit                   =   new Audit__c();
        If(!Utility.ISStringBlankorNull(eres.Branch_Code))
            audit.Branch_Code__c            =   eres.Branch_Code;
        If(!Utility.ISStringBlankorNull(eres.Branch_Name))
            audit.Branch_Name__c            =   eres.Branch_Name;
        If(!Utility.ISStringBlankorNull(eres.Account_Name))
            audit.Account_Name__c           =   eres.Account_Name;
        If(!Utility.ISStringBlankorNull(eres.Account_Number))
            audit.Account_Number__c         =   eres.Account_Number;
        If(!Utility.ISStringBlankorNull(String.valueOf(eres.GL_Date)))
            audit.GL_Date__c                =   Date.valueOf(eres.GL_Date);
        If(!Utility.ISStringBlankorNull(String.valueOf(eres.Balance_OutStanding)))
            audit.Balance_Outstanding__c    =   Double.valueOf(eres.Balance_OutStanding);
        If(!Utility.ISStringBlankorNull(String.valueOf(eres.AUD_Point)))
            audit.Audit_Point__c            =   String.valueOf(eres.AUD_Point);
        If(!Utility.ISStringBlankorNull(eres.PROD_Desc))
            audit.Product_Description__c    =   eres.PROD_Desc;
        If(!Utility.ISStringBlankorNull(eres.Regularity))
            audit.Regularity__c             =   eres.Regularity;
        If(!Utility.ISStringBlankorNull(eres.Addtnl_Comment))
            audit.Additional_Comment__c     =  eres.Addtnl_Comment;
        return audit;
    }
    //Delete all child facility under the Application on click of 'Delete existing rule'
     webservice static void deleteChildFacilities(String appId){
        If(appId !=null){
            List<Facility__c> childFacilityList = new List<Facility__c>();
            childFacilityList = [SELECT Id FROM Facility__c WHERE facility__r.Application__c =: appId AND RecordType.DeveloperName = 'Child'];
            if(!childFacilityList.isEmpty()){
                DELETE childFacilityList;
            }
        }
    }
    //Run SanctionMatrix_Calc_Batch batch 
    webservice static void runSanctionMatrixBatch(String appId){ 
        System.debug('Batch Execution started!!!');
        Database.executeBatch(new SanctionMatrix_Calc_Batch(appId));
    }
    //Run doc generation from btton click 
    /*webservice static void btnDigioDocGeneration(String appId){ 
        SME_Digio_Service.docGenAndSignDoc(appId);
    } */
}