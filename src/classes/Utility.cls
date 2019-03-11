/* 
 * Name     : Utility
 * Purpose  : This class is used for re-usable methods.
 * Company  : ET Marlabs
 * Author   : Amritesh
-----------------------------------------------------------------------
Version  Date         Author             Remarks                                                 
=======   ==========   =============  ==================================
V1.1    03-Sep-2018    Braj             Added method getStateToBranchCodeMap(),getStateFromBranchCode() to get state from state master
*******************************************************************************************/
public class Utility {

    public static boolean runApplicationTrigger(){
        return Trigger_Setting__c.getOrgDefaults().Execute_Application_Trigger__c;
    }
    
    public static boolean runAccountTrigger(){
        return Trigger_Setting__c.getOrgDefaults().Execute_Account_Trigger__c;
    }
    
    //Check if string is blank or null
    public static boolean ISStringBlankorNull(string strVal){
        if(strVal == null || strVal == ''){
             return true;
        }else{
             return false;
        }       
    }
    
    public static Boolean isFirstTime = true;
    
    public static Integer convertMonthTextToNumber(String matrixMonth){
        if(matrixMonth == 'JAN'){
            return 1;   
        }else if(matrixMonth == 'FEB'){
            return 2;   
        }else if(matrixMonth == 'MAR'){
            return 3;   
        }else if(matrixMonth == 'APR'){
            return 4;   
        }else if(matrixMonth == 'MAY'){
            return 5;       
        }else if(matrixMonth == 'JUN'){            
            return 6;   
        }else if(matrixMonth == 'JUL'){
            return 7;   
        }else if(matrixMonth == 'AUG'){
            return 8;   
        }else if(matrixMonth == 'SEP'){
            return 9;   
        }else if(matrixMonth == 'OCT'){
            return 10;  
        }else if(matrixMonth == 'NOV'){
            return 11;  
        }else{
            return 12;
        }
    }
    public static Integer convertYearToDateToNumber(String matrixMonth){
        if(matrixMonth == 'April'){
            return 1;
        }else if(matrixMonth == 'Apr-May'){
            return 2;
        }else if(matrixMonth == 'Apr-Jun'){
            return 3;
        }else if(matrixMonth == 'Apr-Jul'){
            return 4;
        }else if(matrixMonth == 'Apr-Aug'){
            return 5;
        }else if(matrixMonth == 'Apr-Sept'){
            return 6;
        }else if(matrixMonth == 'Apr-Oct'){
            return 7;
        }else if(matrixMonth == 'Apr-Nov'){
            return 8;
        }else if(matrixMonth == 'Apr-Dec'){
            return 9;
        }else if(matrixMonth == 'Apr-Jan'){
            return 10;
        }else if(matrixMonth == 'Apr-Feb'){
            return 11;
        }else{
            return 12;
        }
    }
    
    //check if string is null then return blank
    public static string getBlankStringIfNull(string fieldVal){
        return fieldVal !=null?fieldVal:'';
    }
    
     /*
     * Method to  give endpoint url for given service name.
     * 
     */
    public static String getEndpoint(String serviceName){
        return KVB_Company_Details__c.getOrgDefaults().KVB_MW_Base_URL__c + KVB_Endpoint_URLs__c.getValues(serviceName).Endpoint_URL__c;  
    }
    
     /*
     * Method to  give endpoint url for given service name of Apigee.
     * 
     */
    public static String getEndpointApigee(String serviceName){
        return KVB_Company_Details__c.getOrgDefaults().APIgee_Base_URL__c + KVB_Endpoint_URLs__c.getValues(serviceName).Endpoint_URL__c;  
    }
    
    public static string getFullEndpoints(String serviceName){
        return KVB_Endpoint_URLs__c.getValues(serviceName).Endpoint_URL__c;
    }
    public static string getCommercialPR_APIGEE_Endpoint(String serviceName){
        return KVB_Endpoint_URLs__c.getValues(serviceName).Endpoint_URL__c;
    }
    
