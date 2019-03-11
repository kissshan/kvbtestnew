/*
* Name          : PerfiosStatusReport
* Description   : Structurize Perfios data, for status report
* Author        : Venu gopal
*/
public class PerfiosStatusReportHL{
	public cls_Status Status;
	public class cls_Status {
		public String files;	//available
		public String parts;	//1
		public String processing;	//completed
		public String txnId;	//ae348f79-d0e8-bddf-c9ff-2edca11f2496
		public cls_Part Part;
	}
	public class cls_Part {
		public String errorCode;	//E_NO_ERROR
		public String perfiosTransactionId;	//AE241522146923157
		public String reason;	//
		public String status;	//success
	}
	public static PerfiosStatusReportHL parse(String json){
        System.debug('json'+json);
        System.debug('jkkk'+System.JSON.deserialize(json, PerfiosStatusReportHL.class));
		return (PerfiosStatusReportHL) System.JSON.deserialize(json, PerfiosStatusReportHL.class);
	}
}