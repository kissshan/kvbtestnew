/*
* Name    : WS_UpdateEsignDocStatus
* Company : ET Marlabs
* Purpose : This class is used to Esign Status
* Author  : Venu
-----------------------------------------------------------------------
   Version  Date         Author             Remarks                                                 
  =======   ==========   =============  ==================================
    v1.1    17-Sep-2018    Braj         #VL741:Initiate CBS call on completion of all doc esign
*******************************************************************************************/
@RestResource(urlMapping='/UpdateEsignDocStatus')
global class WS_UpdateEsignDocStatus {
    
    public DgioDocStatus DgioStatus;
    
    global class Response extends WS_Response{
        public Response(){
            
        }
    }
    public class DgioDocStatus{
        public String eSignStatus;
        public String docId;
    }
    
    @HttpPost
    global static Response getstatus(){
        RestRequest req      = Restcontext.Request;
        Response res         = new Response();    
        
        if(req == null || req.requestBody == null){
            res.status          = Constants.WS_ERROR_STATUS;
            res.errorMessage    = Constants.WS_REQ_BODY_IS_NULL;
            res.statusCode      = Constants.WS_ERROR_CODE;
            return res;            
        }
        else{
            
            try{
                String jsonData  = req.requestBody.toString();
                DgioDocStatus resSt = (DgioDocStatus)Json.deserialize(jsonData, DgioDocStatus.class);
                Document_Applicant__c doc = new Document_Applicant__c();
                doc.eSigned__c = Boolean.valueOf(resSt.eSignStatus);
                doc.Id = resSt.docId;
                
                //Download document service 
                if(Doc.eSigned__c==true){
                    Document_Applicant__c Dc = [select id,Digio_Document_ID__r.Application__r.Id,Digio_Document_ID__r.Document_ID__c,Digio_Document_ID__r.name,Digio_Document_ID__r.Application__c,Account__c,eSigned__c from Document_Applicant__c where id=:doc.id]; 
                    system.debug('111111111'+Dc.Digio_Document_ID__r.Application__c);
                    List<Document_Applicant__c> Doclist = [select id,Name,Account__c,eSigned__c from Document_Applicant__c where  Digio_Document_ID__c=:Dc.Digio_Document_ID__c];
                    integer listSize=0;
                    integer plistSize=0;
                    for(Document_Applicant__c dList:Doclist){
                        if(dList.eSigned__c==true){
                            System.debug(dList.Name);
                            listSize++;
                        }
                    }
                    System.debug(Doclist.size()+'-----'+listSize);
                    if(Doclist.size()==(listSize+1)){
                        system.debug('AAAAAsuccess'+Dc.Digio_Document_ID__r.Document_ID__c);
                        String pdfContent = Digioe_Docs_Service.downloadDocument(Dc.Digio_Document_ID__r.Document_ID__c);  
                        system.debug('pdfContent'+pdfContent);
                        //  if(Dc.Digio_Document_ID__r.Application__r.Record_Type_Name__c != 'LAP' && Dc.Digio_Document_ID__r.name != 'LAP_B1'){
                        if(!Dc.Digio_Document_ID__r.name.contains('LAP_B1')){
                            Digioe_Docs_Service.upsertDoc(Dc.Digio_Document_ID__r.Application__c,Dc.Digio_Document_ID__r.name+'.pdf',pdfContent);
                        }
                        
                        // }
                        // else{
                        //     Digioe_Docs_Service.upsertLAPDoc(Dc.Digio_Document_ID__r.Application__c,Dc.Digio_Document_ID__c,pdfContent);
                        // }
                        list<genesis__Applications__c> application = [select id,Legal_desk_state_flag__c,Initiate_Disbursement__c, Name, Record_Type_Name__c,
                                                                      Sub_Stage__c,Loan_Purpose__c,(select id,genesis__Party_Type__c from genesis__Application_Parties__r
                                                                                                    where Active__c=true AND Company__c = false AND genesis__Party_Type__c=:Constants.Gurantor),
                                                                      (select id,Name,Document_ID__c,Status__c from Digio_Documnet_ID__r),(select id,Active__c from genesis__Collaterals__r where active__c=true),(select id,subject,Status from tasks) 
                                                                      from genesis__Applications__c where ID =: Dc.Digio_Document_ID__r.Application__c limit 1];
                        if(Dc.Digio_Document_ID__r.name =='B1' || Dc.Digio_Document_ID__r.name =='B2'){
                            if(application[0].Loan_Purpose__c == Constants.IdentifiedProperty || application[0].Loan_Purpose__c == Constants.ConstructionOn){
                                Boolean StageUpdate=false;
                                Boolean Taskupdate=false;
                                map<string,string> TaskSubject=new map<string,string>();
                                for(task t:application[0].tasks){
                                    if(!TaskSubject.containsKey(t.subject)){
                                        TaskSubject.put(t.subject,t.status);
                                    }
                                }
                                if(TaskSubject!=null){
                                if(TaskSubject.containskey('SI/ E-mandate')){
                                    if(TaskSubject.get('SI/ E-mandate')=='Completed'){
                                         Taskupdate=true;
                                    }
                                }
                                else{
                                      Taskupdate=true;
                                }
                                }
                                for(Digio_Document_ID__c DDID:application[0].Digio_Documnet_ID__r){
                                    if(((Dc.Digio_Document_ID__r.name =='B1' && DDID.Name=='B2') || (Dc.Digio_Document_ID__r.name =='B2' && DDID.Name=='B1' )) && DDID.Status__c=='Completed' && !StageUpdate){
                                        StageUpdate=true;
                                    }
                                }
                                if(StageUpdate && Taskupdate && application[0].Sub_Stage__c!=Constants.App_Process_Closed){
                                    genesis__Applications__c Ap=new genesis__Applications__c();
                                    Ap.id=Dc.Digio_Document_ID__r.Application__c ;
                                    Ap.Sub_Stage__c=Constants.App_Process_Closed;
                                    update Ap;
                                }
                            }
                        }
                        set<string> DocIDs=new set<string>();
                        Integer StatusCount = 0; // VL Doc Esign Count
                        for(Digio_Document_ID__c DD:application[0].Digio_Documnet_ID__r){
                            if(!Utility.ISStringBlankorNull(DD.id )){
                                //v1.1-start
                                if((application[0].Record_Type_Name__c == Constants.VL2W || application[0].Record_Type_Name__c == Constants.VL4W) && DD.Name==Constants.VLDEALERACK){
                                    continue;
                                }
                                //v1.1-end
                                DocIDs.add(DD.id);
                                if(DD.Status__c == 'Completed'){
                                    StatusCount++;
                                }
                            }
                        }
                        if(DocIDs.size()>0){
                            List<Document_Applicant__c> ParentDoclist = [select id,Account__c,eSigned__c,Digio_Document_ID__c from Document_Applicant__c where  Digio_Document_ID__c IN: DocIDs];    
                            
                            for(Document_Applicant__c dList:ParentDoclist){
                                if(dList.eSigned__c==true){
                                    plistSize++;
                                }
                                system.debug(' eSigned__c ---> '+ plistSize);
                            }
                            System.debug(ParentDoclist.size()+'<--ParentDoclist ==> '+ ParentDoclist);
                            if(ParentDoclist.size()==(plistSize+1)){
                                genesis__Applications__c UpdateApp=new genesis__Applications__c();
                                UpdateApp.id=application[0].id;
                                LoanProcess_Config__mdt DocsCount = new LoanProcess_Config__mdt();
                                // PL Loan
                                if(application[0].Record_Type_Name__c == Constants.PERSONALLOAN){
                                    DocsCount = queryService.processingFee('PL');
                                    if(DocsCount.DocCount__c==application[0].Digio_Documnet_ID__r.size()){
                                        UpdateApp.Initiate_CBS_Call__c=true;
                                        if(application[0].Legal_desk_state_flag__c == false){
                                            application[0].Initiate_Disbursement__c = true;
                                        }
                                        UpdateApp.Sub_Stage__c = Constants.SUBSTAGE_DISBURSEMENTESIGN;
                                    }
                                }
                                // Home loan
                                else if(application[0].Record_Type_Name__c == Constants.HOMELOAN){
                                    //prashant singh---updated the hldoccount=2 on 12-10-2018
                                    integer HLDocCount=2;
                                    if(application[0].genesis__Application_Parties__r.size()>0){
                                        HLDocCount = HLDocCount+1;
                                    }
                                    if(application[0].Loan_Purpose__c==Constants.IdentifiedProperty || application[0].Loan_Purpose__c==Constants.ConstructionOn){
                                        HLDocCount = HLDocCount+1;
                                    }
                                    else  if(application[0].Loan_Purpose__c==Constants.Construction || application[0].Loan_Purpose__c==Constants.RepairHouse){
                                        HLDocCount = HLDocCount+2;
                                    }
                                    
                                    if(HLDocCount==application[0].Digio_Documnet_ID__r.size()  && application[0].Sub_Stage__c==Constants.SI_DETAILS_CAPTURED_SUBSTAGE){
                                        UpdateApp.Initiate_CBS_Call__c=true;
                                        UpdateApp.Sub_Stage__c = Constants.SUBSTAGE_DISBURSEMENTESIGN;
                                        if(application[0].Legal_desk_state_flag__c == false){
                                            application[0].Initiate_Disbursement__c = true;
                                        }
                                    }
                                }
                                // LAP
                                else if(application[0].Record_Type_Name__c == Constants.LAPLOAN){
                                    integer LAPDocCount=2;
                                    //commented after production issue
                                   /* if(application[0].genesis__Application_Parties__r.size()>0)
                                        LAPDocCount = LAPDocCount+1;*/
                                    
                                    if(application[0].genesis__Application_Parties__r.size()>0)
                                        LAPDocCount = LAPDocCount+1;
                                    
                                    if(application[0].genesis__Collaterals__r.size()>0)
                                        LAPDocCount = LAPDocCount + application[0].genesis__Collaterals__r.size();
                                    
                                    if(LAPDocCount==application[0].Digio_Documnet_ID__r.size() && Utility.checkIFTaskIsClosed(application[0].Id,'Approve associated business entity')){
                                        UpdateApp.Initiate_CBS_Call__c=true;
                                        UpdateApp.Sub_Stage__c = Constants.SUBSTAGE_DISBURSEMENTESIGN;
                                        if(application[0].Legal_desk_state_flag__c == false ){
                                            application[0].Initiate_Disbursement__c = true;
                                        }
                                    }
                                }else if(application[0].Record_Type_Name__c == Constants.VL2W || application[0].Record_Type_Name__c == Constants.VL4W){
                                    DocsCount = queryService.processingFee('VL');
                                    //v1.1-start
                                   
                                    if(DocsCount.DocCount__c == (StatusCount+1) ){
                                        UpdateApp.Initiate_CBS_Call__c=true;
                                        UpdateApp.Sub_Stage__c = Constants.SUBSTAGE_DISBURSEMENTESIGN;
                                        System.debug('UpdateApp >>> ' + UpdateApp);
                                    }
                                    System.debug('StatusCount >>> ' + StatusCount);
                                    //v1.1-end
                                }
                                update UpdateApp;
                            } 
                        }
                    }
                    
                    update doc;
                    res.status      = Constants.WS_SUCCESS_STATUS;
                    res.statusCode  = Constants.WS_SUCCESS_CODE;
                }
            }
            Catch(Exception e){
                res.status          = Constants.WS_ERROR_STATUS;
                res.errorMessage   = e.getMessage();
                res.statusCode  = Constants.WS_ERROR_CODE;
                system.debug('Exception::'+e.getLineNumber()+'error as'+e.getStackTraceString());
                
            }
        }
        return res;
    }
    
}