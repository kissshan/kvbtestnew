@isTest
public class Test_OperationalData_response {

    @isTest
    public static void method1(){
        String json=		'{'+
		'	"OperationalData_response": {'+
		'		"bpms_error_code": "ppppppo99999"'+
		'	}'+
		'}';
        OperationalData_response.parse(json);
    }
}