    // get CIBIL Value
   public static Decimal getCibilTScore(string Type){
        if(Type=='Cibil')
            return KVB_CIBIL__c.getOrgDefaults().Cibil_Score__c;
        if(Type=='Neg')
            return KVB_CIBIL__c.getOrgDefaults().NegativeValue__c;
        if(Type == 'PLCibil')
            return KVB_CIBIL__c.getOrgDefaults().PL_CibilLow__c;       
        return null;
    }
    // method to return zero if value is null or empty.
    public static Integer getExecuteBatch(){
        Decimal executeNumber = KVB_Company_Details__c.getOrgDefaults().Execute_Batch_in_days__c;
        if(executeNumber !=null){
            return Integer.valueOf(executeNumber.setScale(0));
        }else{
            return 0;
        }
    }
    /*
     * Method to get the template id from custom setting
     * 
     */
    public static String getDIGIOTemplateId(String templateName){
        system.debug('template NAme::: ' + templateName);
        try{    
            system.debug('DIGIO_Templates__c.getValues(templateName).Template_Unique_Id__c:-'+DIGIO_Templates__c.getValues(templateName).Template_Unique_Id__c);
            return DIGIO_Templates__c.getValues(templateName).Template_Unique_Id__c;
        }catch(Exception e){
            System.debug('templateName not found-'+templateName+ '\nException-'+e);
            //return null;
            throw new customException('Template Name not found-'+templateName);
        }
        
    }
    //Insert task
    public static Task createTask(String appId,String usrId, String subject, Decimal dueDays){
        Task tsk = new Task();
        tsk.WhatId = appId;
        tsk.OwnerId = usrId;
        tsk.ActivityDate = system.today()+(Integer)dueDays;
        tsk.Subject = subject;
        tsk.Status = 'Not Started';
        tsk.Pre_defined_task__c = true;
        INSERT tsk;
        RETURN tsk;
    }
    //Get Financial current Year
    public static Integer getCurrentYear(){
        Integer currentYear;
        if(Date.Today().Month() >= 4){
            currentYear = Date.Today().Year();
        }
        else{
            currentYear = (Date.Today().Year()-1);
        }
        RETURN currentYear;
    }
    
    /*
     @Purpose: Generate a random unique string.
     @returnType: string
    */
    public static String generateRandomString(){
        Integer len = 4;
        final String chars = '1234';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr+string.ValueOf(system.now().getTime()); 
    }
    //Check Decimal value is null
    public static Decimal isNullOrZeroDecimal(Decimal decVal){
        if(decVal == null || decVal == 0.0){
            RETURN 0.0;
        }
        else
            RETURN decVal;
    }
    public static Account getAccountdetails(string accId){

        return [SELECT Id,Name,Line_of_Activity__c,Limit_Assesment_Final_Financial_Year__c,Limit_Assesment_Final_Month__c,Limit_Assesment_Closing_Balance__c FROM Account where Id=:accId];
    }
    /*
     * Method to get recordtypeId by developerName.
     * 
     */
    public static Map<String,id> getRecordTypeID(List<String> recTypeDevName) {
        Map<String,id> recordTypeMap = new Map<String,id>();
        Map<Id,RecordType> recTypeMap = new Map<Id,RecordType>();
        recTypeMap = new Map<Id,RecordType>([select id,Name,developerName from recordtype where developerName IN :recTypeDevName]);
        if(!recTypeMap.keySet().isEmpty()){
            for(Id recTypeId : recTypeMap.keySet()){
                recordTypeMap.put(recTypeMap.get(recTypeId).developerName,recTypeId);
                recordTypeMap.put(recTypeMap.get(recTypeId).Name,recTypeId);
            }
        }
        RETURN recordTypeMap ;
    } 
    public static Messaging.SingleEmailMessage getSingleEmailMsg(List<String> addList,String subject,String body){
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new List<String>(addList);
        message.subject = subject;
        message.plainTextBody = body;
        RETURN message;
    }
    
