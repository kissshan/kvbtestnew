/*
* Name      : Application_AssessmentCtrl
* Company   : ET Marlabs
* Purpose   : Controller class for Application_AssessmentVf page.
* Author    : Raushan
*/
public class Application_AssessmentCtrl {
    
    genesis__Applications__c appObj = new genesis__Applications__c(); // APP-0000227628
    List<M68_Balance_Sheet_Analysis__c> mBalancesheetList = new List<M68_Balance_Sheet_Analysis__c>();
    public Funded_Facilities fundedFacilitiesObj {get;set;}
    public static decimal newLoanMBFPValue = 0.0;
    public static decimal itemAB           = 0.0;
    //public static decimal itemAB           = 0.0;
    
    //public genesis__Applications__c genappaccountdetails{get;set;}
    public Id appId                                     {get;set;}
    Decimal estimated_NetSale                           {get;set;}
    Decimal projected_NetSale                           {get;set;}
    double netWorking_Capital_Est                       {get;set;}
    double netWorking_Capital_Proj                      {get;set;}
    double estimated_Purchases                          {get;set;}
    double OverallExposure;
    
    public static string  nextEstFYFullYear             {get;set;}
    public static string  currFYFullYear                {get;set;}
    public static string  nextEstFiscalYear             {get;set;}
    public static String  applicationId;
    public static Boolean renderIfTypeNotNTB            {get;set;}
    public Static Boolean renderIfTypeNotNTC            {get;set;}
    Public Static Boolean renderLess                    {get;set;}
    Public Static Boolean renderLess1                   {get;set;}
    Public Static Boolean renderLess2                   {get;set;}
    public static boolean rendergreater                 {get;set;}
    public static boolean rendergreater1                {get;set;}
    public static boolean rendergreater2                {get;set;}
    public static boolean renderNTB                     {get;set;}
    public static boolean renderNTB1                    {get;set;}
    public static boolean renderNTB2                    {get;set;}
    public static boolean lessThanOneYearNTB            {get;set;}
    public Static Decimal creditSummation               {get;set;}
    public static Decimal averageMonthlyCreditSummation {get;set;}
    Public Static Decimal MPBF                          {get;set;}
    public Static String  mentionMonth                  {get;set;}
    public Static String  fromDate                      {get;set;}
    public Static String  toDate                        {get;set;}
    public Static String  applicationName               {get;set;}
    public static String  accountName                   {get;set;}
    Public Static Decimal gstsalesforFY                 {get;set;}
    public Static Decimal AnnualizedGSTsales            {get;set;}
    public Static Decimal  Previousyearsales            {get;set;}
    public static Decimal  Eligiblelimit1               {get;set;}
    public static Decimal  Eligiblelimit2               {get;set;}
    public Decimal limitAssessment_Drawing              {get;set;}
    public Boolean CashBudget                           {get;set;}
    public String limit_final_year                      {get;set;}
    public String limit_final_month                     {get;set;}

