/*
* Digio Template Generation 
*/ 
public class DigioTemplateService {
    
    public Static Map<String, string> facilityTC    = new Map<String, string>(); 
    public static string sanction_Type              = '';
    public static string SME_DOCUMENT_NAME;
    public static string PENAL_RATE                 = '';
    public static string COMMITMENT_RATE            = ''; 
    public static String next_renewal_Date;
    public static Date NEXT_RENEW_DATE;
    public static List<Facility__c> facilityUpdate;
    public static Decimal FINAL_PROCESSING_CHARGE   = 0;
    public static Date Sanction_Date;
    public static string commitmentCharges          = '';               
    public static string preclosureRate             = '';
    public static String currentYear                = '';
    public static Map<String,String> securtiyDetails;
    public static Map<String,String> ownerNameMap = new Map<String,String>();
    public static List<clcommon__Collateral__c> colList       = new List<clcommon__Collateral__c>();
    public static List<Id> B1_EAE_accList = new List<Id>();
    
    //public static Decimal exceedingPrChrgAmt    = 0.0;              //SME_Exceeding Processing Charge Variable excluding GST
    //public static Decimal enhPrCharge           = 0.0;              //SME_Enhancement & SME_New_Loan Processing Charge variable excluding GST
    //public static Decimal prChargeAdHoc         = 0.0;              //SME_AdHoc Processing Charge variable excluding GST
    public static object getSMESanctionLetter(String appId,String documentName,String templateId){        
        genesis__Applications__c appln = new genesis__Applications__c();
        Sanction_Date                  = date.today();
        securtiyDetails                = new Map<String,String>();
        facilityUpdate                 = new List<Facility__c>();
        try{
            /*appln   = [Select id,Record_Type_Name__c,Renewal_Due_Date__c,genesis__Account__c,genesis__Account__r.Name,genesis__Account__r.Branch_Name__c,
genesis__Account__r.Branch_Code__c,createdDate,Name,genesis__Account__r.BillingStreet,Next_Renewal_Date__c,Security_Description__c,
genesis__Account__r.BillingCity,genesis__Account__r.BillingState,genesis__Account__r.BillingCountry,Sanction_Date__c,
genesis__Account__r.Constitution__c,genesis__Interest_Only_Period__c,genesis__Account__r.BillingPostalCode,
Penal_Interest__c,Preclosure_Charges__c,genesis__Total_Upfront_Payments__c,Processing_charges_with_GST__c,Processing_Charges__c
from genesis__Applications__c where id =:appId];*/
            appln = SME_Digio_Service_EAE.app;
        }catch(QueryException e){}
        
        List<genesis__Application_Parties__c> parties = new List<genesis__Application_Parties__c>();
        try{
            parties = [Select id,genesis__Application__c,Guarantor__c,genesis__Party_Account_Name__c,Signatories__c,
                       genesis__Party_Account_Name__r.Name,Party_Sub_Type__c,genesis__Party_Type__c,Active__c
                       from genesis__Application_Parties__c where genesis__Application__c = :appId 
                       AND (Signatories__c= true OR Guarantor__c = true) AND Active__c = true];
        }catch(QueryException e){}
        
        
        List<Facility__c> facilities = new List<Facility__c>();
        try{
            facilities  = [Select id,Margin__c,Application__c,Application__r.Renewal_Due_Date__c,CL_Product__c,CL_Product__r.clcommon__Product_Name__c,Loan_Purpose__c,Recommended_Processing_Charge__c,
                           MCLR_Rate__c,Interest_Type__c,Type__c,Approved_Margin__c,CL_Product__r.Facility_Category__c,Processing_Charge__c,Existing_Processing_Charge__c,
                           Recommended_Limit__c,Recommended_Rate__c,BRE_Limit__c,BRE_Rate__c,BRE_Spread__c,Final_Spread__c,Variance__c,Existing_Limit__c,Industry__c,Margin_Receivables__c,Margin_Stock_Trading__c,Margin_Stock_Manufacturing__c,
                           (Select id,genesis__Collateral__c,genesis__Collateral__r.Maturity_Date__c,genesis__Collateral__r.clcommon__Insurance_Company_Name__c,genesis__Collateral__r.recordType.DeveloperName,genesis__Collateral__r.Surrender_Value__c,genesis__Collateral__r.clcommon__Value__c,genesis__Collateral__r.MORT_TYPE__c,genesis__Collateral__r.Collateral_Type__c,genesis__Collateral__r.clcommon__Collateral_Type__c,genesis__Collateral__r.clcommon__Policy_Number__c,genesis__Collateral__r.Vehicle_Number__c,genesis__Collateral__r.Machinery_Model__c,genesis__Collateral__r.clcommon__Collateral_Name__c,Security_Type__c,genesis__Collateral__r.Security_Details__c,
                            genesis__Collateral__r.clcommon__Collateral_Category__c,genesis__Collateral__r.Id,genesis__Collateral__r.clcommon__Collateral_Category__r.Name,genesis__Collateral__r.clcommon__Vehicle_Serial_Number__c,
                            Facility__c from Facility_Security__r)
                           from Facility__c where Application__c=:appId AND Active__c = true];
        }catch(Exception e){}
        ownerNameMap           = new Map<String,String>();
        securtiyDetails        = SanctionMatrix_Helper.getSecurityDetails(appId);
        System.debug('securtiyDetails*****'+securtiyDetails);
        
        
        PENAL_RATE          = string.valueof(KVB_Company_Details__c.getOrgDefaults().Penal_Interest__c);
        commitmentCharges   = string.valueof(KVB_Company_Details__c.getOrgDefaults().Commitment_charges__c);
        preclosureRate      = string.valueof(KVB_Company_Details__c.getOrgDefaults().Pre_closure_rate__c);
        
        boolean template123_eligible    = false;
        boolean template12_eligible     = false;
        boolean template13_eligible     = false;
        boolean template1_eligible      = false;
        
        Set<String> facilityCategories  = new Set<String>();
        if(appln.genesis__Account__r.Constitution__c == 'Companies' || appln.genesis__Account__r.Constitution__c == 'Private Limited' 
           || appln.genesis__Account__r.Constitution__c == 'LLP' || appln.genesis__Account__r.Constitution__c == 'Public Limited'){
               template13_eligible  = true;
           }
        for(Facility__c f : facilities){
            if(f.CL_Product__r.Facility_Category__c == 'PCL' || f.CL_Product__r.Facility_Category__c == 'PCFC' ||
               f.CL_Product__r.Facility_Category__c == 'FBN/FBP' || f.CL_Product__r.Facility_Category__c == 'FBN' ||
               f.CL_Product__r.Facility_Category__c == 'FBP' || f.CL_Product__r.Facility_Category__c == 'EBD' ||
               f.CL_Product__r.Facility_Category__c == 'FBG' || f.CL_Product__r.Facility_Category__c =='FDPG' 
               || f.CL_Product__r.Facility_Category__c == 'CEL'){
                   template12_eligible      = true;
               }
            if(f.CL_Product__r.Facility_Category__c != null) facilityCategories.add(f.CL_Product__r.Facility_Category__c);
        }
        
        Map<Id,Audit__C> facTermsCondMap;
        try{
            facTermsCondMap = new Map<Id,Audit__C>([Select id,Facility_Category__c,Seq_No__c,Terms_and_Conditions__c 
                                                    from Audit__C where RecordType.DeveloperName ='Facility_Term_and_Condition' order by Seq_No__c]);  
        }catch(QueryException e){}
        
        facilityTC  = new Map<String, String>();
        for(String s : facTermsCondMap.keySet()){
            Decimal seq = facTermsCondMap.get(s).Seq_No__c;
            if(facilityTC.containsKey(facTermsCondMap.get(s).Facility_Category__c)){
                string tempTC = facilityTC.get(facTermsCondMap.get(s).Facility_Category__c)+'\n'+String.valueOf(seq)+'. '+facTermsCondMap.get(s).Terms_and_Conditions__c;
                facilityTC.put(facTermsCondMap.get(s).Facility_Category__c,tempTC);
            }else{
                facilityTC.put(facTermsCondMap.get(s).Facility_Category__c, String.valueOf(seq)+'. '+facTermsCondMap.get(s).Terms_and_Conditions__c);
            }            
        }
        if(documentName == Constants.PROV_SANCTION_TEMPLATE_SME){
            NEXT_RENEW_DATE     = SMESanction_DocReq.getNextRenewalDate(System.today(),'Interim Extension');
            System.debug('NEXT_RENEW_DATE1--> ' + NEXT_RENEW_DATE);
            if(NEXT_RENEW_DATE != null)NEXT_RENEW_DATE = NEXT_RENEW_DATE - 1;
            next_renewal_Date   = Utility.getBlankStringIfNull(NEXT_RENEW_DATE.format());
            sanction_Type       = Constants.PROV_EXTENTION;
            SME_DOCUMENT_NAME   = Constants.PROV_SANCTION_TEMPLATE_SME;            
            return getProvLetterJSONReq(appln,facilities,parties,templateId);
        }else{
            NEXT_RENEW_DATE     = SMESanction_DocReq.getNextRenewalDate(System.today(),'Final Sanction');
            System.debug('NEXT_RENEW_DATE2--> ' + NEXT_RENEW_DATE);
            if(NEXT_RENEW_DATE != null)NEXT_RENEW_DATE = NEXT_RENEW_DATE - 1;
            next_renewal_Date   = Utility.getBlankStringIfNull(NEXT_RENEW_DATE.format());
            sanction_Type   = Constants.FINAL_REVIEW;
            if(template12_eligible && template13_eligible){
                SME_DOCUMENT_NAME   = Constants.SME_SANCTION_Letter123;
                templateId  = Utility.getDIGIOTemplateId(SME_DOCUMENT_NAME);
                //return getLetterJSONReq(appln,facilities,parties,templateId);
            }else if(template12_eligible && !template13_eligible){
                SME_DOCUMENT_NAME   = Constants.SME_SANCTION_Letter12;
                templateId  = Utility.getDIGIOTemplateId(SME_DOCUMENT_NAME);                
            }else if(!template12_eligible && template13_eligible){
                SME_DOCUMENT_NAME   = Constants.SME_SANCTION_Letter13;
                templateId  = Utility.getDIGIOTemplateId(SME_DOCUMENT_NAME);
            }else{
                SME_DOCUMENT_NAME   = Constants.SME_SANCTION_Letter1;
                templateId  = Utility.getDIGIOTemplateId(SME_DOCUMENT_NAME);                
            }
            system.debug('templateId::'+templateId);
            return getLetterJSONReq(appln,facilities,parties,templateId);
        }
        //return null;
    } 
    
