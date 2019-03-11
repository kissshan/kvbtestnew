/*
* Name          : Test_WS_Vendor_CreateApplicationAndAccount
* Company       : ET Marlabs
* Class         : WS_Vendor_CreateApplicationAndAccount
* Code coverage : 92%
* Author        : Bhavya P
*/
@isTest
public class Test_WS_Vendor_CreateApplication{

    @testSetup static void setup() {
         WS_Vendor_TestUtil.createUser();
    }
    
   @istest
    public static void method1() {         
        WS_Vendor_TestUtil.kvbCompanyDetails();
        WS_Vendor_TestUtil.productDetails();
        WS_Vendor_TestUtil.createCustomSettingRecords();
        String jsonString ='{"SourcedBy": "CHFL","SourcedByOffice": "Karur","InterestRate": "11","LoanAmount": "1000000","SanctionDate": "2018-09-09",  "EMISanctioned": "4453","BranchCode": "4843","BranchName": "ASDF","SanctionedTerm": "2","HolidayPeriod": "5","TotalRepayAmount": "1000000",  "ReqLoanAmount": "1000000","ReqTerm": "4","ReqEMI": "5567","ChargePaymentComplete": "true","DateOfDisbursement": "2018-09-28",'+  
        +'"DisbursementAmount": "600000","DateOfAdvancePayment": "2018-09-30","AdvancePaid": "6789","SaleAgreementDate": "2018-09-30","MarginToPay": "129444","Margin": "13","TypeOfCharge": "First Charge","RERAComplaint": "False","LoanAccNo": "981236876598","LoanPurpose": "Purchase of Identified Property","FIVerDate": "2018-09-30","FISuccess":"Yes","DisbAccBank": "KVB","DisbAccBranch": "Karur","DisbAccIFSC": "KA871323","DisbAccNo": "123310973112","SIAccNo": "779791213","SIBank": "Axis",'+
        +'"SIBranch": "Matunga","SIIFSC": "AX98679","SIApplicant": "Dipen","ExcessMCLR": "0.45","MCLRType": "One Year","PreClosureRate": "2.45","MCLRRate": "9.5","CASAAccNo": "87110822423","MODDate": "2017-12-30","CKYC": "uadcjknbkwcn87998","Scource_Type": "Centrum Housing Finance",  "Type_Of_Loan": "HL","Third_party_loan_account_no": "", "KVB_Amount_Sanction": "","ApplicantDetails": {"FirstName": "James","MiddleName": "A",'+
        +'"LastName": "Corden","FullName":"James Corden","PAN": "CCPMA1867T","AadharNumber": "TestRef123456789","CBSCustId": "987970","Title": "Mr","Nationality": "Indian","Gender": "Male","Caste": "General","BirthDate": "1990-09-28","FatherName": "Cshkj","HusbandName": "","BankingWithUs": "","Religion": "Christian","ExServiceMan": "False","PhysicallyHandicapped": "False","VoterId": "SFWA1231","DrivingLicId": "trdfe45","RationCard": "234567yt","PassportNo": "P987654","PassportExpDate": "2025-08-07",'+        
        +'"OtherId": "rtyu6","OtherIdNo": "tyu7","CurrentAddress": "12/23,4th cross,Hsr layout","CurrentCity": "Bangalore","CurrentState": "Karnataka","CurrentCountry": "Indian","CurrentZip": "560072","PermanentAddress": "12/23,4th cross,Hsr layout","PermanentCity": "Bangalore","PermanentState": "Karnataka","PermanentCountry": "Indian","PermanentZip": "560072","PhoneNo": "9908876654","Mobile": "9876543210","Email": "ads@gmail.com","Fax": "232323","RelatedToDirector": "False",'+
        +'"DirectorBank": "Karur","DirectorName": "Molly","CibilScore": "764","EmploymentType": "Salaried","CompanyName": "IBM","GroupCompanyAddress": "Bangalore","CompanyPIN": "567543","CompanyFax": "","CompanyEmail": "test@marlabs1234.com","CompanyPhone": "9434234567","CustomerType": "Primary Applicant","FinancialApplicant": "","AltMobile": "9967867854","Landline": "080234567","Experience": "2","ClaimedNMIITR": "1245678",'+
        +'"ClaimedAgriIncome": "457890","ApprovedAgriIncome": "400000","ExistingEMIClaimed": "4567","PerfiosEMI": "6789","CIBILEMI": "7890","KVBEMI": "5567","CIBILEMIOverride": "","ComputedEMI": "","ExistingEMIApproved": "5567","TotalChequeBounce": "0","PrimaryBank": "Axis","PrimaryBranch": "Karur","PrimaryAccNo": "1234567","PrimaryIFSC": "KVB67890","GrossIncome1": "823456","AnnualCapGain1": "823456",'+
        +'"InterestIncome1": "45679","AnnualTax1": "45679","DividendIncome1": "0","ShareOfProfit1": "0","AgricultureITR1": "0","GrossIncome2": "0","AnnualCapGain2": "0","InterestIncome2": "0","AnnualTax2": "0","DividendIncome2": "0","ShareOfProfit2": "0","AgricultureITR2": "0","SalaryPaid": "9800000","TaxDeducted": "98790.99","OtherReccuringIncome": "0","EstimatedBusinessIncome": "876544","CustomerIC": "KHK65467","Title_Holder": "true"}}';
        RestRequest req = new RestRequest();     
        req.requestURI = '/services/apexrest/createApplication';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        test.starttest();
            WS_Vendor_CreateApplicationAndAccount.insertApplication();
        test.stoptest();
    }

