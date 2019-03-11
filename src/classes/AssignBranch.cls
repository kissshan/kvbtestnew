/*
* Name    : AssignBranch 
* Company : ET Marlabs
* Purpose : This class is used to Owner
* Author  : Subas Mallick
*/
public class AssignBranch {
    public static String getBranch(String appId, String branchCode, String dsaCode){
        try{
            List<ID> accIdList = new List<ID>();
            List<ID> ptIdList = new List<ID>();
            List<Account> accList = new List<Account>();
            List<genesis__Application_Parties__c> ptList = new List<genesis__Application_Parties__c>();
            genesis__Applications__c application = new genesis__Applications__c();
            application = queryService.getApplication(appId);
            String userId = '';
            if(!String.isBlank(branchCode)){
                userId = getUser(branchCode);  //Getting user based on branch code
            }else if(!String.isBlank(dsaCode)){
                userId = getDoUser(dsaCode);  //Getting user based on DSA code
            }
            system.debug('***UserID***'+userId);
            if(!String.isBlank(userId)){                
                List<genesis__Application_Parties__c> paties = [Select Id,genesis__Party_Account_Name__c From genesis__Application_Parties__c Where genesis__Application__c =: appId];
                //Account acc = new Account();
                //acc.Id = application.genesis__Account__c;
                //acc.OwnerId = userId;
                //accList.add(acc);
                for(genesis__Application_Parties__c pt : paties){
                    Account a = new Account();
                    a.Id = pt.genesis__Party_Account_Name__c;
                    a.OwnerId = userId;
                    accList.add(a);
                    genesis__Application_Parties__c p = new genesis__Application_Parties__c();
                    p.Id = pt.Id;
                    p.OwnerId = userId;
                    ptList.add(p);
                }
                if(accList.Size() >0){
                    update accList;
                }
                if(ptList.size() >0){
                    update ptList;
                }                    
                return userId;
            }
            
            return null;
            
        }catch(Exception e){
            HandleBusinessException.captureError('AssignBranch','getBranch', e);
            return null;
        }
    }
    public static String getUser(String branchCode){
        String userId = '';
        List<User> userList = [Select Id,Office_Code__c From User Where Office_Code__c =:branchCode AND isActive =True];
        if(userList.size()>0){
            userId = userList[0].Id;
        }
        return userId;
    }
    public static String getDoUser(String DsaCode){
        String userId = '';
        List<DSA_Master__c> dsaList = [Select Id,Branch_Code__c From DSA_Master__c where Employ_Code__c =:DsaCode];
        if(dsaList.size() > 0){
            string branchCode = dsaList[0].Branch_Code__c;
            userId = getUser(branchCode);
            if(String.isBlank(userId)){
                List<User> userList = [Select Id,Office_Code__c From User Where Office_Code__c =:branchCode AND isActive =True AND Role_Name__c ='DO HEAD'];
                if(userList.size()>0){
                    userId = userList[0].Id;
                }
            }
            return userId;
        }
        return null;
    }
}