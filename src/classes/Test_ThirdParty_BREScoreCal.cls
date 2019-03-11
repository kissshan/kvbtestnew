@isTest
public class Test_ThirdParty_BREScoreCal {
  
   @istest
    public static void method1() {         
        WS_Vendor_TestUtil.kvbCompanyDetails();
        WS_Vendor_TestUtil.productDetails();
        //WS_Vendor_TestUtil.createCustomSettingRecords();
        Account ac = new Account();
        ac.RecordTypeId = WS_Vendor_RestAPIHelper.getRecordType(WS_Vendor_Constants.PERSON_ACCOUNT);
        ac.Aadhaar_Number__pc = 'TestRef123456789';
        String D=date.today().format();
        ac.Customer_ID_Creation_Date__c= Date.parse(D);
        ac.LastName = 'TestAccount';
        //String DOB='1987-09-28';
        ac.PersonBirthdate= Date.parse('09/11/1990');
        insert ac;
        genesis__Applications__c app = WS_Vendor_TestUtil.createApplication(WS_Vendor_Constants.HOMELOAN);
        genesis__Application_Parties__c party = new genesis__Application_Parties__c();
        party.genesis__Party_Account_Name__c = ac.Id;
        party.genesis__Application__c = app.Id;
        party.Active__c=True;
        party.Financial_Applicant__c=true;
        party.Employment_Types__c='Salaried';
        party.genesis__Party_Type__c='Primary Applicant';
        party.Average_Balances_6_months__c=12409.00;
        party.Additional_Income_Amount1__c=1000.00;
         party.Additional_Income_Amount2__c=1000.00;
         party.Additional_Income_Amount3__c=1000.00;
         party.Additional_Income_Amount4__c=1000.00;
         party.Additional_Income_Amount5__c=1000.00;
        party.Total_ChequeECS_bounces__c=10;
        party.CIBIL_Scores__c=690;
        
        
        insert party;
        clcommon__Collateral__c col=new clcommon__Collateral__c();
        col.genesis__Application__c=app.id;
        col.clcommon__Collateral_Name__c='Test Collateral';
        col.Collateral_Uses__c='Residential';
        col.Collateral_Market_Value__c=10;
        col.clcommon__City__c='ERODE';
        insert col;
        app.genesis__Account__c = ac.Id;
        app.genesis__Loan_Amount__c    =200010.00;
        app.genesis__Term__c = 12;
        app.Sub_Stage__c='3rd Party CBS Pending';
        app.NMI_Claimed_By_Customer__c=120000;
        //app.genesis__Interest_Rate__c=12000.00;
        app.Recommended_Final_Rate_of_Interest__c=120;
        app.Sourced_By__c='CHFL';
        app.Sanction_Authority_Limit__c=200010;
        update app; 
        System.debug('Application Test'+app.Id);
        String jsonString ='{ "applicationid": "'+app.Id+'", "CollateralDetails": [ { "accessories_value":"10000", "advances_paid":"5678", "chassis_no":"12345", "dd_amount":"300000", "dd_date":"2018-12-08", "dealer_email":"bhavyapal93@gmail.com", "dealer_name":"Bhavya P",'+
                           +'"dealer_phone":"9901779552", "dealer_pin":"573115", "exshowroom_price":"250000", "exshowroom_price_car":"250000", "final_vehicle_value":"350000", "financing_authority":"Orange Motor", "proforma_invoice_date":"2018-12-04", "proforma_invoice_no":"234567", "registration_date":"2018-12-12", "registration_no":"KA519326", "RC_response_error_code":"200", "RC_response_error_message":"Success", "registration_cost":"100000",'+
                           +'"security_details":"", "total_vehicle_value":"350000", "variant":"0.25", "vehicle_age":"1", "vehicle_calculated_value":"350000", "vehicle_company":"Tata", "vehicle_model":"2AS", "vehicle_number":"KA519326", "vehicle_owner_name":"Soni", "manufacturer_name":"Tata", "model_name":"", "year_name":"2018", "address":"HSR Layout", "city":"ERODE", "state":"Karnataka", "insurance_amount":"6000", "certificated":"true",'+
                           +'"homestead_property":"true", "collateral_insurance_required":"false", "IDERA":"true", "vehicle_serial_no":"2345", "vehicle_description":"two wheeler", "body_style":"", "scheme_type":"" } ] }';
        RestRequest req = new RestRequest();     
        req.requestURI = '/services/apexrest/UpdateProperty';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        
        System.debug('Record type test in test class'+app.recordtype.name);
        
        test.starttest();
            WS_Vendor_UpdatePropertyinApplication.UpdateProperty();
         //   ThirdParty_BREScoreCal.Calculate_Bre(app);     
        test.stoptest();
    }    
    
