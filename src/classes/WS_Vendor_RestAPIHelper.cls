/*
* Name    : WS_Vendor_RestAPIHelper
* Company : ET Marlabs
* Purpose : This class consists is helper class for all 3rd party loan onboarding APIs
* Author  : Bhavya
*/
global class WS_Vendor_RestAPIHelper{

    global virtual class WS_Vendor_Response{
        global String status; 
        global String errorMessage;
        global String successMessage;
        global String statusCode; 
        global String errorType;

        global WS_Vendor_Response(){
            status = WS_Vendor_Constants.WS_SUCCESS_STATUS;
            errorMessage = '';
            successMessage = '';
            statusCode = WS_Vendor_Constants.WS_SUCCESS_CODE;
            errorType = '';
        } 
    }

    //String null check
    public static boolean ISStringBlankorNull(string strVal){
        if(strVal == null || strVal == ''){
             return true;
        }else{
             return false;
        }       
    }

    public static boolean ISBoolean(string strVal){
        if(strVal == 'false' || strVal == 'true'){
             return true;
        }else{
             return false;
        }       
    }

    public static boolean isValidDate(String dateString) {
        return Pattern.compile('((18|19|20|21)\\d\\d)-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])').matcher(dateString).matches();
    }

    public static Boolean isNumeric(String s){
        try{
            Decimal.valueOf(s);
            return true;
        } catch (Exception e) {
            return false;
        }
    }


    //Get application record type and product name
    public static genesis__Applications__c getRecordTypeAndProduct(String loanType){
        String RType; 
        genesis__Applications__c  app = new genesis__Applications__c();     
        if(loanType == 'HL'){
            RType = WS_Vendor_Constants.HOMELOAN;
            app.genesis__CL_Product__c = getProduct(KVB_Company_Details__c.getOrgDefaults().Third_Party_HL_Name__c).id; 
        }else if(loanType == WS_Vendor_Constants.LAPLOAN){
            RType = WS_Vendor_Constants.LAPLOAN; 
            app.genesis__CL_Product__c = getProduct(KVB_Company_Details__c.getOrgDefaults().Third_Party_LAP_Name__c).id;
        }else if(loanType == 'PL'){
             RType = WS_Vendor_Constants.PERSONALLOAN; 
             app.genesis__CL_Product__c = getProduct(KVB_Company_Details__c.getOrgDefaults().Third_Party_PL_Name__c).id;
        }else if(loanType == 'VL2W'){
             RType = WS_Vendor_Constants.VL2W;
              app.genesis__CL_Product__c = getProduct(KVB_Company_Details__c.getOrgDefaults().Third_Party_VL2W_Name__c).id;
        }else if(loanType == 'VL4W'){
             RType = WS_Vendor_Constants.VL4W;
             app.genesis__CL_Product__c = getProduct(KVB_Company_Details__c.getOrgDefaults().Third_Party_VL4W_Name__c).id;
        }
         Id AppRecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(RType).getRecordTypeId();
         app.RecordTypeId=AppRecordTypeId;  
         return app;    
    }

    public static clcommon__CL_Product__c getProduct(String name){    
        return getProducts(new list<String>{name}).size()>0 ?getProducts(new list<String>{name})[0]:null;    
    }

    public static list<clcommon__CL_Product__c> getProducts(List<String> prodNames){
        return [select id,Name,clcommon__Product_Name__c,Product_Code__c from clcommon__CL_Product__c where clcommon__Product_Name__c IN:prodNames];
    }

    //Get account record type
    public static Id getRecordType(String RType){
            return Schema.SObjectType.Account.getRecordTypeInfosByName().get(RType).getRecordTypeId();
    }

    //Get collateral name    
    public static String getRandomExternalIdForCollateral(){
        Integer randomInteger = Crypto.getRandomInteger();
        String randomString=String.valueOf(math.abs(randomInteger));
        String leftPadding = '000000';
        String leftPaddedString = randomString.leftPad(20,leftPadding);
        return 'FE-'+leftPaddedString+String.valueOf(DateTime.now().millisecond());
    }

    //Create task
    public static void creatTaskAll(String appId,String usrId, String sub, Integer days, String rlpc, String pbg){
        System.debug('entered');
        List<Task> tskList = new List <Task>();
        tskList = [Select Subject,WhatId From Task Where WhatId =: appId AND Subject =: sub];
        System.debug('tskList-->'+tskList);
        System.debug('appId-->'+appId);
        if(tskList.size()==0){
            Task tsk = new Task();
            tsk.WhatId = appId;
            tsk.genesis__Application__c = appId;
            tsk.OwnerId = usrId;
            tsk.ActivityDate = system.today() + days;
            tsk.Subject = sub;
            tsk.Status = 'Not Started';
            tsk.Priority = 'High';
            tsk.RLPC_Head__c = rlpc;
            tsk.PBG__c = pbg;
            System.debug('tsk:::'+tsk);
            try{
                Insert tsk;
            }catch(Exception e){
                System.debug('e.msg:::'+e.getCause());
                System.debug('e.msg:::'+e.getLineNumber());
                System.debug('e.msg:::'+e.getLineNumber());
                System.debug('e.msg:::'+e.getStackTraceString());
            }
        }
    }

    //Get user to create task
    public static List<String> getUserList(String thirdParty){
        List <User> usrList = new List <User>();
        List <String> returnList = new List <String>();
        String UsrId;     
        Branch_Master__c brMaster = getBranchDetails(thirdParty);           
        if(brMaster!=null){
            usrList = [Select ID,Office_Code__c From User where (Office_Code__c =:brMaster.CODCCBRN__c Or Office_Code__c =:brMaster.Linked_RLPC__c) And Designation__c=:WS_Vendor_Constants.NODAL_OFFICER AND IsActive =:True];
            UsrId = AssignTask.userAssign(usrList);
            if(UsrId == null){
                if(usrList.size()>0){
                    UsrId = usrList[0].Id;
                }
            }
            if(UsrId!=null){    
                returnList.add(UsrId); 
            }
            
            usrList = [Select ID,Email From User where Office_Code__c =:brMaster.Linked_RLPC__c And Role_Name__c=:WS_Vendor_Constants.RLPC_HEAD AND IsActive =:True];
            if(usrList.size()>0 && returnList.size()>0){
                UsrId = usrList[0].Email;
                returnList.add(UsrId);
            }

            usrList = [Select ID,Email From User where Office_Code__c =:brMaster.Linked_RLPC__c And Role_Name__c=:WS_Vendor_Constants.RLPC_HEAD AND IsActive =:True];
            if(usrList.size()>0 && returnList.size()>1){
                UsrId = usrList[0].Email;
                returnList.add(UsrId);
            }
        }
        return returnList;    
    }

    public static Branch_Master__c getBranchDetails(String thirdParty){
        List<Branch_Master__c> brList = new List<Branch_Master__c>();
        if(thirdParty!=null && thirdParty!=''){
            brList = [Select Id, CODCCBRN__c,Linked_RLPC__c, Division_Code__c,NAM_BRANCH__c From Branch_Master__c Where Third_Party__c includes (:thirdParty) AND Active__c=true limit 1];
            if(brList.size()>0){
                return brList[0];
            }
        }
        return null;
    }
    
    public static List<Decimal> getInterestRate(String sourcedBy, String employmentTypes,Boolean finApplicant,Decimal loanAmount,Decimal age,String recordtype,Decimal maxCibil){
        list<Third_Party_ROI_Matrix__mdt> matrixList = new list<Third_Party_ROI_Matrix__mdt>(); 
        List<Decimal> decList = new List<Decimal>();
        matrixList = [select id, MasterLabel,ROI_Floating_650_700__c,ROI_Floating_700__c,ROI_Cibil_1__c,ROI_Cibil_5__c,MCLR_Type__c FROM Third_Party_ROI_Matrix__mdt where Field_Investigation__c =: sourcedBy AND Target_Borrowers__c =: employmentTypes AND Is_Financial_Applicant__c =: finApplicant AND Loan_Amount_Max__c>=:loanAmount AND Loan_Amount_Min__c<=:loanAmount AND Age_Norms_Origination__c<=:age AND Age_Norms_Maturity__c>=:age AND Record_Type__c =:recordtype];
        Decimal interestRate = 0;
        Decimal mclrRate = 0;
        if(matrixList.size()>0){
            if(maxCibil >= 650 && maxCibil<700){
                interestRate = matrixList[0].ROI_Floating_650_700__c;
            }else if(maxCibil >= 700){
                interestRate = matrixList[0].ROI_Floating_700__c;
            }else if(maxCibil == -1){
                interestRate = matrixList[0].ROI_Cibil_1__c;
            }else if(maxCibil == 5){
                interestRate = matrixList[0].ROI_Cibil_5__c;
            }
            mclrRate =  ApplicationEligibiltyHandler.getMCLR(Integer.valueOf(matrixList[0].MCLR_Type__c),null,null);
            interestRate += mclrRate;
        }
        decList.add(interestRate);
        decList.add(mclrRate);
        return decList;
    }

}