    public static List<Customer360view.STOCK_TEMPLATE> getStockTemplates(){
        List<Customer360view.STOCK_TEMPLATE> doclist    = new List<Customer360view.STOCK_TEMPLATE>();
        
        Customer360view.STOCK_TEMPLATE  stock   = new Customer360view.STOCK_TEMPLATE();
        stock.TEMPLATE_LABEL                    = 'STOCK_TEMPLATE';
        stock.TEMPLATE_LINK                     = System.label.STOCK_STATEMENT;
        doclist.add(stock);
        Customer360view.STOCK_TEMPLATE  debt    = new Customer360view.STOCK_TEMPLATE();
        debt.TEMPLATE_LABEL                     = 'DEBTORS_TEMPLATE';
        debt.TEMPLATE_LINK                      = System.label.Debtors_Statement;
        doclist.add(debt);
        Customer360view.STOCK_TEMPLATE  credt   = new Customer360view.STOCK_TEMPLATE();
        credt.TEMPLATE_LABEL                    = 'CREDITORS_TEMPLATE';
        credt.TEMPLATE_LINK                     = System.label.Creditors_Statement;
        doclist.add(credt);
        
        return doclist;
    }
    
    public static set<String> getLast3MonthList(){
        
        integer currentMonth = Date.Today().Month();
        integer last1Month   = 0;
        integer last2Month   = 0;
        
        if(currentMonth == 1){
            last1Month   = 12;
        }else{
            last1Month   = currentMonth - 1;
        }
        
        if(last1Month == 1){
            last2Month   = 12;
        }else{
            last2Month   = last1Month - 1;
        }
        Set<string> months  = new Set<String>{getMonthName(currentMonth),getMonthName(last1Month),getMonthName(last2Month)};
        return months;
    } 
    
    public static List<Customer360view.cls_STOCK_STATEMENT> getStockStatementDetails(string custId){
        integer currentMonth = Date.Today().Month();
        integer last1Month   = 0;
        integer last2Month   = 0;        
        if(currentMonth == 1){
            last1Month   = 12;
        }else{
            last1Month   = currentMonth - 1;
        }        
        if(last1Month == 1){
            last2Month   = 12;
        }else{
            last2Month   = last1Month - 1;
        }
        String year                     = String.ValueOf(Date.Today().YEAR());
        string currentMonthName         = getMonthName(currentMonth);
        string last1MonthName           = getMonthName(last1Month);
        string last2MonthName           = getMonthName(last2Month);
        Set<string> months              = new Set<String>{currentMonthName,last1MonthName,last2MonthName};
        Map<string,string> monthYrs     = new Map<String,string>();
        monthYrs.put(currentMonthName+year,currentMonthName);
        monthYrs.put(last1MonthName+year,last1MonthName);
        monthYrs.put(last2MonthName+year,last2MonthName);
            
        Map<string,Customer360view.STOCK_BELOW_LIMIT> belowLast3monthData   = getLast3MonthData(custId, year, months);
        Map<String,Stock_Statement__c> last3monthStockStatus                = Last3monthStockStatus(custId, year, months);
        Map<String,Debtors__c> last3monthDebitorstatus                      = Last3monthDebitorstatus(custId, year, months);
        Map<String,Sundry_Creditors__c> last3monthCreditorsStatus           = Last3monthCreditorsStatus(custId, year, months);
        
        List<Customer360view.cls_STOCK_STATEMENT> stockList                 = new List<Customer360view.cls_STOCK_STATEMENT>();
        for(string monthYr  : monthYrs.keySet()){
            boolean belowFlag   = false;
            boolean aboveSFlag  = false;
            boolean aboveDFlag  = false;
            boolean aboveCFlag  = false;
            Customer360view.cls_STOCK_STATEMENT stk = new Customer360view.cls_STOCK_STATEMENT();
            stk.year                        = year;
            stk.month                       = monthYrs.get(monthYr);
            stk.belowLimit                  = new Customer360view.STOCK_BELOW_LIMIT();
            stk.aboveLimit                  = new Customer360view.STOCK_ABOVE_LIMIT();
            stk.aboveLimit.STOCK_STATUS     = new Customer360view.cls_STATUS();    
            stk.aboveLimit.DEBTORS_STATUS   = new Customer360view.cls_STATUS();    
            stk.aboveLimit.CREDITORS_STATUS = new Customer360view.cls_STATUS();    
            if(belowLast3monthData.containsKey(monthYr)){
              stk.belowLimit    =  belowLast3monthData.get(monthYr);
              belowFlag         =  true;
            }
            if(last3monthStockStatus.containsKey(monthYr)){
                stk.aboveLimit.STOCK_STATUS.status  = 'Completed';
                aboveSFlag                          = true;
            }else{
                stk.aboveLimit.STOCK_STATUS.status  = 'Pending';
            }
            if(last3monthDebitorstatus.containsKey(monthYr)){
                stk.aboveLimit.DEBTORS_STATUS.status    = 'Completed';
                aboveDFlag                              = true;
            }else{
                stk.aboveLimit.DEBTORS_STATUS.status    = 'Pending';
            }
            if(last3monthCreditorsStatus.containsKey(monthYr)){
                stk.aboveLimit.CREDITORS_STATUS.status  = 'Completed';
                aboveCFlag                              = true;
            }else{
                stk.aboveLimit.CREDITORS_STATUS.status  = 'Pending';
            }
            
            if(belowFlag || (aboveSFlag && aboveDFlag && aboveCFlag)){
                stk.status  = 'Completed';
            }else{
                stk.status  = 'Pending';
            }
            stockList.add(stk);
        }
        return stockList;
    }
    
