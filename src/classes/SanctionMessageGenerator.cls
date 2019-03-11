///change

/*@Class Name : SanctionMessageGenerator
 *@Purpose    : To generate sanction message based on four scenario (mentioned in the code), when sub stage change to personal detail captured. 
 *@Date       : 18/05/2018
 *@Author     : Ashish Jain
*/  
public class SanctionMessageGenerator {
    //this method is called by ApplicationTriggerHandler when perticular sub stage changed.
    public static void sanctionMessageMethod(List<genesis__applications__c> newAppList, Map<Id,genesis__Applications__c> oldAppMap, List<genesis__applications__c> oldAppList, Map<Id,genesis__Applications__c> newAppMap){
        try{
            Set<Id> appId = new Set<Id>();
            List<genesis__applications__c> listtoUpdate = new List<genesis__applications__c>();   
            List<genesis__applications__c> newAppIdList = new List<genesis__applications__c>();
            Map<String, SanctionMessage__c> sanctionMessageCS = new Map<String, SanctionMessage__c>();
            for(SanctionMessage__c sm :[select name, Id, Message__c from SanctionMessage__c]){
                sanctionMessageCS.put(sm.name,sm);
            }
            system.debug('sanctionMessageCS==++'+sanctionMessageCS);
            for(genesis__applications__c app : newAppList){
                appId.add(app.Id);
            }
           /* newAppIdList = [ select id, Sanction_Message__c, Sub_Stage__c, Perfios_Captured__c , Additional_Income_Approval__c, genesis__Account__r.Same_Present_Address_Permanent_Address__c, genesis__Account__r.Are_you_An_Existing_Customer__c from genesis__applications__c where id IN : appId];*/
            
            List<genesis__Application_Parties__c> partylist=[select id,Same_Present_Address_Permanent_Address__c,genesis__Party_Type__c,Active__c,Company__c,genesis__Application__c,genesis__Application__r.name,genesis__Party_Account_Name__c,genesis__Party_Account_Name__r.name,genesis__Application__r.Perfios_Captured__c,genesis__Application__r.Additional_Income_Approval__c,genesis__Party_Account_Name__r.Are_you_An_Existing_Customer__c,genesis__Application__r.Sub_Stage__c from genesis__Application_Parties__c  where genesis__Party_Type__c =:Constants.PRIMARY_APP AND Active__c =:True AND Company__c =:false AND  genesis__Application__c IN : appId];

           
            genesis__applications__c appRec;
            //Here checking condition all four one-by-one and assigning message based on the condition.

            for(genesis__Application_Parties__c app : partylist){
                
                appRec = new genesis__applications__c();
                if((oldAppMap.get(app.genesis__Application__c).Sub_Stage__c != app.genesis__Application__r.Sub_Stage__c) && app.genesis__Application__r.Sub_Stage__c == Constants.PersonalDetailsCapt){
                    
                    if(app.genesis__Application__r.Perfios_Captured__c == false && app.genesis__Application__r.Additional_Income_Approval__c ==true && app.Same_Present_Address_Permanent_Address__c == true && app.genesis__Party_Account_Name__r.Are_you_An_Existing_Customer__c == true){
                        appRec.Sanction_Message__c = sanctionMessageCS.get('SM1').Message__c;
                        system.debug('appRec.Sanction_Message__c==++'+appRec.Sanction_Message__c);
                        appRec.Id = app.genesis__Application__c;
                        listtoUpdate.add(appRec);
                        
                    }
                    else if(app.genesis__Application__r.Perfios_Captured__c == false && app.genesis__Application__r.Additional_Income_Approval__c == false && app.Same_Present_Address_Permanent_Address__c == true && app.genesis__Party_Account_Name__r.Are_you_An_Existing_Customer__c == true){
                        appRec.Sanction_Message__c = sanctionMessageCS.get('SM1').Message__c;
                        appRec.Id = app.genesis__Application__c;
                        listtoUpdate.add(appRec);
                    }
                    else if(app.genesis__Application__r.Perfios_Captured__c == false && app.genesis__Application__r.Additional_Income_Approval__c == true && app.Same_Present_Address_Permanent_Address__c == false && app.genesis__Party_Account_Name__r.Are_you_An_Existing_Customer__c == true){
                        appRec.Sanction_Message__c = sanctionMessageCS.get('SM3').Message__c;
                        appRec.Id = app.genesis__Application__c;
                        listtoUpdate.add(appRec);
                    }
                    else if(app.genesis__Application__r.Perfios_Captured__c == false && app.genesis__Application__r.Additional_Income_Approval__c == false && app.Same_Present_Address_Permanent_Address__c == false && app.genesis__Party_Account_Name__r.Are_you_An_Existing_Customer__c == true){
                        appRec.Sanction_Message__c = sanctionMessageCS.get('SM3').Message__c;
                        appRec.Id = app.genesis__Application__c;
                        listtoUpdate.add(appRec);
                    }
                    else if(app.genesis__Application__r.Perfios_Captured__c == false && app.genesis__Application__r.Additional_Income_Approval__c == true && app.Same_Present_Address_Permanent_Address__c == true && app.genesis__Party_Account_Name__r.Are_you_An_Existing_Customer__c == false){
                        appRec.Sanction_Message__c = sanctionMessageCS.get('SM3').Message__c;
                        appRec.Id = app.genesis__Application__c;
                        listtoUpdate.add(appRec);
                    }
                    else if(app.genesis__Application__r.Perfios_Captured__c == false && app.genesis__Application__r.Additional_Income_Approval__c == false && app.Same_Present_Address_Permanent_Address__c == true && app.genesis__Party_Account_Name__r.Are_you_An_Existing_Customer__c == false){
                        appRec.Sanction_Message__c = sanctionMessageCS.get('SM3').Message__c;
                        appRec.Id = app.genesis__Application__c;
                        listtoUpdate.add(appRec);
                    }
                    else if(app.genesis__Application__r.Perfios_Captured__c == false && app.genesis__Application__r.Additional_Income_Approval__c == true && app.Same_Present_Address_Permanent_Address__c == false && app.genesis__Party_Account_Name__r.Are_you_An_Existing_Customer__c == false){
                        appRec.Sanction_Message__c = sanctionMessageCS.get('SM3').Message__c;
                        appRec.Id = app.genesis__Application__c;
                        listtoUpdate.add(appRec);
                    }
                    else if(app.genesis__Application__r.Perfios_Captured__c == false && app.genesis__Application__r.Additional_Income_Approval__c == false && app.Same_Present_Address_Permanent_Address__c == false && app.genesis__Party_Account_Name__r.Are_you_An_Existing_Customer__c == false){
                        appRec.Sanction_Message__c = sanctionMessageCS.get('SM3').Message__c;
                        appRec.Id = app.genesis__Application__c;
                        listtoUpdate.add(appRec);
                    }
                    else if(app.genesis__Application__r.Perfios_Captured__c == true && app.genesis__Application__r.Additional_Income_Approval__c == true && app.Same_Present_Address_Permanent_Address__c == true && app.genesis__Party_Account_Name__r.Are_you_An_Existing_Customer__c == true){
                        appRec.Sanction_Message__c = sanctionMessageCS.get('SM1').Message__c;
                        appRec.Id = app.genesis__Application__c;
                        listtoUpdate.add(appRec);
                    }
                    else if(app.genesis__Application__r.Perfios_Captured__c == true && app.genesis__Application__r.Additional_Income_Approval__c == false && app.Same_Present_Address_Permanent_Address__c == true && app.genesis__Party_Account_Name__r.Are_you_An_Existing_Customer__c == true){
                        appRec.Sanction_Message__c = sanctionMessageCS.get('SM10').Message__c;
                        //appRec.Sub_Stage__c = Constants.PL_LOAN_STP;
                        appRec.Id = app.genesis__Application__c;
                        listtoUpdate.add(appRec);
                    }
                    else if(app.genesis__Application__r.Perfios_Captured__c == true && app.genesis__Application__r.Additional_Income_Approval__c == true && app.Same_Present_Address_Permanent_Address__c == false && app.genesis__Party_Account_Name__r.Are_you_An_Existing_Customer__c == true){
                        appRec.Sanction_Message__c = sanctionMessageCS.get('SM3').Message__c;
                        appRec.Id = app.genesis__Application__c;
                        listtoUpdate.add(appRec);
                    }
                    else if(app.genesis__Application__r.Perfios_Captured__c == true && app.genesis__Application__r.Additional_Income_Approval__c == false && app.Same_Present_Address_Permanent_Address__c == false && app.genesis__Party_Account_Name__r.Are_you_An_Existing_Customer__c == true){
                        appRec.Sanction_Message__c = sanctionMessageCS.get('SM12').Message__c;
                        appRec.Id = app.genesis__Application__c;
                        listtoUpdate.add(appRec);
                    }
                    else if(app.genesis__Application__r.Perfios_Captured__c == true && app.genesis__Application__r.Additional_Income_Approval__c == true && app.Same_Present_Address_Permanent_Address__c == true && app.genesis__Party_Account_Name__r.Are_you_An_Existing_Customer__c == false){
                        appRec.Sanction_Message__c = sanctionMessageCS.get('SM3').Message__c;
                        appRec.Id = app.genesis__Application__c;
                        listtoUpdate.add(appRec);
                    }
                    else if(app.genesis__Application__r.Perfios_Captured__c == true && app.genesis__Application__r.Additional_Income_Approval__c == false && app.Same_Present_Address_Permanent_Address__c == true && app.genesis__Party_Account_Name__r.Are_you_An_Existing_Customer__c == false){
                        appRec.Sanction_Message__c = sanctionMessageCS.get('SM12').Message__c;
                        appRec.Id = app.genesis__Application__c;
                        listtoUpdate.add(appRec);
                    }
                    else if(app.genesis__Application__r.Perfios_Captured__c == true && app.genesis__Application__r.Additional_Income_Approval__c == true && app.Same_Present_Address_Permanent_Address__c == false && app.genesis__Party_Account_Name__r.Are_you_An_Existing_Customer__c == false){
                        appRec.Sanction_Message__c = sanctionMessageCS.get('SM3').Message__c;
                        appRec.Id = app.genesis__Application__c;
                        listtoUpdate.add(appRec);
                    }
                    else if(app.genesis__Application__r.Perfios_Captured__c == true && app.genesis__Application__r.Additional_Income_Approval__c == false && app.Same_Present_Address_Permanent_Address__c == false && app.genesis__Party_Account_Name__r.Are_you_An_Existing_Customer__c == false){
                        appRec.Sanction_Message__c = sanctionMessageCS.get('SM12').Message__c;
                        appRec.Id = app.genesis__Application__c;
                        listtoUpdate.add(appRec);
                    }
                }
            }           
            ApplicationTriggerHandler.IsFirstRun = false;
            update listtoUpdate;
        }catch(Exception e){
            System.debug('####'+e.getMessage()+' At '+e.getLineNumber());
        }
    }
}