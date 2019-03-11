/*
* Name          : WS_Perfios_Get_Operational_Data
* Description   : API for push final Operational Data. 
* Author        : Raushan Abhishek
*/

global class WS_Perfios_Get_Operational_Data {
    
   public static List<Operations_Detail__c> listOfOperatinalData 	=	new List<Operations_Detail__c>();
   public static List<Operations_Detail__c> updateOperatinalData 	=	new List<Operations_Detail__c>(); 
   public static Map<String,List<Operations_Detail__c>> MapOflistOperatinalData 	=	new  Map<String,List<Operations_Detail__c>>(); 
   
   public static boolean sendRequest(String TxnId,String appId, String perfiosId){
        boolean isPerfiosCompleted = false;
        genesis__Applications__c appObj =   new genesis__Applications__c();
        try{
            Perfios__c 	perfiosObject 		= new Perfios__c();
             If(TxnId !=null && TxnId !='' && appId !=null && appId !='' && perfiosId !=null && perfiosId !=''){
                  appObj	= [select id,BRE_Done__c,genesis__Account__c from genesis__Applications__c where id =:appId];
                 MapOflistOperatinalData = getPerfiosResponse(TxnId,appObj.genesis__Account__c,perfiosId);
                 If(MapOflistOperatinalData == null){
                     return true;
                 }
                 If(!MapOflistOperatinalData.isEmpty()){
                     If(MapOflistOperatinalData.containsKey('Insert')){
                         listOfOperatinalData = MapOflistOperatinalData.get('Insert');
                         System.debug('List of OperationalData Insertion'+listOfOperatinalData);
                     }
                     If(MapOflistOperatinalData.containsKey('Update')){
                        updateOperatinalData =  MapOflistOperatinalData.get('Update');
                        System.debug('List of OperationalData Update'+updateOperatinalData); 
                     }
                 }
             }
            
            If(listOfOperatinalData.size() > 0){
               insert listOfOperatinalData;
               isPerfiosCompleted = true; 
            }
            If(updateOperatinalData.size() > 0){
                update updateOperatinalData;
                isPerfiosCompleted = true;
            }
            If(isPerfiosCompleted && perfiosId !=null && perfiosId !=''){
               genesis__Applications__c appObject =   new genesis__Applications__c(); 
               perfiosObject.Id	=	(Id)perfiosId;
               perfiosObject.Perfios_Status__c	= 'Completed';
               perfiosObject.Failure_Reason__c  = '';
               perfiosObject.Error_Message__c   = '';
                If(appId !=null && appId !=''){
                    appObject.Id = (id)appId;
                    appObject.Sub_Stage__c = 'Application Created';
                } 
                If(Perfios_New_SME_Response_Handler.BANK_NAME !=null && Perfios_New_SME_Response_Handler.BANK_NAME != ''){
                	perfiosObject.Bank_Name__c 	=	Perfios_New_SME_Response_Handler.BANK_NAME;   
                } 
               update perfiosObject;
                if(appObject.id !=null){
                	update appObject;    
                } 
               if(appObj.id !=null && !appObj.BRE_Done__c){
                    SME_BRE_Score_Calculator.runBRERule(appObj,false);
                }  
            }
        }catch(Exception Ex){
          System.debug('Exception'+ex.getStackTraceString()); 
          System.debug('Exception Message'+ex.getMessage());  
        }
        return false;
    }

    public static Map<String,List<Operations_Detail__c>> getPerfiosResponse(String TxnId,String CustSFId,String perfiosId){
        Perfios__c 	perfiosObject 		= new Perfios__c();
        try{
            If(TxnId !=null && TxnId !='' && CustSFId !=null && CustSFId !=''){
                
                WS_Perfios_Get_Operational_Data.Request_Structure requestObj = new WS_Perfios_Get_Operational_Data.Request_Structure();
                requestObj.clientTxnId         = TxnId;
                Map<String,String> headerMap   = new Map<String,String>();
                headerMap.put('Authorization',WS_ApiGatewayAccToken.getAccTkn());
                //String endPoint = 'https://kvb-test.apigee.net/next/v1/analysis/offline/statement/report?txnId=';
                
                HttpResponse response  = new HttpResponse();
                response = HttpUtility.sendHTTPRequest(Utility.getFullEndpoints('Perfios SME New Loan')+requestObj.clientTxnId+'&reportFormat=json','GET',null, null,headerMap,null);
                
                If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                    String jsonData             = response.getBody();
                    System.debug('Json'+jsonData);
                    Perfios_New_SME_Response perfiosResObj = Perfios_New_SME_Response.parse(jsonData);
                    If(perfiosResObj !=null){
                        try{
                            Perfios_New_SME_Response_Handler.insertPerfiosdata(perfiosResObj,CustSFId);
                            Map<String,List<Operations_Detail__c>> mapOfPerfios = Perfios_New_SME_Response_Handler.getPerfiosData(perfiosResObj,CustSFId);
                            return mapOfPerfios;
                            
                        }catch(Exception ex){
                            System.debug(ex.getLineNumber());
                            System.debug(ex.getStackTraceString());
                            System.debug(ex.getMessage());
                        } 
                    }
                }else if(response.getStatusCode() == 202){
                    String jsonData             = response.getBody();
                    Error_Structure errorObj = (Error_Structure)System.JSON.deserialize(jsonData, Error_Structure.class);
                    perfiosObject.Id	=	(Id)perfiosId;
                    perfiosObject.Perfios_Status__c	= 'Perfios Pending Process';
                    If(!Utility.ISStringBlankorNull(errorObj.code))	
                    	perfiosObject.Failure_Reason__c	    = errorObj.code;
                    If(!Utility.ISStringBlankorNull(errorObj.message))	
                    	perfiosObject.Error_Message__c	    = errorObj.message;
                    
                    Map<String,List<Operations_Detail__c>> mapOfPerfios	=	new Map<String,List<Operations_Detail__c>>();
                    update perfiosObject;
                    
                    return mapOfPerfios;
                }else{
                    String jsonData             = response.getBody();
                    Error_Structure errorObj = (Error_Structure)System.JSON.deserialize(jsonData, Error_Structure.class);
                    perfiosObject.Id	=	(Id)perfiosId;
                    perfiosObject.Perfios_Status__c	= 'Error';
                    If(!Utility.ISStringBlankorNull(errorObj.errorCode))	
                    	perfiosObject.Failure_Reason__c	    = errorObj.errorCode;
                    If(!Utility.ISStringBlankorNull(errorObj.errorMessage))	
                    	perfiosObject.Error_Message__c	    = errorObj.errorMessage;
                    
                    update perfiosObject;
                    //Map<String,List<Operations_Detail__c>> mapOfPerfios	=	new Map<String,List<Operations_Detail__c>>();
                    //return mapOfPerfios;
                    throw new CustomException('Status Code-'+response.getStatusCode()+' Status-'+response.getStatus());
                }
            }
            
        }catch(Exception ex){
            
        }
        return null;
    }
    
    public class Request_Structure{
        public String clientTxnId;
    }
    public class Error_Structure{
        public String code;
        public String message;
        public String errorCode;
        public String errorMessage;
        
    }
}