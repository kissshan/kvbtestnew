/**
* Created by ET-MARLABS on 02-08-2018.
*/
public class UpdateDMSReferenceHelper {
    public Static ID appId;
    public static String updateDmsRefrecnce(List<DMS_Structure.DMSRefrenceWrapper> dmsRefWrap){
        try {
            List <genesis__AppDocCatAttachmentJunction__c> junctionObjList = new List<genesis__AppDocCatAttachmentJunction__c>();
            genesis__AppDocCatAttachmentJunction__c junctionObjectInstance;
            List<string> uuidlist=new List<string>();
            for(DMS_Structure.DMSRefrenceWrapper wrapObj:dmsRefWrap){
                junctionObjectInstance                                              = new genesis__AppDocCatAttachmentJunction__c();
                junctionObjectInstance.genesis__Application_Document_Category__c    = wrapObj.LOS_DOC_CATEGOREY_ID;
                junctionObjectInstance.Dms_Uuid__c                                  = wrapObj.LOS_DOC_UUID;
                junctionObjectInstance.Document_Name__c                             = wrapObj.LOS_DOC_NAME;
               // junctionObjectInstance.genesis__Application_Document_Category__r.genesis__Application__c = appId;
                System.debug('wrapObj.LOS_APPLICATION_ID:::'+wrapObj.LOS_APPLICATION_ID);
                appId = Id.valueOf(wrapObj.LOS_APPLICATION_ID);
                 if(wrapObj.Los_Is_Deleted !=null && wrapObj.Los_Is_Deleted){
                    uuidlist.add(wrapObj.LOS_DOC_UUID);
                }
                else{
                    junctionObjList.add(junctionObjectInstance);
                }
            }
            List<genesis__AppDocCatAttachmentJunction__c> dellist=[select id from genesis__AppDocCatAttachmentJunction__c where Dms_Uuid__c in:uuidlist];
            System.debug('dellist:::'+dellist);
            if(!junctionObjList.isEmpty()){
                System.debug('junctionObjList:::'+junctionObjList);
                UPSERT junctionObjList Dms_Uuid__c;
                if(appId != null){
                    //CreateFinancialUploadTask(appId);
                }
            }   
            if(!dellist.isEmpty()){
                delete dellist;
            }
            return 'DMS Reference has been Updated';
        } catch (Exception e) {
            return 'Apex Error :::'+' '+e.getMessage()+' AT '+e.getLineNumber()+ 'STCKTRACE'+' '+e.getStackTraceString();
        }
    }
    
    /*
** Creating the Task for CLPC/BM
*/
    public static void CreateFinancialUploadTask(Id DocAppId){
        List<genesis__Applications__c> app= [select id,(select id, subject from tasks where subject= 'Financial Doc Upload') from genesis__Applications__c where id =: DocAppId];
        if(app.size()>0 && app[0].tasks.size()==0){
            User clpcUser = SOQL_Util.getRLPCUser(app[0].Id);
            Task newTsk= SanctionUnderwriting_Process.getTaskObj(app[0].Id, clpcUser.Id, 'Financial Doc Upload', 'Financial Doc Upload');
            insert newTsk;
        }
    }
}