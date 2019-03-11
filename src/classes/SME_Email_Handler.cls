/*
 * Name     : SME_Email_Handler
 * Company  : ET Marlabs
 * Purpose  : Used as a Handler Class to Send Email to SME Customer . 
 * Author   : Raushan
 */

 /*version
V1.1        PRASHANT SINGH      03-12-2018      ADDED CC --notifications@kvbmail.com

 */
public class SME_Email_Handler {
    
    public static String endUrl             = KVB_Company_Details__c.getOrgDefaults().FE_Portal_Url__c;
    public static String support_Contact    = KVB_Company_Details__c.getOrgDefaults().KVB_Support_Contact__c;
    
    public static string getDocumentLogoUrl(){
        List<Document> lstDocument = [Select Id,Name,LastModifiedById from Document where DeveloperName ='Kvb_logo_for_Email' limit 1];
        string strOrgId = UserInfo.getOrganizationId();
        string strDocUrl = system.label.Domain_Name+'/servlet/servlet.ImageServer?id=' + lstDocument[0].Id +'&oid=' + strOrgId;
        System.debug(strDocUrl);
        return strDocUrl;
    }
    
    public static Messaging.SingleEmailMessage getEmailTemplates(String Email_id, String HtmlBody){
        Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
        if(Email_id != null){
            singleMail.toAddresses = new String[]{Email_id};
            singleMail.setHtmlBody(HtmlBody);
            singleMail.setSaveAsActivity(false);
            singleMail.setCcAddresses(new string[]{'notifications@kvbmail.com'});//V1.1
            System.debug('singleMail:-'+singleMail);//V1.1
        }  
        return singleMail;
    }
    public static String getRenewalDueTemplates(genesis__Applications__c appln){
        String logoUrl = getDocumentLogoUrl();
        String emailBody = 'Dear '+appln.genesis__Account__r.Name+'<br/>your working capital loan with KVB is due for renewal on '+appln.Renewal_Due_Date__c+'<br/>Please complete the pre-renewal checklist and initiate the renewal process.';
                    
        /*for(Facility__c  f : appln.Facilities__r){
            emailBody += '<br/>'+f.Product_Name__c+' ,'+f.Existing_Limit__c+'<br/>';
        }
        emailBody += '<br/><br/>'+appln.Owner.Name+'<br/>'+appln.Branch_Name__c+'<br/>';
        emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
        */
        return emailBody;
    }

    public static String getRenewalDueTemplatesBM(genesis__Applications__c appln){
        String logoUrl = getDocumentLogoUrl();
        String emailBody = 'Dear '+appln.Owner.Name+'<br/>your'+appln.genesis__Account__r.Name+'\'s working capital loan is due for renewal on '+appln.Renewal_Due_Date__c+'<br/>Please complete the pre-renewal checklist and initiate the renewal process.';
         /*           
        for(Facility__c  f : appln.Facilities__r){
            emailBody += '<br/>'+f.Product_Name__c+' ,'+f.Existing_Limit__c+'<br/>';
        }
        emailBody += '<br/><br/>'+appln.Owner.Name+'<br/>'+appln.Branch_Name__c+'<br/>';
        emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
        */
        return emailBody;
    }

    public static String getAfterRenewalTemplatesCust(genesis__Applications__c appln){
        String logoUrl = getDocumentLogoUrl();
        String emailBody = 'Dear'+appln.genesis__Account__r.Name+',  your working capital limits have been renewed. Your next renewal will be due on '+appln.Next_Renewal_Date__c+'.';
        emailBody += '<br/><br/>'+appln.Owner.Name+'<br/>'+appln.Branch_Name__c+'<br/>';
        emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';

        return emailBody;
    }

    public static String getAfterRenewalTemplatesBM(genesis__Applications__c appln){
        String logoUrl = getDocumentLogoUrl();
        String emailBody = 'Dear '+appln.Owner.Name+',<br/>'+appln.genesis__Account__r.Name+'working capital renewal is completed and next renewal will be due on '+appln.Next_Renewal_Date__c;
        emailBody += '<br/><br/>'+appln.Owner.Name+'<br/>'+appln.Branch_Name__c+'<br/>';
        emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
        return emailBody;
    }

    public static String getEAENLCreationTemplateCust(genesis__Applications__c appln){
        String logoUrl = getDocumentLogoUrl();
        String emailBody = 'Dear '+appln.genesis__Account__r.Name+',<br/>'+'Thank you for starting your '+appln.Recordtype.Name+' application. Your application number is '+appln.Name+'. Please use this for all future references.';
        emailBody += '<br/><br/>'+appln.Owner.Name+'<br/>'+appln.Branch_Name__c+'<br/>';
        emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
        return emailBody;
    }
    public static String getEAENLCreationTemplateBM(genesis__Applications__c appln){
        String logoUrl = getDocumentLogoUrl();
        String emailBody = 'Dear '+appln.Owner.Name+',<br/>'+appln.Name+' has been created for '+appln.genesis__Account__r.Name+'for '+appln.Recordtype.DeveloperName+'. Please follow up with the customer to assist completion of the application.';
        emailBody += '<br/><br/>'+appln.Owner.Name+'<br/>'+appln.Branch_Name__c+'<br/>';
        emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
        return emailBody;
    }

