/**
 * Created by ET-MARLABS on 07-02-2019.
 */

public class LimitAssessmentModel {

    public static List<String> fyListWithEstimated = new List<String>{YearDataConstant.currFiscalYear, YearDataConstant.nthFiscalYear, YearDataConstant.n_1_FiscalYear,YearDataConstant.nextEstFiscalYear};
    public static List<String> fyList = new List<String>{YearDataConstant.currFiscalYear, YearDataConstant.nthFiscalYear, YearDataConstant.n_1_FiscalYear};

    public static List<M68_Balance_Sheet_Analysis__c> getM68ThreeYears(String customerId){
        try {
            List<M68_Balance_Sheet_Analysis__c> m68DataList = new List<M68_Balance_Sheet_Analysis__c>();

            m68DataList = SOQL_Util.getM68Data(customerId, fyListWithEstimated);
            return m68DataList;

        } catch (Exception e) {
            HandleBusinessException.captureError('LimitAssessmentModel', 'getM68ThreeYears', e);
            return null;
        }
    }
    public static List<Perfios__c> getPerfiosRecords(String custId){
        try {
            return [Select Id,Name,Applicant_Name__c,Total_InterestPaid__c,Fiscal_Year__c from Perfios__c where Applicant_Name__c=:custId And Fiscal_Year__c IN:fyList ];
        } catch (Exception e) {
            HandleBusinessException.captureError('LimitAssessmentModel', 'getPerfiosRecords', e);
            return null;
        }
    }
    public static New_Loan_Input__c getNewLoanInputRecord(String appId){

        String query ='SELECT ';
        Map<String, Schema.SObjectField> accountFieldMap = Schema.getGlobalDescribe().get( 'New_Loan_Input__c' ).getDescribe().fields.getMap();
        for(Schema.SObjectField s : accountFieldMap.values()){
            query = query + s.getDescribe().getName()+',';
        }
        query   = query.removeEnd(',');
        System.debug('Query =>'+query);
        query   = query + ',Application__r.BRE_Done__c from New_Loan_Input__c WHERE Application__c =\''+appId+'\' LIMIT 2';

        List<New_Loan_Input__c> newLoanInputrec = Database.query(query);
        for(New_Loan_Input__c newLoanRec:newLoanInputrec){
            if(newLoanRec.Application__r.BRE_Done__c){
                if(newLoanRec.Input_Given_By__c=='Manager'){
                    return newLoanRec;
                }
            }else{
                if(newLoanRec.Input_Given_By__c=='Customer'){
                    return newLoanRec;
                }
            }
        }
        return null;
        /*if(newLoanInputrec.size()==1){
            return newLoanInputrec[0];
        }else{
            return newLoanInputrec[0];
        }*/


    }
    public static List<Facility__c> getFacilities(string appId){
        if(appId != null && appId != '')
            return [Select Id,Date_of_Disbursement__c,NTB_Facility_Type__c,Active__c,Takeover__c,Name,Purpose_of_Loan__c,BRE_Limit__c,Recommended_Limit__c,Recommended_Rate__c,Existing_Rate__c,Existing_Limit__c,App_Facility_Type__c,Tenure__c from Facility__c where Application__c=:appId AND RecordType.DeveloperName ='Parent' And Active__c=true];
        else
          return null;
    }
    public static List<Facility__c> getActiveTlRecordTypeFacilities(String custId){
        try {
            List<genesis__Applications__c> tlAppRecord = [SELECT Id,Name from genesis__Applications__c where genesis__Account__c=:custId And RecordType.DeveloperName='Term_Loan'];
            if(!tlAppRecord.isEmpty()){
                return getFacilities(tlAppRecord[0].Id);
            }
        } catch (Exception e) {

        }
        return null;

    }
    public static genesis__Applications__c getapplnInformation(string appId){

        return [Select id,UNIQUE_KEY__c,genesis__Account__r.Constitution__c,genesis__Account__r.Industry_Type__c,No_of_years_of_operation__c,Name,Type__c,Deviation_Reason__c,Management_experience__c,Inward_cheque_return__c,Overall_Exposure__c,RecordType.DeveloperName,Processing_Fee__c,Processing_Charges__c,Is_Take_Over__c,New_to_Business__c,Legal_clearance__c,Request_Reason__c,Reason_for_Application__c,EAE_Renewal_Date_in_days__c,Is_Financial_security_Coverage_Less__c,Risk_Rating__c,Overall_Score__c,genesis__Account__r.Name,OwnerId,Committe__c,genesis__Account__r.Description,
                genesis__Account__r.Id,genesis__Account__r.Overall_Exposure__c,genesis__Account__r.CBS_Customer_ID__c,genesis__Account__r.Group_Name__c,Application_Stage__c,
                genesis__Account__r.Name_of_the_Chief_Person__c,Application_Status__c,Company_Profile__c,Key_Management_Profile__c,Beuro_Profile__c,Market_Profile__c,
                genesis__Account__r.Branch_Code__c,genesis__Account__r.SMA_Classification__c,genesis__Account__r.Date_of_Incorporation__c,genesis__Account__r.Branch_Name__c,genesis__Account__r.Line_of_Activity__c,
                Branch_Code__c,Branch_Name__c,Recommended_Security_Coverage__c,Security_coverage__c,genesis__Customer_Cash_Used_For__c from genesis__Applications__c where id=: appId];
    }
    public Static List<genesis__Application_Collateral__c> getAllApplicationColletrForApplication(String appId){
        return [SELECT id,Application__r.RecordType.DeveloperName,genesis__Collateral__r.Is_TL_Collateral__c,genesis__Collateral__r.RecordType.DeveloperName,genesis__Collateral__r.Machinery_Cost__c,genesis__Collateral__r.Chassis_Cost__c,genesis__Collateral__r.Body_Building_Cost__c,genesis__Collateral__r.ExShow_Room_Price__c,genesis__Collateral__r.ExshowRoomPrice_Api__c,genesis__Collateral__r.Total_Asset_Value__c,genesis__Collateral__r.Market_Value_2__c,Application__r.genesis__Account__r.Constitution__c,Facility__r.Account_Number__c,Application__r.Application_Stage__c,genesis__Collateral__r.Name,Facility__r.CL_Product__r.Facility_Code__c,genesis__Collateral__c,genesis__Collateral__r.clcommon__Value__c,Facility__r.Product_Name__c,Facility__r.BRE_Limit__c,genesis__Collateral__r.EM_Date__c,Facility__c,Security_Type__c,Application__r.Active__c,Facility__r.App_Facility_Type__c ,Facility__r.Takeover__c FROM genesis__Application_Collateral__c WHERE Application__c =: appId AND Facility__r.Active__c=true AND Security_Type__c='Primary Securities' And Facility__r.Takeover__c= false];
    }
    public static List<Current_Account__c> getOtherAccountsFromCustomer(String custId){
        try {
            return [Select Id,Name,Account__c,Tenure__c,Start_Date__c,Tenure_Start_Date__c,End_Date__c,Holiday_Period__c,Sanctioned_Amount__c,Interest_Rate__c,RecordType.DeveloperName from Current_Account__c where Account__c =:custId And RecordType.DeveloperName IN:new List<String>{'Term_Loan_other','WC_Other'}];
        } catch (Exception e) {
            HandleBusinessException.captureError('LimitAssessmentModel', 'getOtherAccountsFromCustomer', e);
            return null;
        }
    }
}