    public static SMESanction_DocReq getLetterJSONReq(genesis__Applications__c appln, List<Facility__c> facilities,List<genesis__Application_Parties__c> parties, string templateId){
        System.debug('facilities*****'+facilities);
        System.debug('securtiyDetails*****'+securtiyDetails);
        
        String margin = '';
        List<Security_Text__mdt> securityText = new List<Security_Text__mdt>();
        securityText = [SELECT Application_Id__c,COLLATERAL_SECURITY__c,PRIMARY_SECURITY__c FROM Security_Text__mdt LIMIT 1];
        SMESanction_DocReq req = new SMESanction_DocReq();
        req.inputVariables  = new SMESanction_DocReq.cls_inputVariables();
        req.owner_tenantId  = 'cuecent_tenant';
        req.exe_tenantId    = 'cuecent_tenant';
        //req.serviceName       = 'TestJsonStr';
        req.inputVariables.unique_key       = templateId;
        req.inputVariables.pdf_unique_key   = appln.Id;
        req.inputVariables.in_msg       = '';
        req.inputVariables.inputmap     = new Map<String,String>();
        Map<String,String> reqMap       = new Map<String,String>();
        reqMap.put('Borrower_Name', appln.genesis__Account__r.Name);
        reqMap.put('Borrower_Address1', Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingStreet));
        reqMap.put('Borrower_Address2', Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingCity));
        reqMap.put('Borrower_Address3', Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingState));
        reqMap.put('Borrower_Address4', Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingPostalCode));
        reqMap.put('Branch_Name', Utility.getBlankStringIfNull(appln.genesis__Account__r.Branch_Name__c));
        reqMap.put('Branch_Code', Utility.getBlankStringIfNull(appln.genesis__Account__r.Branch_Code__c));
        reqMap.put('San_Ref_No', Utility.getBlankStringIfNull(appln.Name));
        reqMap.put('San_Ref_Date', Utility.getBlankStringIfNull((System.now()).format('dd-MM-yyyy')));
        reqMap.put('Loan_Sanction_Type', sanction_Type);
        reqMap.put('Appl_Ref_Date', Utility.getBlankStringIfNull((System.now()).format('dd-MM-yyyy')));
        
        Map<Integer,string> facilityMap = new Map<Integer,string>();
        Map<Integer,string> pmSecMap = new Map<Integer,string>();
        Map<Integer,string> colSecMap = new Map<Integer,string>();
        Map<Integer,string> apprvLimit = new Map<Integer,string>();
        Map<Integer,string> apprvMargin = new Map<Integer,string>();
        Map<Integer,string> interestType = new Map<Integer,string>();
        Map<Integer,string> mclrRateMap = new Map<Integer,string>();
        Map<Integer,string> ratCommsnMap = new Map<Integer,string>();
        Map<Integer,string> loanPurposeMap = new Map<Integer,string>();
        
        for(integer i=1;i<16;i++){
            facilityMap.put(i, 'Facility_Type'+i);
            reqMap.put('Facility_Type'+i, '');
            
            apprvLimit.put(i, 'Approved_Limit'+i);
            reqMap.put('Approved_Limit'+i, '');
            
            apprvMargin.put(i, 'Approved_Margin'+i);
            reqMap.put('Approved_Margin'+i, '');
            
            interestType.put(i, 'Interest_Type'+i);
            reqMap.put('Interest_Type'+i, '');
            
            mclrRateMap.put(i, 'MCLR_Rate'+i);
            reqMap.put('MCLR_Rate'+i, '');
            
            ratCommsnMap.put(i, 'Rate_Commission'+i);
            reqMap.put('Rate_Commission'+i, '');
            
            pmSecMap.put(i, 'Primary_Security'+i);
            reqMap.put('Primary_Security'+i, '');
            
            colSecMap.put(i, 'Collateral_Security'+i);
            reqMap.put('Collateral_Security'+i, '');
            
            loanPurposeMap.put(i, 'Loan_Purpose'+i);
            reqMap.put('Loan_Purpose'+i, '');
        }
        
        Integer days            = 0;
        Integer provExtDays     = 0;
        Integer daysToRemove    = 0;
        System.debug('%%%%%%%%%%%%%%%%%%%');
        System.debug(NEXT_RENEW_DATE);
        try{
            days            = (appln.Renewal_Due_Date__c).daysBetween(NEXT_RENEW_DATE);
            if(appln.Sanction_Date__c != null && appln.Next_Renewal_Date__c != null){
                provExtDays     = ((appln.Sanction_Date__c).daysBetween(appln.Next_Renewal_Date__c));
                daysToRemove    = (System.today()).daysBetween(appln.Next_Renewal_Date__c);
            }else{
                daysToRemove    = (System.today()).daysBetween(appln.Renewal_Due_Date__c) -1;
            }              
            
        }catch(Exception exp){}
        System.debug(days);
        System.debug(provExtDays);
        System.debug(daysToRemove);
        List<MCLR_Master__c> mclrs  = new List<MCLR_Master__c>();        
        mclrs                       = SMESanction_DocReq.getMCLRValues();
        
        for(integer i=0; i<facilities.size(); i++){
            string primarySecurity      = '';
            string ColleteralSecurity   = '';
            Decimal variance            = 0;
            try{
                for(MCLR_Master__c m : mclrs){
                    if((m.COD_Term_From__c != null && m.COD_Term_To__c !=null)
                       && days >= m.COD_Term_From__c && days <= m.COD_Term_To__c){
                           if(facilities[i].Type__c == 'Non-Funded'){
                               variance = (facilities[i].Recommended_Rate__c);
                           }else{
                               variance = (facilities[i].Recommended_Rate__c) - (m.MCLR_Of_Interest__c);
                           }
                           variance = variance.setScale(2);
                       }
                }
            }catch(Exception evar){}
            Integer primaryCount = 1;
            Integer SecoundryCount = 1;
            for(genesis__Application_Collateral__c coll :facilities[i].Facility_Security__r){
                if(coll.genesis__Collateral__c !=null && coll.Security_Type__c !=null
                   && securtiyDetails != null && securtiyDetails.containsKey(coll.genesis__Collateral__c)){
                       if(coll.Security_Type__c == Constants.PRIMARY_SECURITIES){
                           if(coll.genesis__Collateral__r.recordType.DeveloperName == Constants.COLLATERAL_RECTYPE_OTHER){
                               if(coll.genesis__Collateral__r.Collateral_Type__c == 'CGTMSE'){
                                   primarySecurity += SecoundryCount+'. '+'Covered under CGTMSE scheme '+'\n';
                                   primaryCount++;
                               }else{
                                   primarySecurity += primaryCount+'. '+getOtherCollateralTypeDetails(coll)+'\n';
                                   primaryCount++;
                               }
                           }else{
                               primarySecurity += primaryCount+'. '+securtiyDetails.get(coll.genesis__Collateral__c)+'\n';
                               primaryCount++;
                           }
                           
                       }
                       if(coll.Security_Type__c == Constants.COLLATERAL_SECURITIES){
                           if(coll.genesis__Collateral__r.recordType.DeveloperName == Constants.COLLATERAL_RECTYPE_OTHER ){
                               if(coll.genesis__Collateral__r.Collateral_Type__c == 'CGTMSE'){
                                   ColleteralSecurity += SecoundryCount+'. '+'Covered under CGTMSE scheme '+'\n';
                                   SecoundryCount++;
                               }else{
                                   ColleteralSecurity += SecoundryCount+'. '+getOtherCollateralTypeDetails(coll)+'\n';
                                   SecoundryCount++;
                               }  
                           }else{
                               ColleteralSecurity += SecoundryCount+'. '+securtiyDetails.get(coll.genesis__Collateral__c)+'\n';
                               SecoundryCount++;
                           }
                       }                    
                   }
            }
            if(primarySecurity == '' || primarySecurity == null){
                primarySecurity     = Utility.getBlankStringIfNull(appln.Security_Description__c);
                if(primarySecurity !=null)primarySecurity     = primarySecurity.removeEnd(',');
            }
            if(ColleteralSecurity== '' || ColleteralSecurity == null){
                ColleteralSecurity     =  Utility.getBlankStringIfNull(appln.Security_Description__c);
                if(ColleteralSecurity !=null)ColleteralSecurity     = ColleteralSecurity.removeEnd(',');
            }
            if(!securityText.isEmpty() && securityText[0].Application_Id__c != null){
                if(securityText[0].Application_Id__c == appln.Id){
                    System.debug(securityText[0]);
                    if(securityText[0].PRIMARY_SECURITY__c != null){
                        System.debug(securityText[0].PRIMARY_SECURITY__c);
                        primarySecurity     = securityText[0].PRIMARY_SECURITY__c;
                    }   
                    if(securityText[0].COLLATERAL_SECURITY__c != null){
                        System.debug(securityText[0].COLLATERAL_SECURITY__c);
                        ColleteralSecurity  = securityText[0].COLLATERAL_SECURITY__c;
                    }   
                }
            }
            if(facilityMap.containsKey(i+1)){
                reqMap.put(facilityMap.get(i+1),Utility.getBlankStringIfNull(facilities[i].CL_Product__r.clcommon__Product_Name__c));
            }
            if(apprvLimit.containsKey(i+1)){
                reqMap.put(apprvLimit.get(i+1),Utility.getBlankStringIfNull(String.ValueOf(facilities[i].Recommended_Limit__c)));
            }
            
            /* Approve Margin Calculation Starts Here */
            /*if(apprvMargin.containsKey(i+1)){
reqMap.put(apprvMargin.get(i+1),Utility.getBlankStringIfNull(String.ValueOf(facilities[i].Approved_Margin__c)));
}*/
            if(facilities[i].CL_Product__r.Facility_Category__c == 'OCC'){
                if(facilities[i].Industry__c == 'Manufacturing'){
                    margin = 'Receivables : '+ facilities[i].Margin_Receivables__c + '; ' +'Stock Manufacturing : '+ facilities[i].Margin_Stock_Manufacturing__c;
                    reqMap.put(apprvMargin.get(i+1),Utility.getBlankStringIfNull(margin)+'%');                        
                }
                else if(facilities[i].Industry__c == 'TRADING'){
                    margin = 'Receivables : '+ facilities[i].Margin_Receivables__c + '; ' +'Stock Trading : '+ facilities[i].Margin_Stock_Trading__c;
                    reqMap.put(apprvMargin.get(i+1),Utility.getBlankStringIfNull(margin)+'%');
                }
            }
            else{
                margin += facilities[i].Margin__c;
                reqMap.put(apprvMargin.get(i+1),Utility.getBlankStringIfNull(margin)+'%');
            }
            /* Approve Margin Calculation Ends Here */
            
            if(interestType.containsKey(i+1)){
                reqMap.put(interestType.get(i+1),Utility.getBlankStringIfNull(String.ValueOf(facilities[i].Interest_Type__c)));
            }
            if(mclrRateMap.containsKey(i+1)){
                reqMap.put(mclrRateMap.get(i+1),Utility.getBlankStringIfNull(String.ValueOf(facilities[i].MCLR_Rate__c)));
            }
            if(ratCommsnMap.containsKey(i+1)){
                string rateComm = Utility.getBlankStringIfNull(String.ValueOf(facilities[i].Recommended_Rate__c));
                
                if(facilities[i].Type__c == 'Funded'){
                    String rateString   = (SMESanction_DocReq.getFundedRateStr).replace('{{Approved_Interest_Rate}}',rateComm);
                    rateString          = rateString.replace('{{BRE_Spread_Rate}}',Utility.getBlankStringIfNull(String.ValueOf(facilities[i].Final_Spread__c)));                    
                    reqMap.put(ratCommsnMap.get(i+1),rateString);
                }else if(facilities[i].Type__c == 'Non-Funded'){
                    reqMap.put(ratCommsnMap.get(i+1),(SMESanction_DocReq.getNonFundedRateStr).replace('{{Approved_Interest_Rate}}',rateComm));
                }                
            }
            if(pmSecMap.containsKey(i+1) && primarySecurity != ''){
                reqMap.put(pmSecMap.get(i+1),' - '+primarySecurity);               
            }
            if(colSecMap.containsKey(i+1) && ColleteralSecurity != ''){
                reqMap.put(colSecMap.get(i+1),' - '+ColleteralSecurity);
            } 
            if(loanPurposeMap.containsKey(i+1)){
                reqMap.put(loanPurposeMap.get(i+1),Utility.getBlankStringIfNull(facilities[i].Loan_Purpose__c));
            }            
            if(facilities[i].CL_Product__r.Facility_Category__c == 'SOD'){
                reqMap.put('SOD_TNC','WORKING CAPITAL LIMIT T&C - SOD'+'\n'+facilityTC.get(facilities[i].CL_Product__r.Facility_Category__c));
            }else{
                reqMap.put('SOD_TNC','');
            }
            if(facilities[i].CL_Product__r.Facility_Category__c == 'OCC' || facilities[i].CL_Product__r.Facility_Category__c == 'CCBD'){
                String temp = facilityTC.get(facilities[i].CL_Product__r.Facility_Category__c).replace('((Penal_Interest_Rate))',PENAL_RATE);  
                reqMap.put('OCC_CCBD_TNC','WORKING CAPITAL LIMIT T&C - OCC /CCBD'+'\n'+temp);
            }else{
                reqMap.put('OCC_CCBD_TNC','');
            }
            
            if(facilities[i].CL_Product__r.Facility_Category__c == 'CCBD'){
                String temp = facilityTC.get(facilities[i].CL_Product__r.Facility_Category__c).replace('((Penal_Interest_Rate))',PENAL_RATE);  
                reqMap.put('CCBD_TNC','WORKING CAPITAL LIMIT T&C - CCBD'+'\n'+temp);
            }else{
                reqMap.put('CCBD_TNC','');
            }
            
            if(facilities[i].CL_Product__r.Facility_Category__c == 'PCL' || facilities[i].CL_Product__r.Facility_Category__c == 'PCFC'){
                String temp = facilityTC.get('PCL/PCFC').replace('((Penal_Interest_Rate))',PENAL_RATE);  
                reqMap.put('PLC_PCFC_TNC','WORKING CAPITAL LIMIT T&C - PCL/ PCFC'+'\n'+temp);
            }else{
                reqMap.put('PLC_PCFC_TNC','');
            }
            if(facilities[i].CL_Product__r.Facility_Category__c == 'FBP' || facilities[i].CL_Product__r.Facility_Category__c == 'EBD'){
                reqMap.put('FBDP_EBDP_TNC','WORKING CAPITAL LIMIT T&C - FBD/P, EBD/P'+'\n'+facilityTC.get('FBP/EBD'));
            }else{
                reqMap.put('FBDP_EBDP_TNC','');
            }
            if(facilities[i].CL_Product__r.Facility_Category__c == 'CEL'){
                reqMap.put('CEL_TNC','FOREX FACILITY T&C - Credit Equivalent Limit (CEL)'+'\n'+facilityTC.get(facilities[i].CL_Product__r.Facility_Category__c));
            }else{
                reqMap.put('CEL_TNC','');
            }
        }
        
        
        if(appln.genesis__Account__r.Constitution__c == 'COMPANIES' 
           || appln.genesis__Account__r.Constitution__c == 'LLP'){
               reqMap.put('CO_LLP_TNC','WORKING CAPITAL LIMIT T&C - COMPANIES/LLP'+'\n'+SMESanction_DocReq.companiesllpTnC);
           }else{
               reqMap.put('CO_LLP_TNC','');
           }
        reqMap.put('CONS_MBA_TNC','');
        reqMap.put('Int_Rate_Validity', Constants.LETTER_VALID_DATE);
        reqMap.put('Loan_Validity_Period', next_renewal_Date);
        reqMap.put('Appl_Guarantors', '');
        FINAL_PROCESSING_CHARGE = appln.Processing_Charges__c;
        if(FINAL_PROCESSING_CHARGE > 0){
            reqMap.put('Process_Charges', 'Rs '+String.valueOf(FINAL_PROCESSING_CHARGE)+'+ Applicable GST');            
        }else{
            reqMap.put('Process_Charges', '');
        }
        //reqMap.put('Process_Charges', SYSTEM.LABEL.Temp_Processing_Charge);
        reqMap.put('Upfront_Fee', Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Total_Upfront_Payments__c)));
        reqMap.put('PreClosure_PrePayment_Charges', preclosureRate+'%');
        reqMap.put('Penal_Interest_Rate1', PENAL_RATE);
        reqMap.put('Commitment_Charges', commitmentCharges+'%');
        reqMap.put('Interest_Rate_Reset', ''); // Need to create this field;
        reqMap.put('PreClosure_Interest_Rate', preclosureRate); // Need to create this field;
        reqMap.put('Penal_Interest_Rate2', PENAL_RATE);
        reqMap.put('Penal_Interest_Rate3', PENAL_RATE);
        
        List<Audit__c> splTnC   = new List<Audit__c>();
        string spForextag   = '';
        try{
            splTnC  = [Select id,Tag_Name__c,Terms_and_Conditions__c from Audit__c where RecordType.DeveloperName ='Underwriting_T_C' AND Application__c =:appln.Id];            
        }catch(QueryException e){}
        
        Integer count =1;
        string tnc  = '';
        for(Audit__c a : splTnC){
            tnc += count+'. '+a.Terms_and_Conditions__c+'\n'; 
            count++;
        }
        if(tnc != ''){
            reqMap.put('WC_SPL_SAN_TNC', 'SPECIAL / ADDITONAL T&C OF SANCTION'+'\n'+tnc);
        }else{
            reqMap.put('WC_SPL_SAN_TNC', '');
        }
        reqMap.put('', '');
        try{
            String corpAdv  = SMESanction_DocReq.getcorpAdvTnC();
            reqMap.put('CORP_ADV_TNC', corpAdv);
        }catch(Exception e){
            reqMap.put('CORP_ADV_TNC', '');
        }
        
        try{
            String forexcontent = SMESanction_DocReq.getForexAdvTnC();
            reqMap.put('FORX_ADV_TNC', forexcontent);
        }catch(Exception e){
            reqMap.put('FORX_ADV_TNC', '');
        }
        
        Map<Integer,String> partyTypeMap = new Map<Integer,String>();
        Map<Integer,String> signatoryMap = new Map<Integer,String>();
        Map<Integer,String> brrwsignMap = new Map<Integer,String>();
        
        for(integer i=1;i<31;i++){
            partyTypeMap.put(i, 'Auth_Signatory_Type'+i);
            signatoryMap.put(i, 'Auth_Signatory'+i);
            brrwsignMap.put(i,'Borrower_Guar_Sign'+i);
            reqMap.put('Auth_Signatory_Type'+i, '');
            reqMap.put('Auth_Signatory'+i, '');
            reqMap.put('Borrower_Guar_Sign'+i, '');
        }
        integer partyCount =1;
        string gaurantorName    = '';
        for(genesis__Application_Parties__c p : parties){
            if(signatoryMap.containsKey(partyCount) && p.genesis__Party_Account_Name__c != null){
                reqMap.put(partyTypeMap.get(partyCount),Utility.getBlankStringIfNull(p.genesis__Party_Type__c));
                reqMap.put(signatoryMap.get(partyCount),Utility.getBlankStringIfNull(p.genesis__Party_Account_Name__r.Name));
                gaurantorName += Utility.getBlankStringIfNull(p.genesis__Party_Account_Name__r.Name)+',';
            }
            partyCount++;
        }
        gaurantorName = gaurantorName.removeEnd(',');
        reqMap.put('Appl_Guarantors', gaurantorName);
        reqMap.put('Auth_Signatory_Bnk', 'KVB Bank');
        reqMap.put('Date_Time_Adm', '');
        reqMap.put('Date_Time_Ver', '');
        reqMap.put('Bnk_Auth_Sign', '');
        reqMap.put('Date_Time_Adm1', '');
        reqMap.put('Date_Time_Ver1', '');
        req.inputVariables.inputmap = reqMap;
        system.debug('req::'+req);
        return req;
    } 
    
    //Provisional letter generation request
    public static SMESanction_DocReq getProvLetterJSONReq(genesis__Applications__c appln, List<Facility__c> facilities,List<genesis__Application_Parties__c> parties, string templateId){
        List<Security_Text__mdt> securityText = new List<Security_Text__mdt>();
        securityText = [SELECT Application_Id__c,COLLATERAL_SECURITY__c,PRIMARY_SECURITY__c FROM Security_Text__mdt LIMIT 1];
        SMESanction_DocReq req = new SMESanction_DocReq();
        req.inputVariables  = new SMESanction_DocReq.cls_inputVariables();
        req.owner_tenantId  = 'cuecent_tenant';
        req.exe_tenantId    = 'cuecent_tenant';
        req.inputVariables.unique_key       = templateId;
        req.inputVariables.pdf_unique_key   = appln.Id;
        req.inputVariables.in_msg       = '';
        req.inputVariables.inputmap     = new Map<String,String>();
        Map<String,String> reqMap       = new Map<String,String>();
        
        reqMap.put('Borrower_Name', appln.genesis__Account__r.Name);
        reqMap.put('Borrower_Address1', Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingStreet));
        reqMap.put('Borrower_Address2', Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingCity));
        reqMap.put('Borrower_Address3', Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingState));
        reqMap.put('Borrower_Address4', Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingPostalCode));
        reqMap.put('Branch_Name', Utility.getBlankStringIfNull(appln.genesis__Account__r.Branch_Name__c));
        reqMap.put('Branch_Code', Utility.getBlankStringIfNull(appln.genesis__Account__r.Branch_Code__c));
        reqMap.put('San_Ref_No', Utility.getBlankStringIfNull(appln.Name));
        reqMap.put('San_Ref_Date', Utility.getBlankStringIfNull((System.now()).format('dd-MM-yyyy')));
        reqMap.put('Appl_Ref_Date', Utility.getBlankStringIfNull((System.now()).format('dd-MM-yyyy')));
        reqMap.put('Loan_Validity_Period', next_renewal_Date);
        reqMap.put('Latest_Completed_FY', Utility.getBlankStringIfNull((Date.newInstance(Utility.getCurrentYear(), 03, 31)).format()));        
        reqMap.put('Penal_Interest_Rate1', PENAL_RATE);
        
        Map<Integer,string> facilityMap = new Map<Integer,string>();
        Map<Integer,string> apprvLimit = new Map<Integer,string>();
        Map<Integer,string> ratCommsnMap = new Map<Integer,string>();
        
        for(integer i=1;i<13;i++){
            facilityMap.put(i, 'Facility_Type'+i);
            reqMap.put('Facility_Type'+i, '');
            
            apprvLimit.put(i, 'Approved_Limit'+i);
            reqMap.put('Approved_Limit'+i, '');
            
            ratCommsnMap.put(i, 'Rate_Commission'+i);
            reqMap.put('Rate_Commission'+i, '');
        }
        
        Integer days            = 0;
        Integer daysToRemove    = 0;
        try{
            days            = (appln.Renewal_Due_Date__c).daysBetween(NEXT_RENEW_DATE);
            daysToRemove    = (System.today()).daysBetween(appln.Renewal_Due_Date__c) - 1;            
        }catch(Exception exp){
            system.debug('days::'+exp.getMessage());
        }
        
        List<MCLR_Master__c> mclrs  = new List<MCLR_Master__c>();        
        mclrs                       = SMESanction_DocReq.getMCLRValues();
        
        for(integer i=0; i<facilities.size(); i++){
            string primarySecurity      ='';
            string ColleteralSecurity   ='';
            Decimal variance            = 0;
            try{
                for(MCLR_Master__c m : mclrs){
                    if((m.COD_Term_From__c != null && m.COD_Term_To__c != null ) 
                       && days >= m.COD_Term_From__c && days <= m.COD_Term_To__c){
                           if(facilities[i].Type__c == 'Non-Funded'){
                               variance = (facilities[i].Recommended_Rate__c);
                           }else{
                               variance = (facilities[i].Recommended_Rate__c) - (m.MCLR_Of_Interest__c);
                           }
                           variance = variance.setScale(2);
                       }
                }
            }catch(Exception eVar){}
            Integer primaryCount = 1;
            Integer SecoundryCount = 1;
            for(genesis__Application_Collateral__c coll :facilities[i].Facility_Security__r){
                if(coll.genesis__Collateral__c !=null && coll.Security_Type__c !=null
                   && securtiyDetails != null && securtiyDetails.containsKey(coll.genesis__Collateral__c)){
                       if(coll.Security_Type__c == Constants.PRIMARY_SECURITIES){
                           if(coll.genesis__Collateral__r.recordType.DeveloperName == Constants.COLLATERAL_RECTYPE_OTHER){
                               if(coll.genesis__Collateral__r.Collateral_Type__c == 'CGTMSE'){
                                   primarySecurity += SecoundryCount+'. '+'Covered under CGTMSE scheme '+'\n';
                                   primaryCount++;
                               }else{
                                   primarySecurity += primaryCount+'. '+getOtherCollateralTypeDetails(coll)+'\n';
                                   primaryCount++;
                               }
                           }else{
                               primarySecurity += primaryCount+'. '+securtiyDetails.get(coll.genesis__Collateral__c)+'\n';
                               primaryCount++;
                           }
                           
                       }
                       if(coll.Security_Type__c == Constants.COLLATERAL_SECURITIES){
                           if(coll.genesis__Collateral__r.recordType.DeveloperName == Constants.COLLATERAL_RECTYPE_OTHER){
                               if(coll.genesis__Collateral__r.Collateral_Type__c == 'CGTMSE'){
                                   ColleteralSecurity += SecoundryCount+'. '+'Covered under CGTMSE scheme '+'\n';
                                   SecoundryCount++;
                               }else{
                                   ColleteralSecurity += SecoundryCount+'. '+getOtherCollateralTypeDetails(coll)+'\n';
                                   SecoundryCount++;
                               }
                           }else{
                               ColleteralSecurity += SecoundryCount+'. '+securtiyDetails.get(coll.genesis__Collateral__c)+'\n';
                               SecoundryCount++;
                           }
                           
                       }
                   }
            }
            if(primarySecurity == '' || primarySecurity == null){
                primarySecurity     = Utility.getBlankStringIfNull(appln.Security_Description__c);
                if(primarySecurity !=null) primarySecurity     = primarySecurity.removeEnd(',');                
            }
            if(ColleteralSecurity== '' || ColleteralSecurity == null){
                ColleteralSecurity     =  Utility.getBlankStringIfNull(appln.Security_Description__c);
                if(ColleteralSecurity !=null) ColleteralSecurity     = ColleteralSecurity.removeEnd(',');
            }
            if(!securityText.isEmpty() && securityText[0].Application_Id__c != null){
                if(securityText[0].Application_Id__c == appln.Id){
                    if(securityText[0].PRIMARY_SECURITY__c != null){
                        primarySecurity     = securityText[0].PRIMARY_SECURITY__c;
                    }   
                    if(securityText[0].COLLATERAL_SECURITY__c != null){
                        ColleteralSecurity  = securityText[0].COLLATERAL_SECURITY__c;
                    }   
                }
            }
            if(facilityMap.containsKey(i+1)){
                reqMap.put(facilityMap.get(i+1),Utility.getBlankStringIfNull(facilities[i].CL_Product__r.clcommon__Product_Name__c));
            }
            if(apprvLimit.containsKey(i+1)){
                reqMap.put(apprvLimit.get(i+1),Utility.getBlankStringIfNull(String.ValueOf(facilities[i].Recommended_Limit__c)));
            }
            if(ratCommsnMap.containsKey(i+1)){
                string rateComm = Utility.getBlankStringIfNull(String.ValueOf(facilities[i].Recommended_Rate__c));
                
                if(facilities[i].Type__c == 'Funded'){
                    String rateString   = (SMESanction_DocReq.getFundedRateStr).replace('{{Approved_Interest_Rate}}',rateComm);
                    rateString          = rateString.replace('{{BRE_Spread_Rate}}',Utility.getBlankStringIfNull(String.ValueOf(facilities[i].Final_Spread__c)));                    
                    reqMap.put(ratCommsnMap.get(i+1),rateString);
                }else if(facilities[i].Type__c == 'Non-Funded'){
                    reqMap.put(ratCommsnMap.get(i+1),(SMESanction_DocReq.getNonFundedRateStr).replace('{{Approved_Interest_Rate}}',rateComm));
                }                
            }         
            
        } 
        FINAL_PROCESSING_CHARGE = appln.Processing_Charges__c;
        if(FINAL_PROCESSING_CHARGE > 0){
            reqMap.put('Process_Charges', String.valueOf(FINAL_PROCESSING_CHARGE));
        }else{
            reqMap.put('Process_Charges', '');
        }
        List<Audit__c> splTnC   = new List<Audit__c>();
        string spForextag   = '';
        try{
            splTnC  = [Select id,Tag_Name__c,Terms_and_Conditions__c from Audit__c where RecordType.DeveloperName ='Underwriting_T_C' AND Application__c =:appln.Id];            
        }catch(QueryException e){}
        
        Integer count =1;
        string tnc  = '';
        for(Audit__c a : splTnC){
            tnc += count+'. '+a.Terms_and_Conditions__c+'\n'; 
            count++;
        }
        if(tnc != ''){
            reqMap.put('Spl_Sanction_Terms', 'SPECIAL / ADDITONAL T&C OF SANCTION'+'\n\n'+tnc);
        }else{
            reqMap.put('Spl_Sanction_Terms', '');
        }
        reqMap.put('', '');
        
        Map<Integer,String> partyTypeMap = new Map<Integer,String>();
        Map<Integer,String> signatoryMap = new Map<Integer,String>();
        Map<Integer,String> brrwsignMap = new Map<Integer,String>();
        
        for(integer i=1;i<31;i++){
            partyTypeMap.put(i, 'Auth_Signatory_Type'+i);
            signatoryMap.put(i, 'Auth_Signatory'+i);
            brrwsignMap.put(i,'Borrower_Guar_Sign'+i);
            reqMap.put('Auth_Signatory_Type'+i, '');
            reqMap.put('Auth_Signatory'+i, '');
            reqMap.put('Borrower_Guar_Sign'+i, '');
        }
        integer partyCount =1;
        for(genesis__Application_Parties__c p : parties){
            if(signatoryMap.containsKey(partyCount) && p.genesis__Party_Account_Name__c != null){
                reqMap.put(partyTypeMap.get(partyCount),Utility.getBlankStringIfNull(p.genesis__Party_Type__c));
                reqMap.put(signatoryMap.get(partyCount),Utility.getBlankStringIfNull(p.genesis__Party_Account_Name__r.Name));
            }
            partyCount++;
        }
        reqMap.put('Auth_Signatory_Bnk', 'KVB Bank');
        reqMap.put('Bnk_Auth_Sign', '');
        req.inputVariables.inputmap = reqMap;
        
        return req;
    } 
    
    public static string getOtherCollateralTypeDetails(genesis__Application_Collateral__c applColl){
        
        String securityDetails = '';
        if(applColl.genesis__Collateral__r.MORT_TYPE__c != null)securityDetails += ' '+applColl.genesis__Collateral__r.MORT_TYPE__c;
        if(applColl.genesis__Collateral__r.Collateral_Type__c == Constants.COLLATERAL_TYPE_FIXED_DEPOSIT || applColl.genesis__Collateral__r.Collateral_Type__c == Constants.COLLATERAL_TYPE_NSC_KVP ){
            if(applColl.genesis__Collateral__r.Collateral_Type__c != null)securityDetails += ' on ' + applColl.genesis__Collateral__r.Collateral_Type__c;
            if(applColl.genesis__Collateral__r.clcommon__Policy_Number__c != null)securityDetails += ' account number '+applColl.genesis__Collateral__r.clcommon__Policy_Number__c;
            if(ownerNameMap.get(applColl.genesis__Collateral__r.Id) != null)securityDetails += ' standing in the name of '+ownerNameMap.get(applColl.genesis__Collateral__r.id);
            if(applColl.genesis__Collateral__r.clcommon__Value__c != null)securityDetails += ' valued at  Rs. '+applColl.genesis__Collateral__r.clcommon__Value__c;
            if(applColl.genesis__Collateral__r.Maturity_Date__c != null)securityDetails += ' with maturity date as '+applColl.genesis__Collateral__r.Maturity_Date__c.format();
        }
        if(applColl.genesis__Collateral__r.Collateral_Type__c == Constants.COLLATERAL_TYPE_INSURANCE_POLICIES){
            if(applColl.genesis__Collateral__r.clcommon__Insurance_Company_Name__c != null)securityDetails += ' of ' + applColl.genesis__Collateral__r.clcommon__Insurance_Company_Name__c;
            if(applColl.genesis__Collateral__r.clcommon__Policy_Number__c != null)securityDetails += ' policy bearing number '+applColl.genesis__Collateral__r.clcommon__Policy_Number__c;
            if(ownerNameMap.get(applColl.genesis__Collateral__r.Id)!= null)securityDetails += ' standing in the name of '+ownerNameMap.get(applColl.genesis__Collateral__r.Id);
            if(applColl.genesis__Collateral__r.Surrender_Value__c != null)securityDetails += ' having surrender value of Rs. '+applColl.genesis__Collateral__r.Surrender_Value__c;
            if(applColl.genesis__Collateral__r.Maturity_Date__c != null)securityDetails += ' with maturity date as '+applColl.genesis__Collateral__r.Maturity_Date__c.format();
        }
        if(applColl.genesis__Collateral__r.Collateral_Type__c == Constants.COLLATERAL_TYPE_VEHICLES){
            if(applColl.genesis__Collateral__r.Collateral_Type__c != null)securityDetails += ' of ' + applColl.genesis__Collateral__r.Collateral_Type__c;
            if(applColl.genesis__Collateral__r.Vehicle_Number__c != null)securityDetails += ' with Vehicle No. '+applColl.genesis__Collateral__r.Vehicle_Number__c; 
            if(applColl.genesis__Collateral__r.clcommon__Value__c != null)securityDetails += ' valued at Rs. '+applColl.genesis__Collateral__r.clcommon__Value__c;
        }
        if(applColl.genesis__Collateral__r.Collateral_Type__c == Constants.COLLATERAL_TYPE_MACHINERY){
            if(applColl.genesis__Collateral__r.Collateral_Type__c != null)securityDetails += ' of ' + applColl.genesis__Collateral__r.Collateral_Type__c;
            if(applColl.genesis__Collateral__r.Machinery_Model__c != null)securityDetails += ' with Model No. '+applColl.genesis__Collateral__r.Machinery_Model__c;
            if(applColl.genesis__Collateral__r.clcommon__Value__c != null )securityDetails += ' valued at Rs. '+applColl.genesis__Collateral__r.clcommon__Value__c;
        }
        return securityDetails;
    }
    
    /*  D (B1) Combined_Afidivate for MOD_2712_V15  */
    public static SMESanction_DocReq generateMODAfidivateDoc(genesis__Applications__c appln, List<Facility__c> facList, String templateId, String collateralId){
        
        SMESanction_DocReq req  = new SMESanction_DocReq();
        req.inputVariables      = new SMESanction_DocReq.cls_inputVariables();
        req.owner_tenantId      = 'cuecent_tenant';
        req.exe_tenantId        = 'cuecent_tenant';
        //Newly Tag added for DMS
        req.applicationType     = appln.RecordType.DeveloperName;
        req.applicationId       = appln.Id;
        req.customerId          = '';
        req.documentType        = templateId;
        req.accountNumbers      = '';
        req.fileName            = '';
        req.uuid                = '';
        
        req.inputVariables.unique_key           = templateId;
        req.inputVariables.pdf_unique_key       = appln.Id;
        req.inputVariables.in_msg               = '';
        req.inputVariables.inputMapForB1        = new Map<String,Object>();

        //Final Map for sending the tags along with its values to Digio
        Map<String,Object> reqMap                   = new Map<String,Object>();

        List<Map<String,String>> tbDataList = new List<Map<String,String>>();
        String allTitleHolder                       = '';
                
        reqMap.put('MOD_Branch', Utility.getBlankStringIfNull(appln.Branch_Name__c));
        if(appln != null && (appln.Branch_Code__c)!= null){
            String temp = appln.Branch_Code__c;
            reqMap.put('Branch_City', Utility.getBlankStringIfNull(getBranchCity(temp)));
        }
        else reqMap.put('Branch_City', '');
        
        reqMap.put('Sanction_Ref_Number', appln.Name);
        reqMap.put('Sanction_date', '');
        reqMap.put('Mod_date', '');
        reqMap.put('Loc_Ref_Branch', Utility.getBlankStringIfNull(appln.Branch_Name__c));
        reqMap.put('Doc_Gen_date', Utility.getBlankStringIfNull((system.now()).format('dd-MM-yyyy')));
        reqMap.put('Borrower_Names', +' M/s./Mr./Ms.  '+Utility.getBlankStringIfNull(appln.genesis__Account__r.Name));
        
        System.debug('collateralId--> ' + collateralId);
        
        try{
            colList                                 =  [SELECT Id,Name,Active__c,ExtentCarpet_area_Built_up_area__c,PlotDoorShopBungalow_No__c, 
                                                        clcommon__Postal_Code__c,State__c,District_Name__c,TalukaTehsil__c,VillageTown__c, 
                                                        Street_NameNo__c, Building_Society_Name__c, Stage_Sector_Ward_Block_No__c,Floor_No__c,
                                                        SurveyKhasraKhataPatta_No__c,Nature_of_Property__c,Buildup_Area__c,                                     
                                                        (SELECT Id,Collateral__c,Name,Account__c,Account__r.Name,Account__r.PersonMailingStreet,
                                                         Account__r.PersonMailingCity,Account__r.PersonMailingState,Account__r.PersonMailingPostalCode,
                                                         Account__r.PersonMailingCountry FROM Ownerships__r WHERE Collateral__c =: collateralId),clcommon__Value_Date__c,
                                                        (SELECT Id,Application__c,Collateral__c,DOcNo__c,Date_Of_DOc__c,Nature_of_Doc__c,Parties_to_Document_From__c,
                                                         Parties_to_Document_To__c FROM MOD_Documents__r WHERE Application__c =: appln.Id  AND Collateral__c =: collateralId
                                                         AND Document_Upload_Type__c ='Copy')
                                                        FROM clcommon__Collateral__c WHERE Id =: collateralId AND Active__c = TRUE];
            //AND RecordType.DeveloperName = 'Land_And_Building'];
        }catch(Exception evar){}
        
        system.debug('colList-- > ' + colList);
        
        Map<Integer,String> propMap             = new Map<Integer,String>();
        Map<Integer,String> surveyNOMap         = new Map<Integer,String>();
        Map<Integer,String> plot_DoorMap        = new Map<Integer,String>();
        Map<Integer,String> extent_UDSMap       = new Map<Integer,String>();
        Map<Integer,String> builtAreaMap        = new Map<Integer,String>();
        Map<Integer,String> floorNoMap          = new Map<Integer,String>();
        Map<Integer,String> stage_WardMap       = new Map<Integer,String>();
        Map<Integer,String> build_SocMap        = new Map<Integer,String>();
        Map<Integer,String> streetMap           = new Map<Integer,String>();
        Map<Integer,String> vill_TownMap        = new Map<Integer,String>();
        Map<Integer,String> talukaMap           = new Map<Integer,String>();
        Map<Integer,String> districtMap         = new Map<Integer,String>();
        Map<Integer,String> stateMap            = new Map<Integer,String>();
        Map<Integer,String> pincodeMap          = new Map<Integer,String>();
        
        for(Integer i=1;i<6;i++){
            
            propMap.put(i, 'Nature_Property_'+i);
            reqMap.put('Nature_Property_'+i, '');
            
            surveyNOMap.put(i, 'Survey_No_'+i);
            reqMap.put('Survey_No_'+i, '');
            
            plot_DoorMap.put(i, 'Plot_Door_Bungalow_No_'+i);
            reqMap.put('Plot_Door_Bungalow_No_'+i, '');
            
            extent_UDSMap.put(i, 'Extent_Site_Uds_'+i);
            reqMap.put('Extent_Site_Uds_'+i, '');
            
            builtAreaMap.put(i, 'Built_up_area_'+i);
            reqMap.put('Built_up_area_'+i, '');
            
            floorNoMap.put(i, 'Floor_No_'+i);
            reqMap.put('Floor_No_'+i, '');
            
            stage_WardMap.put(i, 'Ward_No_'+i);
            reqMap.put('Ward_No_'+i, '');
            
            build_SocMap.put(i, 'Building_Society_Name_No_'+i);
            reqMap.put('Building_Society_Name_No_'+i, '');
            
            streetMap.put(i, 'Street_Name_'+i);
            reqMap.put('Street_Name_'+i, '');
            
            vill_TownMap.put(i, 'Village_Town_'+i);
            reqMap.put('Village_Town_'+i, '');
            
            talukaMap.put(i, 'Taluka_Tehsil_'+i);
            reqMap.put('Taluka_Tehsil_'+i, '');
            
            districtMap.put(i, 'District_Name_'+i);
            reqMap.put('District_Name_'+i, '');
            
            stateMap.put(i, 'State_Name_'+i);
            reqMap.put('State_Name_'+i, '');
            
            pincodeMap.put(i, 'PIN_CODE_'+i);
            reqMap.put('PIN_CODE_'+i, '');
        }
        
        if(! colList.isEmpty()){
            for(Integer i=0; i<colList.size(); i++){
                
                if(propMap.containsKey(i+1)){
                    reqMap.put(propMap.get(i+1),Utility.getBlankStringIfNull(colList[i].Nature_of_Property__c));
                }
                if(surveyNOMap.containsKey(i+1)){
                    reqMap.put(surveyNOMap.get(i+1),Utility.getBlankStringIfNull(colList[i].SurveyKhasraKhataPatta_No__c));
                }
                if(plot_DoorMap.containsKey(i+1)){
                    reqMap.put(plot_DoorMap.get(i+1),Utility.getBlankStringIfNull(colList[i].PlotDoorShopBungalow_No__c));
                }
                if(extent_UDSMap.containsKey(i+1)){
                    reqMap.put(extent_UDSMap.get(i+1),Utility.getBlankStringIfNull(colList[i].ExtentCarpet_area_Built_up_area__c));
                }
                if(builtAreaMap.containsKey(i+1)){
                    reqMap.put(builtAreaMap.get(i+1),Utility.getBlankStringIfNull(String.valueOf(colList[i].Buildup_Area__c)));
                }
                if(floorNoMap.containsKey(i+1)){
                    reqMap.put(floorNoMap.get(i+1),Utility.getBlankStringIfNull(colList[i].Floor_No__c));
                }
                if(stage_WardMap.containsKey(i+1)){
                    reqMap.put(stage_WardMap.get(i+1),Utility.getBlankStringIfNull(colList[i].Stage_Sector_Ward_Block_No__c));
                }
                if(build_SocMap.containsKey(i+1)){
                    reqMap.put(build_SocMap.get(i+1),Utility.getBlankStringIfNull(colList[i].Building_Society_Name__c));
                }
                if(streetMap.containsKey(i+1)){
                    reqMap.put(streetMap.get(i+1),Utility.getBlankStringIfNull(colList[i].Street_NameNo__c));
                }
                if(vill_TownMap.containsKey(i+1)){
                    reqMap.put(vill_TownMap.get(i+1),Utility.getBlankStringIfNull(colList[i].VillageTown__c));
                }
                if(talukaMap.containsKey(i+1)){
                    reqMap.put(talukaMap.get(i+1),Utility.getBlankStringIfNull(colList[i].TalukaTehsil__c));
                }
                if(districtMap.containsKey(i+1)){
                    reqMap.put(districtMap.get(i+1),Utility.getBlankStringIfNull(colList[i].District_Name__c));
                }
                if(stateMap.containsKey(i+1)){
                    reqMap.put(stateMap.get(i+1),Utility.getBlankStringIfNull(colList[i].State__c));
                }
                if(pincodeMap.containsKey(i+1)){
                    reqMap.put(pincodeMap.get(i+1),Utility.getBlankStringIfNull(colList[i].clcommon__Postal_Code__c));
                }
                reqMap.put('Title_deed_deposited_date', Utility.getBlankStringIfNull(formatDate(colList[i].clcommon__Value_Date__c)));
            }
        }   
        
        // SCHEDULE B - Schedule of loan
        Map<Integer,String> facilty_Type_Map   = new Map<Integer,String>();
        Map<Integer,String> final_Limit_Map    = new Map<Integer,String>();
        
        for(Integer i=1; i<6; i++){
            facilty_Type_Map.put(i, 'Facility_Type_'+i);
            reqMap.put('Facility_Type_'+i, '');
            
            final_Limit_Map.put(i, 'Final_Limit'+i);
            reqMap.put('Final_Limit'+i, '');
        }
        
        System.debug('facList--> ' + facList.size());
        if(! facList.isEmpty()){
            for(Integer i=1; i<=facList.size(); i++){
                System.debug('1212' + (facList[i-1].CL_Product__r.clcommon__Product_Name__c));
                System.debug('2121' + (facList[i-1].Recommended_Limit__c));
                if(facilty_Type_Map.containsKey(i)){
                    if((facList[i-1].CL_Product__r.clcommon__Product_Name__c) != NULL){
                        reqMap.put(facilty_Type_Map.get(i),Utility.getBlankStringIfNull(facList[i-1].CL_Product__r.clcommon__Product_Name__c));    
                    }
                    else{
                        reqMap.put(facilty_Type_Map.get(i), '');
                    }
                }
                
                if(final_Limit_Map.containsKey(i)){
                    if((facList[i-1].Recommended_Limit__c) != NULL){
                        reqMap.put(final_Limit_Map.get(i),Utility.getBlankStringIfNull(String.valueOf(facList[i-1].Recommended_Limit__c)));
                    }
                    else{
                        reqMap.put(final_Limit_Map.get(i), '');
                    }
                    
                }
            }    
        }
        
        Map<Integer,string> titleHolderMap      = new Map<Integer,string>();
        Map<Integer,String> addrssMap1          = new Map<Integer,String>();
        Map<Integer,String> addrssMap2          = new Map<Integer,String>();
        Map<Integer,String> addrssMap3          = new Map<Integer,String>();
        
        for(Integer i=1;i<8;i++){
            titleHolderMap.put(i, 'Title_Holder'+i+'_Name1');
            reqMap.put('Title_Holder'+i+'_Name1', '');
            
            addrssMap1.put(i, 'Title_Holder'+i+'_Add_line1');
            reqMap.put('Title_Holder'+i+'_Add_line1', '');
            
            addrssMap2.put(i, 'Title_Holder'+i+'_Add_line2');
            reqMap.put('Title_Holder'+i+'_Add_line2', '');
            
            addrssMap3.put(i, 'Title_Holder'+i+'_Add_line3');
            reqMap.put('Title_Holder'+i+'_Add_line3', '');
        }
        System.debug('1111' + (colList).size());
        if(! colList.isEmpty()){
            for(clcommon__Collateral__c col : colList){
                System.debug('asdf--' + (col.Ownerships__r).size());
                if(! col.Ownerships__r.isEmpty()){
                    for(Integer i=1; i<=(col.Ownerships__r).size(); i++){
                        String mailingAddress = '';
                        
                        System.debug('@@--> '+ (col.Ownerships__r)[i-1].Account__r.Name);
                        System.debug('@@2'+ (col.Ownerships__r)[i-1].Account__r.PersonMailingStreet);
                        
                        if(((col.Ownerships__r)[i-1].Account__r.Name) != NULL){
                            allTitleHolder += (col.Ownerships__r)[i-1].Account__r.Name+','; 
                        }
                        
                        
                        
                        if(((col.Ownerships__r)[i-1].Account__r.PersonMailingState) != NULL && ((col.Ownerships__r)[i-1].Account__r.PersonMailingPostalCode) != NULL && ((col.Ownerships__r)[i-1].Account__r.PersonMailingCountry) != NULL ){
                            mailingAddress = Utility.getBlankStringIfNull((col.Ownerships__r)[i-1].Account__r.PersonMailingState)+','+Utility.getBlankStringIfNull((col.Ownerships__r)[i-1].Account__r.PersonMailingPostalCode)+','+Utility.getBlankStringIfNull((col.Ownerships__r)[i-1].Account__r.PersonMailingCountry);
                            System.debug('mailingAddress' + mailingAddress);
                        }
                        if(titleHolderMap.containsKey(i)){
                            reqMap.put(titleHolderMap.get(i),+'Mr./Ms./M/s. '+Utility.getBlankStringIfNull((col.Ownerships__r)[i-1].Account__r.Name));
                        }
                        if(addrssMap1.containsKey(i)){
                            reqMap.put(addrssMap1.get(i),Utility.getBlankStringIfNull((col.Ownerships__r)[i-1].Account__r.PersonMailingStreet));
                        }
                        if(addrssMap2.containsKey(i)){
                            reqMap.put(addrssMap2.get(i),Utility.getBlankStringIfNull((col.Ownerships__r)[i-1].Account__r.PersonMailingCity));
                        }    
                        
                        if(mailingAddress != NULL){
                            if(addrssMap3.containsKey(i)){
                                reqMap.put(addrssMap3.get(i),Utility.getBlankStringIfNull(mailingAddress));
                            }
                        }
                        else{
                            reqMap.put(addrssMap3.get(i), '');
                        }
                        B1_EAE_accList .add((col.Ownerships__r)[i-1].Account__c);
                    }    
                    
                }
                allTitleHolder = allTitleHolder.removeEnd(',');
                System.debug('££--> ' + allTitleHolder);
                if(allTitleHolder != NULL){
                    reqMap.put('Title_Holder_details',+' Mr./Ms./Mrs. '+ allTitleHolder); 
                }
                else{
                    reqMap.put('Title_Holder_details', '');  
                }
                
                //SCHEDULE –C(List of documents could not be deposited in original).
                System.debug('sadsd--' + (col.MOD_Documents__r).size());
                if(! col.MOD_Documents__r.isEmpty()){
                    Integer slNo    = 1;
                    System.debug('MOD RECORD--> '+ (col.MOD_Documents__r));
                    
                    for(MOD_Documents__c mod : col.MOD_Documents__r){
                        reqMap.put('Sanction_date', Utility.getBlankStringIfNull(formatDate(mod.Date_Of_DOc__c)));
                        reqMap.put('Mod_date', Utility.getBlankStringIfNull(formatDate(mod.Date_Of_DOc__c)));
                        Map<String,String> tbDataMap = new Map<String,String>();
                        tbDataMap.put('sr_no',String.valueOf(slNo));
                        tbDataMap.put('Doc_no',Utility.getBlankStringIfNull(mod.DOcNo__c));
                        tbDataMap.put('Doc_dt',Utility.getBlankStringIfNull(formatDate(mod.Date_Of_DOc__c)));
                        tbDataMap.put('doc_nature',Utility.getBlankStringIfNull(mod.Nature_of_Doc__c));
                        tbDataMap.put('transferor',Utility.getBlankStringIfNull(mod.Parties_to_Document_From__c));
                        tbDataMap.put('transferee',Utility.getBlankStringIfNull(mod.Parties_to_Document_To__c));
                        tbDataList.add(tbDataMap);
                        slNo++;
                        System.debug('tbDataMap:::' + tbDataMap);
                    }
                }
            }   
        }
        
        Map<Integer,String> eSignMap = new  Map<Integer,String>();
        for(Integer i=1; i<=7; i++){
            eSignMap.put(i,'e-Sign'+i);
            reqMap.put(eSignMap.get(i), '');
        }
        reqMap.put('TableData',tbDataList);

        req.inputVariables.inputMapForB1 = reqMap;
        return req;
        
    }
    
    /*  DIGITAL-GCFA v2  Loan Agreement */
    public static SMESanction_DocReq generate_DIGITAL_GCFA_v2(genesis__Applications__c appln, String templateId){
        
        /*EstampHelper_EAE Estamp     = new EstampHelper_EAE();
        Estamp.ReferenceID          = CreateUniqueId.uniqID();
        Estamp.TemplateID           = templateId;
        Estamp.ApplicationID        = appln.Id;
        Estamp.StampPaperData       = new EstampHelper_EAE.StampPaperData();
        Estamp.FormData             = new Map<String,Object>();
        
        Estamp.StampPaperData.UID               = UID;
        Estamp.StampPaperData.FirstParty        = 'FirstParty';
        Estamp.StampPaperData.SecondParty       = 'SecondParty';
        Estamp.StampPaperData.StampAmount       = stAmount;
        Estamp.StampPaperData.StampDutyPaidBy   = 'SecondParty';
        Estamp.StampPaperData.DocumentCategory  = '1';
        Estamp.StampPaperData.StampState        = stState;
        
        EstampHelper_EAE.FirstPartyAddress fParty   = new EstampHelper_EAE.FirstPartyAddress();
        fParty.StreetAddress                        = KVB_Company_Details__c.getOrgDefaults().StreetAddress_eStamp__c;
        fParty.Locality                             = KVB_Company_Details__c.getOrgDefaults().Locality_eStamp__c;
        fParty.City                                 = KVB_Company_Details__c.getOrgDefaults().City_eStamp__c;
        fParty.State                                = KVB_Company_Details__c.getOrgDefaults().State_eStamp__c;
        fParty.Pincode                              = KVB_Company_Details__c.getOrgDefaults().Pincode_eStamp__c;
        fParty.Country                              = KVB_Company_Details__c.getOrgDefaults().Country_estamp__c;
        Estamp.StampPaperData.FirstPartyAddress     = fParty;
        
        EstampHelper_EAE.FirstPartyAddress sParty   = new EstampHelper_EAE.FirstPartyAddress();
        sParty.StreetAddress                        = appln.genesis__Account__r.BillingStreet != null ?appln.genesis__Account__r.BillingStreet : '';
        sParty.Locality                             = '';
        sParty.City                                 = appln.genesis__Account__r.BillingCity != null ?appln.genesis__Account__r.BillingCity : '';
        sParty.State                                = appln.genesis__Account__r.BillingState != null ?appln.genesis__Account__r.BillingState : '';
        sParty.Pincode                              = appln.genesis__Account__r.BillingPostalCode != null ?appln.genesis__Account__r.BillingPostalCode : '';
        sParty.Country                              = appln.genesis__Account__r.BillingCountry != null ?appln.genesis__Account__r.BillingCountry : '';
        Estamp.StampPaperData.SecondPartyAddress    = sParty;*/

        SMESanction_DocReq req  = new SMESanction_DocReq();
        req.inputVariables      = new SMESanction_DocReq.cls_inputVariables();
        req.owner_tenantId      = 'cuecent_tenant';
        req.exe_tenantId        = 'cuecent_tenant';
        //Newly Tag added for DMS
        req.applicationType     = appln.RecordType.DeveloperName;
        req.applicationId       = appln.Id;
        req.customerId          = '';
        req.documentType        = templateId;
        req.accountNumbers      = '';
        req.fileName            = '';
        req.uuid                = '';
        
        req.inputVariables.unique_key           = templateId;
        req.inputVariables.pdf_unique_key       = appln.Id;
        req.inputVariables.in_msg               = '';
        req.inputVariables.inputmap             = new Map<String,String>();
        req.inputVariables.inputMapForB1        = new Map<String,Object>();
        
        String margin               = '';
        String brnchWithAdd         = '';
        String address              = '';
        String tempString           = '';
        String prevYear             = '';
        String currentFiscalYear    = '';
        currentYear                 = String.valueOf(Utility.getCurrentYear());
        tempString                  = currentYear.subString(2);
        prevYear                    = String.valueOf(Utility.getCurrentYear() - 1);
        currentFiscalYear           = prevYear+'-'+tempString;
        
        
        securtiyDetails                               = new Map<String,String>();
        securtiyDetails                               = SanctionMatrix_Helper.getSecurityDetails(appln.Id);
        
        PENAL_RATE                                    = string.valueof(KVB_Company_Details__c.getOrgDefaults().Penal_Interest__c.setscale(2));
        COMMITMENT_RATE                               = string.valueof(KVB_Company_Details__c.getOrgDefaults().Commitment_charges__c.setscale(2));
        DECIMAL loanAmt     = 0.0;
        DECIMAL enhanceAMT  = 0.0;
        //DECIMAL VARIANCE    = 0.0;
        
        //Final Map for sending the tags along with its values to Digio
        Map<String,String>  reqMap                    = new Map<String,String>();

        Map<Integer,String> facilty_NatureMap         = new Map<Integer,String>();
        Map<Integer,String> roiMap                    = new Map<Integer,String>();
        Map<Integer,String> varianceMap               = new Map<Integer,String>();
        Map<Integer,String> finalLimitMap             = new Map<Integer,String>();
        Map<Integer,String> finalSpreadMap            = new Map<Integer,String>();
        Map<Integer,String> rateCommissionMap         = new Map<Integer,String>();
        Map<Integer,String> approveMarginMap          = new Map<Integer,String>();
        Map<Integer,String> existingLimitMap          = new Map<Integer,String>();
        Map<Integer,String> newLimitMap               = new Map<Integer,String>();
        Map<Integer,String> naturePropMap             = new Map<Integer,String>();
        Map<Integer,String> descPropMap               = new Map<Integer,String>();
        Map<Integer,String> valueMap                  = new Map<Integer,String>();
        Map<Integer,String> natureDocMap              = new Map<Integer,String>();
        Map<Integer,String> dateMap                   = new Map<Integer,String>();
        Map<Integer,String> existingNatureSecMap      = new Map<Integer,String>();
        Map<Integer,String> existingDescSecMap        = new Map<Integer,String>();
        Map<Integer,String> existingTypeOfChrgMap     = new Map<Integer,String>();
        
        List<Facility__c> facList = new List<Facility__c>();
        try{
            facList                                   = [SELECT Id,CL_Product__r.clcommon__Product_Name__c,CL_Product__r.Facility_Category__c,Name,Application__c,
                                                         Limit_Amount__c,Recommended_Rate__c,Final_Spread__c,Margin__c,Margin_Receivables__c,Margin_Stock_Trading__c,Margin_Stock_Manufacturing__c,
                                                         Existing_Margin_Receivables__c,Existing_Margin_Stock_Manufacturing__c,Existing_Limit__c,Existing_Margin_Stock_Trading__c,
                                                         New_Limit_Amount__c,MCLR_Rate__c,Nature_of_Document__c,Date_of_Document__c,Recommended_Limit__c,CL_Product__c,Industry__c    
                                                         FROM Facility__c WHERE Application__c =: appln.Id AND Active__c = TRUE];
        }catch(Exception evar){}
        
        List<Unit_Visit__c> unitVisitList             = new List<Unit_Visit__c>();
        try{
            unitVisitList                              = [SELECT Application__c,Address_Location_of_Unit__c FROM Unit_Visit__c WHERE Application__c =: appln.Id LIMIT 1];
        }catch(Exception evar){}
        
        List<genesis__Application_Parties__c> parties = new List<genesis__Application_Parties__c>();
        try{
            parties                                   = [SELECT Id,genesis__Application__c,Guarantor__c,genesis__Party_Account_Name__c,Signatories__c,
                                                         genesis__Party_Account_Name__r.Name,genesis__Party_Account_Name__r.Age__c,genesis__Party_Account_Name__r.Father_Name__pc,
                                                         genesis__Party_Account_Name__r.PersonMailingStreet,genesis__Party_Account_Name__r.PersonMailingCity,genesis__Party_Account_Name__r.PersonMailingState,
                                                         genesis__Party_Account_Name__r.PersonMailingPostalCode,genesis__Party_Account_Name__r.PersonMailingCountry,genesis__Party_Type__c,Active__c
                                                         FROM genesis__Application_Parties__c WHERE genesis__Application__c =: appln.Id 
                                                         AND Signatories__c = true AND Active__c = true];
        }catch(Exception evar){}
        
        List<clcommon__Collateral__c> existingCollaterals     = new List<clcommon__Collateral__c>();
        List<clcommon__Collateral__c> collaterals             = new List<clcommon__Collateral__c>();
        try{
            
            collaterals     = [SELECT Id,Collateral_Uses__c,MORT_TYPE__c,Nature_of_Property__c,SurveyKhasraKhataPatta_No__c,PlotDoorShopBungalow_No__c,Door__c,Floor_No__c,
                               Stage_Sector_Ward_Block_No__c,Building_Society_Name__c,Street_NameNo__c,VillageTown__c,TalukaTehsil__c,District_Name__c,clcommon__Postal_Code__c,
                               State__c,Area_Square_Feet__c,clcommon__Value__c,clcommon__Value_Date__c,Collateral_Use__c,RecordType.Name,EM_Charge_type__c,FE_Created__c,
                               (SELECT Id,Account__c,Account__r.Name FROM Ownerships__r) 
                               FROM clcommon__Collateral__c WHERE Active__c = TRUE AND Id IN (Select genesis__Collateral__c FROM genesis__Application_Collateral__c WHERE Facility__r.Application__c =: appln.Id)];
        }catch(Exception evar){}
        
        try{
            
            existingCollaterals     = [SELECT Id,Collateral_Uses__c,MORT_TYPE__c,Nature_of_Property__c,clcommon__Value__c,clcommon__Value_Date__c,Collateral_Use__c,
                                       RecordType.Name,EM_Charge_type__c,FE_Created__c,
                                       (SELECT Id,Account__c,Account__r.Name FROM Ownerships__r) FROM clcommon__Collateral__c 
                                       WHERE Active__c = TRUE AND FE_Created__c = false AND Id IN 
                                       (Select genesis__Collateral__c FROM genesis__Application_Collateral__c 
                                        WHERE Facility__r.Application__c =: appln.Id)];
        }catch(Exception evar){}
        
        if(appln !=null){
            String temp = appln.Branch_Code__c;
            brnchWithAdd = Utility.getBlankStringIfNull(appln.Branch_Name__c)+','+ Utility.getBlankStringIfNull(getBranchCity(temp)); 
            address      = Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingState)+'\n'+Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingCountry);
        }
        if(appln != null && (appln.Branch_Code__c)!= null){
            String temp = appln.Branch_Code__c;
            reqMap.put('Branch_City', Utility.getBlankStringIfNull(getBranchCity(temp)));
        }
        else reqMap.put('Branch_City', '');
        
        reqMap.put('Branch_name', Utility.getBlankStringIfNull(appln.Branch_Name__c));
        reqMap.put('Borrower_Name', Utility.getBlankStringIfNull(appln.genesis__Account__r.Name));
        
        reqMap.put('Borrower_Address1', Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingStreet));
        reqMap.put('Borrower_Address2', Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingCity));
        reqMap.put('Borrower_Address3', Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingPostalCode));
        reqMap.put('Borrower_Address4', Utility.getBlankStringIfNull(address));
        
        reqMap.put('Loc_Ref_Branch', Utility.getBlankStringIfNull(getBranchCity(appln.Branch_Code__c)));
        reqMap.put('Branch_Name_with_address', Utility.getBlankStringIfNull(brnchWithAdd));
        reqMap.put('Penal_Interest_Rate2', PENAL_RATE);
        reqMap.put('Commitment_Charges', COMMITMENT_RATE);
        reqMap.put('System_date', Utility.getBlankStringIfNull((system.now()).format('dd-MM-yyyy')));
        // if(appln.EAE_Renewal_Date_in_days__c != null) reqMap.put('Loan_Validity_Period', Utility.getBlankStringIfNull(((System.now().AddDays(Integer.valueOf(appln.EAE_Renewal_Date_in_days__c))).format('dd-MM-yyyy'))));
        reqMap.put('Loan_Validity_Period', Utility.getBlankStringIfNull(((System.now().AddDays(365)).format('dd-MM-yyyy'))));
        if(! unitVisitList.isEmpty() && unitVisitList[0].Address_Location_of_Unit__c != null){
            reqMap.put('Address/Location_of_Unit', Utility.getBlankStringIfNull(unitVisitList[0].Address_Location_of_Unit__c));   
        }
        else{
            reqMap.put('Address/Location_of_Unit', '');   
        }        
        if(appln.Book_Debts_Age__c != null) reqMap.put('book_debts_age', Utility.getBlankStringIfNull(string.valueof(appln.Book_Debts_Age__c)));
        reqMap.put('Disb_Ref_Day', Utility.getBlankStringIfNull((System.now()).format('dd')));
        reqMap.put('Disb_Ref_Month', Utility.getBlankStringIfNull((System.now()).format('MMMM')));
        reqMap.put('Disb_Ref_Year', Utility.getBlankStringIfNull((System.now()).format('yyyy')));
        
        
        for(Integer i=1; i<6; i++){
            facilty_NatureMap.put(i, 'Facility_Type_'+i);
            reqMap.put('Facility_Type_'+i, '');
            
            roiMap.put(i, 'ROI'+i);
            reqMap.put('ROI'+i, '');
            
            varianceMap.put(i, 'Variance'+i);
            reqMap.put('Variance'+i, '');
            
            finalSpreadMap.put(i, 'Final_Spread_'+i);
            reqMap.put('Final_Spread_'+i, '');
            
            rateCommissionMap.put(i, 'Rate_Commission_'+i);
            reqMap.put('Rate_Commission_'+i, '');
            
            approveMarginMap.put(i, 'Approved_Margin'+i);
            reqMap.put('Approved_Margin'+i, '');
            
            if(appln.RecordType.DeveloperName != Constants.SME_NEW_LOAN_RECORD_TYPE){
                
                dateMap.put(i, 'Date_'+i);
                reqMap.put('Date_'+i, '');
                
                natureDocMap.put(i, 'Nature_of_document_'+i);
                reqMap.put('Nature_of_document_'+i, '');
                
                existingLimitMap.put(i, 'Existing_limit_'+i);
                reqMap.put('Existing_limit_'+i, '');
                
                newLimitMap.put(i, 'Increment_limit_'+i);
                reqMap.put('Increment_limit_'+i, '');                
            }                     
            
            finalLimitMap.put(i, 'Final_Limit'+i);
            reqMap.put('Final_Limit'+i, '');
            
        }
        
        if(! facList.isEmpty()){
            for(Integer i=1; i<=facList.size(); i++){ 
                System.debug('facList size---> ' + facList.size());
                System.debug('facList---> ' + facList);
                
                if(facilty_NatureMap.containsKey(i) && facList[i-1].CL_Product__r.clcommon__Product_Name__c != null){
                    reqMap.put(facilty_NatureMap.get(i),Utility.getBlankStringIfNull(facList[i-1].CL_Product__r.clcommon__Product_Name__c));
                }
                
                /* Interest clause Start Here */
                if(roiMap.containsKey(i) && facList[i-1].Recommended_Rate__c != null){
                    reqMap.put(roiMap.get(i),Utility.getBlankStringIfNull(String.valueOf(facList[i-1].Recommended_Rate__c)));
                }
                if(varianceMap.containsKey(i)){
                    reqMap.put(varianceMap.get(i),Utility.getBlankStringIfNull(String.valueOf(facList[i-1].Final_Spread__c)));
                    /*if((facList[i-1].MCLR_Rate__c) != NULL && (facList[i-1].Recommended_Rate__c) != NULL){
VARIANCE = (((facList[i-1].MCLR_Rate__c) - (facList[i-1].Recommended_Rate__c))) * (-1);
VARIANCE = VARIANCE.setscale(2);
}
if( VARIANCE != NULL)
reqMap.put(varianceMap.get(i),Utility.getBlankStringIfNull(String.valueOf(VARIANCE)));
else
reqMap.put(varianceMap.get(i), '');*/
                }
                /* Interest Clause Ends Here */
                
                
                /* Amount (Rs. ) */
                if(finalLimitMap.containsKey(i) && facList[i-1].Recommended_Limit__c != null){
                    reqMap.put(finalLimitMap.get(i),Utility.getBlankStringIfNull(String.valueOf(facList[i-1].Recommended_Limit__c)));
                }
                
                if(facList[i-1].Recommended_Limit__c != null){
                    System.debug('Recommended Limit--> ' + facList[i-1].Recommended_Limit__c);
                    loanAmt += facList[i-1].Recommended_Limit__c;
                    System.debug('loanAmt--> ' + loanAmt);
                    reqMap.put('Loan_Amount', Utility.getBlankStringIfNull(String.valueOf(loanAmt)));
                }
                else reqMap.put('Loan_Amount', '');
                
                /* Loan_Amount_in_words */
                NumberToWordConversion noTowrd = new NumberToWordConversion();
                if(loanAmt != null){
                    reqMap.put('Loan_Amount_in_words', Utility.getBlankStringIfNull(String.valueOf(noTowrd.getNumberTOWordConvertion(loanAmt))));
                }
                else reqMap.put('Loan_Amount_in_words', '');
                
                /* Premium over MCL Rate% */
                if(finalSpreadMap.containsKey(i) && (facList[i-1].Final_Spread__c != null || facList[i-1].Final_Spread__c == 0.00)){
                    reqMap.put(finalSpreadMap.get(i),Utility.getBlankStringIfNull(String.valueOf(facList[i-1].Final_Spread__c))+'%');
                }
                else reqMap.put(finalSpreadMap.get(i), '');
                
                /* Lending Interest Rate% */
                if(rateCommissionMap.containsKey(i) && (facList[i-1].Recommended_Rate__c != null || facList[i-1].Recommended_Rate__c == 0.00)){
                    reqMap.put(rateCommissionMap.get(i),Utility.getBlankStringIfNull(String.valueOf(facList[i-1].Recommended_Rate__c))+'%');
                }
                else reqMap.put(rateCommissionMap.get(i), '');
                
                
                // New Limit Calculation Starts (Increment Limit)
                if( (facList[i-1].Recommended_Rate__c)!= null && (facList[i-1].Existing_Limit__c)!= null ){
                    if(((facList[i-1].Recommended_Rate__c) - (facList[i-1].Existing_Limit__c)) < 0){
                        enhanceAMT = ((facList[i-1].Recommended_Rate__c) - (facList[i-1].Existing_Limit__c)) * (-1);
                    }
                    else enhanceAMT = ((facList[i-1].Recommended_Rate__c) - (facList[i-1].Existing_Limit__c));
                }
                //END
                
                
                if(appln.RecordType.DeveloperName != Constants.SME_NEW_LOAN_RECORD_TYPE){
                    
                    if(dateMap.containsKey(i) && facList[i-1].Date_of_Document__c != null){
                        reqMap.put(dateMap.get(i),Utility.getBlankStringIfNull(formatDate(facList[i-1].Date_of_Document__c)));
                    }
                    if(natureDocMap.containsKey(i) && facList[i-1].Nature_of_Document__c != null){
                        reqMap.put(natureDocMap.get(i),Utility.getBlankStringIfNull(facList[i-1].Nature_of_Document__c));
                    }
                    if(existingLimitMap.containsKey(i) && facList[i-1].Existing_Limit__c != null){
                        reqMap.put(existingLimitMap.get(i),Utility.getBlankStringIfNull(String.valueOf(facList[i-1].Existing_Limit__c)));
                    }
                    
                    /* Enhanced Amount */
                    if(newLimitMap.containsKey(i)){
                        if(enhanceAMT != null)
                            reqMap.put(newLimitMap.get(i),Utility.getBlankStringIfNull(String.valueOf(enhanceAMT)));
                        else 
                            reqMap.put(newLimitMap.get(i),Utility.getBlankStringIfNull(String.valueOf(enhanceAMT)));
                    }    
                }
                
                /* Margin % */
                if(approveMarginMap.containsKey(i)){
                    if(facList[i-1].CL_Product__r.Facility_Category__c == 'OCC'){
                        if(facList[i-1].Industry__c == 'Manufacturing'){
                            margin = 'Receivables : '+ facList[i-1].Margin_Receivables__c + '; ' +'Stock Manufacturing : '+ facList[i-1].Margin_Stock_Manufacturing__c;
                            reqMap.put(approveMarginMap.get(i),Utility.getBlankStringIfNull(margin)+'%');                        
                        }
                        else if(facList[i-1].Industry__c == 'TRADING'){
                            margin = 'Receivables : '+ facList[i-1].Margin_Receivables__c + '; ' +'Stock Trading : '+ facList[i-1].Margin_Stock_Trading__c;
                            reqMap.put(approveMarginMap.get(i),Utility.getBlankStringIfNull(margin)+'%');
                        }
                    }
                    else if(facList[i-1].Margin__c != null && facList[i-1].Margin__c >0.0){
                        margin = String.valueOf(facList[i-1].Margin__c);
                        reqMap.put(approveMarginMap.get(i),Utility.getBlankStringIfNull(margin)+'%');
                    }
                    else  reqMap.put(approveMarginMap.get(i), '');
                }
                /* Margin % Ends Here */                    
            }         
        }
        
        reqMap.put('Latest_financials_date', +'31st March,'+Utility.getBlankStringIfNull(currentYear));
        
        M68_Balance_Sheet_Analysis__c   m68Rec      = new M68_Balance_Sheet_Analysis__c();
        try{
            if(appln != null && appln.genesis__Account__c != null && currentYear != null){
                m68Rec                              = [SELECT Id,Account__c,Total_Assets__c,Financial_type__c,Fiscal_Year__c FROM M68_Balance_Sheet_Analysis__c 
                                                       WHERE Account__c=: appln.genesis__Account__c  AND Financial_type__c = 'Actual' AND Fiscal_Year__c =: currentFiscalYear LIMIT 1];
            }
        }catch(Exception evar){}
        
        if(m68Rec != null){
            if(m68Rec.Total_Assets__c == 0.00 || m68Rec.Total_Assets__c == null){
                System.debug('Inside If');
                Decimal TotalCurrentassetvalue = 0.00;
                if(! facList.isEmpty()){
                    for(Facility__c facRec : facList){
                        TotalCurrentassetvalue += facRec.Recommended_Limit__c;
                        System.debug('Result1---->>>>> ' + TotalCurrentassetvalue);
                        System.debug('Result2---->>>>> ' + TotalCurrentassetvalue*1.25);
                    }
                    reqMap.put('Total_Current_asset_value', Utility.getBlankStringIfNull(String.valueOf((TotalCurrentassetvalue*1.25).setScale(2))));
                }
            }
            else{
                System.debug('Inside Else');
                reqMap.put('Total_Current_asset_value', Utility.getBlankStringIfNull(String.valueOf((m68Rec.Total_Assets__c).setScale(2))));
            }
        }
        
        for(Integer i=1; i<11; i++){
            //fe created true
            naturePropMap.put(i, 'Nature_Property_'+i);
            reqMap.put('Nature_Property_'+i, '');
            
            descPropMap.put(i, 'Desc_Property_'+i);
            reqMap.put('Desc_Property_'+i, '');
            
            valueMap.put(i, 'Value_'+i);
            reqMap.put('Value_'+i, '');
            
            //fe created false (SCHEDULE-1 Table)
            if(appln.RecordType.DeveloperName != Constants.SME_NEW_LOAN_RECORD_TYPE){
                existingNatureSecMap.put(i, 'Existing_Nature_of_security_'+i);
                reqMap.put('Existing_Nature_of_security_'+i, '');
                
                existingDescSecMap.put(i, 'Existing_Desc_Property_'+i);
                reqMap.put('Existing_Desc_Property_'+i, '');
                
                existingTypeOfChrgMap.put(i, 'Existing_Type_of_charge_'+i);
                reqMap.put('Existing_Type_of_charge_'+i, '');
            }
            
        }
        
        /* SCHEDULE - III */
        if(collaterals.size() > 0){
            for(Integer i=1; i<=collaterals.size(); i++){
                //if(collaterals[i-1].FE_Created__c == TRUE){
                String nature_Of_Prop     = collaterals[i-1].RecordType.Name+', '+ Utility.getBlankStringIfNull(collaterals[i-1].Collateral_Uses__c) ;
                if(naturePropMap.containsKey(i)){
                    reqMap.put(naturePropMap.get(i),Utility.getBlankStringIfNull(nature_Of_Prop));
                }
                if(!securtiyDetails.isEmpty() && securtiyDetails.containsKey(collaterals[i-1].Id)){
                    if(descPropMap.containsKey(i)){
                        reqMap.put(descPropMap.get(i),Utility.getBlankStringIfNull(String.valueOf(securtiyDetails.get(collaterals[i-1].Id))));
                    }
                }
                if(valueMap.containsKey(i)){
                    reqMap.put(valueMap.get(i),Utility.getBlankStringIfNull(String.valueOf(collaterals[i-1].clcommon__Value__c)));
                }
                //}
            }
        }
        
        
        if(appln.RecordType.DeveloperName != Constants.SME_NEW_LOAN_RECORD_TYPE){
            
            /****** SCHEDULE-1 Table Starts  ******/
            if(! existingCollaterals.isEmpty()){
                for(Integer i=1; i<=existingCollaterals.size(); i++){    
                    if(! existingCollaterals[i-1].FE_Created__c ){  
                        String nature_Of_SEC     = existingCollaterals[i-1].RecordType.Name+', '+ Utility.getBlankStringIfNull(existingCollaterals[i-1].Collateral_Uses__c) ;
                        if(existingNatureSecMap.containsKey(i)){
                            reqMap.put(existingNatureSecMap.get(i),Utility.getBlankStringIfNull(nature_Of_SEC));
                        }
                        if(!securtiyDetails.isEmpty() && securtiyDetails.containsKey(existingCollaterals[i-1].Id)){
                            if(existingDescSecMap.containsKey(i)){
                                reqMap.put(existingDescSecMap.get(i),Utility.getBlankStringIfNull(String.valueOf(securtiyDetails.get(existingCollaterals[i-1].Id))));
                            }
                        }
                        if(existingTypeOfChrgMap.containsKey(i)){
                            if(existingCollaterals[i-1].MORT_TYPE__c != null && existingCollaterals[i-1].MORT_TYPE__c == 'EM'){
                                reqMap.put(existingTypeOfChrgMap.get(i),Utility.getBlankStringIfNull(existingCollaterals[i-1].MORT_TYPE__c));
                            }
                            else reqMap.put(existingTypeOfChrgMap.get(i), '');
                        }
                    }
                }
            }
            /********** SCHEDULE-1 Table END ***********/
        }
        
        Map<Integer,String> partyTypeMap = new Map<Integer,String>();
        Map<Integer,String> signatoryMap = new Map<Integer,String>();
        Map<Integer,String> brrwsignMap  = new Map<Integer,String>();
        
        for(integer i=1;i<31;i++){
            partyTypeMap.put(i, 'Auth_Signatory_Type'+i);
            signatoryMap.put(i, 'Auth_Signatory'+i);
            brrwsignMap.put(i,'Borrower_Guar_Sign'+i);
            reqMap.put('Auth_Signatory_Type'+i, '');
            reqMap.put('Auth_Signatory'+i, '');
            reqMap.put('Borrower_Guar_Sign'+i, '');
        }
        
        If(! parties.isEmpty()){
            Integer partyCount =1;
            for(Integer i=1; i<=parties.size(); i++){
                String Authoritised_Signatories = '';
                If(parties[i-1].genesis__Party_Type__c == 'Partner' || parties[i-1].genesis__Party_Type__c == 'Proprietor' || parties[i-1].genesis__Party_Type__c == 'Director' || parties[i-1].genesis__Party_Type__c == 'Co-Borrower'){
                    If(signatoryMap.containsKey(partyCount) && parties[i-1].genesis__Party_Account_Name__c != null){
                        reqMap.put(partyTypeMap.get(partyCount),Utility.getBlankStringIfNull(parties[i-1].genesis__Party_Type__c));
                        reqMap.put(signatoryMap.get(partyCount),Utility.getBlankStringIfNull(parties[i-1].genesis__Party_Account_Name__r.Name));
                    }
                    partyCount++;
                    
                    Authoritised_Signatories        = 'Name of the authorized signatory'+' '+parties[i-1].genesis__Party_Account_Name__r.Name+','+'s/o Mr.'+' '+parties[i-1].genesis__Party_Account_Name__r.Father_Name__pc+','+parties[i-1].genesis__Party_Account_Name__r.Age__c+' '+'aged about (age of the authorized signatory1), reported to be residing at '+parties[i-1].genesis__Party_Account_Name__r.PersonMailingStreet+','+parties[i-1].genesis__Party_Account_Name__r.PersonMailingCity+','+
                        parties[i-1].genesis__Party_Account_Name__r.PersonMailingState+','+parties[i-1].genesis__Party_Account_Name__r.PersonMailingPostalCode;
                    reqMap.put('Authorised_Signatories', Utility.getBlankStringIfNull(Authoritised_Signatories));
                }
            }
        }
        
        //System.debug(' reqmap  ' + reqMap);
        
        reqMap.put('Auth_Signatory_Bnk', 'KVB Bank');   
        reqMap.put('Bnk_Auth_Sign', '');
        
        /*Estamp.FormData = reqMap;
        System.debug(' 123 ' + Estamp.FormData);
        return Estamp;*/

        req.inputVariables.inputmap = reqMap;
        return req;
    }
    
    
    /*  Guarantor_Agreement_SME_v1 Guarantor Agreement */
    public static SMESanction_DocReq generateGuarantorAgreement(genesis__Applications__c appln, List<Facility__c> facilities, String templateId){
        
        String brnchWithAdd         = '';
        String margin               = '';
        
        /*EstampHelper_EAE Estamp     = new EstampHelper_EAE();
        Estamp.ReferenceID          = CreateUniqueId.uniqID();
        Estamp.TemplateID           = templateId;
        Estamp.ApplicationID        = appln.Id;
        Estamp.StampPaperData       = new EstampHelper_EAE.StampPaperData();
        Estamp.FormData             = new Map<String,Object>();
        
        Estamp.StampPaperData.UID                       = UID;
        Estamp.StampPaperData.FirstParty                = 'FirstParty';
        Estamp.StampPaperData.SecondParty               = 'SecondParty';
        Estamp.StampPaperData.StampAmount               = stAmount;
        Estamp.StampPaperData.StampDutyPaidBy           = 'SecondParty';
        Estamp.StampPaperData.DocumentCategory          = '1';
        Estamp.StampPaperData.StampState                = stState;
        
        EstampHelper_EAE.FirstPartyAddress fParty       = new EstampHelper_EAE.FirstPartyAddress();
        fParty.StreetAddress                            = KVB_Company_Details__c.getOrgDefaults().StreetAddress_eStamp__c;
        fParty.Locality                                 = KVB_Company_Details__c.getOrgDefaults().Locality_eStamp__c;
        fParty.City                                     = KVB_Company_Details__c.getOrgDefaults().City_eStamp__c;
        fParty.State                                    = KVB_Company_Details__c.getOrgDefaults().State_eStamp__c;
        fParty.Pincode                                  = KVB_Company_Details__c.getOrgDefaults().Pincode_eStamp__c;
        fParty.Country                                  = KVB_Company_Details__c.getOrgDefaults().Country_estamp__c;
        Estamp.StampPaperData.FirstPartyAddress         = fParty;
        
        EstampHelper_EAE.FirstPartyAddress sParty       = new EstampHelper_EAE.FirstPartyAddress();
        sParty.StreetAddress                            = Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingStreet);
        sParty.Locality                                 =   '';
        sParty.City                                     = Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingCity);
        sParty.State                                    = Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingState);
        sParty.Pincode                                  = Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingPostalCode);
        sParty.Country                                  = Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingCountry);
        Estamp.StampPaperData.SecondPartyAddress        = sParty;*/

        SMESanction_DocReq req  = new SMESanction_DocReq();
        req.inputVariables      = new SMESanction_DocReq.cls_inputVariables();
        req.owner_tenantId      = 'cuecent_tenant';
        req.exe_tenantId        = 'cuecent_tenant';
        //Newly Tag added for DMS
        req.applicationType     = appln.RecordType.DeveloperName;
        req.applicationId       = appln.Id;
        req.customerId          = '';
        req.documentType        = templateId;
        req.accountNumbers      = '';
        req.fileName            = '';
        req.uuid                = '';
        
        req.inputVariables.unique_key           = templateId;
        req.inputVariables.pdf_unique_key       = appln.Id;
        req.inputVariables.in_msg               = '';
        req.inputVariables.inputmap             = new Map<String,String>();
        req.inputVariables.inputMapForB1        = new Map<String,Object>();
        
        //Final Map for sending the tags along with its values to Digio
        Map<String,String> reqMap               = new Map<String,String>();

        Map<Integer,String> facilty_NatureMap   = new Map<Integer,String>();
        Map<Integer,string> apprvLimitMap       = new Map<Integer,string>();
        Map<Integer,string> apprvMarginMap      = new Map<Integer,string>();
        Map<Integer,string> ratCommsnMap        = new Map<Integer,string>();
        Map<Integer,string> finalSpreadMap      = new Map<Integer,string>();
        Map<Integer,string> guarantroMap        = new Map<Integer,string>();
        Map<Integer,string> eSignMap            = new Map<Integer,string>();
        
        if(appln != null && (appln.Branch_Name__c)!= null && (appln.Branch_Code__c)!= null){
            brnchWithAdd = Utility.getBlankStringIfNull(appln.Branch_Name__c)+', '+ Utility.getBlankStringIfNull(getBranchCity(appln.Branch_Code__c));
            reqMap.put('Branch_with_address', Utility.getBlankStringIfNull(brnchWithAdd));
        }
        else reqMap.put('Branch_with_address', '');
        reqMap.put('Borrower_Names', +'M/S. '+Utility.getBlankStringIfNull(appln.genesis__Account__r.Name));
        /*if(appln != null && appln.EAE_Renewal_Date_in_days__c != null){
reqMap.put('Loan_Validity_Period', Utility.getBlankStringIfNull(((System.now().AddDays(Integer.valueOf(appln.EAE_Renewal_Date_in_days__c))).format('dd-MM-yyyy'))));
}
else reqMap.put('Loan_Validity_Period', '');*/ 
        reqMap.put('Loan_Validity_Period', Utility.getBlankStringIfNull(((System.Now().AddDays(365)).format('dd-MM-yyyy'))));
        reqMap.put('Loc_Ref_Branch', Utility.getBlankStringIfNull(getBranchCity(appln.Branch_Code__c)));
        reqMap.put('Disb_Ref_Day', Utility.getBlankStringIfNull((System.now()).format('dd')));
        reqMap.put('Disb_Ref_Month', Utility.getBlankStringIfNull((System.now()).format('MMMM')));
        reqMap.put('Disb_Ref_Year', Utility.getBlankStringIfNull((System.now()).format('yyyy')));
        
        List<genesis__Application_Parties__c> parties = new List<genesis__Application_Parties__c>();
        try{
            parties                                   = [SELECT Id,genesis__Application__c,Guarantor__c,genesis__Party_Account_Name__c,Signatories__c,
                                                         genesis__Party_Account_Name__r.Father_Name__pc,genesis__Party_Account_Name__r.Age__c,
                                                         genesis__Party_Account_Name__r.PersonMailingStreet,genesis__Party_Account_Name__r.PersonMailingCity,
                                                         genesis__Party_Account_Name__r.PersonMailingState,genesis__Party_Account_Name__r.PersonMailingPostalCode,
                                                         genesis__Party_Account_Name__r.PersonMailingCountry,genesis__Party_Account_Name__r.Name,genesis__Party_Type__c,
                                                         Active__c FROM genesis__Application_Parties__c WHERE genesis__Application__c =: appln.Id AND Signatories__c = true 
                                                         AND Guarantor__c = true AND Active__c = true];
        }catch(Exception evar){}
        
        for(Integer i=1; i<6; i++){
            
            facilty_NatureMap.put(i, 'Facility_Type_'+i);
            reqMap.put('Facility_Type_'+i, '');
            
            apprvLimitMap.put(i, 'Approved_Limit'+i);
            reqMap.put('Approved_Limit'+i, '');
            
            apprvMarginMap.put(i, 'Approved_Margin'+i);
            reqMap.put('Approved_Margin'+i, '');
            
            finalSpreadMap.put(i, 'Final_Spread_'+i);
            reqMap.put('Final_Spread_'+i, '');
            
            ratCommsnMap.put(i, 'Rate_Commission_'+i);
            reqMap.put('Rate_Commission_'+i, '');
            
            guarantroMap.put(i, 'Guarantor'+i+'_Names');
            reqMap.put('Guarantor'+i+'_Names', '');
            
            eSignMap.put(i, 'esign'+i);
            reqMap.put('esign'+i, '');
        }
        
        if(! facilities.isEmpty()){
            for(Integer i=1; i<=facilities.size(); i++){
                
                if(facilty_NatureMap.containsKey(i) && facilities[i-1].CL_Product__r.clcommon__Product_Name__c != null){
                    reqMap.put(facilty_NatureMap.get(i),Utility.getBlankStringIfNull(facilities[i-1].CL_Product__r.clcommon__Product_Name__c));
                }
                if(apprvLimitMap.containsKey(i) && facilities[i-1].Recommended_Limit__c != null){
                    reqMap.put(apprvLimitMap.get(i),Utility.getBlankStringIfNull(String.ValueOf(facilities[i-1].Recommended_Limit__c)));
                }
                
                /* Margin %  */
                if(apprvMarginMap.containsKey(i)){
                    if((facilities[i-1].Industry__c) != null && facilities[i-1].Industry__c == 'Manufacturing'){
                        if((facilities[i-1].CL_Product__r.Facility_Category__c == 'SOD') || (facilities[i-1].CL_Product__r.Facility_Category__c == 'FBP') || (facilities[i-1].CL_Product__r.Facility_Category__c == 'FGN') || (facilities[i-1].CL_Product__r.Facility_Category__c == 'BG') || (facilities[i-1].CL_Product__r.Facility_Category__c == 'LC')){
                            reqMap.put(apprvMarginMap.get(i),Utility.getBlankStringIfNull(String.valueOf(facilities[i-1].Margin__c))+'%');
                        }
                        else {
                            if((facilities[i-1].Margin_Receivables__c) != NULL && (facilities[i-1].Margin_Stock_Manufacturing__c) != NULL){
                                margin = 'Receivables : '+ facilities[i-1].Margin_Receivables__c+'%' + ' ; ' +'Stock Manufacturing : '+ facilities[i-1].Margin_Stock_Manufacturing__c+'%';
                                System.debug('Margin1--> ' + margin);
                                reqMap.put(apprvMarginMap.get(i),Utility.getBlankStringIfNull(margin)); 
                            }
                            else
                                reqMap.put(apprvMarginMap.get(i), '');
                        }      
                    }
                    else if((facilities[i-1].Industry__c) != null && facilities[i-1].Industry__c == 'TRADING'){
                        if((facilities[i-1].CL_Product__r.Facility_Category__c == 'SOD') || (facilities[i-1].CL_Product__r.Facility_Category__c == 'FBP')){
                            reqMap.put(apprvMarginMap.get(i),Utility.getBlankStringIfNull(String.valueOf(facilities[i-1].Margin__c))+'%');
                        }
                        else{
                            if((facilities[i-1].Margin_Receivables__c) != NULL && (facilities[i-1].Margin_Stock_Trading__c) != NULL){
                                margin = 'Receivables : '+ facilities[i-1].Margin_Receivables__c +'%' +' ; ' +'Stock Trading : '+ facilities[i-1].Margin_Stock_Trading__c+'%';
                                System.debug('Margin2--> ' + margin);
                                reqMap.put(apprvMarginMap.get(i),Utility.getBlankStringIfNull(margin));
                            }
                            else
                                reqMap.put(apprvMarginMap.get(i), '');
                        }
                    }
                    else{
                        if((facilities[i-1].Margin__c) != NULL){
                            margin = Utility.getBlankStringIfNull(String.valueOf(facilities[i-1].Margin__c));
                            System.debug('Margin3--> ' + margin);
                            reqMap.put(apprvMarginMap.get(i),Utility.getBlankStringIfNull(margin)); 
                        }
                        else
                            reqMap.put(apprvMarginMap.get(i), '');
                    } 
                }    
                
                /* Premium over MCL Rate %  */
                if(finalSpreadMap.containsKey(i)){
                    /*if(appln.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_EXCEEDING && facilities[i-1].Recommended_Rate__c!= null && facilities[i-1].MCLR_Rate__c!=null && facilities[i-1].Final_Spread__c!= null){
//reqMap.put(finalSpreadMap.get(i),Utility.getBlankStringIfNull(String.ValueOf(((facilities[i-1].Recommended_Rate__c) - (facilities[i-1].MCLR_Rate__c)+3)))+'%');
reqMap.put(finalSpreadMap.get(i),Utility.getBlankStringIfNull(String.ValueOf((facilities[i-1].Final_Spread__c)+3)+'%'));
}
else if((appln.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || appln.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC || appln.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE) && facilities[i-1].Recommended_Rate__c!= null && facilities[i-1].MCLR_Rate__c!=null && facilities[i-1].Final_Spread__c!= null){
//reqMap.put(finalSpreadMap.get(i),Utility.getBlankStringIfNull(String.ValueOf((facilities[i-1].Recommended_Rate__c) - (facilities[i-1].MCLR_Rate__c)))+'%');
reqMap.put(finalSpreadMap.get(i),Utility.getBlankStringIfNull(String.ValueOf((facilities[i-1].Final_Spread__c))+'%'));
}*/
                    reqMap.put(finalSpreadMap.get(i),Utility.getBlankStringIfNull(String.ValueOf((facilities[i-1].Final_Spread__c))+'%'));
                }
                
                /* Lending Interest %  */
                if(ratCommsnMap.containsKey(i) && facilities[i-1].Recommended_Rate__c != null){
                    reqMap.put(ratCommsnMap.get(i),Utility.getBlankStringIfNull(String.ValueOf(facilities[i-1].Recommended_Rate__c))+'%');
                }
            }
        }
        string gaurantorName = '';
        if(! parties.isEmpty()){
            
            for(Integer i=1; i<=parties.size(); i++){
                if((parties[i-1].genesis__Party_Account_Name__c != null) && parties[i-1].genesis__Party_Type__c == 'Partner' || parties[i-1].genesis__Party_Type__c == 'Director' || parties[i-1].genesis__Party_Type__c == 'Guarantor' || parties[i-1].genesis__Party_Type__c == 'Co-Borrower'){
                    if(guarantroMap.containsKey(i)){
                        reqMap.put(guarantroMap.get(i),Utility.getBlankStringIfNull(String.valueof(parties[i-1].genesis__Party_Account_Name__r.Name)));
                    }
                    
                    /* Changes Done for Guarantor_Details tag */
                    if((parties[i-1].genesis__Party_Account_Name__r.Name)!= null && (parties[i-1].genesis__Party_Account_Name__r.Father_Name__pc)!=null && 
                       (parties[i-1].genesis__Party_Account_Name__r.Age__c)!=null && (parties[i-1].genesis__Party_Account_Name__r.PersonMailingStreet)!=null && 
                       (parties[i-1].genesis__Party_Account_Name__r.PersonMailingCity)!=null && (parties[i-1].genesis__Party_Account_Name__r.PersonMailingState)!=null && (parties[i-1].genesis__Party_Account_Name__r.PersonMailingPostalCode)!=null && (parties[i-1].genesis__Party_Account_Name__r.PersonMailingCountry)!=null){
                           
                           gaurantorName += '   Mr./Ms.'+' '+Utility.getBlankStringIfNull(parties[i-1].genesis__Party_Account_Name__r.Name)+', '+'S/o or D/o Mr.'+' '+Utility.getBlankStringIfNull(parties[i-1].genesis__Party_Account_Name__r.Father_Name__pc)+', '+ 'aged '+Utility.getBlankStringIfNull(String.valueOf(parties[i-1].genesis__Party_Account_Name__r.Age__c))+' '+'years old, residing at '+ Utility.getBlankStringIfNull(parties[i-1].genesis__Party_Account_Name__r.PersonMailingStreet)+','+Utility.getBlankStringIfNull(parties[i-1].genesis__Party_Account_Name__r.PersonMailingCity)+','+Utility.getBlankStringIfNull(parties[i-1].genesis__Party_Account_Name__r.PersonMailingState)+','+Utility.getBlankStringIfNull(parties[i-1].genesis__Party_Account_Name__r.PersonMailingPostalCode)+','+Utility.getBlankStringIfNull(parties[i-1].genesis__Party_Account_Name__r.PersonMailingCountry)+',';
                       }
                }
                if(eSignMap.containsKey(i)){
                    reqMap.put(eSignMap.get(i), '');
                }
            }
        }
        
        /* Changes Done for Guarantor_Details tag */
        gaurantorName = gaurantorName.removeEnd(',');
        if(gaurantorName != null){
            reqMap.put('Guarantor_Details', Utility.getBlankStringIfNull(gaurantorName));
        }
        else reqMap.put('Guarantor_Details', '');
        
        reqMap.put('Auth_Sign_Bnk', 'KVB Bank');
        reqMap.put('Bnk_Auth_Sign', '');
        
        /*Estamp.FormData = reqMap;
        System.debug('Estamp2 ' + Estamp);
        return Estamp;*/
        req.inputVariables.inputmap = reqMap;
        return req;
    }
    
    /*  A_1_Doc  (A1) */
    public static SMESanction_DocReq generate_A_1_Doc(genesis__Applications__c appln, String templateId){

        SMESanction_DocReq req  = new SMESanction_DocReq();
        req.inputVariables      = new SMESanction_DocReq.cls_inputVariables();
        req.owner_tenantId      = 'cuecent_tenant';
        req.exe_tenantId        = 'cuecent_tenant';
        //Newly Tag added for DMS
        req.applicationType     = appln.RecordType.DeveloperName;
        req.applicationId       = appln.Id;
        req.customerId          = '';
        req.documentType        = templateId;
        req.accountNumbers      = '';
        req.fileName            = '';
        req.uuid                = '';
        
        req.inputVariables.unique_key           = templateId;
        req.inputVariables.pdf_unique_key       = appln.Id;
        req.inputVariables.in_msg               = '';
        req.inputVariables.inputmap             = new Map<String,String>();
        req.inputVariables.inputMapForB1        = new Map<String,Object>();

        //Final Map for sending the tags along with its values to Digio
        Map<String,String> reqMap               = new Map<String,String>();
        
        String BORROWER_WITH_ADDRESS = '';
        If(appln != null && (appln.genesis__Account__r.Name)!=null && (appln.genesis__Account__r.BillingStreet)!=null && (appln.genesis__Account__r.BillingCity)!=null && (appln.genesis__Account__r.BillingState)!=null && (appln.genesis__Account__r.BillingPostalCode)!=null && (appln.genesis__Account__r.BillingCountry)!=null){
            BORROWER_WITH_ADDRESS    = appln.genesis__Account__r.Name+', '+'Located at : '+appln.genesis__Account__r.BillingStreet+','+
                appln.genesis__Account__r.BillingCity+','+appln.genesis__Account__r.BillingState+','+
                appln.genesis__Account__r.BillingPostalCode+','+appln.genesis__Account__r.BillingCountry;
        }
                
        List<Facility__c> facilities            = new List<Facility__c>();
        try{
            facilities                          = [SELECT Id,Final_Spread__c,Recommended_Rate__c,Limit_Amount__c,Application__c,MCLR_Rate__c,Recommended_Limit__c 
                                                   FROM Facility__c WHERE Application__c =: appln.Id LIMIT 1];
        }catch(Exception evar){}
        
        if(appln != null && (appln.Branch_Code__c)!= null){
            String temp = appln.Branch_Code__c;
            reqMap.put('Branch_City', Utility.getBlankStringIfNull(getBranchCity(temp)));
        }
        else reqMap.put('Branch_City', '');   
        
        reqMap.put('Branch_Name', Utility.getBlankStringIfNull(appln.Branch_Name__c));
        if(BORROWER_WITH_ADDRESS!= null){
            reqMap.put('Borrower_Name_with_address', Utility.getBlankStringIfNull(BORROWER_WITH_ADDRESS));
        }
        else reqMap.put('Borrower_Name_with_address', '');
        reqMap.put('All_Promoters_Singatories_name_fathers_name_age_address', '');
        reqMap.put('Disb_Date', Utility.getBlankStringIfNull((System.now()).format('dd-MM-yyyy')));
        
        If(! facilities.isEmpty()){
            NumberToWordConversion noTowrd = new NumberToWordConversion();
            reqMap.put('Final_Limit1', Utility.getBlankStringIfNull(String.valueOf(facilities[0].Recommended_Limit__c)));
            reqMap.put('Final_Limit1_in_words', Utility.getBlankStringIfNull(String.valueOf(noTowrd.getNumberTOWordConvertion(facilities[0].Recommended_Limit__c))));
            reqMap.put('One_Year_MCLR', Utility.getBlankStringIfNull(String.valueOf(facilities[0].MCLR_Rate__c)));
            reqMap.put('Spread_each_facility', Utility.getBlankStringIfNull(String.valueOf(facilities[0].Final_Spread__c)));
            reqMap.put('Rate_Commission_1', Utility.getBlankStringIfNull(String.valueOf(facilities[0].Recommended_Rate__c)));             
        }
        
        List<genesis__Application_Parties__c> parties = new List<genesis__Application_Parties__c>();
        try{
            
            parties                                   = [SELECT Id,genesis__Application__c,genesis__Party_Type__c,Relationship_to_Borrower__c,Signatories__c,Guarantor__c,
                                                         genesis__Party_Account_Name__r.Name,genesis__Party_Account_Name__r.PersonMailingStreet,
                                                         genesis__Party_Account_Name__r.Age__c,genesis__Party_Account_Name__r.Father_Name__pc,
                                                         genesis__Party_Account_Name__r.PersonMailingCity,genesis__Party_Account_Name__r.PersonMailingState,
                                                         genesis__Party_Account_Name__r.PersonMailingPostalCode,genesis__Party_Account_Name__r.PersonMailingCountry,Active__c
                                                         FROM genesis__Application_Parties__c 
                                                         WHERE genesis__Application__c =: appln.Id AND (Signatories__c = TRUE AND Active__c = TRUE) AND 
                                                         (genesis__Party_Type__c = 'Partner' OR genesis__Party_Type__c = 'Proprietor')];
        }catch(Exception evar){}
        
        If(! parties.isEmpty()){
            for(Integer i=1; i<=parties.size(); i++){
                String allPromoters = '';
                
                
                if((parties[i-1].genesis__Party_Account_Name__r.Name)!= null && (parties[i-1].genesis__Party_Account_Name__r.Father_Name__pc)!=null && 
                   (parties[i-1].genesis__Party_Account_Name__r.Age__c)!=null && (parties[i-1].genesis__Party_Account_Name__r.PersonMailingStreet)!=null && 
                   (parties[i-1].genesis__Party_Account_Name__r.PersonMailingCity)!=null && (parties[i-1].genesis__Party_Account_Name__r.PersonMailingState)!=null && 
                   (parties[i-1].genesis__Party_Account_Name__r.PersonMailingPostalCode)!=null && 
                   (parties[i-1].genesis__Party_Account_Name__r.PersonMailingCountry)!=null){
                       
                       allPromoters        =   'Mr./Ms.'+' '+Utility.getBlankStringIfNull(parties[i-1].genesis__Party_Account_Name__r.Name)+', '+'S/o or D/o Mr.'+' '+
                           Utility.getBlankStringIfNull(parties[i-1].genesis__Party_Account_Name__r.Father_Name__pc)+', '+ 'aged '+
                           Utility.getBlankStringIfNull(String.valueOf(parties[i-1].genesis__Party_Account_Name__r.Age__c))
                           +' '+'years old, residing at '+ Utility.getBlankStringIfNull(parties[i-1].genesis__Party_Account_Name__r.PersonMailingStreet)+','+
                           Utility.getBlankStringIfNull(parties[i-1].genesis__Party_Account_Name__r.PersonMailingCity)+','+
                           Utility.getBlankStringIfNull(parties[i-1].genesis__Party_Account_Name__r.PersonMailingState)+','+
                           Utility.getBlankStringIfNull(parties[i-1].genesis__Party_Account_Name__r.PersonMailingPostalCode)+','+
                           Utility.getBlankStringIfNull(parties[i-1].genesis__Party_Account_Name__r.PersonMailingCountry);
                   }     
                
                if(allPromoters != null){
                    reqMap.put('All_Promoters_Singatories_name_fathers_name_age_address', Utility.getBlankStringIfNull(allPromoters));
                }
                else reqMap.put('All_Promoters_Singatories_name_fathers_name_age_address', '');
            }
        }
        req.inputVariables.inputmap = reqMap;
        return req;
    }
    
    
    /* C-7_Doc */
    public static SMESanction_DocReq generate_C_7_Doc(genesis__Applications__c appln, String templateId){
        
        
        SMESanction_DocReq req = new SMESanction_DocReq();
        req.inputVariables      = new SMESanction_DocReq.cls_inputVariables();
        req.owner_tenantId      = 'cuecent_tenant';
        req.exe_tenantId        = 'cuecent_tenant';
        //Newly Tag added for DMS
        req.applicationType     = appln.RecordType.DeveloperName;
        req.applicationId       = appln.Id;
        req.customerId          = '';
        req.documentType        = templateId;
        req.accountNumbers      = '';
        req.fileName            = '';
        req.uuid                = '';
        
        req.inputVariables.unique_key           = templateId;
        req.inputVariables.pdf_unique_key       = appln.Id;
        req.inputVariables.in_msg               = '';
        req.inputVariables.inputmap             = new Map<String,String>();
        req.inputVariables.inputMapForB1        = new Map<String,Object>();

        //Final Map for sending the tags along with its values to Digio
        Map<String,String> reqMap               = new Map<String,String>();

        String address4 = '';
        NumberToWordConversion noTowrd          = new NumberToWordConversion();
        
        reqMap.put('Borrower_Name', Utility.getBlankStringIfNull(appln.genesis__Account__r.Name));
        reqMap.put('Borrower_Address_1', Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingStreet));
        reqMap.put('Borrower_Address_2', Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingCity));
        reqMap.put('Borrower_Address_3', Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingState));
        reqMap.put('Borrower_Address_4', Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingPostalCode));
        reqMap.put('Borrower_Address_5', Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingCountry));
        reqMap.put('Branch_name', Utility.getBlankStringIfNull(appln.Branch_Name__c));
        
        if(appln != null && (appln.Branch_Code__c)!= null){
            String temp = appln.Branch_Code__c;
            reqMap.put('Branch_City', Utility.getBlankStringIfNull(getBranchCity(temp)));
        }
        else reqMap.put('Branch_City', '');
        
        reqMap.put('Disb_Date', Utility.getBlankStringIfNull((System.now()).format('dd-MM-yyyy')));
        
        List<Facility__c> facilities                = new List<Facility__c>();
        If(appln != null){
            try{
                facilities                          = [SELECT Id,Last_EOD_Date__c,Name,Balance_Outstandings__c,Limit_Amount__c,Recommended_Limit__c,Application__c,Limit_end_date__c,CL_Product__c,CL_Product__r.clcommon__Product_Name__c 
                                                       FROM Facility__c WHERE Application__c =: appln.Id LIMIT 1];
            }catch(Exception evar){}   
        }
        
        If(! facilities.isEmpty()){
            Decimal bal_Outstanding = 0;
            
            for(Integer i=1; i<=facilities.size(); i++){
                
                reqMap.put('Facility_Name', Utility.getBlankStringIfNull(facilities[i-1].CL_Product__r.clcommon__Product_Name__c));
                reqMap.put('Each_Facility_Limit_Amount', Utility.getBlankStringIfNull(String.valueOf(facilities[i-1].Recommended_Limit__c)));
                
                if((facilities[i-1].Balance_Outstandings__c)!= null){
                    if((facilities[i-1].Balance_Outstandings__c) < 0){
                        bal_Outstanding = (facilities[i-1].Balance_Outstandings__c) * (-1);
                        reqMap.put('EOD_Balance_Facility_Amount', Utility.getBlankStringIfNull(String.valueOf(bal_Outstanding)));
                    }
                    else reqMap.put('EOD_Balance_Facility_Amount', Utility.getBlankStringIfNull(String.valueOf((facilities[i-1].Balance_Outstandings__c))));
                }
                else reqMap.put('EOD_Balance_Facility_Amount', '');
                
                reqMap.put('EOD_Balance_Facility_Amount_in_words', Utility.getBlankStringIfNull(String.valueOf(noTowrd.getNumberTOWordConvertion(math.abs(facilities[i-1].Balance_Outstandings__c)))));
                if((facilities[i-1].Limit_end_date__c) != NULL){
                    
                    reqMap.put('EOD_Date_DD/MM/YYY', Utility.getBlankStringIfNull(String.valueOf(facilities[i-1].Last_EOD_Date__c)));
                }
                else{
                    reqMap.put('EOD_Date_DD/MM/YYY', '');
                }
            }
        }    
        req.inputVariables.inputmap = reqMap;
        return req;
    }
    
    /* C-8_V1_Doc */
    public static SMESanction_DocReq generate_C_8_Doc(genesis__Applications__c appln, String templateId){
        
        SMESanction_DocReq req = new SMESanction_DocReq();
        req.inputVariables      = new SMESanction_DocReq.cls_inputVariables();
        req.owner_tenantId      = 'cuecent_tenant';
        req.exe_tenantId        = 'cuecent_tenant';
        //Newly Tag added for DMS
        req.applicationType     = appln.RecordType.DeveloperName;
        req.applicationId       = appln.Id;
        req.customerId          = '';
        req.documentType        = templateId;
        req.accountNumbers      = '';
        req.fileName            = '';
        req.uuid                = '';
        
        req.inputVariables.unique_key           = templateId;
        req.inputVariables.pdf_unique_key       = appln.Id;
        req.inputVariables.in_msg               = '';
        req.inputVariables.inputmap             = new Map<String,String>();
        req.inputVariables.inputMapForB1        = new Map<String,Object>();

        //Final Map for sending the tags along with its values to Digio
        Map<String,String> reqMap               = new Map<String,String>();

        String address4 = '';
        String BORROWER_WITH_ADDRESS = '';
        if(appln != null){
            if((appln.genesis__Account__r.Name)!=null && (appln.genesis__Account__r.BillingStreet)!=null && (appln.genesis__Account__r.BillingCity)!=null && 
               (appln.genesis__Account__r.BillingState)!=null && (appln.genesis__Account__r.BillingPostalCode)!=null && (appln.genesis__Account__r.BillingCountry)!=null){
                   
                   BORROWER_WITH_ADDRESS    = Utility.getBlankStringIfNull(appln.genesis__Account__r.Name)+', '+'Address : '+
                       Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingStreet)+','+
                       Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingCity)+','+
                       Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingState)+','+
                       Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingPostalCode)+','+
                       Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingCountry);
               }
        }

        NumberToWordConversion noTowrd          = new NumberToWordConversion();
        
        
        List<genesis__Application_Parties__c> parties = new List<genesis__Application_Parties__c>();
        try{
            parties = [SELECT Id,genesis__Application__c,Guarantor__c,genesis__Party_Type__c,genesis__Party_Account_Name__c,Signatories__c,genesis__Party_Account_Name__r.Name,
                       Active__c,genesis__Party_Account_Name__r.Age__c,genesis__Party_Account_Name__r.Father_Name__pc,genesis__Party_Account_Name__r.PersonMailingStreet,
                       genesis__Party_Account_Name__r.PersonMailingCity,genesis__Party_Account_Name__r.PersonMailingState,genesis__Party_Account_Name__r.PersonMailingPostalCode,
                       genesis__Party_Account_Name__r.PersonMailingCountry,Relationship_to_Borrower__c,genesis__Party_Account_Name__r.Aadhaar_Number__pc,
                       genesis__Party_Account_Name__r.PersonMobilePhone,Identifier__c,Signer_page_no__c 
                       FROM genesis__Application_Parties__c WHERE genesis__Application__c =: appln.Id AND Signatories__c = true AND Active__c = true];
        }catch(QueryException e){}
        
        
        Map<Integer,String> guarantor_Map = new Map<Integer,String>();
        Map<Integer,String> address_Map1  = new Map<Integer,String>();
        Map<Integer,String> address_Map2  = new Map<Integer,String>();
        Map<Integer,String> address_Map3  = new Map<Integer,String>();
        Map<Integer,String> address_Map4  = new Map<Integer,String>();
        Map<Integer,String> address_Map5  = new Map<Integer,String>();
        
        for(Integer i=1; i<5; i++){
            
            guarantor_Map.put(i, 'Guarantor_'+i+'_Name1');
            reqmap.put('Guarantor_'+i+'_Name1', '');
            
            address_Map1.put(i, 'Guarantor_'+i+'_Address1');
            reqmap.put('Guarantor_'+i+'_Address1', '');
            
            address_Map2.put(i, 'Guarantor_'+i+'_Address2');
            reqmap.put('Guarantor_'+i+'_Address2', '');
            
            address_Map3.put(i, 'Guarantor_'+i+'_Address3');
            reqmap.put('Guarantor_'+i+'_Address3', '');
            
            address_Map4.put(i, 'Guarantor_'+i+'_Address4');
            reqmap.put('Guarantor_'+i+'_Address4', '');
            
            address_Map5.put(i, 'Guarantor_'+i+'_Address5');
            reqmap.put('Guarantor_'+i+'_Address5', '');
        }
        
        
        if(! parties.isEmpty()){
            for(Integer i=1; i<=parties.size(); i++){
                
                if(parties[i-1].genesis__Party_Type__c == 'Partner' || parties[i-1].genesis__Party_Type__c == 'Director' || parties[i-1].genesis__Party_Type__c == 'Guarantor' ){
                    
                    if(guarantor_Map.containsKey(i)){
                        reqMap.put(guarantor_Map.get(i), +'Mr./Ms./M/s. '+ Utility.getBlankStringIfNull(parties[i-1].genesis__Party_Account_Name__r.Name));
                    }
                    if(address_Map1.containsKey(i)){
                        reqMap.put(address_Map1.get(i), Utility.getBlankStringIfNull(parties[i-1].genesis__Party_Account_Name__r.PersonMailingStreet));
                    }
                    if(address_Map2.containsKey(i)){
                        reqMap.put(address_Map2.get(i), Utility.getBlankStringIfNull(parties[i-1].genesis__Party_Account_Name__r.PersonMailingCity));
                    }
                    if(address_Map3.containsKey(i)){
                        reqMap.put(address_Map3.get(i), Utility.getBlankStringIfNull(parties[i-1].genesis__Party_Account_Name__r.PersonMailingState));
                    }
                    if(address_Map4.containsKey(i)){
                        reqMap.put(address_Map4.get(i), Utility.getBlankStringIfNull(parties[i-1].genesis__Party_Account_Name__r.PersonMailingPostalCode));
                    }
                    if(address_Map5.containsKey(i)){
                        reqMap.put(address_Map4.get(i), Utility.getBlankStringIfNull(parties[i-1].genesis__Party_Account_Name__r.PersonMailingCountry));
                    }
                }
            }
        }
        if(BORROWER_WITH_ADDRESS!=null){
            reqMap.put('Borrower_Name_with_address', Utility.getBlankStringIfNull(BORROWER_WITH_ADDRESS));
        }
        else reqMap.put('Borrower_Name_with_address', '');
        reqMap.put('Branch_name', Utility.getBlankStringIfNull(appln.Branch_Name__c));
        
        if(appln != null && (appln.Branch_Code__c)!= null){
            String temp = appln.Branch_Code__c;
            reqMap.put('Branch_City', Utility.getBlankStringIfNull(getBranchCity(temp)));
        }
        else reqMap.put('Branch_City', '');
        
        List<Facility__c> facilities                = new List<Facility__c>();
        If(appln != null){
            try{
                facilities                          = [SELECT Id,Last_EOD_Date__c,Recommended_Rate__c,Limit_end_date__c,Final_Spread__c,Margin__c,Existing_Margin_Receivables__c,Existing_Margin_Stock_Manufacturing__c,Existing_Limit__c,Existing_Margin_Stock_Trading__c,New_Limit_Amount__c,MCLR_Rate__c,Nature_of_Document__c,Date_of_Document__c,Recommended_Limit__c,CL_Product__c,Existing_Rate__c,Application__c,CL_Product__r.clcommon__Product_Name__c,Loan_Purpose__c,Recommended_Processing_Charge__c,Recommended_Days__c,Interest_Type__c,Type__c,Approved_Margin__c,CL_Product__r.Facility_Category__c,Processing_Charge__c,Existing_Processing_Charge__c,Margin_Stock_Trading__c,BRE_Limit__c,BRE_Rate__c,BRE_Spread__c,Variance__c,Margin_Receivables__c,Margin_Stock_Manufacturing__c,Balance_Outstandings__c,Guarantee_Date__c,Account_Number__c
                                                       FROM Facility__c WHERE Application__c =: appln.Id LIMIT 1];
            }catch(Exception evar){}   
        }
        If(! facilities.isEmpty()){
            for(Integer i=1; i<=facilities.size(); i++){
                Decimal bal_Outstanding = 0;
                if((facilities[i-1].Balance_Outstandings__c)!= null){
                    if((facilities[i-1].Balance_Outstandings__c) < 0){
                        bal_Outstanding = (facilities[i-1].Balance_Outstandings__c) * (-1);
                        reqMap.put('EOD_Balance_Facility_Amount', Utility.getBlankStringIfNull(String.valueOf(bal_Outstanding)));
                    }
                    else reqMap.put('EOD_Balance_Facility_Amount', Utility.getBlankStringIfNull(String.valueOf((facilities[i-1].Balance_Outstandings__c))));
                }
                else reqMap.put('EOD_Balance_Facility_Amount', '');
                reqMap.put('EOD_Balance_Facility_Amount_in_words', Utility.getBlankStringIfNull(String.valueof(noTowrd.getNumberTOWordConvertion(math.abs(facilities[i-1].Balance_Outstandings__c)))));                
                if((facilities[i-1].Limit_end_date__c) != NULL){
                    
                    reqMap.put('EOD_Date_DD/MM/YYY', Utility.getBlankStringIfNull(String.valueOf(facilities[i-1].Last_EOD_Date__c)));
                }
                else{
                    reqMap.put('EOD_Date_DD/MM/YYY', '');
                }
                reqMap.put('Guarantee_Date', Utility.getBlankStringIfNull(formatDate(facilities[i-1].Guarantee_Date__c)));
                reqMap.put('Existing_Limit_Amount', Utility.getBlankStringIfNull(String.valueOf(facilities[i-1].Existing_Limit__c)));
            }
        }
        reqMap.put('Disb_Date', Utility.getBlankStringIfNull((System.now()).format('dd-MM-yyyy')));
        req.inputVariables.inputmap = reqMap;
        return req;
    }
    
    
    /* C-9_Doc */
    public static SMESanction_DocReq generate_C_9_Doc(genesis__Applications__c appln, String templateId){
        
        SMESanction_DocReq req  = new SMESanction_DocReq();
        req.inputVariables      = new SMESanction_DocReq.cls_inputVariables();
        req.owner_tenantId      = 'cuecent_tenant';
        req.exe_tenantId        = 'cuecent_tenant';
        //Newly Tag added for DMS
        req.applicationType     = appln.RecordType.DeveloperName;
        req.applicationId       = appln.Id;
        req.customerId          = '';
        req.documentType        = templateId;
        req.accountNumbers      = '';
        req.fileName            = '';
        req.uuid                = '';
        
        req.inputVariables.unique_key           = templateId;
        req.inputVariables.pdf_unique_key       = appln.Id;
        req.inputVariables.in_msg               = '';
        req.inputVariables.inputmap             = new Map<String,String>();
        req.inputVariables.inputMapForB1        = new Map<String,Object>();

        //Final Map for sending the tags along with its values to Digio
        Map<String,String> reqMap               = new Map<String,String>();

        NumberToWordConversion noTowrd          = new NumberToWordConversion();
        String address4 = '';
        reqMap.put('Borrower_Name', Utility.getBlankStringIfNull(appln.genesis__Account__r.Name));
        reqMap.put('Borrower_Address_1', Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingStreet));
        reqMap.put('Borrower_Address_2', Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingCity));
        reqMap.put('Borrower_Address_3', Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingState));
        reqMap.put('Borrower_Address_4', Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingPostalCode));
        reqMap.put('Borrower_Address_5', Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingCountry));
        reqMap.put('Branch_name', Utility.getBlankStringIfNull(appln.Branch_Name__c)); 
        
        if(appln != null && (appln.Branch_Code__c)!= null){
            String temp = appln.Branch_Code__c;
            reqMap.put('Branch_City', Utility.getBlankStringIfNull(getBranchCity(temp)));
        }
        else reqMap.put('Branch_City', '');
        
        reqMap.put('Disb_Date', Utility.getBlankStringIfNull((System.now()).format('dd-MM-yyyy')));
        
        List<Facility__c> facilities                = new List<Facility__c>();
        If(appln != null){
            try{
                facilities                          = [SELECT Id,Limit_Amount__c,Recommended_Limit__c,CL_Product__r.clcommon__Product_Name__c,Application__c 
                                                       FROM Facility__c WHERE Application__c =: appln.Id LIMIT 1];
            }catch(Exception evar){}   
        }
        If(! facilities.isEmpty()){
            for(Integer i=1; i<=facilities.size(); i++){
                reqMap.put('Facility_Type_1', Utility.getBlankStringIfNull(String.valueOf(facilities[i-1].CL_Product__r.clcommon__Product_Name__c)));
                reqMap.put('Final_Limit1', Utility.getBlankStringIfNull(String.valueOf(facilities[i-1].Recommended_Limit__c)));
                if(facilities[i-1].Recommended_Limit__c != null)
                    reqMap.put('Final_Limit1_in_words', Utility.getBlankStringIfNull(noTowrd.getNumberTOWordConvertion(math.abs(facilities[i-1].Recommended_Limit__c))));
                else reqMap.put('Final_Limit1_in_words', '');
            }
        }
        
        req.inputVariables.inputmap = reqMap;
        return req;
    }
    
    
    /*  Exceeding Sanction Letter  */
    public static SMESanction_DocReq generate_Exceeding_AdHoc_SanctionLetter(genesis__Applications__c appln, String templateId){

        System.debug('applnId:::: ' + appln.Id);
        System.debug('templateId:::: ' + templateId);
        
        Decimal exceedingPrChrgAmt              = 0.0;
        Decimal totalAMT                        = 0.0;
        Decimal gstCharge                       = 0.0;
        Decimal exceedingProcessChargeGST       = 0.0;
        Decimal processChrageTotal              = 0.0;
        Decimal docChharge                      = 0.0;
        Decimal ROI                             = 0.0;

        String MODTLno          = 'MODTL '+'('+'Additional Charge'+')'+' on the existing security property/'+'ies is waived to you as a special case.';
        String MODTLyes         = 'You shall create MODTL on the existing security property /'+'ies';
        String Ref_No           = '';
        String str1             = 'Interest will be charged @';
        String str2             = '% which is ';
        String str3             = '% over and above the MCL Rate of the Bank, compounded at monthly rests';
        decimal overallExpo     = 0.0;

        SMESanction_DocReq req  = new SMESanction_DocReq();
        req.inputVariables      = new SMESanction_DocReq.cls_inputVariables();
        req.owner_tenantId      = 'cuecent_tenant';
        req.exe_tenantId        = 'cuecent_tenant';
        //Newly Tag added for DMS
        req.applicationType     = appln.RecordType.DeveloperName;
        req.applicationId       = appln.Id;
        req.customerId          = '';
        req.documentType        = templateId;
        req.accountNumbers      = '';
        req.fileName            = '';
        req.uuid                = '';
        
        req.inputVariables.unique_key           = templateId;
        req.inputVariables.pdf_unique_key       = appln.Id;
        req.inputVariables.in_msg               = '';
        req.inputVariables.inputmap             = new Map<String,String>();
        req.inputVariables.inputMapForB1        = new Map<String,Object>();


        Map<String,String>  reqMap              = new Map<String,String>();

        Map<Integer,String> facilty_NatureMap   = new Map<Integer,String>();
        Map<Integer,String> amountMap           = new Map<Integer,String>();
        Map<Integer,String> rateOfIntrstMap     = new Map<Integer,String>();
        Map<Integer,String> existingRate_Map    = new Map<Integer,String>();
        Map<Integer,String> final_Spread_Map    = new Map<Integer,String>();
        
        currentYear                 = String.valueOf(Utility.getCurrentYear());
        reqMap.put('Branch_Name', Utility.getBlankStringIfNull(appln.Branch_Name__c));
        if(appln != null && (appln.Branch_Code__c)!= null){
            String temp = appln.Branch_Code__c;
            reqMap.put('Branch_City', Utility.getBlankStringIfNull(getBranchCity(temp)));
        }
        else reqMap.put('Branch_City', '');
        if(appln != null){
            Ref_No = Utility.getBlankStringIfNull(appln.Branch_Code__c)+'/'+Utility.getBlankStringIfNull(appln.Name)+'/'+currentYear;
        }
        reqMap.put('Branch_Code/Appln_No/Year', Utility.getBlankStringIfNull(Ref_No));
        reqMap.put('Branch_Code', Utility.getBlankStringIfNull(appln.Branch_Code__c));
        reqMap.put('San_Ref_Date', Utility.getBlankStringIfNull((System.now()).format('dd-MM-yyyy')));
        reqMap.put('Borrower_Name', Utility.getBlankStringIfNull(appln.genesis__Account__r.Name));
        reqMap.put('Borrower_Address_1', Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingStreet));
        reqMap.put('Borrower_Address_2', Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingCity));
        reqMap.put('Borrower_Address_3', Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingState));
        reqMap.put('Borrower_Address_4', Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingPostalCode));
        reqMap.put('Borrower_Address_5', Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingCountry));
        reqMap.put('No_Of_days', Utility.getBlankStringIfNull(String.valueOf(appln.EAE_Renewal_Date_in_days__c)));
        reqMap.put('Processing_Amount', '');
        for(Integer i=1; i<4; i++){
            facilty_NatureMap.put(i, 'Facility_Type_'+i);
            reqMap.put('Facility_Type_'+i, '');
            amountMap.put(i, 'Amount_'+i);
            reqMap.put('Amount_'+i, '');
            rateOfIntrstMap.put(i, 'ROI_'+i);
            reqMap.put('ROI_'+i, '');
            existingRate_Map.put(i, 'Existing_Rate_'+i);
            reqMap.put('Existing_Rate_'+i, '');
            final_Spread_Map.put(i, 'Final_Spread'+i);
            reqMap.put('Final_Spread'+i, '');
        }
        List<Facility__c>   facilities      = new List<Facility__c>();
        try{
            facilities                      = [SELECT Id,Recommended_Rate__c,Final_Spread__c,Margin__c,Existing_Margin_Receivables__c,Existing_Margin_Stock_Manufacturing__c,
                                               Existing_Limit__c,Existing_Margin_Stock_Trading__c,New_Limit_Amount__c,MCLR_Rate__c,Nature_of_Document__c,Date_of_Document__c,
                                               Recommended_Limit__c,CL_Product__c,Existing_Rate__c,Application__c,CL_Product__r.clcommon__Product_Name__c,Loan_Purpose__c,
                                               Recommended_Processing_Charge__c,Recommended_Days__c,Interest_Type__c,Type__c,Approved_Margin__c,
                                               CL_Product__r.Facility_Category__c,Processing_Charge__c,Existing_Processing_Charge__c,Margin_Stock_Trading__c,BRE_Limit__c,
                                               BRE_Rate__c,BRE_Spread__c,Variance__c,Existing_Spread__c,Margin_Receivables__c,Margin_Stock_Manufacturing__c,Balance_Outstandings__c,
                                               Guarantee_Date__c,Account_Number__c,Application__r.genesis__Account__r.Overall_Exposure__c
                                               FROM Facility__c WHERE Application__c =: appln.Id];
            System.debug(appln.Id);
            System.debug(' Faclist size ' + facilities.size());
        }catch(Exception evar){}
        List<genesis__Application_Parties__c> parties = new List<genesis__Application_Parties__c>();
        try{
            parties                                   = [SELECT Id,genesis__Application__c,Guarantor__c,genesis__Party_Account_Name__c,Signatories__c,genesis__Party_Account_Name__r.Name,Active__c,genesis__Party_Account_Name__r.Age__c,genesis__Party_Account_Name__r.Father_Name__pc,genesis__Party_Account_Name__r.PersonMailingStreet,genesis__Party_Account_Name__r.PersonMailingCity,genesis__Party_Account_Name__r.PersonMailingState,genesis__Party_Account_Name__r.PersonMailingPostalCode,Relationship_to_Borrower__c,genesis__Party_Account_Name__r.Aadhaar_Number__pc,genesis__Party_Account_Name__r.PersonMobilePhone,Identifier__c,Signer_page_no__c,llx__c,lly__c,urx__c,ury__c,genesis__Party_Type__c
                                                         FROM genesis__Application_Parties__c WHERE genesis__Application__c =: appln.Id 
                                                         AND Signatories__c= true AND Active__c = true];
        }catch(Exception evar){}
        If(! facilities.isEmpty()){
            for(Integer i=1; i<= facilities.size(); i++){
                If(facilty_NatureMap.containsKey(i)){
                    reqMap.put(facilty_NatureMap.get(i), Utility.getBlankStringIfNull(facilities[i-1].CL_Product__r.clcommon__Product_Name__c));
                }
                If(amountMap.containsKey(i)){
                    reqMap.put(amountMap.get(i), Utility.getBlankStringIfNull(String.valueOf(facilities[i-1].Recommended_Limit__c)));
                }
                /* Rate of Interest (%) /Commission  */
                If(rateOfIntrstMap.containsKey(i)){
                    //reqMap.put(rateOfIntrstMap.get(i), +'3% over and above existing '+Utility.getBlankStringIfNull(String.valueOf(facilities[i-1].Existing_Rate__c))+'%');
                    if((facilities[i-1].MCLR_Rate__c) != null && (facilities[i-1].Existing_Spread__c) != null){
                        ROI = ((facilities[i-1].MCLR_Rate__c) + (facilities[i-1].Existing_Spread__c));
                        reqMap.put(rateOfIntrstMap.get(i), +'3% over and above existing '+Utility.getBlankStringIfNull(String.valueOf(ROI))+'%');
                    }
                    else reqMap.put(rateOfIntrstMap.get(i), '');
                }
                /* ROI Clause */
                If(existingRate_Map.containsKey(i)){
                    //reqMap.put(existingRate_Map.get(i), +str1+Utility.getBlankStringIfNull(String.valueOf((facilities[i-1].Existing_Rate__c )+3))+str2);
                    if((facilities[i-1].Recommended_Rate__c ) != null){
                        reqMap.put(existingRate_Map.get(i), +str1+Utility.getBlankStringIfNull(String.valueOf(facilities[i-1].Recommended_Rate__c ))+str2);
                    }
                    else reqMap.put(existingRate_Map.get(i), '');
                }
                If(final_Spread_Map.containsKey(i)){
                    if((facilities[i-1].Final_Spread__c) != null){
                        reqMap.put(final_Spread_Map.get(i), Utility.getBlankStringIfNull(String.valueOf(facilities[i-1].Final_Spread__c))+str3);
                    }
                    else reqMap.put(final_Spread_Map.get(i), '');
                }
                /* Processing Fee Calculation */
                if((facilities[i-1].Recommended_Limit__c) != NULL){
                    totalAMT += facilities[i-1].Recommended_Limit__c;
                    overallExpo = facilities[i-1].Application__r.genesis__Account__r.Overall_Exposure__c;
                }
                gstCharge               = KVB_Company_Details__c.getOrgDefaults().GST__c;
                if(appln.Sanction_Authority__c != NULL && appln.Sanction_Authority__c.contains('BR_MGR')){
                    if(appln.genesis__Account__r.Priority_Sector__c == TRUE && overallExpo < 500000){
                        reqMap.put('Processing_Amount', Utility.getBlankStringIfNull(String.valueOf(appln.Processing_Charges__c)));
                    }
                    else{
                        exceedingPrChrgAmt              = appln.Processing_Charges__c;
                        exceedingProcessChargeGST       = ((exceedingPrChrgAmt * gstCharge)/100).setscale(2);
                        processChrageTotal              = (exceedingPrChrgAmt + exceedingProcessChargeGST).setscale(2);
                        reqMap.put('Processing_Amount', Utility.getBlankStringIfNull(String.valueOf(processChrageTotal)));
                    }
                }
                else if(appln.genesis__Account__r.Priority_Sector__c == TRUE && overallExpo < 500000){
                    reqMap.put('Processing_Amount', Utility.getBlankStringIfNull(String.valueOf(appln.Processing_Charges__c)));
                }
                else{

                    exceedingPrChrgAmt              = appln.Processing_Charges__c > 0 ? appln.Processing_Charges__c : 0.00;
                    exceedingProcessChargeGST       = ((exceedingPrChrgAmt * gstCharge)/100).setscale(2);
                    processChrageTotal              = (exceedingPrChrgAmt + exceedingProcessChargeGST).setscale(2);
                    reqMap.put('Processing_Amount', Utility.getBlankStringIfNull(String.valueOf(processChrageTotal)));
                }
            }
        }    
        reqMap.put('No_Of_days', Utility.getBlankStringIfNull(String.valueOf(appln.EAE_Renewal_Date_in_days__c)));
        If(appln.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_EXCEEDING){
            reqMap.put('Exceeding/AdHoc','Exceeding'); 
        }
        /*else If(appln.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC){
            reqMap.put('Exceeding/AdHoc','AdHoc'); 
        }*/
        If(appln.MODTL_Required__c == 'No'){
            reqMap.put('MODTL_NO', Utility.getBlankStringIfNull(MODTLno));
            reqMap.put('MODTL_Yes', '');
        }
        else{
            reqMap.put('MODTL_Yes', Utility.getBlankStringIfNull(MODTLyes));
            reqMap.put('MODTL_NO', '');
        }
        Map<Integer,String> partyTypeMap = new Map<Integer,String>();
        Map<Integer,String> signatoryMap = new Map<Integer,String>();
        Map<Integer,String> brrwsignMap  = new Map<Integer,String>();
        
        for(Integer i=1;i<11;i++){
            partyTypeMap.put(i, 'Auth_Signatory_Type'+i);
            signatoryMap.put(i, 'Auth_Signatory'+i);
            brrwsignMap.put(i, 'Borrower_Guar_Sign'+i);
            reqMap.put('Auth_Signatory_Type'+i, '');
            reqMap.put('Auth_Signatory'+i, '');
            reqMap.put('Borrower_Guar_Sign'+i, '');
        }
        If(! parties.isEmpty()){
            Integer partyCount =1;
            for(Integer i=1; i<=parties.size(); i++){
                If(signatoryMap.containsKey(partyCount) && parties[i-1].genesis__Party_Account_Name__c != null){
                    reqMap.put(partyTypeMap.get(partyCount),Utility.getBlankStringIfNull(parties[i-1].genesis__Party_Type__c));
                    reqMap.put(signatoryMap.get(partyCount),Utility.getBlankStringIfNull(parties[i-1].genesis__Party_Account_Name__r.Name));
                }
                partyCount++;
            }
        }
        reqMap.put('Auth_Signatory_Bnk', 'KVB Bank');
        reqMap.put('Bnk_Auth_Sign', '');
        req.inputVariables.inputmap = reqMap;
        //System.debug('From Method req :::: ' + req);
        return req;
    }
    
    /*  Digital-GCFA C1 v.01 (Sanction Document) */
    public static SMESanction_DocReq generate_Digital_GCFA_C1_v1(genesis__Applications__c appln, String templateId){
        try{

            SMESanction_DocReq req  = new SMESanction_DocReq();
            req.inputVariables      = new SMESanction_DocReq.cls_inputVariables();
            req.owner_tenantId      = 'cuecent_tenant';
            req.exe_tenantId        = 'cuecent_tenant';
            //Newly Tag added for DMS
            req.applicationType     = appln.RecordType.DeveloperName;
            req.applicationId       = appln.Id;
            req.customerId          = '';
            req.documentType        = templateId;
            req.accountNumbers      = '';
            req.fileName            = '';
            req.uuid                = '';
            
            req.inputVariables.unique_key           = templateId;
            req.inputVariables.pdf_unique_key       = appln.Id;
            req.inputVariables.in_msg               = '';
            req.inputVariables.inputmap             = new Map<String,String>();
            req.inputVariables.inputMapForB1        = new Map<String,Object>();

            Boolean flag                    = false;
            Boolean forexAdvanceFlag        = false;

            Decimal enhPrCharge             = 0.0;
            Decimal totalAMT                = 0.0;
            Decimal gstCharge               = 0.0;
            Decimal processChargeGST        = 0.0;
            Decimal processChrageTotal      = 0.0;
            Decimal docCharge               = 0.0;
            Decimal docChargeGST            = 0.0;
            Decimal docChrageTotal          = 0.0;
            Decimal cibilCharge             = 0.0;
            Decimal cibilChargeGST          = 0.0;
            Decimal cibilChargeTotal        = 0.0;
            Decimal finalProcessingFee      = 0.0;
            
            String str1     = 'Interest will be charged @';
            String str2     = '% which is ';
            String str3     = '% over and above the MCL Rate of the Bank, compounded at monthly rests';
            String Ref_No   = '';
            
            String margin           = '';
            String mailingAddress   = '';
            String forexcontent     = '';
            String corpAdv          = '';

            //Final Map for sending the tags along with its values to Digio
            Map<String,String> reqMap                   = new Map<String,String>();

            Map<Integer,String> facilty_NatureMap       = new Map<Integer,String>();
            Map<Integer,String> finalLimitMap           = new Map<Integer,String>();
            Map<Integer,String> marginMap               = new Map<Integer,String>();
            Map<Integer,String> rate_Of_Intrst_Map      = new Map<Integer,String>();
            Map<Integer,String> prim_Sec_Map            = new Map<Integer,String>();
            Map<Integer,String> coll_Sec_Map            = new Map<Integer,String>();
            Map<Integer,String> loan_purpose_Map        = new Map<Integer,String>();
            Map<Integer,String> roiMap                  = new Map<Integer,String>();
            Map<Integer,String> varianceMap             = new Map<Integer,String>();
            Map<Integer,String> auth_Sign_Guarnt_Map    = new Map<Integer,String>();
            Map<Integer,String> auth_Sign_Borrow_Map    = new Map<Integer,String>();
            Map<Integer,String> spl_Sanction_Map        = new Map<Integer,String>();
            Map<Integer,String> mclr_Map                = new Map<Integer,String>();
            Map<Integer,String> loan_Validity_Map       = new Map<Integer,String>();

            
            List<Security_Text__mdt> securityText   = new List<Security_Text__mdt>();
            securityText                            = [SELECT Application_Id__c,COLLATERAL_SECURITY__c,PRIMARY_SECURITY__c FROM Security_Text__mdt LIMIT 1];
            
            PENAL_RATE                                  = string.valueof(KVB_Company_Details__c.getOrgDefaults().Penal_Interest__c.setscale(2));
            securtiyDetails                             = new Map<String,String>();
            securtiyDetails                             = SanctionMatrix_Helper.getSecurityDetails(appln.Id);
            currentYear                                 = String.valueOf(Utility.getCurrentYear());
            
            if(appln != null){
                Ref_No = Utility.getBlankStringIfNull(appln.Branch_Code__c)+'/'+Utility.getBlankStringIfNull(appln.Name)+'/'+currentYear;
            }
            
            mailingAddress = Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingPostalCode)+'\n'+Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingCountry);
            
            reqMap.put('Branch_Code/Appln_No/Year', Utility.getBlankStringIfNull(Ref_No));
            reqMap.put('Borrower_Name', Utility.getBlankStringIfNull(appln.genesis__Account__r.Name));
            reqMap.put('Borrower_Address1', Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingStreet));
            reqMap.put('Borrower_Address2', Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingCity));
            reqMap.put('Borrower_Address3', Utility.getBlankStringIfNull(appln.genesis__Account__r.BillingState));
            
            if(mailingAddress != null) reqMap.put('Borrower_Address4', Utility.getBlankStringIfNull(mailingAddress));
            else reqMap.put('Borrower_Address4', '');
            
            reqMap.put('Branch_name', Utility.getBlankStringIfNull(appln.Branch_Name__c));
            reqMap.put('Branch_Code', Utility.getBlankStringIfNull(appln.Branch_Code__c));
            if(appln != null && (appln.Branch_Code__c)!= null){
                reqMap.put('Branch_City', Utility.getBlankStringIfNull(getBranchCity(appln.Branch_Code__c)));
            }
            else reqMap.put('Branch_City', '');
            
            reqMap.put('Upfront_Fee', Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Total_Upfront_Payments__c)));
            reqMap.put('Penal_Interest_Rate2',  Utility.getBlankStringIfNull(PENAL_RATE));
            reqMap.put('San_Ref_Date', Utility.getBlankStringIfNull(appln.San_Ref_Date__c));
            reqMap.put('Penal_Interest_Rate4', Utility.getBlankStringIfNull(PENAL_RATE));
            reqMap.put('Penal_Interest_Rate5', Utility.getBlankStringIfNull(PENAL_RATE));
            reqMap.put('Penal_Interest_Rate7', Utility.getBlankStringIfNull(PENAL_RATE));
            reqMap.put('Disb_date', Utility.getBlankStringIfNull(formatDate(System.today())));
            //reqMap.put('Appl_Ref_Date', Utility.getBlankStringIfNull((System.now()).format('dd-MM-yyyy')));
            reqMap.put('Appl_Ref_Date', Utility.getBlankStringIfNull(formatDate((appln.CreatedDate).date())));
            reqMap.put('Con_Speci_Export_Cred_Facilities', '');
            reqMap.put('FORX_ADV_TNC_EAE', '');
            reqMap.put('CORP_ADV_TNC_EAE', '');
            
            Map<Id,Audit__C> facTermsCondMap;
            try{
                facTermsCondMap = new Map<Id,Audit__C>([Select id,Facility_Category__c,Seq_No__c,Terms_and_Conditions__c 
                                                        from Audit__C where RecordType.DeveloperName ='Facility_Term_and_Condition' order by Seq_No__c]);  
            }catch(QueryException e){}
            
            // For Dynamic Paragraph Generation Based On Facility Type
            /*** Start ***/
            facilityTC  = new Map<String, String>();
            for(String s : facTermsCondMap.keySet()){
                Decimal seq = facTermsCondMap.get(s).Seq_No__c;
                if(facilityTC.containsKey(facTermsCondMap.get(s).Facility_Category__c)){
                    string tempTC = facilityTC.get(facTermsCondMap.get(s).Facility_Category__c)+'\n'+String.valueOf(seq)+'. '+facTermsCondMap.get(s).Terms_and_Conditions__c;
                    facilityTC.put(facTermsCondMap.get(s).Facility_Category__c,tempTC);
                }
                else{
                    facilityTC.put(facTermsCondMap.get(s).Facility_Category__c, String.valueOf(seq)+'. '+facTermsCondMap.get(s).Terms_and_Conditions__c);
                }            
            }
            /*** End ***/
            
            List<Facility__c> facilities = new List<Facility__c>();
            try{
                facilities  = [SELECt id,Application__c,Renewal_Processing_Charge__c,Facility_Application_Type__c,Final_Enhanced_Processing_Fee__c,Limit_Amount__c,Existing_Enhanced_Processing_Fee__c,CL_Product__c,CL_Product__r.clcommon__Product_Name__c,Loan_Purpose__c,
                               Recommended_Processing_Charge__c,Recommended_Days__c,Margin__c,MCLR_Rate__c,Interest_Type__c,Type__c,Approved_Margin__c,
                               CL_Product__r.Facility_Category__c,Processing_Charge__c,Existing_Processing_Charge__c,Margin_Stock_Trading__c,Recommended_Limit__c,
                               Recommended_Rate__c,BRE_Limit__c,BRE_Rate__c,BRE_Spread__c,Final_Spread__c,Variance__c,Existing_Limit__c,Margin_Receivables__c,
                               Margin_Stock_Manufacturing__c,Industry__c,Limit_end_date__c,New_Limit_Amount__c,application__r.Renewal_Due_Date__c,
                               (SELECT id,genesis__Collateral__c,genesis__Collateral__r.recordType.DeveloperName,genesis__Collateral__r.Surrender_Value__c,
                                genesis__Collateral__r.clcommon__Value__c,genesis__Collateral__r.MORT_TYPE__c,genesis__Collateral__r.Collateral_Type__c,
                                genesis__Collateral__r.clcommon__Collateral_Type__c,genesis__Collateral__r.clcommon__Policy_Number__c,genesis__Collateral__r.Vehicle_Number__c,
                                genesis__Collateral__r.Machinery_Model__c,genesis__Collateral__r.clcommon__Collateral_Name__c,Security_Type__c,genesis__Collateral__r.Security_Details__c,
                                genesis__Collateral__r.clcommon__Collateral_Category__c,genesis__Collateral__r.clcommon__Collateral_Category__r.Name,Facility__c,Facility__r.CL_Product__r.Facility_Category__c 
                                FROM Facility_Security__r) FROM Facility__c WHERE Application__c =: appln.Id AND Active__c = true];
            }catch(Exception evar){}
            
            List<genesis__Application_Parties__c> parties = new List<genesis__Application_Parties__c>();
            try{
                parties                                   = [SELECT Id,genesis__Application__c,Guarantor__c,genesis__Party_Account_Name__c,Signatories__c,
                                                             genesis__Party_Account_Name__r.Name,genesis__Party_Account_Name__r.Pan_Number__c,
                                                             genesis__Party_Account_Name__r.PersonEmail,genesis__Party_Account_Name__r.PersonMobilePhone,
                                                             genesis__Party_Account_Name__r.Aadhaar_Number__pc,genesis__Party_Type__c,Active__c
                                                             FROM genesis__Application_Parties__c WHERE genesis__Application__c =: appln.Id 
                                                             AND Signatories__c= true AND Active__c = true];
            }catch(Exception evar){}
            
            try{
                forexcontent = SMESanction_DocReq.getForexAdvTnCEAE();
            }catch(Exception e){
                System.debug('Exception in eDoc generation2 '+e.getMessage());
                System.debug('Exception in eDoc Stack2 '+e.getStackTraceString());
                System.debug('Exception in eDoc LineNumber2 '+e.getLineNumber());
                System.debug('Exception in eDoc Cause2 '+e.getCause());
            }
            
            try{
                corpAdv  = SMESanction_DocReq.getcorpAdvTnCEAE();
            }catch(Exception e){
                System.debug('Exception in eDoc generation1 '+e.getMessage());
                System.debug('Exception in eDoc Stack1 '+e.getStackTraceString());
                System.debug('Exception in eDoc LineNumber1 '+e.getLineNumber());
                System.debug('Exception in eDoc Cause1 '+e.getCause());
            }
            
            for(Integer i=1; i<6; i++){
                facilty_NatureMap.put(i, 'Facility_Type_'+i);   
                reqMap.put('Facility_Type_'+i, '');
                
                finalLimitMap.put(i, 'Final_Limit_'+i);
                reqMap.put('Final_Limit_'+i, '');
                
                marginMap.put(i, 'Approved_Margin'+i);
                reqMap.put('Approved_Margin'+i, '');
                
                rate_Of_Intrst_Map.put(i, 'Rate_Commission_'+i);
                reqMap.put('Rate_Commission_'+i, '');
                
                prim_Sec_Map.put(i, 'Primary_Security'+i);
                reqMap.put('Primary_Security'+i, '');
                
                coll_Sec_Map.put(i, 'Collateral_Security'+i);
                reqMap.put('Collateral_Security'+i, '');
                
                loan_purpose_Map.put(i, 'Loan_Purpose_'+i);
                reqMap.put('Loan_Purpose_'+i, '');
                
                roiMap.put(i, 'ROI'+i);
                reqMap.put('ROI'+i, '');
                
                varianceMap.put(i, 'Variance'+i);
                reqMap.put('Variance'+i, '');
                
                mclr_Map.put(i, 'One_year_MCLR'+i);
                reqMap.put('One_year_MCLR'+i, '');
                
                loan_Validity_Map.put(i, 'Loan_Validity_Period'+i);
                reqMap.put('Loan_Validity_Period'+i, '');
                
            }
            
            If(! facilities.isEmpty()){
                
                for(Integer i=1; i<=facilities.size(); i++){
                    DECIMAL VARIANCE    = 0;
                    string primarySecurity      = '';
                    string ColleteralSecurity   = '';
                    
                    if((facilities[i-1].Recommended_Limit__c) != NULL){
                        totalAMT += facilities[i-1].Recommended_Limit__c;
                    }
                    
                    if(facilty_NatureMap.containsKey(i)){
                        reqMap.put(facilty_NatureMap.get(i), Utility.getBlankStringIfNull(facilities[i-1].CL_Product__r.clcommon__Product_Name__c));
                    }
                    
                    /* Limit in Rs. */
                    if(finalLimitMap.containsKey(i)){
                        reqMap.put(finalLimitMap.get(i), Utility.getBlankStringIfNull(String.valueOf(facilities[i-1].Recommended_Limit__c)));
                    }
                    
                    if(mclr_Map.containsKey(i)){
                        if((facilities[i-1].MCLR_Rate__c) != NULL){
                            reqMap.put(mclr_Map.get(i),Utility.getBlankStringIfNull(String.valueOf(facilities[i-1].MCLR_Rate__c)));
                        }
                        else{
                            reqMap.put(mclr_Map.get(i), '');
                        }
                    }
                    
                    /* Validity Period */
                    if(loan_Validity_Map.containsKey(i)){
                        if((facilities[i-1].Recommended_Days__c) != NULL){
                            reqMap.put(loan_Validity_Map.get(i), Utility.getBlankStringIfNull(((System.Now().AddDays(Integer.valueof(facilities[i-1].Recommended_Days__c))).format('dd-MM-yyyy'))));
                        }
                        else{
                            //reqMap.put(loan_Validity_Map.get(i), '');
                            reqMap.put(loan_Validity_Map.get(i), Utility.getBlankStringIfNull(((System.Now().AddDays(365)).format('dd-MM-yyyy'))));
                        }
                    }
                    
                    /* Margin (%) */
                    if(marginMap.containsKey(i)){
                        if((facilities[i-1].Industry__c) != null && facilities[i-1].Industry__c == 'Manufacturing'){
                            if((facilities[i-1].CL_Product__r.Facility_Category__c == 'SOD') || (facilities[i-1].CL_Product__r.Facility_Category__c == 'FBP')){
                                reqMap.put(marginMap.get(i),Utility.getBlankStringIfNull(String.valueOf(facilities[i-1].Margin__c))+'%');
                            }
                            else {
                                if((facilities[i-1].Margin_Receivables__c) != NULL && (facilities[i-1].Margin_Stock_Manufacturing__c) != NULL){
                                    margin = 'Receivables : '+ facilities[i-1].Margin_Receivables__c+'%' + ' ; ' +'Stock Manufacturing : '+ facilities[i-1].Margin_Stock_Manufacturing__c+'%';
                                    reqMap.put(marginMap.get(i),Utility.getBlankStringIfNull(margin)); 
                                }
                                else
                                    reqMap.put(marginMap.get(i), '');
                            }      
                        }
                        else if((facilities[i-1].Industry__c) != null && facilities[i-1].Industry__c == 'TRADING'){
                            if((facilities[i-1].CL_Product__r.Facility_Category__c == 'SOD') || (facilities[i-1].CL_Product__r.Facility_Category__c == 'FBP')){
                                reqMap.put(marginMap.get(i),Utility.getBlankStringIfNull(String.valueOf(facilities[i-1].Margin__c))+'%');
                            }
                            else{
                                if((facilities[i-1].Margin_Receivables__c) != NULL && (facilities[i-1].Margin_Stock_Trading__c) != NULL){
                                    margin = 'Receivables : '+ facilities[i-1].Margin_Receivables__c +'%' +' ; ' +'Stock Trading : '+ facilities[i-1].Margin_Stock_Trading__c+'%';
                                    reqMap.put(marginMap.get(i),Utility.getBlankStringIfNull(margin));
                                }
                                else
                                    reqMap.put(marginMap.get(i), '');
                            }
                        }
                        else{
                            if((facilities[i-1].Margin__c) != NULL){
                                margin = Utility.getBlankStringIfNull(String.valueOf(facilities[i-1].Margin__c));
                                reqMap.put(marginMap.get(i),Utility.getBlankStringIfNull(margin)); 
                            }
                            else
                                reqMap.put(marginMap.get(i), '');
                        } 
                    }
                    
                    /* Loan Rate of Interest (%) */
                    If(rate_Of_Intrst_Map.containsKey(i)){
                        reqMap.put(rate_Of_Intrst_Map.get(i),Utility.getBlankStringIfNull(String.valueOf(facilities[i-1].Recommended_Rate__c)));
                    }
                    
                    /* Interest clause */
                    If(roiMap.containsKey(i)){
                        reqMap.put(roiMap.get(i),str1+Utility.getBlankStringIfNull(String.valueOf(facilities[i-1].Recommended_Rate__c))+str2);
                    }
                    If(varianceMap.containsKey(i)){
                        if((facilities[i-1].Final_Spread__c) != null){
                            reqMap.put(varianceMap.get(i),Utility.getBlankStringIfNull(String.valueOf(facilities[i-1].Final_Spread__c))+str3);
                        }
                        else reqMap.put(varianceMap.get(i), '');
                    }
                    
                    Integer primaryCount = 1;
                    Integer SecoundryCount = 1;
                    if(! (facilities[i-1].Facility_Security__r).isEmpty()){
                        for(genesis__Application_Collateral__c coll : facilities[i-1].Facility_Security__r){
                            //if(coll.genesis__Collateral__c !=null && coll.Security_Type__c !=null && securtiyDetails != null && securtiyDetails.containsKey(coll.genesis__Collateral__c)){
                            if(securtiyDetails != null && securtiyDetails.containsKey(coll.genesis__Collateral__c)){    
                                /* Primary Security */
                                //if(coll.Security_Type__c == Constants.PRIMARY_SECURITIES){
                                System.debug('CollDetails:::'+coll.Id+'---'+coll.Facility__r.CL_Product__r.Facility_Category__c);
                                if(coll.Facility__r.CL_Product__r.Facility_Category__c == 'SOD'){
                                    if(coll.genesis__Collateral__r.recordType.DeveloperName == Constants.COLLATERAL_RECTYPE_OTHER){
                                        if(coll.genesis__Collateral__r.Collateral_Type__c == 'CGTMSE'){
                                            primarySecurity += SecoundryCount+'. '+'Covered under CGTMSE scheme '+'\n';
                                            primaryCount++;
                                        }else{
                                            primarySecurity += primaryCount+'. '+getOtherCollateralTypeDetails(coll)+'\n';
                                            primaryCount++;
                                        }
                                    }else{
                                        System.debug(primaryCount+'---'+securtiyDetails.get(coll.genesis__Collateral__c));
                                        primarySecurity += primaryCount+'. '+securtiyDetails.get(coll.genesis__Collateral__c)+'\n';
                                        primaryCount++;
                                    }  
                                }
                                
                                /* Collateral Security */
                                //if(coll.Security_Type__c == Constants.COLLATERAL_SECURITIES){
                                if(coll.Facility__r.CL_Product__r.Facility_Category__c == 'OCC'){
                                    if(coll.genesis__Collateral__r.recordType.DeveloperName == Constants.COLLATERAL_RECTYPE_OTHER ){
                                        if(coll.genesis__Collateral__r.Collateral_Type__c == 'CGTMSE'){
                                            ColleteralSecurity += SecoundryCount+'. '+'Covered under CGTMSE scheme '+'\n';
                                            SecoundryCount++;
                                        }else{
                                            ColleteralSecurity += SecoundryCount+'. '+getOtherCollateralTypeDetails(coll)+'\n';
                                            SecoundryCount++;
                                        }  
                                    }else{
                                        System.debug(SecoundryCount+'---'+securtiyDetails.get(coll.genesis__Collateral__c));
                                        ColleteralSecurity += SecoundryCount+'. '+securtiyDetails.get(coll.genesis__Collateral__c)+'\n';
                                        SecoundryCount++;
                                    }
                                }                    
                            }
                        }
                    }
                    if(primarySecurity == '' || primarySecurity == null){
                        primarySecurity     = appln.Security_Description__c;
                        if(primarySecurity !=null)primarySecurity     = primarySecurity.removeEnd(',');
                    }
                    if(ColleteralSecurity== '' || ColleteralSecurity == null){
                        ColleteralSecurity     = appln.Security_Description__c;
                        if(ColleteralSecurity !=null)ColleteralSecurity     = ColleteralSecurity.removeEnd(',');
                    }
                    if(!securityText.isEmpty() && securityText[0].Application_Id__c != null){
                        if(securityText[0].Application_Id__c == appln.Id){
                            System.debug(securityText[0]);
                            if(securityText[0].PRIMARY_SECURITY__c != null){
                                System.debug(securityText[0].PRIMARY_SECURITY__c);
                                primarySecurity     = securityText[0].PRIMARY_SECURITY__c;
                            }   
                            if(securityText[0].COLLATERAL_SECURITY__c != null){
                                System.debug(securityText[0].COLLATERAL_SECURITY__c);
                                ColleteralSecurity  = securityText[0].COLLATERAL_SECURITY__c;
                            }   
                        }
                    }
                    if(prim_Sec_Map.containsKey(i) && primarySecurity != ''){
                        reqMap.put(prim_Sec_Map.get(i),+' : '+ primarySecurity);               
                    }
                    if(coll_Sec_Map.containsKey(i) && ColleteralSecurity != ''){
                        reqMap.put(coll_Sec_Map.get(i),+' : '+ ColleteralSecurity);
                    }
                    if(loan_purpose_Map.containsKey(i)){
                        //reqMap.put(loan_purpose_Map.get(i),+' : '+ Utility.getBlankStringIfNull(String.valueOf(facilities[i-1].Loan_Purpose__c)));
                        reqMap.put(loan_purpose_Map.get(i),+' : '+ 'To Meet Working Capital Requirements.');
                    }
                    
                    // Dynamic Paragraph Based on Facility category 
                    /*** Start ***/
                    
                    if(facilities[i-1].CL_Product__r.Facility_Category__c == 'SOD'){
                        System.debug('Inside If SOD');
                        String temp = facilityTC.get(facilities[i-1].CL_Product__r.Facility_Category__c);
                        System.debug('temp--> ' + temp);
                        reqMap.put('SOD_TNC','WORKING CAPITAL LIMIT T&C - SOD'+'\n'+' '+temp);
                        //reqMap.put('SOD_TNC','WORKING CAPITAL LIMIT T&C - SOD'+'\n'+' '+facilityTC.get(facilities[i-1].CL_Product__r.Facility_Category__c));
                    }
                    else{
                        System.debug('Inside Else SOD');
                        reqMap.put('SOD_TNC','');
                    }
                    if(facilities[i-1].CL_Product__r.Facility_Category__c == 'OCC' || facilities[i-1].CL_Product__r.Facility_Category__c == 'CCBD'){
                        System.debug(facilities[i-1]);
                        System.debug(facilities[i-1].CL_Product__r.Facility_Category__c);
                        System.debug(facilityTC.get(facilities[i-1].CL_Product__r.Facility_Category__c));
                        String temp = facilityTC.get(facilities[i-1].CL_Product__r.Facility_Category__c).replace('((Penal_Interest_Rate))',PENAL_RATE);
                        System.debug('temp2--> ' + temp);  
                        reqMap.put('OCC_CCBD_TNC','WORKING CAPITAL LIMIT T&C - OCC /CCBD'+'\n'+' '+temp);
                    }
                    else{
                        System.debug('Inside OCC/CCBD ELSE');
                        reqMap.put('OCC_CCBD_TNC','');
                    }
                    if(facilities[i-1].CL_Product__r.Facility_Category__c == 'CCBD'){
                        String temp = facilityTC.get(facilities[i-1].CL_Product__r.Facility_Category__c).replace('((Penal_Interest_Rate))',PENAL_RATE);  
                        reqMap.put('CCBD_TNC','WORKING CAPITAL LIMIT T&C - CCBD'+'\n'+' '+temp);
                        forexAdvanceFlag = true;
                        if(forexAdvanceFlag){
                            reqMap.put('FORX_ADV_TNC_EAE', forexcontent);
                        }
                        else reqMap.put('FORX_ADV_TNC_EAE', '');
                    }
                    else{
                        reqMap.put('CCBD_TNC','');
                    }
                    
                    if(facilities[i-1].CL_Product__r.Facility_Category__c == 'PCL' || facilities[i-1].CL_Product__r.Facility_Category__c == 'PCFC'){
                        flag = true;
                        String temp = facilityTC.get('PCL/PCFC').replace('((Penal_Interest_Rate))',PENAL_RATE);  
                        reqMap.put('PLC_PCFC_TNC','WORKING CAPITAL LIMIT T&C - PCL/ PCFC'+'\n'+' '+temp);
                        if(flag){
                            reqMap.put('Con_Speci_Export_Cred_Facilities', facilityTC.get('PLC/FBDP/CEL'));
                        }
                        else reqMap.put('Con_Speci_Export_Cred_Facilities', '');
                        
                        forexAdvanceFlag = true;
                        if(forexAdvanceFlag){
                            reqMap.put('FORX_ADV_TNC_EAE', forexcontent);
                        }
                        else reqMap.put('FORX_ADV_TNC_EAE', '');
                    }
                    
                    else{
                        reqMap.put('PLC_PCFC_TNC','');
                    }
                    
                    if(facilities[i-1].CL_Product__r.Facility_Category__c == 'FBP' || facilities[i-1].CL_Product__r.Facility_Category__c == 'EBD'){
                        flag = true;
                        reqMap.put('FBDP_EBDP_TNC','WORKING CAPITAL LIMIT T&C - FBD/P, EBD/P'+'\n'+' '+facilityTC.get('FBP/EBD'));
                        if(flag){
                            reqMap.put('Con_Speci_Export_Cred_Facilities', facilityTC.get('PLC/FBDP/CEL'));
                        }
                        else reqMap.put('Con_Speci_Export_Cred_Facilities', '');
                        
                        forexAdvanceFlag = true;
                        if(forexAdvanceFlag){
                            reqMap.put('FORX_ADV_TNC_EAE', forexcontent);
                        }
                        else reqMap.put('FORX_ADV_TNC_EAE', '');
                    }
                    
                    else{
                        reqMap.put('FBDP_EBDP_TNC','');
                    }
                    
                    if(facilities[i-1].CL_Product__r.Facility_Category__c == 'CEL'){
                        flag = true;
                        reqMap.put('CEL_TNC','FOREX FACILITY T&C - Credit Equivalent Limit (CEL)'+'\n'+' '+facilityTC.get(facilities[i-1].CL_Product__r.Facility_Category__c));
                        if(flag){
                            reqMap.put('Con_Speci_Export_Cred_Facilities', facilityTC.get('PLC/FBDP/CEL'));
                        }
                        else reqMap.put('Con_Speci_Export_Cred_Facilities', '');
                        
                        forexAdvanceFlag = true;
                        if(forexAdvanceFlag){
                            reqMap.put('FORX_ADV_TNC_EAE', forexcontent);
                        }
                        else reqMap.put('FORX_ADV_TNC_EAE', '');
                    }
                    
                    else{
                        reqMap.put('CEL_TNC','');
                    }
                    
                    if(appln.genesis__Account__r.Constitution__c == 'COMPANIES' || appln.genesis__Account__r.Constitution__c == 'LLP'){
                        reqMap.put('CO_LLP_TNC','WORKING CAPITAL LIMIT T&C - COMPANIES/LLP'+'\n'+' '+SMESanction_DocReq.companiesllpTnC);
                        reqMap.put('CORP_ADV_TNC_EAE', corpAdv);
                    }
                    
                    else{
                        reqMap.put('CO_LLP_TNC','');
                    }
                    /*** End ***/
                }
            }
            
            gstCharge               = KVB_Company_Details__c.getOrgDefaults().GST__c;
            //enhPrCharge             = (SMESanction_DocReq.processingFeeCalculation(facilities,appln)).setscale(2);
            if(appln.recordtype.developerName == 'SME_NEW_Loan')
                enhPrCharge         = appln.genesis__Rate_Floor__c;
            else if(appln.recordtype.developerName == 'SME_Enhancement')
                enhPrCharge             = appln.Processing_Charges__c;
            processChargeGST        = ((enhPrCharge * gstCharge)/100).setscale(2);
            processChrageTotal      = (enhPrCharge + processChargeGST).setscale(2);
            docCharge               = appln.Total_Stamp_Paper_Charge__c;//(SMESanction_DocReq.docFee).setscale(2);
            docChargeGST            = ((docCharge * gstCharge)/100).setscale(2);
            docChrageTotal          = (docCharge + docChargeGST).setscale(2);    
            cibilCharge             = appln.Cibil_Charges__c;//(SMESanction_DocReq.cibilFee).setscale(2);
            cibilChargeGST          = ((cibilCharge * gstCharge)/100).setscale(2);
            cibilChargeTotal        = (cibilCharge + cibilChargeGST).setscale(2); 
            finalProcessingFee      = (processChrageTotal+docChrageTotal+cibilChargeTotal).setscale(2);
            
            if(cibilCharge != null) 
                reqMap.put('cibil_charge', Utility.getBlankStringIfNull(String.valueOf(cibilCharge)));
            else 
                reqMap.put('cibil_charge', '');
            
            if(cibilChargeGST != null) 
                reqMap.put('cibil_charge_gst', Utility.getBlankStringIfNull(String.valueOf(cibilChargeGST)));
            else 
                reqMap.put('cibil_charge_gst', '');
            
            if(cibilChargeTotal != null) 
                reqMap.put('cibil_charge_total', Utility.getBlankStringIfNull(String.valueOf(cibilChargeTotal)));
            else 
                reqMap.put('cibil_charge_total', '');
            
            if(appln.Recordtype.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || appln.Recordtype.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE){
                reqMap.put('process_charge', Utility.getBlankStringIfNull(String.valueOf(enhPrCharge)));
                reqMap.put('process_charge_gst', Utility.getBlankStringIfNull(String.valueOf(processChargeGST)));
                reqMap.put('process_charge_total', Utility.getBlankStringIfNull(String.valueOf(processChrageTotal)));
                reqMap.put('doc_charge', Utility.getBlankStringIfNull(String.valueOf(docCharge)));
                reqMap.put('doc_charge_gst', Utility.getBlankStringIfNull(String.valueOf(docChargeGST)));
                reqMap.put('doc_charge_total', Utility.getBlankStringIfNull(String.valueOf(docChrageTotal)));
                reqMap.put('final_processingFee', Utility.getBlankStringIfNull(String.valueOf(finalProcessingFee))); 
            }
            
            Decimal prChargeAdHoc      = appln.Processing_Charges__c != null ? appln.Processing_Charges__c : 0.0;
            Decimal processChargeGSTAdHoc   = 0.0;
            Decimal processChargeTotalAdHoc = 0.0;
            Decimal finalProcessingFeeAdHoc = 0.0;
            Decimal docChargeAdHoc          = 0.0;
            Decimal docChargeGSTAdHoc       = 0.0;
            Decimal docChrageTotalAdHoc     = 0.0;
            //gstCharge cibilChargeTotal
            if(appln.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC){
                prChargeAdHoc = appln.Processing_Charges__c;
                processChargeGSTAdHoc   = ((prChargeAdHoc * gstCharge)/100).setscale(2);
                processChargeTotalAdHoc = (prChargeAdHoc + processChargeGSTAdHoc).setscale(2);
                docChargeAdHoc = appln.Total_Stamp_Paper_Charge__c != null ? appln.Total_Stamp_Paper_Charge__c : 0.0;
                docChargeGSTAdHoc       = ((docChargeAdHoc * gstCharge)/100).setscale(2);
                docChrageTotalAdHoc     = (docChargeAdHoc + docChargeGSTAdHoc).setscale(2);
                finalProcessingFeeAdHoc = (processChargeTotalAdHoc + docChrageTotalAdHoc + cibilChargeTotal).setscale(2);
                reqMap.put('process_charge', Utility.getBlankStringIfNull(String.valueOf(prChargeAdHoc)));
                reqMap.put('process_charge_gst', Utility.getBlankStringIfNull(String.valueOf(processChargeGSTAdHoc)));
                reqMap.put('process_charge_total', Utility.getBlankStringIfNull(String.valueOf(processChargeTotalAdHoc)));
                reqMap.put('doc_charge', Utility.getBlankStringIfNull(String.valueOf(docChargeAdHoc)));
                reqMap.put('doc_charge_gst', Utility.getBlankStringIfNull(String.valueOf(docChargeGSTAdHoc)));
                reqMap.put('doc_charge_total', Utility.getBlankStringIfNull(String.valueOf(docChrageTotalAdHoc)));
                reqMap.put('final_processingFee', Utility.getBlankStringIfNull(String.valueOf(finalProcessingFeeAdHoc)));
            }
            
            for(Integer i=1; i<7; i++){
                spl_Sanction_Map.put(i, 'Spl_Sanction_Terms'+i);
                reqMap.put('Spl_Sanction_Terms'+i, '');
            }
            
            List<Audit__c> splTnC   = new List<Audit__c>();
            try{
                splTnC  = [Select id,Tag_Name__c,Terms_and_Conditions__c from Audit__c where RecordType.DeveloperName ='Underwriting_T_C' AND Application__c =:appln.Id AND Type__c = 'Final Sanction'];            
            }catch(QueryException e){}
            
            If(! splTnC.isEmpty()){
                for(Integer i=1; i<=splTnC.size(); i++){
                    If(spl_Sanction_Map.containsKey(i)){
                        reqMap.put(spl_Sanction_Map.get(i), i+'. '+ Utility.getBlankStringIfNull(splTnC[i-1].Terms_and_Conditions__c));  
                    }
                }
            }
            
            Map<Integer,String> partyTypeMap = new Map<Integer,String>();
            Map<Integer,String> signatoryMap = new Map<Integer,String>();
            Map<Integer,String> brrwsignMap  = new Map<Integer,String>();
            
            for(integer i=1;i<31;i++){
                partyTypeMap.put(i, 'Auth_Signatory_Type'+i);
                signatoryMap.put(i, 'Auth_Signatory'+i);
                brrwsignMap.put(i,'Borrower_Guar_Sign'+i);
                reqMap.put('Auth_Signatory_Type'+i, '');
                reqMap.put('Auth_Signatory'+i, '');
                reqMap.put('Borrower_Guar_Sign'+i, '');
            }
            
            // Party Account Aadhar Map 
            Map<Integer,String> name_Map                = new Map<Integer,String>();
            Map<Integer,String> party_Type_Map          = new Map<Integer,String>();
            Map<Integer,String> aadhar_Map              = new Map<Integer,String>();
            Map<Integer,String> mbl_No_Map              = new Map<Integer,String>();
            Map<Integer,String> email_Map               = new Map<Integer,String>();
            Map<Integer,String> pan_Map                 = new Map<Integer,String>();
            Map<Integer,String> auth_Sig_Map            = new Map<Integer,String>();
            
            for(Integer i=1; i<8; i++){
                
                auth_Sig_Map.put(i, 'Auth_Signatory_Guarantors'+i);
                reqMap.put('Auth_Signatory_Guarantors'+i, '');
                
                name_Map.put(i, 'Name'+i);   
                reqMap.put('Name'+i, '');
                
                party_Type_Map.put(i, 'Party_Type'+i);   
                reqMap.put('Party_Type'+i, '');
                
                aadhar_Map.put(i, 'Aadhar'+i);   
                reqMap.put('Aadhar'+i, '');
                
                mbl_No_Map.put(i, 'Mobile_No_'+i);   
                reqMap.put('Mobile_No_'+i, '');
                
                email_Map.put(i, 'Email'+i);   
                reqMap.put('Email'+i, '');
                
                pan_Map.put(i, 'Pan'+i);   
                reqMap.put('Pan'+i, '');
            }
            
            if(! parties.isEmpty()){
                Integer partyCount =1;
                for(Integer i=1; i<=parties.size(); i++){
                    If(signatoryMap.containsKey(partyCount) && parties[i-1].genesis__Party_Account_Name__c != null){
                        reqMap.put(partyTypeMap.get(partyCount),Utility.getBlankStringIfNull(parties[i-1].genesis__Party_Type__c));
                        reqMap.put(signatoryMap.get(partyCount),Utility.getBlankStringIfNull(parties[i-1].genesis__Party_Account_Name__r.Name));
                    }
                    partyCount++;
                    
                    if(parties[i-1].genesis__Party_Type__c == 'Guarantor' || parties[i-1].genesis__Party_Type__c == 'Co-Borrower' || parties[i-1].genesis__Party_Type__c == 'Partner' 
                       || parties[i-1].genesis__Party_Type__c == 'Director'){
                           
                           if(auth_Sig_Map.containsKey(i)){
                               reqMap.put(auth_Sig_Map.get(i), Utility.getBlankStringIfNull(parties[i-1].genesis__Party_Account_Name__r.Name));
                           }
                           else  reqMap.put(auth_Sig_Map.get(i), '');
                       }
                    
                    if(parties[i-1].genesis__Party_Type__c == 'Guarantor' || parties[i-1].genesis__Party_Type__c == 'Co-Borrower' || parties[i-1].genesis__Party_Type__c == 'Partner' 
                       || parties[i-1].genesis__Party_Type__c == 'Proprietor' || parties[i-1].genesis__Party_Type__c == 'Director'){
                           
                           string aadhar = parties[i-1].genesis__Party_Account_Name__r.Aadhaar_Number__pc!=null?parties[i-1].genesis__Party_Account_Name__r.Aadhaar_Number__pc:'';
                           aadhar        = WS_getAadharNo.getAadharNo(aadhar);
                           System.debug(aadhar);
                           
                           if(name_Map.containsKey(i)){
                               reqMap.put(name_Map.get(i),Utility.getBlankStringIfNull(parties[i-1].genesis__Party_Account_Name__r.Name));
                           }
                           
                           if(party_Type_Map.containsKey(i)){
                               reqMap.put(party_Type_Map.get(i),Utility.getBlankStringIfNull(parties[i-1].genesis__Party_Type__c));
                           }
                           
                           if(aadhar_Map.containsKey(i)){
                               reqMap.put(aadhar_Map.get(i),Utility.getBlankStringIfNull(aadhar));
                           }
                           
                           if(mbl_No_Map.containsKey(i)){
                               reqMap.put(mbl_No_Map.get(i),Utility.getBlankStringIfNull(parties[i-1].genesis__Party_Account_Name__r.PersonMobilePhone));
                           }
                           
                           if(email_Map.containsKey(i)){
                               reqMap.put(email_Map.get(i),Utility.getBlankStringIfNull(parties[i-1].genesis__Party_Account_Name__r.PersonEmail));
                           }
                           
                           if(pan_Map.containsKey(i)){
                               reqMap.put(pan_Map.get(i),Utility.getBlankStringIfNull(parties[i-1].genesis__Party_Account_Name__r.Pan_Number__c));
                           }
                           /*if(auth_Sig_Map.containsKey(i)){
reqMap.put(auth_Sig_Map.get(i), Utility.getBlankStringIfNull(parties[i-1].genesis__Party_Account_Name__r.Name));
}
else  reqMap.put(auth_Sig_Map.get(i), '');*/                    
                       }
                }
            }
            
            reqMap.put('Auth_Signatory_Bnk', 'KVB Bank');   
            reqMap.put('Bnk_Auth_Sign', '');
            
            req.inputVariables.inputmap = reqMap;
            return req;
        }catch(Exception e){
            System.debug('errMsg ' + e.getMessage());
            System.debug('Line ' + e.getLineNumber());
            System.debug('stack ' + e.getStackTraceString());
            return null;
        } 
    }
    
    // Method to get the format for date/time field.
    public static String formatDate(Date d) {
        if(d != null){
            return d.day() + '-' + d.month() + '-' + d.year();
        }
        return '';
    }
    
    // Method to get the Application Branch City.
    public static String getBranchCity(String branchCode){
        try{
            return [SELECT CODCCBRN__c,NAMCCCITY__c,Active__c FROM Branch_Master__c WHERE Active__c = true AND CODCCBRN__c =: branchCode].NAMCCCITY__c;
        }catch(Exception e){
            System.debug('Error Message--> ' + e.getMessage());
            return null;
        }
    }
}