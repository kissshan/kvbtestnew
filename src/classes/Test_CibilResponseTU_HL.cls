@isTest
public class Test_CibilResponseTU_HL {
@isTest
    public static void method1(){
        
        String json=	
	'{'+
	'"Status":"approved" '+
	'}';
      CibilResponseTU_HL.parse(json);
    }
}