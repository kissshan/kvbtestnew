/*
* Name    : WS_CreateApplicant 
* Company : ET Marlabs
* Purpose : This class is used to Create applicant and all related partys
* Author  : Venugopal N
-----------------------------------------------------------------------
   Version  Date         Author             Remarks                                                 
  =======   ==========   =============  ==================================
   V1.1    29-Sep-2018    Venu          Added party level Kyc field
*******************************************************************************************/
public class PartyService {
    
   
    public static genesis__Application_Parties__c createParty(id AccId,String PartyType,string RelationToBorrower,id AppID,Id ParentAppID){
        genesis__Application_Parties__c  party = createPartyRep(null,AccId,PartyType,RelationToBorrower,AppID,ParentAppID,null);
        return party;
    }
    public static genesis__Application_Parties__c createPartyRep(ApplicantService.borrowerDetail basicDetails,id AccId,String PartyType,string RelationToBorrower,id AppID,Id ParentAppID,String ProdType){    
        genesis__Application_Parties__c  party = new genesis__Application_Parties__c();
        
        party.genesis__Party_Account_Name__c = Accid;
        party.genesis__Party_Type__c = PartyType;
        party.genesis__Application__c = AppID;
        party.Key_Contact__c=ParentAppID;
        party.Relationship_to_Borrower__c=RelationtoBorrower;
		if(!Utility.ISStringBlankorNull(basicDetails.iskyc))
   			 party.IsKYC__c=boolean.valueOf(basicDetails.iskyc) ;   //V1.1
        //if(ProdType != null){
        party.Product_Type__c = ProdType; 
        //}
       
        insert party;
        return party;   
    }
    
    // using Applicant ID
    public static list<genesis__Application_Parties__c> getpartys(string accid,string AppID){
        return [select id,genesis__Party_Account_Name__c,Active__c,name,genesis__Application__c from genesis__Application_Parties__c 
                where   genesis__Party_Account_Name__c =:accid AND genesis__Application__c=:AppID AND Active__c =:true];
        
    }
    
    // Using Application ID
    public static list<genesis__Application_Parties__c> getApppartys(string appid){
        return [select id,genesis__Party_Account_Name__c,Active__c,genesis__Application__c from genesis__Application_Parties__c 
                where   genesis__Application__c =:appid AND Active__c =:true];
        
    }
}