    //Newly Added -- for Faclitywise PMAX1
    public List<pmaxOnewWrapper> facWisePMAX1WrapList {get;set;}

    
    List<String> financialTypeList = new List<String>{'Estimated','Projected','Actual'};
        //constructor 
        public Application_AssessmentCtrl(){
            try{
                if(applicationId == null)
                    appId = apexpages.currentpage().getparameters().get('id');
                else
                    appId = applicationId;

                    facWisePMAX1WrapList = new List<pmaxOnewWrapper>();
                
                renderIfTypeNotNTC = false;
                renderLess         = false;
                renderLess1        = false;
                renderLess2        = false;
                rendergreater      = false;
                rendergreater1     = false;
                rendergreater2     = false;
                lessThanOneYearNTB = false;
                renderNTB          = false;
                renderNTB1         = false;
                renderNTB2         = false;
                renderIfTypeNotNTB = false;
                //genappaccountdetails = new genesis__Applications__c();
                appObj = [select id,Name,New_to_Business__c,Borrower_Name__c,CreatedDate,Type__c,Overall_Exposure__c,RecordType.DeveloperName,Parent_Application__c,genesis__Account__c,Lead_Time__c,Usance_Period__c,Renewal_Due_Date__c,genesis__Account__r.Date_of_Incorporation__c,genesis__Account__r.Cash_Budget__c,genesis__Account__r.Limit_Assesment_Final_Financial_Year__c,genesis__Account__r.Limit_Assesment_Final_Month__c,genesis__Account__r.Limit_Assessment_Drawing_Power__c from genesis__Applications__c where id =:appId];
                //genappaccountdetails= [select id,genesis__Account__r.Cash_Budget__c,genesis__Account__r.Limit_Assesment_Final_Financial_Year__c,genesis__Account__r.Limit_Assesment_Final_Month__c,genesis__Account__r.Limit_Assessment_Drawing_Power__c from genesis__Applications__c where id =:appId limit 1];
                if(appObj !=null){
                    applicationName   = appObj.Name;
                    accountName       = appObj.Borrower_Name__c;
                    
                    System.debug('Application Details ----->'+ appObj);
                    //system.debug('appObj.New_to_Business__c::'+appObj.New_to_Business__c);
                    
                    
                    Integer currentYear = Utility.getCurrentYear();
                    String cyString = String.valueOf(currentYear);
                    String currentFY = (currentYear-1)+'-'+Integer.valueOf(cyString.subString(cyString.length()-2,cyString.length()));
                    String prevFY = (currentYear-2)+'-'+Integer.valueOf(String.valueOf(currentYear-1).subString(String.valueOf(currentYear-1).length()-2,String.valueOf(currentYear-1).length()));
                    String estimatedFY = currentYear+'-'+Integer.valueOf(String.valueOf(currentYear+1).subString(String.valueOf(currentYear+1).length()-2,String.valueOf(currentYear+1).length()));
                    String projectedFY = (currentYear+1)+'-'+Integer.valueOf(String.valueOf(currentYear+2).subString(String.valueOf(currentYear+2).length()-2,String.valueOf(currentYear+2).length()));
                    
                    List<String> fiscalyearList = new List<String>{estimatedFY,projectedFY,currentFY};
                        
                        OverallExposure= appObj.Overall_Exposure__c!=null ? appObj.Overall_Exposure__c : null;
                    
                    
                    If(appObj.genesis__Account__r.Cash_Budget__c !=null && appObj.genesis__Account__r.Cash_Budget__c){
                        CashBudget =    appObj.genesis__Account__r.Cash_Budget__c;         
                    }
                    If(appObj.genesis__Account__r.Limit_Assesment_Final_Financial_Year__c !=null){
                        limit_final_year    =   appObj.genesis__Account__r.Limit_Assesment_Final_Financial_Year__c;   
                    }
                    If(appObj.genesis__Account__r.Limit_Assesment_Final_Month__c !=null){
                        limit_final_month   =   appObj.genesis__Account__r.Limit_Assesment_Final_Month__c;   
                    }
                    If(appObj.genesis__Account__r.Limit_Assessment_Drawing_Power__c !=null){
                        limitAssessment_Drawing =  appObj.genesis__Account__r.Limit_Assessment_Drawing_Power__c;       
                    }
                    
                    mBalancesheetList = [select id,Fiscal_Year__c,Net_sales__c,Net_Working_Capital__c,Purchases__c,Account__c,Financial_type__c from M68_Balance_Sheet_Analysis__c where Account__c =:appObj.genesis__Account__c AND Fiscal_Year__c IN :fiscalyearList AND Financial_type__c IN :financialTypeList];
                    //AND Financial_type__c IN :financialTypeList
                    
                    if(mBalancesheetList !=null){
                        for(M68_Balance_Sheet_Analysis__c m68Obj : mBalancesheetList){
                            
                            if(m68Obj.Financial_type__c == 'Actual' && m68Obj.Fiscal_Year__c == currentFY) {
                                If(m68Obj.Net_Working_Capital__c != null){
                                    netWorking_Capital_Proj = m68Obj.Net_Working_Capital__c;//m68Obj.Net_Working_Capital__c!=null && m68Obj.Net_Working_Capital__c<0 ? 0.00 : m68Obj.Net_Working_Capital__c ; 
                                    netWorking_Capital_Est  = m68Obj.Net_Working_Capital__c; //m68Obj.Net_Working_Capital__c!=null && m68Obj.Net_Working_Capital__c<0 ? 0.00 : m68Obj.Net_Working_Capital__c ;
                                    system.debug('netWorking_Capital_Proj===> '+netWorking_Capital_Proj+' netWorking_Capital_Est===> '+netWorking_Capital_Est);
                                }  
                            }
                            if(m68Obj.Financial_type__c == 'Projected' && m68Obj.Fiscal_Year__c == projectedFY){
                                If(m68Obj.Net_sales__c !=null)
                                    projected_NetSale   = m68Obj.Net_sales__c;
                            }
                            if(m68Obj.Financial_type__c =='Estimated' && m68Obj.Fiscal_Year__c == estimatedFY){
                                System.debug('m68Obj.Net_sales__c'+m68Obj.Net_sales__c);
                                If(m68Obj.Net_sales__c !=null)
                                    estimated_NetSale   = m68Obj.Net_sales__c;
                                
                                If(m68Obj.Purchases__c != null)    
                                    estimated_Purchases = m68Obj.Purchases__c;
                            }
                        }
                        
                        
                    }
                    If(appObj.Renewal_Due_Date__c !=null && appObj.RecordType.DeveloperName== Constants.SME_APP_RECORD_TYPE){
                        fundedFacilitiesObj= new Funded_Facilities(estimated_NetSale,netWorking_Capital_Est,estimated_Purchases,projected_NetSale,netWorking_Capital_Proj,appObj.Lead_Time__c,appObj.Usance_Period__c,appObj.Renewal_Due_Date__c,OverallExposure);       
                    }else if(Constants.SME_RECORD_TYPE_LIST.contains(appObj.RecordType.DeveloperName) ){//appObj.Parent_Application__c !=null){
                        //genesis__Applications__c parentApp = [select id,Renewal_Due_Date__c from genesis__Applications__c where id =: appObj.Parent_Application__c];
                        //If(parentApp !=null && parentApp.Renewal_Due_Date__c !=null){
                        fundedFacilitiesObj= new Funded_Facilities(estimated_NetSale,netWorking_Capital_Est,estimated_Purchases,projected_NetSale,netWorking_Capital_Proj,appObj.Lead_Time__c,appObj.Usance_Period__c,appObj.CreatedDate.date(),OverallExposure);               
                        //}
                        System.debug('$$$$$$$$$$$$'+fundedFacilitiesObj);
                    } 
                } 
                if(appObj.New_to_Business__c){
                    calculateLimitAssessmentForNTB(appObj.genesis__Account__c,appId,appObj.genesis__Account__r.Date_of_Incorporation__c);
                }
                else if(appObj.Type__c != null && appObj.Type__c.contains('New to credit')){
                    calculateLimitAssessmentForNTC(appObj.genesis__Account__c,appId);
                }
                facWisePMAX1WrapList = getAllPrimarySecuredApplicationCollaterals(appObj.Id);
                //facWisePMAX1WrapList = getAllPrimarySecuredApplicationCollaterals(appObj.Id+'abc');
                
            }catch(Exception ex){
                System.debug('Exception'+ex.getStackTraceString());
                System.debug('Line Number'+ex.getLineNumber());
            }
        }
    
