/*
* Digio Sanction letter doc generation Req. Class
*/
public class SMESanction_DocReq {
    public static Decimal finalPrFee;
    public static Decimal totalFee;
    public static Decimal docFee;
    public static Decimal cibilFee;
    public static Map<Integer,Integer> signerPageCountMap;
    public String exe_tenantId= 'cuecent_tenant';   //cuecent_tenant
    public String owner_tenantId= 'cuecent_tenant'; //cuecent_tenant
    // public String serviceName= 'TestJsonStr'; //TestJsonStr
    //Newly added tag for DMS
    public String applicationType = '';
    public String applicationId = '';
    public String customerId = '';
    public String documentType = '';
    public String accountNumbers = '';
    public String fileName = '';
    public String uuid = '';

    public cls_inputVariables inputVariables;
    public class cls_inputVariables {        
        public String in_msg= '';   //
        public String unique_key= '';   //
        public String pdf_unique_key= '';
        public Map<String,String> inputmap;
        public Map<String,Object> inputMapForB1;

    }
    
    public static string getFundedRateStr       = 'Interest will be charged @{{Approved_Interest_Rate}}. % p.a. which is {{BRE_Spread_Rate}} % over and above the MCLR of the Bank, Compounded at Monthly rests.';
    public static string getNonFundedRateStr    = 'Commission will be charged @{{Approved_Interest_Rate}}. % p.a.';
    public static string companiesllpTnC        = 'In case Borrower is limited Company/LLP, Bank\'s charge/ modification in the charges over the primary and collateral securities, as applicable, should be registered with the ROC within the stipulated time.';    
    public static string getcorpAdvTnC(){
        return [Select Content__c from Audit__c where RecordType.DeveloperName ='Other' AND Tag_Name__c ='CORP_ADV_TNC' limit 1 ].Content__c;
    }
    public static string getForexAdvTnC(){
        return [Select Content__c from Audit__c where RecordType.DeveloperName ='Other' AND Tag_Name__c ='FORX_ADV_TNC' limit 1 ].Content__c;
    }
    public static string getForexAdvTnCEAE(){
        return [Select Content__c from Audit__c where RecordType.DeveloperName ='Other' AND Tag_Name__c ='FORX_ADV_TNC_EAE' limit 1 ].Content__c;
    }
    public static string getcorpAdvTnCEAE(){
        List<Audit__c> audRec = [Select Content__c from Audit__c where RecordType.DeveloperName ='Other' AND Tag_Name__c ='CORP_ADV_TNC_EAE' limit 1 ];
        if(!audRec.isEmpty())
            return audRec[0].Content__c;
        return '';
    }
    public static List<MCLR_Master__c> getMCLRValues(){
        return [Select id,COD_Term_From__c,COD_Term_To__c,Effective_Date__c,
                Expiry_Date__c,Interest_Rate_Reset__c,Int_ID__c,MCLR_Of_Interest__c from MCLR_Master__c limit 10];
    }
    
