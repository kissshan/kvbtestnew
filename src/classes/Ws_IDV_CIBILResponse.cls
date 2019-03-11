/*
* Name    : Ws_IDV_CIBILResponse 
* Company : ET Marlabs
* Purpose : This class is used to Parse IDV Response from Appigee
* Author  : Venugopal N
*/

@RestResource(urlMapping='/IDV_CIBILResponse')
global class Ws_IDV_CIBILResponse {
    public static String applnId = '';
    global class idResponse extends WS_Response{
        public IDVResponse IDVResponse;
        public CibilResponse CibilResponse;
        CibilRequestTU_HL CibilRequest;
        public string TUCall;
    }
    @HttpPost
    global static idResponse IDVCreating(){
        RestRequest req      = Restcontext.Request;
        RestResponse restRes = Restcontext.response;
        idResponse res         = new idResponse();
        string ReqCall = req.params.get('TUCall');
        string AppID=req.params.get('Appid');
        string ApplicationId=req.params.get('ApplicationId');
        system.debug('ReqCall:-'+ReqCall);
        system.debug('AppID:-'+AppID);
        system.debug('ApplicationId:-'+ApplicationId);
        applnId = ApplicationId;
        if(req.requestBody == null){
            res.status          = Constants.WS_ERROR_STATUS;
            res.errorMessage    = Constants.WS_REQ_BODY_IS_NULL;
            res.statusCode      = Constants.WS_ERROR_CODE;
            return res;            
        }else{
            try{
                system.debug('##DataLog### --- > '+ ReqCall);
                string Json=req.requestBody.toString();
                if(ReqCall==Constants.IDVCall && AppID!=null && ApplicationId!=null && !Utility.ISStringBlankorNull(AppID) && !Utility.ISStringBlankorNull(ApplicationId)){
                    
                    IDVResponseTU_HL IDvreq= IDVResponseTU_HL.parse(json);
                    system.debug('IDvreq'+IDvreq);
                    IDVResponse reg= new IDVResponse();
                    system.debug('reg'+reg);
                    reg= CibilTUService.getIDV(IDvreq);
                    system.debug('regg+'+reg);
                    system.debug('AppID+'+AppID);
                   account acct=[select id,FirstName,LastName,MiddleName,name,Gender__pc,PersonBirthdate,Aadhaar_Number__pc,Pan_Number__c,PersonMobilePhone,
                                 PersonMailingStreet,Verify_PAN_Number__c,Is_PAN_card_available__c,PersonMailingCity,PersonMailingPostalCode,PersonMailingState,Full_Name__c from account where ID=:AppID];
								 
				    genesis__Application_Parties__c acc=[select id,genesis__Party_Account_Name__r.id,genesis__Party_Account_Name__r.FirstName,genesis__Party_Account_Name__r.LastName,genesis__Party_Account_Name__r.MiddleName,genesis__Party_Account_Name__r.name,genesis__Party_Account_Name__r.Gender__pc,genesis__Party_Account_Name__r.PersonBirthdate,genesis__Party_Account_Name__r.Aadhaar_Number__pc,genesis__Party_Account_Name__r.Pan_Number__c,genesis__Party_Account_Name__r.PersonMobilePhone,
                                 genesis__Party_Account_Name__r.PersonMailingStreet,Verify_PAN_Number__c,genesis__Party_Account_Name__r.Is_PAN_card_available__c,genesis__Party_Account_Name__r.PersonMailingCity,genesis__Party_Account_Name__r.PersonMailingPostalCode,genesis__Party_Account_Name__r.PersonMailingState,genesis__Party_Account_Name__r.Full_Name__c from genesis__Application_Parties__c where  Active__c=true and genesis__Party_Account_Name__r.ID =: AppID AND genesis__Application__r.id =: ApplicationId limit 1];
                    genesis__Application_Parties__c ac=new genesis__Application_Parties__c();
                    
                    if(reg.Result==true){
                        CibilRequestTU_HL Crequest=new  CibilRequestTU_HL ();
                        Crequest=  WS_CibilServiceTU_HL.prepareRequest(acct,Constants.CIBIL) ;
                        res.CibilRequest=Crequest;
                        res.TUCall=Constants.CIBIL;
                        
                        if(reg.PanMatch=='1'){
                            ac.Verify_PAN_Number__c='Yes';
                        }
                        else if(reg.PanMatch=='0' && acc.genesis__Party_Account_Name__r.Is_PAN_card_available__c==false){
                            ac.Verify_PAN_Number__c='No';
                        }
                        ac.id=acc.id;
                        update ac; 
                    }
                    else if(reg.Result==false){
                        list<genesis__Application_Parties__c>  GpList=[select id,genesis__Party_Account_Name__c,genesis__Application__c,Active__c from genesis__Application_Parties__c where genesis__Party_Account_Name__c=:AppID and genesis__Application__c=:ApplicationId and active__c=true and genesis__Party_Type__c !=: Constants.PRIMARY_APP];
                        
                        if(GpList.size()>0){
                            if(GpList[0].Active__c==true){
                                GpList[0].Active__c=false;
                                update  GpList[0];
                            } 
                        }
                        else{
                            list<genesis__Applications__c>  Applist=[select id,genesis__Account__c,Sub_Stage__c from genesis__Applications__c where ID=:ApplicationID];
                            if(Applist.size()>0){
                                Applist[0].Sub_Stage__c =Constants.IDVRejeted;
                                update  Applist[0];
                            }
                            
                        }
                        if(reg.PanMatch!=Null){
                            if(reg.PanMatch=='1'){
                                ac.Verify_PAN_Number__c='Yes';
                            }
                            else if(reg.PanMatch=='0' && acc.genesis__Party_Account_Name__r.Is_PAN_card_available__c==false){
                                ac.Verify_PAN_Number__c='No';
                            }
                            ac.id=acc.id;
                            update ac; 
                            
                        }
                        res.status          = Constants.WS_ERROR_STATUS;
                        res.errorMessage    = reg.Status;
                        res.statusCode      = Constants.WS_ERROR_CODE;
                        res.CibilResponse =null;
                        res.IDVResponse=null;
                        return res;
                    }
                    else{
                        res.status          = Constants.WS_ERROR_STATUS;
                        res.errorMessage    = 'Exception from IDV Response';
                        res.statusCode      = Constants.WS_ERROR_CODE;
                        res.CibilResponse =null;
                        res.IDVResponse=null; 
                        return res;
                    }
                    
                    res.IDVResponse=reg; 
                }
                else if(ReqCall==Constants.CIBIL  && AppID!=null && ApplicationId!=null && !Utility.ISStringBlankorNull(AppID) && !Utility.ISStringBlankorNull(ApplicationId))
                {
                    CibilResponseTU_HL Creq=CibilResponseTU_HL.parse(json);
                    CibilResponse Cres= CibilTUService.getcibildetails(Creq,Constants.HL_CibilRecordType);
                    // Start Code for Personal loan CIBIL check using record typeID
                    genesis__Applications__c appData = queryService.getApp(ApplicationId);
                    //Id LPRecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Personal Loan').getRecordTypeId();
                    //KVB_Company_Details__c company = KVB_Company_Details__c.getOrgDefaults();
                    genesis__Applications__c appp=[select id,genesis__CL_Product__r.Special_Branches_Cutoff__c from genesis__Applications__c where id=:ApplicationId];
              List<Branch_Master__c>    BranchList=[select id,CODCCBRN__c,Special_Branches__c,Retail_Category__c,NAMCCCITY__c from Branch_Master__c where CODCCBRN__c =:appData.Branch_Code__c and Special_Branches__c=:true];
					  Boolean SpecialBranch=false;
                    if(BranchList!=null && BranchList.size()>0)
							SpecialBranch=true;                        
				 if(Cres.Result==true && ((Decimal.valueof(Cres.CibilScore)< appp.genesis__CL_Product__r.Special_Branches_Cutoff__c && Decimal.valueof(Cres.CibilScore)>=650) || Decimal.valueof(Cres.CibilScore)==-1 || (Decimal.valueof(Cres.CibilScore)>=1 && Decimal.valueof(Cres.CibilScore)<=10)) && SpecialBranch){
                        list<genesis__Application_Parties__c>  GpList=[select id,genesis__Party_Account_Name__c,genesis__Application__c,Active__c from genesis__Application_Parties__c where genesis__Party_Account_Name__c=:AppID and genesis__Application__c=:ApplicationId and active__c=true and genesis__Party_Type__c !=: Constants.PRIMARY_APP];
                            
                            if(GpList.size()>0){
								if(!Utility.ISStringBlankorNull(appData.Sub_Type__c)){
								if(appData.Sub_Type__c==Constants.Sub_Type_Top_Up || appData.Sub_Type__c==Constants.Sub_Type_Take_Over){
								  genesis__Applications__c App=new genesis__Applications__c();
                                    App.Id=ApplicationId;
                                    App.Sub_Stage__c=Constants.LowCIBILScore;
									update App;
								}
								}
                                if(GpList[0].Active__c==true){
                                    GpList[0].Active__c=false;
                                    update  GpList[0];
                                } 
                            }
                            else{
                                list<genesis__Applications__c>  Applist=[select id,genesis__Account__c,Reject_Scenario__c,Sub_Stage__c from genesis__Applications__c where ID=:ApplicationID];
                                if(Applist.size()>0){
                                    Applist[0].Sub_Stage__c =Constants.LowCIBILScore;
                                   Applist[0].Reject_Scenario__c=Constants.LOW_CIBIL_SCORE_SUBSTAGE;
                                    update  Applist[0];
                                }
                            }
                         res.errorMessage    = 'Low Cibil Score';//change commented as:'Customer CIBIL score is less than 650, loan cannot be processed' 
                            res.status       =Constants.WS_ERROR_STATUS;
                         res.statusCode      = Constants.WS_ERROR_CODE;
                        
                 }
                    else{
                    if(appData.Record_Type_Name__c == Constants.PERSONALLOAN)
                    {
                        System.debug('Cres:::'+Cres.Result);
                    	System.debug('Cres:::'+Cres.CibilScore);
                        if(Cres.Result==false ){
                            
                            list<genesis__Applications__c>  Applist=[select id,genesis__Account__c,Application_Stage__c,Sub_Stage__c from genesis__Applications__c where ID=:ApplicationID];
                            if(Applist.size()>0){
                                Applist[0].Sub_Stage__c =Constants.CIBILRejected;
                                update  Applist[0];
                            }
                            res.status          = Constants.WS_ERROR_STATUS;
                            res.errorMessage    = Constants.CIBILRejectedMsg;//Cres.Status;
                            res.statusCode      = Constants.WS_ERROR_CODE;
                        }
                        else if(Cres.Result==true && (Decimal.valueof(Cres.CibilScore)==Utility.getCibilTScore('Neg') || ( Decimal.valueof(Cres.CibilScore)>=1 && Decimal.valueof(Cres.CibilScore)<=5))){
                            system.debug('-1 Value in CIBIL');
                            list<genesis__Applications__c>  Applist=[select id,genesis__Account__c,Application_Stage__c,Sub_Stage__c from genesis__Applications__c where ID=:ApplicationID];
                            if(Applist.size()>0){
                                Applist[0].Sub_Stage__c =Constants.InvalidCIBIL;
                                Applist[0].Application_Stage__c =Constants.APP_REJECTED_STAGE;
                                update  Applist[0];
                            }
                            res.errorMessage    = Constants.CIBILRejectedMsg;
                             res.status       =Constants.WS_ERROR_STATUS;
                            
                        }
                        else if(Cres.Result==true && String.valueOf(Cres.serviceType) == Constants.EXPERIAN && (Decimal.valueof(Cres.CibilScore)==Utility.getCibilTScore('Neg') || ( Decimal.valueof(Cres.CibilScore)>=1 && Decimal.valueof(Cres.CibilScore)<=10))){
                            system.debug('##### -1 for experian');
                            list<genesis__Applications__c>  Applist=[select id,genesis__Account__c,Application_Stage__c,Sub_Stage__c from genesis__Applications__c where ID=:ApplicationID];
                            if(Applist.size()>0){
                                Applist[0].Sub_Stage__c =Constants.InvalidCIBIL;
                                Applist[0].Application_Stage__c =Constants.APP_REJECTED_STAGE;
                                update  Applist[0];
                            }
                            res.errorMessage    = Constants.CIBILRejectedMsg;
                             res.status       =Constants.WS_ERROR_STATUS;
                        }
                        
                        else if(Cres.Result==true && Decimal.valueof(Cres.CibilScore)< 700 ){
                              list<genesis__Applications__c>  Applist=[select id,genesis__Account__c,Application_Stage__c,Sub_Stage__c from genesis__Applications__c where ID=:ApplicationID];
                              if(Applist.size()>0){
                                Applist[0].Sub_Stage__c =Constants.LowCIBILScore;
                                Applist[0].Application_Stage__c =Constants.APP_REJECTED_STAGE;
                                update  Applist[0];
                                res.errorMessage    = Constants.LowCIBILScoreMsg;   
                            	res.status       =Constants.WS_ERROR_STATUS;
                            }
                        }
                        else if(Cres.Result==true && Decimal.valueof(Cres.CibilScore) >= Utility.getCibilTScore('PLCibil') ){
                            System.debug('here to');
                            list<genesis__Applications__c>  Applist=[select id,genesis__Account__c,Application_Stage__c,Sub_Stage__c from genesis__Applications__c where ID=:ApplicationID];
                            if(Applist.size()>0){
                                Applist[0].Sub_Stage__c =Constants.AppCreateStage;
                                Applist[0].Application_Stage__c ='Saved Applications';
                                update  Applist[0];
                            }
                        }
                        
                    }// END of personal loan cibil score check
                    else{   
                        
                        if(Cres.Result==false ){
                            
                            list<genesis__Application_Parties__c>  GpList=[select id,genesis__Party_Account_Name__c,genesis__Application__c,Active__c from genesis__Application_Parties__c where genesis__Party_Account_Name__c=:AppID and genesis__Application__c=:ApplicationId and active__c=true and genesis__Party_Type__c !=: Constants.PRIMARY_APP];
                            
                            if(GpList.size()>0){
								if(!Utility.ISStringBlankorNull(appData.Sub_Type__c)){
								if(appData.Sub_Type__c==Constants.Sub_Type_Top_Up || appData.Sub_Type__c==Constants.Sub_Type_Take_Over){
								  genesis__Applications__c App=new genesis__Applications__c();
                                    App.Id=ApplicationId;
                                    App.Sub_Stage__c=Constants.LowCIBILScore;
									update App;
								}
								}
                                if(GpList[0].Active__c==true){
									
                                    GpList[0].Active__c=false;
                                    update  GpList[0];
                                } 
                            }
                            else{
                                list<genesis__Applications__c>  Applist=[select id,genesis__Account__c,Sub_Stage__c from genesis__Applications__c where ID=:ApplicationID];
                                if(Applist.size()>0){
                                    Applist[0].Sub_Stage__c =Constants.CIBILRejected;
                                    update  Applist[0];
                                }
                            } 
                            
                            res.status          = Constants.WS_ERROR_STATUS;
                            res.errorMessage    = Cres.Status;
                            res.statusCode      = Constants.WS_ERROR_CODE;
                        }
                        else if(Cres.Result==true && (appData.Sub_Type__c==Constants.Sub_Type_Top_Up || appData.Sub_Type__c==Constants.Sub_Type_Take_Over) &&  ((String.valueOf(Cres.serviceType) == Constants.Transunion || (String.valueOf(Cres.serviceType) == Constants.EXPERIAN )) && ( Decimal.valueof(Cres.CibilScore)<700 ))){
                         list<genesis__Application_Parties__c>  GpList=[select id,genesis__Party_Account_Name__c,genesis__Application__c,Active__c from genesis__Application_Parties__c where genesis__Party_Account_Name__c=:AppID and genesis__Application__c=:ApplicationId and active__c=:true ];
                            
                            if(GpList.size()>0){
                                if(GpList[0].Active__c==true){
                                    genesis__Applications__c App=new genesis__Applications__c();
                                    App.Id=ApplicationId;
                                    App.Sub_Stage__c=Constants.LowCIBILScore;
                                    GpList[0].Active__c=false;
                                    update  GpList[0];
                                    update App;
                                       res.errorMessage    = 'Low Cibil Score';//change commented as:'Customer CIBIL score is less than 650, loan cannot be processed' 
                            res.status       =Constants.WS_ERROR_STATUS;
                                    res.statusCode      = Constants.WS_ERROR_CODE;
                                } 
                            }
                        }
                        else if(Cres.Result==true && ((String.valueOf(Cres.serviceType) == Constants.Transunion && ( Decimal.valueof(Cres.CibilScore)>=1 && Decimal.valueof(Cres.CibilScore)<=4)) || (String.valueOf(Cres.serviceType) == Constants.EXPERIAN && ( Decimal.valueof(Cres.CibilScore)>=1 && Decimal.valueof(Cres.CibilScore)<=7)) || (Decimal.valueof(Cres.CibilScore)<Utility.getCibilTScore('Cibil') && Decimal.valueof(Cres.CibilScore)!=Utility.getCibilTScore('Neg') &&  Decimal.valueof(Cres.CibilScore)>10))){
                            system.debug('Wrong one for -1');
                            list<genesis__Application_Parties__c>  GpList=[select id,genesis__Party_Account_Name__c,genesis__Application__c,Active__c from genesis__Application_Parties__c where genesis__Party_Account_Name__c=:AppID and genesis__Application__c=:ApplicationId and active__c=true and genesis__Party_Type__c !=: Constants.PRIMARY_APP];
                            
                            if(GpList.size()>0){
								if(!Utility.ISStringBlankorNull(appData.Sub_Type__c)){
								if(appData.Sub_Type__c==Constants.Sub_Type_Top_Up || appData.Sub_Type__c==Constants.Sub_Type_Take_Over){
								  genesis__Applications__c App=new genesis__Applications__c();
                                    App.Id=ApplicationId;
                                    App.Sub_Stage__c=Constants.LowCIBILScore;
									update App;
								}
								}
                                if(GpList[0].Active__c==true){
                                    GpList[0].Active__c=false;
                                    update  GpList[0];
                                } 
                            }
                            else{
                                list<genesis__Applications__c>  Applist=[select id,genesis__Account__c,Sub_Stage__c from genesis__Applications__c where ID=:ApplicationID];
                                if(Applist.size()>0){
                                    Applist[0].Sub_Stage__c =Constants.LowCIBILScore;
                                    update  Applist[0];
                                }
                            } 
                            res.errorMessage    = 'Low Cibil Score';//change commented as:'Customer CIBIL score is less than 650, loan cannot be processed' 
                            res.status       =Constants.WS_ERROR_STATUS;
                            
                        }  //end trans
						  }
                 }
                    res.CibilResponse=Cres;
                    system.debug('##### TU Response '+Cres);
                    // Call KVB EMI after cibil got success.
                    CreateUnique_App.KvbEmiCalculation(AppID);
                    
                }
				else{
                    res.status          = Constants.WS_ERROR_STATUS;
                    res.errorMessage    = 'Please Select the TransUnion Type,AppID and ApplicationId';
                    res.statusCode      = Constants.WS_ERROR_CODE;
                    res.CibilResponse =null;
                    res.IDVResponse=null;
                }
                
                
                
                return res;  
            }
            catch(exception e){
                system.debug('Error: '+e.getMessage()+'&&&&& '+e.getStackTraceString()+' getLineNumber: '+e.getLineNumber());
                res.status          = Constants.WS_ERROR_STATUS;
                res.errorMessage    = 'Please pass the Valid Request'+' AT '+e.getLineNumber()+e.getMessage()+e.getStackTraceString();
                res.statusCode      = Constants.WS_ERROR_CODE;
                res.CibilResponse =null;
                res.IDVResponse=null; 
                return res;
            }
        }
        return null;
    }
}