    //Method to calculate Facilities by Assessment. 
    public void calculateFLC_ILCAssessment(){
        double totalsum=0;
        try{
            fundedFacilitiesObj.facilityCategory ='';
            for(Facility__c facilityObj :[select id,Existing_Limit__c,CL_Product__r.Facility_Category__c,Application__r.Name from Facility__c where Application__r.id =:appId]){
                
                If(facilityObj !=null){
                    fundedFacilitiesObj.facilityCategory += facilityObj.CL_Product__r.Facility_Category__c;
                    If(facilityObj.CL_Product__r.Facility_Category__c =='ILC' || facilityObj.CL_Product__r.Facility_Category__c =='FLC'){
                        fundedFacilitiesObj.calculateEstimatedNetSaleILC();
                    }
                    
                    If(facilityObj.CL_Product__r.Facility_Category__c =='FLC' || facilityObj.CL_Product__r.Facility_Category__c =='PCFC' || facilityObj.CL_Product__r.Facility_Category__c =='FBN' || facilityObj.CL_Product__r.Facility_Category__c =='FBP' || facilityObj.CL_Product__r.Facility_Category__c =='EBD'){
                        If(facilityObj !=null){
                            If(facilityObj.Existing_Limit__c !=null){
                                totalsum += facilityObj.Existing_Limit__c;
                                fundedFacilitiesObj.totalLimitSum   = totalsum;
                                fundedFacilitiesObj.cELRequirement  = (totalsum*12.5)/100; 
                            }
                        }
                    }
                    
                    If(facilityObj.CL_Product__r.Facility_Category__c =='BG'){
                        If(facilityObj.Existing_Limit__c !=null){
                            fundedFacilitiesObj.existingBGlimit = facilityObj.Existing_Limit__c;
                            fundedFacilitiesObj.bglimit         = facilityObj.Existing_Limit__c; 
                        }
                    }   
                } 
            }
        }catch(Exception e){
            System.debug('Exception'+ e.getMessage());
            System.debug('Line Number'+ e.getLineNumber());
            
        }
    }      
    
    
    //Wrapper Class.
    public class Funded_Facilities{
        public Decimal estimated_sale               {get;set;}
        public Decimal projected_sale               {get;set;}      
        public Decimal working_Requirement          {get;set;}
        public Decimal borrowers_contribution       {get;set;}
        public Decimal nwcPrevYearBalanceEstimated  {get;set;}
        public Decimal nwcPrevYearBalanceProjected  {get;set;}
        public Decimal item                         {get;set;}
        public Decimal item2                        {get;set;}
        public Decimal smalleritem                  {get;set;}
        public double estimatedTotalPurchases       {get;set;}
        public Decimal leadTime                     {get;set;}
        public Decimal usancePeriod                 {get;set;}
        public double localPurchases                {get;set;}
        public Decimal totalNoofdays                {get;set;}
        public double requirementILC                {get;set;}
        public String facilityCategory              {get;set;}  
        public double totalLimitSum                 {get;set;}
        public double cELRequirement                {get;set;}
        public double existingBGlimit               {get;set;}
        public double bglimit                       {get;set;}
        public Date renewalDate                     {get;set;}
        public Integer month                        {get;set;}
        public Decimal sale                         {get;set;}
        public Decimal NWCperpreviousyear           {get;set;}
        
        //Constructor
        public Funded_Facilities(Decimal estimated_sale,Decimal nwcPrevYearBalanceEstimated,double estimatedTotalPurchases,Decimal projected_sale,Decimal nwcPrevYearBalanceProjected,Decimal leadTime,Decimal usancePeriod,Date renewalDate,Decimal appOverallExposure){
            If(estimated_sale !=null){
                this.estimated_sale = estimated_sale.setScale(1);    
            }
            this.nwcPrevYearBalanceEstimated = nwcPrevYearBalanceEstimated;
            this.estimatedTotalPurchases = estimatedTotalPurchases;
            If(projected_sale !=null){
                this.projected_sale = projected_sale.setScale(1);
            }
            this.nwcPrevYearBalanceProjected = nwcPrevYearBalanceProjected;
            this.leadTime = leadTime;
            this.usancePeriod = usancePeriod;
            this.renewalDate = renewalDate;
            month =renewalDate.month();
            try{
                If(month>=4 && month<=9){
                    If(estimated_sale !=null){
                        sale = estimated_sale.setScale(1);
                        NWCperpreviousyear = (appOverallExposure< 5000000) ? 0.0 : nwcPrevYearBalanceEstimated.setScale(1);
                        System.debug('NWCperpreviousyear=====> '+NWCperpreviousyear);
                        working_Requirement = ((sale*25)/100);
                        borrowers_contribution = ((sale*5)/100);
                        item = working_Requirement-borrowers_contribution;
                        If(NWCperpreviousyear !=null) 
                            item2 = working_Requirement-NWCperpreviousyear;
                        if(item < item2)
                            smalleritem = item.setScale(1);
                        else
                            smalleritem = item2.setScale(1);
                        itemAB = Math.min(smalleritem,5000000)/100000;//variable use for new to business.
                        /*newLoanMBFPValue = itemAB;// use for new to business.
system.debug('@@@@@::'+itemAB);*/
                    }
                    
                }else{
                    If(projected_sale !=null){
                        sale= projected_sale.setScale(1);
                        NWCperpreviousyear = (appOverallExposure< 5000000) ? 0.0 : nwcPrevYearBalanceProjected;
                        System.debug('NWCperpreviousyear=====> '+NWCperpreviousyear);
                        working_Requirement = ((sale*25)/100);
                        borrowers_contribution = ((sale*5)/100);
                        item = working_Requirement-borrowers_contribution;
                        If(NWCperpreviousyear !=null) 
                            item2 = working_Requirement-NWCperpreviousyear;
                        if(item < item2)
                            smalleritem = item.setScale(1);
                        else
                            smalleritem = item2.setScale(1);
                        itemAB = (Math.min(smalleritem,5000000)/100000).setScale(2);//variable use for new to business.
                        /*newLoanMBFPValue = itemAB;//use for new to business.
system.debug('#####::'+itemAB);*/
                    }
                    
                } 
            }catch(Exception e){
                System.debug('Exception'+ e.getMessage()); 
                System.debug('Line Number'+ e.getLineNumber()); 
            }
            
        }
        
