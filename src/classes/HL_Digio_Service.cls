global class HL_Digio_Service {
    Webservice static String CallDocs(String appId,string Filename){
        docGenAndSignDoc(appId,Filename);
        return 'Document generated';
    }
    @future(callout=true)
    public static void docGenAndSignDoc(String appId ,String Filename){
        System.debug('appId>>> '+appId+'  ;Filename>>> '+Filename);
        try{
            String DOC_UUID  = ''; 
            String docEncodeFile = '';
            Integer pageCount = 0;
            string Class2Doc ='';
            string FF ='';
            string Docid ='';
            genesis__Applications__c appln = [Select id,Sub_Type__c,Sub_Stage__c,genesis__Account__c,Day_Of_Disbursal__c,Legal_desk_state_flag__c,Document_Generation__c,(select id,genesis__Party_Account_Name__c,genesis__Party_Type__c,genesis__Party_Account_Name__r.id from genesis__Application_Parties__r where Active__c=true AND genesis__Party_Account_Name__r.PersonEmail != null AND genesis__Party_Account_Name__r.PersonMobilePhone != null) from genesis__Applications__c where Id =: appId];
            
            String Document_Gen = appln.Document_Generation__c != null ? appln.Document_Generation__c : 'None';
            System.debug('+++::::'+Document_Gen);
            if(appln.Legal_desk_state_flag__c==true)
            {
                system.debug('?????::::'+appln.Legal_desk_state_flag__c+'****::::'+Filename);
                if(Filename==Constants.Acknowledgement_For_Sanction){
                    system.debug(':::---:::'+Filename);
                    if(!Document_Gen.contains(Constants.C1docGen) && !Document_Gen.contains(Constants.C1class2Sign)  && !Document_Gen.contains(Constants.C1DocID)){
                        system.debug(':::---:::'+Filename);
                        FF=Filename;
                    }
                }
                else if(Filename==Constants.Acknowledgement_For_SanctionLAP){
                    system.debug(':::---:::'+Filename);
                    if(!Document_Gen.contains(Constants.C1docGen) && !Document_Gen.contains(Constants.C1class2Sign)  && !Document_Gen.contains(Constants.C1DocID)){
                        system.debug(':::---:::'+Filename);
                        FF=Filename;
                    }
                }
                else if(Filename==Constants.PRE_Approval_Sanction_HL){
                    system.debug(':::---:::'+Filename);
                    if(!Document_Gen.contains(Constants.PreApproveGenerated) && !Document_Gen.contains(Constants.PreApproveClass2)){
                        system.debug(':::---:::'+Filename);
                        FF=Filename;
                    } else{
                        FF='';
                        System.debug('Pre Approval Document Generated.');
                    }
                }
            }
            //prashant singh on 25-10-2018---start
            else{
                System.debug('appln.Legal_desk_state_flag__c:::'+appln.Legal_desk_state_flag__c);
                if(Filename==Constants.Acknowledgement_For_Sanction) {
                    System.debug(':::Filename:::'+Filename);
                    if(!Document_Gen.contains(Constants.C1docGen) && !Document_Gen.contains(Constants.C1class2Sign)  && !Document_Gen.contains(Constants.C1DocID)){
                        FF=constants.HL_DIGIO_MANUAL_C1C11;
                        System.debug('kk:::'+FF);
                    }
                }
                else if(Filename==Constants.Acknowledgement_For_SanctionLAP){
                     System.debug(':::@@Filename@@:::'+Filename);
                    if(!Document_Gen.contains(Constants.C1docGen) && !Document_Gen.contains(Constants.C1class2Sign)  && !Document_Gen.contains(Constants.C1DocID)){
                        FF=constants.Acknowledgement_For_SanctionLAP_NLD;
                        System.debug('kk:::'+FF);
                    }
                }       
                else if(Filename==Constants.LAP_A23D_LAFA){
                    System.debug(':::@@Filename@@:::'+Filename);
                    if(!Document_Gen.contains(Constants.A23DocGen) && !Document_Gen.contains(Constants.A23Class2)  && !Document_Gen.contains(Constants.A23DocGen)){
                        FF=Filename;
                        System.debug('kk:::'+FF);
                    }
                    
                }
                else if(Filename==Constants.LAP_A46DOC){
                    System.debug(':::@@Filename@@:::'+Filename);
                    if(!Document_Gen.contains(Constants.A46DocGene) && !Document_Gen.contains(Constants.A46Class2sign)  && !Document_Gen.contains(Constants.A46DocID)){
                        FF=Filename;
                        System.debug('kk:::'+FF);
                    }
                    
                }
            }
            //prashant singh on 25-10-2018---end
            
            if (FF!=''){
                System.debug('FF doc name>>>'+FF);
                string templateId   = Utility.getDIGIOTemplateId(FF); 
                System.debug('templateId'+templateId);
                //Calling the document DIGIO generation service
         //       Digioe_Docs_Service.DocGenResponse docResp= Digioe_Docs_Service.getEDocs(appId,FF,templateId);
                //DMS change
                DMS_Structure.DocumentUploadRes docResp= Digioe_Docs_Service.getEDocs(appId,FF,templateId);
                DOC_UUID = docResp.uuid;
                pageCount   = Integer.valueOf(docResp.totalPages);
                System.debug('DOC_UUID size>>'+DOC_UUID +' pageCount '+pageCount);
                //DMS change end  

                if(DOC_UUID == '' || DOC_UUID == null){
                    System.debug('##### class2Doc doc getting null ---------------> ');
                    appln.Docgen_Fail__c = TRUE;
                    throw new CustomException(FF+'##### class2Doc doc getting null ---------------> ');
                }
                KVB_Company_Details__c company = KVB_Company_Details__c.getOrgDefaults();
                
                //Calling the Class-2 service
                if(appln.Legal_desk_state_flag__c == true){
                    System.debug('Call class2sign:::'+appln.Legal_desk_state_flag__c);
                    class2Doc = Digioe_Docs_Service.class2Signer(new Digioe_Docs_Service.DocSignerRequest(System.LABEL.DigioKeyPersonName,FF,company.City__c,DOC_UUID),pageCount,FF);
                }else{
                    class2Doc = DOC_UUID;
                }
                
                System.debug('call doc id generation::::'+class2Doc);
                if(appln.Legal_desk_state_flag__c == true){
                    System.debug('Call class2sign:::'+appln.Legal_desk_state_flag__c);
                    if(FF==Constants.Acknowledgement_For_Sanction || FF==Constants.Acknowledgement_For_SanctionLAP ){
                        System.debug('@@@@$$$$:::'+FF);
                        Docid=DigioDocID_EsignHL.DocumentIDGeneration(appId, FF, pageCount,class2Doc);
                        System.debug('$$$$:::'+Docid);
                        
                        if(Docid!=null && (!String.isBlank(Docid))){
                            Document_Gen= Document_Gen + ';' + Constants.C1docGen+';'+Constants.C1class2Sign +';'+Constants.C1DocID; 
                        }
                        else{
                            throw new CustomException(FF+'  Class-2 Sign Failed');
                        } 
                    }
                } 
                //Braj:HL non digio doc generation(start)
                else if (FF==Constants.Acknowledgement_For_Sanction || FF==constants.Acknowledgement_For_SanctionLAP_NLD ||FF==constants.HL_DIGIO_MANUAL_C1C11) {
                    System.debug('@@@@:::$$$$:::'+FF);
                    Document_Gen= Document_Gen + ';' + Constants.C1docGen+';'+Constants.C1class2Sign +';'+Constants.C1DocID;
                    System.debug('HL_Digio_Service #####***Document_Gen >>> '+ Document_Gen);
                }
                //Braj:HL non digio doc generation(end)
                
                List<Attachment> attList = new List<Attachment>();
                Attachment att = new Attachment();
                attList = [Select Id,Body,ParentId,Name from Attachment where ParentId=:appId AND Name=:FF+'.pdf' limit 1];
                System.debug('attList:::::::::::::::::::::::::::>'+attList);
                System.debug('attList:::::::::::::::::::::::::::>'+class2Doc);
                if(!attList.isEmpty()){
                    att = attList[0];
                    att.Body = EncodingUtil.base64Decode(class2Doc);
                    update att;
                }else{
                    
                    att.Name = FF+'.pdf';
                    att.ParentId = appId;
                    att.Body = EncodingUtil.base64Decode(class2Doc);
                   // insert att;
                }
                if(FF==Constants.PRE_Approval_Sanction_HL){
                    Document_Gen= Document_Gen + ';' + Constants.PreApproveGenerated+';'+Constants.PreApproveClass2 ;                
                }
                else if(FF==Constants.LAP_A23D_LAFA){
                    Document_Gen= Document_Gen + ';' + Constants.A23DocGen + ';' + Constants.A23Class2 + ';' + Constants.A23DocID;//Braj:A46DocGene tag also updating because it getting overrite because simultaneous execution of this class from disbusrement initiation page//Date:24-10-2018
                }
                else if(FF==Constants.LAP_A46DOC){
                    Document_Gen= Document_Gen + ';' + Constants.A46DocGene + ';' + Constants.A46Class2sign + ';' + Constants.A46DocID;//Braj:A23DocGen tag also updating because it getting overrite because simultaneous execution of this class from disbusrement initiation page//Date:24-10-2018
                }
                appln.Document_Generation__c=Document_Gen;
                //update appln;
                List<genesis__Application_Document_Category__c> GAdc=[select id from genesis__Application_Document_Category__c where name=:Constants.LoanDocuments And  genesis__Application__c=:AppID limit 1];
                System.debug('@#$@#$ GAdc >>>'+GAdc);
                List<genesis__AppDocCatAttachmentJunction__c> GaList=[select id,genesis__AttachmentId__c from genesis__AppDocCatAttachmentJunction__c where genesis__AttachmentId__c=:att.id and    genesis__Application_Document_Category__c=:GAdc[0].id and   Document_Name__c=:FF+'.pdf' limit 1];
                System.debug('@#$@#$ GaList >>>'+GaList);
                
                if(GaList.isEmpty()){
                    genesis__AppDocCatAttachmentJunction__c AAJ=new genesis__AppDocCatAttachmentJunction__c();
                    AAJ.genesis__Application_Document_Category__c=GAdc[0].id;
                    AAJ.genesis__AttachmentId__c=att.id;
                    AAJ.Dms_Uuid__c = DOC_UUID;
                    AAJ.Document_Name__c =FF;
                    insert AAJ;
                }
                if(FF==Constants.Acknowledgement_For_Sanction || FF==Constants.Acknowledgement_For_SanctionLAP || FF==Constants.Acknowledgement_For_SanctionLAP_NLD || FF==Constants.LAP_A23D_LAFA || FF==Constants.LAP_A46DOC || FF==constants.HL_DIGIO_MANUAL_C1C11){
                    List<Digio_Document_ID__c> Dlist=[select id,Application__c,Document_ID__c from Digio_Document_ID__c where   Name=:FF and Application__c =:appId];
                    System.debug('@#Digio_Document_ID__c#@'+Dlist);

                   Digio_Document_ID__c Did=new Digio_Document_ID__c();
                    Did.Name=FF;
                    Did.Application__c=appId;
                    Did.Document_ID__c=Docid;
                    if(Dlist.size()>0){
                        DELETE Dlist  ; 
                    }
                   // insert Did;      
                    System.debug('*********'+Did);

                    set<id> AcciDs=new set<Id>();
                    AcciDs.add(appln.genesis__Account__c) ;
                    integer pcount=0;
                    integer count=0;
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
                       // insert DocApp;
                    }
                    ApplicationTriggerHandler.IsFirstRun = False;
                    update appln;
                    System.debug('Document Generated Successfully!');
                }
            } else {
                System.debug('No document to generate!!');
            }
        }catch(exception e){
            System.debug('Doc generation error '+e.getLineNumber()+e.getMessage());
            HandleBusinessException.captureError('HL_Digio_Service','docGenAndSignDoc', e);       
        }
    }
    
}