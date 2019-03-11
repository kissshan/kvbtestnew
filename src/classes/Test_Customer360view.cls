/*
* Description : to cover test code for Customer360view class
* Author       : Vignesh
*
*/

@isTest
public class Test_Customer360view {
    @isTest
    public static void method1(){
        
        String json=	
            '{'+
            
            '"LOS_APPLICATION_NAME":"Test" '+
            '}';
        Customer360view.parse(json);
    }
    @isTest
    public static void method2(){
        Customer360view  view=new Customer360view();
        Customer360view.cls_FINANCIAL_SECTION ob9=new Customer360view.cls_FINANCIAL_SECTION();
        Customer360view.cls_FINANCIAL_SECTION ob10 =new Customer360view.cls_FINANCIAL_SECTION('test','7627',7.9);
        Customer360view.cls_COLLATERAL_SECURITIES ob=new Customer360view.cls_COLLATERAL_SECURITIES();
        Customer360view.STOCK_BELOW_LIMIT ob2=new Customer360view.STOCK_BELOW_LIMIT();
        Customer360view.cls_GROUP_CONCERN_DETAILS ob3=new Customer360view.cls_GROUP_CONCERN_DETAILS ();
       // Customer360view.cls_GROUP_CONCERN_DETAILS ob4=new Customer360view.cls_GROUP_CONCERN_DETAILS('AAAPL1234C','FIRM_RELATED_NAME','Axis','50000','primary');
        
        
    }
}