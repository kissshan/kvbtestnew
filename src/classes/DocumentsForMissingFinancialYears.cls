public class DocumentsForMissingFinancialYears {
    public Document document{get;set;}
    public String selecteddocument{get;set;}
    public String fisicalYears{get;set;}
    public List<SelectOption> documentCats{get;set;}
    public List<SelectOption> missingFisicalYears{get;set;}
    Public  genesis__Applications__c application{get;set;}
    public  List<genesis__Application_Document_Category__c> appDocList{get;set;}
    public String uuId{get;set;}
	public String operation{get;set;}
    public Boolean uploadBlock{get;set;}
    public Boolean insertBlock{get;set;}
	
    public DocumentsForMissingFinancialYears(){
        insertBlock = false;
        uploadBlock = false;
        uuId = ApexPages.currentPage().getParameters().get('uuid');
        operation = ApexPages.currentPage().getParameters().get('operation');
        Id appId = ApexPages.currentPage().getParameters().get('Id');
        //appId = 'a4V0l0000004xcg';
        //uuId = '1212';
        //operation = 'updateDMS';
        //operation = 'insertDMS';
        System.debug('uuid>>'+uuid);
		System.debug('operation>>'+operation);
        if(operation == 'updateDMS')
            uploadBlock = true;
        if(operation == 'insertDMS')
            insertBlock = true;
        application = [SELECT Id,genesis__Account__c,CustomerID__c,RecordType_Developer_Name__c FROM genesis__Applications__c WHERE Id =: appId];
        appDocList = [select Id,Name from genesis__Application_Document_Category__c Where genesis__Application__c =: application.Id];
        document = new Document();
        getDocumentNames();
        getMissingFisicalYears();
    }
    public List<SelectOption> getMissingFisicalYears(){
        missingFisicalYears = new List<SelectOption>();
        missingFisicalYears.clear();
        List<String> missingYears = YearDataConstant.getAllMissingYear(application.genesis__Account__c,true);
        for(String str : missingYears){
            missingFisicalYears.add(new SelectOption(str,str));  
        }
        return missingFisicalYears; 
    }  
    public List<SelectOption> getDocumentNames() {
        documentCats = new List<SelectOption>();
        documentCats.clear();
        for( genesis__Application_Document_Category__c appdocs : appDocList) { 
            documentCats.add( new SelectOption(appdocs.Id,appdocs.Name));            
        }
        return documentCats; 
    }

    public PageReference insertDocCatJun() { 
        try {
            String documentbody = EncodingUtil.base64Encode(document.Body);
            genesis__AppDocCatAttachmentJunction__c appDocJunobj = new genesis__AppDocCatAttachmentJunction__c();
            String dmsUuId = DMS_Service.uploadDocument_DMS('',application.CustomerID__c,application.Id,application.RecordType_Developer_Name__c,document.Name,documentbody);
            if(dmsUuId != '' || dmsUuId != null){
                appDocJunobj.Dms_Uuid__c = dmsUuId;
                //appDocJunobj.Name = document.Name;
                appDocJunobj.genesis__Application_Document_Category__c = selecteddocument; 
                System.debug('appDocJunobj***' + appDocJunobj);
                insert appDocJunobj;
            }
        }catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'));
            return null;
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
        return null;
    }

    public PageReference updateDocCatJun(){
        System.debug(uuId);
        System.debug(application.CustomerID__c);
        System.debug(application.Id);
        System.debug(document.Name);
        System.debug(document.Body);
        
        List<genesis__AppDocCatAttachmentJunction__c> appDocJunobjList = new List<genesis__AppDocCatAttachmentJunction__c>();
        appDocJunobjList = [Select Id,Dms_Uuid__c from genesis__AppDocCatAttachmentJunction__c where Dms_Uuid__c =: uuId];
        try {
            for(genesis__AppDocCatAttachmentJunction__c appDocJunobj: appDocJunobjList){
                String documentbody = EncodingUtil.base64Encode(document.Body);
                String dmsUuId = DMS_Service.uploadDocument_DMS(uuId,application.CustomerID__c,application.Id,application.RecordType_Developer_Name__c,document.Name,documentbody);
                if(dmsUuId != '' || dmsUuId != null){
                    appDocJunobj.Dms_Uuid__c = dmsUuId; 
                    System.debug('appDocJunobj***'+appDocJunobj);
                    update appDocJunobj;
                }
            }   
        }catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'));
            return null;
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
        return null;
    }
    public pageReference detaiPage(){
        pageReference pr =  new pageReference('/apex/ApplicationDetails'); 
        pr.setRedirect(true);
        return pr;
    }

}