    // Return last 3 month Stock data for customers exposure limit <25lac
    public static Map<string,Customer360view.STOCK_BELOW_LIMIT> getLast3MonthData(string custId, string year,Set<string> months){
        
        Map<String,Customer360view.STOCK_BELOW_LIMIT> values    = new Map<String,Customer360view.STOCK_BELOW_LIMIT>();
        
        List<Stock_Below_Limit__c> stocks   = new List<Stock_Below_Limit__c>();
        stocks  = [Select id,Stocks__r.Month__c,Opening_Stock__c,Purchases__c,Sales__c,Sundry_Creditors__c,Sundry_Debtors__c
                   from Stock_Below_Limit__c where Stocks__r.Account__r.CBS_Customer_ID__c =:custId AND
                   Stocks__r.Year__c =:year AND Stocks__r.Month__c IN :months];
        for(Stock_Below_Limit__c s : stocks){
            Customer360view.STOCK_BELOW_LIMIT blimit    = new Customer360view.STOCK_BELOW_LIMIT();                
            blimit.OPENING_STOCK    = s.Opening_Stock__c!=null?String.ValueOf(s.Opening_Stock__c):'';
            blimit.PURCHASE         = s.Purchases__c!=null?String.ValueOf(s.Purchases__c):'';
            blimit.SALES            = s.Sales__c!=null?String.ValueOf(s.Sales__c):'';
            blimit.SUNDRY_DEBT      = s.Sundry_Debtors__c!=null?String.ValueOf(s.Sundry_Debtors__c):'';
            blimit.SUNDRY_CREDIT    = s.Sundry_Creditors__c!=null?String.ValueOf(s.Sundry_Creditors__c):'';
            blimit.LOS_RECORD_ID    = s.Id;
            values.put(s.Stocks__r.Month__c+year,blimit);
        }        
        
        return values;
    }
    
