/*
* Name      : ExpiryofApplicationsBatch
* Compnay   : ET Marlabs
* Purpose   : Share the records to specific User
* Author    : Vignesh
*/
public  class RecordsSharingAccess {
	public Static void accountRecordsShare(Set<Id> accIds,User user){
		List<AccountShare> shareAcc = new List<AccountShare>();
		for(Id accId: accIds){
			AccountShare accountShare = new AccountShare();
	        accountShare.AccountId = accId;
	        accountShare.UserOrGroupId = user.Id;
	        accountShare.AccountAccessLevel = 'Read';	        
	        accountShare.OpportunityAccessLevel= 'None';
	        shareAcc.add( accountShare);
		}
		if(shareAcc.size()>0){
			insert shareAcc;
		}	
	}
	public Static void removeAccountRecordsShare(Set<Id> accIds,User usr){
		List<AccountShare> accShare = new List<AccountShare>();
		set<Id> UserIds = new set<Id>{usr.Id};
         accShare = [select Id,AccountId,RowCause,UserOrGroupId  from AccountShare where UserOrGroupId =: UserIds AND AccountId IN :accIds ];
         if(accShare.size() > 0){
            delete accShare;       
         }
	}
}