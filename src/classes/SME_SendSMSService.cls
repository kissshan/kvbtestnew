/*
* Name      : SME_SendSMSService
* Compnay   : ET Marlabs
* Purpose   : For SMS Service and Email. 
* Author    : Raushan
*/
public class SME_SendSMSService {

    public static void sendSMSApp_SME(Set<String> applnIds){
        try{
            String endUrl           = KVB_Company_Details__c.getOrgDefaults().FE_Portal_Url__c;
            String support_Contact  = KVB_Company_Details__c.getOrgDefaults().KVB_Support_Contact__c;
            System.debug('applnIds::'+applnIds);
            List<genesis__Applications__c> listapplication = [select id,genesis__Total_Upfront_Payments__c,Sanction_Authority__c,genesis__Account__r.Priority_Sector__c ,CreatedDate,Recordtype.DeveloperName,Name,OwnerId,Owner.Phone,Owner.Email,genesis__Account__r.Name,Recordtype.Name,genesis__Account__r.Cust_mobile_phone__c,Renewal_Due_Date__c,Application_Stage__c,Sub_Stage__c,Application_UI_Stage__c,Type__c,Next_Renewal_Date__c,Application_to_close__c,genesis__Account__r.Company_Email__c,Branch_Name__c,Owner.Name,genesis__Account__r.Perfios_error_message__c,(select id,Name,Type__c,Recommended_Rate__c,Sanction_Limit__c,Recommended_Processing_Charge__c,Margin__c,MCLR_Rate__c,Interest_Rate__c,Product_Name__c,Recommended_Limit__c,Existing_Limit__c from Facilities__r) from genesis__Applications__c where id IN :applnIds];
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            If(listapplication !=null && listapplication.size() >0){
                System.debug('listapplication'+listapplication);
                for(genesis__Applications__c appObj : listapplication){
                    System.debug(appObj.Application_Stage__c);
                    String branchMngrName= appObj.Owner.Name;
                    String mngrPhone    = appObj.Owner.Phone;
                    String mngremail    = appObj.Owner.Email;
                    String customerName = appObj.genesis__Account__r.Name;
                    String mobileNumber = appObj.genesis__Account__r.Cust_mobile_phone__c;
                    String email_id     = appObj.genesis__Account__r.Company_Email__c;
                    //List<User> usr= [select id,MobilePhone,Name from User where id=: appObj.OwnerId];
                    if(appObj.Application_Stage__c =='Identified for renewal'){
                        String messageAck ='Dear << Customer Name >>, your working capital loan with KVB is due for renewal on <<Due date>>. Please keep the information ready for online processing. Please reach out to your branch manager in case of any clarification.';
                        String DueDate      = String.valueOf(appObj.Renewal_Due_Date__c); 
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        messageAck = messageAck.replace('<<Due date>>',DueDate);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }
                        String emailMessage = SME_Email_Handler.getRenewalDueTemplates(appObj);
                        
                        emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage));

                        //For Branch Manager
                        String messageAckmngr='Dear << Branch Manager >>, <<Customer Name>>\'s working capital loan is due for renewal on <<Due date>>. Please complete the pre-renewal checklist and initiate the renewal process.';
                        messageAckmngr =messageAckmngr.replace('<< Branch Manager >>', branchMngrName);
                        messageAckmngr = messageAckmngr.replace('<< Customer Name >>',customerName+'\'s');
                        messageAckmngr = messageAckmngr.replace('<<Due date>>',DueDate);
                        If(mngrPhone.length() == 12){
                             SMS_Services.sendSMSFutureCall(mngrPhone,messageAckmngr);    
                        }else if(mngrPhone.length() == 10){
                            mngrPhone    = '91'+mngrPhone;
                            SMS_Services.sendSMSFutureCall(mngrPhone,messageAckmngr);
                        }
                        String branchmngrmessage=SME_Email_Handler.getRenewalDueTemplatesBM(appObj);

                        emails.add(SME_Email_Handler.getEmailTemplates(mngremail,branchmngrmessage));

                    }
                    else if(appObj.Application_Stage__c =='Application filling initiated'){
                        String messageAck = 'Dear << Customer Name >>, your working capital loan with KVB is due for renewal on <<Due date>>. Click here '+endUrl+' to renew your working capital loan online.';
                        String DueDate  = String.valueOf(appObj.Renewal_Due_Date__c);
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        messageAck = messageAck.replace('<<Due date>>',DueDate);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }
                        String emailMessage = SME_Email_Handler.getRenewalApplicationSubmissionPending(appObj);
                        emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage));
                    }
                    else if((appObj.Application_Stage__c =='Application Filling - Final' || appObj.Application_Stage__c == 'Interim Sanction') && appObj.Recordtype.DeveloperName==Constants.SME_Renewal){
                        String messageAck = 'Dear << Customer Name >>,  Your working capital loan with Karur Vyasa Bank is due for renewal on <<Due date>>. Click here '+endUrl+' to submit your renewal application online.';
                        String DueDate  = String.valueOf(appObj.Renewal_Due_Date__c);
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        messageAck = messageAck.replace('<<Due date>>',DueDate);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }
                    }
                    else if(appObj.Recordtype.DeveloperName==Constants.SME_Renewal && appObj.Application_Stage__c=='Final Sanction'){
                        String messageAck = 'Dear << Customer Name >>,  Congratulations!!!. Your working capital loan renewal application has been sanctioned. You can login here '+endUrl+'to view the sanction terms.';
                        String DueDate  = String.valueOf(appObj.Renewal_Due_Date__c);
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }
                        String emailMessage = SME_Email_Handler.getRenewalFinalSanctionTemplate(appObj);
                        System.debug('emailMessage==='+emailMessage);
                        emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage));
                    }
                    else if(appObj.Recordtype.DeveloperName==Constants.SME_Renewal && appObj.Application_Stage__c=='Perfios error'){
                        String messageAck = 'Dear << Branch Manager >>, <<Customer Name>>\'s working capital loan is due for renewal on <<Due date>>. There was an error in processing financial statements submitted by the customer. Please re-upload the appropriate financials in the LOS platform';
                        messageAck =messageAck.replace('<< Branch Manager >>', branchMngrName);
                        String DueDate  = String.valueOf(appObj.Renewal_Due_Date__c);
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }
                    }
                    else if(appObj.Recordtype.DeveloperName==Constants.SME_Renewal && (appObj.Application_Stage__c=='Limit renewed/Application close') || appObj.Application_Stage__c=='Limit extended'){
                        String messageAck ='Dear << Customer Name >>,  your working capital limits have been renewed. Your next renewal will be due on <<next due date>>';
                        String DueDate      = String.valueOf(appObj.Next_Renewal_Date__c); 
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        messageAck = messageAck.replace('<<Due date>>',DueDate);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }
                        String emailMessage = SME_Email_Handler.getAfterRenewalTemplatesCust(appObj);
                        
                        emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage));

                        //For Branch Manager
                        String messageAckmngr='Dear << Branch Manager>>,  <<Customer Name >>\'s  working capital renewal is completed and next renewal will be due on <<next due date>>';
                        messageAckmngr =messageAckmngr.replace('<< Branch Manager >>', branchMngrName);
                        String nextRenewalDate=String.valueOf(appObj.Next_Renewal_Date__c);
                        messageAckmngr = messageAckmngr.replace('<< Customer Name >>',customerName+'\'s');
                        messageAckmngr = messageAckmngr.replace('<<Due date>>',nextRenewalDate);
                        If(mngrPhone.length() == 12){
                             SMS_Services.sendSMSFutureCall(mngrPhone,messageAckmngr);    
                        }else if(mngrPhone.length() == 10){
                            mngrPhone    = '91'+mngrPhone;
                            SMS_Services.sendSMSFutureCall(mngrPhone,messageAckmngr);
                        }
                        String branchmngrmessage=SME_Email_Handler.getAfterRenewalTemplatesBM(appObj);

                        emails.add(SME_Email_Handler.getEmailTemplates(mngremail,branchmngrmessage));

                    }
                    else if((appObj.Recordtype.DeveloperName==Constants.SME_APP_RECORD_TYPE_EXCEEDING || appObj.Recordtype.DeveloperName==Constants.SME_APP_RECORD_TYPE_ADHOC || appObj.Recordtype.DeveloperName==Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || appObj.Recordtype.DeveloperName==Constants.SME_NEW_LOAN_RECORD_TYPE) && (appObj.Application_Stage__c.contains('Application created'))){
                        System.debug('new loan application');
                        String messageAck ='Dear << Customer Name >>, Thank you for starting your <<record type>>  application. Your application number is <<app no>>. Please use this for all future references.';
                        String DueDate      = String.valueOf(appObj.Next_Renewal_Date__c); 
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        messageAck = messageAck.replace('<<record type>>',appObj.Recordtype.Name);
                        messageAck = messageAck.replace('<<app no>>',appObj.name);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }
                        String emailMessage = SME_Email_Handler.getEAENLCreationTemplateCust(appObj);
                        
                        emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage));

                        //For Branch Manager
                        String messageAckmngr='Dear <<Branch Manager>>, '+appObj.Name+' has been created for <<customer Name>> for <<record type>>. Please follow up with the customer to assist completion of the application.';
                        messageAckmngr =messageAckmngr.replace('<<Branch Manager>>', branchMngrName);
                        messageAckmngr = messageAckmngr.replace('<<customer Name>>',customerName);
                        messageAckmngr = messageAckmngr.replace('<<record type>>',appObj.Recordtype.Name);
                        If(mngrPhone.length() == 12){
                             SMS_Services.sendSMSFutureCall(mngrPhone,messageAckmngr);    
                        }else if(mngrPhone.length() == 10){
                            mngrPhone    = '91'+mngrPhone;
                            SMS_Services.sendSMSFutureCall(mngrPhone,messageAckmngr);
                        }
                        String branchmngrmessage=SME_Email_Handler.getEAENLCreationTemplateBM(appObj);

                        emails.add(SME_Email_Handler.getEmailTemplates(mngremail,branchmngrmessage));

                    }
                    else if((appObj.Recordtype.DeveloperName==Constants.SME_APP_RECORD_TYPE_EXCEEDING || appObj.Recordtype.DeveloperName==Constants.SME_APP_RECORD_TYPE_ADHOC || appObj.Recordtype.DeveloperName==Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || appObj.Recordtype.DeveloperName==Constants.SME_NEW_LOAN_RECORD_TYPE) && (appObj.Application_Stage__c.contains('Application submitted'))){
                        String messageAck ='Dear << Customer Name >>, Thank you for submitting your <<record type>> application with reference number <<app no>>. Please use this for all future references. Our branch team will reach out to you for the next steps.';
                        String DueDate      = String.valueOf(appObj.Next_Renewal_Date__c); 
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        messageAck = messageAck.replace('<<record type>>',appObj.Recordtype.Name);
                        messageAck = messageAck.replace('<<app no>>',appObj.name);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }
                        String emailMessage = SME_Email_Handler.getEAENLSubmitTemplateCust(appObj);
                        
                        emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage));

                        //For Branch Manager
                        String messageAckmngr='Dear << Branch Manager>>, '+appObj.Name+'has been submitted by the << Customer Name >> for <<record type>>. Please initiate application processing.';
                        messageAckmngr =messageAckmngr.replace('<< Branch Manager>>', branchMngrName);
                        messageAckmngr = messageAckmngr.replace('<< Customer Name >>',customerName);
                        messageAckmngr = messageAckmngr.replace('<<record type>>',appObj.Recordtype.Name);
                        If(mngrPhone.length() == 12){
                             SMS_Services.sendSMSFutureCall(mngrPhone,messageAckmngr);    
                        }else if(mngrPhone.length() == 10){
                            mngrPhone    = '91'+mngrPhone;
                            SMS_Services.sendSMSFutureCall(mngrPhone,messageAckmngr);
                        }
                        String branchmngrmessage=SME_Email_Handler.getEAENLSubmitTemplateBM(appObj);

                        emails.add(SME_Email_Handler.getEmailTemplates(mngremail,branchmngrmessage));
                    }
                    else if((appObj.Recordtype.DeveloperName==Constants.SME_APP_RECORD_TYPE_ENHANCEMENT && appObj.Application_Stage__c=='Enhancement- Final sanction') || (appObj.Recordtype.DeveloperName==Constants.SME_NEW_LOAN_RECORD_TYPE && appObj.Application_Stage__c=='New loan - Final sanction')){
                        
                        if(appObj.Recordtype.DeveloperName==Constants.SME_APP_RECORD_TYPE_ENHANCEMENT){
                            String messageAck ='Dear << Customer Name >>,</br> Congratulations!!!. We are happy to provide an in-principle sanction for your  <<record type>> application with <<app no>>. This sanction is subject to satisfactory completion of collateral verification.';
                            String DueDate      = String.valueOf(appObj.Next_Renewal_Date__c); 
                            messageAck = messageAck.replace('<< Customer Name >>',customerName);
                            messageAck = messageAck.replace('<<record type>>',appObj.Recordtype.Name);
                            messageAck = messageAck.replace('<<app no>>',appObj.name);
                            If(mobileNumber.length() == 12){
                                 SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                            }else if(mobileNumber.length() == 10){
                                mobileNumber    = '91'+mobileNumber;
                                SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                            }
                        }
                        if(appObj.Recordtype.DeveloperName==Constants.SME_NEW_LOAN_RECORD_TYPE){
                            String messageAck ='Dear << Customer Name >>,</br> Congratulations!!!. We are happy to provide an in-principle sanction for your  <<record type>> application with <<app no>>. This sanction is subject to satisfactory completion of collateral verification. You can login here '+endUrl+' to view the sanction terms.';
                            String DueDate      = String.valueOf(appObj.Next_Renewal_Date__c); 
                            messageAck = messageAck.replace('<< Customer Name >>',customerName);
                            messageAck = messageAck.replace('<<record type>>',appObj.Recordtype.Name);
                            messageAck = messageAck.replace('<<app no>>',appObj.name);
                            If(mobileNumber.length() == 12){
                                 SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                            }else if(mobileNumber.length() == 10){
                                mobileNumber    = '91'+mobileNumber;
                                SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                            }
                        }
                    }
                    else if((appObj.Recordtype.DeveloperName==Constants.SME_APP_RECORD_TYPE_EXCEEDING || appObj.Recordtype.DeveloperName==Constants.SME_APP_RECORD_TYPE_ADHOC || appObj.Recordtype.DeveloperName==Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || appObj.Recordtype.DeveloperName==Constants.SME_NEW_LOAN_RECORD_TYPE) && (appObj.Application_Stage__c.contains('Final sanction Offered'))){
                        String messageAck ='Dear << Customer Name >>,</br> Congratulations!!!. We are happy to sanction for your <<record type>> application with <<app no>>. Our branch team will get in touch with you to complete the disbursement formalities.';
                        String DueDate      = String.valueOf(appObj.Next_Renewal_Date__c); 
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        messageAck = messageAck.replace('<<record type>>',appObj.Recordtype.Name);
                        messageAck = messageAck.replace('<<app no>>',appObj.name);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }
                        String emailMessage = SME_Email_Handler.getEAENLFinalSanctionTemplateCust(appObj);
                        
                        emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage));
                    }
                    else if((appObj.Recordtype.DeveloperName==Constants.SME_APP_RECORD_TYPE_EXCEEDING || appObj.Recordtype.DeveloperName==Constants.SME_APP_RECORD_TYPE_ADHOC || appObj.Recordtype.DeveloperName==Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || appObj.Recordtype.DeveloperName==Constants.SME_NEW_LOAN_RECORD_TYPE) && (appObj.Application_Stage__c.contains('Declined by customer'))){
                        String messageAck ='Dear << Branch Manager>>,</br> <<Customer Name>>  has withdrawn  <<record type>> request.The application number is <<app no>>. Please contact the customer soon regarding the decline request.';
                        String DueDate      = String.valueOf(appObj.Next_Renewal_Date__c); 
                        messageAck = messageAck.replace('<< Branch Manager>>',branchMngrName);
                        messageAck = messageAck.replace('<<Customer Name>>',customerName);
                        messageAck = messageAck.replace('<<record type>>',appObj.Recordtype.Name);
                        messageAck = messageAck.replace('<<app no>>',appObj.name);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }
                        String emailMessage = SME_Email_Handler.getEAENLFinalSanctionTemplateCust(appObj);
                        
                        emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage));
                    }
                    else if((appObj.Recordtype.DeveloperName==Constants.SME_APP_RECORD_TYPE_EXCEEDING || appObj.Recordtype.DeveloperName==Constants.SME_APP_RECORD_TYPE_ADHOC || appObj.Recordtype.DeveloperName==Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || appObj.Recordtype.DeveloperName==Constants.SME_NEW_LOAN_RECORD_TYPE) && (appObj.Application_Stage__c.contains('Application Rejected'))){
                        String messageAck ='Dear << Customer Name >>, This is with reference to your << record type >>  application << app no >>. We regret to inform you that the we are unable to sanction your request as per our bank policies. In case of any clarifications, kindly contact our branch manager of <<branch name>>';
                        String DueDate      = String.valueOf(appObj.Next_Renewal_Date__c); 
                        messageAck = messageAck.replace('<< Branch Manager>>',branchMngrName);
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        messageAck = messageAck.replace('<< record type >>',appObj.Recordtype.Name);
                        messageAck = messageAck.replace('<<app no >>',appObj.name);
                        messageAck = messageAck.replace('<<branch name>>',appObj.Branch_Name__c);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }
                        String emailMessage = SME_Email_Handler.getEAENLRejectTemplateCust(appObj);
                        
                        emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage));
                    }
                    else if((appObj.Recordtype.DeveloperName==Constants.SME_APP_RECORD_TYPE_EXCEEDING || appObj.Recordtype.DeveloperName==Constants.SME_APP_RECORD_TYPE_ADHOC || appObj.Recordtype.DeveloperName==Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || appObj.Recordtype.DeveloperName==Constants.SME_NEW_LOAN_RECORD_TYPE) && (appObj.Application_Stage__c.contains('Limit Opened'))){
                        String messageAck ='Dear <<Customer Name>>, we have set up the limits approved as per <<app no >>.';
                        String DueDate      = String.valueOf(appObj.Next_Renewal_Date__c); 
                        //messageAck = messageAck.replace('<< Branch Manager>>',branchMngrName);
                        messageAck = messageAck.replace('<<Customer Name>>',customerName);
                        //messageAck = messageAck.replace('<< record type >>',appObj.Recordtype.Name);
                        messageAck = messageAck.replace('<<app no >>',appObj.name);
                        //messageAck = messageAck.replace('<<branch name>>',appObj.Branch_Name__c);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }
                        String emailMessage = SME_Email_Handler.getEAENLLimitOpenedTemplateCust(appObj);
                        
                        emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage));
                    }
                    else if(appObj.Application_Stage__c =='Perfios error' && appObj.Sub_Stage__c =='Re-upload bank statements' && appObj.Recordtype.Name==Constants.SME_APP_RECORD_TYPE){
                        String messageAck = 'Dear '+appObj.Owner.Name+', '+customerName+'\'s working capital loan is due for renewal on '+appObj.Renewal_Due_Date__c+'. There was an error in processing financial statements submitted by the customer. Please re-upload the appropriate financials in the LOS platform.';
                        String ApplicationNo    = appObj.Name;
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        messageAck = messageAck.replace('<< app no >>',ApplicationNo);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mngrPhone,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mngrPhone,messageAck);
                        }
                        
                        //String emailMessage = SME_Email_Handler.getNewApplicationPerfiosError(appObj);
                        //emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage));
                    }
                    else if((appObj.Recordtype.DeveloperName==Constants.SME_APP_RECORD_TYPE_EXCEEDING || appObj.Recordtype.DeveloperName==Constants.SME_APP_RECORD_TYPE_ADHOC || appObj.Recordtype.DeveloperName==Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || appObj.Recordtype.DeveloperName==Constants.SME_NEW_LOAN_RECORD_TYPE) && appObj.Application_Stage__c =='Perfios error' && appObj.Sub_Stage__c =='Re-upload financials'){
                        String messageAck = 'Dear '+appObj.Owner.Name+', for '+customerName+'\'s application '+appObj.Name+'. Please collect and re-upload the customers bank statement.';
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        String DueDate  = String.valueOf(appObj.Renewal_Due_Date__c);
                        String ApplicationNo    = appObj.Name;
                        //messageAck = messageAck.replace('<<Due date>>',DueDate);
                        messageAck = messageAck.replace('<< app no >>',ApplicationNo);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }
                        
                        //String emailMessage = SME_Email_Handler.getEnhancementPerfiosError(appObj);
                        //emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage));
                    }
                    else if(appObj.Application_Stage__c =='Application review-Critical changes'){
                        String messageAck = 'Dear << Customer Name >>,  Thank you for submitting your working capital renewal application. Your working capital loan renewal application is under process. Please note the application no << app no >> for your reference';
                        String ApplicationNo    = appObj.Name;
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        messageAck = messageAck.replace('<< app no >>',ApplicationNo);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }
                        String emailMessage = SME_Email_Handler.getLoanUnderProcessing(appObj);
                        emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage));
                    }
                    else if(appObj.Application_Stage__c =='Interim Sanction' || appObj.Application_Stage__c =='Final Sanction'){
                        string docsDis= appObj.Application_Stage__c== 'Final Sanction'? ' & disbursment documents': '';
                        String messageAck = 'Dear << Customer Name >>,  Congratulations!!!. Your working capital loan renewal application has been sanctioned. You can login here '+endUrl+'to e-sign the sanction letter'+docsDis+'. A copy of the sanction letter'+docsDis+' has been sent to your registered email address.';
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }

                        if(appObj.Application_Stage__c =='Final Sanction'){
                            String emailMessage = SME_Email_Handler.getFinalSanctionStageEmailTemplate(appObj);
                            emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage));
                        }
                    }
                    if(appObj.Application_Stage__c =='E-sign pending' && appObj.Recordtype.DeveloperName==Constants.SME_APP_RECORD_TYPE){
                        String messageAck = 'Dear << Customer Name >>,  Congratulations!!!. Your working capital renewal application is ready for disbursement. Request you to complete the documentation with the branch to proceed with limit set up';
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else{
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }
                    }
                    //appObj.Application_Stage__c =='E-sign pending' || 
                    else if(appObj.Application_Stage__c =='Exceeding E-sign pending' || appObj.Application_Stage__c =='Adhoc E-sign pending'){
                        String messageAck = 'Dear << Customer Name >>,  your e-sign is pending on your working capital loan santion letter. Request you to complete the e-sign process by clicking here.'+endUrl;
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else{
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }
                        String emailMessage = SME_Email_Handler.getESignPartiallyCompleted_Individuals(appObj);
                        emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage));
                    }
                    else if(appObj.Application_Stage__c =='Limit extended' || appObj.Application_Stage__c =='Sanction complete- Final sanction'){
                        String messageAck = 'Dear << Customer Name >>,  your working capital renewal application has been sanctioned and limit has been renewed upto << Limit validity date >>. You can download the sanction letter by clicking here'+endUrl;
                        String LimitValidityDate = String.valueOf(appObj.Next_Renewal_Date__c);
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        messageAck = messageAck.replace('<< Limit validity date >>',LimitValidityDate);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }
                        
                        String emailMessage = SME_Email_Handler.getSanctionedRenewed(appObj);
                        emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage));
                    }
                    else if(appObj.Application_Stage__c =='Re-upload financials' || appObj.Application_Stage__c =='Interim Sanction'){
                        String messageAck = 'Dear << Customer Name >>,  Your working capital loan with Karur Vyasa Bank is due for renewal on <<Due date>>. You need to upload your audited financials by clicking here to complete the application'+endUrl;
                        String DueDate  = String.valueOf(appObj.Renewal_Due_Date__c);
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        messageAck = messageAck.replace('<<Due date>>',DueDate);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }
                        
                        String emailMessage = SME_Email_Handler.getFinancialsSubmissionPending(appObj);
                        emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage));
                    }
                    else if(appObj.Application_Stage__c =='Re-upload financials' || appObj.Application_Stage__c =='Interim Sanction'){
                        String messageAck = 'Dear << Customer Name >>,  Your working capital loan with Karur Vyasa Bank is due for renewal on <<Due date>>. You need to upload your income tax returns to complete the application.';
                        String DueDate  = String.valueOf(appObj.Renewal_Due_Date__c);
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        messageAck = messageAck.replace('<<Due date>>',DueDate);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }
                        
                        
                        String emailMessage = SME_Email_Handler.getFinancialSubmissionPendingIndividuals(appObj);
                        emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage));
                    }
                    /*if(appObj.Application_Stage__c =='Financials Submission Pending'){
                        String messageAck ='';
                    } */
                    else if(appObj.Application_Stage__c =='Re-upload financials'){
                        String messageAck ='Dear << Customer Name >>, Your working capital loan with Karur Vyasa Bank is due for renewal on <<Due date>>.You are requested to re-upload your audited financials by clicking here to complete the application'+endUrl;
                        String DueDate  = String.valueOf(appObj.Renewal_Due_Date__c);
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        messageAck = messageAck.replace('<<Due date>>',DueDate);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }
                        
                        String emailMessage = SME_Email_Handler.getPerfiosError(appObj);
                        emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage)); 
                    }
                    else if(appObj.Application_Stage__c =='Perfios error'){
                        String imageLogo = SME_Email_Handler.getDocumentLogoUrl();
                        String mailSubject = 'Perfios data insert failed!!';
                        String body = 'Dear '+customerName+',<br><br>Perfios data upload got failed. please contact yourbranch manager.<br><br>Thanks.<br><br><img src="'+imageLogo+'"/>';
                        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                        message.toAddresses = new List<String>{email_id};
                        message.setSubject(mailSubject);
                        message.setReplyTo('support@kvb.com');
                        message.setSenderDisplayName('KVB TEAM');
                        message.setBccSender(false);
                        message.setHtmlBody(body);
                        System.debug('message::'+message);
                        
                        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                        
                        if (results[0].success) {
                            System.debug('The email was sent successfully.');
                        } else {
                            System.debug('The email failed to send: ' + results[0].errors[0].message);
                        }
                    }
                    
                    else if(appObj.Application_Stage__c =='Enhancement- Application created' && appObj.Application_UI_Stage__c == 'Submission'){
                        String messageAck ='Dear << Customer Name >>, we will be processing the renewal of your existing facilities along with your enhancement request.'; 
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }
                        
                        String emailMessage = SME_Email_Handler.getEnhancementApplicationCreated(appObj);
                        emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage));
                    }
                    else if(appObj.Application_Stage__c =='Enhancement- Application submitted' || appObj.Application_Stage__c == 'New loans- Application submitted'){
                        /*String messageAck ='';
                        System.debug('appObj.Application_Stage__c********195'+appObj.Application_Stage__c);
                        if(appObj.Application_Stage__c =='Enhancement- Application submitted')
                        messageAck ='Dear << Customer Name >>,Thank you for submitting your working capital enhancement application. Your application is under process. Please note the application no << app no >> for your reference.';
                        else if(appObj.Application_Stage__c =='New loans- Application submitted'){
                            messageAck ='Dear << Customer Name >>,Thank you for submitting your working capital application. Your application is under process. Please note the application no << app no >> for your reference. Please contact your branch manager in case of any queries <<Application owner name>>, <<Application owner contact number>>';
                            messageAck = messageAck.replace('<<Application owner name>>',appObj.Owner.Name);
                            messageAck = messageAck.replace('<<Application owner contact number>>',appObj.Owner.Phone);
                        }
                        
                       
                        String ApplicationNo    = appObj.Name;
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        messageAck = messageAck.replace('<< app no >>',ApplicationNo);
                        

                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }   
                        
                        String emailMessage = SME_Email_Handler.getEnhancementApplicationSubmitted(appObj);
                        emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage));

                      */                          
                    }
                    else if((appObj.Application_Stage__c =='Enhancement- Application BM Review' || appObj.Application_Stage__c =='New loans - Application BM Review') && appObj.Sub_Stage__c =='Insufficient collateral coverage'){
                        String messageAck ='Dear << Customer Name >>,  This is with reference to your <<working capital/enhancement>> application << app no >>. You are requested to provide additional collateral as the collateral provided is insufficient to process the request. Please click here'+endUrl+ 'to provide additional collateral details. You can contact us on <<contact no>> for any assistance.';
                        String ApplicationNo    = appObj.Name;
                        String AppType= appObj.Application_Stage__c== 'Enhancement- Application BM Review' ? 'working capital enhancement': 'working capital'; 
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        messageAck = messageAck.replace('<< app no >>',ApplicationNo);
                        messageAck = messageAck.replace('<<contact no>>',support_Contact);
                        messageAck = messageAck.replace('<<working capital/enhancement>>',AppType);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }
                        
                        String emailMessage = SME_Email_Handler.getEnhancementApplicationBMReview(appObj);
                        emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage));
                    }
                    else if(appObj.Application_Stage__c =='Enhancement- Final sanction'){
                        String messageAck = 'Dear << Customer Name >>,  Congratulations!!!. Your working capital loan application has been sanctioned. You can login here'+endUrl+'to e-sign the sanction letter & disbursment documents. A copy of the sanction letter and the disbursement documents has been sent to your registered email address';
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }
                        
                         String emailMessage = SME_Email_Handler.getEnhancementFinalSanction(appObj);
                         emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage));
                    }
                    else if(appObj.Application_Stage__c =='Enhancement- Delined by customer' || appObj.Application_Stage__c=='New loan- Declined by customer'){
                        String messageAck = 'Dear << Customer Name >>,  As per your request, we have withdrawn your working capital loan request. Our branch manager will contact you soon regarding the deline request. For any further asssitance you can contact us at <<number>>'; 
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        messageAck = messageAck.replace('<<number>>',support_Contact);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }
                        
                         String emailMessage = SME_Email_Handler.getEnhancementDelinedByCustomer(appObj);
                         emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage));
                    }
                    else if(appObj.Application_Stage__c =='Enhancement E-sign pending' || appObj.Application_Stage__c =='New loan- E-sign pending'){
                        String messageAck = 'Dear << Customer Name >>, e-sign is pending on your working capital loan sanction letter & disbursement docuements. Request you to complete the e-sign process by clicking here'+endUrl;
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }
                    }
                    else if(appObj.Application_Stage__c =='Enhancement application close' || appObj.Application_Stage__c == 'New loan - Application close'){
                        String messageAck = 'Dear << Customer Name >>,  your working capital enhancment application has been sanctioned and limit has been renewed upto << Limit validity date >>. You can download the sanction letter & disbursement documents by clicking here'+endUrl;
                        String LimitValidityDate = String.valueOf(appObj.Next_Renewal_Date__c);
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        messageAck = messageAck.replace('<< Limit validity date >>',LimitValidityDate);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }
                        
                        String emailMessage = SME_Email_Handler.getEnhancementApplicationClose(appObj);
                        emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage));
                    }
                    else if(appObj.Application_Stage__c =='Customer query'){
                        String messageAck = 'Dear << Customer Name >>,  you are required to furnish some additional information regarding your working capital loan application. Please click here'+endUrl+'to submit the additional information';
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }
                        
                        String emailMessage = SME_Email_Handler.getCustomerQuery(appObj);
                        emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage));
                    }/*
                    else if((appObj.Recordtype.DeveloperName==Constants.SME_APP_RECORD_TYPE_EXCEEDING || appObj.Recordtype.DeveloperName==Constants.SME_APP_RECORD_TYPE_ADHOC || appObj.Recordtype.DeveloperName==Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || appObj.Recordtype.DeveloperName==Constants.SME_NEW_LOAN_RECORD_TYPE) && appObj.Application_Stage__c =='Perfios error' && appObj.Sub_Stage__c =='Re-upload financials'){
                        String messageAck = 'Dear '+appObj.Owner.Name+', for '+customerName+'\'s application '+appObj.Name+'. Please collect and re-upload the customers bank statement.';
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        String DueDate  = String.valueOf(appObj.Renewal_Due_Date__c);
                        String ApplicationNo    = appObj.Name;
                        //messageAck = messageAck.replace('<<Due date>>',DueDate);
                        messageAck = messageAck.replace('<< app no >>',ApplicationNo);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }
                        
                        //String emailMessage = SME_Email_Handler.getEnhancementPerfiosError(appObj);
                        //emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage));
                    }*/
                    else if(appObj.Application_Stage__c =='Exceeding- Application submitted'){
                        String messageAck ='Dear << Customer Name >>,  Thank you for submitting your working capital exceeding application. Your application is under process. Please note the application no << app no >> for your reference.';
                        String ApplicationNo    = appObj.Name;
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        messageAck = messageAck.replace('<< app no >>',ApplicationNo);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }
                        
                        String emailMessage = SME_Email_Handler.getExceedingApplicationSubmitted(appObj);
                        emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage));
                    }
                    else if(appObj.Application_Stage__c =='Exceeding-Final sanction' || appObj.Application_Stage__c =='Adhoc-Final sanction'){
                        String messageAck = 'Dear << Customer Name >>,  Congratulations!!!. Your working capital loan application has been sanctioned. You can login here'+endUrl+'to e-sign the sanction letter. A copy of the sanction letter  has been sent to your registered email address';
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }
                        
                        String emailMessage = SME_Email_Handler.getEnhancementFinalSanction(appObj);
                        emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage)); 
                    }
                    else if(appObj.Application_Stage__c =='Exceeding application close'){
                        String messageAck = 'Dear << Customer Name >>,  your working capital exceeding application has been sanctioned and limit has been renewed upto << Limit validity date >>. You can download the sanction letter & disbursement documents by clicking here'+endUrl;
                        String LimitValidityDate = String.valueOf(appObj.Next_Renewal_Date__c);
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        messageAck = messageAck.replace('<< Limit validity date >>',LimitValidityDate);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }
                        
                        String emailMessage = SME_Email_Handler.getEnhancementApplicationClose(appObj);
                        emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage));
                    }
                    else if(appObj.Application_Stage__c =='Adhoc- Application submitted'){
                        String messageAck ='Dear << Customer Name >>,  Thank you for submitting your working capital adhoc application. Your application is under process. Please note the application no << app no >> for your reference.';
                        String ApplicationNo    = appObj.Name;
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        messageAck = messageAck.replace('<< app no >>',ApplicationNo);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }
                        
                        String emailMessage = SME_Email_Handler.getAdhocApplicationSubmitted(appObj);
                        emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage));
                    }
                    else if(appObj.Application_Stage__c =='Adhoc application close'){
                        String messageAck = 'Dear << Customer Name >>,  your working capital adhoc application has been sanctioned and limit has been renewed upto << Limit validity date >>. You can download the sanction letter & disbursement documents by clicking here'+endUrl;
                        String LimitValidityDate = String.valueOf(appObj.Next_Renewal_Date__c);
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        messageAck = messageAck.replace('<< Limit validity date >>',LimitValidityDate);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }
                        
                        String emailMessage = SME_Email_Handler.getEnhancementApplicationClose(appObj);
                        emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage)); //Application_to_close__c
                    }
                    else if(appObj.Application_Stage__c == 'New loans - Application created' && appObj.Type__c =='NTB'){
                       /*String messageAck = 'Dear << customer >>, Thank you for creating the application. Your application number is <<app no>>. You will need to use the application number to retrieve the application.';
                       String ApplicationNo    = appObj.Name;
                        messageAck = messageAck.replace('<< customer >>',customerName);
                        messageAck = messageAck.replace('<<app no>>',ApplicationNo);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }
                        
                        String emailMessage = SME_Email_Handler.getNewApplicationNTBCreated(appObj);
                        emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage));*/
                    }
                    else if(appObj.Application_Stage__c == 'New loans - Application created' && appObj.Application_UI_Stage__c == 'Submission' && appObj.Application_to_close__c){
                        String messageAck = 'Dear << Customer Name >>, we will be processing the renewal of your existing facilities along with your request.';
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                       If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        } 
                        
                        String emailMessage = SME_Email_Handler.getNewApplicationCreated(appObj);
                        emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage));
                    }
                    else if(appObj.Application_Stage__c == 'New loan - Informal sanction through STP' ){
                        String ApplicationNo    = appObj.Name;
                        String messageAck = 'Dear << Customer Name >>, Congratulations!!!. Your working capital loan application <<Application number>> has been in-principle sanctioned. Your final sanction will be issues subject to legal and property valuation.';
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        messageAck = messageAck.replace('<<Application number>>',ApplicationNo);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        } 
                        
                        String emailMessage = SME_Email_Handler.getNewApplicationInformalSacntionSTP(appObj);
                        emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage));
                    }
                    else if(appObj.Application_Stage__c == 'New loan - Application rejected'){
                        String messageAck ='Dear << Customer Name >>, This is with reference to your working capital enhancement application << app no >>, Your application cannot be taken forward as per bank credit policies. Our branch manager will contact you soon regarding the deline. For any further asssitance you can contact us at <<number>>';
                        String ApplicationNo    = appObj.Name;
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        messageAck = messageAck.replace('<< app no >>',ApplicationNo);
                        messageAck = messageAck.replace('<<number>>',support_Contact);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }
                        
                        String emailMessage = SME_Email_Handler.getNewApplicationRejected(appObj);
                        emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage));
                    } 
                    /*else if(appObj.Application_Stage__c =='Perfios error' && appObj.Sub_Stage__c =='Re-upload bank statements' && appObj.Recordtype.Name=Constants.SME_APP_RECORD_TYPE){
                        String messageAck = 'Dear << Customer Name >>, This is with reference to your working capital application << app no >>, You are requested to re-upload your bank statement by clicking here '+endUrl+' to complete the application.';
                        String ApplicationNo    = appObj.Name;
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        messageAck = messageAck.replace('<< app no >>',ApplicationNo);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        }
                        
                        String emailMessage = SME_Email_Handler.getNewApplicationPerfiosError(appObj);
                        emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage));
                    }*/
                    /*added for new Doc flow*/
                    else if(appObj.Application_Stage__c== 'Adhoc- Final sanction offered' ||appObj.Application_Stage__c== 'Enhancement- Final sanction offered' || appObj.Application_Stage__c== 'New Loan - Final sanction offered'){
                        String sanctionOfferedMessage= 'Dear << Borrower Name >>, We are glad to inform you that your << Record Type – Application ID >> application has been approved subject to document acceptance and MOD completion. Please click on this << link >> to accept the sanction terms.';
                        String sanctionOfferedMessageMngr='Dear << Branch Manager >> , We are glad to inform you that your << Record Type – Application ID >> application has been approved subject to document acceptance and MOD completion. Please click on this << link >> to get the customer to accept the sanction terms.';
                        if(customerName!=null){
                             sanctionOfferedMessage= sanctionOfferedMessage.replace('<< Record Type – Application ID >>', appObj.Recordtype.DeveloperName+'-'+appObj.Name);
                             sanctionOfferedMessage= sanctionOfferedMessage.replace('<< Borrower Name >>',customerName);
                            If(mobileNumber.length() == 12){
                                 SMS_Services.sendSMSFutureCall(mobileNumber,sanctionOfferedMessage);    
                            }else if(mobileNumber.length() == 10){
                                mobileNumber    = '91'+mobileNumber;
                                SMS_Services.sendSMSFutureCall(mobileNumber,sanctionOfferedMessage);
                            }
                        }
                        List<User> usr= [select id,Name,MobilePhone from User where id=: appObj.Owner.Id]; 
                        if(usr!= null && usr.size()>0 && usr[0].MobilePhone!= null){
                            sanctionOfferedMessageMngr= sanctionOfferedMessage.replace('<< Branch Manager >>',usr[0].name);
                            sanctionOfferedMessageMngr= sanctionOfferedMessageMngr.replace('<< Record Type – Application ID >>', appObj.Recordtype.DeveloperName+'-'+appObj.Name);
                            String userMobileNumber= usr[0].MobilePhone;
                            If(userMobileNumber.length() == 12){
                                 SMS_Services.sendSMSFutureCall(userMobileNumber,sanctionOfferedMessageMngr);    
                            }else if(userMobileNumber.length() == 10){
                                userMobileNumber    = '91'+mobileNumber;
                                SMS_Services.sendSMSFutureCall(userMobileNumber,sanctionOfferedMessageMngr);
                            }

                        }
                        String emailMessage = SME_Email_Handler.getFinalSanctionOfferedStageEmailTemplate(appObj);
                        Messaging.SingleEmailMessage singleMail= SME_Email_Handler.getEmailTemplates(email_id,emailMessage);
                        singleMail.subject= 'Informal Sanction of credit facilities; Ref: Your application dated '+appObj.CreatedDate;
                        emails.add(singleMail);
                        
                    }else if(appObj.Application_Stage__c == 'New loans - Application created' && appObj.Application_UI_Stage__c == 'NewLoanDetails' && appObj.Sub_Stage__c == 'Re-upload bank statements'){
                        String messageAck = 'Dear << Customer Name >>, This is with reference to your working capital application << app no >>, You are requested to re-upload your bank statement by clicking here '+endUrl+' to complete the application.';
                        String ApplicationNo    = appObj.Name;
                        messageAck = messageAck.replace('<< Customer Name >>',customerName);
                        messageAck = messageAck.replace('<< app no >>',ApplicationNo);
                       If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,messageAck);
                        } 
                        String emailMessage = SME_Email_Handler.getNewApplicationPerfiosError(appObj);
                        emails.add(SME_Email_Handler.getEmailTemplates(email_id,emailMessage));
                        
                        //Branch Manager
                        List<User> usr= [select id,Name,MobilePhone from User where id=: appObj.Owner.Id]; 
                        if(usr!= null && usr.size()>0 && usr[0].MobilePhone!= null){
                            String messageTemp= 'Dear <<Branch Manager Name>>, This is with reference to the working capital application <<App number>>, You are requested to re-upload your bank statement to complete the application';
                            messageTemp = messageTemp.replace('<<Branch Manager Name>>',usr[0].Name);
                            messageTemp = messageTemp.replace('<<App number>>',appObj.Name);
                            String mobileStrNumber= usr[0].MobilePhone;
                            If(mobileStrNumber.length() == 12){
                                SMS_Services.sendSMSCall(mobileStrNumber,messageTemp);    
                            }else if(mobileStrNumber.length() == 10){
                                mobileStrNumber    = '91'+mobileNumber;
                                SMS_Services.sendSMSCall(mobileStrNumber,messageTemp);
                            }
                            String emailMessageTemplate = SME_Email_Handler.getApplicationPerfiosErrorBMTemplate(appObj);
                            
                            if(appObj.Owner.Email!=null)
                                emails.add(SME_Email_Handler.getEmailTemplates(appObj.Owner.Email,emailMessageTemplate));
                        }
                        
                    }
                    if(appObj.Application_Stage__c!=null && Constants.SME_APP_STAGES_LST.contains(appObj.Application_Stage__c)){
                        try{
                            String messageTemp= 'Application number  <<App number>> has been submitted for processing for your branch. Request you to login into LOS to process the application';
                            messageTemp = messageTemp.replace('<<App number>>',appObj.Name);
                            List<User> usr= [select id,MobilePhone from User where id=: appObj.Owner.Id]; 
                            //String MobilePhoneNum= [select MobilePhone from User where id=: appObj.Owner.Id].MobilePhone;
                            if(usr!= null && usr.size()>0 && usr[0].MobilePhone!= null){
                                String mobileStrNumber= usr[0].MobilePhone;
                                If(mobileStrNumber.length() == 12){
                                     SMS_Services.sendSMSFutureCall(mobileStrNumber,messageTemp);    
                                }else if(mobileStrNumber.length() == 10){
                                    mobileStrNumber    = '91'+mobileNumber;
                                    SMS_Services.sendSMSFutureCall(mobileStrNumber,messageTemp);
                                }

                            }
                            String emailMessageTemplate = SME_Email_Handler.getApplicationSubmittedBMTemplate(appObj);

                            if(appObj.Owner.Email!=null)
                            emails.add(SME_Email_Handler.getEmailTemplates(appObj.Owner.Email,emailMessageTemplate));
                        }catch(Exception e){
                            System.debug('Message '+e.getMessage());
                        }
                    }
                    
                }
                Messaging.sendEmail(emails);
            }
        }catch(Exception ex){
            System.debug('Line Number'+ex.getLineNumber());
            System.debug('Error Message'+ex.getStacktraceString());
            System.debug('Message'+ex.getMessage());
        }
            
    }

    @future(callOut=true)
    public static void sendSmsForTasks(String appid,String taskType,String taskSubject){
            String endUrl           = KVB_Company_Details__c.getOrgDefaults().FE_Portal_Url__c;
            String support_Contact  = KVB_Company_Details__c.getOrgDefaults().KVB_Support_Contact__c;
            System.debug('applnIds::'+appid);
            Map<String,SMSTaskTemplate__mdt> mapMetadata=new Map<String,SMSTaskTemplate__mdt>();
            List<SMSTaskTemplate__mdt> templateList=[select id,Application_Stage__c,Branch_Managaer_SMS__c,Customer_SMS__c,Task_Type__c from SMSTaskTemplate__mdt];
            System.debug('templateList=='+templateList);
            For(SMSTaskTemplate__mdt mdtrec:templateList){
                mapMetadata.put(mdtrec.Task_Type__c,mdtrec);
            }
            List<genesis__Applications__c> listapplication = [select id,genesis__Total_Upfront_Payments__c,Sanction_Authority__c,genesis__Account__r.Priority_Sector__c ,CreatedDate,Recordtype.DeveloperName,Name,OwnerId,Owner.Phone,Owner.Email,genesis__Account__r.Name,genesis__Account__r.Cust_mobile_phone__c,Renewal_Due_Date__c,Application_Stage__c,Sub_Stage__c,Application_UI_Stage__c,Type__c,Next_Renewal_Date__c,Application_to_close__c,genesis__Account__r.Company_Email__c,Branch_Name__c,Owner.Name,genesis__Account__r.Perfios_error_message__c,(select id,Name,Type__c,Recommended_Rate__c,Sanction_Limit__c,Recommended_Processing_Charge__c,Margin__c,MCLR_Rate__c,Interest_Rate__c,Product_Name__c,Recommended_Limit__c,Existing_Limit__c from Facilities__r) from genesis__Applications__c where id =:appid];
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            try{
            if(!listapplication.isEmpty()){
                for(genesis__Applications__c appObj:listapplication){
                    String smsBody='';
                    Integer NumberOfMergeFields=0;
                    String branchMngrName= appObj.Owner.Name;
                    String appNo        = appObj.Name;
                    String mngrPhone    = appObj.Owner.Phone;
                    String mngremail    = appObj.Owner.Email;
                    String customerName = appObj.genesis__Account__r.Name;
                    String mobileNumber = appObj.genesis__Account__r.Cust_mobile_phone__c;
                    String email_id     = appObj.genesis__Account__r.Company_Email__c;
                    String recordtypeName = appObj.Recordtype.Name;
                    if(taskType=='Post Disbursement Deviation' && (appObj.Recordtype.DeveloperName==Constants.SME_NEW_LOAN_RECORD_TYPE)){
                        smsBody=(mapMetadata.get(taskType)).Branch_Managaer_SMS__c;
                        NumberOfMergeFields=smsBody.countMatches('<<');
                        smsBody=smsBody.replace('<<Branch_Manager>>',branchMngrName);
                        smsBody=smsBody.replace('<<record_type>>',recordtypeName);
                        smsBody=smsBody.replace('<<app_no>>',appNo);
                        If(mngrPhone.length() == 12){
                             SMS_Services.sendSMSFutureCall(mngrPhone,smsBody);    
                        }else if(mngrPhone.length() == 10){
                            mngrPhone    = '91'+mngrPhone;
                            SMS_Services.sendSMSFutureCall(mngrPhone,smsBody);
                        }
                    }
                    if(taskType=='Complete Documentation' && (appObj.Recordtype.DeveloperName==Constants.SME_APP_RECORD_TYPE_EXCEEDING || appObj.Recordtype.DeveloperName==Constants.SME_APP_RECORD_TYPE_ADHOC || appObj.Recordtype.DeveloperName==Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || appObj.Recordtype.DeveloperName==Constants.SME_NEW_LOAN_RECORD_TYPE)){
                        smsBody=(mapMetadata.get(taskType)).Branch_Managaer_SMS__c;
                        NumberOfMergeFields=smsBody.countMatches('<<');
                        smsBody=smsBody.replace('<<Branch_Manager>>',branchMngrName);
                        smsBody=smsBody.replace('<<record_type>>',recordtypeName);
                        smsBody=smsBody.replace('<<app_no>>',appNo);
                        If(mngrPhone.length() == 12){
                             SMS_Services.sendSMSFutureCall(mngrPhone,smsBody);    
                        }else if(mngrPhone.length() == 10){
                            mngrPhone    = '91'+mngrPhone;
                            SMS_Services.sendSMSFutureCall(mngrPhone,smsBody);
                        }
                    }
                    if(taskType=='Complete Documentation' && (appObj.Recordtype.DeveloperName==Constants.SME_APP_RECORD_TYPE)){
                        smsBody=(mapMetadata.get('Renewal_Complete_Documentation')).Branch_Managaer_SMS__c;
                        NumberOfMergeFields=smsBody.countMatches('<<');
                        smsBody=smsBody.replace('<<Branch_Manager>>',branchMngrName);
                        smsBody=smsBody.replace('<<record_type>>',recordtypeName);
                        smsBody=smsBody.replace('<<app_no>>',appNo);
                        If(mngrPhone.length() == 12){
                             SMS_Services.sendSMSFutureCall(mngrPhone,smsBody);    
                        }else if(mngrPhone.length() == 10){
                            mngrPhone    = '91'+mngrPhone;
                            SMS_Services.sendSMSFutureCall(mngrPhone,smsBody);
                        }
                    }
                }
            }
        }
        catch(Exception ex){
            System.debug('Line Number'+ex.getLineNumber());
            System.debug('Error Message'+ex.getStacktraceString());
            System.debug('Message'+ex.getMessage());
        }
    }

    //@future(callOut=true)
    public static void Send_SMSEmailFuture(Set<String> applnIds,String triggerOfSmsEmail){
        String endUrl           = KVB_Company_Details__c.getOrgDefaults().FE_Portal_Url__c;
        String support_Contact  = KVB_Company_Details__c.getOrgDefaults().KVB_Support_Contact__c;
        System.debug('applnIds::'+applnIds);
        Map<String,SMSTaskTemplate__mdt> mapMetadata=new Map<String,SMSTaskTemplate__mdt>();
        List<SMSTaskTemplate__mdt> templateList=[select id,Application_Stage__c,Branch_Managaer_SMS__c,Customer_SMS__c,Task_Type__c from SMSTaskTemplate__mdt];
        System.debug('templateList=='+templateList);
        For(SMSTaskTemplate__mdt mdtrec:templateList){
            mapMetadata.put(mdtrec.Task_Type__c,mdtrec);
        }
        System.debug('mapMetadata=='+mapMetadata);
        System.debug('mapMetadata size=='+mapMetadata.keySet().size());
        List<genesis__Applications__c> listapplication = [select id,genesis__Total_Upfront_Payments__c,Processing_Charges__c,Sanction_Authority__c,genesis__Account__r.Priority_Sector__c ,CreatedDate,Recordtype.DeveloperName,Name,OwnerId,Owner.Phone,Owner.Email,genesis__Account__r.Name,Recordtype.Name,genesis__Account__r.Cust_mobile_phone__c,Renewal_Due_Date__c,Application_Stage__c,Sub_Stage__c,Application_UI_Stage__c,Type__c,Next_Renewal_Date__c,Application_to_close__c,genesis__Account__r.Company_Email__c,Branch_Name__c,Owner.Name,genesis__Account__r.Perfios_error_message__c,(select id,Name,Type__c,Recommended_Rate__c,Sanction_Limit__c,Recommended_Processing_Charge__c,Margin__c,MCLR_Rate__c,Interest_Rate__c,Product_Name__c,Recommended_Limit__c,Existing_Limit__c from Facilities__r) from genesis__Applications__c where id IN :applnIds];
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        If(listapplication !=null && listapplication.size() >0 && triggerOfSmsEmail!=null && triggerOfSmsEmail!=''){
                System.debug('listapplication'+listapplication);
                for(genesis__Applications__c appObj : listapplication){
                    String smsBody='';
                    Integer NumberOfMergeFields=0;
                    String branchMngrName= appObj.Owner.Name;
                    String mngrPlaceholder='<<Branch Manager>>';
                    String customerPlaceHolder='<<customer>>';
                    String appNo        = appObj.Name;
                    String appNumPlaceholder='<<application no.>>';
                    String mngrPhone    = appObj.Owner.Phone;
                    String mngremail    = appObj.Owner.Email;
                    String customerName = appObj.genesis__Account__r.Name;
                    String mobileNumber = appObj.genesis__Account__r.Cust_mobile_phone__c;
                    String email_id     = appObj.genesis__Account__r.Company_Email__c;
                    String rectypepc    = '<<record type>>';
                    String recordtypeName = appObj.Recordtype.Name;
                    if(triggerOfSmsEmail == 'Processing charges-Charge API' && (appObj.Recordtype.DeveloperName==Constants.SME_NEW_LOAN_RECORD_TYPE || appObj.Recordtype.DeveloperName==Constants.SME_APP_RECORD_TYPE_EXCEEDING || appObj.Recordtype.DeveloperName==Constants.SME_APP_RECORD_TYPE_ADHOC || appObj.Recordtype.DeveloperName==Constants.SME_APP_RECORD_TYPE_ENHANCEMENT)){
                        System.debug('heree=='+triggerOfSmsEmail);

                        smsBody=(mapMetadata.get(triggerOfSmsEmail)).Customer_SMS__c;
                        smsBody=smsBody.replace(customerPlaceHolder,customerName);
                        smsBody=smsBody.replace(appNumPlaceholder,appNo);
                        smsBody=smsBody.replace('<<processing fees>>',String.valueof(appObj.Processing_Charges__c));
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,smsBody);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,smsBody);
                        }
                    }
                    if(triggerOfSmsEmail == 'Processing_charges_Charge_API_Renewal' && appObj.Recordtype.DeveloperName==Constants.SME_APP_RECORD_TYPE){
                        smsBody=(mapMetadata.get(triggerOfSmsEmail)).Customer_SMS__c;
                        smsBody=smsBody.replace(customerPlaceHolder,customerName);
                        smsBody=smsBody.replace(appNumPlaceholder,appNo);
                        smsBody=smsBody.replace('<<processing fees>>',String.valueof(appObj.Processing_Charges__c));
                        smsBody=smsBody.replace(rectypepc,recordtypeName);
                        If(mobileNumber.length() == 12){
                             SMS_Services.sendSMSFutureCall(mobileNumber,smsBody);    
                        }else if(mobileNumber.length() == 10){
                            mobileNumber    = '91'+mobileNumber;
                            SMS_Services.sendSMSFutureCall(mobileNumber,smsBody);
                        }
                    }
                }
        }
    }

}