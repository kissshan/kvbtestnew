/*
* Name    : VL_SendSMS
* Company : ET Marlabs
* Purpose : This class will be used for send sms
* Author  : Niladri*/

public class VL_SendSMS {
    
    
    public static boolean Recusrive = True;
    
    public static string getDocumentLogoUrl() {
        List < Document > lstDocument = [Select Id, Name, LastModifiedById from Document where DeveloperName = 'Kvb_logo_for_Email' limit 1 ];
        System.debug('lstDocument:::' + lstDocument);
        string strOrgId = UserInfo.getOrganizationId();
        string strDocUrl = system.label.Domain_Name + '/servlet/servlet.ImageServer?id=' + lstDocument[0].Id + '&oid=' + strOrgId;
        System.debug(strDocUrl);
        return strDocUrl;
    }
    
    public static void sendSMSPartiesVL(String appObj) {
        system.debug('***Send SMS Co-applicant***');
        try {
            Recusrive = false;
            genesis__Application_Parties__c party = (genesis__Application_Parties__c) JSON.deserialize(appObj, genesis__Application_Parties__c.Class);
            
            
            genesis__Application_Parties__c  parobj=[SELECT ID,genesis__Application__r.Record_Type_Name__c, Party_Email__c, Party_Mobile_No__c, genesis__Application__r.genesis__Loan_Amount__c, genesis__Application__r.Processing_Fee__c, genesis__Party_Account_Name__r.PersonEmail, genesis__Party_Account_Name__r.Name, genesis__Application__r.Name, genesis__Party_Account_Name__r.PersonMobilePhone, genesis__Party_Type__c, Applicant_Name__c, genesis__Party_Account_Name__r.salutation,genesis__Application__r.Primary_Applicant__c FROM genesis__Application_Parties__c Where id =: party.Id];
            
            String producttype='';
            if(parobj.genesis__Application__r.Record_Type_Name__c=='VL4W'){
                producttype=Constants.VL4WPRODNM;
            }
            else{
                producttype=Constants.VL2WPRODNM;
            }
            System.debug('**parobj'+parobj);
            
            if(party.genesis__Party_Type__c !=Constants.PRIMARY_APP) {
                String messageAck = 'Thank you for opting for <<product type>> from KVB. Our representative will guide you to complete your application (<<application no.>>)';
                String applicationNo = party.Application_No__c; //party.genesis__Application__r.Name != null ? party.genesis__Application__r.Name : '-';
                String mobileNo = party.Party_Mobile_No__c;
                // String par = producttype;
                messageAck = messageAck.replace('<<application no.>>', applicationNo);
                messageAck = messageAck.replace('<<product type>>', producttype);
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
        }
    }
    
    ////////////sms create application
    
    public static void sendSMSonCrtVL(String appObj){        
        try{
            genesis__Applications__c application = (genesis__Applications__c)JSON.deserialize(appObj, genesis__Applications__c.Class);
            String messageAck = '';
            String mobileNo = '';
            String producttype='';
            if(application.Record_Type_Name__c=='VL4W'){
                producttype=Constants.VL4WPRODNM;
            }
            else{
                producttype=Constants.VL2WPRODNM;
            }
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
        }
    }
    
    /////////// end create
    public static void sendSMSSubstageVL(String appObj) {
        String primary=Constants.PRIMARY_APP;
        try {
            genesis__Applications__c application = (genesis__Applications__c) JSON.deserialize(appObj, genesis__Applications__c.Class);
            String producttype='';
            String rate;
            if(application.Record_Type_Name__c=='VL4W'){
                producttype=Constants.VL4WPRODNM;
                rate='floating interest';
            }
            else{
                producttype=Constants.VL2WPRODNM;
                rate='fixed interest';
            }
            List < genesis__Application_Parties__c > ptList = [SELECT ID,Active__c,Company__c, Party_Email__c, Party_Mobile_No__c, genesis__Application__r.genesis__Loan_Amount__c, genesis__Application__r.Processing_Fee__c, genesis__Party_Account_Name__r.PersonEmail, genesis__Party_Account_Name__r.Name, genesis__Application__r.Name, genesis__Party_Account_Name__r.PersonMobilePhone, genesis__Party_Type__c, Applicant_Name__c, genesis__Party_Account_Name__r.salutation FROM genesis__Application_Parties__c Where genesis__Application__c =: application.Id  AND genesis__Party_Type__c !=:primary AND Active__c =: true AND Company__c =: false];
            System.debug('***ptList'+ptList);
            genesis__Applications__c app1 = [select id, genesis__Account__r.salutation from genesis__Applications__c where id =: application.id];
            System.debug('app1' + app1);
            String applicationno = application.Name;
            String customername = application.Primary_Applicant__c;
            String title = app1.genesis__Account__r.salutation;
            String borrowername = application.Primary_Applicant__c;
            String email = application.Person_Email__c;
            String  mobileNo = application.Primary_Applicant_Mobile__c;
            String messageAck = '';
            String loanamount;
            string ROI ;
            String tenture ;
            string interestrate;
            String tenure;
            String createddate ;
            System.debug('*applicationno'+application.Sub_Stage__c);
            System.debug('*applicationno'+application.Record_Type_Name__c);
            if (application.Sub_Stage__c == 'Terms and Conditions Accepted') {
                
                System.debug('*inside sendSMSSubstage');
                
                if(application.Record_Type_Name__c==Constants.VL4W){
                    messageAck = 'Dear <<Title>><<Customer name>>, your <<product type>> application <<application no.>> is approved for Rs.<<Loan amount>> at <<ROI>>% p.a. for tenure of <<tenure>> months subject to address and income verification. The interest rate provided above is indicative and in case of any change you will be informed at the time of disbursment.';       
                }
                else {
                    messageAck = 'Dear <<Title>><<Customer name>>, your <<product type>> application <<application no.>> is approved for Rs.<<Loan amount>> at <<ROI>>% p.a. for tenure of <<tenure>> months subject to address and income verification. In case of any changes to the interest rate, you will be informed at the time of disbursment.';                   
                    
                }
                
                loanamount = String.ValueOf(application.Total_Loan_Amount__c);
                ROI = string.ValueOf(application.genesis__Interest_Rate__c);
                tenture = string.ValueOf(application.Sanctioned_Tenure__c);
                interestrate = string.ValueOf(application.genesis__Interest_Rate__c);                
                tenure = String.valueOf(application.genesis__Term__c);
                createddate = String.valueOf(application.Created_Date__c);
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
                if(tenure==null){
                    tenure='0';
                }
                
                system.debug('custname:-'+customername+'producttype:-'+producttype);
                messageAck = messageAck.replace('<<application no.>>', applicationno);
                messageAck = messageAck.replace('<<product type>>', producttype);
                messageAck = messageAck.replace('<<Customer name>>', customername);
                messageAck = messageAck.replace('<<Loan amount>>', loanamount);
                messageAck = messageAck.replace('<<ROI>>', ROI);
                messageAck = messageAck.replace('<<tenure>>', tenure);
                messageAck = messageAck.replace('<<Title>>', title);
                messageAck=  messageAck.replace('<<rate>>', rate);
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
                        if(application.Record_Type_Name__c==Constants.VL4W){
                            messageAck = 'Dear <<Title>><<Customer name>>, your <<product type>> application <<application no.>> is approved for Rs.<<Loan amount>> at <<ROI>>% p.a. for tenure of <<tenure>> months subject to address and income verification. The interest rate provided above is indicative and in case of any change you will be informed at the time of disbursment.';       
                        }
                        else {
                            messageAck = 'Dear <<Title>><<Customer name>>, your <<product type>> application <<application no.>> is approved for Rs.<<Loan amount>> at <<ROI>>% p.a. for tenure of <<tenure>> months subject to address and income verification. In case of any changes to the interest rate, you will be informed at the time of disbursment.';                   
                            
                        }
                        
                        //   messageAck = 'Dear <<Title>>.<<Customer name>>, your <<product type>> application <<application no.>> is approved for Rs.<<Loan amount>> at <<ROI>>% p.a. for tenure of <<tenure>> months subject to address verification, income verification, legal and valuation process. The interest rate provided above is indicative as it is a floating interest rate linked to MCLR of the Bank. The actual interest rate will be fixed as per the rate on the date of disbursement and will be communicated';
                        String cust = pt.Applicant_Name__c;
                        String title1 = pt.genesis__Party_Account_Name__r.salutation;
                        if (title1 == null) {
                            title1 = '-';
                        }
                        if (tenure == null) {
                            tenure = '0';
                        }
                        if (ROI == null) {
                            ROI = '0';
                        }
                        
                        messageAck = messageAck.replace('<<application no.>>', applicationno);
                        messageAck = messageAck.replace('<<product type>>', producttype);
                        messageAck = messageAck.replace('<<Customer name>>', cust);
                        messageAck = messageAck.replace('<<Loan amount>>', loanamount);
                        messageAck = messageAck.replace('<<ROI>>', ROI);
                        messageAck = messageAck.replace('<<tenure>>', tenure);
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
            ///end terms and condition
            /////////////// for loan sanction ntsp
            if (application.Sub_Stage__c =='Loan Sanctioned Non-STP' || application.Sub_Stage__c=='Loan Sanctioned STP' ) {
                System.debug('*inside sendSMSSubstage ---Loan Sanctioned NSTP - VL ');
                
                messageAck ='Dear <<Title>>.<<borrower name>>, congratulations your <<product type>> loan application (<<application no.>>)  has been sanctioned for Rs. <<Limit amt.>> @ <<interest rate>> per annum. In case of any changes to the interest rate, you will be informed at the time of disbursment. The sanction letter will be sent to your email id. (<<email id of borrower>>).';
                loanamount = String.ValueOf(application.Sanction_Authority_Limit__c  );
                interestrate = string.ValueOf(application.genesis__Interest_Rate__c);
                tenture = string.ValueOf(application.Sanctioned_Tenure__c);
                if (title == null) {
                    title = '-';
                }
                if(loanamount==null){
                    loanamount='0';
                }
                if(interestrate==null){
                    interestrate='0';
                }
                if(tenture==null){
                    tenture='0';
                }
                
                //   String tenture =null;
                messageAck = messageAck.replace('<<application no.>>', applicationno);
                messageAck = messageAck.replace('<<product type>>', producttype);
                messageAck = messageAck.replace('<<borrower name>>', borrowername);
                messageAck = messageAck.replace('<<Limit amt.>>', loanamount);
                messageAck = messageAck.replace('<<interest rate>>', interestrate);
                messageAck = messageAck.replace('<<email id of borrower>>', email);
                messageAck = messageAck.replace('<<Title>>', title);
                messageAck = messageAck.replace('<<rate>>', rate);
                system.debug('MobileNo###' + application.Primary_Applicant_Mobile__c);
                system.debug('@@@' + mobileNo + '$$$' + messageAck);
                
                //// for email details-ntsp
                //
                String logoUrl = getDocumentLogoUrl();
                
                String emailbody ='';
                if(application.Record_Type_Name__c==Constants.VL4W){
                    emailbody = '<!DOCTYPE html><html lang="en"><head><title>Bootstrap Example</title><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"><script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.0/jquery.min.js"></script><script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script></head><body>'+'Dear ' + title + ' ' + borrowername + ',<br><br> We are glad to inform you that your ' + producttype + '  application has been approved as per the following terms subject to address verification & income verification.<br/>Loan Amount : Rs. '+loanamount+'<br/>Rate of Interest : '+interestrate+'<br/>Tenure of the Loan : '+tenture+'<br/><br/>Terms and conditions: <br/>1. You are hereby advised to authorize the bank to undertake address verification process by engaging an outside agency and you have no objection to verify your residence/ office at the address given in the proof already submitted to the bank.<br>2. You hereby advised to declare that the particulars furnished are true and correct and you abide by the rules and regulations of the bank in force in respect of such loans and advances.<br>3. You should undertake to inform KVB regarding any change in your occupation/employment and to provide any further information that KVB may require.<br>4. You are hereby advised to agree as a precondition to the loan sanctioned in your name that in case of default in the repayment of the loan or in the servicing of the interest thereon, the Bank and/or the Reserve Bank of India will have unqualified right to disclose or publish your name as defaulter in such manner and through such medium as the Bank and/or the Reserve Bank of India in their absolute discretion may deem fit.<br>5. You have to declare that you have read, understood and acknowledge and agree that KVB may refer your name to credit referencing agency/ies and/or make such references and enquires as the Bank may consider necessary.<br>6. You are hereby advised to authorise the Bank to disclose such information relating to your credit facility to such parties as deemed necessary at the sole discretion of the Bank.<br>7. You are advised to declare that have/had no insolvency proceedings against you nor have ever been adjudicated insolvent.<br>8. You are advised to declare that you abide by all the terms and conditions of the Bank applicable to the above mentioned loan.<br>9. The interest rate provided above is indicative and the actual interest rate will be fixed as per the rate on the date of disbursement.<br>10. You have to undertake insurance coverage for the vehicle to the extend of the loan amount. <br><br>Thanks.<br><br><img src="' + logoUrl + '"/>' + '\t <b>Karur Vysya Bank</b>'+'</body></html>';
                }
                else{
                    emailbody = '<!DOCTYPE html><html lang="en"><head><title>Bootstrap Example</title><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"><script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.0/jquery.min.js"></script><script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script></head><body>'+'Dear ' + title + ' ' + borrowername + ',<br><br> We are glad to inform you that your ' + producttype + '  application has been approved as per the following terms subject to address verification & income verification.<br/>Loan Amount : Rs. '+loanamount+'<br/>Rate of Interest : '+interestrate+'<br/>Tenure of the Loan : '+tenture+'<br/><br/>Terms and conditions: <br/>1. You are hereby advised to authorize the bank to undertake address verification process by engaging an outside agency and you have no objection to verify your residence/ office at the address given in the proof already submitted to the bank.<br>2. You hereby advised to declare that the particulars furnished are true and correct and you abide by the rules and regulations of the bank in force in respect of such loans and advances.<br>3. You should undertake to inform KVB regarding any change in your occupation/employment and to provide any further information that KVB may require.<br>4. You are hereby advised to agree as a precondition to the loan sanctioned in your name that in case of default in the repayment of the loan or in the servicing of the interest thereon, the Bank and/or the Reserve Bank of India will have unqualified right to disclose or publish your name as defaulter in such manner and through such medium as the Bank and/or the Reserve Bank of India in their absolute discretion may deem fit.<br>5. You have to declare that you have read, understood and acknowledge and agree that KVB may refer your name to credit referencing agency/ies and/or make such references and enquires as the Bank may consider necessary.<br>6. You are hereby advised to authorise the Bank to disclose such information relating to your credit facility to such parties as deemed necessary at the sole discretion of the Bank.<br>7. You are advised to declare that have/had no insolvency proceedings against you nor have ever been adjudicated insolvent.<br>8. You are advised to declare that you abide by all the terms and conditions of the Bank applicable to the above mentioned loan.<br>9. The interest rate provided above is a fixed rate.<br>10. You have to undertake insurance coverage for the vehicle to the extend of the loan amount. <br><br>Thanks.<br><br><img src="' + logoUrl + '"/>' + '\t <b>Karur Vysya Bank</b>'+'</body></html>'; 
                }
                // String emailbody = '<!DOCTYPE html><html lang="en"><head><title>Bootstrap Example</title><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"><script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.0/jquery.min.js"></script><script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script></head><body>'+'Dear ' + title + ' ' + borrowername + ',<br><br> We are glad to inform you that your ' + producttype + '  application has been approved as per the following terms subject to address verification & income verification.<br/>Loan Amount : Rs. '+loanamount+'<br/>Rate of Interest : '+interestrate+'<br/>Tenure of the Loan : '+tenture+'<br/><br/>Terms and conditions: <br/>1. You are hereby advised to authorize the bank to undertake address verification process by engaging an outside agency and you have no objection to verify your residence/ office at the address given in the proof already submitted to the bank.<br>2. You hereby advised to declare that the particulars furnished are true and correct and you abide by the rules and regulations of the bank in force in respect of such loans and advances.<br>3. You should undertake to inform KVB regarding any change in your occupation/employment and to provide any further information that KVB may require.<br>4. You are hereby advised to agree as a precondition to the loan sanctioned in your name that in case of default in the repayment of the loan or in the servicing of the interest thereon, the Bank and/or the Reserve Bank of India will have unqualified right to disclose or publish your name as defaulter in such manner and through such medium as the Bank and/or the Reserve Bank of India in their absolute discretion may deem fit.<br>5. You have to declare that you have read, understood and acknowledge and agree that KVB may refer your name to credit referencing agency/ies and/or make such references and enquires as the Bank may consider necessary.<br>6. You are hereby advised to authorise the Bank to disclose such information relating to your credit facility to such parties as deemed necessary at the sole discretion of the Bank.<br>7. You are advised to declare that have/had no insolvency proceedings against you nor have ever been adjudicated insolvent.<br>8. You are advised to declare that you abide by all the terms and conditions of the Bank applicable to the above mentioned loan.<br>9. The interest rate provided above is indicative as it is a floating interest rate linked to MCLR of the Bank. The actual interest rate will be fixed as per the rate on the date of disbursement and will be communicated.<br>10. You have to undertake insurance coverage for the vehicle to the extend of the loan amount. <br><br>Thanks.<br><br><img src="' + logoUrl + '"/>' + '\t <b>Karur Vysya Bank</b>'+'</body></html>';
                String emailsubj = 'KVB  ' + producttype + '  sanction communication';
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
                        messageAck = 'Dear <<Title>>.<<borrower name>>, congratulations your <<product type>> application (<<application no.>>)  has been sanctioned for Rs. <<Limit amt.>> @ <<interest rate>> per annum. In case of any changes to the interest rate, you will be informed at the time of disbursment. The sanction letter will be sent to your email id. (<<email id of borrower>>).';
                        
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
                        
                        String emailbody1 ='';
                        if(application.Record_Type_Name__c==Constants.VL4W){
                            emailbody1 = '<!DOCTYPE html><html lang="en"><head><title>Bootstrap Example</title><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"><script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.0/jquery.min.js"></script><script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script></head><body>'+'Dear ' + title + ' ' + borrowername + ',<br><br> We are glad to inform you that your ' + producttype + '  application has been approved as per the following terms subject to address verification & income verification.<br/>Loan Amount : Rs. '+loanamount+'<br/>Rate of Interest : '+interestrate+'<br/>Tenure of the Loan : '+tenture+'<br/><br/>Terms and conditions: <br/>1. You are hereby advised to authorize the bank to undertake address verification process by engaging an outside agency and you have no objection to verify your residence/ office at the address given in the proof already submitted to the bank.<br>2. You hereby advised to declare that the particulars furnished are true and correct and you abide by the rules and regulations of the bank in force in respect of such loans and advances.<br>3. You should undertake to inform KVB regarding any change in your occupation/employment and to provide any further information that KVB may require.<br>4. You are hereby advised to agree as a precondition to the loan sanctioned in your name that in case of default in the repayment of the loan or in the servicing of the interest thereon, the Bank and/or the Reserve Bank of India will have unqualified right to disclose or publish your name as defaulter in such manner and through such medium as the Bank and/or the Reserve Bank of India in their absolute discretion may deem fit.<br>5. You have to declare that you have read, understood and acknowledge and agree that KVB may refer your name to credit referencing agency/ies and/or make such references and enquires as the Bank may consider necessary.<br>6. You are hereby advised to authorise the Bank to disclose such information relating to your credit facility to such parties as deemed necessary at the sole discretion of the Bank.<br>7. You are advised to declare that have/had no insolvency proceedings against you nor have ever been adjudicated insolvent.<br>8. You are advised to declare that you abide by all the terms and conditions of the Bank applicable to the above mentioned loan.<br>9. The interest rate provided above is indicative and the actual interest rate will be fixed as per the rate on the date of disbursement.<br>10. You have to undertake insurance coverage for the vehicle to the extend of the loan amount. <br><br>Thanks.<br><br><img src="' + logoUrl + '"/>' + '\t <b>Karur Vysya Bank</b>'+'</body></html>';
                        }
                        else{
                            emailbody1 = '<!DOCTYPE html><html lang="en"><head><title>Bootstrap Example</title><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"><script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.0/jquery.min.js"></script><script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script></head><body>'+'Dear ' + title + ' ' + borrowername + ',<br><br> We are glad to inform you that your ' + producttype + '  application has been approved as per the following terms subject to address verification & income verification.<br/>Loan Amount : Rs. '+loanamount+'<br/>Rate of Interest : '+interestrate+'<br/>Tenure of the Loan : '+tenture+'<br/><br/>Terms and conditions: <br/>1. You are hereby advised to authorize the bank to undertake address verification process by engaging an outside agency and you have no objection to verify your residence/ office at the address given in the proof already submitted to the bank.<br>2. You hereby advised to declare that the particulars furnished are true and correct and you abide by the rules and regulations of the bank in force in respect of such loans and advances.<br>3. You should undertake to inform KVB regarding any change in your occupation/employment and to provide any further information that KVB may require.<br>4. You are hereby advised to agree as a precondition to the loan sanctioned in your name that in case of default in the repayment of the loan or in the servicing of the interest thereon, the Bank and/or the Reserve Bank of India will have unqualified right to disclose or publish your name as defaulter in such manner and through such medium as the Bank and/or the Reserve Bank of India in their absolute discretion may deem fit.<br>5. You have to declare that you have read, understood and acknowledge and agree that KVB may refer your name to credit referencing agency/ies and/or make such references and enquires as the Bank may consider necessary.<br>6. You are hereby advised to authorise the Bank to disclose such information relating to your credit facility to such parties as deemed necessary at the sole discretion of the Bank.<br>7. You are advised to declare that have/had no insolvency proceedings against you nor have ever been adjudicated insolvent.<br>8. You are advised to declare that you abide by all the terms and conditions of the Bank applicable to the above mentioned loan.<br>9. The interest rate provided above is a fixed rate.<br>10. You have to undertake insurance coverage for the vehicle to the extend of the loan amount. <br><br>Thanks.<br><br><img src="' + logoUrl + '"/>' + '\t <b>Karur Vysya Bank</b>'+'</body></html>'; 
                        }
                        
                        //  String emailbody1 = '<!DOCTYPE html><html lang="en"><head><title>Bootstrap Example</title><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"><script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.0/jquery.min.js"></script><script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script></head><body>'+'Dear ' + title + ' ' + cust + ',<br><br> We are glad to inform you that your ' + producttype + '  application has been approved as per the following terms subject to address verification & income verification.<br/>Loan Amount : Rs. '+loanamount+'<br/>Rate of Interest : '+interestrate+'<br/>Tenure of the Loan : '+tenture+'<br/><br/>Terms and conditions: <br/>1. You are hereby advised to authorize the bank to undertake address verification process by engaging an outside agency and you have no objection to verify your residence/ office at the address given in the proof already submitted to the bank.<br>2. You hereby advised to declare that the particulars furnished are true and correct and you abide by the rules and regulations of the bank in force in respect of such loans and advances.<br>3. You should undertake to inform KVB regarding any change in your occupation/employment and to provide any further information that KVB may require.<br>4. You are hereby advised to agree as a precondition to the loan sanctioned in your name that in case of default in the repayment of the loan or in the servicing of the interest thereon, the Bank and/or the Reserve Bank of India will have unqualified right to disclose or publish your name as defaulter in such manner and through such medium as the Bank and/or the Reserve Bank of India in their absolute discretion may deem fit.<br>5. You have to declare that you have read, understood and acknowledge and agree that KVB may refer your name to credit referencing agency/ies and/or make such references and enquires as the Bank may consider necessary.<br>6. You are hereby advised to authorise the Bank to disclose such information relating to your credit facility to such parties as deemed necessary at the sole discretion of the Bank.<br>7. You are advised to declare that have/had no insolvency proceedings against you nor have ever been adjudicated insolvent.<br>8. You are advised to declare that you abide by all the terms and conditions of the Bank applicable to the above mentioned loan.<br>9. The interest rate provided above is indicative as it is a floating interest rate linked to MCLR of the Bank. The actual interest rate will be fixed as per the rate on the date of disbursement and will be communicated.<br>10. You have to undertake insurance coverage for the vehicle to the extend of the loan amount. <br><br>Thanks.<br><br><img src="' + logoUrl + '"/>' + '\t <b>Karur Vysya Bank</b>'+'</body></html>';
                        
                        if (partyemail != null) {
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
            ///////end ntsp
            //////SI details captured
            if (application.Sub_Stage__c == 'SI details captured') {
                
                System.debug('*inside sendSMSSubstage --app.Sub_Stage__c==');
                messageAck = 'Dear <<Title>>.<<borrower name>>, per your instructions for <<product type>>, automated deductions of monthly EMIs will be set up for the <<SI account number>> with <<SI Bank name>>';
                String SI_account_number=String.ValueOf(application.SI_Account_Number__c);
                String SI_Bank_name=application.SI_Bank_Name__c;            
                if (title == null) {
                    title = '-';
                }
                if(SI_account_number==null){
                    SI_account_number='0';
                }
                if(SI_Bank_name==null){
                    SI_Bank_name='-';
                }
                System.debug('salutation' + title);
                
                messageAck = messageAck.replace('<<product type>>', producttype);
                messageAck = messageAck.replace('<<borrower name>>', borrowername);
                messageAck = messageAck.replace('<<SI account number>>', SI_account_number);
                messageAck = messageAck.replace('<<SI Bank name>>', SI_Bank_name);
                messageAck = messageAck.replace('<<Title>>', title);
                system.debug('MobileNo###' + application.Primary_Applicant_Mobile__c);
                system.debug('@@@' + mobileNo + '$$$' + messageAck);
                
                String logoUrl = getDocumentLogoUrl();
                
                String emailbody = 'Dear ' + title + ' ' + borrowername + ',<br><br> As per your instructions for ' + producttype + ' automated deductions of monthly EMIs will be set up for the '+SI_account_number+' with '+SI_Bank_name+'.<br><br>Thanks.<br><br><img src="' + logoUrl + '"/>' + '\t <b>Karur Vysya Bank</b>';
                String emailsubj = 'KVB '+producttype+' recurring Mandate details';
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
            ///end si details
            //start -Disbursement Documents
            if (application.Sub_Stage__c == 'Disbursement Documents Esigned') {
                
                System.debug('*inside Disbursement Documents Esigned --- - vl ');
                
                if (title == null) {
                    title = '-';
                }
                
                //// for email e-documents
                //
                String logoUrl = getDocumentLogoUrl();
                String emailbody = 'Dear ' + title + ' ' + borrowername + ',<br><br> please find attached the copy of your ' + producttype + ' agreement and other related documents. <br><br>Thanks.<br><br><img src="' + logoUrl + '"/>' + '\t <b>Karur Vysya Bank</b>';
                String emailsubj = 'KVB '+producttype+' related documents';
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
                        /*   List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
for(Attachment a: [select Name, Body, BodyLength from Attachment where ParentId =:app1.id  AND (Name =: Constants.Acknowledgement_For_SanctionLAP+'.pdf' OR Name LIKE 'LAP_B1%' OR NAME =: Constants.LAP_A23+'.pdf' OR NAME =: Constants.LAP_A46+'.pdf')])
{
// Add to attachment file list
Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
efa.setFileName(a.Name);
efa.setBody(a.Body);
fileAttachments.add(efa);
system.debug('##### Name '+ a.Name + ' ' +app1.id);
} */  
                        if (partyemail != null) {
                            LAP_EmailHandaller.LAP_Email(partyemail, emailbody1, emailsubj);
                            // LAP_EmailHandaller.PLEmail(email, emailbody, emailsubj,fileAttachments);
                        }
                        
                    }
                }
                
            }
            //end Disbursement Documents
            //Loan Account opened
            
            if (application.Sub_Stage__c == 'Loan account opened') {
                
                System.debug('*inside sendSMSSubstage ---Loan account opened ');
                List<clcommon__Collateral__c> collist=queryService.getCollateral(application.id);   
                System.debug('collist'+collist);   
                messageAck = 'Dear <<Title>>.<<borrower name>>, congratulations your <<product type>> account has been opened with a/c no.(<<loan account no.>>) and loan amount has been credited to <<dealer name>>';
                String loanacountno = application.Loan_Account_Number__c;
                String dealername=collist[0].Dealer_name__c;
                
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
                messageAck = messageAck.replace('<<dealer name>>', dealername);    
                
                system.debug('MobileNo###' + application.Primary_Applicant_Mobile__c);
                system.debug('@@@' + mobileNo + '$$$' + messageAck);
                
                String logoUrl = getDocumentLogoUrl();
                // String logoUrl='m';
                
                String emailbody='Dear' +title+'. '+borrowername+',<br><br> congratulations your '+producttype+' account has been opened with a/c no.('+loanacountno+') and loan amount has been credited to '+dealername+'.<br><br>Thanks.<br><br><img src="' + logoUrl + '"/>' + '\t <b>Karur Vysya Bank</b>';
                
                String emailsubj = 'KVB '+producttype+' account details';
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
                    List<clcommon__Collateral__c> collist1=queryService.getCollateral(application.id);   
                    String dealername1=collist1[0].Dealer_name__c;
                    for (genesis__Application_Parties__c pt: ptList) {
                        messageAck = 'Dear <<Title>>.<<borrower name>>, congratulations your <<product type>> account has been opened with a/c no.(<<loan account no.>>) and loan amount has been credited to <<dealer name>>';
                        
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
                        messageAck = messageAck.replace('<<dealer name>>', dealername1); 
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
                        
                        // String logoUrl2='m';
                        String emailbody2='Dear' +title+'. '+cust+',<br><br> congratulations your '+producttype+' account has been opened with a/c no.('+loanacountno+') and loan amount has been credited to '+dealername+'.<br><br>Thanks.<br><br><img src="' + logoUrl + '"/>' + '\t <b>Karur Vysya Bank</b>';
                        
                        String emailsubj2 = 'KVB '+producttype+' account details';
                        if (partyemail != null) {
                            LAP_EmailHandaller.LAP_Email(partyemail, emailbody2, emailsubj2);
                            
                        }
                        
                    }
                }//party end
                
                if (collist.size() > 0) {
                    for (clcommon__Collateral__c pt: collist) {
                        System.debug('pt'+pt);
                        messageAck = 'Dear .<<dealer name>>, as per <<applicant\'s name>> instructions, disbursement for <<product type>> for Make-<<Make>>,Model-<<Model>>,Varient-<<Varient>> has been made to your account number <<disbursement account number>>.';
                        
                        String DelerName = pt.Dealer_name__c;
                        
                        string Delermail = pt.Dealer_Email__c;
                        mobileNo=pt.Dealer_Phone_Number__c;
                        String make=pt.clcommon__Manufacturer__c;
                        String model=pt.clcommon__Model__c;
                        String varient=pt.Variant__c;
                        String disno=application.Disbursement_Account_Number__c;
                        if(disno==null){
                            disno='0';
                        }
                        
                        messageAck = messageAck.replace('<<product type>>', producttype);
                        messageAck = messageAck.replace('<<dealer name>>', DelerName);
                        messageAck = messageAck.replace('<<disbursement account number>>', disno);
                        messageAck = messageAck.replace('<<applicant\'s name>>', borrowername);
                        messageAck = messageAck.replace('<<Make>>', make);
                        messageAck = messageAck.replace('<<Model>>', model);
                        messageAck = messageAck.replace('<<Varient>>', varient);


                        if (mobileNo.length() == 12) {
                        SMS_Services.sendSMSFutureCall(mobileNo, messageAck);
                        } else if (mobileNo.length() == 10) {
                        mobileNo = '91' + mobileNo;
                        SMS_Services.sendSMSFutureCall(mobileNo, messageAck);
                        } else {
                        System.debug('Mobile No Not Valid');
                        }
                        system.debug('@@@' + mobileNo + '$$$' + messageAck);

                        String emailbody2='Dear .'+dealername+',<br><br> as per '+Customername+' instructions, disbursement for '+producttype+' for '+make+' has been made to your account number '+disno+'..<br><br>Thanks.<br><br><img src="' + logoUrl + '"/>' + '\t <b>Karur Vysya Bank</b>';
                        String emailsubj2 = 'KVB '+producttype+' disbursement';
                        if (Delermail != null) {
                        LAP_EmailHandaller.LAP_Email(Delermail, emailbody2, emailsubj2);
                        }
                    }
                }//col end
                
                
                //SI Bank Name != Karur Vysya Bank
                if(application.SI_Bank_Name__c!='Karur Vysya Bank'){
                    genesis__Applications__c app2 = [select id, genesis__Account__r.salutation,Branch_Name__c from genesis__Applications__c where id =: application.id];
                    
                    user u=[select name,Phone,Email,Role_Name__c,Branch_Name__c from user where Branch_Name__c=:app2.Branch_Name__c AND Role_Name__c=:'Branch manager'];
                    System.debug('app1' + app2);
                    System.debug('user**'+u);
                    String uname=u.name;
                    messageAck = '<<product type>> application with application no., customer has chosen to set up an E-mandate through e-nach. Please complete formalities with the customer and update UMRN in LOS';
                    email = u.email;
                    messageAck = messageAck.replace('<<product type>>', producttype);
                    mobileNo = u.Phone;
                    system.debug('MobileNo###' + application.Primary_Applicant_Mobile__c);
                    system.debug('@@@' + mobileNo + '$$$' + messageAck);
                    //  String logoUrl = getDocumentLogoUrl();
                    
                    String emailbody3 ='Dear ' + title + ' ' + uname + ',<br><br>' + producttype + 'application with application no.'+applicationno+', customer has chosen to set up an E-mandate through e-nach. Please complete formalities with the customer and update UMRN in LOS.<br><br>Thanks.<br><br><img src="' + logoUrl + '"/>' + '\t <b>Karur Vysya Bank</b>';
                    String emailsubj3 = producttype+' E-Mandate Set Up';
                    if (email != null) {
                        LAP_EmailHandaller.LAP_Email(email, emailbody3, emailsubj3);
                        
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
            
            //Loan Account closed--end
            
            if (application.Sub_Stage__c == 'Low CIBIL Score' || application.Sub_Stage__c =='Age Ineligible' || application.Sub_Stage__c =='FI Rejected' || application.Sub_Stage__c =='Rejected by branch manager' || application.Sub_Stage__c =='Income assessment rejected' || application.Sub_Stage__c =='Income Rejected' || application.Sub_Stage__c =='Low Application Score') {
                
                System.debug('*Rejected Applications');
                
                genesis__Applications__c app2 = [select id, genesis__Account__r.salutation,Branch_Name__c from genesis__Applications__c where id =: application.id];
                
                //  List<User> u=queryService.getUserDetails(application.Branch_Name__c);
                user u=[select name,Phone,Email,Role_Name__c,Branch_Name__c from user where Branch_Name__c=:app2.Branch_Name__c AND Role_Name__c=:'Branch manager'];
                borrowername=u.name;
                System.debug('app1' + app2);
                System.debug('user**'+u);
                
                messageAck = '<<product type>> application with application no. <<application no.>> has been rejected. Kindly review and communicate with customer.';
                
                email = u.email;
                messageAck = messageAck.replace('<<application no.>>', applicationno);
                messageAck = messageAck.replace('<<product type>>', producttype);
                mobileNo = u.Phone;
                system.debug('MobileNo###' + application.Primary_Applicant_Mobile__c);
                system.debug('@@@' + mobileNo + '$$$' + messageAck);
                String logoUrl = getDocumentLogoUrl();
                
                
                String emailbody = 'Dear ' + title + ' ' + borrowername + ',<br><br>' + producttype +'application with application no.  ' + applicationno + ' has been rejected. Kindly review and communicate with customer.<br><br>Thanks.<br><br><img src="' + logoUrl + '"/>' + '\t <b>Karur Vysya Bank</b>';
                String emailsubj =producttype+' Application Rejection';
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
            
            //rejected app
        }
        catch(Exception e){
            System.debug('Exception'+e);
            System.debug('line'+e.getLineNumber()+''+e.getMessage());
            
        }
    }
    
    
    
}