    public static Map<String,Stock_Statement__c> Last3monthStockStatus(string custId, string year, Set<string> months){
        
        Map<String,Stock_Statement__c> statusList   = new Map<String,Stock_Statement__c>();
        List<Stock_Statement__c> stocks = new List<Stock_Statement__c>();
        stocks  = [Select id,Stocks__r.Year__c,Stocks__r.Month__c from Stock_Statement__c where Stocks__r.Account__r.CBS_Customer_ID__c =:custId AND
                   Stocks__r.Year__c =:year AND Stocks__r.Month__c IN :months];
        for(Stock_Statement__c s : stocks){
            statusList.put(s.Stocks__r.Month__c+year,s);
        }
        return statusList;
    }
    public static Map<String,Debtors__c> Last3monthDebitorstatus(string custId, string year, Set<string> months){
        
        Map<String,Debtors__c> statusList   = new Map<String,Debtors__c>();
        List<Debtors__c> stocks = new List<Debtors__c>();
        stocks  = [Select id,Stocks__r.Year__c,Stocks__r.Month__c from Debtors__c where Stocks__r.Account__r.CBS_Customer_ID__c =:custId AND
                   Stocks__r.Year__c =:year AND Stocks__r.Month__c IN :months];
        for(Debtors__c s : stocks){
            statusList.put(s.Stocks__r.Month__c+year,s);
        }
        return statusList;
    }
    public static Map<String,Sundry_Creditors__c> Last3monthCreditorsStatus(string custId, string year, Set<string> months){
        
        Map<String,Sundry_Creditors__c> statusList  = new Map<String,Sundry_Creditors__c>();
        try{           
            List<Sundry_Creditors__c> stocks    = new List<Sundry_Creditors__c>();
            stocks  = [Select id,Stocks__r.Year__c,Stocks__r.Month__c from Sundry_Creditors__c where Stocks__r.Account__r.CBS_Customer_ID__c =:custId AND
                       Stocks__r.Year__c =:year AND Stocks__r.Month__c IN :months];
            for(Sundry_Creditors__c s : stocks){
                statusList.put(s.Stocks__r.Month__c+year,s);
            }
        }catch(Exception e){}
        return statusList;
    }

    public static string getMonthName(integer monthNo){
        if(monthNo  == 1)
            return 'JAN';
        else if(monthNo== 2)
            return 'FEB';
        else if(monthNo== 3)
            return 'MAR';
        else if(monthNo== 4)
            return 'APR';
        else if(monthNo== 5)
            return 'MAY';
        else if(monthNo== 6)
            return 'JUN';
        else if(monthNo== 7)
            return 'JUL';
        else if(monthNo== 8)
            return 'AUG';
        else if(monthNo== 9)
            return 'SEP';
        else if(monthNo== 10)
            return 'OCT';
        else if(monthNo== 11)
            return 'NOV';
        else if(monthNo== 12)
            return 'DEC';
        else
            return '';
    }
    //Date Formatter (EX.  DD-Mar-YY)
    public static string dateFormatter() {
        Integer month = System.today().Month();
        Integer day = System.today().day();
        String year = String.valueOf(System.today().year());
        year = year.subString(year.length()-2,year.length());
        String mm = getMonthName(month);
        String Dated = day+'-'+mm+'-'+year;
        return Dated;
    }
    //Date Formatter (Ex. DD-Mar-YYYY)
     public static string dateFormatter(Date d) {
        Integer month = d.Month();
        Integer day = d.day();
        Integer year = d.year();
        String mm = getMonthName(month);
        String Dated = day+'-'+mm+'-'+year;
        return Dated;
    }
    public static genesis__Applications__c getAppDocumInfo(string documentId){
        return [Select id,Sanction_Letter_Name__c from genesis__Applications__c where RecordType.DeveloperName ='SME_Renewal' AND Sanction_ESign_Id__c =:documentId limit 1];
    }
    
    //Send Email helper method for masters
    public static void sendEmail(String masterName,string errorMessage){
        List<String> emailAddList = new List<String>();
        String emailSubject = 'Master sync failed!';
        String body = masterName+' sync failed with error:- '+errorMessage;
        emailAddList = KVB_Company_Details__c.getOrgDefaults().Admin_email__c.split(';');
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = emailAddList;
        message.setSubject(emailSubject);
        message.setReplyTo('support@kvb.com');
        message.setSenderDisplayName('KVB TEAM');
        message.setBccSender(false);
        message.setHtmlBody(body);
        //System.debug(message);
        
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
    }
    
