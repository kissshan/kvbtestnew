/*
* Name          : Test_WS_Vendor_CreateCoBorrower
* Company       : ET Marlabs
* Class         : WS_Vendor_CreateCoBorrowerAndGuarantor
* Code coverage : 93%
* Author        : Bhavya P
*/
@isTest
public class Test_WS_Vendor_CreateCoBorrower{

    @testSetup static void setup() {
         WS_Vendor_TestUtil.createUser();
    }

    
    @istest
    public static void method1() {         
        WS_Vendor_TestUtil.kvbCompanyDetails();
        WS_Vendor_TestUtil.productDetails();
        //WS_Vendor_TestUtil.createCustomSettingRecords();
        genesis__Applications__c app = WS_Vendor_TestUtil.createApplication(WS_Vendor_Constants.HOMELOAN);
        Account ac = WS_Vendor_TestUtil.createAccount();
        genesis__Application_Parties__c party = new genesis__Application_Parties__c();
        party.Financial_Applicant__c = False;
        party.Employment_Types__c = 'Self Employed';
        party.genesis__Party_Account_Name__c = ac.Id;
        party.genesis__Application__c = app.Id;
        insert party;
        app.genesis__Account__c = ac.Id;
        app.Sub_Stage__c = WS_Vendor_Constants.SUB_STAGE_CO_ADDED;
        app.Max_CIBIL_Score__c = 755;
        app.Sourced_By__c = 'CHFL';
        app.Sanction_Authority_Limit__c = 210000;
        app.MCLR_Rate__c = 9.5;
        update app;
        String jsonString ='{"ApplicationID": "'+app.Id+'","ApplicantDetails":[ {"FirstName": "James","MiddleName": "A","LastName": "Corden",'+
        +'"FullName":"Linkin Park","PAN": "CCPMA1867T","AadharNumber": "TestRef123456789","CBSCustId": "987970","Title": "Mr","Nationality": "Indian","Gender": "Male","Caste": "General","BirthDate": "1990-09-28","FatherName": "Cshkj","HusbandName": "Jimmy Fallon","BankingWithUs": "2017-09-08","Religion": "Christian","ExServiceMan": "False","PhysicallyHandicapped": "False","VoterId": "SFWA1231","DrivingLicId": "trdfe45","RationCard": "234567yt","PassportNo": "P987654","PassportExpDate": "2025-08-07",'+        
        +'"OtherId": "rtyu6","OtherIdNo": "tyu7","CurrentAddress": "12/23,4th cross,Hsr layout","CurrentCity": "Bangalore","CurrentState": "Karnataka","CurrentCountry": "Indian","CurrentZip": "560072","PermanentAddress": "12/23,4th cross,Hsr layout","PermanentCity": "Bangalore","PermanentState": "Karnataka","PermanentCountry": "Indian","PermanentZip": "560072","PhoneNo": "9908876654","Mobile": "9876543210","Email": "ads@gmail.com","Fax": "232323","RelatedToDirector": "False",'+
        +'"DirectorBank": "Karur","DirectorName": "Molly","CibilScore": "764","EmploymentType": "Salaried","CompanyName": "IBM","GroupCompanyAddress": "Bangalore","CompanyPIN": "567543","CompanyFax": "testFax12","CompanyEmail": "test@marlabs.com","CompanyPhone": "9434234567","CustomerType": "Guarantor","FinancialApplicant": "","AltMobile": "9967867854","Landline": "080234567","Experience": "2","ClaimedNMIITR": "1245678",'+
        +'"ClaimedAgriIncome": "457890","ApprovedAgriIncome": "400000","ExistingEMIClaimed": "4567","PerfiosEMI": "6789","CIBILEMI": "7890","KVBEMI": "5567","CIBILEMIOverride": "","ComputedEMI": "","ExistingEMIApproved": "5567","TotalChequeBounce": "0","PrimaryBank": "Axis","PrimaryBranch": "Karur","PrimaryAccNo": "1234567","PrimaryIFSC": "KVB67890","GrossIncome1": "823456","AnnualCapGain1": "823456",'+
        +'"InterestIncome1": "45679","AnnualTax1": "45679","DividendIncome1": "0","ShareOfProfit1": "0","AgricultureITR1": "0","GrossIncome2": "0","AnnualCapGain2": "0","InterestIncome2": "0","AnnualTax2": "0","DividendIncome2": "0","ShareOfProfit2": "0","AgricultureITR2": "0","SalaryPaid": "9800000","TaxDeducted": "98790.99","OtherReccuringIncome": "0","EstimatedBusinessIncome": "876544","CustomerIC": "KHK65467","Title_Holder": "true"}]}';
        RestRequest req = new RestRequest();     
        req.requestURI = '/services/apexrest/createCoApplicants';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        test.starttest();
            WS_Vendor_CreateCoBorrowerAndGuarantor.insertCoApplicant();
        test.stoptest();
    }