    public static String getEAENLSubmitTemplateCust(genesis__Applications__c appln){
        String logoUrl = getDocumentLogoUrl();
        String emailBody = 'Dear '+appln.genesis__Account__r.Name+',<br/>'+'Thank you for submitting your '+appln.Recordtype.Name+'application with reference number  '+appln.Name+'. Please use this for all future references. Our branch team will reach out to you for the next steps';
        emailBody += '<br/><br/>'+appln.Owner.Name+'<br/>'+appln.Branch_Name__c+'<br/>';
        emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
        return emailBody;
    }
    public static String getEAENLSubmitTemplateBM(genesis__Applications__c appln){
        String logoUrl = getDocumentLogoUrl();
        String emailBody = 'Dear '+appln.Owner.Name+',<br/>'+appln.Name+' has been submitted by the '+appln.genesis__Account__r.Name+'for '+appln.Recordtype.DeveloperName+'. Please initiate application processing.';
        emailBody += '<br/><br/>'+appln.Owner.Name+'<br/>'+appln.Branch_Name__c+'<br/>';
        emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
        return emailBody;
    }
    public static String getEAENLFinalSanctionTemplateCust(genesis__Applications__c appln){
        String logoUrl = getDocumentLogoUrl();
        String emailBody = 'Dear '+appln.genesis__Account__r.Name+',<br/>'+'Congratulations!!!. We are happy to sanction for your  '+appln.Recordtype.Name+'application with '+appln.Name+'. Our branch team will get in touch with you to complete the disbursement formalities';
        emailBody=emailBody+'<html><style>table {table-layout: auto;width: 100%;border-collapse: collapse;border: 1px solid black;} th,td {border: 1px solid black;}</style><table><tr><th>Facility</th><th>Amount</th><th>Margin</th><th>Tenure</th><th>Holiday Period</th></tr><th>ROI</th>';            
        for(Facility__c  f : appln.Facilities__r){
            emailBody += '<tr>'+'<td>'+Utility.getBlankStringIfNull(f.Product_Name__c)+'</td><td>'+Utility.getBlankStringIfNull(String.valueOf(f.Recommended_Limit__c))+'</td><td>'+Utility.getBlankStringIfNull(String.valueOf(f.Margin__c))+'</td><td>'+Utility.getBlankStringIfNull(String.valueOf(f.Tenure__c))+'</td><td>'+Utility.getBlankStringIfNull(String.valueOf(f.Holiday_Period__c))+'</td><td>'+Utility.getBlankStringIfNull(String.valueOf(f.Recommended_Rate__c))+'</td></tr></table></html>';
        }
        emailBody += '<br/><br/>'+appln.Owner.Name+'<br/>'+appln.Branch_Name__c+'<br/>';
        emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
        return emailBody;
    }
    public static String getEAENLRejectTemplateCust(genesis__Applications__c appln){
        String logoUrl = getDocumentLogoUrl();
        String emailBody = 'Dear '+appln.genesis__Account__r.Name+', This is with reference to your '+appln.Recordtype.Name+'  application '+appln.Name+'. We regret to inform you that the we are unable to sanction your request as per our bank policies. In case of any clarifications, kindly contact our branch manager of '+appln.Branch_Name__c;
        emailBody=emailBody.replace('<< Customer Name >>',appln.genesis__Account__r.Name);
        emailBody=emailBody.replace('<< record type>>',appln.Recordtype.Name);
        emailBody=emailBody.replace('<< app no >>',appln.Name);
        emailBody=emailBody.replace('<<branch name>>',appln.Branch_Name__c);
        emailBody += '<br/><br/>'+appln.Owner.Name+'<br/>'+appln.Branch_Name__c+'<br/>';
        emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
        return emailBody;   
    }
    public static String getEAENLLimitOpenedTemplateCust(genesis__Applications__c appln){
        String logoUrl = getDocumentLogoUrl();
        String emailBody = 'Dear '+appln.genesis__Account__r.Name+',<br/>'+'Congratulations!!!. we have set up the limits approved as per '+appln.Name;
        emailBody=emailBody+'<html><style>table {table-layout: auto;width: 100%;border-collapse: collapse;border: 1px solid black;} th,td {border: 1px solid black;}</style><table><tr><th>Facility</th><th>Loan Account No</th><th>Loan Amount</th><th>ROI</th><th>Tenure</th><th>ROI</th>Holiday Period</tr>';            
        for(Facility__c  f : appln.Facilities__r){
            emailBody += '<tr>'+'<td>'+Utility.getBlankStringIfNull(f.Product_Name__c)+'</td><td>'+Utility.getBlankStringIfNull(String.valueOf(f.Account_Number__c))+'</td><td>'+Utility.getBlankStringIfNull(String.valueOf(f.New_Limit_Amount__c))+'</td><td>'+Utility.getBlankStringIfNull(String.valueOf(f.Recommended_Rate__c))+'</td><td>'+Utility.getBlankStringIfNull(String.valueOf(f.Tenure__c))+'</td><td>'+Utility.getBlankStringIfNull(String.valueOf(f.Holiday_Period__c))+'</td></tr></table></html>';
        }
        emailBody += '<br/><br/>'+appln.Owner.Name+'<br/>'+appln.Branch_Name__c+'<br/>';
        emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
        return emailBody;
    }
    public static String getRenewalFinalSanctionTemplate(genesis__Applications__c appln){
        String logoUrl = getDocumentLogoUrl();
        String emailBody = 'Dear '+appln.genesis__Account__r.Name+',<br/>Congratulations!!!. Your working capital loan renewal application has been sanctioned. You can login here '+endUrl+'to view the sanction terms. Summarized below are the key terms of sanction:';
        emailBody=emailBody+'<html><style>table {table-layout: auto;width: 100%;border-collapse: collapse;border: 1px solid black;} th,td {border: 1px solid black;}</style><table><tr><th>Facility</th><th>Limit</th><th>Margin</th><th>ROI</th><th>Processing Fee</th></tr>';            
        for(Facility__c  f : appln.Facilities__r){
            emailBody += '<tr>'+'<td>'+Utility.getBlankStringIfNull(f.Product_Name__c)+'</td><td>'+Utility.getBlankStringIfNull(String.valueOf(f.Existing_Limit__c))+'</td><td>'+Utility.getBlankStringIfNull(String.valueOf(f.Margin__c))+'</td><td>'+Utility.getBlankStringIfNull(String.valueOf(f.Recommended_Rate__c))+'</td><td>'+Utility.getBlankStringIfNull(String.valueOf(f.Recommended_Processing_Charge__c))+'</td></tr></table></html>';
        }
        emailBody += '<br/><br/>'+appln.Owner.Name+'<br/>'+appln.Branch_Name__c+'<br/>';
        emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
        
        return emailBody;
    }
    