      public static Set<String> getDashboardAccessdesignations(){
        Set<String> roleNames    = new Set<String>();
        try{
            for(Underwriting_Dashboard_Access__mdt mdt : [Select id,Label,developerName from Underwriting_Dashboard_Access__mdt]){
                roleNames.add(mdt.Label);
            }
        }catch(Exception e){}
        return roleNames;
    }
    public static Boolean getFiscalYearFlag(String dateString){
         Integer currentYear              = getCurrentYear();
         String cyString                  = String.valueOf(currentYear);
         String currFiscalYear            = (currentYear-1)+'-'+Integer.valueOf(cyString.subString(cyString.length()-2,cyString.length()));
         String nthFiscalYear             = (currentYear-2)+'-'+Integer.valueOf(String.valueOf(currentYear-1).subString(String.valueOf(currentYear-1).length()-2,String.valueOf(currentYear-1).length()));
         String n_1_FiscalYear            = (currentYear-3)+'-'+Integer.valueOf(String.valueOf(currentYear-2).subString(String.valueOf(currentYear-1).length()-2,String.valueOf(currentYear-1).length()));

         String fiscalYearStr             =  getFiscalYearByDate(dateString);
         
         If(fiscalYearStr !=null && fiscalYearStr !=''){
            If(currFiscalYear.equals(fiscalYearStr)){
                return true;
            }else If(nthFiscalYear.equals(fiscalYearStr)){
                return true;
            }else If(n_1_FiscalYear.equals(fiscalYearStr)){
                return true;
            }
         }
        return false;
    }
    public static String getFiscalYearByDate(String dateString){
        If(dateString !=null && dateString !=''){
            String yearString        = dateString.split('-')[0];
            Integer yearInt          = Integer.valueOf(yearString);
            String fiscalYearStr     = (yearInt-1)+'-'+Integer.valueOf(yearString.subString(yearString.length()-2,yearString.length()));

            return fiscalYearStr;
        }
        return '';
    }

    public static DateTime getLocalDateAndTime(){
         Datetime now        = Datetime.now();
         Integer offset      = UserInfo.getTimezone().getOffset(now);
         Datetime localTime  = now.addSeconds(offset/1000);
        return localTime;   
    }
    public static Map<String,String> getNatureOfPropertyByCode(){
        Map<String,String> mapOfNatureOfProperty	= new Map<String,String>();
        List<Immovable_Master__mdt> listOfImmovable = [select id,Code__c,DeveloperName,MasterLabel from Immovable_Master__mdt];
        If(listOfImmovable !=null && listOfImmovable.size() > 0){
            for(Immovable_Master__mdt	immovableMasterObj : listOfImmovable){
                If(immovableMasterObj !=null){
                    If(!mapOfNatureOfProperty.containsKey(immovableMasterObj.Code__c)){
                        mapOfNatureOfProperty.put(immovableMasterObj.Code__c,immovableMasterObj.MasterLabel);
                    }
                }
            }
        }
        If(mapOfNatureOfProperty.size()>0){
           return mapOfNatureOfProperty; 
        }
        return null;
    }
   //Switch case for return month range on specific  Number
    public static String getMonthRange(Integer num){
        If(num !=null && num > 0){
            switch on num {
                when 1 {
                    return 'Apr';
                }
                when 2 {
                    return 'Apr-May';
                }
                when 3 {
                    return 'Apr-Jun';
                }
                when 4 {
                    return 'Apr-Jul';
                }
                when 5 {
                    return 'Apr-Aug';
                }
                when 6 {
                    return 'Apr-Sep';
                }
                when 7 {
                    return 'Apr-Oct';
                }
                when 8 {
                    return 'Apr-Nov';
                }
                when 9 {
                    return 'Apr-Dec';
                }
                when 10 {
                    return 'Apr-Jan';
                }
                when 11 {
                    return 'Apr-Feb';
                }
                when 12 {
                    return 'Apr-Mar';
                }
                when else {
                    return '';
                }
            }
        }
        return '';
    }
    