    @istest
    public static void method2() {         
        WS_Vendor_TestUtil.kvbCompanyDetails();
        WS_Vendor_TestUtil.productDetails();
        //WS_Vendor_TestUtil.createCustomSettingRecords();
        Account ac = WS_Vendor_TestUtil.createAccount();
        genesis__Applications__c app = WS_Vendor_TestUtil.createApplication(WS_Vendor_Constants.HOMELOAN);
        app.genesis__Account__c = ac.Id;
        String jsonString ='{"ApplicationID": "'+app.Id+'","ApplicantDetails":[ {"FirstName": "Le","MiddleName": "","LastName": "Ho",'+
        +'"FullName":"Le Ho","PAN": "CCPMA1867T","AadharNumber": "TestRef123456789","CBSCustId": "987970","Title": "Mr","Nationality": "Indian","Gender": "Male","Caste": "General","BirthDate": "1990-12-08","FatherName": "Cshkj","HusbandName": "","BankingWithUs": "","Religion": "Christian","ExServiceMan": "False","PhysicallyHandicapped": "False","VoterId": "SFWA1231","DrivingLicId": "trdfe45","RationCard": "234567yt","PassportNo": "P987654","PassportExpDate": "2025-08-07",'+        
        +'"OtherId": "rtyu6","OtherIdNo": "tyu7","CurrentAddress": "12/23,4th cross,Hsr layout","CurrentCity": "Bangalore","CurrentState": "Karnataka","CurrentCountry": "Indian","CurrentZip": "560072","PermanentAddress": "12/23,4th cross,Hsr layout","PermanentCity": "Bangalore","PermanentState": "Karnataka","PermanentCountry": "Indian","PermanentZip": "560072","PhoneNo": "9908876654","Mobile": "9876543210","Email": "ads@gmail.com","Fax": "232323","RelatedToDirector": "False",'+
        +'"DirectorBank": "Karur","DirectorName": "Molly","CibilScore": "764","EmploymentType": "Salaried","CompanyName": "IBM","GroupCompanyAddress": "Bangalore","CompanyPIN": "567543","CompanyFax": "","CompanyEmail": "test@marlabs.com","CompanyPhone": "9434234567","CustomerType": "Co-Borrower","FinancialApplicant": "true","AltMobile": "9967867854","Landline": "080234567","Experience": "2","ClaimedNMIITR": "1245678",'+
        +'"ClaimedAgriIncome": "457890","ApprovedAgriIncome": "400000","ExistingEMIClaimed": "4567","PerfiosEMI": "6789","CIBILEMI": "7890","KVBEMI": "5567","CIBILEMIOverride": "1234","ComputedEMI": "2341","ExistingEMIApproved": "5567","TotalChequeBounce": "0","PrimaryBank": "Axis","PrimaryBranch": "Karur","PrimaryAccNo": "1234567","PrimaryIFSC": "KVB67890","GrossIncome1": "823456","AnnualCapGain1": "823456",'+
        +'"InterestIncome1": "45679","AnnualTax1": "45679","DividendIncome1": "0","ShareOfProfit1": "0","AgricultureITR1": "0","GrossIncome2": "0","AnnualCapGain2": "0","InterestIncome2": "0","AnnualTax2": "0","DividendIncome2": "0","ShareOfProfit2": "0","AgricultureITR2": "0","SalaryPaid": "9800000","TaxDeducted": "98790.99","OtherReccuringIncome": "0","EstimatedBusinessIncome": "876544","CustomerIC": "KHK65467","Title_Holder": "true"},{"FirstName": "Harry","MiddleName": "James","LastName": "Potter",'+
        +'"FullName":"Harry James Potter","PAN": "CCPMA1867T","AadharNumber": "TestRef9876543210","CBSCustId": "987970","Title": "Mr","Nationality": "Indian","Gender": "Male","Caste": "General","BirthDate": "1990-09-28","FatherName": "Cshkj","HusbandName": "","BankingWithUs": "","Religion": "Christian","ExServiceMan": "False","PhysicallyHandicapped": "False","VoterId": "SFWA1231","DrivingLicId": "trdfe45","RationCard": "234567yt","PassportNo": "P987654","PassportExpDate": "2025-08-07",'+        
        +'"OtherId": "rtyu6","OtherIdNo": "tyu7","CurrentAddress": "12/23,4th cross,Hsr layout","CurrentCity": "Bangalore","CurrentState": "Karnataka","CurrentCountry": "Indian","CurrentZip": "560072","PermanentAddress": "12/23,4th cross,Hsr layout","PermanentCity": "Bangalore","PermanentState": "Karnataka","PermanentCountry": "Indian","PermanentZip": "560072","PhoneNo": "9908876654","Mobile": "9876543210","Email": "ads@gmail.com","Fax": "232323","RelatedToDirector": "False",'+
        +'"DirectorBank": "Karur","DirectorName": "Molly","CibilScore": "764","EmploymentType": "Salaried","CompanyName": "IBM","GroupCompanyAddress": "Bangalore","CompanyPIN": "567543","CompanyFax": "","CompanyEmail": "test1@marlabs.com","CompanyPhone": "9434234567","CustomerType": "Guarantor","FinancialApplicant": "","AltMobile": "9967867854","Landline": "080234567","Experience": "2","ClaimedNMIITR": "1245678",'+
        +'"ClaimedAgriIncome": "457890","ApprovedAgriIncome": "400000","ExistingEMIClaimed": "4567","PerfiosEMI": "6789","CIBILEMI": "7890","KVBEMI": "5567","CIBILEMIOverride": "","ComputedEMI": "","ExistingEMIApproved": "5567","TotalChequeBounce": "0","PrimaryBank": "Axis","PrimaryBranch": "Karur","PrimaryAccNo": "1234567","PrimaryIFSC": "KVB67890","GrossIncome1": "823456","AnnualCapGain1": "823456",'+
        +'"InterestIncome1": "45679","AnnualTax1": "45679","DividendIncome1": "0","ShareOfProfit1": "0","AgricultureITR1": "0","GrossIncome2": "0","AnnualCapGain2": "0","InterestIncome2": "0","AnnualTax2": "0","DividendIncome2": "0","ShareOfProfit2": "0","AgricultureITR2": "0","SalaryPaid": "9800000","TaxDeducted": "98790.99","OtherReccuringIncome": "0","EstimatedBusinessIncome": "876544","CustomerIC": "KHK65467","Title_Holder": "true"}]}';
        RestRequest req = new RestRequest();     
        req.requestURI = '/services/apexrest/createCoApplicants';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        test.starttest();
            WS_Vendor_CreateCoBorrowerAndGuarantor.insertCoApplicant();
        test.stoptest();
    }