    public static String getRenewalApplicationSubmissionPending(genesis__Applications__c appln){
        String logoUrl = getDocumentLogoUrl();
        String emailBody = 'Dear '+appln.genesis__Account__r.Name+'<br/>your working capital loan with KVB is due for renewal on '+appln.Renewal_Due_Date__c+'<br/> Below are the list of facilities due for renewal:<br/>';
                    
        for(Facility__c  f : appln.Facilities__r){
            emailBody += '<br/>'+f.Product_Name__c+' ,'+f.Existing_Limit__c;
        }
        emailBody +='<br/>You can now renew your working capital loans online by clicking '+endUrl+' and  using your corporate internet banking details.\n Please  contact us on <<phone>> for any assistance on the application.<br/><br/>';
        emailBody += '<br/><br/>'+appln.Owner.Name+'<br/>'+appln.Branch_Name__c+'<br/>';
        emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
        return emailBody;
    }
    
    public static String getLoanUnderProcessing(genesis__Applications__c appln){
        String logoUrl = getDocumentLogoUrl();
        String emailBody = 'Dear '+appln.genesis__Account__r.Name+'<br/>Thank you for submitting your working capital renewal application.\n Your Working capital loan renewal application is under processing.<br/><br/>';
        
        emailBody +='<br/>Please note the application no '+appln.Name +' for your reference. \n You may use this refernce number for any communication regarding your working captial renewal application. <br/><br/>';
        emailBody += '<br/><br/>'+appln.Owner.Name+'<br/>'+appln.Branch_Name__c+'<br/>';
        emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
        return emailBody;
    }
    
    public static String getESignPartiallyCompleted_Individuals(genesis__Applications__c appln){
        String logoUrl = getDocumentLogoUrl();
        String emailBody = 'Dear '+appln.genesis__Account__r.Name+',<br/> your e-sign is pending on your working capital loan santion letter.\n Request you to complete the e-sign process by clicking here '+endUrl+ '<br/><br/>';
        emailBody += '<br/><br/>'+appln.Owner.Name+'<br/>'+appln.Branch_Name__c+'<br/>';
        emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
        return emailBody;
    } 
    
    public static String getSanctionedRenewed(genesis__Applications__c appln){
        String logoUrl = getDocumentLogoUrl();
        String emailBody = 'Dear '+appln.genesis__Account__r.Name+'<br/> your working capital renewal application has been sanctioned and limit has been renewed upto '+appln.Next_Renewal_Date__c+'<br/> Below are the list of facilities renewed:<br/>';
                    
        for(Facility__c  f : appln.Facilities__r){
            emailBody += '<br/>'+f.Product_Name__c+' ,'+f.Recommended_Limit__c;
        }
        emailBody +='<br/>You can download the sanction letter by clicking here '+endUrl+' <br/><br/>';
        emailBody += '<br/><br/>'+appln.Owner.Name+'<br/>'+appln.Branch_Name__c+'<br/>';
        emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
        return emailBody;
    }
    
