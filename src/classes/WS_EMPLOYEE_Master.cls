/* 
* Name     : WS_EMPLOYEE_Master
* Purpose  : Formatter class to prepare request/response structure for EMPLOYEE master sync
* Company  : ET Marlabs
* Author   : Dushyant
*/
public class WS_EMPLOYEE_Master {
    public static void masterRequest(){
        try{
            Map<String,User> empCodeUserMap =new Map<String,User>();
            List<User> empMasterList = new List<User>();
            List<String> empCodeList = new List<String>();
            WS_EMPLOYEE_Master.RequestFormat req = new WS_EMPLOYEE_Master.RequestFormat();
            req.exe_tenantId = 'cuecent_tenant';
            req.owner_tenantId = 'cuecent_tenant';
            req.inputVariables  = new WS_EMPLOYEE_Master.cls_inputVariables();
            
            Map<String,String> headerMap                            = new Map<String,String>();
            headerMap.put('Content-Type','application/json');
            HTTPResponse response                                   = new HTTPResponse();
            
            
            for(Integer retryCount = 0;retryCount < 3; retryCount++){
                try{
                    response = HttpUtility.sendHTTPRequest(Utility.getEndpoint('EMP_MASTER_API'), 'POST', null,JSON.serialize(req),headerMap,label.CA_CERTIFICATE);
                    String jsonResString = response.getBody();
                    If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                        WS_EMPLOYEE_Master.ResponseFormat res = (WS_EMPLOYEE_Master.ResponseFormat)Json.deserialize(jsonResString,WS_EMPLOYEE_Master.ResponseFormat.class);
                        if(res.out_msg.ErrorCode == '0'){
                            for(Employee_Master empdata : res.out_msg.Employee_Master){
                                empCodeList.add(empdata.V_EMP_CODE);
                            }
                        }else throw new CustomException('Error occured in response while fetching EMPLOYEE master data!!!!');   
                        
                        if(!empCodeList.isEmpty()){
                            for(user ur : [SELECT Id,Name,Office_Code__c,Division,Branch_Name__c,EmployeeNumber,FirstName,LastName FROM User WHERE EmployeeNumber IN : empCodeList]){
                                if(!Utility.ISStringBlankorNull(ur.EmployeeNumber)){
                                    empCodeUserMap.put(ur.EmployeeNumber,ur);
                                }
                                
                            }
                            for(Employee_Master empdata : res.out_msg.Employee_Master){
                                if(empCodeUserMap.get(empdata.V_EMP_CODE) != null){
                                    If(!Utility.ISStringBlankorNull(empdata.V_BRANCH_CODE))
                                        empCodeUserMap.get(empdata.V_EMP_CODE).Office_Code__c = empdata.V_BRANCH_CODE;
                                    If(!Utility.ISStringBlankorNull(empdata.V_BRANCH_NAME))
                                        empCodeUserMap.get(empdata.V_EMP_CODE).Branch_Name__c = empdata.V_BRANCH_NAME;
                                    If(!Utility.ISStringBlankorNull(empdata.V_LOGIV_DIV))
                                        empCodeUserMap.get(empdata.V_EMP_CODE).Division = empdata.V_LOGIV_DIV;
                                }
                            }
                            System.debug(empCodeUserMap.values().size());
                            if(!empCodeUserMap.isEmpty()){
                                UPDATE empCodeUserMap.values();
                            } 
                            break;
                        }
                        
                    }
                }catch(Exception e){
                    System.debug(e.getStackTraceString());
                    if(retryCount == 2){
                        //Send Email
                        System.debug('Inside Catch Count 2');
                        Utility.sendEmail('Employee Master ',e.getMessage());
                        break;
                    }
                }
                
                if(retryCount == 2){
                    //Send Email
                    System.debug('Inside Count 2');
                    Utility.sendEmail('Employee Master ', 'Retry Failed'); 
                    break;
                }
            }  
        }Catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
            Utility.sendEmail('Employee Master ', 'Retry Failed');
            //throw new CustomException('Error occured in response while fetching EMPLOYEE master data!!!!'); 
        }  
    }
    
    //Request Format
    public class RequestFormat{
        public String exe_tenantId;	//cuecent_tenant
        public String owner_tenantId;	//cuecent_tenant
        public cls_inputVariables inputVariables;
    }
    public class cls_inputVariables{}
    
    //Response Format
    public class ResponseFormat{
        public String bpms_error_code;
        public String bpms_error_msg;
        public Out_msg out_msg;
    }
    public class Out_msg {
        public String HttpStatus;
        public String ErrorCode;
        public String ErrorMessage;
        public List<Employee_Master> Employee_Master;
    }
    public class Employee_Master {
        public String V_BRANCH_CODE;
        public String V_BRANCH_NAME;
        public String V_EMP_CODE;
        public String V_EMP_NAME;
        public String V_LOS_ROLE;
        public String V_LOGIV_DIV;
    }
}