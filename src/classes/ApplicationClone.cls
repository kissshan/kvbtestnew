/* ClassName - ApplicationClone
*  Purpose   - Class to create  a clone copy of a application record with its related list.
*  Company   - ET Marlabs
*  Date      - 24/04/2018
*  Author    - Ashish Jain  
*/
public class ApplicationClone {

    public static String appRecordType;
    public static Id appOwnerId;
    //method having application id and new record type
    public static String cloneApplication(String appId, String recDevType){
        System.debug('recDevType:::'+recDevType);

        appRecordType= recDevType;
        string recType = ApplicationClone.getRecordType(recDevType);
        System.debug('recType:::'+recType);
        String parenttype = 'Parent';
        System.debug('appId:::'+appId);
        System.debug('recDevType:::'+recDevType);
        //this query is fetching application of passed id
        String queryToApplication = 'select id,genesis__Account__r.CBS_Customer_ID__c, name,recordTypeId,Cash_Flow_Method__c,genesis__Account__r.name,Branch_Code__c, EC_Reference__c,'+
                'Branch_Name__c, FEC_Reference_Number__c, OwnerId,EC_Date__c, customerId__c, '+
                'EC_Start_Date__c,EC_End_Date__c, Latest_Month_Stock_Statement__c, Charge_ID__c,  '+
                'Insurance_Number__c, Insurance_Value__c, Insurance_Start_Date__c, Insurance_End_Date__c, '+
                'Latest_Valuation_Date__c, Latest_Audited_Financial_Statement_Year__c, Application_UI_Stage__c,'+
                'Latest_Date_of_Visit__c, Security_ID__c, Asset_ID__c, Asset_Value__c, Renewal_Due_Date__c, '+
                'Asset_Description__c, SRN_ID__c '+
                'from genesis__Applications__c where id =: appId';

        //this query to fetch all parties of that related application
        String queryToParties = 'select id, Key_Contact__r.CBS_Customer_ID__c,genesis__Party_Account_Name__r.CBS_Customer_ID__c, genesis__Party_Account_Name__c, genesis__Party_Type__c,Key_Contact__c, '+
                'genesis__Party_Account_Name__r.FirstName, genesis__Party_Account_Name__r.LastName,'+
                'Guarantor__c, Joint_Holder__c, Signatories__c, active__c, genesis__Application__c from '+
                'genesis__Application_Parties__c where genesis__Application__c =: appId AND Active__c = true';
        System.debug('appId:::'+appId);
        //this query is to fetch all facility and  collateral of the same application
        String queryToFacility = 'select id,Type__c,Facility_Application_Type__c,Renewal_Processing_Charge__c,Holiday_Period__c,CL_Product__r.Product_Code__c,CL_Product__r.Existing_Rate_Commission__c,CL_Product__r.Processing_fee_renwal__c,CL_Product__r.Processing_fee_fresh__c,Application__c, Total_Loan_Amount__c, Balance_Outstandings__c,'+
                'Over_Due__c, Existing_Spread__c,Recommended_Spread__c, MCLR_Rate__c, Existing_Processing_Charge__c,CL_Product__c, Interest_Type__c,Margin__c,'+
                'approved_Margin__c, Loan_Purpose__c, Account_Number__c, Limit_Amount__c, Existing_Margin_Receivables__c, '+
                'Amount_Disbursed__c, Amount_Net_Disbursed__c, Amount_Yet_disbursed__c, Variance__c, recordTypeId,Recommended_Rate__c, '+
                'Final_Authority_Name__c, Processing_Charge__c, Existing_Rate__c, Existing_Limit__c,'+
                '(select id, Facility__c, genesis__Collateral__c, Application__c, Security_Type__c from Facility_Security__r),'+
                'CL_Product__r.Existing_Margin__c,CL_Product__r.Existing_Margin_Receivables__c,CL_Product__r.Existing_Margin_Stock_Manufacturing__c,CL_Product__r.Existing_Margin_Stock_Trading__c,CL_Product__r.MCLR_Rate__c,'+
                'existing_Margin_Stock_Manufacturing__c, Existing_Margin_Stock_Trading__c from Facility__c where Recordtype.DeveloperName =: parenttype AND Application__c=:appId';

        Savepoint sp = database.setSavepoint();
        try{System.debug('hellboy');
            genesis__Applications__c gApp = Database.query(queryToApplication);
            System.debug('gApp:::'+gApp);
            genesis__Applications__c gAppClone = new genesis__Applications__c();
            gAppClone = ApplicationClone.applicationCreation(gApp, recType);
            gAppClone.Active__c = TRUE;
            insert gAppClone;
            System.debug('gAppClone.id:::'+gAppClone);
            List<genesis__Application_Parties__c> gAppParties = Database.query(queryToParties);
            List<genesis__Application_Parties__c> gAppPartiesClone = ApplicationClone.partiesCreation(gAppClone.id, gAppParties);
            insert gAppPartiesClone;
            System.debug('gAppPartiesClone:::'+gAppPartiesClone);
            List<Facility__c> facility = Database.query(queryToFacility);
            ApplicationClone.facilityCreation(facility, gAppClone.id);
            System.debug('gAppClone.id:::'+gAppClone.id);
            return gAppClone.id;
        }catch(Exception e){
            System.debug('lineNumber:::'+e.getLineNumber());
            System.debug('Error Message'+e.getStackTraceString());
            System.debug('msg:::'+e.getMessage());
            Database.rollback(sp);
            return null;
        }
    }