        // Calculate Line Assessment by facility Category.
        public void calculateEstimatedNetSaleILC(){
            if(estimatedTotalPurchases !=null && usancePeriod !=null && leadTime !=null) {
                localPurchases =((estimatedTotalPurchases*90)/100);
                totalNoofdays = usancePeriod+leadTime;
                requirementILC = ((localPurchases*totalNoofdays)/360);
                
            }
            
        } 
        
    }  
    /*limit Assessement calculation for new to credit application*/
    Public static void calculateLimitAssessmentForNTC(String accId,String appId){
        try{
            nextEstFYFullYear = YearDataConstant.nextEstFYFullYear;
            currFYFullYear    = YearDataConstant.currFYFullYear;
            nextEstFiscalYear = YearDataConstant.nextEstFiscalYear;
            
            Decimal sumOfFacNewLimitAmmount                           = 0.0;
            renderIfTypeNotNTC                                        = true;
            List<GSTN_Info__c>                  GSTSalesChildCurrList = new List<GSTN_Info__c>();
            List<GSTN_Info__c>                  GSTSalesChildPrevList = new List<GSTN_Info__c>();
            List<Operations_Detail__c>          operationalDetailList = [SELECT id,FIN_CR_AMT__c,Fiscal_Year__c,Fiscal_Type__c,From_Date__c,To_Date__c FROM Operations_Detail__c WHERE Fiscal_Year__c =: nextEstFiscalYear AND Fiscal_Type__c = 'YTD' AND Account__c =: accId];
            List<Facility__c>                   facNewLimitAmmount    = [SELECT id,New_Limit_Amount__c FROM Facility__c WHERE Application__c =: appId];
            List<GSTN_Info__c>                  parentGSTNInfoList    = [SELECT id,Account__c,Months__c,Total_Sales__c,Year__c FROM GSTN_Info__c WHERE Account__c =: accId AND Recordtype.DeveloperName = 'Parent'ORDER BY Createddate DESC LIMIT 1];
            
            if(parentGSTNInfoList.size()>0){
                GSTSalesChildCurrList = [SELECT Total_Sales__c,Months__c FROM GSTN_Info__c WHERE Year__c =: nextEstFYFullYear AND Recordtype.DeveloperName = 'Child' AND Parent__c =: parentGSTNInfoList[0].Id ORDER BY Createddate DESC Limit 1];
                GSTSalesChildPrevList = [SELECT Total_Sales__c,Months__c FROM GSTN_Info__c WHERE Year__c =: currFYFullYear AND Recordtype.DeveloperName = 'Child' AND Parent__c =: parentGSTNInfoList[0].Id ORDER BY Createddate DESC Limit 1];
            }
            
            if(facNewLimitAmmount.size()>0){
                for(Facility__c facObj : facNewLimitAmmount){
                    sumOfFacNewLimitAmmount += facObj.New_Limit_Amount__c;
                }
            }
            if(sumOfFacNewLimitAmmount != null){
                if(sumOfFacNewLimitAmmount < 5000000){
                    if(GSTSalesChildCurrList.size()>0 &&  decimal.valueOf(GSTSalesChildCurrList[0].Months__c) != null && decimal.valueOf(GSTSalesChildCurrList[0].Months__c) >= 6 && GSTSalesChildCurrList[0].Total_Sales__c != null && GSTSalesChildCurrList[0].Total_Sales__c != 0.0){
                        renderLess1        = true;
                        gstsalesforFY      = ((GSTSalesChildCurrList[0].Total_Sales__c)/100000).setScale(2);
                        AnnualizedGSTsales = (gstsalesforFY *(12/decimal.valueOf(GSTSalesChildCurrList[0].Months__c))).setScale(2);
                        MPBF               = (AnnualizedGSTsales/4).setScale(2);
                        newLoanMBFPValue   = MPBF;
                        mentionMonth       = GSTSalesChildCurrList[0].Months__c;
                    }else if(GSTSalesChildPrevList.size()>0 && decimal.valueOf(GSTSalesChildPrevList[0].Months__c) == 12 && decimal.valueOf(GSTSalesChildPrevList[0].Months__c )!= null && GSTSalesChildPrevList[0].Total_Sales__c != null && GSTSalesChildPrevList[0].Total_Sales__c != 0.0){
                        renderLess2     = true;
                        gstsalesforFY    = (GSTSalesChildPrevList[0].Total_Sales__c/100000).setScale(2);
                        MPBF             = (gstsalesforFY/4).setScale(2);
                        newLoanMBFPValue = MPBF;
                        mentionMonth     = '12';
                    }else{
                        if(operationalDetailList.size()>0 && operationalDetailList[0].FIN_CR_AMT__c != null && operationalDetailList[0].FIN_CR_AMT__c != 0){
                            renderLess                    = true;
                            creditSummation               = (operationalDetailList[0].FIN_CR_AMT__c /100000).setScale(2);
                            averageMonthlyCreditSummation = (creditSummation/4).setScale(2);
                            MPBF                          = averageMonthlyCreditSummation.setScale(2);
                            newLoanMBFPValue              = MPBF;
                            fromDate                      = String.valueOf((operationalDetailList[0].From_Date__c).toStartOfMonth().format());
                            toDate                        = String.valueOf((operationalDetailList[0].To_Date__c).toStartOfMonth().format());
                        }
                    }
                    
                }else if(sumOfFacNewLimitAmmount >= 5000000){
                    if(GSTSalesChildCurrList.size()>0 &&  GSTSalesChildCurrList[0].Months__c != null && decimal.valueOf(GSTSalesChildCurrList[0].Months__c) >= 6  && GSTSalesChildCurrList[0].Total_Sales__c != null && GSTSalesChildCurrList[0].Total_Sales__c != 0.0){
                        rendergreater1     = true;
                        gstsalesforFY      = ((GSTSalesChildCurrList[0].Total_Sales__c)/100000).setScale(2);
                        AnnualizedGSTsales = (gstsalesforFY * (12/decimal.valueOf(GSTSalesChildCurrList[0].Months__c))).setScale(2);
                        MPBF               = AnnualizedGSTsales/4;
                        newLoanMBFPValue   = MPBF;
                        mentionMonth       = GSTSalesChildCurrList[0].Months__c;
                    }else if(GSTSalesChildPrevList.size()>0 && GSTSalesChildPrevList[0].Months__c != null && decimal.valueOf(GSTSalesChildPrevList[0].Months__c )== 12 && GSTSalesChildPrevList[0].Months__c != null && GSTSalesChildPrevList[0].Total_Sales__c != null && GSTSalesChildPrevList[0].Total_Sales__c != 0.0){
                        rendergreater2   = true;
                        gstsalesforFY    = (GSTSalesChildPrevList[0].Total_Sales__c/100000).setScale(2);
                        Eligiblelimit1   = (gstsalesforFY/4).setScale(2);
                        MPBF             = Eligiblelimit1;
                        newLoanMBFPValue = MPBF;
                        mentionMonth     = '12';
                    }else{
                        if(operationalDetailList.size()>0 && operationalDetailList[0].FIN_CR_AMT__c != null && operationalDetailList[0].FIN_CR_AMT__c != 0){
                            rendergreater    = true;
                            creditSummation  = (operationalDetailList[0].FIN_CR_AMT__c/100000).setScale(2);
                            Eligiblelimit1   = (creditSummation/4).setScale(2);
                            MPBF             = Eligiblelimit1;
                            newLoanMBFPValue = MPBF;
                            fromDate         = String.valueOf((operationalDetailList[0].From_Date__c).toStartOfMonth().format());
                            toDate           = String.valueOf((operationalDetailList[0].To_Date__c).toStartOfMonth().format());
                        }
                    }
                }
            }
        }catch(Exception e){
            system.debug('getLineNumber::::'+e.getLineNumber());
            system.debug('getMessage:::'+e.getMessage());
            system.debug('getStackTraceString:::'+e.getStackTraceString());
            //HandleBusinessException.captureError('Application_AssessmentCtrl', 'calculateLimitAssessmentForNTC', e);  
        }
        
    }
    
