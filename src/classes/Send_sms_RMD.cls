/*
* Name    : Send_sms_RMD 
* Company : ET Marlabs
* Author  : Prasant Singh
-----------------------------------------------------------------------
  Version   Date         Author           Remarks                                                 
  =======   ==========   =============  ==================================
    V1.1    18-Dec-2018    Ashok        Added SendEmailnSMS invocable method to call send sms from process builder.
*******************************************************************************************/
global class Send_sms_RMD {

    @InvocableMethod(Label='Send Email and SMS') //v1.1
    public static void SendEmailnSMS(List<WrapperClass> WrapRequest){
    String Status = '';
    List<WrapperClass> cls = new List<WrapperClass>();
    List<genesis__Applications__c> AppList; 
       for(WrapperClass wrp: WrapRequest)
        {
            cls.add(wrp);
        }
        System.debug('--Printing values --- '+cls); 
        if(cls[0].ApplicationId <> null || cls[0].ApplicationId != ''){
            //AppList = [Select id,Employment_Type__c,Record_Type_Name__c from genesis__Applications__c where id=:cls[0].ApplicationId]; 
            if(cls[0].ApplicationScore < cls[0].PCutoffScore && cls[0].ApplicationScore >= cls[0].PReferralCutOff && cls[0].ScoreOverride == False && cls[0].PerfiosCaptured == true){
                System.debug('Perfios >> ApplicationScore  ApplicationId >>> '+cls[0].PerfiosCaptured +' '+ cls[0].ApplicationScore +' '+cls[0].ApplicationId);
                smsEmailMethod(cls[0].ApplicationId,Status);
            }
            else if(cls[0].NPCutoffScore <> null && cls[0].ApplicationScore < cls[0].NPCutoffScore && cls[0].ApplicationScore >= cls[0].NPReferralCutOff && cls[0].ScoreOverride == False && cls[0].PerfiosCaptured == false){
                System.debug('NP >> ApplicationScore  ApplicationId >>> '+cls[0].PerfiosCaptured +' '+ cls[0].ApplicationScore +' '+cls[0].ApplicationId);
                smsEmailMethod(cls[0].ApplicationId,Status);
            }
        }
    }

    //Backup of single code //v1.1
    /*public static void SendEmailnSMS(List<String> Appid){
        String Status = '';
        smsEmailMethod(Appid[0],Status);
    }*/

    webservice static void smsEmailMethod(String AppID,string Statustype)
    {
        try {
            List<genesis__Applications__c> App = [select id,Branch_Code__c,name,genesis__Account__r.Full_Name__c from genesis__Applications__c where id=:AppID];
            Branch_Master__c brMaster = [Select Id, CODCCBRN__c,Linked_RLPC__c, Division_Code__c From Branch_Master__c Where CODCCBRN__c=:app[0].Branch_Code__c limit 1];
            List <User> usrList =[Select ID,MobilePhone,email From User where Office_Code__c =:brMaster.CODCCBRN__c And Role_Name__c='Branch manager' AND IsActive =:True];      
            string message;
            String email;
            String mobileformat;
            if(Statustype =='' || Statustype == null){ //v1.1
                    message ='Application '+App[0].name+' for '+App[0].genesis__Account__r.Full_Name__c+' is eligible for Refer to Credit. Please check scorecard tab in LOS.';                
                }else{
                    message ='Application '+App[0].name+' for '+App[0].genesis__Account__r.Full_Name__c+' Refer to Credit request '+Statustype+'.';                
                }
            if(usrList.size() > 0){
                mobileformat=usrList[0].MobilePhone != null ? usrList[0].MobilePhone :'';
                email = usrList[0].email != null ? usrList[0].email : '';
            }
            if(mobileformat.length()==11 && mobileformat.charAt(0)==48) //08792319492
            {
                mobileformat=mobileformat.substring(1,11);
                mobileformat='91'+mobileformat;
                system.debug('mobileformat'+mobileformat);
                SMS_Services.sendSMSFutureCall(mobileformat,message);
                
            }
            else if(mobileformat.length()==10) //8792319492
            {
                mobileformat='91'+ mobileformat;
                SMS_Services.sendSMSFutureCall(mobileformat,message);
            }
            else if(mobileformat.length()==13 && mobileformat.charAt(0)==43 && mobileformat.charAt(1)==57 && mobileformat.charAt(2)==49) //+918792319492
            {
                mobileformat=mobileformat.substring(1,13);
                system.debug('mobileformat'+mobileformat);
                SMS_Services.sendSMSFutureCall(mobileformat,message);
            }
            else if(mobileformat.length()==14 && mobileformat.charAt(0)==48 && mobileformat.charAt(1)==48 && mobileformat.charAt(2)==57 && mobileformat.charAt(3)==49  ) //00918792319492
            {
                 mobileformat=mobileformat.substring(2,14);
                system.debug('mobileformat'+mobileformat);
                SMS_Services.sendSMSFutureCall(mobileformat,message);
            }
            else if(mobileformat.length()==12 && mobileformat.charAt(0)==57 && mobileformat.charAt(1)==49)
            {
                system.debug('mobileformat'+mobileformat);
                SMS_Services.sendSMSFutureCall(mobileformat,message);
            }
            if(email <> null || email <> ''){
                EmailMessages.sendEmail(email,message);
            } 
        } catch(Exception ex) {
            System.debug(ex.getMessage());
            HandleBusinessException.captureError('Send_sms_RMD','SendSMS', ex);
        }
    }

    // Wrapper class for getiing values from PB //v1.1
    global class WrapperClass 
    {
        @InvocableVariable
        global ID ApplicationId;
        
        @InvocableVariable
        global Decimal ApplicationScore;

        @InvocableVariable
        global Decimal PCutoffScore;

        @InvocableVariable
        global Decimal PReferralCutOff;

        @InvocableVariable
        global Decimal NPCutoffScore;

        @InvocableVariable
        global Decimal NPReferralCutOff;

        @InvocableVariable
        global Boolean PerfiosCaptured;

        @InvocableVariable
        global Boolean ScoreOverride; // true if in referral band
    }
}