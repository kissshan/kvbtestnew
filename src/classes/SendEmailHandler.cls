/*
* Name    : SendEmailHandler
* Company : ET Marlabs
* Purpose : This class is used to send email with attached document
* Author  : Subas
*/
public class SendEmailHandler {
    public static void SendEmail(String appId, Attachment attach){
        try{
            system.debug('Attach.Name:-'+Attach.Name+'   appId:-'+appId);
            if(appId <> null && (Attach.Name == Constants.Acknowledgement_For_Sanction || Attach.Name == Constants.A23_HL || Attach.Name == Constants.B17_HL || Attach.Name == Constants.A46_HL)){
                
                
                genesis__Applications__c application = new genesis__Applications__c();
                application = [Select Id,sub_stage__c,Person_Email__c From genesis__Applications__c where Id =:appId];
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String Ids='';
                List<EmailTemplate> etemp = [SELECT DeveloperName,Id,Name FROM EmailTemplate WHERE DeveloperName = 'Pre_approval_letter' OR DeveloperName = 'Sanction_Letter' OR DeveloperName = 'MOD_docs' OR DeveloperName = 'Post_e_sign_of_disbursement_docs'];
                List<genesis__Application_Parties__c> ptList = [SELECT ID,Party_Email__c,genesis__Party_Account_Name__r.PersonEmail FROM genesis__Application_Parties__c Where genesis__Application__c =:application.Id];
                
                //String[] toAddresses = new String[]{application.genesis__Account__r.PersonEmail};
                
                String[] toAddresses = new String[]{}; 
                    for(genesis__Application_Parties__c pt : ptList){
                        if(pt.Party_Email__c<>null){
                            toAddresses.add(pt.Party_Email__c);
                        }
                    }
                
                toAddresses.add(application.Person_Email__c);
                
                mail.setToAddresses(toAddresses);
                mail.setReplyTo('support@kvb.com');
                mail.setSenderDisplayName('KVB TEAM');
                //mail.setSubject('Mail with Attachment');
                mail.setBccSender(false);
                mail.setUseSignature(false);
                mail.setTargetObjectId(UserInfo.getUserId());
                system.debug('EmailTemplate:-'+etemp);
                system.debug('application:-'+application);
                for(EmailTemplate et : etemp){
                    if(application.Sub_Stage__c=='Loan Sanctioned Non-STP' || application.Sub_Stage__c=='Loan Sanctioned STP'||  application.Sub_Stage__c=='Loan Sanctioned-Committee'){
                        if(et.DeveloperName == 'Sanction_Letter'){
                            Ids = et.ID;
                        }                  
                    }
                    else if(application.Sub_Stage__c == 'Loan Pre - Approved STP'|| application.Sub_Stage__c == 'Loan Pre - Approved NSTP' ){
                        if(et.DeveloperName == 'Pre_approval_letter'){
                            Ids = et.ID;
                        }                  
                    }
                    else if(application.Sub_Stage__c == 'MOD Documents Esigned'){
                        if(et.DeveloperName == 'MOD_docs'){
                            Ids = et.ID;
                        }                  
                    }
                    else if(application.Sub_Stage__c == 'Disbursement Documents Esigned'){
                        if(et.DeveloperName == 'Post_e_sign_of_disbursement_docs'){
                            Ids = et.ID;
                        }                  
                    }            
                }
                mail.setTemplateId(Ids); 
                mail.setWhatId(application.Id);
                mail.saveAsActivity = false;
                
                //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                //Set email file attachments
                List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
                // Add to attachment file list
                Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                efa.setFileName(attach.Name);
                efa.setBody(attach.Body);
                fileAttachments.add(efa);                                
                
                mail.setFileAttachments(fileAttachments);            
                //Send email
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }Catch(Exception e){
            system.debug('exception:-'+e);
        }
        
    }
    public static void termsEmail(List<genesis__Applications__c> appList, Map<Id,genesis__Applications__c> oldList){       
        try{
        Contact c = [select id, Email from Contact where email <> null limit 1];
            system.debug('appList:-'+appList);
            system.debug('appList:-'+oldList);
        for(genesis__Applications__c app : appList){
            if((oldList.get(app.Id).Sub_Stage__c <> app.Sub_Stage__c) && app.Sub_Stage__c == 'Terms and Conditions Accepted' && app.Record_Type_Name__c==constants.HOMELOAN){                
                String Ids='';
                List<EmailTemplate> etemp = [SELECT DeveloperName,Id,Name FROM EmailTemplate WHERE DeveloperName = 'Informal_sanction_to_HSL'];
                List<Messaging.SingleEmailMessage> lstMsgs = new List<Messaging.SingleEmailMessage>();
                List<Account> accList = queryService.ApplicantList(app.Id);
                for(Account acc : accList){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    String[] toAddresses = new String[]{};
                        //system.assertEquals(acc.PersonEmail,null);
                        toAddresses.add(acc.PersonEmail);
                    
                    mail.setToAddresses(toAddresses);
                    mail.setReplyTo('support@kvb.com');
                    mail.setSenderDisplayName('KVB TEAM');                    
                    mail.setBccSender(false);
                    mail.setUseSignature(false);
                    //mail.setTargetObjectId(UserInfo.getUserId());//0030l00000BrTxNAAV
                    //mail.setTargetObjectId('0030l00000Hpayy');
                    mail.setTargetObjectId(c.id);
                    mail.setTemplateId(etemp[0].Id); 
                    mail.setWhatId(app.Id);
                    mail.saveAsActivity = false;   
                    lstMsgs.add(mail);
                    //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }
                Savepoint sp = Database.setSavepoint();
                Messaging.sendEmail(lstMsgs);
                Database.rollback(sp);                
                List<Messaging.SingleEmailMessage> lstMsgsToSend = new List<Messaging.SingleEmailMessage>();
                for (Messaging.SingleEmailMessage email : lstMsgs) {
                    Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                    emailToSend.setToAddresses(email.getToAddresses());
                    emailToSend.setPlainTextBody(email.getPlainTextBody());
                    emailToSend.setHTMLBody(email.getHTMLBody());
                    emailToSend.setSubject(email.getSubject());
                    lstMsgsToSend.add(emailToSend);
                }
                Messaging.sendEmail(lstMsgsToSend);                
            }
        }
    }catch(Exception e){
        system.debug('Exception:-'+e);
    }
    }
}