    @isTest
    public static void method2() {         
        WS_Vendor_TestUtil.kvbCompanyDetails();
        WS_Vendor_TestUtil.productDetails();
        WS_Vendor_TestUtil.createAccount();
        WS_Vendor_TestUtil.createCustomSettingRecords();
        String jsonString ='{"SourcedBy": "CHFL","SourcedByOffice": "Karur","InterestRate": "11","LoanAmount": "1000000","SanctionDate": "2018-09-09",  "EMISanctioned": "4453","BranchCode": "4843","BranchName": "ASDF","SanctionedTerm": "2","HolidayPeriod": "5","TotalRepayAmount": "1000000",  "ReqLoanAmount": "1000000","ReqTerm": "4","ReqEMI": "5567","ChargePaymentComplete": "true","DateOfDisbursement": "2018-09-28",'+  
        +'"DisbursementAmount": "600000","DateOfAdvancePayment": "2018-09-30","AdvancePaid": "6789","SaleAgreementDate": "2018-09-30","MarginToPay": "129444","Margin": "13","TypeOfCharge": "First Charge","RERAComplaint": "False","LoanAccNo": "981236876598","LoanPurpose": "Purchase of Identified Property","FIVerDate": "2018-09-30","FISuccess":"Yes","DisbAccBank": "KVB","DisbAccBranch": "Karur","DisbAccIFSC": "KA871323","DisbAccNo": "123310973112","SIAccNo": "779791213","SIBank": "Axis",'+
        +'"SIBranch": "Matunga","SIIFSC": "AX98679","SIApplicant": "Dipen","ExcessMCLR": "0.45","MCLRType": "One Year","PreClosureRate": "2.45","MCLRRate": "9.5","CASAAccNo": "87110822423","MODDate": "2017-12-30","CKYC": "uadcjknbkwcn87998","Scource_Type": "Centrum Housing Finance",  "Type_Of_Loan": "HL","Third_party_loan_account_no": "", "KVB_Amount_Sanction": "","ApplicantDetails": {"FirstName": "James","MiddleName": "A",'+
        +'"LastName": "Corden","FullName":"James Corden","PAN": "CCPMA1867T","AadharNumber": "TestRef123456789","CBSCustId": "987970","Title": "Mr","Nationality": "Indian","Gender": "Male","Caste": "General","BirthDate": "1990-09-28","FatherName": "Cshkj","HusbandName": "","BankingWithUs": "","Religion": "Christian","ExServiceMan": "False","PhysicallyHandicapped": "False","VoterId": "SFWA1231","DrivingLicId": "trdfe45","RationCard": "234567yt","PassportNo": "P987654","PassportExpDate": "2025-08-07",'+        
        +'"OtherId": "rtyu6","OtherIdNo": "tyu7","CurrentAddress": "12/23,4th cross,Hsr layout","CurrentCity": "Bangalore","CurrentState": "Karnataka","CurrentCountry": "Indian","CurrentZip": "560072","PermanentAddress": "12/23,4th cross,Hsr layout","PermanentCity": "Bangalore","PermanentState": "Karnataka","PermanentCountry": "Indian","PermanentZip": "560072","PhoneNo": "9908876654","Mobile": "9876543210","Email": "ads@gmail.com","Fax": "232323","RelatedToDirector": "False",'+
        +'"DirectorBank": "Karur","DirectorName": "Molly","CibilScore": "764","EmploymentType": "Salaried","CompanyName": "IBM","GroupCompanyAddress": "Bangalore","CompanyPIN": "567543","CompanyFax": "","CompanyEmail": "test@marlabs1234.com","CompanyPhone": "9434234567","CustomerType": "Primary Applicant","FinancialApplicant": "","AltMobile": "9967867854","Landline": "080234567","Experience": "2","ClaimedNMIITR": "1245678",'+
        +'"ClaimedAgriIncome": "457890","ApprovedAgriIncome": "400000","ExistingEMIClaimed": "4567","PerfiosEMI": "6789","CIBILEMI": "7890","KVBEMI": "5567","CIBILEMIOverride": "","ComputedEMI": "","ExistingEMIApproved": "5567","TotalChequeBounce": "0","PrimaryBank": "Axis","PrimaryBranch": "Karur","PrimaryAccNo": "1234567","PrimaryIFSC": "KVB67890","GrossIncome1": "823456","AnnualCapGain1": "823456",'+
        +'"InterestIncome1": "45679","AnnualTax1": "45679","DividendIncome1": "0","ShareOfProfit1": "0","AgricultureITR1": "0","GrossIncome2": "0","AnnualCapGain2": "0","InterestIncome2": "0","AnnualTax2": "0","DividendIncome2": "0","ShareOfProfit2": "0","AgricultureITR2": "0","SalaryPaid": "9800000","TaxDeducted": "98790.99","OtherReccuringIncome": "0","EstimatedBusinessIncome": "876544","CustomerIC": "KHK65467","Title_Holder": "true"}}';
        RestRequest req = new RestRequest();     
        req.requestURI = '/services/apexrest/createApplication';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        test.starttest();
            WS_Vendor_CreateApplicationAndAccount.insertApplication();
        test.stoptest();
    } 