    public static String getStateFromBranchCode(String branchCode){
        try {
            If(branchCode !=null && branchCode !=''){
                Branch_Master__c branchMaster = [select id, CODCCBRN__c, State__c from Branch_Master__c where CODCCBRN__c=:branchCode Limit 1];
                return branchMaster!=null?branchMaster.State__c:'';
            }
        } catch(QueryException e) {
            System.debug('No record found!!'+e.getMessage());
            return '';
        }
        return '';
    }

    public static Map<String, String> getStateToBranchCodeMap(){
        Map<String, String> stateMap = new Map<String, String>();
        for(Branch_Master__c bm : [select id, CODCCBRN__c, State__c from Branch_Master__c]){
            stateMap.put(bm.CODCCBRN__c, bm.State__c);
        }
        System.debug('stateMap:::'+stateMap);
        return stateMap;
    }
    public static Boolean checkIFTaskIsClosed(string appId,String taskSubject) {

        try {
            List<Task> getExistingTaskList                                              = new List<Task>();
            getExistingTaskList                                                         = [SELECT Id FROM Task where WhatId=:appId and Subject =:taskSubject And Status='Completed'];
            if(getExistingTaskList != null && !getExistingTaskList.isEmpty())
                return getExistingTaskList.size()==1?true:false;
            else
                    return false;
        } catch (Exception e) {
            HandleBusinessException.captureError('Utility', 'checkIFTaskIsClosed', e);
            return false;
        }

    }

    public static List<String> sendMissingYearsFinancials(Date dateofincorporation){
        List<String> missingyears=new List<String>();
        //Boolean subtractyear=false;
        Integer yearofdateofIncorporation=0;
        Date lastfiscalyear;
        Date latestyearfinancial;
        Try{
        if(date.today().month() <=3){
             lastfiscalyear=date.newInstance(date.today().year()-1,3,31);
        }
        latestyearfinancial=date.newInstance(lastfiscalyear.year(),1,1);
        
        //System.debug('lastfiscalyear '+lastfiscalyear);
        Date maxfinancialyeardetails=date.newInstance(lastfiscalyear.year()-2,3,31);
        //System.debug('maxfinancialyeardetails '+maxfinancialyeardetails);
        //System.debug(maxfinancialyeardetails-3);
        yearofdateofIncorporation=dateofincorporation.year();
        if((dateofincorporation) <= (maxfinancialyeardetails)){
            System.debug('same 3 years');
            missingyears.add((maxfinancialyeardetails.year()-1)+'-'+String.valueOf(maxfinancialyeardetails.year()).substring(2));
            missingyears.add((maxfinancialyeardetails.year())+'-'+String.valueOf((maxfinancialyeardetails.year()+1)).substring(2));
            missingyears.add((maxfinancialyeardetails.year()+1)+'-'+String.valueOf((maxfinancialyeardetails.year()+2)).substring(2));
        }
        else {
            if((dateofincorporation) >= (maxfinancialyeardetails+1)){
                System.debug(maxfinancialyeardetails.year());
                System.debug((dateofincorporation.year())-(maxfinancialyeardetails.year()));
                if(((maxfinancialyeardetails.year())-(dateofincorporation.year())) ==0){
                    missingyears.add(dateofincorporation.year()+'-'+String.valueOf((dateofincorporation.year()+1)).substring(2));
                    missingyears.add(((dateofincorporation.year())+1)+'-'+String.valueOf(((dateofincorporation.year())+2)).substring(2));
                }
                else if(((dateofincorporation.year())-(maxfinancialyeardetails.year())) ==1){
                    if(dateofincorporation.month()==1 || dateofincorporation.month()==2 || dateofincorporation.month()==3){
                        missingyears.add(((dateofincorporation.year())-1)+'-'+String.valueOf(((dateofincorporation.year()))).substring(2));
                        missingyears.add(((dateofincorporation.year()))+'-'+String.valueOf(((dateofincorporation.year())+1)).subString(2));
                    }
                    else{
                    missingyears.add(dateofincorporation.year()+'-'+String.valueOf(((dateofincorporation.year())+1)).substring(2));
                    }   
                }
                else if(latestyearfinancial <= dateofincorporation && dateofincorporation <= lastfiscalyear){
                    //System.debug('if date is in last 3 months of fiscal year ');
                    missingyears.add(((dateofincorporation.year())-1)+'-'+String.valueOf(((dateofincorporation.year()))).substring(2));
                }
            }
        }
        }
        catch(Exception ex){
            HandleBusinessException.captureError('Utility', 'sendMissingYearsFinancials', ex);
        }
        return missingyears;

    }

