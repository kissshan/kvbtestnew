//written by prashant singh
@isTest
public class Test_Send_sms_RMD {
    @testsetup
    public static void setup(){
        genesis__Applications__c app=TestUtility.intialSetUp('HomeLoan',true); 
        Branch_Master__c brmas=new Branch_Master__c();
        brmas.CODCCBRN__c='1858';//app.branch_Code__c;
        brmas.Retail_Category__c='A';
        brmas.NAMCCCITY__c='CHENNAI';
        insert brmas;       
    }
    
    @istest
    static void method1(){
        
        //  list<UserRole> ur=new list<UserRole>([select id,name from UserRole]);
        list<Branch_Master__c> br=new list<Branch_Master__c>([select id,CODCCBRN__c from Branch_Master__c]);
        User user1 = getUser();
        list<user> usr=new list<user>([select id,UserName,MobilePhone,Office_Code__c from user where  UserName='ashishjain@ajab.com' limit 1]);
        usr[0].Office_Code__c = br[0].CODCCBRN__c;
        usr[0].MobilePhone='00918792319492';
        
        update usr[0];
        system.debug('usr'+usr);
        list<genesis__Applications__c> app=new list<genesis__Applications__c>([select id from genesis__Applications__c]);
        string id=app[0].id;
        try
        {
            Send_sms_RMD.smsEmailMethod(id,'Approved');
        }catch(exception e)
        {
            system.debug('exception:--'+e);
        }
    }
    public static user getUser(){
        UserRole ur=new UserRole(name='Branch manager');
        insert ur;
        Profile prof = new Profile();       
        
        prof = [select id from Profile where name ='System Administrator' limit 1];
        User usrId = new User(Alias = 'standt', Email='ashish.jain@etmarlabs.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',profileid =prof.id, 
                              LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles', UserName='ashishjain@ajab.com',UserRoleId=ur.id);
        insert usrId;
        return usrId;
        
    }
    
     @istest
    static void method2(){
        
        //  list<UserRole> ur=new list<UserRole>([select id,name from UserRole]);
        list<Branch_Master__c> br=new list<Branch_Master__c>([select id,CODCCBRN__c from Branch_Master__c]);
        User user1 = getUser();
        list<user> usr=new list<user>([select id,UserName,MobilePhone,Office_Code__c from user where  UserName='ashishjain@ajab.com' limit 1]);
        usr[0].Office_Code__c = br[0].CODCCBRN__c;
        usr[0].MobilePhone='+918792319492';
        
        update usr[0];
        system.debug('usr'+usr);
        list<genesis__Applications__c> app=new list<genesis__Applications__c>([select id from genesis__Applications__c]);
        string id=app[0].id;
        try
        {
            Send_sms_RMD.smsEmailMethod(id,'Approved');
        }catch(exception e)
        {
            system.debug('exception:--'+e);
        }
    }
      
     @istest
    static void method3(){
        
        //  list<UserRole> ur=new list<UserRole>([select id,name from UserRole]);
        list<Branch_Master__c> br=new list<Branch_Master__c>([select id,CODCCBRN__c from Branch_Master__c]);
        User user1 = getUser();
        list<user> usr=new list<user>([select id,UserName,MobilePhone,Office_Code__c from user where  UserName='ashishjain@ajab.com' limit 1]);
        usr[0].Office_Code__c = br[0].CODCCBRN__c;
        usr[0].MobilePhone='8792319492';
        
        update usr[0];
        system.debug('usr'+usr);
        list<genesis__Applications__c> app=new list<genesis__Applications__c>([select id from genesis__Applications__c]);
        string id=app[0].id;
        try
        {
            Send_sms_RMD.smsEmailMethod(id,'Approved');
        }catch(exception e)
        {
            system.debug('exception:--'+e);
        }
    }
    
    
    @istest
    static void method4(){
        
        //  list<UserRole> ur=new list<UserRole>([select id,name from UserRole]);
        list<Branch_Master__c> br=new list<Branch_Master__c>([select id,CODCCBRN__c from Branch_Master__c]);
        User user1 = getUser();
        list<user> usr=new list<user>([select id,UserName,MobilePhone,Office_Code__c from user where  UserName='ashishjain@ajab.com' limit 1]);
        usr[0].Office_Code__c = br[0].CODCCBRN__c;
        usr[0].MobilePhone='08792319492';
        
        update usr[0];
        system.debug('usr'+usr);
        list<genesis__Applications__c> app=new list<genesis__Applications__c>([select id from genesis__Applications__c]);
        string id=app[0].id;
        try
        {
            Send_sms_RMD.smsEmailMethod(id,'Approved');
        }catch(exception e)
        {
            system.debug('exception:--'+e);
        }
    }
    @istest
    static void method5(){
        
        //  list<UserRole> ur=new list<UserRole>([select id,name from UserRole]);
        list<Branch_Master__c> br=new list<Branch_Master__c>([select id,CODCCBRN__c from Branch_Master__c]);
        User user1 = getUser();
        list<user> usr=new list<user>([select id,UserName,MobilePhone,Office_Code__c from user where  UserName='ashishjain@ajab.com' limit 1]);
        usr[0].Office_Code__c = br[0].CODCCBRN__c;
        usr[0].MobilePhone='918792319492';
        
        update usr[0];
        system.debug('usr'+usr);
        list<genesis__Applications__c> app=new list<genesis__Applications__c>([select id from genesis__Applications__c]);
        string id=app[0].id;
        try
        {
            Send_sms_RMD.smsEmailMethod(id,'Approved');
        }catch(exception e)
        {
            system.debug('exception:--'+e);
        }
    }
    @istest
    public static void method6(){
        list<genesis__Applications__c> app=new list<genesis__Applications__c>([select id from genesis__Applications__c]);
        string id=app[0].id;
        Send_sms_RMD.WrapperClass wr=new Send_sms_RMD.WrapperClass();
        wr.ApplicationScore=456;
        wr.ApplicationId=id;
        List<Send_sms_RMD.WrapperClass> WrapRequest =new List<Send_sms_RMD.WrapperClass>();
        WrapRequest.add(wr);
        Send_sms_RMD.SendEmailnSMS(WrapRequest);
        
    }

}