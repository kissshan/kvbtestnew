@isTest
public class Test_DigioSignerStatus_ResWrapper {
    @isTest
    public static void method1(){
        String json=	
            '{'+
            '"agreement_type":"outbound" '+
            '}';
        
        DigioSignerStatus_ResWrapper.parse(json);
        
    }
}