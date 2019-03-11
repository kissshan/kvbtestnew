@isTest
public class Test_Form26asResponse {
@isTest
    public static void method1(){
       String json=		'{'+
		'	"form26ASDetails": {'+
		'		"form26asInfo": [{'+
		'				"assessmentYear": "2016-17",'+
		'				"financialYear": "2015-16",'+
		'				"nonTdsList": [{'+
		'					"tax": "0",'+
		'					"date": "2017-01-18",'+
		'					"bsrCode": "192",'+
		'					"minorHead": "XXXXX########",'+
		'					"majorHead": "XXXXX########"'+
		'				}],'+
		'				"tdsList": []'+
		'			},'+
		'			{'+
		'				"assessmentYear": "2017-18",'+
		'				"financialYear": "2016-17",'+
		'				"tdsList": [],'+
		'				"nonTdsList": []'+
		'			},'+
		'			{'+
		'				"assessmentYear": "2018-19",'+
		'				"financialYear": "2017-18",'+
		'				"tdsList": [{'+
		'						"section": "194J",'+
		'						"deductor": "123 SOFTWARE SOLUTIONS",'+
		'						"tdsDate": "2018-01-18",'+
		'						"amount": "0",'+
		'						"tan": "XXXXX####X",'+
		'						"taxDeducted": "0"'+
		'					},'+
		'					{'+
		'						"section": "192",'+
		'						"deductor": "ABC SOFTWARE SOLUTIONS",'+
		'						"tdsDate": "2018-02-11",'+
		'						"amount": "0",'+
		'						"tan": "XXXXX####X",'+
		'						"taxDeducted": "0"'+
		'					}'+
		'				],'+
		'				"nonTdsList": []'+
		'			}'+
		'		],'+
		'		"personalInfo": {'+
		'			"address": "XXXXXXXXXX XXXXX ######",'+
		'			"dob": "01/01/1990",'+
		'			"name": "TAXPAYER",'+
		'			"pan": "ABCD1234Z",'+
		'			"panStatus": "Active"'+
		'		}'+
		'	}'+
		'}'+
		'';
        Form26asResponse.parse(json);
    }
}