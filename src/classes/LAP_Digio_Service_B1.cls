global class LAP_Digio_Service_B1 {
    public Static clcommon__Collateral__c collValue;
    Webservice static String callB1Docs(String appId){
        database.executeBatch(new Batch_eStamp_B1_DocGeneration(appId),1);
        return 'Document generated';
    }
    public static void digioDocGen(String appId ,String Filename,List<clcommon__Collateral__c> colList){
        System.debug('appId>>> '+appId+'  ;Filename>>> '+Filename+'  ;colList>>> '+colList);
        try{
            String DOC_UUID  = '';
            String docEncodeFile  = '';
            Integer pageCount       = 0;
            string Class2Doc='';
            string FF='';
            string Docid='';
            genesis__Applications__c appln = [Select id,genesis__Account__c,Day_Of_Disbursal__c,Legal_desk_state_flag__c,Document_Generation__c,(select id,genesis__Party_Account_Name__c,genesis__Party_Type__c,genesis__Party_Account_Name__r.id from genesis__Application_Parties__r where Active__c=true AND genesis__Party_Account_Name__r.PersonEmail != null AND genesis__Party_Account_Name__r.PersonMobilePhone != null) from genesis__Applications__c where Id =: appId];
            
            
            String Document_Gen = appln.Document_Generation__c != null ? appln.Document_Generation__c : 'None';
            if(colList.size() > 0 && Document_Gen.contains(Constants.B1DOcGene)){
                Document_Gen = Document_Gen.remove(Constants.B1DOcGene);
                Document_Gen = Document_Gen.remove(Constants.B1DOcID);
            }
            
            if(Filename==Constants.LAP_B1_B2DOC){
                if(!Document_Gen.contains(Constants.B1DOcGene) && appln.Legal_desk_state_flag__c == false)
                    FF=Filename;
            }

            if (FF!='') {
                System.debug('FF doc name>>>'+FF);
                string templateId = Utility.getDIGIOTemplateId(FF); 
                System.debug('templateId'+templateId);

                //Calling the document DIGIO generation service
                for(clcommon__Collateral__c c : colList){
                    collValue = c;
                    DMS_Structure.DocumentUploadRes  docResp= Digioe_Docs_Service.getEDocs(appId,FF,templateId);
                    DOC_UUID = docResp.uuid;
                    pageCount = Integer.valueOf(docResp.totalPages);
                }
                System.debug('DOC_UUID size>>'+DOC_UUID +' pageCount '+pageCount);
                    

                if(docEncodeFile == '' || docEncodeFile == null){
                    System.debug('##### class2Doc doc getting null ---------------> ');
                    appln.Docgen_Fail__c = TRUE;
                    throw new CustomException(FF+'##### class2Doc doc getting null ---------------> ');
                }

                KVB_Company_Details__c company = KVB_Company_Details__c.getOrgDefaults();
                
                System.debug('class2Doc'+class2Doc);
                //List<Attachment> attList = new List<Attachment>();
                //Attachment att = new Attachment();
                String LapDocName = FF+Utility.getBlankStringIfNull(collValue.Name);
                /*attList = [Select Id,Body,ParentId,Name from Attachment where ParentId=:appId AND Name like :LapDocName+'%' limit 1];
                if(!attList.isEmpty()){
                    att = attList[0];
                    att.Body = EncodingUtil.base64Decode(docEncodeFile);
                    update att;
                }else{
                    //added by prashant singh------_Manual--on 26/10/2018.
                    att.Name = LapDocName+'_Manual.pdf';
                    att.ParentId = appId;
                    att.Body = EncodingUtil.base64Decode(docEncodeFile);
                    insert att;
                }
                */
                if(FF==Constants.LAP_B1_B2DOC){
                    Document_Gen= Document_Gen + ';' + Constants.B1DOcGene + ';' + Constants.B1DOcID;
                }
                appln.Document_Generation__c=Document_Gen;
                //update appln;
                /*List<genesis__Application_Document_Category__c> GAdc=[select id from genesis__Application_Document_Category__c where name=:Constants.LoanDocuments And  genesis__Application__c=:AppID limit 1];
                System.debug('@#$@#$'+GAdc);
                List<genesis__AppDocCatAttachmentJunction__c> GaList=[select id,genesis__AttachmentId__c from genesis__AppDocCatAttachmentJunction__c where genesis__AttachmentId__c=:att.id and    genesis__Application_Document_Category__c=:GAdc[0].id and Document_Name__c=:LapDocName+'.pdf' limit 1];
                System.debug('@#$@#$'+GaList);
                
                if(GaList.isEmpty()){
                    genesis__AppDocCatAttachmentJunction__c AAJ=new genesis__AppDocCatAttachmentJunction__c();
                    AAJ.genesis__Application_Document_Category__c=GAdc[0].id;
                    AAJ.genesis__AttachmentId__c=att.id;
                    AAJ.Document_Name__c =LapDocName;
                    AAJ.Dms_Uuid__c = DOC_UUID;
                    insert AAJ;
                }*/
                if(FF==Constants.LAP_B1_B2DOC){
                    List<Digio_Document_ID__c> Dlist=[select id,Application__c,Document_ID__c from Digio_Document_ID__c where Name Like:LapDocName and Application__c =:appId];
                    System.debug('@#Digio list size'+Dlist.size());
                    Digio_Document_ID__c Did=new Digio_Document_ID__c();
                    Did.Name=LapDocName;
                    Did.Application__c=appId;
                    Did.DMS_UUID__c = DOC_UUID;
                    Did.Document_ID__c=appln.Legal_desk_state_flag__c == true?Docid:'';
                    if(Dlist.size()>0){
                        DELETE Dlist  ; 
                    }
                    insert Did;
                    //System.debug('*********'+Did);
                    set<id> AcciDs=new set<Id>();
                    AcciDs.add(appln.genesis__Account__c) ;
                    integer pcount=0;
                    integer count=0;
					//System.debug('appln.genesis__Application_Parties__r:'+appln.genesis__Application_Parties__r);
                    for(genesis__Application_Parties__c Apart:appln.genesis__Application_Parties__r){
                        if(Apart.genesis__Party_Type__c ==Constants.Co_Borrower){
                            if(count<=2){
                                count++;
                                AcciDs.add(Apart.genesis__Party_Account_Name__r.id);
                            }
                        }
                        else if(Apart.genesis__Party_Type__c ==Constants.Gurantor){
                            if(pcount<=9){
                                pcount++;
                                AcciDs.add(Apart.genesis__Party_Account_Name__r.id);
                            }
                        }
                    }
                    if(AcciDs.size()>0){
                        List<Document_Applicant__c> DocApp=new List<Document_Applicant__c>();
                        for(string s:AcciDs){
                            Document_Applicant__c DApp=new Document_Applicant__c();
                            DApp.Account__c=s;
                            DApp.Digio_Document_ID__c=Did.Id;
                            DocApp.add(DApp);
                        }
                        insert DocApp;
                    }
                    ApplicationTriggerHandler.IsFirstRun = False;
                    update appln;
                    System.debug('Document generated successfully!!');
                }
            } else {
                System.debug('No document to generate!!');
            }
            
        }catch(exception e){
            System.debug('Doc generation error '+e.getLineNumber()+e.getMessage());
            HandleBusinessException.captureError('LAP_Digio_Service_B1','digioDocGen', e); 
        }
    }
    
}