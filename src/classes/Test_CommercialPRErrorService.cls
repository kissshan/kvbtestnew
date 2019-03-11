@isTest
public class Test_CommercialPRErrorService {

    @isTest
    public static void method1(){
        
        String json=		'{'+
		'	"acct": {'+
		'		"Name": "ppppppo99999",'+
		'		"AccId": "0017F00000iDjlH"'+
		'		'+
		'	}'+
		'}';
         CommercialPRErrorService.parse(json);
        
    }
    
   
}