    @isTest
    public static void method3() {         
        WS_Vendor_TestUtil.kvbCompanyDetails();
        WS_Vendor_TestUtil.productDetails();
        WS_Vendor_TestUtil.createAccount();
        WS_Vendor_TestUtil.createCustomSettingRecords();
        String jsonString ='{"SourcedBy": "CHFL","SourcedByOffice": "Karur","InterestRate": "11","LoanAmount": "1000000","SanctionDate": "2018-09-09",  "EMISanctioned": "4453","BranchCode": "4843","BranchName": "ASDF","SanctionedTerm": "2","HolidayPeriod": "5","TotalRepayAmount": "1000000",  "ReqLoanAmount": "1000000","ReqTerm": "4","ReqEMI": "5567","ChargePaymentComplete": "true","DateOfDisbursement": "2018-09-28",'+  
        +'"DisbursementAmount": "600000","DateOfAdvancePayment": "2018-09-30","AdvancePaid": "6789","SaleAgreementDate": "2018-09-30","MarginToPay": "129444","Margin": "13","TypeOfCharge": "First Charge","RERAComplaint": "False","LoanAccNo": "981236876598","LoanPurpose": "Purchase of Identified Property","FIVerDate": "2018-09-30","FISuccess":"Yes","DisbAccBank": "KVB","DisbAccBranch": "Karur","DisbAccIFSC": "KA871323","DisbAccNo": "123310973112","SIAccNo": "779791213","SIBank": "Axis",'+
        +'"SIBranch": "Matunga","SIIFSC": "AX98679","SIApplicant": "Dipen","ExcessMCLR": "0.45","MCLRType": "One Year","PreClosureRate": "2.45","MCLRRate": "9.5","CASAAccNo": "87110822423","MODDate": "2017-12-30","CKYC": "uadcjknbkwcn87998","Scource_Type": "Centrum Housing Finance",  "Type_Of_Loan": "LAP","Third_party_loan_account_no": "", "KVB_Amount_Sanction": "","ApplicantDetails": {"FirstName": "James","MiddleName": "A",'+
        +'"LastName": "Corden","FullName":"James Corden","PAN": "CCPMA1867T","AadharNumber": "TestRef123456789","CBSCustId": "987970","Title": "Mr","Nationality": "Indian","Gender": "Male","Caste": "General","BirthDate": "1990-09-28","FatherName": "Cshkj","HusbandName": "","BankingWithUs": "","Religion": "Christian","ExServiceMan": "False","PhysicallyHandicapped": "False","VoterId": "SFWA1231","DrivingLicId": "trdfe45","RationCard": "234567yt","PassportNo": "P987654","PassportExpDate": "2025-08-07",'+        
        +'"OtherId": "rtyu6","OtherIdNo": "tyu7","CurrentAddress": "12/23,4th cross,Hsr layout","CurrentCity": "Bangalore","CurrentState": "Karnataka","CurrentCountry": "Indian","CurrentZip": "560072","PermanentAddress": "12/23,4th cross,Hsr layout","PermanentCity": "Bangalore","PermanentState": "Karnataka","PermanentCountry": "Indian","PermanentZip": "560072","PhoneNo": "9908876654","Mobile": "9876543210","Email": "ads@gmail.com","Fax": "232323","RelatedToDirector": "False",'+
        +'"DirectorBank": "Karur","DirectorName": "Molly","CibilScore": "764","EmploymentType": "Salaried","CompanyName": "IBM","GroupCompanyAddress": "Bangalore","CompanyPIN": "567543","CompanyFax": "","CompanyEmail": "test@marlabs1234.com","CompanyPhone": "9434234567","CustomerType": "Primary Applicant","FinancialApplicant": "","AltMobile": "9967867854","Landline": "080234567","Experience": "2","ClaimedNMIITR": "1245678",'+
        +'"ClaimedAgriIncome": "457890","ApprovedAgriIncome": "400000","ExistingEMIClaimed": "4567","PerfiosEMI": "6789","CIBILEMI": "7890","KVBEMI": "5567","CIBILEMIOverride": "","ComputedEMI": "","ExistingEMIApproved": "5567","TotalChequeBounce": "0","PrimaryBank": "Axis","PrimaryBranch": "Karur","PrimaryAccNo": "1234567","PrimaryIFSC": "KVB67890","GrossIncome1": "823456","AnnualCapGain1": "823456",'+
        +'"InterestIncome1": "45679","AnnualTax1": "45679","DividendIncome1": "0","ShareOfProfit1": "0","AgricultureITR1": "0","GrossIncome2": "0","AnnualCapGain2": "0","InterestIncome2": "0","AnnualTax2": "0","DividendIncome2": "0","ShareOfProfit2": "0","AgricultureITR2": "0","SalaryPaid": "9800000","TaxDeducted": "98790.99","OtherReccuringIncome": "0","EstimatedBusinessIncome": "876544",'+
        +'"CustomerIC": "KHK65467","Residential_Status": "","CompanyDetails": [{"CBS_Customer_ID": "","Company_name": "ET-Marlabs","Company_type": "Primary","Relationship_with_Company": "Main","Company_PAN": "ASDD123P","Company_Address": "54 bangalore","Company_Pincode": "700075","Company_City": "BANGALORE","Company_State":"KARNATAKA"},'+
        +'{"CBS_Customer_ID": "","Company_name": "ET-Marlabs2","Company_type": "Primary","Relationship_with_Company": "Second","Company_PAN": "ASDD923P","Company_Address": "54 bangalore","Company_Pincode": "700075","Company_City": "BANGALORE","Company_State":"KARNATAKA"}]}}';
        RestRequest req = new RestRequest();     
        req.requestURI = '/services/apexrest/createApplication';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        test.starttest();
            WS_Vendor_CreateApplicationAndAccount.insertApplication();
        test.stoptest();
    }

