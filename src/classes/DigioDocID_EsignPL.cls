/*
* Name          : DigioDocID_EsignPL
* Description   : Generating Document IDS for PL 
* Author        : Ashok Rathva
*/
public with sharing class DigioDocID_EsignPL {
    
    public static string DocumentIDGeneration(string Appid,String Filename,integer Pgcount,string class2doc){
        try{
            WS_GetEsignDocID.Response resp  = new WS_GetEsignDocID.Response(); 
            resp.eSignRes = new WS_GetEsignDocID.eSignResponse();
            List<String> emailList = new List<String>();
            List<DMS_Structure.cls_signers> signList  = new List<DMS_Structure.cls_signers>();
            List<genesis__Application_Parties__c> parties   = new List<genesis__Application_Parties__c>();
            DMS_Structure.ESignRequest eSignReq       = new DMS_Structure.ESignRequest(); 
            Map<String,Map<Integer,List<Object>>> signMap   = new Map<String,Map<Integer,List<Object>>>();
            List<genesis__Applications__c> ApList=[select id,genesis__Account__r.Aadhaar_Number__pc,genesis__Account__r.PersonMobilePhone,(select id,Title_Holder__c,genesis__Party_Account_Name__r.PersonMobilePhone,genesis__Party_Account_Name__r.Aadhaar_Number__pc,genesis__Party_Type__c from genesis__Application_Parties__r where Active__c=true  AND genesis__Party_Account_Name__r.PersonEmail != null AND genesis__Party_Account_Name__r.PersonMobilePhone != null) from genesis__Applications__c where ID=:Appid];
            system.debug('ApList'+ApList);
            
            for(genesis__Applications__c App:ApList){
                //  emailList.add(App.genesis__Account__r.PersonEmail);
                string PAaadhar = '';
               // PAaadhar=WS_getAadharNo.getAadharNo(PAaadhar);
                // signList.add(new DMS_Structure.cls_signers(App.genesis__Account__r.PersonEmail,PAaadhar,Constants.EMAIL_REASON));
                if(Filename == Constants.PRE_APPROVE_SANCTION_PL){
                    signList.add(new DMS_Structure.cls_signers(App.genesis__Account__r.PersonMobilePhone,PAaadhar,Constants.MOB_REASON));
                    Filename = Constants.PL_DOC_DEVELOPERNAME;
                }
                if(Filename == Constants.PL_AGREEMENT_DOC){
                    signList.add(new DMS_Structure.cls_signers(App.genesis__Account__r.PersonMobilePhone,PAaadhar,Constants.MOB_REASON));
                    Filename = Constants.PL2_DOC_DEVELOPERNAME;
                }
            }
            
            signMap= SMESanction_DocReq.genCordStructure((Integer)Pgcount,appId,Filename);
            system.debug('signMap'+signMap);
            // string  class2SignedDoc=class2doc;
            eSignReq.exe_tenantId   = 'cuecent_tenant';
            eSignReq.owner_tenantId = 'cuecent_tenant';
            eSignReq.inputVariables = new DMS_Structure.cls_inputVariables();
            eSignReq.inputVariables.in_msg = '';
            eSignReq.inputVariables.inputMap = new DMS_Structure.cls_map();
            eSignReq.inputVariables.inputMap.signers = new List<DMS_Structure.cls_signers>();
            eSignReq.inputVariables.inputMap.signers = signList;
            eSignReq.inputVariables.inputMap.display_on_page ='custom';
            eSignReq.inputVariables.inputMap.expire_in_days =integer.valueOf(system.label.DIgio_Expiry_Days);
            eSignReq.inputVariables.inputMap.file_Name = Filename+'_'+appId;
            eSignReq.inputVariables.inputMap.file_data = class2doc;
            eSignReq.inputVariables.inputMap.sign_coordinates = signMap;
            eSignReq.inputVariables.inputMap.notify_signers = false;
            eSignReq.inputVariables.inputMap.send_sign_link = false;
            system.debug('eSignReq:-'+eSignReq);
            resp.eSignRes.docID =DMS_Structure.getESigned(eSignReq);
            return  resp.eSignRes.docID;
        }
        catch(exception e){
            system.debug('Error line'+e.getLineNumber()+'error trace tag'+e.getStackTraceString());
            return null;
        }
    }

}