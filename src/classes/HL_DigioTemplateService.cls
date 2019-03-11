/*
* Name    : HL_DigioTemplateService
* Company : ET Marlabs
* Purpose : This class will be used for pulling data for document generation
-----------------------------------------------------------------------
Version   Date         Author             Remarks                                                 
=======   ==========   =============  ==================================
v1.1      19-Oct-2018    Braj         Addition of HL Non Legal Desk Digio documents template and query method
v1.2      20-Feb-2019    Braj         Addition of HL MVP2 documents template
*******************************************************************************************/
global class HL_DigioTemplateService {
    
    //-----------------------------------HL Start Here-----------------------------
    public static HLpre_Approve_Sanction_DigioDocreq getHLSanctionLetter(String appId,String templateId){
        genesis__Applications__c appln = new genesis__Applications__c();
        appln   = [Select id,genesis__Account__c,genesis__Account__r.Name,genesis__Account__r.Salutation,Branch_Name__c,genesis__Loan_Amount__c,
                   Branch_Code__c,Sanction_Amount_Words__c,Created_Date__c,genesis__Margin__c,Name,genesis__Account__r.BillingStreet,Sanction_Financial_Year__c,Sanction_Date__c,Amount_in_Words_And_Figures__c,
                   genesis__Account__r.BillingCity,genesis__Account__r.BillingState,genesis__Account__r.BillingCountry,genesis__CL_Product_Name__c,genesis__Term__c,
                   genesis__Interest_Rate__c,Sanction_Authority_Limit__c,Processing_Fee__c,Today_Date__c,genesis__Account__r.Father_Husband_Daughter_Name__c,genesis__Account__r.PersonMailingStreet,
                   genesis__Account__r.PersonMailingCity,genesis__Account__r.PersonMailingState,genesis__Account__r.PersonMailingPostalCode,genesis__Account__r.Full_Name__c  
                   from genesis__Applications__c where id =:appId];
        List<genesis__Application_Parties__c> parties = new List<genesis__Application_Parties__c>();
        parties = [Select id,genesis__Application__c,Guarantor__c,genesis__Party_Account_Name__c,Signatories__c,
                   genesis__Party_Account_Name__r.Name,Party_Sub_Type__c,genesis__Party_Type__c,Active__c,genesis__Party_Account_Name__r.Father_Husband_Daughter_Name__c,genesis__Party_Account_Name__r.Salutation,
                   genesis__Party_Account_Name__r.PersonMailingCity,genesis__Party_Account_Name__r.PersonMailingState,genesis__Party_Account_Name__r.PersonMailingPostalCode
                   ,genesis__Party_Account_Name__r.PersonMailingStreet,genesis__Party_Account_Name__r.Full_Name__c from genesis__Application_Parties__c where genesis__Application__c = :appId 
                   AND genesis__Party_Type__c =: Constants.Co_Borrower AND Active__c =true];
        HLpre_Approve_Sanction_DigioDocreq PreApp=new HLpre_Approve_Sanction_DigioDocreq();
        
        
        PreApp.inputVariables   = new HLpre_Approve_Sanction_DigioDocreq.cls_inputVariables();
        PreApp.owner_tenantId   = 'cuecent_tenant';
        PreApp.exe_tenantId = 'cuecent_tenant';
        PreApp.serviceName      = 'TestJsonStr';
        PreApp.inputVariables.unique_key    = templateId;
        PreApp.inputVariables.pdf_unique_key = appln.Id;
        PreApp.inputVariables.in_msg        = '';
        PreApp.inputVariables.inputmap  = new HLpre_Approve_Sanction_DigioDocreq.cls_inputmap();
        
        PreApp.inputVariables.inputmap.Auth_Sign_Bnk= Constants.KvbBank;
        PreApp.inputVariables.inputmap.Loc_Ref_Branch=Utility.getBlankStringIfNull(appln.Branch_Name__c);
        PreApp.inputVariables.inputmap.Branch_code=Utility.getBlankStringIfNull(appln.Branch_Code__c);
        PreApp.inputVariables.inputmap.Application_date=Utility.getBlankStringIfNull(dateFormatterChange(appln.Created_Date__c));  
        PreApp.inputVariables.inputmap.Application_number=Utility.getBlankStringIfNull(appln.Name);
        PreApp.inputVariables.inputmap.Financial_Yr=Utility.getBlankStringIfNull(String.ValueOf(appln.Sanction_Financial_Year__c));
        PreApp.inputVariables.inputmap.sanction_date=Utility.dateFormatterNew();
        PreApp.inputVariables.inputmap.Loan_product=Utility.getBlankStringIfNull(appln.genesis__CL_Product_Name__c);
        PreApp.inputVariables.inputmap.Ap_LT=Utility.getBlankStringIfNull(String.ValueOf(appln.Sanction_Authority_Limit__c)); 
        PreApp.inputVariables.inputmap.Ap_LT_inwords=Utility.getBlankStringIfNull(appln.Sanction_Amount_Words__c);
        PreApp.inputVariables.inputmap.Loan_tenor=Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Term__c));
        if(appln.genesis__Interest_Rate__c==null){
            appln.genesis__Interest_Rate__c=0;
        }
        PreApp.inputVariables.inputmap.Int_ROI=Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Interest_Rate__c.setScale(2)));
        PreApp.inputVariables.inputmap.Processing_charges=Utility.getBlankStringIfNull(String.ValueOf(appln.Processing_Fee__c));
        PreApp.inputVariables.inputmap.Doc_gen_date=Utility.getBlankStringIfNull(dateFormatterChange(appln.Today_Date__c));
        PreApp.inputVariables.inputmap.Borrower1_Name1=Utility.getBlankStringIfNull(appln.genesis__Account__r.Full_Name__c);
        if(appln.genesis__Account__r.Father_Husband_Daughter_Name__c!=null && (!String.isBlank(appln.genesis__Account__r.Father_Husband_Daughter_Name__c)))
            PreApp.inputVariables.inputmap.Borrower1_F_H_D_NAME1= 'S/D/W of  '+Utility.getBlankStringIfNull(appln.genesis__Account__r.Father_Husband_Daughter_Name__c);
        PreApp.inputVariables.inputmap.Borrower1_Add_line1=Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonMailingStreet) ;
        PreApp.inputVariables.inputmap.Borrower1_Add_line2=Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonMailingCity) ;
        PreApp.inputVariables.inputmap.Borrower1_Add_line3=Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonMailingState) +'  '+Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonMailingPostalCode);
        
        for(integer i=0; i<parties.size(); i++){
            if(i==0){
                PreApp.inputVariables.inputmap.Borrower2_Name1=Utility.getBlankStringIfNull(parties[i].genesis__Party_Account_Name__r.Full_Name__c);
                if(parties[i].genesis__Party_Account_Name__r.Father_Husband_Daughter_Name__c!=null && (!String.isBlank(parties[i].genesis__Party_Account_Name__r.Father_Husband_Daughter_Name__c)))
                    PreApp.inputVariables.inputmap.Borrower2_F_H_D_NAME1='S/D/W of  '+Utility.getBlankStringIfNull(parties[i].genesis__Party_Account_Name__r.Father_Husband_Daughter_Name__c);
                PreApp.inputVariables.inputmap.Borrower2_Add_line1=Utility.getBlankStringIfNull(parties[i].genesis__Party_Account_Name__r.PersonMailingStreet) ;
                PreApp.inputVariables.inputmap.Borrower2_Add_line2=Utility.getBlankStringIfNull(parties[i].genesis__Party_Account_Name__r.PersonMailingCity) ;
                PreApp.inputVariables.inputmap.Borrower2_Add_line3=Utility.getBlankStringIfNull(parties[i].genesis__Party_Account_Name__r.PersonMailingState) +'  '+Utility.getBlankStringIfNull(parties[i].genesis__Party_Account_Name__r.PersonMailingPostalCode);
                
            }
            
            if(i==1){
                PreApp.inputVariables.inputmap.Borrower3_Name1=Utility.getBlankStringIfNull(parties[i].genesis__Party_Account_Name__r.Full_Name__c);
                if(parties[i].genesis__Party_Account_Name__r.Father_Husband_Daughter_Name__c!=null && (!String.isBlank(parties[i].genesis__Party_Account_Name__r.Father_Husband_Daughter_Name__c)))
                    PreApp.inputVariables.inputmap.Borrower3_F_H_D_NAME1='S/D/W of  '+Utility.getBlankStringIfNull(parties[i].genesis__Party_Account_Name__r.Father_Husband_Daughter_Name__c);
                PreApp.inputVariables.inputmap.Borrower3_Add_line1=Utility.getBlankStringIfNull(parties[i].genesis__Party_Account_Name__r.PersonMailingStreet) ;
                PreApp.inputVariables.inputmap.Borrower3_Add_line2=Utility.getBlankStringIfNull(parties[i].genesis__Party_Account_Name__r.PersonMailingCity) ;
                PreApp.inputVariables.inputmap.Borrower3_Add_line3=Utility.getBlankStringIfNull(parties[i].genesis__Party_Account_Name__r.PersonMailingState) +'  '+Utility.getBlankStringIfNull(parties[i].genesis__Party_Account_Name__r.PersonMailingPostalCode);
            }
            if(i==2){
                PreApp.inputVariables.inputmap.Borrower4_Name1=Utility.getBlankStringIfNull(parties[i].genesis__Party_Account_Name__r.Full_Name__c);
                if(parties[i].genesis__Party_Account_Name__r.Father_Husband_Daughter_Name__c!=null && (!String.isBlank(parties[i].genesis__Party_Account_Name__r.Father_Husband_Daughter_Name__c)))
                    PreApp.inputVariables.inputmap.Borrower4_F_H_D_NAME1='S/D/W of  '+Utility.getBlankStringIfNull(parties[i].genesis__Party_Account_Name__r.Father_Husband_Daughter_Name__c);
                PreApp.inputVariables.inputmap.Borrower4_Add_line1=Utility.getBlankStringIfNull(parties[i].genesis__Party_Account_Name__r.PersonMailingStreet) ;
                PreApp.inputVariables.inputmap.Borrower4_Add_line2=Utility.getBlankStringIfNull(parties[i].genesis__Party_Account_Name__r.PersonMailingCity) ;
                PreApp.inputVariables.inputmap.Borrower4_Add_line3=Utility.getBlankStringIfNull(parties[i].genesis__Party_Account_Name__r.PersonMailingState) +'  '+Utility.getBlankStringIfNull(parties[i].genesis__Party_Account_Name__r.PersonMailingPostalCode);
            }
        }
        return PreApp;
    }
    
    public static HL_Acknowledge_For_Sanction_req getHLAcknowledgeSanctionC1(string appId,string templateId){
        //removed--- COLLATERAL STRUCTURE CHANGES---Survey_No_Katha_No_Other_No_s__c
        genesis__Applications__c appln = new genesis__Applications__c();
        appln   = [Select id,genesis__Account__c,Record_Type_Name__c,Type_Of_Charge__c,genesis__Account__r.Aadhaar_Number__pc,genesis__Account__r.Phone,genesis__Account__r.Person_Email__c,genesis__Account__r.Pan_Number__c,genesis__Account__r.Name,Branch_Name__c,genesis__Loan_Amount__c,genesis__Account__r.PersonMobilePhone,
                   Branch_Code__c,Created_Date__c,Name,genesis__Account__r.BillingStreet,Sanction_Financial_Year__c,Sanction_Date__c,Amount_in_Words_And_Figures__c,Sanction_Reference_Number__c,
                   genesis__Account__r.BillingCity,genesis__Account__r.BillingState,genesis__Account__r.BillingCountry,genesis__CL_Product_Name__c,genesis__Term__c,
                   genesis__Interest_Rate__c,Processing_Fee__c,Sanctioned_EMI__c,MCLR_Rate__c,genesis__Margin__c,Today_Date__c,genesis__Account__r.Father_Husband_Daughter_Name__c,genesis__Account__r.PersonMailingStreet,
                   genesis__Account__r.PersonMailingCity,genesis__Account__r.PersonMailingState,genesis__Account__r.PersonMailingPostalCode,Loan_Purpose__c,genesis__Payment_Frequency__c,Holiday_Period__c,
                   genesis__Expected_First_Payment_Date__c,genesis__Payment_Amount__c,genesis__Interest_Calculation_Method__c,Non_Refundable_Charges__c,
                   Sanction_Amount_Words__c,Conditions_By_Sanction_Authority__c,Penal_Interest__c,PreClosure_Interest_Rate__c,Rating_Frequency__c,
                   Sanctioned_Tenure__c,Diff_B_w_ROI_MCLR__c,Sanction_Authority_Limit__c,MCLR_Type__c,
                   genesis__Account__r.PersonTitle,genesis__Account__r.Full_Name__c
                   from genesis__Applications__c where id =:appId];
        List<genesis__Application_Parties__c> COparties = new List<genesis__Application_Parties__c>();
        COparties   = [Select id,genesis__Application__c,Guarantor__c,genesis__Party_Account_Name__c,Signatories__c,genesis__Party_Account_Name__r.Aadhaar_Number__pc,genesis__Party_Account_Name__r.Phone,genesis__Party_Account_Name__r.Person_Email__c,genesis__Party_Account_Name__r.Pan_Number__c,genesis__Party_Account_Name__r.PersonMobilePhone,
                       genesis__Party_Account_Name__r.Name,Party_Sub_Type__c,genesis__Party_Type__c,Active__c,genesis__Party_Account_Name__r.Father_Husband_Daughter_Name__c,
                       genesis__Party_Account_Name__r.PersonMailingCity,genesis__Party_Account_Name__r.PersonMailingState,genesis__Party_Account_Name__r.PersonMailingPostalCode
                       ,genesis__Party_Account_Name__r.PersonMailingStreet,genesis__Party_Account_Name__r.Full_Name__c,genesis__Party_Account_Name__r.PersonTitle from genesis__Application_Parties__c where genesis__Application__c = :appId 
                       AND genesis__Party_Type__c =: Constants.Co_Borrower AND Active__c =true];
        List<genesis__Application_Parties__c> Gparties = new List<genesis__Application_Parties__c>();
        Gparties    = [Select id,genesis__Application__c,Guarantor__c,genesis__Party_Account_Name__c,Signatories__c,genesis__Party_Account_Name__r.Aadhaar_Number__pc,genesis__Party_Account_Name__r.Phone,genesis__Party_Account_Name__r.Person_Email__c,genesis__Party_Account_Name__r.Pan_Number__c,genesis__Party_Account_Name__r.PersonMobilePhone,
                       genesis__Party_Account_Name__r.Name,Party_Sub_Type__c,genesis__Party_Type__c,Active__c,genesis__Party_Account_Name__r.Father_Husband_Daughter_Name__c,
                       genesis__Party_Account_Name__r.PersonMailingCity,genesis__Party_Account_Name__r.PersonMailingState,genesis__Party_Account_Name__r.PersonMailingPostalCode
                       ,genesis__Party_Account_Name__r.PersonMailingStreet,genesis__Party_Account_Name__r.PersonTitle,genesis__Party_Account_Name__r.Full_Name__c from genesis__Application_Parties__c where genesis__Application__c = :appId 
                       AND genesis__Party_Type__c =: Constants.Gurantor AND Active__c =true];
        //added by prashant singh
        List<signersWrap> signers = new List<signersWrap>();
        signers.add(new signersWrap(appln.genesis__Account__r.Name,'Primary Applicant'));
        for(genesis__Application_Parties__c br : COparties){
            signers.add(new signersWrap(br.genesis__Party_Account_Name__r.Name,br.genesis__Party_Type__c));
            
        }
        for(genesis__Application_Parties__c gr : Gparties){
            signers.add(new signersWrap(gr.genesis__Party_Account_Name__r.Name,gr.genesis__Party_Type__c));
        }
        //prashant singh ends
        
        HL_Acknowledge_For_Sanction_req C1=new HL_Acknowledge_For_Sanction_req();
        
        C1.inputVariables    = new HL_Acknowledge_For_Sanction_req.cls_inputVariables();
        C1.owner_tenantId   = 'cuecent_tenant';
        C1.exe_tenantId = 'cuecent_tenant';
        C1.applicationType = appln.Record_Type_Name__c;
        C1.applicationId = appId;
        C1.customerId = '';
        C1.documentType = templateId;
        C1.accountNumbers = '';
        C1.fileName = '';
        C1.uuid = '';
        C1.serviceName      = 'TestJsonStr';
        C1.inputVariables.unique_key    = templateId;
        C1.inputVariables.pdf_unique_key = appln.Id;
        C1.inputVariables.in_msg        = '';
        C1.inputVariables.inputmap  = new HL_Acknowledge_For_Sanction_req.cls_inputmap();
        String Ptype='';
        //prashant singh starts
        if(signers.size()>0){
            C1.inputVariables.inputmap.Signer1         = Utility.getBlankStringIfNull(String.ValueOf(signers[0].name));
            C1.inputVariables.inputmap.Party_Type_1    = Utility.getBlankStringIfNull(String.valueOf(signers[0].partyType));
        }
        if(signers.size()>1){
            C1.inputVariables.inputmap.Signer2         = Utility.getBlankStringIfNull(String.ValueOf(signers[1].name));
            C1.inputVariables.inputmap.Party_Type_2    = Utility.getBlankStringIfNull(String.valueOf(signers[1].partyType));
        }
        if(signers.size()>2){
            C1.inputVariables.inputmap.Signer3         = Utility.getBlankStringIfNull(String.ValueOf(signers[2].name));
            C1.inputVariables.inputmap.Party_Type_3    = Utility.getBlankStringIfNull(String.valueOf(signers[2].partyType));
        }
        if(signers.size()>3){
            C1.inputVariables.inputmap.Signer4         = Utility.getBlankStringIfNull(String.ValueOf(signers[3].name));
            C1.inputVariables.inputmap.Party_Type_4    = Utility.getBlankStringIfNull(String.valueOf(signers[3].partyType));
        }
        if(signers.size()>4){
            C1.inputVariables.inputmap.Signer5         = Utility.getBlankStringIfNull(String.ValueOf(signers[4].name));
            C1.inputVariables.inputmap.Party_Type_5    = Utility.getBlankStringIfNull(String.valueOf(signers[4].partyType));
        }
        if(signers.size()>5){
            C1.inputVariables.inputmap.Signer6         = Utility.getBlankStringIfNull(String.ValueOf(signers[5].name));
            C1.inputVariables.inputmap.Party_Type_6    = Utility.getBlankStringIfNull(String.valueOf(signers[5].partyType));
        }
        
        
        //prashant singh ends
        //prashant singh on 16-11-2018--COLLATERAL STRUCTURE CHANGES
        //Area_of_the_Land__c
        list<clcommon__Collateral__c> Collateral= new list<clcommon__Collateral__c>( [Select Id,ExtentCarpet_area_Built_up_area__c,Floor_No__c,Margin__c,Area_of_the_Land__c,Valuation_Date__c,Builder_Present_Owner_Seller_Name__c,Flat_Door_Shop_Bungalow_Nos__c,State__c,Property_Pincode__c,UDS_Sq_Ft__c,Total_Market_value__c,Area_Square_Feet__c,SurveyKhasraKhataPatta_No__c,Nature_Of_Property__c,Stage_Sector_Ward_Block_No__c,Building_Society_Name__c,Street_NameNo__c,clcommon__City__c,TalukaTehsil__c,District_Name__c,clcommon__Address__c,clcommon__Property_Type__c,Market_valueProposedRepairs_Renovation__c,Market_Value_Of_The_Land__c,Buildup_Area__c from clcommon__Collateral__c Where genesis__Application__c =: appid and Active__c=true limit 1]);
        if(Collateral!=null && Collateral.size()>0)
        {
            if(Utility.getBlankStringIfNull(String.ValueOf(Collateral[0].clcommon__Property_Type__c))=='Flat') Ptype=Utility.getBlankStringIfNull(String.ValueOf(Collateral[0].UDS_Sq_Ft__c));                         
            else Ptype=Utility.getBlankStringIfNull(String.ValueOf(Collateral[0].Area_of_the_Land__c));            
            C1.inputVariables.inputmap.PIN_CODE=Utility.getBlankStringIfNull(Collateral[0].Property_Pincode__c);
            C1.inputVariables.inputmap.Village_Town=Utility.getBlankStringIfNull(Collateral[0].clcommon__City__c);
            C1.inputVariables.inputmap.State_Name=Utility.getBlankStringIfNull(Collateral[0].State__c);
            C1.inputVariables.inputmap.Market_value=Utility.getBlankStringIfNull(String.ValueOf(Collateral[0].Total_Market_value__c));
            C1.inputVariables.inputmap.District_Name=Utility.getBlankStringIfNull(Collateral[0].District_Name__c);
            C1.inputVariables.inputmap.Taluka_Tehsil=Utility.getBlankStringIfNull(Collateral[0].TalukaTehsil__c); 
            C1.inputVariables.inputmap.Street_Name=Utility.getBlankStringIfNull(Collateral[0].Street_NameNo__c);
            C1.inputVariables.inputmap.Building_Society_Name_No=Utility.getBlankStringIfNull(Collateral[0].Building_Society_Name__c);
            C1.inputVariables.inputmap.Ward_No=Utility.getBlankStringIfNull(Collateral[0].Stage_Sector_Ward_Block_No__c); 
            C1.inputVariables.inputmap.Survey_No=Utility.getBlankStringIfNull(Collateral[0].SurveyKhasraKhataPatta_No__c);
            C1.inputVariables.inputmap.Nature_Property=Utility.getBlankStringIfNull(Collateral[0].Nature_Of_Property__c);
            C1.inputVariables.inputmap.Built_up_area=Utility.getBlankStringIfNull(string.valueOf(Collateral[0].ExtentCarpet_area_Built_up_area__c)); 
            C1.inputVariables.inputmap.Site_extent               = string.valueOf(Collateral[0].Area_of_the_Land__c);
            C1.inputVariables.inputmap.Plot_Door_Bungalow_No               = string.valueOf(Collateral[0].Flat_Door_Shop_Bungalow_Nos__c);
            C1.inputVariables.inputmap.Seller_Name=Utility.getBlankStringIfNull(Collateral[0].Builder_Present_Owner_Seller_Name__c );
            C1.inputVariables.inputmap.Valuation_report_date=Utility.getBlankStringIfNull(dateFormatterChange(Collateral[0].Valuation_Date__c));
            C1.inputVariables.inputmap.Floor_No=Utility.getBlankStringIfNull(Collateral[0].Floor_No__c);
            C1.inputVariables.inputmap.Margin=Utility.getBlankStringIfNull(String.ValueOf((Collateral[0].Margin__c)));
        }
        
        
        //prashant singh ends 
        
        C1.inputVariables.inputmap.Auth_Sign_Bnk=   Constants.KvbBank ;
        C1.inputVariables.inputmap.Extent_Site_Uds=Ptype;
        C1.inputVariables.inputmap.MCLR_TYPE=Utility.getBlankStringIfNull(appln.MCLR_Type__c);
        C1.inputVariables.inputmap.Loc_Ref_Branch=Utility.getBlankStringIfNull(appln.Branch_Name__c);
        C1.inputVariables.inputmap.Doc_gen_date=Utility.getBlankStringIfNull(dateFormatterChange(appln.Today_Date__c));
        C1.inputVariables.inputmap.Branch_code=Utility.getBlankStringIfNull(appln.Branch_Code__c);
        C1.inputVariables.inputmap.Application_number=Utility.getBlankStringIfNull(appln.Name);
        C1.inputVariables.inputmap.Financial_Yr=Utility.getBlankStringIfNull(String.ValueOf(appln.Sanction_Financial_Year__c));
        C1.inputVariables.inputmap.Int_type=Utility.getBlankStringIfNull(appln.genesis__Interest_Calculation_Method__c);// requirement  given by akshaya to tag mclr type on 16-10-2018
        C1.inputVariables.inputmap.Borrower1_Names=Utility.getBlankStringIfNull(appln.genesis__Account__r.Name);
        
        if(appln.genesis__Interest_Rate__c==null){
            appln.genesis__Interest_Rate__c=0;
        }
        C1.inputVariables.inputmap.Int_ROI=Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Interest_Rate__c.setScale(2)));
        C1.inputVariables.inputmap.Borrower1_Add_line1=Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonMailingStreet) ;
        C1.inputVariables.inputmap.Borrower1_Add_line2=Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonMailingCity) ;
        C1.inputVariables.inputmap.Borrower1_Add_line3=Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonMailingState) +''+Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonMailingPostalCode);
        C1.inputVariables.inputmap.Borrower1_F_H_D_NAME1=Utility.getBlankStringIfNull(appln.genesis__Account__r.Father_Husband_Daughter_Name__c);
        C1.inputVariables.inputmap.Application_date=Utility.getBlankStringIfNull(dateFormatterChange(appln.Created_Date__c));
        // C1.inputVariables.inputmap.Margin=Utility.getBlankStringIfNull(String.ValueOf((appln.genesis__Margin__c)));
        system.debug('Margin:----'+ C1.inputVariables.inputmap.Margin);
        C1.inputVariables.inputmap.MCLR_Rate=Utility.getBlankStringIfNull(String.ValueOf(appln.MCLR_Rate__c));
        C1.inputVariables.inputmap.Loan_tenor=Utility.getBlankStringIfNull(String.ValueOf(appln.Sanctioned_Tenure__c));
        C1.inputVariables.inputmap.Loan_Purpose=Utility.getBlankStringIfNull(appln.Loan_Purpose__c);
        C1.inputVariables.inputmap.Repay_Method=Utility.getBlankStringIfNull(appln.genesis__Payment_Frequency__c);    
        C1.inputVariables.inputmap.EMI_amount=Utility.getBlankStringIfNull(String.ValueOf(appln.Sanctioned_EMI__c)); 
        C1.inputVariables.inputmap.Holiday_period=Utility.getBlankStringIfNull(String.ValueOf(appln.Holiday_Period__c));
        C1.inputVariables.inputmap.Loan_product=Utility.getBlankStringIfNull(appln.genesis__CL_Product_Name__c);
        C1.inputVariables.inputmap.Ap_LT=Utility.getBlankStringIfNull(String.ValueOf(integer.valueOf(appln.Sanction_Authority_Limit__c))); 
        C1.inputVariables.inputmap.dd_fi=Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Expected_First_Payment_Date__c));
        C1.inputVariables.inputmap.ROI_MCLR=Utility.getBlankStringIfNull(String.ValueOf(appln.Diff_B_w_ROI_MCLR__c));
        C1.inputVariables.inputmap.Rating_Freq=Utility.getBlankStringIfNull(String.ValueOf(appln.Rating_Frequency__c));
        C1.inputVariables.inputmap.PreClosure_Charges=Utility.getBlankStringIfNull(String.ValueOf(appln.PreClosure_Interest_Rate__c));
        
        C1.inputVariables.inputmap.Penal_Interest=string.valueof(KVB_Company_Details__c.getOrgDefaults().Penal_Interest__c); 
        C1.inputVariables.inputmap.Conditions_LOS=Utility.getBlankStringIfNull(appln.Conditions_By_Sanction_Authority__c);
        
        C1.inputVariables.inputmap.Non_refundable_charges=Utility.getBlankStringIfNull(String.ValueOf(appln.Non_Refundable_Charges__c));
        
        C1.inputVariables.inputmap.Processing_charges=Utility.getBlankStringIfNull(String.ValueOf(appln.Processing_Fee__c));
        C1.inputVariables.inputmap.Doc_gen_date=Utility.getBlankStringIfNull(dateFormatterChange(appln.Today_Date__c));
        C1.inputVariables.inputmap.Borrower1_Name1=Utility.getBlankStringIfNull(appln.genesis__Account__r.Full_Name__c);
        if(appln.genesis__Account__r.Father_Husband_Daughter_Name__c!=null && (!String.isBlank(appln.genesis__Account__r.Father_Husband_Daughter_Name__c)))
            C1.inputVariables.inputmap.Borrower1_F_H_D_NAME1='S/D/W of  '+Utility.getBlankStringIfNull(appln.genesis__Account__r.Father_Husband_Daughter_Name__c);
        C1.inputVariables.inputmap.Borrower1_Add_line1=Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonMailingStreet) ;
        C1.inputVariables.inputmap.Borrower1_Add_line2=Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonMailingCity) ;
        C1.inputVariables.inputmap.Borrower1_Add_line3=Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonMailingState) +'  '+Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonMailingPostalCode);
        C1.inputVariables.inputmap.Tittle_B1=Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonTitle) ;
        C1.inputVariables.inputmap.Borrower1_Names=Utility.getBlankStringIfNull(appln.genesis__Account__r.Full_Name__c);
        //added by prashant singh
        C1.inputVariables.inputmap.Sanction_Ref_Number=Utility.getBlankStringIfNull(String.ValueOf(appln.Sanction_Reference_Number__c));
        C1.inputVariables.inputmap.Sanction_date=Utility.dateFormatterNew();
        //C1.inputVariables.inputmap.Site_extent                              = Utility.getBlankStringIfNull(appln.Area_of_the_Land__c);
        system.Debug('appln.Type_Of_Charge__c'+appln.Type_Of_Charge__c);
        
        C1.inputVariables.inputmap.Type_of_Charge     = Utility.getBlankStringIfNull(appln.Type_Of_Charge__c);
        system.Debug('C1.inputVariables.inputmapc'+C1.inputVariables.inputmap.Type_of_Charge);
        String TempAaadhar = appln.genesis__Account__r.Aadhaar_Number__pc!=null?appln.genesis__Account__r.Aadhaar_Number__pc:'';
        system.debug('TempAaadhar:-'+TempAaadhar);
        TempAaadhar=WS_getAadharNo.getAadharNo(TempAaadhar);
        system.debug('TempAaadhar:-'+TempAaadhar);
        
        C1.inputVariables.inputmap.Borrower1_Aadhaar                  = Utility.getBlankStringIfNull(String.ValueOf(TempAaadhar));
        C1.inputVariables.inputmap.Borrower1_Phone=Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonMobilePhone);
        //C1.inputVariables.inputmap.Borrower1_Phone                    = Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Account__r.Phone));
        C1.inputVariables.inputmap.Borrower1_Email                    = Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Account__r.Person_Email__c));
        C1.inputVariables.inputmap.Borrower1_PAN                      = Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Account__r.Pan_Number__c));
        
        //prashant ends
        
        for(integer i=0; i<COparties.size(); i++){
            
            if(i==0){
                C1.inputVariables.inputmap.Borrower2_Name1=Utility.getBlankStringIfNull(COparties[i].genesis__Party_Account_Name__r.Full_Name__c);
                if(COparties[i].genesis__Party_Account_Name__r.Father_Husband_Daughter_Name__c!=null && (!String.isBlank(COparties[i].genesis__Party_Account_Name__r.Father_Husband_Daughter_Name__c)))
                    C1.inputVariables.inputmap.Borrower2_F_H_D_NAME1='S/D/W of  '+Utility.getBlankStringIfNull(COparties[i].genesis__Party_Account_Name__r.Father_Husband_Daughter_Name__c); 
                C1.inputVariables.inputmap.Borrower2_Names=Utility.getBlankStringIfNull(COparties[i].genesis__Party_Account_Name__r.Full_Name__c);
                C1.inputVariables.inputmap.Borrower2_Add_line1=Utility.getBlankStringIfNull(COparties[i].genesis__Party_Account_Name__r.PersonMailingStreet) ;
                C1.inputVariables.inputmap.Borrower2_Add_line2=Utility.getBlankStringIfNull(COparties[i].genesis__Party_Account_Name__r.PersonMailingCity) ;
                C1.inputVariables.inputmap.Borrower2_Add_line3=Utility.getBlankStringIfNull(COparties[i].genesis__Party_Account_Name__r.PersonMailingState) +'  '+Utility.getBlankStringIfNull(COparties[i].genesis__Party_Account_Name__r.PersonMailingPostalCode);
                C1.inputVariables.inputmap.Tittle_B2=Utility.getBlankStringIfNull(COparties[i].genesis__Party_Account_Name__r.PersonTitle) ;    
                
                //added by prashant singh
                string TempAaadhar0 = COparties[i].genesis__Party_Account_Name__r.Aadhaar_Number__pc;
                //!=null?appln.genesis__Account__r.Aadhaar_Number__pc:'';
                system.debug('TempAaadhar0:-'+TempAaadhar0);
                
                TempAaadhar0=WS_getAadharNo.getAadharNo(TempAaadhar0);
                system.debug('TempAaadhar0:-'+TempAaadhar0);
                
                C1.inputVariables.inputmap.Borrower2_Aadhaar                  = Utility.getBlankStringIfNull(String.ValueOf(TempAaadhar0));
                C1.inputVariables.inputmap.Borrower2_Phone                    = Utility.getBlankStringIfNull(String.ValueOf(COparties[i].genesis__Party_Account_Name__r.PersonMobilePhone));
                C1.inputVariables.inputmap.Borrower2_Email                    = Utility.getBlankStringIfNull(String.ValueOf(COparties[i].genesis__Party_Account_Name__r.Person_Email__c));
                C1.inputVariables.inputmap.Borrower2_PAN                      = Utility.getBlankStringIfNull(String.ValueOf(COparties[i].genesis__Party_Account_Name__r.Pan_Number__c));
                //prashant singh ends      
                
            }
            
            if(i==1){
                C1.inputVariables.inputmap.Borrower3_Name1=Utility.getBlankStringIfNull(COparties[i].genesis__Party_Account_Name__r.Full_Name__c);
                if(COparties[i].genesis__Party_Account_Name__r.Father_Husband_Daughter_Name__c!=null && (!String.isBlank(COparties[i].genesis__Party_Account_Name__r.Father_Husband_Daughter_Name__c)))
                    C1.inputVariables.inputmap.Borrower3_F_H_D_NAME1='S/D/W of  '+Utility.getBlankStringIfNull(COparties[i].genesis__Party_Account_Name__r.Father_Husband_Daughter_Name__c);
                C1.inputVariables.inputmap.Borrower3_Names=Utility.getBlankStringIfNull(COparties[i].genesis__Party_Account_Name__r.Full_Name__c);
                C1.inputVariables.inputmap.Borrower3_Add_line1=Utility.getBlankStringIfNull(COparties[i].genesis__Party_Account_Name__r.PersonMailingStreet) ;
                C1.inputVariables.inputmap.Borrower3_Add_line2=Utility.getBlankStringIfNull(COparties[i].genesis__Party_Account_Name__r.PersonMailingCity) ;
                C1.inputVariables.inputmap.Borrower3_Add_line3=Utility.getBlankStringIfNull(COparties[i].genesis__Party_Account_Name__r.PersonMailingState) +'  '+Utility.getBlankStringIfNull(COparties[i].genesis__Party_Account_Name__r.PersonMailingPostalCode);
                C1.inputVariables.inputmap.Tittle_B3=Utility.getBlankStringIfNull(COparties[i].genesis__Party_Account_Name__r.PersonTitle) ;    
                
                //added by prashant singh
                string TempAaadhar1 = COparties[i].genesis__Party_Account_Name__r.Aadhaar_Number__pc;
                //!=null?appln.genesis__Account__r.Aadhaar_Number__pc:'';
                system.debug('TempAaadhar1:-'+TempAaadhar1);
                TempAaadhar1=WS_getAadharNo.getAadharNo(TempAaadhar1);
                system.debug('TempAaadhar1:-'+TempAaadhar1);
                C1.inputVariables.inputmap.Borrower3_Aadhaar                  = Utility.getBlankStringIfNull(String.ValueOf(TempAaadhar1));
                // C1.inputVariables.inputmap.Borrower3_Aadhaar                  = Utility.getBlankStringIfNull(String.ValueOf(COparties[i].genesis__Party_Account_Name__r.Aadhaar_Number__pc));
                C1.inputVariables.inputmap.Borrower3_Phone                    = Utility.getBlankStringIfNull(String.ValueOf(COparties[i].genesis__Party_Account_Name__r.PersonMobilePhone));
                C1.inputVariables.inputmap.Borrower3_Email                    = Utility.getBlankStringIfNull(String.ValueOf(COparties[i].genesis__Party_Account_Name__r.Person_Email__c));
                C1.inputVariables.inputmap.Borrower3_PAN                      = Utility.getBlankStringIfNull(String.ValueOf(COparties[i].genesis__Party_Account_Name__r.Pan_Number__c));
                //prashant singh ends      
                
            }
            if(i==2){
                C1.inputVariables.inputmap.Borrower4_Name1=Utility.getBlankStringIfNull(COparties[i].genesis__Party_Account_Name__r.Full_Name__c);
                if(COparties[i].genesis__Party_Account_Name__r.Father_Husband_Daughter_Name__c!=null && (!String.isBlank(COparties[i].genesis__Party_Account_Name__r.Father_Husband_Daughter_Name__c)))
                    C1.inputVariables.inputmap.Borrower4_F_H_D_NAME1='S/D/W of  '+Utility.getBlankStringIfNull(COparties[i].genesis__Party_Account_Name__r.Father_Husband_Daughter_Name__c);
                C1.inputVariables.inputmap.Borrower4_Names=Utility.getBlankStringIfNull(COparties[i].genesis__Party_Account_Name__r.Full_Name__c);
                C1.inputVariables.inputmap.Borrower4_Add_line1=Utility.getBlankStringIfNull(COparties[i].genesis__Party_Account_Name__r.PersonMailingStreet) ;
                C1.inputVariables.inputmap.Borrower4_Add_line2=Utility.getBlankStringIfNull(COparties[i].genesis__Party_Account_Name__r.PersonMailingCity) ;
                C1.inputVariables.inputmap.Borrower4_Add_line3=Utility.getBlankStringIfNull(COparties[i].genesis__Party_Account_Name__r.PersonMailingState) +'  '+Utility.getBlankStringIfNull(COparties[i].genesis__Party_Account_Name__r.PersonMailingPostalCode);
                C1.inputVariables.inputmap.Tittle_B4=Utility.getBlankStringIfNull(COparties[i].genesis__Party_Account_Name__r.PersonTitle) ;    
                
                //added by prashant singh
                string TempAaadhar2  = COparties[i].genesis__Party_Account_Name__r.Aadhaar_Number__pc;
                //!=null?appln.genesis__Account__r.Aadhaar_Number__pc:'';
                system.debug('TempAaadhar2:-'+TempAaadhar2);
                TempAaadhar2=WS_getAadharNo.getAadharNo(TempAaadhar2);
                system.debug('TempAaadhar2:-'+TempAaadhar2);
                C1.inputVariables.inputmap.Borrower4_Aadhaar                  = Utility.getBlankStringIfNull(String.ValueOf(TempAaadhar2));                
                // C1.inputVariables.inputmap.Borrower4_Aadhaar                  = Utility.getBlankStringIfNull(String.ValueOf(COparties[i].genesis__Party_Account_Name__r.Aadhaar_Number__pc));
                C1.inputVariables.inputmap.Borrower4_Phone                    = Utility.getBlankStringIfNull(String.ValueOf(COparties[i].genesis__Party_Account_Name__r.PersonMobilePhone));
                C1.inputVariables.inputmap.Borrower4_Email                    = Utility.getBlankStringIfNull(String.ValueOf(COparties[i].genesis__Party_Account_Name__r.Person_Email__c));
                C1.inputVariables.inputmap.Borrower4_PAN                      = Utility.getBlankStringIfNull(String.ValueOf(COparties[i].genesis__Party_Account_Name__r.Pan_Number__c));
                //prashant singh ends 
            }
            if(i==3){
                C1.inputVariables.inputmap.Borrower5_Names=Utility.getBlankStringIfNull(COparties[i].genesis__Party_Account_Name__r.Full_Name__c);
            }
        }
        for(integer i=0; i<Gparties.size(); i++){
            
            if(i==0){
                C1.inputVariables.inputmap.Guarantor1_Names=Utility.getBlankStringIfNull(Gparties[i].genesis__Party_Account_Name__r.Full_Name__c);
                
                //added by prashant singh    
                string TempAaadhar3 = Gparties[i].genesis__Party_Account_Name__r.Aadhaar_Number__pc;
                //!=null?appln.genesis__Account__r.Aadhaar_Number__pc:'';
                system.debug('TempAaadhar3:-'+TempAaadhar3);
                TempAaadhar3=WS_getAadharNo.getAadharNo(TempAaadhar3);
                system.debug('TempAaadhar3:-'+TempAaadhar3);
                C1.inputVariables.inputmap.Guarantor1_Aadhaar                  = Utility.getBlankStringIfNull(String.ValueOf(TempAaadhar3));                    
                //C1.inputVariables.inputmap.Guarantor1_Aadhaar                 = Utility.getBlankStringIfNull(String.ValueOf(Gparties[i].genesis__Party_Account_Name__r.Aadhaar_Number__pc));
                C1.inputVariables.inputmap.Guarantor1_Phone                   = Utility.getBlankStringIfNull(String.ValueOf(Gparties[i].genesis__Party_Account_Name__r.PersonMobilePhone));
                C1.inputVariables.inputmap.Guarantor1_Email                   = Utility.getBlankStringIfNull(String.ValueOf(Gparties[i].genesis__Party_Account_Name__r.Person_Email__c));
                C1.inputVariables.inputmap.Guarantor1_PAN                     = Utility.getBlankStringIfNull(String.ValueOf(Gparties[i].genesis__Party_Account_Name__r.Pan_Number__c));
                //prashant singh ends
                
            }
            if(i==1){
                C1.inputVariables.inputmap.Guarantor2_Names=Utility.getBlankStringIfNull(Gparties[i].genesis__Party_Account_Name__r.Full_Name__c);
                //added by prashant singh      
                string TempAaadhar4 = Gparties[i].genesis__Party_Account_Name__r.Aadhaar_Number__pc;
                //!=null?appln.genesis__Account__r.Aadhaar_Number__pc:'';
                system.debug('TempAaadhar4:-'+TempAaadhar4);
                TempAaadhar4=WS_getAadharNo.getAadharNo(TempAaadhar4);
                system.debug('TempAaadhar4:-'+TempAaadhar4);
                C1.inputVariables.inputmap.Guarantor2_Aadhaar                  = Utility.getBlankStringIfNull(String.ValueOf(TempAaadhar4)); 
                
                C1.inputVariables.inputmap.Guarantor2_Aadhaar                 = Utility.getBlankStringIfNull(String.ValueOf(Gparties[i].genesis__Party_Account_Name__r.Aadhaar_Number__pc));
                C1.inputVariables.inputmap.Guarantor2_Phone                   = Utility.getBlankStringIfNull(String.ValueOf(Gparties[i].genesis__Party_Account_Name__r.PersonMobilePhone));
                C1.inputVariables.inputmap.Guarantor2_Email                   = Utility.getBlankStringIfNull(String.ValueOf(Gparties[i].genesis__Party_Account_Name__r.Person_Email__c));
                C1.inputVariables.inputmap.Guarantor2_PAN                     = Utility.getBlankStringIfNull(String.ValueOf(Gparties[i].genesis__Party_Account_Name__r.Pan_Number__c));
                //prashant singh ends
            }
            if(i==2){
                C1.inputVariables.inputmap.Guarantor3_Names=Utility.getBlankStringIfNull(Gparties[i].genesis__Party_Account_Name__r.Full_Name__c);
            }
            if(i==3){
                C1.inputVariables.inputmap.Guarantor4_Names=Utility.getBlankStringIfNull(Gparties[i].genesis__Party_Account_Name__r.Full_Name__c);
            }
            if(i==4){
                C1.inputVariables.inputmap.Guarantor5_Names=Utility.getBlankStringIfNull(Gparties[i].genesis__Party_Account_Name__r.Full_Name__c);
            }
            if(i==5){
                C1.inputVariables.inputmap.Guarantor6_Names=Utility.getBlankStringIfNull(Gparties[i].genesis__Party_Account_Name__r.Full_Name__c);
            }
            if(i==6){
                C1.inputVariables.inputmap.Guarantor7_Names=Utility.getBlankStringIfNull(Gparties[i].genesis__Party_Account_Name__r.Full_Name__c);
            }
            if(i==7){
                C1.inputVariables.inputmap.Guarantor8_Names=Utility.getBlankStringIfNull(Gparties[i].genesis__Party_Account_Name__r.Full_Name__c);
            }
            if(i==8){
                C1.inputVariables.inputmap.Guarantor9_Names=Utility.getBlankStringIfNull(Gparties[i].genesis__Party_Account_Name__r.Full_Name__c);
            }
            if(i==9){
                C1.inputVariables.inputmap.Guarantor10_Names=Utility.getBlankStringIfNull(Gparties[i].genesis__Party_Account_Name__r.Full_Name__c);
            }
        }
        
        //prashant singh
        //esign's      
        C1.inputVariables.inputmap.bEsign1                            = '';
        C1.inputVariables.inputmap.bEsign2                            = '';
        C1.inputVariables.inputmap.bEsign3                            = '';
        C1.inputVariables.inputmap.bEsign4                            = '';
        
        
        C1.inputVariables.inputmap.gEsign1                            = '';
        C1.inputVariables.inputmap.gEsign2                            = '';
        //prashant singh ends 
        system.debug(' C1.inputVariables.inputmap.'+ C1.inputVariables.inputmap);
        return C1;
    }
    // ----------------------------------HL End Here--------------------------------
    
    //-----------------------------------Personal Loan Start Here--------------------------
    // PL Santion letter Digio serivice 
    public static PL_Approve_Sanction_DigioDocreq getPLSanctionLetter(String appId,String templateId){
        genesis__Applications__c appln = new genesis__Applications__c();
        appln = [Select id,genesis__Account__c,genesis__Payment_Amount__c,genesis__Account__r.Aadhaar_Number__pc,Conditions_By_Sanction_Authority__c,genesis__Account__r.Pan_Number__c,Penal_Interest__c,genesis__Account__r.PersonEmail,Preclosure_Charges__c,Non_Refundable_Charges__c,genesis__Account__r.PersonMobilePhone,genesis__Account__r.Name,Branch_Name__c,genesis__Loan_Amount__c,
                 Branch_Code__c,Sanction_Amount_Words__c,Created_Date__c,Name,genesis__Account__r.BillingStreet,Sanction_Financial_Year__c,Sanction_Date__c,Amount_in_Words_And_Figures__c,
                 genesis__Account__r.BillingCity,genesis__Account__r.BillingState,genesis__Account__r.BillingCountry,genesis__CL_Product_Name__c,genesis__Term__c,
                 genesis__Interest_Rate__c,Sanctioned_EMI__c,Sanctioned_Tenure__c,Sanction_Authority_Limit__c,Processing_Fee__c,Today_Date__c,genesis__Account__r.Father_Husband_Daughter_Name__c,genesis__Account__r.PersonMailingStreet,
                 genesis__Account__r.PersonMailingCity,genesis__Account__r.PersonMailingState,genesis__Account__r.PersonMailingPostalCode,genesis__Account__r.Full_Name__c  
                 from genesis__Applications__c where id =:appId];
        
        PL_Approve_Sanction_DigioDocreq PreApp=new PL_Approve_Sanction_DigioDocreq();
        
        
        PreApp.inputVariables   = new PL_Approve_Sanction_DigioDocreq.cls_inputVariables();
        PreApp.owner_tenantId   = 'cuecent_tenant';
        PreApp.exe_tenantId = 'cuecent_tenant';
        PreApp.serviceName      = 'TestJsonStr';
        PreApp.inputVariables.unique_key    = templateId;
        PreApp.inputVariables.pdf_unique_key = appln.Id;
        PreApp.inputVariables.in_msg        = '';
        PreApp.inputVariables.inputmap  = new PL_Approve_Sanction_DigioDocreq.cls_inputmap();
        
        PreApp.inputVariables.inputmap.Auth_Sign_Bnk= Constants.KvbBank ;
        PreApp.inputVariables.inputmap.Loc_Ref_Branch=Utility.getBlankStringIfNull(appln.Branch_Name__c);
        PreApp.inputVariables.inputmap.Branch_code=Utility.getBlankStringIfNull(appln.Branch_Code__c);
        PreApp.inputVariables.inputmap.Application_date=Utility.getBlankStringIfNull(String.ValueOf(appln.Created_Date__c));
        PreApp.inputVariables.inputmap.Application_number=Utility.getBlankStringIfNull(appln.Name);
        //PreApp.inputVariables.inputmap.Financial_Yr=Utility.getBlankStringIfNull(String.ValueOf(appln.Sanction_Financial_Year__c));
        //PreApp.inputVariables.inputmap.sanction_date=Utility.getBlankStringIfNull(String.ValueOf(appln.Sanction_Date__c));
        PreApp.inputVariables.inputmap.Financial_Yr=Utility.getBlankStringIfNull(String.ValueOf(system.today().Year()));
        PreApp.inputVariables.inputmap.sanction_date=Utility.dateFormatterNew();
        PreApp.inputVariables.inputmap.Loan_product=Utility.getBlankStringIfNull(appln.genesis__CL_Product_Name__c);
        PreApp.inputVariables.inputmap.Ap_LT=Utility.getBlankStringIfNull(String.ValueOf(appln.Sanction_Authority_Limit__c)); 
        //PreApp.inputVariables.inputmap.Ap_LT_inwords=Utility.getBlankStringIfNull(appln.Sanction_Amount_Words__c);
        PreApp.inputVariables.inputmap.Loan_tenor=Utility.getBlankStringIfNull(String.ValueOf(appln.Sanctioned_Tenure__c));
        if(appln.genesis__Interest_Rate__c==null){
            appln.genesis__Interest_Rate__c=0;
        }
        PreApp.inputVariables.inputmap.Int_ROI=Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Interest_Rate__c.setScale(2)));
        PreApp.inputVariables.inputmap.Processing_charges=Utility.getBlankStringIfNull(String.ValueOf(appln.Processing_Fee__c));
        //PreApp.inputVariables.inputmap.Doc_gen_date=Utility.getBlankStringIfNull(String.ValueOf(appln.Today_Date__c));
        PreApp.inputVariables.inputmap.Borrower1_Name1=Utility.getBlankStringIfNull(appln.genesis__Account__r.Full_Name__c);
        PreApp.inputVariables.inputmap.Borrower1_Add_line1=Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonMailingStreet) ;
        PreApp.inputVariables.inputmap.Borrower1_Add_line2=Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonMailingCity) ;
        PreApp.inputVariables.inputmap.Borrower1_Add_line3=Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonMailingState) +'  '+Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonMailingPostalCode);
        PreApp.inputVariables.inputmap.Conditions_LOS= Utility.getBlankStringIfNull(appln.Conditions_By_Sanction_Authority__c);
        PreApp.inputVariables.inputmap.Borrower1_Pan= Utility.getBlankStringIfNull(appln.genesis__Account__r.Pan_Number__c);
        if(appln.Penal_Interest__c==null){
            appln.Penal_Interest__c=0;
        }
        PreApp.inputVariables.inputmap.Penal_Interest=Utility.getBlankStringIfNull(String.ValueOf(appln.Penal_Interest__c.setScale(2)));
        PreApp.inputVariables.inputmap.Borrower1_Email=Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonEmail);
        if(appln.Preclosure_Charges__c==null){
            appln.Preclosure_Charges__c=0;
        } 
        string TempAaadhar = appln.genesis__Account__r.Aadhaar_Number__pc!=null?appln.genesis__Account__r.Aadhaar_Number__pc:'';
        TempAaadhar=WS_getAadharNo.getAadharNo(TempAaadhar);
        PreApp.inputVariables.inputmap.Borrower1_Aadhaar=Utility.getBlankStringIfNull(TempAaadhar);
        PreApp.inputVariables.inputmap.PreClosure_Charges=Utility.getBlankStringIfNull(String.ValueOf(appln.Preclosure_Charges__c.setScale(2)));//correction by prashant singh--already this field decimal point is 2 ---no use of .setScale(2)
        //PreApp.inputVariables.inputmap.Borrower1_Aadhaar=Utility.getBlankStringIfNull(appln.genesis__Account__r.Aadhaar_Number__pc);
        if(appln.Sanctioned_EMI__c==null){
            appln.Sanctioned_EMI__c=0;
        }
        PreApp.inputVariables.inputmap.EMI_amount=Utility.getBlankStringIfNull(String.ValueOf(appln.Sanctioned_EMI__c.setScale(2)));
        PreApp.inputVariables.inputmap.Borrower1_Phone=Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonMobilePhone);
        if(appln.Non_Refundable_Charges__c==null){
            appln.Non_Refundable_Charges__c=0;
        }
        PreApp.inputVariables.inputmap.Non_refundable_charges= Utility.getBlankStringIfNull(String.ValueOf(appln.Non_Refundable_Charges__c.setScale(2))) ;
        system.debug('##### digio request structrue ');
        return PreApp;
    }
    
    //Pl Loan Agreement letter
    public static PL_Loan_Agreement plLoanAgreement(String appId, String templateId){
        //removed---Name_Of_The_Builder__c--collateral structure change,Property_Pincode__c,Floor_No__c,UDS_Sq_Ft__c,Stage_Sector_Ward_Block_No__c,Property_City__c,Name_Of_The_Socity__c,Nature_Of_Property__c,Survey_No_Katha_No_Other_No_s__c,Flat_No__c,Existing_Built_up_Area__c,Property_Type__c,Street_Name__c,Taluka_Tehsil__c,Property_District__c,Property_State__c,Area_of_the_Land__c
        genesis__Applications__c appln = [select id,Diff_B_w_ROI_MCLR__c,Sanctioned_EMI__c,PreClosure_Interest_Rate__c,Branch_Code__c,Branch_State__c,Sanctioned_Tenure__c,FPIIntRepayInstal__c,FPIPrincRepayInstal__c,Record_Type_Name__c,Docgen_Fail__c,genesis__Account__c,Document_Generation__c,genesis__Expected_Close_Date__c,genesis__Expected_First_Payment_Date__c,Preclosure_Charges__c,Rating_Frequency__c,
                                          MCLR_Rate__c,Excess_MCLR__c,genesis__Interest_Calculation_Method__c,Loan_Purpose__c,Holiday_Period__c,Sanction_Doc_Generation_Check__c,
                                          genesis__Amortization_Term__c,Sanction_Amount_Words__c,Sanction_Authority_Limit__c,genesis__Term__c,genesis__Interest_Rate__c,genesis__Loan_Amount__c,Sanction_Date__c,Sanction_Reference_Number__c,
                                          Xerox_Reason1__c,Xerox_Reason2__c,Xerox_Doc_Table__c,MOD_Date__c,MOD_Branch__c,Primary_Applicant__c,
                                          Disbursal_Financial_Year__c,genesis__Disbursement_Date__c,MCLR_Type__c,Month_Of_Disbursal__c,Day_Of_Disbursal__c,Sub_Stage__c,Name,genesis__Account__r.Name,
                                          genesis__Account__r.PersonMobilePhone,genesis__Account__r.CIBIL_Score__c,Branch_Name__c,genesis__CL_Product_Name__c,
                                          genesis__Account__r.Father_Husband_Daughter_Name__c,genesis__Account__r.Age__c,
                                          Advance_Payment_Made_If_Any__c,Date_Of_Sale_Agreement__c,
                                          
                                          genesis__Account__r.PersonMailingStreet,genesis__Account__r.PersonMailingCity,genesis__Account__r.PersonMailingState,
                                          genesis__Account__r.PersonMailingPostalCode,genesis__Account__r.PersonMailingCountry,Penal_Interest__c
                                          from genesis__Applications__c where ID =:appId];
        PL_Loan_Agreement pla                                    = new PL_Loan_Agreement();
        pla.inputVariables                                       = new PL_Loan_Agreement.cls_inputVariables();
        pla.owner_tenantId                                       = 'cuecent_tenant';
        pla.exe_tenantId                                         = 'cuecent_tenant';
        pla.serviceName                                          = 'TestJsonStr';
        pla.inputVariables.unique_key                            = templateId;
        pla.inputVariables.pdf_unique_key                        = appln.Id;
        pla.inputVariables.in_msg                                = '';
        pla.inputVariables.inputmap                              = new PL_Loan_Agreement.cls_inputmap();
        pla.inputVariables.inputmap.Loc_Ref_Branch               = Utility.getBlankStringIfNull(appln.Branch_Name__c);
        pla.inputVariables.inputmap.Borrower_Details             = Utility.getBlankStringIfNull(appln.genesis__Account__r.name);
        pla.inputVariables.inputmap.Ap_LT                        = Utility.getBlankStringIfNull(String.valueOf(appln.Sanction_Authority_Limit__c));
        pla.inputVariables.inputmap.Ap_LT_inwords                = Utility.getBlankStringIfNull(String.valueOf(appln.Sanction_Amount_Words__c));
        pla.inputVariables.inputmap.Int_ROI                      = Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Interest_Rate__c.setScale(2)));
        pla.inputVariables.inputmap.PreClosure_Charges           = Utility.getBlankStringIfNull(String.ValueOf(appln.PreClosure_Interest_Rate__c));
        pla.inputVariables.inputmap.Penal_Interest               = Utility.getBlankStringIfNull(String.ValueOf(appln.Penal_Interest__c));
        pla.inputVariables.inputmap.Loan_tenor                   = Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Term__c));
        pla.inputVariables.inputmap.EMI_amount                   = Utility.getBlankStringIfNull(String.ValueOf(appln.Sanctioned_EMI__c));
        pla.inputVariables.inputmap.DD_FI                        = Utility.getBlankStringIfNull(formatDate(appln.FPIPrincRepayInstal__c));
        pla.inputVariables.inputmap.DD_LI                        = Utility.getBlankStringIfNull(formatDate( (appln.FPIPrincRepayInstal__c).addMonths(integer.valueOf(appln.Sanctioned_Tenure__c)-1)));
        pla.inputVariables.inputmap.Auth_Sign_Bnk                = Constants.KvbBank;
        pla.inputVariables.inputmap.Borrower1_Names              = Utility.getBlankStringIfNull(appln.genesis__Account__r.name);
        pla.inputVariables.inputmap.Disb_Ref_Day                 = system.now().format('dd');//Utility.getBlankStringIfNull(String.ValueOf(appln.Day_Of_Disbursal__c));
        pla.inputVariables.inputmap.Disb_Ref_Month               = system.now().format('MMMM');//Utility.getBlankStringIfNull(String.ValueOf(appln.Month_Of_Disbursal__c));
        pla.inputVariables.inputmap.Disb_Ref_Year                = system.now().format('yyyy');//Utility.getBlankStringIfNull(String.ValueOf(appln.Disbursal_Financial_Year__c));
        return pla;
    }
    //----------------------------------------------PL END Here-----------------------------------
    
    //----------------------------------------------LAP Start Here-----------------------------------
    //LAP C1 Doc
    public static LAPSanction_DocReq C1SanctionAcknowledgementforLAP(String appId, String templateId){
        try{ 
            genesis__Applications__c appln = new genesis__Applications__c();
            appln   = [Select id,genesis__Account__c,MCLR_Rate__c,genesis__Margin__c,genesis__Account__r.Salutation,genesis__Account__r.Aadhaar_Number__pc,genesis__Account__r.Phone,genesis__Account__r.Person_Email__c,genesis__Account__r.Pan_Number__c,Penal_Interest__c,LTV__c,PreClosure_Interest_Rate__c,Interest_Variation__c,Processing_charges_with_GST__c,Preclosure_Charges__c,Non_Refundable_Charges__c,Holiday_Period__c,Processing_Charges__c,genesis__Account__r.Name,Branch_Name__c,Loan_Purpose__c,genesis__Payment_Frequency__c,Sanctioned_EMI__c,Sanctioned_Tenure__c,genesis__Loan_Amount__c,
                       Branch_Code__c,Sanction_Amount_Words__c,Created_Date__c,genesis__Interest_Calculation_Method__c,MCLR_Type__c,Name,genesis__Account__r.BillingStreet,Sanction_Financial_Year__c,Sanction_Date__c,Amount_in_Words_And_Figures__c,
                       genesis__Account__r.BillingCity,genesis__Account__r.BillingState,genesis__Account__r.BillingCountry,genesis__CL_Product_Name__c,genesis__Term__c,
                       genesis__Interest_Rate__c,Sanction_Authority_Limit__c,Processing_Fee__c,Today_Date__c,genesis__Account__r.Father_Husband_Daughter_Name__c,genesis__Account__r.PersonMailingStreet,
                       genesis__Account__r.PersonMailingCity,genesis__Account__r.PersonMailingState,genesis__Account__r.PersonMailingPostalCode,genesis__Account__r.Full_Name__c,genesis__Account__r.PersonMobilePhone  
                       from genesis__Applications__c where id =:appId];//added by prashant singh----genesis__Account__r.PersonMobilePhone--01/11/2018
            List<genesis__Application_Parties__c> parties           = new List<genesis__Application_Parties__c>();
            parties = [Select id,genesis__Application__c,genesis__Application__r.genesis__Account__r.Name,genesis__Application__r.genesis__Account__r.Full_Name__c,genesis__Application__r.genesis__Account__r.Aadhaar_Number__pc,genesis__Application__r.genesis__Account__r.Phone,genesis__Application__r.genesis__Account__r.Person_Email__c,genesis__Application__r.genesis__Account__r.Pan_Number__c,genesis__Application__r.genesis__Account__r.PersonMailingCity,genesis__Application__r.genesis__Account__r.PersonMailingState,genesis__Application__r.genesis__Account__r.PersonMailingStreet,Guarantor__c,genesis__Party_Account_Name__c,genesis__Application__r.genesis__Account__r.Salutation,genesis__Party_Account_Name__r.Salutation,Signatories__c,
                       genesis__Party_Account_Name__r.Name,Party_Sub_Type__c,genesis__Party_Type__c,Active__c,genesis__Party_Account_Name__r.Father_Husband_Daughter_Name__c,genesis__Application__r.genesis__Account__r.PersonMailingPostalCode,
                       genesis__Party_Account_Name__r.PersonMailingCity,genesis__Party_Account_Name__r.PersonMailingState,genesis__Party_Account_Name__r.PersonMailingPostalCode
                       ,genesis__Party_Account_Name__r.PersonMailingStreet,genesis__Party_Account_Name__r.Full_Name__c,genesis__Party_Account_Name__r.Aadhaar_Number__pc,genesis__Party_Account_Name__r.Phone,genesis__Party_Account_Name__r.Person_Email__c,genesis__Party_Account_Name__r.Pan_Number__c,genesis__Party_Account_Name__r.PersonMobilePhone from genesis__Application_Parties__c where genesis__Application__c = :appId 
                       AND genesis__Party_Type__c = 'Co-Borrower' AND Active__c =true];//added by prashant singh----genesis__Party_Account_Name__r.PersonMobilePhone--01/11/2018
            
            List<genesis__Application_Parties__c> partiesGurrenter = new List<genesis__Application_Parties__c>();
            partiesGurrenter = [Select id,genesis__Application__c,Guarantor__c,genesis__Party_Account_Name__c,Signatories__c,
                                genesis__Party_Account_Name__r.Name,Party_Sub_Type__c,genesis__Party_Type__c,Active__c,genesis__Party_Account_Name__r.Father_Husband_Daughter_Name__c,
                                genesis__Party_Account_Name__r.PersonMailingCity,genesis__Party_Account_Name__r.PersonMailingState,genesis__Party_Account_Name__r.PersonMailingPostalCode
                                ,genesis__Party_Account_Name__r.PersonMailingStreet,genesis__Party_Account_Name__r.Full_Name__c,genesis__Party_Account_Name__r.Aadhaar_Number__pc,genesis__Party_Account_Name__r.Phone,genesis__Party_Account_Name__r.Person_Email__c,genesis__Party_Account_Name__r.Pan_Number__c,genesis__Party_Account_Name__r.PersonMobilePhone from genesis__Application_Parties__c where genesis__Application__c = :appId 
                                AND genesis__Party_Type__c = 'Guarantor' AND Active__c =true];//added by prashant singh----genesis__Party_Account_Name__r.PersonMobilePhone--01/11/2018
            
            
            List<clcommon__Collateral__c> colllist = [SELECT id,clcommon__Postal_Code__c,SurveyKhasraKhataPatta_No__c,EM_Charge_Types__c,Buildup_Area__c,clcommon__City__c,EM_Charge_type__c,PlotDoorShopBungalow_No__c,ExtentCarpet_area_Built_up_area__c,Floor_No__c,Stage_Sector_Ward_Block_No__c,Building_Society_Name__c,Street_NameNo__c,VillageTown__c,TalukaTehsil__c,District_Name__c,State__c,Property_Pincode__c,Total_Market_value__c,Valuation_Date__c ,(SELECT Id,Account__c,Account__r.Name,Account__r.Salutation FROM Ownerships__r) FROM clcommon__Collateral__c WHERE Active__c = true AND genesis__Application__c = :appId];
            List<signersWrap> signers = new List<signersWrap>();
            signers.add(new signersWrap(appln.genesis__Account__r.Name,'Borrower'));
            for(genesis__Application_Parties__c br : parties){
                signers.add(new signersWrap(br.genesis__Party_Account_Name__r.Name,br.genesis__Party_Type__c));
                
            }
            for(genesis__Application_Parties__c gr : partiesGurrenter){
                signers.add(new signersWrap(gr.genesis__Party_Account_Name__r.Name,gr.genesis__Party_Type__c));
            }
            
            Map<String, String> colateralOwnerMap   = new Map<String, String>();
            for(clcommon__Collateral__c c : colllist){
                string ownerName    = '';
                for(Ownership__c owner : c.Ownerships__r){
                    if(owner.Account__r.Name != null){
                        if(owner.Account__r.Salutation != null)ownerName += owner.Account__r.Salutation+' ';
                        ownerName += owner.Account__r.Name+', ';
                    }
                    
                }
                // Decimal.valueOf('qwerty');
                ownerName = ownerName.trim();
                ownerName = ownerName.removeEnd(',');
                if(!colateralOwnerMap.containsKey(c.Id))
                    colateralOwnerMap.put(c.Id,ownerName);
            }
            
            
            LAPSanction_DocReq req  = new LAPSanction_DocReq();
            
            
            req.inputVariables                                  = new LAPSanction_DocReq.cls_inputVariables();
            req.owner_tenantId                                  = 'cuecent_tenant';
            req.exe_tenantId                                    = 'cuecent_tenant';
            req.serviceName                                     = 'TestJsonStr';
            req.inputVariables.unique_key                       = templateId;
            req.inputVariables.pdf_unique_key                   = appln.Id;
            req.inputVariables.in_msg                           = '';
            req.inputVariables.inputmap                         = new LAPSanction_DocReq.cls_inputmap();
            
            //req.inputVariables.inputmap.Auth_Sign_Bnk        = Constants.KvbBank ;  
            req.inputVariables.inputmap.Loc_Ref_Branch         = Utility.getBlankStringIfNull(appln.Branch_Name__c);
            req.inputVariables.inputmap.Branch_code            = Utility.getBlankStringIfNull(appln.Branch_Code__c);
            req.inputVariables.inputmap.Application_date       = Utility.getBlankStringIfNull(String.ValueOf(appln.Created_Date__c));
            req.inputVariables.inputmap.Application_number     = Utility.getBlankStringIfNull(appln.Name);
            req.inputVariables.inputmap.Financial_Yr           = Utility.getBlankStringIfNull(String.ValueOf(appln.Sanction_Financial_Year__c));
            req.inputVariables.inputmap.sanction_date          = Utility.dateFormatterNew();
            req.inputVariables.inputmap.Loan_product           = Utility.getBlankStringIfNull(appln.genesis__CL_Product_Name__c);
            req.inputVariables.inputmap.Ap_LT                  = Utility.getBlankStringIfNull(String.ValueOf(appln.Sanction_Authority_Limit__c)); 
            req.inputVariables.inputmap.Ap_LT_inwords          = Utility.getBlankStringIfNull(appln.Sanction_Amount_Words__c);
            req.inputVariables.inputmap.Loan_tenor             = Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Term__c));
            if(appln.genesis__Interest_Rate__c==null){
                appln.genesis__Interest_Rate__c=0;
            }
            ///start from here
            req.inputVariables.inputmap.MCLR_TYPE              = Utility.getBlankStringIfNull(String.ValueOf(appln.MCLR_Type__c));
            
            req.inputVariables.inputmap.MCLR_Rate              = Utility.getBlankStringIfNull(String.ValueOf(appln.MCLR_Rate__c));
            
            req.inputVariables.inputmap.Loan_Purpose           = Utility.getBlankStringIfNull(String.ValueOf(appln.Loan_Purpose__c));
            req.inputVariables.inputmap.Repay_Method           = Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Payment_Frequency__c));
            req.inputVariables.inputmap.EMI_amount             = Utility.getBlankStringIfNull(String.ValueOf(appln.Sanctioned_EMI__c.setScale(2)));
            req.inputVariables.inputmap.Loan_tenor             = Utility.getBlankStringIfNull(String.ValueOf(appln.Sanctioned_Tenure__c));
            req.inputVariables.inputmap.Holiday_period         = Utility.getBlankStringIfNull(String.ValueOf(appln.Holiday_Period__c));
            if(signers.size()>0){
                req.inputVariables.inputmap.Signer1         = Utility.getBlankStringIfNull(String.ValueOf(signers[0].name));
                req.inputVariables.inputmap.Party_Type_1    = Utility.getBlankStringIfNull(String.valueOf(signers[0].partyType));
            }
            if(signers.size()>1){
                req.inputVariables.inputmap.Signer2         = Utility.getBlankStringIfNull(String.ValueOf(signers[1].name));
                req.inputVariables.inputmap.Party_Type_2    = Utility.getBlankStringIfNull(String.valueOf(signers[1].partyType));
            }
            if(signers.size()>2){
                req.inputVariables.inputmap.Signer3         = Utility.getBlankStringIfNull(String.ValueOf(signers[2].name));
                req.inputVariables.inputmap.Party_Type_3    = Utility.getBlankStringIfNull(String.valueOf(signers[2].partyType));
            }
            if(signers.size()>3){
                req.inputVariables.inputmap.Signer4         = Utility.getBlankStringIfNull(String.ValueOf(signers[3].name));
                req.inputVariables.inputmap.Party_Type_4    = Utility.getBlankStringIfNull(String.valueOf(signers[3].partyType));
            }
            if(signers.size()>4){
                req.inputVariables.inputmap.Signer5         = Utility.getBlankStringIfNull(String.ValueOf(signers[4].name));
                req.inputVariables.inputmap.Party_Type_5    = Utility.getBlankStringIfNull(String.valueOf(signers[4].partyType));
            }
            if(signers.size()>5){
                req.inputVariables.inputmap.Signer6         = Utility.getBlankStringIfNull(String.ValueOf(signers[5].name));
                req.inputVariables.inputmap.Party_Type_6    = Utility.getBlankStringIfNull(String.valueOf(signers[5].partyType));
            }
            if(signers.size()>6){
                req.inputVariables.inputmap.Signer7         = Utility.getBlankStringIfNull(String.ValueOf(signers[6].name));
                req.inputVariables.inputmap.Party_Type_7    = Utility.getBlankStringIfNull(String.valueOf(signers[6].partyType));
            }
            if(signers.size()>7){
                req.inputVariables.inputmap.Signer8            = Utility.getBlankStringIfNull(String.ValueOf(signers[7].name));
                req.inputVariables.inputmap.Party_Type_8       = Utility.getBlankStringIfNull(String.valueOf(signers[7].partyType));
            }
            if(signers.size()>8){
                req.inputVariables.inputmap.Signer9            = Utility.getBlankStringIfNull(String.ValueOf(signers[8].name));
                req.inputVariables.inputmap.Party_Type_9       = Utility.getBlankStringIfNull(String.valueOf(signers[8].partyType));
            }
            
            req.inputVariables.inputmap.Processing_charges     = Utility.getBlankStringIfNull(String.ValueOf(appln.Processing_Fee__c));
            req.inputVariables.inputmap.Non_refundable_charges = Utility.getBlankStringIfNull(String.ValueOf(appln.Non_Refundable_Charges__c));
            req.inputVariables.inputmap.Int_ROI                = Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Interest_Rate__c));
            req.inputVariables.inputmap.ROI_MCLR               = Utility.getBlankStringIfNull(String.ValueOf(appln.Interest_Variation__c));
            req.inputVariables.inputmap.PreClosure_Charges     = Utility.getBlankStringIfNull(String.valueOf(appln.PreClosure_Interest_Rate__c));
            req.inputVariables.inputmap.Penal_Interest         = string.valueof(KVB_Company_Details__c.getOrgDefaults().Penal_Interest__c);
            req.inputVariables.inputmap.Auth_Sign_Bnk          = Constants.KvbBank;
            //title holder
            
            
            //colateral
            if(colllist.size()>0){
                req.inputVariables.inputmap.Type_of_Charge1                   = String.ValueOf(colllist[0].EM_Charge_Types__c);
                req.inputVariables.inputmap.Survey_No_1                       = String.ValueOf(colllist[0].SurveyKhasraKhataPatta_No__c);
                req.inputVariables.inputmap.Plot_Door_Bungalow_No_1           = String.ValueOf(colllist[0].PlotDoorShopBungalow_No__c);
                req.inputVariables.inputmap.Extent_Site_Uds_1                 = String.ValueOf(colllist[0].ExtentCarpet_area_Built_up_area__c);
                req.inputVariables.inputmap.Built_up_area_1                   = String.ValueOf(colllist[0].Buildup_Area__c);
                req.inputVariables.inputmap.Floor_No_1                        = String.ValueOf(colllist[0].Floor_No__c);
                req.inputVariables.inputmap.Ward_No_1                         = String.ValueOf(colllist[0].Stage_Sector_Ward_Block_No__c);
                req.inputVariables.inputmap.Building_Society_Name_No_1        = String.ValueOf(colllist[0].Building_Society_Name__c);
                req.inputVariables.inputmap.Street_Name_1                     = String.ValueOf(colllist[0].Street_NameNo__c);
                req.inputVariables.inputmap.Village_Town_1                    = String.ValueOf(colllist[0].clcommon__City__c);
                req.inputVariables.inputmap.Taluka_Tehsil_1                   = String.ValueOf(colllist[0].TalukaTehsil__c);
                req.inputVariables.inputmap.District_Name_1                   = String.ValueOf(colllist[0].District_Name__c);
                req.inputVariables.inputmap.State_Name_1                      = String.ValueOf(colllist[0].State__c);
                req.inputVariables.inputmap.PIN_CODE_1                        = String.ValueOf(colllist[0].clcommon__Postal_Code__c);
                req.inputVariables.inputmap.Market_value_1                    = String.ValueOf(colllist[0].Total_Market_value__c);
                req.inputVariables.inputmap.Valuation_report_date_1           = String.ValueOf(colllist[0].Valuation_Date__c);
                
                if(colateralOwnerMap != null && colateralOwnerMap.ContainsKey(colllist[0].id) && colateralOwnerMap.get(colllist[0].id) != null){
                    req.inputVariables.inputmap.Title_Holder_Details_1        = colateralOwnerMap.get(colllist[0].id);
                }
                else{
                    req.inputVariables.inputmap.Title_Holder_Details_1        = '';
                }
            }
            if(colllist.size()>1){
                req.inputVariables.inputmap.Type_of_Charge2                   = String.ValueOf(colllist[1].EM_Charge_Types__c);
                req.inputVariables.inputmap.Survey_No_2                       = String.ValueOf(colllist[1].SurveyKhasraKhataPatta_No__c);
                req.inputVariables.inputmap.Plot_Door_Bungalow_No_2           = String.ValueOf(colllist[1].PlotDoorShopBungalow_No__c);
                req.inputVariables.inputmap.Extent_Site_Uds_2                 = String.ValueOf(colllist[1].ExtentCarpet_area_Built_up_area__c);
                req.inputVariables.inputmap.Built_up_area_2                   = String.ValueOf(colllist[1].ExtentCarpet_area_Built_up_area__c);
                req.inputVariables.inputmap.Floor_No_2                        = String.ValueOf(colllist[1].Floor_No__c);
                req.inputVariables.inputmap.Ward_No_2                         = String.ValueOf(colllist[1].Stage_Sector_Ward_Block_No__c);
                req.inputVariables.inputmap.Building_Society_Name_No_2        = String.ValueOf(colllist[1].Building_Society_Name__c);
                req.inputVariables.inputmap.Street_Name_2                     = String.ValueOf(colllist[1].Street_NameNo__c);
                req.inputVariables.inputmap.Village_Town_2                    = String.ValueOf(colllist[1].clcommon__City__c);
                req.inputVariables.inputmap.Taluka_Tehsil_2                   = String.ValueOf(colllist[1].TalukaTehsil__c);
                req.inputVariables.inputmap.District_Name_2                   = String.ValueOf(colllist[1].District_Name__c);
                req.inputVariables.inputmap.State_Name_2                      = String.ValueOf(colllist[1].State__c);
                req.inputVariables.inputmap.PIN_CODE_2                        = String.ValueOf(colllist[1].clcommon__Postal_Code__c);
                req.inputVariables.inputmap.Market_value_2                    = String.ValueOf(colllist[1].Total_Market_value__c);
                req.inputVariables.inputmap.Valuation_report_date_2           = String.ValueOf(colllist[1].Valuation_Date__c);
                
                if(colateralOwnerMap != null && colateralOwnerMap.ContainsKey(colllist[1].id) && colateralOwnerMap.get(colllist[1].id) != null){
                    req.inputVariables.inputmap.Title_Holder_Details_2        = colateralOwnerMap.get(colllist[1].id);
                }
                else{
                    req.inputVariables.inputmap.Title_Holder_Details_2        = '';
                }
            }
            if(colllist.size()>2){
                req.inputVariables.inputmap.Type_of_Charge3                   = String.ValueOf(colllist[2].EM_Charge_Types__c);
                req.inputVariables.inputmap.Survey_No_3                       = String.ValueOf(colllist[2].SurveyKhasraKhataPatta_No__c);
                req.inputVariables.inputmap.Plot_Door_Bungalow_No_3           = String.ValueOf(colllist[2].PlotDoorShopBungalow_No__c);
                req.inputVariables.inputmap.Extent_Site_Uds_3                 = String.ValueOf(colllist[2].ExtentCarpet_area_Built_up_area__c);
                req.inputVariables.inputmap.Built_up_area_3                   = String.ValueOf(colllist[2].ExtentCarpet_area_Built_up_area__c);
                req.inputVariables.inputmap.Floor_No_3                        = String.ValueOf(colllist[2].Floor_No__c);
                req.inputVariables.inputmap.Ward_No_3                         = String.ValueOf(colllist[2].Stage_Sector_Ward_Block_No__c);
                req.inputVariables.inputmap.Building_Society_Name_No_3        = String.ValueOf(colllist[2].Building_Society_Name__c);
                req.inputVariables.inputmap.Street_Name_3                     = String.ValueOf(colllist[2].Street_NameNo__c);
                req.inputVariables.inputmap.Village_Town_3                    = String.ValueOf(colllist[2].clcommon__City__c);
                req.inputVariables.inputmap.Taluka_Tehsil_3                   = String.ValueOf(colllist[2].TalukaTehsil__c);
                req.inputVariables.inputmap.District_Name_3                   = String.ValueOf(colllist[2].District_Name__c);
                req.inputVariables.inputmap.State_Name_3                      = String.ValueOf(colllist[2].State__c);
                req.inputVariables.inputmap.PIN_CODE_3                        = String.ValueOf(colllist[2].clcommon__Postal_Code__c);
                req.inputVariables.inputmap.Market_value_3                    = String.ValueOf(colllist[2].Total_Market_value__c);
                req.inputVariables.inputmap.Valuation_report_date_3           = String.ValueOf(colllist[2].Valuation_Date__c);
                
                if(colateralOwnerMap != null && colateralOwnerMap.ContainsKey(colllist[2].id) && colateralOwnerMap.get(colllist[2].id) != null){
                    req.inputVariables.inputmap.Title_Holder_Details_3        = colateralOwnerMap.get(colllist[2].id);
                }
                else{
                    req.inputVariables.inputmap.Title_Holder_Details_3        = '';
                }
            }
            if(colllist.size()>3){
                req.inputVariables.inputmap.Type_of_Charge4                   = String.ValueOf(colllist[3].EM_Charge_Types__c);
                req.inputVariables.inputmap.Survey_No_4                       = String.ValueOf(colllist[3].SurveyKhasraKhataPatta_No__c);
                req.inputVariables.inputmap.Plot_Door_Bungalow_No_4           = String.ValueOf(colllist[3].PlotDoorShopBungalow_No__c);
                req.inputVariables.inputmap.Extent_Site_Uds_4                 = String.ValueOf(colllist[3].ExtentCarpet_area_Built_up_area__c);
                req.inputVariables.inputmap.Built_up_area_4                   = String.ValueOf(colllist[3].ExtentCarpet_area_Built_up_area__c);
                req.inputVariables.inputmap.Floor_No_4                        = String.ValueOf(colllist[3].Floor_No__c);
                req.inputVariables.inputmap.Ward_No_4                         = String.ValueOf(colllist[3].Stage_Sector_Ward_Block_No__c);
                req.inputVariables.inputmap.Building_Society_Name_No_4        = String.ValueOf(colllist[3].Building_Society_Name__c);
                req.inputVariables.inputmap.Street_Name_4                     = String.ValueOf(colllist[3].Street_NameNo__c);
                req.inputVariables.inputmap.Village_Town_4                    = String.ValueOf(colllist[3].clcommon__City__c);
                req.inputVariables.inputmap.Taluka_Tehsil_4                   = String.ValueOf(colllist[3].TalukaTehsil__c);
                req.inputVariables.inputmap.District_Name_4                   = String.ValueOf(colllist[3].District_Name__c);
                req.inputVariables.inputmap.State_Name_4                      = String.ValueOf(colllist[3].State__c);
                req.inputVariables.inputmap.PIN_CODE_4                        = String.ValueOf(colllist[3].clcommon__Postal_Code__c);
                req.inputVariables.inputmap.Market_value_4                    = String.ValueOf(colllist[3].Total_Market_value__c);
                req.inputVariables.inputmap.Valuation_report_date_4           = String.ValueOf(colllist[3].Valuation_Date__c);
                
                if(colateralOwnerMap != null && colateralOwnerMap.ContainsKey(colllist[3].id) && colateralOwnerMap.get(colllist[3].id) != null){
                    req.inputVariables.inputmap.Title_Holder_Details_4        = colateralOwnerMap.get(colllist[3].id);
                }
                else{
                    req.inputVariables.inputmap.Title_Holder_Details_4        = '';
                }
            }
            if(colllist.size()>4){
                req.inputVariables.inputmap.Type_of_Charge5                   = String.ValueOf(colllist[4].EM_Charge_Types__c);
                req.inputVariables.inputmap.Survey_No_5                       = String.ValueOf(colllist[4].SurveyKhasraKhataPatta_No__c);
                req.inputVariables.inputmap.Plot_Door_Bungalow_No_5           = String.ValueOf(colllist[4].PlotDoorShopBungalow_No__c);
                req.inputVariables.inputmap.Extent_Site_Uds_5                 = String.ValueOf(colllist[4].ExtentCarpet_area_Built_up_area__c);
                req.inputVariables.inputmap.Built_up_area_5                   = String.ValueOf(colllist[4].ExtentCarpet_area_Built_up_area__c);
                req.inputVariables.inputmap.Floor_No_5                        = String.ValueOf(colllist[4].Floor_No__c);
                req.inputVariables.inputmap.Ward_No_5                         = String.ValueOf(colllist[4].Stage_Sector_Ward_Block_No__c);
                req.inputVariables.inputmap.Building_Society_Name_No_5        = String.ValueOf(colllist[4].Building_Society_Name__c);
                req.inputVariables.inputmap.Street_Name_5                     = String.ValueOf(colllist[4].Street_NameNo__c);
                req.inputVariables.inputmap.Village_Town_5                    = String.ValueOf(colllist[4].clcommon__City__c);
                req.inputVariables.inputmap.Taluka_Tehsil_5                   = String.ValueOf(colllist[4].TalukaTehsil__c);
                req.inputVariables.inputmap.District_Name_5                   = String.ValueOf(colllist[4].District_Name__c);
                req.inputVariables.inputmap.State_Name_5                      = String.ValueOf(colllist[4].State__c);
                req.inputVariables.inputmap.PIN_CODE_5                        = String.ValueOf(colllist[4].clcommon__Postal_Code__c);
                req.inputVariables.inputmap.Market_value_5                    = String.ValueOf(colllist[4].Total_Market_value__c);
                req.inputVariables.inputmap.Valuation_report_date_5           = String.ValueOf(colllist[4].Valuation_Date__c);
                
                if(colateralOwnerMap != null && colateralOwnerMap.ContainsKey(colllist[4].id) && colateralOwnerMap.get(colllist[4].id) != null){
                    req.inputVariables.inputmap.Title_Holder_Details_5        = colateralOwnerMap.get(colllist[4].id);
                }
                else{
                    req.inputVariables.inputmap.Title_Holder_Details_5        = '';
                }
            }
            if(colllist.size()>5){
                req.inputVariables.inputmap.Type_of_Charge6                   = String.ValueOf(colllist[5].EM_Charge_Types__c);
                req.inputVariables.inputmap.Survey_No_6                       = String.ValueOf(colllist[5].SurveyKhasraKhataPatta_No__c);
                req.inputVariables.inputmap.Plot_Door_Bungalow_No_6           = String.ValueOf(colllist[5].PlotDoorShopBungalow_No__c);
                req.inputVariables.inputmap.Extent_Site_Uds_6                 = String.ValueOf(colllist[5].ExtentCarpet_area_Built_up_area__c);
                req.inputVariables.inputmap.Built_up_area_6                   = String.ValueOf(colllist[5].ExtentCarpet_area_Built_up_area__c);
                req.inputVariables.inputmap.Floor_No_6                        = String.ValueOf(colllist[5].Floor_No__c);
                req.inputVariables.inputmap.Ward_No_6                         = String.ValueOf(colllist[5].Stage_Sector_Ward_Block_No__c);
                req.inputVariables.inputmap.Building_Society_Name_No_6        = String.ValueOf(colllist[5].Building_Society_Name__c);
                req.inputVariables.inputmap.Street_Name_6                     = String.ValueOf(colllist[5].Street_NameNo__c);
                req.inputVariables.inputmap.Village_Town_6                    = String.ValueOf(colllist[5].clcommon__City__c);
                req.inputVariables.inputmap.Taluka_Tehsil_6                   = String.ValueOf(colllist[5].TalukaTehsil__c);
                req.inputVariables.inputmap.District_Name_6                   = String.ValueOf(colllist[5].District_Name__c);
                req.inputVariables.inputmap.State_Name_6                      = String.ValueOf(colllist[5].State__c);
                req.inputVariables.inputmap.PIN_CODE_6                        = String.ValueOf(colllist[5].clcommon__Postal_Code__c);
                req.inputVariables.inputmap.Market_value_6                    = String.ValueOf(colllist[5].Total_Market_value__c);
                req.inputVariables.inputmap.Valuation_report_date_6           = String.ValueOf(colllist[5].Valuation_Date__c);
                
                if(colateralOwnerMap != null && colateralOwnerMap.ContainsKey(colllist[5].id) && colateralOwnerMap.get(colllist[5].id) != null){
                    req.inputVariables.inputmap.Title_Holder_Details_6        = colateralOwnerMap.get(colllist[5].id);
                }
                else{
                    req.inputVariables.inputmap.Title_Holder_Details_6        = '';
                }
            }
            
            
            req.inputVariables.inputmap.Branch_code                        = Utility.getBlankStringIfNull(String.ValueOf(appln.Branch_Code__c));
            req.inputVariables.inputmap.Application_number                 = Utility.getBlankStringIfNull(String.ValueOf(appln.Name));
            req.inputVariables.inputmap.Financial_Yr                       = Utility.getBlankStringIfNull(String.ValueOf(appln.Sanction_Financial_Year__c));
            req.inputVariables.inputmap.Doc_gen_date                       = Utility.getBlankStringIfNull(String.ValueOf(appln.Today_Date__c));
            req.inputVariables.inputmap.Margin                             = Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Margin__c.setScale(2)));
            
            //borrower
            
            req.inputVariables.inputmap.Tittle_B1                          = Utility.getblankStringIfNull(String.ValueOf(appln.genesis__Account__r.Salutation));   
            req.inputVariables.inputmap.Borrower1_Names                    = Utility.getBlankStringIfNull(appln.genesis__Account__r.Full_Name__c);
            req.inputVariables.inputmap.Borrower1_Aadhaar                  = Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Account__r.Aadhaar_Number__pc));
            req.inputVariables.inputmap.Borrower1_Phone                    = Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Account__r.PersonMobilePhone));//added by prashant singh
            req.inputVariables.inputmap.Borrower1_Email                    = Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Account__r.Person_Email__c));
            req.inputVariables.inputmap.Borrower1_PAN                      = Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Account__r.Pan_Number__c));
            req.inputVariables.inputmap.Borrower1_Name1                    = Utility.getBlankStringIfNull(appln.genesis__Account__r.Full_Name__c);
            req.inputVariables.inputmap.Borrower1_Add_line1                = Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonMailingStreet) ;
            req.inputVariables.inputmap.Borrower1_Add_line2                = Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonMailingCity) ;
            req.inputVariables.inputmap.Borrower1_Add_line3                = Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonMailingState) +'  '+Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonMailingPostalCode);
            
            if(parties.size()>0){
                req.inputVariables.inputmap.Borrower2_Names                    = Utility.getBlankStringIfNull(parties[0].genesis__Party_Account_Name__r.Full_Name__c);
                req.inputVariables.inputmap.Borrower2_Aadhaar                  = Utility.getBlankStringIfNull(String.ValueOf(parties[0].genesis__Party_Account_Name__r.Aadhaar_Number__pc));
                req.inputVariables.inputmap.Borrower2_Phone                    = Utility.getBlankStringIfNull(String.ValueOf(parties[0].genesis__Party_Account_Name__r.PersonMobilePhone));//added by prashant singh
                req.inputVariables.inputmap.Borrower2_Email                    = Utility.getBlankStringIfNull(String.ValueOf(parties[0].genesis__Party_Account_Name__r.Person_Email__c));
                req.inputVariables.inputmap.Borrower2_PAN                      = Utility.getBlankStringIfNull(String.ValueOf(parties[0].genesis__Party_Account_Name__r.Pan_Number__c));
                req.inputVariables.inputmap.Borrower2_Name1                    = Utility.getBlankStringIfNull(parties[0].genesis__Party_Account_Name__r.Full_Name__c);
                req.inputVariables.inputmap.Borrower2_Add_line1                = Utility.getBlankStringIfNull(parties[0].genesis__Party_Account_Name__r.PersonMailingStreet) ;
                req.inputVariables.inputmap.Borrower2_Add_line2                = Utility.getBlankStringIfNull(parties[0].genesis__Party_Account_Name__r.PersonMailingCity) ;
                req.inputVariables.inputmap.Borrower2_Add_line3                = Utility.getBlankStringIfNull(parties[0].genesis__Party_Account_Name__r.PersonMailingState) +'  '+Utility.getBlankStringIfNull(parties[0].genesis__Party_Account_Name__r.PersonMailingPostalCode);    
            }
            if(parties.size()>1){
                req.inputVariables.inputmap.Borrower3_Names                    = Utility.getBlankStringIfNull(parties[1].genesis__Party_Account_Name__r.Full_Name__c);
                req.inputVariables.inputmap.Borrower3_Aadhaar                  = Utility.getBlankStringIfNull(String.ValueOf(parties[1].genesis__Party_Account_Name__r.Aadhaar_Number__pc));
                req.inputVariables.inputmap.Borrower3_Phone                    = Utility.getBlankStringIfNull(String.ValueOf(parties[1].genesis__Party_Account_Name__r.PersonMobilePhone));//added by prashant singh
                req.inputVariables.inputmap.Borrower3_Email                    = Utility.getBlankStringIfNull(String.ValueOf(parties[1].genesis__Party_Account_Name__r.Person_Email__c));
                req.inputVariables.inputmap.Borrower3_PAN                      = Utility.getBlankStringIfNull(String.ValueOf(parties[1].genesis__Party_Account_Name__r.Pan_Number__c));
                req.inputVariables.inputmap.Borrower3_Name1                    = Utility.getBlankStringIfNull(parties[1].genesis__Party_Account_Name__r.Full_Name__c);
                req.inputVariables.inputmap.Borrower3_Add_line1                = Utility.getBlankStringIfNull(parties[1].genesis__Party_Account_Name__r.PersonMailingStreet) ;
                req.inputVariables.inputmap.Borrower3_Add_line2                = Utility.getBlankStringIfNull(parties[1].genesis__Party_Account_Name__r.PersonMailingCity) ;
                req.inputVariables.inputmap.Borrower3_Add_line3                = Utility.getBlankStringIfNull(parties[1].genesis__Party_Account_Name__r.PersonMailingState) +'  '+Utility.getBlankStringIfNull(parties[1].genesis__Party_Account_Name__r.PersonMailingPostalCode);
            }
            if(parties.size()>2){
                req.inputVariables.inputmap.Borrower4_Names                    = Utility.getBlankStringIfNull(parties[2].genesis__Party_Account_Name__r.Full_Name__c);
                req.inputVariables.inputmap.Borrower4_Aadhaar                  = Utility.getBlankStringIfNull(String.ValueOf(parties[2].genesis__Party_Account_Name__r.Aadhaar_Number__pc));
                req.inputVariables.inputmap.Borrower4_Phone                    = Utility.getBlankStringIfNull(String.ValueOf(parties[2].genesis__Party_Account_Name__r.PersonMobilePhone));//added by prashant singh
                req.inputVariables.inputmap.Borrower4_Email                    = Utility.getBlankStringIfNull(String.ValueOf(parties[2].genesis__Party_Account_Name__r.Person_Email__c));
                req.inputVariables.inputmap.Borrower4_PAN                      = Utility.getBlankStringIfNull(String.ValueOf(parties[2].genesis__Party_Account_Name__r.Pan_Number__c));
                req.inputVariables.inputmap.Borrower4_Name1                    = Utility.getBlankStringIfNull(parties[2].genesis__Party_Account_Name__r.Full_Name__c);
                req.inputVariables.inputmap.Borrower4_Add_line1                = Utility.getBlankStringIfNull(parties[2].genesis__Party_Account_Name__r.PersonMailingStreet) ;
                req.inputVariables.inputmap.Borrower4_Add_line2                = Utility.getBlankStringIfNull(parties[2].genesis__Party_Account_Name__r.PersonMailingCity) ;
                req.inputVariables.inputmap.Borrower4_Add_line3                = Utility.getBlankStringIfNull(parties[2].genesis__Party_Account_Name__r.PersonMailingState) +'  '+Utility.getBlankStringIfNull(parties[2].genesis__Party_Account_Name__r.PersonMailingPostalCode);
            }
            
            //gurrentor 
            if(partiesGurrenter.size()>0){
                req.inputVariables.inputmap.Guarantor1_Names                   = Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[0].genesis__Party_Account_Name__r.Name));
                req.inputVariables.inputmap.Guarantor1_Aadhaar                 = Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[0].genesis__Party_Account_Name__r.Aadhaar_Number__pc));
                req.inputVariables.inputmap.Guarantor1_Phone                   = Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[0].genesis__Party_Account_Name__r.PersonMobilePhone));//added by prashant singh
                req.inputVariables.inputmap.Guarantor1_Email                   = Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[0].genesis__Party_Account_Name__r.Person_Email__c));
                req.inputVariables.inputmap.Guarantor1_PAN                     = Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[0].genesis__Party_Account_Name__r.Pan_Number__c));
            }
            if(partiesGurrenter.size()>1){
                req.inputVariables.inputmap.Guarantor2_Names                   = Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[1].genesis__Party_Account_Name__r.Name));
                req.inputVariables.inputmap.Guarantor2_Aadhaar                 = Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[1].genesis__Party_Account_Name__r.Aadhaar_Number__pc));
                req.inputVariables.inputmap.Guarantor2_Phone                   = Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[1].genesis__Party_Account_Name__r.PersonMobilePhone));//added by prashant singh
                req.inputVariables.inputmap.Guarantor2_Email                   = Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[1].genesis__Party_Account_Name__r.Person_Email__c));
                req.inputVariables.inputmap.Guarantor2_PAN                     = Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[1].genesis__Party_Account_Name__r.Pan_Number__c));
            }
            if(partiesGurrenter.size()>2){
                req.inputVariables.inputmap.Guarantor3_Names                   = Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[2].genesis__Party_Account_Name__r.Name));
                req.inputVariables.inputmap.Guarantor3_Aadhaar                 = Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[2].genesis__Party_Account_Name__r.Aadhaar_Number__pc));
                req.inputVariables.inputmap.Guarantor3_Phone                   = Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[2].genesis__Party_Account_Name__r.PersonMobilePhone));//added by prashant singh
                req.inputVariables.inputmap.Guarantor3_Email                   = Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[2].genesis__Party_Account_Name__r.Person_Email__c));
                req.inputVariables.inputmap.Guarantor3_PAN                     = Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[2].genesis__Party_Account_Name__r.Pan_Number__c));
            }
            if(partiesGurrenter.size()>3){
                req.inputVariables.inputmap.Guarantor4_Names                   = Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[3].genesis__Party_Account_Name__r.Name));
                req.inputVariables.inputmap.Guarantor4_Aadhaar                 = Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[3].genesis__Party_Account_Name__r.Aadhaar_Number__pc));
                req.inputVariables.inputmap.Guarantor4_Phone                   = Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[3].genesis__Party_Account_Name__r.PersonMobilePhone));
                req.inputVariables.inputmap.Guarantor4_Email                   = Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[3].genesis__Party_Account_Name__r.Person_Email__c));
                req.inputVariables.inputmap.Guarantor4_PAN                     = Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[3].genesis__Party_Account_Name__r.Pan_Number__c));
            }
            if(partiesGurrenter.size()>4){
                req.inputVariables.inputmap.Guarantor5_Names                   = Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[4].genesis__Party_Account_Name__r.Name));
                req.inputVariables.inputmap.Guarantor5_Aadhaar                 = Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[4].genesis__Party_Account_Name__r.Aadhaar_Number__pc));
                req.inputVariables.inputmap.Guarantor5_Phone                   = Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[4].genesis__Party_Account_Name__r.PersonMobilePhone));//added by prashant singh
                req.inputVariables.inputmap.Guarantor5_Email                   = Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[4].genesis__Party_Account_Name__r.Person_Email__c));
                req.inputVariables.inputmap.Guarantor5_PAN                     = Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[4].genesis__Party_Account_Name__r.Pan_Number__c));
            }
            if(partiesGurrenter.size()>5){
                req.inputVariables.inputmap.Guarantor6_Names                   = Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[5].genesis__Party_Account_Name__r.Name));
                req.inputVariables.inputmap.Guarantor6_Aadhaar                 = Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[5].genesis__Party_Account_Name__r.Aadhaar_Number__pc));
                req.inputVariables.inputmap.Guarantor6_Phone                   = Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[5].genesis__Party_Account_Name__r.PersonMobilePhone));//added by prashant singh
                req.inputVariables.inputmap.Guarantor6_Email                   = Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[5].genesis__Party_Account_Name__r.Person_Email__c));
                req.inputVariables.inputmap.Guarantor6_PAN                     = Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[5].genesis__Party_Account_Name__r.Pan_Number__c));
            }
            
            //branch name
            req.inputVariables.inputmap.Loc_Ref_Branch                     = Utility.getBlankStringIfNull(String.ValueOf(appln.Branch_Name__c));
            req.inputVariables.inputmap.Int_type                           = Utility.getBlankStringIfNull(appln.genesis__Interest_Calculation_Method__c);
            req.inputVariables.inputmap.Conditions_LOS                     = Constants.CONDITIONS_LOS;
            
            //esign's      
            req.inputVariables.inputmap.bEsign1                            = '';
            req.inputVariables.inputmap.bEsign2                            = '';
            req.inputVariables.inputmap.bEsign3                            = '';
            req.inputVariables.inputmap.bEsign4                            = '';
            
            
            req.inputVariables.inputmap.gEsign1                            = '';
            req.inputVariables.inputmap.gEsign2                            = '';
            req.inputVariables.inputmap.gEsign3                            = '';
            req.inputVariables.inputmap.gEsign4                            = '';
            req.inputVariables.inputmap.gEsign5                            = '';
            
            System.debug('##### C1SanctionAcknowledgementforLAP Document request structrue ');
            return req;
            
        }catch(Exception e) {
            System.debug('##C1SanctionAcknowledgementforLAP### --- Error>>> '+ e.getLineNumber() +' ' +e.getMessage());
            HandleBusinessException.captureError('HL_DigioTemplateService', 'C1SanctionAcknowledgementforLAP', e);
            return null;
        }
    }
    
    //LAP A23 Doc
    public static LAP_A23D_LAFADoc A23D_LAFADocForLap(String appId, String templateId){
        String Borrower1Names                                            = '';
        String Borrower2Names                                            = '';
        String Borrower3Names                                            = '';
        String Borrower4Names                                            = '';
        String Borrower5Names                                            = '';
        String BorrowerDetails                                           = '';
        
        genesis__Applications__c appln                                   = new genesis__Applications__c();
        
        appln   = [Select id,genesis__Disbursement_Date__c,genesis__Account__c,Day_Of_Disbursal__c,Month_Of_Disbursal__c,Disbursal_Financial_Year__c,FPIPrincRepayInstal__c,MCLR_Rate__c,Rating_Frequency__c,PreClosure_Interest_Rate__c,Legal_desk_state_flag__c,Penal_Interest__c,Interest_Variation__c,Preclosure_Charges__c,Non_Refundable_Charges__c,Holiday_Period__c,Processing_Charges__c,genesis__Account__r.Name,Branch_Name__c,Loan_Purpose__c,genesis__Payment_Frequency__c,Sanctioned_EMI__c,Sanctioned_Tenure__c,genesis__Loan_Amount__c,
                   Branch_Code__c,Sanction_Amount_Words__c,Created_Date__c,MCLR_Type__c,Name,genesis__Account__r.BillingStreet,Sanction_Financial_Year__c,Sanction_Date__c,Amount_in_Words_And_Figures__c,
                   genesis__Account__r.BillingCity,genesis__Account__r.BillingState,genesis__Account__r.BillingCountry,genesis__CL_Product_Name__c,genesis__Term__c,
                   genesis__Interest_Rate__c,Sanction_Authority_Limit__c,Processing_Fee__c,Today_Date__c,genesis__Account__r.Father_Husband_Daughter_Name__c,genesis__Account__r.PersonMailingStreet,
                   genesis__Account__r.PersonMailingCity,genesis__Account__r.PersonMailingState,genesis__Account__r.PersonMailingPostalCode,genesis__Account__r.Full_Name__c  
                   from genesis__Applications__c where id =:appId];
        
        List<genesis__Application_Parties__c> parties                    = new List<genesis__Application_Parties__c>();
        
        parties = [Select id,genesis__Application__c,Guarantor__c,genesis__Party_Account_Name__c,Signatories__c,
                   genesis__Party_Account_Name__r.Name,Party_Sub_Type__c,genesis__Party_Type__c,Active__c,genesis__Party_Account_Name__r.Father_Husband_Daughter_Name__c,
                   genesis__Party_Account_Name__r.PersonMailingCity,genesis__Party_Account_Name__r.PersonMailingState,genesis__Party_Account_Name__r.PersonMailingPostalCode
                   ,genesis__Party_Account_Name__r.PersonMailingStreet,genesis__Party_Account_Name__r.Full_Name__c,genesis__Party_Account_Name__r.Aadhaar_Number__pc,genesis__Party_Account_Name__r.Phone,genesis__Party_Account_Name__r.Person_Email__c,genesis__Party_Account_Name__r.Pan_Number__c from genesis__Application_Parties__c where genesis__Application__c = :appId 
                   AND genesis__Party_Type__c =: Constants.Co_Borrower AND Active__c =true];
        
        List<genesis__Application_Parties__c> partiesGurrenter           = new List<genesis__Application_Parties__c>();
        
        partiesGurrenter = [Select id,genesis__Application__c,Guarantor__c,genesis__Party_Account_Name__c,Signatories__c,
                            genesis__Party_Account_Name__r.Name,Party_Sub_Type__c,genesis__Party_Type__c,Active__c,genesis__Party_Account_Name__r.Father_Husband_Daughter_Name__c,
                            genesis__Party_Account_Name__r.PersonMailingCity,genesis__Party_Account_Name__r.PersonMailingState,genesis__Party_Account_Name__r.PersonMailingPostalCode
                            ,genesis__Party_Account_Name__r.PersonMailingStreet,genesis__Party_Account_Name__r.Full_Name__c,genesis__Party_Account_Name__r.Aadhaar_Number__pc,genesis__Party_Account_Name__r.Phone,genesis__Party_Account_Name__r.Person_Email__c,genesis__Party_Account_Name__r.Pan_Number__c from genesis__Application_Parties__c where genesis__Application__c = :appId 
                            AND genesis__Party_Type__c =: 'Guarantor' AND Active__c =true];
        
        List<clcommon__Collateral__c> colList = [SELECT id,Name,SurveyKhasraKhataPatta_No__c,Collateral_Type__c,EM_Charge_type__c,Nature_of_Property__c,PlotDoorShopBungalow_No__c,Buildup_Area__c,ExtentCarpet_area_Built_up_area__c,Floor_No__c,Stage_Sector_Ward_Block_No__c,Building_Society_Name__c,Street_NameNo__c,VillageTown__c,TalukaTehsil__c,District_Name__c,State__c,Property_Pincode__c,Total_Market_value__c,clcommon__City__c,clcommon__Postal_Code__c,Building_Name__c,Valuation_Date__c FROM clcommon__Collateral__c WHERE Active__c = true AND genesis__Application__c =:appln.Id];
        
        LAP_A23D_LAFADoc dafaDoc                                         = new LAP_A23D_LAFADoc();
        dafaDoc.inputVariables                                           = new LAP_A23D_LAFADoc.cls_inputVariables();
        dafaDoc.owner_tenantId                                           = 'cuecent_tenant';
        dafaDoc.exe_tenantId                                             = 'cuecent_tenant';
        dafaDoc.serviceName                                              = 'TestJsonStr';
        dafaDoc.inputVariables.unique_key                                = templateId;
        dafaDoc.inputVariables.pdf_unique_key                            = appln.Id;
        dafaDoc.inputVariables.in_msg                                    = '';
        dafaDoc.inputVariables.inputmap                                  = new LAP_A23D_LAFADoc.cls_inputmap();
        
        dafaDoc.inputVariables.inputmap.Auth_Sign_Bnk  = Constants.KvbBank;
        dafaDoc.inputVariables.inputmap.Loc_Ref_Branch = Utility.getBlankStringIfNull(String.ValueOf(appln.Branch_Name__c));
        dafaDoc.inputVariables.inputmap.Disb_Ref_Day = system.now().format('dd');//Utility.getBlankStringIfNull(String.ValueOf(appln.Day_Of_Disbursal__c));
        dafaDoc.inputVariables.inputmap.Disb_Ref_Month = system.now().format('MMMM');//Utility.getBlankStringIfNull(String.ValueOf(appln.Month_Of_Disbursal__c));
        dafaDoc.inputVariables.inputmap.Disb_Ref_Year = system.now().format('yyyy');//Utility.getBlankStringIfNull(String.ValueOf(appln.Disbursal_Financial_Year__c));
        
        dafaDoc.inputVariables.inputmap.Ap_LT = Utility.getBlankStringIfNull(String.ValueOf(appln.Sanction_Authority_Limit__c));
        dafaDoc.inputVariables.inputmap.Ap_LT_inwords = Utility.getBlankStringIfNull(String.ValueOf(appln.Sanction_Amount_Words__c));
        dafaDoc.inputVariables.inputmap.Int_ROI = Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Interest_Rate__c.setScale(2)));
        dafaDoc.inputVariables.inputmap.Variance = Utility.getBlankStringIfNull(String.ValueOf(appln.Interest_Variation__c));
        dafaDoc.inputVariables.inputmap.MCLR_Rate = Utility.getBlankStringIfNull(String.ValueOf(appln.MCLR_Rate__c));
        dafaDoc.inputVariables.inputmap.Loan_Purpose = Utility.getBlankStringIfNull(String.ValueOf(appln.Loan_Purpose__c));
        dafaDoc.inputVariables.inputmap.Rating_Freq = Utility.getBlankStringIfNull(String.ValueOf(appln.Rating_Frequency__c));
        dafaDoc.inputVariables.inputmap.PreClosure_Charges = Utility.getBlankStringIfNull(String.ValueOf(appln.PreClosure_Interest_Rate__c));
        dafaDoc.inputVariables.inputmap.Penal_Interest = Utility.getBlankStringIfNull(String.ValueOf(appln.Penal_Interest__c));
        dafaDoc.inputVariables.inputmap.Loan_tenor = Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Term__c));
        dafaDoc.inputVariables.inputmap.EMI_amount = Utility.getBlankStringIfNull(String.ValueOf(appln.Sanctioned_EMI__c));
        dafaDoc.inputVariables.inputmap.DD_FI = Utility.getBlankStringIfNull(formatDate(appln.FPIPrincRepayInstal__c));
        dafaDoc.inputVariables.inputmap.DD_LI = Utility.getBlankStringIfNull(formatDate((appln.FPIPrincRepayInstal__c).addMonths(integer.valueOf(appln.Sanctioned_Tenure__c -1))));
        //collateral
        for(integer i=0;i<colList.size();i++){
            if(i==0){
                dafaDoc.inputVariables.inputmap.Nature_Property_1 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].Collateral_Type__c));
                dafaDoc.inputVariables.inputmap.Survey_No_1 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].SurveyKhasraKhataPatta_No__c));
                dafaDoc.inputVariables.inputmap.Plot_Door_Bungalow_No_1 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].PlotDoorShopBungalow_No__c));
                dafaDoc.inputVariables.inputmap.Extent_Site_Uds_1 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].ExtentCarpet_area_Built_up_area__c));
                dafaDoc.inputVariables.inputmap.Built_up_area_1 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].Buildup_Area__c));
                dafaDoc.inputVariables.inputmap.Floor_No_1 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].Floor_No__c));
                dafaDoc.inputVariables.inputmap.Ward_No_1 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].Stage_Sector_Ward_Block_No__c));
                dafaDoc.inputVariables.inputmap.Building_Society_Name_No_1 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].Building_Society_Name__c));
                dafaDoc.inputVariables.inputmap.Street_Name_1 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].Street_NameNo__c));
                dafaDoc.inputVariables.inputmap.Village_Town_1 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].clcommon__City__c));
                dafaDoc.inputVariables.inputmap.Taluka_Tehsil_1 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].TalukaTehsil__c));
                dafaDoc.inputVariables.inputmap.District_Name_1 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].District_Name__c));
                dafaDoc.inputVariables.inputmap.State_Name_1 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].State__c));
                dafaDoc.inputVariables.inputmap.PIN_CODE_1 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].clcommon__Postal_Code__c));//changes made by prashant singh as discussed with akshaya on 30/10/2018
            }
            if(i==1){
                dafaDoc.inputVariables.inputmap.Nature_Property_2 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].Collateral_Type__c));
                dafaDoc.inputVariables.inputmap.Survey_No_2 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].SurveyKhasraKhataPatta_No__c));
                dafaDoc.inputVariables.inputmap.Plot_Door_Bungalow_No_2 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].PlotDoorShopBungalow_No__c));
                dafaDoc.inputVariables.inputmap.Extent_Site_Uds_2 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].ExtentCarpet_area_Built_up_area__c));
                dafaDoc.inputVariables.inputmap.Built_up_area_2 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].Buildup_Area__c));
                dafaDoc.inputVariables.inputmap.Floor_No_2 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].Floor_No__c));
                dafaDoc.inputVariables.inputmap.Ward_No_2 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].Stage_Sector_Ward_Block_No__c));
                dafaDoc.inputVariables.inputmap.Building_Society_Name_No_2 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].Building_Society_Name__c));
                dafaDoc.inputVariables.inputmap.Street_Name_2 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].Street_NameNo__c));
                dafaDoc.inputVariables.inputmap.Village_Town_2 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].clcommon__City__c));
                dafaDoc.inputVariables.inputmap.Taluka_Tehsil_2 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].TalukaTehsil__c));
                dafaDoc.inputVariables.inputmap.District_Name_2 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].District_Name__c));
                dafaDoc.inputVariables.inputmap.State_Name_2 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].State__c));
                dafaDoc.inputVariables.inputmap.PIN_CODE_2 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].clcommon__Postal_Code__c));
            }
            if(i==2){
                dafaDoc.inputVariables.inputmap.Nature_Property_3 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].Collateral_Type__c));
                dafaDoc.inputVariables.inputmap.Survey_No_3 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].SurveyKhasraKhataPatta_No__c));
                dafaDoc.inputVariables.inputmap.Plot_Door_Bungalow_No_3 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].PlotDoorShopBungalow_No__c));
                dafaDoc.inputVariables.inputmap.Extent_Site_Uds_3 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].ExtentCarpet_area_Built_up_area__c));
                dafaDoc.inputVariables.inputmap.Built_up_area_3 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].Buildup_Area__c));
                dafaDoc.inputVariables.inputmap.Floor_No_3 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].Floor_No__c));
                dafaDoc.inputVariables.inputmap.Ward_No_3 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].Stage_Sector_Ward_Block_No__c));
                dafaDoc.inputVariables.inputmap.Building_Society_Name_No_3 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].Building_Society_Name__c));
                dafaDoc.inputVariables.inputmap.Street_Name_3 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].Street_NameNo__c));
                dafaDoc.inputVariables.inputmap.Village_Town_3 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].clcommon__City__c));
                dafaDoc.inputVariables.inputmap.Taluka_Tehsil_3 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].TalukaTehsil__c));
                dafaDoc.inputVariables.inputmap.District_Name_3 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].District_Name__c));
                dafaDoc.inputVariables.inputmap.State_Name_3 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].State__c));
                dafaDoc.inputVariables.inputmap.PIN_CODE_3 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].clcommon__Postal_Code__c));
            }
            if(i==3){
                dafaDoc.inputVariables.inputmap.Nature_Property_4 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].Collateral_Type__c));
                dafaDoc.inputVariables.inputmap.Survey_No_4 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].SurveyKhasraKhataPatta_No__c));
                dafaDoc.inputVariables.inputmap.Plot_Door_Bungalow_No_4 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].PlotDoorShopBungalow_No__c));
                dafaDoc.inputVariables.inputmap.Extent_Site_Uds_4 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].ExtentCarpet_area_Built_up_area__c));
                dafaDoc.inputVariables.inputmap.Built_up_area_4 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].Buildup_Area__c));
                dafaDoc.inputVariables.inputmap.Floor_No_4 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].Floor_No__c));
                dafaDoc.inputVariables.inputmap.Ward_No_4 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].Stage_Sector_Ward_Block_No__c));
                dafaDoc.inputVariables.inputmap.Building_Society_Name_No_4 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].Building_Society_Name__c));
                dafaDoc.inputVariables.inputmap.Street_Name_4 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].Street_NameNo__c));
                dafaDoc.inputVariables.inputmap.Village_Town_4 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].clcommon__City__c));
                dafaDoc.inputVariables.inputmap.Taluka_Tehsil_4 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].TalukaTehsil__c));
                dafaDoc.inputVariables.inputmap.District_Name_4 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].District_Name__c));
                dafaDoc.inputVariables.inputmap.State_Name_4 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].State__c));
                dafaDoc.inputVariables.inputmap.PIN_CODE_4 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].clcommon__Postal_Code__c));
            }
            if(i==4){
                dafaDoc.inputVariables.inputmap.Nature_Property_5 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].Collateral_Type__c));
                dafaDoc.inputVariables.inputmap.Survey_No_5 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].SurveyKhasraKhataPatta_No__c));
                dafaDoc.inputVariables.inputmap.Plot_Door_Bungalow_No_5 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].PlotDoorShopBungalow_No__c));
                dafaDoc.inputVariables.inputmap.Extent_Site_Uds_5 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].ExtentCarpet_area_Built_up_area__c));
                dafaDoc.inputVariables.inputmap.Built_up_area_5 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].Buildup_Area__c));
                dafaDoc.inputVariables.inputmap.Floor_No_5 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].Floor_No__c));
                dafaDoc.inputVariables.inputmap.Ward_No_5 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].Stage_Sector_Ward_Block_No__c));
                dafaDoc.inputVariables.inputmap.Building_Society_Name_No_5 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].Building_Society_Name__c));
                dafaDoc.inputVariables.inputmap.Street_Name_5 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].Street_NameNo__c));
                dafaDoc.inputVariables.inputmap.Village_Town_5 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].clcommon__City__c));
                dafaDoc.inputVariables.inputmap.Taluka_Tehsil_5 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].TalukaTehsil__c));
                dafaDoc.inputVariables.inputmap.District_Name_5 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].District_Name__c));
                dafaDoc.inputVariables.inputmap.State_Name_5 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].State__c));
                dafaDoc.inputVariables.inputmap.PIN_CODE_5 = Utility.getBlankStringIfNull(String.ValueOf(colList[i].clcommon__Postal_Code__c)); 
            }
        }
        dafaDoc.inputVariables.inputmap.Borrower1_Names = Utility.getBlankStringIfNull(appln.genesis__Account__r.Full_Name__c);
        for(integer i=0;i<parties.size();i++){
            if(i==0){
                dafaDoc.inputVariables.inputmap.Borrower2_Names = Utility.getBlankStringIfNull(String.ValueOf(parties[i].genesis__Party_Account_Name__r.Full_Name__c));
                Borrower2Names = Utility.getBlankStringIfNull(String.ValueOf(parties[i].genesis__Party_Account_Name__r.Full_Name__c));
            }
            if(i==1){
                dafaDoc.inputVariables.inputmap.Borrower3_Names = Utility.getBlankStringIfNull(String.ValueOf(parties[i].genesis__Party_Account_Name__r.Full_Name__c));
                Borrower3Names = Utility.getBlankStringIfNull(String.ValueOf(parties[i].genesis__Party_Account_Name__r.Full_Name__c));
            }
            if(i==2){
                dafaDoc.inputVariables.inputmap.Borrower4_Names = Utility.getBlankStringIfNull(String.ValueOf(parties[i].genesis__Party_Account_Name__r.Full_Name__c));
                Borrower4Names = Utility.getBlankStringIfNull(String.ValueOf(parties[i].genesis__Party_Account_Name__r.Full_Name__c));
            }
            if(i==3){
                dafaDoc.inputVariables.inputmap.Borrower5_Names = Utility.getBlankStringIfNull(String.ValueOf(parties[i].genesis__Party_Account_Name__r.Full_Name__c));
                Borrower5Names = Utility.getBlankStringIfNull(String.ValueOf(parties[i].genesis__Party_Account_Name__r.Full_Name__c));
            } 
        }
        Borrower1Names = appln.genesis__Account__r.Full_Name__c;
        BorrowerDetails += (Borrower1Names != '' ?  Borrower1Names : '');
        BorrowerDetails += (Borrower2Names != '' ? ' & ' +Borrower2Names : '');
        BorrowerDetails += (Borrower3Names != '' ? ' & ' +Borrower3Names : '');
        BorrowerDetails += (Borrower4Names != '' ? ' & ' +Borrower4Names : '');
        BorrowerDetails += (Borrower5Names != '' ? ' & ' +Borrower5Names : '');
        dafaDoc.inputVariables.inputmap.Borrower_Details = BorrowerDetails;
        //BorrowerDetails = (Borrower1Names != '' ? Borrower1Names : '') + (Borrower2Names != '' ? '&'+Borrower2Names :'') + (Borrower3Names != '' ? '&'+Borrower3Names : '') + (Borrower4Names != '' ? '&'+Borrower4Names : '' );
        return dafaDoc;
    }

    //LAP A46 Doc
    //LAP A46 without class 2 and esign Doc
    public static LAP_A46NoSign A46AgreementDocForLap(String appId, String templateId){
        String Guarantor1Names  = '';
        String Guarantor2Names  = '';
        String Guarantor3Names  = '';
        String Guarantor4Names  = '';
        String Guarantor5Names  = '';
        String GuarantorDetails = '';
        String Borrower1Names   = '';
        String Borrower2Names   = '';
        String Borrower3Names   = '';
        String Borrower4Names   = '';
        String Borrower5Names   = '';
        String BorrowerDetails  = '';
        
        genesis__Applications__c appln = new genesis__Applications__c();
        appln   = [Select id,genesis__Account__c,Day_Of_Disbursal__c,Month_Of_Disbursal__c,Disbursal_Financial_Year__c,FPIPrincRepayInstal__c,MCLR_Rate__c,Rating_Frequency__c,PreClosure_Interest_Rate__c,Legal_desk_state_flag__c,Penal_Interest__c,Interest_Variation__c,Preclosure_Charges__c,Non_Refundable_Charges__c,Holiday_Period__c,Processing_Charges__c,genesis__Account__r.Name,Branch_Name__c,Loan_Purpose__c,genesis__Payment_Frequency__c,Sanctioned_EMI__c,Sanctioned_Tenure__c,genesis__Loan_Amount__c,
                   Branch_Code__c,Sanction_Amount_Words__c,Created_Date__c,MCLR_Type__c,Name,genesis__Account__r.BillingStreet,Sanction_Financial_Year__c,Sanction_Date__c,Amount_in_Words_And_Figures__c,
                   genesis__Account__r.BillingCity,genesis__Account__r.BillingState,genesis__Account__r.BillingCountry,genesis__CL_Product_Name__c,genesis__Term__c,
                   genesis__Interest_Rate__c,Sanction_Authority_Limit__c,Processing_Fee__c,Today_Date__c,genesis__Account__r.Father_Husband_Daughter_Name__c,genesis__Account__r.PersonMailingStreet,
                   genesis__Account__r.PersonMailingCity,genesis__Account__r.PersonMailingState,genesis__Account__r.PersonMailingPostalCode,genesis__Account__r.Full_Name__c  
                   from genesis__Applications__c where id =:appId];
        List<genesis__Application_Parties__c> parties = new List<genesis__Application_Parties__c>();
        parties = [Select id,genesis__Application__c,Guarantor__c,genesis__Party_Account_Name__c,Signatories__c,
                   genesis__Party_Account_Name__r.Name,Party_Sub_Type__c,genesis__Party_Type__c,Active__c,genesis__Party_Account_Name__r.Father_Husband_Daughter_Name__c,
                   genesis__Party_Account_Name__r.PersonMailingCity,genesis__Party_Account_Name__r.PersonMailingState,genesis__Party_Account_Name__r.PersonMailingPostalCode
                   ,genesis__Party_Account_Name__r.PersonMailingStreet,genesis__Party_Account_Name__r.Full_Name__c,genesis__Party_Account_Name__r.Aadhaar_Number__pc,genesis__Party_Account_Name__r.Phone,genesis__Party_Account_Name__r.Person_Email__c,genesis__Party_Account_Name__r.Pan_Number__c from genesis__Application_Parties__c where genesis__Application__c = :appId 
                   AND genesis__Party_Type__c =: Constants.Co_Borrower AND Active__c =true];
        system.debug('parties'+parties);
        
        List<genesis__Application_Parties__c> partiesGurrenter = new List<genesis__Application_Parties__c>();
        partiesGurrenter = [Select id,genesis__Application__c,Guarantor__c,genesis__Party_Account_Name__c,Signatories__c,
                            genesis__Party_Account_Name__r.Name,Party_Sub_Type__c,genesis__Party_Type__c,Active__c,genesis__Party_Account_Name__r.Father_Husband_Daughter_Name__c,
                            genesis__Party_Account_Name__r.PersonMailingCity,genesis__Party_Account_Name__r.PersonMailingState,genesis__Party_Account_Name__r.PersonMailingPostalCode
                            ,genesis__Party_Account_Name__r.PersonMailingStreet,genesis__Party_Account_Name__r.Full_Name__c,genesis__Party_Account_Name__r.Aadhaar_Number__pc,genesis__Party_Account_Name__r.Phone,genesis__Party_Account_Name__r.Person_Email__c,genesis__Party_Account_Name__r.Pan_Number__c from genesis__Application_Parties__c where genesis__Application__c = :appId 
                            AND genesis__Party_Type__c =: 'Guarantor' AND Active__c =true];
        LAP_A46NoSign reqRecLap = new LAP_A46NoSign();
        if(partiesGurrenter.size()>0){
            
            
            reqRecLap.inputVariables   = new LAP_A46NoSign.cls_inputVariables();
            reqRecLap.owner_tenantId   = 'cuecent_tenant';
            reqRecLap.exe_tenantId = 'cuecent_tenant';
            reqRecLap.serviceName      = 'TestJsonStr';
            reqRecLap.inputVariables.unique_key    = templateId;
            reqRecLap.inputVariables.pdf_unique_key = appln.Id;
            reqRecLap.inputVariables.in_msg        = '';
            reqRecLap.inputVariables.inputmap  = new LAP_A46NoSign.cls_inputmap();
            
            reqRecLap.inputVariables.inputmap.Auth_Sign_Bnk= Constants.KvbBank ;
            reqRecLap.inputVariables.inputmap.Loc_Ref_Branch = Utility.getBlankStringIfNull(appln.Branch_Name__c);
            reqRecLap.inputVariables.inputmap.Disb_Ref_Day   = system.now().format('dd');//Utility.getBlankStringIfNull(String.valueOf(appln.Day_Of_Disbursal__c));
            reqRecLap.inputVariables.inputmap.Disb_Ref_Month = system.now().format('MMMM');//Utility.getBlankStringIfNull(String.valueOf(appln.Month_Of_Disbursal__c));
            reqRecLap.inputVariables.inputmap.Disb_Ref_Year  = system.now().format('yyyy');//Utility.getBlankStringIfNull(String.valueOf(appln.Disbursal_Financial_Year__c));
            
            reqRecLap.inputVariables.inputmap.Loan_Product = Utility.getBlankStringIfNull(appln.genesis__CL_Product_Name__c);
            reqRecLap.inputVariables.inputmap.Ap_LT = Utility.getBlankStringIfNull(String.ValueOf(appln.Sanction_Authority_Limit__c));
            reqRecLap.inputVariables.inputmap.Int_ROI = Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Interest_Rate__c.setScale(2)));
            reqRecLap.inputVariables.inputmap.Loan_tenor = Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Term__c));
            
            for(integer i=0;i<partiesGurrenter.size();i++){
                if(i==0){
                    reqRecLap.inputVariables.inputmap.Guarantor1_Names =Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[i].genesis__Party_Account_Name__r.Full_Name__c));
                    Guarantor1Names = Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[i].genesis__Party_Account_Name__r.Full_Name__c));
                }
                if(i==1){
                    reqRecLap.inputVariables.inputmap.Guarantor2_Names =Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[i].genesis__Party_Account_Name__r.Full_Name__c));
                    Guarantor2Names = Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[i].genesis__Party_Account_Name__r.Full_Name__c));
                }
                if(i==2){
                    reqRecLap.inputVariables.inputmap.Guarantor3_Names =Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[i].genesis__Party_Account_Name__r.Full_Name__c));
                    Guarantor3Names = Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[i].genesis__Party_Account_Name__r.Full_Name__c));
                }
                if(i==3){
                    reqRecLap.inputVariables.inputmap.Guarantor4_Names =Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[i].genesis__Party_Account_Name__r.Full_Name__c));
                    Guarantor4Names = Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[i].genesis__Party_Account_Name__r.Full_Name__c));
                }
                if(i==4){
                    reqRecLap.inputVariables.inputmap.Guarantor5_Names =Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[i].genesis__Party_Account_Name__r.Full_Name__c));
                    Guarantor5Names = Utility.getBlankStringIfNull(String.ValueOf(partiesGurrenter[i].genesis__Party_Account_Name__r.Full_Name__c));
                }
            }
            for(integer i=0;i<parties.size();i++){
                if(i==0){
                    Borrower2Names = Utility.getBlankStringIfNull(String.ValueOf(parties[i].genesis__Party_Account_Name__r.Full_Name__c));
                }
                if(i==1){
                    Borrower3Names = Utility.getBlankStringIfNull(String.ValueOf(parties[i].genesis__Party_Account_Name__r.Full_Name__c));
                }
                if(i==2){
                    Borrower4Names = Utility.getBlankStringIfNull(String.ValueOf(parties[i].genesis__Party_Account_Name__r.Full_Name__c));
                }
                if(i==3){
                    Borrower5Names = Utility.getBlankStringIfNull(String.ValueOf(parties[i].genesis__Party_Account_Name__r.Full_Name__c));
                }
            }
            
            Borrower1Names   = appln.genesis__Account__r.Full_Name__c;
            BorrowerDetails += (Borrower1Names != '' ?  Borrower1Names : '');
            BorrowerDetails += (Borrower2Names != '' ? ' & ' +Borrower2Names : '');
            BorrowerDetails += (Borrower3Names != '' ? ' & ' +Borrower3Names : '');
            BorrowerDetails += (Borrower4Names != '' ? ' & ' +Borrower4Names : '');
            BorrowerDetails += (Borrower5Names != '' ? ' & ' +Borrower5Names : '');
            
            GuarantorDetails+= (Guarantor1Names != '' ? Guarantor1Names : '');
            GuarantorDetails+= (Guarantor2Names != '' ? '&'+Guarantor2Names :'');
            GuarantorDetails+= (Guarantor3Names != '' ? '&'+Guarantor3Names :'');
            GuarantorDetails+= (Guarantor4Names != '' ? '&'+Guarantor4Names :'');
            GuarantorDetails+= (Guarantor5Names != '' ? '&'+Guarantor5Names :'');
            
            reqRecLap.inputVariables.inputmap.Guarantor_Details = GuarantorDetails;
            reqRecLap.inputVariables.inputmap.Borrower_Names = BorrowerDetails;
            
            
            //GuarantorDetails = (Guarantor1Names != '' ? Guarantor1Names : '') + () + (Guarantor3Names != '' ? '&'+Guarantor3Names : '') + (Guarantor4Names != '' ? '&'+Guarantor4Names : '' )+ Guarantor5Names != '' ? '&'+Guarantor5Names :'';
            //BorrowerDetails = (Borrower1Names != '' ? Borrower1Names : '') + (Borrower2Names != '' ? '&'+Borrower2Names :'') + (Borrower3Names != '' ? '&'+Borrower3Names : '') + (Borrower4Names != '' ? '&'+Borrower4Names : '' )+ Borrower5Names != '' ? '&'+Borrower5Names :'';
        }
        return reqRecLap;
    }
    
    public static LAP_B1DigioDoc B1_DigioDocForLap(String appId, String templateId){
        String Borrower1Names       = '';
        String Borrower2Names       = '';
        String Borrower3Names       = '';
        String Borrower4Names       = '';
        String Borrower5Names       = '';
        String BorrowerDetails      = '';
        String TitleHolder1Names    = '';
        String TitleHolder2Names    = '';
        String TitleHolder3Names    = '';
        String TitleHolder4Names    = '';
        String TitleHolder5Names    = '';
        String TitleHolder6Names    = '';
        String TitleHolder7Names    = '';
        String TitleHolderdetails = '';
        genesis__Applications__c appln = new genesis__Applications__c();
        appln   = [Select id,genesis__Account__c,Penal_Interest__c,MOD_Branch__c,Sanction_Reference_Number__c,MOD_Date__c,Product_Code__c,Interest_Variation__c,Preclosure_Charges__c,Non_Refundable_Charges__c,Holiday_Period__c,Processing_Charges__c,genesis__Account__r.Name,Branch_Name__c,Loan_Purpose__c,genesis__Payment_Frequency__c,Sanctioned_EMI__c,Sanctioned_Tenure__c,genesis__Loan_Amount__c,
                   Branch_Code__c,Sanction_Amount_Words__c,Created_Date__c,MCLR_Type__c,Name,genesis__Account__r.BillingStreet,Sanction_Financial_Year__c,Sanction_Date__c,Amount_in_Words_And_Figures__c,
                   genesis__Account__r.BillingCity,genesis__Account__r.BillingState,genesis__Account__r.BillingCountry,genesis__CL_Product_Name__c,genesis__Term__c,
                   genesis__Interest_Rate__c,Sanction_Authority_Limit__c,Processing_Fee__c,Today_Date__c,genesis__Account__r.Father_Husband_Daughter_Name__c,genesis__Account__r.PersonMailingStreet,
                   genesis__Account__r.PersonMailingCity,genesis__Account__r.PersonMailingState,genesis__Account__r.PersonMailingPostalCode,genesis__Account__r.Full_Name__c  
                   from genesis__Applications__c where id =:appId];
        List<genesis__Application_Parties__c> parties = new List<genesis__Application_Parties__c>();
        parties = [Select id,genesis__Application__c,Guarantor__c,genesis__Party_Account_Name__c,Signatories__c,
                   genesis__Party_Account_Name__r.Name,Party_Sub_Type__c,genesis__Party_Type__c,Active__c,genesis__Party_Account_Name__r.Father_Husband_Daughter_Name__c,
                   genesis__Party_Account_Name__r.PersonMailingCity,genesis__Party_Account_Name__r.PersonMailingState,genesis__Party_Account_Name__r.PersonMailingPostalCode
                   ,genesis__Party_Account_Name__r.PersonMailingStreet,genesis__Party_Account_Name__r.Full_Name__c,genesis__Party_Account_Name__r.Aadhaar_Number__pc,genesis__Party_Account_Name__r.Phone,genesis__Party_Account_Name__r.Person_Email__c,genesis__Party_Account_Name__r.Pan_Number__c from genesis__Application_Parties__c where genesis__Application__c = :appId 
                   AND genesis__Party_Type__c =: Constants.Co_Borrower AND Active__c =true];
        
        List<genesis__Application_Parties__c> partiesGurrenter = new List<genesis__Application_Parties__c>();
        partiesGurrenter = [Select id,genesis__Application__c,Guarantor__c,genesis__Party_Account_Name__c,Signatories__c,
                            genesis__Party_Account_Name__r.Name,Party_Sub_Type__c,genesis__Party_Type__c,Active__c,genesis__Party_Account_Name__r.Father_Husband_Daughter_Name__c,
                            genesis__Party_Account_Name__r.PersonMailingCity,genesis__Party_Account_Name__r.PersonMailingState,genesis__Party_Account_Name__r.PersonMailingPostalCode
                            ,genesis__Party_Account_Name__r.PersonMailingStreet,genesis__Party_Account_Name__r.Full_Name__c,genesis__Party_Account_Name__r.Aadhaar_Number__pc,genesis__Party_Account_Name__r.Phone,genesis__Party_Account_Name__r.Person_Email__c,genesis__Party_Account_Name__r.Pan_Number__c from genesis__Application_Parties__c where genesis__Application__c = :appId 
                            AND genesis__Party_Type__c =: 'Guarantor' AND Active__c =true];
        // List<clcommon__Collateral__c> colList = [SELECT id,Name,SurveyKhasraKhataPatta_No__c,Collateral_Type__c,EM_Charge_type__c,Nature_of_Property__c,PlotDoorShopBungalow_No__c,Buildup_Area__c,ExtentCarpet_area_Built_up_area__c,Floor_No__c,Stage_Sector_Ward_Block_No__c,Building_Society_Name__c,Street_NameNo__c,VillageTown__c,TalukaTehsil__c,District_Name__c,State__c,Property_Pincode__c,Total_Market_value__c,clcommon__City__c,clcommon__Postal_Code__c,Building_Name__c,Valuation_Date__c FROM clcommon__Collateral__c WHERE Active__c = true AND genesis__Application__c =:appln.Id];
        set<string> allCollIds=new set<string>();
        // for(clcommon__Collateral__c colRec:colList){
        allCollIds.add(LAP_Digio_Service_B1.collValue.Id);
        
        //     }
        List<Ownership__c> ownershp = [SELECT Id,Account__c,Account__r.Name,Account__r.PersonMailingStreet,Account__r.PersonMailingCity,Account__r.PersonMailingState,Branch_Code__c,CBS_Collateral_Id__c,Collateral__c,Collateral__r.Name,Collateral__r.VillageTown__c,Collateral__r.Stage_Sector_Ward_Block_No__c,Collateral__r.clcommon__City__c,Customer_id__c,External_ID__c,Owner_Aadharcard_Number__c,Owner_Customer_Id__c,Owner_Customer_Name__c,Owner_Pancard_Number__c FROM Ownership__c WHERE Collateral__c =: allCollIds];
        List<MOD_Documents__c> modList = [Select Id,DOcNo__c,Date_Of_DOc__c,Nature_of_Doc__c,Parties_to_Document_From__c,Parties_to_Document_To__c,Document_Upload_Type__c,Collateral__c,Collateral__r.Active__c From MOD_Documents__c Where Application__c =:appln.Id  AND Document_Upload_Type__c ='Copy' AND Collateral__c =: allCollIds AND Collateral__r.Active__c = true];
        
        LAP_B1DigioDoc b1Doc = new LAP_B1DigioDoc();
        b1Doc.inputVariables   = new LAP_B1DigioDoc.cls_inputVariables();
        b1Doc.owner_tenantId   = 'cuecent_tenant';
        b1Doc.exe_tenantId = 'cuecent_tenant';
        b1Doc.serviceName      = 'TestJsonStr';
        b1Doc.inputVariables.unique_key    = templateId;
        b1Doc.inputVariables.pdf_unique_key = appln.Id;
        b1Doc.inputVariables.in_msg        = '';
        b1Doc.inputVariables.inputmap  = new LAP_B1DigioDoc.cls_inputmap();
        
        b1Doc.inputVariables.inputmap.Loc_Ref_Branch            = Utility.getBlankStringIfNull(String.ValueOf(appln.Branch_Name__c));
        b1Doc.inputVariables.inputmap.Doc_Gen_date              = formatDate(system.today());
        for(integer i=0;i<ownershp.size();i++){
            if(i==0){
                b1Doc.inputVariables.inputmap.Title_Holder1_Name1         = Utility.getBlankStringIfNull(String.ValueOf(ownershp[i].Account__r.Name));
                TitleHolder1Names                                         = Utility.getBlankStringIfNull(String.ValueOf(ownershp[i].Account__r.Name));    
                b1Doc.inputVariables.inputmap.Title_Holder1_Add_line1     = Utility.getBlankStringIfNull(String.ValueOf(ownershp[i].Account__r.PersonMailingStreet));
                b1Doc.inputVariables.inputmap.Title_Holder1_Add_line2     = Utility.getBlankStringIfNull(String.ValueOf(ownershp[i].Account__r.PersonMailingCity));
                b1Doc.inputVariables.inputmap.Title_Holder1_Add_line3     = Utility.getBlankStringIfNull(String.ValueOf(ownershp[i].Account__r.PersonMailingState));  
            }
            if(i==1){
                b1Doc.inputVariables.inputmap.Title_Holder2_Name1         = Utility.getBlankStringIfNull(String.ValueOf(ownershp[i].Account__r.Name));
                TitleHolder2Names                                         = Utility.getBlankStringIfNull(String.ValueOf(ownershp[i].Account__r.Name));                      
                b1Doc.inputVariables.inputmap.Title_Holder2_Add_line1     = Utility.getBlankStringIfNull(String.ValueOf(ownershp[i].Account__r.PersonMailingStreet));
                b1Doc.inputVariables.inputmap.Title_Holder2_Add_line2     = Utility.getBlankStringIfNull(String.ValueOf(ownershp[i].Account__r.PersonMailingCity));
                b1Doc.inputVariables.inputmap.Title_Holder2_Add_line3     = Utility.getBlankStringIfNull(String.ValueOf(ownershp[i].Account__r.PersonMailingState));
            }
            if(i==2){
                b1Doc.inputVariables.inputmap.Title_Holder3_Name1         = Utility.getBlankStringIfNull(String.ValueOf(ownershp[i].Account__r.Name));
                TitleHolder3Names                                         = Utility.getBlankStringIfNull(String.ValueOf(ownershp[i].Account__r.Name));
                b1Doc.inputVariables.inputmap.Title_Holder3_Add_line1     = Utility.getBlankStringIfNull(String.ValueOf(ownershp[i].Account__r.PersonMailingStreet));
                b1Doc.inputVariables.inputmap.Title_Holder3_Add_line2     = Utility.getBlankStringIfNull(String.ValueOf(ownershp[i].Account__r.PersonMailingCity));
                b1Doc.inputVariables.inputmap.Title_Holder3_Add_line3     = Utility.getBlankStringIfNull(String.ValueOf(ownershp[i].Account__r.PersonMailingState));
            }
            if(i==3){
                b1Doc.inputVariables.inputmap.Title_Holder4_Name1         = Utility.getBlankStringIfNull(String.ValueOf(ownershp[i].Account__r.Name));
                TitleHolder4Names                                         = Utility.getBlankStringIfNull(String.ValueOf(ownershp[i].Account__r.Name));
                b1Doc.inputVariables.inputmap.Title_Holder4_Add_line1     = Utility.getBlankStringIfNull(String.ValueOf(ownershp[i].Account__r.PersonMailingStreet));
                b1Doc.inputVariables.inputmap.Title_Holder4_Add_line2     = Utility.getBlankStringIfNull(String.ValueOf(ownershp[i].Account__r.PersonMailingCity));
                b1Doc.inputVariables.inputmap.Title_Holder4_Add_line3     = Utility.getBlankStringIfNull(String.ValueOf(ownershp[i].Account__r.PersonMailingState));
            }
            if(i==4){
                b1Doc.inputVariables.inputmap.Title_Holder5_Name1         = Utility.getBlankStringIfNull(String.ValueOf(ownershp[i].Account__r.Name));
                TitleHolder5Names                                         = Utility.getBlankStringIfNull(String.ValueOf(ownershp[i].Account__r.Name));
                b1Doc.inputVariables.inputmap.Title_Holder5_Add_line1     = Utility.getBlankStringIfNull(String.ValueOf(ownershp[i].Account__r.PersonMailingStreet));
                b1Doc.inputVariables.inputmap.Title_Holder5_Add_line2     = Utility.getBlankStringIfNull(String.ValueOf(ownershp[i].Account__r.PersonMailingCity));
                b1Doc.inputVariables.inputmap.Title_Holder5_Add_line3     = Utility.getBlankStringIfNull(String.ValueOf(ownershp[i].Account__r.PersonMailingState));
            }
            if(i==5){
                b1Doc.inputVariables.inputmap.Title_Holder6_Name1         = Utility.getBlankStringIfNull(String.ValueOf(ownershp[i].Account__r.Name));
                TitleHolder6Names                                         = Utility.getBlankStringIfNull(String.ValueOf(ownershp[i].Account__r.Name));
                b1Doc.inputVariables.inputmap.Title_Holder6_Add_line1     = Utility.getBlankStringIfNull(String.ValueOf(ownershp[i].Account__r.PersonMailingStreet));
                b1Doc.inputVariables.inputmap.Title_Holder6_Add_line2     = Utility.getBlankStringIfNull(String.ValueOf(ownershp[i].Account__r.PersonMailingCity));
                b1Doc.inputVariables.inputmap.Title_Holder6_Add_line3     = Utility.getBlankStringIfNull(String.ValueOf(ownershp[i].Account__r.PersonMailingState));  
            }
            if(i==6){
                b1Doc.inputVariables.inputmap.Title_Holder7_Name1         = Utility.getBlankStringIfNull(String.ValueOf(ownershp[i].Account__r.Name));
                TitleHolder7Names                                         = Utility.getBlankStringIfNull(String.ValueOf(ownershp[i].Account__r.Name));   
                b1Doc.inputVariables.inputmap.Title_Holder7_Add_line1     = Utility.getBlankStringIfNull(String.ValueOf(ownershp[i].Account__r.PersonMailingStreet));
                b1Doc.inputVariables.inputmap.Title_Holder7_Add_line2     = Utility.getBlankStringIfNull(String.ValueOf(ownershp[i].Account__r.PersonMailingCity));
                b1Doc.inputVariables.inputmap.Title_Holder7_Add_line3     = Utility.getBlankStringIfNull(String.ValueOf(ownershp[i].Account__r.PersonMailingState));  
            }
        }
        b1Doc.inputVariables.inputmap.MOD_Branch                        = Utility.getBlankStringIfNull(String.ValueOf(appln.MOD_Branch__c));
        
        b1Doc.inputVariables.inputmap.Sanction_Ref_Number               = Utility.getBlankStringIfNull(String.ValueOf(appln.Sanction_Reference_Number__c));
        b1Doc.inputVariables.inputmap.Title_deed_deposited_date         = Utility.getBlankStringIfNull(String.ValueOf(appln.MOD_Date__c));
        b1Doc.inputVariables.inputmap.Mod_date                          = Utility.getBlankStringIfNull(String.ValueOf(appln.MOD_Date__c));
        b1Doc.inputvariables.inputmap.Sanction_date                     = Utility.dateFormatterNew();
        
        b1Doc.inputVariables.inputmap.Nature_Property                   = Utility.getBlankStringIfNull(String.ValueOf(LAP_Digio_Service_B1.collValue.Collateral_Type__c));
        b1Doc.inputVariables.inputmap.Survey_No                         = Utility.getBlankStringIfNull(String.ValueOf(LAP_Digio_Service_B1.collValue.SurveyKhasraKhataPatta_No__c));
        b1Doc.inputVariables.inputmap.Plot_Door_Bungalow_No             = Utility.getBlankStringIfNull(String.ValueOf(LAP_Digio_Service_B1.collValue.PlotDoorShopBungalow_No__c));
        b1Doc.inputVariables.inputmap.Extent_Site_Uds                   = Utility.getBlankStringIfNull(String.ValueOf(LAP_Digio_Service_B1.collValue.ExtentCarpet_area_Built_up_area__c));
        b1Doc.inputVariables.inputmap.Built_up_area                     = Utility.getBlankStringIfNull(String.ValueOf(LAP_Digio_Service_B1.collValue.Buildup_Area__c));
        b1Doc.inputVariables.inputmap.Floor_No                          = Utility.getBlankStringIfNull(String.ValueOf(LAP_Digio_Service_B1.collValue.Floor_No__c));
        b1Doc.inputVariables.inputmap.Ward_No                           = Utility.getBlankStringIfNull(String.ValueOf(LAP_Digio_Service_B1.collValue.Stage_Sector_Ward_Block_No__c));
        b1Doc.inputVariables.inputmap.Building_Society_Name_No          = Utility.getBlankStringIfNull(String.ValueOf(LAP_Digio_Service_B1.collValue.Building_Society_Name__c));
        b1Doc.inputVariables.inputmap.Street_Name                       = Utility.getBlankStringIfNull(String.ValueOf(LAP_Digio_Service_B1.collValue.Street_NameNo__c));
        b1Doc.inputVariables.inputmap.Village_Town                      = Utility.getBlankStringIfNull(String.ValueOf(LAP_Digio_Service_B1.collValue.VillageTown__c));
        b1Doc.inputVariables.inputmap.Taluka_Tehsil                     = Utility.getBlankStringIfNull(String.ValueOf(LAP_Digio_Service_B1.collValue.TalukaTehsil__c));
        b1Doc.inputVariables.inputmap.District_Name                     = Utility.getBlankStringIfNull(String.ValueOf(LAP_Digio_Service_B1.collValue.District_Name__c));
        b1Doc.inputVariables.inputmap.State_Name                        = Utility.getBlankStringIfNull(String.ValueOf(LAP_Digio_Service_B1.collValue.State__c));
        b1Doc.inputVariables.inputmap.PIN_CODE                          = Utility.getBlankStringIfNull(String.ValueOf(LAP_Digio_Service_B1.collValue.clcommon__Postal_Code__c));
        
        b1Doc.inputVariables.inputmap.Loan_Product                      = Utility.getBlankStringIfNull(appln.genesis__CL_Product_Name__c);
        b1Doc.inputVariables.inputmap.Ap_LT                             = Utility.getBlankStringIfNull(String.ValueOf(appln.Sanction_Authority_Limit__c));
        for(integer i=0;i<modList.size();i++){
            if(i==0){
                b1Doc.inputVariables.inputmap.Docno_1                    = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                b1Doc.inputVariables.inputmap.Docdt_1                    = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                b1Doc.inputVariables.inputmap.NatureDoc_1                = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                b1Doc.inputVariables.inputmap.Tranf_ror_1                = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                b1Doc.inputVariables.inputmap.Tranf_ree_1          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
            }
            if(i==1){
                b1Doc.inputVariables.inputmap.Docno_2              = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                b1Doc.inputVariables.inputmap.Docdt_2              = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                b1Doc.inputVariables.inputmap.NatureDoc_2          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                b1Doc.inputVariables.inputmap.Tranf_ror_2          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                b1Doc.inputVariables.inputmap.Tranf_ree_2          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
            }
            if(i==2){
                b1Doc.inputVariables.inputmap.Docno_3              = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                b1Doc.inputVariables.inputmap.Docdt_3              = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                b1Doc.inputVariables.inputmap.NatureDoc_3          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                b1Doc.inputVariables.inputmap.Tranf_ror_3          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                b1Doc.inputVariables.inputmap.Tranf_ree_3          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
            }
            if(i==3){
                b1Doc.inputVariables.inputmap.Docno_4              = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                b1Doc.inputVariables.inputmap.Docdt_4              = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                b1Doc.inputVariables.inputmap.NatureDoc_4          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                b1Doc.inputVariables.inputmap.Tranf_ror_4          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                b1Doc.inputVariables.inputmap.Tranf_ree_4          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
            }
            if(i==4){
                b1Doc.inputVariables.inputmap.Docno_5              = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                b1Doc.inputVariables.inputmap.Docdt_5              = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                b1Doc.inputVariables.inputmap.NatureDoc_5          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                b1Doc.inputVariables.inputmap.Tranf_ror_5          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                b1Doc.inputVariables.inputmap.Tranf_ree_5          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
            }
            if(i==5){
                b1Doc.inputVariables.inputmap.Docno_6              = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                b1Doc.inputVariables.inputmap.Docdt_6              = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                b1Doc.inputVariables.inputmap.NatureDoc_6          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                b1Doc.inputVariables.inputmap.Tranf_ror_6          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                b1Doc.inputVariables.inputmap.Tranf_ree_6          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
            }
            if(i==6){
                b1Doc.inputVariables.inputmap.Docno_7              = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                b1Doc.inputVariables.inputmap.Docdt_7              = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                b1Doc.inputVariables.inputmap.NatureDoc_7          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                b1Doc.inputVariables.inputmap.Tranf_ror_7          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                b1Doc.inputVariables.inputmap.Tranf_ree_7          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
            }
            if(i==7){
                b1Doc.inputVariables.inputmap.Docno_8              = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                b1Doc.inputVariables.inputmap.Docdt_8              = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                b1Doc.inputVariables.inputmap.NatureDoc_8          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                b1Doc.inputVariables.inputmap.Tranf_ror_8          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                b1Doc.inputVariables.inputmap.Tranf_ree_8          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
            }
            if(i==8){
                b1Doc.inputVariables.inputmap.Docno_9              = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                b1Doc.inputVariables.inputmap.Docdt_9              = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                b1Doc.inputVariables.inputmap.NatureDoc_9          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                b1Doc.inputVariables.inputmap.Tranf_ror_9          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                b1Doc.inputVariables.inputmap.Tranf_ree_9          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
            }
            if(i==9){
                b1Doc.inputVariables.inputmap.Docno_10             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                b1Doc.inputVariables.inputmap.Docdt_10             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                b1Doc.inputVariables.inputmap.NatureDoc_10         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                b1Doc.inputVariables.inputmap.Tranf_ror_10         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                b1Doc.inputVariables.inputmap.Tranf_ree_10         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
                
            }
            if(i==10){
                b1Doc.inputVariables.inputmap.Docno_11             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                b1Doc.inputVariables.inputmap.Docdt_11             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                b1Doc.inputVariables.inputmap.NatureDoc_11         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                b1Doc.inputVariables.inputmap.Tranf_ror_11         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                b1Doc.inputVariables.inputmap.Tranf_ree_11         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
            }
            if(i==11){
                b1Doc.inputVariables.inputmap.Docno_12             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                b1Doc.inputVariables.inputmap.Docdt_12             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                b1Doc.inputVariables.inputmap.NatureDoc_12         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                b1Doc.inputVariables.inputmap.Tranf_ror_12         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                b1Doc.inputVariables.inputmap.Tranf_ree_12         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
            }
            if(i==12){
                b1Doc.inputVariables.inputmap.Docno_13             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                b1Doc.inputVariables.inputmap.Docdt_13             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                b1Doc.inputVariables.inputmap.NatureDoc_13         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                b1Doc.inputVariables.inputmap.Tranf_ror_13         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                b1Doc.inputVariables.inputmap.Tranf_ree_13         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
            }
            if(i==13){
                b1Doc.inputVariables.inputmap.Docno_14             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                b1Doc.inputVariables.inputmap.Docdt_14             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                b1Doc.inputVariables.inputmap.NatureDoc_14         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                b1Doc.inputVariables.inputmap.Tranf_ror_14         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                b1Doc.inputVariables.inputmap.Tranf_ree_14         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
            }
            if(i==14){
                b1Doc.inputVariables.inputmap.Docno_15             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                b1Doc.inputVariables.inputmap.Docdt_15             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                b1Doc.inputVariables.inputmap.NatureDoc_15         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                b1Doc.inputVariables.inputmap.Tranf_ror_15         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                b1Doc.inputVariables.inputmap.Tranf_ree_15         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
            }
            if(i==15){
                b1Doc.inputVariables.inputmap.Docno_16             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                b1Doc.inputVariables.inputmap.Docdt_16             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                b1Doc.inputVariables.inputmap.NatureDoc_16         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                b1Doc.inputVariables.inputmap.Tranf_ror_16         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                b1Doc.inputVariables.inputmap.Tranf_ree_16         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
            }
            if(i==16){
                b1Doc.inputVariables.inputmap.Docno_17             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                b1Doc.inputVariables.inputmap.Docdt_17             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                b1Doc.inputVariables.inputmap.NatureDoc_17         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                b1Doc.inputVariables.inputmap.Tranf_ror_17         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                b1Doc.inputVariables.inputmap.Tranf_ree_17         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
            }
            if(i==17){
                b1Doc.inputVariables.inputmap.Docno_18             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                b1Doc.inputVariables.inputmap.Docdt_18             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                b1Doc.inputVariables.inputmap.NatureDoc_18         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                b1Doc.inputVariables.inputmap.Tranf_ror_18         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                b1Doc.inputVariables.inputmap.Tranf_ree_18         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
            }
            if(i==18){
                b1Doc.inputVariables.inputmap.Docno_19             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                b1Doc.inputVariables.inputmap.Docdt_19             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                b1Doc.inputVariables.inputmap.NatureDoc_19         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                b1Doc.inputVariables.inputmap.Tranf_ror_19         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                b1Doc.inputVariables.inputmap.Tranf_ree_19         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
            }
            if(i==19){
                b1Doc.inputVariables.inputmap.Docno_20             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                b1Doc.inputVariables.inputmap.Docdt_20             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                b1Doc.inputVariables.inputmap.NatureDoc_20         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                b1Doc.inputVariables.inputmap.Tranf_ror_20         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                b1Doc.inputVariables.inputmap.Tranf_ree_20         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
            }
        }
        for(Integer i=0;i<parties.size();i++){
            if(i==0){
                Borrower2Names = Utility.getBlankStringIfNull(String.ValueOf(parties[i].genesis__Party_Account_Name__r.Full_Name__c));
            }
            if(i==1){
                Borrower3Names = Utility.getBlankStringIfNull(String.ValueOf(parties[i].genesis__Party_Account_Name__r.Full_Name__c));
            }
            if(i==2){
                Borrower4Names = Utility.getBlankStringIfNull(String.ValueOf(parties[i].genesis__Party_Account_Name__r.Full_Name__c));
            }
            if(i==3){
                Borrower5Names = Utility.getBlankStringIfNull(String.ValueOf(parties[i].genesis__Party_Account_Name__r.Full_Name__c));
            }
        }
        Borrower1Names   = appln.genesis__Account__r.Full_Name__c;
        BorrowerDetails += (Borrower1Names != '' ?  Borrower1Names : '');
        BorrowerDetails += (Borrower2Names != '' ? ' & ' +Borrower2Names : '');
        BorrowerDetails += (Borrower3Names != '' ? ' & ' +Borrower3Names : '');
        BorrowerDetails += (Borrower4Names != '' ? ' & ' +Borrower4Names : '');
        BorrowerDetails += (Borrower5Names != '' ? ' & ' +Borrower5Names : '');
        
        TitleHolderdetails += (TitleHolder1Names != '' ? TitleHolder1Names: '');
        TitleHolderdetails += (TitleHolder2Names != '' ? '&' +TitleHolder2Names: '');
        TitleHolderdetails += (TitleHolder3Names != '' ? '&' +TitleHolder3Names: '');
        TitleHolderdetails += (TitleHolder4Names != '' ? '&' +TitleHolder4Names: '');
        TitleHolderdetails += (TitleHolder5Names != '' ? '&' +TitleHolder5Names: '');
        TitleHolderdetails += (TitleHolder6Names != '' ? '&' +TitleHolder6Names: '');
        TitleHolderdetails += (TitleHolder7Names != '' ? '&' +TitleHolder7Names: '');
        
        b1Doc.inputVariables.inputmap.Title_Holder_details        = Utility.getBlankStringIfNull(TitleHolderdetails);
        b1Doc.inputVariables.inputmap.Borrower_Names              = Utility.getBlankStringIfNull(BorrowerDetails);
        return b1Doc;
        
    }
    //----------------------------------------------LAP END Here-----------------------------------
    
    // ----------------------------------HL Non Legal Desk Start Here--------------------------------
    //v1.1(start)
    public static HL_Digio_Manual_Template_Structure getHL_Digio_Manual_A23(string appId,string templateId){
        try {
            genesis__Applications__c appln = new genesis__Applications__c();
            appln = getApplication(appId);
            
            HL_Digio_Manual_Template_Structure HLA23 = new HL_Digio_Manual_Template_Structure();
            
            HLA23.inputVariables   = new HL_Digio_Manual_Template_Structure.cls_inputVariables();
            HLA23.owner_tenantId   = 'cuecent_tenant';
            HLA23.exe_tenantId = 'cuecent_tenant';
            HLA23.serviceName      = 'TestJsonStr';
            HLA23.inputVariables.unique_key    = templateId;
            HLA23.inputVariables.pdf_unique_key = appln.Id;
            HLA23.inputVariables.in_msg        = '';
            HLA23.inputVariables.inputmap  = new HL_Digio_Manual_Template_Structure.cls_inputmap();
            
            String Borrower_Details = '';
            Borrower_Details = appln.genesis__Account__r.Full_Name__c;
            if(appln.genesis__Application_Parties__r.size() > 0){            
                for(genesis__Application_Parties__c party : appln.genesis__Application_Parties__r){
                    if(party.genesis__Party_Type__c == Constants.Co_Borrower && party.Company__c == false){
                        system.debug('party:-'+party);
                        Borrower_Details +=  party.genesis__Party_Account_Name__r.Full_Name__c!=''?' & '+party.genesis__Party_Account_Name__r.Full_Name__c:'';
                        system.debug('Borrower_Details:-'+Borrower_Details);
                        Borrower_Details = Borrower_Details.removeStart(' & ');
                    }
                }          
            }
            HLA23.inputVariables.inputmap.Borrower_Details = Borrower_Details;
            
            
            List<String> BorrowerLst = new List<String>();
            BorrowerLst = Borrower_Details.split(' & ');
            system.debug('BorrowerLst:-'+BorrowerLst);
            if (BorrowerLst.size()>0) {
                HLA23.inputVariables.inputmap.Borrower1_Names = BorrowerLst[0];
            }
            if (BorrowerLst.size()>1) {
                HLA23.inputVariables.inputmap.Borrower2_Names = BorrowerLst[1];
            }
            if (BorrowerLst.size()>2) {
                HLA23.inputVariables.inputmap.Borrower3_Names = BorrowerLst[2];
            }
            if (BorrowerLst.size()>3) {
                HLA23.inputVariables.inputmap.Borrower4_Names = BorrowerLst[3];
            }
            
            //added by prashant singh------on 29/10/2018
            String Ptype='';
            //prashant ends
            HLA23.inputVariables.inputmap.Extent_Site_Uds=Ptype;//added by prashant singh
            HLA23.inputVariables.inputmap.Auth_Sign_Bnk= Constants.KvbBank ;
            
            //prashant singh on 16-11-2018-----COLLATERAL STRUCTURE CHANGES
            //Area_of_the_Land__c
            list<clcommon__Collateral__c> Collateral=new list<clcommon__Collateral__c>( [Select Id,UDS_Sq_Ft__c,Area_of_the_Land__c,Flat_Door_Shop_Bungalow_Nos__c,Floor_No__c,State__c,Property_Pincode__c,Total_Market_value__c,Area_Square_Feet__c,SurveyKhasraKhataPatta_No__c,Nature_Of_Property__c,Stage_Sector_Ward_Block_No__c,Building_Society_Name__c,Street_NameNo__c,clcommon__City__c,TalukaTehsil__c,District_Name__c,clcommon__Address__c,clcommon__Property_Type__c,Market_valueProposedRepairs_Renovation__c,Market_Value_Of_The_Land__c,Buildup_Area__c from clcommon__Collateral__c Where genesis__Application__c =: appid and Active__c=true limit 1]);
            
            if(Collateral!=null && Collateral.size()>0)
            {
                if(Utility.getBlankStringIfNull(String.ValueOf(Collateral[0].clcommon__Property_Type__c))=='Flat') Ptype=Utility.getBlankStringIfNull(String.ValueOf(Collateral[0].UDS_Sq_Ft__c));                         
                else Ptype=Utility.getBlankStringIfNull(String.ValueOf(Collateral[0].Area_of_the_Land__c));  
                HLA23.inputVariables.inputmap.PIN_CODE=Utility.getBlankStringIfNull(Collateral[0].Property_Pincode__c);
                HLA23.inputVariables.inputmap.Village_Town=Utility.getBlankStringIfNull(Collateral[0].clcommon__City__c);
                HLA23.inputVariables.inputmap.State_Name=Utility.getBlankStringIfNull(Collateral[0].State__c);
                HLA23.inputVariables.inputmap.District_Name=Utility.getBlankStringIfNull(Collateral[0].District_Name__c);
                HLA23.inputVariables.inputmap.Taluka_Tehsil=Utility.getBlankStringIfNull(Collateral[0].TalukaTehsil__c); 
                HLA23.inputVariables.inputmap.Street_Name=Utility.getBlankStringIfNull(Collateral[0].Street_NameNo__c);
                HLA23.inputVariables.inputmap.Building_Society_Name_No=Utility.getBlankStringIfNull(Collateral[0].Building_Society_Name__c);
                HLA23.inputVariables.inputmap.Ward_No=Utility.getBlankStringIfNull(Collateral[0].Stage_Sector_Ward_Block_No__c); 
                HLA23.inputVariables.inputmap.Survey_No=Utility.getBlankStringIfNull(Collateral[0].SurveyKhasraKhataPatta_No__c);
                HLA23.inputVariables.inputmap.Nature_Property=Utility.getBlankStringIfNull(Collateral[0].Nature_Of_Property__c);
                //HLA23.inputVariables.inputmap.Built_up_area=Utility.getBlankStringIfNull(Collateral[0].ExtentCarpet_area_Built_up_area__c); 
                HLA23.inputVariables.inputmap.Site_extent               = string.valueOf(Collateral[0].Area_of_the_Land__c);
                HLA23.inputVariables.inputmap.Plot_Door_Bungalow_No               = string.valueOf(Collateral[0].Flat_Door_Shop_Bungalow_Nos__c);
                HLA23.inputVariables.inputmap.Floor_No               = string.valueOf(Collateral[0].Floor_No__c);
                if(appln.Loan_Purpose__c==Constants.Construction || appln.Loan_Purpose__c==Constants.ConstructionOn){
                    HLA23.inputVariables.inputmap.Built_up_area=Utility.getBlankStringIfNull(String.ValueOf(Collateral[0].Buildup_Area__c)); 
                }
                else{
                    HLA23.inputVariables.inputmap.Built_up_area=Utility.getBlankStringIfNull(Collateral[0].ExtentCarpet_area_Built_up_area__c);
                }
            }
            HLA23.inputVariables.inputmap.Disb_Ref_Month = System.now().format('MMMM');
            HLA23.inputVariables.inputmap.Disb_Ref_Year = System.now().format('yyyy');
            HLA23.inputVariables.inputmap.Loc_Ref_Branch = Utility.getBlankStringIfNull(appln.Branch_Name__c);
            HLA23.inputVariables.inputmap.Variance = Utility.getBlankStringIfNull(String.valueOf(appln.Interest_Variation__c));
            HLA23.inputVariables.inputmap.Loc_Ref_Branch = Utility.getBlankStringIfNull(appln.Branch_Name__c);
            HLA23.inputVariables.inputmap.Disb_Ref_Month = system.now().format('MMMM');
            HLA23.inputVariables.inputmap.Loan_Purpose = Utility.getBlankStringIfNull(appln.Loan_Purpose__c);
            HLA23.inputVariables.inputmap.Disb_Ref_Day = System.now().format('dd');
            HLA23.inputVariables.inputmap.Disb_Ref_Month = System.now().format('MMMM')+' month';
            HLA23.inputVariables.inputmap.Disb_Ref_Year = System.now().format('yyyy')+' in year';
            String AmtINWrd = Utility.getBlankStringIfNull(String.ValueOf(appln.Sanction_Amount_Words__c));
            HLA23.inputVariables.inputmap.Ap_LT_inwords = AmtINWrd.replace('Rupess Only','');
            if(appln.genesis__Interest_Rate__c==null){
                appln.genesis__Interest_Rate__c=0;
            }
            HLA23.inputVariables.inputmap.Ap_LT = Utility.getBlankStringIfNull(String.ValueOf(appln.Sanction_Authority_Limit__c));//Sanction_Authority_Limit__c
            
            HLA23.inputVariables.inputmap.Int_ROI = Utility.getBlankStringIfNull(string.valueOf(appln.genesis__Interest_Rate__c));
            HLA23.inputVariables.inputmap.Rating_Freq = Utility.getBlankStringIfNull(appln.MCLR_Type__c);
            if(appln.Penal_Interest__c==null){
                appln.Penal_Interest__c=0;
            }
            HLA23.inputVariables.inputmap.Penal_Interest=Utility.getBlankStringIfNull(String.ValueOf((appln.Penal_Interest__c.setScale(2))));
            if(appln.Preclosure_Charges__c==null){
                appln.Preclosure_Charges__c=0;
            }
            HLA23.inputVariables.inputmap.PreClosure_Charges=Utility.getBlankStringIfNull(String.ValueOf(appln.Preclosure_Charges__c.setScale(2)));
            HLA23.inputVariables.inputmap.Loan_tenor=Utility.getBlankStringIfNull(String.ValueOf(appln.Sanctioned_Tenure__c));
            if( appln.FPIPrincRepayInstal__c <> null && appln.Sanctioned_Tenure__c <> null){
                HLA23.inputVariables.inputmap.DD_FI= Utility.getBlankStringIfNull(String.ValueOf(appln.FPIPrincRepayInstal__c));
                HLA23.inputVariables.inputmap.DD_LI= Utility.getBlankStringIfNull(String.ValueOf((appln.FPIPrincRepayInstal__c).addMonths(integer.valueOf(appln.Sanctioned_Tenure__c-1))));
            }else{
                HLA23.inputVariables.inputmap.DD_FI ='';
                HLA23.inputVariables.inputmap.DD_LI ='';
            }
            //HLA23.inputVariables.inputmap.Extent_Site_Uds =''; commented by prashant singh----on 30/10/2018
            HLA23.inputVariables.inputmap.MCLR_Rate = Utility.getBlankStringIfNull(String.ValueOf(appln.MCLR_Rate__c));
            
            System.debug('##### HL_Digio_Manual_A23 Document request structrue ');
            return HLA23;
        } catch(Exception e) {
            System.debug('##HL_Digio_Manual_A23### --- Error>>> '+ e.getLineNumber() +' ' +e.getMessage());
            HandleBusinessException.captureError('HL_DigioTemplateService', 'getHL_Digio_Manual_A23', e);
            return null;
        }
        
    }
    
    public static HL_Digio_Manual_Template_Structure getHL_Digio_Manual_A46(string appId,string templateId){
        try{
            genesis__Applications__c appln = new genesis__Applications__c();
            appln = getApplication(appId);
            
            HL_Digio_Manual_Template_Structure HLA46 = new HL_Digio_Manual_Template_Structure();
            
            HLA46.inputVariables   = new HL_Digio_Manual_Template_Structure.cls_inputVariables();
            HLA46.owner_tenantId   = 'cuecent_tenant';
            HLA46.exe_tenantId = 'cuecent_tenant';
            HLA46.serviceName      = 'TestJsonStr';
            HLA46.inputVariables.unique_key    = templateId;
            HLA46.inputVariables.pdf_unique_key = appln.Id;
            HLA46.inputVariables.in_msg        = '';
            HLA46.inputVariables.inputmap  = new HL_Digio_Manual_Template_Structure.cls_inputmap();
            
            HLA46.inputVariables.inputmap.Auth_Sign_Bnk= Constants.KvbBank ;
            
            HLA46.inputVariables.inputmap.Int_ROI = Utility.getBlankStringIfNull(string.valueOf(appln.genesis__Interest_Rate__c));
            HLA46.inputVariables.inputmap.Loc_Ref_Branch = Utility.getBlankStringIfNull(appln.Branch_Name__c);
            
            List<genesis__Application_Parties__c> borrowerList = new List<genesis__Application_Parties__c>();
            List<genesis__Application_Parties__c> grantorList = new List<genesis__Application_Parties__c>();
            
            String BorrowerDetails = '';
            String GuarantorDetails = '';
            BorrowerDetails = appln.genesis__Account__r.Full_Name__c;//added by prashant singh---0n 29/10/2018
            system.debug('BorrowerDetails:-'+BorrowerDetails);
            if (appln.genesis__Application_Parties__r.size()>0) {
                for(genesis__Application_Parties__c party : appln.genesis__Application_Parties__r){
                    if(party.genesis__Party_Type__c == 'Co-Borrower' && party.Company__c == false){
                        borrowerList.add(party);
                        BorrowerDetails +=  party.genesis__Party_Account_Name__r.Full_Name__c!=''?' & '+party.genesis__Party_Account_Name__r.Full_Name__c:'';
                        BorrowerDetails = BorrowerDetails.removeStart(' & ');
                        system.debug('BorrowerDetails:- in loop:-'+BorrowerDetails);
                    }
                    if(party.genesis__Party_Type__c == Constants.Gurantor && party.Company__c == false){
                        grantorList.add(party);
                        GuarantorDetails +=  party.genesis__Party_Account_Name__r.Full_Name__c!=''?' & '+party.genesis__Party_Account_Name__r.Full_Name__c:'';
                        GuarantorDetails = GuarantorDetails.removeStart(' & ');          
                    }
                }
            }
            system.debug('check name:--'+BorrowerDetails);
            HLA46.inputVariables.inputmap.Borrower_Names = BorrowerDetails;
            HLA46.inputVariables.inputmap.Guarantor_Details = GuarantorDetails;
            
            if(grantorList.size() >0){
                HLA46.inputVariables.inputmap.Guarantor1_Names = grantorList[0].genesis__Party_Account_Name__r.Full_Name__c;  
            }
            if(grantorList.size() >1){
                HLA46.inputVariables.inputmap.Guarantor2_Names = grantorList[1].genesis__Party_Account_Name__r.Full_Name__c;  
            }
            if(grantorList.size() >2){
                HLA46.inputVariables.inputmap.Guarantor3_Names = grantorList[2].genesis__Party_Account_Name__r.Full_Name__c;  
            }
            if(grantorList.size() >3){
                HLA46.inputVariables.inputmap.Guarantor4_Names = grantorList[3].genesis__Party_Account_Name__r.Full_Name__c;  
            }
            if(grantorList.size() >4){
                HLA46.inputVariables.inputmap.Guarantor5_Names = grantorList[4].genesis__Party_Account_Name__r.Full_Name__c;  
            }
            HLA46.inputVariables.inputmap.Loan_Product=Utility.getBlankStringIfNull(appln.genesis__CL_Product_Name__c);
            HLA46.inputVariables.inputmap.Loan_tenor=Utility.getBlankStringIfNull(String.ValueOf(appln.Sanctioned_Tenure__c));
            HLA46.inputVariables.inputmap.Holiday_period = Utility.getBlankStringIfNull(string.valueOf(appln.Holiday_Period__c));
            HLA46.inputVariables.inputmap.Disb_Ref_Day = System.now().format('dd');
            HLA46.inputVariables.inputmap.Disb_Ref_Month = System.now().format('MMMM')+' month';
            HLA46.inputVariables.inputmap.Disb_Ref_Year = System.now().format('yyyy')+' in year';
            String AmtINWrd = Utility.getBlankStringIfNull(String.ValueOf(appln.Sanction_Amount_Words__c));
            HLA46.inputVariables.inputmap.Ap_LT_inwords = AmtINWrd.replace('Rupess Only','');
            if(appln.genesis__Interest_Rate__c==null){
                appln.genesis__Interest_Rate__c=0;
            }
            HLA46.inputVariables.inputmap.Ap_LT = Utility.getBlankStringIfNull(String.ValueOf(appln.Sanction_Authority_Limit__c));//Sanction_Authority_Limit__c
            
            System.debug('##### HL_Digio_Manual_A46 Document request structrue ');
            system.debug('check name:--'+BorrowerDetails);
            
            return HLA46;
        } catch(Exception e) {
            System.debug('##HL_Digio_Manual_A46### --- Error>>> '+ e.getLineNumber() +' ' +e.getMessage());
            HandleBusinessException.captureError('HL_DigioTemplateService', 'getHL_Digio_Manual_A46', e);
            return null;
        }
    }
    
    public static HL_Digio_Manual_Template_Structure getHL_Digio_Manual_B17(string appId,string templateId){
        try {
            genesis__Applications__c appln = new genesis__Applications__c();
            appln = getApplication(appId);
            
            HL_Digio_Manual_Template_Structure HLB17 = new HL_Digio_Manual_Template_Structure();
            
            HLB17.inputVariables   = new HL_Digio_Manual_Template_Structure.cls_inputVariables();
            HLB17.owner_tenantId   = 'cuecent_tenant';
            HLB17.exe_tenantId = 'cuecent_tenant';
            HLB17.serviceName      = 'TestJsonStr';
            HLB17.inputVariables.unique_key    = templateId;
            HLB17.inputVariables.pdf_unique_key = appln.Id;
            HLB17.inputVariables.in_msg        = '';
            HLB17.inputVariables.inputmap  = new HL_Digio_Manual_Template_Structure.cls_inputmap();
            
            String Borrower_Details = '';
            Borrower_Details = appln.genesis__Account__r.Full_Name__c;
            System.debug('Borrower_Details>>>before'+Borrower_Details);
            if(appln.genesis__Application_Parties__r.size() > 0){            
                for(genesis__Application_Parties__c party : appln.genesis__Application_Parties__r){
                    if(party.genesis__Party_Type__c == Constants.Co_Borrower && party.Company__c == false){
                        Borrower_Details += party.genesis__Party_Account_Name__r.Full_Name__c!=''?' & '+party.genesis__Party_Account_Name__r.Full_Name__c:'';
                        // Borrower_Details = Borrower_Details+ party.genesis__Party_Account_Name__r.Full_Name__c!=''?' & '+party.genesis__Party_Account_Name__r.Full_Name__c:'';
                        //system.debug('Borrower_Details 1 :-'+Borrower_Details);
                        Borrower_Details = Borrower_Details.removeStart(' & ');
                        system.debug('Borrower_Details 2 :-'+Borrower_Details);
                    }
                }          
            }
            System.debug('Borrower_Details>>>'+Borrower_Details);
            HLB17.inputVariables.inputmap.Borrower_Details = Borrower_Details;
            // HLB17.inputVariables.inputmap.Borrower1_Names = appln.genesis__Account__r.Full_Name__c;
            
            List<String> BorrowerLst = new List<String>();
            BorrowerLst = Borrower_Details.split(' & ');
            if (BorrowerLst.size()>0) {
                HLB17.inputVariables.inputmap.Borrower1_Names = BorrowerLst[0];
            }
            if (BorrowerLst.size()>1) {
                HLB17.inputVariables.inputmap.Borrower2_Names = BorrowerLst[1];
            }
            if (BorrowerLst.size()>2) {
                HLB17.inputVariables.inputmap.Borrower3_Names = BorrowerLst[2];
            }
            if (BorrowerLst.size()>3) {
                HLB17.inputVariables.inputmap.Borrower4_Names = BorrowerLst[3];
            }
            
            HLB17.inputVariables.inputmap.Auth_Sign_Bnk= Constants.KvbBank ;
            //prashant singh on 16-11-2018---COLLATERAL STRUCTURE CHANGES
            //Area_of_the_Land__c
            list<clcommon__Collateral__c> Collateral= new list<clcommon__Collateral__c>([Select Id,ExtentCarpet_area_Built_up_area__c,Area_of_the_Land__c,Builder_Present_Owner_Seller_Name__c,State__c,Flat_Door_Shop_Bungalow_Nos__c,Floor_No__c,Property_Pincode__c,Total_Market_value__c,Area_Square_Feet__c,SurveyKhasraKhataPatta_No__c,Nature_Of_Property__c,Stage_Sector_Ward_Block_No__c,Building_Society_Name__c,Street_NameNo__c,clcommon__City__c,TalukaTehsil__c,District_Name__c,clcommon__Address__c,clcommon__Property_Type__c,Market_valueProposedRepairs_Renovation__c,Market_Value_Of_The_Land__c,Buildup_Area__c from clcommon__Collateral__c Where genesis__Application__c =: appid and Active__c=true limit 1]);
            if(Collateral!=null && Collateral.size()>0)
            {
                HLB17.inputVariables.inputmap.PIN_CODE=Utility.getBlankStringIfNull(Collateral[0].Property_Pincode__c);
                HLB17.inputVariables.inputmap.Village_Town=Utility.getBlankStringIfNull(Collateral[0].clcommon__City__c);
                HLB17.inputVariables.inputmap.State_Name=Utility.getBlankStringIfNull(Collateral[0].State__c);
                HLB17.inputVariables.inputmap.District_Name=Utility.getBlankStringIfNull(Collateral[0].District_Name__c);
                HLB17.inputVariables.inputmap.Taluka_Tehsil=Utility.getBlankStringIfNull(Collateral[0].TalukaTehsil__c); 
                HLB17.inputVariables.inputmap.Street_Name=Utility.getBlankStringIfNull(Collateral[0].Street_NameNo__c);
                HLB17.inputVariables.inputmap.Building_Society_Name_No=Utility.getBlankStringIfNull(Collateral[0].Building_Society_Name__c);
                HLB17.inputVariables.inputmap.Ward_No=Utility.getBlankStringIfNull(Collateral[0].Stage_Sector_Ward_Block_No__c); 
                HLB17.inputVariables.inputmap.Survey_No=Utility.getBlankStringIfNull(Collateral[0].SurveyKhasraKhataPatta_No__c);
                HLB17.inputVariables.inputmap.Nature_Property=Utility.getBlankStringIfNull(Collateral[0].Nature_Of_Property__c);
                //HLB17.inputVariables.inputmap.Built_up_area=Utility.getBlankStringIfNull(Collateral[0].ExtentCarpet_area_Built_up_area__c); 
                HLB17.inputVariables.inputmap.Site_extent               = string.valueOf(Collateral[0].Area_of_the_Land__c);
                HLB17.inputVariables.inputmap.Plot_Door_Bungalow_No               = string.valueOf(Collateral[0].Flat_Door_Shop_Bungalow_Nos__c);
                HLB17.inputVariables.inputmap.Floor_No               = string.valueOf(Collateral[0].Floor_No__c);
                HLB17.inputVariables.inputmap.Seller_Name=Utility.getBlankStringIfNull(Collateral[0].Builder_Present_Owner_Seller_Name__c  );
                if(appln.Loan_Purpose__c==Constants.Construction || appln.Loan_Purpose__c==Constants.ConstructionOn){
                    HLB17.inputVariables.inputmap.Built_up_area=Utility.getBlankStringIfNull(String.ValueOf(Collateral[0].Buildup_Area__c)); 
                }
                else{
                    HLB17.inputVariables.inputmap.Built_up_area=Utility.getBlankStringIfNull(Collateral[0].ExtentCarpet_area_Built_up_area__c);
                }
            }
            HLB17.inputVariables.inputmap.Disb_Ref_Month = System.now().format('MMMM');
            HLB17.inputVariables.inputmap.Disb_Ref_Year = System.now().format('yyyy');
            HLB17.inputVariables.inputmap.Loc_Ref_Branch = Utility.getBlankStringIfNull(appln.Branch_Name__c);
            HLB17.inputVariables.inputmap.Variance = Utility.getBlankStringIfNull(String.valueOf(appln.Interest_Variation__c));
            HLB17.inputVariables.inputmap.Loc_Ref_Branch = Utility.getBlankStringIfNull(appln.Branch_Name__c);
            HLB17.inputVariables.inputmap.Disb_Ref_Month = system.now().format('MMMM');
            HLB17.inputVariables.inputmap.Loan_Purpose = Utility.getBlankStringIfNull(appln.Loan_Purpose__c);
            HLB17.inputVariables.inputmap.Disb_Ref_Day = System.now().format('dd');
            HLB17.inputVariables.inputmap.Disb_Ref_Month = System.now().format('MMMM')+' month';
            HLB17.inputVariables.inputmap.Disb_Ref_Year = System.now().format('yyyy')+' in year';
            String AmtINWrd = Utility.getBlankStringIfNull(String.ValueOf(appln.Sanction_Amount_Words__c));
            HLB17.inputVariables.inputmap.Ap_LT_inwords = AmtINWrd.replace('Rupess Only','');
            if(appln.genesis__Interest_Rate__c==null){
                appln.genesis__Interest_Rate__c=0;
            }
            HLB17.inputVariables.inputmap.Ap_LT = Utility.getBlankStringIfNull(String.ValueOf(appln.Sanction_Authority_Limit__c));//Sanction_Authority_Limit__c
            
            HLB17.inputVariables.inputmap.Int_ROI = Utility.getBlankStringIfNull(string.valueOf(appln.genesis__Interest_Rate__c));
            HLB17.inputVariables.inputmap.Rating_Freq = Utility.getBlankStringIfNull(String.valueOf(appln.Rating_Frequency__c));
            if(appln.Penal_Interest__c==null){
                appln.Penal_Interest__c=0;
            }
            HLB17.inputVariables.inputmap.Penal_Interest=Utility.getBlankStringIfNull(String.ValueOf((appln.Penal_Interest__c.setScale(2))));
            if(appln.Preclosure_Charges__c==null){
                appln.Preclosure_Charges__c=0;
            }
            HLB17.inputVariables.inputmap.PreClosure_Charges=Utility.getBlankStringIfNull(String.ValueOf(appln.Preclosure_Charges__c.setScale(2)));
            HLB17.inputVariables.inputmap.Loan_tenor=Utility.getBlankStringIfNull(String.ValueOf(appln.Sanctioned_Tenure__c));
            if( appln.FPIPrincRepayInstal__c <> null && appln.Sanctioned_Tenure__c <> null){
                HLB17.inputVariables.inputmap.DD_FI= Utility.getBlankStringIfNull(String.ValueOf(appln.FPIPrincRepayInstal__c));
                HLB17.inputVariables.inputmap.DD_LI= Utility.getBlankStringIfNull(String.ValueOf((appln.FPIPrincRepayInstal__c).addMonths(integer.valueOf(appln.Sanctioned_Tenure__c-1))));
            }else{
                HLB17.inputVariables.inputmap.DD_FI ='';
                HLB17.inputVariables.inputmap.DD_LI ='';
            }
            HLB17.inputVariables.inputmap.Extent_Site_Uds ='';
            //--HLB17.inputVariables.inputmap.Seller_Name=Utility.getBlankStringIfNull(appln.Name_Of_The_Builder__c);
            HLB17.inputVariables.inputmap.Sale_Agreem_Date = Utility.getBlankStringIfNull(String.valueOf(appln.Date_Of_Sale_Agreement__c));
            HLB17.inputVariables.inputmap.Loan_Product=Utility.getBlankStringIfNull(appln.genesis__CL_Product_Name__c);
            HLB17.inputVariables.inputmap.Advance_Amount = Utility.getBlankStringIfNull(String.ValueOf(appln.Advance_Payment_Made_If_Any__c));
            
            System.debug('##### HL_Digio_Manual_B17 Document request structrue ');
            return HLB17;
        } catch(Exception e) {
            System.debug('##HL_Digio_Manual_B17### --- Error>>> '+ e.getLineNumber() +' ' +e.getMessage());
            HandleBusinessException.captureError('HL_DigioTemplateService', 'getHL_Digio_Manual_B17', e);
            return null;
        }
        
    }
    
    public static HL_Digio_Manual_Template_Structure getHL_Digio_Manual_B1B2(string appId,string templateId){
        try {
            genesis__Applications__c appln = new genesis__Applications__c();
            appln = getApplication(appId);
            
            HL_Digio_Manual_Template_Structure HLB1B2 = new HL_Digio_Manual_Template_Structure();
            
            HLB1B2.inputVariables   = new HL_Digio_Manual_Template_Structure.cls_inputVariables();
            HLB1B2.owner_tenantId   = 'cuecent_tenant';
            HLB1B2.exe_tenantId = 'cuecent_tenant';
            HLB1B2.serviceName      = 'TestJsonStr';
            HLB1B2.inputVariables.unique_key    = templateId;
            HLB1B2.inputVariables.pdf_unique_key = appln.Id;
            HLB1B2.inputVariables.in_msg        = '';
            HLB1B2.inputVariables.inputmap  = new HL_Digio_Manual_Template_Structure.cls_inputmap();
            
            String Title_Holder1Name1 ='';
            String Title_Holder1_Addline1 ='';
            String Title_Holder1_Addline2 ='';
            String Title_Holder1_Addline3 ='';
            
            String Title_Holder2Name1 ='';
            String Title_Holder2_Addline1 ='';
            String Title_Holder2_Addline2 ='';
            String Title_Holder2_Addline3 ='';
            
            String Title_Holder3Name1 ='';
            String Title_Holder3_Addline1 ='';
            String Title_Holder3_Addline2 ='';
            String Title_Holder3_Addline3 ='';
            
            String Title_Holder4Name1 ='';
            String Title_Holder4_Addline1 ='';
            String Title_Holder4_Addline2 ='';
            String Title_Holder4_Addline3 =''; 
            
            List<genesis__Application_Parties__c> titleList = new List<genesis__Application_Parties__c>();
            //added by prashant singh----31/01/2018...
            List<MOD_Documents__c> modList = [Select Id,DOcNo__c,Date_Of_DOc__c,Nature_of_Doc__c,Parties_to_Document_From__c,Parties_to_Document_To__c,Document_Upload_Type__c,Collateral__c,Collateral__r.Active__c From MOD_Documents__c Where Application__c =:appln.Id  AND Document_Upload_Type__c ='Copy' ];
            String Borrower_Details = '';
            Borrower_Details = appln.genesis__Account__r.Full_Name__c;
            String Title_Holder_details = '';
            if(appln.genesis__Application_Parties__r.size() > 0){            
                for(genesis__Application_Parties__c party : appln.genesis__Application_Parties__r){
                    if((party.genesis__Party_Type__c == Constants.Co_Borrower || party.genesis__Party_Type__c == Constants.PRIMARY_APP) && !party.Company__c && party.Title_Holder__c ){
                        Borrower_Details += party.genesis__Party_Account_Name__r.Full_Name__c!=''?' & '+party.genesis__Party_Account_Name__r.Full_Name__c:'';
                        Borrower_Details = Borrower_Details.removeStart(' & ');
                        titleList.add(party);
                        Title_Holder_details +=  party.genesis__Party_Account_Name__r.Full_Name__c!=''?' & '+party.genesis__Party_Account_Name__r.Full_Name__c:'';
                        Title_Holder_details = Title_Holder_details.removeStart(' & ');
                    }
                    
                    
                }          
            }
            system.Debug('Title_Holder_details:-'+Title_Holder_details);
            HLB1B2.inputVariables.inputmap.Borrower_Names = Borrower_Details;
            HLB1B2.inputVariables.inputmap.Title_Holder_details = Title_Holder_details;
            
            if(titleList.size() >0){
                Title_Holder1Name1     = titleList[0].genesis__Party_Account_Name__r.Full_Name__c;
                Title_Holder1_Addline1 = titleList[0].genesis__Party_Account_Name__r.PersonMailingStreet;
                Title_Holder1_Addline2 = titleList[0].genesis__Party_Account_Name__r.PersonMailingCity;
                Title_Holder1_Addline3 = titleList[0].genesis__Party_Account_Name__r.PersonMailingState;  
            }
            if(titleList.size() >1){
                Title_Holder2Name1     = titleList[1].genesis__Party_Account_Name__r.Full_Name__c;
                Title_Holder2_Addline1 = titleList[1].genesis__Party_Account_Name__r.PersonMailingStreet;
                Title_Holder2_Addline2 = titleList[1].genesis__Party_Account_Name__r.PersonMailingCity;
                Title_Holder2_Addline3 = titleList[1].genesis__Party_Account_Name__r.PersonMailingState;  
            }
            
            if(titleList.size() >2){
                Title_Holder3Name1     = titleList[2].genesis__Party_Account_Name__r.Full_Name__c;
                Title_Holder3_Addline1 = titleList[2].genesis__Party_Account_Name__r.PersonMailingStreet;
                Title_Holder3_Addline2 = titleList[2].genesis__Party_Account_Name__r.PersonMailingCity;
                Title_Holder3_Addline3 = titleList[2].genesis__Party_Account_Name__r.PersonMailingState;  
            }
            if(titleList.size() >3){
                Title_Holder4Name1     = titleList[3].genesis__Party_Account_Name__r.Full_Name__c;
                Title_Holder4_Addline1 = titleList[3].genesis__Party_Account_Name__r.PersonMailingStreet;
                Title_Holder4_Addline2 = titleList[3].genesis__Party_Account_Name__r.PersonMailingCity;
                Title_Holder4_Addline3 = titleList[3].genesis__Party_Account_Name__r.PersonMailingState;  
            }
            
            HLB1B2.inputVariables.inputmap.Borrower_Details = Borrower_Details;
            HLB1B2.inputVariables.inputmap.Borrower1_Names = appln.genesis__Account__r.Full_Name__c;
            
            List<String> BorrowerLst = new List<String>();
            BorrowerLst = Borrower_Details.split(' & ');
            if (BorrowerLst.size()>0) {
                HLB1B2.inputVariables.inputmap.Borrower2_Names = BorrowerLst[0];
            }
            if (BorrowerLst.size()>1) {
                HLB1B2.inputVariables.inputmap.Borrower3_Names = BorrowerLst[1];
            }
            if (BorrowerLst.size()>2) {
                HLB1B2.inputVariables.inputmap.Borrower4_Names = BorrowerLst[2];
            }
            
            //prashant start on 29/10/2018
            string Ptype='';
            
            HLB1B2.inputVariables.inputmap.Extent_Site_Uds=Ptype;
            HLB1B2.inputVariables.inputmap.Sanction_Ref_Number=Utility.getBlankStringIfNull(String.ValueOf(appln.Sanction_Reference_Number__c));
            HLB1B2.inputVariables.inputmap.Sanction_date =Utility.dateFormatterNew();
            HLB1B2.inputVariables.inputmap.Mod_date                          = Utility.getBlankStringIfNull(String.ValueOf(appln.MOD_Date__c));
            HLB1B2.inputVariables.inputmap.Doc_Gen_date              = formatDate(system.today());
            
            
            
            //prashant ends
            //added by prashant singh----on 31/10/2018
            for(integer i=0;i<modList.size();i++){
                if(i==0){
                    HLB1B2.inputVariables.inputmap.Docno_1                    = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                    HLB1B2.inputVariables.inputmap.Docdt_1                    = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                    HLB1B2.inputVariables.inputmap.NatureDoc_1                = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ror_1          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ree_1          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
                }
                if(i==1){
                    HLB1B2.inputVariables.inputmap.Docno_2              = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                    HLB1B2.inputVariables.inputmap.Docdt_2              = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                    HLB1B2.inputVariables.inputmap.NatureDoc_2          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ror_2          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ree_2          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
                }
                if(i==2){
                    HLB1B2.inputVariables.inputmap.Docno_3              = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                    HLB1B2.inputVariables.inputmap.Docdt_3              = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                    HLB1B2.inputVariables.inputmap.NatureDoc_3          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ror_3          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ree_3          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
                }
                if(i==3){
                    HLB1B2.inputVariables.inputmap.Docno_4              = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                    HLB1B2.inputVariables.inputmap.Docdt_4              = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                    HLB1B2.inputVariables.inputmap.NatureDoc_4          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ror_4          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ree_4          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
                }
                if(i==4){
                    HLB1B2.inputVariables.inputmap.Docno_5              = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                    HLB1B2.inputVariables.inputmap.Docdt_5              = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                    HLB1B2.inputVariables.inputmap.NatureDoc_5          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ror_5          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ree_5          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
                }
                if(i==5){
                    HLB1B2.inputVariables.inputmap.Docno_6              = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                    HLB1B2.inputVariables.inputmap.Docdt_6              = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                    HLB1B2.inputVariables.inputmap.NatureDoc_6          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ror_6          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ree_6          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
                }
                if(i==6){
                    HLB1B2.inputVariables.inputmap.Docno_7              = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                    HLB1B2.inputVariables.inputmap.Docdt_7              = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                    HLB1B2.inputVariables.inputmap.NatureDoc_7          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ror_7          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ree_7          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
                }
                if(i==7){
                    HLB1B2.inputVariables.inputmap.Docno_8              = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                    HLB1B2.inputVariables.inputmap.Docdt_8              = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                    HLB1B2.inputVariables.inputmap.NatureDoc_8          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ror_8          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ree_8          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
                }
                if(i==8){
                    HLB1B2.inputVariables.inputmap.Docno_9              = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                    HLB1B2.inputVariables.inputmap.Docdt_9              = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                    HLB1B2.inputVariables.inputmap.NatureDoc_9          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ror_9          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ree_9          = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
                }
                if(i==9){
                    HLB1B2.inputVariables.inputmap.Docno_10             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                    HLB1B2.inputVariables.inputmap.Docdt_10             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                    HLB1B2.inputVariables.inputmap.NatureDoc_10         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ror_10         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ree_10         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
                    
                }
                if(i==10){
                    HLB1B2.inputVariables.inputmap.Docno_11             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                    HLB1B2.inputVariables.inputmap.Docdt_11             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                    HLB1B2.inputVariables.inputmap.NatureDoc_11         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ror_11         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ree_11         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
                }
                if(i==11){
                    HLB1B2.inputVariables.inputmap.Docno_12             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                    HLB1B2.inputVariables.inputmap.Docdt_12             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                    HLB1B2.inputVariables.inputmap.NatureDoc_12         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ror_12         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ree_12         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
                }
                if(i==12){
                    HLB1B2.inputVariables.inputmap.Docno_13             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                    HLB1B2.inputVariables.inputmap.Docdt_13             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                    HLB1B2.inputVariables.inputmap.NatureDoc_13         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ror_13         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ree_13         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
                }
                if(i==13){
                    HLB1B2.inputVariables.inputmap.Docno_14             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                    HLB1B2.inputVariables.inputmap.Docdt_14             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                    HLB1B2.inputVariables.inputmap.NatureDoc_14         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ror_14         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ree_14         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
                }
                if(i==14){
                    HLB1B2.inputVariables.inputmap.Docno_15             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                    HLB1B2.inputVariables.inputmap.Docdt_15             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                    HLB1B2.inputVariables.inputmap.NatureDoc_15         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ror_15         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ree_15         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
                }
                if(i==15){
                    HLB1B2.inputVariables.inputmap.Docno_16             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                    HLB1B2.inputVariables.inputmap.Docdt_16             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                    HLB1B2.inputVariables.inputmap.NatureDoc_16         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ror_16         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ree_16         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
                }
                if(i==16){
                    HLB1B2.inputVariables.inputmap.Docno_17             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                    HLB1B2.inputVariables.inputmap.Docdt_17             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                    HLB1B2.inputVariables.inputmap.NatureDoc_17         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ror_17         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ree_17         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
                }
                if(i==17){
                    HLB1B2.inputVariables.inputmap.Docno_18             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                    HLB1B2.inputVariables.inputmap.Docdt_18             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                    HLB1B2.inputVariables.inputmap.NatureDoc_18         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ror_18         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ree_18         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
                }
                if(i==18){
                    HLB1B2.inputVariables.inputmap.Docno_19             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                    HLB1B2.inputVariables.inputmap.Docdt_19             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                    HLB1B2.inputVariables.inputmap.NatureDoc_19         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ror_19         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ree_19         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
                }
                if(i==19){
                    HLB1B2.inputVariables.inputmap.Docno_20             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].DOcNo__c));
                    HLB1B2.inputVariables.inputmap.Docdt_20             = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Date_Of_DOc__c));
                    HLB1B2.inputVariables.inputmap.NatureDoc_20         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Nature_of_Doc__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ror_20         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_From__c));
                    HLB1B2.inputVariables.inputmap.Tranf_ree_20         = Utility.getBlankStringIfNull(String.ValueOf(modList[i].Parties_to_Document_To__c));
                }
            }
            //prashant ends here
            
            HLB1B2.inputVariables.inputmap.Auth_Sign_Bnk= Constants.KvbBank ;
            //prashant singh on 16-11-2018----COLLATERAL STRUCTURE CHANGES
            //Area_of_the_Land__c
            list<clcommon__Collateral__c> Collateral= new list<clcommon__Collateral__c>([Select Id,UDS_Sq_Ft__c,ExtentCarpet_area_Built_up_area__c,Area_of_the_Land__c,Builder_Present_Owner_Seller_Name__c,State__c,Flat_Door_Shop_Bungalow_Nos__c,Floor_No__c,Property_Pincode__c,Total_Market_value__c,Area_Square_Feet__c,SurveyKhasraKhataPatta_No__c,Nature_Of_Property__c,Stage_Sector_Ward_Block_No__c,Building_Society_Name__c,Street_NameNo__c,clcommon__City__c,TalukaTehsil__c,District_Name__c,clcommon__Address__c,clcommon__Property_Type__c,Market_valueProposedRepairs_Renovation__c,Market_Value_Of_The_Land__c,Buildup_Area__c from clcommon__Collateral__c Where genesis__Application__c =: appid and Active__c=true limit 1]);
            
            if(Collateral!=null && Collateral.size()>0)
            {
                if(Utility.getBlankStringIfNull(String.ValueOf(Collateral[0].clcommon__Property_Type__c))=='Flat') Ptype=Utility.getBlankStringIfNull(String.ValueOf(Collateral[0].UDS_Sq_Ft__c));                         
                else Ptype=Utility.getBlankStringIfNull(String.ValueOf(Collateral[0].Area_of_the_Land__c));
                HLB1B2.inputVariables.inputmap.PIN_CODE=Utility.getBlankStringIfNull(Collateral[0].Property_Pincode__c);
                HLB1B2.inputVariables.inputmap.Village_Town=Utility.getBlankStringIfNull(Collateral[0].clcommon__City__c);
                HLB1B2.inputVariables.inputmap.State_Name=Utility.getBlankStringIfNull(Collateral[0].State__c);
                HLB1B2.inputVariables.inputmap.District_Name=Utility.getBlankStringIfNull(Collateral[0].District_Name__c);
                HLB1B2.inputVariables.inputmap.Taluka_Tehsil=Utility.getBlankStringIfNull(Collateral[0].TalukaTehsil__c); 
                HLB1B2.inputVariables.inputmap.Street_Name=Utility.getBlankStringIfNull(Collateral[0].Street_NameNo__c);
                HLB1B2.inputVariables.inputmap.Building_Society_Name_No=Utility.getBlankStringIfNull(Collateral[0].Building_Society_Name__c);
                HLB1B2.inputVariables.inputmap.Ward_No=Utility.getBlankStringIfNull(Collateral[0].Stage_Sector_Ward_Block_No__c); 
                HLB1B2.inputVariables.inputmap.Survey_No=Utility.getBlankStringIfNull(Collateral[0].SurveyKhasraKhataPatta_No__c);
                HLB1B2.inputVariables.inputmap.Nature_Property=Utility.getBlankStringIfNull(Collateral[0].Nature_Of_Property__c);
                //HLB1B2.inputVariables.inputmap.Built_up_area=Utility.getBlankStringIfNull(Collateral[0].ExtentCarpet_area_Built_up_area__c); 
                HLB1B2.inputVariables.inputmap.Site_extent               = string.valueOf(Collateral[0].Area_of_the_Land__c);
                HLB1B2.inputVariables.inputmap.Plot_Door_Bungalow_No               = string.valueOf(Collateral[0].Flat_Door_Shop_Bungalow_Nos__c);
                HLB1B2.inputVariables.inputmap.Floor_No               = string.valueOf(Collateral[0].Floor_No__c);
                HLB1B2.inputVariables.inputmap.Seller_Name=Utility.getBlankStringIfNull(Collateral[0].Builder_Present_Owner_Seller_Name__c );
                if(appln.Loan_Purpose__c==Constants.Construction || appln.Loan_Purpose__c==Constants.ConstructionOn){
                    HLB1B2.inputVariables.inputmap.Built_up_area=Utility.getBlankStringIfNull(String.ValueOf(Collateral[0].Buildup_Area__c)); 
                }
                else{
                    HLB1B2.inputVariables.inputmap.Built_up_area=Utility.getBlankStringIfNull(Collateral[0].ExtentCarpet_area_Built_up_area__c);
                }
            }
            HLB1B2.inputVariables.inputmap.Disb_Ref_Month = System.now().format('MMMM');
            HLB1B2.inputVariables.inputmap.Disb_Ref_Year = System.now().format('yyyy');
            HLB1B2.inputVariables.inputmap.Loc_Ref_Branch = Utility.getBlankStringIfNull(appln.Branch_Name__c);
            HLB1B2.inputVariables.inputmap.Variance = Utility.getBlankStringIfNull(String.valueOf(appln.Interest_Variation__c));
            HLB1B2.inputVariables.inputmap.Loc_Ref_Branch = Utility.getBlankStringIfNull(appln.Branch_Name__c);
            HLB1B2.inputVariables.inputmap.Disb_Ref_Month = system.now().format('MMMM');
            HLB1B2.inputVariables.inputmap.Loan_Purpose = Utility.getBlankStringIfNull(appln.Loan_Purpose__c);
            //-- HLB1B2.inputVariables.inputmap.Ward_No = Utility.getBlankStringIfNull(appln.Stage_Sector_Ward_Block_No__c);
            
            HLB1B2.inputVariables.inputmap.EMI_amount = Utility.getBlankStringIfNull(string.valueOf(appln.Sanctioned_EMI__c));
            HLB1B2.inputVariables.inputmap.Disb_Ref_Day = System.now().format('dd');
            HLB1B2.inputVariables.inputmap.Disb_Ref_Month = System.now().format('MMMM')+' month';
            HLB1B2.inputVariables.inputmap.Disb_Ref_Year = System.now().format('yyyy')+' in year';
            String AmtINWrd = Utility.getBlankStringIfNull(String.ValueOf(appln.Sanction_Amount_Words__c));
            HLB1B2.inputVariables.inputmap.Ap_LT_inwords = AmtINWrd.replace('Rupess Only','');
            if(appln.genesis__Interest_Rate__c==null){
                appln.genesis__Interest_Rate__c=0;
            }
            HLB1B2.inputVariables.inputmap.Ap_LT = Utility.getBlankStringIfNull(String.ValueOf(appln.Sanction_Authority_Limit__c));//Sanction_Authority_Limit__c
            
            HLB1B2.inputVariables.inputmap.Int_ROI = Utility.getBlankStringIfNull(string.valueOf(appln.genesis__Interest_Rate__c));
            HLB1B2.inputVariables.inputmap.Rating_Freq = Utility.getBlankStringIfNull(String.valueOf(appln.Rating_Frequency__c));
            if(appln.Penal_Interest__c==null){
                appln.Penal_Interest__c=0;
            }
            HLB1B2.inputVariables.inputmap.Penal_Interest=Utility.getBlankStringIfNull(String.ValueOf((appln.Penal_Interest__c.setScale(2))));
            if(appln.Preclosure_Charges__c==null){
                appln.Preclosure_Charges__c=0;
            }
            HLB1B2.inputVariables.inputmap.PreClosure_Charges=Utility.getBlankStringIfNull(String.ValueOf(appln.Preclosure_Charges__c.setScale(2)));
            HLB1B2.inputVariables.inputmap.Loan_tenor=Utility.getBlankStringIfNull(String.ValueOf(appln.Sanctioned_Tenure__c));
            if( appln.FPIPrincRepayInstal__c <> null && appln.Sanctioned_Tenure__c <> null){
                HLB1B2.inputVariables.inputmap.DD_FI= Utility.getBlankStringIfNull(String.ValueOf(appln.FPIPrincRepayInstal__c));
                HLB1B2.inputVariables.inputmap.DD_LI= Utility.getBlankStringIfNull(String.ValueOf((appln.FPIPrincRepayInstal__c).addMonths(integer.valueOf(appln.Sanctioned_Tenure__c-1))));
            }else{
                HLB1B2.inputVariables.inputmap.DD_FI ='';
                HLB1B2.inputVariables.inputmap.DD_LI ='';
            }
            // HLB1B2.inputVariables.inputmap.Extent_Site_Uds ='';
            //-- HLB1B2.inputVariables.inputmap.Seller_Name=Utility.getBlankStringIfNull(appln.Name_Of_The_Builder__c);
            HLB1B2.inputVariables.inputmap.Sale_Agreem_Date = Utility.getBlankStringIfNull(String.valueOf(appln.Date_Of_Sale_Agreement__c));
            HLB1B2.inputVariables.inputmap.Loan_Product=Utility.getBlankStringIfNull(appln.genesis__CL_Product_Name__c);
            HLB1B2.inputVariables.inputmap.Advance_Amount = Utility.getBlankStringIfNull(String.ValueOf(appln.Advance_Payment_Made_If_Any__c));
            
            HLB1B2.inputVariables.inputmap.Title_Holder1_Name1 = Title_Holder1Name1;
            HLB1B2.inputVariables.inputmap.Title_Holder1_Add_line1 = Title_Holder1_Addline1;
            HLB1B2.inputVariables.inputmap.Title_Holder1_Add_line2 = Title_Holder1_Addline2;
            HLB1B2.inputVariables.inputmap.Title_Holder1_Add_line2 = Title_Holder1_Addline3;
            
            HLB1B2.inputVariables.inputmap.Title_Holder2_Name1 = Title_Holder2Name1;
            HLB1B2.inputVariables.inputmap.Title_Holder2_Add_line1 = Title_Holder2_Addline1;
            HLB1B2.inputVariables.inputmap.Title_Holder2_Add_line2 = Title_Holder2_Addline2;
            HLB1B2.inputVariables.inputmap.Title_Holder2_Add_line2 = Title_Holder2_Addline3;
            
            HLB1B2.inputVariables.inputmap.Title_Holder3_Name1 = Title_Holder3Name1;
            HLB1B2.inputVariables.inputmap.Title_Holder3_Add_line1 = Title_Holder3_Addline1;
            HLB1B2.inputVariables.inputmap.Title_Holder3_Add_line2 = Title_Holder3_Addline2;
            HLB1B2.inputVariables.inputmap.Title_Holder3_Add_line2 = Title_Holder3_Addline3;
            
            HLB1B2.inputVariables.inputmap.Title_Holder4_Name1 = Title_Holder4Name1;
            HLB1B2.inputVariables.inputmap.Title_Holder4_Add_line1 = Title_Holder4_Addline1;
            HLB1B2.inputVariables.inputmap.Title_Holder4_Add_line2 = Title_Holder4_Addline2;
            HLB1B2.inputVariables.inputmap.Title_Holder4_Add_line2 = Title_Holder4_Addline3;
            
            HLB1B2.inputVariables.inputmap.Doc_gen_date=Utility.getBlankStringIfNull(String.ValueOf(appln.Today_Date__c));
            
            System.debug('##### HL_Digio_Manual_B1B2 Document request structrue ');
            return HLB1B2;
        } catch(Exception e) {
            System.debug('##HL_Digio_Manual_B1B2### --- Error>>> '+ e.getLineNumber() +' ' +e.getMessage());
            HandleBusinessException.captureError('HL_DigioTemplateService', 'getHL_Digio_Manual_B1B2', e);
            return null;
        }
        
    }
    //v1.1(end)
    // ----------------------------------HL Non Legal Desk End Here-------------------------------
    
    // ----------------------------------HL MVP2 Start here-------------------------------
    //v1.2(start)
    public static HL_Digio_Manual_Template_Structure getHL_TakeOver_A54(string appId,string templateId){
        try {
            genesis__Applications__c appln = new genesis__Applications__c();
            appln = getApplication(appId);
            
            HL_Digio_Manual_Template_Structure HL_A54 = new HL_Digio_Manual_Template_Structure();
            
            HL_A54.inputVariables   = new HL_Digio_Manual_Template_Structure.cls_inputVariables();
            HL_A54.owner_tenantId   = 'cuecent_tenant';
            HL_A54.exe_tenantId = 'cuecent_tenant';
            HL_A54.serviceName      = 'TestJsonStr';
            HL_A54.inputVariables.unique_key    = templateId;
            HL_A54.inputVariables.pdf_unique_key = appln.Id;
            HL_A54.inputVariables.in_msg        = '';
            HL_A54.inputVariables.inputmap  = new HL_Digio_Manual_Template_Structure.cls_inputmap();
            
            String Borrower_Details = '';
            String Borrower_Type_Details = '';
            Borrower_Details = appln.genesis__Account__r.Full_Name__c;
            if(appln.genesis__Application_Parties__r.size() > 0){
                for(genesis__Application_Parties__c party : appln.genesis__Application_Parties__r){ 
                    if (party.genesis__Party_Type__c == Constants.PRIMARY_APP) {
                        Borrower_Type_Details = party.genesis__Party_Type__c!=null?party.genesis__Party_Type__c:'';
                    }
                    if(party.genesis__Party_Type__c == Constants.Co_Borrower && party.Company__c == false){
                        Borrower_Details +=  party.genesis__Party_Account_Name__r.Full_Name__c!=''?' & '+party.genesis__Party_Account_Name__r.Full_Name__c:'';
                        Borrower_Details = Borrower_Details.removeStart(' & ');

                        //Added borrower type
                        Borrower_Type_Details = party.genesis__Party_Type__c!=null?','+party.genesis__Party_Type__c:'';
                    }
                }
            }

            System.debug('Borrower_Details:-'+Borrower_Details);
            System.debug('Borrower_Type_Details:-'+Borrower_Type_Details);

            HL_A54.inputVariables.inputmap.Borrower_Details = Borrower_Details;
            
            
            List<String> BorrowerLst = new List<String>();
            BorrowerLst = Borrower_Details.split(' & ');

            List<String> BorrowerTypeLst = new List<String>();
            BorrowerTypeLst = Borrower_Type_Details.split(',');

            System.debug('BorrowerLst:-'+BorrowerLst);
            System.debug('BorrowerTypeLst:-'+BorrowerTypeLst);
            if (BorrowerLst.size()>0 && BorrowerTypeLst.size() > 0) {
                HL_A54.inputVariables.inputmap.Borrower1_Names = BorrowerLst[0];
                HL_A54.inputVariables.inputmap.Borrower1_Type = BorrowerTypeLst[0];
            }
            if (BorrowerLst.size()>1 && BorrowerTypeLst.size() > 1) {
                HL_A54.inputVariables.inputmap.Borrower2_Names = BorrowerLst[1];
                HL_A54.inputVariables.inputmap.Borrower2_Type = BorrowerTypeLst[1];
            }
            if (BorrowerLst.size()>2 && BorrowerTypeLst.size() > 2) {
                HL_A54.inputVariables.inputmap.Borrower3_Names = BorrowerLst[2];
                HL_A54.inputVariables.inputmap.Borrower3_Type = BorrowerTypeLst[2];
            }
            if (BorrowerLst.size()>3 && BorrowerTypeLst.size() > 3) {
                HL_A54.inputVariables.inputmap.Borrower4_Names = BorrowerLst[3];
                HL_A54.inputVariables.inputmap.Borrower4_Type = BorrowerTypeLst[3];
            }
            
            HL_A54.inputVariables.inputmap.Auth_Sign_Bnk= Constants.KvbBank ;
            
            String Ptype='';
            if(appln.genesis__Collaterals__r!=null && appln.genesis__Collaterals__r.size() > 0){
                if(Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Collaterals__r[0].clcommon__Property_Type__c))=='Flat') 
                    Ptype=Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Collaterals__r[0].UDS_Sq_Ft__c));
                else 
                    Ptype=Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Collaterals__r[0].Area_of_the_Land__c));  

                HL_A54.inputVariables.inputmap.PIN_CODE=Utility.getBlankStringIfNull(appln.genesis__Collaterals__r[0].Property_Pincode__c);
                HL_A54.inputVariables.inputmap.Village_Town=Utility.getBlankStringIfNull(appln.genesis__Collaterals__r[0].clcommon__City__c);
                HL_A54.inputVariables.inputmap.State_Name=Utility.getBlankStringIfNull(appln.genesis__Collaterals__r[0].State__c);
                HL_A54.inputVariables.inputmap.District_Name=Utility.getBlankStringIfNull(appln.genesis__Collaterals__r[0].District_Name__c);
                HL_A54.inputVariables.inputmap.Taluka_Tehsil=Utility.getBlankStringIfNull(appln.genesis__Collaterals__r[0].TalukaTehsil__c); 
                HL_A54.inputVariables.inputmap.Street_Name=Utility.getBlankStringIfNull(appln.genesis__Collaterals__r[0].Street_NameNo__c);
                HL_A54.inputVariables.inputmap.Building_Society_Name_No=Utility.getBlankStringIfNull(appln.genesis__Collaterals__r[0].Building_Society_Name__c);
                HL_A54.inputVariables.inputmap.Ward_No=Utility.getBlankStringIfNull(appln.genesis__Collaterals__r[0].Stage_Sector_Ward_Block_No__c); 
                HL_A54.inputVariables.inputmap.Survey_No=Utility.getBlankStringIfNull(appln.genesis__Collaterals__r[0].SurveyKhasraKhataPatta_No__c);
                HL_A54.inputVariables.inputmap.Nature_Property=Utility.getBlankStringIfNull(appln.genesis__Collaterals__r[0].Nature_Of_Property__c);
                HL_A54.inputVariables.inputmap.Built_up_area=Utility.getBlankStringIfNull(appln.genesis__Collaterals__r[0].ExtentCarpet_area_Built_up_area__c); 
                HL_A54.inputVariables.inputmap.Site_extent = string.valueOf(appln.genesis__Collaterals__r[0].Area_of_the_Land__c);
                HL_A54.inputVariables.inputmap.Plot_Door_Bungalow_No = string.valueOf(appln.genesis__Collaterals__r[0].Flat_Door_Shop_Bungalow_Nos__c);
                HL_A54.inputVariables.inputmap.Floor_No = string.valueOf(appln.genesis__Collaterals__r[0].Floor_No__c);
                
                if(appln.Loan_Purpose__c==Constants.Construction || appln.Loan_Purpose__c==Constants.ConstructionOn){
                    HL_A54.inputVariables.inputmap.Built_up_area=Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Collaterals__r[0].Buildup_Area__c)); 
                }
                else{
                    HL_A54.inputVariables.inputmap.Built_up_area=Utility.getBlankStringIfNull(appln.genesis__Collaterals__r[0].ExtentCarpet_area_Built_up_area__c);
                }
            }
            HL_A54.inputVariables.inputmap.Extent_Site_Uds=Ptype;

            HL_A54.inputVariables.inputmap.Disb_Ref_Month = System.now().format('MMMM');
            HL_A54.inputVariables.inputmap.Disb_Ref_Year = System.now().format('yyyy');
            HL_A54.inputVariables.inputmap.Loc_Ref_Branch = Utility.getBlankStringIfNull(appln.Branch_Name__c);
            HL_A54.inputVariables.inputmap.Loc_Ref_Branch = Utility.getBlankStringIfNull(appln.Branch_Name__c);
            HL_A54.inputVariables.inputmap.Disb_Ref_Month = system.now().format('MMMM');
            HL_A54.inputVariables.inputmap.Loan_Purpose = Utility.getBlankStringIfNull(appln.Loan_Purpose__c);
            HL_A54.inputVariables.inputmap.Disb_Ref_Day = System.now().format('dd');
            HL_A54.inputVariables.inputmap.Disb_Ref_Month = System.now().format('MMMM')+' month';
            HL_A54.inputVariables.inputmap.Disb_Ref_Year = System.now().format('yyyy')+' in year';
            //String AmtINWrd = Utility.getBlankStringIfNull(String.ValueOf(appln.Sanction_Amount_Words__c));
            //HL_A54.inputVariables.inputmap.Ap_LT_inwords = AmtINWrd.replace('Rupess Only','');
            if(appln.Sanction_Authority_Limit__c==null){
                appln.Sanction_Authority_Limit__c=0;
            }
            HL_A54.inputVariables.inputmap.Ap_LT = Utility.getBlankStringIfNull(String.ValueOf(appln.Sanction_Authority_Limit__c));
            HL_A54.inputVariables.inputmap.Application_number = Utility.getBlankStringIfNull(String.ValueOf(appln.Name));

            if (appln.Facilities__r.size() > 0) {
                HL_A54.inputVariables.inputmap.Takeover_Bank = Utility.getBlankStringIfNull(String.ValueOf(appln.Facilities__r[0].Approved_Takeover_Bank_Name__c));
                HL_A54.inputVariables.inputmap.Takeover_Outstanding = Utility.getBlankStringIfNull(String.ValueOf(appln.Facilities__r[0].Approved_Takeover_Outstanding_Loan_Amoun__c));
                HL_A54.inputVariables.inputmap.Takeover_Branch = Utility.getBlankStringIfNull(String.ValueOf(appln.Facilities__r[0].Takeover_Branch__c));
                HL_A54.inputVariables.inputmap.Takeover_Loan_Amount = Utility.getBlankStringIfNull(String.ValueOf(appln.Facilities__r[0].Takeover_Sanctioned_Loan_Amount__c));
                HL_A54.inputVariables.inputmap.Takeover_Type_of_charge = Utility.getBlankStringIfNull(String.ValueOf(appln.Facilities__r[0].Takeover_Type_of_Charge__c));
                HL_A54.inputVariables.inputmap.Takeover_OSDate = Utility.getBlankStringIfNull(String.ValueOf(appln.Facilities__r[0].Takeover_Outstanding_as_on__c));
            }

            HL_A54.inputVariables.inputmap.Branch_code = Utility.getBlankStringIfNull(String.ValueOf(appln.Branch_Code__c));
            HL_A54.inputVariables.inputmap.Financial_Yr=Utility.getBlankStringIfNull(String.ValueOf(appln.Sanction_Financial_Year__c));

            System.debug('##### getHL_TakeOver_A54 Document request structrue ');
            return HL_A54;
        } catch(Exception e) {
            System.debug('##getHL_TakeOver_A54### --- Error>>> '+ e.getLineNumber() +' ' +e.getMessage());
            HandleBusinessException.captureError('HL_DigioTemplateService', 'getHL_TakeOver_A54', e);
            return null;
        }
    }

    public static HL_Digio_Manual_Template_Structure getHL_TopUp_A66(string appId,string templateId){
        try {
            genesis__Applications__c appln = new genesis__Applications__c();
            appln = getApplication(appId);
            
            HL_Digio_Manual_Template_Structure HL_A66 = new HL_Digio_Manual_Template_Structure();
            
            HL_A66.inputVariables   = new HL_Digio_Manual_Template_Structure.cls_inputVariables();
            HL_A66.owner_tenantId   = 'cuecent_tenant';
            HL_A66.exe_tenantId = 'cuecent_tenant';
            HL_A66.serviceName      = 'TestJsonStr';
            HL_A66.inputVariables.unique_key    = templateId;
            HL_A66.inputVariables.pdf_unique_key = appln.Id;
            HL_A66.inputVariables.in_msg        = '';
            HL_A66.inputVariables.inputmap  = new HL_Digio_Manual_Template_Structure.cls_inputmap();
            
            String Borrower_Details = '';
            String Borrower_Type_Details = '';
            Borrower_Details = appln.genesis__Account__r.Full_Name__c;
            if(appln.genesis__Application_Parties__r.size() > 0){
                for(genesis__Application_Parties__c party : appln.genesis__Application_Parties__r){ 
                    if (party.genesis__Party_Type__c == Constants.PRIMARY_APP) {
                        Borrower_Type_Details = party.genesis__Party_Type__c!=null?party.genesis__Party_Type__c:'';
                    }
                    if(party.genesis__Party_Type__c == Constants.Co_Borrower && party.Company__c == false){
                        Borrower_Details +=  party.genesis__Party_Account_Name__r.Full_Name__c!=''?' & '+party.genesis__Party_Account_Name__r.Full_Name__c:'';
                        Borrower_Details = Borrower_Details.removeStart(' & ');

                        //Added borrower type
                        Borrower_Type_Details = party.genesis__Party_Type__c!=null?','+party.genesis__Party_Type__c:'';
                    }
                }
            }

            System.debug('Borrower_Details:-'+Borrower_Details);
            System.debug('Borrower_Type_Details:-'+Borrower_Type_Details);

            HL_A66.inputVariables.inputmap.Borrower_Details = Borrower_Details;
            
            
            List<String> BorrowerLst = new List<String>();
            BorrowerLst = Borrower_Details.split(' & ');

            List<String> BorrowerTypeLst = new List<String>();
            BorrowerTypeLst = Borrower_Type_Details.split(',');

            System.debug('BorrowerLst:-'+BorrowerLst);
            System.debug('BorrowerTypeLst:-'+BorrowerTypeLst);
            if (BorrowerLst.size()>0 && BorrowerTypeLst.size() > 0) {
                HL_A66.inputVariables.inputmap.Borrower1_Names = BorrowerLst[0];
                HL_A66.inputVariables.inputmap.Borrower1_Type = BorrowerTypeLst[0];
            }
            if (BorrowerLst.size()>1 && BorrowerTypeLst.size() > 1) {
                HL_A66.inputVariables.inputmap.Borrower2_Names = BorrowerLst[1];
                HL_A66.inputVariables.inputmap.Borrower2_Type = BorrowerTypeLst[1];
            }
            if (BorrowerLst.size()>2 && BorrowerTypeLst.size() > 2) {
                HL_A66.inputVariables.inputmap.Borrower3_Names = BorrowerLst[2];
                HL_A66.inputVariables.inputmap.Borrower3_Type = BorrowerTypeLst[2];
            }
            if (BorrowerLst.size()>3 && BorrowerTypeLst.size() > 3) {
                HL_A66.inputVariables.inputmap.Borrower4_Names = BorrowerLst[3];
                HL_A66.inputVariables.inputmap.Borrower4_Type = BorrowerTypeLst[3];
            }

            //added by prashant singh------on 29/10/2018
            String Ptype='';
            //prashant ends

            HL_A66.inputVariables.inputmap.Extent_Site_Uds=Ptype;//added by prashant singh
            HL_A66.inputVariables.inputmap.Auth_Sign_Bnk= Constants.KvbBank ;
            
            if(appln.genesis__Collaterals__r!=null && appln.genesis__Collaterals__r.size()>0){
                if(Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Collaterals__r[0].clcommon__Property_Type__c))=='Flat') 
                    Ptype=Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Collaterals__r[0].UDS_Sq_Ft__c));                         
                else 
                    Ptype=Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Collaterals__r[0].Area_of_the_Land__c));  
                HL_A66.inputVariables.inputmap.PIN_CODE=Utility.getBlankStringIfNull(appln.genesis__Collaterals__r[0].Property_Pincode__c);
                HL_A66.inputVariables.inputmap.Village_Town=Utility.getBlankStringIfNull(appln.genesis__Collaterals__r[0].clcommon__City__c);
                HL_A66.inputVariables.inputmap.State_Name=Utility.getBlankStringIfNull(appln.genesis__Collaterals__r[0].State__c);
                HL_A66.inputVariables.inputmap.District_Name=Utility.getBlankStringIfNull(appln.genesis__Collaterals__r[0].District_Name__c);
                HL_A66.inputVariables.inputmap.Taluka_Tehsil=Utility.getBlankStringIfNull(appln.genesis__Collaterals__r[0].TalukaTehsil__c); 
                HL_A66.inputVariables.inputmap.Street_Name=Utility.getBlankStringIfNull(appln.genesis__Collaterals__r[0].Street_NameNo__c);
                HL_A66.inputVariables.inputmap.Building_Society_Name_No=Utility.getBlankStringIfNull(appln.genesis__Collaterals__r[0].Building_Society_Name__c);
                HL_A66.inputVariables.inputmap.Ward_No=Utility.getBlankStringIfNull(appln.genesis__Collaterals__r[0].Stage_Sector_Ward_Block_No__c); 
                HL_A66.inputVariables.inputmap.Survey_No=Utility.getBlankStringIfNull(appln.genesis__Collaterals__r[0].SurveyKhasraKhataPatta_No__c);
                HL_A66.inputVariables.inputmap.Nature_Property=Utility.getBlankStringIfNull(appln.genesis__Collaterals__r[0].Nature_Of_Property__c);
                //HL_A66.inputVariables.inputmap.Built_up_area=Utility.getBlankStringIfNull(appln.genesis__Collaterals__r[0].ExtentCarpet_area_Built_up_area__c); 
                HL_A66.inputVariables.inputmap.Site_extent = string.valueOf(appln.genesis__Collaterals__r[0].Area_of_the_Land__c);
                HL_A66.inputVariables.inputmap.Plot_Door_Bungalow_No = string.valueOf(appln.genesis__Collaterals__r[0].Flat_Door_Shop_Bungalow_Nos__c);
                HL_A66.inputVariables.inputmap.Floor_No = string.valueOf(appln.genesis__Collaterals__r[0].Floor_No__c);
                if(appln.Loan_Purpose__c==Constants.Construction || appln.Loan_Purpose__c==Constants.ConstructionOn){
                    HL_A66.inputVariables.inputmap.Built_up_area=Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Collaterals__r[0].Buildup_Area__c)); 
                }
                else{
                    HL_A66.inputVariables.inputmap.Built_up_area=Utility.getBlankStringIfNull(appln.genesis__Collaterals__r[0].ExtentCarpet_area_Built_up_area__c);
                }
                HL_A66.inputVariables.inputmap.East_collateral = Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Collaterals__r[0].Boundaries_East__c));
                HL_A66.inputVariables.inputmap.West_collateral = Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Collaterals__r[0].Boundaries_West__c));
                HL_A66.inputVariables.inputmap.North_collateral = Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Collaterals__r[0].Boundaries_North__c));
                HL_A66.inputVariables.inputmap.South_collateral = Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Collaterals__r[0].Boundaries_South__c));
            }

            HL_A66.inputVariables.inputmap.Disb_Ref_Month = System.now().format('MMMM');
            HL_A66.inputVariables.inputmap.Disb_Ref_Year = System.now().format('yyyy');
            HL_A66.inputVariables.inputmap.Loc_Ref_Branch = Utility.getBlankStringIfNull(appln.Branch_Name__c);
            HL_A66.inputVariables.inputmap.Variance = Utility.getBlankStringIfNull(String.valueOf(appln.Interest_Variation__c));
            HL_A66.inputVariables.inputmap.Loc_Ref_Branch = Utility.getBlankStringIfNull(appln.Branch_Name__c);
            HL_A66.inputVariables.inputmap.Disb_Ref_Month = system.now().format('MMMM');
            HL_A66.inputVariables.inputmap.Loan_Purpose = Utility.getBlankStringIfNull(appln.Loan_Purpose__c);
            HL_A66.inputVariables.inputmap.Disb_Ref_Day = System.now().format('dd');
            HL_A66.inputVariables.inputmap.Disb_Ref_Month = System.now().format('MMMM')+' month';
            HL_A66.inputVariables.inputmap.Disb_Ref_Year = System.now().format('yyyy')+' in year';
            String AmtINWrd = Utility.getBlankStringIfNull(String.ValueOf(appln.Sanction_Amount_Words__c));
            HL_A66.inputVariables.inputmap.Ap_LT_inwords = AmtINWrd.replace('Rupess Only','');
            if(appln.genesis__Interest_Rate__c==null){
                appln.genesis__Interest_Rate__c=0;
            }
            HL_A66.inputVariables.inputmap.Ap_LT = Utility.getBlankStringIfNull(String.ValueOf(appln.Sanction_Authority_Limit__c));//Sanction_Authority_Limit__c
            
            HL_A66.inputVariables.inputmap.Int_ROI = Utility.getBlankStringIfNull(string.valueOf(appln.genesis__Interest_Rate__c));
            HL_A66.inputVariables.inputmap.Rating_Freq = Utility.getBlankStringIfNull(String.valueOf(appln.Rating_Frequency__c));
            if(appln.Penal_Interest__c==null){
                appln.Penal_Interest__c=0;
            }
            HL_A66.inputVariables.inputmap.Penal_Interest=Utility.getBlankStringIfNull(String.ValueOf((appln.Penal_Interest__c.setScale(2))));
            if(appln.Preclosure_Charges__c==null){
                appln.Preclosure_Charges__c=0;
            }
            HL_A66.inputVariables.inputmap.PreClosure_Charges=Utility.getBlankStringIfNull(String.ValueOf(appln.Preclosure_Charges__c.setScale(2)));
            HL_A66.inputVariables.inputmap.Loan_tenor=Utility.getBlankStringIfNull(String.ValueOf(appln.Sanctioned_Tenure__c));
            if( appln.FPIPrincRepayInstal__c <> null && appln.Sanctioned_Tenure__c <> null){
                HL_A66.inputVariables.inputmap.DD_FI= Utility.getBlankStringIfNull(String.ValueOf(appln.FPIPrincRepayInstal__c));
                HL_A66.inputVariables.inputmap.DD_LI= Utility.getBlankStringIfNull(String.ValueOf((appln.FPIPrincRepayInstal__c).addMonths(integer.valueOf(appln.Sanctioned_Tenure__c-1))));
            }else{
                HL_A66.inputVariables.inputmap.DD_FI ='';
                HL_A66.inputVariables.inputmap.DD_LI ='';
            }
            //HL_A66.inputVariables.inputmap.Extent_Site_Uds =''; commented by prashant singh----on 30/10/2018
            HL_A66.inputVariables.inputmap.MCLR_Rate = Utility.getBlankStringIfNull(String.ValueOf(appln.MCLR_Rate__c));
            HL_A66.inputVariables.inputmap.EMI_amount = Utility.getBlankStringIfNull(String.ValueOf(appln.Sanctioned_EMI__c));

            if (appln.Facilities__r!=null && appln.Facilities__r.size() > 0) {
                HL_A66.inputVariables.inputmap.Existing_MOD_SRO = Utility.getBlankStringIfNull(String.ValueOf(appln.Facilities__r[0].Existing_HL_MOD_SRO__c));
                HL_A66.inputVariables.inputmap.Existing_HL_amount = Utility.getBlankStringIfNull(String.ValueOf(appln.Facilities__r[0].Existing_HL_Sanctioned_Amount__c));
                
                NumberToWordConversion numberToWord = new NumberToWordConversion();
                String ExistingHLAmtINWrd = Utility.getBlankStringIfNull(String.valueOf(numberToWord.getNumberTOWordConvertion(appln.Facilities__r[0].Existing_HL_Sanctioned_Amount__c)));
                HL_A66.inputVariables.inputmap.Existing_HL_amount_in_words = ExistingHLAmtINWrd.remove('Rupees Only');
                
                HL_A66.inputVariables.inputmap.Existing_MOD = Utility.getBlankStringIfNull(String.ValueOf(appln.Facilities__r[0].Existing_HL_MOD_No__c));
                HL_A66.inputVariables.inputmap.Existing_A23_date = Utility.getBlankStringIfNull(String.ValueOf(appln.Facilities__r[0].Existing_HL_A23_Agreement_Date__c));
                HL_A66.inputVariables.inputmap.Existing_MOD_date = Utility.getBlankStringIfNull(String.ValueOf(appln.Facilities__r[0].Existing_HL_MOD_Date__c));
            }

            System.debug('##### getHL_TopUp_A66 Document request structrue ');
            return HL_A66;
        } catch(Exception e) {
            System.debug('##getHL_TopUp_A66### --- Error>>> '+ e.getLineNumber() +' ' +e.getMessage());
            HandleBusinessException.captureError('HL_DigioTemplateService', 'getHL_TopUp_A66', e);
            return null;
        }
    }
    //v1.2(end)
    // ----------------------------------HL MVP2 End here-------------------------------

    public class signersWrap{
        public string name;
        public string partyType;
        public  signersWrap(String name,string typee){
            this.name = name;
            this.partyType = typee;
        }
        
    }
    public static String formatDate(Date d) {
        if(d != null){
            return d.day() + '-' + d.month() + '-' + d.year();
        }
        return '';
    }
    
	public static string dateFormatterChange(Date d) {
		if(d != null){
          DateTime yourDate = d;
          String dateOutput = yourDate.format('dd-MM-yyyy');
        return dateOutput;
		}
		return '';
    }

	
    //v1.1(start)
    public static genesis__Applications__c getApplication(String appId){
        genesis__Applications__c appln = new genesis__Applications__c();
        // removed--collateral structure changes----on 29-11-2018--- Survey_No_Katha_No_Other_No_s__c
        appln=[select id,Type_Of_Charge__c,genesis__Account__r.Aadhaar_Number__pc,genesis__Account__r.Phone,genesis__Account__r.Person_Email__c,genesis__Account__r.Pan_Number__c,genesis__Account__r.Name,Branch_Name__c,genesis__Loan_Amount__c,genesis__Account__r.PersonMobilePhone,
               Branch_Code__c,Created_Date__c,Name,genesis__Account__r.BillingStreet,Sanction_Financial_Year__c,Sanction_Date__c,Amount_in_Words_And_Figures__c,Sanction_Reference_Number__c,
               genesis__Account__r.BillingCity,genesis__Account__r.BillingState,genesis__Account__r.BillingCountry,genesis__CL_Product_Name__c,genesis__Term__c,
               genesis__Interest_Rate__c,Processing_Fee__c,Sanctioned_EMI__c,MCLR_Rate__c,genesis__Margin__c,Today_Date__c,genesis__Account__r.Father_Husband_Daughter_Name__c,genesis__Account__r.PersonMailingStreet,
               genesis__Account__r.PersonMailingCity,genesis__Account__r.PersonMailingState,genesis__Account__r.PersonMailingPostalCode,Loan_Purpose__c,genesis__Payment_Frequency__c,Holiday_Period__c,genesis__Account__r.PersonTitle,Diff_B_w_ROI_MCLR__c,Interest_Variation__c,RecordType.developerName,genesis__Account__r.Full_Name__c,Record_Type_Name__c,Branch_State__c,FPIIntRepayInstal__c,Penal_Interest__c,Document_Generation__c,genesis__Expected_Close_Date__c,genesis__Expected_First_Payment_Date__c,Preclosure_Charges__c,Rating_Frequency__c,Excess_MCLR__c,Sanctioned_Tenure__c,genesis__Interest_Calculation_Method__c,genesis__Amortization_Term__c,Sanction_Amount_Words__c,Sanction_Authority_Limit__c,Xerox_Reason1__c,FPIPrincRepayInstal2__c,Xerox_Reason2__c,Xerox_Doc_Table__c,MOD_Date__c,MOD_Branch__c,Primary_Applicant__c,Disbursal_Financial_Year__c,FPIPrincRepayInstal__c,genesis__Disbursement_Date__c,MCLR_Type__c,Month_Of_Disbursal__c,Day_Of_Disbursal__c,Sub_Stage__c,Advance_Payment_Made_If_Any__c,Date_Of_Sale_Agreement__c,PreClosure_Interest_Rate__c,genesis__Account__r.PersonMailingCountry,(select id,genesis__Party_Type__c,genesis__Party_Account_Name__c,genesis__Party_Account_Name__r.CIBIL_Score__c,genesis__Party_Account_Name__r.id,Title_Holder__c,genesis__Party_Account_Name__r.Full_Name__c,Company__c,genesis__Party_Account_Name__r.Name,genesis__Party_Account_Name__r.Father_Husband_Daughter_Name__c,genesis__Party_Account_Name__r.Salutation,genesis__Party_Account_Name__r.PersonMailingCity,genesis__Party_Account_Name__r.PersonMailingState,genesis__Party_Account_Name__r.PersonMailingPostalCode,genesis__Party_Account_Name__r.PersonMailingStreet,Guarantor__c,Signatories__c,genesis__Party_Account_Name__r.Aadhaar_Number__pc,genesis__Party_Account_Name__r.Phone,genesis__Party_Account_Name__r.Person_Email__c,genesis__Party_Account_Name__r.Pan_Number__c,genesis__Party_Account_Name__r.PersonMobilePhone,genesis__Party_Account_Name__r.PersonTitle from genesis__Application_Parties__r where Active__c=true),(Select Id,UDS_Sq_Ft__c,Area_of_the_Land__c,Flat_Door_Shop_Bungalow_Nos__c,Floor_No__c,State__c,Property_Pincode__c,Total_Market_value__c,Area_Square_Feet__c,SurveyKhasraKhataPatta_No__c,Nature_Of_Property__c,Stage_Sector_Ward_Block_No__c,Building_Society_Name__c,Street_NameNo__c,clcommon__City__c,TalukaTehsil__c,District_Name__c,clcommon__Address__c,clcommon__Property_Type__c,Market_valueProposedRepairs_Renovation__c,Market_Value_Of_The_Land__c,Buildup_Area__c,Boundaries_East__c, Boundaries_North__c, Boundaries_South__c, Boundaries_West__c,ExtentCarpet_area_Built_up_area__c from genesis__Collaterals__r Where Active__c=true),(SELECT Id, Approved_Takeover_Outstanding_Loan_Amoun__c, Approved_Takeover_Sanctioned_Loan_Amount__c, Approved_Takeover_Sanctioned_Loan_Tenure__c, Approved_Takeover_Outstanding_Loan_Tenur__c, Approved_Takeover_Holiday_Period_months__c, Approved_Takeover_Loans_EMI__c, Approved_Takeover_Rate_of_Interest__c,Existing_HL_MOD_SRO__c,Existing_HL_Sanctioned_Amount__c,MCLR_Rate__c,Existing_HL_MOD_No__c,Existing_HL_A23_Agreement_Date__c,Existing_HL_MOD_Date__c,Approved_Takeover_Bank_Name__c,Takeover_Branch__c,Takeover_Type_of_Charge__c,Approved_Takeover_Outstanding_as_on__c,Takeover_Outstanding_as_on__c,Takeover_Sanctioned_Loan_Amount__c FROM Facilities__r where Active__c = true AND Selected_for_Top_Up__c = true) from genesis__Applications__c where ID =:appId];//v1.2
        return appln;
    }
    //v1.1(end)
    
}