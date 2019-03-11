/*
 * Name         : SMS_TemplateService
 * Description  : Handle Dynamic rendering of SMS content
 * Author       : Amritesh
*/
public class SMS_TemplateService {
    
    public static string getSMSConentForOneSobject(Id sRecordId ,string smsTemplateId){
        try{
            String sObjectName  = String.ValueOf(sRecordId.getsobjecttype());
            String smsBody      = '';
            List<SMS_Tag_Mapping__mdt> tags = new List<SMS_Tag_Mapping__mdt>();
            tags    = [Select id,Field_API_Name__c,Object_API_Name__c,Tag_Name__c,SMS_Content_Master__c
                       from SMS_Tag_Mapping__mdt where SMS_Content_Master__r.DeveloperName =: smsTemplateId 
                       AND Object_API_Name__c =:sObjectName];
            System.debug('tags=='+tags);
            Map<String,String> tagFieldMap = new Map<String,String>();
            string query = 'Select ';
            for(SMS_Tag_Mapping__mdt tag : tags){
                tagFieldMap.put('{{'+tag.Tag_Name__c+'}}', tag.Field_API_Name__c);
                query += tag.Field_API_Name__c+',';
            }
            query   = query.removeEnd(',')+' from '+sObjectName+' where Id=:sRecordId limit 1';
            System.debug('query=='+query);
            System.debug('tagFieldMap=='+tagFieldMap);
            sObject resultObject    = DataBase.query(query);
            System.debug('resultObject'+resultObject);
            //System.debug('resultObject=='+resultObject.Owner.name);
            Map<String,Object> resltMap = new Map<String,Object>();
            resltMap                    = resultObject.getPopulatedFieldsAsMap();
            System.debug('resltMap=='+resltMap);
            smsBody                     = [Select SMS_Body__c from SMS_Content_Master__mdt 
                                           where DeveloperName =:smsTemplateId limit 1].SMS_Body__c;
            
            for(string s : tagFieldMap.keySet()){
                System.debug('s=='+s); 
                System.debug('smsBody=='+smsBody);   
                System.debug('tagFieldMap.get(s)==='+tagFieldMap.get(s)); 
                System.debug('mapval'+String.ValueOf(resltMap.get(tagFieldMap.get(s))));       
                if(smsBody != null && resltMap.containsKey(tagFieldMap.get(s))){                                                                         
                    smsBody = smsBody.replace(s, String.ValueOf(resltMap.get(tagFieldMap.get(s))));
                }
            }
            return smsBody;
        }catch(Exception ex){
            return null;
        }        
    }
}