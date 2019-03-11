/**
* Created by ET-MARLABS on 16-01-2019.
*/

public with sharing class SanctionAuthorityModel {
    public static Map<Id,clcommon__CL_Product__c> getProductWithAuthorities(set<String> prodIds){
        return new Map<Id,clcommon__CL_Product__c> ([Select Id,name, (Select Id,Name,Limit_End_Range__c,Limit_Start_Range__c,Security_Coverage_Start_Range__c,Security_Coverage_End_Range__c,Product__c from Product_Sanction_Authorities__r) from clcommon__CL_Product__c where id IN:prodIds]);
    }
    public static genesis__Applications__c getApplicationInfo(String appId){
        return [Select Id,name,OwnerId,New_to_Business__c,Type__c,genesis__Account__c,genesis__Account__r.Overall_Exposure__c,RecordType.DeveloperName from genesis__Applications__c where id=:appId];
    }
    public static User getUserInfoById(String ownerId){
        return [Select id,UserRole.Name,UserRoleId,Designation__c,Division,Name from User where Id=:ownerId];
    }
    public static List<Facility__c> getAllFacilities(String appId){
        return [Select Id,BRE_Limit__c,Type__c,Is_Primary_Security_Required__c,Is_Collateral_Security_Required__c,Collateral_Security_Coverage__c,Primary_Security_Coverage__c,(Select Id,Name,Role__c,Highest_Authority__c from Facilities__r),MCLR_Rate__c,CL_Product__r.Facility_Code__c,Tenure__c,Holiday_Period__c,Recommended_Days__c,Recommended_Rate__c,Existing_Spread__c,Recommended_Limit__c,CL_Product__c,CL_Product__r.clcommon__Product_Name__c,Limit_Amount__c,Existing_Limit__c,Existing_Rate__c,CL_Product__r.Product_Code__c,
                Account_Number__c,Application__c,Purpose_of_Loan__c,Total_Loan_Amount__c,Balance_Outstandings__c,New_Limit_Amount__c,Over_Due__c,Product_Name__c,Requested_Amount__c,Limit_Period_In_Days__c,
                Margin__c,Limit_end_date__c,Bank_Statement_from_Date__c,Bank_Statement_to_Date__c,Bank_Name__c,Type_of_Loan__c,Limit_start_date__c,Takeover__c,NTB_Facility_Category__c,
                Purpose_of_Shifting__c,NTB_Product_Type__c,Start_Date_Other__c,NTB_Facility_Type__c,Other_Facility_Name__c,Unique_Number_for_NTB__c,Reason_for_Enhancement__c,
                (SELECT Id FROM Facility_Security__r)
                from Facility__c where Application__c=:appId AND RecordType.DeveloperName ='Parent'];
    }
    public static list<Overall_Exposure__mdt> getOverallExposure(){
        return [Select Id,DeveloperName,Order__c,MasterLabel,Exposure_End_Range__c,Exposure_Start_Range__c from Overall_Exposure__mdt ];
    }
    public static List<Authority_Hierarchy_Level__mdt> getAuthorityLevel(){
        return [Select MasterLabel,DeveloperName,Authority_Level__c,EAE_Limit__c,Margin_OCC_Manufacturing_Receivables__c,Margin_OCC_Manufacturing_Stock__c,Margin_OCC_Trading_Stock__c,Margin_SOD__c from Authority_Hierarchy_Level__mdt];
    }
    public static Task_Escalation_Matrix__mdt fetchEscalationRecord_level1(string name)
    {
        return [select id,Max_Days_Range__c,Min_Days_Range__c from Task_Escalation_Matrix__mdt where MasterLabel=:name];
    }

    
}