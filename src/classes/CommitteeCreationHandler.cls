/*
* Name          : CommitteeCreationHandler
* Description   : Creates committee and members
* Author        : Dushyant
*/
global class CommitteeCreationHandler {
    public string userListformat{get;set;}
    public Boolean DOCO_Flag{get;set;}
    
    //prepares user list to be selected as committee members
    global void onLoad(){
        List<String> excludeDesignationList = Constants.COMMITTEE_EXCLUDE_DESIGNATION.split(':');
        List<String> coccMemberList = new List<String>();
        List<String> doccMemberList = new List<String>();
        if(Label.COCC_Members != null)coccMemberList = Label.COCC_Members.split(',');
        if(Label.DOCC_Members != null)doccMemberList = Label.DOCC_Members.split(',');
        //get user list matching to loggedinuser designation
        User currentUser = [Select Designation__c,Division From User Where Id = :UserInfo.getUserId()];
        List<User> userList = new List<User>();
        //Check if committee creator is DO/CO
        if(currentUser.Designation__c == null || (!currentUser.Designation__c.contains('DO') && !currentUser.Designation__c.contains('CO'))) DOCO_Flag = true;
        else DOCO_Flag = false;
        System.debug(DOCO_Flag);
        if(currentUser.Designation__c.contains('DO') && doccMemberList != null && !doccMemberList.isEmpty()){
            userList = [SELECT Id,Name,Designation__c,Division,isActive FROM User WHERE Division =: currentUser.Division AND Designation__c  IN:doccMemberList AND isActive = true];
        }
        else if(currentUser.Designation__c.contains('CO') && coccMemberList != null && !coccMemberList.isEmpty()){
            userList = [SELECT Id,Name,Designation__c,Division,isActive FROM User WHERE Division =: currentUser.Division AND Designation__c IN:coccMemberList AND isActive = true];
        }
        
        userListformat = JSON.serialize(userList);
        System.debug(DOCO_Flag);
        System.debug(userListformat);
    }
    
    @RemoteAction
    global static String userSaveList(List<user> userListToSave){
        if(!userListToSave.isEmpty()){
            System.debug(UserInfo.getUserId());
            User currentUser = [Select Id,Designation__c,Division From User Where Id = :UserInfo.getUserId()];
            System.debug(userListToSave.size()+'#####'+userListToSave);
            List<genesis__Meeting_Schedule__c> existingCommittee = new List<genesis__Meeting_Schedule__c>();
            existingCommittee = [SELECT Id FROM genesis__Meeting_Schedule__c WHERE Division__c =: currentUser.Division AND genesis__Status__c != 'Completed'];
            genesis__Meeting_Schedule__c newCommittee = new genesis__Meeting_Schedule__c();
            
            if(!existingCommittee.isEmpty()){
                for(genesis__Meeting_Schedule__c commmittee : existingCommittee){
                    commmittee.genesis__Status__c = 'Completed';
                }
                UPDATE existingCommittee;
            }
            //Create new committee and members
            newCommittee = createCommitteeMembers(currentUser,userListToSave);
            System.debug(newCommittee.Id);
            RETURN newCommittee.Id;
        }
        else RETURN null;
        
    }
    
    //Create committee and members and remove existing members
    public static genesis__Meeting_Schedule__c createCommitteeMembers(User currentUser,List<User> userList){
        List<User> userListToInsert = new List<user>();
        List<Id> userIdList = new List<Id>();
        for(User ur : userList){
            userIdList.add(ur.Id);
        }
        userListToInsert = [SELECT Id,Division,Designation__c FROM User WHERE Id IN : userIdList];
        
        genesis__Meeting_Schedule__c committee = new genesis__Meeting_Schedule__c();
        List<genesis__Committee_Member__c> commMembList = new List<genesis__Committee_Member__c>();
        
        committee = new  genesis__Meeting_Schedule__c(genesis__Status__c = 'New',genesis__Type__c = 'Board Committee',Division__c = currentUser.Division);
        //Check if division of current user is "Central Office"
        if(currentUser.Division == Label.COMMITTEE_CREATION_DIVISION) committee.Sanction_Committe_For__c = 'COCC';
        else committee.Sanction_Committe_For__c = 'DOCC';
        
        //committee.genesis__Administrator__c = currentUser.Id;
        INSERT committee;
        
        for(User ur : userListToInsert){
            genesis__Committee_Member__c commMember = new genesis__Committee_Member__c(genesis__User__c = ur.Id, Division__c = ur.Division, genesis__Meeting_Schedule__c = committee.Id, genesis__Role__c = 'Attendee',genesis__Has_Attended__c = true);
            commMember.Designation__c = ur.Designation__c != null ? ur.Designation__c : null;
            commMembList.add(commMember);
        }
        if(!commMembList.isEmpty()){
            INSERT commMembList;
        }
        RETURN committee;
    }
}