    @isTest
    public static void method4() {         
        WS_Vendor_TestUtil.kvbCompanyDetails();
        WS_Vendor_TestUtil.productDetails();
        WS_Vendor_TestUtil.createAccount();
        WS_Vendor_TestUtil.createBusinessAccount();
        WS_Vendor_TestUtil.createCustomSettingRecords();
        String jsonString ='{"SourcedBy": "CHFL","SourcedByOffice": "Karur","InterestRate": "11","LoanAmount": "1000000","SanctionDate": "2018-09-09",  "EMISanctioned": "4453","BranchCode": "4843","BranchName": "ASDF","SanctionedTerm": "2","HolidayPeriod": "5","TotalRepayAmount": "1000000",  "ReqLoanAmount": "1000000","ReqTerm": "4","ReqEMI": "5567","ChargePaymentComplete": "true","DateOfDisbursement": "2018-09-28",'+  
        +'"DisbursementAmount": "600000","DateOfAdvancePayment": "2018-09-30","AdvancePaid": "6789","SaleAgreementDate": "2018-09-30","MarginToPay": "129444","Margin": "13","TypeOfCharge": "First Charge","RERAComplaint": "False","LoanAccNo": "981236876598","LoanPurpose": "Purchase of Identified Property","FIVerDate": "2018-09-30","FISuccess":"Yes","DisbAccBank": "KVB","DisbAccBranch": "Karur","DisbAccIFSC": "KA871323","DisbAccNo": "123310973112","SIAccNo": "779791213","SIBank": "Axis",'+
        +'"SIBranch": "Matunga","SIIFSC": "AX98679","SIApplicant": "Dipen","ExcessMCLR": "0.45","MCLRType": "One Year","PreClosureRate": "2.45","MCLRRate": "9.5","CASAAccNo": "87110822423","MODDate": "2017-12-30","CKYC": "uadcjknbkwcn87998","Scource_Type": "Centrum Housing Finance",  "Type_Of_Loan": "LAP","Third_party_loan_account_no": "18675432189076", "KVB_Amount_Sanction": "1000000","ApplicantDetails": {"FirstName": "Ja","MiddleName": "",'+
        +'"LastName": "Co","FullName":"Ja Co","PAN": "CCPMA1867T","AadharNumber": "TestRef123456789","CBSCustId": "987970","Title": "Mr","Nationality": "Indian","Gender": "Male","Caste": "General","BirthDate": "1990-12-08","FatherName": "Cshkj","HusbandName": "","BankingWithUs": "","Religion": "Christian","ExServiceMan": "False","PhysicallyHandicapped": "False","VoterId": "SFWA1231","DrivingLicId": "trdfe45","RationCard": "234567yt","PassportNo": "P987654","PassportExpDate": "2025-08-07",'+        
        +'"OtherId": "rtyu6","OtherIdNo": "tyu7","CurrentAddress": "12/23,4th cross,Hsr layout","CurrentCity": "Bangalore","CurrentState": "Karnataka","CurrentCountry": "Indian","CurrentZip": "560072","PermanentAddress": "12/23,4th cross,Hsr layout","PermanentCity": "Bangalore","PermanentState": "Karnataka","PermanentCountry": "Indian","PermanentZip": "560072","PhoneNo": "9908876654","Mobile": "9876543210","Email": "ads@gmail.com","Fax": "232323","RelatedToDirector": "False",'+
        +'"DirectorBank": "Karur","DirectorName": "Molly","CibilScore": "764","EmploymentType": "Salaried","CompanyName": "IBM","GroupCompanyAddress": "Bangalore","CompanyPIN": "567543","CompanyFax": "123","CompanyEmail": "test@marlabs1234.com","CompanyPhone": "9434234567","CustomerType": "","FinancialApplicant": "","AltMobile": "9967867854","Landline": "080234567","Experience": "2","ClaimedNMIITR": "1245678",'+
        +'"ClaimedAgriIncome": "457890","ApprovedAgriIncome": "400000","ExistingEMIClaimed": "4567","PerfiosEMI": "6789","CIBILEMI": "7890","KVBEMI": "5567","CIBILEMIOverride": "123","ComputedEMI": "","ExistingEMIApproved": "5567","TotalChequeBounce": "0","PrimaryBank": "Axis","PrimaryBranch": "Karur","PrimaryAccNo": "1234567","PrimaryIFSC": "KVB67890","GrossIncome1": "823456","AnnualCapGain1": "823456","Average_CASA_Balance":"1234",'+
        +'"InterestIncome1": "45679","AnnualTax1": "45679","DividendIncome1": "0","ShareOfProfit1": "0","AgricultureITR1": "0","GrossIncome2": "0","AnnualCapGain2": "0","InterestIncome2": "0","AnnualTax2": "0","DividendIncome2": "0","ShareOfProfit2": "0","AgricultureITR2": "0","GrossIncome3": "100000","AnnualCapGain3": "5000","InterestIncome3": "5000","AnnualTax3": "6789","DividendIncome3": "56789","ShareOfProfit3": "7890","AgricultureITR3": "7890","SalaryPaid": "9800000","TaxDeducted": "98790.99","OtherReccuringIncome": "0","EstimatedBusinessIncome": "876544",'+
        +'"CustomerIC": "KHK65467","Residential_Status": "TestAddress","CompanyDetails": [{"CBS_Customer_ID": "","Company_name": "ET-Marlabs","Company_type": "Primary","Relationship_with_Company": "Main","Company_PAN": "ASDD123P","Company_Address": "54 bangalore","Company_Pincode": "700075","Company_City": "BANGALORE","Company_State":"KARNATAKA"},'+
        +'{"CBS_Customer_ID": "","Company_name": "ET-Marlabs2","Company_type": "Primary","Relationship_with_Company": "Second","Company_PAN": "ASDD923P","Company_Address": "54 bangalore","Company_Pincode": "700075","Company_City": "BANGALORE","Company_State":"KARNATAKA"}]}}';
        RestRequest req = new RestRequest();     
        req.requestURI = '/services/apexrest/createApplication';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        test.starttest();
            WS_Vendor_CreateApplicationAndAccount.insertApplication();
        test.stoptest();
    }

