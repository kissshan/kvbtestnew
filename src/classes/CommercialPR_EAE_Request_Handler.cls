/*
 * Name     : CommercialPR_EAE_Request_Handler
 * Company  : ET Marlabs
 * Purpose  : Handler class  for CommercialPR_EAE_Request class. 
 * Author   : Raushan
*/
global class CommercialPR_EAE_Request_Handler {
    
    global static String Business_Name  ='';
    public static String customerType     = 'LAP';
    public static String NEW_APPLICATION_TYPE = 'SME_NEW_LOAN';
    public static String RecordTypeDeveloperName = '';
    
    public static CommercialPR_EAE_Request getRequest(String custIDList,String Type, String appId){
        try{
            Account accountObj  = [select id,Name,Pan_Number__c,CBS_Customer_ID__c,Date_of_Incorporation__c,Constitution__c,CIN_Number__c,BillingCity,BillingState,BillingPostalCode,BillingStreet,Relationship_with_Firm__c from Account where CBS_Customer_ID__c =: custIDList];
            List<genesis__Application_Parties__c>   listParties;
            If(Type !=customerType && Type != NEW_APPLICATION_TYPE && appId !=null && appId !=''){
                listParties = [select id,genesis__Application__r.RecordType.DeveloperName,genesis__Party_Type__c,Key_Contact__c,Key_Contact__r.Name,Key_Contact__r.Pan_Number__c,Key_Contact__r.CBS_Customer_ID__c,
                               Key_Contact__r.Date_of_Incorporation__c,Key_Contact__r.Constitution__c,Key_Contact__r.CIN_Number__c,Key_Contact__r.RecordType.DeveloperName,
                               Key_Contact__r.BillingCity,Key_Contact__r.BillingState,Key_Contact__r.BillingPostalCode,Key_Contact__r.BillingStreet,genesis__Party_Account_Name__r.Name,
                               genesis__Party_Account_Name__c,genesis__Party_Account_Name__r.PersonMailingStreet,genesis__Party_Account_Name__r.Cust_mobile_phone__c,genesis__Application__c,
                               genesis__Party_Account_Name__r.PersonMailingCity,genesis__Party_Account_Name__r.PersonMailingState,genesis__Party_Account_Name__r.Pan_Number__c,genesis__Party_Account_Name__r.Aadhaar_Number__pc,
                               genesis__Party_Account_Name__r.PersonBirthdate,genesis__Party_Account_Name__r.Gender__pc,genesis__Party_Account_Name__r.CBS_Customer_ID__c,
                               genesis__Party_Account_Name__r.PersonMailingPostalCode,genesis__Party_Account_Name__r.RecordType.DeveloperName from genesis__Application_Parties__c 
                               where genesis__Application__c =: appId AND Active__c = true];
            }

            if(Type != 'SME_NEW_LOAN' && Type !='LAP'){
                RecordTypeDeveloperName = listParties[0].genesis__Application__r.RecordType.DeveloperName;    
            }else if(Type == 'SME_NEW_LOAN'){
                RecordTypeDeveloperName     =   'SME_NEW_Loan';
            }

            CommercialPR_EAE_Request commercialPR_Instance          = new CommercialPR_EAE_Request();
            String gSTStateCode = '';
            Integer noOfDirectors = 0;
            Map<id,String> mapAccountObj                           = new Map<id,String>();
            //ApplicantsData
            commercialPR_Instance.applicantsData                    = new List<CommercialPR_EAE_Request.ApplicantsData>();
            If(accountObj !=null){
                gSTStateCode                                            =   Utility.getBlankStringIfNull(accountObj.BillingState);
                CommercialPR_EAE_Request.ApplicantsData applicantDataObj    =   new CommercialPR_EAE_Request.ApplicantsData();
                commercialPR_Instance.applicantsData.add(getBusinnessApplicantData(accountObj,applicantDataObj,type,accountObj));    
            }
            commercialPR_Instance.applicationData                   =   new CommercialPR_EAE_Request.ApplicationData();
            commercialPR_Instance.applicationData.GSTStateCode      =   gSTStateCode;
            If(listParties !=null){
                for(genesis__Application_Parties__c partiesObj          :   listParties) {
                    
                    If(mapAccountObj.containsKey(partiesObj.Key_Contact__r.id)){
                        
                    }else{
                        noOfDirectors=0;
                        mapAccountObj.put(partiesObj.Key_Contact__r.id, partiesObj.Key_Contact__r.Name);
                    }
                    If(mapAccountObj.containsKey(partiesObj.genesis__Party_Account_Name__r.id)){
                        
                    }else{
                        noOfDirectors++;
                        CommercialPR_EAE_Request.ApplicantsData applicantDataObj    =   new CommercialPR_EAE_Request.ApplicantsData();
                        commercialPR_Instance.applicantsData.add(getPersonApplicantData(partiesObj,applicantDataObj));
                        mapAccountObj.put(partiesObj.genesis__Party_Account_Name__r.id, partiesObj.genesis__Party_Account_Name__r.Name);
                    }
                }
            }
            commercialPR_Instance.applicationData.NoOfDirector      =   String.valueOf(noOfDirectors);
            If(noOfDirectors==0){
                commercialPR_Instance.applicationData.ConsumerCIR   =   Constants.CONSUMER_CIR_FALSE;
            }else{
                commercialPR_Instance.applicationData.ConsumerCIR   =   Constants.CONSUMER_CIR_TRUE;
            }
            System.debug('List of commercialPR'+commercialPR_Instance);
            return commercialPR_Instance;    
        }catch(Exception ex){
        	System.debug('Exception ::'+ex.getMessage() + 'Line Number'+ex.getLineNumber());    
        }
        return null;
    }
    public static CommercialPR_EAE_Request.ApplicantsData getBusinnessApplicantData(Account accountObj,CommercialPR_EAE_Request.ApplicantsData applicantDataObj,String type,Account accountObjct){
        
        applicantDataObj.ApplicantType                      =   Constants.APPLICANT_TYPE_COMPANY;  //Company
            
        applicantDataObj.CIN                                =   Utility.getBlankStringIfNull(accountObj.CIN_Number__c);
            
        applicantDataObj.PAN                                =   Utility.getBlankStringIfNull(accountObj.Pan_Number__c);
        applicantDataObj.CompanyName                        =   Utility.getBlankStringIfNull(accountObj.Name);
        Business_Name                                       =   Utility.getBlankStringIfNull(accountObj.Name);
        applicantDataObj.ClassOfActivity                    =   Constants.CLASS_OF_ACTIVITY;
        String Entity = accountObjct.Relationship_with_Firm__c;
        if(Entity == null){
            If(accountObj.Constitution__c == Constants.HUF) {
                applicantDataObj.TypeOfEntity    =   Constants.HINDU_UNDIVIDED_FAMILY;    
            }else if(accountObj.Constitution__c  == Constants.LLP || accountObj.Constitution__c == Constants.COMPANIES){
                applicantDataObj.TypeOfEntity    =   Constants.NOT_CLASSIFIED;
            }else if(accountObj.Constitution__c == 'Partnership'){
                applicantDataObj.TypeOfEntity = 'PARTNERSHIP';
            }else if(accountObj.Constitution__c == 'Private Limited Company'){
                applicantDataObj.TypeOfEntity = 'PRIVATE LIMITED';
            }else if(accountObj.Constitution__c == 'Sole Proprietorship' ||accountObj.Constitution__c =='SOLE PROPREITOR'){
                applicantDataObj.TypeOfEntity = 'PROPRIETORSHIP';
            }else if(accountObj.Constitution__c == 'Public Limited Company'){
                applicantDataObj.TypeOfEntity = 'PUBLIC LIMITED';
            }
            else{
                applicantDataObj.TypeOfEntity                   =   Utility.getBlankStringIfNull(accountObj.Constitution__c);
            }  
        }else{
            if(Entity == 'Partnership'){
                applicantDataObj.TypeOfEntity = 'PARTNERSHIP';
            }else if(Entity == 'Private Limited Company'){
                applicantDataObj.TypeOfEntity = 'PRIVATE LIMITED';
            }else if(Entity == 'Sole Proprietorship'){
                applicantDataObj.TypeOfEntity = 'PROPRIETORSHIP';
            }else if(Entity == 'Public Limited Company'){
                applicantDataObj.TypeOfEntity = 'PUBLIC LIMITED';
            }else{
                applicantDataObj.TypeOfEntity = 'NOT CLASSIFIED';
            }
        }
        if(type == 'LAP' || type == 'SME_NEW_LOAN'){
            applicantDataObj.DateOfRegistration                 =   String.valueOf(system.today());
        }else{
            applicantDataObj.DateOfRegistration                 =   Utility.getBlankStringIfNull(String.valueOf(accountObj.Date_of_Incorporation__c));   
        }        
        applicantDataObj.RegisteredAddress                  =   new CommercialPR_EAE_Request.RegisteredAddress();
        applicantDataObj.RegisteredAddress.AddressType      =   Constants.REGISTERED_OFFICE;
        applicantDataObj.RegisteredAddress.AddressLine1     =   Utility.getBlankStringIfNull(accountObj.BillingStreet);
        applicantDataObj.RegisteredAddress.AddressCity      =   Utility.getBlankStringIfNull(accountObj.BillingCity);
        applicantDataObj.RegisteredAddress.AddressStateCode =   Utility.getBlankStringIfNull(accountObj.BillingState);
        applicantDataObj.RegisteredAddress.AddressPincode   =   Utility.getBlankStringIfNull(accountObj.BillingPostalCode);
        //applicantDataObj.OtherAddresses                   =   new CommercialPR_EAE_Request.OtherAddresses();
       // applicantDataObj.OtherAddresses.OtherAddress      =   new List<CommercialPR_EAE_Request.RegisteredAddress>();
        //CommercialPR_EAE_Request.RegisteredAddress    regisOBj =  new CommercialPR_EAE_Request.RegisteredAddress();
        //regisOBj.AddressType                                  =   Constants.REGISTERED_OFFICE;
        //regisOBj.AddressLine1                                 =   Utility.getBlankStringIfNull(partiesObj.Key_Contact__r.BillingStreet);
        //regisOBj.AddressCity                                  =   Utility.getBlankStringIfNull(partiesObj.Key_Contact__r.BillingCity);
        //regisOBj.AddressStateCode                             =   Utility.getBlankStringIfNull(partiesObj.Key_Contact__r.BillingState);
        //regisOBj.AddressPincode                               =   Utility.getBlankStringIfNull(partiesObj.Key_Contact__r.BillingPostalCode);
        //applicantDataObj.OtherAddresses.OtherAddress.add(regisOBj);
        applicantDataObj.MemberReferenceNumber              =   Utility.getBlankStringIfNull(accountObj.CBS_Customer_ID__c);
        applicantDataObj.FacilityCategory                   =   Constants.Others;
        //applicantDataObj.FacilityType                       =   Constants.RENEWAL_ENHANCEMENT;

        //Newly Added ------ Souvik
        if(RecordTypeDeveloperName == 'SME_NEW_Loan') applicantDataObj.FacilityType =   'New Loan';
        else applicantDataObj.FacilityType                                          =   Constants.RENEWAL_ENHANCEMENT;    
        
        return applicantDataObj; 
    }
    public static CommercialPR_EAE_Request.ApplicantsData getPersonApplicantData(genesis__Application_Parties__c partiesObj,CommercialPR_EAE_Request.ApplicantsData applicantDataObj){
        
        applicantDataObj.ApplicantType                      =   Constants.APPLICANT_TYPE_DIRECTOR;  //Director
        applicantDataObj.ApplicantFirstName                 =   Utility.getBlankStringIfNull(partiesObj.genesis__Party_Account_Name__r.Name);
        applicantDataObj.DateOfBirth                        =   Utility.getBlankStringIfNull(String.valueOf(partiesObj.genesis__Party_Account_Name__r.PersonBirthdate));
        applicantDataObj.Gender                             =   Utility.getBlankStringIfNull(String.valueOf(partiesObj.genesis__Party_Account_Name__r.Gender__pc));
        applicantDataObj.MemberReferenceNumber              =   Utility.getBlankStringIfNull(partiesObj.genesis__Party_Account_Name__r.CBS_Customer_ID__c);
        applicantDataObj.CompanyName                        =   Business_Name;
        applicantDataObj.Identifiers                        =   new CommercialPR_EAE_Request.Identifiers();        
        applicantDataObj.Identifiers.Identifier             =   new List<CommercialPR_EAE_Request.Identifier>();
        CommercialPR_EAE_Request.Identifier identifierObj   =   new CommercialPR_EAE_Request.Identifier();
        if(partiesObj.genesis__Party_Account_Name__r.Pan_Number__c != null){
            identifierObj.IdType                                =   'Pan Card';
            identifierObj.IdNumber                              =   Utility.getBlankStringIfNull(partiesObj.genesis__Party_Account_Name__r.Pan_Number__c);
        }else if(partiesObj.genesis__Party_Account_Name__r.Aadhaar_Number__pc != null){
            identifierObj.IdType                                =   'UID_REFERENCE_KEY';
            identifierObj.IdNumber                              =   Utility.getBlankStringIfNull(partiesObj.genesis__Party_Account_Name__r.Aadhaar_Number__pc);
        }


        applicantDataObj.Identifiers.Identifier.add(identifierObj);
        applicantDataObj.Addresses                          =   new CommercialPR_EAE_Request.Addresses();
        applicantDataObj.Addresses.Address                  =   new List<CommercialPR_EAE_Request.Address>();
        CommercialPR_EAE_Request.Address    addressObj      =   new CommercialPR_EAE_Request.Address();
        addressObj.AddressType                              =   'Permanent Address';
        addressObj.ResidenceType                            =   'Owned';
        addressObj.AddressLine1                             =   Utility.getBlankStringIfNull(partiesObj.genesis__Party_Account_Name__r.PersonMailingStreet);
        addressObj.City                                     =   Utility.getBlankStringIfNull(partiesObj.genesis__Party_Account_Name__r.PersonMailingCity);
        addressObj.PinCode                                  =   Utility.getBlankStringIfNull(partiesObj.genesis__Party_Account_Name__r.PersonMailingPostalCode);
        addressObj.StateCode                                =   Utility.getBlankStringIfNull(partiesObj.genesis__Party_Account_Name__r.PersonMailingState);
        applicantDataObj.Addresses.Address.add(addressObj);

        //Newly Added RelationType in 'applicantsData' structure For TU Request ------ Souvik
        if(partiesObj.genesis__Party_Type__c != '' && partiesObj.genesis__Party_Type__c != null){
            applicantDataObj.RelationType = partiesObj.genesis__Party_Type__c;
        }
        else{
            applicantDataObj.RelationType = '';
        }

        return applicantDataObj;   
    }
}