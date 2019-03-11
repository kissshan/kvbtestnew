/*
* Name          : Ws_PerfiosUpdate
* Description   : Update Perfios data using bank account numbers
* Author        : Venu Gopal
*/
@RestResource(urlMapping='/UpdatePerfios')

global class Ws_PerfiosUpdate {
    global class Response extends WS_Response{}
    Public cls_PerfDetails PfDetails;
    public class cls_PerfDetails{
        Public string ClientID;
        Public string RequestID;
        Public string Txn_ID;
        Public string Status;
        Public string BSuploadType;
        public string ApplicationID;
        public string Url;
        public string BankName;
        public string Method;
        public string RequestID2;
        public String message;
        public List<BankWrapper> Account_Numbers;
    }
    public class BankWrapper{
        Public string BankAccNumber; 
    }
    @HttpPost
    global static Response CreateBankaccounts(){
        RestRequest req      = Restcontext.Request;
        Response res         = new Response();    
        if(req == null || req.requestBody == null){
            res.status          = Constants.WS_ERROR_STATUS;
            res.errorMessage    = Constants.WS_REQ_BODY_IS_NULL;
            res.statusCode      = Constants.WS_ERROR_CODE;
            return res;            
        }else{
            try{
                List<Perfios__c> perfiosList = new List<Perfios__c>();
                HL_Perfios_CallingAPI.perfiosUpdate perUP = new HL_Perfios_CallingAPI.perfiosUpdate();
                String jsonData  = req.requestBody.toString(); 
                cls_PerfDetails cPerfios=(cls_PerfDetails)Json.deserialize(jsonData, cls_PerfDetails.class);
                if(cPerfios.ApplicationID!= null){
                    if(cPerfios.Txn_ID != null && cPerfios.Txn_ID != ''){
                        perfiosList = [SELECT Id,RecordType.DeveloperName,Transaction_Id__c,Application__r.RecordType.DeveloperName FROM Perfios__c WHERE Transaction_Id__c =: cPerfios.Txn_ID and application__r.RecordType.DeveloperName Like '%SME%'];
                    }
                    if(perfiosList.size() > 0){
                        for(Perfios__c perfios : perfiosList){
                            if(perfios.Application__r.RecordType.DeveloperName.contains('SME')){
                                if(perfios.Application__r.RecordType.DeveloperName == 'SME_NEW_Loan' && perfios.RecordType.DeveloperName == 'SME_New_Loan_Perfios')
                                    Database.executeBatch(new Batch_Perfios_SME_New_Loan('Id : '+perfios.id),1);
                                else
                                    SME_perfiosReportBatch.perfiosFinancialReport(cPerfios);
                            }
						}
					}
                            else{
                                if(cPerfios.Method==Constants.PFITR && !Utility.ISStringBlankorNull(cPerfios.RequestID2) && !Utility.ISStringBlankorNull(cPerfios.ClientID) && !Utility.ISStringBlankorNull(cPerfios.ApplicationID)){
                                    string ITRReport=HL_ITRCallingAPI.callform26AS(cPerfios.RequestID2,system.label.ITRMethod);
                                    string Form26Report=HL_ITRCallingAPI.callform26AS(cPerfios.RequestID2,system.label.Form26AsReport);
                                    if(!Utility.ISStringBlankorNull(ITRReport)){
                                        ITRResponseHL Itr=ITRResponseHL.parse(ITRReport);
                                        perUP = HL_Perfios_CallingAPI.ParseITRResponse(Itr,cPerfios.ClientID,cPerfios.ApplicationID);
                                    }
                                    if(!Utility.ISStringBlankorNull(Form26Report)){
                                        Form26asResponse F26=(Form26asResponse)Json.deserialize(Form26Report,Form26asResponse.class);
                                        HL_Perfios_CallingAPI.ParseForm26ASchange(F26,cPerfios.ClientID,cPerfios.ApplicationID);
                                    }
                                    ITR_Response__c iT                        = new ITR_Response__c();
                                    if(!Utility.ISStringBlankorNull(cPerfios.RequestID2))
                                        iT.Request_ID__c                      = cPerfios.RequestID2;
                                    iT.Account__c                         = cPerfios.ClientID;
                                    iT.Application__c                     = cPerfios.ApplicationID;
                                    if(!Utility.ISStringBlankorNull(perUP.grIncome1))
                                        iT.Gross_Income1__c                   = Decimal.valueOf(perUP.grIncome1);
                                    if(!Utility.ISStringBlankorNull(perUP.grIncome2))
                                        iT.Gross_Income2__c                   = Decimal.valueOf(perUP.grIncome2);
                                    if(!Utility.ISStringBlankorNull(perUP.grIncome3))
                                        iT.Gross_Income3__c                   = Decimal.valueOf(perUP.grIncome3);
                                    if(!Utility.ISStringBlankorNull(perUP.intIncome1))
                                        iT.Interest_income1__c                = Decimal.valueOf(perUP.intIncome1);
                                    if(!Utility.ISStringBlankorNull(perUP.intIncome2))
                                        iT.Interest_income2__c                = Decimal.valueOf(perUP.intIncome2);
                                    if(!Utility.ISStringBlankorNull(perUP.intIncome3))
                                        iT.Interest_income3__c                = Decimal.valueOf(perUP.intIncome3);
                                    if(!Utility.ISStringBlankorNull(perUP.ShareProfit1))
                                        iT.Share_of_Profit1__c                = Decimal.valueOf(perUP.ShareProfit1);
                                    if(!Utility.ISStringBlankorNull(perUP.ShareProfit2))
                                        iT.Share_of_Profit2__c                = Decimal.valueOf(perUP.ShareProfit2);
                                    if(!Utility.ISStringBlankorNull(perUP.ShareProfit3))
                                        iT.Share_of_Profit3__c                = Decimal.valueOf(perUP.ShareProfit3);
                                    if(!Utility.ISStringBlankorNull(perUP.div1))
                                        iT.Dividend_income1__c                = Decimal.valueOf(perUP.div1);
                                    if(!Utility.ISStringBlankorNull(perUP.div2))
                                        iT.Dividend_income2__c                = Decimal.valueOf(perUP.div2);
                                    if(!Utility.ISStringBlankorNull(perUP.div3))
                                        iT.Dividend_income3__c                = Decimal.valueOf(perUP.div3);
                                    if(!Utility.ISStringBlankorNull(perUP.tax1))
                                        iT.Annual_Tax1__c                     = Decimal.valueOf(perUP.tax1);
                                    if(!Utility.ISStringBlankorNull(perUP.tax2))
                                        iT.Annual_Tax2__c                     = Decimal.valueOf(perUP.tax2);
                                    if(!Utility.ISStringBlankorNull(perUP.tax3))
                                        iT.Annual_Tax3__c                     = Decimal.valueOf(perUP.tax3);
                                    if(!Utility.ISStringBlankorNull(perUP.Agr1))
                                        iT.Agriculture_ITR1__c                = Decimal.valueOf(perUP.Agr1);
                                    if(!Utility.ISStringBlankorNull(perUP.Agr2))
                                        iT.Agriculture_ITR2__c                = Decimal.valueOf(perUP.Agr2);
                                    if(!Utility.ISStringBlankorNull(perUP.Agr3))
                                        iT.Agriculture_ITR3__c                = Decimal.valueOf(perUP.Agr3);
                                    if(!Utility.ISStringBlankorNull(perUP.capGain1))
                                        iT.Annual_Capital_Gain1__c            = Decimal.valueOf(perUP.capGain1);
                                    if(!Utility.ISStringBlankorNull(perUP.capGain2))
                                        iT.Annual_Capital_Gain2__c            = Decimal.valueOf(perUP.capGain2);
                                    if(!Utility.ISStringBlankorNull(perUP.capGain3))
                                        iT.Annual_Capital_Gain3__c            = Decimal.valueOf(perUP.capGain3);
                                    if(!Utility.ISStringBlankorNull(perUP.AgriPerITR))
                                        iT.Annual_Agriculture_Income_ITR__c   = Decimal.valueOf(perUP.AgriPerITR);
                                    if(!Utility.ISStringBlankorNull(perUP.TotalShareProfit))
                                        iT.Annual_Share_of_Profit_Firm_ITR__c = Decimal.valueOf(perUP.TotalShareProfit);
                                    if(!Utility.ISStringBlankorNull(perUP.year1))
                                        iT.Year1__c                           = perUP.year1;
                                    if(!Utility.ISStringBlankorNull(perUP.year2))
                                        iT.Year2__c                           = perUp.year2;
                                    if(!Utility.ISStringBlankorNull(perUP.year3))
                                        iT.Year3__c                           = perUp.year3;
                                    if(!Utility.ISStringBlankorNull(perUp.EstimatedAgriITR))
                                        iT.Estimated_Agriculture_ITR__c       = Decimal.valueOf(perUp.EstimatedAgriITR);
                                    if(!Utility.ISStringBlankorNull(perUp.EstimatedIncomeITR))
                                        iT.Estimated_Income_ITR__c            = Decimal.valueOf(perUp.EstimatedIncomeITR);
                                    insert iT;
                                }
                                else{
                                    set<string> BAnumbers=new set<string>();
                                    set<string> BAnumbersSMS = new set<string>();
                                    for(BankWrapper reqobj :cPerfios.Account_Numbers){
                                        if(!Utility.ISStringBlankorNull(reqobj.BankAccNumber) && !Utility.ISStringBlankorNull(cPerfios.ApplicationID))
                                            BAnumbers.add(reqobj.BankAccNumber);
                                        BAnumbersSMS.add('XXXXXXXXXXXX'+String.valueOf(reqobj.BankAccNumber).right(4));
                                    }
                                    if(BAnumbers.size()>0){
                                        List<Perfios__c> UPerfios =new List<Perfios__c>();
                                        List<Perfios__c>  pf =[select id,Send_URL__c,Active__c, Bank_Name__c,Bank_Account_Number__c,All_Bank_Accounts__c,Application__c from Perfios__c where Bank_Account_Number__c IN:BAnumbers and   Applicant_Name__c=:cPerfios.ClientID and Active__c=true and Application__c =:cPerfios.ApplicationID ];
                                        string BankAccNumbers;
                                        if(!Utility.ISStringBlankorNull(cPerfios.Url) && !Utility.ISStringBlankorNull(cPerfios.ClientID)){
                                            Account Acc=[select id,name,Full_Name__c,PersonEmail,PersonMobilePhone from account where id=:cPerfios.ClientID limit 1];
                                            string Msg='Dear '+acc.Full_Name__c+', to complete your KVB Home Loan application, please submit your bank statement as proof of income. Go to --> '+cPerfios.Url+' to login to Net banking/upload bank statement for the '+cPerfios.BankName+' Account number '+BAnumbersSMS+'.';
                                            SMS_Services.sendSMSCall(Acc.PersonMobilePhone,Msg);
                                            EmailMessages.sendEmail(Acc.PersonEmail,Msg);
                                            for(Perfios__c p:pf){
                                                p.Send_URL__c=cPerfios.Url;
                                                p.url__c=true;
                                                if(!Utility.ISStringBlankorNull(cPerfios.BSuploadType))
                                                    p.BS_UploadType__c=cPerfios.BSuploadType;
                                                UPerfios.add(p);
                                            }
                                            update UPerfios;
                                        }
                                        else if(!Utility.ISStringBlankorNull(cPerfios.Txn_ID)){
                                            for(Perfios__c p:pf){
                                                if(!Utility.ISStringBlankorNull(cPerfios.Txn_ID))
                                                    p.Transaction_Id__c= cPerfios.Txn_ID;
                                                if(!Utility.ISStringBlankorNull(cPerfios.RequestID))
                                                    p.Request_Id__c=cPerfios.RequestID;
                                                UPerfios.add(p);
                                            }
                                            if(UPerfios.size()>0 ){
                                                if(cPerfios.Status=='Completed'){
                                                    PerfiosReportResponseHL PGReport=   HL_Perfios_CallingAPI.callReport(cPerfios.Txn_ID);
                                                    HL_Perfios_CallingAPI.parseReportResponse(PGReport,UPerfios,cPerfios.ApplicationID,cPerfios.ClientID);
                                                }
                                                else{
                                                    PerfiosStatusReportHL PFstatus=   HL_Perfios_CallingAPI.callStatus(cPerfios.Txn_ID);
                                                    HL_Perfios_CallingAPI.StatusReport Srepo=  HL_Perfios_CallingAPI.parseStatusResponse(PFstatus);
                                                    Perfios_Error__c Perr=new Perfios_Error__c();
                                                    Perr.Transaction_Id__c =Srepo.TxnID;
                                                    Perr.Error_Message__c =Srepo.ErrorMsg;
                                                    Perr.Perfios__c=pf[0].id;
                                                    pf[0].Error_Message__c=Srepo.ErrorMsg;
                                                    insert Perr;
                                                }
                                                update pf[0];  
                                            }
                                        }
                                    }
                                }
                            }
                        
                }
                return res;
            }
            catch(exception e){
                system.debug('Error  :'+e.getStackTraceString()+'Line number  :'+e.getLineNumber()+'ErrorMsg : '+e.getMessage());
            }
        }
        return null;
    }
}