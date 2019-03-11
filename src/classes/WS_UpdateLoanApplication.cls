/*
* Name    : WS_UpdateLoanApplication 
* Company : ET Marlabs
* Purpose : This class is used to update Application details from App
* Author  : Subas
*/
@RestResource(urlMapping='/updateApplication')

global with sharing class WS_UpdateLoanApplication {
    
    global class Response extends WS_Response{
        
        public genesis__Applications__c application;
        public Response(){
            application = new genesis__Applications__c();            
        }
    }  
    public class acctReqWrapper {
        public String ApplicationID;
        public String FETransId;
        public String PGTransId;
        public String TransDateTime;
        public String TotalAmnt;
        public String PgStatus;
        
        public boolean Is_take_over;
        public String IFSC_code;
        public String Bank_Name;
        public String Branch_Name;
        public String Sanctioned_Loan_Amount;
        public String Outstanding_Loan_Amount;
        public String Date_of_Loan_Sanction;
        public String Start_Date_of_EMI;
        public String End_Date_of_EMI;
        public String Sanctioned_Loan_Term_in_months;
        public String Outstanding_Loan_Term_in_months;
        public String Sanctioned_ROI;
        public String Current_ROI;
    }
    @HttpPost
    global static Response getMandateFields(){
        RestRequest req      = Restcontext.Request;
        Response res         = new Response();    
        
        if(req == null || req.requestBody == null){
            res.status          = Constants.WS_ERROR_STATUS;
            res.errorMessage    = Constants.WS_REQ_BODY_IS_NULL;
            res.statusCode      = Constants.WS_ERROR_CODE;
            return res;            
        }else{
            List<genesis__Applications__c> rencustomers = new List<genesis__Applications__c>();
            try{
                
                String jsonData  = req.requestBody.toString();    
                System.debug('**json'+jsonData);
                acctReqWrapper reqObj  = (acctReqWrapper)Json.deserialize(jsonData, acctReqWrapper.class);   
                genesis__Applications__c app =new genesis__Applications__c();
                if(!String.isBlank(reqObj.ApplicationID)){
                    app.id = reqObj.ApplicationID;
                }
                if(!String.isBlank(reqObj.FETransId)){
                    app.FE_Transaction_ID__c = reqObj.FETransId;
                }
                if(!String.isBlank(reqObj.PGTransId)){
                    app.PG_Transaction_ID__c = reqObj.PGTransId;
                }
                if(!String.isBlank(reqObj.TransDateTime)){
                    app.Date_Time_Processing_Fee__c = datetime.valueOf(reqObj.TransDateTime);
                }
                //TotalAmnt
                if(!String.isBlank(reqObj.PgStatus)){
                    app.PG_Status__c = reqObj.PgStatus;
                }
                if(reqObj.Is_take_over != null){
                    app.Is_Take_Over__c = reqObj.Is_take_over;
                }
                if(!String.isBlank(reqObj.IFSC_code)){
                    app.IFSC_code__c = reqObj.IFSC_code;
                }
                if(!String.isBlank(reqObj.Branch_Name)){
                    app.Branch_Name_Existing__c = reqObj.Branch_Name;
                }
                if(!String.isBlank(reqObj.Sanctioned_Loan_Amount)){
                    app.Sanctioned_Loan_Amount__c = Decimal.ValueOf(reqObj.Sanctioned_Loan_Amount);
                }
                if(!String.isBlank(reqObj.Outstanding_Loan_Amount)){
                    app.Outstanding_Balance__c = Decimal.ValueOf(reqObj.Outstanding_Loan_Amount);
                }                
                if(!String.isBlank(reqObj.Date_of_Loan_Sanction)){
                    app.Date_of_Loan_Sanction_Existing_Loan__c = Date.ValueOf(reqObj.Date_of_Loan_Sanction);
                }
                if(!String.isBlank(reqObj.Start_Date_of_EMI)){
                    app.Start_Date_of_EMI_Existing_Loan__c = Date.ValueOf(reqObj.Start_Date_of_EMI);
                }
                if(!String.isBlank(reqObj.End_Date_of_EMI)){
                    app.End_Date_of_EMI_Existing_Loan__c = Date.ValueOf(reqObj.End_Date_of_EMI);
                }
                if(!String.isBlank(reqObj.Sanctioned_Loan_Term_in_months)){
                    app.Sanctioned_Loan_Term_Existing_Loan__c = Integer.ValueOf(reqObj.Sanctioned_Loan_Term_in_months);
                }
                if(!String.isBlank(reqObj.Outstanding_Loan_Term_in_months)){
                    app.Outstanding_Loan_Term_Existing_Loan__c = Integer.ValueOf(reqObj.Outstanding_Loan_Term_in_months);
                }
                if(!String.isBlank(reqObj.Sanctioned_ROI)){
                    app.Sanctioned_ROI_Existing_Loan__c = Decimal.ValueOf(reqObj.Sanctioned_ROI);
                }
                if(!String.isBlank(reqObj.Current_ROI)){
                    app.Current_ROI_Existing_Loan__c = Decimal.ValueOf(reqObj.Current_ROI);
                }
                system.debug('app s' +app);
                update app; //updating Application with Tranasaction details
                
                //res.application  = app;
                res.status      = Constants.WS_SUCCESS_STATUS;
                res.statusCode  = Constants.WS_SUCCESS_CODE;
                //rencustomers  = SMELoan_Helper.getMandateFields(reqObj.Branch_Code);
            }catch(Exception e){
                res.status          = Constants.WS_ERROR_STATUS;
                res.errorMessage   = e.getMessage();
                res.statusCode  = Constants.WS_ERROR_CODE;
                system.debug('Exception::'+e.getMessage());
                return res;
            }          
            
            
            return res;
        }        
    }
}