    @isTest
    public static void method5() {         
        WS_Vendor_TestUtil.kvbCompanyDetails();
        WS_Vendor_TestUtil.productDetails();
        WS_Vendor_TestUtil.createAccount();
        WS_Vendor_TestUtil.createBusinessAccount();
        WS_Vendor_TestUtil.createCustomSettingRecords();
        
        //WS_Vendor_TestUtil.createUser();
        String jsonString ='{"SourcedBy": "CHFL","SourcedByOffice": "Karur","InterestRate": "11","LoanAmount": "1000000","SanctionDate": "2018-09-09",  "EMISanctioned": "4453","BranchCode": "1440","BranchName": "ASDF","SanctionedTerm": "2",'+
                            +'"TotalRepayAmount": "1000000","ReqLoanAmount": "1000000","ReqTerm": "4","ReqEMI": "5567","ChargePaymentComplete": "true","DateOfDisbursement": "2018-09-28","DisbursementAmount": "600000","MarginToPay": "129444","Margin": "13","TypeOfCharge": "First Charge","LoanAccNo": "981236876598",'+
                            +'"LoanPurpose": "Purchase of Identified Property","FIVerDate": "2018-09-30","FISuccess":"Yes","DisbAccBank": "KVB","DisbAccBranch": "Karur","DisbAccIFSC": "KA871323","DisbAccNo": "123310973112","SIAccNo": "779791213","SIBank": "Axis",'+
                            +'"SIBranch": "Matunga","SIIFSC": "AX98679","SIApplicant": "Dipen","ExcessMCLR": "0.45","MCLRType": "One Year","PreClosureRate": "2.45","MCLRRate": "9.5","CASAAccNo": "87110822423","CKYC": "uadcjknbkwcn87998","CBR_Code": "SRIRA09051977M","PL_Score": "757",'+
                            +'"Scource_Type": "Loan Singh",  "Type_Of_Loan": "PL","Third_party_loan_account_no": "", "KVB_Amount_Sanction": "","ApplicantDetails": {"FirstName": "James","MiddleName": "","LastName": "Corden","FullName":"Linkin Park","PAN": "CCPMA1867T",'+
                            +'"AadharNumber": "Ref123456789","CBSCustId": "987970","Title": "Mr","Nationality": "Indian", "Gender": "Male","Caste": "General","BirthDate": "1990-09-28","FatherName": "Cshkj","HusbandName": "TestHusband","BankingWithUs": "2016-09-01","Religion": "",'+
                            +'"ExServiceMan": "False","PhysicallyHandicapped": "False","VoterId": "SFWA1231","DrivingLicId": "KA345678","RationCard": "RA2341","PassportNo": "12356R","PassportExpDate": "","OtherId": "",'+
                            +'"OtherIdNo": "","CurrentAddress": "12/23,4th cross,Hsr layout","CurrentCity": "Bangalore","CurrentState": "Karnataka","CurrentCountry": "Indian","CurrentZip": "560072","PermanentAddress": "","PermanentCity": "",'+
                            +'"PermanentState": "","PermanentCountry": "","PermanentZip": "","PhoneNo": "","Mobile": "9876543210","Email": "ads@gmail.com","Fax": "232323","RelatedToDirector": "False","DirectorBank": "","DirectorName": "","CibilScore": "764","EmploymentType": "Salaried","CompanyName": "IBM","GroupCompanyAddress": "","CompanyPIN": "","CompanyFax": "","CompanyEmail": "",'+
                            +'"CompanyPhone": "","CustomerType": "Primary Applicant","FinancialApplicant": "","AltMobile": "","Landline": "","Experience": "","ClaimedNMIITR": "","ClaimedAgriIncome": "","ApprovedAgriIncome": "","ExistingEMIClaimed": "",'+
                            +'"PerfiosEMI": "","CIBILEMI": "","KVBEMI": "","CIBILEMIOverride": "","ExistingEMIApproved": "","PrimaryBank": "Axis","PrimaryBranch": "","PrimaryIFSC": "",'+
                            +'"AnnualCapGain1": "100000","InterestIncome1": "100000","DividendIncome1": "100000","AgricultureITR1": "100000","AnnualCapGain2": "500","InterestIncome2": "500","DividendIncome2": "500","ShareOfProfit2": "500","AgricultureITR2": "500","SalaryPaid": "9800000",'+
                            +'"TaxDeducted": "98790.99","OtherReccuringIncome": "","EstimatedBusinessIncome": "","CustomerIC": "KHK65467","Residential_Status": "","Average_CASA_Balance": "",  "Policy_type": "",'+
                            +'"Policy_number": "1234567","Insure_date": "2018-08-09","Expiry_date": "2028-08-09","Upload_insurance_policy": "false","Is_KVB_designated_assignee": "No","Standing_instruction": "Yes" }  }';
        RestRequest req = new RestRequest();     
        req.requestURI = '/services/apexrest/createApplication';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        test.starttest();
            WS_Vendor_CreateApplicationAndAccount.insertApplication();
        test.stoptest();
    } 

