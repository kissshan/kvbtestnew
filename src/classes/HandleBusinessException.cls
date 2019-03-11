/* 
* @Description : This class is used to capture exception occured while apex code execution.
* 				 Note: This class/method should not be used if try/catch is inside a loop. 
* 				 As insert in not bulyfy in insertError method.
*Author :        Amritesh
*/ 
public class HandleBusinessException extends Exception {
    
    public static void captureError(String className, String methodName, Exception ex){
        clcommon__Log__c newException = createError(className, methodName, ex);
        insertError(newException);          
    }
    
    public static void captureError(String component, String errCode, string errMsg, String className, String methodName, Exception ex){
        clcommon__Log__c newException = createError(component,errCode,errMsg,className, methodName, ex);
        insertError(newException);          
    }
    
    private static clcommon__Log__c createError(String className, String methodName, Exception ex){
        clcommon__Log__c result 		= new clcommon__Log__c();
        result.Class_Name__c 			= className;
        result.Method_Name__c 			= methodName;
        result.clcommon__Message__c 	= ex.getMessage();
        result.Error_Stack_Trace__c		= ex.getStackTraceString();
        result.Error_Line_No__c			= ex.getLineNumber();
        result.clcommon__Type__c		= ex.getTypeName();
        
        return result;
    }
    
    private static clcommon__Log__c createError(String component, String errCode, string errMsg,String className, String methodName, Exception ex){
        clcommon__Log__c result 			= new clcommon__Log__c();
        result.Class_Name__c 				= className;
        result.Method_Name__c 				= methodName;
        result.clcommon__Message__c 		= ex.getMessage();
        result.Error_Stack_Trace__c			= ex.getStackTraceString();
        result.Error_Line_No__c				= ex.getLineNumber();
        result.clcommon__Type__c			= ex.getTypeName();
        result.Component__c					= component;
        result.Error_Code__c				= errCode;
        result.External_Error_Message__c 	= errMsg;
        return result;
    }
    
    private static void insertError(clcommon__Log__c exceps){
        try{
            Database.insert(exceps, false);
        }
        catch(DMLException dmlError){}
    }
}