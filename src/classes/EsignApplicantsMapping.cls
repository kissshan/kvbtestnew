/*
* Name      : EsignApplicantsMapping
* Company   : ET Marlabs
* Purpose   : Handler class for DocumentAPplicantCreation.
* Author    : 
*/
public class EsignApplicantsMapping {
    
    public static void CreateApplicantSign(Digio_Document_ID__c DDI,string Appid){
        try{
            map<id,id> AppDocID=new map<id,id>();
            List<Document_Applicant__c> DOCAppList=new List<Document_Applicant__c>();
            genesis__Applications__c App=[select id,genesis__Account__r.Employment_Type__c,genesis__Account__r.Net_Monthly_Income__c,(select id,genesis__Party_Type__c,genesis__Party_Account_Name__r.Employment_Type__c,genesis__Party_Account_Name__r.Net_Monthly_Income__c from genesis__Application_Parties__r where Active__c=true) from genesis__Applications__c where ID =:Appid];
            
            //  if(DDI.Name==Constants.Execution_Certificate_C11_HL  || DDI.Name==Constants.Acknowledgement_For_Sanction){
            AppDocID.put(App.genesis__Account__r.id, DDI.id);
            for(genesis__Application_Parties__c parti:App.genesis__Application_Parties__r){
                
                if(parti.genesis__Party_Type__c==Constants.Co_Borrower || parti.genesis__Party_Type__c==Constants.Gurantor){
                    AppDocID.put(parti.genesis__Party_Account_Name__r.id, DDI.id);
                    
                }
            }
            
            //  }
            
            for(string s:AppDocID.keySet()){
                Document_Applicant__c DocApp=new Document_Applicant__c();
                DocApp.Account__c=s;
                DocApp.Digio_Document_ID__c=AppDocID.get(s);
                
                DOCAppList.add(DocApp);
                
                
            }
            if(DOCAppList.size()>0){
                Database.insert(DOCAppList, false) ;
            }
            // insert 
        }
        catch(exception e){
            
            system.debug('eeee'+e.getLineNumber()+'trace'+e.getStackTraceString());
        }
    }
    
    //Adding stamp charge
    public static void ApplicantCreating(List<Digio_Document_ID__c> DList){
        try{
            for(Digio_Document_ID__c DD : DList) {
                System.debug('DD.Application__r.Property_State__c '+DD.Application__r.Property_State__c);
                System.debug(dd);
                List<Stamping_Charges__mdt> stampChargeAmt =[Select ID,MasterLabel,Declaration_Of_Title_Mortgage__c,Declaration_of_Original_Mortgage__c,
                                                             Create_Mortgage_Charges__c,Housing_Loan_Agreement__c,Agreement_of_Guarantee__c 
                                                             From Stamping_Charges__mdt Where MasterLabel =: DD.Application__r.Property_State__c Limit 1];
                System.debug('TEst stampChargeAmt '+stampChargeAmt);
                if(stampChargeAmt.size()>0){
                    if(DD.Name == Constants.A23_HL ){
                        DD.Stamp_Charges__c = stampChargeAmt[0].Housing_Loan_Agreement__c != null ? stampChargeAmt[0].Housing_Loan_Agreement__c : 0;
                    }
                    else if(DD.Name == Constants.A46_HL){
                        DD.Stamp_Charges__c = stampChargeAmt[0].Agreement_of_Guarantee__c != null ? stampChargeAmt[0].Agreement_of_Guarantee__c : 0;
                    }
                    else if(DD.Name == Constants.B1_HL){
                        DD.Stamp_Charges__c = stampChargeAmt[0].Declaration_Of_Title_Mortgage__c != null ? stampChargeAmt[0].Declaration_Of_Title_Mortgage__c : 0;
                    }
                    else if(DD.Name == Constants.B2_HL){
                        DD.Stamp_Charges__c = stampChargeAmt[0].Declaration_of_Original_Mortgage__c != null ? stampChargeAmt[0].Declaration_of_Original_Mortgage__c : 0;
                    }
                    else if(DD.Name == Constants.B17_HL){
                        DD.Stamp_Charges__c = stampChargeAmt[0].Create_Mortgage_Charges__c != null ? stampChargeAmt[0].Create_Mortgage_Charges__c : 0;
                    }   
                }
            }        
        }Catch(exception e){
            
        }
        
    }
    //For Update DMS UUID for Manual Esign
    public static void getUUid_ForManualEsign(List<Digio_Document_ID__c> newListOfDigioDoc, List<Digio_Document_ID__c> oldListOfDigioDoc,Map<id,Digio_Document_ID__c> newMapOfDigioDoc,Map<id,Digio_Document_ID__c> oldMapOfDigioDoc){
        try{
            for(Digio_Document_ID__c	digioDocObj	:   newMapOfDigioDoc.values()){
                if(digioDocObj.Document_ID__c !=null && digioDocObj.Document_ID__c !=''){
                    if(digioDocObj.Document_ID__c != oldMapOfDigioDoc.get(digioDocObj.Id).Document_ID__c){
                    	callWs_UploadDMSDocument(digioDocObj.Id,digioDocObj.Document_ID__c);    
                    }    
                }
            }
        }catch(Exception ex){
        	System.debug('Exception ::'+ ex.getMessage());
        	HandleBusinessException.captureError('EsignApplicantsMapping', 'getUUid_ForManualEsign', ex);     
        }    
    }
    @future(CallOut =true)
    public static void callWs_UploadDMSDocument(String digioId,String attachmentId){
        try{
            if(digioId !=null && digioId !='' && attachmentId !=null && attachmentId !=''){
				Attachment	attachmentObj	=	[select id,ParentId,Name,ContentType,Body from  Attachment where id =:attachmentId];
                Digio_Document_ID__c	digioDocumentObj	=	[select id,Name,Application__c,Application__r.CustomerID__c,Application__r.Record_Type_Name__c,Document_ID__c from Digio_Document_ID__c where id =:digioId];
				if(digioDocumentObj !=null && attachmentObj !=null){
                    WS_UploadDMSDocument.getAttachement(digioDocumentObj.Application__c,digioDocumentObj.Application__r.CustomerID__c,digioDocumentObj.Application__r.Record_Type_Name__c,digioDocumentObj.Id,attachmentObj,'');
                }                
            }    
        }catch(Exception ex){
        	System.debug('Exception ::'+ ex.getMessage());
        	HandleBusinessException.captureError('EsignApplicantsMapping', 'callWs_UploadDMSDocument', ex);    
        }
    }
}