     @istest
    public static void method2() {         
        WS_Vendor_TestUtil.kvbCompanyDetails();
        WS_Vendor_TestUtil.productDetails();
        //WS_Vendor_TestUtil.createCustomSettingRecords();
        Account ac = new Account();
        ac.RecordTypeId = WS_Vendor_RestAPIHelper.getRecordType(WS_Vendor_Constants.PERSON_ACCOUNT);
        ac.Aadhaar_Number__pc = 'TestRef123456789';
        String D=date.today().format();
        ac.Customer_ID_Creation_Date__c= Date.parse(D);
        ac.LastName = 'TestAccount';
        ac.PersonBirthdate= Date.parse('09/11/1990');
        insert ac;
        genesis__Applications__c app = WS_Vendor_TestUtil.createApplication(WS_Vendor_Constants.HOMELOAN);
        genesis__Application_Parties__c party = new genesis__Application_Parties__c();
        party.genesis__Party_Account_Name__c = ac.Id;
        party.genesis__Application__c = app.Id;
        party.Active__c=True;
        party.Financial_Applicant__c=true;
        party.Average_Balances_6_months__c=12409.00;
        party.Employment_Types__c='Agriculturist1';
        party.genesis__Party_Type__c='Primary Applicant';  
        party.Additional_Income_Amount1__c=0.00;
         party.Additional_Income_Amount2__c=0.00;
         party.Additional_Income_Amount3__c=0.00;
         party.Additional_Income_Amount4__c=0.00;
         party.Additional_Income_Amount5__c=0.00;
        party.Net_Monthly_Income__c=100.00;
        party.Average_Balances_6_months__c=12409.00;
        insert party;
        clcommon__Collateral__c col=new clcommon__Collateral__c();
        col.genesis__Application__c=app.id;
        col.clcommon__Collateral_Name__c='Test Collateral';
        col.Collateral_Uses__c='Commercial';
        col.Collateral_Market_Value__c=10;
        col.clcommon__City__c='CHENNAI';
        insert col;
        app.genesis__Account__c = ac.Id;
      //  app.genesis__Interest_Rate__c=9.23;
       app.genesis__Loan_Amount__c  =200010.00;
        app.genesis__Term__c = 12;
        app.Sub_Stage__c='3rd Party CBS Pending';
        app.NMI_Claimed_By_Customer__c=120000;
        app.Sourced_By__c='CHFL';
        app.Sanction_Authority_Limit__c=200010;
        update app; 
         
        String jsonString ='{ "applicationid": "'+app.Id+'", "CollateralDetails": [ { "accessories_value":"10000", "advances_paid":"5678", "chassis_no":"12345", "dd_amount":"300000", "dd_date":"2018-12-08", "dealer_email":"bhavyapal93@gmail.com", "dealer_name":"Bhavya P",'+
                           +'"dealer_phone":"9901779552", "dealer_pin":"573115", "exshowroom_price":"250000", "exshowroom_price_car":"250000", "final_vehicle_value":"350000", "financing_authority":"Orange Motor", "proforma_invoice_date":"2018-12-04", "proforma_invoice_no":"234567", "registration_date":"2018-12-12", "registration_no":"KA519326", "RC_response_error_code":"200", "RC_response_error_message":"Success", "registration_cost":"100000",'+
                           +'"security_details":"", "total_vehicle_value":"350000", "variant":"0.25", "vehicle_age":"1", "vehicle_calculated_value":"350000", "vehicle_company":"Tata", "vehicle_model":"2AS", "vehicle_number":"KA519326", "vehicle_owner_name":"Soni", "manufacturer_name":"Tata", "model_name":"", "year_name":"2018", "address":"HSR Layout", "city":"CHENNAI", "state":"Karnataka", "insurance_amount":"6000", "certificated":"true",'+
                           +'"homestead_property":"true", "collateral_insurance_required":"false", "IDERA":"true", "vehicle_serial_no":"2345", "vehicle_description":"two wheeler", "body_style":"", "scheme_type":"" } ] }';
        RestRequest req = new RestRequest();     
        req.requestURI = '/services/apexrest/UpdateProperty';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        
        System.debug('Record type test in test class'+app.recordtype.name);
        
        test.starttest();
            WS_Vendor_UpdatePropertyinApplication.UpdateProperty();
          //  ThirdParty_BREScoreCal.Calculate_Bre(app);     
        test.stoptest();
    }
     @istest
    public static void method3() {         
        WS_Vendor_TestUtil.kvbCompanyDetails();
        WS_Vendor_TestUtil.productDetails();
        //WS_Vendor_TestUtil.createCustomSettingRecords();
        Account ac = new Account();
        ac.RecordTypeId = WS_Vendor_RestAPIHelper.getRecordType(WS_Vendor_Constants.PERSON_ACCOUNT);
        ac.Aadhaar_Number__pc = 'TestRef123456789';
        String D=date.today().format();
        ac.Customer_ID_Creation_Date__c= Date.parse(D);
        ac.LastName = 'TestAccount';
         ac.PersonBirthdate= Date.parse('09/11/1990');
        insert ac;
        genesis__Applications__c app = WS_Vendor_TestUtil.createApplication(WS_Vendor_Constants.VL2W);
        genesis__Application_Parties__c party = new genesis__Application_Parties__c();
        party.genesis__Party_Account_Name__c = ac.Id;
        party.genesis__Application__c = app.Id;
        party.Active__c=True;
        party.Financial_Applicant__c=true;
        party.Employment_Types__c='Agriculturist1';
        party.genesis__Party_Type__c='Primary Applicant';  
        party.Additional_Income_Amount1__c=0.02;
         party.Additional_Income_Amount2__c=0.00;
         party.Additional_Income_Amount3__c=0.00;
         party.Additional_Income_Amount4__c=0.00;
         party.Additional_Income_Amount5__c=0.00;
        party.Average_Balances_6_months__c=12409.00;
        party.Net_Monthly_Income__c=0.00;
        insert party;
        app.genesis__Account__c = ac.Id;
      //  app.genesis__Interest_Rate__c=9.23;
        app.genesis__Loan_Amount__c =200010.00;
        app.genesis__Term__c = 12;
        app.Sub_Stage__c='3rd Party CBS Pending';
        app.NMI_Claimed_By_Customer__c=120000;
        app.Sourced_By__c='CHFL';
        app.Sanction_Authority_Limit__c=200010;
        update app; 
        clcommon__Collateral__c col=new clcommon__Collateral__c();
        col.genesis__Application__c=app.id;
        col.clcommon__Collateral_Name__c='Test Collateral';
        col.Collateral_Uses__c='Residential';
        col.Collateral_Market_Value__c=10;
        //col.clcommon__City__c='CHENNAI';
        insert col;
        String jsonString ='{ "applicationid": "'+app.Id+'", "CollateralDetails": [ { "accessories_value":"10000", "advances_paid":"5678", "chassis_no":"12345", "dd_amount":"300000", "dd_date":"2018-12-08", "dealer_email":"bhavyapal93@gmail.com", "dealer_name":"Bhavya P",'+
                           +'"dealer_phone":"9901779552", "dealer_pin":"573115", "exshowroom_price":"250000", "exshowroom_price_car":"250000", "final_vehicle_value":"350000", "financing_authority":"Orange Motor", "proforma_invoice_date":"2018-12-04", "proforma_invoice_no":"234567", "registration_date":"2018-12-12", "registration_no":"KA519326", "RC_response_error_code":"200", "RC_response_error_message":"Success", "registration_cost":"100000",'+
                           +'"security_details":"", "total_vehicle_value":"350000", "variant":"0.25", "vehicle_age":"1", "vehicle_calculated_value":"350000", "vehicle_company":"Tata", "vehicle_model":"2AS", "vehicle_number":"KA519326", "vehicle_owner_name":"Soni", "manufacturer_name":"Tata", "model_name":"", "year_name":"2018", "address":"HSR Layout", "city":"CHENNAI", "state":"Karnataka", "insurance_amount":"6000", "certificated":"true",'+
                           +'"homestead_property":"true", "collateral_insurance_required":"false", "IDERA":"true", "vehicle_serial_no":"2345", "vehicle_description":"two wheeler", "body_style":"", "scheme_type":"" } ] }';
        RestRequest req = new RestRequest();     
        req.requestURI = '/services/apexrest/UpdateProperty';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        
        System.debug('Record type test in test class'+app.recordtype.name);
        
        test.starttest();
            WS_Vendor_UpdatePropertyinApplication.UpdateProperty();
            //ThirdParty_BREScoreCal.Calculate_Bre(app);     
        test.stoptest();
    }
    
