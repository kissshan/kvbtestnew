/*
* Name          : DocumentFetch
* Description   : Handle Document Category Juction Operations
* Author        : Dushyant
*/
public class DocumentFetch {
    //get document category and create application document category if not there.
    public static List<genesis__Application_Document_Category__c> checkDocumentCategory(String appId,List<String> documentCategoryType){
        try{
            genesis__Applications__c apprecord = [Select Id,Name from genesis__Applications__c where id=:appId];
            Map<Id,genesis__Document_Category__c> docCatList;
            List<genesis__Application_Document_Category__c> appDocCategoryList          = new List<genesis__Application_Document_Category__c>();
            Set<string> documentSet                                                     = new set<string>();
            documentSet.addAll(documentCategoryType);
            
            docCatList = new Map<Id,genesis__Document_Category__c>([SELECT Id,genesis__Category_Name__c,Doc_Category_No__c,Document_Category__c FROM genesis__Document_Category__c WHERE Document_Category__c IN :documentCategoryType order by Doc_Category_No__c ]);
            appDocCategoryList = [SELECT Id,Name,App_Doc_Category_No__c,Parent_Category_Name__c,genesis__Document_Category__c,genesis__Document_Category__r.Required_for_Missing_Financial__c,genesis__Document_Category__r.Document_Category__c,(SELECT Id,Dms_Uuid__c FROM genesis__AppDocCatAttachmentJunctions__r) FROM genesis__Application_Document_Category__c WHERE genesis__Document_Category__r.Document_Category__c IN: documentCategoryType AND genesis__Application__c =: appId];
            system.debug('appDocCategoryList==='+appDocCategoryList);
            set<string> docParentIds    = new set<string>();
            system.debug('docParentIds===='+docParentIds);
            for(genesis__Application_Document_Category__c  ap : appDocCategoryList){
                docParentIds.add(ap.genesis__Document_Category__c);
            }
            List<genesis__Document_Category__c> doclistToAdd    = new List<genesis__Document_Category__c>();
            for(string dcatId : docCatList.keySet()){
                system.debug('docCatList.keySet====='+docCatList.keySet());
                if(!docParentIds.contains(dcatId)){
                    if(docCatList.containsKey(dcatId))
                        doclistToAdd.add(docCatList.get(dcatId));
                }
            }
            if(!doclistToAdd.isEmpty()){
                List<genesis__Application_Document_Category__c> newCategoryList = new List<genesis__Application_Document_Category__c>();
                genesis__Application_Document_Category__c parentCatg ;
                parentCatg = new genesis__Application_Document_Category__c(Name = 'SME '+apprecord.Name , genesis__Application__c = appId,External_ID__c='SME_'+appId+'_Root');
                upsert parentCatg External_ID__c;
                for(genesis__Document_Category__c dcat : doclistToAdd){
                    newCategoryList.add(new genesis__Application_Document_Category__c(Name = dcat.genesis__Category_Name__c , genesis__Application__c = appId , genesis__Document_Category__c = dcat.Id, genesis__Parent_Application_Document_Category__c=parentCatg.id,App_Doc_Category_No__c=dcat.Doc_Category_No__c));
                }
                INSERT newCategoryList;
                return [SELECT Id,Name,App_Doc_Category_No__c,Parent_Category_Name__c,genesis__Document_Category__c,genesis__Document_Category__r.Document_Category__c FROM genesis__Application_Document_Category__c WHERE genesis__Document_Category__r.Document_Category__c IN: documentCategoryType AND genesis__Application__c =: appId];
            }
            RETURN appDocCategoryList;
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
            RETURN null;
        }
    }
     public static List<genesis__Application_Document_Category__c> checkDocumentCategory2(String appId,List<String> documentCategoryType,Set<String> missingFin){
        try{
            documentCategoryType.addAll(new List<String>{'Other Banks - TL Sanction Letter','Collateral','Margin Name','Other Banks - TL Bank Statement','Investment Details - Machinery','Investment Details - Vehicle','Investment Details - L&B','Investment Details - Others','Investment Details - BTL','Investment Details - Construction Equipment','Investment Details - Commercial Vehicle','nvestment Details - Construction Equipment'});
            genesis__Applications__c apprecord = [Select Id,Name,type__c from genesis__Applications__c where id=:appId];
            List<genesis__Document_Category__c> docCatList                              = new List<genesis__Document_Category__c>();
            List<genesis__Application_Document_Category__c> appFinancialDocCategoryList          = new List<genesis__Application_Document_Category__c>();
            List<genesis__Application_Document_Category__c> appDocCategoryList          = new List<genesis__Application_Document_Category__c>();
            List<genesis__Application_Document_Category__c> collappDocCategoryList          = new List<genesis__Application_Document_Category__c>();
            docCatList = [SELECT Id,Name,genesis__Category_Name__c,Required_for_Missing_Financial__c,CollateralDoc__c,Doc_Category_No__c,Document_Category__c FROM genesis__Document_Category__c WHERE Document_Category__c IN :documentCategoryType order by Doc_Category_No__c];
            appDocCategoryList = [SELECT Id,Name,App_Doc_Category_No__c,genesis__Document_Category__r.Document_Category__c,genesis__Document_Category__r.Required_for_Missing_Financial__c,Parent_Category_Name__c,(SELECT Id,Dms_Uuid__c FROM genesis__AppDocCatAttachmentJunctions__r) FROM genesis__Application_Document_Category__c WHERE genesis__Document_Category__r.Document_Category__c IN: documentCategoryType AND genesis__Application__c =: appId];
            System.debug(docCatList);
            System.debug(appDocCategoryList);
            if(appDocCategoryList.isEmpty()){
                genesis__Application_Document_Category__c parentCatg ;
                parentCatg = new genesis__Application_Document_Category__c(Name = 'SME '+apprecord.Name , genesis__Application__c = appId,External_ID__c='SME_'+appId+'_Root');
                upsert parentCatg External_ID__c;
                Decimal flag=10000;
                for(genesis__Document_Category__c dcat : docCatList){
                    System.debug('dcat ==> '+dcat);
                    flag++;

                    if(missingFin!= null && missingFin.size()>0){
                        System.debug('missingFin ==> '+missingFin);
                        for(String year:missingFin){
                            System.debug('year '+year);
                            flag++;
                            if(dcat.Required_for_Missing_Financial__c){
                                System.debug('Required'+dcat.genesis__Category_Name__c);
                                appDocCategoryList.add(new genesis__Application_Document_Category__c(Name = dcat.genesis__Category_Name__c+' '+year, genesis__Application__c = appId , genesis__Document_Category__c = dcat.Id, genesis__Parent_Application_Document_Category__c=parentCatg.id,App_Doc_Category_No__c=flag+dcat.Doc_Category_No__c));

                            }
                        }
                    }
                    /*
                    collappDocCategoryList=DocumentFetch.createCollateralDocCategoty(appid,dcat,flag,parentCatg);
                    System.debug(collappDocCategoryList);
                    if(collappDocCategoryList!=null && collappDocCategoryList.size()>0){
                        appDocCategoryList.addAll(collappDocCategoryList);
                        flag=flag+appDocCategoryList.size();
                    }*/
                    if(! dcat.Required_for_Missing_Financial__c && !dcat.CollateralDoc__c){
                        System.debug('Not Required'+dcat.genesis__Category_Name__c);
                        appDocCategoryList.add(new genesis__Application_Document_Category__c(Name = dcat.genesis__Category_Name__c, genesis__Application__c = appId , genesis__Document_Category__c = dcat.Id, genesis__Parent_Application_Document_Category__c=parentCatg.id,App_Doc_Category_No__c=dcat.Doc_Category_No__c));

                        //appDocCategoryList.add(new genesis__Application_Document_Category__c(Name = dcat.genesis__Category_Name__c+' '+YearDataConstant.currFiscalYear , genesis__Application__c = appId , genesis__Document_Category__c = dcat.Id, genesis__Parent_Application_Document_Category__c=parentCatg.id,App_Doc_Category_No__c=dcat.Doc_Category_No__c));
                    }
                }
                for(genesis__Application_Document_Category__c rec:appDocCategoryList){
                    System.debug('Record Value'+rec);
                }
                INSERT appDocCategoryList;
            }


            //NTB-Start
            for(genesis__Application_Document_Category__c appdoc:appDocCategoryList){
                if(appdoc.genesis__Document_Category__r.Document_Category__c=='SME Financial Document' && appdoc.genesis__Document_Category__r.Required_for_Missing_Financial__c==true){
                    appFinancialDocCategoryList.add(appdoc);
                }
            }
            
            //System.debug('appDocCategoryList.isEmpty()==> '+appDocCategoryList.isEmpty());
            //System.debug('apprecord.type__c.contains(NTB)==> '+apprecord.type__c.contains('NTB'));
            //System.debug('appFinancialDocCategoryList.isEmpty()==> '+appFinancialDocCategoryList.isEmpty());
            if(!appDocCategoryList.isEmpty() && missingFin!=null && apprecord.type__c.contains('NTB') && appFinancialDocCategoryList.isEmpty()){
                genesis__Application_Document_Category__c parentCatg;
                parentCatg = new genesis__Application_Document_Category__c(Name = 'SME '+apprecord.Name , genesis__Application__c = appId,External_ID__c='SME_'+appId+'_Root');
                upsert parentCatg External_ID__c;
                Decimal flaginc=10000;
                for(genesis__Document_Category__c dcat : docCatList){
                    System.debug('dcat ==> '+dcat);
                    flaginc++;

                    if(missingFin!= null && missingFin.size()>0){
                        System.debug('missingFin ==> '+missingFin);
                        for(String year:missingFin){
                            System.debug('year '+year);
                            flaginc++;
                            if(dcat.Required_for_Missing_Financial__c){
                                System.debug('Required'+dcat.genesis__Category_Name__c);
                                appFinancialDocCategoryList.add(new genesis__Application_Document_Category__c(Name = dcat.genesis__Category_Name__c+' '+year, genesis__Application__c = appId , genesis__Document_Category__c = dcat.Id, genesis__Parent_Application_Document_Category__c=parentCatg.id,App_Doc_Category_No__c=flaginc+dcat.Doc_Category_No__c));

                            }
                        }
                    }
                    
                }
                for(genesis__Application_Document_Category__c rec:appFinancialDocCategoryList){
                    System.debug('Record Value'+rec);
                }
                INSERT appFinancialDocCategoryList;
            }
            
            if(!appFinancialDocCategoryList.isEmpty()){
                appDocCategoryList.addAll(appFinancialDocCategoryList);
            }
            //NTB-END


        RETURN appDocCategoryList;
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
            RETURN null;
        }
    }
    //Get financial details against an application
    public static List<genesis__AppDocCatAttachmentJunction__c> getFinanceDetails(String appId){
        List<genesis__AppDocCatAttachmentJunction__c> appDocCategoryList    = new List<genesis__AppDocCatAttachmentJunction__c>();
        appDocCategoryList = [SELECT Id,Name,genesis__Application_Document_Category__r.Name,genesis__AttachmentId__c,genesis__Application_Document_Category__r.App_Doc_Category_No__c FROM genesis__AppDocCatAttachmentJunction__c WHERE genesis__Application_Document_Category__r.genesis__Application__c =: appId];
        RETURN appDocCategoryList;
    }
    //Delete other document and documentCategoryJunctionObject against document category after document insert
    public static void deleteDocAndDocumentCategory(Map<Id,genesis__AppDocCatAttachmentJunction__c> docJuncMap){
        List<genesis__AppDocCatAttachmentJunction__c> docCatJuncToDelete   = new List<genesis__AppDocCatAttachmentJunction__c>();
        List<Attachment> attToDeleteList                   = new List<Attachment>();
        Set<Id> catIdSet                           = new Set<Id>();
        Set<Id> attIsSet                           = new Set<Id>();
        List<String> docCategoryToExclude                   = new List<String>{'Individual ITR','Constitution Supporting Document','Constitution Deed Document','Bank Statement Upload','Sanction letter Upload','Supporting Documents'};
        for(genesis__AppDocCatAttachmentJunction__c catJuncObj : docJuncMap.values()){
            catIdSet.add(catJuncObj.genesis__Application_Document_Category__c);
        }
        System.debug(catIdSet.size()+':::'+catIdSet);
        if(!catIdSet.isEmpty())
            docCatJuncToDelete = [SELECT Id,genesis__AttachmentId__c FROM genesis__AppDocCatAttachmentJunction__c WHERE genesis__Application_Document_Category__c IN :catIdSet AND Id != :docJuncMap.keySet() AND genesis__Application_Document_Category__r.Name NOT IN :docCategoryToExclude AND genesis__Application_Document_Category__r.genesis__Application__r.RecordType.DeveloperName IN : Constants.allSMERecordTypeDeveloperName];
        system.debug('docCatJuncToDelete==='+docCatJuncToDelete);
        if(!docCatJuncToDelete.isEmpty()){
            for(genesis__AppDocCatAttachmentJunction__c catJunc : docCatJuncToDelete){
                attIsSet.add(catJunc.genesis__AttachmentId__c);
            }
            if(!attIsSet.isEmpty()){
                attToDeleteList = [SELECT Id FROM Attachment WHERE Id IN :attIsSet];
            }
        }
        if(!docCatJuncToDelete.isEmpty()){
            system.debug('docCatJuncToDelete****'+docCatJuncToDelete);
            DELETE docCatJuncToDelete;
        }
        if(!attToDeleteList.isEmpty()){
            DELETE attToDeleteList;
        }
    }

