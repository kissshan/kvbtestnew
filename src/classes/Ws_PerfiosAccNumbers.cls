@RestResource(urlMapping='/CreatePerfios')

global class Ws_PerfiosAccNumbers {
    
    global class Response extends WS_Response{
        
        
        public List<Perfios__c> Bank_AccountNumbers;
        
    }
    
    Public cls_PerfDetails PfDetails;
    
    public class cls_PerfDetails{
        Public string ClientID;
        public List<BankWrapper> Account_Numbers;
        public string ApplicationId;
    }
    public class BankWrapper{
        Public string BankAccNumber;
        public string BankName;
        public string RecordID;
        public string Deleted;
    }
   
    
    @HttpPost
    global static Response CreateBankaccounts(){
        
        RestRequest req      = Restcontext.Request;
        Response res         = new Response();    
        
        if(req == null || req.requestBody == null){
            res.status          = Constants.WS_ERROR_STATUS;
            res.errorMessage    = Constants.WS_REQ_BODY_IS_NULL;
            res.statusCode      = Constants.WS_ERROR_CODE;
            return res;            
        }else{
            
            try{
                
                String jsonData  = req.requestBody.toString(); 
                system.debug('jsonData:::'+jsonData);
                
                cls_PerfDetails Cperfios=(cls_PerfDetails)Json.deserialize(jsonData, cls_PerfDetails.class);
                system.debug('Cperfios'+Cperfios);
                List<Perfios__c> pf=new List<Perfios__c>();
                set<ID>  PFIds=new set<ID>();
                AppAccountNMIJunction__c accAppNMIJunction = new AppAccountNMIJunction__c();
                for(BankWrapper reqobj :Cperfios.Account_Numbers){
                   
                    
                    if(!Utility.ISStringBlankorNull(reqobj.RecordID) && !Utility.ISStringBlankorNull(reqobj.Deleted)){
                        PFIds.add(reqobj.RecordID);
                    }else{
                        Perfios__c p=new Perfios__c();
                        if(!Utility.ISStringBlankorNull(reqobj.BankAccNumber))
                            p.Bank_Account_Number__c =reqobj.BankAccNumber;
                        if(!Utility.ISStringBlankorNull(Cperfios.ClientID))
                            p.Applicant_Name__c=Cperfios.ClientID;
                        if(!Utility.ISStringBlankorNull(reqobj.BankName))
                            p.Bank_Name__c=reqobj.BankName;
                        if(!Utility.ISStringBlankorNull(Cperfios.ApplicationId))
                        {p.Application__c = Cperfios.ApplicationId;
                         p.Application_id__c = Cperfios.ApplicationId;}
                        pf.add(p);
                    }
                    //if(!Utility.ISStringBlankorNull(apps.id))
                    //p.Application_id__c = apps.id;      
                    
                }
                                     System.debug('pf:::'+pf);
                if(pf.size() > 0){
                    insert pf;
                    
                }
                 System.debug('pfIDS:::'+PFIds);
                if(PFIds!=null && PFIds.size()>0){
                    List<Perfios__c> PFlsit=[select id,Applicant_Name__c,IS_DELETED__c,Application__c from Perfios__c where ID IN:PFIds and Applicant_Name__c=:Cperfios.ClientID AND Application__c=:Cperfios.ApplicationId];
                    
                    system.debug(PFlsit);
                        if(PFlsit!=null && PFlsit.size()>0){
                        List<Perfios__c> UpdatePFList=new  List<Perfios__c>();
                        
                        for(Perfios__c per:PFlsit){
                             Perfios__c ps=new Perfios__c();
                            ps.IS_DELETED__c= true;
                            ps.active__c=false;
                            ps.id=per.id;
                            UpdatePFList.add(ps);
                        }
                             system.debug(UpdatePFList);
                        if(UpdatePFList!=null && UpdatePFList.size()>0){
                            update UpdatePFList;
                        }
                    }
                }

                res.Bank_AccountNumbers=pf;
                System.debug('res:::'+res);
                return res;
            }
            catch(exception e){
                system.debug('Error  :'+e.getStackTraceString()+'Line number  :'+e.getLineNumber()+'message:-'+e);
            }
        }
        return res;
    }
}