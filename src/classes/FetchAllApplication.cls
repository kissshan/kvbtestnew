/*
* Name    : FetchAllApplication
* Company : ET Marlabs
* Purpose : This class is used to application for Dashboard API
* Author  : Subas
*/
@RestResource(urlMapping='/getApplication')
global with sharing class FetchAllApplication {
    
    global class DetailResponse extends WS_Response{
        public List<AppReqWrapper> APPDETAILS;
        public DetailResponse (){  
            APPDETAILS = new List<AppReqWrapper>();
        }
    }   
    
    public class AppReqWrapper{
        public String ApplicationID;
        public String Stage;
        public String Primary_Applicant;
        public String ApplicationNo;
        public String CreateDate;
        public String ProductCode;
        public String DocGenSuccess;
        public string RecordType;
        public string LOS_CUSTOMER_SF_ID;
        public string LOS_CUSTOMER_NAME;
        public string TYPE;
        public string AppSubType;
    }
    
    @httpGet
    global static DetailResponse getDetails(){
        
        RestRequest req = Restcontext.Request;
        RestResponse restRes = Restcontext.response;
        DetailResponse res = new DetailResponse();
        try{    
            string dsaCode = req.params.get('dsaCode');
            string appStage = req.params.get('appStage');
            system.debug('**DSACODE**'+dsaCode+'**APPSTAGE**'+appStage);
            if(!String.isBlank(dsaCode)/* & !String.isBlank(appStage)*/){
                List<genesis__Applications__c> applist = queryService.getApplication(dsaCode,appStage); 
                res.APPDETAILS  = new List<AppReqWrapper>(); 
                for(genesis__Applications__c app : applist){
                    AppReqWrapper ab                    = new AppReqWrapper();
                    ab.ApplicationID                    = app.Id;
                    ab.Primary_Applicant                = app.Primary_Applicant__c;
                    ab.Stage                            = app.Sub_Stage__c;
                    ab.ApplicationNo                    = app.Name;
                    ab.CreateDate                       = String.ValueOf(app.Created_Date__c);
                    ab.ProductCode                      = app.Product_Code__c;
                    ab.RecordType                       =  Utility.getBlankStringIfNull(app.RecordType.DeveloperName);
                    ab.LOS_CUSTOMER_SF_ID               =  Utility.getBlankStringIfNull(app.genesis__Account__c);
                    ab.LOS_CUSTOMER_NAME                =  Utility.getBlankStringIfNull(app.genesis__Account__r.Name);
                    ab.TYPE                             =  Utility.getBlankStringIfNull(app.Type__c);
                    ab.DocGenSuccess                    = String.ValueOf(app.Sanction_Doc_Generation_Check__c);
                    ab.AppSubType                       = app.Sub_Type__c!=null?app.Sub_Type__c:'';
                    res.APPDETAILS.add(ab);
                }        
            }
            /*else if(String.isBlank(dsaCode) & String.isBlank(appStage)){
                List<genesis__Applications__c> applist = queryService.getAllApplication();
                res.APPDETAILS  = new List<AppReqWrapper>();
                for(genesis__Applications__c app : applist){
                    AppReqWrapper ab                    = new AppReqWrapper();
                    ab.ApplicationID                    = app.Id;
                    ab.Primary_Applicant                = app.Primary_Applicant__c;
                    ab.Stage                            = app.Sub_Stage__c;
                    ab.ApplicationNo                    = app.Name;
                    ab.CreateDate                       = String.ValueOf(app.Created_Date__c);
                    ab.ProductCode                      = app.Product_Code__c;
                    ab.RecordType                       =  Utility.getBlankStringIfNull(app.RecordType.DeveloperName);
                    ab.LOS_CUSTOMER_SF_ID               =  Utility.getBlankStringIfNull(app.genesis__Account__c);
                    ab.LOS_CUSTOMER_NAME                =  Utility.getBlankStringIfNull(app.genesis__Account__r.Name);
                    ab.TYPE                             =  Utility.getBlankStringIfNull(app.Type__c);
                    ab.DocGenSuccess                    = String.ValueOf(app.Sanction_Doc_Generation_Check__c);
                    res.APPDETAILS.add(ab);
                }
            }*/
            return res;
            
        }catch(QueryException qe){
            res.statusCode      = '400';
            res.status         = 'ERROR';
            res.errorMessage   = 'No Applications Found.';
            return res;         
        }
    }
}