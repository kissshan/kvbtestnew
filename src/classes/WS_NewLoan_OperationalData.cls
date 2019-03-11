/*
 * Name     : WS_NewLoan_OperationalData
 * Company  : ET Marlabs
 * Purpose  : Get Operational Data through customer id for New Loan Application. 
 * Author   : Raushan
*/

public class WS_NewLoan_OperationalData {
    
    public static void getRequest(String CbsCustId){
        If(CbsCustId !=null && CbsCustId !=''){
            try{
                Map<String,String> headerMap            = new Map<String,String>();
                headerMap.put('Content-Type','application/json');
                HTTPResponse response                   = new HTTPResponse();
                
                WS_NewLoan_OperationalData.Request_Structure requestObj	=   new WS_NewLoan_OperationalData.Request_Structure();
                requestObj.exe_tenantId					= 	'cuecent_tenant';
                requestObj.owner_tenantId 				= 	'cuecent_tenant';
                requestObj.inputVariables				=	new WS_NewLoan_OperationalData.cls_inputVariables();
                requestObj.inputVariables.in_msg		=	new WS_NewLoan_OperationalData.cls_in_msg();
                requestObj.inputVariables.in_msg.CustId	=   CbsCustId;
                
                //String endUrlPoint	= 'http://kvbbank.net/ext_bpms/rest/CueRest/invokeESBService/FCR_OPR_DATA_CUST';
                response	 		= HttpUtility.sendHTTPRequest(Utility.getEndpoint('NewLoan_OperationalData'), 'POST', null,JSON.Serialize(requestObj),headerMap,label.CA_CERTIFICATE);
                
                if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                    String jsonString	=  response.getBody();
                    System.debug('Json Structure'+jsonString);
                    OperationalData_response opdResponseObj	= OperationalData_response.parse(jsonString);
                    If(opdResponseObj !=null){
                        Map<String,String> resDetail;
                        /*Added for TL New Loan - Start*/
                        map<String,String> accMap= new map<String,String>();
                        OperationalData_response.cls_AccountNumber accNumData= opdResponseObj.out_msg.AccountNumber;
                        if(accNumData!=null){
                            String allAccNo='';
                            for(Integer i=0; i< accNumData.CustAccNo.size(); i++ ){//cls_CustAccNo accNo: accNumData.CustAccNo){
                                if(i!=(accNumData.CustAccNo.size()-1)){
                                    allAccNo= allAccNo+accNumData.CustAccNo[i].AccountNo+';';
                                }else{
                                    allAccNo= allAccNo+accNumData.CustAccNo[i].AccountNo;
                                }
                            }
                            if(allAccNo!=null)
                                accMap.put(accNumData.CustomerID,allAccNo);

                        }
                        /*Added for TL New Loan - End*/
                        for(OperationalData_response.cls_Operational_Data opData : opdResponseObj.out_msg.Operational_Data){
                            resDetail = new Map<String,String>();
                            resDetail = OperationalDataChange_Helper.handleOpsData(opData);
                            if(accMap.size()>0)
                            OperationalDataChange_Helper.insertOpsData(opData,accMap);
                        }
                    }
                    }else{
                        throw new CustomException('Status Code-'+response.getStatusCode()+' Status-'+response.getStatus());
                    }
               
                }catch(Exception ex){
                    System.debug('Exception'+ex.getStackTraceString());
                    System.debug('Message'+ex.getMessage());
                }
            }
    }
    public class Request_Structure {
        public String exe_tenantId;
        public String owner_tenantId;
        public cls_inputVariables inputVariables;
    } 
    public class cls_inputVariables {
        public cls_in_msg in_msg;
    }
    public class cls_in_msg {
        public String CustId;
    }
   
}