    @isTest
    public static void method6() {         
        String jsonString ='';
        RestRequest req = new RestRequest();     
        req.requestURI = '/services/apexrest/createApplication';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        test.starttest();
            WS_Vendor_CreateApplicationAndAccount.insertApplication();
        test.stoptest();
    } 

    @istest
    public static void method7() {         
        WS_Vendor_TestUtil.kvbCompanyDetails();
        WS_Vendor_TestUtil.productDetails();
        String jsonString ='{"SourcedBy": "CHFL","SourcedByOffice": "Karur","InterestRate": "testDatatypeError","LoanAmount": "1000000","SanctionDate": "2018-09-09",  "EMISanctioned": "4453","BranchCode": "4843","BranchName": "ASDF","SanctionedTerm": "2","HolidayPeriod": "5","TotalRepayAmount": "1000000",  "ReqLoanAmount": "1000000","ReqTerm": "4","ReqEMI": "5567","ChargePaymentComplete": "true","DateOfDisbursement": "2018-09-28",'+  
        +'"DisbursementAmount": "600000","DateOfAdvancePayment": "2018-09-30","AdvancePaid": "6789","SaleAgreementDate": "2018-09-30","MarginToPay": "129444","Margin": "13","TypeOfCharge": "First Charge","RERAComplaint": "False","LoanAccNo": "981236876598","LoanPurpose": "Purchase of Identified Property","FIVerDate": "2018-09-30","FISuccess":"Yes","DisbAccBank": "KVB","DisbAccBranch": "Karur","DisbAccIFSC": "KA871323","DisbAccNo": "123310973112","SIAccNo": "779791213","SIBank": "Axis",'+
        +'"SIBranch": "Matunga","SIIFSC": "AX98679","SIApplicant": "Dipen","ExcessMCLR": "0.45","MCLRType": "One Year","PreClosureRate": "2.45","MCLRRate": "9.5","CASAAccNo": "87110822423","MODDate": "2017-12-30","CKYC": "uadcjknbkwcn87998","Scource_Type": "Centrum Housing Finance",  "Type_Of_Loan": "HL","Third_party_loan_account_no": "", "KVB_Amount_Sanction": "","ApplicantDetails": {"FirstName": "James","MiddleName": "A",'+
        +'"LastName": "Corden","FullName":"James Corden","PAN": "CCPMA1867T","AadharNumber": "TestRef123456789","CBSCustId": "987970","Title": "Mr","Nationality": "Indian","Gender": "Male","Caste": "General","BirthDate": "1990-09-28","FatherName": "Cshkj","HusbandName": "","BankingWithUs": "","Religion": "Christian","ExServiceMan": "False","PhysicallyHandicapped": "False","VoterId": "SFWA1231","DrivingLicId": "trdfe45","RationCard": "234567yt","PassportNo": "P987654","PassportExpDate": "2025-08-07",'+        
        +'"OtherId": "rtyu6","OtherIdNo": "tyu7","CurrentAddress": "12/23,4th cross,Hsr layout","CurrentCity": "Bangalore","CurrentState": "Karnataka","CurrentCountry": "Indian","CurrentZip": "560072","PermanentAddress": "12/23,4th cross,Hsr layout","PermanentCity": "Bangalore","PermanentState": "Karnataka","PermanentCountry": "Indian","PermanentZip": "560072","PhoneNo": "9908876654","Mobile": "9876543210","Email": "ads@gmail.com","Fax": "232323","RelatedToDirector": "False",'+
        +'"DirectorBank": "Karur","DirectorName": "Molly","CibilScore": "764","EmploymentType": "Salaried","CompanyName": "IBM","GroupCompanyAddress": "Bangalore","CompanyPIN": "567543","CompanyFax": "","CompanyEmail": "test@marlabs1234.com","CompanyPhone": "9434234567","CustomerType": "Primary Applicant","FinancialApplicant": "","AltMobile": "9967867854","Landline": "080234567","Experience": "2","ClaimedNMIITR": "1245678",'+
        +'"ClaimedAgriIncome": "457890","ApprovedAgriIncome": "400000","ExistingEMIClaimed": "4567","PerfiosEMI": "6789","CIBILEMI": "7890","KVBEMI": "5567","CIBILEMIOverride": "","ComputedEMI": "","ExistingEMIApproved": "5567","TotalChequeBounce": "0","PrimaryBank": "Axis","PrimaryBranch": "Karur","PrimaryAccNo": "1234567","PrimaryIFSC": "KVB67890","GrossIncome1": "823456","AnnualCapGain1": "823456",'+
        +'"InterestIncome1": "45679","AnnualTax1": "45679","DividendIncome1": "0","ShareOfProfit1": "0","AgricultureITR1": "0","GrossIncome2": "0","AnnualCapGain2": "0","InterestIncome2": "0","AnnualTax2": "0","DividendIncome2": "0","ShareOfProfit2": "0","AgricultureITR2": "0","SalaryPaid": "9800000","TaxDeducted": "98790.99","OtherReccuringIncome": "0","EstimatedBusinessIncome": "876544","CustomerIC": "KHK65467","Title_Holder": "true"}}';
        RestRequest req = new RestRequest();     
        req.requestURI = '/services/apexrest/createApplication';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        test.starttest();
            WS_Vendor_CreateApplicationAndAccount.insertApplication();
        test.stoptest();
    }