    // Purpose: This method prepares signer cordinate structure 
    public static Map<String,Map<Integer,List<Object>>> genCordStructure(Integer totalPage, String appId, String docName){
        try{
            docName = docName.split('.pdf')[0];//Extracting file extension from file name
            List<String> identifierList = new List<String>();
            Boolean isHLDocument = false;//Check if Document is for HL
            Boolean isSMEApplication = false;
            Boolean isLAPApplication = false;
            List<integer> pageNoList = new List<Integer>();
            Integer grSize = 0;
            Integer brSize = 0;
            genesis__Applications__c appln = new genesis__Applications__c();
            List<genesis__Application_Parties__c> parties = new List<genesis__Application_Parties__c>();
            List<genesis__Application_Parties__c> coBorrowersList = new List<genesis__Application_Parties__c>();
            List<genesis__Application_Parties__c> guarentersList = new List<genesis__Application_Parties__c>();
            List<String> partyTypeList = new List<String>();
            
            if(Constants.DOC_NAME_HL_BORR_PH.contains(docName)){
                parties = new List<genesis__Application_Parties__c>([Select id,genesis__Application__c,genesis__Party_Account_Name__c,genesis__Party_Account_Name__r.Full_Name__c,Party_Mobile_No__c,
                                                                     genesis__Party_Account_Name__r.Name,Active__c,genesis__Party_Type__c,
                                                                     genesis__Party_Account_Name__r.PersonEmail,genesis__Party_Account_Name__r.Aadhaar_Number__pc,
                                                                     genesis__Party_Account_Name__r.PersonMobilePhone,CreatedDate                                                                        
                                                                     from genesis__Application_Parties__c WHERE genesis__Party_Account_Name__r.PersonMobilePhone != null AND Active__c = true AND genesis__Application__c =: appId AND Title_Holder__c = true order by CreatedDate asc LIMIT :Constants.TITLE_HOOLDER_LIMIT]);
                //isHLDocument = true;
                System.debug('isHLDocument:::'+isHLDocument+'parties:::::'+parties);
                
            }
            else if(Constants.DOC_NAME_HL_BORROWER.contains(docName)){
                parties = new List<genesis__Application_Parties__c>([Select id,genesis__Application__c,genesis__Party_Account_Name__c,genesis__Party_Account_Name__r.Full_Name__c,Party_Mobile_No__c,
                                                                     genesis__Party_Account_Name__r.Name,Active__c,genesis__Party_Type__c,
                                                                     genesis__Party_Account_Name__r.PersonEmail,genesis__Party_Account_Name__r.Aadhaar_Number__pc,
                                                                     genesis__Party_Account_Name__r.PersonMobilePhone,CreatedDate                                                                        
                                                                     from genesis__Application_Parties__c WHERE genesis__Party_Account_Name__r.PersonMobilePhone != null AND Active__c = true AND genesis__Application__c =: appId AND genesis__Party_Type__c ='Co-Borrower' order by CreatedDate asc LIMIT 3]);
                isHLDocument = true;
                
            }
            else if(Constants.DOC_NAME_HL_GUARANTER.contains(docName)){
                System.debug('*&*&*&*&*&*&*&*&*&*&*&*&*&');
                parties = new List<genesis__Application_Parties__c>([Select id,genesis__Application__c,genesis__Party_Account_Name__c,genesis__Party_Account_Name__r.Full_Name__c,Party_Mobile_No__c,
                                                                     genesis__Party_Account_Name__r.Name,Active__c,genesis__Party_Type__c,
                                                                     genesis__Party_Account_Name__r.PersonEmail,genesis__Party_Account_Name__r.Aadhaar_Number__pc,
                                                                     genesis__Party_Account_Name__r.PersonMobilePhone,CreatedDate                                                                        
                                                                     from genesis__Application_Parties__c WHERE genesis__Party_Account_Name__r.PersonMobilePhone != null AND Active__c = true AND genesis__Application__c =: appId AND genesis__Party_Type__c ='Guarantor' order by CreatedDate asc]);
                System.debug('#$#$#$#$#$#$#$#$#'+parties);
                //isHLDocument = true;
            }
            else if(Constants.DOC_NAME_HL_COMMON.contains(docName)){
                partyTypeList.add('Guarantor');
                partyTypeList.add('Co-Borrower');
                parties = new List<genesis__Application_Parties__c>([Select id,genesis__Application__c,genesis__Party_Account_Name__c,genesis__Party_Account_Name__r.Full_Name__c,Party_Mobile_No__c,
                                                                     genesis__Party_Account_Name__r.Name,Active__c,genesis__Party_Type__c,
                                                                     genesis__Party_Account_Name__r.PersonEmail,genesis__Party_Account_Name__r.Aadhaar_Number__pc,
                                                                     genesis__Party_Account_Name__r.PersonMobilePhone,CreatedDate                                                                        
                                                                     from genesis__Application_Parties__c WHERE genesis__Party_Account_Name__r.PersonMobilePhone != null AND Active__c = true AND genesis__Application__c =: appId AND genesis__Party_Type__c IN :partyTypeList order by CreatedDate asc]);
                if(!parties.isEmpty()){
                    for(genesis__Application_Parties__c party : parties ){
                        if(party.genesis__Party_Type__c == 'Guarantor' && guarentersList.size() <= 10) guarentersList.add(party);
                        if(party.genesis__Party_Type__c == 'Co-Borrower') coBorrowersList.add(party);
                    }
                }
                
                
                isHLDocument = true;
            }
            else if(Constants.PL_DOC_DEVELOPERNAME.contains(docName)){
                appln = [Select genesis__Account__r.PersonEmail,Sanction_Doc_Generation_Check__c,Sanction_Class2_Check__c,
                         genesis__Account__r.PersonMobilePhone,Sanction_ESign_Check__c from genesis__Applications__c where Id =: appId];
                
                identifierList.add(appln.genesis__Account__r.PersonMobilePhone);
            }else if(Constants.PL2_DOC_DEVELOPERNAME.contains(docName)){
                appln = [Select genesis__Account__r.PersonEmail,Sanction_Doc_Generation_Check__c,Sanction_Class2_Check__c,
                         genesis__Account__r.PersonMobilePhone,Sanction_ESign_Check__c from genesis__Applications__c where Id =: appId];
                
                identifierList.add(appln.genesis__Account__r.PersonMobilePhone);
            }
            //VL start here
            else if(Constants.VLSANCTIONLETTER.contains(docName) || Constants.VLDEALERPYMNTAUTH.contains(docName) || Constants.VLHYPOTHECATIONLD.contains(docName)){
                partyTypeList.add(Constants.PRIMARY_APP);
                partyTypeList.add(Constants.Co_Borrower);
                parties = new List<genesis__Application_Parties__c>([Select id,genesis__Application__c,genesis__Party_Account_Name__c,genesis__Party_Account_Name__r.Full_Name__c,Party_Mobile_No__c,
                                                                     genesis__Party_Account_Name__r.Name,Active__c,genesis__Party_Type__c,
                                                                     genesis__Party_Account_Name__r.PersonEmail,genesis__Party_Account_Name__r.Aadhaar_Number__pc,
                                                                     genesis__Party_Account_Name__r.PersonMobilePhone,CreatedDate                                                                        
                                                                     from genesis__Application_Parties__c WHERE genesis__Party_Account_Name__r.PersonMobilePhone != null AND Active__c = true AND genesis__Application__c =: appId AND genesis__Party_Type__c IN :partyTypeList order by CreatedDate asc]);
               
            }//VL end here
            else if(Constants.Acknowledgement_For_SanctionLAP.contains(docName) || Constants.LAP_A23.contains(docName) || Constants.LAP_A46.contains(docName) || Constants.LAP_B1.contains(docName)){
                isHLDocument = true;
                if(Constants.Acknowledgement_For_SanctionLAP.contains(docName)){
                    partyTypeList.add('Co-Borrower');
                    partyTypeList.add('Guarantor');
                }
                if(Constants.LAP_A23.contains(docName)) partyTypeList.add('Co-Borrower');
                if(Constants.LAP_A46.contains(docName)) {
                    isHLDocument = false;
                    partyTypeList.add('Guarantor');
                }
                if(Constants.LAP_B1.contains(docName)){
                    isHLDocument = false;
                    
                }
                
                isLAPApplication = true;
                parties = new List<genesis__Application_Parties__c>([Select id,genesis__Application__c,genesis__Party_Account_Name__c,genesis__Party_Account_Name__r.Full_Name__c,Party_Mobile_No__c,
                                                                     genesis__Party_Account_Name__r.Name,Active__c,genesis__Party_Type__c,
                                                                     genesis__Party_Account_Name__r.PersonEmail,genesis__Party_Account_Name__r.Aadhaar_Number__pc,
                                                                     genesis__Party_Account_Name__r.PersonMobilePhone,CreatedDate                                                                        
                                                                     from genesis__Application_Parties__c WHERE genesis__Party_Account_Name__r.PersonMobilePhone != null AND Active__c = true AND genesis__Application__c =: appId 
                                                                     AND genesis__Party_Type__c IN : partyTypeList order by CreatedDate asc]);//query for parties
                
            }
            else{
                System.debug(docName);
                String B1_EAE = System.Label.B1_EAE;
                String GCFA_EAE = System.Label.GCFA_EAE;
                String GCFA_C1_EAE = System.Label.GCFA_C1_EAE;
                String Guarantor_Agreement_EAE = System.Label.Guarantor_Agreement_EAE;
                String Exceeding_Final_Sanction = System.Label.Exceeding_Final_Sanction;
                if(docName.contains(B1_EAE)){
                    System.debug('B1accList:::'+DigioTemplateService.B1_EAE_accList);
                    System.debug('B1_EAE');
                    parties = new List<genesis__Application_Parties__c>([Select id,genesis__Application__c,genesis__Party_Account_Name__c,genesis__Party_Account_Name__r.Full_Name__c,Party_Mobile_No__c,
                                                                         genesis__Party_Account_Name__r.Name,Active__c,genesis__Party_Type__c,
                                                                         genesis__Party_Account_Name__r.PersonEmail,genesis__Party_Account_Name__r.Aadhaar_Number__pc,
                                                                         genesis__Party_Account_Name__r.PersonMobilePhone,CreatedDate                                                                        
                                                                         from genesis__Application_Parties__c WHERE genesis__Party_Account_Name__r.PersonMobilePhone != null AND Active__c = true AND genesis__Application__c =: appId 
                                                                         AND genesis__Party_Account_Name__r.RecordType.DeveloperName ='PersonAccount' AND Signatories__c =true AND genesis__Party_Account_Name__c IN : DigioTemplateService.B1_EAE_accList order by CreatedDate asc LIMIT 7]);//query for parties
                }
                else if(docName.contains(GCFA_EAE)){
                    partyTypeList.add('Partner');
                    partyTypeList.add('Proprietor');
                    partyTypeList.add('Co-Borrower');
                    parties = new List<genesis__Application_Parties__c>([Select id,genesis__Application__c,genesis__Party_Account_Name__c,genesis__Party_Account_Name__r.Full_Name__c,Party_Mobile_No__c,
                                                                         genesis__Party_Account_Name__r.Name,Active__c,genesis__Party_Type__c,
                                                                         genesis__Party_Account_Name__r.PersonEmail,genesis__Party_Account_Name__r.Aadhaar_Number__pc,
                                                                         genesis__Party_Account_Name__r.PersonMobilePhone,CreatedDate                                                                        
                                                                         from genesis__Application_Parties__c WHERE genesis__Party_Account_Name__r.PersonMobilePhone != null AND Active__c = true AND genesis__Application__c =: appId 
                                                                         AND genesis__Party_Account_Name__r.RecordType.DeveloperName ='PersonAccount' AND Signatories__c =true AND genesis__Party_Type__c IN : partyTypeList order by CreatedDate asc LIMIT 30]);//query for parties
                }
                else if(docName.contains(GCFA_C1_EAE)){
                    parties = new List<genesis__Application_Parties__c>([Select id,genesis__Application__c,genesis__Party_Account_Name__c,genesis__Party_Account_Name__r.Full_Name__c,Party_Mobile_No__c,
                                                                         genesis__Party_Account_Name__r.Name,Active__c,genesis__Party_Type__c,
                                                                         genesis__Party_Account_Name__r.PersonEmail,genesis__Party_Account_Name__r.Aadhaar_Number__pc,
                                                                         genesis__Party_Account_Name__r.PersonMobilePhone,CreatedDate                                                                        
                                                                         from genesis__Application_Parties__c WHERE genesis__Party_Account_Name__r.PersonMobilePhone != null AND Active__c = true AND genesis__Application__c =: appId 
                                                                         AND genesis__Party_Account_Name__r.RecordType.DeveloperName ='PersonAccount' AND Signatories__c =true order by CreatedDate asc LIMIT 30]);//query for parties
                }
                else if(docName.contains(Guarantor_Agreement_EAE)){
                    parties = new List<genesis__Application_Parties__c>([Select id,genesis__Application__c,genesis__Party_Account_Name__c,genesis__Party_Account_Name__r.Full_Name__c,Party_Mobile_No__c,
                                                                         genesis__Party_Account_Name__r.Name,Active__c,genesis__Party_Type__c,
                                                                         genesis__Party_Account_Name__r.PersonEmail,genesis__Party_Account_Name__r.Aadhaar_Number__pc,
                                                                         genesis__Party_Account_Name__r.PersonMobilePhone,CreatedDate                                                                        
                                                                         from genesis__Application_Parties__c WHERE genesis__Party_Account_Name__r.PersonMobilePhone != null AND Active__c = true AND genesis__Application__c =: appId 
                                                                         AND genesis__Party_Account_Name__r.RecordType.DeveloperName ='PersonAccount' AND Signatories__c =true AND Guarantor__c = true order by CreatedDate asc LIMIT 5]);//query for parties
                }
                else if(docName.contains(Exceeding_Final_Sanction)){
                    parties = new List<genesis__Application_Parties__c>([Select id,genesis__Application__c,genesis__Party_Account_Name__c,genesis__Party_Account_Name__r.Full_Name__c,Party_Mobile_No__c,
                                                                         genesis__Party_Account_Name__r.Name,Active__c,genesis__Party_Type__c,
                                                                         genesis__Party_Account_Name__r.PersonEmail,genesis__Party_Account_Name__r.Aadhaar_Number__pc,
                                                                         genesis__Party_Account_Name__r.PersonMobilePhone,CreatedDate                                                                        
                                                                         from genesis__Application_Parties__c WHERE genesis__Party_Account_Name__r.PersonMobilePhone != null AND Active__c = true AND genesis__Application__c =: appId 
                                                                         AND genesis__Party_Account_Name__r.RecordType.DeveloperName ='PersonAccount' AND Signatories__c =true order by CreatedDate asc LIMIT 10]);//query for parties
                }
                else{
                    parties = new List<genesis__Application_Parties__c>([Select id,genesis__Application__c,genesis__Party_Account_Name__c,genesis__Party_Account_Name__r.Full_Name__c,Party_Mobile_No__c,
                                                                         genesis__Party_Account_Name__r.Name,Active__c,genesis__Party_Type__c,
                                                                         genesis__Party_Account_Name__r.PersonEmail,genesis__Party_Account_Name__r.Aadhaar_Number__pc,
                                                                         genesis__Party_Account_Name__r.PersonMobilePhone,CreatedDate                                                                        
                                                                         from genesis__Application_Parties__c WHERE genesis__Party_Account_Name__r.PersonMobilePhone != null AND Active__c = true AND genesis__Application__c =: appId 
                                                                         AND genesis__Party_Account_Name__r.RecordType.DeveloperName ='PersonAccount' AND Signatories__c =true order by CreatedDate asc]);//query for parties
                    
                }
                isSMEApplication = true;
            }
            
            if(isHLDocument){
                appln = [Select id,genesis__Account__c,genesis__Account__r.PersonEmail,genesis__Account__r.Aadhaar_Number__pc,Sanction_Doc_Generation_Check__c,Sanction_Class2_Check__c,
                         genesis__Account__r.PersonMobilePhone,Sanction_ESign_Check__c from genesis__Applications__c where Id =: appId];
                
                identifierList.add(appln.genesis__Account__r.PersonMobilePhone);
            }
            
            if(docName == Constants.SANCTION_TEMPLATE_SME || docName == Constants.SME_SANCTION_Letter123 || docName == Constants.SME_SANCTION_Letter1 
               || docName == Constants.SME_SANCTION_Letter12 || docName == Constants.SME_SANCTION_Letter13){
                   docName    = Constants.SANCTION_TEMPLATE_SME;
               }
            System.debug('parties:::'+parties.size());
            //if(!parties.isEmpty()){
            if(Constants.DOC_NAME_HL_COMMON.contains(docName)){ 
                if(!coBorrowersList.isEmpty()){
                    Integer count = 0;
                    for(genesis__Application_Parties__c party : coBorrowersList){
                        System.debug('Inside BR block');
                        brSize++;
                        identifierList.add(party.genesis__Party_Account_Name__r.PersonMobilePhone);
                        if(count == 2) break;
                        count++;
                    }
                }
                if(!guarentersList.isEmpty()){ 
                    grSize = guarentersList.size();
                    for(genesis__Application_Parties__c party : guarentersList){
                        System.debug('Inside GR block');
                        identifierList.add(party.genesis__Party_Account_Name__r.PersonMobilePhone);
                        //count++;
                    }
                }
            }
            else if(isLAPApplication){
                if(Constants.Acknowledgement_For_SanctionLAP.contains(docName)){
                    List<String> grList = new List<String>();
                    List<String> brList = new List<String>();
                    for(genesis__Application_Parties__c party : parties){
                        if(grList.size() <= 5 && party.genesis__Party_Type__c == 'Guarantor'){
                            grList.add(party.genesis__Party_Account_Name__r.PersonMobilePhone);
                        }
                        else if(brList.size() <= 4 &&  party.genesis__Party_Type__c == 'Co-Borrower'){
                            brList.add(party.genesis__Party_Account_Name__r.PersonMobilePhone);
                        }
                    }
                    if(grList.size() >0) identifierList.addAll(grList);
                    if(brList.size() >0) identifierList.addAll(brList);
                }
                else if(Constants.LAP_A23.contains(docName)){
                    for(genesis__Application_Parties__c party : parties){
                        if(identifierList.size() <= 7 && party.genesis__Party_Type__c == 'Co-Borrower') identifierList.add(party.genesis__Party_Account_Name__r.PersonMobilePhone);
                    }
                }
                else if(Constants.LAP_A46.contains(docName)){
                    for(genesis__Application_Parties__c party : parties){
                        if(identifierList.size() <= 7 && party.genesis__Party_Type__c == 'Guarantor') identifierList.add(party.genesis__Party_Account_Name__r.PersonMobilePhone);
                    }
                }
                else if(Constants.LAP_B1.contains(docName)){
                    for(Account acc : WS_eStampDocGen.accList){
                        identifierList.add(acc.PersonMobilePhone);
                    }
                }
            }
            else{
                for(genesis__Application_Parties__c party : parties){
                    if(isSMEApplication) 
                        identifierList.add(party.Id);
                    else 
                        identifierList.add(party.genesis__Party_Account_Name__r.PersonMobilePhone);
                }
            }
            
            //}
            Integer partySizeLeft = identifierList.size();
            Integer sgnerCount = 0;
            signerPageCountMap = new Map<Integer,Integer>();
            Map<Integer,List<String>> perPageSignerMap = new Map<Integer,List<String>>();
            System.debug('partySizeLeft:::'+partySizeLeft);
            List<SignerPerPage__mdt> signerPerPageList = new List<SignerPerPage__mdt>();
            if(docName.contains('B1_EAE'))
                signerPerPageList = [SELECT Page__c,SignerCount__c FROM SignerPerPage__mdt WHERE DocumentName__r.MasterLabel LIKE '%B1_EAE%'];
            else
                signerPerPageList = [SELECT Page__c,SignerCount__c FROM SignerPerPage__mdt WHERE DocumentName__r.MasterLabel =: docName];
            for(SignerPerPage__mdt sPP : signerPerPageList){
                signerPageCountMap.put((Integer)sPP.Page__c,(Integer)sPP.SignerCount__c);
            }
            pageNoList.addAll(signerPageCountMap.keySet());
            pageNoList.sort();
            System.debug('pageNoList:::'+pageNoList);
            for(Integer pageNo : pageNoList){
                if(partySizeLeft >= signerPageCountMap.get(pageNo)){
                    System.debug('If Condition');
                    for(Integer i = 0; i < signerPageCountMap.get(pageNo) ; i++){
                        if(!perPageSignerMap.keySet().contains(pageNo)){
                            perPageSignerMap.put(pageNo,new List<String>{identifierList.get(identifierList.size() - partySizeLeft+i)});
                            sgnerCount++;
                        }
                        else{
                            if(Constants.DOC_NAME_HL_COMMON.contains(docName)){
                                if(brSize > 0){
                                    perPageSignerMap.get(pageNo).add(identifierList.get(i));
                                    brSize--;
                                    sgnerCount++;
                                    if(brSize == 0) break;
                                }
                                else if(grSize > 0){
                                    perPageSignerMap.get(pageNo).add(identifierList.get(coBorrowersList.size()+i+1));
                                    sgnerCount++;
                                    grSize--;
                                }
                            }
                            else{
                                perPageSignerMap.get(pageNo).add(identifierList.get(i));
                                sgnerCount++;
                            }
                        }
                    }
                    
                    if(Constants.DOC_NAME_HL_COMMON.contains(docName) && brSize == 0) partySizeLeft = grSize;
                    else partySizeLeft -= signerPageCountMap.get(pageNo);
                }
                else{
                    System.debug('else Condition');
                    System.debug('partySizeLeft:::::'+partySizeLeft);
                    List<String> tempList = new List<string>();
                    if(partySizeLeft > 0){
                        if(Constants.DOC_NAME_HL_COMMON.contains(docName)){// && brSize == 0
                            if(pageNo == 1){
                                tempList.add(identifierList[0]);
                                sgnerCount++;
                                if(brSize > 0){
                                    Integer count  = 0;
                                    count = brSize; //< 2 ? brSize : 5;
                                    for(Integer i = 0; i < count ; i++){
                                        tempList.add(identifierList.get(i+1));
                                        sgnerCount++;
                                    }
                                    brSize = 0; 
                                }
                                perPageSignerMap.put(pageNo,tempList);
                                continue;
                            }
                            
                            if(grSize > 0){
                                Integer leftCount = grSize-1;
                                for(Integer i = sgnerCount; i < identifierList.size() ; i++){
                                    tempList.add(identifierList.get(sgnerCount));
                                    sgnerCount++;
                                }
                                partySizeLeft =0;
                            }
                        }
                        else{
                            for(Integer i = 0; i < partySizeLeft ; i++){
                                tempList.add(identifierList.get(identifierList.size()-partySizeLeft+i));
                            }
                            partySizeLeft =0;
                        }
                        
                        perPageSignerMap.put(pageNo,tempList);
                    }
                    
                    
                }
            }
            
            RETURN genCordStructure1(perPageSignerMap,totalPage,docName);
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
            RETURN null;
        }
    }
    public static Map<String,Map<Integer,List<Object>>> genCordStructure1(Map<Integer,List<String>> perPageSignerMap,Integer totalPage,String docName){
        System.debug('perPageSignerMap::'+perPageSignerMap);
        System.debug('totalPage::'+totalPage);
        System.debug('docName::'+docName);
        
        Map<String,Map<Integer,List<Object>>> finalMap = new Map<String,Map<Integer,List<Object>>>();
        List<cls_PgSigner> finalWrapper = new List<cls_PgSigner>();
        List<Cordinate__mdt> cordList = new List<Cordinate__mdt>();
        Map<Integer,Integer> stPageReferenceMap = new Map<Integer,Integer>();
        Map<Integer,Map<Integer,List<cordWrapClass>>> cordMap = new Map<Integer,Map<Integer,List<cordWrapClass>>>();
        
         if(docName.contains('B1_EAE'))
             cordList = [SELECT CordinateSequence__c,SignStartPage__c,PageVarient__c,llx__c,lly__c,urx__c,ury__c FROM Cordinate__mdt WHERE DocumentName__r.MasterLabel LIKE '%B1_EAE%' ORDER BY CordinateSequence__c asc];
         else
            cordList = [SELECT CordinateSequence__c,SignStartPage__c,PageVarient__c,llx__c,lly__c,urx__c,ury__c FROM Cordinate__mdt WHERE DocumentName__r.MasterLabel =: docName ORDER BY CordinateSequence__c asc];
         system.Debug('cordMap:-'+cordMap);
        if(!cordList.isEmpty()){
            for(Cordinate__mdt cord : cordList){
                stPageReferenceMap.put((Integer)cord.SignStartPage__c,(Integer)cord.PageVarient__c);
                if(!cordMap.keySet().contains((Integer)cord.SignStartPage__c)){
                    Map<Integer,List<cordWrapClass>> tempMap = new Map<Integer,List<cordWrapClass>>();
                    tempMap.put((Integer)cord.PageVarient__c,new List<cordWrapClass>{new cordWrapClass(cord.llx__c,cord.lly__c,cord.urx__c,cord.ury__c)});
                    cordMap.put((Integer)cord.SignStartPage__c,tempMap);
                }
                else{
                    Map<Integer,List<cordWrapClass>> tempMap = new Map<Integer,List<cordWrapClass>>();
                    cordWrapClass crd= new cordWrapClass(cord.llx__c,cord.lly__c,cord.urx__c,cord.ury__c);
                    cordMap.get((Integer)cord.SignStartPage__c).get((Integer)cord.PageVarient__c).add(crd);
                }
            }
        }
        system.Debug('cordMap:-'+cordMap);
        Map<Integer,List<Object>> tempMap;
        //Integer tempVar = 0;
        system.debug('perPageSignerMap:-'+perPageSignerMap);
        for(Integer signerKey : perPageSignerMap.keySet()){
            Integer tempVar = 0;
            if(perPageSignerMap.get(signerKey) != null && !perPageSignerMap.get(signerKey).isEmpty()){
                for(String signer : perPageSignerMap.get(signerKey)){
                    tempMap = new Map<Integer,List<Object>>();
                    if(!finalMap.keySet().contains(signer)){
                        cordWrapClass cordTemp = cordMap.get(signerKey).values().get(0).get(tempVar);
                        tempMap.put(totalPage-stPageReferenceMap.get(signerKey),new List<Object>{new cordWrapClass(cordTemp.llx,cordTemp.lly,cordTemp.urx,cordTemp.ury)});
                        finalMap.put(signer,tempMap);
                        tempVar++;
                    }
                }
            }
        }
        System.debug('finalMap:::'+finalMap);
        RETURN finalMap;
    }
    