    //Wrapper Classes
    public class DocCatRequest{
        public List<DocumentCategory> CATEGORY_LIST;
    }

    public class DocumentCategory{
        public String LABEL_ID;
        public String CATEGORY_NAME;
        public String CATEGORY_ID;
        public String DMS_UUID;
        public String PARENT_CAT_NAME;
        //Constructor
        public DocumentCategory(String LABEL_ID,String catName, String catId){
            this.LABEL_ID  = LABEL_ID;
            this.CATEGORY_NAME = catName;
            this.CATEGORY_ID = catid;
            this.DMS_UUID = '';
            this.PARENT_CAT_NAME ='';
        }
        //Constructor
        public DocumentCategory(){}
    }

    public class FinanceRequest{
        public List<FinanceSection> FINANCIAL_SECTION;
    }

    public class FinanceSection{
        public String FILE_NAME;
        public String FILE_URL;
        public String LOS_FINANCE_FILE_ID;
        //Constructor
        public FinanceSection(String fName, String fURL, String fId){
            this.FILE_NAME = fName;
            this.FILE_URL = fURL;
            this.LOS_FINANCE_FILE_ID = fId;
        }
        //Constructor
        public FinanceSection(){}
    }

    public static List<genesis__Application_Document_Category__c> createCollateralDocCategoty(String appid,genesis__Document_Category__c dcat,Decimal flag,genesis__Application_Document_Category__c parentCatg){
        
    try{
        List<String> collidlist=DocumentFetch.getcollateralids(appid);
        System.debug(collidlist);
        List<clcommon__Collateral__c> collist=SOQL_Util.getCollateralWithCollIds(collidlist);
        List<genesis__Application_Document_Category__c> appDocCategoryList = new List<genesis__Application_Document_Category__c>();
        
        System.debug('Here1 ');
        if(collidlist!=null && collidlist.size()>0 && collist!=null && collist.size()>0){
            System.debug('Here2 ');
                        for(clcommon__Collateral__c coll:collist){
                            System.debug('Here3 ');
                            flag++;
                            if(dcat.CollateralDoc__c){
                                System.debug('Here4 ');
                                if(coll.recordtype.developername=='Land_And_Building'){
                                        appDocCategoryList.add(new genesis__Application_Document_Category__c(Name =coll.name+' '+'Sale_Deed', genesis__Application__c = appId , genesis__Document_Category__c = dcat.Id, genesis__Parent_Application_Document_Category__c=parentCatg.id,App_Doc_Category_No__c=flag+dcat.Doc_Category_No__c));
                                        appDocCategoryList.add(new genesis__Application_Document_Category__c(Name =coll.name+' '+'First_Completion_Certificate', genesis__Application__c = appId , genesis__Document_Category__c = dcat.Id, genesis__Parent_Application_Document_Category__c=parentCatg.id,App_Doc_Category_No__c=flag+dcat.Doc_Category_No__c));
                                        
                                }
                                else if(coll.recordtype.developername=='Commercial_Machinery'){
                                        appDocCategoryList.add(new genesis__Application_Document_Category__c(Name =coll.name+' '+'Installation_Certificate', genesis__Application__c = appId , genesis__Document_Category__c = dcat.Id, genesis__Parent_Application_Document_Category__c=parentCatg.id,App_Doc_Category_No__c=flag+dcat.Doc_Category_No__c));
                                        appDocCategoryList.add(new genesis__Application_Document_Category__c(Name =coll.name+' '+'Tax_Invoice', genesis__Application__c = appId , genesis__Document_Category__c = dcat.Id, genesis__Parent_Application_Document_Category__c=parentCatg.id,App_Doc_Category_No__c=flag+dcat.Doc_Category_No__c));
                                }
                                else if(coll.recordtype.developername=='Commercial_Vehicle' || coll.recordtype.developername=='Passenger_Vehicle'){
                                        appDocCategoryList.add(new genesis__Application_Document_Category__c(Name =coll.name+' '+'RC_Copy', genesis__Application__c = appId , genesis__Document_Category__c = dcat.Id, genesis__Parent_Application_Document_Category__c=parentCatg.id,App_Doc_Category_No__c=flag+dcat.Doc_Category_No__c));
                                        appDocCategoryList.add(new genesis__Application_Document_Category__c(Name =coll.name+' '+'Tax_Copy', genesis__Application__c = appId , genesis__Document_Category__c = dcat.Id, genesis__Parent_Application_Document_Category__c=parentCatg.id,App_Doc_Category_No__c=flag+dcat.Doc_Category_No__c));
                                }
                                else if(coll.recordtype.developername=='Construction_Equipment'){
                                        appDocCategoryList.add(new genesis__Application_Document_Category__c(Name =coll.name+' '+'Installation_Certificate', genesis__Application__c = appId , genesis__Document_Category__c = dcat.Id, genesis__Parent_Application_Document_Category__c=parentCatg.id,App_Doc_Category_No__c=flag+dcat.Doc_Category_No__c));
                                        appDocCategoryList.add(new genesis__Application_Document_Category__c(Name =coll.name+' '+'Tax_Invoice', genesis__Application__c = appId , genesis__Document_Category__c = dcat.Id, genesis__Parent_Application_Document_Category__c=parentCatg.id,App_Doc_Category_No__c=flag+dcat.Doc_Category_No__c));
                                }
                                else if(coll.recordtype.developername=='Other'){
                                        appDocCategoryList.add(new genesis__Application_Document_Category__c(Name =coll.name+' '+'Completion_Certificate', genesis__Application__c = appId , genesis__Document_Category__c = dcat.Id, genesis__Parent_Application_Document_Category__c=parentCatg.id,App_Doc_Category_No__c=flag+dcat.Doc_Category_No__c));
                                        appDocCategoryList.add(new genesis__Application_Document_Category__c(Name =coll.name+' '+'Tax_Invoice', genesis__Application__c = appId , genesis__Document_Category__c = dcat.Id, genesis__Parent_Application_Document_Category__c=parentCatg.id,App_Doc_Category_No__c=flag+dcat.Doc_Category_No__c));
                                }
                                else if(coll.recordtype.developername=='Business_Term_Loan'){
                                        appDocCategoryList.add(new genesis__Application_Document_Category__c(Name =coll.name+' '+'CA_Certificate', genesis__Application__c = appId , genesis__Document_Category__c = dcat.Id, genesis__Parent_Application_Document_Category__c=parentCatg.id,App_Doc_Category_No__c=flag+dcat.Doc_Category_No__c));
                                }
                            }
                            
                        }
                    }
                    return appDocCategoryList;
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
            HandleBusinessException.captureError('DocumentFetch','createCollateralDocCategoty',e);
            RETURN null;
        }

    }

    public static List<String> getcollateralids(String appid){
            List<String> collidlist=new List<String>();
            List<genesis__Application_Collateral__c> lstappcoll=new List<genesis__Application_Collateral__c>();
            try{
                
                
                    
                        lstappcoll=[select id,genesis__Collateral__r.id,Application__r.Type_of_Application__c from genesis__Application_Collateral__c where Application__r.id=:appid and Facility__r.App_Facility_Type__c='TL' AND Security_Type__c='Primary Securities' and Application__r.Type_of_Application__c in ('Term Loan','Composite')];
                        if(lstappcoll!=null && lstappcoll.size()>0){
                            for(genesis__Application_Collateral__c appcoll:lstappcoll){
                               collidlist.add(appcoll.genesis__Collateral__r.id);
                        }
                        }
                    
                        return collidlist;
                
            }
            catch(Exception ex){
                HandleBusinessException.captureError('DocumentFetch','getcollateralids',ex);
                return null;
            }
           // return null;
    }


}