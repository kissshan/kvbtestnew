/*
* Name    : VL_Digio_Services
* Company : ET Marlabs
* Purpose : Class used for document generation and insert. #VL717
* Author  : Ashok
-----------------------------------------------------------------------
Version  Date            Author             Remarks                                                 
=======   ===========     =============  ==================================
v1.1    27-Aug-2018     Braj           'VLPaymentAcknoLetter' generation stage changed from SI details to button in skuid page
*******************************************************************************************/

global class VL_Digio_Services {
    webService static String genAllVLDoc(String appId ,String Filename){
        docGenAndSignDocVL(appId,Filename);
        return 'Document generated';
    }
    
    @future (callout=true)
    public static void docGenAndSignDocVL(String appId ,String Filename){
        System.debug('appId=='+appId+' Filename=='+Filename);
           Map<String,String> mapDocContent=New Map<String,String>();
           set<string> DocsList=new set<string>();
            //Map<String,String> mapDocContent=New Map<String,String>();
            Map<String,String> mapDocIds=New Map<String,String>();
            List<String> partyTypeList = new List<String>{Constants.PRIMARY_APP,Constants.Co_Borrower};
            Map<String,String> mapofUidFile = new Map<String,String>();
            Map<String,String> mapofDocIdFile = new Map<String,String>();
        
                   
            String  DOC_UUID = '';    
            String docEncodeFile  = '';
            Integer pageCount       = 0;
            string class2Doc='';
            string FF='';
            string Docid='';
            string BranchState='';
            String Document_Gen = '';
            String templateId = '';
            Integer count = 0;
        
            DMS_Structure.EStampResponse EStamp = new DMS_Structure.EStampResponse();
            KVB_Company_Details__c company = KVB_Company_Details__c.getOrgDefaults();
            System.debug('company>>>'+company);
            genesis__Applications__c appln = new genesis__Applications__c();
            try{
               appln = [select id,Advance_Payment_Made_If_Any__c,Legal_desk_state_flag__c,Created_Date__c,Diff_B_w_ROI_MCLR__c,Branch_Code__c,genesis__Account__r.Full_Name__c,Sanctioned_EMI__c,Sanctioned_Tenure__c,Branch_State__c,
                                              FPIIntRepayInstal__c,FPIPrincRepayInstal__c,Record_Type_Name__c,Docgen_Fail__c,genesis__Account__c,Document_Generation__c,genesis__Expected_Close_Date__c,
                                              genesis__Expected_First_Payment_Date__c,Preclosure_Charges__c,Rating_Frequency__c,MCLR_Rate__c,Excess_MCLR__c,genesis__Interest_Calculation_Method__c,Loan_Purpose__c,Holiday_Period__c,
                                              genesis__Amortization_Term__c,Sanction_Amount_Words__c,Sanction_Authority_Limit__c,genesis__Term__c,genesis__Interest_Rate__c,genesis__Loan_Amount__c,Sanction_Date__c,Sanction_Reference_Number__c,
                                              Xerox_Reason1__c,Xerox_Reason2__c,Xerox_Doc_Table__c,MOD_Date__c,MOD_Branch__c,Primary_Applicant__c,Sanction_Doc_Generation_Check__c,
                                              Disbursal_Financial_Year__c,genesis__Disbursement_Date__c,MCLR_Type__c,Month_Of_Disbursal__c,Day_Of_Disbursal__c,Sub_Stage__c,Name,genesis__Account__r.Name,
                                              genesis__Account__r.PersonMobilePhone,Processing_Fee__c,PreClosure_Interest_Rate__c,genesis__Account__r.CIBIL_Score__c,Branch_Name__c,genesis__CL_Product_Name__c,
                                              genesis__Account__r.Father_Husband_Daughter_Name__c,genesis__Account__r.PersonOtherStreet,genesis__Account__r.PersonOtherPostalCode,genesis__Account__r.PersonOtherState,genesis__Account__r.Age__c,genesis__Account__r.PersonOtherCity,
                                              Interest_Variation__c,Date_Of_Sale_Agreement__c,
                                              genesis__Account__r.PersonMailingStreet,genesis__Account__r.PersonMailingCity,genesis__Account__r.PersonMailingState,
                                              genesis__Account__r.PersonMailingPostalCode,genesis__Account__r.PersonMailingCountry,Penal_Interest__c,genesis__Account__r.Father_Name__pc,genesis__Margin__c,(Select id,Name,genesis__Party_Account_Name__c,genesis__Party_Type__c from genesis__Application_Parties__r where genesis__Party_Type__c IN : partyTypeList AND Active__c = true),
                                              (select id,Total_Vehicle_Value__c,Dealer_name__c,Final_vehicle_value__c,clcommon__Year__c,Dealer_Pincode__c,Dealer_Email__c,clcommon__Address__c,clcommon__Manufacturer__c,clcommon__Model__c,Variant__c,Proforma_Invoice_Date__c,Proforma_Invoice_No__c,Vehicle_CalculatedValue__c from genesis__Collaterals__r LIMIT 1)
                                              from genesis__Applications__c where ID =:appId];
            
                if(appln.Legal_desk_state_flag__c == true) {
                    if(Filename==Constants.VLSANCTIONLETTER) {
                        DocsList.add(Constants.VLSANCTIONLETTER);
                        DocsList.add(Constants.VLDEALERPYMNTAUTH);
                        DocsList.add(Constants.VLHYPOTHECATIONLD);
                        //VLPaymentAcknoLetterDocsList.add(Constants.VLDEALERACK);
                    } else if(Filename==Constants.VLDEALERACK){
                        DocsList.add(Constants.VLDEALERACK);
                        DocsList.add(Constants.VLCover);
                    }
                }
                else{
                    if(Filename==Constants.VLSANCTIONLETTER) {
                        DocsList.add(Constants.VLSANCTIONLETTER_NLD);
                        DocsList.add(Constants.VLDEALERPYMNTAUTH_NLD);
                        DocsList.add(Constants.VLHYPOTHECATION);
                    } else if(Filename==Constants.VLDEALERACK){
                        DocsList.add(Constants.VLDEALERACK);
                        DocsList.add(Constants.VLCover);
                    }
                }
                system.debug('DocsList:-'+DocsList);
                for(String docName: DocsList){
                    System.debug('inside docName for loop=='+docName);
                    Document_Gen = appln.Document_Generation__c != null ? appln.Document_Generation__c : 'None';
                    System.debug('Document_Gen=='+Document_Gen);
                    FF='';
                    if(appln.Legal_desk_state_flag__c==true)
                    {
                        if(Filename==Constants.VLSANCTIONLETTER){
                            if(!Document_Gen.contains(Constants.VL1_DOCGEN)){
                                FF=Filename;
                            }else if(!Document_Gen.contains(Constants.VL2_DOCGEN)){
                                FF = Constants.VLDEALERPYMNTAUTH;
                            }else if(!Document_Gen.contains(Constants.VL4_DOCGEN) && appln.Legal_desk_state_flag__c == True){
                                FF = Constants.VLHYPOTHECATIONLD;
                            }
                        } else if(Filename==Constants.VLDEALERACK){//v1.1(start)
                            if(!Document_Gen.contains(Constants.VL3_DOCGEN)){
                                FF = Constants.VLDEALERACK;
                            }
                           else if(!Document_Gen.contains(Constants.VL6_DOCGEN)){
                                FF = Constants.VLCover;
                            }
                        }
                    }
                    else{
                        if(Filename==Constants.VLSANCTIONLETTER){
                            if(!Document_Gen.contains(Constants.VL1_DOCGEN)){
                                FF=Constants.VLSANCTIONLETTER_NLD;
                                system.debug('hh'+FF);
                            }else if(!Document_Gen.contains(Constants.VL2_DOCGEN)){
                                FF = Constants.VLDEALERPYMNTAUTH_NLD;
                            }
                            else if(!Document_Gen.contains(Constants.VL4_DOCGEN) ){
                                FF = Constants.VLHYPOTHECATION;
                            }
                        }
                        else if(Filename==Constants.VLDEALERACK){//v1.1(start)
                            if(!Document_Gen.contains(Constants.VL3_DOCGEN)){
                                FF = Constants.VLDEALERACK;
                            }
                          else  if(!Document_Gen.contains(Constants.VL6_DOCGEN)){
                                FF = Constants.VLCover;
                            }
                        }
                    }
                    
                    System.debug('##DataLog### FF==> '+ FF);
                    if(FF != ''){
                        class2Doc='';
                        templateId = Utility.getDIGIOTemplateId(FF); 
                        System.debug('templateId=='+templateId);
                        if(FF==Constants.VLSANCTIONLETTER  || FF==Constants.VLDEALERPYMNTAUTH || FF==Constants.VLDEALERACK || FF==Constants.VLHYPOTHECATION || FF==Constants.VLSANCTIONLETTER_NLD || FF==Constants.VLDEALERPYMNTAUTH_NLD || FF==Constants.VLCover){
                            System.debug('## Document Name ### --- > '+ FF);
                            DMS_Structure.DocumentUploadRes docResp= Digioe_Docs_Service.getEDocs(appId,FF,templateId);
                            DOC_UUID = docResp.uuid;
                            pageCount   = Integer.valueOf(docResp.totalPages);
                            if(DOC_UUID == '' || DOC_UUID == null){
                                appln.Docgen_Fail__c = TRUE;
                                continue;
                            }else{
                                mapDocContent.put(FF, DOC_UUID);
                            }
                        }
                        
                    }
                    mapofUidFile.put(DOC_UUID,docName);
                }
                     
                for(String UidsRec : mapofUidFile.KeySet()){
                 String fName = mapofUidFile.get(UidsRec);
                       
                        if(fName == Constants.VLHYPOTHECATIONLD){
                            String AccToken=WS_ApiGatewayAccToken.getAccTkn(); 
               		       if(!Utility.ISStringBlankorNull(appln.Branch_Code__c))
                                BranchState = Utility.getStateFromBranchCode(String.ValueOf(appln.Branch_Code__c));
                            if(!Utility.ISStringBlankorNull(BranchState) && AccToken!=null){
                                System.debug('##### State=='+ BranchState);
                                EStamp =  WS_eStampDocGen.createDocnew(appln,null,null,FF,AccToken,BranchState);
                                if(EStamp!=null && EStamp.status != null && EStamp.status == 'success' && EStamp.result.uuid != null){
                                    pageCount = EStamp.result.pageCount;
                                    DOC_UUID = String.valueOf(EStamp.result.uuid);
                                    mapDocContent.put(fName, DOC_UUID);
                                    class2Doc = Digioe_Docs_Service.class2Signer(new Digioe_Docs_Service.DocSignerRequest(System.LABEL.DigioKeyPersonName,FF,company.City__c,DOC_UUID),pageCount ,FF);
                                }else{
                                    appln.Docgen_Fail__c = TRUE;
                                    continue;
                                }
                            }
                        }
                     
                        if(fName==Constants.VLSANCTIONLETTER || fName==Constants.VLSANCTIONLETTER_NLD  || fName==Constants.VLHYPOTHECATION ){
                            if(appln.Legal_desk_state_flag__c == false){
                                class2Doc = DOC_UUID;
                                System.debug('#### Legal Desk False ::::');
                            }else{
                                class2Doc = Digioe_Docs_Service.class2Signer(new Digioe_Docs_Service.DocSignerRequest(System.LABEL.DigioKeyPersonName,fName,company.City__c,DOC_UUID),pageCount,fName); 
                            }
                            
                        }
                        if(fName==Constants.VLDEALERPYMNTAUTH||fName==Constants.VLDEALERPYMNTAUTH_NLD || fName==Constants.VLDEALERACK || fName==Constants.VLCover){
                            class2Doc = DOC_UUID;
                            System.debug('#### Payment Authentication and Ack Letter::::');
                            
                        }
                        
                        if(class2Doc != ''){
                            mapDocContent.put(fName, class2Doc);
                        } else {
                            System.debug('##### class2Doc doc getting null ---------------> ');
                            appln.Docgen_Fail__c = TRUE;
                            continue;
                        }
                    mapofDocIdFile.put(class2Doc,fName);
                }
                for(String fSign : mapofDocIdFile.KeySet()){
                    String RecVal = mapofDocIdFile.get(fSign);
                        if(FF==Constants.VLSANCTIONLETTER || FF == Constants.VLHYPOTHECATIONLD  || FF==Constants.VLDEALERPYMNTAUTH || FF==Constants.VLDEALERACK|| FF==Constants.VLHYPOTHECATION|| FF==Constants.VLDEALERPYMNTAUTH_NLD|| FF==Constants.VLSANCTIONLETTER_NLD || FF==Constants.VLCover){
                            if(appln.Legal_desk_state_flag__c == true && (FF!=Constants.VLDEALERACK && FF!=Constants.VLCover)){
                                Docid=DigioDocID_EsignHL.DocumentIDGeneration(appId, FF, pageCount,class2Doc);
                                System.debug('##### doc idss--0-------------> '+ Docid);
                                if(Docid!=null) {
                                    mapDocIds.put(FF, Docid);
                                }
                                if(Docid!=null && (!String.isBlank(Docid))){
                                    if(Document_Gen!=null && FF==Constants.VLSANCTIONLETTER){
                                        System.debug('#####Legal Desk doc idss--1---------------> '+ Docid);
                                        Document_Gen= Document_Gen + ';' + Constants.VL1_DOCGEN+';'+Constants.VL1_C2SIGN +';'+Constants.VL1_DOCID;
                                    }
                                    if(Document_Gen!=null && FF == Constants.VLDEALERPYMNTAUTH){
                                        System.debug('#####Legal Desk doc idss--2-------------> '+ Docid);
                                        Document_Gen= Document_Gen + ';' + Constants.VL2_DOCGEN+';'+Constants.VL2_C2SIGN +';'+Constants.VL2_DOCID;
                                        //appln.genesis__Disbursement_Date__c = System.today();
                                    }
                                    if(Document_Gen!=null && FF == Constants.VLHYPOTHECATIONLD){
                                        System.debug('#####Legal Desk doc idss--3-------------> '+ Docid);
                                        Document_Gen= Document_Gen + ';'+Constants.VL4_DOCGEN+';'+Constants.VL4_C2SIGN +';'+Constants.VL4_DOCID;
                                        appln.Sanction_Doc_Generation_Check__c  = TRUE;
                                        appln.genesis__Disbursement_Date__c = System.today();
                                        appln.Sanction_Date__c = System.today();
                                    }
                                }else{
                                    appln.Docgen_Fail__c = TRUE;
                                    throw new CustomException(FF+'  Borrower Signner Failed');
                                } 
                            }else{
                                if(Document_Gen!=null && FF == Constants.VLSANCTIONLETTER_NLD){
                                    System.debug('#####Non Legal Desk doc idss--1-------------> '+ Docid);
                                    Document_Gen= Document_Gen + ';'+Constants.VL1_DOCGEN+';'+Constants.VL1_C2SIGN +';'+Constants.VL1_DOCID;
                                }
                                if(Document_Gen!=null && FF == Constants.VLDEALERPYMNTAUTH_NLD){
                                    System.debug('##### doc idss--2-------------> '+ Docid);
                                    Document_Gen= Document_Gen + ';'+Constants.VL2_DOCGEN+';'+Constants.VL2_C2SIGN +';'+Constants.VL2_DOCID;
                                }
                                if(Document_Gen!=null && FF == Constants.VLDEALERACK){
                                    System.debug('##### doc idss--3-------------> '+ Docid);
                                    Document_Gen= Document_Gen + ';'+Constants.VL3_DOCGEN+';'+Constants.VL3_C2SIGN +';'+Constants.VL3_DOCID;
                                    appln.Sanction_Doc_Generation_Check__c  = TRUE;
                                    //appln.genesis__Disbursement_Date__c = System.today();
                                }
                                //prashant singh VLHYPOTHECATION_NLD
                                if(Document_Gen!=null && FF == Constants.VLHYPOTHECATION){
                                    System.debug('##### doc idss--4-------------> '+ Docid);
                                    Document_Gen= Document_Gen + ';'+Constants.VL4_DOCGEN+';'+Constants.VL4_C2SIGN +';'+Constants.VL4_DOCID;
                                    appln.Sanction_Doc_Generation_Check__c  = TRUE;
                                    appln.genesis__Disbursement_Date__c = System.today();
                                    appln.Sanction_Date__c = System.today();
                                }
                                if(Document_Gen!=null && FF == Constants.VLCover){
                                    System.debug('##### doc idss--3-------------> '+ Docid);
                                    Document_Gen= Document_Gen + ';'+Constants.VL6_DOCGEN+';'+Constants.VL6_C2SIGN +';'+Constants.VL6_DOCID;
                                    appln.Sanction_Doc_Generation_Check__c  = TRUE;
                                    //appln.genesis__Disbursement_Date__c = System.today();
                                }
                            }
                        }
                        if(Document_Gen!=null){
                            System.debug('Document_Gen>>>'+Document_Gen);
                            appln.Document_Generation__c=Document_Gen;
                            count++;
                        }
                    }
            List<Digio_Document_ID__c> ListDocIDS=new list<Digio_Document_ID__c>();
            List<String> docListToDelete    = new List<String>();
            if(!mapDocContent.isEmpty() && mapDocContent.size()>0){
                List<genesis__Application_Document_Category__c> GAdc=[select id from genesis__Application_Document_Category__c where name=:Constants.LoanDocuments And  genesis__Application__c=:AppID limit 1];
                List<genesis__AppDocCatAttachmentJunction__c> GaList=new  List<genesis__AppDocCatAttachmentJunction__c>();
                    
                for(string Docs:mapDocContent.keySet()){
                        
                    if(mapDocContent.get(Docs)!=null){
                        Digio_Document_ID__c Did=new Digio_Document_ID__c();
                        Did.Name=Docs;
                        Did.Application__c=AppID;
                        Did.DMS_UUID__c = mapDocContent.get(Docs);
                        Did.Document_ID__c=mapDocIds.containsKey(Docs)?mapDocIds.get(Docs):'';
                        ListDocIDS.add(Did);

                        //App Doc category
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
                
                set<id> AppDocIDSet=new set<id>();
                List<Digio_Document_ID__c> DlistToDel=[select id,Application__c,Document_ID__c from Digio_Document_ID__c where Name IN :mapDocContent.keySet() and Application__c =:appId];
                System.debug('DlistToDel @***'+DlistToDel);
                if(DlistToDel.size()>0){
                    DELETE DlistToDel;
                }
                if(ListDocIDS.size()>0){
                    database.insert(ListDocIDS,false);
                    Map<id,id> OriginalAppDoc=new map<id,id>();
                    for(Digio_Document_ID__c ddi:ListDocIDS){
                        AppDocIDSet.add(ddi.id);
                    }
                }
                
                List<Document_Applicant__c> DOCAppList=new List<Document_Applicant__c>();
                for(string ddi:AppDocIDSet){
                    for(genesis__Application_Parties__c party: appln.genesis__Application_Parties__r) {
                        Document_Applicant__c DocApp=new Document_Applicant__c();
                        DocApp.Account__c=party.genesis__Party_Account_Name__c;
                        DocApp.Digio_Document_ID__c=ddi;
                        DOCAppList.add(DocApp);
                    }
                }
   
                if(DOCAppList.size()>0){
                    insert DOCAppList;
                }
                appln.Document_Generation__c=Document_Gen;
                ApplicationTriggerHandler.IsFirstRun = False;
                update appln;
                System.debug(DOCAppList.size()+'<--DOCAppList==>'+DOCAppList);            
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
            HandleBusinessException.captureError('VL_Digio_Services','docGenAndSignDocVL', e);         
        }
    }
}