    public List<String> getDateinfinancialformat(List<String> stringFromYeardataconstant){

        List<String> retlist=new List<String>();
        For(String s:stringFromYeardataconstant){
            retlist.add(s.substring(2));
        }

        return retlist;

    }


     public static New_Loan_Input__c getNewLoanInputRecord(String appId){

        String query ='SELECT ';
        Map<String, Schema.SObjectField> accountFieldMap = Schema.getGlobalDescribe().get( 'New_Loan_Input__c' ).getDescribe().fields.getMap();
        for(Schema.SObjectField s : accountFieldMap.values()){
            query = query + s.getDescribe().getName()+',';
        }
        query   = query.removeEnd(',');
        query   = query + ' from New_Loan_Input__c WHERE Application__c =\''+appId+'\' LIMIT 1';

        New_Loan_Input__c newLoanInputrec = Database.query(query);
        /*if(newLoanInputrec!=null){
            return newLoanInputrec;
        }*/

        return newLoanInputrec;

    }


    public static Boolean isNewToBuisness(Date dateofincorporation){
        Integer incorporationYear = dateOfIncorporation.year();
        Integer currentYearIN      = Utility.getCurrentYear();
        if(dateofincorporation!=null){
            If(incorporationYear > (currentYearIN -1)){
                return true;
            }
        }
        return false;
    }
    public static Boolean isSRTO(String appId){
        List<New_Loan_Input__c> newLoanInput = new List<New_Loan_Input__c>();
        try{
            if(getNewLoanInputRecord(appId)!=null){
                newLoanInput.add(getNewLoanInputRecord(appId));
                //System.debug('newLoanInput[0].Future_Count_of_Vehicles__c==='+newLoanInput[0].Future_Count_of_Vehicles__c);
                //System.debug('Limit_Assessement__c.getValues(Vehicles Owned).Number_of_Vehicles__c=='+Limit_Assessement__c.getValues('Limit Parameters').Number_of_Vehicles__c);
                if(newLoanInput!=null && newLoanInput[0].Future_Count_of_Vehicles__c!=null && !newLoanInput.isEmpty()){
                    return newLoanInput[0].Future_Count_of_Vehicles__c <= Limit_Assessement__c.getValues('Limit Parameters').Number_of_Vehicles__c ? true :false;
                }
            }
        }
        catch(Exception ex){
            HandleBusinessException.captureError('Utility','isSRTO',ex);
            
        }
        return false;
    }

    /*public static Boolean checkIfSrtoOrNewToBuisness(Date dateofincorporation,String appid){

        try{
            if(dateofincorporation!=null){
        return isSRTO(appId);
    }
    }
    catch(Exception ex){
        HandleBusinessException.captureError('Utility','checkIfSrtoOrNewToBuisness',ex);
        return false;
    }
    return false;
}*/

    public static string getEnhancementExcludedStages(String settiname){
        return Term_Loan_Utility_Settings__c.getValues(settiname).Enhancement_Stages__c;
    }
    
    public static string dateFormatterNew() {
          DateTime yourDate = System.today();
          String dateOutput = yourDate.format('dd-MM-yyyy');
        return dateOutput;
    }
}