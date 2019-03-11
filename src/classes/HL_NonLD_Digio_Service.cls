/*
* Name    		: HL_NonLD_Digio_Service
* purpose 		: Call Digio service to get non legal desk document
* Author   		: Braj
* Created Date 	: 19-Oct-2018
-----------------------------------------------------------------------
Version     Date            Author          Remarks                                                 
=======     ==========      =============   ==================================
v1.1        15-Feb-2018     Braj            Appln at substage Loan Sanctioned NSTP/MOD Initiated will to go Disbursement Approved only if all the Top Up documents are generated
*******************************************************************************************/
global class HL_NonLD_Digio_Service {
    Webservice static String CallDocs(String appId,string Filename){
        docGenAndSignDoc(appId,Filename);
        return 'Document generated';
    }
    @future(callout=true)
    public static void docGenAndSignDoc(String appId ,String Filename){
        System.debug('appId>>> '+appId+'  ;Filename>>> '+Filename);
        try{
            set<string> DocsList = new set<string>();
            set<String> docNameSetExt = new set<String>();
            Map<String,String> mapDocContent = new Map<String,String>();
            Map<String,String> mapofUuidfl = new Map<String,String>();
            Map<String,String> mapoffileVal = new Map<String,String>();
            String DOC_UUID ='';
            String docEncodeFile = '';
            Integer pageCount = 0;
            string Class2Doc='';
            string FF='';
            string BranchState='';
            String Document_Gen = '';
            String templateId = '';

            genesis__Applications__c appln = [Select id,Sub_Type__c,Sub_Stage__c,Loan_Purpose__c,genesis__Account__c,Day_Of_Disbursal__c,Legal_desk_state_flag__c,Document_Generation__c,(select id,genesis__Party_Account_Name__c,genesis__Party_Type__c,genesis__Party_Account_Name__r.id from genesis__Application_Parties__r where Active__c=true AND genesis__Party_Account_Name__r.PersonEmail != null AND genesis__Party_Account_Name__r.PersonMobilePhone != null),(Select id,Approved_Additional_Charge__c,Valuation_Applicable__c from genesis__Collaterals__r limit 1) from genesis__Applications__c where Id =: appId];//v1.1


            Document_Gen = appln.Document_Generation__c != null ? appln.Document_Generation__c : 'None';
            
            if(Filename==Constants.HL_DIGIO_MANUAL_C1C11){
                system.debug('appln.Legal_desk_state_flag__c:-'+appln.Legal_desk_state_flag__c);
                 if(appln.Legal_desk_state_flag__c == false){
                    if(!Document_Gen.contains(Constants.C1docGen)){
                        DocsList.add(Filename);
                        System.debug('DocsList==HL_DIGIO_MANUAL_C1C11:-'+DocsList);
                    }
                }
            }

            else if (Filename == Constants.DISBURSE) {
                if(!Document_Gen.contains(Constants.A23DocGen)){
                    DocsList.add(Constants.HL_DIGIO_MANUAL_A23);
                    System.debug('DocsList==HL_DIGIO_MANUAL_A23:-'+DocsList);
                }

                if((appln.Loan_Purpose__c==Constants.IdentifiedProperty  || appln.Loan_Purpose__c==Constants.ConstructionOn) && !Document_Gen.contains(Constants.B17DocGen)){
                    DocsList.add(Constants.HL_DIGIO_MANUAL_B17);
                    System.debug('DocsList==HL_DIGIO_MANUAL_B17:-'+DocsList);
                }

                for(genesis__Application_Parties__c Apart:appln.genesis__Application_Parties__r){
                    if(Apart.genesis__Party_Type__c == Constants.Gurantor &&  !Document_Gen.contains(Constants.A46DocGene)){
                        DocsList.add(Constants.HL_DIGIO_MANUAL_A46);
                        System.debug('DocsList==HL_DIGIO_MANUAL_A46:-'+DocsList);   
                    }
                }
            }

            else if (Filename == Constants.MOD) {
                if(!Document_Gen.contains(Constants.B1DOcGene)){
                    DocsList.add(Constants.HL_DIGIO_MANUAL_B1B2);
                    System.debug('DocsList==HL_DIGIO_MANUAL_B1B2:-'+DocsList);
                }
            }
            System.debug('DocsList>>>'+DocsList);
            for(String docName: DocsList) {
                System.debug('inside docName for loop=='+docName);
                System.debug('Document_Gen=='+Document_Gen);
                FF=docName;
                if(FF != ''){
                    class2Doc='';
                    System.debug('Document Name FF >>> '+FF);
                    templateId = Utility.getDIGIOTemplateId(FF); 
                    System.debug('templateId== '+templateId);

                    //Calling the document DIGIO generation service
                    DMS_Structure.DocumentUploadRes docResp= Digioe_Docs_Service.getEDocs(appId,FF,templateId);
                    DOC_UUID = docResp.uuid;
                    pageCount   = Integer.valueOf(docResp.totalPages);
                    System.debug('DOC_UUID:::'+DOC_UUID);
                    System.debug('pageCount:::'+pageCount);

                    if(appln.Legal_desk_state_flag__c == false){
                    	class2Doc = DOC_UUID;
                    }

                    if(class2Doc != '' && class2Doc !=null){
                        mapDocContent.put(FF, class2Doc);
                        docNameSetExt.add(FF+'.pdf');
                    } else {
                        System.debug('##### class2Doc doc getting null ---------------> ');
                        appln.Docgen_Fail__c = TRUE;
                        continue;
                    }

                    System.debug('class2Doc length == '+class2Doc.length());
                    if (class2Doc != '' && class2Doc != null) {
                        if(FF==Constants.HL_DIGIO_MANUAL_A23){
                            Document_Gen= Document_Gen + ';' + Constants.A23DocGen+ ';' +Constants.A23Class2 +';'+Constants.A23DocID;
                            System.debug('##### HL_DIGIO_MANUAL_A23***Document_Gen >>> '+ Document_Gen);
                        }
                        else if(FF==Constants.HL_DIGIO_MANUAL_A46){
                            Document_Gen= Document_Gen + ';' + Constants.A46DocGene+ ';' +Constants.A46Class2sign +';'+Constants.A46DocID;
                            System.debug('##### HL_DIGIO_MANUAL_A46***Document_Gen >>> '+ Document_Gen);
                        }
                        else if(FF==Constants.HL_DIGIO_MANUAL_B17){
                            Document_Gen= Document_Gen + ';' + Constants.B17DocGen+';'+Constants.B17DocID;
                            System.debug('##### HL_DIGIO_MANUAL_B17***Document_Gen >>> '+ Document_Gen);
                        }
                        else if(FF==Constants.HL_DIGIO_MANUAL_B1B2){
                            Document_Gen= Document_Gen + ';' + Constants.B1DOcGene+';'+Constants.B1DOcID;
                            System.debug('##### HL_DIGIO_MANUAL_B1B2***Document_Gen >>> '+ Document_Gen);
                        }
                        else if(FF==Constants.HL_DIGIO_MANUAL_C1C11){
                            Document_Gen= Document_Gen + ';' + Constants.C1docGen+ ';' +Constants.C1class2Sign +';'+Constants.C1DocID;
                            System.debug('##### HL_DIGIO_MANUAL_C1C11***Document_Gen >>> '+ Document_Gen);
                        }
                    }
                }else{
                    System.debug('Document Name Not Found**FF>>> '+FF);
                }
            }

            //Generated document Segregation logic
            List<Digio_Document_ID__c> ListDocIDS=new list<Digio_Document_ID__c>();
            //List<Attachment> UpdateAtt = new List<Attachment>();
            //Map<String,Attachment> mapNameToAttchment= new Map<String,Attachment>();
            System.debug('docNameSetExt>>>'+docNameSetExt);
            if(!mapDocContent.isEmpty() && mapDocContent.size()>0){
            	/*List<Attachment> attList = [Select Id,Body,ParentId,Name from Attachment where ParentId=:appId AND Name IN:docNameSetExt];
            	System.debug(attList.size()+'<<<attList>>>'+attList);
            	for(Attachment attch: attList) {
            		mapNameToAttchment.put(attch.Name.removeEnd('.pdf'),attch);
            	}*/
                for(string Docs:mapDocContent.keySet()){
                    Attachment att = new Attachment();
                    /*if(mapNameToAttchment.containsKey(Docs)){
                    	System.debug('##### attachments to update>>> ');
                        att = mapNameToAttchment.get(Docs);
                        att.Body = EncodingUtil.base64Decode(mapDocContent.get(Docs));
                        UpdateAtt.add(att);
                    }else{
                        System.debug('##### attachments to insert>>> ');
                        att.Name = Docs+'.pdf';
                        att.ParentId = appId;
                        att.Body = EncodingUtil.base64Decode(mapDocContent.get(Docs));
                        UpdateAtt.add(att);
                    }*/
                    System.debug('att=='+att);
                    Digio_Document_ID__c Did=new Digio_Document_ID__c();
                    Did.Name=Docs;
                    Did.Application__c=AppID;
                    Did.DMS_UUID__c = mapDocContent.get(Docs);
                    ListDocIDS.add(Did);
                }
                
                //System.debug(UpdateAtt.size()+'<--UpdateAtt==>'+UpdateAtt);
                System.debug(ListDocIDS.size()+'<--ListDocIDS==>'+ListDocIDS);
                
                //Segregated document Insertion logic
                //if(UpdateAtt.size()>0){
                    //upsert UpdateAtt;
                    //Map<Id,Attachment> mapAttach = new Map<Id,Attachment>(UpdateAtt);
                    appln.Document_Generation__c=Document_Gen;
                    //v1.1(start)
                    if (appln.Sub_Type__c == Constants.Sub_Type_Top_Up && appln.genesis__Collaterals__r.size() > 0 && ((appln.Sub_Stage__c == Constants.LOAN_SANCTIONED_NON_STP_SUBSTAGE || appln.Sub_Stage__c == Constants.LOAN_SANCTIONED_STP_SUBSTAGE) && appln.genesis__Collaterals__r[0].Approved_Additional_Charge__c == 0) || (appln.Sub_Stage__c == Constants.InitaiteMOD && appln.genesis__Collaterals__r[0].Approved_Additional_Charge__c > 0) && appln.Loan_Purpose__c == Constants.RepairHouse) {
                        String docGen = appln.Document_Generation__c;
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
                            Integer HlDocsCount = Call_BRE_HL.DocumnetsCount(appln);
                            System.debug('docCount:::'+docCount);
                            System.debug('HlDocsCount:::'+HlDocsCount);
                            if (docCount == (HlDocsCount - 1)) {
                                appln.Sub_Stage__c = Constants.Sub_Stage_DisbuApprov;
                            }
                        }
                    }
                    //v1.1(end)
                    appln.Sanction_Doc_Generation_Check__c = TRUE;
                    update appln;
                    List<genesis__Application_Document_Category__c> GAdc=[select id from genesis__Application_Document_Category__c where name=:Constants.LoanDocuments And  genesis__Application__c=:AppID limit 1];
                    /*List<genesis__AppDocCatAttachmentJunction__c> GaList=new  List<genesis__AppDocCatAttachmentJunction__c>();
                    for(Attachment a:UpdateAtt){
                        genesis__AppDocCatAttachmentJunction__c AtJunction=new genesis__AppDocCatAttachmentJunction__c();
                        AtJunction.genesis__Application_Document_Category__c=GAdc[0].id;
                        AtJunction.genesis__AttachmentId__c=a.id;
                        AtJunction.Document_Name__c = a.Name;
                        GaList.add(AtJunction);
                    }
                    List<genesis__AppDocCatAttachmentJunction__c> GaListOld=[select id,genesis__AttachmentId__c from genesis__AppDocCatAttachmentJunction__c where genesis__AttachmentId__c IN:mapAttach.keySet() and    genesis__Application_Document_Category__c=:GAdc[0].id and Document_Name__c IN:docNameSetExt];
                    System.debug('@#$@#$***GaListOld >>> '+GaListOld);
                    if(!GaListOld.isEmpty()){
                        DELETE GaListOld;
                    }
                    if(GaList.size()>0){
                        insert GaList;
                    }
                    System.debug(GaList.size()+'<--GaList==>'+GaList);*/
                    
                //}
                
                //Digio_Document_ID__c record deletion/insertion and generated digio record id is added into set for Document_Applicant__c
                set<id> AppDocIDSet=new set<id>();
                List<Digio_Document_ID__c> Dlist=[select id,Application__c,Document_ID__c from Digio_Document_ID__c where Name IN :mapDocContent.keySet() and Application__c =:appId];
                System.debug('@#Digio_Document_ID__c#@***'+Dlist);
                if(Dlist.size()>0){
                    DELETE Dlist;
                }
                if(ListDocIDS.size()>0){
                    database.insert(ListDocIDS,false);
                    for(Digio_Document_ID__c ddi:ListDocIDS){
                        AppDocIDSet.add(ddi.id);
                    }
                }
                System.debug(AppDocIDSet.size()+'<--AppDocIDSet==>'+AppDocIDSet);
                
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
                if(DOCAppList.size()>0){
                    insert DOCAppList;
                }
                System.debug(DOCAppList.size()+'<--DOCAppList==>'+DOCAppList);
               	System.debug('Document Generated Successfully**');
            }else{
                System.debug('No Document Generated**');
            } 
        }catch(exception e){
            System.debug('Error HL_NonLD_Digio_Service>>> '+e.getLineNumber()+e.getStackTraceString());
            HandleBusinessException.captureError('HL_NonLD_Digio_Service','docGenAndSignDoc', e);       
        }
    }
}