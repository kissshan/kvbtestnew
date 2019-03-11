/*
* Name    : WS_Digio_Doc_Gen_PL
* Company : ET Marlabs
* Purpose : This class is used to Generate Digio document from FE
* Author  : Ashok
-----------------------------------------------------------------------
   Version  Date         Author             Remarks                                                 
  =======   ==========   =============  ==================================
   V1.1    29-Aug-2018    Braj          Changes in sanction document generation structure call
   v1.2    14-Aug-2018    Braj          Skip Payment Acknowledgement doc generation for Vehicle loan
   v1.3    30-Nov-2018    Braj          Added condition after agreement letter is getting generated twice
   v1.4    06-Dec-2018    Braj          Send instant success and blank message as per discussion with Akshaya
*******************************************************************************************/
@RestResource(urlMapping='/generateDigioDoc')
global class WS_Digio_Doc_Gen_PL {
    
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
        public String DocGenFail;//Docgen_Fail__c
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
           //V1.1-start
            genesis__Applications__c getApps = [select id, Document_Generation__c, Name,Record_Type_Name__c,Sanction_Doc_Generation_Check__c from genesis__Applications__c where id=:ApplicationID];
            if(getApps.Record_Type_Name__c == Constants.VL2W || getApps.Record_Type_Name__c == Constants.VL4W) {
                VL_Digio_Services.docGenAndSignDocVL(ApplicationID,Constants.VLSANCTIONLETTER);
                System.debug('##### Inside VL letter');
            } else if(getApps.Record_Type_Name__c == Constants.PERSONALLOAN){
                //v1.4
                PL_Digio_Services.docGenAndSignDocPL(ApplicationID,Constants.PRE_APPROVE_SANCTION_PL);
                System.debug('##### Inside PL letter');
            }
            //V1.1-end
            if(getApps.Sanction_Doc_Generation_Check__c == True){
                system.debug('##### Doc Success .. '+ getApps.Sanction_Doc_Generation_Check__c);
                List<Account> accList = queryService.accList(ApplicationID);
                System.debug('accList=='+accList);
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
            }else{
                res.statusCode     = '200';
                res.status         = 'Success';//v1.4
                res.errorMessage   = '';//v1.4
            }
            System.debug('res=='+res);
           return res;
            
        }catch(QueryException qe){
            res.statusCode     = '400';
            res.status         = 'ERROR';
            res.errorMessage   = 'Exception Occurred please Retry to generate document';
            return res;         
        } 
    }

}