    //Passing application and recordtype to take duplicate application.
    public static genesis__Applications__c applicationCreation(genesis__Applications__c gApp, String recType){
        genesis__Applications__c gAppCloneCopy = new genesis__Applications__c();
        System.debug('hellboy1');
        System.debug('gApp:::'+gApp);
        gAppCloneCopy.Parent_Application__c = (String)gApp.Id;
        gAppCloneCopy.Application_UI_Stage__c    = 'NA';
        if(gApp.genesis__Account__c!=null){
            gAppCloneCopy.genesis__Account__c = gApp.genesis__Account__c;
        }
        if(gApp.Branch_Code__c != null){
            gAppCloneCopy.Branch_Code__c = gApp.Branch_Code__c;
        }
        if(gApp.Branch_Name__c != null){
            gAppCloneCopy.Branch_Name__c = gApp.Branch_Name__c;
        }
        if(gApp.OwnerId != null){
            gAppCloneCopy.OwnerId = gApp.OwnerId;
            appOwnerId = gApp.OwnerId;
        }

        if(gApp.FEC_Reference_Number__c  != null){
            gAppCloneCopy.FEC_Reference_Number__c = gApp.FEC_Reference_Number__c;
        }
        if(gApp.EC_Date__c  != null){
            gAppCloneCopy.EC_Date__c =  gApp.EC_Date__c;
        }
        if(gApp.EC_Start_Date__c != null){
            gAppCloneCopy.EC_Start_Date__c = gApp.EC_Start_Date__c;
        }
        if(gApp.EC_End_Date__c != null){
            gAppCloneCopy.EC_End_Date__c = gApp.EC_End_Date__c;
        }
        if(gApp.Latest_Month_Stock_Statement__c != null){
            gAppCloneCopy.Latest_Month_Stock_Statement__c = gApp.Latest_Month_Stock_Statement__c;
        }
        if(gApp.Charge_ID__c != null){
            gAppCloneCopy.Charge_ID__c = gApp.Charge_ID__c;
        }
        if(gApp.Insurance_Number__c != null){
            gAppCloneCopy.Insurance_Number__c = gApp.Insurance_Number__c;
        }
        if(gApp.Insurance_Value__c != null){
            gAppCloneCopy.Insurance_Value__c = gApp.Insurance_Value__c;
        }
        if(gApp.Insurance_Start_Date__c != null){
            gAppCloneCopy.Insurance_Start_Date__c = gApp.Insurance_Start_Date__c;
        }
        if(gApp.Insurance_End_Date__c != null){
            gAppCloneCopy.Insurance_End_Date__c = gApp.Insurance_End_Date__c;
        }
		if(gApp.Renewal_Due_Date__c != null){
            gAppCloneCopy.Renewal_Due_Date__c = gApp.Renewal_Due_Date__c;
        }
        System.debug('recType:::'+recType);
        //System.debug('ApplicationClone.getApplicationStage(rectype):::'+ApplicationClone.getApplicationStage(rectype));
        gAppCloneCopy.Application_Stage__c = ApplicationClone.getApplicationStage(rectype);

        if(gApp.Latest_Valuation_Date__c != null){
            gAppCloneCopy.Latest_Valuation_Date__c = gApp.Latest_Valuation_Date__c;
        }
        if(gApp.Latest_Audited_Financial_Statement_Year__c != null){
            gAppCloneCopy.Latest_Audited_Financial_Statement_Year__c = gApp.Latest_Audited_Financial_Statement_Year__c;
        }
        if(gApp.Latest_Date_of_Visit__c != null){
            gAppCloneCopy.Latest_Date_of_Visit__c = gApp.Latest_Date_of_Visit__c;
        }
        if(gApp.Security_ID__c != null){
            gAppCloneCopy.Security_ID__c = gApp.Security_ID__c;
        }
        if(gApp.Asset_ID__c != null){
            gAppCloneCopy.Asset_ID__c = gApp.Asset_ID__c;
        }
        if(gApp.Asset_Value__c != null){
            gAppCloneCopy.Asset_Value__c = gApp.Asset_Value__c;
        }
        if(gApp.Asset_Description__c != null){
            gAppCloneCopy.Asset_Description__c = gApp.Asset_Description__c;
        }
        if(gApp.SRN_ID__c != null){
            gAppCloneCopy.SRN_ID__c = gApp.SRN_ID__c;
        }
        gAppCloneCopy.Active__c = true;
        If(recType == 'SME NEW Loan'){
            gAppCloneCopy.Type__c   = 'ETB-WC';
            gAppCloneCopy.CBS_API_Sequence__c   = '16';
        }
        else {
            gAppCloneCopy.Type__c   = 'EAE';
            gAppCloneCopy.CBS_API_Sequence__c   = '15';
        }
        gAppCloneCopy.RecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(recType).getRecordTypeId();
        return gAppCloneCopy;
    }

