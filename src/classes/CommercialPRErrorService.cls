/*
* Name    : CommercialPRErrorService
* Company  : ET Marlabs
* Purpose   : Request API for CommercialPR Error . 
* Author  : Raushan
*/
public class CommercialPRErrorService {
        public List<Out_msg> out_msg;
      
    public class Out_msg {
        public String CUST_LIST;
        public String Req_id;
        public String Ticket_id;
        public String ID;
        public String Response;
        public String Error;
        public String Date_Processed;
        public String Member_Code;
        public String Refrence_Number;
        public String Error_Description;  
       }
    
    public static CommercialPRErrorService parse(String json) {
        return (CommercialPRErrorService) System.JSON.deserialize(json, CommercialPRErrorService.class);
    }
    
}