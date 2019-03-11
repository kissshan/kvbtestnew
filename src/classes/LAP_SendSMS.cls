/*
* Name      : SMS_Services
* Compnay   : ET Marlabs
* Purpose   : For SMS Service - LAP. 
* Author    : Niladri
*/
public class LAP_SendSMS {
    
    /*
public static boolean Recusrive=True;


*/
    
    public static boolean Recusrive = True;
    
    public static string getDocumentLogoUrl() {
        List < Document > lstDocument = [Select Id, Name, LastModifiedById from Document where DeveloperName = 'Kvb_logo_for_Email' limit 1 ];
        System.debug('lstDocument:::' + lstDocument);
        string strOrgId = UserInfo.getOrganizationId();
        string strDocUrl = system.label.Domain_Name + '/servlet/servlet.ImageServer?id=' + lstDocument[0].Id + '&oid=' + strOrgId;
        System.debug(strDocUrl);
        return strDocUrl;
    }
    
    public static void sendSMSParties(String appObj) {
        system.debug('***Send SMS Co-applicant***');
        try {
            Recusrive = false;
            genesis__Application_Parties__c party = (genesis__Application_Parties__c) JSON.deserialize(appObj, genesis__Application_Parties__c.Class);
            
            
            List<genesis__Application_Parties__c>  parobj=[SELECT ID, Party_Email__c, Party_Mobile_No__c, genesis__Application__r.genesis__Loan_Amount__c, genesis__Application__r.Processing_Fee__c, genesis__Party_Account_Name__r.PersonEmail, genesis__Party_Account_Name__r.Name, genesis__Application__r.Name, genesis__Party_Account_Name__r.PersonMobilePhone, genesis__Party_Type__c, Applicant_Name__c, genesis__Party_Account_Name__r.salutation,genesis__Application__r.Primary_Applicant__c FROM genesis__Application_Parties__c Where id =: party.Id AND Active__c =: true AND Company__c =: false];
            
            System.debug('**parobj'+parobj);
            
            if (party.genesis__Party_Type__c =='Guarantor') {
              if(parobj.size()>0){
                String messageAck = 'Dear <<Title>>.<<Customer name>>,you have been added as guarantor by Mr. <<borrower name>> for <<product type>> application (<<application no.>>) with Karur Vysya Bank.';
                
                String applicationNo = party.Application_No__c; //party.genesis__Application__r.Name != null ? party.genesis__Application__r.Name : '-';
                String mobileNo = party.Party_Mobile_No__c;
                String par = 'LAP ';
                String Customername = party.Applicant_Name__c;
                String  borrowername=parobj[0].genesis__Application__r.Primary_Applicant__c;
                String title = parobj[0].genesis__Party_Account_Name__r.salutation;
                System.debug('**title'+title);
                System.debug('**borrowername'+borrowername);
                if (title == null) {
                    title = '-';
                }
                
                messageAck = messageAck.replace('<<application no.>>', applicationNo);
                messageAck = messageAck.replace('<<product type>>', par);
                messageAck = messageAck.replace('<<Customer name>>', Customername);
                messageAck = messageAck.replace('<<borrower name>>', borrowername);
                messageAck = messageAck.replace('<<Title>>', title);
                system.debug('####' + messageAck);
                if (mobileNo.length() == 12) {
                    SMS_Services.sendSMSFutureCall(mobileNo, messageAck);
                } else if (mobileNo.length() == 10) {
                    mobileNo = '91' + mobileNo;
                    SMS_Services.sendSMSFutureCall(mobileNo, messageAck);
                } else {
                    System.debug('Mobile No Not Valid');
                }
              }
                
            } else {
                String messageAck = 'Thank you for opting for <<product type>> from KVB. Our representative will guide you to complete your application (<<application no.>>)';
                String applicationNo = party.Application_No__c; //party.genesis__Application__r.Name != null ? party.genesis__Application__r.Name : '-';
                String mobileNo = party.Party_Mobile_No__c;
                String par = 'LAP ';
                messageAck = messageAck.replace('<<application no.>>', applicationNo);
                messageAck = messageAck.replace('<<product type>>', par);
                system.debug('####' + messageAck);
                if (mobileNo.length() == 12) {
                    SMS_Services.sendSMSFutureCall(mobileNo, messageAck);
                } else if (mobileNo.length() == 10) {
                    mobileNo = '91' + mobileNo;
                    SMS_Services.sendSMSFutureCall(mobileNo, messageAck);
                } else {
                    System.debug('Mobile No Not Valid');
                   
                }
            }
        }
        Catch(Exception e) {
            System.debug('*e' + e);
             System.debug('line no'+e.getLineNumber());
            HandleBusinessException.captureError('LAP_SendSMS','sendSMSParties', e);
        }
    }
    
    ////////////sms create application
   
    public static void sendSMSonCrt1(String appObj){        
        try{
            genesis__Applications__c application = (genesis__Applications__c)JSON.deserialize(appObj, genesis__Applications__c.Class);
            String messageAck = '';
            String mobileNo = '';
            String producttype='LAP ';
            messageAck ='Thank you for opting for <<product type>> from KVB. Our representative will guide you to complete your application (<<application no.>>).';       
            messageAck = messageAck.replace('<<application no.>>',application.Name);
            messageAck = messageAck.replace('<<product type>>',producttype);
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
            System.debug('e'+e);
            System.debug('e line number'+e.getLineNumber());
            HandleBusinessException.captureError('LAP_SendSMS','sendSMSonCrt1', e);
        }
    }
    
    
    