    public static void calculateLimitAssessmentForNTB(String accId,String appId,date datOfIncorporation){
        try{
            nextEstFYFullYear = YearDataConstant.nextEstFYFullYear;
            currFYFullYear    = YearDataConstant.currFYFullYear;
            nextEstFiscalYear = YearDataConstant.nextEstFiscalYear;
           
            renderIfTypeNotNTB = true;
            List<GSTN_Info__c>                  GSTSalesChildCurrList = new List<GSTN_Info__c>();
            List<GSTN_Info__c>                  GSTSalesChildPrevList = new List<GSTN_Info__c>();
            List<Operations_Detail__c>          operationalDetailList = [SELECT id,FIN_CR_AMT__c,Fiscal_Year__c,Fiscal_Type__c,From_Date__c,To_Date__c FROM Operations_Detail__c WHERE Fiscal_Year__c =: nextEstFiscalYear AND Fiscal_Type__c = 'YTD' AND Account__c =: accId];
            List<GSTN_Info__c>                  parentGSTNInfoList    = [SELECT id,Account__c,Months__c,Total_Sales__c,Year__c FROM GSTN_Info__c WHERE Account__c =: accId AND Recordtype.DeveloperName = 'Parent'ORDER BY Createddate DESC LIMIT 1];
            if(parentGSTNInfoList.size()>0){
                GSTSalesChildPrevList = [SELECT Total_Sales__c,Months__c FROM GSTN_Info__c WHERE Year__c =: currFYFullYear AND Recordtype.DeveloperName = 'Child' AND Parent__c =: parentGSTNInfoList[0].Id ORDER BY Createddate DESC Limit 1];
            }
            
            if(calculateFinancialOneYear(datOfIncorporation)){
                if(GSTSalesChildPrevList.size()>0){
                    if(GSTSalesChildPrevList[0].Months__c != null && decimal.valueOf(GSTSalesChildPrevList[0].Months__c ) == 12){
                        if(GSTSalesChildPrevList[0].Total_Sales__c != null && GSTSalesChildPrevList[0].Total_Sales__c != 0.0){
                            renderNTB        = true;
                            gstsalesforFY    = (GSTSalesChildPrevList[0].Total_Sales__c/100000).setScale(2);
                            if(gstsalesforFY/4 <= 50.00)
                                MPBF             = gstsalesforFY/4;
                            else
                                MPBF             = 50.00;
                            newLoanMBFPValue = Math.min(MPBF,50.00);
                        }
                    }else{
                        if(operationalDetailList.size()>0 && operationalDetailList[0].FIN_CR_AMT__c != null && operationalDetailList[0].FIN_CR_AMT__c != 0){
                            renderNTB1       = true;
                            creditSummation  = (operationalDetailList[0].FIN_CR_AMT__c/100000).setScale(2);
                            if(creditSummation/4 <= 50.00)
                                MPBF         = creditSummation/4;
                            else 
                                MPBF         = 50.00;
                            newLoanMBFPValue = Math.min(MPBF,50.00);
                            fromDate         = String.valueOf((operationalDetailList[0].From_Date__c).toStartOfMonth().format());
                            toDate           = String.valueOf((operationalDetailList[0].To_Date__c).toStartOfMonth().format());
                        }
                    }
                }
            }else{
                renderNTB2       = true;
                MPBF             = itemAB;
                newLoanMBFPValue = MPBF;
            }
        }catch(Exception e){
            system.debug('Line Number::'+e.getLineNumber());
            system.debug('Error Message::'+e.getMessage());
            system.debug('Exception::'+e.getStackTraceString());
        }
        
    }
    public static boolean calculateFinancialOneYear(date datOfIncorporation){
        try{
            system.debug('datOfIncorporation::'+datOfIncorporation);
            if(datOfIncorporation != null){
                Integer incorporationYear  =  Integer.valueOf(String.valueOf(datOfIncorporation).split('-')[0]);
                Integer currentYearIN      =  Utility.getCurrentYear();
                If(incorporationYear < (currentYearIN -1)){
                    return true;
                }
                else if(incorporationYear == (currentYearIN -1)){
                    Integer incorporationMonth  =  Integer.valueOf(String.valueOf(datOfIncorporation).split('-')[1]);
                    System.debug('incorporationMonth@@@@'+incorporationMonth);
                    if(incorporationMonth < 04 || incorporationMonth < 4){
                        return true;
                    }
                    return false;
                    
                }else{
                    return false;
                }
            }else{
                return false; 
            }
        }catch(Exception e){
            system.debug('Line Number::'+e.getLineNumber());
            system.debug('Error Message::'+e.getMessage());
            system.debug('Exception::'+e.getStackTraceString());
            return false;
        }
    }