    @istest
    public static void method8() {         
        WS_Vendor_TestUtil.kvbCompanyDetails();
        WS_Vendor_TestUtil.productDetails();
        String jsonString ='{"SourcedBy": "CHFL","SourcedByOffice": "Karur","InterestRate": "11","LoanAmount": "100000",'+  
        +'"ApplicantDetails": {"FirstName": "James","MiddleName": "A","LastName": "Corden","ExServiceMan": "Yes"}}';
        RestRequest req = new RestRequest();     
        req.requestURI = '/services/apexrest/createApplication';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        test.starttest();
            WS_Vendor_CreateApplicationAndAccount.insertApplication();
        test.stoptest();
    } 

    @istest
    public static void method9() {         
        WS_Vendor_TestUtil.kvbCompanyDetails();
        WS_Vendor_TestUtil.productDetails();
        String jsonString ='{"SourcedBy": "CHFL","SourcedByOffice": "Karur","InterestRate": "11",'+  
        +'"ApplicantDetails": {"FirstName": "James","MiddleName": "A","LastName": "Corden","BankingWithUs": "Yes"}}';
        RestRequest req = new RestRequest();     
        req.requestURI = '/services/apexrest/createApplication';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        test.starttest();
            WS_Vendor_CreateApplicationAndAccount.insertApplication();
        test.stoptest();
    }