    public static Date getNextRenewalDate(Date currentRenwalDate, string sanctionType){
        try{
            Date finalDate;
            if(sanctionType == 'Interim Extension'){
                integer month   = currentRenwalDate.month();
                integer year    = currentRenwalDate.year();
                integer day = currentRenwalDate.day();
                
                if(month == 1 || month == 2){
                    month += 1;
                    finalDate = Date.newInstance(year,month,day);
                }
                else if(month == 3){
                    finalDate = Date.newInstance(year,03,31);
                }
                else if(month <= 6){
                    month += 6;
                    finalDate = Date.newInstance(year,month,day);
                }
                else
                    finalDate = Date.newInstance(year,12,31);
            }else{
                finalDate   = currentRenwalDate.addMonths(12);
            }
            RETURN finalDate;
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
            RETURN null;
        }
    }
    
    public class cls_PgSigner{
        public Integer pgNo;
        public String signer;
        public cordWrapClass cord;
        public cls_PgSigner(Integer pgNo, String signer, cordWrapClass cord){
            this.pgNo = pgNo;
            this.signer = signer;
            this.cord = cord;
        }
    }
    public class cls_cordWrap{
        public Map<String,Map<Integer,List<Object>>> sign_coordinates;
        public cls_cordWrap(Map<String,Map<Integer,List<Object>>> sign_coordinates){
            this.sign_coordinates = sign_coordinates;
        }
    }
    public class cordWrapClass {
        public Decimal llx; 
        public Decimal lly; 
        public Decimal urx; 
        public Decimal ury; 
        public cordWrapClass(Decimal llx, Decimal lly, Decimal urx, Decimal ury){
            this.llx = llx;
            this.lly = lly;
            this.urx = urx;
            this.ury = ury;
        }
        public cordWrapClass(){}
    }
    public static Decimal processingFeeCalculation(List<Facility__c> facilityList,genesis__Applications__c app){
        finalPrFee  = 0.0;
        totalFee    = 0.0;
        docFee      = 0.0;
        cibilFee    = 0.0;
        
        decimal numberOfDays     = 0.0;
        try{
            genesis__Applications__c parentApp = new genesis__Applications__c();
            Facility__c facToUpdate = new Facility__c();
            Integer daysToRemove    = 0;
            Integer daysToAdd       = 0;

            Date NEXT_RENEW_DATE  = System.today().addDays(365);
            if(app.Parent_Application__c != null){
                parentApp= [SELECT Id,Renewal_Due_Date__c FROM genesis__Applications__c WHERE Id =: app.Parent_Application__c];
                daysToRemove    = (System.today()).daysBetween(parentApp.Renewal_Due_Date__c) - 1;
               // daysToAdd       = NEXT_RENEW_DATE.daysBetween(parentApp.Renewal_Due_Date__c) - 1;
                daysToAdd       = (parentApp.Renewal_Due_Date__c).daysBetween(NEXT_RENEW_DATE);
            }
            System.debug('#######'+parentApp);
            System.debug('#######'+parentApp);
            System.debug('#######'+daysToAdd);
            if(facilityList.size() > 0){
                /*if(app.Recordtype.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT){
                    if(facilityList[0] != null && facilityList[0].Recommended_Processing_Charge__c != null && facilityList[0].Existing_Limit__c != null && facilityList[0].New_Limit_Amount__c != null){
                        if((facilityList[0].Recommended_Limit__c-facilityList[0].Existing_Limit__c) > 0){
                            finalEnahanceFee = ((facilityList[0].Recommended_Limit__c-facilityList[0].Existing_Limit__c) * (facilityList[0].Recommended_Processing_Charge__c/100)).setScale(2);
                            system.debug('finalEnahanceFee:::'+finalEnahanceFee);
                        }
                    }
                    if(facilityList[0] != null && facilityList[0].Existing_Limit__c != null && facilityList[0].Existing_Processing_Charge__c != null && facilityList[0].application__r.Renewal_Due_Date__c != null){
                        numberOfDays = (facilityList[0].application__r.Renewal_Due_Date__c).daysBetween(System.today().addDays(365));
                        system.debug('numberOfDays:::'+numberOfDays);
                        finalExistingFee= (facilityList[0].Existing_Limit__c * (facilityList[0].Existing_Processing_Charge__c/100) * ((numberOfDays/365))).setScale(2);
                        system.debug('total:::'+(numberOfDays/365).setScale(2));
                        system.debug('facilityList[0].Existing_Limit__c:::'+facilityList[0].Existing_Limit__c);
                        system.debug('facilityList[0].Existing_Processing_Charge__c/100:::'+facilityList[0].Existing_Processing_Charge__c/100);
                        system.debug('((facilityList[0].application__r.Renewal_Due_Date__c).daysBetween(System.today().addDays(365)))/365::'+((facilityList[0].application__r.Renewal_Due_Date__c).daysBetween(System.today().addDays(365)))/365);
                        system.debug('days::'+(facilityList[0].application__r.Renewal_Due_Date__c).daysBetween(System.today().addDays(365)));
                        system.debug('finalExistingFee::'+finalExistingFee);
                    }
                }*/
                
                //facToUpdate = Underwriting_CTRL_Helper.calculatePercentageChangeInExistingFacility(facilityList[0],0.0);
                
                system.debug('inside facilityList::'+facilityList);
                for(Facility__c fac : facilityList){
                    Decimal prFee = 0.0;
                    Decimal perdayProvCharge           = 0.00;
                    Decimal feeToremove                = 0.00;
                    Decimal exLimit                    = 0.00;
                    Decimal exProcFee                  = 0.00;
                    Decimal recLimitForNewLoan         = 0.00;
                    Decimal recRateForNewLoan          = 0.00;
                    Integer days                       = 0;
                    decimal finalEnahanceFee           = 0.0;
                    Decimal finalExistingFee           = 0.0;
                    Decimal finalRenewalFee            = 0.0;
                    if(app.Record_Type_Name__c == Constants.SME_RECORD_TYPE_LABEL_ENHANCEMENT){
                        system.debug('fac.Facility_Application_Type__c::'+fac.Facility_Application_Type__c);
                        if(fac.Facility_Application_Type__c == 'Enhancement'){
                            if(fac != null && fac.Recommended_Processing_Charge__c != null && fac.Existing_Limit__c != null && fac.New_Limit_Amount__c != null){
                                if((fac.Recommended_Limit__c-fac.Existing_Limit__c) > 0){
                                    finalEnahanceFee = ((fac.Recommended_Limit__c-fac.Existing_Limit__c) * (fac.Recommended_Processing_Charge__c/100)).setScale(2);
                                    system.debug('finalEnahanceFee:::'+finalEnahanceFee);
                                }
                            }
                            if(fac != null && fac.Existing_Limit__c != null && fac.Existing_Processing_Charge__c != null && fac.application__r.Renewal_Due_Date__c != null){
                                numberOfDays = (fac.application__r.Renewal_Due_Date__c).daysBetween(System.today().addDays(365));
                                system.debug('numberOfDays:::'+numberOfDays);
                                finalExistingFee= (fac.Existing_Limit__c * (fac.Renewal_Processing_Charge__c/100) * ((numberOfDays/365))).setScale(2);
                                system.debug('finalExistingFee::'+finalExistingFee);
                            }
                        }else if(fac.Facility_Application_Type__c == 'Renewal'){
                            if(fac.application__r.Renewal_Due_Date__c != null)
                                days = (fac.application__r.Renewal_Due_Date__c).daysBetween(System.today().addDays(365));
                            if(fac.Recommended_Limit__c != null && fac.Recommended_Processing_Charge__c != null)
                                finalRenewalFee = (fac.Recommended_Limit__c * (fac.Recommended_Processing_Charge__c/100) * days/365).setScale(2);
                            system.debug('days::'+days+' '+'finalRenewalFee::'+finalRenewalFee);
                        }
                    }
                    
                    if(fac.Existing_Limit__c != null){
                        exLimit = fac.Existing_Limit__c;
                    }
                    if(fac.Recommended_Limit__c != null){
                        recLimitForNewLoan = fac.Recommended_Limit__c;
                    }
                    if(fac.Recommended_Processing_Charge__c != null){
                        recRateForNewLoan  = fac.Recommended_Processing_Charge__c;
                        system.debug('recRateForNewLoan:::'+recRateForNewLoan);
                    }
                    System.debug('#######'+fac);
                    System.debug('#######daysToAdd'+daysToAdd);
                    
                    if(fac.Existing_Enhanced_Processing_Fee__c!= null){
                        exProcFee= fac.Existing_Enhanced_Processing_Fee__c;
                    }
                    if(app.Record_Type_Name__c == Constants.SME_NEW_LOAN_RECORD_TYPE_LABEL){
                        prFee = recLimitForNewLoan * (recRateForNewLoan/100);
                    }else{
                        prfee = finalEnahanceFee + finalExistingFee + finalRenewalFee;
                        /*if(daysToAdd>0)
                            prFee = (((exLimit * (exProcFee)/100)/365)*daysToAdd + (fac.Limit_Amount__c - exLimit) * (fac.Final_Enhanced_Processing_Fee__c)/100 );
                        else
                            prFee = (((exLimit * (exProcFee)/100)/365) + (fac.Limit_Amount__c - exLimit) * (fac.Final_Enhanced_Processing_Fee__c)/100 );*/
                        
                    }
                    
                    finalPrFee += prFee;
                }
                System.debug('@@@@@@@@ finalPrFee'+finalPrFee);
                docFee      += docChargeCalculation(SanctionMatrixControllerHelper_EA.getLimitAmountAggregate(facilityList));
                cibilFee    += KVB_Company_Details__c.getOrgDefaults().Cibil_Charges__c;
                cibilFee    += KVB_Company_Details__c.getOrgDefaults().Person_Cibil_Charges__c *getPartyCount(app.Id);
                System.debug('@@@@@@@@ docFee'+docFee);
                System.debug('@@@@@@@@ cibilFee'+cibilFee);
                System.debug('@@@@@@@@'+finalPrFee);
                totalFee    += finalPrFee;
                totalFee    += cibilFee;
                totalFee    += docFee;
                System.debug('@@@@@@@@ totalFee'+totalFee);
            }
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
            
        }
        
        RETURN finalPrFee;
    }
    Public static Integer getPartyCount(String appId){
        return [Select COUNT() from genesis__Application_Parties__c where genesis__Application__c=:appId];
    }
    public static Decimal docChargeCalculation(Decimal existingLimit){
        Decimal docChharge = 0.0;
        if(existingLimit < 500000) docChharge = 0;
        if(existingLimit >= 500000   && existingLimit   < 1000000) docChharge  = 750;
        if(existingLimit >= 1000000  && existingLimit   < 2500000) docChharge  = 2000;
        if(existingLimit >= 2500000  && existingLimit   < 5000000) docChharge  = 3500;
        if(existingLimit >= 5000000  && existingLimit   < 10000000) docChharge = 6500;
        if(existingLimit >= 10000000 && existingLimit   < 50000000) docChharge = 10000;
        if(existingLimit > 50000000) docChharge = 15000;
        RETURN docChharge;
    }
    
