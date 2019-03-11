public class SendSMSService {
  public static boolean Recusrive=True;
    public static void sendSMSParties(String appObj){
        system.debug('***Send SMS Co-applicant***');
        try{
            Recusrive=false;
            genesis__Application_Parties__c party = (genesis__Application_Parties__c)JSON.deserialize(appObj, genesis__Application_Parties__c.Class);
            if(party.Guarantor__c == TRUE){
                String messageAck = 'You have been added as guarantor by Mr. <<borrower name>> for Housing Loan application <<application no.>> with Karur Vysya Bank.';
            }
            String messageAck = 'Thank you for opting for Housing Loan from KVB. Please complete your application <<application no.>> to initiate processing of loan application.';
            String applicationNo = party.Application_No__c;//party.genesis__Application__r.Name != null ? party.genesis__Application__r.Name : '-';
            String borrowerName = party.Applicant_Name__c;
            String mobileNo = party.Party_Mobile_No__c;
            messageAck = messageAck.replace('<<application no.>>',applicationNo);
            messageAck = messageAck.replace('<<borrower name>>',borrowerName);
            system.debug('####'+messageAck);
            system.debug('mobileNo.length():-'+mobileNo);
            if(mobileNo.length() == 12){
                SMS_Services.sendSMSFutureCall(mobileNo,messageAck);
            }
            else if(mobileNo.length() == 10){
                mobileNo = '91'+ mobileNo;
                SMS_Services.sendSMSFutureCall(mobileNo,messageAck);
            }
            else{
                System.debug('Mobile No Not Valid');
            }
        }Catch(Exception e){
            system.debug('exception:-'+e+'line no:-'+e.getLineNumber());
        }
    }
    
    //Send SMS when loan created in los   
    public static void sendSMSonCrt(String appObj){        
        try{
            genesis__Applications__c application = (genesis__Applications__c)JSON.deserialize(appObj, genesis__Applications__c.Class);
            String messageAck = '';
            String mobileNo = '';
            messageAck ='Thank you for opting for Housing Loan from KVB. Please complete your application <<application no.>> to initiate processing of loan application.';       
            messageAck = messageAck.replace('<<application no.>>',application.Name);
            mobileNo = application.Primary_Applicant_Mobile__c;
            system.debug('MobileNo###'+application.Primary_Applicant_Mobile__c);
            system.debug('@@@'+mobileNo+'$$$'+messageAck);
            if(mobileNo.length() == 12){
                SMS_Services.sendSMSFutureCall(mobileNo,messageAck);
            }
            else if(mobileNo.length() == 10){
                mobileNo = '91'+ mobileNo;
                SMS_Services.sendSMSFutureCall(mobileNo,messageAck);
            }
            else{
                System.debug('Mobile No Not Valid');
            }                
        }Catch(Exception e){
           
        }
    }
    
    
    public static void sendSMSApp(String appObj){
        try{
            genesis__Applications__c application = (genesis__Applications__c)JSON.deserialize(appObj, genesis__Applications__c.Class);
            String messageAck = '';
            String mobileNo = '';
            List<genesis__Application_Parties__c> ptList = [SELECT ID,Party_Email__c,Party_Mobile_No__c,genesis__Application__r.genesis__Loan_Amount__c,genesis__Application__r.Processing_Fee__c,genesis__Party_Account_Name__r.PersonEmail,genesis__Party_Account_Name__r.Name,genesis__Application__r.Name,genesis__Party_Account_Name__r.PersonMobilePhone FROM genesis__Application_Parties__c Where genesis__Application__c =:application.Id and Active__c=:true AND Company__c =: false];
            if(application.Sub_Stage__c=='Loan Sanctioned Non-STP' || application.Sub_Stage__c=='Loan Sanctioned STP'||  application.Sub_Stage__c=='Loan Sanctioned-Committee'){
                messageAck ='Dear Mr.<<borrower name>>, congratulations, your housing loan application <<application no.>> has been sanctioned for Rs. <<Limit amt.>>. Sanction copy is being sent to your email id. <<email id of borrower>>.';
                messageAck = messageAck.replace('<<borrower name>>',application.Borrower_Name__c);
                messageAck = messageAck.replace('<<application no.>>',application.Name);
                messageAck = messageAck.replace('<<Limit amt.>>',String.ValueOf(application.Sanction_Authority_Limit__c));
                messageAck = messageAck.replace('<<email id of borrower>>',application.Person_Email__c);                
                mobileNo = application.Primary_Applicant_Mobile__c;
                system.debug('MobileNo###'+application.Primary_Applicant_Mobile__c);
                system.debug('@@@'+mobileNo+'$$$'+messageAck);
                if(mobileNo.length() == 12){
                    SMS_Services.sendSMSFutureCall(mobileNo,messageAck);
                }
                else if(mobileNo.length() == 10){
                    mobileNo = '91'+ mobileNo;
                    SMS_Services.sendSMSFutureCall(mobileNo,messageAck);
                }
                else{
                    System.debug('Mobile No Not Valid');
                }
                if(ptList.size() >0){
                    for(genesis__Application_Parties__c pt : ptList){                    
                        messageAck ='Dear Mr.<<borrower name>>, congratulations, your housing loan application <<application no.>> has been sanctioned for Rs. <<Limit amt.>>. Sanction copy is being sent to your email id. <<email id of borrower>>.';
                        messageAck = messageAck.replace('<<borrower name>>',pt.genesis__Party_Account_Name__r.Name);
                        messageAck = messageAck.replace('<<application no.>>',application.Name);
                        messageAck = messageAck.replace('<<Limit amt.>>',String.ValueOf(application.Sanction_Authority_Limit__c));
                        messageAck = messageAck.replace('<<email id of borrower>>',pt.Party_Email__c);
                        mobileNo = pt.Party_Mobile_No__c;
                        if(mobileNo.length() == 12){
                            SMS_Services.sendSMSFutureCall(mobileNo,messageAck);
                        }
                        else if(mobileNo.length() == 10){
                            mobileNo = '91'+ mobileNo;
                            SMS_Services.sendSMSFutureCall(mobileNo,messageAck);
                        }
                        else{
                            System.debug('Mobile No Not Valid');
                        }
                        system.debug('@@@'+mobileNo+'$$$'+messageAck);
                    }
                }
            }
            if(application.Sub_Stage__c == 'Loan Pre - Approved STP'|| application.Sub_Stage__c == 'Loan Pre - Approved NSTP' ){
                for(genesis__Application_Parties__c pt : ptList){
                    messageAck ='Dear Mr.<<borrower name>>, congratulations, your housing loan application no. <<application no.>>  has been pre-approved for Rs.<<Pre-approved amt>>. Pre-approval copy is being sent to your email id. <<email id of borrower>>.';
                    messageAck = messageAck.replace('<<Pre-approved amt>>','');
                    messageAck = messageAck.replace('<<application no.>>',pt.genesis__Application__r.Name);
                    messageAck = messageAck.replace('<<email id of borrower>>',pt.genesis__Party_Account_Name__r.PersonEmail);  
                    mobileNo = pt.Party_Mobile_No__c;
                    if(mobileNo.length() == 12){
                        SMS_Services.sendSMSFutureCall(mobileNo,messageAck);
                    }
                    else if(mobileNo.length() == 10){
                        mobileNo = '91'+ mobileNo;
                        SMS_Services.sendSMSFutureCall(mobileNo,messageAck);
                    }
                    else{
                        System.debug('Mobile No Not Valid');
                    }
                }
            }
            if(application.Sub_Stage__c == 'Processing Fee Paid'){
                for(genesis__Application_Parties__c pt : ptList){
                    messageAck ='Dear Mr.<<borrower name>>, We acknowledge the  receipt of processing charges Rs.<<processing charges>> for your Home Loan application <<application no.>>.';
                    messageAck = messageAck.replace('<<borrower name>>',pt.genesis__Party_Account_Name__r.Name);
                    messageAck = messageAck.replace('<<application no.>>',pt.genesis__Application__r.Name);
                    messageAck = messageAck.replace('<<processing charges>>',String.ValueOf(pt.genesis__Application__r.Processing_Fee__c));  
                    mobileNo = pt.Party_Mobile_No__c;
                    if(mobileNo.length() == 12){
                        SMS_Services.sendSMSFutureCall(mobileNo,messageAck);
                    }
                    else if(mobileNo.length() == 10){
                        mobileNo = '91'+ mobileNo;
                        SMS_Services.sendSMSFutureCall(mobileNo,messageAck);
                    }
                    else{
                        System.debug('Mobile No Not Valid');
                    }
                }
            }
            if(application.Sub_Stage__c == 'Disbursement Approved'){
                for(genesis__Application_Parties__c pt : ptList){
                    messageAck ='Dear Mr.<<borrower name>>, your home loan application (<<application no.>>) has  been approved for disbursement and our branch team will contact you for proceeding further.';
                    messageAck = messageAck.replace('<<borrower name>>',pt.genesis__Party_Account_Name__r.Name);
                    messageAck = messageAck.replace('<<application no.>>',pt.genesis__Application__r.Name);
                    mobileNo = pt.Party_Mobile_No__c;
                    if(mobileNo.length() == 12){
                        SMS_Services.sendSMSFutureCall(mobileNo,messageAck);
                    }
                    else if(mobileNo.length() == 10){
                        mobileNo = '91'+ mobileNo;
                        SMS_Services.sendSMSFutureCall(mobileNo,messageAck);
                    }
                    else{
                        System.debug('Mobile No Not Valid');
                    }
                }
            }
            if(application.Sub_Stage__c == 'Sanction pending - Non STP' && application.Income_Verification__c==FALSE && application.Property_Verification__c==FALSE){
                for(genesis__Application_Parties__c pt : ptList){
                    messageAck ='Dear Mr.<<borrower name>>, your Home Loan application <<application no.>> is under process. Based on your application, you are eligible for a loan of Rs. <<limit_amt>>.  Please submit the proof of income and property documents as per checklist. Our officials will soon approach you for property verification.';
                    messageAck = messageAck.replace('<<borrower name>>',pt.genesis__Party_Account_Name__r.Name);
                    messageAck = messageAck.replace('<<application no.>>',pt.genesis__Application__r.Name);
                    messageAck = messageAck.replace('<<limit_amt>>',String.ValueOf(pt.genesis__Application__r.genesis__Loan_Amount__c));
                    mobileNo = pt.Party_Mobile_No__c;
                    if(mobileNo.length() == 12){
                        SMS_Services.sendSMSFutureCall(mobileNo,messageAck);
                    }
                    else if(mobileNo.length() == 10){
                        mobileNo = '91'+ mobileNo;
                        SMS_Services.sendSMSFutureCall(mobileNo,messageAck);
                    }
                    else{
                        System.debug('Mobile No Not Valid');
                    }
                }            
            }
            if(application.Sub_Stage__c == 'Sanction pending - Non STP' & application.Income_Verification__c==FALSE){
                for(genesis__Application_Parties__c pt : ptList){
                    messageAck ='Dear Mr.<<borrower name>>, your Home Loan application <<application no.>> is under process. Based on the income furnished by you, you are eligible for a Housing Loan of Rs. <<Limit_Amt>>.  Please submit your proof of income.';
                    messageAck = messageAck.replace('<<borrower name>>',pt.genesis__Party_Account_Name__r.Name);
                    messageAck = messageAck.replace('<<application no.>>',pt.genesis__Application__r.Name);
                    messageAck = messageAck.replace('<<limit_amt>>',String.ValueOf(pt.genesis__Application__r.genesis__Loan_Amount__c));
                    mobileNo = pt.Party_Mobile_No__c;
                    if(mobileNo.length() == 12){
                        SMS_Services.sendSMSFutureCall(mobileNo,messageAck);
                    }
                    else if(mobileNo.length() == 10){
                        mobileNo = '91'+ mobileNo;
                        SMS_Services.sendSMSFutureCall(mobileNo,messageAck);
                    }
                    else{
                        System.debug('Mobile No Not Valid');
                    }
                }            
            }
            if(application.Sub_Stage__c == 'Sanction pending - Non STP' & application.Property_Verification__c==FALSE){
                for(genesis__Application_Parties__c pt : ptList){
                    messageAck ='Dear Mr.<<borrower name>>, your Home Loan application <<application no.>> is under process.  Based on your application, you are eligible for a loan of Rs. <<limit_amt>>.  Please submit the property documents as per the checklist. Our officials will soon approch you for property verification.';
                    messageAck = messageAck.replace('<<borrower name>>',pt.genesis__Party_Account_Name__r.Name);
                    messageAck = messageAck.replace('<<application no.>>',pt.genesis__Application__r.Name);
                    messageAck = messageAck.replace('<<limit_amt>>',String.ValueOf(pt.genesis__Application__r.genesis__Loan_Amount__c));
                    mobileNo = pt.Party_Mobile_No__c;
                    if(mobileNo.length() == 12){
                        SMS_Services.sendSMSFutureCall(mobileNo,messageAck);
                    }
                    else if(mobileNo.length() == 10){
                        mobileNo = '91'+ mobileNo;
                        SMS_Services.sendSMSFutureCall(mobileNo,messageAck);
                    }
                    else{
                        System.debug('Mobile No Not Valid');
                    }
                }
                
                
            }
            if(application.Sub_Stage__c == 'MOD Initiated'){
                for(genesis__Application_Parties__c pt : ptList){
                    messageAck ='Dear Mr.<<borrower name>>, with reference to your home loan application no. <<application no.>>, we have received the sale deed and our branch team will soon contact you for MOD registration process.';
                    messageAck = messageAck.replace('<<borrower name>>',pt.genesis__Party_Account_Name__r.Name);
                    messageAck = messageAck.replace('<<application no.>>',pt.genesis__Application__r.Name);
                    mobileNo = pt.Party_Mobile_No__c;
                    if(mobileNo.length() == 12){
                        SMS_Services.sendSMSFutureCall(mobileNo,messageAck);
                    }
                    else if(mobileNo.length() == 10){
                        mobileNo = '91'+ mobileNo;
                        SMS_Services.sendSMSFutureCall(mobileNo,messageAck);
                    }
                    else{
                        System.debug('Mobile No Not Valid');
                    }
                }            
            }   
        }Catch(Exception e){
             system.debug('EEEEEEEEEEEEE'+e.getLineNumber()+'Error'+e.getStackTraceString());
        }
    }
    
    @InvocableMethod
    public static List<String> perfiosSMS(List<ID> ids){
        try{
        String messageAck = '';
        String mobileNo = '';	
        List<Account> accList = new List<Account>();
        accList = [Select ID,PersonMobilePhone,Perfios_URL__c From Account Where ID IN: ids];
        for(Account acc : accList){
            messageAck ='Please follow the link for submission of Income Proff. <<Perfios_URL>>';       
            messageAck = messageAck.replace('<<Perfios_URL>>',acc.Perfios_URL__c);
            mobileNo = acc.PersonMobilePhone;
            system.debug('@@@'+mobileNo+'$$$'+messageAck);
            if(mobileNo.length() == 12){
                SMS_Services.sendSMSFutureCall(mobileNo,messageAck);
            }
            else if(mobileNo.length() == 10){
                mobileNo = '91'+ mobileNo;
                SMS_Services.sendSMSFutureCall(mobileNo,messageAck);
            }
        }
        }Catch(Exception e){}
        return null;
    }
    public static void termsSms(List<genesis__Applications__c> appList, Map<Id,genesis__Applications__c> oldList){
        try{
        String messageAck = '';
        String mobileNo = '';        
        for(genesis__Applications__c app : appList){
            system.debug('kkkkkk'+oldList.get(app.Id).Sub_Stage__c +'lllllll'+app.Sub_Stage__c);
            if((oldList.get(app.Id).Sub_Stage__c <> app.Sub_Stage__c) && app.Sub_Stage__c == 'Terms and Conditions Accepted' && app.Record_Type_Name__c=='Home Loan'){
                system.debug('app.Id:-'+app.Id);
               List<Account> accList = queryService.ApplicantList(app.Id);
                system.debug('accList:--'+accList);

                for(Account acc : accList){
                    messageAck ='Dear Mr./Ms. <<borrower_Name>> , Your Housing Loan application No. <<App_No>> is  approved  for Rs. <<Loan_amt>> at  <<In_Rate>>% R.O.I p.a. for tenure of <<Ln_Term>> months subject to  address verification, income verification, Legal and valuation process.';       
                    messageAck = messageAck.replace('<<borrower_Name>>', acc.Full_Name__c);
                    messageAck = messageAck.replace('<<App_No>>', app.Name);
                    messageAck = messageAck.replace('<<Loan_amt>>', app.genesis__Loan_Amount__c != null ? String.ValueOf(app.genesis__Loan_Amount__c) : '');
                    messageAck = messageAck.replace('<<In_Rate>>', app.genesis__Interest_Rate__c != null ? String.ValueOf(app.genesis__Interest_Rate__c) : '');
                    messageAck = messageAck.replace('<<Ln_Term>>', app.genesis__Term__c != null ? String.ValueOf(app.genesis__Term__c) : '');
                    mobileNo = acc.PersonMobilePhone;
                    system.debug('@@@'+mobileNo+'$$$'+messageAck);
                    if(mobileNo.length() == 12){
                        SMS_Services.sendSMSFutureCall(mobileNo,messageAck);
                    }
                    else if(mobileNo.length() == 10){
                        mobileNo = '91'+ mobileNo;
                        SMS_Services.sendSMSFutureCall(mobileNo,messageAck);
                    }                    
                }
            }
        }
    }catch(Exception e){}
    }
     // Deleting Parties
  //  public static void Delparties(set<id> Pids){
        public static void Delparties(list<genesis__Application_Parties__c> Partlist,Map<Id,genesis__Application_Parties__c> newPart,Map<Id,genesis__Application_Parties__c> oldPart){
        try{
             Map<id,id> AppAccID=new map<id,id>();
            set<id> Dellist=new set<id>();
        //system.debug('Pids'+Pids);
         for(genesis__Application_Parties__c pat : Partlist){
             if((oldPart.get(pat.id).Active__c!=pat.Active__c) && !pat.Active__c){
                AppAccID.put(pat.genesis__Application__c,pat.genesis__Party_Account_Name__c);
             }
        }
          
        if (!AppAccID.isEmpty())  
        {
     list<genesis__Application_Document_Category__c>   FolderList=[select id,name,genesis__Application__c,Applicant__c from genesis__Application_Document_Category__c where genesis__Application__c IN:AppAccID.keyset()];
            if(!FolderList.isEmpty()) {
            for(genesis__Application_Document_Category__c Adc:FolderList){
                for(Id s:AppAccID.keyset()){
                    if(Adc.genesis__Application__c==s  && adc.Applicant__c==AppAccID.get(s) ){
                        Dellist.add(Adc.id);
                    }
                }
               
            }
                if(!Dellist.isEmpty()){
                         list<genesis__Application_Document_Category__c>   FolderList1=[select id from genesis__Application_Document_Category__c where ID IN:Dellist];

                    delete FolderList1;
                }
            }
        }

       /* if(Pids!=null){
      list<genesis__Application_Document_Category__c>   FOlderList=[select id,name from genesis__Application_Document_Category__c where Applicant__c IN:Pids];
        if(FOlderList.size()>0){
       system.debug('FOlderList'+FOlderList.size());
       delete FOlderList;
        }
        
    }*/
      
    }
        catch(exception e){
            system.debug('Error'+e.getStackTraceString()+'LineNumber'+e.getLineNumber());
        }
    }
}