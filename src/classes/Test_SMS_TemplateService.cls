@isTest
public class Test_SMS_TemplateService {
@isTest
    public static void method1(){
        genesis__Applications__c app=TestUtility.intialSetUp('TestName',true);
         List<SMS_Tag_Mapping__mdt> tags = new List<SMS_Tag_Mapping__mdt>();
            tags= [Select id,Field_API_Name__c,Object_API_Name__c,Tag_Name__c,SMS_Content_Master__c
                       from SMS_Tag_Mapping__mdt where SMS_Content_Master__r.DeveloperName='SMSTEMP01' AND Object_API_Name__c='genesis__Applications__c'];

   
      SMS_TemplateService.getSMSConentForOneSobject(app.id, 'SMSTEMP01'); 
          } 
}