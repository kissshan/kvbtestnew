/*
* Name    : WS_Digio_Doc_Fetch_HL
* Company : ET Marlabs
* Purpose : This class is used to Fetch Digio document for Esign
* Author  : Subas
-----------------------------------------------------------------------
   Version  Date         Author             Remarks                                                 
  =======   ==========   =============  ==================================
   v1.1    17-Aug-2018    Braj          Added application query and skip Payment Acknowledgement doc generation for Vehicle loan
*******************************************************************************************/
@RestResource(urlMapping='/getDgioDoc')
global class WS_Digio_Doc_Fetch_HL {
    
    global class DetailResponse extends WS_Response{
        public List<Applicant_DETAILS> Applicant;
        public DetailResponse(){
            Applicant = new List<Applicant_DETAILS>();
        }
    }
    
    public class Applicant_DETAILS{
        public String Applicant_Name;
        public String Applicant_Id;
        public String Email;
        public String MobileNo;
        public List<DigioDoc_Details> DigioDoc_Details;
        public String DocSuccess;//Sanction_Doc_Generation_Check__c
    }
    
    public class DigioDoc_Details{
        public String Doc_Id;
        public String Doc_Name;
        public String Digio_Doc_Id;
        public String eSigned;            
    }
    @httpGet
    global static DetailResponse getDetails(){
        
        RestRequest req = Restcontext.request;
        RestResponse restRes = Restcontext.response;
        
        DetailResponse res = new DetailResponse();
        String ApplicationID = req.params.get('appId');
        Boolean DocStatus;
        try{
            genesis__Applications__c getApps = queryService.getApplication(ApplicationID);//v1.1
            List<Account> accList = queryService.accList(ApplicationID);
            res.Applicant = new List<Applicant_DETAILS>();
            for(Account acc: accList){
                Applicant_DETAILS ad = new Applicant_DETAILS();
                ad.Applicant_Name = acc.Name;
                ad.Applicant_Id = acc.Id;
                ad.Email = acc.PersonEmail;
                ad.MobileNo = acc.PersonMobilePhone;
                ad.DigioDoc_Details = new List<DigioDoc_Details>();
                for(Document_Applicant__c accDoc : acc.Document_Applicants__r){
                    if(accDoc.Digio_Document_ID__r.Application__c == ApplicationID){
                        //v1.1-start
                        if((getApps.Record_Type_Name__c == Constants.VL2W || getApps.Record_Type_Name__c == Constants.VL4W) && (accDoc.Digio_Document_ID__r.Name==Constants.VLDEALERACK ||accDoc.Digio_Document_ID__r.Name==Constants.VLCover)){
                            continue;
                        }
                        //v1.1-end
                        DigioDoc_Details dd = new DigioDoc_Details();
                        dd.Doc_Id = accDoc.Id;
                        dd.Doc_Name = accDoc.Digio_Document_ID__r.Name;
                        dd.Digio_Doc_Id = accDoc.Digio_Document_ID__r.Document_ID__c;
                        dd.eSigned = String.ValueOf(accDoc.eSigned__c);
                        ad.DigioDoc_Details.add(dd);
                        DocStatus = accDoc.Digio_Document_ID__r.Application__r.Sanction_Doc_Generation_Check__c;
                        }
                }
                ad.DocSuccess = String.valueOf(DocStatus);
                res.Applicant.add(ad);
            }
            return res;
            
        }catch(QueryException qe){
            res.statusCode      = '400';
            res.status         = 'ERROR';
            res.errorMessage   = 'No Document Found.';
            return res;         
        } 
    }   
}