    public static String getFinancialsSubmissionPending(genesis__Applications__c appln){
        String logoUrl = getDocumentLogoUrl();
        String emailBody = 'Dear '+appln.genesis__Account__r.Name+'<br/>  your working capital loan with Karur Vyasa Bank is due for renewal on '+appln.Renewal_Due_Date__c+'<br/>';
                    
        for(Facility__c  f : appln.Facilities__r){
            emailBody += '<br/>'+f.Product_Name__c+' ,'+f.Existing_Limit__c;
        }
        emailBody +='<br/>You need to upload your audited financials by clicking here to complete the application <br/><br/>';
        emailBody += '<br/><br/>'+appln.Owner.Name+'<br/>'+appln.Branch_Name__c+'<br/>';
        emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
        return emailBody;
    }
    
    public static String getFinancialSubmissionPendingIndividuals(genesis__Applications__c appln){
        String logoUrl = getDocumentLogoUrl();
        String emailBody = 'Dear '+appln.genesis__Account__r.Name+'<br/>  your working capital loan with Karur Vyasa Bank is due for renewal on '+appln.Renewal_Due_Date__c+'<br/>';
                    
        for(Facility__c  f : appln.Facilities__r){
            emailBody += '<br/>'+f.Product_Name__c+' ,'+f.Existing_Limit__c;
        }
        emailBody +='<br/>You need to upload your income tax returns by clicking here to complete the application<br/><br/>';
        emailBody += '<br/><br/>'+appln.Owner.Name+'<br/>'+appln.Branch_Name__c+'<br/>';
        emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
        return emailBody;
    }
    public static String getPerfiosError(genesis__Applications__c appln){
        String logoUrl = getDocumentLogoUrl();
        String emailBody = 'Dear '+appln.genesis__Account__r.Name+'<br/>  your working capital loan with Karur Vyasa Bank is due for renewal on '+appln.Renewal_Due_Date__c+'<br/>';
                    
        for(Facility__c  f : appln.Facilities__r){
            emailBody += '<br/>'+f.Product_Name__c+' ,'+f.Existing_Limit__c;
        }
        emailBody +='<br/>You are requested to re-upload your audited financials due to the following reason:'+appln.genesis__Account__r.Perfios_error_message__c+'. You are requested to re-upload the audited financials by clicking here '+endUrl+' <br/><br/>';
        emailBody += '<br/><br/>'+appln.Owner.Name+'<br/>'+appln.Branch_Name__c+'<br/>';
        emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
        return emailBody;
    }
    public static String getEnhancementApplicationCreated(genesis__Applications__c appln){
        String logoUrl = getDocumentLogoUrl();
        String emailBody = 'Dear '+appln.genesis__Account__r.Name+', we will be processing the renewal of your existing facilities along with your enhancement request.';
        emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
        return emailBody;
    }
    public static String getEnhancementApplicationSubmitted(genesis__Applications__c appln){
        String logoUrl = getDocumentLogoUrl();
        String emailBody = '';
        if(appln.Application_Stage__c =='Enhancement- Application submitted'){
        	 emailBody = 'Dear '+appln.genesis__Account__r.Name+',  Thank you for submitting your working capital enhancement application. Your application is under process. Please note the application no '+appln.Name+' for your reference.';    
        }else if(appln.Application_Stage__c =='New loans- Application submitted'){
        	 emailBody = 'Dear '+appln.genesis__Account__r.Name+', Thank you for submitting your working capital application. Your application is under process. Please note the application no '+appln.Name+' for your reference.Please contact your branch manager in case of any queries '+appln.Owner.Name+', '+appln.Owner.phone;
        }
        emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
        return emailBody;
    }
    public static String getEnhancementApplicationBMReview(genesis__Applications__c appln){
        String AppType= appln.Application_Stage__c== 'Enhancement- Application BM Review' ? 'working capital enhancement': 'working capital'; 
        String logoUrl = getDocumentLogoUrl();
        String emailBody = 'Dear '+appln.genesis__Account__r.Name+',  This is with reference to your '+AppType+' '+appln.Name+'.'; 
        emailBody +='<br>You are requested to provide additional collateral as the collateral provided is insufficient to process the request.';
        emailBody += '<br><br> Please click' +endUrl+ ' to provide additional collateral details. You can contact us on '+support_Contact+' for any assistance';
        emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
        return emailBody;
    }
    public static String getEnhancementFinalSanction(genesis__Applications__c appln){
        String logoUrl = getDocumentLogoUrl();
        String emailBody = 'Dear '+appln.genesis__Account__r.Name+',  Congratulations!!!. Your working capital loan application has been sanctioned. You can login here '+endUrl+' to e-sign the sanction letter & disbursment documents.';
        emailBody += '<br> A copy of your sanction letter and disbursement documents has been attached with this mail. Request you to review the same. In case of any assistance please contact'+ support_Contact;       
        emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
        return emailBody;
    }
    public static String getEnhancementDelinedByCustomer(genesis__Applications__c appln){
        String logoUrl = getDocumentLogoUrl();
        String emailBody = 'Dear '+appln.genesis__Account__r.Name+',  As per your request, we have withdrawn your working capital loan request. Our branch manager will contact you soon regarding the deline request. For any further asssitance you can contact us at' +support_Contact;
        emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
        return emailBody;
    }
    public static String getEnhancementApplicationClose(genesis__Applications__c appln){
        String logoUrl = getDocumentLogoUrl();
        String emailBody = 'Dear '+appln.genesis__Account__r.Name+',  your working capital application has been sanctioned and limit has been renewed upto'+ appln.Next_Renewal_Date__c+'.';
        emailBody += '<br/><br/>Below are the list of facilities renewed:';
        for(Facility__c  f : appln.Facilities__r){
            emailBody += '<br/><br/>'+f.Name+' ,'+f.Existing_Limit__c+'<br/>';
        }
        emailBody +='<br/>You can download the sanction letter & disbursement documents by clicking here '+endUrl;
        emailBody += '<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
        return emailBody;
    }
    public static String getCustomerQuery(genesis__Applications__c appln){
        String logoUrl = getDocumentLogoUrl();
        String emailBody = 'Dear '+appln.genesis__Account__r.Name+',   you are required to furnish some additional information regarding your working capital loan application. Please click here '+endUrl+' to submit the additional information';
        emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
        return emailBody;
    }
    public static String getEnhancementPerfiosError(genesis__Applications__c appln){
        String logoUrl = getDocumentLogoUrl();
        String emailBody = 'Dear '+appln.genesis__Account__r.Name+'<br/>your working capital loan with KVB is due for renewal on '+appln.Renewal_Due_Date__c;
                    
        for(Facility__c  f : appln.Facilities__r){
            emailBody += '<br/>'+f.Name+' ,'+f.Existing_Limit__c+'<br/>';
        }
        emailBody +='<br/>You are requested to re-upload your audited financials due to the following reason:'+appln.genesis__Account__r.Perfios_error_message__c+'. You are requested to re-upload the audited financials by clicking here '+endUrl+' <br/><br/>';
        emailBody += '<br/><br/>'+appln.Owner.Name+'<br/>'+appln.Branch_Name__c+'<br/>';
        emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
        
        return emailBody;
    }
     public static String getExceedingApplicationSubmitted(genesis__Applications__c appln){
        String logoUrl = getDocumentLogoUrl();
        String emailBody = 'Dear '+appln.genesis__Account__r.Name+',  Thank you for submitting your working capital exceeding application. Your application is under process. Please note the application no '+appln.Name+'for your reference.';
        emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
        return emailBody;
    }
     public static String getAdhocApplicationSubmitted(genesis__Applications__c appln){
        String logoUrl = getDocumentLogoUrl();
        String emailBody = 'Dear '+appln.genesis__Account__r.Name+',  Thank you for submitting your working capital adhoc application. Your application is under process. Please note the application no '+appln.Name+'for your reference.';
        emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
        return emailBody;
    }
    public static String getNewApplicationNTBCreated(genesis__Applications__c appln){
        String logoUrl = getDocumentLogoUrl();
        String emailBody = 'Dear '+appln.genesis__Account__r.Name+', Thank you for creating the application. Your application number is '+appln.Name+'. You will need to use the application number to retrieve the application.';
        emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
        return emailBody;
    }
    public static String getNewApplicationCreated(genesis__Applications__c appln){
        String logoUrl = getDocumentLogoUrl();
        String emailBody = 'Dear '+appln.genesis__Account__r.Name+', We will be processing the renewal of your existing facilities along with your request.';
        emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
        return emailBody; 
    }
    public static String getNewApplicationRejected(genesis__Applications__c appln){
        String logoUrl = getDocumentLogoUrl();
        String emailBody = 'Dear '+appln.genesis__Account__r.Name+', This is with reference to your working capital enhancement application '+appln.Name+', Your application cannot be taken forward as per bank credit policies. Our branch manager will contact you soon regarding the deline. For any further asssitance you can contact us at '+support_Contact;
        emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
        return emailBody; 
    }
    public static String getNewApplicationPerfiosError(genesis__Applications__c appln){
        String logoUrl = getDocumentLogoUrl();
        String emailBody = 'Dear '+appln.genesis__Account__r.Name+',  This is with reference to your working capital application '+appln.Name+', You are requested to re-upload your bank statement by clicking here' +endUrl+' to complete the application. Bank statement has been rejected.';
        emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
        return emailBody;
    }
    public static String getNewApplicationInformalSacntionSTP(genesis__Applications__c appln){
       String logoUrl = getDocumentLogoUrl();
       String emailBody = 'Dear '+appln.genesis__Account__r.Name+', Congratulations!!!. Your working capital loan application '+appln.Name+' has been in-principle sanctioned.  Your final sanction will be issues subject to legal and property valuation.' ;
       emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
       return emailBody; 
    }

