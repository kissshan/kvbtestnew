/* 
* Name     : WS_BRANCH_MASTER
* Purpose  : Formatter class to prepare request/response structure for BRANCH master sync
* Company  : ET Marlabs
* Author   : Dushyant
*/
public class WS_BRANCH_MASTER {
    public static void masterRequest(){
        try{
            List<Branch_Master__c> otherBranchMaster        = new List<Branch_Master__c>();
            List<Branch_Master__c> branchMasterList         = new List<Branch_Master__c>();
            List<String> branchCodeList                     = new List<String>();
            
            WS_BRANCH_MASTER.RequestFormat req = new WS_BRANCH_MASTER.RequestFormat();
            req.exe_tenantId        = 'cuecent_tenant';
            req.owner_tenantId      = 'cuecent_tenant';
            req.inputVariables      = new WS_BRANCH_MASTER.cls_inputVariables();
            
            Map<String,String> headerMap                            = new Map<String,String>();
            headerMap.put('Content-Type','application/json');
            HTTPResponse response                                   = new HTTPResponse();
            //System.debug(jsonResString);
            for(Integer retryCount = 0;retryCount < 3; retryCount++){
                System.debug('retryCount===>'+retryCount);
                response = HttpUtility.sendHTTPRequest(Utility.getEndpoint('BRANCH_MASTER_API'), 'POST', null,JSON.serialize(req),headerMap,label.CA_CERTIFICATE);
                If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                    try{
                        String jsonResString = response.getBody();
                        WS_BRANCH_MASTER.ResponseFormat res = (WS_BRANCH_MASTER.ResponseFormat)Json.deserialize(jsonResString,WS_BRANCH_MASTER.ResponseFormat.class);
                        if(res.out_msg.ErrorCode == '0'){
                            for(cls_Branch_Master branchData : res.out_msg.Branch_Master){
                                Branch_Master__c branch = new Branch_Master__c();
                                If(!Utility.ISStringBlankorNull(branchData.V_BRANCH_CODE)){
                                    branchCodeList.add(branchData.V_BRANCH_CODE);
                                    branch.CODCCBRN__c = branchData.V_BRANCH_CODE;
                                }
                                If(branchData.D_OPENING_DT != null)
                                    branch.Branch_Opening_Date__c = Date.valueOf(branchData.D_OPENING_DT);
                                If(!Utility.ISStringBlankorNull(branchData.V_BRANCH_NAME))
                                    branch.NAM_BRANCH__c = branchData.V_BRANCH_NAME;
                                If(!Utility.ISStringBlankorNull(branchData.V_STATE))
                                    branch.State__c = branchData.V_STATE;
                                If(!Utility.ISStringBlankorNull(branchData.V_DIV))
                                    branch.Division__c = branchData.V_DIV;
                                If(!Utility.ISStringBlankorNull(branchData.V_CATEG))
                                    branch.Category__c = branchData.V_CATEG;
                                If(!Utility.ISStringBlankorNull(branchData.ADDRESS1))
                                    branch.Address1__c = branchData.ADDRESS1;
                                If(!Utility.ISStringBlankorNull(branchData.ADDRESS2))
                                    branch.Address2__c = branchData.ADDRESS2;
                                If(!Utility.ISStringBlankorNull(branchData.ADDRESS2))
                                    branch.Address3__c = branchData.ADDRESS3;
                                If(!Utility.ISStringBlankorNull(branchData.CITY))
                                    branch.NAMCCCITY__c = branchData.CITY;
                                If(!Utility.ISStringBlankorNull(branchData.STATE))
                                    branch.State__c = branchData.STATE;
                                If(!Utility.ISStringBlankorNull(branchData.PINCODE))
                                    branch.Pincode__c = branchData.PINCODE;
                                If(!Utility.ISStringBlankorNull(branchData.MANAGER_SALUTATION))
                                    branch.Manager_salutation__c = branchData.MANAGER_SALUTATION;
                                If(!Utility.ISStringBlankorNull(branchData.MANAGER_NAME))
                                    branch.Manager_name__c = branchData.MANAGER_NAME;
                                If(!Utility.ISStringBlankorNull(branchData.MANAGER_SCALE))
                                    branch.Manager_scale__c = branchData.MANAGER_SCALE;
                                If(!Utility.ISStringBlankorNull(branchData.RETAIL_CATEGORY))
                                    branch.Retail_Category__c= branchData.RETAIL_CATEGORY;
                                If(!Utility.ISStringBlankorNull(branchData.EMAIL)){
                                    if(branchData.EMAIL.contains(';')){
                                        branch.Email__c = branchData.EMAIL.split(';')[0];
                                    }
                                    else
                                        branch.Email__c = branchData.EMAIL;
                                }
                                
                                If(!Utility.ISStringBlankorNull(branchData.BRANCH_OFFICE))
                                    branch.Branch_Office__c = branchData.BRANCH_OFFICE;
                                If(!Utility.ISStringBlankorNull(branchData.IFSC_CODE))
                                    branch.IFSC_Code__c = branchData.IFSC_CODE;
                                branch.Active__c = true;
                                branchMasterList.add(branch);
                            } 

                        }
                        
                        if(!branchMasterList.isEmpty()){
                            UPSERT branchMasterList CODCCBRN__c;
                            otherBranchMaster = [SELECT Id,Active__c,CODCCBRN__c 
                                                 FROM Branch_Master__c 
                                                 WHERE CODCCBRN__c NOT IN :branchCodeList];
                            
                            if(!otherBranchMaster.isEmpty()){
                                for(Branch_Master__c branch : otherBranchMaster){
                                    branch.Active__c = false;
                                }
                                UPDATE otherBranchMaster;
                                
                            }  
                            break;
                        }  
                        
                    }catch(Exception e){
                        System.debug(e.getStackTraceString());
                        if(retryCount == 2){
                            //Send Email
                            Utility.sendEmail('Branch Master',e.getMessage());
                            break;
                        }
                    }   
                }
                
                if(retryCount == 2){
                    //Send Email
                    Utility.sendEmail('Branch Master','Retry Failed');
                    break;
                }
            }
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
            System.debug('e.getStackTraceString()---->'+e.getStackTraceString());
            throw new CustomException('Error occured in response while fetching BRANCH master data!!!!'+e.getMessage()+'--'+e.getStackTraceString());
        }
    }
    
    //Request Format
    public class RequestFormat{
        public String exe_tenantId;  //cuecent_tenant
        public String owner_tenantId;  //cuecent_tenant
        public cls_inputVariables inputVariables;
    }
    public class cls_inputVariables {}
    
    //Response Format
    public class ResponseFormat{
        public String bpms_error_code;  //00
        public String bpms_error_msg;  //Success
        public cls_out_msg out_msg;
    }
    public class cls_out_msg {
        public String HttpStatus;  //500
        public String ErrorCode;  //MW9999
        public String ErrorMessage;  //TECHNICAL ERROR
        public cls_Branch_Master[] Branch_Master;
    }
    public class cls_Branch_Master {
        public String V_BRANCH_CODE;  //1101
        public String D_OPENING_DT;  //1110652200000
        public String V_BRANCH_NAME;  //CENTRAL OFFICE
        public String V_STATE;  //T
        public String V_DIV;  //CENTRAL OFFICE
        public String V_CATEG;  //S
        public String ADDRESS1;  //POST BOX NO. 21,
        public String ADDRESS2;  //ERODE ROAD,
        public String ADDRESS3;  //ERODE ROAD,
        public String CITY;  //KARUR
        public String STATE;  //TAMIL NADU
        public String PINCODE;  //639002
        public String MANAGER_SALUTATION;  //Mr.
        public String MANAGER_NAME;  //SESHADRI P R - MD and CEO
        public String EMAIL;  //kvbcs@kvbmail.com
        public String BRANCH_OFFICE;  //C.O.      
        public String IFSC_CODE;  //KVBL0001101
        public String MANAGER_SCALE;  //KVBL0001101
        Public String RETAIL_CATEGORY;
    }
    
}