public class EmailMessages {
   
    public static void sendEmail( string Email,string Msg){
         string[] ToAddress=new string[]{};
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
        ToAddress.add(Email);
        		mail.setToAddresses(ToAddress);
                mail.setReplyTo('support@kvb.com');
                mail.setSenderDisplayName('KVB TEAM');
       		    mail.setPlainTextBody(Msg);
        		mail.setSubject(Msg);
                mail.setBccSender(false);
                mail.setUseSignature(false);
                mail.setCcAddresses(new string[]{'notifications@kvbmail.com'}); //added on 3-12-2018 
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail}); 
    }

}