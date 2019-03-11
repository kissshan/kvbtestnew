@isTest
public class Test_JsonUtilities {
    @isTest
    public static void method1(){
        String json=	
            '{'+
            '"appId":"2198928" '+
            '}';        
        JsonUtilities.getValuesFromJson(json);
    }
    
    @isTest
    public static void method2(){
        String json=	
            '{'+
            '"appId":"2198928" '+
            '}';        
        try{
            JsonUtilities.getValuesFromJson('json');}
        catch(Exception ex){
            System.debug('ex'+ex);
        }
    }
}