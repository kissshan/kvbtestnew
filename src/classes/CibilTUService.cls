/******************************************************************************************
*  Name        : CibilTUService
*  
*  Company     : Et marlabs
*    
*  Purpose     : This classs used reponse Cibil for Home loan Product(bureau call)
* 
*  Developer   : venu gopal
* 
*  Version     : 1.0 
-------------------------------------------------------------------------------------------
*/
public virtual class CibilTUService {
    public static String INVALID_REQUEST_MSG;
    
    
    public static CibilResponse getcibildetails(CibilResponseTU_HL cResp,string RecordType){
        // uow = new SObjectUnitOfWork(MY_SOBJECTS);
        system.debug('Inside the cibil bureau helper');
        CibilResponse Cres=new CibilResponse();
        try{
            if(cResp!=null){
                Decimal MaxScore=0;
                Decimal EmiValue=0;
                
                Decimal plMaxCore ;
                Decimal plScore = 0;
                Decimal cibilScore = 0;
                List<CibilResponseTU_HL.cls_Applicants> listApplicants;
                
                List<CibilResponseTU_HL.cls_IDSegment> listIDs;
                List<CibilResponseTU_HL.cls_TelephoneSegment> listTelephones;
                // List<CibilResponseTU_HL.cls_EmailContactSegment> listEmails;
                List<CibilResponseTU_HL.cls_ReportAddress> listAddress;
                List<CibilResponseTU_HL.cls_Accounts> listAccounts;
                List<CibilResponseTU_HL.cls_Enquiry> listEnquirys;
                List<CibilResponseTU_HL.cls_ScoreSegment> listScores;
                List<CibilResponseTU_HL.cls_Account_NonSummary_Segment_Fields> ListAccNonSegment;
                List<CibilResponseTU_HL.cls_CAIS_Account_History> ListAccHistory;
                
                // For ID Segments
                List<TU_ID_s__c> listIDsegments = new List<TU_ID_s__c>(); 
                // For telephone Segments
                List<TU_Telephone__c>    listTelephonesegment = new List<TU_Telephone__c>(); 
                // For EMail Segments
                List<TU_Email__c>    listEmailsegment = new List<TU_Email__c>(); 
                // For TU Account
                List<TU_Account__c>    listTUAccount = new List<TU_Account__c>(); 
                // For TU Enquiry
                List<Enquiry_Summary__c>    listTUEnquiry= new List<Enquiry_Summary__c>(); 
                // For TU Address
                List<Location_Detail__c>    listTUAddres= new List<Location_Detail__c>(); 
                // For TU scores    
                List<TU_Score__c>   listTUscores= new List<TU_Score__c>(); 
                // For TU history added by shubham
                List<AccountHistory__c> listTUAccHistory = new List<AccountHistory__c>();
                
                
                ints__TransUnion_Credit_Report__c transunionObj = new ints__TransUnion_Credit_Report__c();
                
                Id HLRecID = Schema.SObjectType.ints__TransUnion_Credit_Report__c.getRecordTypeInfosByName().get(RecordType).getRecordTypeId();
                String TranExternalId = String.valueOf(Math.random())+'transcreditreport';
                
                transunionObj.External_Id__c = TranExternalId;
                transunionObj.RecordTypeId=HLRecID;
                if(cResp.Status=='Success'){
                    If(!Utility.ISStringBlankorNull(cResp.Provider)){
                        transunionObj.Response_From__c = cResp.Provider;
                        Cres.serviceType = cResp.Provider;
                    }
                    CibilResponseTU_HL.cls_Authentication cAut=cResp.Authentication;
                    CibilResponseTU_HL.cls_ResponseInfo cResInfo=cResp.ResponseInfo;
                    CibilResponseTU_HL.cls_ContextData cls_ContData=cResp.ContextData;
                    
                    if(cResInfo!=null){
                        If(!Utility.ISStringBlankorNull(string.valueOf(cResInfo.ApplicationId)))
                            transunionObj.Application_Reference_Number__c =string.valueOf(cResInfo.ApplicationId);
                        
                        If(!Utility.ISStringBlankorNull(string.valueOf(cResInfo.LosApplicationId)))
                            transunionObj.Application__c =string.valueOf(cResInfo.LosApplicationId);    
                        
                        if(cls_ContData!=null){
                            listApplicants=cls_ContData.Applicants;
                            if(listApplicants!=null && listApplicants.size()>0){
                                for(CibilResponseTU_HL.cls_Applicants Appobj:listApplicants){
                                    CibilResponseTU_HL.cls_Applicant cApp=Appobj.Applicant;
                                    CibilResponseTU_HL.cls_DsCibilBureau cbureau=cApp.DsCibilBureau;
                                    CibilResponseTU_HL.cls_DsCibilResponse cResponse =cbureau.DsCibilResponse;
                                    CibilResponseTU_HL.cls_CibilBureauResponse  cCBResponse=cResponse.CibilBureauResponse;
                                    if(cCBResponse!=null){
                                        /*If(!Utility.ISStringBlankorNull(cCBResponse.IsSucess)){
transunionObj.IsSucess__c=  cCBResponse.IsSucess;
}*/
                                        CibilResponseTU_HL.cls_BureauResponseXml  cCBResXML=cCBResponse.BureauResponseXml; 
                                        CibilResponseTU_HL.cls_CreditReport cCredReport=cCBResXML.CreditReport;
                                        CibilResponseTU_HL.cls_Header cHeader=cCredReport.Header; 
                                        system.debug('cHeader++++'+cHeader);
                                        if(cHeader!=null){
                                            If(!Utility.ISStringBlankorNull(cHeader.ReferenceNumber))
                                                transunionObj.Account__c=cHeader.ReferenceNumber;
                                            If(!Utility.ISStringBlankorNull(cHeader.MemberCode))
                                                transunionObj.Member_Code__c =cHeader.MemberCode;
                                            If(!Utility.ISStringBlankorNull(cHeader.EnquiryControlNumber))
                                                transunionObj.EnquiryControlNumber__c =cHeader.EnquiryControlNumber;
                                            If((!Utility.ISStringBlankorNull(cHeader.DateProcessed)) && (!Utility.ISStringBlankorNull(cHeader.TimeProcessed))){     
                                                string DTime =cHeader.DateProcessed+cHeader.TimeProcessed;
                                                // datetime d=Datetime.valueOf(DTime);
                                                // transunionObj.Processed_Date_Time__c =cHeader.EnquiryControlNumber; 
                                            }
                                            If(!Utility.ISStringBlankorNull(cHeader.SubjectReturnCode))
                                                transunionObj.SubjectReturnCode__c =cHeader.SubjectReturnCode;
                                        }
                                        else{
                                            Cres.Result=false;
                                            Cres.Status='Header Null';
                                            return Cres;                                                                                        
                                            
                                        }
                                        
                                        CibilResponseTU_HL.cls_NameSegment cNamesegment=cCredReport.NameSegment; 
                                        if(cNamesegment!=null){
                                            If(!Utility.ISStringBlankorNull(cNamesegment.ConsumerName1))
                                                transunionObj.Borrower_Name__c =cNamesegment.ConsumerName1;
                                            if(!Utility.ISStringBlankorNull(cNamesegment.Gender))
                                                //    transunionObj.Gender__c =cNamesegment.Gender; 
                                                if(!Utility.ISStringBlankorNull(cNamesegment.DateOfBirth))
                                                transunionObj.ints__DOB__c =cNamesegment.DateOfBirth; 
                                            
                                        }
                                        
                                        //added by shubham
                                        /*TU_Account__c TAcc1=new  TU_Account__c();
CibilResponseTU_HL.cls_Credit_Account cCreditAccount=cCredReport.Credit_Account; 
if(cCreditAccount != null){
if(!Utility.ISStringBlankorNull(cCreditAccount.CreditAccountTotal))
TAcc1.CreditAccountTotal__c =cCreditAccount.CreditAccountTotal;
if(!Utility.ISStringBlankorNull(cCreditAccount.CreditAccountActive))
TAcc1.CreditAccountActive__c =cCreditAccount.CreditAccountActive; 
if(!Utility.ISStringBlankorNull(cCreditAccount.CreditAccountDefault))
TAcc1.CreditAccountDefault__c =cCreditAccount.CreditAccountDefault; 
if(!Utility.ISStringBlankorNull(cCreditAccount.CreditAccountClosed))
TAcc1.CreditAccountClosed__c =cCreditAccount.CreditAccountClosed; 
if(!Utility.ISStringBlankorNull(cCreditAccount.CADSuitFiledCurrentBalance))
TAcc1.CADSuitFiledCurrentBalance__c =cCreditAccount.CADSuitFiledCurrentBalance; 
}

CibilResponseTU_HL.cls_Total_Outstanding_Balance cOutStandingBalance=cCredReport.Total_Outstanding_Balance; 
if(cCreditAccount != null){
if(!Utility.ISStringBlankorNull(cOutStandingBalance.Outstanding_Balance_Secured))
TAcc1.OutstandingBalanceSecured__c =cOutStandingBalance.Outstanding_Balance_Secured;
if(!Utility.ISStringBlankorNull(cOutStandingBalance.Outstanding_Balance_Secured_Percentage))
TAcc1.OutstandingBalanceSecuredPercentg__c =cOutStandingBalance.Outstanding_Balance_Secured_Percentage; 
if(!Utility.ISStringBlankorNull(cOutStandingBalance.Outstanding_Balance_UnSecured))
TAcc1.OutstandingBalanceUnSecured__c =cOutStandingBalance.Outstanding_Balance_UnSecured; 
if(!Utility.ISStringBlankorNull(cOutStandingBalance.Outstanding_Balance_UnSecured_Percentage))
TAcc1.OutstandingBalanceUnSecuredPercentg__c =cOutStandingBalance.Outstanding_Balance_UnSecured_Percentage; 
if(!Utility.ISStringBlankorNull(cOutStandingBalance.Outstanding_Balance_All))
TAcc1.OutstandingBalanceAll__c =cOutStandingBalance.Outstanding_Balance_All; 
}

*/
                                        //end
                                        
                                        
                                        listIDs=cCredReport.IDSegment;
                                        if(listIDs!=null && listIDs.size()>0){
                                            for(CibilResponseTU_HL.cls_IDSegment lId:listIDs){
                                                
                                                TU_ID_s__c Tid= new TU_ID_s__c();
                                                if(!Utility.ISStringBlankorNull(lId.IDNumber))
                                                    Tid.ID_Number__c=lId.IDNumber;
                                                if(!Utility.ISStringBlankorNull(lId.IDType))
                                                    Tid.ID_Type__c=lId.IDType;
                                                Tid.TU_Credit_Report__r=new ints__TransUnion_Credit_Report__c(External_Id__c=TranExternalId);
                                                listIDsegments.add(Tid);
                                            }
                                        }
                                        list<Decimal> Scores=new List<Decimal>();
                                        list<Decimal> plScores=new List<Decimal>();
                                        listScores=cCredReport.ScoreSegment;
                                        if(listScores!=null && listScores.size()>0){
                                            for(CibilResponseTU_HL.cls_ScoreSegment lscore:listScores){
                                                TU_Score__c Tsc=new TU_Score__c();
                                                if(!Utility.ISStringBlankorNull(lscore.ScoreName))
                                                    Tsc.Score_Name__c=lscore.ScoreName;
                                                if(!Utility.ISStringBlankorNull(lscore.ScoreCardName))
                                                    Tsc.Score_Card_Name__c=lscore.ScoreCardName;
                                                if(!Utility.ISStringBlankorNull(lscore.ScoreCardVersion))
                                                    Tsc.Score_Card_Version__c=lscore.ScoreCardVersion;
                                                if(!Utility.ISStringBlankorNull(lscore.ScoreDate))
                                                    Tsc.Score_Date__c=lscore.ScoreDate;
                                                if(!Utility.ISStringBlankorNull(lscore.Score)){
                                                    if(lscore.Score =='000-1'){
                                                        lscore.Score  =String.valueOf(-1);                                                                
                                                    }
                                                    Tsc.Score__c=Decimal.valueOf(lscore.Score);
                                                    
                                                    if(lscore.ScoreName == 'PLSCORE'){      
                                                        plScores.add(Decimal.valueOf(lscore.Score));        
                                                    }
                                                    else{
                                                        Scores.add(Decimal.valueOf(lscore.Score));
                                                    }
                                                }
                                                Tsc.TU_Credit_Report__r=new ints__TransUnion_Credit_Report__c(External_Id__c=TranExternalId);
                                                listTUscores.add(Tsc);
                                                
                                            }
                                            system.debug(Scores);
                                            system.debug('plScores:::'+plScores); 
                                            
                                            if(plScores.size()>0){     
                                                plMaxCore = plScores[0];
                                            }
                                            
                                            if(Scores.size()>0 ){
                                                MaxScore=Scores[0];
                                                for(integer i=0;i<Scores.size(); i++){
                                                    if(Scores[i]>MaxScore){
                                                        MaxScore=Scores[i];
                                                    }
                                                }
                                                system.debug('the max value is'+MaxScore);
                                                Cres.CibilScore=string.valueOf(MaxScore);
                                                /* if(MaxScore >=Utility.getCibilTScore()){
}
else{
Cres.Result=false;
Cres.Status='Low Cibil Score';
return Cres;  

}
*/
                                            }
                                            else{
                                                Cres.Result=false;
                                                Cres.Status='CIBIL Score Not Avalable';
                                                return Cres;  
                                            }
                                            
                                        }
                                        else{
                                            
                                            Cres.Result=false;
                                            Cres.Status='CIBIL Fail';
                                            return Cres;                                                    
                                            
                                        }
                                        
                                        listTelephones =cCredReport.TelephoneSegment;
                                        
                                        if(listTelephones!=null && listTelephones.size()>0){
                                            for(CibilResponseTU_HL.cls_TelephoneSegment Tut:listTelephones){
                                                TU_Telephone__c TuTphone=new TU_Telephone__c();
                                                if(!Utility.ISStringBlankorNull(Tut.EnrichedThroughEnquiry))
                                                    TuTphone.EnrichedThroughEnquiry__c = Tut.EnrichedThroughEnquiry;
                                                /* if(!Utility.ISStringBlankorNull(Tut.TelephoneExtension))
TuTphone.TelephoneExtension__c = Tut.TelephoneExtension;
*/
                                                if(!Utility.ISStringBlankorNull(Tut.TelephoneNumber))
                                                    TuTphone.TelephoneNumber__c = Tut.TelephoneNumber;
                                                if(!Utility.ISStringBlankorNull(Tut.TelephoneType))
                                                    TuTphone.TelephoneType__c = Tut.TelephoneType;
                                                
                                                TuTphone.TU_Credit_Report__r=new ints__TransUnion_Credit_Report__c(External_Id__c=TranExternalId);
                                                
                                                
                                                listTelephonesegment.add(TuTphone);
                                            }
                                        }
                                        /*
listEmails=cCredReport.EmailContactSegment;
If(listEmails!=null && listEmails.size()>0){
for(CibilResponseTU_HL.cls_EmailContactSegment EcS:listEmails){
TU_Email__c TEmail=new  TU_Email__c();
if(!Utility.ISStringBlankorNull(EcS.EmailID))
TEmail.Email_ID__c= EcS.EmailID;
TEmail.TU_Credit_Report__r=new ints__TransUnion_Credit_Report__c(External_Id__c=TranExternalId);
listEmailsegment.add(TEmail);
}
}
*/
                                        
                                        listAccounts=cCredReport.Accounts;
                                        
                                        If(listAccounts!=null && listAccounts.size()>0){ 
                                            for(CibilResponseTU_HL.cls_Accounts CAcc:listAccounts){
                                                TU_Account__c TAcc=new  TU_Account__c();
                                                if(TAcc!=null){
                                                    ListAccNonSegment=CAcc.Account_NonSummary_Segment_Fields;
                                                    if(ListAccNonSegment!=null && ListAccNonSegment.size()>0){
                                                        for(CibilResponseTU_HL.cls_Account_NonSummary_Segment_Fields  CNsegment:ListAccNonSegment){
                                                            System.debug('!!!!!!!!!!!!!!!!!'+CNsegment);
                                                            String TUAccExternalId = String.valueOf(Math.random())+'tuacchistory';
                                                            // CibilResponseTU_HL.cls_Account_NonSummary_Segment_Fields cANonSegment=CAcc.Account_NonSummary_Segment_Fields;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.AccountType))
                                                                TAcc.Account_Type__c=CNsegment.AccountType;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.AmountOverdue))
                                                                TAcc.Amount_Overdue__c=CNsegment.AmountOverdue;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.CurrentBalance))
                                                                TAcc.Current_Balance__c=CNsegment.CurrentBalance;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.DateOfLastPayment))
                                                                TAcc.Date_Of_Last_Payment__c=CNsegment.DateOfLastPayment;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.DateOpenedOrDisbursed))
                                                                TAcc.Date_Opened_Or_Disbursed__c=CNsegment.DateOpenedOrDisbursed;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.DateReportedAndCertified))
                                                                TAcc.Date_Reported_And_Certified__c=CNsegment.DateReportedAndCertified;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.HighCreditOrSanctionedAmount))
                                                                TAcc.High_Credit_Or_Sanctioned_Amount__c=CNsegment.HighCreditOrSanctionedAmount;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.OwenershipIndicator))
                                                                TAcc.Owenership_Indicator__c=CNsegment.OwenershipIndicator;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.PaymentHistory1))
                                                                TAcc.Payment_History1__c=CNsegment.PaymentHistory1;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.PaymentHistory2))
                                                                TAcc.Payment_History2__c=CNsegment.PaymentHistory2;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.PaymentHistoryEndDate))
                                                                TAcc.Payment_History_End_Date__c=CNsegment.PaymentHistoryEndDate;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.PaymentHistoryStartDate))
                                                                TAcc.Payment_History_StartDate__c=CNsegment.PaymentHistoryStartDate;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.ReportingMemberShortName))
                                                                TAcc.Reporting_Member_Short_Name__c=CNsegment.ReportingMemberShortName;
                                                            
                                                            if(!Utility.ISStringBlankorNull(CNsegment.SuitFiledOrWilfulDefault))
                                                                TAcc.SuitFiled_O_rWilfulDefault__c=CNsegment.SuitFiledOrWilfulDefault;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.WrittenOffAndSettled))
                                                                TAcc.Written_Off_And_Settled__c=CNsegment.WrittenOffAndSettled;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.ValueOfCollateral))
                                                                TAcc.Value_Of_Collateral__c=CNsegment.ValueOfCollateral;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.TypeOfCollateral))
                                                                TAcc.Type_Of_Collateral__c=CNsegment.TypeOfCollateral;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.CreditLimit))
                                                                TAcc.Credit_Limit__c=CNsegment.CreditLimit;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.CashLimit))
                                                                TAcc.Cash_Limit__c=CNsegment.CashLimit;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.RateOfInterest))
                                                                TAcc.Rate_Of_Interest__c=CNsegment.RateOfInterest;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.RepaymentTenure))
                                                                TAcc.Repayment_Tenure__c=CNsegment.RepaymentTenure;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.EmiAmount))
                                                                TAcc.Emi_Amount__c=CNsegment.EmiAmount;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.WrittenOffAmountTotal))
                                                                TAcc.Written_Off_Amount_Total__c=CNsegment.WrittenOffAmountTotal;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.WrittenOffAmountPrincipal))
                                                                TAcc.Written_Off_Amount_Principal__c=CNsegment.WrittenOffAmountPrincipal;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.SettlementAmount))
                                                                TAcc.Settlement_Amount__c=CNsegment.SettlementAmount;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.PaymentFrequency))
                                                                TAcc.Payment_Frequency__c=CNsegment.PaymentFrequency;
                                                            
                                                            if(!Utility.ISStringBlankorNull(CNsegment.ActualPaymentAmount))
                                                                TAcc.Actual_Payment_Amount__c=CNsegment.ActualPaymentAmount;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.ErrorCode))
                                                                TAcc.Error_Code__c=CNsegment.ErrorCode;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.CIBILRemarksCode))
                                                                TAcc.CIBIL_Remarks_Code__c=CNsegment.CIBILRemarksCode;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.DateOfEntryForErrorDisputeRemarksCode))
                                                                TAcc.Date_Of_Entry_Dispute_Code__c=CNsegment.DateOfEntryForErrorDisputeRemarksCode;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.ErrorDisputeRemarksCode1))
                                                                TAcc.Error_Dispute_Remarks_Code1__c=CNsegment.ErrorDisputeRemarksCode1;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.ErrorDisputeRemarksCode2))
                                                                TAcc.Error_Dispute_Remarks_Code2__c=CNsegment.ErrorDisputeRemarksCode2;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.FID))
                                                                TAcc.FID__c=CNsegment.FID;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.SNo))
                                                                TAcc.SNo__c=CNsegment.SNo;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.SuppressFlag))
                                                                TAcc.Suppress_Flag__c=CNsegment.SuppressFlag;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.DateOfSuppression))
                                                                TAcc.Date_Of_Suppression__c=CNsegment.DateOfSuppression;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.DateClosed))
                                                                TAcc.Date_Closed__c=CNsegment.DateClosed;
                                                            //experian
                                                            if(!Utility.ISStringBlankorNull(CNsegment.DateOfAddition))
                                                                TAcc.DateOfAddition__c = CNsegment.DateOfAddition;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.WriteOffStatusDate))
                                                                TAcc.WriteOffStatusDate__c = CNsegment.WriteOffStatusDate;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.LitigationStatusDate))
                                                                TAcc.LitigationStatusDate__c = CNsegment.LitigationStatusDate;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.DefaultStatusDate))
                                                                TAcc.DefaultStatusDate__c = CNsegment.DefaultStatusDate;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.SuitFiledWillfulDefaultWrittenOffStatus))
                                                                TAcc.SuitFiled_O_rWilfulDefault__c = CNsegment.SuitFiledWillfulDefaultWrittenOffStatus;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.Payment_Rating))
                                                                TAcc.PaymentRating__c = CNsegment.Payment_Rating;
                                                            if(!Utility.ISStringBlankorNull(CNsegment.Account_Status))
                                                                TAcc.AccountStatus__c = CNsegment.Account_Status;
                                                            
                                                            // system.debug('Emi amount'+string.isBlank(CNsegment.EmiAmount) );
                                                            if(CNsegment.OwenershipIndicator!=null && (CNsegment.OwenershipIndicator=='Individual' || CNsegment.OwenershipIndicator=='Joint') && (CNsegment.DateClosed == null || string.isBlank(CNsegment.DateClosed) ==true) && CNsegment.AccountType!=null && string.isBlank(CNsegment.AccountType)==false && CNsegment.AccountType!='Gold Loan' && CNsegment.AccountType!='Credit Card' && CNsegment.AccountType!='Business Loan Against Bank Deposits' && CNsegment.AccountType!='Overdraft' && CNsegment.AccountType!='Non Funded Credit Facility' && CNsegment.AccountType!='Loan Against Bank Deposits' && CNsegment.AccountType!='Fleet Card' && CNsegment.AccountType!='Secured Credit Card' &&  CNsegment.AccountType!='Corporate Credit Card' && CNsegment.AccountType!='Kisan Credit Card' && CNsegment.AccountType!='Loan on Credit Card' && CNsegment.AccountType!='Prime Minister Jaan Dhan Yojana - Overdraft' && CNsegment.AccountType!='Mudra Loans – Shishu / Kishor / Tarun' && CNsegment.AccountType!='Pradhan Mantri Awas Yojana - Credit Link Subsidy Scheme MAY CLSS' && CNsegment.AccountType!='Business Loan – Priority Sector – Agriculture' && CNsegment.AccountType!='Business Non-Funded Credit Facility – General' && CNsegment.AccountType!='Business Non-Funded Credit Facility – Priority Sector – Small Business' && CNsegment.AccountType!='Business Non-Funded Credit Facility – Priority Sector – Agriculture' && CNsegment.AccountType!='Business Non-Funded Credit Facility – Priority Sector-Others'){          
                                                                
                                                                // && (CNsegment.EmiAmount!=null && string.isBlank(CNsegment.EmiAmount) ==false) 
                                                                // if(CNsegment.AccountType!='Gold Loan'){
                                                                //  if(CNsegment.AccountType!=null && string.isBlank(CNsegment.AccountType)==false && CNsegment.AccountType!='Gold Loan' && CNsegment.AccountType!='Credit Card' && CNsegment.AccountType!='Business Loan Against Bank Deposits' && CNsegment.AccountType!='Overdraft' && CNsegment.AccountType!='Non Funded Credit Facility' && CNsegment.AccountType!='Loan Against Bank Deposits' && CNsegment.AccountType!='Fleet Card' && CNsegment.AccountType!='Secured Credit Card' &&  CNsegment.AccountType!='Corporate Credit Card' && CNsegment.AccountType!='Kisan Credit Card' && CNsegment.AccountType!='Loan on Credit Card' && CNsegment.AccountType!='Prime Minister Jaan Dhan Yojana - Overdraft' && CNsegment.AccountType!='Mudra Loans – Shishu / Kishor / Tarun' && CNsegment.AccountType!='Pradhan Mantri Awas Yojana - Credit Link Subsidy Scheme MAY CLSS' && CNsegment.AccountType!='Business Loan – Priority Sector – Agriculture' && CNsegment.AccountType!='Business Non-Funded Credit Facility – General' && CNsegment.AccountType!='Business Non-Funded Credit Facility – Priority Sector – Small Business' && CNsegment.AccountType!='Business Non-Funded Credit Facility – Priority Sector – Agriculture' && CNsegment.AccountType!='Business Non-Funded Credit Facility – Priority Sector-Others'){  
                                                                
                                                                
                                                                if(string.isBlank(CNsegment.EmiAmount) ==false){
                                                                    EmiValue +=Decimal.valueOf(Utility.getBlankStringIfNull(CNsegment.EmiAmount)); 
                                                                    
                                                                }
                                                                
                                                                //ActualPaymentAmount
                                                                else if(CNsegment.ActualPaymentAmount!=null && string.isBlank(CNsegment.ActualPaymentAmount) ==false){
                                                                    EmiValue +=Decimal.valueOf(Utility.getBlankStringIfNull(CNsegment.ActualPaymentAmount)); //
                                                                    system.debug('EmiValue'+CNsegment.ActualPaymentAmount);
                                                                }
                                                                system.debug('EmiValue'+EmiValue);
                                                                //}
                                                            }     
                                                            
                                                            TAcc.TU_Credit_Report__r=new ints__TransUnion_Credit_Report__c(External_Id__c=TranExternalId);
                                                            TAcc.TU_Acc_External_Id__c = TUAccExternalId;
                                                            listTUAccount.add(TAcc);
                                                            System.debug('SSSSSS------>'+CNsegment.AccountHistory);
                                                            ListAccHistory = CNsegment.AccountHistory;
                                                            if(ListAccHistory != null && ListAccHistory.size() > 0){
                                                                for(CibilResponseTU_HL.cls_CAIS_Account_History AccHistory : ListAccHistory){
                                                                    AccountHistory__c accHist = new AccountHistory__c();
                                                                    if(!Utility.ISStringBlankorNull(AccHistory.Year))
                                                                        accHist.Year__c= AccHistory.Year;
                                                                    if(!Utility.ISStringBlankorNull(AccHistory.Month))
                                                                        accHist.Month__c=AccHistory.Month;
                                                                    if(!Utility.ISStringBlankorNull(AccHistory.DPD))
                                                                        accHist.DaysPastDue__c=AccHistory.DPD;
                                                                    if(!Utility.ISStringBlankorNull(AccHistory.AssetClassification))
                                                                        accHist.AssetClassification__c=AccHistory.AssetClassification;
                                                                    
                                                                    accHist.TUAccount__r = new TU_Account__c(TU_Acc_External_Id__c=TUAccExternalId);
                                                                    listTUAccHistory.add(accHist);
                                                                }
                                                                System.debug('Account History....>'+listTUAccHistory);
                                                            }
                                                        }
                                                        
                                                    }
                                                    
                                                }
                                            }
                                            
                                            
                                        }
                                        system.debug('EmiValue'+EmiValue);
                                        listEnquirys=cCredReport.Enquiry;
                                        
                                        If(listEnquirys!=null && listEnquirys.size()>0){
                                            for(CibilResponseTU_HL.cls_Enquiry cE:listEnquirys){
                                                Enquiry_Summary__c Es=new Enquiry_Summary__c();
                                                for(integer x=0;x<20;x++){
                                                    if(!Utility.ISStringBlankorNull(cE.SegmentTag))   
                                                        Es.SegmentTag__c=cE.SegmentTag;
                                                    if(!Utility.ISStringBlankorNull(cE.DateOfEnquiryFields))   
                                                        Es.Enquiry_Date__c=cE.DateOfEnquiryFields;
                                                    if(!Utility.ISStringBlankorNull(cE.EnquiryPurpose))   
                                                        Es.Enquiry_Purpose__c=cE.EnquiryPurpose;
                                                    if(!Utility.ISStringBlankorNull(cE.EnquiringMemberShortName))   
                                                        Es.Credit_Lender__c=cE.EnquiringMemberShortName;
                                                    if(!Utility.ISStringBlankorNull(cE.EnquiryAmount))   
                                                        Es.Enquiry_Amount__c = cE.EnquiryAmount;
                                                    ES.Tu_Credit_Report__r =new ints__TransUnion_Credit_Report__c(External_Id__c=TranExternalId);
                                                    
                                                    
                                                }
                                                listTUEnquiry.add(Es);
                                            }
                                            
                                        }
                                        
                                        listAddress=cCredReport.ReportAddress;
                                        If(listAddress!=null && listAddress.size()>0){
                                            for(CibilResponseTU_HL.cls_ReportAddress CRA:listAddress){
                                                Location_Detail__c Ld=new Location_Detail__c();  
                                                if(!Utility.ISStringBlankorNull(CRA.AddressLine1))   
                                                    Ld.Address__c = CRA.AddressLine1;
                                                if(!Utility.ISStringBlankorNull(CRA.AddressSegmentTag))   
                                                    Ld.Address_Segment_Tag__c = CRA.AddressSegmentTag;
                                                if(!Utility.ISStringBlankorNull(CRA.StateCode))   
                                                    Ld.State_Name__c = CRA.StateCode;
                                                if(!Utility.ISStringBlankorNull(CRA.PinCode))   
                                                    Ld.Pin_Code__c = CRA.PinCode;
                                                if(!Utility.ISStringBlankorNull(CRA.AddressCategory))   
                                                    Ld.Address_Category__c = CRA.AddressCategory;
                                                if(!Utility.ISStringBlankorNull(CRA.DateReported))   
                                                    Ld.Date_Reported__c = CRA.DateReported;
                                                if(!Utility.ISStringBlankorNull(CRA.EnrichedThroughEnquiry))   
                                                    Ld.Enriched_Through_Enquiry__c = CRA.EnrichedThroughEnquiry;
                                                
                                                Ld.Tu_Credit_Report__r =new ints__TransUnion_Credit_Report__c(External_Id__c=TranExternalId);
                                                listTUAddres.add(Ld);
                                            }
                                            
                                        }
                                    }
                                    else{
                                        Cres.Result=false;
                                        Cres.Status='Cibil Bureau Response  Null';
                                        return Cres;                                                                                        
                                        
                                    }
                                }
                            }
                            else{
                                Cres.Result=false;
                                Cres.Status='Applicants not available';
                                return Cres;                                                                                        
                                
                            }  
                        }
                        else{
                            Cres.Result=false;
                            Cres.Status='Context Data Null';
                            return Cres; 
                        }
                    }
                    else{
                        Cres.Result=false;
                        Cres.Status='Response Info Null';
                        return Cres; 
                    }
                }
                else if(cResp.errorCode != null && cResp.errorMessage != null){
                    Cres.Result=false;
                    Cres.Status='INVALID_REQUEST';
                    INVALID_REQUEST_MSG = cResp.errorMessage;
                    RETURN Cres;
                }
                else{
                    Cres.Result=false;
                    Cres.Status=cResp.Status;
                    return Cres; 
                }
                system.debug('transunionObj'+transunionObj);
                insert transunionObj;
                
                system.debug('transunionObj'+transunionObj);
                if(listIDsegments.size()>0)
                    Database.insert(listIDsegments, false);
                
                if(listTUscores.size()>0)
                    Database.insert(listTUscores, false);
                
                if(listTelephonesegment.size()>0)
                    Database.insert(listTelephonesegment, false);
                
                /*  if(listEmailsegment.size()>0)
Database.insert(listEmailsegment, false);  */
                
                if(listTUAccount.size()>0)
                    Database.insert(listTUAccount, false);
                if(listTUAccHistory.size()>0)
                    Database.insert(listTUAccHistory, false);
                
                account acc=new account();
                acc.Id =transunionObj.Account__c;
                //acc.Existing_Emis__c=EmiValue;
                //acc.CIBIL_EMI__c = EmiValue; //commented as discussed by vivek 2018-07-10
                acc.CIBIL_Score__c=MaxScore;
                acc.CIBIL_Status__pc = 'Complete';
                acc.TU_Trigger_Time__c = System.now();
                update acc;
                
                List<genesis__Application_Parties__c> listOfparties= [Select id,genesis__Application__r.RecordType.DeveloperName,genesis__Party_Account_Name__r.id from genesis__Application_Parties__c where genesis__Party_Account_Name__r.id =:transunionObj.Account__c And Active__c=true AND ((Company__c = false AND (genesis__Party_Type__c=:Constants.PRIMARY_APP OR genesis__Party_Type__c=:Constants.Co_Borrower OR genesis__Party_Type__c=: Constants.Gurantor)) OR (genesis__Application__r.RecordType.DeveloperName Like 'SME_ %' ))order by CreatedDate DESC limit 1];
                system.debug('listOfparties====='+listOfparties);
                if(listOfparties !=null && listOfparties.size() > 0){
                    system.debug('##DataLogv part id ### --- > '+ listOfparties[0]);
                    genesis__Application_Parties__c partyss = new genesis__Application_Parties__c();
                    partyss.CIBIL_EMI__c = EmiValue;
                    partyss.CIBIL_Scores__c = MaxScore;
                    partyss.id = listOfparties[0].id;
                    
                    SendSMSService.Recusrive = False;
                    update partyss;    
                }
                
                if(!Utility.ISStringBlankorNull(string.valueOf(plMaxCore) )){
                    String appId = Ws_IDV_CIBILResponse.applnId;  
                    
                    genesis__applications__c gApp = new genesis__applications__c();
                    system.debug('cResInfo.ApplicationId:::'+appId);
                    gApp.Id=appId;
                    gApp.PL_Score__c = plMaxCore;
                    ApplicationTriggerHandler.IsFirstRun = False;
                    update gApp;
                }
                
                if(listTUEnquiry.size()>0)
                    Database.insert(listTUEnquiry, false);
                if(listTUAddres.size()>0)
                    Database.insert(listTUAddres, false);
                
                Cres.Result=true;
                Cres.Status='CIBIL Success';
                return Cres;
            }
            
            else{
                Cres.Result=false;
                Cres.Status='No Response From CIBIL';
                return Cres;                                                                                        
                
            }
            
        }
        catch(exception e){
            system.debug('Line Number '+e.getLineNumber()+' Traces: '+e.getStackTraceString()+'message:-'+e.getMessage()); 
            HandleBusinessException.captureError('CibilTUService', 'getcibildetails', e);
        }
        return Cres;
    }
    public static IDVResponse getIDV(IDVResponseTU_HL cResp){
        IDVResponse Ires=new IDVResponse();
        
        try{
            if(cResp!=null){
                List<IDVResponseTU_HL.cls_Applicants> listApplicants;
                List<IDVResponseTU_HL.cls_SuitFiled> listSuitFIeld;
                List<IDVResponseTU_HL.cls_WilfulDefault> listWilful;
                List<IDVResponseTU_HL.cls_SuitfiledandWilfuldefault> listSuitWilful;
                //prashant 
                list<SuitFor__c> listsuit=new  list<SuitFor__c>();
                IDVResponse__c  idvres=new IDVResponse__c();
                IDVResponseTU_HL.cls_ResponseInfo cResInfo=cResp.ResponseInfo;
                idvres.IDVResponseToAccount__c=cResInfo.ReferenceNumber;//for tagging account id
                idvres.IDVResponseToApplication__c=cResInfo.LosApplicationId;//for tagging application id
                IDVResponseTU_HL.cls_Authentication cAut=cResp.Authentication;
                idvres.Authentication__c=string.valueOf(cAut.Status);
                
                idvres.Status__c=cResp.Status;
                //prashant ends
                
                if(cResp.Status=='Success'){
                    //IDVResponseTU_HL.cls_Authentication cAut=cResp.Authentication;
                    //IDVResponseTU_HL.cls_ResponseInfo cResInfo=cResp.ResponseInfo;
                    IDVResponseTU_HL.cls_ContextData cls_ContData=cResp.ContextData;
                    //prashant 
                    idvres.Authentication__c=string.valueOf(cAut.status);
                    String IDVExternalId = String.valueOf(Math.random())+'IDV';
                    idvres.External_Id__c = IDVExternalId;
                    // idvres.IDVResponseToAccount__c=cResInfo.ReferenceNumber;//for tagging account id
                    // idvres.IDVResponseToApplication__c=cResInfo.LosApplicationId;//for tagging application id
                    IDVResponseTU_HL.cls_MemberDetails md=new IDVResponseTU_HL.cls_MemberDetails();                                                             
                    //  SuitFor__c sf=new SuitFor__c();
                    
                    //prashant ends
                    if(cAut.Status=='Success'){
                        system.debug('cMatch'+cAut);
                        system.debug('testingjc:::'+cls_ContData.Applicants);
                        if(cls_ContData!=null){
                            listApplicants=cls_ContData.Applicants;
                            if(listApplicants!=null && listApplicants.size()>0){
                                for(IDVResponseTU_HL.cls_Applicants Appobj:listApplicants){
                                    IDVResponseTU_HL.cls_Applicant cApp=Appobj.Applicant;
                                    IDVResponseTU_HL.cls_DsIDVision cDsIDVision=cApp.DsIDVision;
                                    IDVResponseTU_HL.cls_CPVAttributes   cCPV=cDsIDVision.CPVAttributes;
                                    
                                    IDVResponseTU_HL.cls_Match cMatch=cCPV.Match;
                                    system.debug('cMatch'+cMatch);
                                    //added by prashant singh
                                    IDVResponseTU_HL.cls_VerificationScore verfscr=cCPV.VerificationScore;
                                    idvres.FinalAddressScore__c=verfscr.FinalAddressScore;
                                    idvres.FinalContactabilityScore__c=verfscr.FinalContactabilityScore;
                                    idvres.FinalIdentityScore__c=verfscr.FinalIdentityScore;
                                    idvres.FinalVerificationScore__c=verfscr.FinalVerificationScore;                                   
                                    
                                    //prashant ends 13-11-2018
                                    if(cMatch!=null){
                                        if((!Utility.ISStringBlankorNull(cMatch.IDAadharNameMatch)) && (!Utility.ISStringBlankorNull(cMatch.IDAadharGenderMatch))&&(!Utility.ISStringBlankorNull(cMatch.IDAadharDOBYearMatch)))
                                        {
                                            //prashant                                                          
                                            idvres.IDAadharDOBYearMatch__c=cMatch.IDAadharDOBYearMatch;
                                            idvres.IDAadharGenderMatch__c=cMatch.IDAadharGenderMatch;
                                            idvres.IDAadharNameMatch__c=cMatch.IDAadharNameMatch;
                                            idvres.IDNSDLNameStatus__c=cMatch.IDNSDLNameStatus;
                                            //prashant ends
                                            if((Decimal.valueOf(cMatch.IDAadharNameMatch) >=80 ) && (Decimal.valueOf(cMatch.IDAadharGenderMatch) ==100) &&(Decimal.valueOf(cMatch.IDAadharDOBYearMatch) ==100)) {
                                                Ires.AadharMatch='1';
                                            }
                                            else{
                                                Ires.AadharMatch='0';    
                                            }
                                            if(!Utility.ISStringBlankorNull(cMatch.IDNSDLNameMatch)){
                                                //prashant                                                    
                                                idvres.IDNSDLNameMatch__c=cMatch.IDNSDLNameMatch;
                                                //prashant ends
                                                if(cMatch.IDNSDLNameMatch == 'NA'){
                                                    cMatch.IDNSDLNameMatch ='0';
                                                }                                                
                                                if(Decimal.valueOf(cMatch.IDNSDLNameMatch)>=66.66){ 
                                                    
                                                    Ires.PanMatch='1';                                                                
                                                }
                                                else{
                                                    Ires.PanMatch='0';  
                                                    // Ires.Status ='PAN Mis Match' ;
                                                    
                                                    // Ires.Result=false;
                                                    //  return Ires;
                                                }
                                                set<string> abc=new set<string>();
                                                IDVResponseTU_HL.cls_WilfulDefaultDetails CwDetails=cCPV.WilfulDefaultDetails;
                                                if(CwDetails!=null){
                                                    listSuitFIeld=CwDetails.SuitFiled;
                                                    
                                                    if(listSuitFIeld!=null && listSuitFIeld.size()>0){
                                                        for(IDVResponseTU_HL.cls_SuitFiled Suit:listSuitFIeld){
                                                            //prashant      
                                                            for(IDVResponseTU_HL.cls_MemberDetails m:suit.MemberDetails)
                                                            {
                                                                SuitFor__c sf=new SuitFor__c();
                                                                
                                                                sf.ProductCategory__c=m.ProductCategory;
                                                                sf.ProductType__c=m.ProductType;
                                                                sf.OwenershipIndicator__c=m.OwenershipIndicator;
                                                                sf.MemberName__c=m.MemberName;
                                                                sf.DateReported__c=m.DateReported;
                                                                sf.AmountOutstandingasonReportedDate__c=m.AmountOutstandingasonReportedDate;                                                                                                                                                                                                                                             
                                                                sf.AccountNumber__c=m.AccountNumber;       
                                                                Id SuitFiledID = Schema.SObjectType.SuitFor__c.getRecordTypeInfosByName().get('SuitFiled').getRecordTypeId();
                                                                sf.RecordTypeId=SuitFiledID;    
                                                                sf.Status__c=suit.Status;
                                                                sf.IDVResponse__R=new IDVResponse__c(External_Id__c=IDVExternalId);  
                                                                
                                                                listsuit.add(sf);
                                                                
                                                            }
                                                            //prashant ends
                                                            system.debug('Suit.Status'+Suit.Status);
                                                            system.debug(abc);
                                                            // abc.add(Suit.Status);
                                                            abc.add(Utility.getBlankStringIfNull(Suit.Status));
                                                        }
                                                    }
                                                    listWilful=  CwDetails.WilfulDefault;
                                                    
                                                    if(listWilful!=null && listWilful.size()>0){
                                                        for(IDVResponseTU_HL.cls_WilfulDefault wilful:listWilful){
                                                            //prashant      
                                                            for(IDVResponseTU_HL.cls_MemberDetails m:wilful.MemberDetails)
                                                            {
                                                                SuitFor__c sf=new SuitFor__c();
                                                                
                                                                sf.ProductCategory__c=m.ProductCategory;
                                                                sf.ProductType__c=m.ProductType;
                                                                sf.OwenershipIndicator__c=m.OwenershipIndicator;
                                                                sf.MemberName__c=m.MemberName;
                                                                sf.DateReported__c=m.DateReported;
                                                                sf.AmountOutstandingasonReportedDate__c=m.AmountOutstandingasonReportedDate;                                                                                                                                                                                                                                             
                                                                Id WilfulDefaultID = Schema.SObjectType.SuitFor__c.getRecordTypeInfosByName().get('WilfulDefault').getRecordTypeId();
                                                                sf.RecordTypeId=WilfulDefaultID;    
                                                                sf.IDVResponse__R=new IDVResponse__c(External_Id__c=IDVExternalId);  
                                                                sf.Status__c=wilful.Status;
                                                                
                                                                listsuit.add(sf);
                                                                
                                                            }
                                                            //prashant ends
                                                            abc.add(Utility.getBlankStringIfNull(wilful.Status));
                                                        }
                                                    } 
                                                    
                                                    listSuitWilful=  CwDetails.SuitfiledandWilfuldefault;
                                                    
                                                    if(listSuitWilful!=null && listSuitWilful.size()>0){
                                                        for(IDVResponseTU_HL.cls_SuitfiledandWilfuldefault suiwilful:listSuitWilful){
                                                            //prashant      
                                                            
                                                            for(IDVResponseTU_HL.cls_MemberDetails m:suiwilful.MemberDetails)
                                                            {
                                                                SuitFor__c sf=new SuitFor__c();
                                                                
                                                                sf.ProductCategory__c=m.ProductCategory;
                                                                sf.ProductType__c=m.ProductType;
                                                                sf.OwenershipIndicator__c=m.OwenershipIndicator;
                                                                sf.MemberName__c=m.MemberName;
                                                                sf.DateReported__c=m.DateReported;
                                                                sf.AmountOutstandingasonReportedDate__c=m.AmountOutstandingasonReportedDate;                                                                                                                                                                                                                                             
                                                                Id SuitfiledandWilfuldefaultID = Schema.SObjectType.SuitFor__c.getRecordTypeInfosByName().get('SuitfiledandWilfuldefault').getRecordTypeId();
                                                                sf.RecordTypeId=SuitfiledandWilfuldefaultID;    
                                                                sf.IDVResponse__R=new IDVResponse__c(External_Id__c=IDVExternalId);  
                                                                listsuit.add(sf);
                                                                sf.Status__c=suiwilful.Status;
                                                                
                                                                
                                                            }
                                                            //prashant ends
                                                            abc.add(Utility.getBlankStringIfNull(suiwilful.Status));
                                                        }
                                                    }
                                                    system.debug('abc'+abc); 
                                                    
                                                    if(abc.size()>0 && abc.contains('Yes')){
                                                        Ires.Status ='IDV SuitFilled/Willfil/SuitfiledandWilfuldefault Rejected' ; 
                                                        Ires.Result=false; 
                                                        //prashant
                                                        try{
                                                            upsert idvres;  
                                                            upsert listsuit;
                                                        }catch(Exception e)
                                                        {
                                                            system.debug('exception:-'+e);
                                                        }
                                                        //prashant ends;
                                                        return Ires;
                                                    }
                                                    else{
                                                        Ires.Status ='IDV Success' ; 
                                                        system.debug('CwDetails'+CwDetails);
                                                        Ires.Result=True;
                                                        //prashant
                                                        try{
                                                            system.debug('idvres:-'+idvres);
                                                            system.debug('listsuit:-'+listsuit);
                                                            //insert idvres;
                                                            upsert idvres ;                                                                                                           
                                                            upsert listsuit;
                                                        }catch(Exception e)
                                                        {
                                                            system.debug('exception:-'+e+' LINE NO:-'+e.getLineNumber());
                                                        }
                                                        //prashant ends;
                                                        return Ires;
                                                    }
                                                    
                                                }  
                                                
                                            }
                                            else{
                                                
                                                Ires.Status ='IDV Fail-IDNSDL' ;
                                                Ires.Result=false;
                                                //prashant
                                                try{
                                                    system.debug('idvres:-'+idvres);
                                                    system.debug('listsuit:-'+listsuit);
                                                    //insert idvres;
                                                    upsert idvres ;                                                                                                           
                                                    upsert listsuit;
                                                }catch(Exception e)
                                                {
                                                    system.debug('exception:-'+e+' LINE NO:-'+e.getLineNumber());
                                                }
                                                //prashant ends;
                                                return Ires;
                                            }
                                        }
                                        else{
                                            Ires.Status ='IDV Fail-Aadhar' ;
                                            Ires.Result=false;
                                            //prashant
                                            try{
                                                system.debug('idvres:-'+idvres);
                                                system.debug('listsuit:-'+listsuit);
                                                //insert idvres;
                                                upsert idvres ;                                                                                                           
                                                upsert listsuit;
                                            }catch(Exception e)
                                            {
                                                system.debug('exception:-'+e+' LINE NO:-'+e.getLineNumber());
                                            }
                                            //prashant ends;
                                            return Ires;
                                            
                                        }                                        // try{
                                        /*
if((!Utility.ISStringBlankorNull(cMatch.IDAadharNameMatch)) && (!Utility.ISStringBlankorNull(cMatch.IDAadharGenderMatch))&&(!Utility.ISStringBlankorNull(cMatch.IDAadharDOBYearMatch)))
{
if((integer.valueOf(cMatch.IDAadharNameMatch) >=80 ) && (integer.valueOf(cMatch.IDAadharGenderMatch) ==100) &&(integer.valueOf(cMatch.IDAadharDOBYearMatch) ==100))  
{
if(!Utility.ISStringBlankorNull(cMatch.IDNSDLNameMatch))
if(integer.valueOf(cMatch.IDNSDLNameMatch)>=80){
IDVResponseTU_HL.cls_WilfulDefaultDetails CwDetails=cCPV.WilfulDefaultDetails;
if((!Utility.ISStringBlankorNull(CwDetails.SuitfiledandWilfuldefault.status)) && (!Utility.ISStringBlankorNull(CwDetails.WilfulDefault.status))&&(!Utility.ISStringBlankorNull(CwDetails.SuitFiled.status))){

if(CwDetails.SuitfiledandWilfuldefault.status=='No'  && CwDetails.WilfulDefault.status=='No' && CwDetails.SuitFiled.status=='No'){                                                                                      
Ires.Status ='IDV Success' ; 
system.debug('CwDetails'+CwDetails);
Ires.Result=True;
return Ires;
}
else{
Ires.Status ='IDV SuitFilled/Willfil/SuitfiledandWilfuldefault Rejected' ; 
Ires.Result=false; 
return Ires;
}
}
}
else{
Ires.Status ='Pan MisMatch' ; 
Ires.Result=false;
return Ires;
}

}
else{
Ires.Status ='Aadhar MisMatch' ;
Ires.Result=false;
return Ires;
}
}*/
                                        //  }
                                        /* catch(exception e){

system.debug(e.getLineNumber()+''+e.getStackTraceString());
Ires.Status ='IDV Success' ; 
Ires.Result=True;
return Ires;
}  */
                                    }
                                    
                                }
                            }
                        }
                        
                        //prashant
                        upsert idvres;   
                        if(listsuit.size()>0)  upsert listsuit;
                        
                        //prashant ends  
                    }
                    
                }
                else if(cResp.Status=='Failed'||cResp.Status=='Server_Failure'){
                    system.debug('erroer');
                    Ires.Status ='IDV Status - Failed' ;
                    Ires.Result=false;
                    //idvres.Authentication__c=string.valueOf(cAut.Status);
                    //prashant
                    upsert idvres;   
                    if(listsuit.size()>0)  upsert listsuit;
                    
                    //prashant ends
                    return Ires;
                    
                }
                
                
            }
            return null;
        }
        catch(exception e){
            HandleBusinessException.captureError('CibilTUService', 'getIDV', e);
            system.debug(e.getMessage());
            system.debug(e.getLineNumber()+'sss'+e.getStackTraceString()+e.getMessage()+e.getCause());
        }
        return Ires;
    }
    
}