    @istest
    public static void method10() {         
        WS_Vendor_TestUtil.kvbCompanyDetails();
        WS_Vendor_TestUtil.productDetails();
        String jsonString ='{"SourcedBy": "CHFL","SourcedByOffice": "Karur","InterestRate": "11","DisbursementAmount":"testData",'+  
        +'"ApplicantDetails": {"FirstName": "James","MiddleName": "A","LastName": "Corden","BankingWithUs": "Yes"}}';
        RestRequest req = new RestRequest();     
        req.requestURI = '/services/apexrest/createApplication';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        test.starttest();
            WS_Vendor_CreateApplicationAndAccount.insertApplication();
        test.stoptest();
    } 

    @istest
    public static void method11() {         
        WS_Vendor_TestUtil.kvbCompanyDetails();
        WS_Vendor_TestUtil.productDetails();
        String jsonString ='{"SourcedBy": "CHFL","SourcedByOffice": "Karur","InterestRate": "11","RERAComplaint": "Yes",'+  
        +'"ApplicantDetails": {"FirstName": "James","MiddleName": "A","LastName": "Corden"}}';
        RestRequest req = new RestRequest();     
        req.requestURI = '/services/apexrest/createApplication';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        test.starttest();
            WS_Vendor_CreateApplicationAndAccount.insertApplication();
        test.stoptest();
    }

    @istest
    public static void method12() {         
        WS_Vendor_TestUtil.kvbCompanyDetails();
        WS_Vendor_TestUtil.productDetails();
        String jsonString ='{"SourcedBy": "CHFL","SourcedByOffice": "Karur","InterestRate": "11","SanctionDate":"testData",'+  
        +'"ApplicantDetails": {"FirstName": "James","MiddleName": "A","LastName": "Corden"}}';
        RestRequest req = new RestRequest();     
        req.requestURI = '/services/apexrest/createApplication';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        test.starttest();
            WS_Vendor_CreateApplicationAndAccount.insertApplication();
        test.stoptest();
    }  
}