    //Passing application id and list of parties to take duplicate list of parties.
    public static List<genesis__Application_Parties__c> partiesCreation(Id gParId,List<genesis__Application_Parties__c> gAppParties){
        List<genesis__Application_Parties__c> gAppPartiesCloneCopy = new List<genesis__Application_Parties__c>();

        for(genesis__Application_Parties__c gAppPart : gAppParties){
            genesis__Application_Parties__c gAppParties1 = new genesis__Application_Parties__c();
            gAppParties1.genesis__Application__c = gParId;
            gAppParties1.genesis__Party_Account_Name__c = gAppPart.genesis__Party_Account_Name__c;
            gAppParties1.Key_Contact__c = gAppPart.Key_Contact__c;
            gAppParties1.Guarantor__c = gAppPart.Guarantor__c;
            gAppParties1.Joint_Holder__c = gAppPart.Joint_Holder__c;
            gAppParties1.Signatories__c = gAppPart.Signatories__c;
            gAppParties1.Active__c = gAppPart.Active__c;
            gAppParties1.genesis__Party_Type__c = gAppPart.genesis__Party_Type__c;
            if(appOwnerId !=null){
            	gAppParties1.OwnerId = appOwnerId;    
            }
            gAppParties1.External_ID__c = gAppPart.Key_Contact__r.CBS_Customer_ID__c+'@'+gAppPart.genesis__Party_Account_Name__r.CBS_Customer_ID__c+'@'+gParId;
            gAppPartiesCloneCopy.add(gAppParties1);
        }
        return gAppPartiesCloneCopy;
    }

