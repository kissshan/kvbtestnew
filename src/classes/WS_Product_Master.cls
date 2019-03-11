/*
* Name      : WS_Product_Master.
* Company   : ET Marlabs
* Purpose   : Used to Update or Insert Product Master Information. 
* Author    : Raushan
*/
public class WS_Product_Master {
    
    public static void masterRequest(){
        try{
            List<clcommon__CL_Product__c> otherListProduct  =   new List<clcommon__CL_Product__c>();
            List<clcommon__CL_Product__c> listProduct       =   new List<clcommon__CL_Product__c>();
            List<String> custIdList                         =   new List<String>();
            List<String> prodCodeNameList                   =   new List<String>();
            List<clcommon__CL_Product__c> masterProdList    =   new List<clcommon__CL_Product__c>();
            
            String LOS_PRO_WC       =   '';
            String LOS_PRO_TL       =   ''; 
            
            WS_Product_Master.Request_Product   req         =   new WS_Product_Master.Request_Product();
            req.exe_tenantId                                =   'cuecent_tenant';
            req.owner_tenantId                              =   'cuecent_tenant';
            req.inputVariables                              =    new WS_Product_Master.cls_inputVariables();
            
            Map<String,String> headerMap                 = new Map<String,String>();
            headerMap.put('Content-Type','application/json');
            HTTPResponse response                                   = new HTTPResponse(); 
            
            for(Integer retryCount = 0;retryCount < 3; retryCount++){
                try{
                    response = HttpUtility.sendHTTPRequest(Utility.getEndpoint('PRODUCT_MASTER_API'), 'POST', null,JSON.serialize(req),headerMap,label.CA_CERTIFICATE);
                    String jsonString = response.getBody();
                    If(response.getStatusCode() ==200 || response.getStatusCode() ==201){
                        prodCodeNameList.add('Working Capital');
                        prodCodeNameList.add('TERM LOAN');
                        masterProdList = [SELECT Id,Los_Customer_Id__c,clcommon__Product_Name__c FROM clcommon__CL_Product__c WHERE clcommon__Product_Name__c IN : prodCodeNameList AND RecordType.developerName = 'Product_Master'];
                        WS_Product_Master.Response_Product resObj   =   (WS_Product_Master.Response_Product)Json.deserialize(jsonString, WS_Product_Master.Response_Product.class);
                        If(resObj.out_msg.ErrorCode == '0'){
                            for(clcommon__CL_Product__c masterProd : masterProdList){
                                if(masterProd.clcommon__Product_Name__c == 'Working Capital') LOS_PRO_WC = masterProd.Los_Customer_Id__c;
                                if(masterProd.clcommon__Product_Name__c == 'TERM LOAN') LOS_PRO_TL = masterProd.Los_Customer_Id__c;
                            }
                            List<String> listDeveloperName = new List<String>{'Product_Child'};
                                Map<String,id> recordtypeIdMap = Utility.getRecordTypeID(listDeveloperName);
                            for(WS_Product_Master.cls_Product_Master    productObj  : resObj.out_msg.Product_Master) {
                                //System.debug('LOS_PRODUCT_CODE:::'+productObj.LOS_PRODUCT_CODE);
                                clcommon__CL_Product__c productObject           = new clcommon__CL_Product__c();    
                                If(productObj !=null){
                                    If(!Utility.ISStringBlankorNull(productObj.PRODUCT_NAME))
                                        productObject.clcommon__Product_Name__c =   productObj.PRODUCT_NAME;
                                    If(!Utility.ISStringBlankorNull(productObj.AGRI_PROP))
                                        productObject.Agri_Prop__c              =   productObj.AGRI_PROP;
                                    If(!Utility.ISStringBlankorNull(productObj.AVAIL_DUR_AGAINST_SANCTION_LETTER_MONTH))
                                        productObject.Avail_Dur_Against_Sanction_Letter_Month__c    =   Decimal.valueOf(productObj.AVAIL_DUR_AGAINST_SANCTION_LETTER_MONTH);
                                    If(!Utility.ISStringBlankorNull(productObj.BEP_CHECK))
                                        productObject.BEP_Check__c              =   productObj.BEP_CHECK;
                                    If(!Utility.ISStringBlankorNull(productObj.BOOKDEBIT_CHECK))
                                        productObject.Bookdebit_Check__c            =   productObj.BOOKDEBIT_CHECK;
                                    If(!Utility.ISStringBlankorNull(productObj.COMMITMENT_CHARGES))
                                        productObject.Commitment_Charges__c     =   Decimal.valueOf(productObj.COMMITMENT_CHARGES);
                                    If(!Utility.ISStringBlankorNull(productObj.DSCR_CHECK))
                                        productObject.DSCR_Check__c             =    productObj.DSCR_CHECK;
                                    If(!Utility.ISStringBlankorNull(productObj.EXP_DED_FOR_PROC_CHRG))
                                        productObject.Exp_Ded_For_Proc_Chrg__c  =    productObj.EXP_DED_FOR_PROC_CHRG;
                                    If(!Utility.ISStringBlankorNull(productObj.EXPOSURE_FORMULA_CHECK))
                                        productObject.Exposure_Formula_Check__c =    productObj.EXPOSURE_FORMULA_CHECK;
                                    If(!Utility.ISStringBlankorNull(productObj.FACILITY_CATEGORY_DESCRIPTION))
                                        productObject.Facility_Category_Description__c  =   productObj.FACILITY_CATEGORY_DESCRIPTION;
                                    If(!Utility.ISStringBlankorNull(productObj.FACILITY_CATEGORY))
                                        productObject.Facility_Category__c      =   productObj.FACILITY_CATEGORY;
                                    If(!Utility.ISStringBlankorNull(productObj.FACILITY_CODE)){
                                        productObject.Facility_Code__c          =   productObj.FACILITY_CODE; 
                                        If(productObj.FACILITY_CODE.endsWithIgnoreCase('WC')){
                                            productObject.Product_Master__r     =   new clcommon__CL_Product__c(Los_Customer_Id__c = LOS_PRO_WC);  
                                        }
                                        else if(productObj.FACILITY_CODE.endsWithIgnoreCase('TL')){
                                            productObject.Product_Master__r     =   new clcommon__CL_Product__c(Los_Customer_Id__c = LOS_PRO_TL);  
                                        } 
                                    }
                                    If(!Utility.ISStringBlankorNull(productObj.FACILITY_ID))
                                        productObject.Facility_Id__c                =   Integer.valueOf(productObj.FACILITY_ID);
                                    If(!Utility.ISStringBlankorNull(productObj.HOLIDAY_PERIOD))
                                        productObject.Holiday_Period__c         =   Integer.valueOf(productObj.HOLIDAY_PERIOD);
                                    If(!Utility.ISStringBlankorNull(productObj.INTEREST_AS_PER_CIRC))
                                        productObject.Interest_As_Per_CIRC__c       =    productObj.INTEREST_AS_PER_CIRC;
                                    If(!Utility.ISStringBlankorNull(productObj.INTEREST_CALCULATION_METHOD))
                                        productObject.Interest_Calculation_Method__c    =   productObj.INTEREST_CALCULATION_METHOD;
                                    If(!Utility.ISStringBlankorNull(productObj.LIEN_EXPOSURE))
                                        productObject.LIEN_Exposure__c          =    productObj.LIEN_EXPOSURE;
                                    If(!Utility.ISStringBlankorNull(productObj.LOS_PRODUCT_CODE)){
                                        custIdList.add(productObj.LOS_PRODUCT_CODE);
                                        productObject.Los_Customer_Id__c            =   productObj.LOS_PRODUCT_CODE;
                                    }
                                    If(!Utility.ISStringBlankorNull(productObj.MAX_AMOUNT))
                                        productObject.Max_Amount__c             =   Decimal.valueOf(productObj.MAX_AMOUNT);
                                    If(!Utility.ISStringBlankorNull(productObj.MAX_PERIOD))
                                        productObject.Max_Period__c             =   Double.valueOf(productObj.MAX_PERIOD);
                                    If(!Utility.ISStringBlankorNull(productObj.MIN_AMOUNT))
                                        productObject.Min_Amount__c             =   Decimal.valueOf(productObj.MIN_AMOUNT);
                                    If(!Utility.ISStringBlankorNull(productObj.MIN_CLAUSE_ROI_CHECK))
                                        productObject.Min_Clause_ROI_Check__c       =   productObj.MIN_CLAUSE_ROI_CHECK;
                                    If(!Utility.ISStringBlankorNull(productObj.MIN_PERIOD))
                                        productObject.Min_Period__c             =   Double.valueOf(productObj.MIN_PERIOD);
                                    If(!Utility.ISStringBlankorNull(productObj.MINIMUM_INTEREST))
                                        productObject.Minimum_Interest__c           =   Decimal.valueOf(productObj.MINIMUM_INTEREST);
                                    If(!Utility.ISStringBlankorNull(productObj.MODULE_TYPE))
                                        productObject.Module_Type__c                =   productObj.MODULE_TYPE;
                                    If(!Utility.ISStringBlankorNull(productObj.PEAK_NON_LEVEL_IS_NEED))
                                        productObject.Peak_Non_Level_Is_Need__c =   productObj.PEAK_NON_LEVEL_IS_NEED;
                                    If(!Utility.ISStringBlankorNull(productObj.PENAL_INTEREST))
                                        productObject.Penal_Interest__c         =   Decimal.valueOf(productObj.PENAL_INTEREST);
                                    If(!Utility.ISStringBlankorNull(productObj.PRE_CLOSURE_INTEREST_RATE))
                                        productObject.Pre_Closure_Interest_Rate__c =  Decimal.valueOf(productObj.PRE_CLOSURE_INTEREST_RATE);
                                    If(!Utility.ISStringBlankorNull(productObj.PRODUCT_CODE))
                                        productObject.Product_Code__c               =    productObj.PRODUCT_CODE;
                                    If(!Utility.ISStringBlankorNull(productObj.PRODUCT_TYPE))
                                        productObject.Product_Type__c               =   productObj.PRODUCT_TYPE;
                                    If(!Utility.ISStringBlankorNull(productObj.RATING_BASED_ROI))
                                        productObject.Rating_Based_ROI__c           =   productObj.RATING_BASED_ROI;
                                    If(!Utility.ISStringBlankorNull(productObj.RENEWABLE))
                                        productObject.Renewable__c              =   productObj.RENEWABLE;
                                    If(!Utility.ISStringBlankorNull(productObj.REPAYMENT_PERIOD_TYPE))
                                        productObject.Repayment_Period_Type__c  =   productObj.REPAYMENT_PERIOD_TYPE;
                                    If(!Utility.ISStringBlankorNull(productObj.SCHEDULE))
                                        productObject.Schedule__c                   =   productObj.SCHEDULE;
                                    If(!Utility.ISStringBlankorNull(productObj.SCHEMATIC_LOAN))
                                        productObject.Schematic_Loan__c         =   productObj.SCHEMATIC_LOAN;
                                    If(!Utility.ISStringBlankorNull(productObj.USANCE_CHECK))
                                        productObject.Usance_Check__c               =   productObj.USANCE_CHECK;
                                    If(!Utility.ISStringBlankorNull(productObj.WAREHOUSE_CHECK))
                                        productObject.Warehouse_Check__c            =   productObj.WAREHOUSE_CHECK;
                                    
                                    String recordTypeIDStr                      =   recordtypeIdMap.get('Product_Child');               
                                    productObject.RecordTypeId                  =   recordTypeIDStr;
                                    productObject.Active__c = true;
                                    
                                    listProduct.add(productObject);
                                }    
                            }   
                        }else{
                            throw new CustomException('Error occured in response while fetching Product master data');
                        }
                        If(!listProduct.isEmpty()){
                            upsert listProduct Los_Customer_Id__c;
                            otherListProduct = [SELECT Id,Active__c,Los_Customer_Id__c FROM clcommon__CL_Product__c WHERE Los_Customer_Id__c NOT IN :custIdList];
                            if(!otherListProduct.isEmpty()){
                                for(clcommon__CL_Product__c prod : otherListProduct){
                                    prod.Active__c = false;
                                }
                                UPDATE otherListProduct;
                                
                            }
                            break;
                        }
                    }
                }catch(Exception e){
                    System.debug(e.getStackTraceString());
                    if(retryCount == 2){
                        //Send Email
                        Utility.sendEmail('Product Master ',e.getMessage());
                        break;
                    }
                }
                
                if(retryCount == 2){
                    //Send Email
                    Utility.sendEmail('Product master ', 'Retry Failed'); 
                    break;
                }
            }
        }catch(Exception Ex){
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
            Utility.sendEmail('Product','Retry Failed');
            //throw new CustomException('Error occured in response while fetching Product master data'+Ex.getMessage()+'--'+Ex.getLineNumber()+'--'+Ex.getStackTraceString());
        }
    }
    