    public static String getApplicationSubmittedBMTemplate(genesis__Applications__c appln){
        String logoUrl = getDocumentLogoUrl();
        String emailBody = 'Dear '+appln.Owner.Name+',<br/>  Application number '+appln.Name+' has been submitted for processing for your branch. Request you to login into LOS to process the application.';    
        
        emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
        return emailBody;
    }

    public static String getFinalSanctionStageEmailTemplate(genesis__Applications__c appln){
        String logoUrl = getDocumentLogoUrl();
        String emailBody = 'Dear '+appln.genesis__Account__r.Name+',<br/>Congratulations!!!.<br/> <p> Your working capital loan application has been sanctioned. You can login here '+endUrl+' to e-sign the sanction letter & disbursment documents. A copy of your sanction letter and disbursement documents has been attached with this mail. Request you to review the same. In case of any assistance please contact '+support_Contact+'.</p>';
        
        emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
        return emailBody;
    }
    public static String getApplicationPerfiosErrorBMTemplate(genesis__Applications__c appln){
        String logoUrl = getDocumentLogoUrl();
        String emailBody = 'Dear '+appln.Owner.Name+',<br/>  This is with reference to the working capital application '+appln.Name+' You are requested to re-upload your bank statement to complete the application.';    
        
        emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
        return emailBody;
    }
    public static String getFinalSanctionOfferedStageEmailTemplate(genesis__Applications__c appln){
        String logoUrl = getDocumentLogoUrl();
        Decimal processCharge= 0;
        Decimal processChargeGST=0;
        Decimal processChargeTotal=0;
        Decimal docCharge=0;
        Decimal docChargeGST=0;
        Decimal docChrageTotal=0;
        Decimal cibilCharge=0;
        Decimal cibilChargeGST=0;
        Decimal cibilChargeTotal=0;
        Decimal finalProcessingFee=0;
        Decimal totalAMT= 0;
        Decimal gstCharge= KVB_Company_Details__c.getOrgDefaults().GST__c;

        
        

        String emailBody= 'Dear '+appln.genesis__Account__r.Name+',</br><p>We are glad to inform you that your '+appln.Recordtype.DeveloperName+'-'+appln.Name+' application has been approved as per the following terms subject to legal and valuation process, terms and conditions acceptance, document acceptance and MOD completion. Please click on this link to accept the sanction terms.</p></br>Additionally, please review the key sanction terms below.</br>';
        System.debug('TEst---------------');
        String faciData='<table border="1">'+
        '<tr><td>S. No</td> <td>Nature of Facility</td> <td>Limit in Rs.</td> <td>Margin (%)</td> <td>MCL Rate (%)</td> <td>Loan Rate of Interest (%)</td> <td>Validity Period</td> </tr>';
        integer sno=0;
        for(Facility__c faci: appln.Facilities__r){
            totalAMT= totalAMT+ faci.Recommended_Limit__c;
            sno++;
            String Validity_period= (appln.RecordType.DeveloperName== 'SME_Exceeding' || appln.RecordType.DeveloperName== 'SME_AdHoc')? Utility.getBlankStringIfNull(String.valueOf(faci.Recommended_Days__c)) :'365';
            faciData= faciData+ '<tr> <td>'+sno+'</td> <td>'+faci.Product_Name__c+'</td> <td>'+faci.Recommended_Limit__c+'</td> <td>'+faci.Margin__c+'</td> <td>'+faci.MCLR_Rate__c+'</td> <td>'+faci.Recommended_Rate__c+'</td> <td>'+Validity_period+'</td> </tr>';
        }
		System.debug(appln.RecordTypeId);
        if(appln.RecordType.DeveloperName== 'SME_Enhancement' ||  appln.RecordType.DeveloperName== 'SME_NEW_Loan'){
            processCharge= SMESanction_DocReq.processingFeeCalculation(appln.Facilities__r,appln);
            System.debug('Tset processCharge'+processCharge+' TESt gstCharge '+gstCharge);
            processChargeGST= ((processCharge * gstCharge)/100).setscale(2);
            processChargeTotal= (processCharge + processChargeGST).setscale(2);
            docCharge= (SMESanction_DocReq.docFee).setscale(2);
            docChargeGST= ((docCharge * gstCharge)/100).setscale(2);
            docChrageTotal= (docCharge + docChargeGST).setscale(2);    
            cibilCharge= (SMESanction_DocReq.cibilFee).setscale(2);
            cibilChargeGST= ((cibilCharge * gstCharge)/100).setscale(2);
            cibilChargeTotal= (cibilCharge + cibilChargeGST).setscale(2); 
            finalProcessingFee= (processChargeTotal+docChrageTotal+cibilChargeTotal).setscale(2);
        }else if(appln.RecordType.DeveloperName== 'SME_AdHoc'){
            if(appln.Sanction_Authority__c != NULL && appln.Sanction_Authority__c.contains('BR_MGR')){
                if(appln.genesis__Account__r.Priority_Sector__c == TRUE && totalAMT < 500000){
                    processChargeGST   = ((processCharge * gstCharge)/100).setscale(2);
                    processChargeTotal = (processCharge + processChargeGST).setscale(2);
                    finalProcessingFee = (processChargeTotal + docChrageTotal + cibilChargeTotal).setscale(2);

                }else If(appln.genesis__Account__r.Priority_Sector__c == FALSE && totalAMT < 500000){
                    processCharge      = 3000;
                    processChargeGST   = ((processCharge * gstCharge)/100).setscale(2);
                    processChargeTotal = (processCharge + processChargeGST).setscale(2);
                    finalProcessingFee = (processChargeTotal + docChrageTotal + cibilChargeTotal).setscale(2);

                }else If(appln.genesis__Account__r.Priority_Sector__c == FALSE && (totalAMT >= 500000 && totalAMT < 1000000)){
                    processCharge      = 3000;
                    processChargeGST   = ((processCharge * gstCharge)/100).setscale(2);
                    processChargeTotal = (processCharge + processChargeGST).setscale(2);
                    docCharge          = (SMESanction_DocReq.docChargeCalculation(totalAMT)).setscale(2);
                    docChargeGST       = ((docCharge * gstCharge)/100).setscale(2);
                    docChrageTotal     = (docCharge + docChargeGST).setscale(2);
                    finalProcessingFee = (processChargeTotal + docChrageTotal + cibilChargeTotal).setscale(2);
                }else If(appln.genesis__Account__r.Priority_Sector__c == FALSE && (totalAMT >= 1000000 && totalAMT < 2500000)){
                    processCharge      = 4500;
                    processChargeGST   = ((processCharge * gstCharge)/100).setscale(2);
                    processChargeTotal = (processCharge + processChargeGST).setscale(2);
                    docCharge          = (SMESanction_DocReq.docChargeCalculation(totalAMT)).setscale(2);
                    docChargeGST       = ((docCharge * gstCharge)/100).setscale(2);
                    docChrageTotal     = (docCharge + docChargeGST).setscale(2);
                    finalProcessingFee = (processChargeTotal + docChrageTotal + cibilChargeTotal).setscale(2);

                }else If(appln.genesis__Account__r.Priority_Sector__c == FALSE && (totalAMT >= 2500000 && totalAMT < 5000000)){
                    processCharge      = 6500;
                    processChargeGST   = ((processCharge * gstCharge)/100).setscale(2);
                    processChargeTotal = (processCharge + processChargeGST).setscale(2);
                    docCharge          = (SMESanction_DocReq.docChargeCalculation(totalAMT)).setscale(2);
                    docChargeGST       = ((docCharge * gstCharge)/100).setscale(2);
                    docChrageTotal     = (docCharge + docChargeGST).setscale(2);
                    finalProcessingFee = (processChargeTotal + docChrageTotal + cibilChargeTotal).setscale(2);
                }
            }else if(appln.genesis__Account__r.Priority_Sector__c == TRUE && totalAMT < 500000){
                finalProcessingFee = (processChargeTotal + docChrageTotal + cibilChargeTotal).setscale(2);
            }else if(appln.genesis__Account__r.Priority_Sector__c == TRUE && (totalAMT >= 5000000 && totalAMT < 10000000)){
                finalProcessingFee = (processChargeTotal + docChrageTotal + cibilChargeTotal).setscale(2);
            }else if(totalAMT >= 500000 && totalAMT < 1000000){
                processCharge      = 6000;
                processChargeGST   = ((processCharge * gstCharge)/100).setscale(2);
                processChargeTotal = (processCharge+ processChargeGST).setscale(2);
                docCharge          = (SMESanction_DocReq.docChargeCalculation(totalAMT)).setscale(2);
                docChargeGST       = ((docCharge * gstCharge)/100).setscale(2);
                docChrageTotal    = (docCharge + docChargeGST).setscale(2);
                finalProcessingFee = (processChargeTotal + docChrageTotal + cibilChargeTotal).setscale(2);
            }else if(totalAMT >= 1000000 && totalAMT < 2000000){
                processCharge      = 7000;
                processChargeGST   = ((processCharge * gstCharge)/100).setscale(2);
                processChargeTotal = (processCharge + processChargeGST).setscale(2);
                docCharge          = (SMESanction_DocReq.docChargeCalculation(totalAMT)).setscale(2);
                docChargeGST       = ((docCharge * gstCharge)/100).setscale(2);
                docChrageTotal    = (docCharge + docChargeGST).setscale(2);
                finalProcessingFee = (processChargeTotal + docChrageTotal + cibilChargeTotal).setscale(2);
            }else if(totalAMT >= 2000000 && totalAMT < 5000000){
                processCharge      = 10000;
                processChargeGST   = ((processCharge * gstCharge)/100).setscale(2);
                processChargeTotal = (processCharge + processChargeGST).setscale(2);
                docCharge          = (SMESanction_DocReq.docChargeCalculation(totalAMT)).setscale(2);
                docChargeGST      = ((docCharge * gstCharge)/100).setscale(2);
                docChrageTotal     = (docCharge + docChargeGST).setscale(2);
                finalProcessingFee = (processChargeTotal + docChrageTotal + cibilChargeTotal).setscale(2);
            }
            else if(totalAMT >= 5000000 && totalAMT < 10000000){
                processCharge      = 25000;
                processChargeGST   = ((processCharge * gstCharge)/100).setscale(2);
                processChargeTotal = (processCharge + processChargeGST).setscale(2);
                docCharge          = (SMESanction_DocReq.docChargeCalculation(totalAMT)).setscale(2);
                docChargeGST       = ((docCharge * gstCharge)/100).setscale(2);
                docChrageTotal    = (docCharge + docChargeGST).setscale(2);
                finalProcessingFee = (processChargeTotal + docChrageTotal + cibilChargeTotal).setscale(2);
            }else if(appln.genesis__Account__r.Priority_Sector__c == FALSE && totalAMT > 10000000){
                processCharge      = 40000;
                processChargeGST   = ((processCharge * gstCharge)/100).setscale(2);
                processChargeTotal = (processCharge + processChargeGST).setscale(2);
                docCharge         = (SMESanction_DocReq.docChargeCalculation(totalAMT)).setscale(2);
                docChargeGST       = ((docCharge * gstCharge)/100).setscale(2);
                docChrageTotal    = (docCharge + docChargeGST).setscale(2);
                finalProcessingFee = (processChargeTotal + docChrageTotal + cibilChargeTotal).setscale(2);
            }
            else{
                finalProcessingFee = (processChargeTotal + docChrageTotal + cibilChargeTotal).setscale(2);
            }
        }

        faciData= faciData+'</table>';
        emailBody= emailBody+faciData;
        emailBody= emailBody+ '<br> Interest type            : Floating rate linked to MCLR <br> Interest charge method  : Compounding on monthly basis <br> Interest rate validity : Valid till next MCLR revision <br>';
        String chargTable= '<table border="1">'+
                    '<tr> <td> </td> <td><b>Bank Fee</b></td> <td><b>GST</b></td> <td><b>Total</b></td> </tr>'+
                    '<tr> <td>Processing Charge</td> <td>'+processCharge+'</td> <td>'+processChargeGST+'</td> <td>'+processChargeTotal+'</td> </tr>'+
                    '<tr> <td>Documentation Charge</td> <td>'+docCharge+'</td> <td>'+docChargeGST+'</td> <td>'+docChrageTotal+'</td> </tr>'+
                    '<tr> <td>CIBIL Charge</td> <td>'+cibilCharge+'</td> <td>'+cibilChargeGST+'</td> <td>'+cibilChargeTotal+'</td> </tr>'+
                    '<tr> <td><b>Total</b></td> <td>'+finalProcessingFee+'</td> </tr>'+
                    '</table>';
        emailBody= emailBody+ chargTable;
        emailBody= emailBody+'<br> <br> Upfront fee (non-refundable): '+ appln.genesis__Total_Upfront_Payments__c +'<br> <br> <b>Terms and conditions:</b>'+
                            '<br> 1. Limit should be availed within three months from the date of sanction'+
                            '<br> 2. The interest rate provided above is indicative as it is a floating interest rate linked to MCLR of the Bank. The actual interest rate will be fixed as per the rate on the date of disbursement and will be communicated'+
                            '<br> 3. The Bank is entitled to charge penal interest @ ((Penal_Interest_Rate2))% p.a. in case of default in paying the instalments/ interest dues on the due dates, and the penal interest would be charged on the amount overdue and for the overdue period, till the defaulted amount is repaid and account regularized.'+
                            '<br> 4. The borrower hereby undertakes and agrees that the bank shall be entitled to and recover/impose prepayment/pre-closure charges for the full or partial closure of the credit facilities of the borrower by any means other than as stipulated under the sanction terms and such prepayment/pre-closure charges shall be at ((Penal_Interest_Rate2))% or at such rate as stipulated by the bank as per its policy from time to time on the sanctioned working capital Limits (Both Fund and Non-Fund based Limits) as appearing in the bank’s books, save as otherwise agreed by the bank in writing in favour of the borrower.'+
                            '<br> 5. All other terms and conditions will be communicated to you along with the sanction letter</br>';
        emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
        return emailBody;



    }
}