    //method returning facilities related to application against application Id
    public static void facilityCreation(List<Facility__c> facility, Id appId){
        List<Facility__c> facilityList = new List<Facility__c>();
        System.debug('facility:::'+facility);
        String applicationrecordlabelName=getRecordType(appRecordType);
        List<genesis__Application_Collateral__c> facilitySecList    = new List<genesis__Application_Collateral__c>();
        for(Facility__c faci : facility){
            Facility__c fc = new Facility__c();
            if(appId != null){
                fc.Application__c = appId;
            }

            fc.RecordTypeId = faci.RecordTypeId;
            if(faci.Total_Loan_Amount__c != null){
                fc.Total_Loan_Amount__c = faci.Total_Loan_Amount__c;
            }
            if(faci.Balance_Outstandings__c != null){
                fc.Balance_Outstandings__c = faci.Balance_Outstandings__c;
            }
            if(faci.Over_Due__c != null){
                fc.Over_Due__c = faci.Over_Due__c;
            }
            if(faci.MCLR_Rate__c != null){
                fc.MCLR_Rate__c = faci.MCLR_Rate__c;
            }
            if(faci.Existing_Processing_Charge__c != null){
                fc.Existing_Processing_Charge__c = faci.Existing_Processing_Charge__c;
                fc.Renewal_Processing_Charge__c  = faci.Existing_Processing_Charge__c;
            }
            if(faci.CL_Product__c != null){
                fc.CL_Product__c = faci.CL_Product__c;
            }
            if(faci.Interest_Type__c != null){
                fc.Interest_Type__c = faci.Interest_Type__c;
            }
            
            if(faci.Loan_Purpose__c != null){
                fc.Loan_Purpose__c = faci.Loan_Purpose__c;
            }

            if(appRecordType!= null && (applicationrecordlabelName== 'SME NEW Loan' || applicationrecordlabelName== 'SME Enhancement')){

                if(faci.CL_Product__r.Existing_Margin__c != null){
                    fc.Approved_Margin__c = faci.CL_Product__r.Existing_Margin__c; //faci.Approved_Margin__c;
                }
                if(faci.CL_Product__r.Existing_Margin_Receivables__c != null){
                    fc.Existing_Margin_Receivables__c = faci.CL_Product__r.Existing_Margin_Receivables__c; //faci.Existing_Margin_Receivables__c;
                }
                if(faci.CL_Product__r.Existing_Margin_Stock_Manufacturing__c != null){
                    fc.Existing_Margin_Stock_Manufacturing__c =  faci.CL_Product__r.Existing_Margin_Stock_Manufacturing__c;//faci.Existing_Margin_Stock_Manufacturing__c;
                }
                if(faci.CL_Product__r.Existing_Margin_Stock_Trading__c != null){
                    fc.Existing_Margin_Stock_Trading__c = faci.CL_Product__r.Existing_Margin_Stock_Trading__c; //faci.Existing_Margin_Stock_Trading__c;
                }
                if(faci.CL_Product__r.MCLR_Rate__c != null){
                    // Comment This
                    fc.MCLR_Rate__c = faci.CL_Product__r.MCLR_Rate__c;
                }
                /*if(faci.Recommended_Spread__c != null && getRecordType(appRecordType)== 'SME Enhancement'){
                    fc.Existing_Spread__c = faci.Recommended_Spread__c;
                }*/

            }else{ 
                if(faci.Approved_Margin__c != null){
                    fc.Approved_Margin__c = faci.Approved_Margin__c;
                }
                if(faci.Existing_Margin_Receivables__c != null){
                    fc.Existing_Margin_Receivables__c = faci.Existing_Margin_Receivables__c;
                }
                if(faci.Existing_Margin_Stock_Manufacturing__c != null){
                    fc.Existing_Margin_Stock_Manufacturing__c = faci.Existing_Margin_Stock_Manufacturing__c;
                }
                if(faci.Existing_Margin_Stock_Trading__c != null){
                    fc.Existing_Margin_Stock_Trading__c = faci.Existing_Margin_Stock_Trading__c;
                }
            }
            if(appRecordType!= null &&  Constants.SME_PROCESSING_FEE_LIST.contains(applicationrecordlabelName)){
                fc.Existing_Processing_Charge__c = faci.CL_Product__r.Processing_fee_renwal__c!=null ? faci.CL_Product__r.Processing_fee_renwal__c : null;

           }else if(appRecordType!= null && applicationrecordlabelName== 'SME NEW Loan'){
                fc.NTB_Facility_Type__c     =   'Renewal';
                fc.Existing_Processing_Charge__c = faci.CL_Product__r.Processing_fee_fresh__c!=null ? faci.CL_Product__r.Processing_fee_fresh__c : null;
            }
            if(faci.Amount_Disbursed__c !=null){
                fc.Amount_Disbursed__c = faci.Amount_Disbursed__c;
            }
            if(faci.Amount_Net_Disbursed__c != null){
                fc.Amount_Net_Disbursed__c = faci.Amount_Net_Disbursed__c;
            }
            if(faci.Amount_Yet_disbursed__c != null){
                fc.Amount_Yet_disbursed__c = faci.Amount_Yet_disbursed__c;
            }
            if(faci.Variance__c != null){
                fc.Variance__c =faci.Variance__c;
            }
            if(faci.Final_Authority_Name__c != null){
                fc.Final_Authority_Name__c = faci.Final_Authority_Name__c;
            }
            if(faci.Processing_Charge__c != null){
                fc.Processing_Charge__c = faci.Processing_Charge__c;
            }
            if(faci.Existing_Rate__c != null){
                fc.Existing_Rate__c = faci.Existing_Rate__c;
            }
            if(faci.Existing_Limit__c != null){
                fc.Existing_Limit__c = faci.Existing_Limit__c;
            }
            if(faci.Existing_Spread__c != null){

                fc.Existing_Spread__c = faci.Existing_Spread__c;

            }
            if(applicationrecordlabelName== 'SME Exceeding' || applicationrecordlabelName== 'SME AdHoc' || applicationrecordlabelName== 'SME Enhancement'){
                /*if(faci.Recommended_Spread__c != null && getRecordType(appRecordType)== 'SME Enhancement'){
                     fc.Existing_Spread__c = faci.Recommended_Spread__c;
                 }*/
                fc.Existing_Spread__c = faci.Recommended_Spread__c;
            }
            /*if(faci.Recommended_Spread__c != null && getRecordType(appRecordType)== 'SME Enhancement'){
                 fc.Existing_Spread__c = faci.Recommended_Spread__c;
            }*/
            if(faci.Account_Number__c != null){
                fc.Account_Number__c = faci.Account_Number__c;
            }
            /* Pre population of BRE Values*/
            if(appRecordType!= null && (applicationrecordlabelName== 'SME NEW Loan' || applicationrecordlabelName== 'SME Enhancement')){
                // Filling Processing Charges
                /*if(appRecordType!= null &&  Constants.SME_PROCESSING_FEE_LIST.contains(getRecordType(appRecordType))){
                    fc.BRE_Processing_Charge__c = faci.CL_Product__r.Processing_fee_renwal__c!=null ? faci.CL_Product__r.Processing_fee_renwal__c : null;

                }*/

                fc.BRE_Processing_Charge__c = faci.CL_Product__r.Processing_fee_fresh__c!=null ? faci.CL_Product__r.Processing_fee_fresh__c : null;

                if(appRecordType!= null && applicationrecordlabelName== 'SME NEW Loan'){
                    fc.NTB_Facility_Type__c     =   'Renewal';
                }
                // Filling Margin
                if(faci.CL_Product__r.Existing_Margin__c != null) {
                    fc.BRE_Margin__c = faci.CL_Product__r.Existing_Margin__c;
                }
                // Filling Margin Receivables
                if(faci.CL_Product__r.Existing_Margin_Receivables__c != null){
                    fc.BRE_Margin_Receivables__c = faci.CL_Product__r.Existing_Margin_Receivables__c; //faci.Existing_Margin_Receivables__c;
                }
                // Filling Margin Stock_Manufacturing
                if(faci.CL_Product__r.Existing_Margin_Stock_Manufacturing__c != null){
                    fc.BRE_Margin_Stock_Manufacturing__c =  faci.CL_Product__r.Existing_Margin_Stock_Manufacturing__c;//faci.Existing_Margin_Stock_Manufacturing__c;
                }
                // Filling Margin Stock_Trading
                if(faci.CL_Product__r.Existing_Margin_Stock_Trading__c != null){
                    fc.BRE_Margin_Stock_Trading__c = faci.CL_Product__r.Existing_Margin_Stock_Trading__c; //faci.Existing_Margin_Stock_Trading__c;
                }
                if(faci.Type__c != 'Funded'){
                    //fc.BRE_Rate__c =
                    fc.BRE_Spread__c = 0.0;
                    fc.BRE_Rate__c = faci.CL_Product__r.Existing_Rate_Commission__c;
                }

            }
            if(applicationrecordlabelName== 'SME Exceeding' || applicationrecordlabelName== 'SME AdHoc' ){
                if(faci.CL_Product__r.Existing_Margin__c != null) {
                    fc.BRE_Margin__c = faci.CL_Product__r.Existing_Margin__c;
                }

                // Filling Margin Receivables
                if(faci.CL_Product__r.Existing_Margin_Receivables__c != null){
                    fc.BRE_Margin_Receivables__c = faci.CL_Product__r.Existing_Margin_Receivables__c; //faci.Existing_Margin_Receivables__c;
                }
                // Filling Margin Stock_Manufacturing
                if(faci.CL_Product__r.Existing_Margin_Stock_Manufacturing__c != null){
                    fc.BRE_Margin_Stock_Manufacturing__c =  faci.CL_Product__r.Existing_Margin_Stock_Manufacturing__c;//faci.Existing_Margin_Stock_Manufacturing__c;
                }
                // Filling Margin Stock_Trading
                if(faci.CL_Product__r.Existing_Margin_Stock_Trading__c != null){
                    fc.BRE_Margin_Stock_Trading__c = faci.CL_Product__r.Existing_Margin_Stock_Trading__c; //faci.Existing_Margin_Stock_Trading__c;
                }

                if(faci.Existing_Rate__c != null && faci.Type__c == 'Funded'){
                    fc.BRE_Rate__c = faci.Existing_Rate__c + 3;

                }

                if(faci.Type__c != 'Funded'){
                    fc.BRE_Rate__c =faci.CL_Product__r.Existing_Rate_Commission__c;
                    fc.BRE_Spread__c =0.0;
                }

            }
            if(applicationrecordlabelName == 'SME NEW Loan')
            fc = getRefreshedDataFromProduct(faci,fc,applicationrecordlabelName);
            /* Added By Ajeet*/
            fc.External_Id__c = faci.Account_Number__c + appId;
            if(appOwnerId !=null)
            	fc.OwnerId	=	appOwnerId;
            
            facilityList.add(fc);
            for(genesis__Application_Collateral__c secur : faci.Facility_Security__r){
                genesis__Application_Collateral__c sec = new genesis__Application_Collateral__c();
                sec.Facility__r = new Facility__c(External_Id__c = faci.Account_Number__c + appId);
                sec.Application__c  = appId;
                sec.genesis__Collateral__c = secur.genesis__Collateral__c;
                sec.Security_Type__c    = secur.Security_Type__c;
                if(appOwnerId !=null)
            		sec.OwnerId	=	appOwnerId;
                
                facilitySecList.add(sec);
            }
        }
        System.debug('facilityList:::'+facilityList);
        System.debug('facilitySecList:::'+facilitySecList);
        insert facilityList;
        insert facilitySecList;
    }
    