    //Request Format
    public class Request_Product{
        public String exe_tenantId; //cuecent_tenant
        public String owner_tenantId;   //cuecent_tenant
        public cls_inputVariables inputVariables;
    }
    public class cls_inputVariables {}
    
    //Response Format
    public class Response_Product{
        public String bpms_error_code;  //00
        public cls_out_msg out_msg;
        public String bpms_error_msg;   //Success
    }
    public class cls_out_msg {
        public String HttpStatus;   //500
        public String ErrorCode;    //MW9999
        public String ErrorMessage; //TECHNICAL ERROR
        public cls_Product_Master[] Product_Master;
    }
    public class cls_Product_Master {
        public String SALESFORCE_ID;    //
        public String PRODUCT_NAME; //Open Cash Credit
        public String AGRI_PROP;    //No
        public String AVAIL_DUR_AGAINST_SANCTION_LETTER_MONTH;  //
        public String BEP_CHECK;    //No
        public String BOOKDEBIT_CHECK;  //No
        public String COMMITMENT_CHARGES;   //
        public String DSCR_CHECK;   //
        public String EXP_DED_FOR_PROC_CHRG;    //No
        public String EXPOSURE_FORMULA_CHECK;   //No
        public String FACILITY_CATEGORY_DESCRIPTION;    //OPEN CASH CREDIT
        public String FACILITY_CATEGORY;    //OCC
        public String FACILITY_CODE;    //WC
        public String FACILITY_ID;  //1
        public String HOLIDAY_PERIOD;   //0
        public String INTEREST_AS_PER_CIRC; //No
        public String INTEREST_CALCULATION_METHOD;  //
        public String LIEN_EXPOSURE;    //No
        public String LOS_PRODUCT_CODE; //22300
        public String MAX_AMOUNT;   //99999
        public String MAX_PERIOD;   //12
        public String MIN_AMOUNT;   //0
        public String MIN_CLAUSE_ROI_CHECK; //No
        public String MIN_PERIOD;   //1
        public String MINIMUM_INTEREST; //
        public String MODULE_TYPE;  //c
        public String PEAK_NON_LEVEL_IS_NEED;   //Yes
        public String PENAL_INTEREST;   //
        public String PRE_CLOSURE_INTEREST_RATE;    //
        public String PRODUCT_CODE; //223
        public String PRODUCT_TYPE; //F
        public String RATING_BASED_ROI; //Yes
        public String RENEWABLE;    //Yes
        public String REPAYMENT_PERIOD_TYPE;    //MONTHLY
        public String SCHEDULE; //1@
        public String SCHEMATIC_LOAN;   //No
        public String USANCE_CHECK; //No
        public String WAREHOUSE_CHECK;  //No
    }    
}