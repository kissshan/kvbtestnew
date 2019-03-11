@isTest
public class Test_WS_UpdatemandatoryFieldsAcc {
    Static genesis__Applications__c app;
    static Account acc;
    static Account acc1;
    static genesis__Application_Parties__c par;
    //valid data
    @isTest
    public static void getMandateFieldsValid() {
        WS_UpdatemandatoryFieldsAcc ob=new WS_UpdatemandatoryFieldsAcc();
        app = TestUtility.intialSetUp('HomeLoan', true);
        app.Sub_Stage__c='Work Information Captured';
        update app;
        acc = new Account(Name = 'TestName');
        //Id rectType = Schema.SObjectType.account.getRecordTypeInfosByName().get('PersonAccount').getRecordTypeId();
        //acc.RecordTypeId=rectType;
        insert acc;
        par=VL_Test_Utility.createAppParty(acc.id,app.id,Constants.Co_Borrower);
        insert par;
        blob b = blob.valueOf(getdetails1());
        TestUtility.webserviceRequest('services/apexrest/updateMandateFields','POST', b);
       // List<WS_UpdatemandatoryFieldsAcc.OUT_MAP> lisobj=new List<WS_UpdatemandatoryFieldsAcc.OUT_MAP>();
       // WS_UpdatemandatoryFieldsAcc.Response res=new  WS_UpdatemandatoryFieldsAcc.Response[]{lisobj};
        Test.startTest();
        WS_UpdatemandatoryFieldsAcc.getMandateFields();
        Test.stopTest();
       
    }
    //Null data
     @isTest
    public static void getMandateFieldsValidNull() {
        app = TestUtility.intialSetUp('HomeLoan', true);
        acc = new Account(Name = 'TestName');
        insert acc;
        TestUtility.webserviceRequest('services/apexrest/updateMandateFields','POST', Null);
        Test.startTest();
        WS_UpdatemandatoryFieldsAcc.getMandateFields();
        Test.stopTest();
       
    }
    