    //////////////////////////////////////////////////////////
    
    
    public static void sendSMSSubstage(String appObj) {
        try {
            genesis__Applications__c application = (genesis__Applications__c) JSON.deserialize(appObj, genesis__Applications__c.Class);
            
            /// Terms and Conditions Accepted  stage
            
            if (application.Sub_Stage__c == 'Terms and Conditions Accepted') {
                
                System.debug('*inside sendSMSSubstage');
                
                List < genesis__Application_Parties__c > ptList = [SELECT ID, Party_Email__c, Party_Mobile_No__c, genesis__Application__r.genesis__Loan_Amount__c,
                                                                   genesis__Application__r.Processing_Fee__c, genesis__Party_Account_Name__r.PersonEmail, 
                                                                   genesis__Party_Account_Name__r.Name, genesis__Application__r.Name, genesis__Party_Account_Name__r.PersonMobilePhone,
                                                                   genesis__Party_Type__c, Applicant_Name__c, genesis__Party_Account_Name__r.salutation 
                                                                   FROM genesis__Application_Parties__c Where genesis__Application__c =: application.Id AND Active__c =: true AND Company__c =: false];
                genesis__Applications__c app1 = [select id, genesis__Account__r.salutation from genesis__Applications__c where id =: application.id];
                
                String messageAck = '';
                String mobileNo = '';
                messageAck = 'Dear <<Title>>.<<Customer name>>, your <<product type>> application <<application no.>> is approved for Rs.<<Loan amount>> at <<ROI>>% p.a. for tenure of <<tenure>> months subject to address verification, income verification, legal and valuation process.';
                String producttype = 'LAP ';
                String applicationno = application.Name;
                String customername = application.Primary_Applicant__c;
                String loanamount = String.ValueOf(application.Total_Loan_Amount__c);
                //String amnt = Double.valueOf(loanamount);
                string ROI = string.ValueOf(application.genesis__Interest_Rate__c);
                String tenture = string.ValueOf(application.Sanctioned_Tenure__c);
                String title = app1.genesis__Account__r.salutation;
                String borrowername = application.Primary_Applicant__c;
                string interestrate = string.ValueOf(application.genesis__Interest_Rate__c);
                String email = application.Person_Email__c;
                String tenure = String.valueOf(application.genesis__Term__c);
                String createddate = String.valueOf(application.Created_Date__c);
                if (title == null) {
                    title = '-';
                }
                if(loanamount==null) {
                  loanamount='0'; 
                }
                if(ROI==null){
                    ROI='0';
                }
                if(interestrate==null){
                    interestrate='0';
                }
                if(tenture==null){
                    tenture='0';
                }
               
                messageAck = messageAck.replace('<<application no.>>', applicationno);
                messageAck = messageAck.replace('<<product type>>', producttype);
                messageAck = messageAck.replace('<<Customer name>>', customername);
                messageAck = messageAck.replace('<<Loan amount>>', loanamount);
                messageAck = messageAck.replace('<<ROI>>', ROI);
                messageAck = messageAck.replace('<<tenure>>', tenture);
                messageAck = messageAck.replace('<<Title>>', title);
                mobileNo = application.Primary_Applicant_Mobile__c;
                system.debug('MobileNo###' + application.Primary_Applicant_Mobile__c);
                system.debug('@@@' + mobileNo + '$$$' + messageAck);
                
                String logoUrl = getDocumentLogoUrl();
                /*String emailbody = 'Dear ' + title + ' ' + borrowername + ',<br><br> congratulations, your  application no. ' + applicationno + '  has been sanctioned for Rs.' + loanamount + ' @ ' + interestrate + ' per annum. <br><br>Thanks.<br><br><img src="' + logoUrl + '"/>' + '\t <b>Karur Vysya Bank</b>';*/
                String emailsubj = 'Informal Sanction of your LAP Loan Application No.'+ applicationno + 'dt.'+createddate;
                String emailbody = '<!DOCTYPE html><html lang="en"><head><title>Bootstrap Example</title><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"><script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.0/jquery.min.js"></script><script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script> </head><body>'+'Dear ' + title + ' ' + borrowername + ',<br><br>  We are glad to inform you that your Loan against property application has been approved as per the following terms subject to address verification, income verification, Legal and valuation process.<br><br>Loan Amount&nbsp;&nbsp;&nbsp;&nbsp;:&nbsp; Rs.'+ loanamount +'<br><br>Rate of Interest&nbsp;&nbsp&nbsp;&nbsp;:&nbsp; '+ interestrate +'%<br><br>Tenure of the Loan&nbsp;&nbsp;&nbsp;&nbsp;:&nbsp;'+ tenure +'<br><br>Terms and conditions:<br><br>1.  You are hereby advised to authorize the bank to undertake address verification process by engaging an outside agency and you have no objection to verify your residence/ office at the address given in the proof already submitted to the bank.<br><br>2.   You hereby advised to declare that the particulars furnished are true and correct and you abide by the rules and regulations of the bank in force in respect of such loans and advances.<br><br>3. You should undertake to inform KVB regarding any change in your occupation/employment and to provide any further information that KVB may require.<br><br>4.  You are hereby advised to agree as a precondition to the loan sanctioned in your name that in case of default in the repayment of the loan or in the servicing of the interest thereon, the Bank and/or the Reserve Bank of India will have unqualified right to disclose or publish your name as defaulter in such manner and through such medium as the Bank and/or the Reserve Bank of India in their absolute discretion may deem fit.<br><br>5.You have to declare that you have read, understood and acknowledge and agree that KVB may refer your name to credit referencing agency/ies and/or make such references and enquires as the Bank may consider necessary.<br><br>6. You are hereby advised to authorise the Bank to disclose such information relating to your credit facility to such parties as deemed necessary at the sole discretion of the Bank.<br><br>7. You are advised to declare that have/had no insolvency proceedings against you nor have ever been adjudicated insolvent.<br><br>8. You are advised to declare that you abide by all the terms and conditions of the Bank applicable to the above mentioned loan.<br><br>9. The interest rate provided above is indicative as it is a floating interest rate linked to MCLR of the Bank. The actual interest rate will be fixed as per the rate on the date of disbursement and will be communicated <br><br><br>Thanks.<br><br><img src="' + logoUrl + '"/>' + '\t <b>Karur Vysya Bank</b>'+'</body></html>';
                if (email != null) {
                    LAP_EmailHandaller.LAP_Email(email, emailbody, emailsubj);
                    
                }
                if (mobileNo.length() == 12) {
                    SMS_Services.sendSMSFutureCall(mobileNo, messageAck);
                } else if (mobileNo.length() == 10) {
                    mobileNo = '91' + mobileNo;
                    SMS_Services.sendSMSFutureCall(mobileNo, messageAck);
                } else {
                    System.debug('Mobile No Not Valid');
                }
                
                ///////////
                if (ptList.size() > 0) {
                    for (genesis__Application_Parties__c pt: ptList) {
                        messageAck = 'Dear <<Title>>.<<Customer name>>, your <<product type>> application <<application no.>> is approved for Rs.<<Loan amount>> at <<ROI>>% p.a. for tenure of <<tenure>> months subject to address verification, income verification, legal and valuation process.';
                        
                        String cust = pt.Applicant_Name__c;
                        String title1 = pt.genesis__Party_Account_Name__r.salutation;
                        if (title1 == null) {
                            title1 = '-';
                        }
                        
                        messageAck = messageAck.replace('<<application no.>>', applicationno);
                        messageAck = messageAck.replace('<<product type>>', producttype);
                        messageAck = messageAck.replace('<<Customer name>>', cust);
                        messageAck = messageAck.replace('<<Loan amount>>', loanamount);
                        messageAck = messageAck.replace('<<ROI>>', ROI);
                        messageAck = messageAck.replace('<<tenure>>', tenture);
                        messageAck = messageAck.replace('<<Title>>', title1);
                        mobileNo = pt.Party_Mobile_No__c;
                        if (mobileNo.length() == 12) {
                            SMS_Services.sendSMSFutureCall(mobileNo, messageAck);
                        } else if (mobileNo.length() == 10) {
                            mobileNo = '91' + mobileNo;
                            SMS_Services.sendSMSFutureCall(mobileNo, messageAck);
                        } else {
                            System.debug('Mobile No Not Valid');
                        }
                        system.debug('@@@' + mobileNo + '$$$' + messageAck);
                    }
                }
                
                
            }
            
            /////////////// for loan sanction ntsp
             if (application.Sub_Stage__c == 'Loan Sanctioned Non-STP') {
                
                System.debug('*inside sendSMSSubstage ---Loan Sanctioned NSTP - LAP ');
                
                List < genesis__Application_Parties__c > ptList = [SELECT ID, Party_Email__c, Party_Mobile_No__c, genesis__Application__r.genesis__Loan_Amount__c,
                                                                   genesis__Application__r.Processing_Fee__c, genesis__Party_Account_Name__r.PersonEmail, 
                                                                   genesis__Party_Account_Name__r.Name, genesis__Application__r.Name, genesis__Party_Account_Name__r.PersonMobilePhone,
                                                                   genesis__Party_Type__c, Applicant_Name__c, genesis__Party_Account_Name__r.salutation 
                                                                   FROM genesis__Application_Parties__c Where genesis__Application__c =: application.Id AND Active__c =: true AND Company__c =: false];
                
                genesis__Applications__c app1 = [select id, genesis__Account__r.salutation from genesis__Applications__c where id =: application.id];
                
                System.debug('app1' + app1);
                String messageAck = '';
                String mobileNo = '';
                messageAck = 'Dear <<Title>>.<<borrower name>>, Congratulations your <<product type>> application (<<application no.>>)  has been sanctioned for Rs. <<Limit amt.>> @ <<interest rate>> per annum. The sanction letter will be sent to your email id. (<<email id of borrower>>).';
                String producttype = 'LAP ';
                String applicationno = application.Name;
                String borrowername = application.Primary_Applicant__c;
                String loanamount = String.ValueOf(application.Sanction_Authority_Limit__c  );
                string interestrate = string.ValueOf(application.genesis__Interest_Rate__c);
                String email = application.Person_Email__c;
                String title = app1.genesis__Account__r.salutation;
                
                if (title == null) {
                    title = '-';
                }
                 if(loanamount==null){
                     loanamount='0';
                 }
                  if(interestrate==null){
                     interestrate='0';
                 }
                 
                
                
                messageAck = messageAck.replace('<<application no.>>', applicationno);
                messageAck = messageAck.replace('<<product type>>', producttype);
                messageAck = messageAck.replace('<<borrower name>>', borrowername);
                messageAck = messageAck.replace('<<Limit amt.>>', loanamount);
                messageAck = messageAck.replace('<<interest rate>>', interestrate);
                messageAck = messageAck.replace('<<email id of borrower>>', email);
                messageAck = messageAck.replace('<<Title>>', title);
                mobileNo = application.Primary_Applicant_Mobile__c;
                system.debug('MobileNo###' + application.Primary_Applicant_Mobile__c);
                system.debug('@@@' + mobileNo + '$$$' + messageAck);
                
                //// for email details-ntsp
                //
                String logoUrl = getDocumentLogoUrl();
                String emailbody = 'Dear ' + title + ' ' + borrowername + ',<br><br> congratulations, your  application no. ' + applicationno + '  has been sanctioned for Rs.' + loanamount + ' @ ' + interestrate + ' per annum. <br><br>Thanks.<br><br><img src="' + logoUrl + '"/>' + '\t <b>Karur Vysya Bank</b>';
                
                String emailsubj = 'KVB  ' + producttype + 'sanction communication';
                if (email != null) {
                    LAP_EmailHandaller.LAP_Email(email, emailbody, emailsubj);
                    
                }
                
                if (mobileNo.length() == 12) {
                    SMS_Services.sendSMSFutureCall(mobileNo, messageAck);
                } else if (mobileNo.length() == 10) {
                    mobileNo = '91' + mobileNo;
                    SMS_Services.sendSMSFutureCall(mobileNo, messageAck);
                } else {
                    System.debug('Mobile No Not Valid');
                }
                
                
                
                ///////////
                if (ptList.size() > 0) {
                    for (genesis__Application_Parties__c pt: ptList) {
                        messageAck = 'Dear <<Title>>.<<borrower name>>, congratulations your <<product type>> application (<<application no.>>)  has been sanctioned for Rs. <<Limit amt.>> @ <<interest rate>> per annum. The sanction letter will be sent to your email id. (<<email id of borrower>>).';
                        
                        String cust = pt.Applicant_Name__c;
                        string partyemail = pt.Party_Email__c;
                        String title1 = pt.genesis__Party_Account_Name__r.salutation;
                        if (title1 == null) {
                            title1 = '-';
                        }
                        
                        messageAck = messageAck.replace('<<application no.>>', applicationno);
                        messageAck = messageAck.replace('<<product type>>', producttype);
                        messageAck = messageAck.replace('<<borrower name>>', cust);
                        messageAck = messageAck.replace('<<Limit amt.>>', loanamount);
                        messageAck = messageAck.replace('<<interest rate>>', interestrate);
                        messageAck = messageAck.replace('<<email id of borrower>>', partyemail);
                        messageAck = messageAck.replace('<<Title>>', title1);
                        mobileNo = pt.Party_Mobile_No__c;
                        ///party email
                        //
                        
                        String emailbody1 = 'Dear ' + title1 + ' ' + cust + ',<br><br> congratulations, your mortgage loan application no. ' + applicationno + '  has been sanctioned for Rs.' + loanamount + ' @ ' + interestrate + ' per annum.  <br><br>Thanks.<br><br><img src="' + logoUrl + '"/>' + '\t <b>Karur Vysya Bank</b>';
                        
                        if (email != null) {
                            LAP_EmailHandaller.LAP_Email(partyemail, emailbody1, emailsubj);
                            
                        }
                        
                        if (mobileNo.length() == 12) {
                            SMS_Services.sendSMSFutureCall(mobileNo, messageAck);
                        } else if (mobileNo.length() == 10) {
                            mobileNo = '91' + mobileNo;
                            SMS_Services.sendSMSFutureCall(mobileNo, messageAck);
                        } else {
                            System.debug('Mobile No Not Valid');
                        }
                        system.debug('@@@' + mobileNo + '$$$' + messageAck);
                    }
                }
                
                
            }
            /////////////////////////////    Post E-sign of documents-------Disbursement Documents Esigned////
            
            if (application.Sub_Stage__c == 'Disbursement Documents Esigned') {
                
                System.debug('*inside sendSMSSubstage --- - LAP ');
                
                List < genesis__Application_Parties__c > ptList = [SELECT ID, Party_Email__c, Party_Mobile_No__c, genesis__Application__r.genesis__Loan_Amount__c, 
                                                                   genesis__Application__r.Processing_Fee__c, genesis__Party_Account_Name__r.PersonEmail, 
                                                                   genesis__Party_Account_Name__r.Name, genesis__Application__r.Name, genesis__Party_Account_Name__r.PersonMobilePhone, 
                                                                   genesis__Party_Type__c, Applicant_Name__c, genesis__Party_Account_Name__r.salutation 
                                                                   FROM genesis__Application_Parties__c Where genesis__Application__c =: application.Id AND Active__c =: true AND Company__c =: False];
                
                genesis__Applications__c app1 = [select id, genesis__Account__r.salutation from genesis__Applications__c where id =: application.id];
                
                System.debug('app1' + app1);
                String messageAck = '';
                String mobileNo = '';
                messageAck = 'Dear <<Title>>.<<borrower name>>, congratulations your <<product type>> application (<<application no.>>)  has been sanctioned for Rs. <<Limit amt.>> @ <<interest rate>> per annum. The sanction letter will be sent to your email id. (<<email id of borrower>>).';
                String producttype = 'LAP ';
                String applicationno = application.Name;
                String borrowername = application.Primary_Applicant__c;
                String loanamount = String.ValueOf(application.Sanction_Authority_Limit__c  );
                string interestrate = string.ValueOf(application.genesis__Interest_Rate__c);
                String email = application.Person_Email__c;
                String title = app1.genesis__Account__r.salutation;
                if (title == null) {
                    title = '-';
                }
                if(loanamount==null){
                    loanamount='0';
                }
                if(interestrate==null){
                    interestrate='0';
                }
                
                mobileNo = application.Primary_Applicant_Mobile__c;
                system.debug('MobileNo###' + application.Primary_Applicant_Mobile__c);
                system.debug('@@@' + mobileNo + '$$$' + messageAck);
                
                //// for email e-documents
                //
                String logoUrl = getDocumentLogoUrl();
                String emailbody = 'Dear ' + title + ' ' + borrowername + ',<br><br> please find attached the copy of your ' + producttype + ' agreement and other related documents. <br><br>Thanks.<br><br><img src="' + logoUrl + '"/>' + '\t <b>Karur Vysya Bank</b>';
                
                String emailsubj = 'KVB  ' + producttype + 'documents';
                if (email != null) {
                    LAP_EmailHandaller.LAP_Email(email, emailbody, emailsubj);
                    
                }
                
                ///////////
                if (ptList.size() > 0) {
                    for (genesis__Application_Parties__c pt: ptList) {
                        messageAck = 'Dear <<Title>>.<<borrower name>>, congratulations your <<product type>> application (<<application no.>>)  has been sanctioned for Rs. <<Limit amt.>> @ <<interest rate>> per annum. The sanction letter will be sent to your email id. (<<email id of borrower>>).';
                        
                        String cust = pt.Applicant_Name__c;
                        string partyemail = pt.Party_Email__c;
                        String title1 = pt.genesis__Party_Account_Name__r.salutation;
                        if (title1 == null) {
                            title1 = '-';
                        }
                        
                        mobileNo = pt.Party_Mobile_No__c;
                        
                        ///party email
                        
                        String emailbody1 = 'Dear ' + title1 + ' ' + cust + ',<br><br> please find attached the copy of your ' + producttype + ' agreement and other related documents. <br><br>Thanks.<br><br><img src="' + logoUrl + '"/>' + '\t <b>Karur Vysya Bank</b>';
                        
                                  //Set email file attachments
                        List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
                        for(Attachment a: [select Name, Body, BodyLength from Attachment where ParentId =:app1.id  AND (Name =: Constants.Acknowledgement_For_SanctionLAP+'.pdf' OR Name LIKE 'LAP_B1%' OR NAME =: Constants.LAP_A23+'.pdf' OR NAME =: Constants.LAP_A46+'.pdf')])
                        {
                            // Add to attachment file list
                            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                            efa.setFileName(a.Name);
                            efa.setBody(a.Body);
                            fileAttachments.add(efa);
                            system.debug('##### Name '+ a.Name + ' ' +app1.id);
                        }   
                        if (email != null) {
                            //LAP_EmailHandaller.LAP_Email(partyemail, emailbody1, emailsubj);
                            LAP_EmailHandaller.PLEmail(email, emailbody, emailsubj,fileAttachments,null);
                            }
                        system.debug('@@@' + mobileNo + '$$$' + messageAck);
                    }
                }
               
            }
            
            /////////////////////Loan account opened////////////////////
            
            
            if (application.Sub_Stage__c == 'Loan account opened') {
                
                System.debug('*inside sendSMSSubstage ---Loan account opened ');
                
                List < genesis__Application_Parties__c > ptList = [SELECT ID, Party_Email__c, Party_Mobile_No__c, genesis__Application__r.genesis__Loan_Amount__c, 
                                                                   genesis__Application__r.Processing_Fee__c, genesis__Party_Account_Name__r.PersonEmail, 
                                                                   genesis__Party_Account_Name__r.Name, genesis__Application__r.Name, genesis__Party_Account_Name__r.PersonMobilePhone,
                                                                   genesis__Party_Type__c, Applicant_Name__c, genesis__Party_Account_Name__r.salutation 
                                                                   FROM genesis__Application_Parties__c Where genesis__Application__c =: application.Id AND Active__c =:true AND Company__c =: False];
                
                genesis__Applications__c app1 = [select id, genesis__Account__r.salutation from genesis__Applications__c where id =: application.id];
                
                System.debug('app1' + app1);
                
                String messageAck = '';
                String mobileNo = '';
                messageAck = 'Dear <<Title>>.<<borrower name>>, congratulations your <<product type>> account has been opened with a/c no.(<<loan account no.>>).';
                String producttype = 'LAP ';
                String borrowername = application.Primary_Applicant__c;
                String loanacountno = application.Loan_Account_Number__c;
                String title = app1.genesis__Account__r.salutation;
                
                if (title == null) {
                    title = '-';
                }
                if(loanacountno==null){
                    loanacountno='0';
                }
                System.debug('salutation' + title);
                
                
                messageAck = messageAck.replace('<<product type>>', producttype);
                messageAck = messageAck.replace('<<borrower name>>', borrowername);
                messageAck = messageAck.replace('<<loan account no.>>', loanacountno);
                messageAck = messageAck.replace('<<Title>>', title);
                mobileNo = application.Primary_Applicant_Mobile__c;
                system.debug('MobileNo###' + application.Primary_Applicant_Mobile__c);
                system.debug('@@@' + mobileNo + '$$$' + messageAck);
                if (mobileNo.length() == 12) {
                    SMS_Services.sendSMSFutureCall(mobileNo, messageAck);
                } else if (mobileNo.length() == 10) {
                    mobileNo = '91' + mobileNo;
                    SMS_Services.sendSMSFutureCall(mobileNo, messageAck);
                } else {
                    System.debug('Mobile No Not Valid');
                }
                 ///////////
                if (ptList.size() > 0) {
                    for (genesis__Application_Parties__c pt: ptList) {
                        messageAck = 'Dear <<Title>>.<<borrower name>>, congratulations your <<product type>> account has been opened with a/c no.(<<loan account no.>>).';
                        
                        String cust = pt.Applicant_Name__c;
                        string partyemail = pt.Party_Email__c;
                        String title1 = pt.genesis__Party_Account_Name__r.salutation;
                        if (title1 == null) {
                            title1 = '-';
                        }
                        messageAck = messageAck.replace('<<product type>>', producttype);
                        messageAck = messageAck.replace('<<borrower name>>', cust);
                        messageAck = messageAck.replace('<<loan account no.>>', loanacountno);
                        messageAck = messageAck.replace('<<Title>>', title1);
                        mobileNo = pt.Party_Mobile_No__c;
                        if (mobileNo.length() == 12) {
                            SMS_Services.sendSMSFutureCall(mobileNo, messageAck);
                        } else if (mobileNo.length() == 10) {
                            mobileNo = '91' + mobileNo;
                            SMS_Services.sendSMSFutureCall(mobileNo, messageAck);
                        } else {
                            System.debug('Mobile No Not Valid');
                        }
                        system.debug('@@@' + mobileNo + '$$$' + messageAck);
                    }
                }
                
                
            }
            
            
        }
        Catch(Exception e) {
            System.debug('e' + e);
            System.debug('e' + e.getLineNumber());
            HandleBusinessException.captureError('LAP_SendSMS','sendSMSSubstage', e);
        }
    }
    
    
       /////////////sms for PL---------------------------------------------Personal Loan-----------------------------------------------------------
     public static  void sendSms(String appObj){
        try {
            genesis__Applications__c application = (genesis__Applications__c) JSON.deserialize(appObj, genesis__Applications__c.Class);
            
            ///Sub-Stage change to "Application created"
            
            if (application.Sub_Stage__c == 'Application created') {
                
                System.debug('*Application created');
                
                genesis__Applications__c app1 = [select id, genesis__Account__r.salutation from genesis__Applications__c where id =: application.id];
                
                String messageAck = '';
                String mobileNo = '';
                messageAck = 'Thank you for opting for personal loan from KVB. Our representative will guide you to complete your application (<<application no.>>).';
                String applicationno = application.Name;
                String producttype = 'Personal Loan';
                
                messageAck = messageAck.replace('<<application no.>>', applicationno);
                messageAck = messageAck.replace('<<product type>>', producttype);
                
                mobileNo = application.Primary_Applicant_Mobile__c;
                system.debug('MobileNo###' + application.Primary_Applicant_Mobile__c);
                system.debug('@@@' + mobileNo + '$$$' + messageAck);
                if (mobileNo.length() == 12) {
                    SMS_Services.sendSMSFutureCall(mobileNo, messageAck);
                } else if (mobileNo.length() == 10) {
                    mobileNo = '91' + mobileNo;
                    SMS_Services.sendSMSFutureCall(mobileNo, messageAck);
                } else {
                    System.debug('Mobile No Not Valid');
                }
            }
           
            /// Terms and Conditions Accepted  stage
            
            if (application.Sub_Stage__c == 'Terms and Conditions Accepted') {
                
                System.debug('*inside Terms and Conditions Accepted');
                
                genesis__Applications__c app1 = [select id, genesis__Account__r.salutation from genesis__Applications__c where id =: application.id];
                
                String messageAck = '';
                String mobileNo = '';
                messageAck = 'Dear <<Title>>.<<borrower name>>, <<sanction message>> subject to address verification, income verification';
                String customername = application.Primary_Applicant__c;
                String sanctionmessage=application.Sanction_Message__c;
                String title = app1.genesis__Account__r.salutation;
                if (title == null) {
                    title = '-';
                }
                
                messageAck = messageAck.replace('<<borrower name>>', customername);
                messageAck = messageAck.replace('<<Title>>', title);
                messageAck = messageAck.replace('<<sanction message>>', sanctionmessage);
                mobileNo = application.Primary_Applicant_Mobile__c;
                system.debug('MobileNo###' + application.Primary_Applicant_Mobile__c);
                system.debug('@@@' + mobileNo + '$$$' + messageAck);
                if (mobileNo.length() == 12) {
                    SMS_Services.sendSMSFutureCall(mobileNo, messageAck);
                } else if (mobileNo.length() == 10) {
                    mobileNo = '91' + mobileNo;
                    SMS_Services.sendSMSFutureCall(mobileNo, messageAck);
                } else {
                    System.debug('Mobile No Not Valid');
                }
                
            }
            
            //Loan Sanctioned STP"/ "Loan Sanctioned NSTP
            
            if (application.Sub_Stage__c =='Loan Sanctioned Non-STP' || application.Sub_Stage__c==Constants.PL_LOAN_STP) {
                
                System.debug('*inside sendSMSSubstage ---Loan Sanctioned Non-STP -pl');
                genesis__Applications__c app1 = [select id, genesis__Account__r.salutation from genesis__Applications__c where id =: application.id];
                
                System.debug('app1' + app1);
                String messageAck = '';
                String mobileNo = '';
                messageAck = 'Dear <<Title>>.<<borrower name>>, congratulations your personal loan application (<<application no.>>)  has been sanctioned for Rs. <<Limit amt.>> @ <<interest rate>>% per annum. The sanction letter will be sent to your email id. (<<email id of borrower>>).';
                String producttype = 'personal Loan';
                String applicationno = application.Name;
                String borrowername = application.Primary_Applicant__c;
                String loanamount = String.ValueOf(application.Sanction_Authority_Limit__c);
                string interestrate = string.ValueOf(application.genesis__Interest_Rate__c);
                String email = application.Person_Email__c;
                String title = app1.genesis__Account__r.salutation;
                String IsCreditLife = '';
                if (title == null) {
                    title = '-';
                }
                if(application.Is_CreditLife__c == True){
                        IsCreditLife = '9. You have agreed to take credit life insurance for this loan. You are requested to provide the bank with the insurance policy details.';
                }

                messageAck = messageAck.replace('<<application no.>>', applicationno);
                messageAck = messageAck.replace('<<product type>>', producttype);
                messageAck = messageAck.replace('<<borrower name>>', borrowername);
                messageAck = messageAck.replace('<<Limit amt.>>', loanamount);
                messageAck = messageAck.replace('<<interest rate>>', interestrate);
                messageAck = messageAck.replace('<<email id of borrower>>', email);
                messageAck = messageAck.replace('<<Title>>', title);
                mobileNo = application.Primary_Applicant_Mobile__c;
                system.debug('@@@' + mobileNo + '$$$' + messageAck);
                
                //// for email details-ntsp
                String logoUrl = getDocumentLogoUrl();
                //String emailbody = 'Dear ' + title + ' ' + borrowername + ',<br><br>  congratulations your personal loan application  ' + applicationno + '  has been sanctioned for Rs.' + loanamount + ' @ ' + interestrate + '%per annum. The sanction letter will be sent shortly.  <br><br>Thanks.<br><br><img src="' + logoUrl + '"/>' + '\t <b>Karur Vysya Bank</b>';
                String emailbody = '<!DOCTYPE html><html lang="en"><head><title>Bootstrap Example</title><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"><script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.0/jquery.min.js"></script><script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script></head><body>'+'Dear ' + title + ' ' + borrowername + ',<br><br>  Congratulations! your personal loan application  ' + applicationno + '  has been sanctioned for Rs.' + loanamount + ' @ ' + interestrate + '%per annum. The sanction letter will be sent shortly.<br><br>Terms and conditions:<br>1. You are hereby advised to authorize the bank to undertake address verification process by engaging an outside agency and you have no objection to verify your residence/ office at the address given in the proof already submitted to the bank.<br>2. You hereby advised to declare that the particulars furnished are true and correct and you abide by the rules and regulations of the bank in force in respect of such loans and advances.<br>3. You should undertake to inform KVB regarding any change in your occupation/employment and to provide any further information that KVB may require.<br>4. You are hereby advised to agree as a precondition to the loan sanctioned in your name that in case of default in the repayment of the loan or in the servicing of the interest thereon, the Bank and/or the Reserve Bank of India will have unqualified right to disclose or publish your name as defaulter in such manner and through such medium as the Bank and/or the Reserve Bank of India in their absolute discretion may deem fit.<br>5. You have to declare that you have read, understood and acknowledge and agree that KVB may refer your name to credit referencing agency/ies and/or make such references and enquires as the Bank may consider necessary.<br>6. You are hereby advised to authorise the Bank to disclose such information relating to your credit facility to such parties as deemed necessary at the sole discretion of the Bank.<br>7. You are advised to declare that have/had no insolvency proceedings against you nor have ever been adjudicated insolvent.<br>8. You are advised to declare that you abide by all the terms and conditions of the Bank applicable to the above mentioned loan.<br>'+IsCreditLife+'<br><br>Thanks.<br><br><img src="' + logoUrl + '"/>' + '\t <b>Karur Vysya Bank</b>'+'</body></html>';

                String emailsubj = 'KVB  ' + producttype + ' sanction communication';
                if (email != null) {
                    LAP_EmailHandaller.LAP_Email(email, emailbody, emailsubj);
                    
                }
                
                if (mobileNo.length() == 12) {
                    SMS_Services.sendSMSFutureCall(mobileNo, messageAck);
                } else if (mobileNo.length() == 10) {
                    mobileNo = '91' + mobileNo;
                    SMS_Services.sendSMSFutureCall(mobileNo, messageAck);
                } else {
                    System.debug('Mobile No Not Valid');
                }
            }
            
            ///Disbursement details captured
           if (application.Sub_Stage__c == 'SI details captured') {
                
                System.debug('*inside Disbursement details captured ');
                
                genesis__Applications__c app1 = [select id, genesis__Account__r.salutation,genesis__Account__r.Name from genesis__Applications__c where id =: application.id];
                
                ///for preapprove sms
               if(application.Pre_approved_flag__c){
                   System.debug('check preapprove');
                  user u=[select name,Phone,Email,Role_Name__c,Branch_Name__c,Office_Code__c from user where Office_Code__c=:application.Branch_Code__c];
               
                String messageAck1 = '';
                String mobileNo1 = '';
                messageAck1 = 'Pre approved PL application <<application no.>> of <<Borrower Name>> has been sanctioned for Rs <<Sanction Authority Limit>>.';
                String customername1 = app1.genesis__Account__r.Name;
                String applno=application.name;
                String sanctAmt =String.valueOf(application.Sanction_Authority_Limit__c);
                
                messageAck1 = messageAck1.replace('<<Borrower Name>>', customername1);
                messageAck1 = messageAck1.replace('<<Sanction Authority Limit>>', sanctAmt);
                messageAck1 = messageAck1.replace('<<application no.>>', applno);
                mobileNo1 = u.Phone;
                system.debug('MobileNo###' +mobileNo1);
                system.debug('@@@' + mobileNo1 + '$$$' + messageAck1);
                if (mobileNo1.length() == 12) {
                    SMS_Services.sendSMSFutureCall(mobileNo1, messageAck1);
                } else if (mobileNo1.length() == 10) {
                    mobileNo1 = '91' + mobileNo1;
                    SMS_Services.sendSMSFutureCall(mobileNo1, messageAck1);
                } else {
                    System.debug('Mobile No Not Valid');
                }
               }
               //end pre approve sms
               
                System.debug('app1' + app1);
                String messageAck = '';
                String mobileNo = '';
                messageAck = 'Dear <<Title>>.<<borrower name>>,as per your instructions, your personal loan will be disbursed to account number <<disbursement account number>> with <<disbursement bank name>>. As per your approval, automated deduction of monthly EMIs will be set up for the <<SI account number>> with <<SI Bank name>>';
                String producttype = 'Personal Loan';
                String applicationno = application.Name;
                String borrowername = application.Primary_Applicant__c;
                String disbursement_account_number = String.ValueOf(application.Disbursement_Account_Number__c);
                string disbursement_bank_name = application.Disbursement_Account_Bank_Name__c;
                String SI_account_number=String.ValueOf(application.SI_Account_Number__c);
                String SI_Bank_name=application.SI_Bank_Name__c;
                String email = application.Person_Email__c;
                String title = app1.genesis__Account__r.salutation;
                
                if (title == null) {
                    title = '-';
                }
                messageAck = messageAck.replace('<<application no.>>', applicationno);
                messageAck = messageAck.replace('<<product type>>', producttype);
                messageAck = messageAck.replace('<<borrower name>>', borrowername);
                messageAck = messageAck.replace('<<disbursement account number>>', disbursement_account_number);
                messageAck = messageAck.replace('<<disbursement bank name>>', disbursement_bank_name);
                messageAck = messageAck.replace('<<SI account number>>', SI_account_number);
                messageAck = messageAck.replace('<<SI Bank name>>', SI_Bank_name);
                messageAck = messageAck.replace('<<email id of borrower>>', email);
                messageAck = messageAck.replace('<<Title>>', title);
                mobileNo = application.Primary_Applicant_Mobile__c;
                system.debug('MobileNo###' + application.Primary_Applicant_Mobile__c);
                system.debug('@@@' + mobileNo + '$$$' + messageAck);
                
                //// for email details-ntsp
                //
                String logoUrl = getDocumentLogoUrl();
                String emailbody = 'Dear ' + title + ' ' + borrowername + ',<br><br> as per your instructions, your personal loan will be disbursed to account number ' + disbursement_account_number + ' with ' + disbursement_bank_name + ' . As per your approval, automated deduction of monthly EMIs will be set up for the ' + SI_account_number + ' with' + SI_Bank_name + '  <br><br>Thanks.<br><br><img src="' + logoUrl + '"/>' + '\t <b>Karur Vysya Bank</b>';

    
               String emailsubj = 'KVB  ' + producttype + ' disbursement and recurring Mandate details';
                if (email != null) {
                    LAP_EmailHandaller.LAP_Email(email, emailbody, emailsubj);
                    
                }
                
                if (mobileNo.length() == 12) {
                    SMS_Services.sendSMSFutureCall(mobileNo, messageAck);
                } else if (mobileNo.length() == 10) {
                    mobileNo = '91' + mobileNo;
                    SMS_Services.sendSMSFutureCall(mobileNo, messageAck);
                } else {
                    System.debug('Mobile No Not Valid');
                }
               
              
            }
            
            //Documents signed
            
              if (application.Sub_Stage__c == Constants.SUBSTAGE_DISBURSEMENTESIGN) {
                
                System.debug('*Documents signed');
                
                genesis__Applications__c app1 = [select id, genesis__Account__r.salutation from genesis__Applications__c where id =: application.id];
                
                System.debug('app1' + app1);
                String messageAck = '';
                String mobileNo = '';
                messageAck = 'Dear <<Title>>.<<borrower name>>,as per your instructions, your personal loan will be disbursed to account number <<disbursement account number>> with <<disbursement bank name>>. As per your approval, automated deduction of monthly EMIs will be set up for the <<SI account number>> with <<SI Bank name>>';
                String producttype = 'Personal Loan';
                String applicationno = application.Name;
                String borrowername = application.Primary_Applicant__c;
                String disbursement_account_number = String.ValueOf(application.Disbursement_Account_Number__c);
                string disbursement_bank_name = application.Disbursement_Account_Bank_Name__c;
                String SI_account_number=String.ValueOf(application.SI_Account_Number__c);
                String SI_Bank_name=application.SI_Bank_Name__c;
                String email = application.Person_Email__c;
                String title = app1.genesis__Account__r.salutation;
                
                if (title == null) {
                    title = '-';
                }
                
                 //Set email file attachments
                List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
                for(Attachment a: [select Name, Body, BodyLength from Attachment where ParentId =:app1.id  AND (Name =: Constants.PRE_APPROVE_SANCTION_PL+'.pdf' OR NAME =: Constants.PL_AGREEMENT_DOC+'.pdf')])
                {
                    // Add to attachment file list
                    Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                    efa.setFileName(a.Name);
                    efa.setBody(a.Body);
                    fileAttachments.add(efa);
                    system.debug('##### Name '+ a.Name + ' ' +app1.id);
                }                
                
                system.debug('##### attachment '+ fileAttachments);

                mobileNo = application.Primary_Applicant_Mobile__c;
                system.debug('MobileNo###' + application.Primary_Applicant_Mobile__c);
                system.debug('@@@' + mobileNo + '$$$' + messageAck);
                
                //// for email details-ntsp
                //
                String logoUrl = getDocumentLogoUrl();
                String emailbody = 'Dear ' + title + ' ' + borrowername + ',<br><br> please find attached the copy of your ' + producttype + ' agreement and other related documents. <br><br>Thanks.<br><br><img src="' + logoUrl + '"/>' + '\t <b>Karur Vysya Bank</b>';
                
                String emailsubj = 'KVB  ' + producttype + ' related documents';
                if (email != null) {
                         LAP_EmailHandaller.PLEmail(email, emailbody, emailsubj,fileAttachments,null);
                    
                }
                
            }
            
            ///Disbursed application
            
             if (application.Sub_Stage__c == 'Loan Account Opened') {
                
                System.debug('*Loan Account Opened -- application');
                
                genesis__Applications__c app1 = [select id, genesis__Account__r.salutation from genesis__Applications__c where id =: application.id];
                
                System.debug('app1' + app1);
                
                String messageAck = '';
                String mobileNo = '';
                messageAck = 'Dear <<Title>>.<<borrower name>>, congratulations your <<product type>> account has been opened with a/c no.(<<loan account no.>>) and loan amount has been credited to <<disbursement account number>> with <<disbursement bank name>>.';
                String producttype = 'Personal Loan';
                String borrowername = application.Primary_Applicant__c;
                String loanacountno = application.Loan_Account_Number__c;
                String title = app1.genesis__Account__r.salutation;
                String disbursement_account_number=String.ValueOf(application.Disbursement_Account_Number__c);
                String disbursement_bank_name=application.Disbursement_Account_Bank_Name__c;
                String email = application.Person_Email__c;
                 
                if (title == null) {
                    title = '-';
                }
                System.debug('salutation' + title);
                messageAck = messageAck.replace('<<product type>>', producttype);
                messageAck = messageAck.replace('<<borrower name>>', borrowername);
                messageAck = messageAck.replace('<<loan account no.>>', loanacountno);
                messageAck = messageAck.replace('<<disbursement account number>>', disbursement_account_number);
                messageAck = messageAck.replace('<<disbursement bank name>>', disbursement_bank_name);

                messageAck = messageAck.replace('<<Title>>', title);
                mobileNo = application.Primary_Applicant_Mobile__c;
                system.debug('MobileNo###' + application.Primary_Applicant_Mobile__c);
                system.debug('@@@' + mobileNo + '$$$' + messageAck);
                   String logoUrl = getDocumentLogoUrl();
                 
                 String emailbody = 'Dear ' + title + ' ' + borrowername + ',<br><br> congratulations your ' + producttype + ' account has been opened with a/c no.' + loanacountno + ' and loan amount has been credited to  ' + disbursement_account_number + ' with' + disbursement_bank_name + '  <br><br>Thanks.<br><br><img src="' + logoUrl + '"/>' + '\t <b>Karur Vysya Bank</b>';
                 
                String emailsubj = 'KVB  ' + producttype + ' Account Details';
                if (email != null) {
                       LAP_EmailHandaller.LAP_Email(email, emailbody, emailsubj);
                    
                }
       
                if (mobileNo.length() == 12) {
                    SMS_Services.sendSMSFutureCall(mobileNo, messageAck);
                } else if (mobileNo.length() == 10) {
                    mobileNo = '91' + mobileNo;
                    SMS_Services.sendSMSFutureCall(mobileNo, messageAck);
                } else {
                    System.debug('Mobile No Not Valid');
                }
                
             }    
            
            ///Rejected Applications
            
             if (application.Application_Stage__c == 'Application Rejected') {
                
                System.debug('*Rejected Applications');
                
                genesis__Applications__c app1 = [select id, genesis__Account__r.salutation,Branch_Name__c from genesis__Applications__c where id =: application.id];
                
              //  List<User> u=queryService.getUserDetails(application.Branch_Name__c);
              //  prashant singh--added limit 1 only because of code breaking while testing rejection senario
                user u=[select name,Phone,Email,Role_Name__c,Branch_Name__c from user where Branch_Name__c=:app1.Branch_Name__c AND Role_Name__c=:'Branch manager' limit 1];
                System.debug('app1' + app1);
                System.debug('user**'+u);
                String messageAck = '';
                String mobileNo = '';
                messageAck = 'Personal Loan application with application no. <<application no.>> has been rejected. Kindly review and communicate with customer.';
                String application_no = application.Name;
                String producttype = 'Personal Loan';
                String email = u.email;
                messageAck = messageAck.replace('<<application no.>>', application_no);
                mobileNo = u.Phone;
                system.debug('MobileNo###' + application.Primary_Applicant_Mobile__c);
                system.debug('@@@' + mobileNo + '$$$' + messageAck);
                   String logoUrl = getDocumentLogoUrl();
                
                 String emailbody = 'Personal Loan application with application no.  ' + application_no + ' has been rejected. Kindly review and communicate with customer.<br><br>Thanks.<br><br><img src="' + logoUrl + '"/>' + '\t <b>Karur Vysya Bank</b>';
                
                String emailsubj = 'Personal Loan Application Rejection';
                if (email != null) {
                     //  LAP_EmailHandaller.LAP_Email(email, emailbody, emailsubj);
                    
                }
       
                if (mobileNo.length() == 12) {
                    SMS_Services.sendSMSFutureCall(mobileNo, messageAck);
                } else if (mobileNo.length() == 10) {
                    mobileNo = '91' + mobileNo;
                    SMS_Services.sendSMSFutureCall(mobileNo, messageAck);
                } else {
                    System.debug('Mobile No Not Valid');
                }
                
             }   
            
        }
        catch(Exception e){
            System.debug('Exception'+e);
            System.debug('*ee'+e.getLineNumber());
            HandleBusinessException.captureError('LAP_SendSMS','sendSms', e);
        }
        
    }
    @InvocableMethod
    public static void RejectSMS(List<ID> ids){
        try{
            System.debug('Inside RejectSMS()***');
            genesis__Applications__c application =[select id,OwnerId,Application_Stage__c,genesis__Account__r.salutation,genesis__CL_Product_Name__c,Name,Sub_Stage__c,Total_Loan_Amount__c,Primary_Applicant__c,Amount_in_Words_And_Figures__c,genesis__Interest_Rate__c,Person_Email__c from genesis__Applications__c where id=:ids[0]];
           
                 System.debug('stage'+application.Application_Stage__c);
            if(application.Application_Stage__c==Constants.APPLICATION_REJECTED_MAINSTAGE ){
                 System.debug('**********check'+application);
                NumberToWordConversion ntwc = new NumberToWordConversion();
                String productName=application.genesis__CL_Product_Name__c;
                String applicationno = application.Name;
                String loanamount = String.ValueOf(application.Total_Loan_Amount__c);
                String loaninWords =ntwc.getNumberTOWordConvertion(Decimal.valueOf(application.Total_Loan_Amount__c));          
                String title = application.genesis__Account__r.salutation;
                String borrowername = application.Primary_Applicant__c;
                string interestrate = string.ValueOf(application.genesis__Interest_Rate__c);
                String email = application.Person_Email__c;  
                if (title == null) {
                    title = '-';
                }
                if(loanamount==null) {
                  loanamount='0'; 
                }  
                user u=[select name,Phone,Email,Role_Name__c,Branch_Name__c from user where id=:application.OwnerId];
                String branchCcMail=u.Email;
                String logoUrl = getDocumentLogoUrl();
                String emailsubj = 'Application Rejected  '+ applicationno ;
                String emailbody = 'Dear ' + title + ' ' + borrowername + ',<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; We regret to inform you that your loan application No.' + applicationno + ' for ' + productName + ' facility of Rs. ' + loanamount + ' (Rupees  ' + loaninWords+ ') has been rejected due to non-compliance of applicable requirements. ' +'<br><br> Please contact your branch manager for further details. <br>'+'<br> Kindly quote your loan application number in all your future correspondences. <br>'+ '  <br><br>Regards,.<br><br><img src="' + logoUrl + '"/>' + '\t <b>Karur Vysya Bank</b>';                              
                    if (email != null) {
                    LAP_EmailHandaller.PLEmail(email, emailbody, emailsubj,null,branchCcMail);
                }                
                ///////////
              /*  if (ptList.size() > 0) {
                    for (genesis__Application_Parties__c pt: ptList) {
                          
                        String cust = pt.Applicant_Name__c;
                        string partyemail = pt.Party_Email__c;
                        String title1 = pt.genesis__Party_Account_Name__r.salutation;
                        if (title1 == null) {
                            title1 = '-';
                        }
                       String emailsubj2 = 'Application Rejected '+ applicationno ;
                       String emailbody2 = 'Dear ' + title1 + ' ' + cust + ',<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; We regret to inform you that your loan application No.' + applicationno + ' for ' + productName + ' facility of Rs. ' + loanamount + ' (Rupees  ' + loaninWords+ ') has been rejected due to non-compliance of applicable requirements. ' +'<br><br> Please contact your branch manager for further details. <br>'+'<br><br> Kindly quote your loan application number in all your future correspondences. <br>'+ '  <br><br>Regards,.<br><br><img src="' + logoUrl + '"/>' + '\t <b>Karur Vysya Bank</b>';
                     if (email != null) {
                    LAP_EmailHandaller.LAP_Email(partyemail, emailbody2, emailsubj2);
                    
                }                             
                  } 
                    // end reject
                     }*/
            }
                }
    
        catch(Exception e){
            System.debug('Exception'+e);
            System.debug('*ee'+e.getLineNumber());
            HandleBusinessException.captureError('LAP_SendSMS','RejectSMS', e);
        }
    
    } //rejectt
    
}