    public static List<pmaxOnewWrapper> getAllPrimarySecuredApplicationCollaterals(String appId){
        try {
            List<genesis__Application_Collateral__c> appCollRecList =  [Select Id,Name,genesis__Collateral__r.Accessories_value__c,genesis__Collateral__r.Registration_cost__c,genesis__Collateral__r.clcommon__Insurance_Amount__c,genesis__Collateral__r.ExShow_Room_Price__c,genesis__Collateral__r.Name,Facility__r.BRE_Rate__c,genesis__Collateral__r.Total_Asset_Value__c,genesis__Collateral__r.Market_Value_2__c,Facility__c,Facility__r.Recommended_Rate__c,Facility__r.Tenure__c,Facility__r.Recommended_Limit__c,Facility__r.Name,genesis__Collateral__r.RecordType.DeveloperName,genesis__Collateral__c,Facility__r.App_Facility_Type__c,Facility__r.Margin__c,Facility__r.BRE_Limit__c,genesis__Collateral__r.Machinery_Cost__c,genesis__Collateral__r.Installation_Cost__c,genesis__Collateral__r.Other_Cost__c,genesis__Collateral__r.Tax__c,genesis__Collateral__r.Chassis_Cost__c,genesis__Collateral__r.Body_Building_Cost__c,genesis__Collateral__r.ExshowRoomPrice_Api__c from genesis__Application_Collateral__c where Application__c =:appId And Security_Type__c ='Primary Securities' And Facility__r.App_Facility_Type__c ='TL'];
            System.debug('appCollRecList'+appCollRecList.size());
            Map<String,pmaxOnewWrapper> facilityWisePmax1 = new Map<String,pmaxOnewWrapper>();
            Map<String,Decimal> facilityWiseMarginPart = new Map<String,Decimal>();

            for(genesis__Application_Collateral__c appColRec:appCollRecList){
                System.debug('appCollRecList'+appColRec);
                Decimal rateToBeApplyed = appColRec.Facility__r.Recommended_Rate__c != null?appColRec.Facility__r.Recommended_Rate__c:appColRec.Facility__r.BRE_Rate__c;
                Decimal minFromLimit = math.min(appColRec.Facility__r.Recommended_Limit__c != null?appColRec.Facility__r.Recommended_Limit__c:0.00,appColRec.Facility__r.BRE_Limit__c != null ?appColRec.Facility__r.BRE_Limit__c:0.00);
                Decimal EmiRequired = (LimitAssessmentHelper.getEmi(minFromLimit,appColRec.Facility__r.Tenure__c,rateToBeApplyed)).setScale(2);
                Decimal marginToBeConsiderd = appColRec.Facility__r.Margin__c != null ? appColRec.Facility__r.Margin__c:appColRec.Facility__r.BRE_Margin__c;
                Decimal marginPart = marginToBeConsiderd != null ? (1.00-marginToBeConsiderd/100.00):0.00;
                System.debug('Margin Part'+marginPart);

                if(marginPart != null){
                    facilityWiseMarginPart.put(appColRec.Facility__c,marginPart);
                }

                System.debug('minFromLimit'+minFromLimit);
                System.debug('Coll Name =>'+appColRec.genesis__Collateral__r.Name);
                if(appColRec.genesis__Collateral__r.RecordType.DeveloperName == TermLoanConstants.LAND_AND_BUILDING_RTDN){
                    if(!facilityWisePmax1.containsKey(appColRec.Facility__c)){
                        Decimal assetValue = appColRec.genesis__Collateral__r.Market_Value_2__c !=null ?appColRec.genesis__Collateral__r.Market_Value_2__c:appColRec.genesis__Collateral__r.Total_Asset_Value__c;
                        Decimal sumOfCostField = assetValue;
                        System.debug('sumOfCostField =>'+sumOfCostField);
                        facilityWisePmax1.put(appColRec.Facility__c ,new pmaxOnewWrapper(appColRec.Facility__r.Name,appColRec.Facility__c,sumOfCostField,EmiRequired) );


                    }else{

                        Decimal assetValue = appColRec.genesis__Collateral__r.Market_Value_2__c !=null ?appColRec.genesis__Collateral__r.Market_Value_2__c:appColRec.genesis__Collateral__r.Total_Asset_Value__c;
                        Decimal sumOfCostField = assetValue;
                        System.debug('facilityWisePmax1.get(appColRec.Facility__c).pmax1 =>'+facilityWisePmax1.get(appColRec.Facility__c).pmax1);
                        sumOfCostField                                                      = facilityWisePmax1.get(appColRec.Facility__c).pmax1 + sumOfCostField;
                        facilityWisePmax1.put(appColRec.Facility__c ,new pmaxOnewWrapper(appColRec.Facility__r.Name,appColRec.Facility__c,sumOfCostField,EmiRequired) );

                    }
                }else if(appColRec.genesis__Collateral__r.RecordType.DeveloperName == TermLoanConstants.COMMERCIAL_MACHINERY_RTDN){
                    if(!facilityWisePmax1.containsKey(appColRec.Facility__c)){

                        Decimal sumOfCostField = (appColRec.genesis__Collateral__r.Machinery_Cost__c != null ? appColRec.genesis__Collateral__r.Machinery_Cost__c : 0.00) + (appColRec.genesis__Collateral__r.Installation_Cost__c != null ? appColRec.genesis__Collateral__r.Installation_Cost__c : 0.00) +(appColRec.genesis__Collateral__r.Other_Cost__c != null ? appColRec.genesis__Collateral__r.Other_Cost__c : 0.00) + (appColRec.genesis__Collateral__r.Tax__c != null ? appColRec.genesis__Collateral__r.Tax__c : 0.00);
                        System.debug('sumOfCostField =>'+sumOfCostField);
                        facilityWisePmax1.put(appColRec.Facility__c ,new pmaxOnewWrapper(appColRec.Facility__r.Name,appColRec.Facility__c,sumOfCostField,EmiRequired) );

                    }else{


                        Decimal sumOfCostField = (appColRec.genesis__Collateral__r.Machinery_Cost__c != null ? appColRec.genesis__Collateral__r.Machinery_Cost__c : 0.00) + (appColRec.genesis__Collateral__r.Installation_Cost__c != null ? appColRec.genesis__Collateral__r.Installation_Cost__c : 0.00) + (appColRec.genesis__Collateral__r.Other_Cost__c != null ? appColRec.genesis__Collateral__r.Other_Cost__c : 0.00) + (appColRec.genesis__Collateral__r.Tax__c != null ? appColRec.genesis__Collateral__r.Tax__c : 0.00);
                        System.debug('facilityWisePmax1.get(appColRec.Facility__c).pmax1 =>'+facilityWisePmax1.get(appColRec.Facility__c).pmax1);
                        sumOfCostField                                                      = facilityWisePmax1.get(appColRec.Facility__c).pmax1 + sumOfCostField;
                        facilityWisePmax1.put(appColRec.Facility__c ,new pmaxOnewWrapper(appColRec.Facility__r.Name,appColRec.Facility__c,sumOfCostField,EmiRequired) );

                    }
                }else if(appColRec.genesis__Collateral__r.RecordType.DeveloperName == TermLoanConstants.CONSTRUCTION_EQUIPMENT_RTDN){
                    if(!facilityWisePmax1.containsKey(appColRec.Facility__c)){

                        Decimal sumOfCostField = (appColRec.genesis__Collateral__r.Machinery_Cost__c != null ? appColRec.genesis__Collateral__r.Machinery_Cost__c : 0.00) + (appColRec.genesis__Collateral__r.Installation_Cost__c != null ? appColRec.genesis__Collateral__r.Installation_Cost__c : 0.00) + (appColRec.genesis__Collateral__r.Other_Cost__c != null ? appColRec.genesis__Collateral__r.Other_Cost__c : 0.00) + (appColRec.genesis__Collateral__r.Tax__c != null ? appColRec.genesis__Collateral__r.Tax__c : 0.00);
                        System.debug('sumOfCostField =>'+sumOfCostField);
                        facilityWisePmax1.put(appColRec.Facility__c ,new pmaxOnewWrapper(appColRec.Facility__r.Name,appColRec.Facility__c,sumOfCostField,EmiRequired) );

                    }else{
                        Decimal sumOfCostField = (appColRec.genesis__Collateral__r.Machinery_Cost__c != null ? appColRec.genesis__Collateral__r.Machinery_Cost__c : 0.00) + (appColRec.genesis__Collateral__r.Installation_Cost__c != null ? appColRec.genesis__Collateral__r.Installation_Cost__c : 0.00) + (appColRec.genesis__Collateral__r.Other_Cost__c != null ? appColRec.genesis__Collateral__r.Other_Cost__c : 0.00) + (appColRec.genesis__Collateral__r.Tax__c != null ? appColRec.genesis__Collateral__r.Tax__c : 0.00);
                        System.debug('facilityWisePmax1.get(appColRec.Facility__c).pmax1 =>'+facilityWisePmax1.get(appColRec.Facility__c).pmax1);
                        sumOfCostField                                                      = facilityWisePmax1.get(appColRec.Facility__c).pmax1 + sumOfCostField;
                        facilityWisePmax1.put(appColRec.Facility__c ,new pmaxOnewWrapper(appColRec.Facility__r.Name,appColRec.Facility__c,sumOfCostField,EmiRequired) );

                    }
                }else if(appColRec.genesis__Collateral__r.RecordType.DeveloperName == TermLoanConstants.OTHER_RTDN){
                    if(!facilityWisePmax1.containsKey(appColRec.Facility__c)){

                        Decimal sumOfCostField = (appColRec.genesis__Collateral__r.Machinery_Cost__c != null ? appColRec.genesis__Collateral__r.Machinery_Cost__c : 0.00) + (appColRec.genesis__Collateral__r.Installation_Cost__c != null ? appColRec.genesis__Collateral__r.Installation_Cost__c : 0.00) + (appColRec.genesis__Collateral__r.Other_Cost__c != null ? appColRec.genesis__Collateral__r.Other_Cost__c : 0.00) + (appColRec.genesis__Collateral__r.Tax__c != null ? appColRec.genesis__Collateral__r.Tax__c : 0.00);
                        System.debug('sumOfCostField =>'+sumOfCostField);
                        facilityWisePmax1.put(appColRec.Facility__c ,new pmaxOnewWrapper(appColRec.Facility__r.Name,appColRec.Facility__c,sumOfCostField,EmiRequired) );

                    }else{


                        Decimal sumOfCostField = (appColRec.genesis__Collateral__r.Machinery_Cost__c != null ? appColRec.genesis__Collateral__r.Machinery_Cost__c : 0.00) + (appColRec.genesis__Collateral__r.Installation_Cost__c != null ? appColRec.genesis__Collateral__r.Installation_Cost__c : 0.00) + (appColRec.genesis__Collateral__r.Other_Cost__c != null ? appColRec.genesis__Collateral__r.Other_Cost__c : 0.00) + (appColRec.genesis__Collateral__r.Tax__c != null ? appColRec.genesis__Collateral__r.Tax__c : 0.00);
                        System.debug('facilityWisePmax1.get(appColRec.Facility__c).pmax1 =>'+facilityWisePmax1.get(appColRec.Facility__c).pmax1);
                        sumOfCostField                                                      = facilityWisePmax1.get(appColRec.Facility__c).pmax1 + sumOfCostField;
                        facilityWisePmax1.put(appColRec.Facility__c ,new pmaxOnewWrapper(appColRec.Facility__r.Name,appColRec.Facility__c,sumOfCostField,EmiRequired) );

                    }
                }else if(appColRec.genesis__Collateral__r.RecordType.DeveloperName == TermLoanConstants.COMMERCIAL_VEHICLE_RTDN){

                    if(!facilityWisePmax1.containsKey(appColRec.Facility__c)){

                        Decimal sumOfCostField = math.min((appColRec.genesis__Collateral__r.Chassis_Cost__c != null ? appColRec.genesis__Collateral__r.Chassis_Cost__c: 0.00 )+ (appColRec.genesis__Collateral__r.Body_Building_Cost__c != null ? appColRec.genesis__Collateral__r.Body_Building_Cost__c : 0.00), appColRec.genesis__Collateral__r.ExshowRoomPrice_Api__c != null ? appColRec.genesis__Collateral__r.ExshowRoomPrice_Api__c : 0.00) + (appColRec.genesis__Collateral__r.Other_Cost__c != null ? appColRec.genesis__Collateral__r.Other_Cost__c : 0.00) + (appColRec.genesis__Collateral__r.Tax__c != null ? appColRec.genesis__Collateral__r.Tax__c : 0.00) ;
                        System.debug('sumOfCostField =>'+sumOfCostField);
                        facilityWisePmax1.put(appColRec.Facility__c ,new pmaxOnewWrapper(appColRec.Facility__r.Name,appColRec.Facility__c,sumOfCostField,EmiRequired) );

                    }else{

                        Decimal sumOfCostField = math.min((appColRec.genesis__Collateral__r.Chassis_Cost__c != null ? appColRec.genesis__Collateral__r.Chassis_Cost__c: 0.00 )+ (appColRec.genesis__Collateral__r.Body_Building_Cost__c != null ? appColRec.genesis__Collateral__r.Body_Building_Cost__c : 0.00), appColRec.genesis__Collateral__r.ExshowRoomPrice_Api__c != null ? appColRec.genesis__Collateral__r.ExshowRoomPrice_Api__c : 0.00) + (appColRec.genesis__Collateral__r.Other_Cost__c != null ? appColRec.genesis__Collateral__r.Other_Cost__c : 0.00) + (appColRec.genesis__Collateral__r.Tax__c != null ? appColRec.genesis__Collateral__r.Tax__c : 0.00) ;
                        System.debug('facilityWisePmax1.get(appColRec.Facility__c).pmax1 =>'+facilityWisePmax1.get(appColRec.Facility__c).pmax1);
                        sumOfCostField                                                      = facilityWisePmax1.get(appColRec.Facility__c).pmax1 + sumOfCostField;
                        facilityWisePmax1.put(appColRec.Facility__c ,new pmaxOnewWrapper(appColRec.Facility__r.Name,appColRec.Facility__c,sumOfCostField,EmiRequired) );

                    }
                }else if(appColRec.genesis__Collateral__r.RecordType.DeveloperName == TermLoanConstants.PASSENGER_VEHICLE_RTDN){
                    if(!facilityWisePmax1.containsKey(appColRec.Facility__c)){

                        Decimal sumOfCostField = math.min((appColRec.genesis__Collateral__r.ExShow_Room_Price__c != null ? appColRec.genesis__Collateral__r.ExShow_Room_Price__c : 0.00) , appColRec.genesis__Collateral__r.ExshowRoomPrice_Api__c != null ? appColRec.genesis__Collateral__r.ExshowRoomPrice_Api__c : 0.00) + (appColRec.genesis__Collateral__r.clcommon__Insurance_Amount__c != null ? appColRec.genesis__Collateral__r.clcommon__Insurance_Amount__c : 0.00) + (appColRec.genesis__Collateral__r.Registration_cost__c != null ? appColRec.genesis__Collateral__r.Registration_cost__c : 0.00) + math.min(50000.00,appColRec.genesis__Collateral__r.Accessories_value__c != null ? appColRec.genesis__Collateral__r.Accessories_value__c : 0.00) ;
                        System.debug('sumOfCostField =>'+sumOfCostField);
                        facilityWisePmax1.put(appColRec.Facility__c ,new pmaxOnewWrapper(appColRec.Facility__r.Name,appColRec.Facility__c,sumOfCostField,EmiRequired) );

                    }else{
                        Decimal sumOfCostField = math.min((appColRec.genesis__Collateral__r.ExShow_Room_Price__c != null ? appColRec.genesis__Collateral__r.ExShow_Room_Price__c : 0.00) , appColRec.genesis__Collateral__r.ExshowRoomPrice_Api__c != null ? appColRec.genesis__Collateral__r.ExshowRoomPrice_Api__c : 0.00) + (appColRec.genesis__Collateral__r.clcommon__Insurance_Amount__c != null ? appColRec.genesis__Collateral__r.clcommon__Insurance_Amount__c : 0.00) + (appColRec.genesis__Collateral__r.Registration_cost__c != null ? appColRec.genesis__Collateral__r.Registration_cost__c : 0.00) + math.min(50000.00,appColRec.genesis__Collateral__r.Accessories_value__c != null ? appColRec.genesis__Collateral__r.Accessories_value__c : 0.00) ;
                        System.debug('facilityWisePmax1.get(appColRec.Facility__c).pmax1 =>'+facilityWisePmax1.get(appColRec.Facility__c).pmax1);
                        sumOfCostField                                                      = facilityWisePmax1.get(appColRec.Facility__c).pmax1 + sumOfCostField;
                        facilityWisePmax1.put(appColRec.Facility__c ,new pmaxOnewWrapper(appColRec.Facility__r.Name,appColRec.Facility__c,sumOfCostField,EmiRequired) );

                    }
                }
            }
            if (facilityWisePmax1 != null) {
                for (String facId : facilityWisePmax1.keySet()) {
                    if(facilityWisePmax1.get(facId).pmax1 != null && facilityWiseMarginPart.containsKey(facId)){
                        facilityWisePmax1.put(facId, new pmaxOnewWrapper(facilityWisePmax1.get(facId).FacName,facilityWisePmax1.get(facId).FacId,facilityWisePmax1.get(facId).pmax1 * facilityWiseMarginPart.get(facId),facilityWisePmax1.get(facId).emiRequired));
                    }

                }
            }
            System.debug('facilityWisePmax1 ::: '+facilityWisePmax1);
            return facilityWisePmax1.values();

        } catch (Exception e) {
            System.debug(' Error :'+e.getMessage() +' AT '+e.getLineNumber() + 'STACKTRACE '+e.getStackTraceString());
            return null;
        }
    }

    public class pmaxOnewWrapper{
        public String FacId         {get;set;}
        public String FacName       {get;set;}
        public Decimal pmax1        {get;set;}
        public Decimal emiRequired  {get;set;}
        public pmaxOnewWrapper(String facName,String facId,Decimal pmaDecimal,Decimal emiRequired){
            this.FacId          = facId;
            this.FacName        = facName;
            this.pmax1          = pmaDecimal;
            this.emiRequired    = emiRequired;
        }
    }

    
}