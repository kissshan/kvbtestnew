/*
* Name     :  
* Company  : ET Marlabs
* Purpose  : Trigger on Attachment – Restricting user from attaching files with specific extensions. 
* Author   : Raushan
*/
trigger AttachmentTrigger on Attachment (before insert, after insert) {
    set<String> setExtNotAllowed = new set<String> {'exe','dll','bat'};
    map<Id,List<attachment>> pIdAttchMap= new map<Id,List<attachment>>();

    if(Trigger.isBefore && Trigger.isInsert){
    	for (Attachment attachment :Trigger.new) {
            String strFilename = attachment.Name.toLowerCase();
            List<String> parts = strFilename.splitByCharacterType();
            if(setExtNotAllowed.Contains(parts[parts.size()-1])) {
                attachment.addError('File with extension exe or dll could not be attached!!');
            }
        }

    }
    /* Update the Attachment Id into appropriate DIGIODocument Record */ //Added By Vignesh
    if(Trigger.isAfter && Trigger.isInsert){
        for(Attachment att :Trigger.new){
            if(pIdAttchMap.containskey(att.ParentId)){
                pIdAttchMap.get(att.ParentId).add(att);
            }else{
                pIdAttchMap.put(att.ParentId,new List<Attachment>{att});
            }
            //system.debug('att Name===> '+att.Name);
        }
        //system.debug('pIdAttchMap===> '+pIdAttchMap);
        if(pIdAttchMap!= null){
            List<Digio_Document_ID__c> DigioDocLstAppPId= [SELECT id,Name,Application__c from Digio_Document_ID__c where Application__c IN: pIdAttchMap.keyset()];
            if(DigioDocLstAppPId.size()>0){
                for(Digio_Document_ID__c digi: DigioDocLstAppPId){
                    if(pIdAttchMap.get(digi.Application__c)!=null){
                        for(Attachment att: pIdAttchMap.get(digi.Application__c)){
                            if(digi.Name==att.Name){
                                digi.Document_ID__c=att.Id;
                                break;
                                //system.debug('Testing doc Loop');
                            }
                        }
                    }
                }
                update DigioDocLstAppPId;
            }
            /*List<Digio_Document_ID__c> DigioDocLstDiPId= [SELECT id,Name,Application__c from Digio_Document_ID__c where Id IN: pIdAttchMap.keyset()];
            if(DigioDocLstDiPId.size()>0){
                for(Digio_Document_ID__c digi: DigioDocLstDiPId){
                    if(pIdAttchMap.get(digi.Id)!=null){
                        for(Attachment att: pIdAttchMap.get(digi.Id)){
                            if(digi.Name==att.Name){
                                digi.Document_ID__c=att.Id;
                                break;
                                //system.debug('Testing doc Loop');
                            }
                        }
                    }
                }
                update DigioDocLstDiPId;
            }*/
            
        }
        
    }
        
 
}