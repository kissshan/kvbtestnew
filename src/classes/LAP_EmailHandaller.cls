/*
* Name      : SMS_Services
* Compnay   : ET Marlabs
* Purpose   : For Email Handaller - LAP. 
* Author    : Niladri
-----------------------------------------------------------------------
Version     Date            Author          Remarks                                                 
=======     ==========      =============   ==================================
v1.1        04-Oct-2018     Braj Mohan      #VL717:Send email fuctionality bulkified,null check and error log added
*******************************************************************************************/
public class LAP_EmailHandaller {
    public static void LAP_Email(String emailid,string emailbody,string emailSubj){
    	PLEmail(emailid,emailbody,emailSubj,null,null);
    }
    
    public static void PLEmail(String emailid,string emailbody,string emailSubj, List<Messaging.Emailfileattachment>  attch,String CCMailId){
        try{
            //v1.1(start)
            if (emailid!=null && emailid!=''){
                //System.debug('emailid>>>'+emailid);
                List<String> emailLst = emailid.split(',');
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                if (emailLst.size()>1)
                    message.toAddresses = new List<String>(emailLst);
                else 
                    message.toAddresses = new List<String>{emailid};
                //v1.1(end)
                message.setSubject(emailSubj);
                message.setReplyTo('support@kvb.com');
                message.setSenderDisplayName('KVB TEAM');
                message.setBccSender(false);
                message.setHtmlBody(emailbody);
                message.setFileAttachments(attch);
                System.debug('message::'+message);
               System.debug('CCMailId::'+CCMailId);
                if(CCMailId !=null){
                   // message.ccaddresses =new List<String>{CCMailId};
                     message.setCcAddresses(new string[]{CCMailId});
                }
                else{
                     message.setCcAddresses(new string[]{'dtnotifications@kvbmail.com'});
                }
                /*OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress LIMIT 1];
                if (owea.size() > 0 ) {
                    message.setOrgWideEmailAddressId(owea.get(0).Id);
                }*/
                
                Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                
                if (results[0].success) {
                    System.debug('The email was sent successfully.');
                } else {
                    System.debug('The email failed to send: ' + results[0].errors[0].message);
                }  
            }
        }
        catch(Exception e){
            System.debug('LAP_Email>>>'+e.getLineNumber()+e.getStackTraceString()+e.getMessage());
            HandleBusinessException.captureError('LAP_EmailHandaller','LAP_Email', e);//v1.1
        }
    }
}