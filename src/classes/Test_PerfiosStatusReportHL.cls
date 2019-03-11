@isTest
public class Test_PerfiosStatusReportHL {

    @isTest
    public static void method1(){
        String json=		'{'+
		'	"PerfiosStatusReportHL": {'+
		'		"Status": "checked"'+
		'	}'+
		'}';
        PerfiosStatusReportHL.parse(json);
    }
}