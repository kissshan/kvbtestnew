/*
* Name      : WS_AstuteCallingAPI
* Compnay   : ET Marlabs
* Purpose   : Field Investigation Astute Request API 1
* Author    : Ashok
-----------------------------------------------------------------------
Version     Date            Author          Remarks                                                 
=======     ==========      =============   ==================================
v1.1        27-Aug-2018     Braj            Addition of record type 'Vehicle loan' for FI call and addition of productname 'VehicleLN' for api call
v1.2        20-Dec-2018     Braj            Addition of manual astute changes and pincode master
*******************************************************************************************/
public class WS_AstuteCallingAPI {
    public static string applicationId;
    public static Map<String,astuteWrap> mapCNidToAstuteWrp=new Map<String,astuteWrap>();//v1.2
    public static map<String,String> mapPincodeToAstuteService = new map<String,String>();//v1.2
    public static boolean isRetry;
    
    public static void callAstute(String AppId,String caseid,String PropType){
        try {
            System.debug('inside WS_AstuteCallingAPI ***@@@'+AppId);
            applicationId=AppId;
            isRetry=false;
            String ProductType = '';
            String PickUpDate = String.valueOf(System.now());
            
            //Remodel data structure
            List <genesis__Application_Parties__c> FIAccList = new List<genesis__Application_Parties__c>();
            List <genesis__Application_Parties__c> RFIAccList = new List<genesis__Application_Parties__c>();
            
            //List<Account> NewListFI =  new List<Account>();
            List<genesis__Application_Parties__c> NewListFI =  new List<genesis__Application_Parties__c>();
            Set<id> OldListFI = new Set<id>();
            
            // To check is any existing Astute record is there.        
            List<Astute_Verification__c> astList = queryService.getAstuteRecord(applicationId);
            WS_AstuteCallingAPI.AstueRequest astutereqObj=new WS_AstuteCallingAPI.AstueRequest();
            astutereqObj.Case145_089 = new List<cls_Case>();
            genesis__Applications__c application = queryService.getApplication(AppId);
            
            //Adding Product Name
            if(application.Record_Type_Name__c == Constants.PERSONALLOAN){
                ProductType = 'PRSNLN';
            }else if(application.Record_Type_Name__c == Constants.LAPLOAN){
                ProductType = 'LNALAP';
            }else if(application.Record_Type_Name__c == Constants.HOMELOAN){
                ProductType = 'HOMELN';
            }else if(application.Record_Type_Name__c == Constants.VL2W || application.Record_Type_Name__c == Constants.VL4W){//v1.1
                ProductType = 'VHCLLN';
            }
            List<Account> accList = accList(AppId);
            List<genesis__Application_Parties__c> partydetails=partylist(AppID);
            //integer cnt = 0;
            System.debug('##DataLog partylist ### --- > '+ partydetails);
            // re run astute api
            if(partydetails.size() > 0){
                //NewListFI.addAll(partydetails);
                for(Astute_Verification__c astl:astList){
                    OldListFI.add(astl.Account__c);
                }
                System.debug('## OldListFI ### --- > '+ OldListFI);
                
                for(genesis__Application_Parties__c att:partydetails){
                    if(OldListFI.size() >= 0 && !OldListFI.contains(att.genesis__Party_Account_Name__c)){
                        NewListFI.add(att);
                    }
                }
                partydetails.clear();
                partydetails.addAll(NewListFI);
                System.debug('## FI final ### --- > '+ partydetails);
            }
            //-----end of rerun astute-----------------------------
            
            for(genesis__Application_Parties__c party: partydetails){

                // PL Logic start here--------------------
                if(application.Record_Type_Name__c == Constants.PERSONALLOAN){

                    if(party.genesis__Party_Type__c == Constants.PRIMARY_APP){
                        RFIAccList.add(party);
                        if(party.Employment_Types__c==Constants.EMPTYP_SALARIED || party.Employment_Types__c==Constants.EMPTYP_SELFEMPB){
                            FIAccList.add(party);
                        }
                    }
                }
                // PL Logic ends here-------------------------

                //VL/LAP Logic start here--------------------
                if(application.Record_Type_Name__c  == Constants.VL4W || application.Record_Type_Name__c  == Constants.VL2W || application.Record_Type_Name__c==Constants.LAPLOAN) {
                    //FI will trigger for both financial and non-financial parties;Non-exempted will go for FI
                    if(!party.FI_Exempted__c) {
                        if(party.Key_Contact__r.RecordType.DeveloperName == Constants.BUSINESS_ACCOUNT) 
                            FIAccList.add(party);
                        else {
                            RFIAccList.add(party);
                            if(party.Employment_Types__c==Constants.EMPTYP_SALARIED)
                                FIAccList.add(party);
                        }
                    }
                }
                //VL/LAP Logic End here--------------------

                //HL Logic start here--------------------
                if(application.Record_Type_Name__c==Constants.HOMELOAN) {
                    //FI will trigger for both financial and non-financial parties;Non-exempted will go for FI
                    if(!party.FI_Exempted__c){
                        RFIAccList.add(party);
                        if(party.Employment_Types__c==Constants.EMPTYP_SALARIED || party.Employment_Types__c==Constants.EMPTYP_SELFEMPB){
                            FIAccList.add(party);
                        }
                    }
                }
                //HL Logic End here--------------------

                System.debug(RFIAccList.size()+'==RFIAccList=='+RFIAccList);
                System.debug(FIAccList.size()+'==FIAccList=='+FIAccList); 
            }
            
            //+++++++++++++++++++++++++++++++++++Office Request creation start here++++++++++++++++++
            if(FIAccList.size() > 0 && (PropType == null || PropType == '' || PropType == Constants.ACTIVITY_DESCO)){
                // loop for office
                for(genesis__Application_Parties__c party: FIAccList){
                    WS_AstuteCallingAPI.cls_Case cbsInput = new WS_AstuteCallingAPI.cls_Case();
                    if(caseid ==null || caseid==''){
                        String dts = CreateUniqueId.uniqID();
                        cbsInput.NotificationId = dts.substring(0,dts.length()-PickUpDate.length())+PickUpDate;
                    }else{
                        cbsInput.NotificationId=caseid;
                    }
                    cbsInput.ApplicationNumber=AppId;
                    cbsInput.ApplicantId= party.genesis__Party_Account_Name__c;
                    cbsInput.ActivityDescription=Constants.ACTIVITY_DESCO;
                    cbsInput.ProductName = ProductType;
                    if(!Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.Name))
                        cbsInput.ApplicantName=party.genesis__Party_Account_Name__r.Name;    //Sagar
                    cbsInput.ApplicantType=Constants.BORROWER_TYPE; //Borrower
                    if(!Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.Pan_Number__c))    
                        cbsInput.PAN=party.genesis__Party_Account_Name__r.Pan_Number__c; //ABCDE1234G
                    
                    /// logic for  assigining address for salaried account and self employed buisness
                    if(!Utility.ISStringBlankorNull(party.Employment_Types__c)){
                        
                        /// for salaried
                        if(party.Employment_Types__c==Constants.EMPTYP_SALARIED){
                            if(!Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.Holding_Comp_Address__c))       
                                cbsInput.VerificationAddress=party.genesis__Party_Account_Name__r.Holding_Comp_Address__c;   //ShivajiNagar,Pune
                            
                            cbsInput.Landmark = '';
                            if(!Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.Company_Pincode__c))    
                                cbsInput.PINCode=party.genesis__Party_Account_Name__r.Company_Pincode__c;   //411516
                            if(!Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.PersonMailingCity))    
                                cbsInput.Location=party.genesis__Party_Account_Name__r.PersonMailingCity;  //PUNE
                            if(!Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.PersonMailingState))    
                                cbsInput.State=party.genesis__Party_Account_Name__r.PersonMailingState;    //MAHARASHTRA
                        }
                        //LAP/PL for self buisness
                        if(party.Employment_Types__c==Constants.EMPTYP_SELFEMPB){
                            if(!Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.Holding_Comp_Address__c))    
                                cbsInput.VerificationAddress=party.genesis__Party_Account_Name__r.Holding_Comp_Address__c;   //411516
                            if(!Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.Company_Pincode__c ))  
                                cbsInput.PINCode=party.genesis__Party_Account_Name__r.Company_Pincode__c;  //PUNE
                            if(!Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.PersonMailingCity))    
                                cbsInput.Location=party.genesis__Party_Account_Name__r.PersonMailingCity;  //PUNE
                            if(!Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.PersonMailingState))    
                                cbsInput.State=party.genesis__Party_Account_Name__r.PersonMailingState;
                            
                            cbsInput.Landmark = '';
                        }
                        cbsInput.OfficeName= party.genesis__Party_Account_Name__r.Company_Name__c != null ? party.genesis__Party_Account_Name__r.Company_Name__c : '';    //Global Solutions
                        if(!Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.PersonMobilePhone))     
                            cbsInput.MobileNumber=party.genesis__Party_Account_Name__r.PersonMobilePhone;    //12345567898
                        if(!Utility.ISStringBlankorNull(party.Employment_Types__c))    
                            cbsInput.ApplicantCategory=party.Employment_Types__c != null ? party.Employment_Types__c :'';  //Salaried
                        
                        cbsInput.PhoneNumber=party.Company_phone__c != null ? party.Company_phone__c : '';  //679999
                    }
                    if(party.Key_Contact__r.RecordType.DeveloperName == 'Business_Account'){
                        if(!Utility.ISStringBlankorNull(party.Key_Contact__r.Billingstreet))    
                            cbsInput.VerificationAddress=party.Key_Contact__r.Billingstreet;   //411516
                        if(!Utility.ISStringBlankorNull(party.Key_Contact__r.BillingPostalCode ))  
                            cbsInput.PINCode=party.Key_Contact__r.BillingPostalCode;  //411010
                        if(!Utility.ISStringBlankorNull(party.Key_Contact__r.Billingcity))    
                            cbsInput.Location=party.Key_Contact__r.Billingcity;  //PUNE
                        if(!Utility.ISStringBlankorNull(party.Key_Contact__r.Billingstate))    
                            cbsInput.State=party.Key_Contact__r.Billingstate;
                        cbsInput.Landmark = '';
                        cbsInput.Location='';
                        cbsInput.State='';
                        cbsInput.MobileNumber='';
                        cbsInput.ApplicantCategory= '';
                        cbsInput.OfficeName= party.Name; //Global Solutions
                        
                        List<genesis__Application_Parties__c> PTFirm = [Select Id,genesis__Party_Account_Name__r.FirstName,genesis__Party_Account_Name__r.LastName,
                                                                        genesis__Party_Account_Name__r.PersonMobilePhone,genesis__Party_Account_Name__r.Phone,genesis__Party_Account_Name__r.Name
                                                                        From genesis__Application_Parties__c where Key_Contact__c =: party.Id];
                        if(PTFirm.size()>0){
                            cbsInput.ApplicantName = PTFirm[0].genesis__Party_Account_Name__r.FirstName != null ? (PTFirm[0].genesis__Party_Account_Name__r.FirstName +' '+(PTFirm[0].genesis__Party_Account_Name__r.LastName != null ? PTFirm[0].genesis__Party_Account_Name__r.LastName : ''))  : ''; 
                            cbsInput.MobileNumber = PTFirm[0].genesis__Party_Account_Name__r.PersonMobilePhone != null ?PTFirm[0].genesis__Party_Account_Name__r.PersonMobilePhone :'';
                            cbsInput.PhoneNumber = PTFirm[0].genesis__Party_Account_Name__r.Phone !=null ? PTFirm[0].genesis__Party_Account_Name__r.Phone :''; 
                        } 
                    }
                    
                    cbsInput.PickUpDate=PickUpDate; //2018-11-04 15:19:10
                    cbsInput.PrimaryOccupation= party.Employment_SubType__c != null ? party.Employment_SubType__c : '';   
                    cbsInput.SubUrban = '';

                    mapCNidToAstuteWrp.put(cbsInput.NotificationId,new astuteWrap(cbsInput.PINCode,cbsInput.VerificationAddress,cbsInput.ApplicantCategory,'OFFICE',party.genesis__Party_Account_Name__c));//v1.2
                    System.debug(mapCNidToAstuteWrp);
                    astutereqObj.Case145_089.add(cbsInput);
                }
                ///end for loop
            }//end if(Office)
            //+++++++++++++++++++++++++++++++++++Office Request creation end here++++++++++++++++++++

            //++++++++++++++++++++++++++++++++++++++++++Resident Request creation start here++++++++++++++++++++++++++++
            if(RFIAccList.size() > 0 && (PropType == null || PropType == '' || PropType == Constants.ACTIVITY_DESCR )){
                // loop for  Residence
                for(genesis__Application_Parties__c party: RFIAccList){
                    WS_AstuteCallingAPI.cls_Case cbsInput = new WS_AstuteCallingAPI.cls_Case();  
                    if(caseid ==null || caseid==''){    
                        String dts = CreateUniqueId.uniqID();
                        cbsInput.NotificationId = dts.substring(0,dts.length()-PickUpDate.length())+PickUpDate;
                    }else{
                        cbsInput.NotificationId=caseid; 
                    }
                    cbsInput.ApplicationNumber=AppId;
                    cbsInput.ApplicantId= party.genesis__Party_Account_Name__r.id;
                    cbsInput.ActivityDescription=Constants.ACTIVITY_DESCR;
                    cbsInput.ProductName = ProductType;
                    if(!Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.Name))    
                        cbsInput.ApplicantName=party.genesis__Party_Account_Name__r.Name; //Sagar
                    
                    cbsInput.ApplicantType=Constants.BORROWER_TYPE; //Borrower
                    if(!Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.Pan_Number__c))    
                        cbsInput.PAN=party.genesis__Party_Account_Name__r.Pan_Number__c; //ABCDE1234G
                    if(!Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.PersonMailingStreet))      
                        cbsInput.VerificationAddress=party.genesis__Party_Account_Name__r.PersonMailingStreet; //ShivajiNagar,Pune
                    if(!Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.PersonMailingPostalCode))    
                        cbsInput.PINCode=party.genesis__Party_Account_Name__r.PersonMailingPostalCode;   //411516
                    if(!Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.PersonMailingCity))    
                        cbsInput.Location=party.genesis__Party_Account_Name__r.PersonMailingCity;   //PUNE
                    if(!Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.PersonMailingstate))     
                        cbsInput.State=party.genesis__Party_Account_Name__r.PersonMailingstate;  //MAHARASHTRA
                    if(!Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.PersonMobilePhone))     
                        cbsInput.MobileNumber=party.genesis__Party_Account_Name__r.PersonMobilePhone;    //12345567898
                    
                    cbsInput.PhoneNumber=party.genesis__Party_Account_Name__r.Phone != null ? party.genesis__Party_Account_Name__r.Phone :''; //679999
                    cbsInput.OfficeName= party.genesis__Party_Account_Name__r.Company_Name__c != null ? party.genesis__Party_Account_Name__r.Company_Name__c : '';    //Global Solutions
                    cbsInput.PickUpDate=PickUpDate; //2018-11-04 15:19:10
                    if(!Utility.ISStringBlankorNull(party.Employment_Types__c))     
                        cbsInput.ApplicantCategory=party.Employment_Types__c != null ? party.Employment_Types__c : '';  //Salaried
                    
                    cbsInput.PrimaryOccupation=party.Employment_SubType__c != null ?party.Employment_SubType__c : '';  
                    cbsInput.Landmark = '';
                    cbsInput.SubUrban = '';

                    mapCNidToAstuteWrp.put(cbsInput.NotificationId,new astuteWrap(cbsInput.PINCode,cbsInput.VerificationAddress,cbsInput.ApplicantCategory,'RESIDENCE',party.genesis__Party_Account_Name__c));//v1.2
                    System.debug(mapCNidToAstuteWrp);
                    astutereqObj.Case145_089.add(cbsInput);
                }
                //end for loop
            }//end if(Residence)
            //++++++++++++++++++++++++++++++++++++++++++Resident Request creation end here++++++++++++++++++++++++++++
            
            System.debug('astutereqObj-callAstute()***'+astutereqObj);
            if(FIAccList.size()>0 || RFIAccList.size()>0){
                AstuteMethod(JSON.serialize(astutereqObj));
            }
            
        } catch(Exception e) {
            System.debug('error LineNumber'+e.getLineNumber());
            System.debug('error message'+e.getMessage());
            HandleBusinessException.captureError('WS_AstuteCallingAPI', 'callAstute', e);
        }
        
    }
    //end of astute method
    
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++    
    
    //Astute retry() from batch AstuteCalloutBatchJob()(start)
    public static void astuteRetry2(List<Astute_Verification__c> astutelist){
        try{
            System.debug('**astutelist retry method --- '+astutelist);
            WS_AstuteCallingAPI.AstueRequest astutereqObj=new WS_AstuteCallingAPI.AstueRequest();
            astutereqObj.Case145_089 = new List<cls_Case>();
            String PickUpDate = String.valueOf(system.now());
            String ProductType;
            for(Astute_Verification__c astuteObj :astutelist){
                if(astuteObj.Application__r.Record_Type_Name__c == Constants.PERSONALLOAN){
                    System.debug('$$$$$$$$$'+astuteObj.Application__r.Record_Type_Name__c);
                    ProductType = 'PRSNLN';
                }else if(astuteObj.Application__r.Record_Type_Name__c == Constants.LAPLOAN){
                    ProductType = 'LNALAP';
                }else if(astuteObj.Application__r.Record_Type_Name__c == Constants.HOMELOAN){
                    ProductType = 'HOMELN';
                }else if(astuteObj.Application__r.Record_Type_Name__c == Constants.VL2W || astuteObj.Application__r.Record_Type_Name__c == Constants.VL4W){//v1.1
                    ProductType = 'VHCLLN';
                }   
                String AccId=astuteObj.Application__c;
                WS_AstuteCallingAPI.cls_Case cbsInput = new WS_AstuteCallingAPI.cls_Case();  
                
                List<genesis__Application_Parties__c> Partylst = partylist(AccId); 
                for(genesis__Application_Parties__c party:Partylst){
                    if(party.genesis__Party_Account_Name__r.id == astuteObj.Account__c){
                        if(astuteObj.Property_Type__c==Constants.ACTIVITY_DESCO){
                            cbsInput.NotificationId=astuteObj.Case_Notification_Id__c;
                            cbsInput.ApplicationNumber=astuteObj.Application__c;
                            cbsInput.ApplicantId= astuteObj.Account__c;
                            cbsInput.ActivityDescription=Constants.ACTIVITY_DESCO;
                            cbsInput.ProductName = ProductType;
                            if(!Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.Name))
                                cbsInput.ApplicantName=party.genesis__Party_Account_Name__r.Name;    //Sagar
                            cbsInput.ApplicantType=Constants.BORROWER_TYPE; //Borrower
                            if(!Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.Pan_Number__c))    
                                cbsInput.PAN=party.genesis__Party_Account_Name__r.Pan_Number__c; //ABCDE1234G
                            
                            /// logic for  assigining address for salaried account and self employed buisness
                            if(!Utility.ISStringBlankorNull(party.Employment_Types__c)){
                                //for salaried
                                if(party.Employment_Types__c==Constants.EMPTYP_SALARIED ){
                                    if(!Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.Holding_Comp_Address__c))
                                        cbsInput.VerificationAddress=party.genesis__Party_Account_Name__r.Holding_Comp_Address__c;//ShivajiNagar,Pune
                                    if(!Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.Company_Pincode__c))    
                                        cbsInput.PINCode=party.genesis__Party_Account_Name__r.Company_Pincode__c;//411516
                                    if(!Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.PersonMailingCity))    
                                        cbsInput.Location=party.genesis__Party_Account_Name__r.PersonMailingCity;//PUNE
                                    if(!Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.PersonMailingState))    
                                        cbsInput.State=party.genesis__Party_Account_Name__r.PersonMailingState;//MAHARASHTRA
                                        cbsInput.Landmark = '';
                                }
                                //for self buisness
                                if(party.Employment_Types__c==Constants.EMPTYP_SELFEMPB){
                                    if(!Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.Holding_Comp_Address__c))    
                                        cbsInput.VerificationAddress=party.genesis__Party_Account_Name__r.Holding_Comp_Address__c;   //411516
                                    if(!Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.Company_Pincode__c ))cbsInput.PINCode=party.genesis__Party_Account_Name__r.Company_Pincode__c;  //PUNE
                                    if(!Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.PersonMailingCity))cbsInput.Location=party.genesis__Party_Account_Name__r.PersonMailingCity;  //PUNE
                                    if(!Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.PersonMailingState))cbsInput.State=party.genesis__Party_Account_Name__r.PersonMailingState;
                                    
                                    cbsInput.Landmark = '';
                                }
                                if(!Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.PersonMobilePhone))     
                                    cbsInput.MobileNumber=party.genesis__Party_Account_Name__r.PersonMobilePhone;//12345567898
                                if(!Utility.ISStringBlankorNull(party.Employment_Types__c))    
                                    cbsInput.ApplicantCategory=party.Employment_Types__c != null ? party.Employment_Types__c :'';//Salaried
                            }
                            if(party.Key_Contact__r.RecordType.DeveloperName == 'Business_Account'){
                                if(!Utility.ISStringBlankorNull(party.Key_Contact__r.Billingstreet))    
                                    cbsInput.VerificationAddress=party.Key_Contact__r.Billingstreet;   //411516
                                if(!Utility.ISStringBlankorNull(party.Key_Contact__r.BillingPostalCode ))  
                                    cbsInput.PINCode=party.Key_Contact__r.BillingPostalCode;  //411010
                                if(!Utility.ISStringBlankorNull(party.Key_Contact__r.Billingcity))    
                                    cbsInput.Location=party.Key_Contact__r.Billingcity;  //PUNE
                                if(!Utility.ISStringBlankorNull(party.Key_Contact__r.Billingstate))    
                                    cbsInput.State=party.Key_Contact__r.Billingstate;

                                cbsInput.Landmark = '';//new List<cls_Landmark>();
                                cbsInput.Location='';
                                cbsInput.State='';
                                cbsInput.MobileNumber='';
                                cbsInput.ApplicantCategory= '';
                            }
                            
                            cbsInput.PhoneNumber=party.Company_phone__c != null ? party.Company_phone__c : '';  //679999
                            cbsInput.OfficeName= party.genesis__Party_Account_Name__r.Company_Name__c != null ? party.genesis__Party_Account_Name__r.Company_Name__c : '';    //Global Solutions
                            cbsInput.PickUpDate=PickUpDate; //2018-11-04 15:19:10
                            
                            cbsInput.PrimaryOccupation= party.Employment_SubType__c != null ? party.Employment_SubType__c : '';   
                            cbsInput.SubUrban = '';//new List<cls_SubUrban>();
                            
                            mapCNidToAstuteWrp.put(cbsInput.NotificationId,new astuteWrap(cbsInput.PINCode,cbsInput.VerificationAddress,cbsInput.ApplicantCategory,'OFFICE',null));//v1.2
                            System.debug(mapCNidToAstuteWrp);
                            astutereqObj.Case145_089.add(cbsInput);
                        }// for Residence 
                        else{
                            cbsInput.NotificationId=astuteObj.Case_Notification_Id__c;
                            cbsInput.ApplicationNumber=astuteObj.Application__c;
                            cbsInput.ApplicantId= astuteObj.Account__c;
                            cbsInput.ActivityDescription=Constants.ACTIVITY_DESCR;
                            cbsInput.ProductName = ProductType;
                            System.debug('*************'+cbsInput.ProductName);
                            if(!Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.Name))    
                                cbsInput.ApplicantName=party.genesis__Party_Account_Name__r.Name; //Sagar
                            cbsInput.ApplicantType=Constants.BORROWER_TYPE; //Borrower
                            if(!Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.Pan_Number__c))    
                                cbsInput.PAN=party.genesis__Party_Account_Name__r.Pan_Number__c; //ABCDE1234G
                            if(!Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.PersonMailingStreet))      
                                cbsInput.VerificationAddress=party.genesis__Party_Account_Name__r.PersonMailingStreet; //ShivajiNagar,Pune
                            if(!Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.PersonMailingPostalCode))    
                                cbsInput.PINCode=party.genesis__Party_Account_Name__r.PersonMailingPostalCode;   //411516
                            if(!Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.PersonMailingCity))    
                                cbsInput.Location=party.genesis__Party_Account_Name__r.PersonMailingCity;   //PUNE
                            if(!Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.PersonMailingstate))     
                                cbsInput.State=party.genesis__Party_Account_Name__r.PersonMailingstate;  //MAHARASHTRA
                            if(!Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.PersonMobilePhone))     
                                cbsInput.MobileNumber=party.genesis__Party_Account_Name__r.PersonMobilePhone;    //12345567898
                            
                            cbsInput.PhoneNumber=party.genesis__Party_Account_Name__r.Phone != null ? party.genesis__Party_Account_Name__r.Phone :''; //679999
                            cbsInput.OfficeName= party.genesis__Party_Account_Name__r.Company_Name__c != null ? party.genesis__Party_Account_Name__r.Company_Name__c : '';    //Global Solutions
                            cbsInput.PickUpDate=PickUpDate; //2018-11-04 15:19:10
                            cbsInput.PrimaryOccupation=party.Employment_SubType__c != null ?party.Employment_SubType__c : '';  
                            if(!Utility.ISStringBlankorNull(party.Employment_Types__c))     
                                cbsInput.ApplicantCategory=party.Employment_Types__c;  //Salaried
                            
                            cbsInput.Landmark = '';//new List<cls_Landmark>(); 
                            cbsInput.SubUrban = '';//new List<cls_SubUrban>();

                            mapCNidToAstuteWrp.put(cbsInput.NotificationId,new astuteWrap(cbsInput.PINCode,cbsInput.VerificationAddress,cbsInput.ApplicantCategory,'RESIDENCE',null));//v1.2
                            System.debug(mapCNidToAstuteWrp);
                            astutereqObj.Case145_089.add(cbsInput); 
                            
                        }
                    }
                }
                
            }
            isRetry=true;
            System.debug('**isRetry'+isRetry);
            System.debug('astutereqObj-astuteRetry2()***'+astutereqObj);
            AstuteMethod(JSON.serialize(astutereqObj));
            
        }
        catch(Exception e){
            System.debug('ex'+e.getLineNumber());
            System.debug('ex message'+e.getMessage());
            HandleBusinessException.captureError('WS_AstuteCallingAPI', 'astuteRetry2', e);
        }
    }
    //Astute retry() from batch AstuteCalloutBatchJob()(end)
    
    public static void AstuteMethod(String  astreq){
        try{
            if((!isRetry && checkAstuteCalling()) || isRetry){
                System.debug('json request for Astute'+astreq);
                String req= astreq.replace('Case145_089','Case');
                System.debug('++req'+req);
                Map<String,String> headerMap = new Map<String,String>();              
                headerMap.put('Content-Type','application/json'); 
                headerMap.put('Authorization',WS_ApiGatewayAccToken.getAccTkn());
                HTTPResponse response = new HTTPResponse();
                response = HttpUtility.sendHTTPRequest(Utility.getFullEndpoints('AstuteRequest1'), 'POST',null,req,headerMap,label.CA_CERTIFICATE);
                System.debug('response::'+response);
                if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                    String jsonData = response.getBody();
                    System.debug('jsonData::'+jsonData);
                    AstueResponse appReqObj = (AstueResponse)System.JSON.deserialize(jsonData, AstueResponse.class);
                    System.debug('**appReqObj'+appReqObj);
                    if(appReqObj == null ){
                        throw new CustomException('There is No Response from Astute.....');
                    }else{
                        if (isRetry){
                            checkAstuteCalling();
                        }
                        List<Astute_Verification__c> ListAstuteUpdt = new List<Astute_Verification__c>();
                        for(cls_CaseDetails detls: appReqObj.CaseDetails){
                            Astute_Verification__c AstuteVefr = new Astute_Verification__c();
                            if(!Utility.ISStringBlankorNull(detls.NotificationId))
                                AstuteVefr.Case_Notification_Id__c = String.valueOf(detls.NotificationId);
                            if(!Utility.ISStringBlankorNull(detls.Status))
                                AstuteVefr.Status__c = String.valueOf(detls.Status);
                            if(!Utility.ISStringBlankorNull(detls.Message))
                                AstuteVefr.Message__c = String.valueOf(detls.Message);
                            if(!Utility.ISStringBlankorNull(detls.CaseId))
                                AstuteVefr.Case_Id__c = String.valueOf(detls.CaseId);
                            if(!Utility.ISStringBlankorNull(detls.StatusId))
                                AstuteVefr.Status_ID__c = String.valueOf(detls.StatusId);
                            
                            if (!isRetry){
                                AstuteVefr.Application__c=applicationId;
                            }

                            //v1.2(start)
                            if (mapCNidToAstuteWrp.containskey(detls.NotificationId)) {
                                AstuteVefr.Requested_Pincode__c = mapCNidToAstuteWrp.get(detls.NotificationId).pincode;
                                AstuteVefr.Requested_Address__c = mapCNidToAstuteWrp.get(detls.NotificationId).address;
                                AstuteVefr.Employment_Type__c = mapCNidToAstuteWrp.get(detls.NotificationId).empType;
                                AstuteVefr.Property_Type__c = mapCNidToAstuteWrp.get(detls.NotificationId).propertyType;
                                if (mapCNidToAstuteWrp.get(detls.NotificationId).accId!=null)
                                    AstuteVefr.Account__c = mapCNidToAstuteWrp.get(detls.NotificationId).accId;
                                if(detls.Status=='Success' && detls.StatusId=='100'){
                                    AstuteVefr.Expected_Date__c = getExpectedDate(mapCNidToAstuteWrp.get(detls.NotificationId).pincode);
                                }
                            }
                            //v1.2(start)
                            ListAstuteUpdt.add(AstuteVefr);
                        }
                        System.debug('** ListAstuteUpdt size>>'+ListAstuteUpdt.size());
                        upsert ListAstuteUpdt Case_Notification_Id__c;
                    }
                }else{
                    throw new CustomException('Status Code-'+response.getStatusCode()+' Status-'+response.getStatus());
                }
            }
            //v1.2(start)
            else {
                List<Astute_Verification__c> ListAstuteUpdt = new List<Astute_Verification__c>();
                for(string NotificatnId: mapCNidToAstuteWrp.keyset()) {
                    Astute_Verification__c AstuteVefr = new Astute_Verification__c();
                    AstuteVefr.Case_Notification_Id__c = NotificatnId;
                    AstuteVefr.Status__c = '';
                    AstuteVefr.Message__c = 'Non Serviceable';
                    AstuteVefr.Case_Id__c = Constants.FI_MANUAL;
                    //AstuteVefr.Status_ID__c = Constants.FI_MANUAL;
                    
                    AstuteVefr.Application__c=applicationId;
                    if (mapCNidToAstuteWrp.containskey(NotificatnId)) {
                        AstuteVefr.Requested_Pincode__c = mapCNidToAstuteWrp.get(NotificatnId).pincode;
                        AstuteVefr.Requested_Address__c = mapCNidToAstuteWrp.get(NotificatnId).address;
                        AstuteVefr.Employment_Type__c = mapCNidToAstuteWrp.get(NotificatnId).empType;
                        AstuteVefr.Property_Type__c = mapCNidToAstuteWrp.get(NotificatnId).propertyType;
                        AstuteVefr.Account__c = mapCNidToAstuteWrp.get(NotificatnId).accId;
                        //AstuteVefr.Expected_Date__c = getExpectedDate(mapCNidToAstuteWrp.get(NotificatnId).pincode);
                    }
                    ListAstuteUpdt.add(AstuteVefr);
                }
                insert ListAstuteUpdt;
            }
            //v1.2(start)
        }
        catch(Exception e){
            System.debug(e.getLineNumber()+' Exception on Astute request call.... '+e.getStackTraceString());
            System.debug('message'+e.getMessage());
            HandleBusinessException.captureError('WS_AstuteCallingAPI', 'AstuteMethod', e);
        }
        //return 
    }
    
    // astue request
    public class AstueRequest{
        public cls_Case[] Case145_089;
    }
    public class cls_Case {
        public String NotificationId;   //CC20180404031945675432
        public String ApplicationNumber;    //#CCMNV51111
        //public cls_ApplicantId[] ApplicantId;
        public string ApplicantId;
        public String ActivityDescription;  //Office
        public String ApplicantName;    //Sagar
        public String ApplicantType;    //Borrower
        public String PAN;  //ABCDE1234G
        public String VerificationAddress;  //ShivajiNagar,Pune
        //public cls_Landmark[] Landmark;
        public String Landmark;
        public String PINCode;  //411516
        public String Location; //PUNE
        public String State;    //MAHARASHTRA
        //public cls_SubUrban[] SubUrban;
        public String SubUrban;
        public String MobileNumber; //12345567898
        public String PhoneNumber;  //679999
        public String OfficeName;   //Global Solutions
        public String PickUpDate;   //2018-11-04 15:19:10
        public String ApplicantCategory;    //Salaried
        public String PrimaryOccupation;    //Salaried
        public String ProductName; //send Product name=(Home Loan: HOMELN Personal Loan: PRSNLN LAP: MLAPLN Vehicle Loan:VHCLLN)
    }
    
    // astue response
    public class AstueResponse{
        public cls_CaseDetails[] CaseDetails;
    }
    public class cls_CaseDetails {
        public String NotificationId;  //
        public String Status;   //Failed
        public String Message;  //Mandatory fields are blank NotificationId)
        public String CaseId;   //0
        public String StatusId; //202
    }
    
    public static List<Account> accList(String AppID){
        Set<String> accIds = new Set<String>();
        genesis__Applications__c app = [Select Id,genesis__Account__r.ID From genesis__Applications__c where Id =:AppID];
        accIds.add(app.genesis__Account__r.ID);
        List<genesis__Application_Parties__c> partiesList = [Select Id,genesis__Party_Account_Name__c
                                                             From genesis__Application_Parties__c Where genesis__Application__c =:AppID AND Active__c = True AND genesis__Party_Type__c =: 'Co-Borrower'];
        
        List<genesis__Application_Parties__c> BussinessList = [Select Id,Key_Contact__c,genesis__Party_Account_Name__c,Company__c
                                                               From genesis__Application_Parties__c Where genesis__Application__c =:AppID AND Active__c = True AND Company__c = True];
        if(partiesList.size()>0){
            for(genesis__Application_Parties__c pt : partiesList){
                accIds.add(pt.genesis__Party_Account_Name__c);
            }
        }
        if(BussinessList.size()>0){
            for(genesis__Application_Parties__c pt: BussinessList){
                accIds.add(pt.Key_Contact__c);
            }
            
        }
        List <Account> accountList = [Select Id,Phone,Firm_Address__c,Company_phone__c,Company_Name__c,PersonMailingPostalCode,PersonMailingStreet,Employment_SubType__c,
                                      Employment_Type__c,Firm_Pincode__c,Are_you_An_Existing_Customer__c,Name,Salutation,PersonOtherCountry,PersonOtherCity,Gender__pc,FirstName,Father_Name__pc,PersonEmail,
                                      Verify_PAN_Number__c,PersonMobilePhone,Customer_Type__c,Aadhaar_Number__pc,Pan_Number__c,Customer_IC__c,Branch_Code__c,PersonBirthdate,CBS_Prof_Code__C,Husband_Name__pc,
                                      LastName,PersonOtherStreet,PersonOtherPostalCode,PersonOtherState,Marital_Status__pc,MiddleName,Perfios_Captured__c,Nationality__pc,Spouse_Name__pc,CBS_Customer_ID__c,
                                      Voter_Id__c,Passport_Number__pc,Driving_License_ID__c,RecordType.DeveloperName,
                                      National_Identification_Code__c,Other_identification_number__c,CreatedDate,Customer_ID_Creation_Date__c,NMI_Approved__c,
                                      Same_Present_Address_Permanent_Address__c,Bank_Statement__c,Telephone_Bill__c,Ration_Card__c,Employment_Letter__c,
                                      Holding_Comp_Address__c,Company_Pincode__c,PersonMailingCity,PersonMailingState,Billingstreet,BillingPostalCode,Billingcity,
                                      Billingstate From Account Where  Id IN: accIds];
        
        return accountList;
    }    
    
    
    //astute record for parties
    public static List<genesis__Application_Parties__c> partylist(String AppID){
        List<genesis__Application_Parties__c> parlist=[select id,Name,genesis__Party_Type__c,Active__c,Company__c,genesis__Application__c,genesis__Party_Account_Name__r.name,genesis__Application__r.name,genesis__Application__r.Record_Type_Name__c,Key_Contact__r.RecordType.DeveloperName,genesis__Party_Account_Name__r.RecordType.DeveloperName,genesis__Party_Account_Name__r.id,genesis__Party_Account_Name__r.Phone,genesis__Party_Account_Name__r.Firm_Address__c,Company_phone__c,
                                                       genesis__Party_Account_Name__r.Are_you_An_Existing_Customer__c,genesis__Party_Account_Name__r.Company_Pincode__c,Same_Present_Address_Permanent_Address__c,NMI_Approved__c,Perfios_Captured__c,Employment_Types__c,Employment_SubType__c,genesis__Party_Account_Name__r.PersonOtherCountry,genesis__Party_Account_Name__r.PersonOtherCity,genesis__Party_Account_Name__r.PersonMailingPostalCode,
                                                       genesis__Party_Account_Name__r.PersonMailingStreet,genesis__Party_Account_Name__r.FirstName,Key_Contact__r.Billingstreet,Key_Contact__r.BillingPostalCode,Key_Contact__r.BillingCity,Key_Contact__r.BillingState,genesis__Party_Account_Name__r.Billingstate,genesis__Party_Account_Name__r.Billingcity,
                                                       genesis__Party_Account_Name__r.BillingPostalCode,genesis__Party_Account_Name__r.Billingstreet,genesis__Party_Account_Name__r.PersonMailingState,genesis__Party_Account_Name__r.PersonMailingCity,
                                                       genesis__Party_Account_Name__r.Company_Name__c,genesis__Party_Account_Name__r.Holding_Comp_Address__c,genesis__Party_Account_Name__r.Employment_Letter__c,genesis__Party_Account_Name__r.Ration_Card__c,genesis__Party_Account_Name__r.Telephone_Bill__c,genesis__Party_Account_Name__r.Bank_Statement__c,genesis__Party_Account_Name__r.Customer_ID_Creation_Date__c,genesis__Party_Account_Name__r.CreatedDate,genesis__Party_Account_Name__r.Other_identification_number__c,
                                                       genesis__Party_Account_Name__r.National_Identification_Code__c,genesis__Party_Account_Name__r.Driving_License_ID__c,genesis__Party_Account_Name__r.Passport_Number__pc,genesis__Party_Account_Name__r.Voter_Id__c,genesis__Party_Account_Name__r.CBS_Customer_ID__c,genesis__Party_Account_Name__r.Spouse_Name__pc,genesis__Party_Account_Name__r.Nationality__pc,genesis__Party_Account_Name__r.Marital_Status__pc,
                                                       genesis__Party_Account_Name__r.MiddleName,genesis__Party_Account_Name__r.PersonOtherState,genesis__Party_Account_Name__r.PersonOtherPostalCode,genesis__Party_Account_Name__r.PersonOtherStreet,genesis__Party_Account_Name__r.LastName,genesis__Party_Account_Name__r.Husband_Name__pc,genesis__Party_Account_Name__r.CBS_Prof_Code__C,genesis__Party_Account_Name__r.PersonBirthdate,genesis__Party_Account_Name__r.Branch_Code__c,
                                                       genesis__Party_Account_Name__r.Customer_IC__c,genesis__Party_Account_Name__r.Pan_Number__c,genesis__Party_Account_Name__r.Aadhaar_Number__pc,genesis__Party_Account_Name__r.Customer_Type__c,genesis__Party_Account_Name__r.PersonMobilePhone,Verify_PAN_Number__c,genesis__Party_Account_Name__r.PersonEmail,genesis__Party_Account_Name__r.Father_Name__pc,genesis__Party_Account_Name__r.Gender__pc,FI_Exempted__c from genesis__Application_Parties__c where Active__c = True AND genesis__Application__c=:AppID];
        return parlist;
    }
    
    //v1.2(start)
    //Expected date to get astute response
    public static Date getExpectedDate(String pincode){
        try {
            String pincodeServiceArea='';
            Date expDate = null;
            //System.debug(mapPincodeToAstuteService.size()+'<<mapPincodeToAstuteService**>>'+mapPincodeToAstuteService);
            if (pincode!=null){
                if(mapPincodeToAstuteService.containskey(pincode))
                    pincodeServiceArea = mapPincodeToAstuteService.get(pincode);
                if (pincodeServiceArea!='') {
                    if (pincodeServiceArea==Constants.LOCAL) {
                        expDate = addDays(1);
                    }else if (pincodeServiceArea==Constants.OCL) {
                        expDate = addDays(2);
                    }else if (pincodeServiceArea==Constants.OCL50_100) {
                        expDate = addDays(3);
                    }else if (pincodeServiceArea==Constants.OCL100ABOVE) {
                        expDate = addDays(4);
                    }
                }
            }
            System.debug('expDate>>'+expDate);
            return expDate;
        } catch(Exception e) {
            System.debug('error LineNumber'+e.getLineNumber()+' message '+e.getMessage());
            return null;
        }
    }

    //add days start from today
    public static Date addDays(Integer noOfDays){
        Datetime todayDate = System.now();
        Integer dayCount = 0;
        while(noOfDays>dayCount){
            todayDate = todayDate.addDays(1);
            if (todayDate.format('EEE')!='Sat' && todayDate.format('EEE')!='Sun') {
                dayCount++;
            }
        }
        return todayDate.date();
    }
    
    //check astute api call is required or not
    public static Boolean checkAstuteCalling(){
        try {
            set<string> pincodeSet=new set<string>();
            List<Pincode_Master__c> lstPincode = new List<Pincode_Master__c>();
            for(astuteWrap eachwrp: mapCNidToAstuteWrp.values()) {
                if (eachwrp.pincode!=null && eachwrp.pincode!='') {
                    pincodeSet.add(eachwrp.pincode);
                }
            }
            if (mapCNidToAstuteWrp.values().size()>0){
                lstPincode = [select id,Pincode__c,Astute_Serviceability__c,Astute_Location_Category__c from Pincode_Master__c where Pincode__c IN:pincodeSet];
            }
            for(Pincode_Master__c pm: lstPincode){
                if(pm.Astute_Serviceability__c){
                    mapPincodeToAstuteService.put(pm.Pincode__c,pm.Astute_Location_Category__c);
                }
            }
            //System.debug(mapPincodeToAstuteService.size()+'<<mapPincodeToAstuteService>>'+mapPincodeToAstuteService);

            if(pincodeSet.size()==lstPincode.size() && mapPincodeToAstuteService.size()==lstPincode.size())
                return true;
            else
                return false;
        } catch(Exception e) {
            System.debug('error LineNumber'+e.getLineNumber()+' message '+e.getMessage());
            return false;
        }
    }

    public class astuteWrap{
        public string pincode{get;set;}
        public string address{get;set;}
        public string empType{get;set;}
        public string propertyType{get;set;}
        public string accId{get;set;}
        public astuteWrap(string pincode,string address,string empType,string propertyType,string accId){
            this.pincode = pincode;
            this.address = address;
            this.empType = empType;
            this.propertyType = propertyType;
            this.accId = accId;
        }
    }
    //v1.2(end)

}