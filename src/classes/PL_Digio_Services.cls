/*-----------------------------------------------------------------------
   Version  Date         Author             Remarks                                                 
  =======   ==========   =============  ==================================
   v1.1    30-Nov-2018    Braj          Commented after agreement letter is getting generated twice
   v1.2    04-Dec-2018    Braj          Class functionality made dynamic
*******************************************************************************************/
global class PL_Digio_Services {
    webService static String genAllPLDoc(String appId,String Filename){
        docGenAndSignDocPL(appId,Filename);
        return 'Document generated';
    }   
    
    //v1.2(start)
    @future (callout=true)
    public static void docGenAndSignDocPL(String appId ,String Filename){
        System.debug('appId>>> '+appId+'  ;Filename>>> '+Filename);
        try{ 
            set<string> DocsList=new set<string>();
            Map<String,String> mapDocContent=New Map<String,String>();
            Map<String,String> mapDocIds=New Map<String,String>();
            Map<String,String> mapofUuidbyFF = new Map<String,String>();
            Map<String,String> mapofUuidbyF = new Map<String,String>();

            String DOC_UUID  = '';
            String Class2_UUID  = '';
            Integer pageCount       = 0;
            string class2Doc='';
            string FF='';
            string Docid='';
            string BranchState='';
            String Document_Gen = '';
            String templateId = '';
            Integer count = 0;
            KVB_Company_Details__c company = KVB_Company_Details__c.getOrgDefaults();
            DMS_Structure.EStampResponse EStamp = new DMS_Structure.EStampResponse();
            
            genesis__Applications__c appln = [select id,Advance_Payment_Made_If_Any__c,Legal_desk_state_flag__c,Diff_B_w_ROI_MCLR__c,Branch_Code__c,genesis__Account__r.Full_Name__c,Sanctioned_EMI__c,Sanctioned_Tenure__c,Branch_State__c,FPIIntRepayInstal__c,FPIPrincRepayInstal__c,Record_Type_Name__c,Docgen_Fail__c
            ,genesis__Account__c,Document_Generation__c,genesis__Expected_Close_Date__c,genesis__Expected_First_Payment_Date__c,Preclosure_Charges__c,Rating_Frequency__c,
                                              MCLR_Rate__c,Excess_MCLR__c,genesis__Interest_Calculation_Method__c,Loan_Purpose__c,Holiday_Period__c,Sanction_Doc_Generation_Check__c,
                                              genesis__Amortization_Term__c,Sanction_Amount_Words__c,Sanction_Authority_Limit__c,genesis__Term__c,genesis__Interest_Rate__c,genesis__Loan_Amount__c,Sanction_Date__c,Sanction_Reference_Number__c,
                                              Xerox_Reason1__c,Xerox_Reason2__c,Xerox_Doc_Table__c,MOD_Date__c,MOD_Branch__c,Property_City__c,Name_Of_The_Socity__c,Primary_Applicant__c,
                                              Disbursal_Financial_Year__c,genesis__Disbursement_Date__c,MCLR_Type__c,Month_Of_Disbursal__c,Day_Of_Disbursal__c,Sub_Stage__c,Name,genesis__Account__r.Name,
                                              genesis__Account__r.PersonMobilePhone,Processing_Fee__c,PreClosure_Interest_Rate__c,genesis__Account__r.CIBIL_Score__c,Branch_Name__c,genesis__CL_Product_Name__c,Name_Of_The_Builder__c,
                                              genesis__Account__r.Father_Husband_Daughter_Name__c,genesis__Account__r.PersonOtherStreet,genesis__Account__r.Age__c,
                                             Interest_Variation__c,Date_Of_Sale_Agreement__c,Nature_Of_Property__c,Survey_No_Katha_No_Other_No_s__c,Flat_No__c,
                                              Floor_No__c,Stage_Sector_Ward_Block_No__c,Street_Name__c,Taluka_Tehsil__c,Property_District__c,Property_State__c,Property_Pincode__c,
                                              genesis__Account__r.PersonMailingStreet,genesis__Account__r.PersonMailingCity,genesis__Account__r.PersonMailingState,
                                              genesis__Account__r.PersonMailingPostalCode,genesis__Account__r.PersonMailingCountry,Penal_Interest__c,(Select id,Name,genesis__Party_Account_Name__c,genesis__Party_Type__c from genesis__Application_Parties__r where genesis__Party_Type__c =: Constants.PRIMARY_APP AND Active__c = true)
                                              from genesis__Applications__c where ID =:appId];

            List<genesis__AppDocCatAttachmentJunction__c> LoanDocs =[Select id,Dms_Uuid__c,Document_Name__c from genesis__AppDocCatAttachmentJunction__c Where genesis__Application_Document_Category__r.name=:Constants.LoanDocuments And  genesis__Application_Document_Category__r.genesis__Application__c=:appId limit 1];
            for(genesis__AppDocCatAttachmentJunction__c abc : LoanDocs){
                mapofUuidbyFF.put(abc.Dms_Uuid__c,abc.Document_Name__c);
            }
            if(appln.Legal_desk_state_flag__c==true)
            {
                if(Filename==Constants.PRE_APPROVE_SANCTION_PL){
                    DocsList.add(Constants.PRE_APPROVE_SANCTION_PL);
                    DocsList.add(Constants.PL_AGREEMENT_DOC);
                }
            }
            else{
                if(Filename==Constants.PRE_APPROVE_SANCTION_PL){
                    DocsList.add(Constants.PRE_APPROVE_SANCTION_PL_NLD);
                    DocsList.add(Constants.PL_loan_Agreement_Letter);
                } 
            }

            System.debug('DocsList:-'+DocsList);
            try {
                for(String docName: DocsList) {
                    System.debug('inside docName for loop=='+docName);
                    Document_Gen = appln.Document_Generation__c != null ? appln.Document_Generation__c : 'None';
                    System.debug('Document_Gen=='+Document_Gen);
                    FF='';
                    if(appln.Legal_desk_state_flag__c==true)
                    {
                        if(Filename==Constants.PRE_APPROVE_SANCTION_PL){
                            if(!Document_Gen.contains(Constants.PL1_DOCGEN)){
                                FF=Filename;
                            }else if(!Document_Gen.contains(Constants.PL2_DOCGEN)){
                                FF = Constants.PL_AGREEMENT_DOC;
                            }
                        }
                    }
                    else{
                        if(Filename==Constants.PRE_APPROVE_SANCTION_PL){
                            if(!Document_Gen.contains(Constants.PL1_DOCGEN)){
                                FF=Constants.PRE_APPROVE_SANCTION_PL_NLD;
                            }else if(!Document_Gen.contains(Constants.PL2_DOCGEN)){
                                FF = Constants.PL_loan_Agreement_Letter;
                            }
                        }
                    }

                    System.debug('##Each document### FF==> '+ FF);
                    if (FF!='') {
                        Class2_UUID='';
                        templateId = Utility.getDIGIOTemplateId(FF); 
                        System.debug('templateId'+templateId);

                        //Calling the document DIGIO generation service
                        if(FF==Constants.PRE_APPROVE_SANCTION_PL || FF == Constants.PRE_APPROVE_SANCTION_PL_NLD || FF==Constants.PL_loan_Agreement_Letter){
                            DMS_Structure.DocumentUploadRes docResp= Digioe_Docs_Service.getEDocs(appId,FF,templateId);
                            DOC_UUID = docResp.uuid;
                            pageCount   = Integer.valueOf(docResp.totalPages);
                            System.debug('DOC_UUID size>>'+DOC_UUID +' pageCount '+pageCount);
                            if(DOC_UUID == '' || DOC_UUID == null){
                                appln.Docgen_Fail__c = TRUE;
                                continue;
                            }else{
                                mapDocContent.put(FF, DOC_UUID);
                                Document_Gen = FF!=Constants.PL_loan_Agreement_Letter ? Constants.PL1_DOCGEN : Constants.PL2_DOCGEN ;
                            }
                        }
                        
                        System.debug('company>>>'+company);

                        // PL Loan Agreement start here... 
                        if(FF == Constants.PL_AGREEMENT_DOC){
                            string AccToken=WS_ApiGatewayAccToken.getAccTkn(); 
                            System.debug('##### AccToken '+ AccToken);

                            if(!Utility.ISStringBlankorNull(appln.Branch_Code__c))
                            BranchState = Utility.getStateFromBranchCode(String.ValueOf(appln.Branch_Code__c));
                            System.debug('##### BranchState '+ BranchState);
                            
                            if(!Utility.ISStringBlankorNull(BranchState) && AccToken!=null){
                                System.debug('Calling legal desk..WS_eStampDocGen');        
                                
                                EStamp =  WS_eStampDocGen.createDocnew(appln,null,null,FF,AccToken,BranchState);
                                if(EStamp!=null && EStamp.status!=null && EStamp.status == 'success' && EStamp.result.uuid != null){
                                    pageCount = EStamp.result.pageCount;
                                    //EStamp.Content  = EStamp.Content != '' ? EStamp.Content : EncodingUtil.base64Encode(Digioe_Docs_Service.getAttachmentBody(appId,FF+'.pdf'));
                                    //Calling the Class-2 service for E stamp Agreement
                                    DOC_UUID = String.valueOf(EStamp.result.uuid);
                                    mapDocContent.put(FF, DOC_UUID);
                                    Class2_UUID = Digioe_Docs_Service.class2Signer(new Digioe_Docs_Service.DocSignerRequest(System.LABEL.DigioKeyPersonName,FF,company.City__c,DOC_UUID),EStamp.result.pageCount ,FF);
                                }else{
                                    appln.Docgen_Fail__c = TRUE;
                                    continue;
                                }
                            }
                        }
                        mapofUuidbyFF.put(DOC_UUID,FF);
                    }
                        // PL Agreement end here till class 2 signer done.
                    for(String Sf : mapofUuidbyFF.KeySet()){
                        String Fs = mapofUuidbyFF.get(Sf);
                        if(Fs==Constants.PRE_APPROVE_SANCTION_PL || Fs==Constants.PL_loan_Agreement_Letter ||Fs==Constants.PRE_APPROVE_SANCTION_PL_NLD){
                            if(appln.Legal_desk_state_flag__c == false){
                                Class2_UUID = Sf;
                                System.debug('####class 2 size()::::'+ Class2_UUID.length());
                            }else{
                                //Calling the Class-2 service
                                Class2_UUID = Digioe_Docs_Service.class2Signer(new Digioe_Docs_Service.DocSignerRequest(System.LABEL.DigioKeyPersonName,Fs,company.City__c,DOC_UUID),pageCount,Fs); 
                            } 
                        }

                        if(Class2_UUID != ''){
                            mapDocContent.put(Fs, Class2_UUID);
                        } else {
                            System.debug('##### class2Doc doc getting null ---------------> ');
                            appln.Docgen_Fail__c = TRUE;
                            continue;
                        }
                     DOC_UUID = String.valueOf(EStamp.result.uuid);
                     mapofUuidbyF.put(DOC_UUID,Fs);
             	   }
                    for(String files : mapofUuidbyF.KeySet()){
                        String FilesVal = mapofUuidbyF.get(files);
                        System.debug('Entering into doc id generation..');
                        if(FilesVal==Constants.PRE_APPROVE_SANCTION_PL || FilesVal == Constants.PL_AGREEMENT_DOC || FilesVal==Constants.PL_loan_Agreement_Letter ||FilesVal==Constants.PRE_APPROVE_SANCTION_PL_NLD){
                            if(appln.Legal_desk_state_flag__c==true)
                            {
                                System.debug('Inside doc id generation..');
                                Docid=DigioDocID_EsignPL.DocumentIDGeneration(appId, FilesVal, pageCount,Class2_UUID);
                                System.debug('##### doc idss--0-------------> '+ Docid);
                                if(Docid!=null) {
                                    mapDocIds.put(FilesVal, Docid);
                                }
                                if(Docid!=null && (!String.isBlank(Docid))){
                                    if(FilesVal==Constants.PRE_APPROVE_SANCTION_PL){
                                        System.debug('##### doc idss--1-------------> '+ Docid);
                                        Document_Gen= Document_Gen +';'+Constants.PL1_DOCID; //+ ';' + Constants.PL1_DOCGEN+';'+Constants.PL1_CLASS2 
                                        appln.genesis__Disbursement_Date__c = System.today();
                                    }
                                    if(FilesVal == Constants.PL_AGREEMENT_DOC){
                                        System.debug('##### doc idss--2-------------> '+ Docid);
                                        Document_Gen= Document_Gen + Constants.PL2_DOCID; //';' + Constants.PL2_DOCGEN+';'+Constants.PL2_CLASS2 +';'+
                                        appln.Sanction_Doc_Generation_Check__c  = TRUE;
                                        appln.genesis__Disbursement_Date__c = System.today();
                                        appln.Sanction_Date__c = System.today();
                                    }
                                }else{
                                    appln.Docgen_Fail__c = TRUE;
                                    throw new CustomException(FilesVal+'  Borrower Signner Failed');
                                }
                            }else{
                                if(FilesVal==Constants.PRE_APPROVE_SANCTION_PL_NLD){
                                    System.debug('#####NLD doc idss 1---------------> '+ Docid);
                                    Document_Gen= Document_Gen  +';'+Constants.PL1_DOCID; //+ ';' + Constants.PL1_DOCGEN+';'+Constants.PL1_CLASS2
                                    appln.genesis__Disbursement_Date__c = System.today();
                                }
                                if(FilesVal == Constants.PL_loan_Agreement_Letter){
                                    System.debug('#####NLD doc idss 2---------------> '+ Docid);
                                    Document_Gen= Document_Gen  +';'+Constants.PL2_DOCID; //+ ';' + Constants.PL2_DOCGEN+';'+Constants.PL2_CLASS2
                                    appln.Sanction_Doc_Generation_Check__c  = TRUE;
                                    appln.genesis__Disbursement_Date__c = System.today();
                                    appln.Sanction_Date__c = System.today();
                                }
                            }
                        }
                        if(Document_Gen!=null){
                            System.debug('Document_Gen>>>'+Document_Gen);
                            appln.Document_Generation__c=Document_Gen;
                            count++;
                        }
                    }
                }
                
            } catch(Exception e) {
                System.debug('##Document Exceptions ### --- > '+ e.getMessage() + ' ' +e.getLineNumber() +'get stake trace'+e.getStackTraceString());
            }

            //Generated document Segregation logic
            List<Digio_Document_ID__c> ListDocIDS=new list<Digio_Document_ID__c>();
            List<String> docListToDelete    = new List<String>();
            if(!mapDocContent.isEmpty() && mapDocContent.size()>0){
                List<genesis__Application_Document_Category__c> GAdc=[select id from genesis__Application_Document_Category__c where name=:Constants.LoanDocuments And  genesis__Application__c=:appId limit 1];
                List<genesis__AppDocCatAttachmentJunction__c> GaList=new  List<genesis__AppDocCatAttachmentJunction__c>();
                    
                for(string Docs:mapDocContent.keySet()){
                    if(mapDocContent.get(Docs)!=null){
                        
                        Digio_Document_ID__c Did=new Digio_Document_ID__c();
                        Did.Name=Docs;
                        Did.Application__c=appId;
                        Did.Document_ID__c=mapDocIds.containsKey(Docs)?mapDocIds.get(Docs):'';
                        Did.DMS_UUID__c = DOC_UUID;
                        ListDocIDS.add(Did);

                        genesis__AppDocCatAttachmentJunction__c AtJunction=new genesis__AppDocCatAttachmentJunction__c();
                        AtJunction.genesis__Application_Document_Category__c=GAdc[0].id;
                        AtJunction.Dms_Uuid__c = mapDocContent.get(Docs);
                        AtJunction.Document_Name__c =Docs;
                        GaList.add(AtJunction);
                    
                        if(GaList.size()>0){
                            insert GaList;
                        }
                    }
                }


                List<Digio_Document_ID__c> DlistToDel=[select id,Application__c,Document_ID__c from Digio_Document_ID__c where Name IN :mapDocContent.keySet() and Application__c =:appId];
                //System.debug('DlistToDel size***'+DlistToDel.size());
                if(DlistToDel.size()>0){
                    DELETE DlistToDel;
                }

                set<id> AppDocIDSet=new set<id>();
                if(ListDocIDS.size()>0){
                    database.insert(ListDocIDS,false);
                    for(Digio_Document_ID__c ddi:ListDocIDS){
                        AppDocIDSet.add(ddi.id);
                    }
                }
                //System.debug(AppDocIDSet.size()+'<--AppDocIDSet==>'+AppDocIDSet);
                
                //Insertion of Document_Applicant__c record used for document checklist in Api call
                List<Document_Applicant__c> DOCAppList=new List<Document_Applicant__c>();
                for(string ddi:AppDocIDSet){
                    for(genesis__Application_Parties__c party: appln.genesis__Application_Parties__r) {
                        Document_Applicant__c DocApp=new Document_Applicant__c();
                        DocApp.Account__c=party.genesis__Party_Account_Name__c;
                        DocApp.Digio_Document_ID__c=ddi;
                        DOCAppList.add(DocApp);
                    }
                }
                //System.debug(DOCAppList.size()+'<--DOCAppList==>'+DOCAppList); 
                if(DOCAppList.size()>0){
                    insert DOCAppList;
                }

                appln.Document_Generation__c=Document_Gen;
                ApplicationTriggerHandler.IsFirstRun = False;
                update appln;
                
                //System.debug(DOCAppList.size()+'<--DOCAppList==>'+DOCAppList);
            }
            
            if(count > 0 && mapDocContent.size() == count){
                System.debug('Document Generated**');
            }else if(count==0){
                System.debug('No Document Generated!!');             
            }else{
                System.debug('Document Generation Failed**');             
            }
        }catch(exception e){
            System.debug('Doc generation error '+e.getLineNumber()+e.getMessage());
            HandleBusinessException.captureError('PL_Digio_Services','docGenAndSignDocPL', e);       
        }
    }
    //v1.2(end)
}