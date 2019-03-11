/*
*   Name    : JocataListMatching_Model
*   purpose : This is the model class for Jocata List Matching classes
*   Author  : Numaan
*/ 
public class JocataListMatching_Model {
    
    public class JocataLMRequest{
        
        public String name; 
        public String customerId;   
        public String dob;  
        public String address;  
        public String city; 
        public String state;    
        public String country;  
        public String nationality;  
        public String docNumber;
        public String panId;   
        public String driverlicenseid;  
        public String adharNo;  
        public String rationCardNo; 
        public String phone1;   
        public String phone2;   
        public String email;    
        
    }
    
    public class JocataLMResponse{
        public cls_evokeResponse evokeResponse;
    }
    
    public class cls_evokeResponse {
        public String statusCode;   
        public String statusMessage;    
        public Integer txnId;   
    }
    
    public class JocataLMStatusResponse{
        public cls_responseResult responseResult;
        public String customerId;   //122
        
    }
    
    public class cls_responseResult {
        public String uniqueRequestId;  //ODA0180226115413734
        public boolean matchFlag;
        public cls_responseVOList[] responseVOList;
        public Decimal searchedDate;    //1519626253734
        public String searchedFor;  //Name : Vijay malya%%Customer ID : 122
    }
    public class cls_responseVOList {
        public String country;
        public cls_targetData targetData;
        public String din;
        public String cin;
        public String primaryName;  //VIJAY MALLYA
        public String phoneNo;
        public Integer entryId; //77930
        public String score;    //94.11764705882354
        public String passport;
        public String dob;
        public String customerId;
        public String voterId;
        public String alias;
        public String uidai;
        public String listName; //RBIDefaulter
        public String pan;
        public cls_fields[] fields;
        public String tinVat;
    }
 
    public class cls_targetData {
        public String OtherBank;    //SBI, AXIS BANK, BOI, CBI, IDBI, PNB ETC
        public String EntityName;   //KINGFISHER AIRLINES LTD
        public String Address;  //U B ANCHORAGE, 100/1, RICHMOND ROAD, BANGALORE
        public String State;    //MAHARASHTRA
        public String BKBR; //NARIMAN POINT
        public String BKNM; //BANK OF BARODA
        public String DirectorNames;    //AYANI KURUSSI RANDRANATH NEDUNGADI [Din : NA]</br>MANMOHANSINGH KAPUR [Din : NA]</br>V BHARATH [Din : NA]</br>VIJAY MALLYA [Din : NA]</br>SUBHASH GUPTE [Din : NA]</br>
    }
    public class cls_fields {
        public String targetData;   //vijay mallya
        public String sourceData;   //Vijay malya
        public String matchedField; //Name
    }

}