/*
* Name    : OwnershipTrigger 
* Company : ET Marlabs
* Purpose : Ownership Trigger
* Author  : Braj Mohan
* Date    : 28-Dec-2018
*/
Trigger OwnershipTrigger on Ownership__c (before insert,before update) {
    
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        set<Id> ownerSet = new set<Id>();
        map<Id,List<Id>> mapCollToOwnerLst = new map<Id,List<Id>>();
        for(Ownership__c owner: Trigger.new) {
            ownerSet.add(owner.Collateral__c);
        }
        //System.debug('ownerSet>>'+ownerSet);
        List<Ownership__c> ownerLst = [Select Id,Name,Account__c,Collateral__c,Collateral__r.AppRecord_Type__c from Ownership__c where Collateral__c IN:ownerSet];
        if(ownerLst!=null && ownerLst.size()>0){
            if(ownerLst[0].Collateral__r.AppRecord_Type__c == Constants.LAPLOAN){
                //System.debug('ownerLst>>'+ownerLst);
                for(Ownership__c ownership: ownerLst){
                    if (mapCollToOwnerLst.containskey(ownership.Collateral__c)) {
                        mapCollToOwnerLst.get(ownership.Collateral__c).add(ownership.Account__c);
                    } else {
                        mapCollToOwnerLst.put(ownership.Collateral__c,new List<Id>{ownership.Account__c});
                    }
                }
                // Dont comment below system.debug
                System.debug(mapCollToOwnerLst.size()+'<<mapCollToOwnerLst>>'+mapCollToOwnerLst);
                for(Ownership__c owner: Trigger.new){
                    if (mapCollToOwnerLst.containskey(owner.Collateral__c) && mapCollToOwnerLst.get(owner.Collateral__c).contains(owner.Account__c)){
                        owner.addError('Select Account is already owner of this Collateral.Please choose different account.');
                    }
                }
            }
        }
    }
}