     @istest
    public static void method4() {         
        WS_Vendor_TestUtil.kvbCompanyDetails();
        WS_Vendor_TestUtil.productDetails();
        //WS_Vendor_TestUtil.createCustomSettingRecords();
        Account ac = new Account();
        ac.RecordTypeId = WS_Vendor_RestAPIHelper.getRecordType(WS_Vendor_Constants.PERSON_ACCOUNT);
        ac.Aadhaar_Number__pc = 'TestRef123456789';
        String D=date.today().format();
        ac.Customer_ID_Creation_Date__c= Date.parse(D);
        ac.LastName = 'TestAccount'; 
        ac.PersonBirthdate= Date.parse('09/11/1990');
        insert ac;
        genesis__Applications__c app = WS_Vendor_TestUtil.createApplication(WS_Vendor_Constants.VL2W);
        genesis__Application_Parties__c party = new genesis__Application_Parties__c();
        party.genesis__Party_Account_Name__c = ac.Id;
        party.genesis__Application__c = app.Id;
        party.Active__c=True;
        party.Financial_Applicant__c=true;
        party.Employment_Types__c='Agriculturist';
        party.genesis__Party_Type__c='Primary Applicant';  
        party.Additional_Income_Amount1__c=0.02;
         party.Additional_Income_Amount2__c=0.00;
         party.Additional_Income_Amount3__c=0.00;
         party.Additional_Income_Amount4__c=0.00;
         party.Additional_Income_Amount5__c=0.00;
        party.Average_Balances_6_months__c=12409.00;
        party.Net_Monthly_Income__c=0.00;
        insert party;
        app.genesis__Account__c = ac.Id;
       // app.genesis__Interest_Rate__c=9.23;
        app.genesis__Loan_Amount__c =200010.00;
        app.genesis__Term__c = 12;
        app.Sub_Stage__c='3rd Party CBS Pending';
        app.NMI_Claimed_By_Customer__c=120000;
        app.Sourced_By__c='CHFL';
        app.Sanction_Authority_Limit__c=200010;
        update app; 
        clcommon__Collateral__c col=new clcommon__Collateral__c();
        col.genesis__Application__c=app.id;
        col.clcommon__Collateral_Name__c='Test Collateral';
        col.Collateral_Uses__c='Residential';
        col.Collateral_Market_Value__c=10;
        //col.clcommon__City__c='CHENNAI';
        insert col;
        String jsonString ='{ "applicationid": "'+app.Id+'", "CollateralDetails": [ { "accessories_value":"10000", "advances_paid":"5678", "chassis_no":"12345", "dd_amount":"300000", "dd_date":"2018-12-08", "dealer_email":"bhavyapal93@gmail.com", "dealer_name":"Bhavya P",'+
                           +'"dealer_phone":"9901779552", "dealer_pin":"573115", "exshowroom_price":"250000", "exshowroom_price_car":"250000", "final_vehicle_value":"350000", "financing_authority":"Orange Motor", "proforma_invoice_date":"2018-12-04", "proforma_invoice_no":"234567", "registration_date":"2018-12-12", "registration_no":"KA519326", "RC_response_error_code":"200", "RC_response_error_message":"Success", "registration_cost":"100000",'+
                           +'"security_details":"", "total_vehicle_value":"350000", "variant":"0.25", "vehicle_age":"1", "vehicle_calculated_value":"350000", "vehicle_company":"Tata", "vehicle_model":"2AS", "vehicle_number":"KA519326", "vehicle_owner_name":"Soni", "manufacturer_name":"Tata", "model_name":"", "year_name":"2018", "address":"HSR Layout", "city":"CHENNAI", "state":"Karnataka", "insurance_amount":"6000", "certificated":"true",'+
                           +'"homestead_property":"true", "collateral_insurance_required":"false", "IDERA":"true", "vehicle_serial_no":"2345", "vehicle_description":"two wheeler", "body_style":"", "scheme_type":"" } ] }';
        RestRequest req = new RestRequest();     
        req.requestURI = '/services/apexrest/UpdateProperty';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        
        System.debug('Record type test in test class'+app.recordtype.name);
        
        test.starttest();
           WS_Vendor_UpdatePropertyinApplication.UpdateProperty();
           // ThirdParty_BREScoreCal.Calculate_Bre(app);     
        test.stoptest();
    }
     @istest
    public static void method5() {         
        WS_Vendor_TestUtil.kvbCompanyDetails();
        WS_Vendor_TestUtil.productDetails();
        //WS_Vendor_TestUtil.createCustomSettingRecords();
        Account ac = new Account();
        ac.RecordTypeId = WS_Vendor_RestAPIHelper.getRecordType(WS_Vendor_Constants.PERSON_ACCOUNT);
        ac.Aadhaar_Number__pc = 'TestRef123456789';
        String D=date.today().format();
        ac.Customer_ID_Creation_Date__c= Date.parse(D);
        ac.LastName = 'TestAccount';
         ac.PersonBirthdate= Date.parse('09/11/1990');
        insert ac;
        genesis__Applications__c app = WS_Vendor_TestUtil.createApplication(WS_Vendor_Constants.HOMELOAN);
        genesis__Application_Parties__c party = new genesis__Application_Parties__c();
        party.genesis__Party_Account_Name__c = ac.Id;
        party.genesis__Application__c = app.Id;
        party.Active__c=True;
        party.Financial_Applicant__c=true;
        party.Employment_Types__c='Agriculturist';
        party.genesis__Party_Type__c='Primary Applicant';  
        party.Additional_Income_Amount1__c=0.02;
         party.Additional_Income_Amount2__c=0.00;
         party.Additional_Income_Amount3__c=0.00;
         party.Additional_Income_Amount4__c=0.00;
         party.Additional_Income_Amount5__c=0.00;
        party.Average_Balances_6_months__c=12409.00;
        party.Net_Monthly_Income__c=0.00;
        insert party;
        app.genesis__Account__c = ac.Id;
       // app.genesis__Interest_Rate__c=9.23;
        app.genesis__Loan_Amount__c =200010.00;
        app.genesis__Term__c = 12;
        app.Sub_Stage__c='3rd Party CBS Pending';
        app.NMI_Claimed_By_Customer__c=120000;
        app.Sourced_By__c='CHFL';
        app.Sanction_Authority_Limit__c=200010;
        update app; 
        clcommon__Collateral__c col=new clcommon__Collateral__c();
        col.genesis__Application__c=app.id;
        col.clcommon__Collateral_Name__c='Test Collateral';
        col.Collateral_Uses__c='Residential';
        col.Collateral_Market_Value__c=10;
        //col.clcommon__City__c='CHENNAI';
        insert col;
        String jsonString ='{ "applicationid": "'+app.Id+'", "CollateralDetails": [ { "accessories_value":"10000", "advances_paid":"5678", "chassis_no":"12345", "dd_amount":"300000", "dd_date":"2018-12-08", "dealer_email":"bhavyapal93@gmail.com", "dealer_name":"Bhavya P",'+
                           +'"dealer_phone":"9901779552", "dealer_pin":"573115", "exshowroom_price":"250000", "exshowroom_price_car":"250000", "final_vehicle_value":"350000", "financing_authority":"Orange Motor", "proforma_invoice_date":"2018-12-04", "proforma_invoice_no":"234567", "registration_date":"2018-12-12", "registration_no":"KA519326", "RC_response_error_code":"200", "RC_response_error_message":"Success", "registration_cost":"100000",'+
                           +'"security_details":"", "total_vehicle_value":"350000", "variant":"0.25", "vehicle_age":"1", "vehicle_calculated_value":"350000", "vehicle_company":"Tata", "vehicle_model":"2AS", "vehicle_number":"KA519326", "vehicle_owner_name":"Soni", "manufacturer_name":"Tata", "model_name":"", "year_name":"2018", "address":"HSR Layout", "city":"CHENNAI", "state":"Karnataka", "insurance_amount":"6000", "certificated":"true",'+
                           +'"homestead_property":"true", "collateral_insurance_required":"false", "IDERA":"true", "vehicle_serial_no":"2345", "vehicle_description":"two wheeler", "body_style":"", "scheme_type":"" } ] }';
        RestRequest req = new RestRequest();     
        req.requestURI = '/services/apexrest/UpdateProperty';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        
        System.debug('Record type test in test class'+app.recordtype.name);
        
        test.starttest();
            WS_Vendor_UpdatePropertyinApplication.UpdateProperty();
            //ThirdParty_BREScoreCal.Calculate_Bre(app);     
        test.stoptest();
    }
     
}