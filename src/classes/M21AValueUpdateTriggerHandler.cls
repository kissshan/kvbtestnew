/* @Name           : M21AValueUpdateTriggerHandler
 * @Purpose        : To update value  field of clcommon__Collateral__c object and record type also at the same type
 * @Author         : Ashish Jain
 * @Date           : 10/05/2018 
*/ 
public class M21AValueUpdateTriggerHandler {

    public static void UpdateValueOnCollateral(List<M21_A__c> m21){
    
        List<clcommon__Collateral__c> collateralList = new List<clcommon__Collateral__c>();        
        
        try{
            for(M21_A__c mobj : m21){
                clcommon__Collateral__c colObj  = new clcommon__Collateral__c();
                colObj.Id                       = mObj.Collateral__c;
                colObj.clcommon__Value__c       = mobj.Estimated_value_Rs__c;
                //colObj.RecordTypeId = colRecType;
                
                collateralList.add(colObj);
            }
            update collateralList;
        }catch(Exception ex){
            system.debug('Exception::'+ex.getMessage());
        }
        //Id colRecType = Schema.SObjectType.clcommon__Collateral__c.getRecordTypeInfosByName().get('Land And Building').getRecordTypeId();

        
    }
}