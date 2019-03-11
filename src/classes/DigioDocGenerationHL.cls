/*
* Name      : DigioDocGenerationHL
* Compnay   : ET Marlabs
* Purpose   : Document generation of HL and LAP for Legal desk flow applications
* Author    : Venu
-----------------------------------------------------------------------
Version     Date            Author          Remarks                                                 
=======     ==========      =============   ==================================
v1.1        14-Dec-2018     Braj            LAP B1 document generation logic change with multiple ownership for collateral
v1.2        15-Feb-2018     Braj            Appln at substage Loan Sanctioned NSTP/MOD Initiated will to go Disbursement Approved only if all the Top Up documents are generated
*******************************************************************************************/
global class DigioDocGenerationHL {
    public static String collName = '';
    Webservice static void callLegalDocGen(string appId){
        database.executeBatch(new Batch_eStamp_B1_DocGeneration(appId),1);
    }
    Webservice static String CallDocuments(String AppID,string DocType,List<clcommon__Collateral__c> colList){
        System.debug('AppID>>'+AppID+' **DocType>>'+DocType+' **colList>>'+colList);
        try{
            if(colList != null && colList.size() > 0)
                collName = colList[0].Name;
            
            set<string> DocsList=new set<string>();
            set<string> allCollIds=new set<string>();
            transient Map<String,String> DocCOntent=new Map<String,String>();
            Map<String,String> DocIds=new Map<String,String>();
            Map<String,String> mapCollToOwner=new Map<String,String>();
            Map<Integer,String> mapofUuidByFileName = new Map<Integer,String>();
            Map<Integer,String> mapofUuidByclass2File = new Map<Integer,String>();
            
            integer pageCount =0;
            string ss='';
            string Class2Doc='';
            string Docid;
            string BranchState='';
            
            genesis__Applications__c App=[select id,Sub_Type__c,Diff_B_w_ROI_MCLR__c,Interest_Variation__c,Processing_Fee__c,RecordType.developerName,Sanctioned_EMI__c,genesis__Account__r.Full_Name__c,Record_Type_Name__c,Branch_Code__c,Branch_State__c,FPIIntRepayInstal__c,Penal_Interest__c,Document_Generation__c,genesis__Expected_Close_Date__c,genesis__Expected_First_Payment_Date__c,Preclosure_Charges__c,Rating_Frequency__c,
                                          MCLR_Rate__c,Excess_MCLR__c,Sanctioned_Tenure__c,genesis__Interest_Calculation_Method__c,Loan_Purpose__c,Holiday_Period__c,genesis__Amortization_Term__c,Sanction_Amount_Words__c,Sanction_Authority_Limit__c,genesis__Term__c,genesis__Interest_Rate__c,genesis__Loan_Amount__c,Sanction_Date__c,Sanction_Reference_Number__c,
                                          Xerox_Reason1__c,FPIPrincRepayInstal2__c,Xerox_Reason2__c,Xerox_Doc_Table__c,MOD_Date__c,MOD_Branch__c,Property_City__c,Name_Of_The_Socity__c,Primary_Applicant__c,
                                          Disbursal_Financial_Year__c,FPIPrincRepayInstal__c,genesis__Disbursement_Date__c,MCLR_Type__c,Month_Of_Disbursal__c,Day_Of_Disbursal__c,Sub_Stage__c,Name,genesis__Account__r.Name,
                                          genesis__Account__r.PersonMobilePhone,genesis__Account__r.CIBIL_Score__c,Branch_Name__c,genesis__CL_Product_Name__c,
                                          Advance_Payment_Made_If_Any__c,Date_Of_Sale_Agreement__c,Nature_Of_Property__c,Survey_No_Katha_No_Other_No_s__c,Flat_No__c,
                                          Floor_No__c,Stage_Sector_Ward_Block_No__c,Street_Name__c,PreClosure_Interest_Rate__c,Taluka_Tehsil__c,Property_District__c,Property_State__c,Property_Pincode__c,
                                          genesis__Account__r.PersonMailingStreet,genesis__Account__r.PersonMailingCity,genesis__Account__r.PersonMailingState,
                                          genesis__Account__r.PersonMailingPostalCode,genesis__Account__r.PersonMailingCountry,( select id,genesis__Party_Type__c,genesis__Party_Account_Name__c, genesis__Party_Account_Name__r.id,Title_Holder__c from genesis__Application_Parties__r where Active__c=true AND genesis__Party_Account_Name__r.PersonEmail != null AND genesis__Party_Account_Name__r.PersonMobilePhone != null),(Select id,Approved_Additional_Charge__c,Valuation_Applicable__c,Buildup_Area__c,Boundaries_East__c, Boundaries_North__c, Boundaries_South__c, Boundaries_West__c,UDS_Sq_Ft__c,Floor_No__c,Flat_Door_Shop_Bungalow_Nos__c,Area_of_the_Land__c,State__c,Builder_Present_Owner_Seller_Name__c,Property_Pincode__c,Total_Market_value__c,Area_Square_Feet__c,SurveyKhasraKhataPatta_No__c,Nature_Of_Property__c,Stage_Sector_Ward_Block_No__c,Building_Society_Name__c,Street_NameNo__c,clcommon__City__c,TalukaTehsil__c,District_Name__c,clcommon__Address__c,clcommon__Property_Type__c,Market_valueProposedRepairs_Renovation__c,Market_Value_Of_The_Land__c ,ExtentCarpet_area_Built_up_area__c from genesis__Collaterals__r Where Active__c=true limit 1),(SELECT Id,Approved_Takeover_Outstanding_as_on__c, Approved_Takeover_Outstanding_Loan_Amoun__c, Approved_Takeover_Sanctioned_Loan_Amount__c, Approved_Takeover_Sanctioned_Loan_Tenure__c, Approved_Takeover_Outstanding_Loan_Tenur__c, Approved_Takeover_Holiday_Period_months__c, Approved_Takeover_Loans_EMI__c, Approved_Takeover_Rate_of_Interest__c,Existing_HL_MOD_SRO__c,Existing_HL_Sanctioned_Amount__c,MCLR_Rate__c,Existing_HL_MOD_No__c,Existing_HL_A23_Agreement_Date__c,Existing_HL_MOD_Date__c,Approved_Takeover_Bank_Name__c,Takeover_Branch__c,Takeover_Type_of_Charge__c FROM Facilities__r where Active__c = true AND Selected_for_Top_Up__c = true)
                                          from genesis__Applications__c where ID =:AppID];//v1.2
            
            List<clcommon__Collateral__c> colllist = new List<clcommon__Collateral__c>();
            if(colList!=null && colList.size()>0 && colList[0].Id!=null){
                colllist = colList;
            }else{
                colllist = [SELECT id,Name,SurveyKhasraKhataPatta_No__c,Collateral_Type__c,EM_Charge_type__c,Nature_of_Property__c,PlotDoorShopBungalow_No__c,Buildup_Area__c,ExtentCarpet_area_Built_up_area__c,Floor_No__c,Stage_Sector_Ward_Block_No__c,Building_Society_Name__c,Street_NameNo__c,VillageTown__c,TalukaTehsil__c,District_Name__c,State__c,Property_Pincode__c,Total_Market_value__c,clcommon__City__c,clcommon__Postal_Code__c,Building_Name__c,Valuation_Date__c FROM clcommon__Collateral__c WHERE Active__c = true AND genesis__Application__c = :AppID];//v1.2
            }
            for(clcommon__Collateral__c colRec:colllist){
                allCollIds.add(colRec.Id);
            }
            //v1.1(start)
            List<Ownership__c> ownershp = new List<Ownership__c>();
            for(Ownership__c o : [SELECT Id,Account__c,Account__r.Name,Account__r.PersonMailingStreet,Account__r.PersonMailingCity,Account__r.PersonMailingState,Branch_Code__c,CBS_Collateral_Id__c,Collateral__c,Collateral__r.Name,Collateral__r.VillageTown__c,Collateral__r.Stage_Sector_Ward_Block_No__c,Collateral__r.clcommon__City__c,Customer_id__c,External_ID__c,Owner_Aadharcard_Number__c,Owner_Customer_Id__c,Owner_Customer_Name__c,Owner_Pancard_Number__c FROM Ownership__c WHERE Collateral__c =: allCollIds]){
                ownershp.add(o);
                mapCollToOwner.put(o.Collateral__r.Name,o.Account__c);
            }
            
            String Document_Gen = App.Document_Generation__c != null ? App.Document_Generation__c : 'none';
            System.debug('Document_Gen>>'+Document_Gen);
            if(colList.size() > 0 && Document_Gen.contains(Constants.B1DOcGene)){
                Document_Gen = Document_Gen.remove(Constants.B1DOcGene);
                Document_Gen = Document_Gen.remove(Constants.B1DOcID);
            }
            //v1.1(end)
            if(DocType == 'Disburse' && (App.Loan_Purpose__c==Constants.IdentifiedProperty  || App.Loan_Purpose__c==Constants.ConstructionOn) && !Document_Gen.contains(Constants.B17DocGen) && !Document_Gen.contains(Constants.B17DocID)){
                
                DocsList.add(Constants.B17_HL);
                
            }
            
            for(genesis__Application_Parties__c Apart:App.genesis__Application_Parties__r){
                
                if(DocType == 'Disburse' && Apart.genesis__Party_Type__c ==Constants.Gurantor &&  !Document_Gen.contains(Constants.A46DocGene) && !Document_Gen.contains(Constants.A46Class2sign)  && !Document_Gen.contains(Constants.A46DocID)){
                    DocsList.add(Constants.A46_HL);
                }
            }
            for(genesis__Application_Parties__c Apart:App.genesis__Application_Parties__r){
                
                if(DocType == 'LAPADOC' && Apart.genesis__Party_Type__c ==Constants.Gurantor &&  !Document_Gen.contains(Constants.A46DocGene) && !Document_Gen.contains(Constants.A46Class2sign)  && !Document_Gen.contains(Constants.A46DocID)){
                    DocsList.add(Constants.LAP_A46);
                }
            }
            if(DocType == 'Disburse'){
                if(!Document_Gen.contains(Constants.A23DocGen) && !Document_Gen.contains(Constants.A23Class2)  && !Document_Gen.contains(Constants.A23DocID)){
                    DocsList.add(Constants.A23_HL);
                }
                
            }
            else if(DocType == 'LAPADOC'){
                if(!Document_Gen.contains(Constants.A23DocGen) && !Document_Gen.contains(Constants.A23Class2)  && !Document_Gen.contains(Constants.A23DocID)){
                    DocsList.add(Constants.LAP_A23);
                }
                
            }
            else if(DocType=='MOD'){
                
                if(!Document_Gen.contains(Constants.B1DOcGene) && !Document_Gen.contains(Constants.B1DOcID)){
                    DocsList.add(Constants.B1_HL);
                }
                
            }
            else if(DocType=='LAPMOD'){
                if(!Document_Gen.contains(Constants.B1DOcGene) && !Document_Gen.contains(Constants.B1DOcID)){
                    DocsList.add(Constants.LAP_B1);
                }
            }
            
            System.debug('DocsList:-'+DocsList);
            if(DocsList.size()>0){
                if(!Utility.ISStringBlankorNull(App.Branch_Code__c))
                    BranchState=[select id,CODCCBRN__c,State__c from Branch_Master__c where CODCCBRN__c=:App.Branch_Code__c limit 1].state__c;
                string AccToken=WS_ApiGatewayAccToken.getAccTkn();
                if(AccToken!=null){
                    if(!Utility.ISStringBlankorNull(BranchState)){
                        DMS_Structure.EStampResponse EStamp = new DMS_Structure.EStampResponse();
                        for(string s:DocsList){
                            if(s!=''){
                                System.debug('doc name>>'+s);
                                //WS_eStampDocGen.EstampDocGenResp EStamp = new WS_eStampDocGen.EstampDocGenResp();
                                if(App.Record_Type_Name__c == constants.LAPLOAN){
                                    for(clcommon__Collateral__c clList : colllist){
                                        EStamp =  WS_eStampDocGen.createDocnew(App,clList,ownershp,s,AccToken,BranchState);
                                        //docNameCountMap.put(s,EStamp.PageCount);
                                    }
                                }else{
                                    system.debug('App:-'+App+'  s:-'+s+'  AccToken:-'+AccToken+' BranchState:-'+BranchState);
                                    EStamp =  WS_eStampDocGen.createDoc(App,s,AccToken,BranchState);
                                }
                                mapofUuidByFileName.put(EStamp.result.uuid,s);
                            }
                            if(s==Constants.A23_HL){
                                if(Document_Gen!=null){
                                    
                                    Document_Gen= Document_Gen + ';' + Constants.A23DocGen; //+';'+Constants.A23Class2 + ';' + Constants.A23DocID
                                }
                                else{
                                    Document_Gen=Constants.A23DocGen; //+';'+Constants.A23Class2 + ';' + Constants.A23DocID
                                }
                            }
                            else if(s==Constants.LAP_A23){
                                if(Document_Gen!=null){
                                    
                                    Document_Gen= Document_Gen + ';' + Constants.A23DocGen; //+';'+Constants.A23Class2 + ';' + Constants.A23DocID
                                }
                                else{
                                    Document_Gen=Constants.A23DocGen; //+';'+Constants.A23Class2 + ';' + Constants.A23DocID
                                }
                            }
                            
                            else if(s==Constants.A46_HL){
                                if(Document_Gen!=null){
                                    
                                    Document_Gen= Document_Gen + ';' + Constants.A46DocGene; //+';'+Constants.A46Class2sign + ';' + Constants.A46DocID
                                }
                                else{
                                    Document_Gen=Constants.A46DocGene; //+';'+Constants.A46Class2sign + ';' + Constants.A46DocID
                                }
                            }
                            else if(s==Constants.LAP_A46){
                                if(Document_Gen!=null){
                                    
                                    Document_Gen= Document_Gen + ';' + Constants.A46DocGene; //+';'+Constants.A46Class2sign + ';' + Constants.A46DocID
                                }
                                else{
                                    Document_Gen=Constants.A46DocGene; //+';'+Constants.A46Class2sign + ';' + Constants.A46DocID
                                }
                            }
                            
                            else if(s==Constants.B17_HL){
                                if(Document_Gen!=null){
                                    
                                    Document_Gen= Document_Gen + ';' + Constants.B17DocGen; //+';'+Constants.B17DocID 
                                }
                                else{
                                    Document_Gen=Constants.B17DocGen; //+';'+Constants.B17DocID
                                }
                            }
                            
                            else if(s==Constants.B1_HL){
                                if(Document_Gen!=null){
                                    
                                    Document_Gen= Document_Gen + ';' + Constants.B1DOcGene; //+';'+Constants.B1DOcID 
                                }
                                else{
                                    Document_Gen=Constants.B1DOcGene; //+';'+Constants.B1DOcID
                                }
                            }
                            else if(s==Constants.LAP_B1){
                                
                                if(Document_Gen!=null){
                                    
                                    Document_Gen= Document_Gen + ';' + Constants.B1DOcGene; //+';'+Constants.B1DOcID 
                                    
                                }
                                
                                else{
                                    Document_Gen=Constants.B1DOcGene; //+';'+Constants.B1DOcID
                                    
                                }
                            }
                        }
                        //system.debug('EStamp.Content:-'+EStamp.Content);
                        for(Integer st: mapofUuidByFileName.KeySet()){
                            String sm = mapofUuidByFileName.get(st);
                            if(EStamp.result.uuid!=null){
                                KVB_Company_Details__c company = KVB_Company_Details__c.getOrgDefaults();
                                //EStamp.Content  = EStamp.Content != '' ? EStamp.Content : EncodingUtil.base64Encode(Digioe_Docs_Service.getAttachmentBody(AppID,s+'.pdf'));
                                
                                //Calling the Class-2 service
                                
                                if(sm==Constants.A23_HL || sm==Constants.A46_HL || sm==Constants.LAP_A46 || sm==Constants.LAP_A23){
                                    ss = Digioe_Docs_Service.class2Signer(new Digioe_Docs_Service.DocSignerRequest(SYSTEM.LABEL.DigioKeyPersonName,sm,company.City__c,String.valueOf(EStamp.result.uuid)),EStamp.result.pageCount ,sm);
                                }
                                else{
                                    ss  = String.valueOf(EStamp.result.uuid);
                                }
                                mapofUuidByclass2File.put(EStamp.result.uuid,ss);
                            }
                            if(sm==Constants.A23_HL){
                                if(Document_Gen!=null){
                                    
                                    Document_Gen= Document_Gen + ';' + Constants.A23Class2; //+';'+Constants.A23Class2 + ';' + Constants.A23DocID
                                }
                                else{
                                    Document_Gen=Constants.A23Class2; //+';'+Constants.A23Class2 + ';' + Constants.A23DocID
                                }
                            }
                            else if(sm==Constants.LAP_A23){
                                if(Document_Gen!=null){
                                    
                                    Document_Gen= Document_Gen + ';' + Constants.A23Class2; //+';'+Constants.A23Class2 + ';' + Constants.A23DocID
                                }
                                else{
                                    Document_Gen=Constants.A23Class2; //+';'+Constants.A23Class2 + ';' + Constants.A23DocID
                                }
                            }
                            
                            else if(sm==Constants.A46_HL){
                                if(Document_Gen!=null){
                                    
                                    Document_Gen= Document_Gen + ';' + Constants.A46Class2sign; //+';'+Constants.A46Class2sign + ';' + Constants.A46DocID
                                }
                                else{
                                    Document_Gen=Constants.A46Class2sign; //+';'+Constants.A46Class2sign + ';' + Constants.A46DocID
                                }
                            }
                            else if(sm==Constants.LAP_A46){
                                if(Document_Gen!=null){
                                    
                                    Document_Gen= Document_Gen + ';' + Constants.A46Class2sign; //+';'+Constants.A46Class2sign + ';' + Constants.A46DocID
                                }
                                else{
                                    Document_Gen=Constants.A46Class2sign; //+';'+Constants.A46Class2sign + ';' + Constants.A46DocID
                                }
                            }
                            
                        }
                        //    for(string Sss:DocsList){
                        for(Integer Sss:mapofUuidByclass2File.KeySet()){
                            String sFile = mapofUuidByclass2File.get(Sss);
                            if(ss!=null && ss!=''){
                                Docid=DigioDocID_EsignHL.DocumentIDGeneration(AppID, sFile, EStamp.result.pageCount,ss);
                                
                                if(Docid!=null && (!String.isBlank(Docid))){
                                    DocCOntent.put(sFile, ss);
                                    DocIds.put(sFile, Docid);
                                    
                                    if(sFile==Constants.A23_HL){
                                        if(Document_Gen!=null){
                                            
                                            Document_Gen= Document_Gen + ';' +  Constants.A23DocID;
                                        }
                                        else{
                                            Document_Gen= Constants.A23DocID;
                                        }
                                    }
                                    else if(sFile==Constants.LAP_A23){
                                        if(Document_Gen!=null){
                                            
                                            Document_Gen= Document_Gen + ';' + Constants.A23DocID;
                                        }
                                        else{
                                            Document_Gen= Constants.A23DocID;
                                        }
                                    }
                                    
                                    else if(sFile==Constants.A46_HL){
                                        if(Document_Gen!=null){
                                            
                                            Document_Gen= Document_Gen + ';' + Constants.A46DocID;
                                        }
                                        else{
                                            Document_Gen=Constants.A46DocID;
                                        }
                                    }
                                    else if(sFile==Constants.LAP_A46){
                                        if(Document_Gen!=null){
                                            
                                            Document_Gen= Document_Gen + ';' +Constants.A46DocID;
                                        }
                                        else{
                                            Document_Gen=Constants.A46DocID;
                                        }
                                    }
                                    
                                    else if(sFile==Constants.B17_HL){
                                        if(Document_Gen!=null){
                                            
                                            Document_Gen= Document_Gen + ';' +Constants.B17DocID ;
                                        }
                                        else{
                                            Document_Gen=Constants.B17DocID;
                                        }
                                    }
                                    
                                    else if(sFile==Constants.B1_HL){
                                        if(Document_Gen!=null){
                                            
                                            Document_Gen= Document_Gen + ';' +Constants.B1DOcID ;
                                        }
                                        else{
                                            Document_Gen=Constants.B1DOcID;
                                        }
                                    }
                                    else if(sFile==Constants.LAP_B1){
                                        
                                        if(Document_Gen!=null){
                                            
                                            Document_Gen= Document_Gen + ';' +Constants.B1DOcID ;
                                            
                                        }
                                        
                                        else{
                                            Document_Gen=Constants.B1DOcID;
                                            
                                        }
                                    }
                                }
                            }
                        }
                        
                        
                        List<Digio_Document_ID__c> ListDOcIDS=new list<Digio_Document_ID__c>();
                        //List<Attachment> UpdateAtt = new List<Attachment>();
                        //List<Attachment> attList = new List<Attachment>();
                        List<String> docListToDelete = new List<String>();
                        set<string> docNameSet = new set<string>();
                        for(string Docs:DocCOntent.keySet()){
                            //Attachment att = new Attachment();
                            if(DocCOntent.get(Docs)!=null){
                                //v1.1(start)
                                
                                if(DocIds.get(Docs)!=null){
                                    Digio_Document_ID__c Did=new Digio_Document_ID__c();
                                    if(Docs.contains(Constants.LAP_B1)){
                                        Did.Name=Docs+Utility.getBlankStringIfNull(collName);
                                        Did.Application__c=AppID;
                                        Did.Document_ID__c=DocIds.get(Docs);
                                        Did.DMS_UUID__c = DocCOntent.get(Docs);
                                        ListDOcIDS.add(Did);
                                        docNameSet.add(Docs+Utility.getBlankStringIfNull(collName));
                                    } else {
                                        Did.Name=Docs;
                                        Did.Application__c=AppID;
                                        Did.Document_ID__c=DocIds.get(Docs);
                                        Did.DMS_UUID__c = DocCOntent.get(Docs);
                                        ListDOcIDS.add(Did);
                                        docNameSet.add(Docs);
                                    }
                                }
                                List<genesis__Application_Document_Category__c> GAdc=[select id from genesis__Application_Document_Category__c where name=:Constants.LoanDocuments And  genesis__Application__c=:AppID limit 1];
                                List<genesis__AppDocCatAttachmentJunction__c> GaList=new  List<genesis__AppDocCatAttachmentJunction__c>();
                                
                                genesis__AppDocCatAttachmentJunction__c AtJunction=new genesis__AppDocCatAttachmentJunction__c();
                                AtJunction.genesis__Application_Document_Category__c=GAdc[0].id;
                                //AtJunction.genesis__AttachmentId__c=a.id;
                                AtJunction.Dms_Uuid__c = DocCOntent.get(Docs);
                                GaList.add(AtJunction);
                                
                                if(GaList.size()>0){
                                    insert GaList;
                                }
                                //v1.1(end)
                            }
                        }
                        //if(UpdateAtt.size()>0){
                        //upsert   UpdateAtt;
                        App.Document_Generation__c=Document_Gen;
                        //v1.2(start)
                        if (App.Sub_Type__c == Constants.Sub_Type_Top_Up && App.genesis__Collaterals__r.size() > 0 && ((App.Sub_Stage__c == Constants.LOAN_SANCTIONED_NON_STP_SUBSTAGE || App.Sub_Stage__c == Constants.LOAN_SANCTIONED_STP_SUBSTAGE) && App.genesis__Collaterals__r[0].Approved_Additional_Charge__c == 0) || (App.Sub_Stage__c == Constants.InitaiteMOD && App.genesis__Collaterals__r[0].Approved_Additional_Charge__c > 0) && App.Loan_Purpose__c == Constants.RepairHouse) {
                            String docGen = App.Document_Generation__c;
                            System.debug('docGen:::'+docGen);
                            if(docGen != null && docGen != ''){
                                Integer docCount = 0;
                                if (docGen.contains(Constants.C1docGen)) {
                                    docCount++;
                                }
                                if (docGen.contains(Constants.A23DocGen)) {
                                    docCount++;
                                }
                                if (docGen.contains(Constants.A46DocGene)) {
                                    docCount++;
                                }
                                if (docGen.contains(Constants.B17DocGen)) {
                                    docCount++;
                                }
                                Integer HlDocsCount = Call_BRE_HL.DocumnetsCount(App);
                                System.debug('docCount:::'+docCount);
                                System.debug('HlDocsCount:::'+HlDocsCount);
                                if (docCount == (HlDocsCount - 1)) {
                                    App.Sub_Stage__c = Constants.Sub_Stage_DisbuApprov;
                                }
                            }
                        }
                        //v1.2(end)
                        update App;
                        
                        if(ListDOcIDS.size()>0){
                            //v1.1(start)
                            List<Digio_Document_ID__c> DigiolistToDel=[select id,Application__c,Document_ID__c from Digio_Document_ID__c where Name Like :docNameSet and Application__c =:AppID];
                            System.debug('DigiolistToDel @***'+DigiolistToDel);
                            //v1.1(end)
                            if(DigiolistToDel.size()>0){
                                DELETE DigiolistToDel;
                            }
                            database.insert(ListDOcIDS,false);
                            List<Document_Applicant__c> DOCAppList=new List<Document_Applicant__c>();
                            map<id,id> AppDocID;
                            Map<id,id> OriginalAppDoc=new map<id,id>();
                            for(Digio_Document_ID__c d:ListDOcIDS){
                                AppDocID =new map<id,id>();
                                if(d.Document_ID__c!=null && (!String.isBlank(d.Document_ID__c)) ){
                                    
                                    //@@@  A23 && B17
                                    if(d.Name==Constants.A23_HL ||d.Name==Constants.B17_HL || d.Name==Constants.LAP_A23){
                                        AppDocID.put(App.genesis__Account__r.id,d.id);
                                        integer count=0;
                                        for(genesis__Application_Parties__c Apart:App.genesis__Application_Parties__r){
                                            if(Apart.genesis__Party_Type__c ==Constants.Co_Borrower){
                                                if(count<=2){
                                                    count++;
                                                    AppDocID.put(Apart.genesis__Party_Account_Name__r.id,d.id);
                                                }
                                            }
                                        }
                                    }
                                    
                                    //@@@  A46
                                    else  if(d.Name==Constants.A46_HL || d.Name==Constants.LAP_A46){
                                        integer count=0;
                                        for(genesis__Application_Parties__c Apart:App.genesis__Application_Parties__r){
                                            if(Apart.genesis__Party_Type__c ==Constants.Gurantor){
                                                if(count<=9){
                                                    count++;
                                                    //if(AppDocID.c )
                                                    AppDocID.put(Apart.genesis__Party_Account_Name__r.id,d.id);
                                                }
                                            }
                                        }
                                    }
                                    
                                    //@@@  HL B1 
                                    else  if(d.Name==Constants.B1_HL ){
                                       // AppDocID.put(App.genesis__Account__r.id,d.id);
                                        integer count=0;
                                        for(genesis__Application_Parties__c Apart:App.genesis__Application_Parties__r){
                                            if(Apart.Title_Holder__c){
                                                if(count<=12){
                                                    count++;
                                                    AppDocID.put(Apart.genesis__Party_Account_Name__r.id,d.id);
                                                }
                                            }
                                        }
                                    }
                                    
                                    //v1.1(start)
                                    //@@@ LAP B1
                                    else  if(d.Name==Constants.LAP_B1+Utility.getBlankStringIfNull(collName)){
                                        AppDocID.put(mapCollToOwner.get(collName),d.id);
                                    }
                                    //v1.1(end)
                                    
                                    for(string s:AppDocID.keySet()){
                                        if(AppDocID.containsKey(s)){
                                            Document_Applicant__c DocApp=new Document_Applicant__c();
                                            DocApp.Account__c=s;
                                            DocApp.Digio_Document_ID__c=AppDocID.get(s);
                                            DOCAppList.add(DocApp);
                                        }
                                    }
                                }
                            }
                            if(DOCAppList.size()>0){
                                insert DOCAppList;
                            }
                        }
                        //}
                        
                        if(DocCOntent.size() == DocsList.size()){
                            System.debug('Document Generated');
                            return 'Document Generated';
                        }else{
                            System.debug('Document Generation Failed');
                            return 'Document Generation Failed';
                        }
                        
                    }
                    else{
                        return 'Document Generation Failed - Branch State Not Avvailable';
                    }
                    
                }
                else{
                    return 'APIGEE Failed';
                }
            }
            else{
                return 'Document Generation Failed';
            }
        }
        catch(exception e){
            System.debug('Doc generation error**Line number'+e.getLineNumber()+'MESSAGE:-'+e.getMessage()+'Stack Trace:-'+e.getStackTraceString());
            HandleBusinessException.captureError('DigioDocGenerationHL','CallDocuments', e);
            return 'Document Generation Failed';
        }
    }
}