    @istest
    public static void method3() {         
        WS_Vendor_TestUtil.kvbCompanyDetails();
        WS_Vendor_TestUtil.productDetails();
        WS_Vendor_TestUtil.createAccount();
        //WS_Vendor_TestUtil.createCustomSettingRecords();
        genesis__Applications__c app = WS_Vendor_TestUtil.createApplication(WS_Vendor_Constants.LAPLOAN);
        String jsonString ='{"ApplicationID": "'+app.Id+'","ApplicantDetails":[{"FirstName": "James","MiddleName": "A",'+
        +'"LastName": "Corden","FullName":"James A Corden","PAN": "CCPMA1867T","AadharNumber": "TestRef123456789","CBSCustId": "987970","Title": "Mr","Nationality": "Indian","Gender": "Male","Caste": "General","BirthDate": "1990-09-28","FatherName": "Cshkj","HusbandName": "","BankingWithUs": "","Religion": "Christian","ExServiceMan": "False","PhysicallyHandicapped": "False","VoterId": "SFWA1231","DrivingLicId": "trdfe45","RationCard": "234567yt","PassportNo": "P987654","PassportExpDate": "2025-08-07",'+        
        +'"OtherId": "rtyu6","OtherIdNo": "tyu7","CurrentAddress": "12/23,4th cross,Hsr layout","CurrentCity": "Bangalore","CurrentState": "Karnataka","CurrentCountry": "Indian","CurrentZip": "560072","PermanentAddress": "12/23,4th cross,Hsr layout","PermanentCity": "Bangalore","PermanentState": "Karnataka","PermanentCountry": "Indian","PermanentZip": "560072","PhoneNo": "9908876654","Mobile": "9876543210","Email": "ads@gmail.com","Fax": "232323","RelatedToDirector": "False",'+
        +'"DirectorBank": "Karur","DirectorName": "Molly","CibilScore": "764","EmploymentType": "Salaried","CompanyName": "IBM","GroupCompanyAddress": "Bangalore","CompanyPIN": "567543","CompanyFax": "","CompanyEmail": "test@marlabs.com","CompanyPhone": "9434234567","CustomerType": "Co-Borrower","FinancialApplicant": "","AltMobile": "9967867854","Landline": "080234567","Experience": "2","ClaimedNMIITR": "1245678",'+
        +'"ClaimedAgriIncome": "457890","ApprovedAgriIncome": "400000","ExistingEMIClaimed": "4567","PerfiosEMI": "6789","CIBILEMI": "7890","KVBEMI": "5567","CIBILEMIOverride": "","ComputedEMI": "","ExistingEMIApproved": "5567","TotalChequeBounce": "0","PrimaryBank": "Axis","PrimaryBranch": "Karur","PrimaryAccNo": "1234567","PrimaryIFSC": "KVB67890","GrossIncome1": "823456","AnnualCapGain1": "823456",'+
        +'"InterestIncome1": "45679","AnnualTax1": "45679","DividendIncome1": "0","ShareOfProfit1": "0","AgricultureITR1": "0","GrossIncome2": "0","AnnualCapGain2": "0","InterestIncome2": "0","AnnualTax2": "0","DividendIncome2": "0","ShareOfProfit2": "0","AgricultureITR2": "0","SalaryPaid": "9800000","TaxDeducted": "98790.99","OtherReccuringIncome": "0","EstimatedBusinessIncome": "876544",'+
        +'"CustomerIC": "KHK65467","Residential_Status": "","CompanyDetails": [{"CBS_Customer_ID": "","Company_name": "ET-Marlabs","Company_type": "Primary","Relationship_with_Company": "Main","Company_PAN": "ASDD123P","Company_Address": "54 bangalore","Company_Pincode": "700075","Company_City": "BANGALORE","Company_State":"KARNATAKA"},'+
        +'{"CBS_Customer_ID": "","Company_name": "ET-Marlabs2","Company_type": "Primary","Relationship_with_Company": "Second","Company_PAN": "ASDD923P","Company_Address": "54 bangalore","Company_Pincode": "700075","Company_City": "BANGALORE","Company_State":"KARNATAKA"}]},{"FirstName": "Harry","MiddleName": "James",'+
        +'"LastName": "Potter","FullName":"Harry James Potter","PAN": "CCPMA1867T","AadharNumber": "TestRef9876543210","CBSCustId": "987970","Title": "Mr","Nationality": "Indian","Gender": "Male","Caste": "General","BirthDate": "1990-09-28","FatherName": "Cshkj","HusbandName": "","BankingWithUs": "","Religion": "Christian","ExServiceMan": "False","PhysicallyHandicapped": "False","VoterId": "SFWA1231","DrivingLicId": "trdfe45","RationCard": "234567yt","PassportNo": "P987654","PassportExpDate": "2025-08-07",'+        
        +'"OtherId": "rtyu6","OtherIdNo": "tyu7","CurrentAddress": "12/23,4th cross,Hsr layout","CurrentCity": "Bangalore","CurrentState": "Karnataka","CurrentCountry": "Indian","CurrentZip": "560072","PermanentAddress": "12/23,4th cross,Hsr layout","PermanentCity": "Bangalore","PermanentState": "Karnataka","PermanentCountry": "Indian","PermanentZip": "560072","PhoneNo": "9908876654","Mobile": "9876543210","Email": "ads@gmail.com","Fax": "232323","RelatedToDirector": "False",'+
        +'"DirectorBank": "Karur","DirectorName": "Molly","CibilScore": "764","EmploymentType": "Salaried","CompanyName": "IBM","GroupCompanyAddress": "Bangalore","CompanyPIN": "567543","CompanyFax": "","CompanyEmail": "test1@marlabs.com","CompanyPhone": "9434234567","CustomerType": "Guarantor","FinancialApplicant": "","AltMobile": "9967867854","Landline": "080234567","Experience": "2","ClaimedNMIITR": "1245678",'+
        +'"ClaimedAgriIncome": "457890","ApprovedAgriIncome": "400000","ExistingEMIClaimed": "4567","PerfiosEMI": "6789","CIBILEMI": "7890","KVBEMI": "5567","CIBILEMIOverride": "","ComputedEMI": "","ExistingEMIApproved": "5567","TotalChequeBounce": "0","PrimaryBank": "Axis","PrimaryBranch": "Karur","PrimaryAccNo": "1234567","PrimaryIFSC": "KVB67890","GrossIncome1": "823456","AnnualCapGain1": "823456",'+
        +'"InterestIncome1": "45679","AnnualTax1": "45679","DividendIncome1": "0","ShareOfProfit1": "0","AgricultureITR1": "0","GrossIncome2": "0","AnnualCapGain2": "0","InterestIncome2": "0","AnnualTax2": "0","DividendIncome2": "0","ShareOfProfit2": "0","AgricultureITR2": "0","GrossIncome3": "20098","AnnualCapGain3": "1234","InterestIncome3": "123","AnnualTax3": "321","DividendIncome3": "1234","ShareOfProfit3": "5000","AgricultureITR3": "444","SalaryPaid": "9800000","TaxDeducted": "98790.99","OtherReccuringIncome": "0","EstimatedBusinessIncome": "876544",'+
        +'"CustomerIC": "KHK65467","Residential_Status": "","CompanyDetails": [{"CBS_Customer_ID": "","Company_name": "ET-Marlabs","Company_type": "Primary","Relationship_with_Company": "Main","Company_PAN": "ASRFT567","Company_Address": "54 bangalore","Company_Pincode": "700075","Company_City": "BANGALORE","Company_State":"KARNATAKA"},'+
        +'{"CBS_Customer_ID": "","Company_name": "ET-Marlabs2","Company_type": "Primary","Relationship_with_Company": "Second","Company_PAN": "ASRFT867","Company_Address": "54 bangalore","Company_Pincode": "700075","Company_City": "BANGALORE","Company_State":"KARNATAKA"}]}]}';
        RestRequest req = new RestRequest();     
        req.requestURI = '/services/apexrest/createCoApplicants';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        test.starttest();
            WS_Vendor_CreateCoBorrowerAndGuarantor.insertCoApplicant();
        test.stoptest();
    }

