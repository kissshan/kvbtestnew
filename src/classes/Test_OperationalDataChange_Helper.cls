@isTest
public class Test_OperationalDataChange_Helper {
@isTest
    public static void method1(){
        String json=		'{'+
		'	"acct": {'+
		'		"bpms_error_code": "ppppppo99999",'+
		'		"AccId": "0017F00000iDjlH"'+
		'		'+
		'	}'+
		'}';
        
       OperationalData_response res=OperationalData_response.parse(json);
        Map<String,String> opsmap=new Map<String,String>();
        
        OperationalData_response.cls_Operational_Data opobj=new OperationalData_response.cls_Operational_Data();
        opobj.Customer_Id='2873';
       opsmap= OperationalDataChange_Helper.handleOpsData(opobj);
    }
}