global class DocMasterFetchHandler {
    global class DocumentWrap{
        public categoryClass applnCategories;
        Public List<categoryClass> accCategories;
    }
    public Class categoryClass {
        public string recordId;
        public List<cls_DocType> docType;        
    }
    
    public class cls_DocType{
        public string categoryType;
        public List<String> categories;
    }
    

    public static DocMasterFetchHandler.DocumentWrap getDocumentCategory(String appln){
        genesis__Applications__c applnInfo = new genesis__Applications__c();
        applnInfo   = [Select id,genesis__Account__c,Project_Code__c from genesis__Applications__c where Id =:appln];
        
        List<genesis__Application_Parties__c> accts = new List<genesis__Application_Parties__c>();
        accts   = [Select id,genesis__Party_Account_Name__c,Additional_Income__c,
                   genesis__Party_Account_Name__r.Current_Address_Proof_Type__c
                   from genesis__Application_Parties__c
                   where genesis__Application__c =:appln];
        
        Set<String> docCategory = new Set<String>();
        string appDocType ='Property verification documents';
        if(applnInfo.Project_Code__c == null) docCategory.add(appDocType);
        
        Map<String,Set<string>> accCateg = new Map<String,Set<string>>();
        string docType1 ='Proof of income';
        string docType2 ='Proof of current address';
        
        for(genesis__Application_Parties__c acc: accts){          
            if(acc.Additional_Income__c != null) {
                docCategory.add(docType1);
                accCateg.put(acc.genesis__Party_Account_Name__c,new Set<String>{docType1});
            }
            if(acc.genesis__Party_Account_Name__r.Current_Address_Proof_Type__c != null){
                docCategory.add(docType2); 
                if(accCateg.containsKey(acc.genesis__Party_Account_Name__c)){
                    accCateg.get(acc.genesis__Party_Account_Name__c).add(docType2);
                }else{
                    accCateg.put(acc.genesis__Party_Account_Name__c, new Set<String>{docType2});
                }
            }
        }
        
        List<genesis__Document_Category__c> catgs = new List<genesis__Document_Category__c>();
        catgs   = [Select Id,genesis__Category_Name__c  , Document_Category__c 
                   from genesis__Document_Category__c where Document_Category__c IN :docCategory];
        
        Map<String, List<string>> categMap = new Map<String, List<string>>();
        for(genesis__Document_Category__c s : catgs){
            if(categMap.containsKey(s.Document_Category__c)){
                categMap.get(s.Document_Category__c).add(s.genesis__Category_Name__c);
            }else{
                categMap.put(s.Document_Category__c,new List<string>{s.genesis__Category_Name__c});
            }
        }
        system.debug(categMap);
        system.debug(categMap.keySet());
        DocMasterFetchHandler.DocumentWrap reqWrp = new DocMasterFetchHandler.DocumentWrap();
        reqWrp.applnCategories = new categoryClass();
        reqWrp.applnCategories.recordId = appln;
        reqWrp.applnCategories.docType = new List<DocMasterFetchHandler.cls_DocType>();
        if(applnInfo.Project_Code__c == null && categMap != null && categMap.containsKey(appDocType)){
            cls_DocType ab = new DocMasterFetchHandler.cls_DocType();
            ab.categories = new List<String>();
            ab.categoryType = appDocType;
            ab.categories.addAll(categMap.get(appDocType));
            reqWrp.applnCategories.docType.add(ab);
        }            
        
        reqWrp.accCategories = new List<categoryClass>();
        
        for(String s : accCateg.keySet()){
            categoryClass acCatges = new categoryClass();
            acCatges.recordId = s;
            acCatges.docType = new List<DocMasterFetchHandler.cls_DocType>();
            for(String doc : categMap.keySet()){
                if(doc != appDocType){
                    cls_DocType ab = new DocMasterFetchHandler.cls_DocType();
                    ab.categories = new List<String>();
                    ab.categoryType = doc;
                    ab.categories.addAll(categMap.get(doc));
                    acCatges.docType.add(ab);
                }
            }
            reqWrp.accCategories.add(acCatges);
        }
        return reqWrp;
    }
}