/* 
* Name     : WS_MCLR_Master
* Purpose  : Formatter class to prepare request/response structure for MCLR master sync
* Company  : ET Marlabs
* Author   : Dushyant
*/
public class WS_MCLR_Master {
    public static void masterRequest(){
        try{
            List<MCLR_Master__c> mclrList = new List<MCLR_Master__c>();
            WS_MCLR_Master.RequestFormat req = new WS_MCLR_Master.RequestFormat();
            req.exe_tenantId        = 'cuecent_tenant';
            req.owner_tenantId      = 'cuecent_tenant';
            req.inputVariables      = new WS_MCLR_Master.cls_inputVariables();
            
            Map<String,String> headerMap                            = new Map<String,String>();
            headerMap.put('Content-Type','application/json');
            HTTPResponse response                                   = new HTTPResponse();
            
            for(Integer retryCount = 0;retryCount < 3; retryCount++){
                try{
                    response = HttpUtility.sendHTTPRequest(Utility.getEndpoint('MCLR_MASTER_API'), 'POST', null,JSON.serialize(req),headerMap,label.CA_CERTIFICATE);
                    String jsonResString = response.getBody();
                    If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                        WS_MCLR_Master.ResponseFormat res = (WS_MCLR_Master.ResponseFormat)Json.deserialize(jsonResString,WS_MCLR_Master.ResponseFormat.class);
                        DELETE [SELECT Id FROM MCLR_Master__c];
                        if(res.out_msg.ErrorCode == '0'){
                            for(cls_MCLR_Intrest mclrData : res.out_msg.MCLR_Intrest){
                                MCLR_Master__c mclr = new MCLR_Master__c();
                                If(!Utility.ISStringBlankorNull(mclrData.COD_MCLR_INDX))
                                    mclr.Int_ID__c = Decimal.valueOf(mclrData.COD_MCLR_INDX);
                                If(!Utility.ISStringBlankorNull(mclrData.COD_TERM_FROM))
                                    mclr.COD_Term_From__c = Decimal.valueOf(mclrData.COD_TERM_FROM);
                                If(!Utility.ISStringBlankorNull(mclrData.COD_TERM_TO))
                                    mclr.COD_Term_To__c = Decimal.valueOf(mclrData.COD_TERM_TO);
                                If(!Utility.ISStringBlankorNull(mclrData.RAT_MCLR_INDX))
                                    mclr.MCLR_Of_Interest__c = Decimal.valueOf(mclrData.RAT_MCLR_INDX);
                                If(!Utility.ISStringBlankorNull(mclrData.COD_PROD_TYP))
                                    mclr.COD_prod_type__c = mclrData.COD_PROD_TYP;
                                If(!Utility.ISStringBlankorNull(mclrData.DAT_EFFECTIVE))
                                    mclr.Effective_Date__c = Date.valueOf(mclrData.DAT_EFFECTIVE);
                                mclrList.add(mclr);
                            }
                        }
                        else throw new CustomException('Error occured in response while fetching MCLR master data!!!!');   
                        
                        if(!mclrList.isEmpty()){
                            INSERT mclrList;
                            break;
                        } 
                    }
                }catch(Exception e){
                    System.debug(e.getStackTraceString());
                    if(retryCount == 2){
                        //Send Email
                        Utility.sendEmail('MCLR Master ',e.getMessage());
                        break;
                    }
                }
                
                if(retryCount == 2){
                    //Send Email
                    Utility.sendEmail('MCLR master ', 'Retry Failed'); 
                    break;
                }
            }
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
            throw new CustomException('MCLR_MASTER_SYNC_NO_HIT');
        }
    }
    
    //Request Format
    public class RequestFormat{
        public String exe_tenantId; //cuecent_tenant
        public String owner_tenantId;   //cuecent_tenant
        public cls_inputVariables inputVariables;
    }
    public class cls_inputVariables {}
    
    //Response Format
    public class ResponseFormat{
        public String bpms_error_code;  //00
        public String bpms_error_msg;   //Success
        public cls_out_msg out_msg;
    }
    
    public class cls_out_msg {
        public String HttpStatus;   //500
        public String ErrorCode;    //MW9999
        public String ErrorMessage; //TECHNICAL ERROR
        public cls_MCLR_Intrest[] MCLR_Intrest;
    }
    public class cls_MCLR_Intrest {
        public String COD_MCLR_INDX;    //9994
        public String COD_TERM_FROM;    //0
        public String COD_TERM_TO;  //29
        public String RAT_MCLR_INDX;    //8.3
        public String COD_PROD_TYP; //CH
        public String DAT_EFFECTIVE;    //2018-03-07 00:00:00.0
    }
}