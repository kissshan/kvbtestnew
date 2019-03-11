/*
* Name    : WS_PreApproveCreateApp 
* Company : ET Marlabs
* Purpose : Pre Approved Loan For PL
* Author  : Prashant Singh
-----------------------------------------------------------------------
Version  Date         Author             Remarks                                                 
=======   ==========   =============  ==================================
*******************************************************************************************/
@RestResource(urlMapping='/preApproveCreateApp')

global class WS_PreApproveCreateApp {
    global class Response extends Ws_Response
    {
        
    }
    
    public class applicantRequest{
        public PrimaryApplicant applicants;        
        
        public applicantRequest(){
            applicants =new PrimaryApplicant();
        }
        
    }
    
    public class PrimaryApplicant{
        public string CustID;
        public String Tenure; 
        public String PreApprovedLoan; 
        public String RateOfInterest;
        public string EMI;
        public string SourcedBy;	
    }
    
    
    
    @HttpPost
    global static Response preApprove(){
        RestRequest req      = Restcontext.Request;
        RestResponse restRes = Restcontext.response;
        Response res         = new Response();
        
        if(req.requestBody == null){
            res.status          = Constants.WS_ERROR_STATUS;
            res.errorMessage    = Constants.WS_REQ_BODY_IS_NULL;
            res.statusCode      = Constants.WS_ERROR_CODE;
            return res;            
        }
        else
        {
            try{
                string jsonData = req.requestBody.toString();
                
                
                PrimaryApplicant applicantRequestobj=(PrimaryApplicant)Json.deserialize(jsonData, PrimaryApplicant.class);
				list<Account> AccObjList = new list<Account>([select id,Full_Name__c,PersonOtherCountry,PersonOtherState,PersonOtherPostalCode,PersonOtherCity,PersonMailingCountry,PersonMailingState,PersonMailingPostalCode,PersonMailingCity,PersonMailingStreet,PersonOtherStreet,CBS_Customer_ID__c,LastName,FirstName,MiddleName,Aadhaar_Number__pc,Pan_Number__c,Customer_IC__c,Father_Name__pc,PersonBirthdate,PersonMobilePhone,PersonEmail,Branch_Code__c,Branch_Name__c from Account where CBS_Customer_ID__c=:applicantRequestobj.CustID limit 1]);                
                 
                system.debug('applicantRequestobj:-'+applicantRequestobj); 
                list<PreApprovePL__c> PreAppvObjList=new list<PreApprovePL__c>([select id,Already_have_Pre_Approve_Loan__c,Communication_City__c,Communication_ZIPCODE__c,Communication_State__c,Permanent_Address__c,Permanent_City__c,Permanent_ZIPCODE__c,Permanent_State__c,Communication_Address__c,CIBIL_Score__c,Account_Number__c,Customer_ID__c,AQB__c,Customer_Last_Name__c,Customer_Middle_Name__c,Customer_First_Name__c,Adhaar_Number__c,PAN_Number__c,Customer_IC__c,Father_Name__c,Date_Of_Birth__c,Mobile_Number__c,Email_Address__c,Branch_Code__c,Branch_Name__c,Minimum_Tenure__c,Maximum_Tenure__c,Rate_Of_Interest__c,PreApproved_Loan__c from PreApprovePL__c where Customer_ID__c=:applicantRequestobj.CustID And  Already_have_Pre_Approve_Loan__c=false  limit 1]);
                if(PreAppvObjList.size()>0)
                {
                    
                    genesis__Applications__c app=new genesis__Applications__c(); 
                    
                    Boolean UniqFlag; 
                    UniqFlag = CreateUnique_App.checkuniqApp(PreAppvObjList[0].PAN_Number__c);  
                    if(UniqFlag)
                    {
                        res.status          = 'FAILED';
                        res.statusCode  = string.valueOf(genesis.Constants.HTTP_INTERNAL_ERROR);
                        res.errorMessage  = 'Currently another Loan Application is in process for this Customer.';                        
                        return res;
                    }
                    
                    
                    if((PreAppvObjList[0].Minimum_Tenure__c> Decimal.valueOf(applicantRequestobj.Tenure)) || (Decimal.valueOf(applicantRequestobj.Tenure) > PreAppvObjList[0].Maximum_Tenure__c ))
                    {
                        res.status          = 'FAILED';
                        res.statusCode  = string.valueOf(genesis.Constants.HTTP_INTERNAL_ERROR);
                        res.errorMessage  = 'Tenure should be more than '+PreAppvObjList[0].Minimum_Tenure__c+' and less than '+PreAppvObjList[0].Maximum_Tenure__c;                        
                        return res;                     
                    }
                    if(Decimal.valueOf(applicantRequestobj.RateOfInterest) !=PreAppvObjList[0].Rate_Of_Interest__c)
                    {
                        
                        res.status          = 'FAILED';
                        res.statusCode  = string.valueOf(genesis.Constants.HTTP_INTERNAL_ERROR);
                        res.errorMessage  = 'Rate Of Interest is incorrect. Kindly input the correct value.';                        
                        return res;
                    }
                    if(Decimal.valueOf(applicantRequestobj.PreApprovedLoan) >PreAppvObjList[0].PreApproved_Loan__c)
                    {
                        res.status          = 'FAILED';
                        res.statusCode  = string.valueOf(genesis.Constants.HTTP_INTERNAL_ERROR);
                        res.errorMessage  = 'Pre-Approved Loan of cust id: should be less than '+PreAppvObjList[0].PreApproved_Loan__c;                        
                        return res;
                    }
                    
                    //CREATING ACCOUNT IF NOT AVAILABLE IN LOS
                    if(AccObjList.size()==0)
                    {
                        string FullName='';
                        Account InstAcc=new Account();
                        InstAcc.CBS_Customer_ID__c=PreAppvObjList[0].Customer_ID__c; 
                        if(!Utility.ISStringBlankorNull(PreAppvObjList[0].Customer_First_Name__c))
                        {
                            InstAcc.FirstName=PreAppvObjList[0].Customer_First_Name__c;
                            FullName=FullName+PreAppvObjList[0].Customer_First_Name__c;
                        }
                        if(!Utility.ISStringBlankorNull(PreAppvObjList[0].Customer_Last_Name__c))
                        {
                            InstAcc.LastName=PreAppvObjList[0].Customer_Last_Name__c;
                            FullName=FullName+' '+PreAppvObjList[0].Customer_Last_Name__c;
                        }
                        
                        if(!Utility.ISStringBlankorNull(PreAppvObjList[0].Customer_Middle_Name__c))
                            InstAcc.MiddleName=PreAppvObjList[0].Customer_Middle_Name__c;
                        if(!Utility.ISStringBlankorNull((PreAppvObjList[0].Adhaar_Number__c)))
                            InstAcc.Aadhaar_Number__pc = PreAppvObjList[0].Adhaar_Number__c;
                        if(!Utility.ISStringBlankorNull(PreAppvObjList[0].PAN_Number__c))
                            InstAcc.Pan_Number__c =PreAppvObjList[0].PAN_Number__c;
                        if(!Utility.ISStringBlankorNull(PreAppvObjList[0].Customer_IC__c))
                            InstAcc.Customer_IC__c=PreAppvObjList[0].Customer_IC__c;
                        if(!Utility.ISStringBlankorNull(PreAppvObjList[0].Father_Name__c))
                            InstAcc.Father_Name__pc = PreAppvObjList[0].Father_Name__c;
                        if(!Utility.ISStringBlankorNull( string.valueOf(PreAppvObjList[0].Date_Of_Birth__c)))
                            InstAcc.PersonBirthdate = PreAppvObjList[0].Date_Of_Birth__c; 
                        if(!Utility.ISStringBlankorNull(PreAppvObjList[0].Mobile_Number__c))
                            InstAcc.PersonMobilePhone = PreAppvObjList[0].Mobile_Number__c;
                        if(!Utility.ISStringBlankorNull(PreAppvObjList[0].Email_Address__c))
                            InstAcc.PersonEmail = PreAppvObjList[0].Email_Address__c;
                        if(!Utility.ISStringBlankorNull(PreAppvObjList[0].Branch_Code__c))
                            InstAcc.Branch_Code__c = PreAppvObjList[0].Branch_Code__c;
                        if(!Utility.ISStringBlankorNull(PreAppvObjList[0].Branch_Name__c))
                            InstAcc.Branch_Name__c = PreAppvObjList[0].Branch_Name__c;
                        //COMMINUTION ADDRESS
                        if(!Utility.ISStringBlankorNull(PreAppvObjList[0].Communication_Address__c))
                            InstAcc.PersonMailingStreet=PreAppvObjList[0].Communication_Address__c;
                        if(!Utility.ISStringBlankorNull(PreAppvObjList[0].Communication_City__c))
                            InstAcc.PersonMailingCity=PreAppvObjList[0].Communication_City__c;
                        if(!Utility.ISStringBlankorNull(PreAppvObjList[0].Communication_ZIPCODE__c))
                            InstAcc.PersonMailingPostalCode=PreAppvObjList[0].Communication_ZIPCODE__c;
                        if(!Utility.ISStringBlankorNull(PreAppvObjList[0].Communication_State__c))
                            InstAcc.PersonMailingState=PreAppvObjList[0].Communication_State__c;
                        InstAcc.PersonMailingCountry='India';
                        
                        //PERMANANT ADDRESS
                        if(!Utility.ISStringBlankorNull(PreAppvObjList[0].Permanent_Address__c))
                            InstAcc.PersonOtherStreet=PreAppvObjList[0].Permanent_Address__c;
                        if(!Utility.ISStringBlankorNull(PreAppvObjList[0].Permanent_City__c))
                            InstAcc.PersonOtherCity=PreAppvObjList[0].Permanent_City__c;
                        if(!Utility.ISStringBlankorNull(PreAppvObjList[0].Permanent_ZIPCODE__c))
                            InstAcc.PersonOtherPostalCode=PreAppvObjList[0].Permanent_ZIPCODE__c;
                        if(!Utility.ISStringBlankorNull(PreAppvObjList[0].Permanent_State__c))
                            InstAcc.PersonOtherState=PreAppvObjList[0].Permanent_State__c; 
                        InstAcc.PersonOtherCountry='India';
                        
                        InstAcc.Full_Name__c =FullName; 
                        
                        insert InstAcc;
                        
                        AccObjList.add(InstAcc);
                    }
                    else{ //if Account data is not present  in  LOS then update account data with pre-approved pl master
                        
                        if(Utility.ISStringBlankorNull(AccObjList[0].Branch_Code__c))
                        {
                            AccObjList[0].Branch_Code__c=PreAppvObjList[0].Branch_Code__c;
                        }
                        if(Utility.ISStringBlankorNull(AccObjList[0].Branch_Name__c))
                        {
                            AccObjList[0].Branch_Name__c=PreAppvObjList[0].Branch_Name__c;
                            
                        }

                        
                        if(Utility.ISStringBlankorNull(AccObjList[0].FirstName))
                        {
                            AccObjList[0].FirstName=PreAppvObjList[0].Customer_First_Name__c;
                        }
                        if(Utility.ISStringBlankorNull(AccObjList[0].LastName))
                        {
                            AccObjList[0].LastName=PreAppvObjList[0].Customer_Last_Name__c;
                        }
                        if(Utility.ISStringBlankorNull(AccObjList[0].FirstName))
                        {
                            AccObjList[0].MiddleName=PreAppvObjList[0].Customer_Middle_Name__c;
                        }
                        
                        if(Utility.ISStringBlankorNull(AccObjList[0].Customer_IC__c)){
                            AccObjList[0].Customer_IC__c=PreAppvObjList[0].Customer_IC__c;
                        }                        
                        if(Utility.ISStringBlankorNull(AccObjList[0].Full_Name__c)){
                            AccObjList[0].Full_Name__c=(Utility.ISStringBlankorNull(PreAppvObjList[0].Customer_First_Name__c) ?'':PreAppvObjList[0].Customer_First_Name__c) +' '+(Utility.ISStringBlankorNull(PreAppvObjList[0].Customer_Last_Name__c) ?'':PreAppvObjList[0].Customer_Last_Name__c);
                        }
                        
                        if(Utility.ISStringBlankorNull(AccObjList[0].Aadhaar_Number__pc)){
                            AccObjList[0].Aadhaar_Number__pc=PreAppvObjList[0].Adhaar_Number__c;
                        }
                        if(Utility.ISStringBlankorNull(AccObjList[0].Pan_Number__c)){
                            AccObjList[0].Pan_Number__c=PreAppvObjList[0].PAN_Number__c;
                        }    
                        if(Utility.ISStringBlankorNull(AccObjList[0].Father_Name__pc)){
                            AccObjList[0].Father_Name__pc=PreAppvObjList[0].Father_Name__c;
                        }
                        if(Utility.ISStringBlankorNull(string.valueof(AccObjList[0].PersonBirthdate))){
                            AccObjList[0].PersonBirthdate=PreAppvObjList[0].Date_Of_Birth__c;
                        }  
                        
                        if(Utility.ISStringBlankorNull(AccObjList[0].PersonMobilePhone)){
                            AccObjList[0].PersonMobilePhone=PreAppvObjList[0].Mobile_Number__c;
                        }
                        if(Utility.ISStringBlankorNull(AccObjList[0].Pan_Number__c)){
                            AccObjList[0].PersonEmail=PreAppvObjList[0].Email_Address__c;
                        }    
                        if(Utility.ISStringBlankorNull(AccObjList[0].PersonMailingStreet)){
                            AccObjList[0].PersonMailingStreet=PreAppvObjList[0].Communication_Address__c;
                            system.debug('PersonMailingStreet:-'+AccObjList[0].PersonMailingStreet);
                        }
                        if(Utility.ISStringBlankorNull(AccObjList[0].PersonMailingCity)){
                            AccObjList[0].PersonMailingCity=PreAppvObjList[0].Communication_City__c;
                        }      
                        if(Utility.ISStringBlankorNull(AccObjList[0].PersonMailingPostalCode)){
                            AccObjList[0].PersonMailingPostalCode=PreAppvObjList[0].Communication_ZIPCODE__c;
                        }    
                        if(Utility.ISStringBlankorNull(AccObjList[0].PersonMailingState)){
                            AccObjList[0].PersonMailingState=PreAppvObjList[0].Communication_State__c;
                        }
                        if(Utility.ISStringBlankorNull(AccObjList[0].PersonMailingCountry)){
                        AccObjList[0].PersonMailingCountry='India';
                        }
                        
                        //PERMANANT ADDRESS
                        
                        if(Utility.ISStringBlankorNull(AccObjList[0].PersonOtherStreet)){
                            AccObjList[0].PersonOtherStreet=PreAppvObjList[0].Permanent_Address__c;
                        }
                        if(Utility.ISStringBlankorNull(AccObjList[0].PersonMailingCity)){
                            AccObjList[0].PersonOtherCity=PreAppvObjList[0].Permanent_City__c;
                        }      
                        
                        if(Utility.ISStringBlankorNull(AccObjList[0].PersonMailingPostalCode)){
                            AccObjList[0].PersonOtherPostalCode=PreAppvObjList[0].Permanent_ZIPCODE__c;
                        }    
                        if(Utility.ISStringBlankorNull(AccObjList[0].PersonOtherState)){
                            AccObjList[0].PersonOtherState=PreAppvObjList[0].Permanent_State__c;
                        }
                        if(Utility.ISStringBlankorNull(AccObjList[0].PersonOtherCountry)){
                            AccObjList[0].PersonOtherCountry='India';
                        }
                        update AccObjList[0];
                                               
    
                       
                        
                    }
                    
                    
                    Id AppRecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.PERSONALLOAN).getRecordTypeId(); 
                    app.genesis__Account__c=AccObjList[0].id;
                    app.RecordTypeId=AppRecordTypeId;
                    app.genesis__CL_Product__c = ApplicationService.getProduct(KVB_Company_Details__c.getOrgDefaults().PL_NAME__c).id;
                    if(!Utility.ISStringBlankorNull(PreAppvObjList[0].Branch_Code__c))
                        app.Branch_Code__c = PreAppvObjList[0].Branch_Code__c;
                    if(!Utility.ISStringBlankorNull(PreAppvObjList[0].Branch_Name__c))
                    {
                        app.Branch_Name__c = PreAppvObjList[0].Branch_Name__c;
                        app.Sourced_By_Office__c=PreAppvObjList[0].Branch_Name__c;
                    }
                    list<Branch_Master__c> brmstr=new list<Branch_Master__c>([select id,CODCCBRN__c,State__c,Active__c from Branch_Master__c where CODCCBRN__c=:PreAppvObjList[0].Branch_Code__c AND Active__c = true limit 1]);
                    list<State_Master__c> stmstr=new list<State_Master__c>();
                    if(brmstr.size()>0) 
                        stmstr=[select id,Name,Legal_desk_state_flag__c from State_Master__c where Name=:brmstr[0].State__c limit 1];
                    system.debug('stmstr:-'+stmstr);
                    if(stmstr.size()>0)
                        app.Legal_desk_state_flag__c=stmstr[0].Legal_desk_state_flag__c;
                    app.Pre_Approved_Flag__c=true;
                    app.Sub_Stage__c=Constants.AppCreateStage;
                    
                    if(!Utility.ISStringBlankorNull(string.valueOf(PreAppvObjList[0].Account_Number__c)))
                    {
                        app.Disbursement_Account_Number__c=PreAppvObjList[0].Account_Number__c;
                        app.SI_Account_Number__c=PreAppvObjList[0].Account_Number__c;   
                    }
                    string BankName='Karur Vysya Bank';
                    app.SI_Bank_Name__c=BankName;
                    app.Disbursement_Account_Bank_Name__c=BankName;
                    app.Is_GMRA_Policy_Selected__c=true;  
                    if(!Utility.ISStringBlankorNull(applicantRequestobj.SourcedBy))
                        app.Sourced_By__c=applicantRequestobj.SourcedBy;
                    
                    if(!Utility.ISStringBlankorNull(applicantRequestobj.EMI))
                    {
                        app.genesis__Payment_Amount__c=decimal.valueOf(applicantRequestobj.EMI);
                        app.Sanctioned_EMI__c=decimal.valueOf(applicantRequestobj.EMI);
                        app.EMI_Max__c=decimal.valueOf(applicantRequestobj.EMI);
                    }                
                    if(!Utility.ISStringBlankorNull(applicantRequestobj.Tenure))
                    {
                        app.genesis__Term__c=decimal.valueOf(applicantRequestobj.Tenure);
                        app.Sanctioned_Tenure__c=decimal.valueOf(applicantRequestobj.Tenure);
                    }
                    if(!Utility.ISStringBlankorNull(applicantRequestobj.RateOfInterest))
                        app.genesis__Interest_Rate__c=decimal.valueOf(applicantRequestobj.RateOfInterest);
                    if(!Utility.ISStringBlankorNull(applicantRequestobj.PreApprovedLoan))
                    {
                        app.genesis__Loan_Amount__c=decimal.valueOf(applicantRequestobj.PreApprovedLoan);
                        app.Sanction_Authority_Limit__c=decimal.valueOf(applicantRequestobj.PreApprovedLoan);
                    }
                    NumberToWordConversion ntwc = new NumberToWordConversion();
                    app.Sanction_Amount_Words__c=ntwc.getNumberTOWordConvertion(decimal.valueOf(applicantRequestobj.PreApprovedLoan));       
                    insert app;
                    //updating  Already have Pre Approve Loan  check box  so that customer will not take other pre approve loan.
                    PreAppvObjList[0].Already_have_Pre_Approve_Loan__c=true;
                    update PreAppvObjList[0];
                    
                    
                    
                    //FOLDER FOR PRE APPROVED LOAN
                    genesis__Applications__c Applicatoin=[select id,Pre_Approved_Flag__c,Sanction_Authority_Limit__c,Sanctioned_EMI__c,Created_Date__c,name,Record_Type_Name__c from genesis__Applications__c where ID=:App.id limit 1];
                    APPDocCategoryCreation.CreateDocCat(Applicatoin,AccObjList[0],true);
                    
                    //CREATING  PARTY WITH PARTY_TYPE PRIMARY APPLICANT 
                    genesis__Application_Parties__c Party=new genesis__Application_Parties__c();
                    party.genesis__Party_Account_Name__c = AccObjList[0].id;
                    party.genesis__Party_Type__c =Constants.PRIMARY_APP;
                    party.genesis__Application__c = app.id;
                    party.Key_Contact__c=App.genesis__Account__c;
                    party.Is_Existing_Customer__c=true;
                    if(!Utility.ISStringBlankorNull(string.valueOf(PreAppvObjList[0].AQB__c)))
                        party.Average_Balances_6_months__c=PreAppvObjList[0].AQB__c;
                    if(!Utility.ISStringBlankorNull(string.valueOf(PreAppvObjList[0].CIBIL_Score__c)))
                        party.CIBIL_Scores__c=PreAppvObjList[0].CIBIL_Score__c; 
                    party.Product_Type__c='PL';
                    if(!Utility.ISStringBlankorNull(string.valueOf(PreAppvObjList[0].Account_Number__c)))
                        party.Bank_Account_Number__c=PreAppvObjList[0].Account_Number__c;
                    party.Financial_Applicant__c=true;
                    party.Eligible_EMI1__c=Applicatoin.Sanctioned_EMI__c;               
                    insert party;
                    
                    //GMRA CALCULATION
                    GmraCal.GmraCalculations(Applicatoin.id);
                    Applicatoin.Final_GMRA__c=GmraCal.preApprvGmraVar;
                    Applicatoin.Sanction_Date__c=Applicatoin.Created_Date__c;
                    system.debug('GmraCal.preApprvGmraVar:-'+GmraCal.preApprvGmraVar);
                    Applicatoin.Disbursement_Amount__c=Applicatoin.Sanction_Authority_Limit__c;
                    Applicatoin.genesis__Loan_Amount__c=Applicatoin.Sanction_Authority_Limit__c+GmraCal.preApprvGmraVar;// in processing fee class  this tag is use to calculate processing fee charge which include (GMRA)
                    Applicatoin.Sanction_Authority_Limit__c=Applicatoin.Sanction_Authority_Limit__c+GmraCal.preApprvGmraVar;
                    
                    
                    //PROCESSING FEE CALCULATION INCLUDING GMRA VALUE
                    Applicatoin.Sub_Stage__c=Constants.PersonalDetailsCapt;
                    update Applicatoin;
                    
                    Applicatoin.genesis__Payment_Amount__c=Applicatoin.Sanction_Authority_Limit__c;
                    Applicatoin.Sanction_Amount_Words__c=ntwc.getNumberTOWordConvertion(Applicatoin.Sanction_Authority_Limit__c);
                    
                    
                    //FOR EMAIL TRIGGER
                    Applicatoin.Sub_Stage__c=Constants.PL_LOAN_STP;
                    update Applicatoin;
                    
                    //APPLICATION LAND TO SI DETAIL CAPTURED
                    system.debug('Application  si detail captured');
                    ApplicationTriggerHandler.IsFirstRun=true;
                    Applicatoin.Sub_Stage__c=Constants.SI_DETAILS_CAPTURED_SUBSTAGE;
                    update Applicatoin;
                    
                    
                    res.status          = 'SUCCESS';
                    res.statusCode  = string.valueOf(genesis.Constants.HTTP_INTERNAL_ERROR);
                    res.successMessage  = 'Application Created Successfully with Application Number '+Applicatoin.Name;                        
                    return res;                
                    
                }
                
                else 
                {
                    
                    res.status          = 'FAILED';
                    res.statusCode  = string.valueOf(genesis.Constants.HTTP_INTERNAL_ERROR);
                    res.errorMessage  = 'Customer is not applicable For Pre-Approved Loan. Kindly contact your nearest branch to avail a personal loan.';                
                    return res;
                    
                }
                
                
                
                
            }catch(Exception e)
            {
                system.debug('123'+e.getMessage()+' Stack '+e.getStackTraceString());
                res.status          = 'ERROR';
                res.statusCode  = string.valueOf(genesis.Constants.HTTP_INTERNAL_ERROR);
                res.errorMessage  = e.getMessage();
                
                return res;			
            }
        }
    }
    
}