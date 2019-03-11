/*
 * Name     : WS_SMECustomerListFetch
 * Company  : ET Marlabs
 * Purpose  : This class is used to get SME Customer's list which are ready for renewal.
 * Author   : Amritesh
*/

@RestResource(urlMapping='/renewalCustomerList')

global with sharing class WS_SMECustomerListFetch {

    global class Response extends WS_Response{

        public Customers renewalCustomers;
        public Response(){
            renewalCustomers                        = new Customers();
        }
    }

    public class ReqWrapObj {
        public String Emp_Name;
        public String Branch_Code;
    }

    @HttpPost
    global static Response getSMECustomers(){
        RestRequest req                             = Restcontext.Request;
        Response res                                = new Response();

        if(req == null || req.requestBody == null){
            res.status                              = Constants.WS_ERROR_STATUS;
            res.errorMessage                        = Constants.WS_REQ_BODY_IS_NULL;
            res.statusCode                          = Constants.WS_ERROR_CODE;
            return res;
        }else{
            List<Account> allAccounts               = new List<Account>();
            try{

                String jsonData                     = req.requestBody.toString();
                ReqWrapObj reqObj                   = (ReqWrapObj)Json.deserialize(jsonData, ReqWrapObj.class);
                if(reqObj.Branch_Code != null){
                    allAccounts                     = SOQL_Util.getAllCustomerByBranchCode(reqObj.Branch_Code);
                }

            }catch(Exception e){
                res.status                          = Constants.WS_ERROR_STATUS;
                res.errorMessage                    = e.getMessage();
                res.statusCode                      = Constants.WS_ERROR_CODE;
                system.debug('Exception::'+e.getMessage());
                return res;
            }

            if(!allAccounts.isEmpty() && allAccounts.size() > 0){
                res.renewalCustomers.CUSTOMER_DETAILS = SMELoan_Helper.getCustomerWrapper(allAccounts);
            }else{
                res.status                          = Constants.WS_SUCCESS_STATUS;
                res.successMessage                  = Constants.WS_NO_RECORD_FOUND;
                res.statusCode                      = Constants.WS_SUCCESS_CODE;
            }

            return res;
        }
    }
}