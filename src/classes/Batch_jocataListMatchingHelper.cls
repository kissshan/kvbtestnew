public class Batch_jocataListMatchingHelper {
   
    public static Map<String,String> getJocataTocken(genesis__Applications__c appObj){
        Set<String> custIdSet = new Set<String>();
       List<Account> accList = new List<Account>();
        List<Account> accListToProcess = new List<Account>();
        Map<String,String> custIdTxIdMap = new Map<String,String>();
        
        Datetime dt;
        Date crtDate;
        List<genesis__Application_Parties__c> partyList = new List<genesis__Application_Parties__c>();
               
        custIdSet.add(appObj.genesis__Account__c);
        for(genesis__Application_Parties__c party : appObj.genesis__Application_Parties__r){
            custIdSet.add(party.genesis__Party_Account_Name__c);
        }
        
        accList = [SELECT Id,Name,CBS_Customer_ID__c,PersonBirthdate,PersonMailingStreet,PersonMailingCity,PersonMailingState,PersonMailingCountry,Nationality__pc,
        Driving_License_ID__c,Pan_Number__c,BillingStreet,BillingState,BillingCity,BillingPostalCode,BillingCountry,Aadhaar_Number__pc,Ration_Card__c,PersonMobilePhone,Phone,
        PersonEmail,Jocata_TxnId__c,(SELECT Id,Name,CreatedDate FROm List_Matchings__r ORDER By CreatedDate DESC) FROM Account WHERE Id IN : custIdSet];
        
        //Datetime dt = Date.today().addDays(-90);
        for(Account acc : accList){
            if(acc.List_Matchings__r.size() > 0){
                dt          = acc.List_Matchings__r[0].CreatedDate;
                crtDate     = date.newinstance(dT.year(), dT.month(), dT.day());
            }
            System.debug('Txn Id--> ' + acc.Jocata_TxnId__c);
            if((acc.Jocata_TxnId__c == null || acc.Jocata_TxnId__c == '') ||((acc.List_Matchings__r.size() > 0) && (crtDate.daysBetween(Date.today()) > 90))){
                accListToProcess.add(acc);
            }
        }

        try{
            
            for(Account acc : accListToProcess){
                JocataListMatching_Model.JocataLMRequest jlmReq = new JocataListMatching_Model.JocataLMRequest();
            
                jlmReq.name                 = Utility.getBlankStringIfNull(acc.Name); 
                jlmReq.customerId           = Utility.getBlankStringIfNull(acc.CBS_Customer_ID__c); 
                
                if(acc.PersonBirthdate != null)
                jlmReq.dob                  = Utility.getBlankStringIfNull(Utility.dateFormatter(acc.PersonBirthdate));   
                    
                jlmReq.address              = Utility.getBlankStringIfNull(acc.BillingStreet);   
                jlmReq.city                 = Utility.getBlankStringIfNull(acc.BillingCity);    
                jlmReq.state                = Utility.getBlankStringIfNull(acc.BillingState);  
                jlmReq.country              = Utility.getBlankStringIfNull(acc.BillingCountry);  
                jlmReq.nationality          = Utility.getBlankStringIfNull(acc.Nationality__pc);   
                jlmReq.panId                = Utility.getBlankStringIfNull(acc.Pan_Number__c);   
                jlmReq.driverlicenseid      = Utility.getBlankStringIfNull(acc.Driving_License_ID__c); 
                jlmReq.adharNo              = Utility.getBlankStringIfNull(acc.Aadhaar_Number__pc);    
                jlmReq.rationCardNo         = Utility.getBlankStringIfNull(acc.Ration_Card__c);   
                jlmReq.phone1               = Utility.getBlankStringIfNull(acc.PersonMobilePhone);  
                jlmReq.phone2               = Utility.getBlankStringIfNull(acc.Phone);  
                jlmReq.email                = Utility.getBlankStringIfNull(acc.PersonEmail);
                    
                string reqStr = JSON.serialize(jlmReq);
                System.debug('req ::: '+reqStr);
                custIdTxIdMap.put(acc.Id,makeJocataCall(reqStr));
            }
            return custIdTxIdMap;//makeJocataCall(reqStr);     
                                        
        }catch(Exception Ex){
            System.debug('Exception'+ex.getMessage()+ex.getLineNumber());
            return null;
        }
    }
    
    public static string getJocataTxnforAcc(Account accountInfo){
        try{
            JocataListMatching_Model.JocataLMRequest jlmReq = new JocataListMatching_Model.JocataLMRequest();
            jlmReq.name= Utility.getBlankStringIfNull(accountInfo.Name); 
            jlmReq.customerId= Utility.getBlankStringIfNull(accountInfo.CBS_Customer_ID__c); 
            if(accountInfo.PersonBirthdate != null)
                jlmReq.dob= Utility.getBlankStringIfNull(Utility.dateFormatter(accountInfo.PersonBirthdate));   
            jlmReq.address= Utility.getBlankStringIfNull(accountInfo.BillingStreet);   
            jlmReq.city= Utility.getBlankStringIfNull(accountInfo.BillingCity);    
            jlmReq.state= Utility.getBlankStringIfNull(accountInfo.BillingState);  
            jlmReq.country= Utility.getBlankStringIfNull(accountInfo.BillingCountry);  
            jlmReq.nationality= Utility.getBlankStringIfNull(accountInfo.Nationality__pc);   
            jlmReq.panId= Utility.getBlankStringIfNull(accountInfo.Pan_Number__c);   
            jlmReq.driverlicenseid= Utility.getBlankStringIfNull(accountInfo.Driving_License_ID__c); 
            jlmReq.adharNo= Utility.getBlankStringIfNull(accountInfo.Aadhaar_Number__pc);    
            jlmReq.rationCardNo= Utility.getBlankStringIfNull(accountInfo.Ration_Card__c);   
            jlmReq.phone1= Utility.getBlankStringIfNull(accountInfo.PersonMobilePhone);  
            jlmReq.phone2= Utility.getBlankStringIfNull(accountInfo.Phone);  
            jlmReq.email= Utility.getBlankStringIfNull(accountInfo.PersonEmail);
            
            string reqStr = JSON.serialize(jlmReq);
            System.debug('req '+reqStr);
            return makeJocataCall(reqStr);                       
        }catch(Exception Ex){
            System.debug('Exception'+ex.getMessage()+ex.getLineNumber());
            return null;
        }
    }
    
    public static string makeJocataCall(String requestString){
        HTTPResponse response = new HTTPResponse();
        Map<String,String> headerMap = new Map<String,String>();  
        headerMap.put('Content-Type','application/json'); 
        headerMap.put('Authorization',WS_ApiGatewayAccToken.getAccTkn());
        System.debug('Header'+headerMap); //Listmatching
        response = HttpUtility.sendHTTPRequest(Utility.getFullEndpoints('Listmatching'), 'POST', null,requestString,headerMap,null);
        
        System.debug('@@@@ response.getStatusCode()'+response.getStatusCode());
        System.debug(response.getBody());
        
        if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
            
            String jsonData = response.getBody();
            JocataListMatching_Model.JocataLMResponse jlmRes = (JocataListMatching_Model.JocataLMResponse)Json.deserialize(jsonData, JocataListMatching_Model.JocataLMResponse.class);
            
            return String.ValueOf(jlmRes.evokeResponse.txnId);
            
        }else{
            return null;
        }
    }
}