    @istest
    public static void method4() {         
        WS_Vendor_TestUtil.kvbCompanyDetails();
        WS_Vendor_TestUtil.productDetails();
        WS_Vendor_TestUtil.createAccount();
        WS_Vendor_TestUtil.createBusinessAccount();
        //WS_Vendor_TestUtil.createCustomSettingRecords();
        genesis__Applications__c app = WS_Vendor_TestUtil.createApplication(WS_Vendor_Constants.LAPLOAN);
        /*app.Sub_Stage__c = WS_Vendor_Constants.SUB_STAGE_CBS_PENDING;
        update app;*/
        String jsonString ='{"ApplicationID": "'+app.Id+'","ApplicantDetails":[{"FirstName": "James","MiddleName": "A",'+
        +'"LastName": "Corden","FullName":"James A Corden","PAN": "CCPMA1867T","AadharNumber": "TestRef123456789","CBSCustId": "987970","Title": "Mr","Nationality": "Indian","Gender": "Male","Caste": "General","BirthDate": "1990-09-28","FatherName": "Cshkj","HusbandName": "","BankingWithUs": "","Religion": "Christian","ExServiceMan": "False","PhysicallyHandicapped": "False","VoterId": "SFWA1231","DrivingLicId": "trdfe45","RationCard": "234567yt","PassportNo": "P987654","PassportExpDate": "2025-08-07",'+        
        +'"OtherId": "rtyu6","OtherIdNo": "tyu7","CurrentAddress": "12/23,4th cross,Hsr layout","CurrentCity": "Bangalore","CurrentState": "Karnataka","CurrentCountry": "Indian","CurrentZip": "560072","PermanentAddress": "12/23,4th cross,Hsr layout","PermanentCity": "Bangalore","PermanentState": "Karnataka","PermanentCountry": "Indian","PermanentZip": "560072","PhoneNo": "9908876654","Mobile": "9876543210","Email": "ads@gmail.com","Fax": "232323","RelatedToDirector": "False",'+
        +'"DirectorBank": "Karur","DirectorName": "Molly","CibilScore": "764","EmploymentType": "Salaried","CompanyName": "IBM","GroupCompanyAddress": "Bangalore","CompanyPIN": "567543","CompanyFax": "","CompanyEmail": "test@marlabs.com","CompanyPhone": "9434234567","CustomerType": "Co-Borrower","FinancialApplicant": "","AltMobile": "9967867854","Landline": "080234567","Experience": "2","ClaimedNMIITR": "1245678",'+
        +'"ClaimedAgriIncome": "457890","ApprovedAgriIncome": "400000","ExistingEMIClaimed": "4567","PerfiosEMI": "6789","CIBILEMI": "7890","KVBEMI": "5567","CIBILEMIOverride": "","ComputedEMI": "","ExistingEMIApproved": "5567","TotalChequeBounce": "0","PrimaryBank": "Axis","PrimaryBranch": "Karur","PrimaryAccNo": "1234567","PrimaryIFSC": "KVB67890","GrossIncome1": "823456","AnnualCapGain1": "823456",'+
        +'"InterestIncome1": "45679","AnnualTax1": "45679","DividendIncome1": "0","ShareOfProfit1": "0","AgricultureITR1": "0","GrossIncome2": "0","AnnualCapGain2": "0","InterestIncome2": "0","AnnualTax2": "0","DividendIncome2": "0","ShareOfProfit2": "0","AgricultureITR2": "0","SalaryPaid": "9800000","TaxDeducted": "98790.99","OtherReccuringIncome": "0","EstimatedBusinessIncome": "876544",'+
        +'"CustomerIC": "KHK65467","Residential_Status": "","CompanyDetails": [{"CBS_Customer_ID": "","Company_name": "ET-Marlabs","Company_type": "Primary","Relationship_with_Company": "Main","Company_PAN": "ASDD123P","Company_Address": "54 bangalore","Company_Pincode": "700075","Company_City": "BANGALORE","Company_State":"KARNATAKA"},'+
        +'{"CBS_Customer_ID": "","Company_name": "ET-Marlabs2","Company_type": "Primary","Relationship_with_Company": "Second","Company_PAN": "ASDD923P","Company_Address": "54 bangalore","Company_Pincode": "700075","Company_City": "BANGALORE","Company_State":"KARNATAKA"}]},{"FirstName": "Harry","MiddleName": "James",'+
        +'"LastName": "Potter","FullName":"Harry James Potter","PAN": "CCPMA1867T","AadharNumber": "TestRef9876543210","CBSCustId": "987970","Title": "Mr","Nationality": "Indian","Gender": "Male","Caste": "General","BirthDate": "1990-09-28","FatherName": "Cshkj","HusbandName": "","BankingWithUs": "","Religion": "Christian","ExServiceMan": "False","PhysicallyHandicapped": "False","VoterId": "SFWA1231","DrivingLicId": "trdfe45","RationCard": "234567yt","PassportNo": "P987654","PassportExpDate": "2025-08-07",'+        
        +'"OtherId": "rtyu6","OtherIdNo": "tyu7","CurrentAddress": "12/23,4th cross,Hsr layout","CurrentCity": "Bangalore","CurrentState": "Karnataka","CurrentCountry": "Indian","CurrentZip": "560072","PermanentAddress": "12/23,4th cross,Hsr layout","PermanentCity": "Bangalore","PermanentState": "Karnataka","PermanentCountry": "Indian","PermanentZip": "560072","PhoneNo": "9908876654","Mobile": "9876543210","Email": "ads@gmail.com","Fax": "232323","RelatedToDirector": "False",'+
        +'"DirectorBank": "Karur","DirectorName": "Molly","CibilScore": "764","EmploymentType": "Salaried","CompanyName": "IBM","GroupCompanyAddress": "Bangalore","CompanyPIN": "567543","CompanyFax": "","CompanyEmail": "test1@marlabs.com","CompanyPhone": "9434234567","CustomerType": "Guarantor","FinancialApplicant": "","AltMobile": "9967867854","Landline": "080234567","Experience": "2","ClaimedNMIITR": "1245678",'+
        +'"ClaimedAgriIncome": "457890","ApprovedAgriIncome": "400000","ExistingEMIClaimed": "4567","PerfiosEMI": "6789","CIBILEMI": "7890","KVBEMI": "5567","CIBILEMIOverride": "","ComputedEMI": "","ExistingEMIApproved": "5567","TotalChequeBounce": "0","PrimaryBank": "Axis","PrimaryBranch": "Karur","PrimaryAccNo": "1234567","PrimaryIFSC": "KVB67890","GrossIncome1": "823456","AnnualCapGain1": "823456",'+
        +'"InterestIncome1": "45679","AnnualTax1": "45679","DividendIncome1": "0","ShareOfProfit1": "0","AgricultureITR1": "0","GrossIncome2": "0","AnnualCapGain2": "0","InterestIncome2": "0","AnnualTax2": "0","DividendIncome2": "0","ShareOfProfit2": "0","AgricultureITR2": "0","SalaryPaid": "9800000","TaxDeducted": "98790.99","OtherReccuringIncome": "0","EstimatedBusinessIncome": "876544",'+
        +'"CustomerIC": "KHK65467","Residential_Status": "","CompanyDetails": [{"CBS_Customer_ID": "","Company_name": "ET-Marlabs","Company_type": "Primary","Relationship_with_Company": "Main","Company_PAN": "ASRFT567","Company_Address": "54 bangalore","Company_Pincode": "700075","Company_City": "BANGALORE","Company_State":"KARNATAKA"},'+
        +'{"CBS_Customer_ID": "","Company_name": "ET-Marlabs2","Company_type": "Primary","Relationship_with_Company": "Second","Company_PAN": "ASRFT867","Company_Address": "54 bangalore","Company_Pincode": "700075","Company_City": "BANGALORE","Company_State":"KARNATAKA"}]}]}';
        RestRequest req = new RestRequest();     
        req.requestURI = '/services/apexrest/createCoApplicants';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        test.starttest();
            WS_Vendor_CreateCoBorrowerAndGuarantor.insertCoApplicant();
        test.stoptest();
    } 

    @isTest
    public static void method5() {         
        String jsonString ='';
        RestRequest req = new RestRequest();     
        req.requestURI = '/services/apexrest/createCoApplicants';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        test.starttest();
            WS_Vendor_CreateCoBorrowerAndGuarantor.insertCoApplicant();
        test.stoptest();
    }
}