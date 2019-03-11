/*
* Name          : DigioDocID_EsignHL
* Description   : Generating Document IDS for HL 
* Author        : VenuGopal N
*/

public class DigioDocID_EsignHL {
    
    public static string DocumentIDGeneration(string Appid,String Filename,integer Pgcount,string class2doc){
        System.debug('Filename'+Filename);
        System.debug('AppId::'+Appid);
        System.debug('pagecount::'+Pgcount);
        System.debug('classs2::'+class2doc);
        try{
            
            WS_GetEsignDocID.Response resp = new WS_GetEsignDocID.Response(); 
            resp.eSignRes          = new WS_GetEsignDocID.eSignResponse();
            List<String> emailList= new List<String>();
            List<DMS_Structure.cls_signers> signList    = new List<DMS_Structure.cls_signers>();
            List<genesis__Application_Parties__c> parties   = new List<genesis__Application_Parties__c>();
            DMS_Structure.ESignRequest eSignReq       = new DMS_Structure.ESignRequest(); 
            Map<String,Map<Integer,List<Object>>> signMap   = new Map<String,Map<Integer,List<Object>>>();
            List<genesis__Applications__c> ApList           = new List<genesis__Applications__c>();
            string docName = Filename.split('.pdf')[0];
            System.debug('docName:'+docName);
            List<String> partyTypeList = new List<String>();
            boolean checkPartyType  = false;
            if(Constants.Acknowledgement_For_SanctionLAP.contains(docName) || Constants.LAP_A23.contains(docName) || Constants.LAP_B1 == docName || Constants.B17_HL == docName || Constants.HL_Topup_A66 == docName || Constants.HL_Takeover_A54 == docName){
                System.debug('docName:'+docName);
                checkPartyType = true;
                partyTypeList.add('Co-Borrower');
            }if(Constants.LAP_A46.contains(docName) || Constants.Acknowledgement_For_SanctionLAP.contains(docName)) {
                checkPartyType = true;
                partyTypeList.add('Guarantor');
            }
            if(Constants.VLSANCTIONLETTER.contains(docName) || Constants.VLHYPOTHECATIONLD.contains(docName) || Constants.VLDEALERPYMNTAUTH.contains(docName)) {
                checkPartyType = True;
                partyTypeList.add(Constants.Co_Borrower);
                System.debug('object docName >>> ' + docName);
            }
            if(docName == Constants.B1_HL){
                checkPartyType = True;
                partyTypeList.add(Constants.Co_Borrower);
                partyTypeList.add(Constants.PRIMARY_APP);
            }
            System.debug('!!!!!!--->>>'+partyTypeList);
            if(checkPartyType){
                System.debug('----->'+checkPartyType);
                ApList=[select id,RecordType.DeveloperName,genesis__Account__r.Aadhaar_Number__pc,genesis__Account__r.PersonMobilePhone,(select id,Title_Holder__c,genesis__Party_Account_Name__r.PersonMobilePhone,genesis__Party_Account_Name__r.Aadhaar_Number__pc,genesis__Party_Type__c from genesis__Application_Parties__r where Active__c=true  AND genesis__Party_Account_Name__r.PersonEmail != null AND genesis__Party_Account_Name__r.PersonMobilePhone != null AND genesis__Party_Type__c IN : partyTypeList) from genesis__Applications__c where ID=:Appid];
                System.debug('^^^^^^>>>>>'+ApList);
            }
            else{
                ApList=[select id,RecordType.DeveloperName,genesis__Account__r.Aadhaar_Number__pc,genesis__Account__r.PersonMobilePhone,(select id,Title_Holder__c,genesis__Party_Account_Name__r.PersonMobilePhone,genesis__Party_Account_Name__r.Aadhaar_Number__pc,genesis__Party_Type__c from genesis__Application_Parties__r where Active__c=true  AND genesis__Party_Account_Name__r.PersonEmail != null AND genesis__Party_Account_Name__r.PersonMobilePhone != null) from genesis__Applications__c where ID=:Appid];
            }
            
            integer count = 0;
            for(genesis__Applications__c App:ApList){
                string PAaadhar = '';
                System.debug('Applicant PAaadhar'+PAaadhar);
                if(Filename!=Constants.A46_HL && Filename!=Constants.LAP_B1 && Filename!=Constants.LAP_A46 && Filename!=Constants.B1_HL){
                    signList.add(new DMS_Structure.cls_signers(App.genesis__Account__r.PersonMobilePhone,PAaadhar,Constants.MOB_REASON));
                }
                
                if(app.RecordType.DeveloperName == Constants.LAPLOAN && Filename == Constants.LAP_B1){
                        System.debug('@@@@@@@@@@@@@@@@@@'+WS_eStampDocGen.accList.size());
                        if(WS_eStampDocGen.accList.size() > 0){
                            String aadhar = '';
                            
                            for(Account acc : WS_eStampDocGen.accList){
                                count++;
                                signList.add(new DMS_Structure.cls_signers(acc.PersonMobilePhone,aadhar,Constants.MOB_REASON));
                            }
                        }
                }
                else{
                    for(genesis__Application_Parties__c Parti:App.genesis__Application_Parties__r){
                        string aadhar ;            
                        if(Filename==Constants.A46_HL || Filename== Constants.LAP_A46){
                            if(Parti.genesis__Party_Type__c==Constants.Gurantor){
                                aadhar ='';
                            }
                            
                        }
                        else if(Filename==Constants.B17_HL || Filename==Constants.A23_HL || Filename==Constants.LAP_A23 || Filename==Constants.HL_Topup_A66 || Filename==Constants.HL_Takeover_A54){
                            if(Parti.genesis__Party_Type__c==Constants.Co_Borrower){
                               aadhar = '';
                            }
                        }
                        else if(Filename==Constants.B1_HL ){
                            if(Parti.Title_Holder__c){
                                aadhar = '';
                            }
                        }
                        else{
                            if(parti.genesis__Party_Type__c != Constants.PRIMARY_APP){
                                aadhar = ''; 
                                System.debug('object >>> Co Borrower');
                            }
                        }
                        System.debug('Co -Applicant PAaadhar'+aadhar);
                        if((parti.genesis__Party_Type__c == Constants.Co_Borrower   || parti.genesis__Party_Type__c == Constants.PRIMARY_APP) && Filename==Constants.B1_HL){
                          if(parti.Title_Holder__c==true)
                            signList.add(new DMS_Structure.cls_signers(Parti.genesis__Party_Account_Name__r.PersonMobilePhone,aadhar,Constants.MOB_REASON));
                        }
                        else if(parti.genesis__Party_Type__c != Constants.PRIMARY_APP){
                            signList.add(new DMS_Structure.cls_signers(Parti.genesis__Party_Account_Name__r.PersonMobilePhone,aadhar,Constants.MOB_REASON));
                        }
                    }
                }
            }
            System.debug('::Count::'+Count);
            signMap= SMESanction_DocReq.genCordStructure((Integer)Pgcount,appId,Filename);
            System.debug('signMap'+signMap);
            eSignReq.exe_tenantId   = 'cuecent_tenant';
            eSignReq.owner_tenantId = 'cuecent_tenant';
            eSignReq.applicationType = '1';
            eSignReq.applicationId = Appid;
            eSignReq.customerId = '1';
            eSignReq.documentType = Filename;
            eSignReq.accountNumbers = '1';
            eSignReq.uuid = class2doc;
            eSignReq.inputVariables = new DMS_Structure.cls_inputVariables();
            eSignReq.inputVariables.in_msg = '';
            eSignReq.inputVariables.inputMap = new DMS_Structure.cls_map();
            eSignReq.inputVariables.inputMap.signers = new List<DMS_Structure.cls_signers>();
            eSignReq.inputVariables.inputMap.signers = signList;
            eSignReq.inputVariables.inputMap.display_on_page ='custom';
            eSignReq.inputVariables.inputMap.expire_in_days =integer.valueOf(System.label.DIgio_Expiry_Days);
            eSignReq.inputVariables.inputMap.file_Name = Filename+'_'+appId;
            eSignReq.inputVariables.inputMap.file_data = class2doc;
            eSignReq.inputVariables.inputMap.sign_coordinates = signMap;
            eSignReq.inputVariables.inputMap.notify_signers = false;
            eSignReq.inputVariables.inputMap.send_sign_link = false;
            //System.debug('eSignReq:-'+eSignReq);
            resp.eSignRes.docID =DMS_Service.getESigned(eSignReq);
            return  resp.eSignRes.docID;
            
        }
        
        catch(exception e){
            System.debug('Error line'+e.getLineNumber()+'error trace tag'+e.getStackTraceString()+' message'+e.getMessage());
            return null;
        }
        
    } 
    
}