    public static Facility__c getRefreshedDataFromProduct(Facility__c facRecord,Facility__c fc,String recType){
       
        /*if(recType!= null && (recType== 'SME NEW Loan' || recType== 'SME Enhancement')){
            fc.Existing_Processing_Charge__c = facRecord.CL_Product__r.Processing_fee_fresh__c;
        }else{
            fc.Existing_Processing_Charge__c = facRecord.CL_Product__r.Processing_fee_renwal__c;
        }
        //All 4 Margin Fields
        if(facRecord.CL_Product__r.Existing_Margin__c!= null)
        fc.Approved_Margin__c 						= facRecord.CL_Product__r.Existing_Margin__c;
        if(facRecord.CL_Product__r.Existing_Margin_Receivables__c!= null)
        fc.Existing_Margin_Receivables__c 			= facRecord.CL_Product__r.Existing_Margin_Receivables__c;
        if(facRecord.CL_Product__r.Existing_Margin_Stock_Manufacturing__c!= null)
        fc.Existing_Margin_Stock_Manufacturing__c 	= facRecord.CL_Product__r.Existing_Margin_Stock_Manufacturing__c;
        if(facRecord.CL_Product__r.Existing_Margin_Stock_Trading__c!= null)
        fc.Existing_Margin_Stock_Trading__c 		= facRecord.CL_Product__r.Existing_Margin_Stock_Trading__c;
         // Existing Rate
        if(facRecord.CL_Product__r.Existing_Rate_Commission__c!= null)
        fc.Existing_Rate__c 						= facRecord.CL_Product__r.Existing_Rate_Commission__c;*/
        if(recType!= null && (recType== 'SME NEW Loan' || recType== 'SME Enhancement')){
            fc.BRE_Processing_Charge__c = facRecord.CL_Product__r.Processing_fee_fresh__c;
        }else{
            fc.BRE_Processing_Charge__c = facRecord.CL_Product__r.Processing_fee_renwal__c;
        }
        //All 4 Margin Fields
        if(facRecord.CL_Product__r.Existing_Margin__c!= null)
            fc.BRE_Margin__c 						= facRecord.CL_Product__r.Existing_Margin__c;
        if(facRecord.CL_Product__r.Existing_Margin_Receivables__c!= null)
            fc.BRE_Margin_Receivables__c 			= facRecord.CL_Product__r.Existing_Margin_Receivables__c;
        if(facRecord.CL_Product__r.Existing_Margin_Stock_Manufacturing__c!= null)
            fc.BRE_Margin_Stock_Manufacturing__c 	= facRecord.CL_Product__r.Existing_Margin_Stock_Manufacturing__c;
        if(facRecord.CL_Product__r.Existing_Margin_Stock_Trading__c!= null)
            fc.BRE_Margin_Stock_Trading__c 		= facRecord.CL_Product__r.Existing_Margin_Stock_Trading__c;
        // Existing Rate
        if(facRecord.CL_Product__r.Existing_Rate_Commission__c!= null && facRecord.Type__c != 'Funded'){
            fc.BRE_Rate__c 						= facRecord.CL_Product__r.Existing_Rate_Commission__c;
        }

        
        return fc;
    }

    //method to return record type label by against record type developer name
    public static String getRecordType(String recDevType){
        System.debug('recDevType:::'+recDevType);
        String recName = [SELECT Name, DeveloperName FROM RecordType WHERE DeveloperName =: recDevType].name;
        return recName;
    }

    //method to return applicn stage against record type label name
    public static String getApplicationStage(String recType){
        System.debug('recType:::'+recType);
        String appStage ='';
        if(recType == 'SME Enhancement'){
            appStage = 'Enhancement- Application created';
            return appStage;
        }
        else if(recType == 'SME Exceeding'){
            appStage = 'Exceeding- Application created';
            return appStage;
        }
        else if(recType == 'SME AdHoc'){
            appStage = 'Adhoc- Application created';
            return appStage;
        }
        else if(recType == 'SME NEW Loan'){
            appStage = 'New loans - Application created';
            return appStage;
        }
        else{
            return null;
        }
    }
}