    public static void documentDetails(){
        Map<Id,genesis__Applications__c> appMap = new Map<Id,genesis__Applications__c>();
        appMap = new Map<Id,genesis__Applications__c>([SELECT Id,Name,(SELECT ID,Name FROM Digio_Documnet_ID__r) FROM genesis__Applications__c WHERE RecordType.developername = 'SME_Renewal'AND Application_Stage__c IN ('Interim sanction offered','Final Sanction Offered','E-sign pending','E-sign pending-final')]);
        
    }
    public static String getRMDUserAssign(String appId){                
        List <ID> IdList = new List <ID>();
		List<User> usrList = new List<User>();
		usrList = [SELECT Id FROM User WHERE Designation__c = 'RMD' AND isActive = true];
        for(User u : usrList){
            IdList.add(u.Id);
        }
        Map<ID,Integer> mapTsk = new Map<ID,Integer>();
        List<Task> tskList = [Select Id,OwnerId,Subject,Status,WhatId From Task where OwnerId IN:IdList AND Status != 'Completed' AND  WhatId =: appId];
        for(Task t : tskList){
            if(mapTsk.keySet().contains(t.OwnerId)){
                mapTsk.put(t.OwnerId,mapTsk.get(t.OwnerId)+1);
				//system.debug('mapTsk***'+mapTsk);
            }
            else{
                mapTsk.put(t.OwnerId,1);
				//system.debug('mapTsk***'+mapTsk);
            }
        }
        for(Id uId : IdList){
            if(!mapTsk.containsKey(uId )){
                mapTsk.put(uId , 0);
            }
        }      
        String minSize = null;
        for(String str : mapTsk.keyset()){
            if(minSize==null||mapTsk.get(str)<mapTsk.get(minSize))
                minSize = str;
        }
        system.debug('###'+minSize);                
        return minSize;
    }
}