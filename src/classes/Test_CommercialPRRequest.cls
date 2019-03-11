@isTest
public class Test_CommercialPRRequest {
 @isTest
    public static void method1(){
         String json=	
	'{'+

	'"exe_tenantId":"50000" '+
	
	'}';
     CommercialPRRequest.parse(json)  ; 
    }
    @isTest
    public static void method2(){
        CommercialPRRequest ob=new CommercialPRRequest();
    }
}