/**
 * Created by ET-MARLABS on 10-06-2018.
 */
/*@IsTest(SeeAllData = false)*/
/**
* Create By Ajeet
 * Dyanmic Method created to be used in test class for creating test data
 * 1.Pass list of object name
 * 2.Pass map of (Field Api Name and its valuy)
 * 3.Pass List of Api Names
 */
public with sharing class TestUtil_SME {
    public static sobject createSobjectTypeRecord(String objectApiName,List<String> fieldsToMap,Map<String,Object> valuesByFieldMap){
        // Get Generic sobjectType;
        Schema.SObjectType convertType                  = Schema.getGlobalDescribe().get(objectApiName);
        Sobject genericObject                           = convertType.newSObject();

        Map<String, Schema.SObjectField> objectFieldMap = Schema.getGlobalDescribe().get(objectApiName).getDescribe().fields.getMap();
        Map<String, String> fieldsByType                = new Map<String, String>();
        //if(fieldsToMap != null && fieldsToMap.size()>0)
        for(Schema.SObjectField s : objectFieldMap.values()) {
            fieldsByType.put(String.valueOf(s.getDescribe().getName()),String.valueOf(s.getDescribe().getType()));
            //System.debug('@@@@--> '+s.getDescribe().getName()+' type of ' +s.getDescribe().getType());
            if(fieldsToMap != null && fieldsToMap.size()>0 && fieldsToMap.contains(s.getDescribe().getName()))
            {
                //System.debug('@@@--> '+s.getDescribe().getName()+' type of ' +s.getDescribe().getType());
                genericObject.put(s.getDescribe().getName(),getRandomValues(String.valueOf(s.getDescribe().getType())));
            }
        }
        if(valuesByFieldMap != null && !valuesByFieldMap.isEmpty()){
            for (String o:valuesByFieldMap.keySet()) {
               // genericObject.put(String.valueOf(o),valuesByFieldMap.get(o));
                if(fieldsByType.get(o) == 'STRING' || fieldsByType.get(o) == 'PICKLIST' || fieldsByType.get(o) == 'TEXTAREA' || fieldsByType.get(o) == 'TEXT'){
                    genericObject.put(String.valueOf(o),String.valueOf(valuesByFieldMap.get(o)));
                }else if(fieldsByType.get(o) == 'INTEGER'){
                    genericObject.put(String.valueOf(o),Integer.valueOf(valuesByFieldMap.get(o)));
                }else if(fieldsByType.get(o) == 'DOUBLE'){
                    genericObject.put(String.valueOf(o),Double.valueOf(valuesByFieldMap.get(o)));
                }else if(fieldsByType.get(o) == 'CURRENCY'){
                    genericObject.put(String.valueOf(o),Double.valueOf(valuesByFieldMap.get(o)));
                }else if(fieldsByType.get(o) == 'DATETIME'){
                    genericObject.put(String.valueOf(o),Datetime.valueOf(valuesByFieldMap.get(o)));
                }else if(fieldsByType.get(o) == 'DATE'){
                    genericObject.put(String.valueOf(o),Date.valueOf(valuesByFieldMap.get(o)));
                }else if(fieldsByType.get(o) == 'REFERENCE'){
                    genericObject.put(String.valueOf(o),String.valueOf(valuesByFieldMap.get(o)));
                }else if(fieldsByType.get(o) == 'BOOLEAN'){
                    genericObject.put(String.valueOf(o),Boolean.valueOf(valuesByFieldMap.get(o)));
                }else if(fieldsByType.get(o) == 'PHONE'){
                    genericObject.put(String.valueOf(o),String.valueOf(valuesByFieldMap.get(o)));
                }else if(fieldsByType.get(o) == 'EMAIL'){
                    genericObject.put(String.valueOf(o),String.valueOf(valuesByFieldMap.get(o)));
                }else if(fieldsByType.get(o) == 'PERCENT'){
                    //genericObject.put(String.valueOf(o),Integer.valueOf(valuesByFieldMap.get(o)));
                }

            }
        }

        //System.debug('@@@ genericObject--> '+genericObject);
        return genericObject;
    }

    public static Object getRandomValues(String typeOfRandomValues){
        if(typeOfRandomValues == 'STRING')
            return 'QQQQQQ';
        else if(typeOfRandomValues == 'INTEGER')
            return math.random();
        else
            return null;
    }



}