    //Invalid data
    @isTest
    public static void getMandateFieldsInValid() {
        app = TestUtility.intialSetUp('HomeLoan', true);
        acc = new Account(Name = 'TestName');
        insert acc;
        blob b = blob.valueOf(getdetails());
        TestUtility.webserviceRequest('services/apexrest/updateMandateFields','POST', b);
        Test.startTest();
        WS_UpdatemandatoryFieldsAcc.getMandateFields();
        Test.stopTest();
       
    }
    
    
     public static string getdetails() {
        
String json=
    
    '{ '+

'  "ApplicationID": "'+app.id+'",'+
' "Purpose_of_loan": "Home Loan",'+
'  "Property_type": "TEE",'+
'  "Purchase_cost_of_property": "1233331",'+
'  "Cost_of_land": "123333123",'+
' "Cost_of_construction": "1231233",'+
' "Cost_of_repair": "12312",'+
'  "Bank_of_existing_home_loan": "",'+
' "Loan_start_date_of_existing_home_loan": "2017-03-03",'+
'  "Tenure_of_existing_home_loan": "",'+
' "Outstanding_balance": "213366",'+
'  "Project_code": "HL",'+
'  "Builder_name": "BRIGADE",'+
'  "Project_name": "AAS",'+
'  "Tower": "SA",'+
'  "Flat": "SDs",'+
'  "Address": "ASDFASDFADF",'+
' "Total_repayment_amount": "123099",'+
' "EMI": "3423",'+
'  "Interest": "12",'+
' "Loan_required_amount": "10000000",'+
'  "Required_loan_tenure": "300",'+
' "Holiday_period": "23",'+
'  "GMRA_policy_is_selected": "TRUE",'+
' "Is_GMRA_policy_added_to_loan_amount": "TRUE",'+
'  "Branch_code": "SSF",'+
'  "Branch_name": "ASDF",'+
'  "Is_loan_processing_fee_paid": "TRUE",'+
'  "Documents_uploaded": "FALSE",'+
'  "Sourced_by": "ASDD",'+
'  "Sourced_by_office": "AASEAR",'+
'  "Stage": "Property Information Captured",'+
' "FETransId": "S",'+
'  "PGTransId": "S",'+
'  "TransDateTime": "",'+
'  "TotalAmnt": "",'+
'  "PgStatus": "",'+
'  "Term" :"",'+
'  "BorrowerEsign" : "",'+
'  "GuarantorEsign" : "",'+
'  "SubType": "Take Over",'+
' "BuildingAge" : "",'+  
    '  "HL_Facility": [ '+
        ' {'+
        ' "Takeover_Bank_Name" : "sbi",'+
        ' "Takeover_Outstanding_Loan_Amount" : "2345689",'+
        ' "Takeover_Outstanding_Loan_Tenure_months" : "23",'+
        ' "Takeover_Loans_EMI" : "13456"'+
        '} '+
        '], '+
'  "ACCTDETAILS": [ '+
   ' {'+
     ' "AccountId": "'+acc.id+'",'+
     ' "presentAddress1": "ASSD",'+
     ' "presentAddress2": "sdjh",'+
     ' "presentAddress3": "jhdsf",'+
     ' "presentCity": "Bangalore",'+
     ' "presentState": "Karnataka",'+
     ' "presentCountry": "India",'+
     ' "presentZip": "560076",'+
     ' "addProof": "Voter",'+
     ' "voterId": "12331233",'+
     ' "electricityCustNo": "23456",'+
     ' "CustLpgNo": "45678",'+
     ' "waterBill": "23456",'+
     ' "driveLicense": "KA5620180008735",'+
     ' "passport": "PR56785",'+
     ' "caste": "General",'+
     ' "maritalStatus": "Single",'+
     ' "branchCode": "saaa",'+
     ' "isPhyHandicap": "false",'+
     ' "isExserviceMan": "false",'+
     ' "religion": "Hindu",'+
     ' "eduQualification": "btech",'+
     ' "isAppRelatedBankDir": "false",'+
     ' "nameBankRelated": "axis",'+
     ' "nameDirRelated": "ram",'+
     ' "Are_you_an_existing_customer": "false",'+
     ' "Customer_since": "2017-12-29",'+
     ' "Customer_ID": "",'+
     ' "Aadhaar_No": "123456786543",'+
     ' "account_No": "",'+
     ' "PAN_No": "CCPYT1475B",'+
     ' "Mobile_Number": "9876543210",'+
     ' "E_mail": "aa@dd.com",'+
     ' "Reason_for_not_having_PAN_card": "sdffadsf",'+
     ' "First_Name": "SDADF",'+
     ' "Last_Name": "ASDA",'+
     ' "Middle_Name": "asdf",'+
     ' "DOB": "1988-11-29",'+
     ' "Fathers_Name": "asdasdass",'+
     ' "Husbands_Name": "Jacob",'+
     ' "permanentAddress1": "45,2nd cross",'+
     ' "permanentAddress2": "HSR Layout Main road",'+
     ' "permanentAddress3": "HSR Layout",'+
     ' "permanentCity": "Bengaluru",'+
     ' "permanentState": "Karnataka",'+
     ' "permanentZip": "560068",'+
     ' "permanentCountry": "India",'+
     ' "Nationality": "Indian",'+
     ' "Resdential_status": "",'+
     ' "Do_you_have_any_assets": "true",'+
     ' "Immovable_assets": "Home",'+
     ' "Other_assets": "123321",'+
     ' "Employment_type": "",'+
     ' "Mothers_Name": "Jalaja",'+
     ' "Cust_Type": "Test",'+
     ' "Experience": "11",'+
     ' "Company_name": "ET",'+
     ' "Company_address": "Bang",'+
     ' "Net_monthly_income": "980000",'+
     ' "Mode_of_bank_statement_verification": "",'+
     ' "Mode_of_ITR_verification": "",'+
     ' "Additional_income": "1200",'+
     ' "Source_of_income1": "rent",'+
     ' "Additional_income_amount1": "3455",'+
     ' "Source_of_income2": "share",'+
     ' "Additional_income_amount2": "",'+
     ' "Source_of_income3": "",'+
     ' "Additional_income_amount3": "",'+
     ' "Source_of_income4": "",'+
     ' "decimal Additional_income_amount4": "",'+
     ' "Source_of_income5": "",'+
     ' "Additional_income_amount5": "",'+
	 ' "DisbursmentEsignCheck" : "True",'+
	 ' "ModEsignCheck" : "True",'+
	 ' "CBSAccNo1" : "123214aa",'+
	 ' "CBSAccNo2" : "123214ss",'+
	 ' "CBSAccNo3" : "123214kk",'+
	 ' "CBSAccNo4" : "123214ww",'+
	 ' "CBSAccNo5" : "123214rr",'+
	 ' "IsFinancial" : "True",'+
	 ' "PerfiosReqId1" : "jasgkjasdsddf",'+
	 ' "PerfiosReqId2" : "kdfjvkjsdlfklkdf",'+
     ' "Company_City" : "Bengaluru",'+
     ' "Company_State" : "Karnataka",'+
	 ' "PerfiosUrl" : "www.perfios.com/jhj/hjggj"'+     
   '} '+
 '] '+
 
     ' } '   ;

        return json;
    }



// invalid json
  public static string getdetails1() {
        
String json=		'{'+
		'  "ApplicationID": "'+app.id+'",'+
		'  "Purpose_of_loan": "Personal requirements",'+
		'  "Property_type": "TEE",'+
		'  "Purchase_cost_of_property": "1233331",'+
		'  "Cost_of_land": "123333123",'+
		'  "Cost_of_construction": "1231233",'+
		'  "Cost_of_repair": "12312",'+
		'  "Bank_of_existing_home_loan": "",'+
		'  "Loan_start_date_of_existing_home_loan": "",'+
		'  "Tenure_of_existing_home_loan": "",'+
		'  "Outstanding_balance": "213366",'+
		'  "SI_Account_Number": "123456789",'+
		'  "SI_Bank_Name": "KVB Limited",'+
		'  "SI_Branch_Name": "Tenaympet",'+
		'  "SI_IFSC_Code": "KVB0000005",'+
		'  "Is_ITR_Required": "false",'+
		'  "ITRs_Filled_within_3_Months": "false",'+
		'  "ITR_Uploaded": "false",'+
		'  "Docgen_Fail": "false",'+
		'  "FI_Status": "Fraud",'+
		'  "Is_CreditLife": "false",'+
		'  "PMin": "100000",'+
		'  "Error_Message_PL": "sddsdsds",'+
		'  "Sanction_Message": "sdsdsdd",'+
		'  "Total_GST_Charges": "2490",'+
		'  "Disbursement_Account_Bank_Name": "SBI",'+
		'  "Disbursement_Account_Branch_Name": "Santoshpur",'+
		'  "Disbursement_Account_IFSC_Code": "SBIN000098",'+
		'  "Disbursement_Account_Number": "1234567543",'+
		'  "Project_code": "PL",'+
		'  "Builder_name": "BRIGADE",'+
		'  "Project_name": "AAS",'+
		'  "Tower": "SA",'+
		'  "Flat": "SDs",'+
		'  "Total_repayment_amount": "123099",'+
		'  "EMI": "3423",'+
		'  "Interest": "12",'+
		'  "Loan_required_amount": "10000000",'+
		'  "Required_loan_tenure": "300",'+
		'  "Holiday_period": "23",'+
		'  "GMRA_policy_is_selected": "FALSE",'+
		'  "Is_GMRA_policy_added_to_loan_amount": "FALSE",'+
		'  "Branch_code": "SSF",'+
		'  "Branch_name": "ASDF",'+
		'  "Is_loan_processing_fee_paid": "TRUE",'+
		'  "Documents_uploaded": "FALSE",'+
		'  "Sourced_by": "ASDD",'+
		'  "Sourced_by_office": "AASEAR",'+
		'  "FETransId": "S",'+
		'  "PGTransId": "S",'+
		'  "TransDateTime": "",'+
		'  "TotalAmnt": "",'+
		'  "PgStatus": "",'+
		'  "Term": "12",'+
		'  "BorrowerEsign": "true",'+
		'  "GuarantorEsign": "true",'+
		'  "BuildingAge": "25",'+
		'  "Fe_Extras": "qeqweqw",'+
		'  "Property_State": "Tamil nadu",'+
		'  "Property_City": "Chennai",'+
		'  "Property_Pincode": "522614",'+
		'  "Branch_city": "Chennai",'+
		'  "Branch_State": "Tamil nadu",'+
		'  "GMRA_Selected_Option": "Test",'+
		'  "GMRA_Amount": "0",'+
		'  "Property_State_Id": "01",'+
		'  "Property_City_Id": "76",'+
		'  "Property_Address1": "Chennai",'+
		'  "Property_Address2": "Chennai",'+
		'  "Whether_Construction_Completed": "true",'+
		'  "Branch_State_Id": "76",'+
		'  "Branch_city_Id": "01",'+
		'  "Holiday_PeriodMax": "3",'+
		'  "Is_take_over": true,'+
		'  "Type_Of_Loan": "New Personal Loan",'+
		'  "Type_of_charge": "Primary Charge",'+
		'  "Type_of_property": "Residential",'+
		'  "SI_Applicant": "Subas",'+
		'  "Minimum_Loan_Amount": "320000.00",'+
		'  "MarginValue": "1000000",'+
		'  "MarginPaymentMode": "Cash",'+
		'  "MarginPaymentReference": "8474",'+
		'  "PreApprovedValue": "789999",'+
		'  "PreApprovedFlag": "true",'+
		'  "stage": "HL Selected",'+
    	'  "SubType": "Top Up",'+
    	'  "Option": "Test",'+
    	'  "RejectionScenario": "Test",'+
        '  "HL_Facility": [ '+
               ' {'+
                ' "Takeover_Bank_Name" : "sbi",'+
                ' "Takeover_Outstanding_Loan_Amount" : "2345689",'+
                ' "Takeover_Outstanding_Loan_Tenure_months" : "23",'+
                ' "Takeover_Loans_EMI" : "13456"'+
               '} '+
             '], '+
		'  "ACCTDETAILS": ['+
		'    {'+
		'      "AccountId": "'+acc.id+'",'+
		'      "presentAddress1": "ASSD",'+
		'      "presentAddress2": "sdjh",'+
		'      "presentAddress3": "jhdsf",'+
		'      "presentCity": "Bangalore",'+
		'      "presentState": "Karnataka",'+
		'      "presentCountry": "India",'+
		'      "presentZip": "560076",'+
		'      "addProof": "Voter",'+
		'      "voterId": "12331233",'+
		'      "electricityCustNo": "",'+
		'      "CustLpgNo": "",'+
		'      "waterBill": "",'+
		'      "driveLicense": "",'+
		'      "passport": "",'+
		'      "Company_Pincode": "212339",'+
		'      "caste": "General",'+
		'      "maritalStatus": "Single",'+
		'      "branchCode": "saaa",'+
		'      "isPhyHandicap": "false",'+
		'      "isExserviceMan": "false",'+
		'      "religion": "Hindu",'+
		'      "IncomeComputationForm": "ITR",'+
		'      "Agriculture_Income_itr1": "10000",'+
		'      "Agriculture_Income_itr2": "10000",'+
		'      "Agriculture_Income_itr3": "10000",'+
		'      "Share_of_Profit_itr_yr1": "1500",'+
		'      "Share_of_Profit_itr_yr2": "1500",'+
		'      "Share_of_Profit_itr_yr3": "1500",'+
		'      "eduQualification": "btech",'+
		'      "isAppRelatedBankDir": "false",'+
		'      "nameBankRelated": "KVB",'+
		'      "nameDirRelated": "ram",'+
		'      "Annual_Other_Income_Recurring_Credits_IT": "500",'+
		'      "Are_you_an_existing_customer": "false",'+
		'      "Customer_since": "2017-12-29",'+
		'      "Customer_ID": "53",'+
		'      "Aadhaar_No": "",'+
		'      "account_No": "367686485379",'+
		'      "PAN_No": "",'+
		'      "Mobile_Number": "9876543210",'+
		'      "E_mail": "aa@dd.com",'+
		'      "Reason_for_not_having_PAN_card": "sdffadsf",'+
		'      "First_Name": "SDADF",'+
		'      "Last_Name": "ASDA",'+
		'      "Middle_Name": "",'+
		'      "Full_Name": "Raju",'+
		'      "DOB": "1988-11-29",'+
		'      "Fathers_Name": "asdasdass",'+
		'      "Husbands_Name": "",'+
		'      "permanentAddress1": "",'+
		'      "permanentAddress2": "",'+
		'      "permanentAddress3": "",'+
		'      "permanentCity": "",'+
		'      "permanentState": "",'+
		'      "permanentZip": "",'+
		'      "permanentCountry": "India",'+
		'      "Nationality": "Indian",'+
		'      "Resdential_status": "",'+
		'      "Do_you_have_any_assets": "",'+
		'      "Immovable_assets": "",'+
		'      "Other_assets": "123321",'+
		'      "Employment_type": "Salaried",'+
		'      "Cust_Type": "",'+
		'      "Experience": "11",'+
		'      "Company_name": "ET",'+
		'      "Company_address": "Bang",'+
		'      "Net_monthly_income": "980000",'+
		'      "Mode_of_bank_statement_verification": "",'+
		'      "Mode_of_ITR_verification": "",'+
		'      "Additional_income": "1200",'+
		'      "Source_of_income1": "rent",'+
		'      "Additional_income_amount1": "3455",'+
		'      "Source_of_income2": "share",'+
		'      "Additional_income_amount2": "",'+
		'      "Source_of_income3": "",'+
		'      "Additional_income_amount3": "",'+
		'      "Source_of_income4": "",'+
		'      "decimal Additional_income_amount4": "",'+
		'      "Source_of_income5": "",'+
		'      "Additional_income_amount5": "",'+
		'      "DisbursmentEsignCheck": "True",'+
		'      "ModEsignCheck": "True",'+
		'      "CBSAccNo1": "123214aa",'+
		'      "CBSAccNo2": "123214ss",'+
		'      "CBSAccNo3": "123214kk",'+
		'      "CBSAccNo4": "123214ww",'+
		'      "CBSAccNo5": "123214rr",'+
		'      "IsFinancial": "True",'+
		'      "PerfiosReqId1": "jasgkjasdsddf",'+
		'      "PerfiosReqId2": "kdfjvkjsdlfklkdf",'+
		'      "PerfiosUrl": "www.perfios.com/jhj/hjggj",'+
		'      "Customer_IC": "5647658",'+
		'      "AddressFrmCBS": "text",'+
		'      "Gross_Income_1": "73872",'+
		'      "Capital_Gains_1": "73827",'+
		'      "Interest_income_1": "9312829",'+
		'      "Dividend_income_1": "723873",'+
		'      "Tax_1": "12873",'+
		'      "Gross_Income_2": "8373",'+
		'      "Capital_Gains_2": "7379279",'+
		'      "Interest_income_2": "278372",'+
		'      "Dividend_income_2": "73262",'+
		'      "Tax_2": "72837",'+
		'      "Gross_Income_3": "73287",'+
		'      "Capital_Gains_3": "7837",'+
		'      "Interest_income_3": "7382",'+
		'      "Dividend_income_3": "63286",'+
		'      "Tax_3": "73287",'+
		'      "Month_1_Income": "73872",'+
		'      "Month_2_Income": "72872",'+
		'      "Month_3_Income": "732872",'+
		'      "Month_4_Income": "72387",'+
		'      "Month_5_Income": "6237673",'+
		'      "Month_6_Income": "7328732",'+
		'      "Amount_Paid": "8378723",'+
		'      "MinNMI": "83298",'+
		'      "Tax": "1200",'+
		'      "Recurring_Income_bs": "12200.00",'+
		'      "Agriculture_Income_itr": "30000.00",'+
		'      "Share_of_Profit_itr": "78098.00",'+
		'      "AlternativeMobile": "9812567549",'+
		'      "LandLine": "0801276512",'+
		'      "PrimaryBank": "Karur vaishya Bank",'+
		'       "Company": ['+
		'        {'+
		'          "Business_Customer_ID": "5311",'+
		'          "Firm_name": "Tcs",'+
		'          "Firm_type": "primary",'+
		'          "Relationship_with_Firm": "AASEAR",'+
		'          "Firm_PAN": "ASDD",'+
		'          "Firm_Address": "54 bangalore",'+
		'          "Firm_Pincode": "700075"'+
		'        }'+
		'      ]'+
		''+
		'     '+
		''+
		'    }'+
		'  ],'+
		'  "Collateral": ['+
		'    {'+
		'      "Collateral_Type": "Vehicles",'+
		'      "Collateral_Address": "sahidnagar",'+
		'      "Collateral_State": "WestBengal",'+
		'      "Collateral_City": "kolkata",'+
		'      "Collateral_PinCode": "700075",'+
		'      "EM_Charge_type": "Fresh",'+
		'      "No._of_tenants": "2",'+
		'      "Vacant_Land_area": "500",'+
		'      "Collateral_Market_Value": "100000",'+
		'      "ManufacturerName": "Hundai",'+
		'      "Model": "i20",'+
		'      "Variant": "4890",'+
		'      "DealerName": "shyamHundai",'+
		'      "DealerEmail": "shyamhundai@gmail.com",'+
		'      "DealerPincode": "700078",'+
		'      "DealerPhone": "7006084139",'+
		'      "ExShowRoomPrice": "600000",'+
		'      "RegistrationCost": "5000",'+
		'      "InsuranceAmount": "10000",'+
		'      "AccessoriesValue": "10000",'+
		'      "TotalVehicleValue": "700000",'+
		'       "Title_Holder": ['+
		'        {'+
		'          "ApplicantId": "0010l00000H3Lw6"'+
		'        }'+
		'       '+
		'      ]'+
		'      '+
		'    }'+
		'  '+
		'  ]'+
		'}';

        return json;
    }

}