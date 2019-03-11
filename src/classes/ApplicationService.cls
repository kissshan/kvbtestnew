/*
* Name    : ApplicantionService
* Company : ET Marlabs
* Purpose : This class is used to Create applicant from App
* Author  : Venugopal N
-----------------------------------------------------------------------
   Version  Date         Author             Remarks                                                 
  =======   ==========   =============  ==================================
   V1.1    28-Sep-2018    Venu          Fetching and creating Application Service
  
*******************************************************************************************/
public class ApplicationService {
    //* V1.1 Start 
  /*  public static genesis__Applications__c createApplication(id AccId,String RTypeName,string SourcedBy,string sourcedbyOffice){
        genesis__Applications__c  App = new genesis__Applications__c();
        app = createApplication2(AccId,RTypeName,SourcedBy,sourcedbyOffice,null,null,null);
        return app;
    }
    */
    public static genesis__Applications__c createApplication2(id AccId,String RTypeName,WS_CreateApplicant.Co_applicant ApplicationDet){
        // string Appname;

        Id AppRecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(RTypeName).getRecordTypeId(); 

        genesis__Applications__c  App = new genesis__Applications__c();
        
        App.genesis__Account__c=AccId;
        app.RecordTypeId=AppRecordTypeId;
        app.Sourced_By__c=ApplicationDet.Sourced_by;
        app.Sourced_By_Office__c=ApplicationDet.Sourced_by_office;
        if((ApplicationDet.LoanType == null || ApplicationDet.LoanType == '') && ApplicationDet.AppSubType!=Constants.Sub_Type_Top_Up) {
			app.genesis__CL_Product__c = getProduct(KVB_Company_Details__c.getOrgDefaults().HomeLoanName__c).id;
        }else if(ApplicationDet.LoanType == 'LAP'){
            app.genesis__CL_Product__c = getProduct(KVB_Company_Details__c.getOrgDefaults().LAP_NAME__c).id;
        }else if(ApplicationDet.LoanType == 'PL'){
            app.genesis__CL_Product__c = getProduct(KVB_Company_Details__c.getOrgDefaults().PL_NAME__c).id;
        }else if(ApplicationDet.LoanType == 'VL4W'){
            app.genesis__CL_Product__c = getProduct(KVB_Company_Details__c.getOrgDefaults().VL4W__c).id;
        }else if(ApplicationDet.LoanType == 'VL2W'){
            app.genesis__CL_Product__c = getProduct(KVB_Company_Details__c.getOrgDefaults().VL2W__c).id;
        }
        else if(ApplicationDet.AppSubType == Constants.Sub_Type_Top_Up){
            app.genesis__CL_Product__c = getProduct(KVB_Company_Details__c.getOrgDefaults().Topup_Name__c).id;
        }
        if(!Utility.ISStringBlankorNull(ApplicationDet.AppSubType))
            app.Sub_Type__c=ApplicationDet.AppSubType;
        system.debug(ApplicationDet.AppSubType);
        app.Branch_Code__c = ApplicationDet.BranchCode;
        app.Branch_Name__c = ApplicationDet.BranchName;
        String Owner = ApplicationDet.BranchCode != null ? AssignBranch.getUser(ApplicationDet.BranchCode) : null;
        if(!String.isBlank(Owner )){
            app.OwnerId = Owner;
        }   
        // app.genesis__CL_Product__c=getProduct(Constants.HomeLoanName).id;
        insert App;
        // Appname=App.name;
        return App;   
    }
    // V1.1 End 29_9_18
    public static genesis__Applications__c getApplication(string AccountID){
        system.debug('prashant:--'+AccountID);
        return [select id,Name,genesis__Account__c,Record_Type_Name__c,Pre_Approved_Flag__c,Sub_Type__c from genesis__Applications__c where ID =:AccountID order by Createddate desc Limit 1];
        
    }
    public static clcommon__CL_Product__c getProduct(String name){
        
        return   getProducts(new list<String>{name}).size()>0 ?getProducts(new list<String>{name})[0]:null;
        
        
    }
    
    public static list<clcommon__CL_Product__c> getProducts(List<String> prodNames){
        return [select id,Name,clcommon__Product_Name__c,Product_Code__c from clcommon__CL_Product__c where clcommon__Product_Name__c IN:prodNames];
    }
    
}